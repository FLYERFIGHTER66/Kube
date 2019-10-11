     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Build Master Tag Drop Ship File                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2005             ? Kube-Pak Corporation ?    :
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

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate

      *? Arrays

      *? Data Structures

      *? Field Definitions
     D   ParmDate      S              6P 0                                      ?Ship Date
     D   ParmSeq#      S              2P 0                                      ?Next Seq # for Date
     D   InvcDate      S              6S 0                                      ?Invoice Date
     D   InvcDateYMD   S              6S 0                                      ?Invoice Date YYMMDD
     D   NextSeq#      S              2S 0                                      ?Next Seq # for Date
     D   OurName       S             30A                                        ?Company Name
     D   OurEmail      S             33A                                        ?Email Address
     D   FromDate      S              7S 0                                      ?From Date

      *? Indicators

    ?C                   ExSr      GetData                                      ?
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      GetData   - Run SQL to populate data               :
      *?  :.........................................................:

     C     GetData       BegSr

      *? Clear MTDROPSHIP file

    ?c/exec sql
    ?c+
    ?c+                  DELETE from MTFORWARD
    ?c+
    ?c/end-exec

      *? Build MTFORWARD file

    ?c/exec sql
    ?c+
    ?c+  INSERT INTO MTFORWARD  (
    ?c+
    ?c+  SELECT  '790100  '                          as MTVEND
    ?c+       ,  'Kube Pak Corporation'              as MTVNAM
    ?c+       ,  OIITEM                              as MTPROD
    ?c+       ,  OIDES1                              as MTDESC
    ?c+       ,  int(SZSALE * (OIQORD-OIQSHP))       as MTSQTY
    ?c+       ,  substr(digits(OIDTRQ),1,2) ||'-'||
    ?c+          substr(digits(OIDTRQ),3,2) ||'-20'||
    ?c+          substr(digits(OIDTRQ),5,2)          as MTODAT
    ?c+       ,  substr(digits(OIDTRQ),1,2) ||'-'||
    ?c+          substr(digits(OIDTRQ),3,2) ||'-20'||
    ?c+          substr(digits(OIDTRQ),5,2)          as MTSDAT
    ?c+       ,  digits(OHORD#)                      as MTORD#
    ?c+    FROM    FHORDR, FIORDR, FMINVT, FMSIZE, MTITEMS
    ?c+    WHERE   OHORD# =  OIORD#
    ?c+      and   OIITEM =  IMITEM
    ?c+      and   OISIZE =  IMSIZE
    ?c+      and   OISIZE =  SZCODE
    ?c+      and   OIITEM =  MTITEM
    ?c+      and   OISIZE =  MTSIZE
    ?c+      and   OICUST <> 2730
    ?c+      and   OICUST not in
    ?c+            (Select CMCUST from FMCUST where CMNAME like '%KUBE%')
    ?c+      and   OHSTAT =  'A'
    ?c+      and   OISTAT =  'A'
    ?c+      and   OIRVDT >  :FromDate
    ?c+      and   OIITYP <> 'C'
    ?c+      and   IMFRSZ =  'CUT'
    ?c+  )
    ?c+
    ?c/end-exec


     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C*    *Entry        PList
     C*                  Parm                    ParmDate
     C*                  Parm                    ParmSeq#

     C                   Eval      FromDate = $Date7($AddDate($Date(0):-30))

    ?C                   EndSr                                                  ?
