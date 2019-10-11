     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     D EARLYPAY        PR                  ExtPgm('EARLYPAY')
     D EARLYPAY        PI

      *? External Function Prototypes
      /COPY QFunctDefn,$_Dates

      *? Local Field Definitions
     D LastInvoice#    S              6P 0
     D CashDiscDate    S              7P 0

     D RHORDW        E DS                  extname(FHORDW)

      /Free

         WHINV# = 1;

         DoW WHINV# <> 0;
           WHINV# = 0;
           Exec SQL
             SELECT  *
             INTO   :RHORDW
             FROM    FHORDW
             WHERE   WHTRAT <> 0
               and   WHTDAY <> 0
               and   Date(Substr(WHDTAC,4,2)||'/'||
                          Substr(WHDTAC,6,2)||'/'||
                          Char(1900+Left(WHDTAC,3)))
                        + WHTDAY days >= curdate()
               and   WHINV# > :LastInvoice#
             ORDER BY WHINV#;
           If WHINV# > 0;
             LastInvoice# = WHINV#;
             CashDiscDate = $Date7($AddDate($Date(WHDTAC):WHTDAY));
             Exec SQL
               Update  FAROPN
               Set     ARDISC =  :WHTRAT * AR$AMT / 100
                 ,     ARDCDT =  :CashDiscDate
               Where   ARCUST =  :WHBLCU
                 and   ARINV# =  :WHINV#
                 and   ARSUFF =  '  '
                 and   ARSEQ# =   0
                 and   ARSTAT =  'A'
                 and   ARDISC =   0;
           EndIf;
         EndDo;

         // Now get rid of any expired discounts

         Exec SQL   // Remove exprired discounts
           UPDATE  FAROPN
           SET     ARDISC = 0
           WHERE   ARDISC <> 0
             and   ARDCDT < (year(curdate())-1900) * 10000
                          + (month(curdate())) * 100
                          + (day(curdate()));

         *InLR = *On;

      /End-Free
