     **Free
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI FIXFMINVT;
         END-PI;

         DCL-F FTINVT DISK(*EXT) USAGE(*INPUT);
         DCL-F FMINVT DISK(*EXT) USAGE(*UPDATE) KEYED;

         Read FTINVT;
         DoW not %EOF(FTINVT);
           If ITTIME = 102840;
             Chain (ITITEM:ITSIZE) FMINVT;
             IMQTOH -= ITTQTY;
             IMQTAV -= ITTQTY;
             Update RMINVT;
           ENDIF;
           Read FTINVT;
         ENDDO;

         *InLR = *On;
         Return;
