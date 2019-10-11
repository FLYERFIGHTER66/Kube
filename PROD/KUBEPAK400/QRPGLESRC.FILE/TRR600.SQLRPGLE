     **Free
         //  :````````````````````````````````````````````````````````````:
         //  : Unscheduled Orders                                         :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  Nov. 2016            ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:
        /COPY QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI TRR600;
         END-PI;

        /COPY QFunctDefn,$_Dates
        //dcl-f TRR600FM WORKSTN(*EXT) SFILE(TRR600S:RRN01);

         //dcl-s RRN01 packed(4:0) inz(0);
         dcl-s selWeek date;

         Exec SQL // TEMP
            Select ( current date -
           (dayOfWeek_ISO( current date )-1) days ) + 7 days
            into :SelWeek
            from sysibm.sysdummy1;

         SelWeek = $AddDate( $MONDAY( %date():'*MON') : 8 );

         *InLR = *On;
