      *? Program        : WSPCI002
      *?
      *? Description    : This pgm to Process Credit Card and
      *?                  Call Webservice Program for Payment
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 02 Apr 2018
      //--------------------------------------------------------------------
      *? Special Notes  :** Used for BIR235 & ARR210
      *?
      *? Called Program : WSPCI003 - PCI-POST XML to Client Site and Receive Response
      *?                  WSRTVMSG - WS - Retrieve message from Message file
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   06/25/18   S.Uthaya     Manual Swiping F7 Function Key Added and
      *                                 Comment Field Added in Screen
      * WJB01   07/24/18   W.J.Behr     Change Card4 logic
      * SUD02   07/26/18   S.Uthaya     Tokenize and Store Card based on Get
      *                                 Token Field (New field in Screen)
      * SUD03   08/31/18   S.Uthaya     Error message field length increased
      *                                 in Screen
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - PCI Credit Card/Token Logical File
SUD02 *?Key : Customer Number : Card Number
SUD02   Dcl-F WSCCTOKL01 Disk(*Ext) Keyed Usage(*Output:*Update)
                                          Rename(WSCCTOKR:Rec);
      *?Key : Customer Number : Token Number
        Dcl-F WSCCTOKL02 Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: Credit Card Master File
      *?Key : Credit Card Code
        Dcl-F FMCRED     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File : Display file for Credit Card Process Screen
        Dcl-F WSPCI002FM Workstn Indds(Dspf);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry Parameters
        Dcl-Pi WSPCI002;
           ParmDs1 LikeDs(ParmDs);
        End-Pi;
      *
      *?Procedure Prototype Declaration : To Call Webservice Program
        Dcl-Pr WSPCI003 Extpgm;
           ParmDs1   LikeDs(ParmDs);
           PGetToken Char(1);
           PCCvv     Packed(3);
SUD03      PMsg      Char(150);
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
      *?Parameter Data Structure : ParmDs
        Dcl-Ds ParmDs Qualified;
           PCust#     Packed(6);                 // Customer Number
           POrder#    Packed(6);                 // Order Number
           PInvoice   Packed(6);                 // Invoice Number
           PPgm       Char(10);                  // Program Name
           PSts       Char(10);                  // Status from Called
           PCCard     Packed(16);                // Card Number
           PCType     Char(4);                   // Credit Card Type
           PCExp      Packed(4);                 // Credit Card Expiry
           PToken     Packed(16);                // Token Number
           PCApr      Char(10);                  // C.C Approval Status
           PAmount    Packed(11:2);              // Amount to be paid
           PManual    Char(1);                   // To Identify Manual Process
        End-Ds;
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
      *?Flag Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);
      *
      *?Global Variable Declaration :
        Dcl-S ModReq Char(10)    Inz;
        Dcl-S FunReq Char(10)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkMsgf   Char(10)    Inz;                // Used for Msg File
        Dcl-S WkMsgId  Char(7)     Inz;                // Used for Msg File
        Dcl-S WkMsg    Char(132)   Inz;                // Used for Msg File
        Dcl-S WkDta    Char(10)    Inz;                // Used for Msg File
        Dcl-S WkCard   Char(16)    Inz;
        Dcl-S WkCard4  Packed(4)   Inz;
        Dcl-S WkCExp   Char(4)     Inz;
        Dcl-S WKCCvv   Char(3)     Inz;
        Dcl-S WkCMm    Packed(2)   Inz;
        Dcl-S WkCYy    Packed(2)   Inz;
        Dcl-S WkLen    Packed(2)   Inz;
        Dcl-S WkToken  Packed(16)  Inz;
        Dcl-S WkCust   Packed(6)   Inz;
        Dcl-S WkCustNa Char(30)    Inz;
        Dcl-S WkCurDt  Char(6)     Inz;
        Dcl-S WkCurMm  Packed(2)   Inz;
        Dcl-S WkCurYy  Packed(2)   Inz;
      *
      *?CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PGetToken Char(1);
        Dcl-S PCCvv     Packed(3);
SUD03   Dcl-S PMsg      Char(150);
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Process         Ind Pos(9);          // Process Function Key
           Previous        Ind Pos(12);         // Previous Function Key
      *
           RAmountRi       Ind Pos(50);         // Record CAmount Ind
           RCCardRi        Ind Pos(51);         // Record CCard Ind
           RCTypeRi        Ind Pos(52);         // Record CType Ind
SUD01      RCCmntRi        Ind Pos(53);         // Record CCmnt Ind
  |        RCExpRi         Ind Pos(54);         // Record CardExp Ind
  |        RCCvvRi         Ind Pos(55);         // Record CCvv2 Ind
