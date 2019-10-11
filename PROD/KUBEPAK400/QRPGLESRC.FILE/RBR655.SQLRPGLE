     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FRBR655FM  CF   E             WORKSTN

      //  Function Prototypes
     D/COPY QFunctDefn,QCMDEXC

      //  Main procedure prototype & interface
     D RBR655          PR                  ExtPgm('RBR655')
     D RBR655          PI

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         DoW not *In03 and not *In13;
           Exfmt RBR65501;
         EndDo;
         If *In03;
           *InLr = *On;
           Return;
         EndIf;
         If *In13;
         Exec SQL Delete From RBLOTRD_LR;
         Exec SQL Insert Into RBLOTRD_LR Select * from RBLOTRD;
         Exec SQL Delete from RBLOTRD;
         EndIf;
         DoW not *In03;
           Exfmt RBR65502;
         EndDo;
         If *In03;
           *InLr = *On;
           Return;
         EndIf;

         *InLR = *On;

      /End-Free
