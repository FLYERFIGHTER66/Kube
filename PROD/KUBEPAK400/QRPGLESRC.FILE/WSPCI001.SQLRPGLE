      *? Program        : WSPCI001
      *?
      *? Description    : This pgm to Select List of Credit cards for
      *?                  Bill to Customer
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 03 APR 2018
      *---------------------------------------------------------------------
      *? Special Notes  :** Used for BIR235 & ARR210
      *?
      *? Called Program : WSPCI002 - PCI-Credit Card Process Screen Program
      *?                : WSPCI004 - PCI-Maintenance Program for Credit Card Token File
      *?                : WSSFLMSG - WS - Send and clear message from subfile
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   06/25/18   S.Uthaya     Added PManual in Entry Parameter
      * SUD02   06/25/18   S.Uthaya     Token replaced by Comment in Screen
      * SUD03   08/01/18   S.Uthaya     Call CC Token Maintenance Program from Screen
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
      *?File: Display file to Select Credit Card Screen
        Dcl-F WSPCI001FM Workstn Indds(Dspf) Sfile(PCI001S01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry Parameters
        Dcl-Pi WSPCI001 ExtPgm;
           ParmDs1 LikeDs(ParmDs);
        End-Pi;
      *
      *?Procedure Prototype Declaration : To Call Credit Card Process Screen
        Dcl-Pr WSPCI002 Extpgm;
           ParmDs1 Like(ParmDs);
        End-Pr;
      *
SUD03 *?Procedure Prototype Declaration : To Call CCC Token Maintenance Program
  |     Dcl-Pr WSPCI004 Extpgm;
  |        PCust Packed(6);
  |        PSts  Char(2);
SUD03   End-Pr;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
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
SUD01      PManual    Char(1);                   // Identify Manual Process
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
      *?Global Variable Declaration :
        Dcl-S ModReq Char(10)    Inz;
        Dcl-S FunReq Char(10)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCount  Zoned(2:0) Inz;
        Dcl-S WkCust   Packed(6)  Inz;
SUD02   Dcl-S WkToken  Packed(16) Inz;
        Dcl-S WkCustNa Char(30)   Inz;
      *
      *?Flag Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf  Char(10);                  // For CL program
        Dcl-S PMsgId Char(7);
        Dcl-S POpt   Char(1);
SUD03   Dcl-S PCust  Packed(6);                 // For WSPCI004
SUD03   Dcl-S PSts   Char(2);                   // For WSPCI004
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           AddNew          Ind Pos(6);          // Add New CC Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
SUD03      TokenMain       Ind Pos(23);         // Token Maintenance Function Key
      *
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           S01OptRi        Ind Pos(50);         // Option Reverse Image Ind
           S01OptPc        Ind Pos(51);         // Position Cursor Ind
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
              Dow ModReq = 'SCREEN';
                 Exsr SN1M;
              Enddo;

           Enddo;

      *?   // Move Values to Return Datastructure from Pgm Datastructure
           Eval-Corr ParmDs = ParmDs1;

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

      *?   // Initialise Reverse Image indicator
           Dspf.S01OptRi = False;
           FlError = False;
           S01Opt  = *Zeros;
           S01Rrn  = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write PCI001C01;

      *?   // Clear Subfile
           Dspf.S01SflClr    = False;          // Clear Ind OFF
           Dspf.S01SflDspCtl = True;           // Display Control Ind ON

      *?   // Build Subfile
           Exsr SN1B;

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
           Dspf.S01OptRi = False;
           Dspf.S01OptPc = True;
           S01Opt  = *Zeros;
           S01Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A1 Cursor For
SUD02         Select CCTYPE, CCCARDNO, CCCMNT FROM WSCCTOKPF
                               WHERE CCCUST= :WkCust;
           Exec Sql
              Open A1;
              If SqlCode = -502 ;
                 Exec Sql
                 Close A1;
                 Exec Sql
                 Open A1;
              EndIf;

SUD02      Exec Sql Fetch A1 Into :S01TYPE,:S01CARD,:S01CMNT;

           Dow SqlCod = 0 And WkCount < 9999;

      *?      // Increment RRN
              S01Rrn  += 1;
              WkCount += 1;

      *?      // Write Subfile Display Part
              Write PCI001S01;
SUD02         Exec Sql Fetch A1 Into :S01TYPE,:S01CARD,:S01CMNT;
           Enddo;
           Exec Sql Close A1;

      *?   // Subfile End Indicator ON
           Dspf.S01SflEnd = *On;

      *?   // Check RRN
           If S01Rrn <> *Zeros;
              Dspf.S01SflDsp = True;
              FunReq = 'DISPLAY';
           Else;

      *?      // If No Records Found, Call Credit Card Process Screen
              WSPCI002(ParmDs);
              If ParmDs.PSts = 'Approval';
                 ModReq = 'EXIT';
                 Eval-Corr ParmDs1 = ParmDs;
              Elseif ParmDs.PSts = 'Cancel';
                 ModReq = 'EXIT';
                 Eval-Corr ParmDs1 = ParmDs;
              Endif;
           Endif;

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
           Write PCI001F01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt PCI001C01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F6 Pressed
              When Dspf.AddNew;
                 If S01Opt = *Zeros and FlError = False;
                    Eval-Corr ParmDs = ParmDs1;
                    WSPCI002(ParmDs);
                    If ParmDs.PSts = 'Cancel';
                       S01Opt = *Zeros;
                       ModReq = 'SCREEN';
                       FunReq = 'INITIAL';
                    Elseif ParmDs.PSts = 'Approval';
                       Eval-Corr ParmDs1 = ParmDs;
                       ModReq = 'EXIT';
                    Endif;
                 Endif;

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ParmDs.PSts = 'Cancel';
                 Eval-Corr ParmDs1 = ParmDs;
                 ModReq = 'EXIT';

SUD03 *?      // F23 Pressed
  |           When Dspf.TokenMain;
  |              PCust = ParmDs.PCust#;
  |              PSts = *Blanks;
  |              WSPCI004(PCust:PSts);
  |              If PSts = '03';
  |                 ModReq = 'EXIT';
  |              Elseif PSts = '12';
  |                 FunReq = 'INITIAL';
SUD03            Endif;

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
           Dspf.S01OptRi = False;
           Dspf.S01OptPc = False;
           FlError = False;
           WkCount = *Zeros;

      *?   // Validate Entered values in Subfile
           If Dspf.S01SflDsp;
              ReadC PCI001S01;
              Dow Not %Eof(WSPCI001FM);
                 Dspf.S01OptRi = False;

      *?         // Validate Option
                 If S01Opt <> *Zeros And S01Opt <> 1;
                    Dspf.S01OptPc = True;
                    Dspf.S01OptRi = True;
                    PMsgId  = 'WS00028';
                    FlError = True;
                    Exsr SendMessage;
                 Endif;
                 Dspf.S01SflNxtChg = True;
                 Update PCI001S01;
                 Dspf.S01SflNxtChg = False;
                 ReadC PCI001S01;
              Enddo;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
           Else;
              FunReq = 'PROCESS';
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
              ReadC PCI001S01;
              Dow Not %Eof(WSPCI001FM);
                 Select;

      *?            // Select Credit Card
                    When S01Opt = 1;
                       Exsr ProcessSr;
                 Endsl;
                 Dspf.S01SflNxtChg = True;
                 Update PCI001S01;
                 Dspf.S01SflNxtChg = False;
                 ReadC PCI001S01;
              Enddo;
              FunReq = 'INITIAL';

           Endif;

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
           PGMQ   = Pgm;
           C01Pgm = Pgm;
           C01Usr = User;

      *?   // Move Values from Entry Datastructure to Pgm Datastructure
           Eval-Corr ParmDs = ParmDs1;

      *?   // Move Control Fields
           C01Cust = ParmDs.PCust#;
           C01Ord# = ParmDs.POrder#;
           C01Inv# = ParmDs.PInvoice;
           WkCust  = C01Cust;
           Exec Sql
              Select CMNAME into :WkCustNa From FMCUST Where
              CMCUST = :C01Cust;
           C01Name = WkCustNa;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : ProcessSr Subroutine :
      *?                :----------------------:
      *
      *?Logic : Call Credit Card Process Screen
      *?
        Begsr ProcessSr;

      *?   // Call Program to Show all error in screen
           ParmDs.PCType = S01Type;
           ParmDs.PCCard = S01Card;
SUD02      Exec Sql
  |           Select CCTOKENNO into :WkToken From WSCCTOKPF where
  |           CCTYPE = :S01Type and CCCARDNO = :S01Card and
  |           CCCUST = :C01Cust;
SUD02      ParmDs.PToken = WkToken;

           WSPCI002(ParmDs);
           If ParmDs.PSts = 'Cancel';
              S01Opt = *Zeros;
              ModReq = 'SCREEN';
              FunReq = 'INITIAL';
           Elseif ParmDs.PSts = 'Approval';
              Eval-Corr ParmDs1 = ParmDs;
              ModReq = 'EXIT';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
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
      *?---------------- End Of Subroutines --------------------------------
