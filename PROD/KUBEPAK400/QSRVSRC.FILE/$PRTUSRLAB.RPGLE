     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$PrtUsrLab


     ?*   ..................................................................
     ?*   :  $PrtUsrLab                                           function :
     ?*   :................................................................:

     P $PrtUsrLab      B                   Export
     D $PrtUsrLab      PI
     D $UsrLab#                       8S 0
     D $Copies                        3S 0

     D $UsrLab@        S              8A
     D $Copies4        S              4S 0
     D $Copies@        S              4A   Inz('0000')
?    ?*  The $PrtUsrLab routine prints user labels for Sown By or Fixed By... etc.
     C                   Move      $UsrLab#      $UsrLab@
     C                   Eval      $Copies4 = $Copies
     C                   Move      $Copies4      $Copies@
     C                   Call      'PRTUSRLABC'
     C                   Parm                    $UsrLab@
     C                   Parm                    $Copies@
     C                   return

     P   $PrtUsrLab    E

