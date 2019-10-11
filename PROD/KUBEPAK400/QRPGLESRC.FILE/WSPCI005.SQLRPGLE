      *? Program        : WSPCI005
      *?
      *? Description    : This pgm to PCI Tokenization of Credit card
      *?                  for Future Sales
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 03 Jul 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Called from Menu / ARR010 (With Customer)
      *?                : ** Tokenize the Credit Card for Future Use
      *?                : ** Generate Send XML for Payment Process
      *?                : ** Write XML data into IFS stream file
      *?
      *? Called Program : WSRTVMSG - WS - Send and clear message from subfile
      *?                  QCMDEXC  - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * WJB01   07/25/18   W.J.Behr     Always include leading zeros
      * SUD01   08/02/18   S.Uthaya     Added Entry Parameter in Program
      * SUD02   08/31/18   S.Uthaya     Error Message field length increased
      *                                 in Screen
      * SUD03   09/17/18   S.Uthaya     Store request Xml based on Flag
      * SUD04   04/02/19   S.Uthaya     Added Error Handling
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl)
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
      *?Key : Customer Number : Credit Card : Token Number
        Dcl-F WSCCTOKL01 Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: WS - PCI Parameter Logical File
      *?Key : Parameter Code : Parameter Type
        Dcl-F WSPCIPRM01 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File : Display file for Credit Card Process Screen
        Dcl-F WSPCI005FM Workstn Indds(Dspf);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry Parameters
        Dcl-Pi WSPCI005;
SUD01      PCust# Packed(6);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Call CL program to Retreive MSG
        Dcl-Pr RtvErrMsg Extpgm('WSRTVMSG');            // CL Program
           WkMsgId  Char(7);                            // Msg Id
           WkMsgF   Char(10);                           // Msg File
           WKMsg    Char(132);                          // Msg
           WkDta    Char(10);                           // Msg Data
        End-Pr;
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
      *?Program Status Data Structure : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Response Data Structure :
        Dcl-Ds Txn Qualified;
           errorCode                   Char(10);
           errorName                   Char(50);
SUD02      errorMessage                Char(150);
      *
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
           ssl_add_token               Char(1);
           ssl_token_response          Char(50);
           ssl_txn_time                Char(26);
        End-Ds;
      *
      *?Flag Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);
      *
      *?Global Variable Declaration :
        Dcl-S ModReq    Char(10)     Inz;
        Dcl-S FunReq    Char(10)     Inz;
        Dcl-S Xmldata   Char(65535)  Inz;
        Dcl-S XmlIfs    Char(300)    Inz;
        Dcl-S Cmd       Char(400)    Inz;
        Dcl-S Url       Char(400)    Inz;
        Dcl-S Rc        Int(10:0)    Inz;
        Dcl-S Filename  Char(100)    Inz;
      *
      *?Work Variable Declaration :
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
      *
      *?CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Process         Ind Pos(9);          // Process Function Key
      *
           RCustRi         Ind Pos(50);         // Record Customer Ind
           RCCardRi        Ind Pos(51);         // Record CCard Ind
           RCCExpRi        Ind Pos(52);         // Record CCExp Ind
