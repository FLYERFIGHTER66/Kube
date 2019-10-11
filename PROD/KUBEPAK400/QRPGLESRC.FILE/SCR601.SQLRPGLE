    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:         Prompt fot R.B. Rotation Program                   :?
      *??:............................................................:?

     FSCR601FM  CF   E             WORKSTN

      //  Main procedure prototype & interface
     D SCR601          PR                  ExtPgm('SCR601')
     D SCR601          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$ChgPrt
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$isPrinter

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

      *? Field Definitions
     D  Screen         S              3S 0 Inz(0)                               ?Screen Number
     D  SDate7         S              7S 0 Inz(0)                               ?Ship Date YMD7
     D  SMaster#       S              2S 0 Inz(0)                               ?Master #
     D  Pink           S              1A   Inz('?')                             ?Color Code -?PINK
     D  White          S              1A   Inz('?')                              Color Code - White
     D  ShipDate       S              7S 0

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:

      /Free
         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
               Edit01();
             Other;
               *In26 = *On;
               $ERR_PROG = $PGM;
               Exec SQL  SELECT max(PSLOCD) into :SDATE7  FROM FPLGSCTL;
               SDATE6 = $MDYDate($Date(SDATE7));
               Exec SQL  SELECT max(PSLOCM) into :SMASTER FROM FPLGSCTL;
               Load01();
               Scrn01();
               *In26 = *Off;
           ENDSL;
         ENDDO;

         *InLR = *On;

      /End-Free

      //_____________________________________________________________________
      //
     P Load01          B
     D Load01          PI
      /Free
         Printer = $DftPrt('*NONE':'SCR600':'*PGM');
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
         exfmt SCR60101;
         $ClrError();
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
      // Prototype for Report Program
    ?D SCR600          PR                  ExtPgm('SCR600')
     D  #SDATE7                       7S 0
     D  #SMASTER                      2S 0
     D  #PRINTER                     10
      /Free

         Select;
           When *In03;
             *InLR = *On;
           When *In11;
             PRINTER = $ChgPrt($User():'SCR600':PRINTER);
             Scrn01();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn01();
           When not $isDate#(SDATE6:'*MDY');
             $SndError('DATE901':%EditC(SDATE6 :'4'));
             Scrn01();
           Other;
             SDATE7 = $Date7($DateMDY(SDATE6 ));
             SMaster# = SMaster;
             CallP SCR600(SDATE7:SMASTER#:Printer);
             *InLR = *On;
         EndSl;
      /End-Free
     P Edit01          E
      //_____________________________________________________________________
      //
    ?D/COPY QFunctDefn,$ErrMsgSP