SUD01      RCAprRi         Ind Pos(56);         // Record CAPR Ind
SUD02      RGetTknRi       Ind Pos(57);         // Record GETTOKEN Ind
SUD01      RProtect        Ind Pos(60);         // Record Protect Ind
  |        RFKey           Ind Pos(70);         // Function Key Ind
  |        RNonDsp         Ind Pos(80);         // Non Display Ind
SUD01      RNonDsp1        Ind Pos(81);         // Non Display Ind for Comment
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

      *?   // Move Values to Return Datastructure from Pgm Datastructure
           Eval-Corr ParmDs1 = ParmDs;

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
      *?Logic : Clear all screen Input Parameters
      *?
        Begsr SN1I;

      *?   // Initialise Reverse Image & Function Key indicator
           Dspf.RAmountRi = False;
           Dspf.RCCardRi  = False;
           Dspf.RCTypeRi  = False;
           Dspf.RCCmntRi  = False;
           Dspf.RCExpRi   = False;
           Dspf.RCCvvRi   = False;
SUD02      Dspf.RGetTknRi = False;

      *?   // Clear Subfile
           Clear Record;                       // Clear Record Format

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
           BillTo  = ParmDs.PCust#;

      *?   // Get Customer Name from File
           Exec Sql
              Select CMNAME into :WkCustNa From FMCUST Where CMCUST = WkCust#;
           BillCust = WkCustNa;

      *?   // Get All screen fields
           OrderNo# = ParmDs.POrder#;
           Invoice# = ParmDs.PInvoice;
           If CAmount = *Zeros;
              CAmount = ParmDs.PAmount;
           Endif;
           If CType = *Blanks;
              CType = ParmDs.PCType;
           Endif;
           If CCard = *Zeros;
              CCard = ParmDs.PCCard;
           Endif;
           If ParmDs.PToken <> *Zeros;
              Dspf.RProtect = *On;
              Wktoken  = ParmDs.PToken;
           Else;
              Dspf.RProtect = *Off;
           Endif;

           If CCmnt = *Blanks and CCard <> *Zeros;
              Exec Sql
                 Select CCCMNT into :CCmnt From WSCCTOKPF
                 Where CCCARDNO = :CCARD and CCCUST = :BILLTO;
           Endif;

SUD02      If GetToken = *Blanks;
  |           If WkToken  <> *Zeros;
  |              GetToken = 'N';
  |           Else;
  |              GetToken = 'Y';
  |           Endif;
SUD02      Endif;

      *?   // Write the Record Format
           Exfmt Record;

      *?   // Check for Function Keys
           Select;

      *?      // F9 Pressed
              When Dspf.Process;
                 Exsr SN1V;
                 If FlError = False;
                    If ParmDs.PManual = 'Y';
                       Exsr MoveFields;
                    Else;
                       FunReq = 'PROCESS';
                    Endif;
                 Endif;

      *?      // F12 Pressed
              When Dspf.Previous;
                 ModReq = 'EXIT';
                 ParmDs.PSts = 'Cancel';

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
SUD03      Clear ErrMsg1;
SUD03      Clear ErrMsg2;

      *?   // Initialise Reverse Image Indicator & Flag
           FlError = False;
           Dspf.RAmountRi= False;
           Dspf.RCCardRi = False;
           Dspf.RCTypeRi = False;
           Dspf.RCAprRi  = False;
           Dspf.RCCmntRi = False;
           Dspf.RCExpRi  = False;
           Dspf.RCCvvRi  = False;
SUD02      Dspf.RGetTknRi= False;

      *?   // Validate Amount Field
           If CAMOUNT <= *Zeros;
              FlError = True;
              Dspf.RAmountRi =  True;
              WkMsgID = 'WS00051';
              Exsr ErrMessage;
           Endif;

SUD01 *?   // Validate Approval Code Field
  |        If ParmDs.PManual = 'Y' and FlError = False;
  |           If CAPR = *Blanks;
  |              FlError = True;
  |              Dspf.RCAprRi =  True;
  |              WkMsgID = 'WS00064';
  |              Exsr ErrMessage;
  |           Endif;
SUD01      Endif;

      *?   // Validate Credit Card Number Field
           If (CCARD = *Zeros and CCARD4 = *Zeros) and FlError = False
                          and Dspf.RProtect = *Off;
              FlError = True;
              Dspf.RCCardRi =  True;
              WkMsgID = 'WS00052';
              Exsr ErrMessage;
           Elseif (CCARD <> *Zeros Or CCARD4 <> *Zeros) and FlError = False
                          and Dspf.RProtect = *Off;
