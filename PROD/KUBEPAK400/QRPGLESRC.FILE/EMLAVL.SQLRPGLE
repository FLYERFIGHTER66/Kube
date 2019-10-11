     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: EMLINV.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : EMLINV.01?Original Version                                ?:
      *? :............................................................:

     FEMLINVFM  CF   E             WORKSTN


      //  Main procedure prototype & interface
     D EMLINV          PR                  ExtPgm('EMLINV')
     D  #Invoice                      6P 0
     D EMLINV          PI
     D  #Invoice                      6P 0

      *? Local Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D EmailIt         PR
     D PrintIt         PR
     D isEmailAd       PR              N
     D   #CustEmail                 256A

      *? External Function Prototypes
     D BIC420CLEM      PR                  EXTPGM('BIC420CLEM')
     D   #Invoice                     6A   CONST

     D SENDMIMEIN      PR                  EXTPGM('SENDMIMEIN')
     D   #SUBJECT                    80A   CONST
     D   #SNDNAM                    256A   CONST
     D   #SNDEML                    256A   CONST
     D   #RCVNAM                     48A   CONST
     D   #RCVEML                    256A   CONST
     D   #INVOICE#                    6A   CONST
     D   #SPLFILNAM                  10A   CONST
     D   #SPLFILNBR                   6A   CONST
     D   #SPLJOBNAM                  10A   CONST
     D   #SPLJOBUSR                  10A   CONST
     D   #SPLJOBNBR                   6A   CONST

     D JOB             PR                  EXTPGM('JOB')
     D   #JOBNAM                     10A   CONST
     D   #JOBUSR                     10A   CONST
     D   #JOBNBR                      6A   CONST

     D/COPY QFunctDefn,$ErrMsg
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$PrintPick
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$isCust
     D/COPY QFunctDefn,$InvoicePO
     D/COPY QFunctDefn,$isInvoice
     D/COPY QFunctDefn,QCMDEXC
     D/COPY QFunctDefn,$_DATES

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

     D  Email_DS       DS
     D   CUSNAM                      30A
     D   EMAIL1                      40A
     D   EMAIL2                      40A
     D   EMAIL3                      40A
     D   EMAILREST                  136A
     D   EMAIL                      286A   Overlay(Email_DS)

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Invoice#      S              6S 0                                      ?Invoice# to Print
     D   Invoice@      S              6A                                        ?Invoice# to Print
     D   PO            S             15A                                        ?PO Number
     D   SPLJOBNAM     S             10A                                        ?JOBNAM
     D   SPLJOBUSR     S             10A                                        ?JOBUSR
     D   SPLJOBNBR     S              6A                                        ?JOBNBR
     D   Printer       S             10A                                        ?Printer to Use
     D   CustName      S            256A                                        ?Cust Name
     D   CustEmail     S            256A                                        ?Cust Email Address
     D   BillCust      S              6S 0                                      ?Cust Name
     D   TimeStamp     S               Z                                        ?TimeStamp
     D   User          S             10A                                        ?User ID
     D   NewEmail      S               N                                        ?New Email Flag

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         //#Invoice = 179264;    For Testing
         Invoice@ = %Char(#Invoice);

         PO = $InvoicePO(#Invoice);
         If PO = ' ';
           PO = '*None';
         EndIf;

         If $isInvoice(#Invoice);
           DoW *InLR <> *On;
             Select;
               When Screen = 01;
                 Edit01();
               Other;
                 $ERR_PROG = $PGM;
                 Load01();
                 Scrn01();
             ENDSL;
           ENDDO;
         EndIf;

         *InLR = *On;
         *In03 = *On;
         *In10 = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 1 SubProcedures                                           :
      // :..................................................................:
     P Load01          B
     D Load01          PI
      /Free

         Exec SQL // Get Bill To Customer from Invoice Header
           Select WHBLCU into :BillCust from FHORDW where WHINV# = :#Invoice;

         Clear Email;
         NewEmail = *Off;

         Exec SQL // Get Customer Name and Email Address from FMEMAIL
           Select  EMNAME||EMAIL
           into   :Email
           from    FMEMAIL
           Where EMSTAT = 'A'
             and EMACTT = 'C'
             and EMACCT = :BillCust
             and EMCODE = 'A/P';
         If Email = *Blanks;
           PRTEMLBOTH = 'E';
           NewEmail   = *On;
          Else;
           PRTEMLBOTH = 'P';
         EndIf;

         If PRINTER = ' ';
           Printer = $DftPrt($User():'EMLINV':'*USER');
         EndIf;

      /End-Free
     P Load01          E
      //_____________________________________________________________________
      //
     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         // write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
           exfmt EMLINV01;
         $ClrError();
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
      /Free

         CustEmail = %trim(EMAIL1) + %trim(EMAIL2) + %trim(EMAIL3);
         CustName  = CUSNAM;

         Select;

           When *In03;
             *InLR = *On;
           When *In10;
             PRINTER = $ChgPrt($User():'EMLINV':PRINTER);
             Scrn01();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn01();
           When PRINTER = *Blanks;
             $SndError('PRT0003':' ');
             Scrn01();
           When (PRTEMLBOTH = 'E' or PRTEMLBOTH = 'B')
                  and not isEmailAd(CustEmail);
             $SndError('EML0001':CustEmail);
             Scrn01();
           Other;
             Select;
               When PRTEMLBOTH = 'E';
                 EmailIt();
               When PRTEMLBOTH = 'P';
                 PrintIt();
               When PRTEMLBOTH = 'B';
                 EmailIt();
                 PrintIt();
             EndSl;
             *InLR = *On;
         EndSl;

      /End-Free
     P Edit01          E
      //_____________________________________________________________________
      //
     P EmailIt         B
     D EmailIt         PI
      /Free

         If NewEmail;
           TimeStamp = $TimeStamp;
           User = $User;
           Exec SQL  // Create a new Entry in the FMEMAIL File
             INSERT INTO TGMSDATA/FMEMAIL
             (EMSTAT, EMACTT, EMACCT, EMCODE, EMNAME, EMAIL, EMTMST, EMUSER)
             VALUES('A'
                  , 'C'
                  , :BillCust
                  , 'A/P'
                  , :CustName
                  , :CustEmail
                  , :TimeStamp
                  , :USER  );
         EndIf;

         CallP JOB(SPLJOBNAM:SPLJOBUSR:SPLJOBNBR);
         CallP BIC420CLEM(Invoice@);
         CallP SENDMIMEIN( 'Kube-Pak Invoice Number:' + INVOICE@
           + '. Reference PO#:' + PO                                         : // SUBJECT
           'Kube-Pak Automated Invoice Processing'                           : // SNDNAM
           'DoNotReply@kubepak.com'                                          : // SNDEML
           CustName                                                          : // RCVNAM
           CustEmail                                                         : // RCVEML
           Invoice@                                                          : // ORDER
           'BIR421'                                                          : // SPLFILNAM
           '*Last'                                                           : // SPLFILNBR
           SPLJOBNAM                                                         : // SPLJOBNAM
           SPLJOBUSR                                                         : // SPLJOBUSR
           SPLJOBNBR                                                         );// SPLJOBNBR

      /End-Free
     P EmailIt         E

      //_____________________________________________________________________
      //
     P PrintIt         B
     D PrintIt         PI

     D BIC420CLPT      PR                  EXTPGM('BIC420CLPT')
     D   #Invoice                     6A   CONST
     D   #Printer                    10A   CONST
      /Free

         CallP BIC420CLPT(Invoice@:PRINTER);

      /End-Free
     P PrintIt         E

      //_____________________________________________________________________
      //
     P isEmailAd       B
     D isEmailAd       PI              N
     D  #CustEmail                  256A
    ?D/COPY QFunctDefn,$isEmailAd

      /Free

         Return $isEmailAd(%subst(#CustEmail:001:32):
                           %subst(#CustEmail:033:32):
                           %subst(#CustEmail:065:32):
                           %subst(#CustEmail:097:32):
                           %subst(#CustEmail:129:32):
                           %subst(#CustEmail:161:32):
                           %subst(#CustEmail:193:32):
                           %subst(#CustEmail:225:32));
      /End-Free
     P isEmailAd       E


    ?D/COPY QFunctDefn,$ErrMsgSP
