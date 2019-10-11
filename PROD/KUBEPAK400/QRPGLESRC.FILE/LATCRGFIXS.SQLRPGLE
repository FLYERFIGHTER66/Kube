     **Free
         //  :````````````````````````````````````````````````````````````:
         //  :       Monthly Late Charges (Assessed Daily)                :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  June 2004            ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:

        /COPY QFunctDefn,#CopyRight  // Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI LATCRGFIXS;
           DCL-PARM Cust@ char(6) Const;             // Specify Cutomer #
           DCL-PARM Invoice@ char(6) Const;          // Specify Invoice #
         END-PI;

         dcl-f FARLCD keyed usage(*update:*output) ;  // Late Charge Details File

         dcl-s ThisInvoice packed(6:0);
         dcl-s ThisCust packed(6:0);
         dcl-s NewDefault packed(4:0);
         dcl-s TheDueDate date;

      //------------------------------------------------------------------------
      // Begin Program Logic
      //------------------------------------------------------------------------
         Monitor;
           ThisCust = %Int(Cust@);
           ThisInvoice = %Int(Invoice@);
          on-error;
           return;
         ENDMON;

         Exec SQL // Get Due Date from L/C Header
           Select ARDUED
             Into :TheDueDate
             From FARLC
             Where ARCUST = :ThisCust
               and ARINV# = :ThisInvoice;

         NewDefault = 9999;
         SetGT (ThisCust:ThisInvoice) FARLCD;
         ReadPE (ThisCust:ThisInvoice) FARLCD;
         DoW not %EOF(FARLCD);
           ARDAYS = NewDefault;
           Update RARLCD;
           NewDefault -= 1;
           ReadPE (ThisCust:ThisInvoice) FARLCD;
         ENDDO;

         SetLL (ThisCust:ThisInvoice) FARLCD;
         ReadE (ThisCust:ThisInvoice) FARLCD;
         DoW not %EOF(FARLCD);
           ARDAYS =  %DIFF ( %Date(ARLMLC:*CYMD):TheDueDate:*DAYS);
           Update RARLCD;
           ReadE (ThisCust:ThisInvoice) FARLCD;
         ENDDO;

         *InLR = *On;

