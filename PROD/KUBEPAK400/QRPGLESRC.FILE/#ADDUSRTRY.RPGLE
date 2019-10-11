    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:               Add a tray to Employee Tray Count            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  August 2006          ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? : Used to keep real time track of tray produced / fixed, etc.:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
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

     FFMATTENDEMUF A E           K DISK

     D  JobCode        S                   Like(ATTYPE)
     D  DATE           S                   Like(ATDATE)
     D  EMPLOYEE       S                   Like(ATFILE)
     D  TIME           S                   Like(ATSTRT)
     D  TrayCount      S                   Like(ATTRAZ)
     D  AttTimestamp   S                   Like(ATTIME)
     D  NoTimeStamp    S                   Like(ATTIME) Inz

      *? Function Prototypes
    ?D*COPY QFunctDefn,$Function
    ?D/COPY QFunctDefn,$TimeStamp

    ?C                   ExSr      CheckStat

     C                   Eval      ATTRAZ = ATTRAZ + TrayCount
    ?C                   Update    RMATTEND
     C                   Eval      AttTimestamp = ATTIME

    ?C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      CheckStat - Check User Status and Job Code         :
      *?  :.........................................................:
    ?C     CheckStat     BegSr                                                  ?

    ?C     ClockKey      SetLL     FMATTENDEM
     C                   If        %Equal(FMATTENDEM)
    ?C                   Read      FMATTENDEM
     C                   Else
    ?C     ClockKey2     ReadPE    FMATTENDEM
     C                   If        %EOF(FMATTENDEM)
    ?C                   Eval      *InLR = *On
    ?C                   Return                                                 ?
     C                   EndIf
     C                   If        ATTYPE <> JobCode
    ?C                   ExSr      FindPrior                                    ?
     C                   EndIf
     C                   EndIf

    ?C                   EndSR                                                  ?

      *?  ...........................................................
      *?  :      FindPrior - Find Prior time record                 :
      *?  :.........................................................:
    ?C     FindPrior     BegSr                                                  ?

     C                   DoW       Not %EOF(FMATTENDEM) and
     C                             Employee = ATFILE
     C*                            and Date = ATDATE
     C                   If        ATTYPE = JobCode
     C                   LeaveSR
     C                   EndIf
    ?C     ClockKey2     ReadPE    FMATTENDEM
     C                   EndDo
    ?C                   Eval      *InLR = *On
    ?C                   Return                                                 ?

    ?C                   EndSR                                                  ?

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    ATFILE
    ?C                   Parm                    TrayCount
    ?C                   Parm                    JobCode
    ?C                   Parm                    AttTimestamp

    ?C     ClockKey      KList                                                  ?
    ?C                   KFld                    Employee
    ?C                   KFld                    Date
    ?C                   KFld                    Time
    ?C     ClockKey2     KList                                                  ?
    ?C                   KFld                    Employee

     C                   Eval      Employee = ATFILE

     C                   If        AttTimestamp = NoTimeStamp
     C                   Eval      AttTimestamp = $TimeStamp()
     C                   Time                    Date
     C                   Time                    Time
     C                   Else
     C                   Move      AttTimestamp  Date
     C                   Move      AttTimestamp  Time
     C                   EndIf

    ?C                   EndSr                                                  ?

