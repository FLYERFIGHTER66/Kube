     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: FPR115.01                                                  :?
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
      *? :  FPR115.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPR115FM  CF   E             WORKSTN
     F                                     SFILE(FPR11501S:RRN01)


      //  Main procedure prototype & interface
     D FPR115          PR                  ExtPgm('FPR115')
     D FPR115          PI

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

     D SQL01_DS        DS
     D  LIST                          6A
     D  SEQ#                          4S 0
     D  LOOK12                       12A
     D  ITEM                         12A
     D  SIZE                          3A
     D  DES1                         30A
     D  TQTY                         15P 5
     D  SQL01_Key                    67A   Overlay(SQL01_DS)

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
     D   LastRcdKey    S             67
     D   LastItemSize  S             15
     D   LastList      S                   Like(LIST)
     D   Trans_Desc    S             30
     D   CUST          S              6S 0
     D   SELSEARCH@    S             +2    Like(SELSEARCH)

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

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
         Write FPR11501;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         *In28 = *Off;  // SFLNXTCHG
         RRN01 = 0;
         SavSelBatch = SelBatch;
         SelPOST  = ' ';
         ProjB4   = 0;
         ProjTran = 0;
         ActlTran = 0;

         SQLState = '00000';
         Clear LastRcdKey;
         SELSEARCH@ = '%' + %Trim(SELSEARCH) + '%';
         DoW SQLState = '00000' and RRN01 < 9999;
           Exec SQL
             SELECT     FMORLS.OLLIST
                  ,     FMORLS.OLSEQ#
                  ,     FMORLS.OLLOOK
                  ,     FTINVT.ITITEM
                  ,     FTINVT.ITSIZE
                  ,     FMINVT.IMDES1
                  ,     sum( FTINVT.ITTQTY )

             Into      :SQL01_DS

             FROM       FTINVT, FMINVT, FMORLS
             WHERE      ITTYPE = 'P'
               and      FTINVT.ITITEM=FMINVT.IMITEM
               and      FTINVT.ITITEM=FMORLS.OLITEM
               and      FTINVT.ITSIZE=FMINVT.IMSIZE
               and      FTINVT.ITSIZE=FMORLS.OLSIZE
               and    ( FMORLS.OLLIST=:SELLIST or :SELLIST = ' ' )
               and    ( FTINVT.ITITEM=:SelITEM or :SelITEM = ' ' )
               and    ( FTINVT.ITSIZE=:SelSIZE or :SelSIZE = ' ' )
               and    ( :SELSEARCH = ' ' or
                        IMDES1 like trim(:SELSEARCH@) or
                        IMLOOK like trim(:SELSEARCH@)   )
               and      FMORLS.OLLIST
                     || Right('0000'||FMORLS.OLSEQ#,4)
                     || FMORLS.OLLOOK
                     || FTINVT.ITITEM
                     || FTINVT.ITSIZE
                     || FMINVT.IMDES1 > :LastRcdKey
             GROUP BY
             FMORLS.OLLIST,
             FMORLS.OLSEQ#,
             FMORLS.OLLOOK,
             FTINVT.ITITEM,
             FTINVT.ITSIZE,
             FMINVT.IMDES1

             HAVING sum( FTINVT.ITTQTY ) <> 0

             ORDER BY
             FMORLS.OLLIST,
             FMORLS.OLSEQ#,
             FMORLS.OLLOOK,
             FTINVT.ITITEM,
             FTINVT.ITSIZE,
             FMINVT.IMDES1
             Fetch First Row Only;
           LastRcdKey = SQL01_Key;
           If ITEM + SIZE <> LastItemSize;
             *In41 = not *In41;
             LastItemSize = ITEM + SIZE;
           EndIf;
           If LIST <> LastList;
             *In42 = not *In42;
             LastList = LIST;
           EndIf;
           *In43 = *Off;

           If SQLState = '00000';
             RRN01 += 1;
             In41  = *In41;
             In42  = *In42;
             In43  = *In43;
             ITEMSIZE = %Trim(ITEM) + ' (' + %Trim(SIZE) +')';
             SPROJ = TQTY;
             PROJ_ADJ = -TQTY;
             DESC  = DES1;
             TRAN_R = 0;
             TRAN_A = 0;
             TRAN_I = 0;
             IMQTOH = 0;
             IMQTAV = 0;

             Exec SQL SELECT sum(ITTQTY) INTO :TRAN_R FROM ftinvt
              WHERE ITTYPE = 'R' and ITITEM = :ITEM and ITSIZE = :SIZE ;
             Exec SQL SELECT sum(ITTQTY) INTO :TRAN_A FROM ftinvt
              WHERE ITTYPE = 'A' and ITITEM = :ITEM and ITSIZE = :SIZE ;
             Exec SQL SELECT sum(ITTQTY) INTO :TRAN_I FROM ftinvt
              WHERE ITTYPE = 'I' and ITITEM = :ITEM and ITSIZE = :SIZE ;
             Exec SQL SELECT sum(IMQTOH) INTO :IMQTOH FROM fminvt
              WHERE  IMITEM = :ITEM and IMSIZE = :SIZE ;
             Exec SQL SELECT sum(IMQTAV) INTO :IMQTAV FROM fminvt
              WHERE  IMITEM = :ITEM and IMSIZE = :SIZE ;
             //INVPROJ = ItemProjection(ITEM:SIZE:FPCUST);
             ERROR = ( SPROJ + TRAN_R + TRAN_A - TRAN_I ) - IMQTOH;
             In41 = *IN41;
             In42 = *IN42;
             In43 = *IN43;
             Write FPR11501S;
             *In26 = *On;
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
         write FPR11501F;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt FPR11501;
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
    ?      When *In22;  //Right Mouse Click
             Mouse01();
    ?      When *In23;  //Delete Line (i.e. Convert all Projections to Adjustments)
             DelLine();
             Scrn01();
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
         When CSRFLD = 'SELITEM';
           SelITEM = *Blanks;
           Load01();
         When CSRFLD = 'SELSIZE';
           SelSIZE = *Blanks;
           Load01();
         When CSRFLD = 'SELLIST';
           SelLIST = *Blanks;
           Load01();
         When CSRFLD = 'SELSIZE';
           SELSIZE = *Blanks;
           Load01();
         // If no other enabled fields selected see if cursor is on the subfile.
         When CSRRCD = 'FPR11501S';
  ?        Chain SFLCSRRRN FPR11501S;
           Select;
           When CSRFLD = 'ITEMSIZE';
             SelITEM   =  ITEM ;
             SelSIZE   =  SIZE ;
             Load01();
           When CSRFLD = 'LIST';
             SelLIST   =  LIST ;
             Load01();
           When CSRFLD = 'SPROJ'
             or CSRFLD = 'TRAN_R'
             or CSRFLD = 'TRAN_A'
             or CSRFLD = 'TRAN_I';
             InvTrans(ITEM:SIZE);
           Other;
             FindItem(%Trim(ITEM) + ' ' +
                      %Trim(SIZE));
             *In28 = *On;
             *In41 = In41;
             *In42 = In42;
             *In43 = In43;
             *In52 = In52;
             *In53 = In53;
             *In54 = In54;
    ?        Update FPR11501S;
             *In28 = *Off;
           EndSl;
         Other;
         EndSl;
         Scrn01();
      /End-Free
     P Mouse01         E


      //_____________________________________________________________________
      //

     P DelLine         B
     D DelLine         PI
      /Free
         // Check to make sure the user select a subfile record
         If CSRRCD = 'FPR11501S' and SFLCSRRRN <> 0;
  ?        Chain SFLCSRRRN FPR11501S;
           Exec SQL // Convert all Projections to 'A'djustments
             Update  FTINVT
             Set     ITTYPE = 'A'
             WHERE   ITITEM = :ITEM
               and   ITSIZE = :SIZE
               and   ITTYPE ='P'  ;
           *In28 = *On;
           *In41 = In41;
           *In42 = In42;
            IN43 = *On;
           *In43 = In43;
  ?        Update FPR11501S;
            IN43 = *Off;
           *In43 = In43;
           *In28 = *Off;
         EndIf;
      /End-Free
     P DelLine         E

      //_____________________________________________________________________
      //

     P UpdS01          B
     D UpdS01          PI
      /Free
        For X = 1 to 9999;
          Chain X FPR11501S;
          If %Found(FPR115FM);
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
            Update FPR11501S;
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
           ReadC FPR11501S;
           Dow not %EOF(FPR115FM);
             // Edit Subfile Changes
             Trans_Desc = 'Projections Removed';
             If SELPOST = 'Y';
               Post_Y();
             EndIf;
             If SELPOST = 'D';
               Post_D();
             EndIf;
             *In27 = *On;
             *In28 = *On;
             *In41 = IN41;
             *In42 = IN42;
             *In43 = IN43;
             *In52 = In52;
             *In53 = In53;
             *In54 = In54;
             Update FPR11501S;
             *In28 = *Off;
             *In27 = *Off;
             ReadC FPR11501S;
           EndDo;
         EndIf;
      /End-Free
     P SflS01          E


      //_____________________________________________________________________
      //
     P Post_Y          B
     D Post_Y          PI
      /Free

         Proj_Tran(ITEM:SIZE:PROJ_ADJ);
         Adj_Inv(ITEM:SIZE:PROJ_ADJ);

      /End-Free
     P Post_Y          E


      //_____________________________________________________________________
      //
     P Post_D          B
     D Post_D          PI
      /Free

         Exec SQL // Convert all Projections to 'A'djustments
           Update  FTINVT
           Set     ITTYPE = 'A'
           WHERE   ITITEM = :ITEM
             and   ITSIZE = :SIZE
             and   ITTYPE ='P'  ;
         IN43 = *On;

      /End-Free
     P Post_D          E


      //_____________________________________________________________________
      //
     P Adj_Inv         B
     D Adj_Inv         PI
     D  #ITEM#                       12A   CONST
     D  #SIZE#                        3A   CONST
     D  #ActlTran                     5P 0
      /Free
           Exec SQL  // Adjust inventory by Actual Amount
             Update FMINVT
             Set    IMQTOH = IMQTOH + :#ActlTran
               ,    IMQTAV = IMQTAV + :#ActlTran
               ,    IMDTLA = :Today
               ,    IMTIME = :Now
               ,    IMUSER = 'FPR115'
             Where  IMITEM = :ITEM
               and  IMSIZE = :SIZE;
      /End-Free
     P Adj_Inv         E


      //_____________________________________________________________________
      //
     P Proj_Tran       B
     D Proj_Tran       PI
     D  #ITEM#                       12A   CONST
     D  #SIZE#                        3A   CONST
     D  #ProjTran#                    5P 0
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
               , 0
               , 0
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
     P ItemProjection  B
     D ItemProjection  PI            11S 1
     D  #ITEM#                       12A   CONST
     D  #SIZE#                        3A   CONST
     D  #CUST#                        6S 0
     D  #Proj#         S             11S 1
      /Free
         #PROJ# = *Zero;
         If CUST = 0;
           Exec SQL
             SELECT   sum( FTINVT.ITTQTY)
             INTO    :#PROJ#
             FROM     ftinvt
             WHERE    FTINVT.ITTYPE = 'P'
               and    FTINVT.ITITEM = :#ITEM#
               and    FTINVT.ITSIZE = :#SIZE#
               and    FTINVT.ITORD# =  0  ;
          else;
           Exec SQL
             SELECT   sum( FTINVT.ITTQTY)
             INTO    :#PROJ#
             FROM     ftinvt,fhordr
             WHERE    FTINVT.ITORD#=FHORDR.OHORD#
               and    ITDESC like 'Proj:%'
               and    FTINVT.ITTYPE = 'P'
               and    FTINVT.ITITEM = :#ITEM#
               and    FTINVT.ITSIZE = :#SIZE#
               and    FHORDR.OHCUST = :#CUST#;
         EndIf;
         Return #PROJ#;
      /End-Free
     P ItemProjection  E


      //_____________________________________________________________________
      //
     P Get_Proj        B
     D Get_Proj        PI            11S 1
     D  #ITEM#                       12A   CONST
     D  #SIZE#                        3A   CONST
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
