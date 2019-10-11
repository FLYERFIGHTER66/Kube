     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:   Put Att.Timestamp on FCATRDT where missing               :?
      *??:............................................................:?


     D  File#P         S              6P 0 DIM(07)                              ?File Number (Packed
     D  PunchIn        S              1A   Inz('I')
     D  File#          S              6S 0 DIM(07) CTDATA PERRCD(1)             ?File Number
     D  JobCode        S              1A   DIM(07) ALT(File#)
     D  X              S              2S 0 Inz(1)

    ?C     X             Do        7             X
     C                   Eval      File#P(x) = File#(x)
     C                   Call      '#ATTEND'     ATTEND
    ?C                   EndDo

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     Attend        PList                                                  ?
    ?C                   Parm                    File#P(x)
    ?C                   Parm                    PunchIn
    ?C                   Parm                    JobCode(x)

    ?C                   EndSr                                                  ?

**
000000F  NO FIXING - FIXER FLAT
000001V  VACUUMING NOT REQUIRED
000002C  INITIAL PLANTING
000003F  MISSING FIXING LABEL
000004C  MISSING R/C LABEL
000005V  MISSING VACUUM LABEL
000007F  AUTOMATED FIXING
