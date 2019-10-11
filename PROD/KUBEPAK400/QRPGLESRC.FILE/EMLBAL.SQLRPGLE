     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: EMLBAL.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2015                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : EMLACK.01?Original Version                                ?:
      *? :............................................................:

     FEMLBALFM  CF   E             WORKSTN


      //  Main procedure prototype & interface
     D EMLBAL          PR                  ExtPgm('EMLBAL')
     D  #Customer                     6P 0
     D  #Link                       256A
     D EMLBAL          PI
     D  #Customer                     6P 0
     D  #Link                       256A

     D SENDBALPDF      PR                  EXTPGM('SENDBALPDF')
     D   #SUBJECT                    80A   CONST
     D   #SNDNAM                    256A   CONST
     D   #SNDEML                    256A   CONST
     D   #RCVNAM                     48A   CONST
     D   #RCVEML                    256A   CONST
     D   #LINK                      256A   CONST

     D OPENLINK        PR                  EXTPGM('OPENLINK')
     D   #LINK                      256A   CONST

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D EmailIt         PR
     D PrintIt         PR
     D*isEmailAd       PR
     D* #CustEmail                  256A

     D/COPY QFunctDefn,$ErrMsg
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$isCust
     D/COPY QFunctDefn,QCMDEXC
     D/COPY QFunctDefn,$_DATES

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

     D  Email_DS       DS
     D   CUSNAM                      30A
     D   EMAIL1                      55A
     D   EMAIL2                      55A
     D   EMAIL3                      55A
     D   EMAILREST                   91A
     D   EMAIL                      286A   Overlay(Email_DS)
     D  Subject_DS     DS
     D   SUBJECT               1     70A
     D   SUBJECT1              1     35A
     D   SUBJECT2             36     70A

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Order#        S              6S 0                                      ?Order# to Print
     D   Order@        S              6A                                        ?Order# to Print
     D   PO            S             15A                                        ?PO Number
     D   SPLJOBNAM     S             10A                                        ?JOBNAM
     D   SPLJOBUSR     S             10A                                        ?JOBUSR
     D   SPLJOBNBR     S              6A                                        ?JOBNBR
     D   Printer       S             10A                                        ?Printer to Use
     D   CustName      S            256A                                        ?Cust Name
     D   CustEmail     S            256A                                        ?Cust Email Address
     D   Customer      S              6A                                        ?Customer
     D   BillCust      S              6S 0                                      ?Cust Name
     D   TimeStamp     S               Z                                        ?TimeStamp
     D   User          S             10A                                        ?User ID
     D   NewEmail      S               N                                        ?New Email Flag
     D   Link          S            256A                                        ?Link to PDF
     D   LPLUG         S              1A                                        ?isPlugOrder

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         Customer = %Char(#Customer);
         Link = #Link;
         Display = 'N';

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

         Clear Email;
         NewEmail = *Off;

         Exec SQL // Get Customer Name and Email Address from FMEMAIL
           Select  EMNAME||EMAIL
           into   :Email
           from    FMEMAIL
           Where EMSTAT = 'A'
             and EMACTT = 'C'
             and EMACCT = :#Customer
             and EMCODE = 'STM';

         Subject = 'A/R Balance Statement from Kube-Pak. Account: ' + Customer;

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
           exfmt EMLBAL01;
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
           When not isEmailAd(CustEmail);
             Scrn01();
           Other;
             EmailIt();
             If Display = 'Y';
               PrintIt();
             EndIf;
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
                  , 'OAC'
                  , :CustName
                  , :CustEmail
                  , :TimeStamp
                  , :USER  );
         EndIf;

         CallP SENDBALPDF(
           SUBJECT                                                           : // SUBJECT
           'Kube-Pak Automated Statements'                                   : // SNDNAM
           'DoNotReply@kubepak.com'                                          : // SNDEML
           CustName                                                          : // RCVNAM
           CustEmail                                                         : // RCVEML
           LINK                                                             ); // LINK

      /End-Free
     P EmailIt         E

      //_____________________________________________________________________
      //
     P PrintIt         B
     D PrintIt         PI
      /Free

         CallP OPENLINK(LINK);

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
