      *? Program        : WSPLGORD02
      *?
      *? Description    : This pgm to Create Plug Order Entry for the Customer
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 13 Jul 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** F7 - To show Previous 5 Weeks from the screen Start date
      *?                  ** F8 - To show Next 5 weeks from the screen End date
      *?                  ** F9 - To show Confirmed quantity for user reference
      *?                  ** F10- To show Summary of the ordered quantity
      *?
      *? Called Program : WSPLGORD03 - WS - Plug Entry Order Creation - Item View Screen
      *?                : WSPLGORD04 - WS - Plug Entry Order Creation - Order Create Screen
      *?                : WSSFLMSG   - WS - Send and Clear message from subfile
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   04/10/19   S.Uthaya     Added Ready Bay Week Indicator
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*USA) AlwNull(*UsrCtl);
        /COPY QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Plug Order Entry Work File
        Dcl-F WPLGORDPF Disk(*Ext) Usage(*Update:*Output);
      *?Key : Customer : ReqDate : Item : Size
        Dcl-F WPLGORDL0 Disk(*Ext) Keyed Usage(*Delete:*Output)
                                             Rename(WPLGORDR:Rec);
      *?File: Calendar File
      *?Key : Date
        Dcl-F FCALENWEEK Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for Plug Order Entry Program
        Dcl-F WSPLG002FM Workstn Indds(Dspf) Sfile(PLGSFL2:S02Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSPLGORD01)
        Dcl-Pi WSPLGORD02;
           PReqDte Packed(6);
           PCust#  Packed(6);
           PItem   Char(5);
           PSize   Char(3);
           PDesc   Char(30);
           PAlpha  Char(15);
           PSts    Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : To Show Ordered Qty in Screen
        Dcl-Pr WSPLGORD03 ExtPgm;
           PReqDte Packed(6);
           PCust#  Packed(6);
           PSts    Char(2);
        End-Pr;
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
      *?Workfile Data Structure :
        Dcl-Ds SflRec Qualified;
           Alpha   Char(15);
           Size    Char(3);
           Item    Char(5);
           Desc    Char(30);
           ReqDte  Date(*ISO);
           Avlqty  Packed(31:2);
           Ordqty  Packed(4);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S ModReq    Char(10)       Inz;
        Dcl-S FunReq    Char(10)       Inz;
        Dcl-S WkFRrn    Like(S02Rrn)   Inz;
        Dcl-S WkLRrn    Like(S02Rrn)   Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkStDte   Date(*ISO)    Inz;
        Dcl-S WkEndDt   Date(*ISO)    Inz;
        Dcl-S WkRbDte   Date(*ISO)    Inz;
        Dcl-S WkDtYr    Date(*ISO)    Inz;
        Dcl-S WkDate    Date(*ISO)    Inz;
        Dcl-S WkMondt   Date(*ISO)    Inz;
        Dcl-S WkMnDte   Date(*ISO)    Inz;                         // Manual Entry Date
        Dcl-S WKMon     Zoned(6:0)    Inz;
        Dcl-S WkDteN    Zoned(7:0)    Inz;
        Dcl-S WkRbDtN   Zoned(7:0)    Inz;
        Dcl-S WkCount   Zoned(5:0)    Inz;
        Dcl-S WkCount1  Zoned(5:0)    Inz;
        Dcl-S WkPQty    Packed(4)     Inz;
        Dcl-S WkItemS   Char(22)      Inz;
        Dcl-S WkItem    Char(22)      Inz;
        Dcl-S WkSize    Char(3)       Inz;
        Dcl-S WkSizeS   Char(3)       Inz;
        Dcl-S WkDesc    Char(30)      Inz;
        Dcl-S WkDescS   Char(30)      Inz;
        Dcl-S WkLookS   Char(15)      Inz;
        Dcl-S WkLook    Char(15)      Inz;
SUD01   Dcl-S WkRbDteC  Char(10)      Inz;
        Dcl-S WkSflQty  Packed(30)    Inz;
        Dcl-S WkSflQtyC Char(30)      Inz;
        Dcl-S WkMQty    Packed(31:2)  Inz;
        Dcl-S WkOQty    Packed(31:2)  Inz;
        Dcl-S WkPos     Zoned(1)      Inz;
        Dcl-S WkDtYr7   Zoned(7:0)    Inz;                         // 52 Week Date CYYMMDD
        Dcl-S WkFlag    Char(1)       Inz;
        Dcl-S WkFilter  Char(1)       Inz;
        Dcl-S WkAItem   Char(5)       Inz;
        Dcl-S WkASize   Char(3)       Inz;
        Dcl-S WkAQty    Packed(4)     Inz;
        Dcl-S WKADate   Zoned(6:0)    Inz;
        Dcl-S NullInd   Int(5) Dim(7) Inz(0);                      // Null Indicator for WkAlcQty
        Dcl-S NullValue Like(NullInd) Inz(-1);
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf     Char(10);
        Dcl-S PMsgId    Char(7);
        Dcl-S POpt      Char(1);
      *
      *?Flag Variables Declaration :
        Dcl-S FlCtlMod    Ind Inz(*Off);
        Dcl-S FlManual    Ind Inz(*Off);
        Dcl-S FlManualAdd Ind Inz(*Off);
        Dcl-S FlError     Ind Inz(*Off);
        Dcl-S FlAllow     Ind Inz(*Off);
        Dcl-S FlCtl       Ind Inz(*Off);
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Backward        Ind Pos(7);          // Backward Function Key
           Forward         Ind Pos(8);          // Forward Function Key
           Confirm         Ind Pos(9);          // Confirm Function Key
           Summary         Ind Pos(10);         // Summary Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
           Pagedown        Ind Pos(13);         // Pagedown Function Key
      *
           S02SflDsp       Ind Pos(21);         // Subfile Display Ind
           S02SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S02SflClr       Ind Pos(23);         // Subfile Clear Ind
           S02SflEnd       Ind Pos(24);         // Subfile End Ind
           S02SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           S02Qty1Ri       Ind Pos(31);         // Week 1 Ordered Quantity Ind
           S02Qty2Ri       Ind Pos(32);         // Week 2 Ordered Quantity Ind
           S02Qty3Ri       Ind Pos(33);         // Week 3 Ordered Quantity Ind
           S02Qty4Ri       Ind Pos(34);         // Week 4 Ordered Quantity Ind
           S02Qty5Ri       Ind Pos(35);         // Week 5 Ordered Quantity Ind
      *
           S02Part1        Ind Pos(50);         // Partial Indicator Ind
           S02Part2        Ind Pos(51);         // Partial Indicator Ind
           S02Part3        Ind Pos(52);         // Partial Indicator Ind
           S02Part4        Ind Pos(53);         // Partial Indicator Ind
           S02Part5        Ind Pos(54);         // Partial Indicator Ind
      *
           M02SizePc       Ind Pos(40);         // Manual Size Position Cursor Ind
           M02SizeRi       Ind Pos(41);         // Manual Size Reverse Image Ind
           M02ItemRi       Ind Pos(42);         // Manual Item Reverse Image Ind
           M02QtyRi        Ind Pos(43);         // Manual Quantity Reverse Image Ind
           M02DateRi       Ind Pos(44);         // Manual Date Reverse Image Ind
           M02ExistRi      Ind Pos(45);         // Manual Item Exist Reverse Image Ind
           M02ExistNd      Ind Pos(46);         // Manual Item Exist Non Display Ind
      *
           C02ItemPc       Ind Pos(47);         // Item Position Cursor Ind
      *
