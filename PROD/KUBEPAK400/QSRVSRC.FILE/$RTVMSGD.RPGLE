     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     ?*? Function Prototype(s)                                        *
      /Copy QFunctDefn,$RtvMsgD


     ?*   ..................................................................
     ?*   :  $RtvMsgD                                             function :
     ?*   :................................................................:


     P $RtvMsgD        B                   Export
     D $RtvMsgD        PI           256A
     D   $MsgLib                     10A   const
     D   $MsgFil                     10A   const
     D   $MsgId                       7A   const

     ?*  The $RtvMsgD Function returns the Message Description of the message specified.

     D   #MsgLib       S                   like($MsgLib)
     D   #MsgFil       S                   like($MsgFil)
     D   #MsgId        S                   like($MsgId )
     D   #MsgLvl1      S            256A

     C                   Eval      #MsgLib = $MsgLib
     C                   Eval      #MsgFil = $MsgFil
     C                   Eval      #MsgId  = $MsgId

     C                   Call      'RTVMSGD_CL'
     C                   Parm                    #MsgLib
     C                   Parm                    #MsgFil
     C                   Parm                    #MsgId
     C                   Parm                    #MsgLvl1

     C                   return    #MsgLvl1

     P   $RtvMsgD      E