SUD01      RCustPr         Ind Pos(60);         // Record Customer Protect Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line : Process the screen until EXIT key pressed/Success

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Main Screen
              Dow ModReq = 'SCREEN';
                 Exsr SN1M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;

      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN1M;

      *?   // Initialization
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
              Exsr SN1I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN1D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN1V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN1P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen Input Parameters and control field values
      *?
        Begsr SN1I;

      *?   // Initialise Reverse Image indicator
           Dspf.RCustRi  = False;
           Dspf.RCCardRi = False;
           Dspf.RCCExpRi = False;

      *?   // Get Current Date and Month
           WkCurDt= %Char(Rundate);
           WkLen  = %Len(%Trim(WkCurDt));
           If WkLen = 6;
              WkCurMM = %Int(%Subst(WkCurDt:1:2));
              WkCurYy = %Int(%Subst(WkCurDt:5:2));
           Else;
              WkCurMM = %Int(%Subst(WkCurDt:1:1));
              WkCurYy = %Int(%Subst(WkCurDt:4:2));
           Endif;
           WkLen = *Zeros;

      *?   // Move Values into Screen
           PrgName  = Pgm;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Record Format , Check the Function Key Pressed
      *?
        Begsr SN1D;

      *?   // Move Values into Screen
           PrgName = Pgm;

      *?   // Write the Subfile Control Part
           Exfmt Record;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F9 Pressed
              When Dspf.Process;
                 Exsr SN1V;
                 If FlError = False;
                    FunReq = 'PROCESS';
                 Endif;

      *?      // Other Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input Capable Fields
      *?      : If No errors then Process , Else Display error in Screen
      *?
        Begsr SN1V;

      *?   // Clear Message
           Clear ErrMsg1;
           Clear ErrMsg2;

      *?   // Initialise Reverse Image Indicator & Flag
           FlError = False;
           Dspf.RCustRi  = False;
           Dspf.RCCardRi = False;
           Dspf.RCCExpRi = False;

      *?   // Validate Customer Field
SUD01      If PCust# = *Zeros;
              If Cust# = *Zeros;
                 Custname = *Blanks;
                 FlError = True;
                 Dspf.RCustRi =  True;
                 WkMsgID = 'WS00065';
                 Exsr ErrMessage;
              Else;

      *?         // Get Customer Name from File
                 Exec Sql
                   Select CMNAME into :CUSTNAME From FMCUST Where
                                                CMCUST = :CUST#;
              Endif;