SUD01         If ParmDs.PManual = 'Y';              // Only Last 4 Digit
  |              WkCard = %Char(CCard4);
  |              WkCard = %EditC(CCard4:'X');       // WJB01
  |              WkLen  = %Len(%Trim(%Char(WkCard)));
  |              If WkLen <> 4;
  |                 FlError = True;
  |                 Dspf.RCCardRi =  True;
  |                 WkMsgID = 'WS00062';
  |                 Exsr ErrMessage;
  |              Endif;
  |           Else;
  |              WkCard = %Char(CCard);
  |              WkLen  = %Len(%Trim(%Char(WkCard)));
  |              If WkLen <> 16;
  |                 FlError = True;
  |                 Dspf.RCCardRi =  True;
  |                 WkMsgID = 'WS00060';
  |                 Exsr ErrMessage;
  |              Else;
  |                 WkCard4 = %Int(%Subst(WkCard:13:4));
  |              Endif;
SUD01         Endif;
              WkCard = *Blanks;
              WkLen  = *Zeros;
           Endif;

      *?   // Validate Credit Card Type Field
           If CTYPE = *Blanks and FlError = False and Dspf.RProtect = *Off;
              FlError = True;
              Dspf.RCTypeRi  = True;
              WkMsgID = 'WS00053';
              Exsr ErrMessage;

      *?   // Validate Credit Card Type in Credit Card Master File
           Elseif CTYPE <> *Blanks and FlError = False and Dspf.RProtect = *Off;
              Chain CTYPE FMCRED;
              If Not %Found;
                 FlError = True;
                 Dspf.RCTypeRi  = True;
                 WkMsgID = 'WS00055';
                 Exsr ErrMessage;
              Endif;
           Endif;

      *?   // Validate Credit Card Expiry Date
           If CARDEXP = *Zeros and FlError = False and Dspf.RNonDsp = *Off;
              FlError = True;
              Dspf.RCExpRi  = True;
              WkMsgID = 'WS00054';
              Exsr ErrMessage;

      *?   // Validate Credit Card Expiry Date (Month & Year)
           Elseif CARDEXP <> *Zeros and FlError = False and
                          Dspf.RNonDsp = *Off;
              WkCExp = %Char(CARDEXP);
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
                    Dspf.RCExpRi  = True;
                    WkMsgID = 'WS00056';
                    Exsr ErrMessage;
                 Endif;
                 If WkCYy = WkCurYy and WkCMm < WKCurMm and FlError = False;
                    FlError = True;
                    Dspf.RCExpRi  = True;
                    WkMsgID = 'WS00059';
                    Exsr ErrMessage;
                 Endif;
                 If (WkCYy < 18 or WkCYy >= 60)  and FlError = False;
                    FlError = True;
                    Dspf.RCExpRi  = True;
                    WkMsgID = 'WS00057';
                    Exsr ErrMessage;
                 Endif;
              Else;
                 FlError = True;
                 Dspf.RCExpRi  = True;
                 WkMsgID = 'WS00066';
                 Exsr ErrMessage;
              Endif;
              WkCExp = *Blanks;
              WkLen  = *Zeros;
           Endif;

      *?   // Validate Credit Card CVV
           If CCVV2 = *Zeros and FlError = False and Dspf.RNonDsp = *Off;
              FlError = True;
              Dspf.RCCvvRi = True;
              WkMsgID = 'WS00058';
              Exsr ErrMessage;
           Elseif CCVV2 <> *Zeros and FlError = False and Dspf.RNonDsp = *Off;
              WKCCvv = %Char(CCVV2);
              WkLen  = %Len(%Trim(%Char(WkCCvv)));
              If WkLen <> 3;
              // FlError = True;
              // Dspf.RCCvvRi =  True;
              // WkMsgID = 'WS00061';
              // Exsr ErrMessage;
              Endif;
              WKCCvv = *Blanks;
              WkLen  = *Zeros;
           Endif;

SUD02 *?   // Validate Get Token Field
  |        If ParmDs.PManual = 'N' and FlError = False;
  |           If GetToken <> 'N' and GetToken <> 'Y';
  |              FlError = True;
  |              Dspf.RGetTknRI = True;
  |              WkMsgID = 'WS00063';
  |              Exsr ErrMessage;
  |           Endif;
  |        Endif;
  |
  |   *?   // Token Exists for the Customer and Card
  |        If ParmDs.PManual = 'N' and FlError = False;
  |           If WkCard4 <> *Zeros;
  |              Chain(N) (BillTo:WkCard4) WSCCTOKL01;
  |              If %Found;
  |                 FlError = True;
  |                 Dspf.RCCardRi = True;
  |                 WkMsgID = 'WS00073';
  |                 Exsr ErrMessage;
  |              Endif;
  |              WkCard = *Zeros;
  |           Endif;
  |        Endif;
SUD02
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

      *?   // Call Web service program
           PMsg = *Blanks;
           ParmDs.PCCard = CCard;
           ParmDs.PCExp  = CardExp;
           ParmDs.PCType = CType;
           ParmDs.PAmount= CAmount;
