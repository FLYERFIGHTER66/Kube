     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$IsBatch


     ?*   ..................................................................
     ?*   :  $IsBatch                                             function :
     ?*   :................................................................:

     P $IsBatch        B                   Export
     D $IsBatch        PI              N

     D $Batch          S               N
?    ?*  The $IsBatch routine returns true if the job is a batch job.
     C                   Call      '#ISBATCH'
     C                   Parm                    $Batch
     C                   return    $Batch

     P   $IsBatch      E

