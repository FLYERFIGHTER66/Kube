     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: FPR063.01                                                  :?
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
      *? :  FPR063.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPR063FM  CF   E             WORKSTN
     F                                     SFILE(FPR06301S:RRN01)


      //  Main procedure prototype & interface
     D FPR063          PR                  ExtPgm('FPR063')
     D  #Batch                        6P 0 const
     D FPR063          PI
     D  #Batch                        6P 0 const

     D PrintLabel      PR                  ExtPgm('FPR067')
     D  #PPD#                         8P 0 const
     D  #Printer                     10A   const

     D EditLabel       PR                  ExtPgm('FPR064')
     D  #PPD#                         8P 0 const

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR

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
     D   ADRX          S              1S 0 Inz(0)                               ?Address Index
     D   OVRPRTF       S            256A   Inz(' ')                             ?Override PRTF
     D   Order#        S              6S 0
     D   SelBatch      S              6S 0
     D   LastFPPPD#    S              6S 0
     D   SavSELBATCH   S              6S 0
     D   OrdTimeStamp  S               Z
     D   CstmProj      S             30A
     D   User          S             10A
     D   X             S              5S 0 Inz(0)

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
               SelBatch = #Batch;
               Printer = $DftPrt('*NONE':'FPR063':'*PGM');
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
         Write FPR06301;
         *In26 = *Off;  // Empty Subfile
         *In80 = *Off;
         *In28 = *Off;  // SFLNXTCHG
         RRN01 = 0;
         LastFPPPD# = *Zero;
         SavSelBatch = SelBatch;

         SQLState = '00000';
         DoW SQLState = '00000';
           Exec SQL
             SELECT     *
             Into      :FFINPPDTAG_DS
             FROM       FFINPPDTAG
             WHERE      FPBAT#  = :SelBatch
               and      FPPPD#  > :LastFPPPD#
             order by   FPPPD#
             Fetch First Row Only;

           If SQLState = '00000';
             RRN01 += 1;
             *In41 = isEven(RRN01);
              In41 = *In41;
              ITEMSIZE = %Trim(FPITEM) + '(' + %Trim(FPSIZE) + ')';
             Write FPR06301S;
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
         write FPR06301F;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt FPR06301;
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
             SelBatch = #Batch;
             Load01();
             Scrn01();
           When *In06;                 // Reprint
             Chain SFLCSRRRN FPR06301S;
             If %Found();
               PrintLabel(FPPPD#:Printer);
             EndIf;
             Scrn01();
           When *In10;                 // Change PPD Tag Info
             Chain SFLCSRRRN FPR06301S;
             If %Found();
               EditLabel(FPPPD#);
             EndIf;
             Load01();
             Scrn01();
           When *In11;                 // Change Printer
             PRINTER = $ChgPrt($User():'FPR063':PRINTER);
             Load01();
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

     P UpdS01          B
     D UpdS01          PI
      /Free
        For X = 1 to 9999;
          Chain X FPR06301S;
          If %Found(FPR063FM);
            // Do Something
            *In28 = *On;
            *In41 = IN41;
            Update FPR06301S;
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
           ReadC FPR06301S;
           Dow not %EOF(FPR063FM);
             // Edit Subfile Changes
             *In27 = *On;
             *In28 = *On;
             Update FPR06301S;
             *In28 = *Off;
             *In27 = *Off;
             ReadC FPR06301S;
           EndDo;
         EndIf;
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
