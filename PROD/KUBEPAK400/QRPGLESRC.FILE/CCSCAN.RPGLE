     FCCSCANFM  CF   E             WORKSTN
     F                                     DEVID(WSID)

     D  Screen         S              2S 0

     C     StartOver     Tag
     C                   Eval      Screen = 1
     C                   ExFmt     CCINFO1
     C                   ExSr      EDIT
     C   05              Goto      StartOver

     C                   Eval      Screen = 2
     C                   ExFmt     CCINFO2
     C                   ExSr      EDIT
     C   05              Goto      StartOver

     C                   Eval      Screen = 3
     C                   ExFmt     CCINFO3
     C                   ExSr      EDIT
     C   05              Goto      StartOver

     C                   Eval      Name =
     C                             %Subst(NameLong:1:%Scan('':NameLong:1)-1)
     C                   Select
     C                   When      %Subst(Number:1:1) = '4'
     C                   Eval      Type = 'VISA'
     C                   When      %Subst(Number:1:1) = '5'
     C                   Eval      Type = 'MC  '
     C                   EndSl

     C                   Eval      Expires = %Subst(Expires:3:2) +
     C                                       %Subst(Expires:1:2)

     C     ReturnSR      BEGSR
     C                   Eval                    Name = 'Scan Cancelled'
     C                   Eval                    Type  = *Blanks
     C                   Eval                    Number  = *Zeros
     C                   Eval                    Expires  = *Zeros
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndSR

     C     Edit          BEGSR
     C                   Select
     C                   When      *In03
     C                   ExSr      ReturnSR
     C                   When      *In05
     C                   Eval                    Name = *Blanks
     C                   Eval                    Type  = *Blanks
     C                   Eval                    Number  = *Zeros
     C                   Eval                    Expires  = *Zeros
     C                   When      Screen = 3
     C                   Eval      *InLR = *On
     C                   EndSl
     C                   EndSR

     C     *InzSr        BEGSR
     C     *Entry        PList
     C                   Parm                    Name             25
     C                   Parm                    Type              4
     C                   Parm                    Number           16
     C                   Parm                    Expires           4

     C                   Eval                    Name = *Blanks
     C                   Eval                    Type  = *Blanks
     C                   Eval                    Number  = *Zeros
     C                   Eval                    Expires  = *Zeros
     C                   ENDSR
      *
