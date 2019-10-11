      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
     FFDLOTRDY  UF   E           K DISK
     FFALITEM   IF   E           K DISK

      //? Function Prototypes
    ?D/COPY QFunctDefn,$_Dates

      //? Subprocedure Prototypes

      //? Program Prototype
     D FIX_RD_ALO      PR                  ExtPgm('FIX_RD_ALO')                 Prototype
      //? Program Interface
     D FIX_RD_ALO      PI                                                       Procedure Interface

      //? Field Definitions
     D Today7          S              7S 0 Inz(0)
      //? Indicators

      //? Data Areas

      /Free

         Today7 = $Date7($Date(0));

           SetLL Today7 FDLOTRDY;
           Read FDLOTRDY;

           DoU %Eof(FDLOTRDY);

             Exec SQL
               Select  sum(AIQTOA)
               Into   :LRQTAL
               From    FALITEM
               Where  :LRITEM = AIITEM
                 and  :LRSIZE = AISIZE
                 and  :LRCRDY = AICRDY
                 and  :LRSOWD = AISOWD
                 and  :LRCUST = AICUST
                 and  :LRGLOC = AIGLOC;

           If SQLState = '00000';
             LRQTAV = LRQTOH - LRQTAL;
             Update RDLOTRD;
           EndIf;

           Read FDLOTRDY;
           ENDDO;

           *InLR = *On;

      /End-Free
