     H DEBUG OPTION(*SRCSTMT:*NODEBUGIO)

     H DFTACTGRP(*NO)

     H BndDir('*LIBL/KPFUNCTION')



     d dateFld         s               d

     d date7           s              7s 0



      /Copy QFunctDefn,$date7iso





      /free



        exec sql SET OPTION DATFMT=*ISO, CLOSQLCSR=*ENDMOD, COMMIT=*NONE;





        date7 = $date7iso( %date() );





        clear date7;

        exec sql

         SET :date7 = $date7iso( current_date );





         *inlr = *on;

         return;

