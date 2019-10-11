    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Get Employee File# from Card#                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2006            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :  Get Employee File# from Card#                            ?:
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
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFMEMPLOY  IF   E           K DISK                                         ?Employee Master
     FFMEMPXREF IF   E           K DISK                                         ?Card# X-Ref


      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Card#         S                   Like(TXCARD)                         ?Card Number
     D   File#         S                   Like(TXFILE)                         ?File Number
     D   Name          S             25A                                        ?Employee Name
     D   Blank25       S             25A   Inz(' ')                             ?Employee Name

     C                   Z-add     Card#         TXFILE
     C                   Z-add     *Zero         File#
     C                   Move      *Blanks       Name
    ?C     Card#         Chain     FMEMPXREF
    ?C     TXFILE        Chain     FMEMPLOY
     C                   Eval      Name = %subst(%trim(EMLAST) + ', '
     C                                  + EMFIRS + Blank25:1:25)
     C                   Z-add     EMFILE        File#
     C                   MOVE      *ON           *INLR                          ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    Card#
    ?C                   Parm                    File#
    ?C                   Parm                    Name

    ?C                   EndSr                                                  ?
