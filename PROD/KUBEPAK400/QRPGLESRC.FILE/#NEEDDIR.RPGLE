     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:        Determine is Customer Record needs directions       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Feb 2009             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This program is used to determine is we need directions  ?:
      *? :  for a given customer.                                    ?:
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
     FFCMDIR    IF   E             DISK

      *? Field Definitions
     D   #Cust         S              6S 0
     D   #Need         S               N

     C     #Cust         Chain     FCMDIR

     C                   If        CMDR01 +                                     ?DIRECTION LINE 01
     C                             CMDR02 +                                     ?DIRECTION LINE 02
     C                             CMDR03 +                                     ?DIRECTION LINE 03
     C                             CMDR04 +                                     ?DIRECTION LINE 04
     C                             CMDR05 +                                     ?DIRECTION LINE 05
     C                             CMDR06 +                                     ?DIRECTION LINE 06
     C                             CMDR07 +                                     ?DIRECTION LINE 07
     C                             CMDR08 +                                     ?DIRECTION LINE 08
     C                             CMDR09 +                                     ?DIRECTION LINE 09
     C                             CMDR10 +                                     ?DIRECTION LINE 10
     C                             CMDR11 = *Blanks                             ?DIRECTION LINE 11
     C                   Eval      #Need = *On                                  ?
     C                   Else                                                   ?
     C                   Eval      #Need = *Off                                 ?
     C                   EndIf                                                  ?

     C                   Eval      *InLR = *On
     C                   Return

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    #Cust
    ?C                   Parm                    #Need

    ?C                   EndSr                                                  ?
