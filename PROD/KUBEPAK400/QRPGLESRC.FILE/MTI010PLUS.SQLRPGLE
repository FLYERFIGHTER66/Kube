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
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

      *? Arrays

      *? Data Structures

      *? Field Definitions
     D   ParmDate      S              6P 0                                      ?Ship Date
     D   ParmSeq#      S              2P 0                                      ?Next Seq # for Date
     D   InvcDate      S              6S 0                                      ?Invoice Date
     D   LastMonday    S              7S 0                                      ?Last Monday CYMD7
     D   ThisMonday    S              7S 0                                      ?This Monday CYMD7
     D   NextMonday    S              7S 0                                      ?Next Monday CYMD7
     D   InvcDateYMD   S              6S 0                                      ?Invoice Date YYMMDD
     D   NextSeq#      S              2S 0                                      ?Next Seq # for Date
     D   OurName       S             30A                                        ?Company Name
     D   OurEmail      S             33A                                        ?Email Address

      *? Indicators

    ?C                   ExSr      GetVariables                                 ?
    ?C                   ExSr      GetData                                      ?
    ?C                   ExSr      GetMemberName                                ?
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      GetVariables - Run SQL to retrieve variables       :
      *?  :.........................................................:

     C     GetVariables  BegSr

      *? Get our company name

    ?c/exec sql
    ?c+
    ?c+  SELECT  RGNAME
    ?c+  INTO    :OurName
    ?c+  FROM    FMCORG
    ?c+  WHERE   RGCOMP = 01
    ?c+
    ?c/end-exec

      *? Get our e-mail address

    ?c/exec sql
    ?c+
    ?c+  SELECT  RGEML
    ?c+  INTO    :OurEmail
    ?c+  FROM    FMCORG
    ?c+  WHERE   RGCOMP = 01
    ?c+
    ?c/end-exec


     C                   EndSr


      *?  ...........................................................
      *?  :      GetData02 - Run SQL to populate data               :
      *?  :.........................................................:

     C     GetData       BegSr

      *? Clear MTDROPSHIP file

    ?c/exec sql
    ?c+
    ?c+                  DELETE from MTDROPSHIP
    ?c+
    ?c/end-exec

      *? Build MTDROPSHIP file

    ?c/exec sql                                                                 ?
    ?c+
    ?c+  INSERT INTO MTDROPSHIP (
    ?c+    SELECT  '790100  '                          as MTVEND                ?MTVEND
    ?c+         ,  :OurName                            as MTVNAM                ?MTVNAM
    ?c+         ,  digits(OHCUST)                      as MTCUST                ?MTCUST
    ?c+         ,  OHNAME                              as MTCNAM                ?MTCNAM
    ?c+         ,  OHSHP2                              as MTADR1                ?MTADR1
    ?c+         ,  OHSHP3                              as MTADR2                ?MTADR2
    ?c+         ,  OHSHP4                              as MTADR3                ?MTADR3
    ?c+         ,  OHSHCT                              as MTCITY                ?MTCITY
    ?c+         ,  OHSHST                              as MTSTTE                ?MTSTTE
    ?c+         ,  OHSHZP                              as MTCZIP                ?MTCZIP
    ?c+         ,  'USA'                               as MTCTRY                ?MTCTRY
    ?c+         ,  OHPONO                              as MTBPO#                ?MTBPO#
    ?c+         ,  substr(CMCNME,1,25)                 as MTCTNM                ?MTCTNM
    ?c+         ,  CASE WHEN CMPHON = 0 then ' ' else                           ?
    ?c+           (substr(digits(CMPHON),1,3) ||'-'||
    ?c+            substr(digits(CMPHON),4,3) ||'-'||
    ?c+            substr(digits(CMPHON),7,4)) end     as MTPHON                ?MTPHON
    ?c+         ,  CASE WHEN HSFAX = 0 then ' ' else                            ?
    ?c+            substr(digits(HSFAX ),1,3) ||'-'||
    ?c+            substr(digits(HSFAX ),4,3) ||'-'||
    ?c+            substr(digits(HSFAX ),7,4) end      as MTFAX#                ?MTFAX#
    ?c+         ,  digits(OIORD#)                      as MTORD#                ?MTORD#
    ?c+         ,  substr(digits(OIRVDT),4,2) ||'-'||
    ?c+            substr(digits(OIRVDT),6,2) ||'-20'||
    ?c+            substr(digits(OIRVDT),2,2)          as MTSDAT                ?MTSDAT
    ?c+         ,  '2'                                 as MTTYPE                ?MTTYPE
    ?c+         ,  OIITEM                              as MTPROD                ?MTPROD
    ?c+         ,  OIDES1                              as MTDESC                ?MTDESC
    ?c+         ,  int(SZSALE * OIQORD)                as MTSQTY                ?MTSQTY
    ?c+         ,  ' '                                 as MTAGID                ?MTAGID
    ?c+         ,  '01'                                as MTCOCD                ?MTCOCD
    ?c+         ,  :OurEmail                           as MTEMAL                ?MTEMAL
    ?c+         ,  0                                   as MTBDSZ                ?MTBDSZ
    ?c+    FROM    FHORDR as O                                                  ?Order Header
    ?c+       ,    FIORDR as I                                                  ?Order Detail
    ?c+       ,    FMCUST                                                       ?Customer Master
    ?c+       ,    FARHST                                                       ?
    ?c+       ,    FMINVT                                                       ?Item Master
    ?c+       ,    FMSIZE                                                       ?Size Master
    ?c+       ,    MTITEMS                                                      ?
    ?c+    WHERE   OHORD# =  OIORD#                                             ?
    ?c+      and   OHCUST =  CMCUST                                             ?
    ?c+      and   OHCUST =  HSCUST                                             ?
    ?c+      and   OIITEM =  IMITEM                                             ?
    ?c+      and   OISIZE =  IMSIZE                                             ?
    ?c+      and   OISIZE =  SZCODE                                             ?
    ?c+      and   OIITEM =  MTITEM                                             ?
    ?c+      and   OISIZE =  MTSIZE                                             ?
    ?c+      and   OICUST <> 2730                                               ?
    ?c+      and   OICUST not in                                                ?No Kube Pak Orders
    ?c+            (Select CMCUST from FMCUST where CMNAME like '%KUBE%')       ?we use custom tags
    ?c*      and   OISTAT =  'A'                                                ?include for R.Bay
    ?c+      and   OIRVDT between :LastMonday and :NextMonday
    ?c+      and   OIITYP <> 'C'                                                ?
    ?c+      and   IMFRSZ =  'CUT'                                              ?
    ?c+   )                                                                     ?
    ?c+
    ?c/end-exec                                                                 ?

    ?c/exec sql
    ?c+
    ?c+    update mtdropship as cur
    ?c+    set cur.mtsqty =
    ?c+        cur.mtsqty -  Case when (Select   sum(HIST.MTSQTY)
    ?c+                                   from   MTDSHIST as HIST
    ?c+                                  where   HIST.MTCUST = CUR.MTCUST
    ?c+                                    and   HIST.MTORD# = CUR.MTORD#
    ?c+                                    and   HIST.MTPROD = CUR.MTPROD)
    ?c+                           is null then 0
    ?c+                           else (Select   sum(HIST.MTSQTY)
    ?c+                                   from   MTDSHIST as HIST
    ?c+                                  where   HIST.MTCUST = CUR.MTCUST
    ?c+                                    and   HIST.MTORD# = CUR.MTORD#
    ?c+                                    and   HIST.MTPROD = CUR.MTPROD)
    ?c+                           end
    ?c+
    ?c/end-exec                                                                 ?

    ?c/exec sql
    ?c+
    ?c+    DELETE FROM MTDROPSHIP WHERE MTSQTY <= 0
    ?c+
    ?c/end-exec                                                                 ?


     C                   EndSr


      *?  ...........................................................
      *?  :      GetMemberName - Get the member name to use.        :
      *?  :.........................................................:

     C     GetMemberName BegSr

      *? Retrieve the Number of the last transmission for this date

    ?c/exec sql
    ?c+
    ?c+  SELECT
    ?c+          CASE
    ?c+              WHEN MAX(MLNAME) IS NULL               THEN 1
    ?c*              WHEN INT(SUBSTR(MAX(MLNAME),9,2)) = 99 THEN 0
    ?c+          ELSE
    ?c+              INT(SUBSTR(MAX(MLNAME),9,2)) + 1
    ?c+          END
    ?c+  INTO    :ParmSeq#
    ?c+  FROM    QTEMP/DSPFD
    ?c+  WHERE   Int(SUBSTR(MLNAME,3,6)) = :InvcDateYMD
    ?c+
    ?c/end-exec


     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
     C                   Parm                    ParmDate
     C                   Parm                    ParmSeq#

      *?  If Zeros are passed in, get today's date
     C                   If        ParmDate = 0
     C*                  Eval      ParmDate = $MDYDATE($ADDDATE($DATE(0):-1))
     C                   Eval      ParmDate = $MDYDATE($DATE(0))
     C                   EndIf

      *?  new Logic - Calculate Shipping Window ( two weeks future and one week back )
      *?              This will give us this week and next for future and last week as past
     C                   Eval      ThisMonday =
     C                             $Date7($Monday($DateMDY(ParmDate):'MON'))
     C                   Eval      LastMonday =
     C                             $Date7($AddDate($Date(ThisMonday):-112))
     C                   Eval      NextMonday =
     C                             $Date7($AddDate($Date(ThisMonday):7))

     C                   Eval      InvcDate = ParmDate
     C     InvcDate      Mult      10000.01      InvcDateYMD

    ?C                   EndSr                                                  ?
