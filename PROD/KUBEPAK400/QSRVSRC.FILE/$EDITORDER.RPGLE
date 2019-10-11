     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:      Edit an Order Detail Record as Specified              :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Sep 2012             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This program is used edit order detail records.          ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :............................................................:

      *? Function Prototype(s)
     D/Copy QFunctDefn,$EditOrder

     P $EditOrder      B                   Export
     D $EditOrder      PI              N
     D   #Order#                      6P 0 Const
     D   #Sequence#                   3P 0 Const

      *? Field Definitions
     D   Ord#          S              6P 0
     D   Seq#          S              3P 0


     C                   Eval      *InLR = *On

     C                   call      'BIR100CLO'
     C                   Parm      #Order#       Ord#
     C                   Parm      #Sequence#    Seq#

     C                   Return    *On

     P $EditOrder      E
