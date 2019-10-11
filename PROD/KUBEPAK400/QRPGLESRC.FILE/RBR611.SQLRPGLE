     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FFDLOTRD_SAUF   E           K DISK    Rename(RDLOTRD:RDLOTRD_SA)
     FFDLOTRD_S UF A E           K DISK    Rename(RDLOTRD:RDLOTRD_S )

      //  Main procedure prototype & interface
     D RBR611          PR                  ExtPgm('RBR611')
     D RBR611          PI

     D Qty2Move        S                   Like(LRQTOH)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Now

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         Setll (*LoVal) FDLOTRD_SA;
         Read FDLOTRD_SA;
         DoW not %EOF(FDLOTRD_SA);
           Qty2Move = LRQTOH - LRQTAL;
           LRQTOH -= Qty2Move;
           LRQTAV = LRQTOH - LRQTAL;
           LRDTLA = $MDYDate($Date(0));
           LRTIME = $Now();
           LRUSER = 'RBR611a';
           Update RDLOTRD_SA;
           Chain (LRITEM:LRSIZE:LRCRDY:LRSOWD:'N  ':LRCUST) FDLOTRD_S;
           LRDTLA = $MDYDate($Date(0));
           LRTIME = $Now();
           LRUSER = 'RBR611b';
           If %Found(FDLOTRD_S);
             LRQTOH += Qty2Move;
             LRQTAV += Qty2Move;
             Update RDLOTRD_S;
            Else;
             LRGLOC = 'N  ';
             LRQTOH  = Qty2Move;
             LRQTAV  = Qty2Move;
             Write RDLOTRD_S;
           EndIf;
           Read FDLOTRD_SA;
         EndDo;

         *InLR = *On;

      /End-Free
