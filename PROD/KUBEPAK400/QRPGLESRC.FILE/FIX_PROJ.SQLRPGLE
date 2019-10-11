     **Free
         //  :````````````````````````````````````````````````````````````:
         //  :       Fix Projections                                      :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  Jan 2017             ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:

        /COPY QFunctDefn,#CopyRight  // Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI FIX_PROJ;
         END-PI;

         dcl-f FTINVT keyed usage(*delete) ;  // Inventory Transactions

      //------------------------------------------------------------------------
      // Begic Program Logic
      //------------------------------------------------------------------------

         Read FTINVT;

         DoW not %EOF(FTINVT);
           If ITTYPE = 'P' and ITTREF = 'Projections Upload';
             Exec SQL // Update Inventory Master
               Update FMINVT
               Set IMQTOH = IMQTOH - :ITTQTY
                 , IMQTAV = IMQTAV - :ITTQTY
               Where IMITEM = :ITITEM
                 and IMSIZE = :ITSIZE
                 and IMQTOH >= :ITTQTY;
           Delete RTINVT;
           ENDIF;
         Read FTINVT;
         ENDDO;

         *InLR = *On;
