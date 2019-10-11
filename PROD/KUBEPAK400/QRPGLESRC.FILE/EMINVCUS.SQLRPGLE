     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     FEMINVCUSP O    E             PRINTER OFLIND(INOF)

     D EMINVCUS        PR                  ExtPgm('EMINVCUS')
     D  #SelDate                      6P 0
     D  #SelCust                      6P 0
     D  #EmlName                     30A
     D  #Eml1                        32A
     D  #Eml2                        32A
     D  #Eml3                        32A
     D EMINVCUS        PI
     D  #SelDate                      6P 0
     D  #SelCust                      6P 0
     D  #EmlName                     30A
     D  #Eml1                        32A
     D  #Eml2                        32A
     D  #Eml3                        32A

      *? External Function Prototypes
      /COPY QFunctDefn,$InvoicePO
     D PRTINV          PR                  EXTPGM('PRTINV')
     D  #Invoice                      6P 0 CONST

      *? Local Function Prototypes
     D GetData         PR
     D WriteTracking   PR

      *? Local Field Definitions
     D EndOfFile       S               N
     D Invoice#        S              6P 0
     D LastInvoice#    S              6P 0
     D INOF            S               N

     D RMCUST        E DS                  extname(FMCUST)
     D RMEMAIL       E DS                  extname(FMEMAIL)

      /Free
         Exec SQL
           Select * Into :RMCUST From FMCUST
           Where CMCUST = :#SelCust;
         Exec SQL
           Select * Into :RMEMAIL From FMEMAIL
           Where EMACCT = :#SelCust and EMCODE='INV';

         adr1 = CMADD2;
         adr2 = CMADD3;
         adr3 = %Trim(CMCITY)+', '+CMSTST+' '+CMZIP;
         adr4 = %Trim(EMNAME)+'<'+ %Trim(EMAIL)+'>';

         FileName = 'Invoice_'+%Trim(%EditW(#SelDate:'0      '))
                          +'_'+%Trim(%EditW(#SelCust:'0      '))+'.pdf';
         Write Header;

         #EmlName = EMNAME;
         #Eml1    = %Subst(EMAIL:01:32);
         #Eml2    = %Subst(EMAIL:33:32);
         #Eml3    = %Subst(EMAIL:65:32);

         GetData();
         Dow not EndOfFile;
           CallP PRTINV(Invoice#);
           If INOF;
             Write Header;
             INOF = *Off;
           EndIf;
           Write Detail;
           WriteTracking();
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

         Invoice# = *Zero;

         Exec SQL
           SELECT    WHINV#
           INTO     :Invoice#
           FROM      FHORDW
           WHERE     WHINDT = :#SelDate
            and      WHBLCU = :#SelCust
            and      WHINV# > :LastInvoice#
           ORDER BY  WHINV#
           FETCH FIRST ROW ONLY;

         If Invoice# = *Zero;
           EndOfFile = *On;
          Else;
           EndOfFile = *Off;
           LastInvoice# = Invoice#;
           PO# = '*None';
           PO# = $InvoicePO(Invoice#);
           If PO# = ' ';
             PO# = '*None';
           ENDIF;

           ShipTo = ' ';
           Exec SQL
              SELECT left( trim(WHNAME)
                  ||'|'||  trim(WHSHP2)
                  ||'|'||  trim(WHSHCT)
                  ||', '|| trim(WHSHST)
                  ||'|'||  trim(WHSHZP),55)
              INTO :SHIPTO
              FROM FHORDW WHERE WHINV# = :Invoice#;
         ENDIF;

      /End-Free
     P GetData         E

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Write Tracking                                                   :
      // :..................................................................:
     P WriteTracking   B
     D WriteTracking   PI
      /Free

         Monitor;
           Exec SQL
             INSERT INTO EMINVCUSPF
               VALUES ( :#SELDATE
                      , :#SELCUST
                      , :#EMLNAME
                      , :#EML1
                      , :#EML2
                      , :#EML3
                      , :CMNAME
                      , :ADR1
                      , :ADR2
                      , :ADR3
                      , :ADR4
                      , :INVOICE#
                      , :PO#
                      , :SHIPTO
                      , :FILENAME
                      ,  current timestamp );
           On-Error;
             // Do Nothing !
         EndMon;

      /End-Free
     P WriteTracking   E
