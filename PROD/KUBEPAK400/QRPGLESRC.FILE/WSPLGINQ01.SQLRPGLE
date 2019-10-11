      *? Program        : WSPLGINQ01
      *?
      *? Description    : This program for Plug Item Inquiry
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 12 Apr 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** F7 - To show Previous 10 Weeks from the screen Start date
      *?                  ** F8 - To show Next 10 weeks from the screen End date
      *?
      *? Called Program : WSSFLMSG - WS - Send and Clear message from subfile
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
           BndDir('*LIBL/KPFUNCTION') DatFmt(*USA) AlwNull(*UsrCtl);
        /COPY QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Calendar File
      *?Key : Date
        Dcl-F FCALENWEEK Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for Plug Order Entry Program
        Dcl-F WSPLGINQFM Workstn Indds(Dspf) Sfile(PLGSFL:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPLGINQ01;
        End-Pi;
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
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S ModReq    Char(10)      Inz;
        Dcl-S FunReq    Char(10)      Inz;
      *
      *?Work Variable Declaration :
        Dcl-S NullInd   Int(5) Dim(7) Inz(0);        // Null Indicator for WkAlcQty
        Dcl-S NullValue Like(NullInd) Inz(-1);       // Null Indicator for WkAlcQty
        Dcl-S WkFRrn    Like(S01Rrn)  Inz;
        Dcl-S WkLRrn    Like(S01Rrn)  Inz;
        Dcl-S WkStDte   Date(*ISO)    Inz;
        Dcl-S WkEndDt   Date(*ISO)    Inz;
        Dcl-S WkRbDte   Date(*ISO)    Inz;
        Dcl-S WkDtYr    Date(*ISO)    Inz;
        Dcl-S WkMondt   Date(*ISO)    Inz;
        Dcl-S WkSflQty  Packed(30)    Inz;
        Dcl-S WKMon     Zoned(6:0)    Inz;
        Dcl-S WkDat7    Zoned(7:0)    Inz;
        Dcl-S WkDat4    Zoned(4:0)    Inz;
        Dcl-S WkDteN    Zoned(7:0)    Inz;
        Dcl-S WkRbDtN   Zoned(7:0)    Inz;
        Dcl-S WkRbDt4   Zoned(4:0)    Inz;
        Dcl-S WkCount   Zoned(5:0)    Inz;
        Dcl-S WkCount1  Zoned(5:0)    Inz;
        Dcl-S WkDtYr7   Zoned(7:0)    Inz;           // 52 Week Date CYYMMDD
        Dcl-S WkPos     Zoned(1)      Inz;
        Dcl-S WkItemS   Char(22)      Inz;
        Dcl-S WkItem    Char(22)      Inz;
        Dcl-S WkDesc    Char(30)      Inz;
        Dcl-S WkDescS   Char(30)      Inz;
        Dcl-S WkLookS   Char(15)      Inz;
        Dcl-S WkLook    Char(15)      Inz;
        Dcl-S WkSflQtyC Char(30)      Inz;
        Dcl-S WkSize    Char(3)       Inz;
        Dcl-S WkSizeS   Char(3)       Inz;
        Dcl-S WkFlag    Char(1)       Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf     Char(10);
        Dcl-S PMsgId    Char(7);
        Dcl-S POpt      Char(1);
        Dcl-S PCust#    Packed(6);
      *
      *?Flag Variables Declaration :
        Dcl-S FlCtlMod    Ind Inz(*Off);
        Dcl-S FlError     Ind Inz(*Off);
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
           Pagedown        Ind Pos(13);         // Pagedown Function Key
      *
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           C01ItemPc       Ind Pos(30);         // Item Position Cursor Ind
      *
           S01Part01       Ind Pos(40);         // Partial Indicator Ind
           S01Part02       Ind Pos(41);         // Partial Indicator Ind
           S01Part03       Ind Pos(42);         // Partial Indicator Ind
           S01Part04       Ind Pos(43);         // Partial Indicator Ind
           S01Part05       Ind Pos(44);         // Partial Indicator Ind
           S01Part06       Ind Pos(45);         // Partial Indicator Ind
           S01Part07       Ind Pos(46);         // Partial Indicator Ind
           S01Part08       Ind Pos(47);         // Partial Indicator Ind
           S01Part09       Ind Pos(48);         // Partial Indicator Ind
           S01Part10       Ind Pos(49);         // Partial Indicator Ind
           S01Part11       Ind Pos(50);         // Partial Indicator Ind
           S01Part12       Ind Pos(51);         // Partial Indicator Ind
      *
           C01RbInd01      Ind Pos(60);         // Ready Bay Week 1 Ind
           C01RbInd02      Ind Pos(61);         // Ready Bay Week 2 Ind
           C01RbInd03      Ind Pos(62);         // Ready Bay Week 3 Ind
           C01RbInd04      Ind Pos(63);         // Ready Bay Week 4 Ind
           C01RbInd05      Ind Pos(64);         // Ready Bay Week 5 Ind
           C01RbInd06      Ind Pos(65);         // Ready Bay Week 6 Ind
           C01RbInd07      Ind Pos(66);         // Ready Bay Week 7 Ind
           C01RbInd08      Ind Pos(67);         // Ready Bay Week 8 Ind
           C01RbInd09      Ind Pos(68);         // Ready Bay Week 9 Ind
           C01RbInd10      Ind Pos(69);         // Ready Bay Week 10 Ind
           C01RbInd11      Ind Pos(70);         // Ready Bay Week 10 Ind
           C01RbInd12      Ind Pos(71);         // Ready Bay Week 10 Ind
           C01RbTxt        Ind Pos(72);         // Ready Bay Text Indicator
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
                 Exsr SN1M;
              Enddo;

           Enddo;

      *?   // Close Cursor
           Exec Sql Close A1;
           Exec Sql Close A2;

      *?   // End Program
           *InLr = *On;
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

      *?   // Close Cursor
           Exec Sql Close A1;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;                      // Clear Ind ON
           Dspf.S01SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write PLGCTL;

      *?   // Clear Rrn and Flag
           FlError = False;
           S01Rrn  = *Zeros;
           WkFRrn  = *Zeros;
           WkLRrn  = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S01SflClr    = False;                  // Clear Ind OFF
           Dspf.S01SflDspCtl = True;                   // Display Control Ind ON

      *?   // Build the Subfile
           Exsr SN1B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Control fields
      *?
        Begsr SN1B;

      *?   // Initialise Fields, Rrn and Count
           Exsr ClearSflFields;
           Exsr ClearQtyFields;
           Dspf.C01ItemPc = True;

      *?   // Execute Sql to get Subfile Records
           If Dspf.PageDown = False;
              Exec Sql Declare A1 Cursor For
              Select Item_Sort, Item_Size, Substring(Item_Number,1,5),
                   Item_Description, Ready_Date, Quantity_Available
                   From FSTDPLGINV
              Where
               (Ready_Date >= :WkStDte and Ready_Date <= :WKEndDt)        and
               Quantity_Available > 0  and View_Control_Type = 'Kube-Pak' and
               (Substring(Item_Number,1,5)= :SMITEM or :SMITEM = ' ')     and
               (Item_Size = :SMSIZE or :SMSIZE = ' ')                     and
               (Item_Description like Trim(:WkDESC) or :WkDESC = ' ')     and
               (Item_Sort like Trim(:WkLOOK) or :WkLOOK = ' ')
              Order by Item_Sort, ITEM_SIZE, ITEM_Number,
                                    Item_description, Ready_Date;
      *?      // Open Cursor
              Exec Sql Open A1;
                 If SqlCode = -502 ;
                    Exec Sql Close A1;
                    Exec Sql Open A1;
                 Endif;
              Exec Sql Fetch A1 into :SflRec :NullInd;
           Endif;

      *?   // For Pagedown
           If Dspf.PageDown = True;
              WkItem = SflRec.Item;
              WkSize = SflRec.Size;
              Exsr MoveValuesSR;
              Exec Sql Fetch A1 into :SflRec :NullInd;
              If SqlCod = 0;
                 S01Rrn = WkLRrn;
              Endif;
           Endif;

      *?   // Load Subfile
           Dow SqlCod = 0 and WkCount < 18;

      *?      // Write Subfile Display Part
              If (WkItem <> SflRec.Item and WkItem <> *Blanks) Or
                 (WkSize <> SflRec.Size and WkSize <> *Blanks);

      *?         // Increment RRN
                 S01Rrn  += 1;
                 WkCount += 1;
                 If WkCount = 1;
                    WkFRrn = S01Rrn;
                 Endif;
                 WkLRrn = S01Rrn;
                 Write PLGSFL;
                 Exsr ClearQtyFields;
              Endif;

      *?      // Move Values
              WkItem = SflRec.Item;
              WkSize = SflRec.Size;
              Exsr MoveValuesSR;
              If WkCount <= 17;
                 Exec Sql Fetch A1 into :SflRec :NullInd;
              Endif;
           Enddo;

      *?   // If RRN is equal to Zero and S01Item not equal to Zero
           If S01Item <> *Blanks and WkCount < 18;
              S01Rrn += 1;
              WkCount += 1;
              If WkCount = 1;
                 WkFRrn = S01Rrn;
              Endif;
              WkLRrn = S01Rrn;
              Write PLGSFL;
              Exsr ClearQtyFields;
           Endif;

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
              H01FRRN = S01RRN;
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
      *?                : SN1D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN1D;

      *?   // Position to the First RRN
           If WkFRrn <> *Zeros;
              S01Rrn = WkFRrn;
           Else;

      *?      // Position to the current page
              If H01FRrn <> *Zeros;
                 S01Rrn = H01FRrn;
              Endif;
           Endif;

      *?   // Write the Footer
           Write PLGFTR;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt PLGCTL;
           WkFRrn = *Zeros;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F7 Pressed
              When Dspf.Backward;
                 FlCtl  = True;
                 FunReq = 'VALIDATE';

      *?      // F8 Pressed
              When Dspf.Forward;
                 FlCtl  = True;
                 FunReq = 'VALIDATE';

      *?      // Pagedown Pressed
              When Dspf.PageDown;
                 If Dspf.S01SflEnd = False;
                    FunReq = 'VALIDATE';
                 Else;
                    FunReq = 'DISPLAY';
                    WkFRrn = S01Rrn;
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
      *?                : SN1V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate Input capable Control Fields ,
      *?      : If No errors then Process , Else Display error in Screen
      *?
        Begsr SN1V;

      *?   // Initialise Flags
           FlCtlMod = False;
           FlError  = False;

      *?   // Validate Control Screen Fields
           If FlError = False;
              If (SMITEM <> WkItemS Or SMSIZE <> WkSizeS Or SMDES1 <> WkDescS
                 Or SMLOOK <> WkLookS);
                 Exsr ValidateCtl;
              Endif;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
           Elseif FlCtlMod;
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
           Elseif FlCtlMod = False and Dspf.Pagedown = False and FlCtl = False;
              FunReq = 'DISPLAY';
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

      *?   // Process Backward on F7
           If Dspf.Backward = True;
              If WkStDte = WkRbDte;
                 PMsgId  = 'WS00080';
                 Exsr SendMessage;
                 FunReq = 'DISPLAY';
              Else;
                 Exsr GetBackWeekSr;
                 Exsr SN1I;
              Endif;

      *?   // Process Forward on F8
           Elseif Dspf.Forward = True;
              If WkEndDt = WkMonDt;
                 PMsgId  = 'WS00081';
                 Exsr SendMessage;
                 FunReq = 'DISPLAY';
              Else;
                 WkFlag = 'Y';
                 Exsr GetNextWeekSr;
                 Exsr SN1I;
              Endif;

      *?   // Process Forward on Pagedown
           Elseif Dspf.PageDown = True;
              Exsr SN1B;

      *?   // Process on Enter
           Else;
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
           WkEndDt = %Date;

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
           WkRbDtN = %Int(%Char(WkRbDte:*CYMD0));
           WKRbDt4 = %Int(%Subst(%Char(WkRbDtN):4:4));

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
           Clear C01DTE01;
           Clear C01DTE02;
           Clear C01DTE03;
           Clear C01DTE04;
           Clear C01DTE05;
           Clear C01DTE06;
           Clear C01DTE07;
           Clear C01DTE08;
           Clear C01DTE09;
           Clear C01DTE10;
           Clear C01DTE11;
           Clear C01DTE12;
           C01WK01 = *Blanks;
           C01WK02 = *Blanks;
           C01WK03 = *Blanks;
           C01WK04 = *Blanks;
           C01WK05 = *Blanks;
           C01WK06 = *Blanks;
           C01WK07 = *Blanks;
           C01WK08 = *Blanks;
           C01WK09 = *Blanks;
           C01WK10 = *Blanks;
           C01WK11 = *Blanks;
           C01WK12 = *Blanks;
           Dspf.C01RbTxt   = False;
           Dspf.C01RbInd01 = False;
           Dspf.C01RbInd02 = False;
           Dspf.C01RbInd03 = False;
           Dspf.C01RbInd04 = False;
           Dspf.C01RbInd05 = False;
           Dspf.C01RbInd06 = False;
           Dspf.C01RbInd07 = False;
           Dspf.C01RbInd08 = False;
           Dspf.C01RbInd09 = False;
           Dspf.C01RbInd10 = False;
           Dspf.C01RbInd11 = False;
           Dspf.C01RbInd12 = False;

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
           S01Item = *Blanks;
           S01Size = *Blanks;
           S01Des1 = *Blanks;
           S01Look = *Blanks;
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
           S1AVQTY01 = *Blanks;
           S1AVQTY02 = *Blanks;
           S1AVQTY03 = *Blanks;
           S1AVQTY04 = *Blanks;
           S1AVQTY05 = *Blanks;
           S1AVQTY06 = *Blanks;
           S1AVQTY07 = *Blanks;
           S1AVQTY08 = *Blanks;
           S1AVQTY09 = *Blanks;
           S1AVQTY10 = *Blanks;
           S1AVQTY11 = *Blanks;
           S1AVQTY12 = *Blanks;

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
           Dspf.C01ItemPc = False;

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
      *?                :-------------------------:
      *?                : MoveValuesSr Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Move Values into Subfile Fields
      *?
        Begsr MoveValuesSr;

      *?   // From Workfile to Subfile Fields
           S01Item = SflRec.Item;
           S01SIZE = SflRec.Size;
           S01DES1 = SflRec.Desc;
           S01LOOK = SflRec.Alpha;
           Dspf.S01Part01 = True;
           Dspf.S01Part02 = True;
           Dspf.S01Part03 = True;
           Dspf.S01Part04 = True;
           Dspf.S01Part05 = True;
           Dspf.S01Part06 = True;
           Dspf.S01Part07 = True;
           Dspf.S01Part08 = True;
           Dspf.S01Part09 = True;
           Dspf.S01Part10 = True;
           Dspf.S01Part11 = True;
           Dspf.S01Part12 = True;

      *?   // Move Available on Date
           WkDat7 = %Int(%Char(SflRec.ReqDte:*CYMD0));
           WKDat4 = %Int(%Subst(%Char(WkDat7):4:4));
           If SflRec.Avlqty > 0 and SflRec.Avlqty < 1;
              WkSflQtyC = %Trim(%Char(SflRec.Avlqty * 100)) + '%';
           Else;
              WkSflQty = *Zeros;
              WkSflQty = SflRec.Avlqty ;
              WkSflQtyC = %Trim(%Char(WkSflQty));
           Endif;

           Select;
              When WkDat4 = C01Dte01;
                 S1AVQTY01 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY01 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part01 = False;
                 Else;
                    Dspf.S01Part01 = True;
                 Endif;
              When WkDat4 = C01Dte02;
                 S1AVQTY02 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY02 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part02 = False;
                 Else;
                    Dspf.S01Part02 = True;
                 Endif;
              When WkDat4 = C01Dte03;
                 S1AVQTY03 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY03 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part03 = False;
                 Else;
                    Dspf.S01Part03 = True;
                 Endif;
              When WkDat4 = C01Dte04;
                 S1AVQTY04 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY04 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part04 = False;
                 Else;
                    Dspf.S01Part04 = True;
                 Endif;
              When WkDat4 = C01Dte05;
                 S1AVQTY05 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY05 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part05 = False;
                 Else;
                    Dspf.S01Part05 = True;
                 Endif;
              When WkDat4 = C01Dte06;
                 S1AVQTY06 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY06 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part06 = False;
                 Else;
                    Dspf.S01Part06 = True;
                 Endif;
              When WkDat4 = C01Dte07;
                 S1AVQTY07 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY07 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part07 = False;
                 Else;
                    Dspf.S01Part07 = True;
                 Endif;
              When WkDat4 = C01Dte08;
                 S1AVQTY08 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY08 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part08 = False;
                 Else;
                    Dspf.S01Part08 = True;
                 Endif;
              When WkDat4 = C01Dte09;
                 S1AVQTY09 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY09 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part09 = False;
                 Else;
                    Dspf.S01Part09 = True;
                 Endif;
              When WkDat4 = C01Dte10;
                 S1AVQTY10 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY10 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part10 = False;
                 Else;
                    Dspf.S01Part10 = True;
                 Endif;
              When WkDat4 = C01Dte11;
                 S1AVQTY11 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY11 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part11 = False;
                 Else;
                    Dspf.S01Part11 = True;
                 Endif;
              When WkDat4 = C01Dte12;
                 S1AVQTY12 = %Trim(WkSflQtyC);
                 WkPos = %Scan('%' : S1AVQTY12 : 1);
                 If WkPos <> 0;
                    Dspf.S01Part12 = False;
                 Else;
                    Dspf.S01Part12 = True;
                 Endif;
           Endsl;
           WkPos = 0;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : GetBackWeekSr Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Get Backward 12 Dates from the Subfile Date

        Begsr GetBackWeekSr;

      *?   // Get Ready Bay Date
           Exsr ClearCtlFields;
           WkDteN  = *Zeros;
           WkRbDtN = *Zeros;
           WkRbDtN =  %Int(%Char(WkRbDte:*CYMD0));
           WkDteN  =  %Int(%Char(WkStDte:*CYMD0));

      *?   // Check Ready bay Date in Calender File
           WkCount = 1;
           Setll WkDteN FCALENWEEK;
           ReadP FCALENWEEK;
           Dow Not %Eof And WkCount < 12;
              If CLCYMD <= WkRbDtN;
                 Leave;
              Endif;
              WkCount +=1;
              ReadP FCALENWEEK;
           Enddo;

      *?   // Get 12 dates based on Ready bay
           If WkCount < 12;
              Setll WkRbDtN FCALENWEEK;
           Else;
              Setll CLCYMD FCALENWEEK;
           Endif;
           WkCount = 1;
           Read FCALENWEEK;
           Dow Not %Eof And WkCount <=12;
              Select;
                 When WkCount= 1;
                    WkStDte  = %Date(CLCYMD:*CYMD);
                    WkEndDt  = %Date(CLCYMD:*CYMD);
                    C01DTE01 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK01  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 2;
                    WkEndDt  = %Date(CLCYMD:*CYMD);
                    C01DTE02 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK02  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 3;
                    WkEndDt  = %Date(CLCYMD:*CYMD);
                    C01DTE03 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK03  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 4;
                    WkEndDt  = %Date(CLCYMD:*CYMD);
                    C01DTE04 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK04  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 5;
                    WkEndDt  = %Date(CLCYMD:*CYMD);
                    C01DTE05 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK05  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 6;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE06 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK06  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 7;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE07 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK07  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 8;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE08 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK08  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 9;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE09 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK09  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 10;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE10 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK10  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 11;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE11 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK11  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 12;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE12 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK12  = 'WK'+ %EditC(CLWEEK:'X');
              EndSl;
              Read FCALENWEEK;
              WkCount +=1;
           Enddo;

      *?   // Check RB Date and Display Indicator
           Exsr CheckRBdate;
           WkCount = *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : GetNextWeekSr Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Get Next Ten Dates from the Subfile Date
      *?
        Begsr GetNextWeekSr;

      *?   // Get Next 10 Dates
           Exsr ClearCtlFields;
           WkDteN = *Zeros;
           WkDteN = %Int(%Char(WkEndDt:*CYMD0));

      *?   // Check 52 Week Date in Calender File
           WkCount = *Zeros;
           Setgt WkDteN FCALENWEEK;
           Read FCALENWEEK;
           Dow Not %Eof And WkCount <= 12;
              If CLCYMD > WkDtYr7;
                 Leave;
              Endif;
              WkCount +=1;
              Read FCALENWEEK;
           Enddo;

      *?   // Get Start Date if End of 52th Week
           If WkCount < 12;
              WkCount1 = 1;
              Setgt WkDtYr7 FCALENWEEK;
              ReadP FCALENWEEK;
              Dow Not %Eof and WkCount1 <= 13;
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

      *?   // Get 12 Week Date in Calender File
           WkCount = 1;
           Dow Not %Eof and WkCount <= 12 and WkDtYr7 >= CLCYMD;
              Select;
                 When WkCount = 1;
                    WkStDte = %Date(CLCYMD:*CYMD);
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE01 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK01  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 2;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE02 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK02  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 3;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE03 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK03  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 4;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE04 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK04  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 5;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE05 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK05  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 6;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE06 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK06  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 7;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE07 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK07  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 8;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE08 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK08  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 9;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE09 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK09  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 10;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE10 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK10  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 11;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE11 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK11  = 'WK'+ %EditC(CLWEEK:'X');
                 When WkCount = 12;
                    WkEndDt = %Date(CLCYMD:*CYMD);
                    C01DTE12 = %Int(%Subst(%Char(CLCYMD):4:4));
                    C01WK12  = 'WK'+ %EditC(CLWEEK:'X');
              EndSl;
              Read  FCALENWEEK;
              WkCount +=1;
           Enddo;

      *?   // Check RB Date and Display Indicator
           Exsr CheckRBdate;
           WkCount  = *Zeros;
           WkCount1 = *Zeros;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : CheckRBdate Subroutine :
      *?                :------------------------:
      *
      *?Logic : Check Ready bay date with Control fields
      *?
        Begsr CheckRBdate;

      *?   // Check RB Date
           Select;
              When WkRbDt4 = C01Dte01;
                 Dspf.C01RbInd01 = True;
              When WkRbDt4 = C01Dte02;
                 Dspf.C01RbInd02 = True;
              When WkRbDt4 = C01Dte03;
                 Dspf.C01RbInd03 = True;
              When WkRbDt4 = C01Dte04;
                 Dspf.C01RbInd04 = True;
              When WkRbDt4 = C01Dte05;
                 Dspf.C01RbInd05 = True;
              When WkRbDt4 = C01Dte06;
                 Dspf.C01RbInd06 = True;
              When WkRbDt4 = C01Dte07;
                 Dspf.C01RbInd07 = True;
              When WkRbDt4 = C01Dte08;
                 Dspf.C01RbInd08 = True;
              When WkRbDt4 = C01Dte09;
                 Dspf.C01RbInd09 = True;
              When WkRbDt4 = C01Dte10;
                 Dspf.C01RbInd10 = True;
              When WkRbDt4 = C01Dte11;
                 Dspf.C01RbInd11 = True;
              When WkRbDt4 = C01Dte12;
                 Dspf.C01RbInd12 = True;
           Endsl;

      *?   // RB Text Indicator
           If Dspf.C01RbInd01 Or Dspf.C01RbInd02 Or Dspf.C01RbInd03 Or
              Dspf.C01RbInd04 Or Dspf.C01RbInd05 Or Dspf.C01RbInd06 Or
              Dspf.C01RbInd07 Or Dspf.C01RbInd08 Or Dspf.C01RbInd09 Or
              Dspf.C01RbInd10 Or Dspf.C01RbInd11 Or Dspf.C01RbInd12;
              Dspf.C01RbTxt = True;
           Else;
              Dspf.C01RbTxt = False;
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
      *?---------------- End Of Subroutines --------------------------------
