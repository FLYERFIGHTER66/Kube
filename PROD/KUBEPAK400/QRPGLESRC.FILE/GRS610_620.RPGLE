     **Free
        /COPY QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI GRS610_620;
       //    DCL-PARM Date_In7 zoned(7:0) const ;
         END-PI;

         dcl-pr GRS610 extpgm ;
             *n zoned(7:0) const ;
         end-pr ;

         dcl-pr GRS620 extpgm ;
             *n zoned(7:0) const ;
             *n zoned(2:0) const ;
         end-pr ;

         dcl-ds PS_RB_MM# dtaara;
             Master zoned(2:0);
         end-ds;

         DCL-S nextMonday7 zoned(7:0) Inz(0);

         In PS_RB_MM#;

         NextMonday7 = %int(%char(%date()
          -%days((%rem(%diff(%date():d'01/01/0001':*days):7))-(7)):*CYMD0));

           CallP GRS610(nextMonday7);
           CallP GRS620(nextMonday7:Master);

         *InLR = *On;
