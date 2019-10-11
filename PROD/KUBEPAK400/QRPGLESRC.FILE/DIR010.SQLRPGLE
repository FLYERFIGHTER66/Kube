      *? Program        : DIR010
      *?
      *? Description    : This pgm to Maintain ShipTo Directions
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 20 Nov 2018
      *---------------------------------------------------------------------
      *? Special Notes  : Called from
      *?                   1.ARR010 - SCRNB - F16 - Directions
      *?                   2.SHR010 - (Main Screen F9-Directions)
      *?                              (Add Screen F8-Directions)
      *?                   3.BIR100 - SCRND - F8 - ShipTo/Directions
      *?
      *? Called Program : WSSFLMSG - WS - Send and Clear message from subfile
      *?                  QCMDEXC  - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *
      *
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*usa);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Ship-To Directions Logical File
      *?Key : Customer Number : Seq# Number : Line Number
        Dcl-F FDIRECTL0  Disk(*Ext) Keyed Usage(*Delete:*Output);
      *
      *?File: Display file to ShipTo Directions Screen
        Dcl-F DIR010FM   Workstn Indds(Dspf) Sfile(DIR010S01:S01Rrn);
      *
      *?File: Printer file to ShipTo Directions
        Dcl-F DIR010P    Printer  OflInd(*In29) UsrOpn;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi DIR010 ExtPgm;
           PCust Packed(6);
           PSeq# Packed(3);
        End-Pi;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;                         // CL Program
           PMsgf  Char(10);                             // Msg File
           PMsgId Char(7);                              // Msg Id
           POpt   Char(1);                              // Msg Opt
        End-Pr;
      *
      *?Procedure Prototype Declaration :  Call Change Printer Program
        Dcl-Pr #CHGPRT ExtPgm;                          // Rpg Program
           PUser  Char(10);                             // User
           PPgm   Char(10);                             // Program
           PPrt   Char(10);                             // Printer
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(200)    Const Options(*Varsize);
           Len Packed(15:5) Const;
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
      *?Direction Declaration :
        Dcl-Ds Direction;
           DirRcd     Char(80)  Dim(320);
           DirPage    Char(80)  Dim(50) Pos(1);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S ModReq     Char(10)    Inz;
        Dcl-S FunReq     Char(10)    Inz;
        Dcl-S Cmd        Char(200)   Inz;
        Dcl-S DirLine    Packed(3:0) Inz;
        Dcl-S TargetLine Packed(3:0) Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkSeq     Like(SDSEQ#);
        Dcl-S WkPrinter Char(10)    Inz;
      *
      *?Flag Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlSflMod Ind Inz(*Off);
        Dcl-S FlFound  Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf  Char(10);                        // For CL program
        Dcl-S PMsgId Char(7);
        Dcl-S POpt   Char(1);
        Dcl-S PPrt   Char(10);                        // For Change Printer Pgm
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           PrintMode       Ind Pos(2);          // Print Mode Function Key
           Exit            Ind Pos(3);          // Exit Function Key
           Refresh         Ind Pos(5);          // Refresh Function Key
           FDelete         Ind Pos(8);          // Delete Function Key
           FInsert         Ind Pos(9);          // Insert Function Key
           FPrint          Ind Pos(10);         // Print Function Key
           ChangePrinter   Ind Pos(11);         // ChangePrinter Function Key

           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :--------------:
      *?                : Copy  Source :
      *?                :--------------:
      *
      *?Service Programs
    ?D/COPY QFunctDefn,$DftPrt
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
           S01Rrn  = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write DIR010C01;

      *?   // Clear Subfile
           Dspf.S01SflClr    = False;          // Clear Ind OFF
           Dspf.S01SflDspCtl = True;           // Display Control Ind ON

      *?   // Build Subfile
           C01Cust = PCust;
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

      *?   // Load the Subfile from Array
           Dspf.S01SflNxtChg = True;
           Dow S01Rrn < %Elem(DirPage);

      *?      // Increment RRN
              S01Rrn  += 1;
              S01Text = DirPage(S01RRN);

      *?      // Write Subfile Display Part
              Write DIR010S01;
              Dspf.S01SflDsp = True;
           Enddo;

      *?   // Chain RRN and Subfile End Indicator On
           Chain S01RRN DIR010S01;
           Dspf.S01SflEnd = True;
           Update DIR010S01;

      *?   // Check RRN
           If S01Rrn <> *Zeros;
              Dspf.S01SflDsp = True;
              FunReq = 'DISPLAY';
           Else;

      *?      // If No Records Found , Write Blank Lines
              Exsr InsertLine;
              Dspf.S01SflDsp = True;
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
           Write Assume;
           Write DIR010F01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt DIR010C01;

      *?   // Find Cursor
           Exsr FindCursor;

      *?   // Load Array from Subfile
           Exsr DirAryFromSubfile;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F2 Pressed
              When Dspf.PrintMode;
                 ExSr PrintModeSr;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F5 Pressed
              When Dspf.Refresh;
                 ModReq = 'SCREEN';
                 FunReq = 'INITIAL';

      *?      // F8 Pressed
              When Dspf.FDelete;
                 If SFLCSRRRN <> *Zeros;
                    Exsr DeleteLine;
                    FunReq = 'INITIAL';
                 Else;
                    PMsgId = 'WS00087';
                    Exsr Sendmessage;
                    FunReq = 'DISPLAY';
                 Endif;

      *?      // F9 Pressed
              When Dspf.FInsert;
                 Select;
                    When DirRcd(%Elem(DirRcd)) <> *Blanks;
                       PMsgId = 'WS00089';
                       Exsr Sendmessage;
                       FunReq = 'DISPLAY';
                    When CSRFLD <> 'S01TEXT';
                       PMsgId = 'WS00087';
                       Exsr Sendmessage;
                       FunReq = 'DISPLAY';
                    Other;
                       Exsr InsertLine;
                       FunReq = 'INITIAL';
                 EndSl;

      *?      // F10 Pressed
              When Dspf.FPrint;
                 Exsr PrintSr;

      *?      // F11 Pressed
              When Dspf.ChangePrinter;
                 Exsr ChangePrinter;
                 FunReq = 'DISPLAY';

      *?      // Other Pressed
              Other;
                 FunReq = 'PROCESS';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN1P;

      *?   // Process the subfile records
           WkSeq = 1;
           DoW WkSeq <= %Elem(DirRcd);
              Setll (C01Cust:C01Seq#:WkSeq) FDirectL0;
              FlFound = %Equal(FDirectL0);
              Select;

      *?         // If Direction Line is Blank , But Detail Record Exists
      *?         // Delete the Line
                 When DirRcd(WkSeq) = *Blanks and FlFound = True;
                    Chain (C01Cust:C01Seq#:WkSeq) FDirectL0;
                    Delete FDirectR;

      *?         // If there is detail Line for this , But Detail Record Doesn't Exists
      *?         // Write the Line
                 When DirRcd(WkSeq) <> *Blanks and FlFound = False;
                    Exsr WriteSr;

      *?         // If there is detail Line for this , But Detail Record Exists
      *?         // Write the Line
                 When DirRcd(WkSeq) <> *Blanks and FlFound = True;
                    Exsr UpdateSr;
              Endsl;
              WkSeq = WkSeq + 1;
           Enddo;
           ModReq = 'EXIT';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : InsertLine Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Insert Blank Lines
      *?
        Begsr InsertLine;

      *?   // Insert Lines Based on Rrn
           DirLine = SFLCSRRRN;
           TargetLine = %Elem(DirRcd);
           DoW TargetLine > DirLine;
              DirRcd(TargetLine) = DirRcd(TargetLine - 1);
              TargetLine = TargetLine - 1;
           Enddo;
           DirRcd(DirLine) = *Blanks;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : DeleteLine Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Delete Lines from Subfile and File
      *?
        Begsr DeleteLine;

      *?   // Delete Lines Based on Rrn
           DirLine = SFLCSRRRN;
           DoW DirLine < %Elem(DirRcd);
              DirRcd(DirLine) = DirRcd(DirLine + 1);
              DirLine = DirLine + 1;
           Enddo;
           DirRcd(%Elem(DirRcd)) = *Blanks;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : UpdateSr Subroutine :
      *?                :---------------------:
      *
      *?Logic : Update Directions in file
      *?
        Begsr UpdateSr;

      *?   // Update Directions for that Line
           Chain (C01Cust:C01Seq#:WkSeq) FDIRECTL0;
           If %Found;
              SDTEXT = DirRcd(WkSeq);
              SDUPDDAT = Rundate;
              SDUPDTIM = Runtime;
              SDUPDUSR = User;
              SDUPDPGM = Pgm;
              SDUPDJOB = Job;
              Update FDIRECTR %Fields(SDTEXT:SDUPDDAT:SDUPDTIM:
                                   SDUPDUSR:SDUPDJOB:SDUPDPGM);
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : WriteSr Subroutine :
      *?                :--------------------:
      *
      *?Logic : Write Directions in file
      *?
        Begsr WriteSr;

      *?   // Clear Record
           Clear FDIRECTR;

      *?   // Write New record in Directions for that Customer
           SDCUST   = C01Cust;
           SDSEQ#   = C01Seq#;
           SDLINE   = WkSeq;
           SDTEXT   = DirRcd(WkSeq);
           SDCRTDAT = Rundate;
           SDCRTTIM = Runtime;
           SDCRTUSR = User;
           SDCRTPGM = Pgm;
           SDCRTJOB = Job;
           Write FDIRECTR;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : ChangePrinter Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Change Printer Name
      *?
        Begsr ChangePrinter;

      *?   // Call Rpg Program to Change Printer
           PPrt = '*LAST';
           #Chgprt(User:Pgm:PPrt);
           If PPrt <> *Blanks;
              PrtName = PPrt;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : PrintModeSr Subroutine :
      *?                :------------------------:
      *
      *?Logic : Choose Print Mode
      *?
        Begsr PrintModeSr;

      *?   // Clear Record Format
           Clear DIR010R01;

      *?   // Write Record Format
           Exfmt DIR010R01;

      *?   // Go back to Sceen
           FunReq = 'DISPLAY';

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
           PGMQ = Pgm;

      *?   // Move Control Fields
           C01Cust = PCust;
           C01Seq# = PSeq#;
           Exec Sql
              Select CMNAME into :C01Name From FMCUST Where
              CMCUST = :C01Cust;

      *?   // Set Default Printer Values
           WkPrinter = $DftPrt(User:Pgm:'*LAST');
           PRTName = WkPrinter;
           PtMode  = 1;

      *?   // Set Default Values
           PUTSFLRRN = 1;

      *?   // Load Array from the File
           Exsr DirAryFromFile;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------------:
      *?                : DirAryFromSubFile Subroutine :
      *?                :------------------------------:
      *
      *?Logic : Load directions from Subfile to array
      *?
        Begsr DirAryFromSubFile;

      *?   // Check Record Exists
           Dspf.S01SflNxtChg = True;
           ReadC DIR010S01;
           DoW Not %Eof(DIR010FM);
              DirPage(S01RRN) = S01Text;
              ReadC DIR010S01;
           Enddo;
           Dspf.S01SflNxtChg = False;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : DirAryFromFile Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Load directions from file to array
      *?
        Begsr DirAryFromFile;

      *?   // Check Record Exists
           Setll (C01Cust:C01Seq#) FDirectl0;
           ReadE(N) (C01Cust:C01Seq#) FDirectl0;
           DoW Not %EOF(FDirectL0);
               DirRcd(SDLine) = SDText;
               ReadE (C01Cust:C01Seq#) FDirectl0;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : FindCursor Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Find Cursor position
      *?
        Begsr FindCursor;

      *?   // Check Cursor
           If CSRFLD <> 'S01TEXT';
              PUTCSRLIN = 7;
              PUTCSRPOS = 2;
              PUTSFLRRN = 1;
           Else;
              PUTCSRLIN = SFLCSRRRN + 6;
              PUTCSRPOS = 2;
              PUTSFLRRN = SFLCSRRRN;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : PrintSr Subroutine :
      *?                :--------------------:
      *
      *?Logic : Print subfile records based on the mode
      *?
        Begsr PrintSr;

      *?   // Setup Printer file with Name
           Exsr CallCmd;

      *?   // Open Printer file
           If not %Open(DIR010P);
              Open DIR010P;
           Endif;

      *?   // Setoff indicators
           *In60 = *Off;
           *In61 = *Off;
           *In62 = *Off;
           *In99 = *Off;

      *?   // Set Print Mode
           If PtMode = 1;
              *In60 = *On;                       // Print all Line
           Elseif PtMode = 2;
              *In61 = *On;                       // Remove Multiple Blank Lines
           Else;
              *In62 = *On;                       // Remove all Blanks
           Endif;

      *?   // Write Header/Detail
           Exsr DetailSr;

      *?   // Close Printer file
           If %Open(DIR010P);
              Close DIR010P;
           Endif;


        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : DetailSr Subroutine :
      *?                :---------------------:
      *
      *?Logic : Write Detail records in Printer File
      *?
        Begsr DetailSr;

      *?   // Write Details Records
           Setll (C01Cust:C01Seq#) FDIRECTL0;
           ReadE(N) (C01Cust:C01Seq#) FDIRECTL0;
           Dow Not %Eof(FDIRECTL0);

      *?      // Write Header
              If *In99 = *Off Or *In29 = *On;
                 *In99 = *On;
                 *In29 = *Off;
                 Write Header;
              Endif;

              Direct = SDText;
              Write Detail;
              ReadE(N) (C01Cust:C01Seq#) FDIRECTL0;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CallCmd Subroutine :
      *?                :--------------------:
      *
        Begsr CallCmd;

      *?   // Override Printer File
           Cmd = 'OVRPRTF FILE(DIR010P) PAGESIZE(66) CPI(10) FORMTYPE(*NAR)' +
                 ' PAGRTT(0) OVRSCOPE(*JOB) OUTQ(|P)';

      *?   // Put the Printer Name in the Override command
           Cmd = %ScanRpl('|P':PrtName:Cmd);

      *?   // Call QCMDEXC ,Monitor if there is a error
           Monitor;
              QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
           On-Error;
           EndMon;

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
