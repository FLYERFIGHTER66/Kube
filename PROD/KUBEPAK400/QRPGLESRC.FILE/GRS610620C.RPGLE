**Free
        /COPY QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI GRS610620C;
         END-PI;

         dcl-pr GRS610 extpgm ;
             *n zoned(7:0) const ;
         end-pr ;

         dcl-s Master zoned(2:0) inz(1);

         dcl-pr GRS620 extpgm ;
             *n zoned(7:0) const ;
             *n zoned(2:0) const ;
         end-pr ;
         dcl-s Date7 Zoned(7:0);

         Date7 = 1170227;

         CallP GRS610(Date7);
         CallP GRS620(Date7:Master);

         *InLR = *On;
