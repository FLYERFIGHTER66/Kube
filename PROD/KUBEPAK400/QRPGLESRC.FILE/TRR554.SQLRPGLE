      *? Program        : TRR554
      *?
      *? Description    : This pgm to Maintain Final Truck Schedule History
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 16 Oct 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** View of Truck Schedule History Records
      *?
      *? Called Program : WSSFLMSG - WS - Send and Clear message from subfile
      *?                : WSRTVMSG - WS - Retrieve message from Message file
      *?                : QCMDEXC  - Pgm To Call CL command in Rpg
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
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*usa);
        /COPY QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: M/F Customer Master File
      *?Key : Customer Number
        Dcl-F FMCUST     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Order Header Record
      *?Key : Order Number
        Dcl-F FHORDR     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for Maintain Final Truck Schedule History
        Dcl-F TRR554FM   Workstn Indds(Dspf) Sfile(TRKSFL:S02Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi TRR554;
        End-Pi;
      *
      *?Procedure Prototype Declaration : Check Date
        Dcl-Pr ChkDate  ExtPgm('@DT@A1');
           PMdy   Like(WkShpDt);
           PCymd  Like(WkShpDte);
           PErr   Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG  ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : To Call CL program to Retreive MSG
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
        Dcl-S ModReq    Char(10)  Inz;
        Dcl-S FunReq    Char(10)  Inz;
        Dcl-S Cmd       Char(200) Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkMsgf   Char(10)    Inz;                // Used for Msg File
        Dcl-S WkMsgId  Char(7)     Inz;                // Used for Msg File
        Dcl-S WkMsg    Char(132)   Inz;                // Used for Msg File
        Dcl-S WkDta    Char(10)    Inz;                // Used for Msg File
        Dcl-S WkCount  Packed(4)   Inz;
        Dcl-S WkShpDt  Packed(6)   Inz;
        Dcl-S WkShpDt1 Packed(6)   Inz;
        Dcl-S WkShpDte Packed(7)   Inz;
        Dcl-S WkQty1   Packed(7:1) Inz;
        Dcl-S WkQty2   Packed(7:1) Inz;
        Dcl-S WkQty3   Packed(7:1) Inz;
        Dcl-S WkQty4   Packed(7:1) Inz;
        Dcl-S WkQty5   Packed(7:1) Inz;
        Dcl-S WkQty6   Packed(7:1) Inz;
        Dcl-S WkFlag   Char(1)     Inz;
        Dcl-S WkTruck  Char(4)     Inz;
      *
      *?Flag Variables Declaration :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlCtl    Ind Inz(*Off);
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf      Char(10);              // For CL Program
        Dcl-S PMsgId     Char(7);
        Dcl-S POpt       Char(1);
        Dcl-S PErr       Char(1);
      *
      *?Display File Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Refresh         Ind Pos(5);          // Refresh Function Key
           Pageup          Ind Pos(6);          // Pageup Function Key
           Pagedown        Ind Pos(7);          // Pagedown Function Key
           PrevWeek        Ind Pos(8);          // Previous Function Key
           NextWeek        Ind Pos(9);          // Next Function Key
           NextTruck       Ind Pos(11);         // Next Truck Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           RShpDtRi        Ind Pos(18);         // Ship date Reverse Image Ind
           RTrkRi          Ind Pos(19);         // Truck Reverse Image Ind
      *
           S02SflDsp       Ind Pos(21);         // Subfile Display Ind
           S02SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S02SflClr       Ind Pos(23);         // Subfile Clear Ind
           S02SflEnd       Ind Pos(24);         // Subfile End Ind
           S02SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           C02TrkRi        Ind Pos(42);         // Truck Reverse Image Ind
           C02ShpDtRi      Ind Pos(43);         // Ship date Reverse Image Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :-------------:
      *?                : Copy Source :
      *?                :-------------:
      *
      *?Function Prototypes
    ? /COPY QFunctDefn,$_Dates
    ? /COPY QFunctDefn,$TimeStamp
    ? /COPY QFunctDefn,$User
    ? /COPY QFunctDefn,$NeedDir
    ? /COPY QFunctDefn,$Monday
    ? /COPY QFunctDefn,$isNote
    ? /COPY QFunctDefn,$Notes
    ? /COPY QFunctDefn,$DotW
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Screen
              Dow ModReq = 'SCREEN1';
                 Exsr SN1M;
              Enddo;

              Dow ModReq = 'SCREEN2';
                 Exsr SN2M;
              Enddo;

           Enddo;

      *?   // Close Cursor
           Exec Sql Close A1;

      *?   // End Program
           *InLr = *On;
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

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen Input Parameters
      *?
        Begsr SN1I;

      *?   // Initialise Reverse Image indicator
           Dspf.RTrkRi    = False;
           Dspf.RShpDtRi  = False;

      *?   // Clear Record Format
           Clear Main;
           SHPDAT = $MDYDate($AddDate($Date(0):1));
           WkShpDt = SHPDAT;
           DOTW = $DotW($DateMDY(SHPDAT));

      *?   // Move Values into Screen
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

      *?   // Write the Record format
           Exfmt Main;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F5 Pressed
              When Dspf.Refresh;
                 SHPDAT = $MDYDate($AddDate($Date(0):1));
                 FunReq = 'DISPLAY';

      *?      // F8 Pressed
              When Dspf.PrevWeek;
                 SHPDAT = $MDYDate($AddDate($DateMDY(SHPDAT):-7));
                 FunReq = 'DISPLAY';

      *?      // F9 Pressed
              When Dspf.NextWeek;
                 SHPDAT = $MDYDate($AddDate($DateMDY(SHPDAT):+7));
                 FunReq = 'DISPLAY';

      *?      // F11 Pressed
              When Dspf.NextTruck;
                 Exsr NextTruck;
                 FunReq = 'DISPLAY';

      *?      // Pageup Pressed
              When Dspf.Pageup;
                 SHPDAT = $MDYDate($AddDate($DateMDY(SHPDAT):-1));
                 FunReq = 'DISPLAY';

      *?      // Pagedown Pressed
              When Dspf.Pagedown;
                 SHPDAT = $MDYDate($AddDate($DateMDY(SHPDAT):+1));
                 FunReq = 'DISPLAY';

      *?      // Enter Pressed
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
           Clear ErrMsg;

      *?   // Initialise Reverse Image Indicator & Flag
           FlError = False;
           Dspf.RTrkRi   = False;
           Dspf.RShpDtRi = False;

      *?   // Validate ShipDate Field
           If SHPDAT = *Loval;
              FlError = True;
              Dspf.RShpDtRi = True;
              WkMsgID = 'WS00002';
              Exsr ErrMessage;
           Elseif SHPDAT <> *Loval;
              ChkDate(SHPDAT:WkShpDte:PErr);
              If PErr = 'Y';
                 FlError = True;
                 Dspf.RShpDtRi = True;
                 WkMsgID = 'WS00083';
                 Exsr ErrMessage;
              Else;
                 DOTW = $DotW($DateMDY(SHPDAT));
                 WkShpDt = SHPDAT;
              Endif;
           Endif;

      *?   // Validate Truck Field
           If Truck = *Blanks and FlError = False;
              FlError = True;
              Dspf.RTrkRi = True;
              WkMsgID = 'WS00084';
              Exsr ErrMessage;
           Endif;

      *?   // Process non error screen
           If FlError = True;
              ModReq = 'SCREEN1';
              FunReq = 'DISPLAY';
           Else;
              ModReq = 'SCREEN2';
              FunReq = 'INITIAL';
              WkFlag = 'Y';
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
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
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
           Dspf.C02TrkRi = False;
           FlCtl   = False;

      *?   // Clear Subfile
           Dspf.S02SflClr = True;                      // Clear Ind ON
           Dspf.S02SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write TRKCTL;

      *?   // Clear Rrn
           S02Rrn  = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S02SflClr    = False;                  // Clear Ind OFF
           Dspf.S02SflDspCtl = True;                   // Display Control Ind ON

      *?   // Check Control field
           If WkFlag = 'Y';
              C01TRK   = TRUCK;
              C01SHPDT = %Dec(%Char(%Date(SHPDAT:*MDY) :*CYMD0):7:0);
              WkTruck  = C01TRK;
              WkShpDte = C01SHPDT;
              DAYNM = $DotW($DateMDY(WkShpDt));
           Else;
              If C01ShpDt <> *Zeros;
                 WkShpDt1 = %Dec(%Char(%Date(C01ShpDt:*CYMD):*MDY0):6:0);
                 DAYNM = $DotW($DateMDY(WkShpDt1));
              Endif;
           Endif;

      *?   // Build Subfile
           Exsr SN2B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Control fields
      *?
        Begsr SN2B;

      *?   // Initialise Subfile fields and Indicator
           Dspf.C02TrkRi = False;
           S02Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Select Subfile Records
           Exec Sql Declare A1 Cursor For
              SELECT TRSEQ#, TRSTOP, TRORD#,
                     TRCUST,TRACTN,TRUSER,TRPROG,
                     TRWKST, TRTMST, TRQTY1, TRQTY2, TRQTY3,
                     TRQTY4, TRQTY5, TRQTY6
              From FTRSCHDHST
              Where(:C01Trk = ' ' Or :C01Trk = TRTRK#) and
                   (:C01ShpDT = 0 Or :C01ShpDt = TRSHDT)
              Order by TRTMST DESC;

      *?   // Open Cursor
           Exec Sql
              Open A1;
              If SqlCode = -502 ;
                 Exec Sql
                 Close A1;
                 Exec Sql
                 Open A1;
              Endif;

           Exec Sql Fetch A1 into :S01TRSEQ#, :S01TRSTOP, :S01TRORD#,
              :S01TRCUST, :S01TRACTN, :S01TRUSER, :S01TRPROG,
              :S01TRWKST, :S01TRTMST, :WkQTY1, :WkQTY2, :WkQTY3,
              :WkQTY4, :WkQTY5, :WkQTY6;

      *?   // Load Data into Subfile fields
           Dow SqlCod = 0 and WkCount < 9999;

      *?      // Move Values into Subfile fields
              Exsr LoadSflvalue;

      *?      // Increment RRN
              S02Rrn  += 1;
              WkCount += 1;

      *?      // Write Subfile Display Part
              Write TRKSFL;
              Exec Sql Fetch A1 into :S01TRSEQ#, :S01TRSTOP, :S01TRORD#,
                 :S01TRCUST, :S01TRACTN, :S01TRUSER, :S01TRPROG, :S01TRWKST,
                 :S01TRTMST, :WkQTY1, :WkQTY2, :WkQTY3, :WkQTY4, :WkQTY5,
                 :WkQTY6;
           Enddo;

      *?   // Subfile End Indicator ON
           Dspf.S02SflEnd = *On;

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
           Write TRKFTR;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt TRKCTL;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

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
      *?                : SN2V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input capable Control and Subfile Fields ,
      *?      : If No errors then Process , Else Display error in Screen
      *?
        Begsr SN2V;

      *?   // Initialise Fields and Indicators
           Dspf.C02TrkRi  = False;
           Dspf.C02ShpDtRi= False;
           WkCount  = *Zeros;

      *?   // Validate Control Screen Fields
           If WkTruck <> C01TRK Or WkShpDte <> C01SHPDT;
              FlCtl = True;
           Else;
              FlCtl = False;
           Endif;

      *?   // Check Flag and Execute
           If FlCtl = False;
              FunReq = 'DISPLAY';
           Else;
              WkFlag = 'N';
              FunReq = 'INITIAL';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialize Screen Inputs
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PGMQ = Pgm;

      *?   // Open Main Screen
           ModReq = 'SCREEN1';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : LoadSflvalue Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Load All values into Subfile Fields
      *?
        Begsr LoadSflvalue;

      *?   // From Truck Schedule History File
           S01QTY1 = WkQTY1;
           S01QTY2 = WkQTY2;
           S01QTY3 = WkQTY3;
           S01QTY4 = WkQTY4;
           S01QTY5 = WkQTY5;
           S01QTY6 = WkQTY6;

      *?   // From FMCUST File
           Chain S01TRCUST FMCUST;
           S01ADDR = %Trim(CMCITY) + ', ' + %Trim(CMSTST) + ' ' +
                            %Subst(CMZIP:1:5);
      *?   // From FHORDR File
           Chain S01TRORD# FHORDR;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : NextTruck Subroutine :
      *?                :----------------------:
      *
      *?Logic : Next Truck
      *?
        Begsr NextTruck;

      *?   // Get Next truck for this day
           Monitor;
              WkShpDte = $Date7($DateMDY(SHPDAT));
           On-Error;
              SHPDAT   = $MDYDate($Date(0));
              WkShpDte = $Date7($DateMDY(SHPDAT));
           EndMon;

           WkTruck = TRUCK;
           Exec SQL
              Select THTRK# Into :Truck From FTRHDRH
              Where THSHDT = :WkShpDte and THTRK# > :WkTruck
              Order by THTRK#;

           If Truck = WkTruck;
              Truck = *Blanks;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : ClearMessage Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Clear Message
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
      *?Logic : Send Message
      *?
        Begsr SendMessage;

      *?   // Show Message on Message Subfile Control Part
           PMsgf = 'WSMSGF';
           POpt  = 'I';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
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
             RtvErrMsg(WkMsgID:WkMsgf:WkMsg:WkDta);
           On-Error;
           EndMon;
           ErrMsg = WkMsg;
           ModReq = 'SCREEN1';
           FunReq = 'DISPLAY';

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
