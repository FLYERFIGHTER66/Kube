     H BndDir('*LIBL/KPFUNCTION')
     H DftActGrp(*No)

      *??:````````````````````````````````````````````````````````````:?
      *??:                  Time Clock Function                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  July 2006            ? Kube-Pak Corporation ?    :
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
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
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

     FFMEMPLOY  UF   E           K DISK
     FFMATTEND  UF A E           K DISK

     D  NewStat        S                   Like(EMSTTS)
     D  NewType        S                   Like(EMTYPE)
     D  DATE           S                   Like(ATDATE)
     D  EMPLOYEE       S                   Like(ATFILE)
     D  JOBCODE        S                   Like(ATTYPE)
     D  TIME           S                   Like(ATSTRT)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now

    ?C     EMFILE        Chain     FMEMPLOY
     C                   Eval      EMSTTS = NewStat
     C                   Eval      EMTYPE = NewType
    ?C                   Update    RMEMPLOY

     C                   If        NewStat = 'I'
     C                   ExSr      ClockIN
     C                   Else
     C                   ExSr      ClockOUT
     C                   EndIf

    ?C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      ClockIN - Clock IN function                        :
      *?  :.........................................................:
    ?C     ClockIN       BegSr                                                  ?

      *?  Check to Make Sure user is Clocked out from previous job
     C                   ExSR      ClockOUT
      *?  Create new Attendance Record
     C                   Eval      ATFILE = EMFILE
     C                   Eval      ATCARD = EMCARD
     C                   Eval      ATDATE = Date
     C                   Eval      ATTYPE = EMTYPE
     C                   Eval      ATSTRT = Time
     C                   Eval      ATENDT = Time
     C                   Eval      ATTRAZ = 0
     C                   Eval      ATPROG = '#ATTEND'
     C                   Eval      ATUSER = $User()
     C                   Time                    ATTIME
    ?C                   Write     RMATTEND
    ?C                   EndSR                                                  ?

      *?  ...........................................................
      *?  :      ClockOUT - Clock OUT function                      :
      *?  :.........................................................:
    ?C     ClockOUT      BegSr                                                  ?

    ?C     ClockKey      SetLL     FMATTEND
    ?C     ClockKey2     ReadPE    FMATTEND
     C                   If        not %EOF(FMATTEND) and ATSTRT = ATENDT
     C                   Eval      ATENDT = Time
    ?C                   Update    RMATTEND
     C                   EndIf

    ?C                   EndSR                                                  ?

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    EMFILE
    ?C                   Parm                    NewStat
    ?C                   Parm                    NewType

    ?C     ClockKey      KList                                                  ?
    ?C                   KFld                    Date
    ?C                   KFld                    Employee
    ?C                   KFld                    Time
    ?C*                  KFld                    JobCode
    ?C     ClockKey2     KList                                                  ?
    ?C                   KFld                    Date
    ?C                   KFld                    Employee

     C                   Eval      Employee = EMFILE
     C                   Time                    Date
     C                   Time                    Time

    ?C                   EndSr                                                  ?

