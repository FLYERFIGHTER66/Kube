     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:                  Mass Clock-Out Function                   :?
      *??:............................................................:?

     D  DateWorked     S               D
     D  TimeOut        S               T
     D  JobType        S              1A
     D  Authorized     S               N                                        ?Authorized to Use

     D/Copy QFunctDefn,$isBatch                                                 ?is proc. in batch ?

    ?C                   Call      'ATT030'
    ?C                   Parm                    DateWorked
    ?C                   Parm                    TimeOut
    ?C                   Parm                    JobType
     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    CheckAuth         1
    ?C                   Parm                    JobType

     C                   If        CheckAuth = 'Y'
    ?C                   Call      'ATT040'                                     ?
    ?C                   Parm                    Authorized
     C                   If        not Authorized
     C                   Eval      *InH1 = *On
     C                   Return
     C                   EndIF
     C                   EndIF

     C                   If        not $isBatch and
     C                             JobType = ' '
    ?C                   Call      'XATABLE'
    ?C                   Parm      'JC'          TABID             2
    ?C                   Parm                    #KEYP#            2
    ?C     JobType       Parm                    #EELM#            6
     C                   EndIf

     C                   Time                    DateWorked
     C                   Time                    TimeOut
    ?C                   EndSr                                                  ?

