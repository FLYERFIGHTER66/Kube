    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*no)
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:       Balance Sow Schedule to Tray Files                   :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jan  2006            ? Kube-Pak Corporation ?    :
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
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFSOWSCHJR UF   E           K DISK                                         ?Sow Job Schedule

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate

      *? Arrays
    ?D*...None...

      *? Field Definitions
     D   SowDate@      S              7A                                        ?Sow Date
     D   SowDate       S              7S 0                                      ?Sow Date
     D   SowJob#@      S              4A                                        ?Job Number
     D   SowJob#       S              4S 0                                      ?Job Number
     D   SowItem       S              4A                                        ?Item@
     D   SowSize       S              3A                                        ?Size@
     D   Today7        S              7S 0                                      ?Today CYMD
     D   FTRAY_CNT     S              6S 0                                      ?Count FTRAY
     D   FTRAYR_CNT    S              6S 0                                      ?Count FTRAYR

      *? Indicators
     D  EndOfFile      S               N   INZ(*Off)


    ?C     SowDateJob    SetLL     FSOWSCHJR
    ?C     SowDateJob    KList
    ?C                   KFld                    SowDate
    ?C                   KFld                    SowJob#
    ?C     SowDate       ReadE     FSOWSCHJR
    ?C                   If        %EOF(FSOWSCHJR)
     C                   Eval      *In99 = *On
     C                   EndIf
    ?C                   DoW       not %EOF(FSOWSCHJR)
    ?C                             and (SowJob# = 0 or SowJob# = SOJOB#)
     C                   If        (SowItem = *Blanks or SowItem = SOITEM) and
     C                             (SowSize = *Blanks or SowSize = SOSIZE)
     C                   ExSr      GetSown
     C                   If           SOSOWQ <> FTRAY_CNT
     C                             or SOSOWL <> FTRAY_CNT + FTRAYR_CNT
     C                   Eval      SOSOWQ =  FTRAY_CNT
     C                   Eval      SOSOWL =  FTRAY_CNT + FTRAYR_CNT
     C                   Eval      SODTLA = $MDYDate($Date(0))
     C                   Eval      SOTIME = $Now()
     C                   Eval      SOUSER = 'SOW037'
    ?C                   Update    RSowSch
     C                   EndIf
     C                   EndIf
    ?C     SowDate       ReadE     FSOWSCHJR
    ?C                   EndDo                                                  ?

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      GetSown - Get quantity of tags Sown                :
      *?  :.........................................................:
    ?C     GetSown       BegSr                                                  ?

      *? Count Selected trays from FTRAYR & FTRAY
    ?c/exec sql
    ?c+
    ?c+    SELECT      count(*)
    ?c+
    ?c+    INTO        :FTRAY_CNT
    ?c+
    ?c+    FROM        FTRAY as Tray
    ?c+
    ?c+    WHERE       Tray.TRJOB# = :SOJOB#
    ?c+      and       Tray.TRSCYM = :SOSOWD
    ?c+      and       Tray.TRSTAT <> 'D'
    ?c+      and       Tray.TRSTAT <> ' '
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    SELECT      count(*)
    ?c+
    ?c+    INTO        :FTRAYR_CNT
    ?c+
    ?c+    FROM        FTRAYR as TrayR
    ?c+
    ?c+    WHERE       TrayR.TRJOB# = :SOJOB#
    ?c+      and       TrayR.TRSCYM = :SOSOWD
    ?c+      and       TrayR.TRSTAT <> 'D'
    ?c+      and       TrayR.TRSTAT <> ' '
    ?c+
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

      *?  WHEN CALLING THIS PROGRAM...
      *?  If you provide a week and job number, only that week/job is effected.
      *?  If you provide a week and no job number, the entire week is effected.
      *?  If you do not provide a week nor a job number, the entire current week is effected.
      *?  If you do not provide a week, but a job number is provided,
      *?     the job number for the current week is processed.
      *?  Item and Size may also be included...
      *?     If a Job# is provided, only that job number is processed
      *?     If a Job# is not provided, the week is processed for the item and/or size passed.

    ?C     *Entry        PList
    ?C                   Parm                    SowDate@
    ?C                   Parm                    SowItem
    ?C                   Parm                    SowSize
    ?C                   Parm                    SowJob#@

     C                   If        SowJob#@ <> ' '
     C                   Eval      SowJob# = %Int(SowJob#@)
     C                   EndIf

     C                   If        SowDate@ <> ' '
     C                   Eval      SowDate = %Int(SowDate@)                     ?Use Passed Date
     C                   If        SowJob#@ <> ' '
     C                   Eval      SowJob# = %Int(SowJob#@)                     ?Use Passed Job
     C                   EndIf
     C                   Else
     C                   Eval      Today7  = $Date7($Date(0))                   ?Use Default Date
     C                   If        SowJob#@ <> ' '
     C                   Eval      SowJob# = %Int(SowJob#@)                     ?Use Passed Job
     C                   EndIf
     C                   Eval      SowJob# = *Zero                              ?No Date => No Job
    ?c/exec sql
    ?c+
    ?c+    SELECT      max(SOSOWD)
    ?c+    INTO        :SowDate
    ?c+    FROM        FSOWSCH
    ?c+    WHERE       SOSOWD <= :Today7
    ?c+
    ?c/end-exec
     C                   EndIf

    ?C                   EndSr                                                  ?
