      *? Program        : CUR400W1
      *?
      *? Description    : This pgm to Show Vendor and Qty for the Item & Date
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 21 Nov 2018
      *---------------------------------------------------------------------
      *? Special Notes  : Called from CUR400 and CUR450
      *?
      *? Called Program : WSSFLMSG  - WS - Send and Clear message from subfile
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
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Display file to Select Credit Card Screen
        Dcl-F CUR400WFM  Workstn Indds(Dspf) Sfile(CURWDWS01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi CUR400W1 ExtPgm;
           PItem   Char(12);
           PSupDte Date(*ISO);
        End-Pi;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
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
      *?Global Variable Declaration :
        Dcl-S ModReq Char(10)    Inz;
        Dcl-S FunReq Char(10)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCount  Zoned(2:0) Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf  Char(10);                  // For CL program
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
           S01Rrn  = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write CURWDWC01;

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

      *?   // Initialise fields
           WkCount = *Zeros;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A1 Cursor For
              Select VENDOR, SUPPLIER_QUANTITY_AVAILABLE  From WSSUPINVL1
              Where KUBE_PAK_ITEM = :PItem and AVAILABLE_DATE = :PSupDte
              Group by VENDOR, SUPPLIER_QUANTITY_AVAILABLE
              Order by VENDOR, SUPPLIER_QUANTITY_AVAILABLE;

      *?   // Check Cursor Open
           Exec Sql
              Open A1;
           If SqlCode = -502 ;
              Exec Sql
                 Close A1;
              Exec Sql
                 Open A1;
           EndIf;

      *?   // Fetch Record
           Exec Sql Fetch A1 Into :S01Vend,:S01Qty;
           Dow SqlCod = 0 And WkCount < 9999;

      *?      // Increment RRN
              S01Rrn  += 1;
              WkCount += 1;

      *?      // Write Subfile Display Part
              Write CURWDWS01;
              Exec Sql Fetch A1 Into :S01Vend,:S01Qty;
           Enddo;
           Exec Sql Close A1;

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

      *?   // Write the Window and Footer
           //Write ASSUME;
           Write CURWDWW01;
           Write CURWDWF01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt CURWDWC01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // Other Pressed
              Other;
                 FunReq = 'INITIAL';
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

      *?   // Move Control Fields
           C01Item  = PItem;
           C01SupDte= %Char(PSupDte:*MDY/);

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

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
