*Free
      // Program        : WSPCI005B
      //
      // Description    : This pgm to PCI Tokenization of Credit card - Batch
      //
      // Created By     : W. Behr based on WSPCI005 by S.Uthayadurga
      //
      // Date           : 25 Jul 2018
      //--------------------------------------------------------------------
      // Special Notes  : ** Tokenize the Credit Card for Future Use
      //                : ** Generate Send XML for Payment Process
      //                : ** Write XML data into IFS stream file
      //
      // Called Program : WSRTVMSG - To get message from Message File
      //                  QCMDEXCG - To use Command Line Commands in Program
      //--------------------------------------------------------------------
      //                :---------------:
      //                : Modifications :
      //                :---------------:
      //------  --------   ----------   ------------------------------------
      //MOD#    MOD Date   Programmer   Description
      //------  --------   ----------   ------------------------------------
      //
      //--------------------------------------------------------------------
      //                :----------------------:
      //                : Header Specification :
      //                :----------------------:

        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl)
        BndDir('HTTPAPI');

      /Include QRpglesrc,Httpapi_h
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : File Specification :
      //                :--------------------:

      //File: WS - PCI Credit Card/Token Logical File
      //Key : Customer Number : Credit Card : Token Number
        Dcl-F WSCCTOKL01 Disk(*Ext) Keyed Usage(*Output:*Update);
      //
      //File: WS - PCI Parameter Logical File
      //Key : Parameter Code : Parameter Type
        Dcl-F WSPCIPRM01 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : Data Specification :
      //                :--------------------:

      //Procedure Interface Declaration : *Entry Parameters
        Dcl-Pi WSPCI005B End-Pi;

      //Procedure Prototype Declaration : Call CL program to Retreive MSG
        Dcl-Pr RtvErrMsg Extpgm('WSRTVMSG');            // CL Program
           WkMsgId  Char(7);                            // Msg Id
           WkMsgF   Char(10);                           // Msg File
           WKMsg    Char(132);                          // Msg
           WkDta    Char(10);                           // Msg Data
        End-Pr;

      //Procedure Interface Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(200)    Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;

      //Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname    Char(50)    Value;
           Tagval     Char(300)   Value;
           Info       Char(10)    Value;
        End-Pr;

      //Program Status Data Structure : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;

      //Response Data Structure :
        Dcl-Ds Txn Qualified;
           errorCode                   Char(10);
           errorName                   Char(50);
           errorMessage                Char(100);

           ssl_transaction_type        Char(10);
           ssl_merchant_id             Char(10);
           ssl_user_id                 Char(10);
           ssl_pin                     Char(64);
           ssl_card_number             Char(16);
           ssl_token                   Char(16);
           ssl_exp_date                Char(5);
           ssl_first_name              Char(6);
           ssl_last_name               Char(30);
           ssl_card_short_description  Char(4);
           ssl_add_token              Char(1);
           ssl_token_response         Char(50);
           ssl_txn_time               Char(26);
        End-Ds;

      //Flag Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);

      //Global Variable Declaration :
        Dcl-S ModReq    Char(10)     Inz;
        Dcl-S FunReq    Char(10)     Inz;
        Dcl-S Xmldata   Char(65535)  Inz;
        Dcl-S XmlIfs    Char(300)    Inz;
        Dcl-S Cmd       Char(400)    Inz;
        Dcl-S Url       Char(400)    Inz;
        Dcl-S Rc        Int(10:0)    Inz;
        Dcl-S Filename  Char(100)    Inz;

      //Work Variable Declaration :
        Dcl-S WkMsgf    Char(10)    Inz;               // Used for Msg File
        Dcl-S WkMsgId   Char(7)     Inz;               // Used for Msg File
        Dcl-S WkMsg     Char(132)   Inz;               // Used for Msg File
        Dcl-S WkDta     Char(10)    Inz;               // Used for Msg File
        Dcl-S WkCard    Char(16)    Inz;
        Dcl-S WkCard4   Packed(4)   Inz;
        Dcl-S WkCExp    Char(4)     Inz;
        Dcl-S WkCMm     Packed(2)   Inz;
        Dcl-S WkCYy     Packed(2)   Inz;
        Dcl-S WkLen     Packed(2)   Inz;
        Dcl-S WkToken   Packed(16)  Inz;
        Dcl-S WkCust    Packed(6)   Inz;
        Dcl-S WkCustNa  Char(50)    Inz;
        Dcl-S WkCurDt   Char(6)     Inz;
        Dcl-S WkCurMm   Packed(2)   Inz;
        Dcl-S WkCurYy   Packed(2)   Inz;
        Dcl-S WkCustC   Char(6)     Inz;
        Dcl-S WkFile    Char(75)    Inz;
        Dcl-S WkPath    Char(75)    Inz;
        Dcl-S WkExtra   Char(55)    Inz;
        Dcl-S Options   Char(150)   Inz;
        Dcl-S WkTxnTyp  Char(10)    Inz;
        Dcl-S WkMrcId   Char(20)    Inz;
        Dcl-S WkUsrId   Char(20)    Inz;
        Dcl-S WkPin     Char(100)   Inz;
        Dcl-S WkMode    Char(10)    Inz('false');
        Dcl-S SQLState1  Like(SQLState);


      //CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;

      //Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);

      //Program Parameters
        Dcl-DS Card_to_Process_DS;
           Cust#    Packed(6:0)  Inz(0);
           CustName Char(30)     Inz('Customer Not Found');
           CCard    Packed(16:0) Inz(0);
           CardExp  Packed(4:0)  Inz(0);
        End-Ds;


      //--------------------------------------------------------------------
      //                :------------------:
      //                : Calculation Spec :
      //                :------------------:

       SQLState1 = '00000';

       DoW SQLState1 = '00000';
         exec SQL
           SELECT distinct CMCUST, CMNAME, HSCRC#, HSCRDT
             INTO :Card_to_Process_DS
           FROM FMCUST join FARHST on CMCUST = HSCUST
           WHERE HSCRCD <> ' '
             and HSCRC# > 0999999999999999
             and HSFIL2 = ' '
             and right(int(HSCRDT * 100.01),4) >=
                 ( year (current date) -2000 ) *100  + month(current date)
             and CMCUST > :Cust#
           ORDER BY CMCUST
         Fetch First Row Only;
         SQLState1 = SQLState;

         If SQLState = '00000';
           exsr ProcessCC;
           If CCTOKENNO <> 0;
             exec SQL
               Update FARHST
                 Set  HSCRC# = :CCTOKENNO
                   ,  HSFIL2 = 'TOKEN'
                   ,  HSBANK = 0
                   ,  HSCRDT = 0
               Where  HSCRC# = :CCard
                 and  HSCUST = :Cust#;
           ELSE;
             exec SQL
               Update FARHST
                 Set  HSFIL2 = 'ERROR'
               Where  HSCRC# = :CCard
                 and  HSCUST = :Cust#;
           ENDIF;
         EndIf;
       EndDo;

       *InLR = *On;
       Return;


      //--------------------------------------------------------------------
      //                :------------------:
      //                : Process CC       :
      //                :------------------:
      //Logic : Process Non Error Screen Inputs
        Begsr ProcessCC;

      //   // Clear any previous XML
           Clear XMLData;
           Xmldata = 'xmldata=';

      //   // Create IFSXML temp file in QTEMP
           Cmd = 'CRTPF FILE(QTEMP/IFSREQ) RCDLEN(300)';
           Exsr CallCmd;

      //   // Move Values into Work variables
           Exsr MoveParm;

      //   // Generate XML
           Exsr GenXml;

      //   // Save Request XML into IFS
           Exsr SavReqIfs;

      //   // Post Xml
           Exsr PostXml;

      //   // Check Response and Process
           Exsr ResponseSr;


        Endsr;
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : WriteSr Subroutine :
      //                :--------------------:
      *
      //Logic : Write a record in Credit Card File
      //
        Begsr WriteSr;

      //   // Clear Record Format
           Clear WSCCTOKR;

      //   // Move Values into File fields
           CCSTAT    = 'A';
           CCCUST    = CUST#;
           If CCard <> *Zeros;
              WkCard   = *Blanks;
              WKCard   = %Char(CCard);
              CCCARDNO = %Int(%Subst(WkCard:13:4));
           Endif;
           CCTYPE    = txn.ssl_card_short_description;
           CCTOKENNO = WkToken;
           CCCMNT    = 'Tokenized from Card on File';

      //   // Audit Stamp
           CCCRTDAT = Rundate;
           CCCRTTIM = Runtime;
           CCCRTUSR = User;
           CCCRTJOB = Job;
           CCCRTPGM = Pgm;

      //   // Write a Record
           Write WSCCTOKR;

         Endsr;
      //--------------------------------------------------------------------
      //                :------------------:
      //                : INZSR Subroutine :
      //                :------------------:
      *
      //Logic : Initialise Subroutine
      //
        Begsr *InzSr;

      //   // Clear Xml
           Clear Xmldata;

      //   // Add value into XML
           Xmldata = 'xmldata=';

        Endsr;
      //--------------------------------------------------------------------
      //                :---------------------:
      //                : MoveParm Subroutine :
      //                :---------------------:
      *
        Begsr MoveParm;

      //   // Get Authentication Values from Control File
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

           Chain ('TXNTYPE' :'FUTURESALES') WSPCIPRM01;
           If %Found;
              WkTxnTyp =  %Trim(PRVALUE);
           Endif;

      //   // Move Parameters into Work variable
           WkCustC = %Char(Cust#);
           WkCard  = %Char(CCard);
           WkCExp  = %EditC(CardExp:'X');

      //   // Replace Special Characters
           If CUSTNAME <> *Blanks;
              WkCustNa = %ScanRpl('&' : '' : CUSTNAME);
              WkCustNa = %ScanRpl('''': '' : WkCustNa);
              WkCustNa = %ScanRpl('"' : '' : WkCustNa);
              WkCustNa = %ScanRpl('  ' : ' ' : WkCustNa);
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      //                :-------------------:
      //                : GenXml Subroutine :
      //                :-------------------:
      *
        Begsr GenXml;

      //   // Start Tag
           AddToXml('txn' : *Blanks : 'Starttag');

      //   // Xml Body : Authorization Details
           AddToXml('ssl_transaction_type' : WkTxnTyp : 'Element');
           AddToXml('ssl_merchant_id' : WkMrcId : 'Element');
           AddToXml('ssl_user_id' : WkUsrId : 'Element');
           AddToXml('ssl_pin' : WkPin : 'Element');

      //   // Xml Body : Card Details
           AddToXml('ssl_card_number' : WkCard : 'Element');
           AddToXml('ssl_exp_date' : WkCExp : 'Element');
           AddToXml('ssl_add_token' : 'Y' : 'Element');

      //   // Xml Body : Customer Name
           AddToXml('ssl_first_name' : WkCustC : 'Element');
           AddToXml('ssl_last_name' : WkCustNa : 'Element');

      //   // End Tag
           AddToXml('txn' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : PostXml Subroutine :
      //                :--------------------:
      *
        Begsr PostXml;

      //   // To get tech info about the HTTP transaction
           Http_debug(*ON: '/tmp/httpapi_PCIPOSTRCV.log');

      //   // Get Url from Control File
           Chain ('PCIFUTSAL' :'URLPATH') WSPCIPRM01;
           If %Found;
              Url =  %Trim(PRVALUE);
           Endif;

      //   // Create Stream file & Change attribute to read XML
           Exsr CrtStmf;

      //   // POST xml to client site
           Rc = Http_Url_post(Url :%Addr(Xmldata) : %Len(%Trim(Xmldata))
                            : Filename
                            : HTTP_TIMEOUT
                            : HTTP_USERAGENT
            :'application/x-www-form-urlencoded;charset=UTF-8');

      //   // If Response code = 1 (Success)
           If Rc = 1;
              Exsr XmlInto;
           Else;
              Http_crash();
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : CrtStmf Subroutine :
      //                :--------------------:
      *
        Begsr CrtStmf;

      //   // Create Stream file in IFS
           WKFile = *Blanks;
           Chain ('IFS' : 'IFSPATH' ) WSPCIPRM01;
           If %Found;
               WkPath = %Trim(PRVALUE);
           Endif;

           WkFile = 'Res_' + %Trim(Pgm) + '_' + %Trim(WkCustC);

           Filename =  %Trim(WKPATH)+  '/'  + %Trim(WkFile) +  '-'  +
                       %Char(%Timestamp())  + '.xml';
           Cmd = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(Filename) + ''' )';

           Exsr CallCmd;

      //   // Change attributes of Stream file
           Cmd = 'CHGATR OBJ(''' + %Trim(Filename) + ''')' +
                         ' ATR(*CCSID) VALUE(1208)';
           Exsr CallCmd;

        EndSr;
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : CallCmd Subroutine :
      //                :--------------------:
      *
        Begsr CallCmd;

      //   // Call QCMDEXC ,Monitor if there is a error
           Monitor;
              QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : XmlInto Subroutine :
      //                :--------------------:
      *
        Begsr XmlInto;

      //   // XML Into Datastructure
           Options = 'path=txn allowextra=yes allowmissing=yes case=any ' +
                     'doc=file';
           Xml-Into Txn  %XML(%Trim(Filename) : Options);

        EndSr;
      //--------------------------------------------------------------------
      //                :-----------------------:
      //                : ResponseSr Subroutine :
      //                :-----------------------:
      *
        Begsr ResponseSr;

      //   // Check Response values
           If Txn.errorCode <> *Blanks;
           exec SQL
             Update FARHST
               Set  HSFIL2 = 'ERROR'
             Where  HSCRC# = :CCard
               and  HSCUST = :Cust#;
              // Return;
           Else;
              If Txn.ssl_token_response = 'SUCCESS';

      //            // Write Record in Transaction file
                    WkToken = %Int(Txn.ssl_token);
                    Exsr WriteSr;
                    ModReq = 'EXIT';
              Else;
                    Return;
              Endif;
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      //                :----------------------:
      //                : SavReqIfs Subroutine :
      //                :----------------------:
      *
        Begsr SavReqIfs;

      //   // Check Xml Value
           If Xmldata <> *Blanks;

      //      // Create stream file
              WkFile = *Blanks;
              Chain ('IFS' : 'IFSPATH' ) WSPCIPRM01;
              If %Found;
                 WkPath = %Trim(PRVALUE);
              Endif;

              WkFile = 'Req_' + %Trim(Pgm) + '_' + %Trim(WkCustC) +
                       '_' + %Char(%Timestamp()) + '.xml';

      //      // Copy to Stream File
              Cmd = 'CPYTOIMPF FROMFILE(IFSREQ) STMFCODPAG(1208) ' +
                    'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
                    + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)';

              Exsr CallCmd;

      //      // Clear Flat File
              Cmd  = 'CLRPFM FILE(QTEMP/IFSREQ)';
              Exsr CallCmd;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      //                :--------------------:
      //                : AddToXml Procedure :
      //                :--------------------:
      *
      //Logic   : AddToXml to generate XML Acknowledgement
      //          Field by field process
      //Example : Starttag : <Tagname>
      //          Opentag  : <Tagname
      //          Closetag :  Tagname/>
      //          Close    :  Tagname>
      //          Endtag   : </Tagname>
      *
        Dcl-Proc  AddToXml;
           Dcl-Pi AddToXml;
              Tagname      Char(50)  Value;
              Tagvalue     Char(300) Value;
              Info         Char(10)  Value;
           End-Pi;

      //   // Check Info to add XML tag
           Select;

              When Info = 'Starttag';
                 Xmldata = %Trimr(Xmldata) + '<' + %Trim(Tagname)+ '>';

              When Info = 'Element';
                  Xmldata = %Trimr(Xmldata) + ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

              When Info = 'Endtag';
                  Xmldata = %Trimr(Xmldata) + ' </' + %Trim(Tagname) + '>';

           Endsl;

      //   // Write XML Line into IFS
           Exsr WriteIFS;
      *
      //--------------------------------------------------------------------
      //            :---------------------:
      //            : WriteIFS Subroutine :
      //            :---------------------:
      *
      //Logic : Write Each tag as a Record into Flat File
      //
        Begsr WriteIFS;

      //   // Check Info to add XML tag
           Select;

              When Info = 'Starttag';
                 XmlIfs = '<' + %Trim(Tagname) + '>';

              When Info = 'Element';
                 XmlIfs = ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

              When Info = 'Endtag';
                 XmlIfs = ' </' + %Trim(Tagname) + '>';

           Endsl;

      //   // Insert into Flat File
           Exec Sql
           INSERT INTO IFSREQ Values(:XMLIFS);

        Endsr;

        End-Proc;
      //---------------- End Of Procedure ---------------------------------------------
