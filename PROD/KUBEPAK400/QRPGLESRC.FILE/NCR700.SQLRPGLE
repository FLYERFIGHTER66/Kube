     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??:                                                            :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FNCR700FM  CF   E             WORKSTN
     FNCR700P   O    E             PRINTER USROPN
     FFMCUST    IF   E           K DISK                                         ?Order Header

      //  Main procedure prototype & interface
     D NCR700          PR                  ExtPgm('NCR700')
     D NCR700          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$ErrMsg
    ?D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,$isOrder
    ?D/COPY QFunctDefn,QCMDEXC

      *? Data Structures
     D                SDS
     D  $PGM             *PROC

     D Addresses       DS
     D  ADR1
     D  ADR2
     D  ADR3
     D  ADR4
     D   ADR                         35A   Dim(0004) OverLay(Addresses)         ?Address

      *? Field Definitions
     D   Screen        S              3S 0 Inz(0)                               ?Screen Number
     D   RRN02         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 02
     D   RRN03         S              4S 0 Inz(*Zero)                           ?RRN SFL Scrn 03
     D   SelDate7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   Pink          S              1A   Inz('?')                             ?Color Code -?PINK
     D   White         S              1A   Inz('?')                              Color Code - White
     D   ADRX          S              1S 0 Inz(0)                               ?Address Index
     D   OVRPRTF       S            256A   Inz(' ')                             ?Override PRTF

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         DoW *InLR <> *On;
           Select;
             When Screen = 01;
               Edit01();
             When Screen = 02;
               Edit02();
             //When Screen = 03;
               //Edit03();
             Other;
               *In26 = *On;
               $ERR_PROG = $PGM;
               Clear NCR70001;
               Load01();
               Scrn01();
               *In26 = *Off;
           ENDSL;
         ENDDO;

         *InLR = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 1 SubProcedures                                           :
      // :..................................................................:
     P Load01          B
     D Load01          PI
      /Free

         SelCust  = *Zeros;
         SerName  = *Blanks;
         SerPhone = *Zeros;
         SerZip   = *Zeros;
         If PRINTER = ' ';
           Printer = $DftPrt('*NONE':'NCR700':'*PGM');
         EndIf;

      /End-Free
     P Load01          E
      //_____________________________________________________________________
      //
     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 01;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR70001;
         $ClrError();
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
      /Free

         Select;

           When *In03;
             *InLR = *On;
           When *In10;
             PRINTER = $ChgPrt($User():'NCR700':PRINTER);
             Scrn01();
           When not $isPrinter(PRINTER);
             $SndError('PRT0102':PRINTER);
             Scrn01();
           When PRINTER = *Blanks;
             $SndError('PRT0003':' ');
             Scrn01();
           When ValidCust(SelCust);
             Load02();
             Scrn02();
           When SerName <> '';
             SelCust = SearchName(SerName);
             If ValidCust(SelCust);
               Load02();
               Scrn02();
              Else;
               Scrn01();
             ENDIF;
           When SerPhone <> 0;
             //SelCust = SearchPhone(SerPhone);
             Scrn01();
           When SerZip <> 0;
             //SelCust = SearchZip(SerZip);
             Scrn01();
           Other;
             Scrn01();
         EndSl;
      /End-Free
     P Edit01          E

      //_____________________________________________________________________
      //
     P ValidCust       B
     D ValidCust       PI              N
     D #SelCust                       6P 0
     D #ValidCust      S               N
      /Free

         Exec SQL
           SELECT '1'
           into :#ValidCust
           FROM FMCUST
           WHERE CMCUST = :#SelCust
             and CMSTAT = 'A'
           Fetch First Row Only;

         Return #ValidCust;

      /End-Free
     P ValidCust       E

      //_____________________________________________________________________
      //
     P SearchName      B
     D SearchName      PI             6P 0
     D  #SerName                     30A
     D  #Cust          S              6P 0

     D LKCUST          PR                  ExtPgm('LKCUST')
     D  #CMLOOK                            Const Like(CMLOOK)
     D  #CMCUST                            Const Like(CMCUST)
     D  #CMNAME                            Const Like(CMNAME)
      /Free

         CallP LKCUST(%Subst(#SerName:1:15):#CUST:#SerName);

         Return #CUST;

      /End-Free
     P SearchName      E
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 2 SubProcedures                                           :
      // :..................................................................:

     P Load02          B
     D Load02          PI
      /Free

         Clear RMCUST;
         Chain (SelCust) FMCUST;
         CUSTBAR = %Subst('000000' + %Trim(%Char(CMCUST)):
                          %Len(%Trim(%Char(CMCUST)))+1:6);
         ADRX = 0;
         If CMADD2 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = CMADD2;
         EndIf;
         If CMADD3 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = CMADD3;
         EndIf;
         If CMADD4 <> *Blanks;
           ADRX += 1;
           ADR(ADRX) = CMADD4;
         EndIf;
         ADRX += 1;
         ADR(ADRX) = %Trim(CMCITY) + ', ' + CMSTST + ' ' + CMZIP ;

      /End-Free
     P Load02          E

      //_____________________________________________________________________
      //

     P Scrn02          B
     D Scrn02          PI
      /Free
         Screen = 02;
         write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt NCR70002;
         $ClrError();
      /End-Free
     P Scrn02          E

      //_____________________________________________________________________
      //

     P Edit02          B
     D Edit02          PI
      /Free
         Select;
           When *In03;
             *InLR = *On;
           When *In01;
             PrintTicket();
             Load01();
             Scrn01();
           When *In10;
             PRINTER = $ChgPrt($User():'NCR700':PRINTER);
             Scrn02();
           Other;         // Process Scan and Subfile
             Scrn02();
         EndSl;
      /End-Free
     P Edit02          E

      //_____________________________________________________________________
      //
     P PrintTicket     B
     D PrintTicket     PI
     D PrtOrder        S              6S 0
     D LastOrder       S              6S 0
      /Free

         If %Open(NCR700P);
           Close NCR700P;
         EndIf;
         If Printer = ' ';
           Printer = 'P6';
         EndIf;

         OVRPRTF = 'OVRPRTF FILE(NCR700P)' +
                          ' FORMTYPE(*NAR)' +
                          ' OUTQ(' + %Trim(Printer) + ') ' +
                          ' OPNSCOPE(*JOB)';
         QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
         Open NCR700P;

         Write RTICKET;

         PrtOrder = 999999;
         DoW PrtOrder <> 0;
           PrtOrder = 0;
           Exec SQL
             Select  ohord#
             into   :PrtOrder
             from    fhordr
             where   ohcust = :SelCust
               and   ohstat <> 'D'
               and   ohcomp = 1
               and   ohord# not in (Select PLORD# from PLUG_ORD)
               and   ohord# > :LastOrder
             Fetch First Row Only;

           If PrtOrder <> 0;
             BarOrder = %Subst('000000' + %Trim(%Char(PrtOrder)):
                           %Len(%Trim(%Char(PrtOrder)))+1:6);
             Exec Sql
               Select   OHNAME
               into    :OHNAME
               from     FHORDR
               Where    OHORD# = :PrtOrder;

             Write DETAIL;

           EndIf;

           LastOrder = PrtOrder;

         EndDo;
         Write FOOTER;
         Close NCR700P;

      /End-Free
     P PrintTicket     E

      //_____________________________________________________________________
      //
     D/COPY QFunctDefn,$ErrMsgSP
