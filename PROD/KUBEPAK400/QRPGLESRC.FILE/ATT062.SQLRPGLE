    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)                                                           ?
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)                                                             ?
      *??:````````````````````````````````````````````````````````````:?
      *??:           Time Card Inactivation Program                   :?
      *??:............................................................:?
    ?c/exec sql
    ?c+
    ?c+    UPDATE   FMEMPLOY
    ?c+    SET      EMSTAT = 'I'
    ?c+    WHERE    EMSTAT <> 'I'
    ?c+      and    EMCARD not in (SELECT ATCARD
    ?c+                            FROM fmattend
    ?c+                            WHERE ATDATE > CURDATE() - 21 DAYS )
    ?c+      and    EMFILE not in (SELECT ATFILE
    ?c+                            FROM fmattend
    ?c+                            WHERE ATDATE > CURDATE() - 21 DAYS )
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    UPDATE   FMEMPLOY
    ?c+    SET      EMSTAT = 'A'
    ?c+    WHERE    EMSTAT <> 'A'
    ?c+      and    EMCARD     in (SELECT ATCARD
    ?c+                            FROM fmattend
    ?c+                            WHERE ATDATE > CURDATE() - 21 DAYS )
    ?c+       OR    EMSTAT <> 'A'
    ?c+      and    EMFILE     in (SELECT ATFILE
    ?c+                            FROM fmattend
    ?c+                            WHERE ATDATE > CURDATE() - 21 DAYS )
    ?c+
    ?c/end-exec
     C                   Eval      *InLR = *On