SUD01      C02RbInd        Ind Pos(60);         // Ready Bay Indicator
  |        C02RbInd1       Ind Pos(61);         // Ready Bay Indicator
  |        C02RbInd2       Ind Pos(62);         // Ready Bay Indicator
  |        C02RbInd3       Ind Pos(63);         // Ready Bay Indicator
  |        C02RbInd4       Ind Pos(64);         // Ready Bay Indicator
SUD01      C02RbInd5       Ind Pos(65);         // Ready Bay Indicator
        End-Ds;
      //--------------------------------------------------------------------
      *?                :--------------:
      *?                : Copy  Source :
      *?                :--------------:
      *
      *?Service Programs
    ? /COPY QFunctDefn,$UnitPrice
    ? /COPY QFunctDefn,$Monday
    ? /COPY QFunctDefn,$MDYDate
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
                 Exsr SN2M;
              Enddo;

           Enddo;

      *?   // Close Cursor
           Exec Sql Close A1;
           Exec Sql Close A2;

      *?   // End Program
           *InLr = *On;
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

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN2P;
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

      *?   // Close Cursor
           Exec Sql Close A1;

      *?   // Clear Subfile
           Dspf.S02SflClr = True;                      // Clear Ind ON
           Dspf.S02SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write PLGCTL2;

      *?   // Clear Rrn and Flag
           FlError = False;
           S02Rrn  = *Zeros;
           WkFRrn  = *Zeros;
           WkLRrn  = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S02SflClr    = False;                  // Clear Ind OFF
           Dspf.S02SflDspCtl = True;                   // Display Control Ind ON

      *?   // Build the Subfile
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

      *?   // Initialise Fields, Rrn and Count
           Exsr ClearSflFields;
           Exsr ClearQtyFields;
           Exsr SetIndicator;
           Dspf.M02SizePc = False;
           Dspf.C02ItemPc = True;
           Dspf.M02ExistNd= True;

      *?   // Execute Sql to get Subfile Records
           If Dspf.PageDown = False;
      *
              If Filter = 'N';
                 Exec Sql Declare A1 Cursor For
                 Select Item_Sort, Item_Size, Substring(Item_Number,1,5),
                      Item_Description, Ready_Date, Quantity_Available, WPOQTY1
                      From FSTDPLGINV Left Outer Join WPLGORDPF
                      On Item_Number = WPITEM and Item_Size = WPSIZE and
                      Ready_date = WPDTE1
                 Where
                  (Ready_Date >= :WkStDte and Ready_Date <= :WKEndDt)        and
                  Quantity_Available > 0  and View_Control_Type = 'Kube-Pak' and
                  (Substring(Item_Number,1,5)= :SMITEM or :SMITEM = ' ')     and
                  (Item_Size = :SMSIZE or :SMSIZE = ' ')                     and
                  (Item_Description like Trim(:WkDESC) or :WkDESC = ' ')     and
                  (Item_Sort like Trim(:WkLOOK) or :WkLOOK = ' ')
                 Order by Item_Sort, ITEM_SIZE, ITEM_Number,
                                       Item_description, Ready_Date;
      *?         // Open Cursor
                 Exec Sql
                    Open A1;
                    If SqlCode = -502 ;
                       Exec Sql
                       Close A1;
                       Exec Sql
                       Open A1;
                    Endif;
                 Exec Sql Fetch A1 into :SflRec :NullInd;

              Elseif Filter = 'Y';
                 Exec Sql Declare A2 Cursor For
                 Select Item_Sort, Item_Size, Substring(Item_Number,1,5),
                      Item_Description, Ready_Date, Quantity_Available, WPOQTY1
                      From FSTDPLGINV Left Outer Join WPLGORDPF
                      On Item_Number = WPITEM and Item_Size = WPSIZE and
                      Ready_date = WPDTE1
                 Where
                  (Ready_Date >= :WkStDte and Ready_Date <= :WKEndDt)        and
                  Quantity_Available > 0  and View_Control_Type = 'Kube-Pak' and
                  (Substring(Item_Number,1,5)= :SMITEM or :SMITEM = ' ')     and
                  (Item_Size = :SMSIZE or :SMSIZE = ' ')                     and
                  (Item_Description like Trim(:WkDESC) or :WkDESC = ' ')     and
                  (Item_Sort like Trim(:WkLOOK) or :WkLOOK = ' ')            and
                  WPOQTY1 > 0
                 Order by Item_Sort, ITEM_SIZE, ITEM_Number,
                                       Item_description, Ready_Date;

      *?         // Open Cursor
                 Exec Sql
                    Open A2;
                    If SqlCode = -502 ;
                       Exec Sql
                       Close A2;
                       Exec Sql
                       Open A2;
                    Endif;
                 Exec Sql Fetch A2 into :SflRec :NullInd;
              Endif;
           Endif;

      *?   // For Pagedown
           If Dspf.PageDown = True;
              WkItem = SflRec.Item;
              WkSize = SflRec.Size;
              Exsr MoveValuesSR;
              If Filter = 'N';
                 Exec Sql Fetch A1 into :SflRec :NullInd;
              Elseif Filter = 'Y';
                 Exec Sql Fetch A2 into :SflRec :NullInd;
              Endif;
              If SqlCod = 0;
                 S02Rrn = WkLRrn;
              Endif;
           Endif;

      *?   // Load Subfile
           Dow SqlCod = 0 and WkCount < 18;

      *?      // Write Subfile Display Part
              If (WkItem <> SflRec.Item and WkItem <> *Blanks) Or
                    (WkSize <> SflRec.Size and WkSize <> *Blanks);

      *?         // Increment RRN
                 S02Rrn  += 1;
                 WkCount += 1;
                 If WkCount = 1;
                    WkFRrn = S02Rrn;
                 Endif;
                 WkLRrn = S02Rrn;
                 Write PLGSFL2;
                 Exsr ClearQtyFields;
              Endif;

      *?      // Move Values
              WkItem = SflRec.Item;
              WkSize = SflRec.Size;
              Exsr MoveValuesSR;
              If WkCount <= 17;
                 If Filter = 'N';
                    Exec Sql Fetch A1 into :SflRec :NullInd;
                 Elseif Filter = 'Y';
                    Exec Sql Fetch A2 into :SflRec :NullInd;
                 Endif;
              Endif;
           Enddo;

      *?   // If RRN is equal to Zero and S02Item not equal to Zero
           If S02Item <> *Blanks and WkCount < 18;
              S02Rrn += 1;
              WkCount += 1;
              If WkCount = 1;
                 WkFRrn = S02Rrn;
              Endif;
              WkLRrn = S02Rrn;
              Write PLGSFL2;
              Exsr ClearQtyFields;
           Endif;

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
              H01FRRN = S02RRN;
              PMsgId = 'WS00030';
              Exsr Sendmessage;
           Endif;

      *?   // Display Next Set Records
           If Dspf.PageDown = True;
              FunReq = 'DISPLAY';
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

      *?   // Position to the First RRN
           If WkFRrn <> *Zeros;
              S02Rrn = WkFRrn;
           Else;

      *?      // Position to the current page
              If H01FRrn <> *Zeros;
                 S02Rrn = H01FRrn;
              Endif;
           Endif;

      *?   // Write the Footer
           Write PLGFTR2;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt PLGCTL2;
           WkFRrn = *Zeros;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 PSts = '03';

      *?      // F7 Pressed
              When Dspf.Backward;
                 FlCtl  = True;
                 FunReq = 'VALIDATE';

      *?      // F8 Pressed
              When Dspf.Forward;
                 FlCtl  = True;
                 FunReq = 'VALIDATE';

      *?      // F9 Pressed
              When Dspf.Confirm;
                 FlCtl  = True;
                 FunReq = 'VALIDATE';

      *?      // F10 Pressed
              When Dspf.Summary;
                 FlCtl  = True;
                 FunReq = 'VALIDATE';

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ModReq = 'EXIT';
                 PSts = '12';

      *?      // Pagedown Pressed
              When Dspf.PageDown;
                 If Dspf.S02SflEnd = False;
                    FunReq = 'VALIDATE';
                 Else;
                    FunReq = 'DISPLAY';
                    WkFRrn = S02Rrn;
                 Endif;

      *?      // Other Pressed
              Other;
                 Dspf.Pagedown = False;
                 FunReq = 'VALIDATE';
                 FlCtl  = False;
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate Input capable Manual ,Control and Subfile Fields ,
      *?      : If No errors then Process , Else Display error in Screen
      *?
        Begsr SN2V;

      *?   // Initialise Flags
           FlManualAdd = False;
           FlCtlMod = False;
           FlManual = False;
           FlError  = False;

      *?   // Validate Entered values in Subfile Display Part
           If Dspf.S02SflDsp;
              ReadC PLGSFL2;

      *?      // Validate Subfile part
              Dow Not %Eof;
                 Exsr ValidateSfl;
                 Dspf.S02SflNxtChg = True;
                 Update PLGSFL2;
                 Dspf.S02SflNxtChg = False;
                 ReadC PLGSFL2;
              Enddo;

      *?      // On No Error Update Subfile Date into Plug Order File
              If FlError = False;
                 Exsr WriteDataToFile;
              Endif;

           Endif;

      *?   // Validate Manual Entry Fields
           If FlError = False;
              Exsr ValidateManual;
           Endif;

      *?   // Validate Control Screen Fields
           If FlError = False and FlManual = False and FlManualAdd = False;
              If (SMITEM <> WkItemS Or SMSIZE <> WkSizeS Or SMDES1 <> WkDescS
                 Or SMLOOK <> WkLookS);
                 Exsr ValidateCtl;
              Endif;
           Elseif FlError = False and (FlManual = True Or FlManualAdd = True);
              If (SMITEM <> WkItemS Or SMSIZE <> WkSizeS Or SMDES1 <> WkDescS
                 Or SMLOOK <> WkLookS);
                 FlError = True;
                 PMsgId  = 'WS00071';
                 Exsr SendMessage;
              Endif;

              If FlManualAdd = True;
                 SMITEM = *Blanks;
                 SMSIZE = *Blanks;
                 SMDES1 = *Blanks;
                 SMLOOK = *Blanks;
                 WkItemS = SMITEM;
                 WkSizeS = SMSIZE;
                 WkDescS = SMDES1;
                 WkLookS = SMLOOK;
                 WkItem  = SMITEM;
                 WkSize  = SMSIZE;
              Endif;
           Endif;

      *?   // Build Subfile based on Filter
           If WkFilter <> Filter and FlError = False;
              FlCtlMod = True;
              WkFilter = Filter;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
           Elseif FlCtlMod Or FlManualAdd = True;
              FunReq = 'INITIAL';
           Elseif Dspf.Pagedown;
              FunReq = 'PROCESS';
              If FlCtl = True;
                 WkItemS = SMITEM;
                 WkSizeS = SMSIZE;
                 WkItem  = SMITEM;
                 WkSize  = SMSIZE;
                 WkDescS = SMDES1;
                 WkLookS = SMLOOK;
                 If SMITEM <> *Blanks Or SMSIZE <> *Blanks Or SMDES1 <> *Blanks
                         Or SMLOOK <> *Blanks;
                   Exsr ConcatString;
                 Else;
                    WkDesc = *Blanks;
                    WkLook = *Blanks;
                 Endif;
              Endif;
           Elseif FlCtlMod = False and Dspf.Pagedown = False and FlCtl = True;
              WkItemS = SMITEM;
              WkSizeS = SMSIZE;
              WkItem  = SMITEM;
              WkSize  = SMSIZE;
              WkDescS = SMDES1;
              WkLookS = SMLOOK;
              If SMITEM <> *Blanks Or SMSIZE <> *Blanks Or SMDES1 <> *Blanks
                      Or SMLOOK <> *Blanks;
                Exsr ConcatString;
              Else;
                 WkDesc = *Blanks;
                 WkLook = *Blanks;
              Endif;
              FunReq = 'PROCESS';
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

      *?   // Process based on Function Key
           If Dspf.Confirm = *On;                   // On F9 Function Key
              Exsr WorkFileCheck;                   // Check Record Count
              If FlAllow = True;
                 WSPLGORD03(PReqDte:PCust#:PSts);
                 If PSts = '12';
                    FunReq = 'INITIAL';
                    ModReq = 'SCREEN';
                 Else;
                    ModReq = 'EXIT';
                 Endif;
              Else;
                 PMsgId  = 'WS00079';
                 Exsr SendMessage;
                 FunReq = 'INITIAL';
              Endif;
           Elseif Dspf.Summary = True;              // On F10 Function Key
              Exsr WorkFileCheck;                   // Check Record Count
              If FlAllow = True;
                 WSPLGORD04(PCust#:PSts);
                 If PSts = '12';
                    FunReq = 'INITIAL';
                    ModReq = 'SCREEN';
                 Else;
                    ModReq = 'EXIT';
                 Endif;
              Else;
                 PMsgId  = 'WS00079';
                 Exsr SendMessage;
                 FunReq = 'INITIAL';
              Endif;
           Elseif Dspf.Backward = True;             // On F7 Function Key
              If WkStDte = WkRbDte;
                 PMsgId  = 'WS00080';
                 Exsr SendMessage;
                 FunReq = 'DISPLAY';
              Else;
                 Exsr GetBackWeekSr;
                 Exsr SN2I;
              Endif;
           Elseif Dspf.Forward = True;              // On F8 Function Key
              If WkEndDt = WkMonDt;
                 PMsgId  = 'WS00081';
                 Exsr SendMessage;
                 FunReq = 'DISPLAY';
              Else;
                 WkFlag = 'Y';
                 Exsr GetNextWeekSr;
                 Exsr SN2I;
              Endif;
           Elseif Dspf.PageDown = True;             // On Pagedown
              Exsr SN2B;
           Else;                                    // On Enter
              FunReq = 'DISPLAY';
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
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

      *?   // Get Requested Ship Date
           WkEndDt = %Date(PReqDte:*MDY);
           SMITEM = PItem;
           SMSIZE = PSize;
           SMDES1 = PDesc;
           SMLOOK = PAlpha;
           WkItemS = SMITEM;
           WkSizeS = SMSIZE;
           WkDescS = SMDES1;
           WkLookS = SMLOOK;
           Filter = 'N';
           WkFilter = Filter;
           Exsr ConcatString;

      *?   // Write into Workfile
           Exsr Next52Weeks;
           WkFlag = 'N';
           Exsr GetNextWeekSr;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : Next52Weeks Subroutine :
      *?                :------------------------:
      *
      *?Logic : Calculate next 52 weeks date from ready bay date for future reference
      *?
        Begsr Next52Weeks;

      *?   // Get Ready_Bay_week
           Exec Sql SET :WkRbDte = Ready_Bay_Week;
SUD01      WKRbDteC = %Char(WkRbDte:*USA/);

      *?   // Add 1 year to Ready_Bay_Date
           WkDtYr  = WkRbDte + %Days(365);
           WkDtYr7 = %Int(%Char(WkDtYr:*CYMD0));
           WkMon   = $MDYDate($Monday(WkDtYr:'FRI'));           // Monday MDY
           WkMonDt = %Date(WkMon:*MDY);

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : ClearCtlFields Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Clear Control Record
      *?
        Begsr ClearCtlFields;

      *?   // Clear Subfile fields and Indicator
           Clear C02DTE1;
           Clear C02DTE2;
           Clear C02DTE3;
           Clear C02DTE4;
           Clear C02DTE5;
           C02WK1 = *Zeros;
           C02WK2 = *Zeros;
           C02WK3 = *Zeros;
           C02WK4 = *Zeros;
           C02WK5 = *Zeros;
SUD01      Dspf.C02RbInd  = False;
  |        Dspf.C02RbInd1 = False;
  |        Dspf.C02RbInd2 = False;
  |        Dspf.C02RbInd3 = False;
  |        Dspf.C02RbInd4 = False;
SUD01      Dspf.C02RbInd5 = False;

      *?   // Clear Manual Entry Fields
           ADDITEM = *Blanks;
           ADDDESC = *Blanks;
           ADDQTY  = *Zeros;
           ADDEXIST= *Zeros;
           Dspf.M02ExistNd = True;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : ClearSflFields Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Clear Subfile Fields
      *?
        Begsr ClearSflFields;

      *?   // Clear Subfile Fields
           S02Item = *Blanks;
           S02Size = *Blanks;
           S02Des1 = *Blanks;
           S02Look = *Blanks;
           S02Price= *Zeros;
           WkItem  = *Blanks;
           WkSize  = *Blanks;
           WkCount = *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : ClearQtyFields Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Clear Subfile Quantity fields Every time
      *?
        Begsr ClearQtyFields;

      *?   // Clear Subfile Quantity fields
           S2AVQTY1 = *Blanks;
           S2AVQTY2 = *Blanks;
           S2AVQTY3 = *Blanks;
           S2AVQTY4 = *Blanks;
           S2AVQTY5 = *Blanks;
           S2ORQTY1 = *Zeros;
           S2ORQTY2 = *Zeros;
           S2ORQTY3 = *Zeros;
           S2ORQTY4 = *Zeros;
           S2ORQTY5 = *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : SetIndicator Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Set Indicators in Subfile Display Part
      *?
        Begsr SetIndicator;

      *?   // Initilize Subfile Indicators
           Dspf.S02Qty1Ri = False;
           Dspf.S02Qty2Ri = False;
           Dspf.S02Qty3Ri = False;
           Dspf.S02Qty4Ri = False;
           Dspf.S02Qty5Ri = False;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : ValidateSfl Subroutine :
      *?                :------------------------:
      *
      *?Logic : Set Indicators in Subfile Display Part
      *?
        Begsr ValidateSfl;

      *?   // Initialize Subfile Indicators
           Exsr SetIndicator;

      *?   // Check Available and Ordered Quantity
           If S2AVQTY1 = *Blanks;
              If S2ORQTY1 <> *Zeros;
                 FlError = True;
                 Dspf.S02Qty1Ri = True;
                 PMsgId  = 'WS00026';
                 Exsr SendMessage;
              Endif;
           Elseif S2AVQTY1 <> *Blanks;
              Wkpos = %Scan('%' :S2AVQTY1:1);
              If WkPos = *Zeros;
                 WkPQty = %Int(S2AVQTY1);
                 If S2ORQTY1 > WkPQty;
                    FlError = True;
                    Dspf.S02Qty1Ri = True;
                    PMsgId  = 'WS00072';
                    Exsr SendMessage;
                 Endif;
              Else;
                 If S2ORQTY1 <> 1 And S2ORQTY1 <> 0;
                    FlError = True;
                    Dspf.S02Qty1Ri = True;
                    PMsgId  = 'WS00082';
                    Exsr SendMessage;
                 Endif;
              Endif;
              WkPos = *Zeros;
           Endif;

           If S2AVQTY2 = *Blanks;
              If S2ORQTY2 <> *Zeros;
                 FlError = True;
                 Dspf.S02Qty2Ri = True;
                 PMsgId  = 'WS00026';
                 Exsr SendMessage;
              Endif;
           Elseif S2AVQTY2 <> *Blanks;
              Wkpos = %Scan('%' :S2AVQTY2:1);
              If WkPos = *Zeros;
                 WkPQty = %Int(S2AVQTY2);
                 If S2ORQTY2 > WkPQty;
                    FlError = True;
                    Dspf.S02Qty2Ri = True;
                    PMsgId  = 'WS00072';
                    Exsr SendMessage;
                 Endif;
              Else;
                 If S2ORQTY2 <> 1 And S2ORQTY2 <> 0;
                    FlError = True;
                    Dspf.S02Qty2Ri = True;
                    PMsgId  = 'WS00082';
                    Exsr SendMessage;
                 Endif;
              Endif;
              WkPos = *Zeros;
           Endif;

           If S2AVQTY3 = *Blanks;
              If S2ORQTY3 <> *Zeros;
                 FlError = True;
                 Dspf.S02Qty3Ri = True;
                 PMsgId  = 'WS00026';
                 Exsr SendMessage;
              Endif;
           Elseif S2AVQTY3 <> *Blanks;
              Wkpos = %Scan('%' :S2AVQTY3:1);
              If WkPos = *Zeros;
                 WkPQty = %Int(S2AVQTY3);
                 If S2ORQTY3 > WkPQty;
                    FlError = True;
                    Dspf.S02Qty3Ri = True;
                    PMsgId  = 'WS00072';
                    Exsr SendMessage;
                 Endif;
              Else;
                 If S2ORQTY3 <> 1 And S2ORQTY3 <> 0;
                    FlError = True;
                    Dspf.S02Qty3Ri = True;
                    PMsgId  = 'WS00082';
                    Exsr SendMessage;
                 Endif;
              Endif;
              WkPos = *Zeros;
           Endif;

           If S2AVQTY4 = *Blanks;
              If S2ORQTY4 <> *Zeros;
                 FlError = True;
                 Dspf.S02Qty4Ri = True;
                 PMsgId  = 'WS00026';
                 Exsr SendMessage;
              Endif;
           Elseif S2AVQTY4 <> *Blanks;
              Wkpos = %Scan('%' :S2AVQTY4:1);
              If WkPos = *Zeros;
                 WkPQty = %Int(S2AVQTY4);
                 If S2ORQTY4 > WkPQty;
                    FlError = True;
                    Dspf.S02Qty4Ri = True;
                    PMsgId  = 'WS00072';
                    Exsr SendMessage;
                 Endif;
              Else;
                 If S2ORQTY4 <> 1 And S2ORQTY4 <> 0;
                    FlError = True;
                    Dspf.S02Qty4Ri = True;
                    PMsgId  = 'WS00082';
                    Exsr SendMessage;
                 Endif;
              Endif;
              WkPos = *Zeros;
           Endif;

           If S2AVQTY5 = *Blanks;
              If S2ORQTY5 <> *Zeros;
                 FlError = True;
                 Dspf.S02Qty5Ri = True;
                 PMsgId  = 'WS00026';
                 Exsr SendMessage;
              Endif;
           Elseif S2AVQTY5 <> *Blanks;
              Wkpos = %Scan('%' :S2AVQTY5:1);
              If WkPos = *Zeros;
                 WkPQty = %Int(S2AVQTY5);
                 If S2ORQTY5 > WkPQty;
                    FlError = True;
                    Dspf.S02Qty5Ri = True;
                    PMsgId  = 'WS00072';
                    Exsr SendMessage;
                 Endif;
              Else;
                 If S2ORQTY5 <> 1 And S2ORQTY5 <> 0;
                    FlError = True;
                    Dspf.S02Qty5Ri = True;
                    PMsgId  = 'WS00082';
                    Exsr SendMessage;
                 Endif;
              Endif;
              WkPos = *Zeros;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : ValidateManual Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Validate Control Screen Manual Entry fields in Subfile
      *?
        Begsr ValidateManual;

      *?   // Initilize Subfile Indicators
           Dspf.M02SizePc = False;
           Dspf.M02ItemRi = False;
           Dspf.M02SizeRi = False;
           Dspf.M02QtyRi  = False;
           Dspf.M02DateRi = False;
           Dspf.M02ExistRi= False;

      *?   // Check Manual Entry field values and Function Key
           If (ADDITEM <> *Blanks And ADDSIZE <> *Blanks And ADDQTY <> *Zeros
              and ADDDATE <> *Zeros);
              If (ADDITEM <> WkAItem Or ADDSIZE <> WkASize Or ADDQTY <> WkAQty
                 Or ADDDATE <> WkADate);
                 FlManual = True;
                 FlManualAdd = False;
              Else;
                 FlManualAdd = True;
                 FlManual = False;
              Endif;
              Dspf.M02SizePc = True;

      *?      // Get *ISO format Date
              If ADDDATE <> *Zeros;
                 WkMnDte = %Date(ADDDATE :*MDY);
              Else;
                 WkMnDte = WkRbDte;
              Endif;

              If FlManual = True;

      *?         // Check in Inventory File and Validate
                 Exec Sql
                    Select Item_Description, Quantity_Available into :ADDDESC,
                       :WkMQty From FSTDPLGINV Left Outer Join WPLGORDPF
                       On Item_Number = WPITEM and Item_Size = WPSIZE and
                       Ready_date = WPDTE1
                    Where
                       (Ready_Date = :WkMnDte) and Quantity_Available > 0  and
                       View_Control_Type = 'Kube-Pak'                      and
                       (Substring(Item_Number,1,5)= :ADDITEM)              and
                       (Item_Size = :ADDSIZE);

                 If SqlCod = 0;
                    If WkMQty < ADDQTY;
                       FlError = True;
                       Dspf.M02QtyRi = True;
                       PMsgId  = 'WS00072';
                       Exsr SendMessage;
                    Else;

      *?               // Check in Temp File
                       Chain (PCust#:WkMnDte:ADDItem:ADDSize) WPLGORDL0;
                       If %Found;
                          ADDEXIST = WPOQTY1;
                          Dspf.M02ExistRi= True;
                          Dspf.M02ExistNd= False;
                       Endif;
                    Endif;
                 Else;
                    FlError = True;
                    Dspf.M02QtyRi = True;
                    PMsgId  = 'WS00026';
                    Exsr SendMessage;
                 Endif;
              Endif;

           Elseif (ADDITEM = *Blanks and ADDSIZE = *Blanks and ADDQTY = *Zeros
                 and ADDDATE = *Zeros);
              FlManual = False;
              Dspf.M02ExistNd = True;
              AddExist = *Zeros;
              AddDesc  = *Blanks;

      *?   // Check all fields
           Else;
              If ADDSIZE <> *Blanks and ADDDATE = *ZEROS;
                 FlError = True;
                 Dspf.M02ItemRi = True;
                 Dspf.M02QtyRi  = True;
                 Dspf.M02DateRi = True;
                 PMsgId  = 'WS00041';
                 Exsr SendMessage;
              Elseif ADDITEM <> *Blanks and ADDDATE = *ZEROS;
                 FlError = True;
                 Dspf.M02SizeRi = True;
                 Dspf.M02QtyRi  = True;
                 Dspf.M02DateRi = True;
                 PMsgId  = 'WS00041';
                 Exsr SendMessage;
              Elseif ADDQTY <> *Zeros and ADDDATE = *ZEROS;
                 FlError = True;
                 Dspf.M02ItemRi = True;
                 Dspf.M02SizeRi = True;
                 Dspf.M02DateRi = True;
                 PMsgId  = 'WS00041';
                 Exsr SendMessage;
              Endif;
           Endif;

      *?   // Check in Temp File
           If FlManualAdd = True;
              Chain (PCust#:WkMnDte:ADDItem:ADDSize) WPLGORDL0;
              If %Found;
                 WkOQTY = WPOQTY1 + ADDQTY;
                 Exec Sql
                    Select Quantity_Available into :WkMQty
                       From FSTDPLGINV Left Outer Join WPLGORDPF
                       On Item_Number = WPITEM and Item_Size = WPSIZE and
                       Ready_date = WPDTE1
                    Where
                       (Ready_Date = :WkMnDte) and Quantity_Available > 0  and
                       View_Control_Type = 'Kube-Pak'                      and
                       (Substring(Item_Number,1,5)= :ADDITEM)              and
                       (Item_Size = :ADDSIZE);

                 If SqlCod = 0;
                    If WkMQty < WkOQty;
                       FlError = True;
                       Dspf.M02QtyRi = True;
                       PMsgId  = 'WS00072';
                       Exsr SendMessage;
                    Else;
                       WPOQTY1 = WkOQty;
                       Update Rec %Fields(WPOQTY1);
                    Endif;
                 Endif;
              Else;
                 WPCUST  = PCust#;
                 WPITEM  = AddItem;
                 WPSIZE  = AddSize;
                 WPDES1  = AddDesc;
                 WPLOOK  = *Blanks;
                 WPPRICE = $UnitPrice(ADDITEM:ADDSIZE:PCust#);
                 WPDTE1  = WkMnDte;
                 WPAQTY1 = %Char(WkMQty);
                 WPOQTY1 = AddQty;
                 Write WPLGORDR;
              Endif;

              If FlError = False;
                 ADDITEM = *Blanks;
                 ADDDESC = *Blanks;
                 ADDQTY  = *Zeros;
                 ADDEXIST= *Zeros;
                 Dspf.M02ExistNd= True;
              Endif;
              Dspf.M02SizePc = False;
              Dspf.C02ItemPc = True;
           Endif;

      *?   // Move Screen Values into Work Variables
           WkAItem = ADDITEM;
           WkASize = ADDSIZE;
           WkAQty  = ADDQTY;
           WkADate = ADDDATE;

      *?   // Display Subfile
           If FlManualAdd = True;
              FunReq  = 'INITIAL';
           Else;
              FunReq = 'DISPLAY';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : ValidateCtl Subroutine :
      *?                :------------------------:
      *
      *?Logic : Validate Control Screen Input fields in Subfile
      *?
        Begsr ValidateCtl;

      *?   // Initilize Subfile Indicators
           Dspf.C02ItemPc = False;

      *?   // Check Control search field values and Function Key
           If (SMITEM <> WkItemS Or SMSIZE <> WkSizeS Or SMDES1 <> WkDescS
              Or SMLOOK <> WkLookS) and (FlCtl <> True);
              FlCtlMod = True;             // Load Subfile based on Control fields
           Else;
              If Dspf.PageDown = False;
                 FlCtlMod = False;
                 WkItemS = *Blanks;
                 WkSizeS = *Blanks;
                 If SMDES1 = *Blanks;
                    WkDescS = *Blanks;
                    WkDesc  = *Blanks;
                 Endif;
                 If SMLOOK = *Blanks;
                    WkLook  = *Blanks;
                    WkLookS = *Blanks;
                 Endif;
              Endif;
           Endif;

      *?   // Get Search Values in to Work fields
           If FlCtlMod = True;
              WkItemS = SMITEM;
              WkSizeS = SMSIZE;
              WkDescS = SMDES1;
              WkLookS = SMLOOK;
              If SMITEM <> *Blanks Or SMSIZE <> *Blanks Or SMDES1 <> *Blanks
                      Or SMLOOK <> *Blanks;
                Exsr ConcatString;
              Else;
                 WkDesc = *Blanks;
                 WkLook = *Blanks;
              Endif;

      *?      // User Press Pagedown with search field
              If Dspf.Pagedown = True;
                 Dspf.Pagedown = False;
              Endif;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : ConcatString Subroutine :
      *?                :-------------------------:
      *
      *?Logic : ConcatString for Search
      *?
        Begsr ConcatString;

      *?   // Move Values into Work fields
           If SMDES1 <> *Blanks;
              WkDesc = '%' + %Trim(SMDES1) + '%';
           Else;
              WkDesc = *Blanks;
           Endif;

           If SMLOOK <> *Blanks;
              WkLook = '%' + %Trim(SMLOOK) + '%';
           Else;
              WkLook = *Blanks;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------------:
      *?                : WriteDataToFile Subroutine :
      *?                :----------------------------:
      *
      *?Logic : Write Subfile Data into Plug Order File
      *?
        Begsr WriteDataToFile;

      *?   // Read Changed record and Process
           If Dspf.S02SflDsp;
              ReadC PLGSFL2;
              Dow Not %Eof;
                 Dspf.S02SflNxtChg = False;
                 Update PLGSFL2;
                 Exsr WriteWorkFileSr;
                 Dspf.S02SflNxtChg = False;
                 ReadC PLGSFL2;
              Enddo;
              ReadC PLGSFL2;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------------:
      *?                : WriteWorkfileSr Subroutine :
      *?                :----------------------------:
      *
      *?Logic : Write/Update/Delete record in Workfile
      *?
        Begsr WriteWorkfileSr;

      *?   // Update into Workfile
           If S2ORQTY1 <> H2ORQTY1;
              Chain (PCust#:C02Dte1:S02Item:S02Size) WPLGORDL0;
              If %Found;
                 If S2ORQTY1 <> *Zeros;
                    WPOQTY1 = S2ORQTY1;
                    Update Rec %Fields(WPOQTY1);
                 Else;
                    Delete Rec;
                 Endif;
              Else;
                 Exsr Movevalues;
                 WPDTE1  = C02DTE1;
                 WPAQTY1 = S2AVQTY1;
                 WPOQTY1 = S2ORQTY1;
                 Write WPLGORDR;
              Endif;
           Endif;

           If S2ORQTY2 <> H2ORQTY2;
              Chain (PCust#:C02Dte2:S02Item:S02Size) WPLGORDL0;
              If %Found;
                 If S2ORQTY2 <> *Zeros;
                    WPOQTY1 = S2ORQTY2;
                    Update Rec %Fields(WPOQTY1);
                 Else;
                    Delete Rec;
                 Endif;
              Else;
                 Exsr Movevalues;
                 WPDTE1  = C02DTE2;
                 WPAQTY1 = S2AVQTY2;
                 WPOQTY1 = S2ORQTY2;
                 Write WPLGORDR;
              Endif;
           Endif;

           If S2ORQTY3 <> H2ORQTY3;
              Chain (PCust#:C02Dte3:S02Item:S02Size) WPLGORDL0;
              If %Found;
                 If S2ORQTY3 <> *Zeros;
                    WPOQTY1 = S2ORQTY3;
                    Update Rec %Fields(WPOQTY1);
                 Else;
                    Delete Rec;
                 Endif;
              Else;
                 Exsr Movevalues;
                 WPDTE1  = C02DTE3;
                 WPAQTY1 = S2AVQTY3;
                 WPOQTY1 = S2ORQTY3;
                 Write WPLGORDR;
              Endif;
           Endif;

           If S2ORQTY4 <> H2ORQTY4;
              Chain (PCust#:C02Dte4:S02Item:S02Size) WPLGORDL0;
              If %Found;
                 If S2ORQTY4 <> *Zeros;
                    WPOQTY1 = S2ORQTY4;
                    Update Rec %Fields(WPOQTY1);
                 Else;
                    Delete Rec;
                 Endif;
              Else;
                 Exsr Movevalues;
                 WPDTE1  = C02DTE4;
                 WPAQTY1 = S2AVQTY4;
                 WPOQTY1 = S2ORQTY4;
                 Write WPLGORDR;
              Endif;
           Endif;

           If S2ORQTY5 <> H2ORQTY5;
              Chain (PCust#:C02Dte5:S02Item:S02Size) WPLGORDL0;
              If %Found;
                 If S2ORQTY5 <> *Zeros;
                    WPOQTY1 = S2ORQTY5;
                    Update Rec %Fields(WPOQTY1);
                 Else;
                    Delete Rec;
                 Endif;
              Else;
                 Exsr Movevalues;
                 WPDTE1  = C02DTE5;
                 WPAQTY1 = S2AVQTY5;
                 WPOQTY1 = S2ORQTY5;
                 Write WPLGORDR;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Movevalues Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Move Values into Workfile Fields
      *?
        Begsr MoveValues;

      *?   // Clear record format
           Clear WPLGORDR;

      *?   // From Screen to Work File Fields
           WPCUST  = PCust#;
           WPITEM  = S02Item;
           WPSIZE  = S02SIZE;
           WPDES1  = S02DES1;
           WPLOOK  = S02LOOK;
           WPPRICE = S02Price;

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
           S02Item = SflRec.Item;
           S02SIZE = SflRec.Size;
           S02DES1 = SflRec.Desc;
           S02LOOK = SflRec.Alpha;
           S02Price= $UnitPrice(S02ITEM:S02SIZE:PCust#);
           Dspf.S02Part1 = True;
           Dspf.S02Part2 = True;
           Dspf.S02Part3 = True;
           Dspf.S02Part4 = True;
           Dspf.S02Part5 = True;

      *?   // Move Available/Ordered Quantity based on Date
           WkDate = SflRec.ReqDte;
           If SflRec.Avlqty > 0 and SflRec.Avlqty < 1;
              WkSflQtyC = %Trim(%Char(SflRec.Avlqty * 100)) + '%';
           Else;
              WkSflQty = *Zeros;
              WkSflQty = SflRec.Avlqty ;
              WkSflQtyC = %Trim(%Char(WkSflQty));
           Endif;

           Select;
              When WkDate = C02Dte1;
                 S2AVQTY1 = %Trim(WkSflQtyC);
                 S2ORQTY1 = SflRec.OrdQty;
                 H2ORQTY1 = SflRec.OrdQty;
                 WkPos = %Scan('%' : S2AVQTY1 : 1);
                 If WkPos <> 0;
                    Dspf.S02Part1 = False;
                 Else;
                    Dspf.S02Part1 = True;
                 Endif;
              When WkDate = C02Dte2;
                 S2AVQTY2 = %Trim(WkSflQtyC);
                 S2ORQTY2 = SflRec.OrdQty;
                 H2ORQTY2 = SflRec.OrdQty;
                 WkPos = %Scan('%' : S2AVQTY2 : 1);
                 If WkPos <> 0;
                    Dspf.S02Part2 = False;
                 Else;
                    Dspf.S02Part2 = True;
                 Endif;
              When WkDate = C02Dte3;
                 S2AVQTY3 = %Trim(WkSflQtyC);
                 S2ORQTY3 = SflRec.OrdQty;
                 H2ORQTY3 = SflRec.OrdQty;
                 WkPos = %Scan('%' : S2AVQTY3 : 1);
                 If WkPos <> 0;
                    Dspf.S02Part3 = False;
                 Else;
                    Dspf.S02Part3 = True;
                 Endif;
              When WkDate = C02Dte4;
                 S2AVQTY4 = %Trim(WkSflQtyC);
                 S2ORQTY4 = SflRec.OrdQty;
                 H2ORQTY4 = SflRec.OrdQty;
                 WkPos = %Scan('%' : S2AVQTY4 : 1);
                 If WkPos <> 0;
                    Dspf.S02Part4 = False;
                 Else;
                    Dspf.S02Part4 = True;
                 Endif;
              When WkDate = C02Dte5;
                 S2AVQTY5 = %Trim(WkSflQtyC);
                 S2ORQTY5 = SflRec.OrdQty;
                 H2ORQTY5 = SflRec.OrdQty;
                 WkPos = %Scan('%' : S2AVQTY5 : 1);
                 If WkPos <> 0;
                    Dspf.S02Part5 = False;
                 Else;
                    Dspf.S02Part5 = True;
                 Endif;
           Endsl;
           WkPos = 0;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : GetBackWeekSr Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Get Backward Five Dates from the Subfile Date

        Begsr GetBackWeekSr;

      *?   // Get Ready Bay Date
           Exsr ClearCtlFields;
           WkDteN  = *Zeros;
           WkRbDtN = *Zeros;
           Exec Sql SET :WkRbDte = Ready_Bay_Week;
           WkRbDtN =  %Int(%Char(WkRbDte:*CYMD0));
           WkDteN  =  %Int(%Char(WkStDte:*CYMD0));

      *?   // Check Ready bay Date in Calender File
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

      *?   // Get 5 dates based on Ready bay
           If WkCount < 5;
              Setll WkRbDtN FCALENWEEK;
           Else;
              Setll CLCYMD FCALENWEEK;
           Endif;
           WkCount = 1;
           Read FCALENWEEK;
           Dow Not %Eof And WkCount <=5;
              Select;
                 When WkCount= 1;
                    C02DTE1 = %Date(CLCYMD:*CYMD);
                    WkStDte = C02DTE1;
                    WkEndDt = C02DTE1;
                    C02WK1  = CLWEEK;
                 When WkCount = 2;
                    C02DTE2 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE2;
                    C02WK2  = CLWEEK;
                 When WkCount = 3;
                    C02DTE3 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE3;
                    C02WK3  = CLWEEK;
                 When WkCount = 4;
                    C02DTE4 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE4;
                    C02WK4  = CLWEEK;
                 When WkCount = 5;
                    C02DTE5 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE5;
                    C02WK5  = CLWEEK;
              EndSl;
              Read FCALENWEEK;
              WkCount +=1;
           Enddo;

SUD01 *?   // Check RB Date and Display Indicator
SUD01      Exsr CheckRBdate;
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

      *?   // Get Next 5 Dates
           Exsr ClearCtlFields;
           WkDteN = *Zeros;
           WkDteN = %Int(%Char(WkEndDt:*CYMD0));

      *?   // Check 52 Week Date in Calender File
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

      *?   // Get Start Date if End of 52th Week
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

      *?   // Set Pointer in Calender File
           If WkFlag = 'Y';
              Setgt WkDteN FCALENWEEK;
           Else;
              Setll WkDteN FCALENWEEK;
           Endif;
           Read FCALENWEEK;

      *?   // Get 5 Week Date in Calender File
           WkCount = 1;
           Dow Not %Eof and WkCount <=5 and WkDtYr7 >= CLCYMD;
              Select;
                 When WkCount = 1;
                    C02DTE1 = %Date(CLCYMD:*CYMD);
                    WkStDte = C02DTE1;
                    WkEndDt = C02DTE1;
                    C02WK1  = CLWEEK;
                 When WkCount = 2;
                    C02DTE2 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE2;
                    C02WK2  = CLWEEK;
                 When WkCount = 3;
                    C02DTE3 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE3;
                    C02WK3  = CLWEEK;
                 When WkCount = 4;
                    C02DTE4 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE4;
                    C02WK4  = CLWEEK;
                 When WkCount = 5;
                    C02DTE5 = %Date(CLCYMD:*CYMD);
                    WkEndDt = C02DTE5;
                    C02WK5  = CLWEEK;
              EndSl;
              Read  FCALENWEEK;
              WkCount +=1;
           Enddo;

SUD01 *?   // Check RB Date and Display Indicator
SUD01      Exsr CheckRBdate;
           WkCount  = *Zeros;
           WkCount1 = *Zeros;

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?                :------------------------:
  |   *?                : CheckRBdate Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Check Ready bay date with Control fields
  |   *?
  |     Begsr CheckRBdate;
  |
  |   *?   // Check RB Date
  |        If WkRbDteC = %Char(C02Dte1);
  |           Dspf.C02RbInd = True;
  |           Dspf.C02RbInd1= True;
  |        Elseif WkRbDteC  = %Char(C02Dte2);
  |           Dspf.C02RbInd = True;
  |           Dspf.C02RbInd2= True;
  |        Elseif WkRbDteC  = %Char(C02Dte3);
  |           Dspf.C02RbInd = True;
  |           Dspf.C02RbInd3= True;
  |        Elseif WkRbDteC  = %Char(C02Dte4);
  |           Dspf.C02RbInd = True;
  |           Dspf.C02RbInd4= True;
  |        Elseif WkRbDteC  = %Char(C02Dte5);
  |           Dspf.C02RbInd = True;
  |           Dspf.C02RbInd5= True;
  |        Endif;
  |
SUD01   Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : WorkFileCheck Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Check Record exists in Work file
      *?
        Begsr WorkFileCheck;

      *?   // Check Record Count
           WkCount = *Zeros;
           Exec Sql
              Select  Count(*) into :WkCount from WPLGORDPF;
           If SqlCode = 0;
              If WkCount <> *Zeros;
                 FlAllow = True;
              Else;
                 FlAllow = False;
              Endif;
           Endif;
           WkCount = *Zeros;

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
      *?---------------- End Of Subroutines --------------------------------
