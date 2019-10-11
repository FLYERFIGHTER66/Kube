     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: FPR120.01                                                  :?
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
      *? :  FPR120.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPR120FM  CF   E             WORKSTN
     F                                     SFILE(FPR12001S:RRN01)


      //  Main procedure prototype & interface
     D FPR120          PR                  ExtPgm('FPR120')
     D FPR120          PI

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR

     D FindItem        PR                  ExtPgm('FPR055')
     D  #Find#                       20A   CONST

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


      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   RRN01         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 03
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Now           S              6S 0 Inz(0)                               ?Time Now
     D   Today         S              6S 0 Inz(0)                               ?Today
     D   Today7        S              7S 0 Inz(0)                               ?Today YMD7
     D   Pink          S              1A   Inz('?')                             ?Color Code -?PINK
     D   White         S              1A   Inz('?')                              Color Code - White
     D   LastFPPPD#    S              6S 0
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
     D   IN52          S               N   Inz(*Off)
     D   DEC155        S             15P 5 Inz(0)

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
               SelCstm  = 'B';
               *In51 = *Off;  // Sort by PPD #
               Exec SQL  // Get Latest Week...
                 SELECT     Max(FPWEEK)
                 Into      :SelFPWEEK
                 FROM       FFINPPDTAG
                 WHERE      FPPRTD <> 'D';
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
         Write FPR12001;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         *In28 = *Off;  // SFLNXTCHG
         RRN01 = 0;
         LastFPPPD# = *Zero;
         ProjB4   = 0;
         ProjTran = 0;
         ActlTran = 0;
         Clear DEC155;
         Exec SQL
           SELECT     dec(sum(FPQTYACTL))/dec(sum(FPQTYPROJ))
           Into      :DEC155
           FROM       FFINPPDTAG
           WHERE      FPPRTD <> 'D'
             and  (   date(FPWEEK)  = date(:SelFPWEEK)
                  or :SelFPWEEK = :DftDate2 );
         PctDone = DEC155 * 100;

         SQLState = '00000';
         Clear LastRcdKey;
         DoW SQLState = '00000';
           If not *In51;  // Sort by PPD Tag#
             Exec SQL
               SELECT     *
               Into      :FFINPPDTAG_DS
               FROM       FFINPPDTAG
               WHERE      FPPRTD <> 'D'
                 and      FPPPD#  > :LastFPPPD#
                 and  (   date(FPWEEK)  = date(:SelFPWEEK)
                      or :SelFPWEEK = :DftDate2 )
                 and  (   FPITEM  = :SelITEM
                      or :SelITEM =  ' ' )
                 and  (   FPSIZE  = :SelSIZE
                      or :SelSIZE =  ' ' )
                 and  (   FPCUST  = :SelCUST
                      or :SelCUST =  0   )
                 and  (  (FPCUST  = 0 and :SelCstm = 'N')
                      or (FPCUST <> 0 and :SelCstm = 'Y')
                      or :SelCstm = 'B' )
                 and  (   FPQTYACTL < FPQTYPROJ or :IN52 = '1')
               order by   FPPPD#
               Fetch First Row Only;
             *In41 = isEven(RRN01);
            else;
             Exec SQL
               SELECT     *
               Into      :FFINPPDTAG_DS
               FROM       FFINPPDTAG
               WHERE      FPPRTD <> 'D'
                 and      FPSIZE ||
                          FPITEM ||
                          FPPLTG ||
                          FPCUST ||
                          char(FPTIMESTAMP)  > :LastRcdKey
                 and  (   date(FPWEEK)  = date(:SelFPWEEK)
                      or :SelFPWEEK = :DftDate2 )
                 and  (   FPITEM  = :SelITEM
                      or :SelITEM =  ' ' )
                 and  (   FPSIZE  = :SelSIZE
                      or :SelSIZE =  ' ' )
                 and  (   FPCUST  = :SelCUST
                      or :SelCUST =  0   )
                 and  (  (FPCUST  = 0 and :SelCstm = 'N')
                      or (FPCUST <> 0 and :SelCstm = 'Y')
                      or :SelCstm = 'B' )
                 and  (   FPQTYACTL < FPQTYPROJ or :IN52 = '1')
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
             ITEMSIZE = %Trim(FPITEM) + '-' + %Trim(FPSIZE);
             If FPCUST <> 0;
               CSTMYN = 'Y';
              Else;
               CSTMYN = ' ';
             EndIf;
             In41 = *IN41;
             Write FPR12001S;
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
         write FPR12001F;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt FPR12001;
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
             Load01();
             Scrn01();
           When *In07;                 // Select All
             *In52 = not *In52;
             IN52 = *In52;
             Load01();
             Scrn01();
           When *In08;                 // - Week
             SELFPWEEK = $AddDate(SELFPWEEK:-7);
             Load01();
             Scrn01();
           When *In09;                 // + Week
             SELFPWEEK = $AddDate(SELFPWEEK:+7);
             Load01();
             Scrn01();
           When *In10;                 // Change Sort
             *In51 = not *In51;
             Load01();
             Scrn01();
    ?      When *In22;  //Left Mouse Click - Find Records
    ?        Chain SFLCSRRRN FPR12001S;
             FindItem(%Trim(FPITEM) + ' ' +
                      %Trim(FPSIZE));
             *In28 = *On;
             *In41 = In41;
    ?        Update FPR12001S;
             *In28 = *Off;
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

     P UpdS01          B
     D UpdS01          PI
      /Free
      /End-Free
     P UpdS01          E

      //_____________________________________________________________________
      //

     P SflS01          B
     D SflS01          PI
      /Free
      /End-Free
     P SflS01          E


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