SUD02      WSPCI003(ParmDs:GetToken:CCvv2:PMsg);

      *?   // Show the Credit card process screen until user rectifies the Error
SUD02      If GetToken = 'N';
SUD02         If PMsg <> 'APPROVAL';
SUD03            Exsr MoveErrMsg;
SUD02            ModReq  = 'SCREEN';
  |              FunReq  = 'DISPLAY';
  |           Else;
  |
  |   *?         // Goback to Called Program
  |              ModReq = 'EXIT';
  |              ParmDs.PSts  = 'Approval';
  |           Endif;
  |        Else;
SUD02         If ParmDs.PToken = *Zeros;
SUD03            Exsr MoveErrMsg;
SUD02            ModReq = 'SCREEN';
  |              FunReq = 'DISPLAY';
SUD02         Elseif ParmDs.PToken <> *Zeros and PMsg <> 'APPROVAL';
SUD03            Exsr MoveErrMsg;
SUD02            ModReq = 'SCREEN';
  |              FunReq = 'DISPLAY';
  |           Elseif ParmDs.PToken <> *Zeros and PMsg = 'APPROVAL';
  |
  |   *?         // Update/Write a record in Credit Card File
  |              WkToken = ParmDs.PToken;
  |              Chain (WKCust:WkToken) WSCCTOKL02;
  |              If Not %Found;
  |                 Exsr WriteSr;
  |              Endif;
  |
  |   *?         // Goback to Called Program
  |              ModReq = 'EXIT';
  |              ParmDs.PSts  = 'Approval';
  |           Endif;
SUD02      Endif;

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
           CCCUST    = ParmDs.PCust#;
           If CCard <> *Zeros;
              WkCard   = *Blanks;
              WKCard   = %Char(CCard);
              CCCARDNO = %Int(%Subst(WkCard:13:4));
           Endif;
           CCTYPE    = CTYPE;
           CCTOKENNO = ParmDs.PToken;
           CCCMNT    = CCMNT;

      *?   // Audit Stamp
           CCCRTDAT = Rundate;
           CCCRTTIM = Runtime;
           CCCRTUSR = User;
           CCCRTJOB = Job;
           CCCRTPGM = Pgm;

      *?   // Write a Record
           Write WSCCTOKR;

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?                :-----------------------:
  |   *?                : MoveFields Subroutine :
  |   *?                :-----------------------:
  |   *
  |   *?Logic : Move Scren fields into Parameter Data Structure
  |   *?
  |     Begsr MoveFields;
  |
  |   *?   // Move Fields
  |        ParmDs.PCCard  = CCard4;
  |        ParmDs.PCType  = CType;
  |        ParmDs.PCApr   = CApr;
  |        ParmDs.PAmount = CAMOUNT;
  |        ParmDs.PSts    = 'Approval';
  |        ModReq  = 'EXIT';
  |
SUD01   Endsr;
SUD03 //--------------------------------------------------------------------
  |   *?                :-----------------------:
  |   *?                : MoveErrMsg Subroutine :
  |   *?                :-----------------------:
  |   *
  |   *?Logic : Move Error Message into fields based on length
  |   *?
  |     Begsr MoveErrMsg;
  |
  |   *?   // Move Message
  |        If PMsg <> *Blanks;
  |           WkLen = *Zeros;
  |           WkLen = %Len(%Trim(PMsg));
  |           If WkLen < 76;
  |              ErrMsg1 = %Subst(PMsg : 1 : 75);
  |              ErrMsg2 = *Blanks;
  |           Else;
  |              ErrMsg1 = %Subst(PMsg : 1  : 75);
  |              ErrMsg2 = %Subst(PMsg : 76 : 75);
  |           Endif;
  |           WkLen = *Zeros;
  |        Endif;
  |
SUD03   Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialise Subroutine
      *?
        Begsr *InzSr;

      *?   // Move Values from Entry Datastructure to Pgm Datastructure
           Eval-Corr ParmDs = ParmDs1;

      *?   // Initialise Values
           PrgName = Pgm;
           WkCust  = ParmDs.PCust#;
           ModReq  = 'SCREEN';
           FunReq  = 'INITIAL';

      *?   // Set Function Key
SUD01      If ParmDs.PManual = 'Y';
  |           Dspf.RNonDsp  = True;
  |           Dspf.RNonDsp1 = True;
  |           Dspf.RFKey = True;
  |        Else;
  |           If ParmDs.PCCard = *Zeros;
  |              Dspf.RNonDsp = False;
  |           Else;
  |              Dspf.RNonDsp = True;
  |           Endif;
  |           Dspf.RFKey = False;
SUD01      Endif;

        Endsr;
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
      *?---------------- End Of Subroutines --------------------------------
