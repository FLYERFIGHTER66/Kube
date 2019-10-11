      *? Program        : WSB2BINQ01
      *?
      *? Description    : This Pgm to Show B2B Log File Inquiry
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 19 Jun 2019
      //---------------------------------------------------------------------------------
      *? Special Notes  : Called from WSPOINQ01
      *?
      *? Called Program : WSSFLMSG - WS - Send and clear message from subfile
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   06/25/19   S.Uthaya     Added Time Stamp Field in Subfile
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
        Dcl-F WSB2BINQFM Workstn Indds(Dspf) Sfile(B2BINQS01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration :  No Entry Parameters
        Dcl-Pi WSB2BINQ01;
           PVendPO Char(10);
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
        Dcl-S ModReq Char(10)  Inz;
        Dcl-S FunReq Char(10)  Inz;
      *
      *?Work Variable Declaration       :
        Dcl-S WkMsg      Char(132)   Inz;              // Used for Msg File
        Dcl-S WkMsg1     Char(100)   Inz;              // Used for Msg File
        Dcl-S WkFile     Char(95)    Inz;
        Dcl-S WkMsgf     Char(10)    Inz;              // Used for Msg File
        Dcl-S WkMsgId    Char(7)     Inz;              // Used for Msg File
        Dcl-S WkCount    Zoned(2:0)  Inz;
SUD01   Dcl-S WkTime     Zoned(6:0)  Inz;
  |     Dcl-S WkDate     Zoned(7:0)  Inz;
SUD01   Dcl-S WkTmSt     TimeStamp   Inz;

      *?CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;
      *
      *?Parameter Variable Declaration  :
        Dcl-S PMsgf  Char(10);
        Dcl-S PMsgId Char(7);
        Dcl-S POpt   Char(1);
      *
      *?Program Indicators Declaration  :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration  :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
      *
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
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
           S01Rrn  = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write B2BINQC01;

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
           S01Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A1 Cursor For
SUD01         Select OLMSG, OLCRTDAT , OLCRTTIM
              From WSORDLOGPF Where OLBRKORID = :PVendPO;

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;
SUD01      Exec Sql Fetch A1 into :WkMsg1 , :WkDate , :WkTime;

      *?   // Load Subfile
           Dow SqlCod = 0 and WkCount < 9999;

      *?      // Increment RRN
              S01Rrn  += 1;
              WkCount += 1;
SUD01         WkTmSt   =  %Timestamp((%Date(WkDate:*MDY)) +
  |                            (%Time(WkTime)));
SUD01         S01Time = %Char(WkTmSt);
              S01Msg  = %Trim(WkMsg1);
              Write B2BINQS01;

      *?      // Move Values
SUD01         Exec Sql Fetch A1 into :WkMsg1 , :WkDate , :WkTime;
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
           Write B2BINQF01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt B2BINQC01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // Other Pressed
              Other;
                 FunReq = 'DISPLAY';
           Endsl;

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
           C01VendPO = PVendPO;
           Exec Sql
              Select OLFRORID into :C01FRMORG from WSORDLOGPF
              Where OLBRKORID = :PVendPO;

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
