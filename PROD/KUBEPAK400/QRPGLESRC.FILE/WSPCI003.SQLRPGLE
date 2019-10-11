      *? Program        :  WSPCI003
      *?
      *? Description    : This program is to Post XML and Receive response
      *?                  from Client Site
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 04 APR 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Generate Send XML for Payment Process
      *?                : ** Write XML data into IFS stream file
      *?                : ** Used for BIR235 & ARR210
      *?                : ** Write a record in Transaction file for SUCCESS
      *
      *? Called Program : QCMDEXC  - To Call Command in Program
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * WJB01   07/24/18   W.J.Behr     Change Card4 logic
      * SUD01   07/26/18   S.Uthaya     Tokenize and Store Card based on Get
      *                                 Token Field (New field in Screen)
      * SUD02   08/31/18   S.Uthaya     Response message parameter length Changed
      * SUD03   09/17/18   S.Uthaya     Store request Xml based on Flag
      * SUD04   04/02/19   S.Uthaya     Added Error Handling
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
           BndDir('HTTPAPI');
      *
      *?Include Httpapi_h Source
      /Include QRpglesrc,Httpapi_h
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - PCI Credit Card/Token Logical File
      *?Key : Customer Number : Card Number : Token Number
        Dcl-F WSCCTOKL01 Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: WS - PCI Credit Card Transaction File
      *?Key : Customer Number : Customer Number : Token Number
        Dcl-F WSCCTXNL01 Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: WS - PCI Parameter Logical File
      *?Key : Parameter Code : Parameter Type
        Dcl-F WSPCIPRM01 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration: *Entry Parameters
        Dcl-Pi WSPCI003 ExtPgm;
           ParmDs1   LikeDs(ParmDs);
           PGetToken Char(1);
           PCCvv     Packed(3);
SUD02      PMsg      Char(150);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(200)    Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname    Char(50)    Value;
           Tagval     Char(300)   Value;
           Info       Char(10)    Value;
        End-Pr;
      *
      *?Parameter Data Structure : ParmDs
        Dcl-Ds ParmDs Qualified;
           PCust#     Packed(6);                           // Customer Number
           POrder#    Packed(6);                           // Order Number
           PInvoice   Packed(6);                           // Invoice Number
           PPgm       Char(10);                            // Program Name
           PSts       Char(10);                            // Status from Called
           PCCard     Packed(16);                          // Card Number
           PCType     Char(4);                             // Credit Card Type
           PCExp      Packed(4);                           // Credit Card Expiry
           PToken     Packed(16);                          // Token Number
           PCApr      Char(10);                            // C.C Approval Statu
           PAmount    Packed(11:2);                        // Amount to be paid/
        End-Ds;
      *
      *?Response Data Structure :
        Dcl-Ds Txn Qualified;
           errorCode              Char(10);
           errorName              Char(50);
SUD02      errorMessage           Char(150);
      *
           ssl_transaction_type   Char(10);
           ssl_merchant_id        Char(10);
           ssl_user_id            Char(10);
           ssl_pin                Char(10);
           ssl_card_number        Char(16);
           ssl_token              Char(16);
           ssl_exp_date           Char(5);
           ssl_amount             Char(10);
           ssl_card_present       Char(1);
           ssl_avs_zip            Char(5);
           ssl_avs_address        Char(50);
           ssl_cvv2cvc2           Char(10);
           ssl_cvv2cvc2_indicator Char(1);
           ssl_get_token          Char(1);
           ssl_add_token          Char(1);
SUD02      ssl_result_message     Char(75);
           ssl_txn_id             Char(50);
           ssl_approval_code      Char(10);
           ssl_txn_time           Char(26);
           ssl_result             Char(1);
        End-Ds;
      *
      *?Program Status Data Structure :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S Xml       Char(65535)  Inz;
        Dcl-S XmlIfs    Char(300)    Inz;
        Dcl-S Cmd       Char(400)    Inz;
        Dcl-S Url       Char(400)    Inz;
        Dcl-S Rc        Int(10:0)    Inz;
        Dcl-S Filename  Char(100)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCust    Char(6)  Inz;
