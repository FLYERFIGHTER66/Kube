     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     D WSINVDAT        PR                  ExtPgm('WSINVDAT')
     D  #SelDate                      6P 0
     D WSINVDAT        PI
     D  #SelDate                      6P 0

      *? External Function Prototypes
     D WSINVOICE       PR                  EXTPGM('WSINVOICE')
     D  #Invoice                      6P 0 CONST

     D/COPY QFunctDefn,$_Dates

      *? Local Function Prototypes
     D GetData         PR

      *? Local Field Definitions
     D EndOfFile       S               N
     D Invoice         S              6P 0
     D LastCustomer    S              6P 0

      /Free
         Monitor;
           #SelDate = %dec(#SelDate:6:0);
          On-Error;  // If the date passed is NG use 0.
           #SelDate = 0;
         EndMon;

         If #SelDate = 0; // If the date is 0, use today
           #SelDate = $MDYDate($Date(0));
         ENDIF;

         GetData();
         Dow not EndOfFile;
           WSINVOICE(Invoice:0);
           GetData();
         EndDo;

         *InLR = *On;
         Return;

      /End-Free

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Get Data                                                         :
      // :..................................................................:
     P GetData         B
     D GetData         PI
      /Free

         Exec SQL
           SELECT   FHORDW.WHINV#
           INTO     :Invoice
           FROM     FHORDW, FBROKDFT
           WHERE    FHORDW.WHBLCU  = int(FBROKDFT.BROKER_NUMBER)
             and    FHORDW.WHINV#  > :Invoice
             and    FHORDW.WHINDT  = :#SelDate
           ORDER BY FHORDW.WHBLCU
                  , FHORDW.WHCUST
                  , FHORDW.WHINV#
           FETCH FIRST ROW ONLY;

         If Invoice = *Zero or Invoice = LastInvoice;
           EndOfFile = *On;
          Else;
           EndOfFile = *Off;
           LastInvocie = Invoice;
         ENDIF;

      /End-Free
     P GetData         E
