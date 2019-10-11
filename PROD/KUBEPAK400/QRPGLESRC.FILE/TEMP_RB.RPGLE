     **Free
        /COPY QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI TEMP_RB
         END-PI;

         dcl-pr GRS610 extpgm ;
             *n zoned(7:0) const ;
         end-pr ;

         dcl-pr GRS620 extpgm ;
             *n zoned(7:0) const ;
             *n zoned(2:0) const ;
         end-pr ;

         DCL-S Date7 zoned(7:0) Inz(1170220);
         DCL-S Master zoned(2:0) Inz(01);

         CallP GRS610(Date7);
         CallP GRS620(Date7:Master);

         *InLR = *On;
