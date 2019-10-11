      *? Program        : WSRTNMAN01
      *?
      *? Description    : This Pgm to Maintain Webservices_Retention_Policy File
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 22 May 2019
      //---------------------------------------------------------------------------------
      *? Special Notes  :
      *?
      *? Called Program :WSSFLMSG - WS - Send and clear message from subfile
      *?                 WSRTVMSG - WS - Retrieve message from Message file
      *?                 QCMDEXC  - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl)
                DatFmt(*Usa);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Webservices_Retention_Policy File
      *?Key : Seq : Directory
        Dcl-F RETENTION1 Disk(*Ext) Keyed Usage(*Output:*Update:*Delete);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for IFS Maintainance Screen Program
        Dcl-F WSRTNMANFM Workstn Indds(Dspf) Sfile(RTNMANS01:S01Rrn)
                                             Sfile(RTNMANS02:S02Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration :  No Entry Parameters
        Dcl-Pi WSRTNMAN01 End-Pi;
      *
      *?Procedure Prototype Declaration :  Prompt Screen
        Dcl-Pr WSRTNDIR01 ExtPgm;
           PDirect  Char(32);
           PReturn  Char(75);
        End-Pr;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Call CL program to Retreive MSG
        Dcl-Pr WSRTVMSG Extpgm;                         // CL Program
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
      *?Work Data Structure             :
        Dcl-Ds SflRec Qualified;
           Directory  Char(256);
           FileBeg    Char(32);
           FileEnd    Char(32);
           FileCon    Char(32);
           FileType   Char(32);
           RtnDays    Packed(4:0);
           Seq        Packed(4:0);
        End-Ds;
      *
      *?Program Status Data Structure   : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration     :
        Dcl-S ModReq Char(10)    Inz;
        Dcl-S FunReq Char(10)    Inz;
      *
      *?Work Variable Declaration       :
        Dcl-S WkDirect   Char(256)     Inz;
        Dcl-S WkDirect1  Char(256)     Inz;
        Dcl-S WkFld      Char(256)     Inz;
        Dcl-S WkMsg      Char(132)     Inz;              // Used for Msg File
        Dcl-S WkDta      Char(10)      Inz;              // Used for Msg File
        Dcl-S WkMsgf     Char(10)      Inz;              // Used for Msg File
        Dcl-S WkMsgId    Char(7)       Inz;              // Used for Msg File
        Dcl-S WkFlag     Char(1)       Inz;              // Used for Flag
        Dcl-S WkCount    Zoned(2:0)    Inz;
        Dcl-S NullInd    Int(5) Dim(7) Inz(0);           // Null Indicator for DS
        Dcl-S NullValue  Like(NullInd) Inz(-1);
        Dcl-S WkFRrn     Like(S01RRn);

      *?CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;
      *
      *?Flag Variable Declaration       :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlCtlMod Ind Inz(*Off);
        Dcl-S FlSflMod Ind Inz(*Off);
      *
      *?Parameter Variable Declaration  :
        Dcl-S PDirect Char(32);
        Dcl-S PReturn Char(75);
        Dcl-S PMsgf   Char(10);
        Dcl-S PMsgId  Char(7);
        Dcl-S POpt    Char(1);
      *
      *?Program Indicators Declaration  :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration  :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Prompt          Ind Pos(4);          // Prompt Function Key
           Refresh         Ind Pos(5);          // Refresh Function Key
           Add             Ind Pos(6);          // Add Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           S01SflDsp       Ind Pos(13);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(14);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(15);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(16);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(17);         // Subfile Next Change Ind
      *
           S02SflDsp       Ind Pos(21);         // Subfile Display Ind
           S02SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S02SflClr       Ind Pos(23);         // Subfile Clear Ind
           S02SflEnd       Ind Pos(24);         // Subfile End Ind
           S02SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           R01DirectRi     Ind Pos(30);         // Directory Reverse Image Ind
           R01FBegRi       Ind Pos(31);         // File Begin Reverse Image Ind
           R01FEndRi       Ind Pos(32);         // File End Reverse Image Ind
           R01ContRi       Ind Pos(33);         // File Contains Reverse Image Ind
           R01TypeRi       Ind Pos(34);         // File Type Reverse Image Ind
           R01DaysRi       Ind Pos(35);         // Retention Days Reverse Image Ind
      *
           S01OptRi        Ind Pos(18);         // File Type Reverse Image Ind
           S01OPtPc        Ind Pos(19);         // Retention Days Reverse Image Ind
           S02OptRi        Ind Pos(26);         // File Type Reverse Image Ind
           S02OPtPc        Ind Pos(27);         // Retention Days Reverse Image Ind
           C02Direc        Ind Pos(28);         // Directory Reverse Image Ind
           C02DelRi        Ind Pos(44);         // Option Delete Reverse Image Ind
           C02DelNd        Ind Pos(45);         // Option Delete Non Display Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line : Process the screen until EXIT key pressed

        Begsr Main;

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Main Screen
              Dow ModReq = 'SCREEN1';
                 Exsr SN1M;
              Enddo;

      *?      // Process Add Screen
              Dow ModReq = 'SCREEN2';
                 Exsr SN2M;
              Enddo;

      *?      // Process Add Screen
              Dow ModReq = 'SCREEN3';
                 Exsr SN3M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;
           Return;

        Endsr;
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
      *?                : SN2M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN2M;

      *?   // Initialization
           If FunReq = 'INITIAL';
              Exsr SN2I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN2D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN2V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN2P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN3M;

      *?   // Initialization
           If FunReq = 'INITIAL';
              Exsr SN3I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN3D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN3V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN3P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen field values
      *?
        Begsr SN1I;

      *?   // Initialise Fields and indicators
           FlSflMod = False;
           FlError  = False;
           S01Rrn   = *Zeros;
           S01Opt   = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write RTNMANC01;

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
      *?Logic : Read the file and Build Subfile
      *?
        Begsr SN1B;

      *?   // Initialise Subfile fields and Indicator
           Dspf.S01OptPc = False;
           Dspf.S01OptRi = False;
           WkCount = *Zeros;
           S01Rrn  = *Zeros;
           WkFRrn  = S01Rrn;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A1 Cursor For
              Select Distinct DIRECTORY from Retention
              Order By DIRECTORY;

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;
           Exec Sql Fetch A1 into :WkDirect1;

      *?   // Load Subfile
           Dow SqlCod = 0 and WkCount < 9999;

      *?      // Increment RRN
              S01Rrn  += 1;
              WkCount += 1;
              If WkCount =  1;
                 WkFRrn = S01Rrn;
              Endif;
              S01DIRECT = %Trim(WkDirect1);
              Write RTNMANS01;

      *?      // Move Values
              Exec Sql Fetch A1 into :WkDirect1;
           Enddo;

      *?   // Check Sql Code and Set ON Subfile End Indicator
           If SqlCod <> *Zeros Or S01RRN = 0;
              Dspf.S01SflEnd = *On;
           Else;
              Dspf.S01SflEnd = *Off;
           Endif;

      *?   // Check RRN and Show Subfile
           If S01Rrn <> *Zeros;
              Dspf.S01SflDsp = True;
              S01Rrn = WkFRrn;
           Else;

      *?      // No Records Found
              PMsgId = 'WS00030';
              Exsr Sendmessage;
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
           Write RTNMANF01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt RTNMANC01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 Exsr Main;

      *?      // F5 Pressed
              When Dspf.Refresh;
                 ModReq = 'SCREEN1';
                 FunReq = 'RELOAD';
                 Exsr Main;

      *?      // F6 Pressed
              When Dspf.Add;
                 PDirect = '/Webservices';
                 PReturn = *Blanks;
                 WSRTNDIR01(PDirect:PReturn);
                 If PReturn <> *Blanks;
                    R01Direct = PReturn;
                    WkFlag = 'A';
                    ModReq = 'SCREEN3';
                    FunReq = 'INITIAL';
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
      *?Logic : Validate input capable Subfile Fields , Pressed
      *?      : If No errors then Process , else Display error in Screen Pressed
      *?
        Begsr SN1V;

      *?   // Initialise Fields and Indicators
           Dspf.S01OptRi = False;
           Dspf.S01OptPc = False;
           FlError = False;
           WkCount = *Zeros;

      *?   // Validate Entered values in Subfile
           If Dspf.S01SflDsp;
              ReadC RTNMANS01;
              Dow Not %Eof(WSRTNMANFM);
                 Dspf.S01OptRi = False;

      *?         // Validate Option
                 If S01Opt <> *Zeros And S01Opt <> 2;
                    FlError  = True;
                    FlSflMod = False;
                    Dspf.S01OptPc = True;
                    Dspf.S01OptRi = True;
                    PMsgId  = 'WS00028';
                    Exsr SendMessage;
                 Endif;
                 Dspf.S01SflNxtChg = True;
                 Update RTNMANS01;
                 Dspf.S01SflNxtChg = False;
                 ReadC RTNMANS01;
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
              ReadC RTNMANS01;
              Dow Not %Eof(WSRTNMANFM);
                 Select;

      *?            // Edit Link
                    When S01Opt = 2;
                       C02Direct = S01Direct;
                       ModReq = 'SCREEN2';
                       FunReq = 'INITIAL';
                       Exsr SN2M;
                 Endsl;
                 Dspf.S01SflNxtChg = True;
                 Update RTNMANS01;
                 Dspf.S01SflNxtChg = False;
                 ReadC RTNMANS01;
              Enddo;
           Endif;
           ModReq = 'SCREEN1';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN2I;

      *?   // Initialise Reverse Image indicator
           Dspf.S02OptRi = False;
           Dspf.C02Direc = False;
           FlCtlMod = False;
           FlSflMod = False;
           FlError  = False;
           S02Opt   = *Zeros;
           S02Rrn   = *Zeros;

      *?   // Clear Subfile
           Dspf.S02SflClr = True;              // Clear Ind ON
           Dspf.S02SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write RTNMANC02;

      *?   // Clear Subfile
           Dspf.S02SflClr    = False;          // Clear Ind OFF
           Dspf.S02SflDspCtl = True;           // Display Control Ind ON

      *?   // Build Subfile
           Exsr SN2B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Read the file and Build Subfile based on size
      *?
        Begsr SN2B;

      *?   // Initialise Subfile fields and Indicator
           Dspf.C02Direc = False;
           Dspf.S02OptRi = False;
           Dspf.S02OptPc = True;
           Dspf.C02DelNd = True;
           S02Opt  = *Zeros;
           S02Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A2 Cursor For
              Select * from Retention
              Where DIRECTORY = :C02Direct  Or :C02Direct = ' ';
              //DIRECTORY Like '%' Concat TRIM(:C02Direct) Concat'%'
              //                 or :C02Direct = ' ');

      *?   // Open Cursor
           Exec Sql Open A2;
           If SqlCode = -502 ;
              Exec Sql Close A2;
              Exec Sql Open A2;
           Endif;
           Exec Sql Fetch A2 into :SflRec :NullInd;

      *?   // Load Subfile
           Dow SqlCod = 0 and WkCount < 9999;

      *?      // Increment RRN
              S02Rrn  += 1;
              WkCount += 1;
              H02Seq   = SflRec.Seq;
              S02FILL1 = SflRec.FileBeg;
              S02FILL2 = SflRec.FileEnd;
              S02FILL3 = SflRec.FileCon;
              S02TYPE  = SflRec.FileType;
              S02RETEN = SflRec.RtnDays;
              WkDirect = C02Direct;
              Write RTNMANS02;

      *?      // Move Values
              Exec Sql Fetch A2 into :SflRec :NullInd;
           Enddo;

      *?   // Check Sql Code and Set ON Subfile End Indicator
           If SqlCod <> *Zeros Or S02RRN = 0;
              Dspf.S02SflEnd = *On;
           Else;
              Dspf.S02SflEnd = *Off;
           Endif;

      *?   // Check RRN and Show Subfile
           If S02Rrn <> *Zeros;
              Dspf.S02SflDsp = True;
           Else;

      *?      // No Records Found
              PMsgId = 'WS00030';
              Exsr Sendmessage;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN2D;

      *?   // Write the Footer
           Write RTNMANF02;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt RTNMANC02;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 Exsr Main;

      *?      // F6 Pressed
              When Dspf.Add;
                 ModReq = 'SCREEN3';
                 FunReq = 'INITIAL';
                 WkFlag = 'A';
                 Exsr SN3M;

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ModReq = 'SCREEN1';
                 FunReq = 'INITIAL';
                 Exsr Main;

      *?      // Other Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input capable Control and Subfile Fields , Pressed
      *?      : If No errors then Process , else Display error in Screen Pressed
      *?
        Begsr SN2V;

      *?   // Initialise Fields and Indicators
           Dspf.C02Direc = False;
           Dspf.S02OptRi = False;
           Dspf.S02OptPc = False;
           FlCtlMod = False;
           FlSflMod = False;
           FlError  = False;
           WkCount  = *Zeros;

      *?   // Validate Non Display Field
           If Dspf.C02DelNd = False;
              Exsr DeleteSr;
              FlCtlMod = True;
              If C02Del = 'Y';
                 PMsgId  = 'WS00075';
                 Exsr SendMessage;
              Endif;
              FlSflMod = False;
           Endif;

      *?   // Check Control Fields
           If WkDirect <> C02Direct and Dspf.C02DelNd = True;
              C02Direct= %ScanRpl('\' : '/' : C02Direct);
              WkDirect = C02Direct;
              FlCtlMod = True;
           Else;
              If Dspf.C02DelNd = True;
                 FlCtlMod = False;
              Endif;
              WkDirect = C02Direct;
           Endif;

      *?   // Validate Entered values in Subfile
           If FlCtlMod <> True and Dspf.C02DelNd = True;
              If Dspf.S02SflDsp;
                 ReadC RTNMANS02;
                 Dow Not %Eof(WSRTNMANFM);
                    Dspf.S02OptRi = False;

      *?            // Validate Option
                    If S02Opt <> *Zeros And S02Opt <> 2 And S02Opt <> 4;
                       FlError  = True;
                       FlSflMod  = False;
                       Dspf.S02OptPc = True;
                       Dspf.S02OptRi = True;
                       PMsgId  = 'WS00028';
                       Exsr SendMessage;
                    Else;
                       FlSflMod = True;
                    Endif;
                    Dspf.S02SflNxtChg = True;
                    Update RTNMANS02;
                    Dspf.S02SflNxtChg = False;
                    ReadC RTNMANS02;
                 Enddo;
              Endif;
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
      *?                : SN2P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN2P;

      *?   // Read Changed record and Process based on Option
           If Dspf.S02SflDsp;
              ReadC RTNMANS02;
              Dow Not %Eof(WSRTNMANFM);
                 Select;

      *?            // Edit Link
                    When S02Opt = 2;
                       R01Direct = C02Direct;
                       R01Seq  = H02Seq;
                       R01FBEG = S02FILL1;
                       R01FEND = S02FILL2;
                       R01CONT = S02FILL3;
                       R01TYPE = S02TYPE;
                       R01DAYS = S02RETEN;
                       FunReq = 'INITIAL';
                       WkFlag = 'U';
                       Exsr SN3M;

      *?            // Delete
                    When S02Opt = 4;
                       Dspf.C02DelNd = False;
                       Dspf.C02DelRi = True;
                       C02Del = 'Y';

                 Endsl;
                 Dspf.S02SflNxtChg = True;
                 Update RTNMANS02;
                 Dspf.S02SflNxtChg = False;
                 ReadC RTNMANS02;
              Enddo;

      *?      // Check Non Display Field
              If Dspf.C02DelNd = False;
                 FunReq = 'DISPLAY';
              Else;
                 FunReq = 'INITIAL';
                 FlSflMod = False;
              Endif;
              Exsr SN2M;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen parameters and field values
      *?
        Begsr SN3I;

      *?   // Initialise Indicators
           FlError = False;
           If WkFlag = 'U';
              Heading= 'Edit Retention Policy Record';
           Else;

      *?      // Clear Record Format
              If R01Direct = *Blanks;
                 Clear RTNMANR01;
              Else;
                 R01Direct= %ScanRpl('\' : '/' : R01Direct);
                 Clear R01FBEG;
                 Clear R01FEND;
                 Clear R01CONT;
                 Clear R01TYPE;
                 Clear R01DAYS;
              Endif;
              Heading= 'Add Retention Policy Record';
              Setgt *Hival Retention1;
              ReadP(N) Retention1;
              If Not %Eof;
                 R01Seq = SEQ + 1;
              Else;
                 R01Seq = 1;
              Endif;
           Endif;
           If R01Direct = *Blanks;
              R01Direct = C02Direct;
              R01Direct= %ScanRpl('\' : '/' : R01Direct);
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Display Record format based on function keys
      *?
        Begsr SN3D;

      *?   // Write the Subfile Control Part
           Exfmt RTNMANR01;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 Exsr Main;

      *?      // F4 Pressed
              When Dspf.Prompt;
                 PDirect = '/Webservices';
                 PReturn = *Blanks;
                 WSRTNDIR01(PDirect:PReturn);
                 If PReturn <> *Blanks;
                    R01Direct = PReturn;
                    FunReq = 'DISPLAY';
                 Endif;

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ModReq = 'SCREEN1';
                 FunReq = 'INITIAL';

      *?      // Other Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input capable Fields ,
      *?      : If No errors then Process , Else Display error in Screen Pressed
      *?
        Begsr SN3V;

      *?   // Initialise Fields and Indicators
           Dspf.R01DirectRi= False;
           Dspf.R01FBegRi  = False;
           Dspf.R01FEndRi  = False;
           Dspf.R01ContRi  = False;
           Dspf.R01TypeRi  = False;
           Dspf.R01DaysRi  = False;
           FlError = False;

      *?   // Validate Directory
           If R01Direct = *Blanks;
              FlError = True;
              Dspf.R01DirectRi = True;
              WkMsgID = 'WS00097';
              Exsr ErrMessage;
           Else;
              R01Direct= %ScanRpl('\' : '/' : R01Direct);
           Endif;

      *?   // Validate Filters
           If R01FBeg = *Blanks and R01FEnd = *Blanks and R01Cont = *Blanks
                       and FlError = False;
              FlError = True;
              Dspf.R01FBegRi = True;
              Dspf.R01FEndRi = True;
              Dspf.R01ContRi = True;
              WkMsgID = 'WS00098';
              Exsr ErrMessage;
           Endif;

      *?   // Validate File Type
           If R01Type = *Blanks and FlError = False;
              FlError = True;
              Dspf.R01TypeRi = True;
              WkMsgID = 'WS00099';
              Exsr ErrMessage;
           Else;
              If R01Type <> '*STMF' and R01Type <> '*DIR' and FlError = False;
                 FlError = True;
                 Dspf.R01TypeRi = True;
                 WkMsgID = 'WS00101';
                 Exsr ErrMessage;
              Endif;
           Endif;

      *?   // Validate Retention Days
           If R01Days = *Zeros and FlError = False;
              FlError = True;
              Dspf.R01DaysRi = True;
              WkMsgID = 'WS00100';
              Exsr ErrMessage;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
              Exsr SN3M;
           Else;
              FunReq = 'PROCESS';
              Exsr SN3P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN3P;

      *?   // Write/Update Record
           Exsr WriteUpdSr;
           C02Direct = R01Direct;
           ModReq = 'SCREEN2';
           FunReq = 'INITIAL';
           Exsr Main;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : WriteUpdSr Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Process the Write Or Update Subroutine
      *?
        Begsr WriteUpdSr;

      *?   // Check Record Exitance
           WkFld = R01Direct;
           Chain (R01Seq:WkFld) Retention1;
           If %Found;
              FILE_00001 = R01FBEG;
              FILE_00002 = R01FEND;
              FILE_00003 = R01CONT;
              FILE_TYPE  = R01TYPE;
              RETEN00001 = R01DAYS;
              Update RETENTIONR %Fields(FILE_00001:FILE_00002:
                        FILE_00003:FILE_TYPE:RETEN00001);
           Else;
              SEQ        = R01Seq;
              DIRECTORY  = R01Direct;
              FILE_00001 = R01FBEG;
              FILE_00002 = R01FEND;
              FILE_00003 = R01CONT;
              FILE_TYPE  = R01TYPE;
              RETEN00001 = R01DAYS;
              Write RETENTIONR;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : DeleteSr Subroutine :
      *?                :---------------------:
      *
      *?Logic : Process Delete Subroutine
      *?
        Begsr DeleteSr;

      *?   // Delete Retention File Details
           If C02Del = 'Y';
              WkFld = *Blanks;
              WkFld = C02Direct;
              Chain (H02Seq:WkFld) Retention1;
              If %Found;
                 Delete RetentionR;
              Endif;
              WkFld = *Blanks;
           Endif;
           ModReq = 'SCREEN2';
           FunReq = 'INITIAL';
           Exsr Main;

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
           C01Sys = Pgm;
           C01Pgm = Job;
           C02Sys = Pgm;
           C02Pgm = Job;

      *?   // Open Main Screen
           ModReq = 'SCREEN1';
           FunReq = 'INITIAL';
           Exsr Main;

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
           PMsgf  = 'WSMSGF';
           POpt   = 'C';
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
           PMsgf  = 'WSMSGF';
           POpt   = 'I';
           WSSFLMSG(PMsgf:PMsgId:POpt);

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
             WSRTVMSG(WkMsgID:WkMsgf:WKMSG:WkDta);
           On-Error;
           EndMon;
           ErrMsg = WkMsg;
           ModReq  = 'SCREEN3';
           FunReq  = 'DISPLAY';

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
