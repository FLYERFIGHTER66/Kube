     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Purge FDLOT                                        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   Purge Program - FDLOT                                    :
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
      *? :  QCmdExc     -?Run an OS/400 command                      ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFDLOTRDY  UF   E           K DISK    UsrOpn                               ?Tray File by Ready

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0001) CtData                     ?System Commands

      *? Field Definitions
     D   DaysBack      S              7S 0 Inz(*Zeros)                          ???? days ago
     D   Command       S            100A   Inz(*Blanks)                         ?System Command

    ?C     DaysBack      SetGt     FDLOTRDY
    ?C                   ReadP     FDLOTRDY

     C                   DoW       not %EOF(FDLOTRDY)

     C                   If        LRITEM <> '2786' and                         |DRACAENA:SPIKES
     C                             LRITEM <> '5834' and                         |VINCA VINE:WOJO'S
     C                             LRITEM <> '8023' and                         |VINCA VINE:MAJ MAC
     C                             LRITEM <> '5832'                             |VINCA VINE:MAJ VAR
    ?C                   Delete    RDLOTRD
     C                   EndIf

    ?C                   ReadP     FDLOTRDY

     C                   EndDo                                                  ?

     C                   If        %Open(FDLOTRDY)
    ?C                   Close     FDLOTRDY
     C                   EndIf

     C                   Eval      Command = Cmd(1)
     C                   ExSr      $Command
     C                   Eval      *InLR = *On


      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
    ?C     $Command      BegSR

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

    ?C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Eval      DaysBack = $Date7($AddDate($Date(0):-28))

     C                   If        not %Open(FDLOTRDY)
    ?C                   Open      FDLOTRDY
     C                   EndIf

    ?C                   EndSr                                                  ?
**
RGZPFM FILE(*LIBL/FDLOTRD)
