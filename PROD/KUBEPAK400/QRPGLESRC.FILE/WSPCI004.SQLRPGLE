      *? Program        : WSPCI004
      *?
      *? Description    : This pgm to Maintain Credit Card Token File
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 27 Jul 2018
      *---------------------------------------------------------------------
      *? Special Notes  : Called from 1.WSPCI001-PCI-Subfile Program to Select
      *?                                 Credit Card
      *?                : 2.ARR010-M/F Customer Master Maintenance
      *?
      *? Called Program : WSSFLMSG - WS - Send and Clear message from subfile
      *?                  QCMDEXC  - To Call Command in Program
      *? Entry Parameter: Customer Number Packed(6,0)
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   08/01/18   S.Uthaya     Added Entry Parameter in Program
      * SUD02   12/13/18   S.Uthaya     1. Added New Window for Option = 2
      *                                 2. Calling API to update Expiry date
      *                                 for Existing Credit card
      * SUD03   12/14/18   S.Uthaya     Calling API to Delete token from
      *                                 Converge system
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
      *?Key : Customer Number : Card Number : Token Number
        Dcl-F WSCCTOKL01 Disk(*Ext) Keyed Usage(*Delete:*Update);
      *
SUD02 *?File: WS - PCI Parameter Logical File
  |   *?Key : Parameter Code : Parameter Type
