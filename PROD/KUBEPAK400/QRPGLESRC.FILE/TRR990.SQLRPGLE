     **Free
         //  :````````````````````````````````````````````````````````````:
         //  : Delete Truck records for *Blanks Truck numbers             :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  Sep. 2017            ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:
        /COPY QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI TRR990;
         END-PI;

         Exec SQL Delete FROM FTRHDRH WHERE THTRK# = ' ';
         Exec SQL Delete FROM FTRSCHD WHERE TRTRK# = ' ';

         *InLR = *On;
