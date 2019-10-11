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

    ?c/exec sql
    ?c+
    ?c+    UPDATE    FMATTEND
    ?c+    SET       ATENDT = :TimeOut
    ?c+    WHERE     ATDATE = :DateWorked
    ?c+      and     ATSTRT = ATENDT
    ?c+      and     ( ATTYPE = :JobType or :JobType = ' ' )
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    DateWorked
    ?C                   Parm                    TimeOut
    ?C                   Parm                    JobType

    ?C                   EndSr                                                  ?