SUD02   Dcl-F WSPCIPRM01 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: FMCUST  M/F Customer Master File
      *?Key : Customer Number
        Dcl-F FMCUST Disk(*Ext) Usage(*Input);
      *
      *?File: Display file to Select Credit Card Screen
        Dcl-F WSPCI004FM Workstn Indds(Dspf) Sfile(PCI004S01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPCI004 ExtPgm;
SUD01      PCust Packed(6);
SUD01      PSts  Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Call CL program to Retreive MSG
        Dcl-Pr RtvErrMsg Extpgm('WSRTVMSG');            // CL Program
           WkMsgId  Char(7);                            // Msg Id
           WkMsgF   Char(10);                           // Msg File
           WKMsg    Char(132);                          // Msg
           WkDta    Char(10);                           // Msg Data
        End-Pr;
      *
SUD02 *?Procedure Prototype Declaration : Pgm to Call Command
  |     Dcl-Pr QCMDEXC Extpgm;
  |        Cmd Char(200)    Const Options(*Varsize);
  |        Len Packed(15:5) Const;
  |     End-Pr;
  |   *
  |   *?Procedure Prototype Declaration : AddXml Part
  |     Dcl-Pr AddToXml;
  |        Tagname    Char(50)    Value;
  |        Tagval     Char(300)   Value;
  |        Info       Char(10)    Value;
SUD02   End-Pr;
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
SUD02 *?Response Data Structure :
  |     Dcl-Ds Txn Qualified;
  |        errorCode                   Char(10);
  |        errorName                   Char(50);
  |        errorMessage                Char(150);
  |   *
  |        ssl_transaction_type        Char(20);
  |        ssl_merchant_id             Char(10);
  |        ssl_user_id                 Char(10);
  |        ssl_pin                     Char(64);
  |        ssl_card_number             Char(16);
  |        ssl_token                   Char(16);
  |        ssl_exp_date                Char(5);
  |        ssl_first_name              Char(6);
  |        ssl_last_name               Char(30);
  |        ssl_card_short_description  Char(4);
  |        ssl_token_response          Char(50);
  |        ssl_txn_time                Char(26);
SUD02   End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S ModReq   Char(10)     Inz;
        Dcl-S FunReq   Char(10)     Inz;
SUD02   Dcl-S Xmldata  Char(65535)  Inz;
  |     Dcl-S Cmd      Char(200)    Inz;
  |     Dcl-S Url      Char(400)    Inz;
  |     Dcl-S Rc       Int(10:0)    Inz;
  |     Dcl-S Filename Char(100)    Inz;
  |     Dcl-S Options  Char(150)    Inz;
SUD02   Dcl-S XmlIfs   Char(300)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCount  Zoned(2:0) Inz;
        Dcl-S WkCust   Packed(6)  Inz;
        Dcl-S WkCustNa Char(30)   Inz;
SUD02   Dcl-S WkCmnt   Char(50)   Inz;
  |     Dcl-S WkCard   Packed(4)  Inz;
  |     Dcl-S WkCustC  Char(6)    Inz;
  |     Dcl-S WkToken  Char(16)   Inz;
  |     Dcl-S WkCExp   Char(4)    Inz;
  |     Dcl-S WkCMm    Packed(2)  Inz;
  |     Dcl-S WkCYy    Packed(2)  Inz;
  |     Dcl-S WkCurDt  Char(6)    Inz;
  |     Dcl-S WkCurMm  Packed(2)  Inz;
  |     Dcl-S WkCurYy  Packed(2)  Inz;
  |     Dcl-S WkLen    Packed(2)  Inz;
  |     Dcl-S WkMsgf   Char(10)   Inz;                // Used for Msg File
  |     Dcl-S WkMsgId  Char(7)    Inz;                // Used for Msg File
  |     Dcl-S WkMsg    Char(132)  Inz;                // Used for Msg File
  |     Dcl-S WkDta    Char(10)   Inz;                // Used for Msg File
  |     Dcl-S WkFile   Char(75)   Inz;
  |     Dcl-S WkPath   Char(75)   Inz;
  |     Dcl-S WkTxnTyp Char(20)   Inz;
  |     Dcl-S WkMrcId  Char(20)   Inz;
  |     Dcl-S WkUsrId  Char(20)   Inz;
SUD02   Dcl-S WkPin    Char(100)  Inz;
      *
      *?Flag Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlCtlMod Ind Inz(*Off);
        Dcl-S FlSflMod Ind Inz(*Off);
SUD02   Dcl-S FlStore  Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf  Char(10);                        // For CL program
        Dcl-S PMsgId Char(7);
        Dcl-S POpt   Char(1);
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
SUD01      Cancel          Ind Pos(12);         // Cancel Function Key
      *
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           S01OptRi        Ind Pos(50);         // Option Reverse Image Ind
           S01OptPc        Ind Pos(51);         // Position Cursor Ind
      *
           C01CustRi       Ind Pos(52);         // Option Customer Reverse Image Ind
           C01DelRi        Ind Pos(53);         // Option Delete Reverse Image Ind
           C01DelNd        Ind Pos(54);         // Option Delete Non Display Ind
      *
SUD02      W01ExpDtRi      Ind Pos(55);         // Expiry Date Reverse Image Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line : Process the screen until Cancel key pressed

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Main Screen
SUD02         Dow ModReq = 'SCREEN1';
                 Exsr SN1M;
              Enddo;

SUD02 *?      // Process Window Screen
  |           Dow ModReq = 'SCREEN2';
  |              Exsr SN2M;
SUD02         Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;
           Return;

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
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN1I;

      *?   // Initialise Reverse Image & Non Display indicator
           FlError = False;
           S01Opt  = *Zeros;
           S01Rrn  = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write PCI004C01;

      *?   // Clear Subfile
           Dspf.S01SflClr    = False;          // Clear Ind OFF
           Dspf.S01SflDspCtl = True;           // Display Control Ind ON

      *?   // Build Subfile
           Exsr SN1B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Read the file and Build Subfile based on Customer
      *?
        Begsr SN1B;

      *?   // Initialise Subfile fields and Indicator
           Exsr SetIndicator;
           S01Opt  = *Zeros;
           S01Rrn  = *Zeros;
           WkCount = *Zeros;
           WkCust  = *Zeros;

      *?   // Get First Record from Credit Card Token File
           If C01Cust = *Zeros;
              Setll *Loval WSCCTOKL01;
              Read(N) WSCCTOKL01;
              Dow Not %Eof;
                 WkCust = CCCUST;
                 C01Cust= WkCust;
                 Leave;
              Enddo;
           Else;
              WkCust = C01Cust;
           Endif;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A1 Cursor For
              Select CCTYPE, CCCARDNO, CCCMNT FROM WSCCTOKPF
                     WHERE ((:WkCust = 0) Or
                     (:WkCust <> 0 and CCCUST = :WKCust))
                     Order by CCTYPE, CCCARDNO;
           Exec Sql
              Open A1;
              If SqlCode = -502 ;
                 Exec Sql
                 Close A1;
                 Exec Sql
                 Open A1;
              EndIf;

           Exec Sql Fetch A1 Into :S01TYPE,:S01CARD,:S01CMNT;

           Dow SqlCod = 0 And WkCount < 9999;

      *?      // Increment RRN
              S01Rrn  += 1;
              WkCount += 1;

      *?      // Write Subfile Display Part
              Write PCI004S01;
              Exec Sql Fetch A1 Into :S01TYPE,:S01CARD,:S01CMNT;
           Enddo;
           Exec Sql Close A1;

      *?   // Move Control Fields
           C01Name = *Blanks;
           WkCustNa= *Blanks;
           Exec Sql
              Select CMNAME into :WkCustNa From FMCUST Where
              CMCUST = :C01Cust;
           C01Name = WkCustNa;

      *?   // Subfile End Indicator ON
           Dspf.S01SflEnd = *On;

      *?   // Check RRN
           If S01Rrn <> *Zeros;
              Dspf.S01SflDsp = True;
              FunReq = 'DISPLAY';
           Else;

      *?      // No Records Found
              Dspf.S01SflEnd = True;
              PMsgId = 'WS00030';
              Exsr Sendmessage;
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN1D;

      *?   // Write the Footer
           Write PCI004F01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt PCI004C01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
SUD01            PSts   = '03';
  |
  |   *?      // F12 Pressed
  |           When Dspf.Cancel;
  |              ModReq = 'EXIT';
SUD01            PSts   = '12';

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
      *?Logic : Validate input capable Subfile Fields ,
      *?      : If No errors then Process , Else Display error in Screen Pressed
      *?
        Begsr SN1V;

      *?   // Initialise Fields and Indicators
           FlError = False;
           WkCount = *Zeros;

      *?   // Validate Non Display Field
           If Dspf.C01DelNd = False;
              Exsr DeleteSr;
              FlCtlMod = True;
              If Del = 'Y';
                 PMsgId  = 'WS00075';
                 Exsr SendMessage;
              Endif;
              FlSflMod = False;
           Endif;

      *?   // Validate Control field in Subfile
           If C01Cust <> *Zeros and WkCust <> C01Cust and Dspf.C01DelNd = True;
              WkCust = C01Cust;
              Chain C01Cust Fmcust;
              If %Found;
                 WkCust = C01Cust;
                 FlCtlMod = True;
              Else;
                 Dspf.C01CustRi = True;
                 PMsgId  = 'WS00015';
                 FlError = True;
                 Exsr SendMessage;
              Endif;
           Else;
              If Dspf.C01DelNd = True;
                 FlCtlMod = False;
              Endif;
              WkCust = C01Cust;
           Endif;

      *?   // Validate Entered values in Subfile
           If Dspf.S01SflDsp and FlError = False and FlCtlMod = False
                                      and Dspf.C01DelNd = True;
              ReadC PCI004S01;
              Dow Not %Eof(WSPCI004FM);
                 Dspf.S01OptRi = False;

      *?         // Validate Option
                 If S01Opt <> *Zeros And S01Opt <> 2 and S01Opt <> 4;
                    Dspf.S01OptPc = True;
                    Dspf.S01OptRi = True;
                    PMsgId  = 'WS00028';
                    FlError = True;
                    Exsr SendMessage;
                 Else;
                    FlSflMod = True;
                 Endif;
                 Dspf.S01SflNxtChg = True;
                 Update PCI004S01;
                 Dspf.S01SflNxtChg = False;
                 ReadC PCI004S01;
              Enddo;
           Endif;

           If FlSflMod and C01Cust = *Zeros;
              FlSflMod = False;
              FlError  = True;
              Dspf.C01CustRi = True;
              PMsgId  = 'WS00074';
              FlError = True;
              Exsr SendMessage;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
           Elseif FlCtlMod;
              FunReq = 'INITIAL';
           Elseif FlSflMod;
              FunReq = 'PROCESS';
           Else;
              FunReq = 'INITIAL';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN1P;

      *?   // Read Changed record and Process based on Option
           If Dspf.S01SflDsp;
              ReadC PCI004S01;
              Dow Not %Eof(WSPCI004FM);
                 Select;

      *?            // Edit
                    When S01Opt = 2;
SUD02                  WkCmnt = S01CMNT;
  |                    WkCard = S01Card;
  |                    ModReq = 'SCREEN2';
SUD02                  FunReq = 'INITIAL';

      *?            // Delete
                    When S01Opt = 4;
                       Dspf.C01DelNd = False;
                       Dspf.C01DelRi = True;
                       Del = 'Y';
                 Endsl;
                 Dspf.S01SflNxtChg = True;
                 Update PCI004S01;
                 Dspf.S01SflNxtChg = False;
                 ReadC PCI004S01;
              Enddo;

      *?      // Check Non Display Field
              If Dspf.C01DelNd = False;
                 FunReq = 'DISPLAY';
              Else;
                 FunReq = 'INITIAL';
                 FlSflMod = False;
              Endif;
           Endif;

        Endsr;
SUD02 //--------------------------------------------------------------------
  |   *?                :-----------------:
  |   *?                : SN2M Subroutine :
  |   *?                :-----------------:
  |   *
  |   *?Logic : Call subroutine based on functional request
  |   *?
  |     Begsr SN2M;
  |
  |   *?   // Initialization
  |        If FunReq = 'INITIAL';
  |           Exsr SN2I;
  |        Endif;
  |
  |   *?   // Display
  |        If FunReq = 'DISPLAY';
  |           Exsr SN2D;
  |        Endif;
  |
  |   *?   // Validate
  |        If FunReq = 'VALIDATE';
  |           Exsr SN2V;
  |        Endif;
  |
  |   *?   // Process
  |        If FunReq = 'PROCESS';
  |           Exsr SN2P;
  |        Endif;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :-----------------:
  |   *?                : SN2I Subroutine :
  |   *?                :-----------------:
  |   *
  |   *?Logic : Initialise Record Format
  |   *?
  |     Begsr SN2I;
  |
  |   *?   // Clear Record Format
  |        Clear EDTWDW;
  |
  |   *?   // Move Values into Screen Fields
  |        W01CUST = C01CUST;
  |        W01NAME = C01NAME;
  |        W01CMNT = WkCMNT;
  |        CARDEXP = *Zeros;
  |        ERRMSG1 = *Blanks;
  |        ERRMSG2 = *Blanks;
  |
  |   *?   // Get Current Date and Month
  |        WkCurDt= %Char(Rundate);
  |        WkLen  = %Len(%Trim(WkCurDt));
  |        If WkLen = 6;
  |           WkCurMM = %Int(%Subst(WkCurDt:1:2));
  |           WkCurYy = %Int(%Subst(WkCurDt:5:2));
  |        Else;
  |           WkCurMM = %Int(%Subst(WkCurDt:1:1));
  |           WkCurYy = %Int(%Subst(WkCurDt:4:2));
  |        Endif;
  |        WkLen = *Zeros;
  |
  |   *?   // Display Screen
  |        FunReq = 'DISPLAY';
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :-----------------:
  |   *?                : SN2D Subroutine :
  |   *?                :-----------------:
  |   *
  |   *?Logic : Display Record Format and Process Function Key
  |   *?
  |     Begsr SN2D;
  |
  |   *?   // Clear Record Format
  |        ExFmt EDTWDW;
  |
  |   *?   // Check for Function Keys
  |        Select;
  |
  |   *?      // F12 Pressed
  |           When Dspf.Cancel;
  |              ModReq = 'SCREEN1';
  |              FunReq = 'INITIAL';
  |
  |   *?      // Other Pressed
  |           Other;
  |              FunReq = 'VALIDATE';
  |        Endsl;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :-----------------:
  |   *?                : SN2V Subroutine :
  |   *?                :-----------------:
  |   *
  |   *?Logic : Validate input capable Fields
  |   *?      : If No errors then Process , Else Display error in Screen Pressed
  |   *?
  |     Begsr SN2V;
  |
  |   *?   // Initialise Fields and Indicators
  |        FlError = False;
  |        Dspf.W01ExpDtRi = False;
  |
  |   *?   // Validate Credit Card Expiry Date (Month & Year)
  |        If CARDEXP <> *Zeros;
  |           WkCExp = %Char(CARDEXP);
  |           WkLen  = %Len(%Trim(WkCExp));
  |           If WkLen > 2 and WkLen <= 4;
  |              If WkLen = 4;
  |                 WkCMm = %Int(%Subst(WkCExp:1:2));
  |                 WkCYY = %Int(%Subst(WkCExp:3:2));
  |              Else;
  |                 WkCMm = %Int(%Subst(WkCExp:1:1));
  |                 WkCYY = %Int(%Subst(WkCExp:2:2));
  |              Endif;
  |              If WkCmm > 12 Or WkCmm <= *Zeros;
  |                 FlError = True;
  |                 Dspf.W01ExpDtRi = True;
  |                 WkMsgID = 'WS00056';
  |                 Exsr ErrMessage;
  |              Endif;
  |              If WkCYy = WkCurYy and WkCMm < WKCurMm and FlError = False;
  |                 FlError = True;
  |                 Dspf.W01ExpDtRi = True;
  |                 WkMsgID = 'WS00059';
  |                 Exsr ErrMessage;
  |              Endif;
  |              If (WkCYy < 18 or WkCYy >= 60)  and FlError = False;
  |                 FlError = True;
  |                 Dspf.W01ExpDtRi = True;
  |                 WkMsgID = 'WS00057';
  |                 Exsr ErrMessage;
  |              Endif;
  |           Else;
  |              FlError = True;
  |              Dspf.W01ExpDtRi = True;
  |              WkMsgID = 'WS00066';
  |              Exsr ErrMessage;
  |           Endif;
  |           WkCExp = *Blanks;
  |           WkLen  = *Zeros;
  |        Endif;
  |
  |        If FlError = False;
  |           FunReq = 'PROCESS';
  |        Else;
  |           FunReq = 'DISPLAY';
  |        Endif;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :-----------------:
  |   *?                : SN2P Subroutine :
  |   *?                :-----------------:
  |   *
  |   *?Logic : Process the Fields based on Input Fields
  |   *?
  |     Begsr SN2P;
  |
  |   *?   // Check Comment Field
  |        Chain (W01Cust:WkCard) WSCCTOKL01;
  |        If %Found;
  |           WkToken= %Char(CCTOKENNO);
  |           CCCMNT = W01Cmnt;
  |           Update WSCCTOKR %Fields(CCCMNT);
  |           ModReq = 'SCREEN1';
  |           FunReq = 'INITIAL';
  |        Endif;
  |
  |   *?   // Check Card Expiry Date
  |        If CARDEXP <> *Zeros;
  |           Exsr CallApi;
  |        Endif;
  |        Exsr ClearMessage;
  |
SUD02   Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialise Subroutine
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PGMQ   = Pgm;
           C01Pgm = Pgm;
           C01Usr = User;

      *?   // Move Control Fields
SUD01      C01Cust  = PCust;
           WkCust   = *Zeros;
           WkCustNa = *Blanks;

      *?   // Open Main Screen
SUD02      ModReq = 'SCREEN1';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : SetIndicator Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Set Indicator
      *?
        Begsr SetIndicator;

      *?   // Initialize inidcators
           Dspf.S01OptRi = False;
           Dspf.S01OptPc = False;
           Dspf.C01CustRi= False;
           Dspf.C01DelRi = False;
           Dspf.C01DelNd = True;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : DeleteSR Subroutine :
      *?                :---------------------:
      *
      *?Logic : Delete Record from Credit card token file
      *?
        Begsr DeleteSr;

      *?   // Initialize inidcators
           If Del = 'Y';
SUD03         WkToken= *Blanks;
              Chain (C01Cust:S01Card) WSCCTOKL01;
              If %Found;
SUD03            WkToken= %Char(CCTOKENNO);
                 Delete WSCCTOKR;
              Endif;

SUD03 *?      // Delete from Elavon Site
  |           Exsr CallApi;
SUD03         Exsr ClearMessage;

           Endif;

        Endsr;
SUD02 //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : CallApi Subroutine :
  |   *?                :--------------------:
  |   *
  |   *?Logic : Call API to Update Card Details in Elavon
  |   *?
  |     Begsr CallApi;
  |
  |   *?   // Move Values into Work variables
  |        FlStore = False;
  |        Exsr MoveParm;
  |
  |   *?   // Generate XML
  |        Exsr GenXml;
  |
  |   *?   // Post Xml
  |        Exsr PostXml;
  |
  |   *?   // Save Request XML into IFS
  |        If FlStore = True;
  |           Exsr SavReqIfs;
  |        Endif;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :---------------------:
  |   *?                : MoveParm Subroutine :
  |   *?                :---------------------:
  |   *
  |     Begsr MoveParm;
  |
  |   *?   // Get Authentication Values from Control File
  |        Chain ('MERCHANTID' :'PASSWORD') WSPCIPRM01;
  |        If %Found;
  |           WkMrcId = %Trim(PRVALUE);
  |        Endif;
  |
  |        Chain ('USERID' :'PASSWORD') WSPCIPRM01;
  |        If %Found;
  |           WkUsrId = %Trim(PRVALUE);
  |        Endif;
  |
  |        Chain ('PINID' :'PASSWORD') WSPCIPRM01;
  |        If %Found;
  |           WkPin = %Trim(PRVALUE);
  |        Endif;
SUD02
SUD03      If Del <> 'Y';
  |           Chain ('TXNTYPE' :'UPDATETOKEN') WSPCIPRM01;
  |        Else;
  |           Chain ('TXNTYPE' :'DELETETOKEN') WSPCIPRM01;
SUD03      Endif;
SUD02      If %Found;
  |           WkTxnTyp =  %Trim(PRVALUE);
  |        Endif;
  |
  |   *?   // Move Parameters into Work variable
  |        WkCustC = %Char(C01Cust);
  |        WkCExp  = %EditC(CardExp:'X');
  |
SUD02 *?   // Replace Special Characters
SUD03      If Del <> 'Y';
  |           If W01Name <> *Blanks;
  |              WkCustNa = %ScanRpl('&': '': W01Name);
  |              WkCustNa = %ScanRpl('''': '' : WkCustNa);
  |              WkCustNa = %ScanRpl('"': '' : WkCustNa);
SUD03         Endif;
SUD02      Endif;
  |
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :-------------------:
  |   *?                : GenXml Subroutine :
  |   *?                :-------------------:
  |   *
  |     Begsr GenXml;
  |
  |   *?   // Check Store Ifs Value , Then Create Temp File
  |        Chain ('IFS' : 'STOREREQ' ) WSPCIPRM01;
  |        If %Found;
  |           If PRVALUE = '1';
  |              FlStore = True;
  |
  |   *?         // Create IFSXML temp file in QTEMP
  |              Cmd = 'CRTPF FILE(QTEMP/IFSREQ) RCDLEN(300)';
  |              Exsr CallCmd;
  |
  |           Endif;
  |        Endif;
  |
  |   *?   // Clear Xml
  |        Clear Xmldata;
  |
  |   *?   // Add value into XML
  |        Xmldata = 'xmldata=';
  |
  |   *?   // Start Tag
  |        AddToXml('txn' : *Blanks : 'Starttag');
  |
  |   *?   // Xml Body : Authorization Details
  |        AddToXml('ssl_transaction_type' : WkTxnTyp : 'Element');
  |        AddToXml('ssl_merchant_id' : WkMrcId : 'Element');
  |        AddToXml('ssl_user_id' : WkUsrId : 'Element');
  |        AddToXml('ssl_pin' : WkPin : 'Element');
SUD02
SUD03 *?   // Xml Body : Card Details
  |        If Del = 'Y';
  |           AddToXml('ssl_token' : WkToken : 'Element');
  |        Else;
  |           AddToXml('ssl_exp_date' : WkCExp : 'Element');
  |           AddToXml('ssl_token' : WkToken : 'Element');
  |
  |   *?      // Xml Body : Customer Name
  |           AddToXml('ssl_first_name' : WkCustC : 'Element');
  |           AddToXml('ssl_last_name' : WkCustNa : 'Element');
  |
SUD03      Endif;
SUD02
  |   *?   // End Tag
  |        AddToXml('txn' : *Blanks : 'Endtag');
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : PostXml Subroutine :
  |   *?                :--------------------:
  |   *
  |     Begsr PostXml;
  |
  |   *?   // To get tech info about the HTTP transaction
  |        Http_debug(*ON: '/tmp/httpapi_PCIPOSTRCV.log');
  |
  |   *?   // Get Url from Control File
  |        Chain ('PCIURL' :'URLPATH') WSPCIPRM01;
  |        If %Found;
  |           Url =  %Trim(PRVALUE);
  |        Endif;
  |
  |   *?   // Create Stream file & Change attribute to read XML
  |        Exsr CrtStmf;
  |
SUD02 *?   // POST xml to client site
SUD04      Monitor;
  |           Rc = Http_Url_post(Url :%Addr(Xmldata) : %Len(%Trim(Xmldata))
  |                         : Filename
  |                         : HTTP_TIMEOUT
  |                         : HTTP_USERAGENT
  |           :'application/x-www-form-urlencoded;charset=UTF-8');
  |        On-Error;
  |        EndMon;
  |
  |   *?   // If Response code = 1 (Success)
  |        If Rc = 1;
  |           Exsr XmlInto;
  |
  |   *?      // Check Response and Process
  |           Exsr ResponseSr;
  |        Else;
  |           ErrMsg1 = 'We are unable to connect to the credit card company';
  |           If Del <> 'Y';
  |              ModReq = 'SCREEN2';
  |              FunReq = 'DISPLAY';
  |           Else;
  |              ModReq = 'SCREEN1';
  |              FunReq = 'DISPLAY';
SUD04         Endif;
SUD02      Endif;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : CrtStmf Subroutine :
  |   *?                :--------------------:
  |   *
  |     Begsr CrtStmf;
  |
  |   *?   // Create Stream file in IFS
  |        WKFile = *Blanks;
  |        Chain ('IFS' : 'IFSPATH' ) WSPCIPRM01;
  |        If %Found;
  |            WkPath = %Trim(PRVALUE);
  |        Endif;
  |
  |        WkFile = 'Res_' + %Trim(Pgm) + '_' + %Trim(WkCustC);
  |
  |        Filename =  %Trim(WKPATH)+ %Trim(WkFile) +  '-'  +
  |                    %Char(%Timestamp())  + '.xml';
  |        Cmd = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(Filename) + ''' )';
  |
  |        Exsr CallCmd;
  |
  |   *?   // Change attributes of Stream file
  |        Cmd = 'CHGATR OBJ(''' + %Trim(Filename) + ''')' +
  |                      ' ATR(*CCSID) VALUE(1208)';
  |        Exsr CallCmd;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : CallCmd Subroutine :
  |   *?                :--------------------:
  |   *
  |     Begsr CallCmd;
  |
  |   *?   // Call QCMDEXC ,Monitor if there is a error
  |        Monitor;
  |           QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
  |        On-Error;
  |        EndMon;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : XmlInto Subroutine :
  |   *?                :--------------------:
  |   *
  |     Begsr XmlInto;
  |
  |   *?   // XML Into Datastructure
  |        Options = 'path=txn allowextra=yes allowmissing=yes case=any ' +
  |                  'doc=file';
  |        Xml-Into Txn  %XML(%Trim(Filename) : Options);
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :-----------------------:
  |   *?                : ResponseSr Subroutine :
  |   *?                :-----------------------:
  |   *
  |     Begsr ResponseSr;
  |
  |   *?   // Check Response values
  |        If Txn.errorCode <> *Blanks;
  |           WkLen = 0;
  |           WkLen = %Len(%Trim(Txn.errorMessage));
  |           If WkLen < 76;
  |              ErrMsg1 = %Subst(Txn.errorMessage : 1 : 50);
  |              ErrMsg2 = *Blanks;
  |           Else;
  |              ErrMsg1 = %Subst(Txn.errorMessage : 1  : 50);
  |              ErrMsg2 = %Subst(Txn.errorMessage : 51 : 50);
  |           Endif;
  |           WkLen = 0;
  |        Else;
  |           If Txn.ssl_token_response <> 'SUCCESS';
  |              ErrMsg1 = Txn.ssl_token_response;
  |           Endif;
  |        Endif;
  |
  |   *?   // If Error Show it on Second Screen
SUD02      If ErrMsg1 <> *Blanks;
SUD03         If Del <> 'Y';
  |              ModReq = 'SCREEN2';
  |              FunReq = 'DISPLAY';
  |           Else;
  |              ModReq = 'SCREEN1';
  |              FunReq = 'DISPLAY';
SUD03         Endif;
SUD02      Else;
  |           ModReq = 'SCREEN1';
  |           FunReq = 'INITIAL';
  |        Endif;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :----------------------:
  |   *?                : SavReqIfs Subroutine :
  |   *?                :----------------------:
  |   *
  |     Begsr SavReqIfs;
  |
  |   *?   // Store Request Xml
  |        If Xmldata <> *Blanks;
  |
  |   *?      // Create stream file
  |           WkFile = *Blanks;
  |           Chain ('IFS' : 'IFSPATH' ) WSPCIPRM01;
  |           If %Found;
  |              WkPath = %Trim(PRVALUE);
  |           Endif;
  |
  |           WkFile = 'Req_' + %Trim(Pgm) + '_' + %Trim(WkCustC)
  |                       + '_' + %Char(%Timestamp()) + '.xml';
  |
  |   *?      // Copy to Stream File
  |           Cmd = 'CPYTOIMPF FROMFILE(IFSREQ) STMFCODPAG(1208) ' +
  |                  'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
  |                    + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)';
  |
  |           Exsr CallCmd;
  |        Endif;
  |
  |   *?   // Clear Flat File
  |        Cmd  = 'CLRPFM FILE(QTEMP/IFSREQ)';
  |        Exsr CallCmd;
  |
  |     Endsr;
SUD02 //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : ClearMessage Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Call CL program to Clear Message
      *?
        Begsr ClearMessage;

      *?   // Clear Message from Message Subfile Control Part
           PMsgf = 'WSMSGF';
           POpt  = 'C';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : SendMessage Subroutine :
      *?                :------------------------:
      *
      *?Logic : Call CL program to Send Message
      *?
        Begsr SendMessage;

      *?   // Show Message on Message Subfile Control Part
           PMsgf = 'WSMSGF';
           POpt  = 'I';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
SUD02 //--------------------------------------------------------------------
  |   *?                :-----------------------:
  |   *?                : ErrMessage Subroutine :
  |   *?                :-----------------------:
  |   *
  |   *?Logic : Call CL program to Show Message
  |   *?
  |     Begsr ErrMessage;
  |
  |   *?   // Show Message On Screen from Message File
  |        Monitor;
  |          WkMsgf = 'WSMSGF';
  |          WkDta  = *Blanks;
  |          RtvErrMsg(WkMsgID:WkMsgf:WKMSG:WkDta);
  |        On-Error;
  |        EndMon;
  |        ErrMsg1 = WkMsg;
  |        ModReq  = 'SCREEN2';
  |        FunReq  = 'DISPLAY';
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : AddToXml Procedure :
  |   *?                :--------------------:
  |   *
  |   *?Logic   : AddToXml to generate XML Acknowledgement
  |   *?          Field by field process
  |   *?Example : Starttag : <Tagname>
  |   *?          Opentag  : <Tagname
  |   *?          Closetag :  Tagname/>
  |   *?          Close    :  Tagname>
  |   *?          Endtag   : </Tagname>
  |   *
  |     Dcl-Proc  AddToXml;
  |        Dcl-Pi AddToXml;
  |           Tagname      Char(50)  Value;
  |           Tagvalue     Char(300) Value;
  |           Info         Char(10)  Value;
  |        End-Pi;
  |
  |   *?   // Check Info to add XML tag
  |        Select;
  |
  |           When Info = 'Starttag';
  |              Xmldata = %Trimr(Xmldata) + '<' + %Trim(Tagname)+ '>';
  |
  |           When Info = 'Element';
  |               Xmldata = %Trimr(Xmldata) + ' <' + %Trim(Tagname) + '>'
  |                     + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';
  |
  |           When Info = 'Endtag';
  |               Xmldata = %Trimr(Xmldata) + ' </' + %Trim(Tagname) + '>';
  |
  |        Endsl;
  |
  |   *?   // Write XML Line into IFS
  |        If FlStore = True;
  |           Exsr WriteIFS;
  |        Endif;
  |   *
  |   //--------------------------------------------------------------------
  |   *?            :---------------------:
  |   *?            : WriteIFS Subroutine :
  |   *?            :---------------------:
  |   *
  |   *?Logic : Write Each tag as a Record into Flat File
  |   *?
  |     Begsr WriteIFS;
  |
  |   *?   // Check Info to add XML tag
  |        Select;
  |
  |           When Info = 'Starttag';
  |              XmlIfs = '<' + %Trim(Tagname) + '>';
  |
  |           When Info = 'Element';
  |              XmlIfs = ' <' + %Trim(Tagname) + '>'
  |                     + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';
  |
  |           When Info = 'Endtag';
  |              XmlIfs = ' </' + %Trim(Tagname) + '>';
  |
  |        Endsl;
  |
  |   *?   // Insert into Flat File
  |        Exec Sql
  |        INSERT INTO IFSREQ Values(:XMLIFS);
  |
  |     Endsr;
  |
SUD02   End-Proc;
      *?---------------- End Of Subroutines --------------------------------
