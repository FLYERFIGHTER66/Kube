      *? Program        : WSPLGORD03
      *?
      *? Description    : This pgm to show ordered quantity for the Order
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 23 Jul 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** View Ordered Item in Single Screen (Output Mode)
      *?                  ** F7 - To show previous 5 Weeks from the screen date
      *?                  ** F8 - To show next weeks from the screen date
      *?                  ** F10- To show summary of the ordered quantity
      *?
      *? Called Program : WSPLGORD04 - WS-Plug Entry Order Creation - Order Create Screen
      *?                : WSSFLMSG   - WS - Send and Clear message from subfile
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
        Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)
           DatFmt(*USA);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Plug Order Entry Work File
      *?Key : Customer : ReqDate : Item : Size
        Dcl-F WPLGORDL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Calendar File
      *?Key : Date
        Dcl-F FCALENWEEK Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for Plug Order Entry Program
        Dcl-F WSPLG003FM Workstn Indds(Dspf) Sfile(PLGSFL3:S03Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSPLGORD02)
        Dcl-Pi WSPLGORD03;
           PReqDte Packed(6);
           PCust#  Packed(6);
           PSts    Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : To Show Summary Screen
        Dcl-Pr WSPLGORD04 ExtPgm;
           PCust#  Packed(6);
           PSts    Char(2);
        End-Pr;
      *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG  ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
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
      *?Subfile Data Structure :
        Dcl-Ds SflRecS Qualified;
           Item    Char(5);
           Size    Char(3);
           Desc    Char(30);
           Alpha   Char(15);
           Price   Packed(6:2);
           ReqDte  Date(*ISO);
           Avlqty  Char(4);
           Ordqty  Packed(4);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S ModReq  Char(10) Inz;
        Dcl-S FunReq  Char(10) Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf   Char(10);
        Dcl-S PMsgId  Char(7);
        Dcl-S POpt    Char(1);
      *
      *?Work Variable Declaration :
        Dcl-S WkStDte  Date(*ISO) Inz;
        Dcl-S WkEndDt  Date(*ISO) Inz;
        Dcl-S WkRbDte  Date(*ISO) Inz;
        Dcl-S WkDate   Date(*ISO) Inz;
        Dcl-S WkDtYr   Date(*ISO) Inz;
        Dcl-S WkDteN   Zoned(7:0) Inz;
        Dcl-S WkDte    Zoned(8:0) Inz;
        Dcl-S WkRbDtN  Zoned(7:0) Inz;
        Dcl-S WkRbDt8  Zoned(8:0) Inz;
        Dcl-S WkDtYr8  Zoned(8:0) Inz;          // 52 Week Date CCYYMMDD
        Dcl-S WkDtYr7  Zoned(7:0) Inz;          // 52 Week Date CYYMMDD
        Dcl-S WkCount  Zoned(5:0) Inz;
        Dcl-S WkCount1 Zoned(5:0) Inz;
        Dcl-S WkItemS  Char(22)   Inz;
        Dcl-S WkSizeS  Char(3)    Inz;
        Dcl-S WkFlag   Char(1)    Inz;
        Dcl-S WkWrtFlg Char(1)    Inz;
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Backward        Ind Pos(7);          // Backward Function Key
           Forward         Ind Pos(8);          // Forward Function Key
           Summary         Ind Pos(10);         // Summary Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           S03SflDsp       Ind Pos(21);         // Subfile Display Ind
           S03SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S03SflClr       Ind Pos(23);         // Subfile Clear Ind
           S03SflEnd       Ind Pos(24);         // Subfile End Ind
           S03SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Screen
              Dow ModReq = 'SCREEN';
                 Exsr SN3M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = *On;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN3M;

      *?   // Initialization
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
              Exsr SN3I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN3D;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN3I;

      *?   // Clear Subfile
           Dspf.S03SflClr = True;                      // Clear Ind ON
           Dspf.S03SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write PLGCTL3;

      *?   // Clear Rrn;
           S03Rrn = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S03SflClr    = False;                  // Clear Ind OFF
           Dspf.S03SflDspCtl = True;                   // Display Control Ind ON

      *?   // Build the Subfile
           Exsr SN3B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Control fields
      *?
        Begsr SN3B;

      *?   // Initialise Rrn and Count
           Exsr ClearSflFields;
           S03Rrn  = *Zeros;
           WkCount = *Zeros;
           WkItemS = *Blanks;
           WkSizeS = *Blanks;
           WkWrtFlg = 'N';

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A2 Cursor for
           Select WPITEM, WPSIZE, WPDES1, WPLOOK, WPPRICE, WPDTE1, WPAQTY1,
                                     WPOQTY1
           From WPLGORDL0
           Where WPOQTY1 <> 0
           and  WPDTE1 >= :WkStDte and WPDTE1 <= :WkEndDt
           Order by WPITEM, WPSIZE;

      *?   // Open Cursor
           Exec Sql
              Open A2;
              If SqlCode = -502 ;
                 Exec Sql
                 Close A2;
                 Exec Sql
                 Open A2;
             EndIf;

      *?   // Load Subfile
           Exec Sql Fetch A2 into :SflRecS;
           Dow SqlCod = 0 and WkCount < 9999;

      *?      // Write Subfile Display Part
              If (WKItemS <> SflRecS.Item and WkItemS <> *Blanks) Or
                    (WKSizeS <> SflRecS.Size and WkSizeS <> *Blanks);

      *?        // Increment RRN
                S03Rrn  += 1;
                WkCount += 1;
                Write PLGSFL3;
                Exsr ClearSflFields;
                WkWrtFlg = 'N';
              Endif;

      *?      // Move Values
              WkItemS = SflRecS.Item;
              WkSizeS = SflRecS.Size;
              Exsr MoveValuesSR;
              Exec Sql Fetch A2 into :SflRecS;
           Enddo;

      *?   // Save Last Values and Set ON Subfile End Indicator
           If SqlCod = 0 Or (SqlCod = 100 and WkWrtFlg = 'Y');
              S03Rrn  += 1;
              Write PLGSFL3;
           Endif;
           Exec Sql Close A2;
           Dspf.S03SflEnd = *On;

      *?   // Check RRN and Show Subfile
           If S03Rrn <> *Zeros;
              Dspf.S03SflDsp = True;
           Else;

      *?      // No Records Found
              PMsgId = 'WS00030';
              Exsr Sendmessage;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN3D;

      *?   // Write the Footer
           Write PLGFTR3;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt PLGCTL3;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F7 Pressed
              When Dspf.Backward;
                 Exsr GetBackWeekSr;
                 Exsr SN3I;

      *?      // F8 Pressed
              When Dspf.Forward;
                 WkFlag = 'Y';
                 Exsr GetNextWeekSr;
                 Exsr SN3I;

      *?      // F10 Pressed
              When Dspf.Summary;
                 WSPLGORD04(PCust#:PSts);
                 If PSts = '12';
                    FunReq = 'INITIAL';
                    ModReq = 'SCREEN';
                 Else;
                    ModReq = 'EXIT';
                 Endif;

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ModReq = 'EXIT';
                 PSts = '12';

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
      *?Logic : Initialize Screen Inputs
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PGMQ = Pgm;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

      *?   // Get Ready_Bay_week and load data for 52 weeks
           Exec sql SET :WkRbDte = Ready_Bay_Week;
           WkRbDt8 =  %Int(%Char(WkRbDte:*ISO0));

      *?   // Add 1 year to Ready_Bay_Date
           WkDtYr  =  WkRbDte + %Days(365);
           WkDtYr8 =  %Int(%Char(WkDtYr:*ISO0));
           WkDtYr7 =  %Int(%Char(WkDtYr:*CYMD0));

      *?   // Get first date from file
           Setll *Loval WPLGORDL0;
           Read WPLGORDL0;
           If Not %Eof();
              WkEndDt = WPDte1;
           Endif;

      *?   // Write into Workfile
           WkWrtFlg = 'N';
           WkFlag = 'N';
           Exsr GetNextWeekSr;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : MoveValuesSr Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Move Values into Subfile Fields
      *?
        Begsr MoveValuesSr;

      *?   // From Workfile to Subfile Fields
           WkWrtFlg = 'Y';
           S03Item = SflRecS.Item;
           IMSIZE  = SflRecS.Size;
           IMDES1  = SflRecS.Desc;
           IMLOOK  = SflRecS.Alpha;
           S03Price= SflRecS.Price;

      *?   // Move Available Quantity
           WkDate = SflRecS.ReqDte;
           Select;
              When WkDate = C03Dte1;
                 S3AVQTY1 = SflRecS.AvlQty;
              When WkDate = C03Dte2;
                 S3AVQTY2 = SflRecS.AvlQty;
              When WkDate = C03Dte3;
                 S3AVQTY3 = SflRecS.AvlQty;
              When WkDate = C03Dte4;
                 S3AVQTY4 = SflRecS.AvlQty;
              When WkDate = C03Dte5;
                 S3AVQTY5 = SflRecS.AvlQty;
           Endsl;

      *?   // Move Ordered Quantity
           Select;
              When WkDate = C03Dte1;
                 S3ORQTY1 = SflRecS.OrdQty;
              When WkDate = C03Dte2;
                 S3ORQTY2 = SflRecS.OrdQty;
              When WkDate = C03Dte3;
                 S3ORQTY3 = SflRecS.OrdQty;
              When WkDate = C03Dte4;
                 S3ORQTY4 = SflRecS.OrdQty;
              When WkDate = C03Dte5;
                 S3ORQTY5 = SflRecS.OrdQty;
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : GetBackWeekSr Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Get Backward Five Dates from the Subfile Date

        Begsr GetBackWeekSr;

      *?  // Get Ready Bay Date
          Exsr ClearCtlFields;
          WkDteN  = *Zeros;
          WkRbDtN = *Zeros;
          WkRbDtN =  %Int(%Char(WkRbDte:*CYMD0));
          WkDteN  =  %Int(%Char(WkStDte:*CYMD0));

      *?  // Check Ready bay Date in Calender File
          WkCount = 1;
          Setll WkDteN FCALENWEEK;
          ReadP FCALENWEEK;
          Dow Not %Eof And WkCount < 5;
             If CLCYMD <= WkRbDtN;
                Leave;
             Endif;
             WkCount +=1;
             ReadP FCALENWEEK;
          Enddo;

      *?  // Get 5 dates based on Ready bay
          If WkCount < 5;
             Setll WkRbDtN  FCALENWEEK;
          Else;
             Setll CLCYMD FCALENWEEK;
          Endif;
          WkCount = 1;
          Read FCALENWEEK;
          Dow Not %Eof And WkCount <=5;
             Select;
                When WkCount= 1;
                   C03DTE1 = %Date(CLCYMD:*CYMD);
                   WkStDte = C03DTE1;
                   WkEndDt = C03DTE1;
                   C03WK1  = CLWEEK;
                When WkCount = 2;
                   C03DTE2 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE2;
                   C03WK2  = CLWEEK;
                When WkCount = 3;
                   C03DTE3 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE3;
                   C03WK3  = CLWEEK;
                When WkCount = 4;
                   C03DTE4 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE4;
                   C03WK4  = CLWEEK;
                When WkCount = 5;
                   C03DTE5 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE5;
                   C03WK5  = CLWEEK;
             EndSl;
             Read FCALENWEEK;
             WkCount +=1;
          Enddo;
          WkCount = *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : GetNextWeekSr Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Get Next Five Dates from the Subfile Date
      *?
        Begsr GetNextWeekSr;

      *?  // Get Next 5 Dates
          Exsr ClearCtlFields;
          WkDteN = *Zeros;
          WkDteN = %Int(%Char(WkEndDt:*CYMD0));

      *?  // Check 52 Week Date in Calender File
          WkCount = *Zeros;
          Setgt WkDteN FCALENWEEK;
          Read FCALENWEEK;
          Dow Not %Eof And WkCount <= 5;
             If CLCYMD > WkDtYr7;
                Leave;
             Endif;
             WkCount +=1;
             Read FCALENWEEK;
          Enddo;

      *?  // Get Start Date if End of 52th Week
          If WkCount < 5;
             WkCount1 = 1;
             Setgt WkDtYr7 FCALENWEEK;
             ReadP FCALENWEEK;
             Dow Not %Eof and WkCount1 <= 6;
                WkDteN = CLCYMD;
                WkCount1 += 1;
                ReadP FCALENWEEK;
             Enddo;
          Endif;

      *?  // Set Pointer in Calender File
          If WkFlag = 'Y';
             Setgt WkDteN FCALENWEEK;
          Else;
             Setll WkDteN FCALENWEEK;
          Endif;

      *?  // Get 5 Week Date in Calender File
          WkCount = 1;
          Read  FCALENWEEK;
          Dow Not %Eof and WkCount <=5 and WkDtYr7 >= CLCYMD;
             Select;
                When WkCount= 1;
                   C03DTE1 = %Date(CLCYMD:*CYMD);
                   WkStDte = C03DTE1;
                   WkEndDt = C03DTE1;
                   C03WK1  = CLWEEK;
                When WkCount = 2;
                   C03DTE2 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE2;
                   C03WK2  = CLWEEK;
                When WkCount = 3;
                   C03DTE3 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE3;
                   C03WK3  = CLWEEK;
                When WkCount = 4;
                   C03DTE4 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE4;
                   C03WK4  = CLWEEK;
                When WkCount = 5;
                   C03DTE5 = %Date(CLCYMD:*CYMD);
                   WkEndDt = C03DTE5;
                   C03WK5  = CLWEEK;
             EndSl;
             Read  FCALENWEEK;
             WkCount +=1;
          Enddo;
          WkCount = *Zeros;
          WkCount1 = *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : ClearSflFields Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Clear Subfile Record Every time
      *?
        Begsr ClearSflFields;

      *?   // Clear fields
           S3AVQTY1= *Blanks;
           S3AVQTY2= *Blanks;
           S3AVQTY3= *Blanks;
           S3AVQTY4= *Blanks;
           S3AVQTY5= *Blanks;
           S3ORQTY1= *Zeros;
           S3ORQTY2= *Zeros;
           S3ORQTY3= *Zeros;
           S3ORQTY4= *Zeros;
           S3ORQTY5= *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : ClearCtlFields Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Clear Control Record
      *?
        Begsr ClearCtlFields;

      *?   // Clear Subfile fields
           Clear C03DTE1;
           Clear C03DTE2;
           Clear C03DTE3;
           Clear C03DTE4;
           Clear C03DTE5;
           C03WK1 = *Zeros;
           C03WK2 = *Zeros;
           C03WK3 = *Zeros;
           C03WK4 = *Zeros;
           C03WK5 = *Zeros;

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
           PMsgf  = 'WSMSGF';
           POpt   = 'C';
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
           PMsgf  = 'WSMSGF';
           POpt   = 'I';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
