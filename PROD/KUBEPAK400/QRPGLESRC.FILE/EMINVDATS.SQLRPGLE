     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     D EMINVDATS       PR                  ExtPgm('EMINVDATS')
     D EMINVDATS       PI

      *? External Function Prototypes
     D EMINVDAT        PR                  ExtPgm('EMINVDAT')
     D  #SelDate                      6P 0

     D  #SelDate       S              6P 0

      /Free

         #SelDate = 033117;
           EMINVDAT(#SelDate);

       //  #SelDate = 031217;
       //    EMINVDAT(#SelDate);

       //  #SelDate = 031917;
       //    EMINVDAT(#SelDate);

       //  #SelDate = 032617;
       //    EMINVDAT(#SelDate);

       //  #SelDate = 032917;
       //    EMINVDAT(#SelDate);

       //  #SelDate = 040317;
       //    EMINVDAT(#SelDate);

       //  #SelDate = 040217;
       //    EMINVDAT(#SelDate);

       //  #SelDate = 040117;
       //    EMINVDAT(#SelDate);

         *InLR = *On;
         Return;

      /End-Free
