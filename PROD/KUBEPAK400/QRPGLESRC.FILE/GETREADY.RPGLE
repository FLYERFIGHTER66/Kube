    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         GET RDY DATE FROM SOW DATE                         :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Nov. 2008            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :          ?                                                ?:
      *? :............................................................:
      *
     FFMINVT    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY


      *? Field Definitions
     D   Start         S               D                                        ?Starting Date
     D   X             S              2S 0                                      ?Counter

RED |C     ITMKEY        Chain     FMINVT

     C                   Z-Add     99            LowGerm           2 0
     C                   Z-Add     00            MaxGerm           2 0
     C                   Z-Add     00            SowDat

     C                   If        IMWG1 <> *Zero and IMWG1 < LowGerm
     C                   Eval              LowGerm =  IMWG1
     C                   EndIf
     C                   If        IMWG2 <> *Zero and IMWG2 < LowGerm
     C                   Eval              LowGerm =  IMWG2
     C                   EndIf
     C                   If        IMWG3 <> *Zero and IMWG3 < LowGerm
     C                   Eval              LowGerm =  IMWG3
     C                   EndIf
     C                   If        IMWG4 <> *Zero and IMWG4 < LowGerm
     C                   Eval              LowGerm =  IMWG4
     C                   EndIf

     C                   If        IMWG1 <> *Zero and IMWG1 > MaxGerm
     C                   Eval              MaxGerm =  IMWG1
     C                   EndIf
     C                   If        IMWG2 <> *Zero and IMWG2 > MaxGerm
     C                   Eval              MaxGerm =  IMWG2
     C                   EndIf
     C                   If        IMWG3 <> *Zero and IMWG3 > MaxGerm
     C                   Eval              MaxGerm =  IMWG3
     C                   EndIf
     C                   If        IMWG4 <> *Zero and IMWG4 > MaxGerm
     C                   Eval              MaxGerm =  IMWG4
     C                   EndIf

     C                   If           LowGerm = 99
     C                             or MaxGerm = 0
     C                             or Not %Found(FMINVT)
     C                   Eval      REQDAT = SOWDATIn
RED |C                   Return
     C                   EndIf

     C                   Eval      X = LowGerm
     C                   Eval      Start = $Date(SOWDATIn)

    ?C                   DoU       X > MaxGerm + 1 or SOWDAT = SOWDATIn

     C                   Eval      REQDAT = $Date7($AddDate(Start:X*7))
RED |C                   CALL      'GETGERM'     GETGERM
     C                   Eval      X = X + 1

    ?C                   EndDo

     C                   Return


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *ENTRY        PList                                                  ?
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    REQDAT            7 0          CYMD
    ?C                   Parm                    SOWDATIn          7 0          CYMD

    ?C     GETGERM       PList
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    REQDAT            7 0          CYMD
    ?C                   Parm                    SOWDAT            7 0          CYMD

    ?C     LKITAL        PList
    ?C                   Parm                    IMLOOK
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    IMDES1
    ?C                   Parm                    IMDES2
    ?C                   Parm                    IMDES3
    ?C                   Parm                    IMDES4
    ?C                   Parm                    SHPFR             3

    ?C     ITMKEY        KLIST
    ?C                   KFLD                    IMITEM
    ?C                   KFLD                    IMSIZE
    ?C                   KFLD                    IMWHSE

    ?C                   EndSr                                                  ?
