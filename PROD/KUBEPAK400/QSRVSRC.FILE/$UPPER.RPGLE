     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$Upper

     ?*   ..................................................................
     ?*   :  $Upper                                               function :
     ?*   :................................................................:

     P $Upper          B                   Export
     D $Upper          PI           256A
     D   SourceString               256A   const                                ?Source Sting to Con

?    ?*  The $Upper  function returns the Source String in all Caps.
?    ?*   ie. - If you pass "abcde" you get back "ABCDE".

     D   x             S              3S 0
     D                 DS
     D   Letters                    256A
     D   Letter                       1A   Dim(256) Overlay(Letters)
     D   From                        26A   INZ('abcdefghijklmnopqrstuvwxyz')
     D   FromLetters                  1A   Dim(26) Overlay(From)
     D   To                          26A   INZ('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D   ToLetters                    1A   Dim(26) Overlay(To)

     C                   Eval      Letters = SourceString

     C                   Eval      x = 1
     C                   DoW       %SubSt(Letters:x:257-x) <> *Blanks
     C                             and x < 256
     C                   If        Letter(x) >= 'a' and Letter(x) <= 'z'
     C                   Eval      Letter(x)= ToLetters(%Scan(Letter(x):From:1))
     C                   EndIf
     C                   Eval      x = x + 1
     C                   EndDo

     C                   return    Letters

     P   $Upper        E
