     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:   Put Att.Timestamp on FTRAYFIXED where missing            :?
      *??:............................................................:?

     FFSOWNBYL1 UP   E           K DISK
     FFMATTEND  UF A E           K DISK

     D  ZeroTrays      S              4P 0 Inz(0)                               ?Zero Trays
     D  File#          S              6P 0 Inz(0)                               ?File Number
     D  DATE           S               D
     D  TIME           S               T
     D  JobCode        S              1A   Inz('T')

      *? Function Prototypes
    ?D/COPY QFunctDefn,$AddDate

     C                   Eval      File# = SBCARD

    ?C                   ExSR      UserTray

    ?C                   Update    RSOWNBY

      *?  ...........................................................
      *?  :      UserTray - Put User Timestamp On Tray              :
      *?  :.........................................................:
    ?C     UserTray      BegSr                                                  ?

     C                   Move      SBTIME        Date
     C                   Move      '23.59.59'    Time
    ?C     ClockKey      SetLL     FMATTEND
    ?C     ClockKey2     ReadPE    FMATTEND
     C                   If        not %EOF(FMATTEND) and
     C                             ATTYPE = JobCode
     C                   Eval      SBATTT = ATTIME
    ?C                   LeaveSr                                               ?
     C                   EndIf
    ?C                   ExSr      FindPrior                                    ?

    ?C                   EndSR                                                  ?

      *?  ...........................................................
      *?  :      FindPrior - Find Prior time record                 :
      *?  :.........................................................:
    ?C     FindPrior     BegSr                                                  ?

     C                   Do        5
     C                   DoW       Not %EOF(FMATTEND)   and
     C                             SBCARD = ATFILE
     C                   If        ATTYPE = JobCode
     C                   Eval      SBATTT = ATTIME
     C                   LeaveSR
     C                   EndIf
    ?C     ClockKey2     ReadPE    FMATTEND
     C                   EndDo
     C                   Eval      Date = $AddDate(Date:-1)
     C                   Move      '23.59.59'    Time
    ?C     ClockKey      SetLL     FMATTEND
    ?C     ClockKey2     ReadPE    FMATTEND
     C                   EndDo

    ?C                   EndSR                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     ClockKey      KList                                                  ?
    ?C                   KFld                    Date
    ?C                   KFld                    File#
    ?C                   KFld                    Time
    ?C     ClockKey2     KList                                                  ?
    ?C                   KFld                    Date
    ?C                   KFld                    File#

    ?C                   EndSr                                                  ?