SUD01   Dcl-S WkCustNa  Char(50) Inz;
        Dcl-S WkFile    Char(75) Inz;
        Dcl-S WkPath    Char(75) Inz;
        Dcl-S WkExtra   Char(55) Inz;
        Dcl-S Options   Char(150)Inz;
        Dcl-S WkTxnTyp  Char(10) Inz;
        Dcl-S WkMrcId   Char(20) Inz;
        Dcl-S WkUsrId   Char(20) Inz;
        Dcl-S WkPin     Char(100)Inz;
        Dcl-S WkAmount  Char(11) Inz;
        Dcl-S WkCc      Char(16) Inz;
        Dcl-S WkCcExp   Char(4)  Inz;
        Dcl-S WKCvv2    Char(3)  Inz;
        Dcl-S WKToken   Char(16) Inz;
        Dcl-S WkMode    Char(10) Inz('false');
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

           Exsr InzPgm;
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
        Begsr InzPgm;

      *?   // Clear Xml
           Clear Xml;

      *?   // Move Values from Entry Datastructure to Pgm Datastructure
           Eval-Corr ParmDs = ParmDs1;

      *?   // Create IFSXML temp file in QTEMP
           Cmd = 'CRTPF FILE(QTEMP/IFSREQ) RCDLEN(300)';
           Exsr CallCmd;

      *?   // Move Values into Work variables
           Exsr MoveParm;

      *?   // Generate XML
           Exsr GenXml;

      *?   // Post Xml
           Exsr PostXml;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Save Request XML into IFS
           Exsr SavReqIfs;

      *?   // Move Values to Return Datastructure from Pgm Datastructure
           Eval-Corr ParmDs1 = ParmDs;

      *?   // Return
           *InLr = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : MoveParm Subroutine :
      *?                :---------------------:
      *
        Begsr MoveParm;

      *?   // Move Parameters into Work variable
           WkCust   = %Char(ParmDs.PCust#);
           WkAmount = %Char(ParmDs.PAmount);
           If ParmDs.PToken = *Zeros;
              WkToken = *Blanks;
              WkCc    = %Char(ParmDs.PCCard);
              WkCvv2  = %Char(PCCvv);
              WkCvv2  = %EditC(PCCvv:'X');       //WJB
           Else;
              WkToken = %Char(ParmDs.PToken);
              WkCcExp = *Blanks;
              WkCc    = *Blanks;
              WkCvv2  = *Blanks;
           Endif;
           WkCcExp  = %Char(ParmDs.PCExp);
           WkCcExp  = %EditC(ParmDs.PCExp:'X');  //WJB

      *?   // Get Authentication Values from Control File
           Chain ('MERCHANTID' :'PASSWORD') WSPCIPRM01;
           If %Found;
              WkMrcId = %Trim(PRVALUE);
           Endif;

           Chain ('USERID' :'PASSWORD') WSPCIPRM01;
           If %Found;
              WkUsrId = %Trim(PRVALUE);
           Endif;

           Chain ('PINID' :'PASSWORD') WSPCIPRM01;
           If %Found;
              WkPin = %Trim(PRVALUE);
           Endif;

           Chain ('TXNTYPE' :'CREDITCARD') WSPCIPRM01;
           If %Found;
              WkTxnTyp = %Trim(PRVALUE);
           Endif;

SUD01 *?   // Get Customer Last Name
  |        Exec Sql
  |           Select CMNAME into :WkCustNa From FMCUST
  |                                       Where CMCUST = :ParmDs.PCust#;
  |        If WkCustNa <> *Blanks;
  |           WkCustNa = %ScanRpl('&': '&amp;': WkCustNa);
  |           WkCustNa = %ScanRpl('''': '&apos;' : WkCustNa);
  |           WkCustNa = %ScanRpl('"': '&quot;' : WkCustNa);
SUD01      Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : GenXml Subroutine :
      *?                :-------------------:
      *
        Begsr GenXml;

      *?   // Start Tag
           AddToXml('txn' : *Blanks : 'Starttag');

      *?   // Xml Body
           AddToXml('ssl_transaction_type' : WkTxnTyp : 'Element');
           AddToXml('ssl_merchant_id' : WkMrcId : 'Element');
           AddToXml('ssl_user_id' : WkUsrId : 'Element');
           AddToXml('ssl_pin' : WkPin : 'Element');

      *?   // To Get Token for New Credit Card
           If WkToken = *Blanks;
              AddToXml('ssl_card_number' : WkCc : 'Element');
              AddToXml('ssl_exp_date' : WkCcExp : 'Element');
              AddToXml('ssl_cvv2cvc2' : WkCvv2 : 'Element');
           Endif;
SUD01      If PGetToken = 'Y';
  |           AddToXml('ssl_add_token' : 'Y' : 'Element');
  |           AddToXml('ssl_get_token' : PGetToken : 'Element');
  |           AddToXml('ssl_first_name' : WkCust : 'Element');
  |        // AddToXml('ssl_last_name' : WkCustNa : 'Element');
  |        Else;
  |           AddToXml('ssl_add_token' : 'N' : 'Element');
  |           AddToXml('ssl_get_token' : PGetToken : 'Element');
SUD01      Endif;

      *?   // For Exists Card (Send Token with Amount)
           AddToXml('ssl_amount' : WkAmount : 'Element');
           AddToXml('ssl_token' : WkToken : 'Element');
           AddToXml('ssl_test_mode' : WkMode : 'Element');

      *?   // End Tag
           AddToXml('txn' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : PostXml Subroutine :
      *?                :--------------------:
      *
        Begsr PostXml;

      *?   // To get tech info about the HTTP transaction
           Http_debug(*ON: '/tmp/httpapi_PCIPOSTRCV.log');

      *?   // Get Url from Control File
           Chain ('PCIURL' :'URLPATH') WSPCIPRM01;
           If %Found;
              Url =  %Trim(PRVALUE);
           Endif;

      *?   // Create Stream file & Change attribute to read XML
           Exsr CrtStmf;

      *?   // POST xml to client site
SUD04      Monitor;
              Rc = Http_Url_post(Url :%Addr(Xml) : %Len(%Trim(Xml))
                            : Filename
                            : HTTP_TIMEOUT
                            : HTTP_USERAGENT
                            :'application/x-www-form-urlencoded;charset=UTF-8');
SUD04      On-Error;
  |        EndMon;
  |
  |   *?   // If Response code = 1 (Success)
  |        If Rc = 1;
  |           Exsr XmlInto;
  |
  |   *?      // Check Response and Process
  |           Exsr ResponseSr;
  |        Else;
SUD04         PMsg = 'We are unable to connect to the credit card company';
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CrtStmf Subroutine :
      *?                :--------------------:
      *
        Begsr CrtStmf;

      *?   // Create Stream file in IFS
           WKFile = *Blanks;
           Chain ('IFS' : 'IFSPATH' ) WSPCIPRM01;
           If %Found;
               WkPath = %Trim(PRVALUE);
           Endif;

           WkFile = 'Res_' + %Trim(ParmDs.PPgm) + '_' + %Trim(WkCust);

           Filename =  %Trim(WKPATH)+ %Trim(WkFile) +  '-'  +
                       %Char(%Timestamp())  + '.xml';
           Cmd = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(Filename) + ''' )';

           Exsr CallCmd;

      *?   // Change attributes of Stream file
           Cmd = 'CHGATR OBJ(''' + %Trim(Filename) + ''')' +
                         ' ATR(*CCSID) VALUE(1208)';
           Exsr CallCmd;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CallCmd Subroutine :
      *?                :--------------------:
      *
        Begsr CallCmd;

      *?   // Call QCMDEXC ,Monitor if there is a error
           Monitor;
              QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : XmlInto Subroutine :
      *?                :--------------------:
      *
        Begsr XmlInto;

      *?   // XML Into Datastructure
           Options = 'path=txn allowextra=yes allowmissing=yes case=any ' +
                     'doc=file';
           Xml-Into Txn  %XML(%Trim(Filename) : Options);

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ResponseSr Subroutine :
      *?                :-----------------------:
      *
        Begsr ResponseSr;

      *?   // Check Response values
           If Txn.errorCode <> *Blanks;
              PMsg = Txn.errorMessage;
           Else;
SUD01         If Txn.ssl_result <> '1';
  |              If Txn.ssl_result_message = 'APPROVAL';
  |                 If Txn.ssl_token <> *Blanks;
  |
  |   *?               // Write Record in Transaction file
  |                    Exsr WriteTxn;
  |                    ParmDs.PCApr  = Txn.ssl_approval_code;
  |                    ParmDs.PToken = %Int(Txn.ssl_token);
  |                    PMsg = Txn.ssl_result_message;
  |                 Elseif Txn.ssl_card_number <> *Blanks and PGetToken = 'N';
  |
  |   *?               // Write Record in Transaction file
  |                    Exsr WriteTxn;
  |                    ParmDs.PCCard = %Int(%Subst(Txn.ssl_card_number:13:4));
  |                    ParmDs.PCApr  = Txn.ssl_approval_code;
  |                    PMsg = Txn.ssl_result_message;
  |                 Elseif Txn.ssl_token = *Blanks and PGetToken = 'Y';
  |                    PMsg = 'Token not generated';
  |                 Endif;
  |              Else;
  |                 PMsg = Txn.ssl_result_message;
  |              Endif;
  |           Else;
  |              PMsg = Txn.ssl_result_message;
  |           Endif;
SUD01      Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : WriteTxn Subroutine :
      *?                :---------------------:
      *
      *?Logic : Write a record in Credit Card Transcation File
      *?
        Begsr WriteTxn;

      *?   // Clear Record Format
           Clear WSCCTXNR;

      *?   // Move Values into File fields
           CTSTAT    = 'A';
           CTCUST    = ParmDs.PCust#;
           CTORDNO   = ParmDs.POrder#;
           CTINVNO   = ParmDs.PInvoice;
           CTCTYPE   = ParmDs.PCType;
           CTPGMNM   = ParmDs.PPgm;                          // Called Program
SUD01      If Txn.ssl_card_number <> *Blanks;
  |           CTCARDNO  = %Int(%Subst(Txn.ssl_card_number:13:4));
  |        Endif;
  |        If Txn.ssl_token <> *Blanks;
  |           CTTOKENNO = %Int(Txn.ssl_token);
SUD01      Endif;
           CTAPPRCD  = Txn.ssl_approval_code;
           CTAMNT    = %Dec(Txn.ssl_amount:13:2);
           CTTXNID   = Txn.ssl_txn_id;
           CTTXNTM   = Txn.ssl_txn_time;

      *?   // Audit Stamp
           CTCRTDAT = Rundate;
           CTCRTTIM = Runtime;
           CTCRTUSR = User;
           CTCRTJOB = Job;
           CTCRTPGM = Pgm;

      *?   // Write Record
           Write  WSCCTXNR;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : SavReqIfs Subroutine :
      *?                :----------------------:
      *
        Begsr SavReqIfs;

SUD03 *?   // Check Parameter file , Based on Flag value Store Request
  |        If Xml <> *Blanks;
  |           Chain ('IFS' : 'STOREREQ' ) WSPCIPRM01;
  |           If %Found;
  |              If PRVALUE = '1';
  |
  |   *?            // Create stream file
  |                 WkFile = *Blanks;
  |                 Chain ('IFS' : 'IFSPATH' ) WSPCIPRM01;
  |                 If %Found;
  |                    WkPath = %Trim(PRVALUE);
  |                 Endif;
  |
  |                 WkFile = 'Req_' + %Trim(ParmDs.PPgm) + '_' + %Trim(WkCust)
  |                        + '_' + %Char(%Timestamp()) + '.xml';
  |
  |   *?            // Copy to Stream File
  |                 Cmd = 'CPYTOIMPF FROMFILE(IFSREQ) STMFCODPAG(1208) ' +
  |                       'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
  |                       + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)';
  |
  |                 Exsr CallCmd;
  |              Endif;
SUD03         Endif;

      *?      // Clear Flat File
              Cmd  = 'CLRPFM FILE(QTEMP/IFSREQ)';
              Exsr CallCmd;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : AddToXml Procedure :
      *?                :--------------------:
      *
      *?Logic   : AddToXml to generate XML Acknowledgement
      *?          Field by field process
      *?Example : Starttag : <Tagname>
      *?          Opentag  : <Tagname
      *?          Closetag :  Tagname/>
      *?          Close    :  Tagname>
      *?          Endtag   : </Tagname>
      *
        Dcl-Proc  AddToXml;
           Dcl-Pi AddToXml;
              Tagname      Char(50)  Value;
              Tagvalue     Char(300) Value;
              Info         Char(10)  Value;
           End-Pi;

      *?   // Check Info to add XML tag
           Select;

              When Info = 'Starttag';
                 Xml = %Trimr(Xml) + '<' + %Trim(Tagname)+ '>';

              When Info = 'Element';
                  Xml = %Trimr(Xml) + ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

              When Info = 'Endtag';
                  Xml = %Trimr(Xml) + ' </' + %Trim(Tagname) + '>';

           Endsl;

      *?   // Write XML Line into IFS
           Exsr WriteIFS;
      *
      //--------------------------------------------------------------------
      *?            :---------------------:
      *?            : WriteIFS Subroutine :
      *?            :---------------------:
      *
      *?Logic : Write Each tag as a Record into Flat File
      *?
        Begsr WriteIFS;

      *?   // Check Info to add XML tag
           Select;

              When Info = 'Starttag';
                 XmlIfs = '<' + %Trim(Tagname) + '>';

              When Info = 'Element';
                 XmlIfs = ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

              When Info = 'Endtag';
                 XmlIfs = ' </' + %Trim(Tagname) + '>';

           Endsl;

      *?   // Insert into Flat File
           Exec Sql
           INSERT INTO IFSREQ Values(:XMLIFS);

        Endsr;

        End-Proc;
