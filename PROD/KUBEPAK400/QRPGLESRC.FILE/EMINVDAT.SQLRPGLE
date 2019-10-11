     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     D EMINVDAT        PR                  ExtPgm('EMINVDAT')
     D  #SelDate                      6P 0
     D EMINVDAT        PI
     D  #SelDate                      6P 0

      *? External Function Prototypes
     D EMINVCUSCL      PR                  EXTPGM('EMINVCUSCL')
     D  #SelDate                      6P 0 CONST
     D  #Customer                     6P 0 CONST

     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$_Dates

      *? Local Function Prototypes
     D GetData         PR

      *? Local Field Definitions
     D EndOfFile       S               N
     D Customer        S              6P 0
     D LastCustomer    S              6P 0

      /Free
         Monitor;
           #SelDate = %dec(#SelDate:6:0);
          On-Error;
           #SelDate = 0;
         EndMon;
         If #SelDate = 0;
           #SelDate = $MDYDate($Date(0));
         ENDIF;

         GetData();
         Dow not EndOfFile;
           EMINVCUSCL(#SelDate:Customer);
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
           SELECT   FHORDW.WHBLCU
           INTO     :Customer
           FROM     FHORDW, FMEMAIL
           WHERE    FHORDW.WHBLCU  = FMEMAIL.EMACCT
             and    FHORDW.WHBLCU  > :Customer
             and    FHORDW.WHINDT  = :#SelDate
             and    FMEMAIL.EMCODE = 'INV'
             and    FMEMAIL.EMAIL like '%@%'
             and    FMEMAIL.EMAIL like '%.%'
           ORDER BY FHORDW.WHBLCU
                  , FHORDW.WHCUST
                  , FHORDW.WHINV#
           FETCH FIRST ROW ONLY;

         If Customer = *Zero or Customer = LastCustomer;
           EndOfFile = *On;
          Else;
           EndOfFile = *Off;
           LastCustomer = Customer;
         ENDIF;

      /End-Free
     P GetData         E
