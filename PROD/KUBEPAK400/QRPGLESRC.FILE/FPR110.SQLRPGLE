     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: FPR110.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2016                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? :  FPR110.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPR110FM  CF   E             WORKSTN
     F                                     SFILE(FPR11001S:RRN01)
     FFMINVTHISTO  A E             DISK


      //  Main procedure prototype & interface
     D FPR110          PR                  ExtPgm('FPR110')
     D FPR110          PI

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR

     D FindItem        PR                  ExtPgm('FPR055')
     D  #Find#                       20A   CONST

     D InvTrans        PR                  ExtPgm('ICR800')
     D  #ITEM#                       12A   CONST
     D  #SIZE#                        3A   CONST

    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$Monday
     D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,QCMDEXC

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

     D FFINPPDTAG_DS E DS
     D RMINVT        E DS                  ExtName(FMINVT)


      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   RRN01         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 03
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Now           S              6S 0 Inz(0)                               ?Time Now
     D   Today         S              6S 0 Inz(0)                               ?Today
     D   Today7        S              7S 0 Inz(0)                               ?Today YMD7
     D   Pink          S              1A   Inz('?')                             ?Color Code -?PINK
     D   White         S              1A   Inz('?')                              Color Code - White
     D   SelBatch      S              6S 0
     D   LastFPPPD#    S              6S 0
     D   SavSELBATCH   S              6S 0
     D   User          S             10A
     D   X             S              5S 0 Inz(0)
     D   dftDate1      S               D   Inz
     D   dftDate2      S               D   Inz(d'01/01/2000')
     D   selFPWEEK     S               D   Inz(d'01/01/2000')
     D   selFPDATE     S               D   Inz(d'01/01/2000')
     D   ActlTran      S              6S 0
     D   ProjTran      S              6S 0
     D   ProjB4        S              6S 0
     D   LastRcdKey    S             64
     D   LastItemSize  S             15
     D   Trans_Desc    S             30

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

    ?   /COPY QFunctDefn,LASTUSEDCB

         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
             Other;
               *In50 = *On;
               $ERR_PROG = $PGM;
               Today=$MDYDATE($Date(0));
               Today7=$DATE7($Date(0));
               User = $User();
               SelBatch = 0;
               SelCstm  = 'B';
               SortBy = 'PPD Tag#';
               Exec SQL  // Get Latest Week...
                 SELECT     Max(FPWEEK)
                 Into      :SelFPWEEK
                 FROM       FFINPPDTAG
                 WHERE      FPPRTD  = 'Y'
                   and      FPINVT  = 'N';
               Load01();
               Scrn01();
               *In50 = *Off;
           ENDSL;
         ENDDO;

         *InLR = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 01 SubProcedures                                          :
      // :..................................................................:

     P Load01          B
     D Load01          PI
     D  #Truck         S              8A
     D  #TimeStamp     S               Z
     D  #User          S             10A
      /Free

         SFLPOSTO1 = 1;
         RRN01 = 0;
         *In80 = *On;   // Clear Subfile
         Write FPR11001;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         *In28 = *Off;  // SFLNXTCHG
         RRN01 = 0;
         LastFPPPD# = *Zero;
         SavSelBatch = SelBatch;
         SelPOST  = ' ';
         ProjB4   = 0;
         ProjTran = 0;
         ActlTran = 0;

         SQLState = '00000';
         Clear LastRcdKey;
         DoW SQLState = '00000';
           If SortBy = 'PPD Tag#';
             Exec SQL
               SELECT     *
               Into      :FFINPPDTAG_DS
               FROM       FFINPPDTAG
               WHERE      FPINVT  = 'N'
                 and      FPPRTD <> 'D'
                 and      FPPPD#  > :LastFPPPD#
                 and  (   date(FPWEEK)  = date(:SelFPWEEK)
                      or :SelFPWEEK = :DftDate2 )
                 and  (   date(FPDATE)  = date(:SelFPDATE)
                      or :SelFPDATE = :DftDate2 )
                 and  (   FPITEM  = :SelITEM
                      or :SelITEM =  ' ' )
                 and  (   FPSIZE  = :SelSIZE
                      or :SelSIZE =  ' ' )
                 and  (   FPCUST  = :SelCUST
                      or :SelCUST =  0   )
                 and  (  (FPCUST  = 0 and :SelCstm = 'N')
                      or (FPCUST <> 0 and :SelCstm = 'Y')
                      or :SelCstm = 'B' )
               order by   FPPPD#
               Fetch First Row Only;
             *In41 = isEven(RRN01);
            else;
             Exec SQL
               SELECT     *
               Into      :FFINPPDTAG_DS
               FROM       FFINPPDTAG
               WHERE      FPINVT  = 'N'
                 and      FPPRTD <> 'D'
                 and      FPSIZE ||
                          FPITEM ||
                          FPPLTG ||
                          FPCUST ||
                          char(FPTIMESTAMP)  > :LastRcdKey
                 and  (   date(FPWEEK)  = date(:SelFPWEEK)
                      or :SelFPWEEK = :DftDate2 )
                 and  (   date(FPDATE)  = date(:SelFPDATE)
                      or :SelFPDATE = :DftDate2 )
                 and  (   FPITEM  = :SelITEM
                      or :SelITEM =  ' ' )
                 and  (   FPSIZE  = :SelSIZE
                      or :SelSIZE =  ' ' )
                 and  (   FPCUST  = :SelCUST
                      or :SelCUST =  0   )
                 and  (  (FPCUST  = 0 and :SelCstm = 'N')
                      or (FPCUST <> 0 and :SelCstm = 'Y')
                      or :SelCstm = 'B' )
               order by   FPSIZE
                      ,   FPITEM
                      ,   FPPLTG
                      ,   FPCUST
                      ,   FPTIMESTAMP
               Fetch First Row Only;
             LastRcdKey =
               FPSIZE + FPITEM + %char(FPPLTG) +
               %char(FPCUST) + %char(FPTIM00001);
             If FPITEM + FPSIZE <> LastItemSize;
               *In41 = not *In41;
               LastItemSize = FPITEM + FPSIZE;
             EndIf;

           EndIf;

           If SQLState = '00000';
             RRN01 += 1;
             In41  = *In41;
             *In42 = *Off;
             *In43 = *Off;
             If FPDATE = dftDate1 or FPDATE = dftDate2;
               *In42 = *On;
             EndIf;
             In42 = *In42;
             If FPSHIP = dftDate1 or FPSHIP = dftDate2;
               *In43 = *On;
             EndIf;
             In43 = *In43;
             ITEMSIZE = %Trim(FPITEM) + ' ( ' + %Trim(FPSIZE) + ' )';
             INVPROJ = ItemProjection(FPITEM:FPSIZE:FPCUST);
             //INVPROJ = 0;  //  Don't Show this number
             If INVPROJ = 0;
               *In55 = *On;
              Else;
               *In55 = *Off;
             EndIf;
             QTYFOUND = 0;
             Exec SQL
               Select  sum(FLQTY)
               into   :QTYFOUND
               From    FFINLOC
               Where   FLITEM = :FPITEM
                 and   FLSIZE = :FPSIZE
                 and   FLPLTG = :FPPLTG
                 //and   FLDATE = :FPDATE
                 and   FLSHIP = :FPSHIP
                 and   FLCUST = :FPCUST;
             Exec SQL
               Select  sum(FLQTY)
               into   :FPPD#CNTD
               From    FFINLOC
               Where   FLPPD# = :FPPPD#;
             SQLState = '00000';
             *In52 = *Off;
             *In53 = *Off;
             *In54 = *Off;
             If FPQTYACTL <> FPQTYPROJ;
               *In52 = *On;
             EndIf;
             If QTYFOUND <> FPQTYACTL;
               *In53 = *On;
             EndIf;
          // If FPQTYCNTD <> QTYFOUND;
          //   *In54 = *On;
          // EndIf;
             In41 = *IN41;
             In42 = *IN42;
             In43 = *IN43;
             In52 = *In52;
             In53 = *In53;
             In54 = *In54;
             Write FPR11001S;
             *In26 = *On;
             LastFPPPD# = FPPPD#;
           EndIf;
         EndDo;

         Records = RRN01;

      /End-Free
     P Load01          E

      //_____________________________________________________________________
      //

     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         If SFLPOSTO1 <= *Zero;
           SFLPOSTO1 = 1;
         EndIf;
         write ASSUME;
         write FPR11001F;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt FPR11001;
         If SFLCSRRRN > 0;
           SFLPOSTO1 = SFLCSRRRN;
         EndIf;
         $ClrError();
      /End-Free
     P Scrn01          E

      //_____________________________________________________________________
      //

     P Edit01          B
     D Edit01          PI
      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In05;                 // Refresh
             SelBatch = 0;
             Load01();
             Scrn01();
           When *In07;                 // Select All
             UpdS01();
             Scrn01();
           When *In08;                 // De-Select All
             UpdS01();
             Scrn01();
           When *In09;                 // Reverse Selection
             UpdS01();
             Scrn01();
           When *In10;                 // Change Sort
             If SortBy = 'PPD Tag#';
                SortBy = 'Siz/Item';
              else;
                SortBy = 'PPD Tag#';
             EndIf;
             Load01();
             Scrn01();
    ?      When *In22;  //Right Mouse Click
             Mouse01();
    ?      When SELBATCH  <> SavSELBATCH;
             Load01();
             Scrn01();
           Other;         // Process Scan and Subfile
             SflS01();
             Load01();
             Scrn01();
         EndSl;
      /End-Free
     P Edit01          E

      //_____________________________________________________________________
      //

     P Mouse01         B
     D Mouse01         PI
      /Free
         //  We only use a left mouse click now because we are too used to using the mouse
         //  to move around the screen.  The mouse action will be determined by the field.
         Select;
         When CSRFLD = '';
           Load01();
         When CSRFLD = 'WEEK_PLUS';
           SELFPWEEK = $AddDate(SelFPWEEK:+7);
           Load01();
         When CSRFLD = 'WEEK_MINUS';
           SELFPWEEK = $AddDate(SelFPWEEK:-7);
           Load01();
         When CSRFLD = 'PLNT_PLUS';
           SELFPDATE = $AddDate(SELFPDATE:+7);
           Load01();
         When CSRFLD = 'PLNT_MINUS';
           SELFPDATE = $AddDate(SELFPDATE:-7);
           Load01();
         When CSRFLD = 'SelITEM';
           SelITEM = *Blanks;
           Load01();
         When CSRFLD = 'SELFPWEEK';
           SELFPWEEK = dftDate2 ;
           Load01();
         When CSRFLD = 'SELFPDATE';
           SELFPDATE = dftDate2 ;
           Load01();
         When CSRFLD = 'SELCUST';
           SELCUST = *Zeros;
           Load01();
         When CSRFLD = 'SELITEM';
           SELITEM = *Blanks;
           Load01();
         When CSRFLD = 'SELSIZE';
           SELSIZE = *Blanks;
           Load01();
         // If no other enabled fields selected see if cursor is on the subfile.
         When CSRRCD = 'FPR11001S';
  ?        Chain SFLCSRRRN FPR11001S;
           Select;
           When CSRFLD = 'FPWEEK';
             SelFPWEEK =  FPWEEK ;
             Load01();
           When CSRFLD = 'FPDATE';
             SelFPDATE =  FPDATE ;
             Load01();
           When CSRFLD = 'FPCUST';
             SelCUST   =  FPCUST ;
             Load01();
           When CSRFLD = 'ITEMSIZE';
             SelITEM   =  FPITEM ;
             SelSIZE   =  FPSIZE ;
             Load01();
           When CSRFLD = 'INVPROJ';
             InvTrans(FPITEM:FPSIZE);
           Other;
             FindItem(%Trim(FPITEM) + ' ' +
                      %Trim(FPSIZE) + ' ' +
                      %Trim(%Char(FPPLTG)) + ' ' +
                      %Trim(%Char(FPCUST)));
             *In28 = *On;
             *In41 = In41;
             *In42 = In42;
             *In43 = In43;
             *In52 = In52;
             *In53 = In53;
             *In54 = In54;
    ?        Update FPR11001S;
             *In28 = *Off;
           EndSl;
         Other;
         EndSl;
         Scrn01();
      /End-Free
     P Mouse01         E

      //_____________________________________________________________________
      //

     P UpdS01          B
     D UpdS01          PI
      /Free
        For X = 1 to 9999;
          Chain X FPR11001S;
          If %Found(FPR110FM);
            // Do Something
            Select;
              When *In07;
                SELPOST = 'Y';
              When *In08;
                SELPOST = ' ';
              When *In09;
                If SELPOST = ' ';
                  SELPOST = 'Y';
                 Else;
                  SELPOST = ' ';
                EndIf;
            EndSl;
            *In28 = *On;
            *In41 = IN41;
            *In42 = IN42;
            *In43 = IN43;
            *In52 = In52;
            *In53 = In53;
            *In54 = In54;
            Update FPR11001S;
            *In28 = *Off;
           Else;
            X = 9999;
          EndIf;
        EndFor;
      /End-Free
     P UpdS01          E

      //_____________________________________________________________________
      //

     P SflS01          B
     D SflS01          PI
      /Free
         If RRN01 > 0;
           Now = $Now();
           ReadC FPR11001S;
           Dow not %EOF(FPR110FM);
             // Edit Subfile Changes
             If FPCUST = 0;
               If FPPLTG = 0;
                 Trans_Desc = 'Production Confirmed-KP';
                Else;
                 Trans_Desc = 'Production Confirmed-Pltg:'+%Char(FPPLTG);
               EndIf;
              Else;
               Trans_Desc = %SubSt('Production Confirmed-'+ FPCABB:1:30);
             EndIf;
             Select;
               When SELPOST = 'Y' and QTYFOUND  > 0;
                 Post_Y();
               When SELPOST = 'F';
                 Post_F();
               When SELPOST = 'D';
                 Post_D();
             EndSl;
             *In27 = *On;
             *In28 = *On;
             *In41 = IN41;
             *In42 = IN42;
             *In43 = IN43;
             *In52 = In52;
             *In53 = In53;
             *In54 = In54;
             Update FPR11001S;
             *In28 = *Off;
             *In27 = *Off;
             ReadC FPR11001S;
           EndDo;
         EndIf;
      /End-Free
     P SflS01          E


      //_____________________________________________________________________
      //
     P Post_Y          B
     D Post_Y          PI
      /Free
         //  In the "Y" transaction, we are posting what was planting by backing inventory out
         //  of Projections and entering them as Receipts.  We are only eliminating Projections
         //  we have actually produced.  The only change in actual inventory is the amount
         //  produced beyond the projections.

         // Get Projected quantity available to reverse
         //ProjB4 = Get_Proj(FPITEM:FPSIZE);
         ProjB4 = ItemProjection(FPITEM:FPSIZE:FPCUST);

         // Determine Transaction Amounts.
         If ProjB4 >= QTYFOUND ;
           ProjTran = -QTYFOUND ;
           ActlTran = +0;
          else;
           ProjTran = -ProjB4;
           ActlTran = +(QTYFOUND  - ProjB4);
         EndIf;

         // 1. Back out of Projections
         If ProjB4 > 0;
           Proj_Tran(FPITEM:FPSIZE:ProjTran:FPCUST);
         EndIf;

         // 2. Add in Receipts Transactions
         Prod_Tran(FPITEM:FPSIZE:QTYFOUND:FPCUST);

         // 3. Adjust Inventory if needed.
         If ActlTran <> 0;
           Adj_Inv(FPITEM:FPSIZE:ActlTran);
         EndIf;

         // 4. Update FFINPPDTAG record as processed.
         Posted(FPPPD#:QTYFOUND:'Y');

      /End-Free
     P Post_Y          E


      //_____________________________________________________________________
      //
     P Post_F          B
     D Post_F          PI
      /Free
         //  In the "F" transaction, we are posting what was planting by backing everything out
         //  of Projections and entering the new Receipts.
         //  The change in actual inventory might move either direction based on Proj vs. Prod.

         // Get Projected quantity available to reverse
         //ProjB4 = Get_Proj(FPITEM:FPSIZE);
         ProjB4 = ItemProjection(FPITEM:FPSIZE:FPCUST);

         // Determine Transaction Amounts.
         ProjTran = -ProjB4 ;
         ActlTran = +(QTYFOUND  - ProjB4);

         // 1. Back out all of the Projections
         If ProjB4 <> 0;
           Proj_Tran(FPITEM:FPSIZE:ProjTran:FPCUST);
         EndIf;

         // 2. Add in Receipts Transactions
         Prod_Tran(FPITEM:FPSIZE:QTYFOUND:FPCUST);

         // 3. Adjust Inventory if needed.
         If ActlTran <> 0;
           Adj_Inv(FPITEM:FPSIZE:ActlTran);
         EndIf;

         // 4. Update FFINPPDTAG record as processed for Inventory. (Set FPINVT)
         Posted(FPPPD#:QTYFOUND:'F');


      /End-Free
     P Post_F          E


      //_____________________________________________________________________
      //
     P Post_D          B
     D Post_D          PI
      /Free
         //  In the "D" transaction, we are not planting the item.  The quantity entered is backed
         //  out of Projections and removed from inventory (presuming adaquate projections)

         // Get Projected quantity available to reverse
         //ProjB4 = Get_Proj(FPITEM:FPSIZE);
         ProjB4 = ItemProjection(FPITEM:FPSIZE:FPCUST);

         // Determine Transaction Amounts.
         If QTYFOUND > ProjB4;
           QTYFOUND = ProjB4 ;
         EndIf;
         ProjTran = -QTYFOUND ;
         ActlTran = -QTYFOUND ;

         // 1. Back out Projections
         If ProjTran <> 0;
           If FPCUST = 0;
             If FPPLTG = 0;
               Trans_Desc = 'Production Cancelled-KP';
              Else;
               Trans_Desc = 'Production Cancelled-Pltg:'+%Char(FPPLTG);
             EndIf;
            Else;
             Trans_Desc = %SubSt('Production Cancelled-'+ FPCABB:1:30);
           EndIf;
           Proj_Tran(FPITEM:FPSIZE:ProjTran:FPCUST);
         EndIf;

         // 2. Adjust Inventory
         If ActlTran <> 0;
           Adj_Inv(FPITEM:FPSIZE:ActlTran);
         EndIf;

         // 3. Update FFINPPDTAG record as processed.
         Posted(FPPPD#:QTYFOUND:'D');

      /End-Free
     P Post_D          E


      //_____________________________________________________________________
      //
     P Posted          B
     D Posted          PI
     D  #FPPPD#                            Like(FPPPD#)
     D  #QTYFOUND#                         Like(FPQTYACTL)
     D  #PostedFlag                   1A   Const
      /Free

         Exec SQL  // Update FFINPPDTAG record as processed.
           Update FFINPPDTAG
           Set    FPINVT      = :#PostedFlag
             ,    FPQTYCNTD   = :#QTYFOUND#
             ,    FPUSER      =  USER
             ,    FPTIMESTAMP =  Current Timestamp
           Where  FPPPD#      = :#FPPPD#;

      /End-Free
     P Posted          E


      //_____________________________________________________________________
      //
     P Adj_Inv         B
     D Adj_Inv         PI
     D  #ITEM#                             Like(FPITEM)
     D  #SIZE#                             Like(FPSIZE)
     D  #ActlTran                     6S 0
      /Free

           Exec SQL  // Get Item Master Before Image
             Select *
             into  :RMINVT
             from   FMINVT
             Where  IMITEM = :FPITEM
               and  IMSIZE = :FPSIZE;
           USERID     = $User();
           PROGRAM    = 'FPR110';
           PROCEDURE  = 'Adj_Inv - Sel:' + %Trim(SELPOST) ;
           IMAGE      = 'B';  // (B)efore
           TIMESTAMP  = $timestamp();
           Write RMINVTHIST;

           Exec SQL  // Adjust inventory by Actual Amount
             Update FMINVT
             Set    IMQTOH = IMQTOH + :#ActlTran
               ,    IMQTAV = IMQTAV + :#ActlTran
               ,    IMDTLA = :Today
               ,    IMTIME = :Now
               ,    IMUSER = 'FPR110'
             Where  IMITEM = :FPITEM
               and  IMSIZE = :FPSIZE;

           Exec SQL  // Get Item Master After Image
             Select *
             into  :RMINVT
             from   FMINVT
             Where  IMITEM = :FPITEM
               and  IMSIZE = :FPSIZE;
           USERID     = $User();
           PROGRAM    = 'FPR110';
           PROCEDURE  = 'Adj_Inv - Sel:' + %Trim(SELPOST) ;
           IMAGE      = 'A';  // (B)efore
           TIMESTAMP  = $timestamp();
           Write RMINVTHIST;

      /End-Free
     P Adj_Inv         E


      //_____________________________________________________________________
      //
     P Proj_Tran       B
     D Proj_Tran       PI
     D  #ITEM#                             Like(FPITEM)
     D  #SIZE#                             Like(FPSIZE)
     D  #ProjTran#                    6S 0
     D  #CUST#                             Like(FPCUST)
      /Free
           Exec SQL  // Write FTINVT record for Projection reduction.
             INSERT INTO FTINVT  Values
               ( 'A'
               , :#ITEM#
               , :#SIZE#
               , 1
               , ' '
               , ' '
               , 'P'
               , 0
               , ' '
               , ' '
               , :Today
               , :Trans_Desc
               , 'Projections Reduced'
               , :#ProjTran#
               , 'EA'
               , 'Y'
               , 0
               , ' '
               , 0
               , ' '
               , :Today
               , :Now
               , :User
               , ' '
               , ' '
               , 0
               , ' '
               , ' '
               , 0
               , 0
               , 0
               , 0
               , 0
               , :#CUST#
               , 999
               , ' '
               , ' '
               , 0
               , :Today7
               , 0
               , 'PRJ' );
      /End-Free
     P Proj_Tran       E


      //_____________________________________________________________________
      //
     P Prod_Tran       B
     D Prod_Tran       PI
     D  #ITEM#                             Like(FPITEM)
     D  #SIZE#                             Like(FPSIZE)
     D  #QTYFOUND#                         Like(FPQTYACTL)
     D  #CUST#                             Like(FPCUST)
      /Free
         Exec SQL  // Write FTINVT record for Actual Production.
           INSERT INTO FTINVT  Values
             ( 'A'
             , :#ITEM#
             , :#SIZE#
             , 1
             , ' '
             , ' '
             , 'R'
             , 0
             , ' '
             , ' '
             , :Today
             , :Trans_Desc
             , 'Actual Production '
             , :#QTYFOUND#
             , 'EA'
             , 'Y'
             , 0
             , ' '
             , 0
             , ' '
             , :Today
             , :Now
             , :User
             , ' '
             , ' '
             , 0
             , ' '
             , ' '
             , 0
             , 0
             , 0
             , 0
             , 0
             , :#CUST#
             , 999
             , ' '
             , ' '
             , 0
             , :Today7
             , 0
             , 'ADJ' );
      /End-Free
     P Prod_Tran       E


      //_____________________________________________________________________
      //
     P ItemProjection  B
     D ItemProjection  PI            11S 1
     D  #ITEM#                             Like(FPITEM)
     D  #SIZE#                             Like(FPSIZE)
     D  #CUST#                             Like(FPCUST)
     D  #ProjAll#      S             11S 1
      /Free
        // 7/27/2016 - Removed logic to remove projection by customer per Debbie Mazur.

         #PROJAll# = *Zero;
         Exec SQL
           SELECT   sum( FTINVT.ITTQTY)
           INTO    :#PROJALL#
           FROM     ftinvt
           WHERE    FTINVT.ITTYPE = 'P'
             and    FTINVT.ITITEM = :#ITEM#
             and    FTINVT.ITSIZE = :#SIZE#;

         Return #PROJALL#;

      /End-Free
     P ItemProjection  E


      //_____________________________________________________________________
      //
     P Get_Proj        B
     D Get_Proj        PI            11S 1
     D  #ITEM#                             Like(FPITEM)
     D  #SIZE#                             Like(FPSIZE)
     D  #ProjB4#       S             11S 1
      /Free
         ProjB4 = 0;
         // Get Projected to reverse
         Exec SQL // Count Projected
           SELECT  sum(ITTQTY)
           INTO   :#ProjB4#
           FROM    FTINVT
           WHERE   ITITEM = :#ITEM#
             and   ITSIZE = :#SIZE#
             and   ITTYPE = 'P';
         Return #ProjB4#;
      /End-Free
     P Get_Proj        E


      //_____________________________________________________________________
      //
     P isEven          B
     D isEven          PI              N
     D   #number                     10S 0 CONST
     D   #integer      S             10S 0
     D   #decimal      S             15S 5
      /Free

         #decimal = #number / 2;
         #integer = #number / 2;
         if #decimal = #integer;
           Return *On;
          else;
           Return *Off;
         endif;

      /End-Free
     P isEven          E

      //_____________________________________________________________________
      //

    ?D/COPY QFunctDefn,$ErrMsgSP
