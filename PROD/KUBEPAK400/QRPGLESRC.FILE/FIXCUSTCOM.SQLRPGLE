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
    ?c+    insert into fcustcom
    ?c+
    ?c+      (   select    'A'        as    STATUS
    ?c+                    , CMCUST   as    CUST_NUMBER
    ?c+                    , 1        as    COMMENT_SEQ
    ?c+                    , ' '      as    COMMENT_1
    ?c+                    , ' '      as    COMMENT_2
    ?c+                    , ' '      as    EMAIL
    ?c+                    , ' '      as    URL
    ?c+                    , 'N'      as    ST3
    ?c+                    , 'N'      as    CREDIT_APP
    ?c+          from fmcust
    ?c+          where cmcust not in (
    ?c+                                SELECT  CCUST
    ?c+                                FROM    fcustcom
    ?c+                                WHERE   CCSEQ = 1 ) )
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On