SUD01      Endif;

      *?   // Validate Credit Card Number Field
           If CCARD = *Zeros and FlError = False;
              FlError = True;
              Dspf.RCCardRi =  True;
              WkMsgID = 'WS00052';
              Exsr ErrMessage;
           Elseif CCARD <> *Zeros and FlError = False;
              WkCard = %Char(CCard);
              WkLen  = %Len(%Trim(WkCard));
              If WkLen <> 16;
                 FlError = True;
                 Dspf.RCCardRi =  True;
                 WkMsgID = 'WS00060';
                 Exsr ErrMessage;
              Else;
                 WkCard4 = %Int(%Subst(WkCard:13:4));
              Endif;
              WkCard = *Blanks;
              WkLen  = *Zeros;
           Endif;

      *?   // Check Record Exists
           If Cust# <> *Zeros and WkCard4 <> *Zeros and FlError = False;
              Chain(N) (Cust#:WkCard4) WSCCTOKL01;
              If %Found;
                 FlError = True;
                 Dspf.RCCardRi = True;
                 Dspf.RCustRi =  True;
                 WkMsgID = 'WS00073';
                 Exsr ErrMessage;
              Endif;
           Endif;

      *?   // Validate Credit Card Expiry Date
           If CARDEXP = *Zeros and FlError = False;
              FlError = True;
              Dspf.RCCExpRi = True;
              WkMsgID = 'WS00054';
              Exsr ErrMessage;

      *?   // Validate Credit Card Expiry Date (Month & Year)
           Elseif CARDEXP <> *Zeros and FlError = False;
              WkCExp = %Char(CARDEXP);
              WkCExp = %EditC(CARDEXP:'X'); // WJB01 - Always use all 4 digits
              WkLen  = %Len(%Trim(WkCExp));
              If WkLen > 2 and WkLen <= 4;
                 If WkLen = 4;
                    WkCMm = %Int(%Subst(WkCExp:1:2));
                    WkCYY = %Int(%Subst(WkCExp:3:2));
                 Else;
                    WkCMm = %Int(%Subst(WkCExp:1:1));
                    WkCYY = %Int(%Subst(WkCExp:2:2));
                 Endif;
                 If WkCmm > 12 Or WkCmm <= *Zeros;
                    FlError = True;
                    Dspf.RCCExpRi = True;
                    WkMsgID = 'WS00056';
                    Exsr ErrMessage;
                 Endif;
                 If WkCYy = WkCurYy and WkCMm < WKCurMm and FlError = False;
                    FlError = True;
                    Dspf.RCCExpRi = True;
                    WkMsgID = 'WS00059';
                    Exsr ErrMessage;
                 Endif;
                 If (WkCYy < 18 or WkCYy >= 60)  and FlError = False;
                    FlError = True;
                    Dspf.RCCExpRi = True;
                    WkMsgID = 'WS00057';
                    Exsr ErrMessage;
                 Endif;
              Else;
                 FlError = True;
                 Dspf.RCCExpRi = True;
                 WkMsgID = 'WS00066';
                 Exsr ErrMessage;
              Endif;
              WkCExp = *Blanks;
              WkLen  = *Zeros;
           Endif;

           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN1P;

      *?   // Create IFSXML temp file in QTEMP
           Cmd = 'CRTPF FILE(QTEMP/IFSREQ) RCDLEN(300)';
           Exsr CallCmd;

      *?   // Move Values into Work variables
           Exsr MoveParm;

      *?   // Generate XML
           Exsr GenXml;

      *?   // Post Xml
           Exsr PostXml;

      *?   // Save Request XML into IFS
           Exsr SavReqIfs;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : WriteSr Subroutine :
      *?                :--------------------:
      *
      *?Logic : Write a record in Credit Card File
      *?
        Begsr WriteSr;

      *?   // Clear Record Format
           Clear WSCCTOKR;

      *?   // Move Values into File fields
           CCSTAT    = 'A';
           CCCUST    = CUST#;
           If CCard <> *Zeros;
              WkCard   = *Blanks;
              WKCard   = %Char(CCard);
              CCCARDNO = %Int(%Subst(WkCard:13:4));
           Endif;
           CCTYPE    = txn.ssl_card_short_description;
           CCTOKENNO = WkToken;
           CCCMNT    = CCmnt;

      *?   // Audit Stamp
           CCCRTDAT = Rundate;
           CCCRTTIM = Runtime;
           CCCRTUSR = User;
           CCCRTJOB = Job;
           CCCRTPGM = Pgm;

      *?   // Write a Record
           Write WSCCTOKR;

         Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialise Subroutine
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PrgName = Pgm;
           ModReq  = 'SCREEN';
           FunReq  = 'INITIAL';

      *?   // Clear Subfile
           Clear Record;                       // Clear Record Format

SUD01 *?   // Check Entry Parameter
  |        If PCust# <> *Zeros;
  |           Cust# = PCust#;
  |           Dspf.RCustPr = True;
  |        Else;
  |           Cust# = *Zeros;
  |           Dspf.RCustPr = False;
  |        Endif;
  |
  |   *?   // Get Customer Name from File
  |        Exec Sql
SUD01         Select CMNAME into :CUSTNAME From FMCUST Where CMCUST = :CUST#;

      *?   // Clear Xml
           Clear Xmldata;

      *?   // Add value into XML
           Xmldata = 'xmldata=';

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : MoveParm Subroutine :
      *?                :---------------------:
      *
        Begsr MoveParm;

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

           Chain ('TXNTYPE' :'FUTURESALES') WSPCIPRM01;
           If %Found;
              WkTxnTyp =  %Trim(PRVALUE);
           Endif;

      *?   // Move Parameters into Work variable
           WkCustC = %Char(Cust#);
           WkCard  = %Char(CCard);
           WkCExp  = %Char(CardExp);
           WkCExp  = %EditC(CardExp:'X');

      *?   // Replace Special Characters
           If CUSTNAME <> *Blanks;
              WkCustNa = %ScanRpl('&': '': CUSTNAME);
              WkCustNa = %ScanRpl('''': '' : WkCustNa);
              WkCustNa = %ScanRpl('"': '' : WkCustNa);
           Endif;


        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : GenXml Subroutine :
      *?                :-------------------:
      *
        Begsr GenXml;

      *?   // Start Tag
           AddToXml('txn' : *Blanks : 'Starttag');

      *?   // Xml Body : Authorization Details
           AddToXml('ssl_transaction_type' : WkTxnTyp : 'Element');
           AddToXml('ssl_merchant_id' : WkMrcId : 'Element');
           AddToXml('ssl_user_id' : WkUsrId : 'Element');
           AddToXml('ssl_pin' : WkPin : 'Element');

      *?   // Xml Body : Card Details
           AddToXml('ssl_card_number' : WkCard : 'Element');
           AddToXml('ssl_exp_date' : WkCExp : 'Element');
           AddToXml('ssl_add_token' : 'Y' : 'Element');

      *?   // Xml Body : Customer Name
           AddToXml('ssl_first_name' : WkCustC : 'Element');
           AddToXml('ssl_last_name' : WkCustNa : 'Element');

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
           Chain ('PCIFUTSAL' :'URLPATH') WSPCIPRM01;
           If %Found;
              Url =  %Trim(PRVALUE);
           Endif;

      *?   // Create Stream file & Change attribute to read XML
           Exsr CrtStmf;

      *?   // POST xml to client site
SUD04      Monitor;
              Rc = Http_Url_post(Url :%Addr(Xmldata) : %Len(%Trim(Xmldata))
                            : Filename
                            : HTTP_TIMEOUT
                            : HTTP_USERAGENT
                  :'application/x-www-form-urlencoded;charset=UTF-8');
SUD04      On-Error;
SUD04      EndMon;

      *?   // If Response code = 1 (Success)
           If Rc = 1;
              Exsr XmlInto;

SUD04 *?      // Check Response and Process
SUD04         Exsr ResponseSr;
           Else;
SUD04         ErrMsg1 = 'We are unable to connect to the credit card company';
SUD04         FunReq = 'DISPLAY';
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

           WkFile = 'Res_' + %Trim(Pgm) + '_' + %Trim(WkCustC);

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
SUD02         WkLen = 0;
  |           WkLen = %Len(%Trim(Txn.errorMessage));
  |           If WkLen < 76;
  |              ErrMsg1 = %Subst(Txn.errorMessage : 1 : 75);
  |              ErrMsg2 = *Blanks;
  |           Else;
  |              ErrMsg1 = %Subst(Txn.errorMessage : 1  : 75);
  |              ErrMsg2 = %Subst(Txn.errorMessage : 76 : 75);
  |           Endif;
SUD02         WkLen = 0;
           Else;
              If Txn.ssl_token_response = 'SUCCESS';

      *?         // Write Record in Transaction file
                 WkToken = %Int(Txn.ssl_token);
                 Exsr WriteSr;
                 ModReq = 'EXIT';
              Else;
SUD02            ErrMsg1 = Txn.ssl_token_response;
              Endif;
           Endif;
           FunReq = 'DISPLAY';

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ErrMessage Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Call CL program to Show Message
      *?
        Begsr ErrMessage;

      *?   // Show Message On Screen from Message File
           Monitor;
             WkMsgf = 'WSMSGF';
             WkDta  = *Blanks;
             RtvErrMsg(WkMsgID:WkMsgf:WKMSG:WkDta);
           On-Error;
           EndMon;
           ErrMsg1 = WkMsg;
           ModReq  = 'SCREEN';
           FunReq  = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : SavReqIfs Subroutine :
      *?                :----------------------:
      *
        Begsr SavReqIfs;

SUD03 *?   // Check Parameter file , Based on Flag value Store Request
  |        If Xmldata <> *Blanks;
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
  |                 WkFile = 'Req_' + %Trim(Pgm) + '_' + %Trim(WkCustC)
  |                          + '_' + %Char(%Timestamp()) + '.xml';
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
                 Xmldata = %Trimr(Xmldata) + '<' + %Trim(Tagname)+ '>';

              When Info = 'Element';
                  Xmldata = %Trimr(Xmldata) + ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

              When Info = 'Endtag';
                  Xmldata = %Trimr(Xmldata) + ' </' + %Trim(Tagname) + '>';

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
      *?---------------- End Of Procedure ---------------------------------------------
