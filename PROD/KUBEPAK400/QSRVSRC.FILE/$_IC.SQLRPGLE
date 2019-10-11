     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H BndDir('KPFUNCTION')
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototypes
     D/Copy QFunctDefn,$_IC

      // $Saleable - Returns number of Saleable Cells for a Size Code
     P $Saleable       B                   Export
     D $Saleable       PI             5S 0
     D  $P_Size                       3A   Const

     D  #Saleable      S              5S 0

      /Free

         Exec Sql
           Select SZSALE
           Into   :#Saleable
           From   FMSIZE
           Where  SZCODE = :$P_Size;

         If SQLSTT <> '00000';
           Return *Zero;
         Else;
           Return #Saleable;
         EndIf;

      /End-Free

     P $Saleable       E
