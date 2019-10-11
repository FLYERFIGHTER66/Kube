     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:             Recalculate Attendance Tray Counts             :?
      *??:............................................................:?

    ?C                   Call      'ATT081'
    ?C                   Call      'ATT082'
    ?C                   Call      'ATT083'

    ?c/exec sql
    ?c+
    ?c+    update  fmattend
    ?c+    set     attraz =
    ?c+                   (select  count(*)
    ?c+                    from    fsownby
    ?c+                    where   sbattt = attime)
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    update  fmattend
    ?c+    set     attraz =
    ?c+                   (select  count(*)
    ?c+                    from    ftrayfixed
    ?c+                    where   tfattt = attime
    ?c+                    and     tfattt <> '0001-01-01-00.00.00.000000')
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On
