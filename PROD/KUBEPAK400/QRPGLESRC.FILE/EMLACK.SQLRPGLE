     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: EMLACK.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : EMLACK.01?Original Version                                ?:
      *? :............................................................:

     FEMLACKFM  CF   E             WORKSTN


      //  Main procedure prototype & interface
     D EMLACK          PR                  ExtPgm('EMLACK')
     D  #Order                        6P 0
     D EMLACK          PI
     D  #Order                        6P 0

      *? Function Prototypes
     D Load01          PR
     D Scrn01          PR
     D Edit01          PR
     D EmailIt         PR

     D BIC420CLEM      PR                  EXTPGM('BIC420CLEM')                  Generate PDF
     D   #Order                       6A   CONST
     D   #LPLUG                       1A   CONST
     D   #LINK                      256A   CONST

     D* BIC420CLPT      PR                  EXTPGM('BIC420CLPT')
     D*   #Order                       6A   CONST
     D*   #LPLUG                       1A   CONST

     D OPENLINK        PR                  EXTPGM('OPENLINK')
     D   #LINK                      256A   CONST

     D SENDACKPDF      PR                  EXTPGM('SENDACKPDF')
     D   #SUBJECT                    80A   CONST
     D   #SNDNAM                    256A   CONST
     D   #SNDEML                    256A   CONST
     D   #RCVNAM                     48A   CONST
     D   #RCVEML                    256A   CONST
     D   #ORDER@                      6A   CONST
     D   #LINK                      256A   CONST

     D*WSORDERACK      PR                  EXTPGM('WSORDERACK')
     D*  POrderNo                     6P 0 CONST
     D*  HttpStatus                  10I 0 CONST

     D WSSBMORACK      PR                  EXTPGM('WSSBMORACK')
     D   POrderNo                     6P 0 CONST

     D SNDPCMSG        PR                  EXTPGM('SNDPCMSG')
     D   PCMessage                  256A   CONST

     D* JOB             PR                  EXTPGM('JOB')
     D*   #JOBNAM                     10A   CONST
     D*   #JOBUSR                     10A   CONST
     D*   #JOBNBR                      6A   CONST

     D* DLTJOBSPLF      PR                  EXTPGM('DLTJOBSPLF')
     D*   #FILENAME                   10A   CONST
     D*   #JOBNAM                     10A   CONST
     D*   #JOBUSR                     10A   CONST
     D*   #JOBNBR                      6A   CONST

    ?D/COPY QFunctDefn,$OrderBil2
    ?D/COPY QFunctDefn,$OrderPO
    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$isOrder
    ?D/COPY QFunctDefn,$PrintPick
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$isCust
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$_DATES

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
     D   BillCust      S              6S 0                                      ?Cust Name
     D   TimeStamp     S               Z                                        ?TimeStamp
     D   User          S             10A                                        ?User ID
     D   NewEmail      S               N                                        ?New Email Flag
     D   Link          S            256A                                        ?Link to PDF
     D   LPLUG         S              1A                                        ?isPlugOrder
     D OriginalEmail   S            256A
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         //#Order = 179264;    For Testing
         Order@ = %Char(#Order);

         PO = $OrderPO(#Order);
         If PO = ' ';
           PO = '*None';
         EndIf;

         If $isOrder(#Order);
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

         dcl-s CustNo Zoned(6:0) Inz(0);

         Exec SQL // Get Bill To Customer from Order Header
           Select OHBLCU, OHCUST
            into :BillCust, :CustNo
            from FHORDR where OHORD# = :#Order;

         If BillCust = 009785;   // 1/04/2019 - If Cust is Master Nursery Send to Ship Cust
           BillCust = CustNo;
         ENDIF;

         LPLUG = 'F';
         Exec SQL // Determine if this is a plug order
           Select 'P' into :LPLUG from PLUG_ORD where PLORD# = :#Order
           Fetch First Row Only;

         Clear Email;
         NewEmail = *Off;

         Exec SQL // Get Customer Name and Email Address from FMEMAIL
           Select  EMNAME||EMAIL
           into   :Email
           from    FMEMAIL
           Where EMSTAT = 'A'
             and EMACTT = 'C'
             and EMACCT = :BillCust
             and EMCODE = 'OAC';
         OriginalEmail = %SubSt(Email:31:256);  // Email Address begins in POS 31
         If Email = *Blanks;
           PRTEMLBOTH = 'P';
           NewEmail   = *On;
          Else;
           PRTEMLBOTH = 'E';
         EndIf;

         If PRINTER = ' ';
           Printer = $DftPrt($User():'EMLACK':'*USER');
         EndIf;

         Subject = 'Order Number:'+ORDER@+'-Acknowledgement. Reference PO#:'+PO;

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
           exfmt EMLACK01;
         $ClrError();
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
      /Free

       dcl-s httpStatus int(10:0);

         CustEmail = %trim(EMAIL1) + %trim(EMAIL2) + %trim(EMAIL3);
         CustName  = CUSNAM;

         Select;

           When *In03;
             *InLR = *On;
           //When *In10;
           //  PRINTER = $ChgPrt($User():'EMLACK':PRINTER);
           //  Scrn01();
           //When not $isPrinter(PRINTER);
           //  $SndError('PRT0102':PRINTER);
           //  Scrn01();
           //When PRINTER = *Blanks;
           //  $SndError('PRT0003':' ');
           //  Scrn01();
           When (PRTEMLBOTH = 'E' or PRTEMLBOTH = 'B')
                  and not isEmailAd(CustEmail);
             $SndError('EML0001':CustEmail);
             Scrn01();
           Other;
             CallP BIC420CLEM(Order@:LPLUG:LINK);
          // CallP WSORDERACK(#Order:httpStatus);    Changed 2/7/19 wjb -> submit instead
             CallP WSSBMORACK(#Order);  // Attempt B2B XML Send (Submit)
             If HttpStatus = 0;
               callp SNDPCMSG('Success!\n\n' +
                  'This acknowledgement was sent electronically via B2B!');
             EndIf;
             Select;
               When PRTEMLBOTH = 'E';
                 If not B2BEmailHold(#Order);
                   EmailIt();
                 ENDIF;
               When PRTEMLBOTH = 'P';
                 PrintIt();
               When PRTEMLBOTH = 'B';
                 If not B2BEmailHold(#Order);
                   EmailIt();
                 ENDIF;
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
                  , 'OAC'
                  , :CustName
                  , :CustEmail
                  , :TimeStamp
                  , :USER  );
         EndIf;

         //CallP JOB(SPLJOBNAM:SPLJOBUSR:SPLJOBNBR);
         //CallP DLTJOBSPLF('BIR421':SPLJOBNAM:SPLJOBUSR:SPLJOBNBR);
         //CallP BIC420CLEM(Order@:LPLUG:LINK);

         CallP SENDACKPDF(
           SUBJECT                                                           : // SUBJECT
           'Kube-Pak Automated Order Acknowledgements'                       : // SNDNAM
           'DoNotReply@kubepak.com'                                          : // SNDEML
           CustName                                                          : // RCVNAM
           CustEmail                                                         : // RCVEML
           ORDER@                                                            : // ORDER
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

      //_____________________________________________________________________
      //
      /Free
         dcl-proc B2BEmailHold;
           dcl-pi B2BEmailHold ind;
             Order# packed(6:0);
           END-PI;
           // This subprocedure will:
           //   1. Determine if the given order is a B2B order (If not, No Hold)
           //   2. Determine if the broker gets B2B acknowledgement emails (If not, No Hold)
           //   3. See if user has changed the email address (If so, No Hold)
           //
           dcl-s Hold          ind inz(*On);
           dcl-s NoHold        ind inz(*Off);
           dcl-s isB2B         ind inz(*Off);
           dcl-s Broker_Name   char(30) inz(*Blanks);
           dcl-s getsB2Bemail  char(1) inz('N');
           dcl-s UserChanged   ind inz(*Off);
           Exec SQL // Determine if the given order is a B2B order (If not, Okay to send)
           Select '1', phfrorid into :isB2B, :Broker_Name from WSPOHDRPF
             where phordno = :Order#
             Fetch first row only;
           If not isB2B;
             return noHold;
            else;
             Exec SQL //Determine if the broker gets B2B acknowledgement emails (If not, No Hold)
               Select brok.BROKER_VARIABLE_VALUE into :getsB2Bemail
               from   FBROKDFT as look
               join   FBROKDFT as brok
                 on   look.BROKER_VARIABLE = 'FromOrgId_BROKER'
                 and  brok.BROKER_VARIABLE = 'B2B_SENDS_EMAIL_ACK'
                 and  look.BROKER_NUMBER = brok.BROKER_NUMBER
               where  look.BROKER_VARIABLE_VALUE = :Broker_Name
               Fetch first row only;
             If getsB2Bemail = 'N';
               return noHold;
              else;
               If CustEmail <> OriginalEmail;
                 return noHold;
                Else;
                 return Hold;
               ENDIF;
             ENDIF;
           ENDIF;

           return isB2B;
         END-PROC;
      /End-Free

    ?D/COPY QFunctDefn,$ErrMsgSP
