    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                                                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2008            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:

      *? Run SQL
    ?C                   ExSr      UpdateWeeks                                  ?
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      OpenData - Open Data Source                        :
      *?  :.........................................................:
    ?C     UpdateWeeks   BegSr                                                  ?

     ?*  Update records that represent the entire year./
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMBD1=01
    ?c+      ,    IMED1=53
    ?c+    WHERE  IMBD1=101
    ?c+      and  IMED1=1231
    ?c+      and  IMBD2=0
    ?c+      and  IMED2=0
    ?c+      and  IMBD3=0
    ?c+      and  IMED3=0
    ?c+      and  IMBD4=0
    ?c+      and  IMED4=0
    ?c+
    ?c/end-exec

     ?*  Update Beginning Week Buckets 1 - 4
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMBD1 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD1 )
    ?c+    WHERE  IMBD1 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD1 ) > 0
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMBD2 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD2 )
    ?c+    WHERE  IMBD2 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD2 ) > 0
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMBD3 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD3 )
    ?c+    WHERE  IMBD3 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD3 ) > 0
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMBD4 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD4 )
    ?c+    WHERE  IMBD4 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMBD4 ) > 0
    ?c+
    ?c/end-exec

     ?*  Update Ending Week Buckets 1 - 4
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED1 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED1 )
    ?c+    WHERE  IMED1 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED1 ) > 0
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED2 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED2 )
    ?c+    WHERE  IMED2 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED2 ) > 0
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED3 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED3 )
    ?c+    WHERE  IMED3 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED3 ) > 0
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED4 = ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED4 )
    ?c+    WHERE  IMED4 > 100
    ?c+      and          ( SELECT CLWEEK
    ?c+                     FROM   FCALEN
    ?c+                     WHERE  CLYEAR = 8
    ?c+                       and  CLCYMD = 1080000 + IMED4 ) > 0
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMBD1=01
    ?c+    WHERE  IMBD1=1229
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED1=53
    ?c+    WHERE  IMED1=1231
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED3=53
    ?c+    WHERE  IMED3=1231
    ?c+
    ?c/end-exec
     ?*  Update Ending Week Buckets 1 - 4
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED1=53
    ?c+    WHERE  IMED1=52
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED2=53
    ?c+    WHERE  IMED2=52
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED3=53
    ?c+    WHERE  IMED3=52
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE FMINVT
    ?c+    SET    IMED4=53
    ?c+    WHERE  IMED4=52
    ?c+
    ?c/end-exec

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C                   EndSr                                                  ?
