      *? Program        : WSRTNDIR01
      *?
      *? Description    : This Pgm to Show All Unique Directories in Retention File
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 10 Jul 2019
      //---------------------------------------------------------------------------------
      *? Special Notes  : Called from WSRTNMAN01
      *?
      *? Called Program : WSSFLMSG - WS - Send and clear message from subfile
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
      *?File: Display file for IFS Maintainance Screen Program
        Dcl-F WSRTNDIRFM Workstn Indds(Dspf) Sfile(RTNDIRS02:S02Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry Parameters
        Dcl-Pi WSRTNDIR01;
           PDirect Char(32);
           PReturn Char(75);
        End-Pi;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
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
        Dcl-S WkDirect2  Char(256)     Dim(10);
        Dcl-S WkArray    Char(256)     Dim(9999);
        Dcl-S WkDirect   Char(256)     Inz;
        Dcl-S WkDirect1  Char(256)     Inz;
        Dcl-S WkFile     Char(95)      Inz;
        Dcl-S WkMsgf     Char(10)      Inz;              // Used for Msg File
        Dcl-S WkMsgId    Char(7)       Inz;              // Used for Msg File
        Dcl-S WkMsg      Char(132)     Inz;              // Used for Msg File
        Dcl-S WkCount    Zoned(2:0)    Inz;
        Dcl-S WkCount1   Zoned(2:0)    Inz;
      *
      *?Flag Variable Declaration       :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlMulSel Ind Inz(*Off);
        Dcl-S FlReload Ind Inz(*Off);
      *
      *?Parameter Variable Declaration  :
        Dcl-S PMsgf  Char(10);
        Dcl-S PMsgId Char(7);
        Dcl-S POpt   Char(1);
      *
      *?CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;
        Dcl-S String   Char(500)    Inz;
        Dcl-S X        Zoned(5:0)   Inz;
      *
      *?Program Indicators Declaration  :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration  :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           S02SflDsp       Ind Pos(21);         // Subfile Display Ind
           S02SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S02SflClr       Ind Pos(23);         // Subfile Clear Ind
           S02SflEnd       Ind Pos(24);         // Subfile End Ind
           S02SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           S02OptRi        Ind Pos(26);         // File Type Reverse Image Ind
           S02OPtPc        Ind Pos(27);         // Retention Days Reverse Image Ind
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
              Dow ModReq = 'SCREEN';
                 Exsr SN1M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;

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
           If FunReq = 'INITIAL';
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
      *?Logic : Clear all screen field values
      *?
        Begsr SN1I;

      *?   // Initialise Fields and indicators
           S02Rrn  = *Zeros;
           S02Opt  = *Zeros;
           FlError = False;

      *?   // Clear Subfile
           Dspf.S02SflClr = True;              // Clear Ind ON
           Dspf.S02SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write RTNDIRC02;

      *?   // Clear Subfile
           Dspf.S02SflClr    = False;          // Clear Ind OFF
           Dspf.S02SflDspCtl = True;           // Display Control Ind ON

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
           Clear WkArray;
           S02Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Execute Sql to get Subfile Records
           WkFile = '(QGpl.IFSDIR(' + '''' + %Trim(WkDirect1) + ''''
                                  + ' ))';
           String = 'SELECT FILENAME                 ' +
                        ' FROM Table' + %Trim(WkFile)  +
                        ' Where Type = ''' + '*DIR' + ''' ';

           Exec Sql CLOSE A1;
           Exec Sql PREPARE S1 From :String;
           Exec Sql DECLARE A1 Cursor For S1;

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;
           Exec Sql Fetch A1 into :WkDirect;

      *?   // Load Array
           Dow SqlCod = 0 and WkCount < 9999;

      *?      // Increment WkCount
              WkCount += 1;
              WkArray(WkCount) = %Trim(WkDirect);
              Exec Sql Fetch A1 into :WkDirect;
           Enddo;

      *?   // Load Subfile
           SortA WkArray;
           For X = 1 to 9999;

      *?      // Increment RRN
              If WkArray(X) <> *Blanks;
                 S02Rrn += 1;
                 S02DIRECT= %Trim(WkArray(X));
                 Write RTNDIRS02;
              Endif;
           Endfor;

      *?   // Check Sql Code and Set ON Subfile End Indicator
           If S02RRN = 0;
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
      *?                : SN1D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN1D;

      *?   // Write the Footer
           Write RTNDIRF02;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt RTNDIRC02;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F12 Pressed
              When Dspf.Cancel;
                 If C02Direct = '/';
                    ModReq = 'EXIT';
                 Else;
                    If WkCount1 >= 1;
                       WkDirect1 = WkDirect2(WkCount1);
                       WkCount1  = WkCount1 - 1;
                       C02Direct = WkDirect1;
                       FunReq = 'INITIAL';
                    Endif;
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
      *?Logic : Validate Input Subfile Fields , Pressed
      *?      : If No errors then Process , else Display error in Screen Pressed
      *?
        Begsr SN1V;

      *?   // Initialise Fields and Indicators
           FlError = False;
           FlMulSel= False;
           WkCount = *Zeros;

      *?   // Validate Entered values in Subfile
           If Dspf.S02SflDsp;
              ReadC RTNDIRS02;
              Dow Not %Eof(WSRTNDIRFM);
                 Dspf.S02OptRi = False;

      *?         // Validate Option
                 If FlMulSel <> True;
                    If S02Opt <> *Zeros And S02Opt <> 1 and S02Opt <> 5;
                       Dspf.S02OptPc = True;
                       Dspf.S02OptRi = True;
                       PMsgId  = 'WS00028';
                       FlError = True;
                       Exsr SendMessage;
                    Else;
                       If S02Opt = 1 Or S02Opt = 5;
                          FlMulSel = True;
                       Endif;
                    Endif;
                 Elseif FlMulSel = True;
                    If S02Opt <> *Zeros;
                       FlError = True;
                       Dspf.S02OptRi = True;
                       PMsgId  = 'WS00036';
                       Exsr SendMessage;
                    Endif;
                 Endif;

                 Dspf.S02SflNxtChg = True;
                 Update RTNDIRS02;
                 Dspf.S02SflNxtChg = False;
                 ReadC RTNDIRS02;
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
           FlReload = False;
           If Dspf.S02SflDsp;
              ReadC RTNDIRS02;
              Dow Not %Eof(WSRTNDIRFM);
                 Select;

      *?            // Select
                    When S02Opt = 1;
                       If C02Direct <> '/';
                          PReturn = %Trim(C02Direct) + '/' + %Trim(S02Direct);
                       Elseif C02Direct = '/';
                          PReturn = %Trim(C02Direct) +  %Trim(S02Direct);
                       Endif;
                       ModReq = 'EXIT';

      *?            // Reload
                    When S02Opt = 5;
                       If C02Direct <> '/';
                          WkCount1 += 1;
                          WkDirect2(WkCount1) = %Trim(C02Direct);
                          WkDirect1= %Trim(C02Direct) + '/' + %Trim(S02Direct);
                       Elseif C02Direct = '/';
                          WkCount1 = 1;
                          Clear WkDirect;
                          WkDirect2(WkCount1) = %Trim(C02Direct);
                          WkDirect1= '/' +  %Trim(S02Direct);
                       Endif;
                       FlReload = True;
                 Endsl;
                 Dspf.S02SflNxtChg = True;
                 Update RTNDIRS02;
                 Dspf.S02SflNxtChg = False;
                 ReadC RTNDIRS02;
              Enddo;
           Endif;

      *?   // Reload Subfile
           If FlReload = True;
              C02Direct = %Trim(WkDirect1);
              ModReq = 'SCREEN';
              FunReq = 'INITIAL';
           Else;
              FunReq = 'DISPLAY';
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
           C02Sys = Pgm;
           C02Pgm = Job;
           PDirect= %ScanRpl('\' : '/' : PDirect);
           WkDirect1= PDirect;
           C02Direct= PDirect;
           WkCount1 = 0;
           Clear WkDirect2;
           WkCount1 += 1;
           WkDirect2(WkCount1) = '/';

      *?   // Open Main Screen
           ModReq = 'SCREEN';
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
      *?---------------- End Of Subroutines --------------------------------
