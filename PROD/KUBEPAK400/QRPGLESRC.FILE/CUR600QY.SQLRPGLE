    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Populate the FCUT600 file.                             :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Sep. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program replace two queries.  CUR600QRY and        ?:
      *? : CUR600QRYA.                                               ?:
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
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB  9/26/05  ?Initial Programming                       ?:
      *? :  ... ../../..  ?..........................................?:
      *? :............................................................:

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

      *?  Clear the Work File
    ?c/exec sql
    ?c+
    ?c+    DELETE FROM  FCUT600
    ?c+
    ?c/end-exec

      *?  Repopulate the Work File
    ?c/exec sql
    ?c+
    ?c+    INSERT INTO  FCUT600
    ?c+    SELECT       C.IMVEND
    ?c+           ,     A.OIORD#
    ?c+           ,     A.OIITEM
    ?c+           ,     A.OISIZE
    ?c+           ,     A.OIDES1
    ?c+           ,     A.OIQORD
    ?c+           ,     A.OIDTRQ
    ?c+           ,     A.OIRVDT
    ?c+           ,     A.OISOW
    ?c+           ,     B.OHDTOR
    ?c+           ,     B.OHCUST
    ?c+           ,     B.OHNAME
    ?c+           ,     C.IMLOOK
    ?c+    FROM         FIORDR AS A
    ?c+           ,     FHORDR AS B
    ?c+           ,     FMINVT AS C
    ?c+    WHERE        A.OIORD# = B.OHORD#
    ?c+      and        A.OIITEM = C.IMITEM
    ?c+      and        A.OISIZE = C.IMSIZE
    ?c+      and        A.OISTAT = 'A'
    ?c+      and        A.OIQORD > a.OIQSHP
    ?c+      and        C.IMFRSZ = 'CUT'
    ?c+      and        C.IMVEND = :Vendor
    ?c+
    ?c/end-exec

     C                   Eval      *InLr = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     *Entry        PList
     C                   Parm                    Vendor            6 0          ?Vendor Number

     C                   EndSR
