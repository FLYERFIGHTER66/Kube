     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Purge two day old records from FIORDRWK            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program clears the FIORDRWK file of records where  ?:
      *? : the ship Date is more than two days old.                  ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  $Command    -?Run System Command                         ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  $Date       -?Returns a date field value                 ?:
      *? :  $Date7      -?Obtain an 7 digit number date in CYYMMDD   ?:
      *? :  $AddDate    -?Adds given number of days to given date    ?:
      *? :  QCmdExc     -?Run an OS/400 command                      ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFIORDRL9  UF   E           K DISK    UsrOpn                               ?Future Release Orde

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0001) CtData                     ?System Commands

      *? Field Definitions
     D   TwoDaysAgo    S              7S 0 Inz(0)                               ?Two Days Ago
     D   Command       S            100A   Inz(*Blanks)                         ?System Command

     C     TwoDaysAgo    SetGt     FIORDRL9
     C                   ReadP     FIORDRL9

     C                   DoW       not %EOF(FIORDRL9)                           ?
     C                   Delete    RIORDRWK

     C                   ReadP     FIORDRL9

     C                   ENDDO                                                  ?

     C                   If        %Open(FIORDRL9)
     C                   Close     FIORDRL9
     C                   EndIf

     C                   Eval      Command = Cmd(1)
     C                   ExSr      $Command
     C                   Eval      *InLR = *On


      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

     C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Eval      TwoDaysAgo = $Date7($AddDate($Date(0):-2))   ?Two Days Ago
     C                   If        not %Open(FIORDRL9)
     C                   Open      FIORDRL9
     C                   EndIf

    ?C                   EndSr                                                  ?
**
RGZPFM FILE(*LIBL/FIORDRWK)
