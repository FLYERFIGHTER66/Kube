     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Purge FPPO records with no match in FHORDR         :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program clears the FPPO file of records where there?:
      *? : is no match on FHORDR by order #.                         ?:
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
      *? :  QCmdExc     -?Run an OS/400 command                      ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFPPO      UF   E           K DISK    UsrOpn                               ?Order User Info
     FFHORDR    IF   E           K DISK                                         ?Order Header

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0001) CtData                     ?System Commands

      *? Field Definitions
     D   Command       S            100A   Inz(*Blanks)                         ?System Command

    ?C     *LoVal        SetLL     FPPO
    ?C                   Read      FPPO

     C                   DoW       not %EOF(FPPO)
    ?C     POORD#        SetLL     FHORDR
     C                   If        not %Equal(FHORDR)
    ?C                   Delete    RPPO
     C                   EndIF

    ?C                   Read      FPPO

     C                   ENDDO                                                  ?

     C                   If        %Open(FPPO)
    ?C                   Close     FPPO
     C                   EndIf

     C                   Eval      Command = Cmd(1)
     C                   ExSr      $Command
     C                   Eval      *InLR = *On


      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
    ?C     $Command      BegSR

      *? Execute the Command using QCMDEXC.
     C* dont reorg now   CALLP     QCmdExc(Command:%len(%Trim(Command)))

    ?C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   If        not %Open(FPPO)
    ?C                   Open      FPPO
     C                   EndIf

    ?C                   EndSr                                                  ?
**
RGZPFM FILE(*LIBL/FPPO)
