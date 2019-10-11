    ?H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:         Sow Confirmation Scanning                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Sep. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program allows item sow on the recip machines to   ?:
      *? : be scanned as having been sow.  Formerly, recip type trays?:
      *? : where marked as sown as soon as they were prefilled.      ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFSOWNBYDT UF   E           K DISK

      *?  LDA
     D                UDS

      *? Fields
     D   AttTimestamp  S                   Like(SBATTT)
     D   First_Time    S                   Like(SBATTT)
     D   Second_Time   S                   Like(SBATTT)
     D   FixType       S              1A                                        ?Type to Fix
     D   FixDate       S               D                                        ?Date to Fix
     D   AttDate       S               D                                        ?Attendance Date
     D   MinusTray     S              4P 0 Inz(-1)                              ?Minus One Tray
     D   PlusTray      S              4P 0 Inz(+1)                              ?Plus One Tray
     D   EMCARD        S              9P 0                                      ?Timecard Number
     D   EMFILE        S              6P 0                                      ?Employee File #
     D   MaxTime       S             15A   Inz('23.59.59.999000')               ?Maximum Time

      *? Function Prototypes
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date8
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?
    ?C     FixKey        SetLL     FSOWNBYDT
    ?C     FixKey        READE     FSOWNBYDT
     C                   DoW       not %EOF(FSOWNBYDT)
     C                   MoveL     SBATTT        AttDate
     C                   If        AttDate <> FixDate
    ?C                   ExSr      Fix
     C                   EndIf
    ?C     FixKey        READE     FSOWNBYDT
     C                   EndDo
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      Fix    - Fix the Bad Record                        :
      *?  :.........................................................:

     C     Fix           BegSR

      * ? Remove Credit from Old Time Record.
     C                   Z-add     SBCARD        EMFILE
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    MINUSTRAY
    ?C                   Parm      FixType       OperType          1
    ?C                   Parm      SBATTT        AttTimestamp
     C                   Eval      First_Time =  AttTimestamp

     C                   Eval      EMFILE = SBCARD
     C                   Eval      EMCARD = SBCARD

    ?C                   Call      '#EMPFILE#'
    ?C                   Parm                    EMCARD
    ?C                   Parm                    EMFILE
    ?C                   Parm                    name             25
      * ? Add Credit to New Time Record.
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm      FixType       OperType
    ?C     SBATTT        Parm      SBTIME        AttTimestamp
     C                   Eval      Second_Time = AttTimestamp
      * ? If normal method doesn't work try looking for Attendance record from end of day.
     C                   If        First_Time = Second_Time
      * ? Remove Credit from Old Time Record.
     C                   Z-add     SBCARD        EMFILE
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    MINUSTRAY
    ?C                   Parm      FixType       OperType          1
    ?C                   Parm      SBATTT        AttTimestamp

     C                   Eval      EMFILE = SBCARD
     C                   Eval      EMCARD = SBCARD

     C                   Move      SBTIME        NewTime          26
     C                   Eval      NewTime = %Replace(MaxTime:NewTime:12:15)
     C                   Move      NewTime       AttTimeStamp

    ?C                   Call      '#EMPFILE#'
    ?C                   Parm                    EMCARD
    ?C                   Parm                    EMFILE
    ?C                   Parm                    name             25
      * ? Add Credit to New Time Record.
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm      FixType       OperType
    ?C     SBATTT        Parm                    AttTimestamp
     C                   Eval      Second_Time = AttTimestamp
     C                   EndIf
      * ? Update produced by record.
    ?C                   Update    RSOWNBY

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *InzSr        BegSR

     C     *Entry        PList
     C                   Parm                    FixType
     C                   Parm                    FixDate

     C     FixKey        KList
     C                   KFld                    FixType
     C                   KFld                    FixDate

    ?C                   Select
    ?C                   When      FixType = 'R'                                 Recip
    ?C                   When      FixType = 'C'                                 Cuttings
    ?C                   When      FixType = 'T'                                 Transplant
    ?C                   When      FixType = 'D'                                 Drum
    ?C                   Other
     C                   Eval      *InLR = *On
     C                   Return
    ?C                   EndSL

     C                   EndSR
