     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: FPR064.01                                                  :?
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
      *? :  FPR064.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPR064FM  CF   E             WORKSTN

      //  Main procedure prototype & interface
     D FPR064          PR                  ExtPgm('FPR064')
     D  #Tag#                         8P 0 const
     D FPR064          PI
     D  #Tag#                         8P 0 const

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D Updt01          PR

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
     D   SelTag        S                   Like(FPPPD#)
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
               SelTag = #Tag#;
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
      /Free

           Exec SQL
             SELECT     *
             Into      :FFINPPDTAG_DS
             FROM       FFINPPDTAG
             WHERE      FPPPD#  = :SelTag;

      /End-Free
     P Load01          E

      //_____________________________________________________________________
      //

     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt FPR06401;
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
             SelTag = #Tag#;
             Load01();
             Scrn01();
           Other;         // Process Scan and Subfile
             Updt01();
             *InLR = *On;
         EndSl;
      /End-Free
     P Edit01          E

      //_____________________________________________________________________
      //

     P Updt01          B
     D Updt01          PI
      /Free

         Exec SQL // Update FFINPPDTAG record
          Update FFINPPDTAG
             Set  FPITEM      = :FPITEM
               ,  FPSIZE      = :FPSIZE
               ,  FPDESC      = :FPDESC
               ,  FPPLTG      = :FPPLTG
               ,  FPCUST      = :FPCUST
               ,  FPCABB      = :FPCABB
               ,  FPSHIP      = :FPSHIP
               ,  FPQTYPROJ   = :FPQTYPROJ
               ,  FPUSER      =  user
               ,  FPTIMESTAMP =  current timestamp
          Where   FPPPD#      = :SelTag;

      /End-Free
     P Updt01          E

      //_____________________________________________________________________
      //

    ?D/COPY QFunctDefn,$ErrMsgSP
