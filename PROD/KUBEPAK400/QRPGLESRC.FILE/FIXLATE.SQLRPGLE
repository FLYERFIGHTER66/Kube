     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                  Fix Late Charges                          :?
      *??:............................................................:?

      *?   Fix amount Due
    ?c/exec sql
    ?c+
    ?c+    UPDATE  FAROPN as A
    ?c+    SET     ARDUE$ =  ( select   sum(ar$amt)
    ?c+                        from     faropn as b
    ?c+                        where    a.arcust = b.arcust
    ?c+                          and    a.arinv# = b.arinv#
    ?c+                          and    a.arsuff = b.arsuff )
    ?c+    WHERE   arttyp = 7
    ?c+      and   arsuff = 'LC'
    ?c+      and   ardue$ <> ( select   sum(ar$amt)
    ?c+                        from     faropn as b
    ?c+                        where    a.arcust = b.arcust
    ?c+                          and    a.arinv# = b.arinv#
    ?c+                          and    a.arsuff = b.arsuff )
    ?c+
    ?c/end-exec

      *?   Fix amount Adjusted
    ?c/exec sql
    ?c+
    ?c+    UPDATE  FAROPN as A
    ?c+    SET     ARADJ$ =  ( select   sum(ar$amt)
    ?c+                        from     faropn as b
    ?c+                        where    a.arcust = b.arcust
    ?c+                          and    a.arinv# = b.arinv#
    ?c+                          and    a.arsuff = b.arsuff
    ?c+                          and    b.arttyp = '4')
    ?c+    WHERE   arttyp =  7
    ?c+      and   arsuff = 'LC'
    ?c+      and   ARADJ$ <> ( select   sum(ar$amt)
    ?c+                        from     faropn as b
    ?c+                        where    a.arcust = b.arcust
    ?c+                          and    a.arinv# = b.arinv#
    ?c+                          and    a.arsuff = b.arsuff
    ?c+                          and    b.arttyp = '4')
    ?c+
    ?c/end-exec

      *?   Fix amount Paid
    ?c/exec sql
    ?c+
    ?c+    UPDATE  FAROPN as A
    ?c+    SET     ARPAID = -( select   sum(ar$amt)
    ?c+                        from     faropn as b
    ?c+                        where    a.arcust = b.arcust
    ?c+                          and    a.arinv# = b.arinv#
    ?c+                          and    a.arsuff = b.arsuff
    ?c+                          and    b.arttyp <> '4'
    ?c+                          and    b.arttyp <> '7')
    ?c+    WHERE   arttyp =  7
    ?c+      and   arsuff = 'LC'
    ?c+      and   ARPAID <> -( select   sum(ar$amt)
    ?c+                        from     faropn as b
    ?c+                        where    a.arcust = b.arcust
    ?c+                          and    a.arinv# = b.arinv#
    ?c+                          and    a.arsuff = b.arsuff
    ?c+                          and    b.arttyp <> '4'
    ?c+                          and    b.arttyp <> '7')
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On
