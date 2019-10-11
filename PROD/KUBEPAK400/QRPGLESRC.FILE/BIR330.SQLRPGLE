      *--------------------------------------------------------------
      *   ANY CHANGES TO PRINT FORMAT CHANGE IN BIR331
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.     1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR330  - INVOICE PRINT PROGRAM
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- THIS PROGRAM WILL PRINT INVOICES.
      **
      *
      *   CHANGE--DATE-------DESCRIPTION
      *  5/22/97 EFD ADD NUMBER OF PIECES.
      *  5/28/97 EFD GET LIST CODE BASED ON SHIP FROM
      *  6/11/97 GD  ADD PO NUMBER PRINT
      *  6/25/97 EFD DO NOT PRINT SPEC PRICE MESSAGE IF PRICE GT IMSEL1
      *  7/23/97 GD  ADDED TERMS CODE 02 DEFERRED INVOICE
      * 11/04/97 GD  CHANGED EDIT CODE ON LINE ITEM TO PRINT .00
      * 11/20/97 EFD CHANGED COMMENT TO NOT PRINT EXTENDED AMOUNT.
      * 12/03/97 EFD DO NOT PRINT MULT COPIES IF POS INVOICE.
      * 12/11/97 EFD CALC COPIES FROM KATY'S LIST.
      *  1/09/98 EFD FRESH ONLY 1 COPY OF TAKEN INVOICES.
      * 10/07/98 GD  CHANGED HORDWRS TO PRINT IN ROUTE/STOP SEQ
      *  2/22/99 EFD DO NOT PRINT QTYS FOR ROYALTIES
      *  9/10/99 EFD ADD LOGIC FOR SKU AND CUST ITEM NUMBER. CUST 7124
      *  4/22/02 EFD PRINT SPECIAL CHARGE ON SUMMARY LINE.
      *  2/25/03 CAB CHANGED SPECS FOR THE NEW INVOICES.
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *
     FFHORDW    IF   E           K DISK
     F                                     RENAME(RHORDW:HORDWI)
     FFHORDWRS  IF   E           K DISK
     FFHORDISCNTIF   E           K DISK
     FFIORDW    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCUSTNO   IF   E           K DISK
     FFPAYMNTI  IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFOECTL    UF   E           K DISK
     FFMSIZE    IF   E           K DISK
WJB  FFMSIZC    IF   E           K DISK
     FFOINVT    IF   E           K DISK
     FBIR330A   O    F  132        PRINTER OFLIND(*INOF)
     F                                     FORMLEN(66)
     F                                     FORMOFL(65)
      *
      * ADDRESS ARRAYS
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      * PRINT ARRAYS
     D MSG             S             50    DIM(1) CTDATA PERRCD(1)              MESSAGE
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      * REPRINT Y/N
     D  LDARPT                 3      3
      * JOBQ Y/N
     D  LDAJBQ                 4      4
      * ROUTE I.D.
     D  LDARTE                 5      6
      * ROUTE ALL
     D  LDAALL                 7      9
      * BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                 10     15  0
      * ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 16     21  0
      * FORM NUMBER
     D**                                     21  30 LFORM
      * PRINTER I.D.
     D  LPRTR                 31     40
      * INVOICE DATE
     D  LDATE                 41     46  0
      * SHIP FROM LOCATION
     D  LSHFR                 47     49
      * BEGINING ORDER NUMBER
     D  LBORD                 50     55  0
      * ENDING ORDER NUMBER
     D  LEORD                 56     61  0
      ** CANCEL  X=CANCEL
     D  LCANCL                62     62
      ** POINT OF SALE INVOICE Y/N
     D  LPOS                  63     63
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 64     64
      /Free
       dcl-s SVIADESC like(WIDES1);
      /End-Free
     IRHORDW
     I              WHNAME                      #WSHP1
     I              WHSHP2                      #WSHP2
     I              WHSHP3                      #WSHP3
     I              WHSHP4                      #WSHP4
     I              WHSHCT                      #WSHCT
     I              WHSHST                      #WSHST
     I              WHSHZP                      #WSHZP
     I              WHSLD1                      #WSLD1
     I              WHSLD2                      #WSLD2
     I              WHSLD3                      #WSLD3
     I              WHSLD4                      #WSLD4
     I              WHSLCT                      #WSLCT
     I              WHSLST                      #WSLST
     I              WHSLZP                      #WSLZP
     IHORDWI
     I              WHNAME                      #WSHP1
     I              WHSHP2                      #WSHP2
     I              WHSHP3                      #WSHP3
     I              WHSHP4                      #WSHP4
     I              WHSHCT                      #WSHCT
     I              WHSHST                      #WSHST
     I              WHSHZP                      #WSHZP
     I              WHSLD1                      #WSLD1
     I              WHSLD2                      #WSLD2
     I              WHSLD3                      #WSLD3
     I              WHSLD4                      #WSLD4
     I              WHSLCT                      #WSLCT
     I              WHSLST                      #WSLST
     I              WHSLZP                      #WSLZP
      *
     C*
      *POS
     C                   Z-ADD     1             FIRST             6 0
     C     LDARPT        IFEQ      'Y'
     C                   SETON                                        44
     C                   ELSE
     C                   SETOFF                                       44
     C                   END
      *
     C     LBINV         IFGT      0
     C                   SETON                                        32
     C                   ENDIF
      *** CHECK IF BEG INVOICE = END THEN ONLY PRINT 1 AND EXIT
     C                   SETOFF                                       33
      ** SKIP TEMP
     C   32
     CAN 33LBINV         IFEQ      LEINV
     C                   SETON                                        33
     C     LBINV         CHAIN     FHORDW                             90
     C   90              GOTO      END
     C                   END
      *
     C                   MOVEL     *BLANKS       WHROUT
     C     WHROUT        SETLL     FHORDWRS
     C     NXT           TAG
     C                   EXSR      CLEAR
     C                   Z-ADD     0             LINE              2 0
     C                   Z-ADD     0             PAGE              2 0
     C                   SETOFF                                       47
     C                   READ      FHORDWRS                               90
     C   90              GOTO      END
     C  N32              GOTO      NOREP
     C     WHINV#        IFLT      LBINV
     C                   GOTO      NXT
     C                   ENDIF
     C     WHINV#        IFGT      LEINV
     C                   GOTO      NXT
     C                   ENDIF
     C     NOREP         TAG
      *** CHECK FOR SHIP FROM
     C**         LSHFR     IFGT *BLANKS
     C**         WHSHFR    ANDNELSHFR
     C**                   GOTO NXT
     C**                   ENDIF
      *** CHECK FOR POINT OF SALE
     C     LDARPT        IFNE      'Y'
     C     WHPOS         ANDEQ     'P'
     C     LPOS          ANDNE     'P'
     C                   GOTO      NXT
     C                   ENDIF
      *** CHECK FOR IMMEDIATE PRINT
     C     LDARPT        IFNE      'Y'
     C     WHIMED        ANDEQ     'Y'
     C     LIMED         ANDNE     'Y'
     C                   GOTO      NXT
     C                   ENDIF
     C     WHPOS         IFEQ      'P'
     C                   SETON                                        42
     C                   ELSE
     C                   SETOFF                                       42
     C                   ENDIF
      * CHECK IF HOME DEPOT
     C                   SETOFF                                       81
     C     WHARCU        IFEQ      7124
     C                   SETON                                        81
     C                   END
      * CHECK IF CASH AND CARRY DISCOUNT ON REG INVOICE
     C                   SETOFF                                       43
     C  N42              DO
     C     HIKEY         KLIST
     C                   KFLD                    WHINV#
     C                   KFLD                    SEQ#              3 0
     C                   Z-ADD     996           SEQ#
     C     HIKEY         CHAIN     FIORDW                             98
     C**N98                SETON                     43
     C                   ENDDO
      *
      *   CHECK THE MESSAGES IN THE COMPANY CONTROL FILE.
      *
     C     FIRST         IFEQ      1
     C     WHCOMP        CHAIN     FMCOMP                             98
     C  N98MCMSG1        COMP      *BLANKS                            6161
     C  N98MCMSG2        COMP      *BLANKS                            6262
     C  N98MCMSG3        COMP      *BLANKS                            6363
     C  N98MCMSG4        COMP      *BLANKS                            6464
     C                   ENDIF
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
     C                   EXSR      GTDAT
      *
     C                   MOVEL     *BLANKS       TDESC            20
     C     WHTMCD        IFGT      '49'
     C     WHTMCD        ANDLT     '61'
     C                   MOVEL     WHTERM        TDESC            20
     C                   ENDIF
     C**         WHTMCD    IFEQ 02
     C**                   MOVEL'Deferred'DDESC  16
     C**                   MOVE ' Invoice'DDESC
     C**                   ELSE
     C**                   MOVEL*BLANKS   DDESC  16
     C**                   ENDIF
      *
      * GET CUSTOMER TELE NUMBER
      *
     C                   Eval      CMBABB = ' '
     C     WHCUST        CHAIN     FMCUST                             90
     C                   Z-ADD     CMPHON        PHONE            11 0
     C   90              Z-ADD     0             PHONE
     C                   if        CMBABB = 'MASTR'
     C                   eval      *In70 = *Off                                 Dont Print Terms
     C                   else
     C                   eval      *In70 = *On                                  Print Terms
     C                   endif
     C     CMCOPY        IFLT      1
     C                   Z-ADD     1             COPY              1 0
     C                   ELSE
     C                   Z-ADD     CMCOPY        COPY
     C                   ENDIF
     C*          WHSHFR    IFNE 'F  '
     C*          LPOS      IFEQ 'P'
     C*          WHSHPC    OREQ 'T '
     C*                    Z-ADD2         COPY
     C*                    ENDIF
     C*                    END                             SHFR <> F
     C     LDARPT        IFEQ      'Y'
     C                   Z-ADD     1             COPY
     C                   END
      *
     C     WHSHFR        CHAIN     FMDEPT                             88
     C   88              MOVE      *BLANKS       DEDESC
     C     NXTCPY        TAG
     C                   Z-ADD     WHDTAC        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DTAC              6 0
      /Free
       // If the order did not ship Truck (SVIA = 01 or 41)
         //then use SVIA description instead of ROUTE: & STOP:
       If WHSHPC = '01' or WHSHPC = '41';
         *In68 = *On;  // Ship Via Truck Indicator
        Else;
         *In68 = *Off; // Ship Via Truck Indicator
         SVIADESC = *Blanks;
         Exec SQL // GET SVIA record freom Invoice Detail
           Select  WIDES1
           into   :SVIADESC
           from    FIORDW
           where   WIINV# = :WHINV#
             and   WIITEM = 'SVIA'
           Fetch First Row Only;
       ENDIF;
      /End-Free
     C                   EXCEPT    HDG1                                         HEADINGS
     C                   Z-ADD     0             LINE
     C   81              Z-ADD     1             LINE
      * 6/11/97
     C     WHPONO        IFGT      *BLANKS
     C                   SETON                                        47
     C**                   EXCPTHDG2
     C                   ENDIF
      *
     C     WHINV#        SETLL     FIORDW
     C     NXTI          TAG
     C     WHINV#        READE     FIORDW                                 97
      ** PRINT TOTALS
     C   97              DO
WJB  C                   Clear                   RHORDISCNT
WJB  C     WHORD#        Chain     FHORDISCNT
WJB  C                   If        %Found(FHORDISCNT) and ADDSC1 > 0
WJB  C                   Z-Add     ADDSC1        EODPCT            2 0
WJB  C     ADDSC1        Div       -100          EOD               5 5
WJB  C     SUBTOT        Mult      EOD           EOD$              7 2
WJB  C                   Sub       EOD$          WHDIS$
WJB  C                   Eval      *In34 = *On
WJB  C                   Else
WJB  C                   Z-Add     *Zero         EODPCT            2 0
WJB  C                   Eval      *In34 = *Off
WJB  C                   EndIf
WJB  C                   Z-Add     *Zero         TRDPCT            2 0
     C     WHDIS$        IFNE      0.00
WJB  C*                  Eval      TRDPCT = %INT((WHDIS$/SUBTOT)*-100)
     C     WHDIS$        DIV       SUBTOT        TMPPCT            5 5
     C     TMPPCT        Mult(H)   -100          TRDPCT
     C                   SETON                                        29
     C                   ELSE
     C                   SETOFF                                       29
     C                   END
     C     WHTAX$        IFNE      0.00
     C                   SETON                                        28
     C                   ELSE
     C                   SETOFF                                       28
     C                   END
     C                   SETOFF                                       26
     C                   MOVE      *BLANKS       CCPAYTY          13            CC Pay ThankYou
      /FREE
       IF WHCASH <> 0.00;
         CHAIN WHINV# FPAYMNTI;
         *IN90 = NOT %FOUND;
         If %Found and PYCHEK <> *Blanks;
           *IN26 = *ON;
         ENDIF;
         CCPAYTY = 'CC: ' + %trim(PYCRCD) +
             ' ' + %Subst(%editw(PYCRC#:'0               '):13:4);
         *IN27 = *ON;
       ELSE;
         *IN27 = *OFF;
       ENDIF;
      /END-FREE
     C     TOTROY        IFGT      0.00
     C                   SETON                                        31
     C                   ELSE
     C                   SETOFF                                       31
     C                   END
     C     WH$AMT        ADD       WHFET$        TOTINV            9 2
     C                   MOVEL     MSG(1)        PCSMSG           38
     C                   Z-ADD     WHTBLK        NOPCS             5 067
     C                   TIME                    TIMOD             6 0
     C                   MOVEL     TIMOD         TIME              4 0
     C                   MOVEL     WHTIME        PTIME             4 0
     C                   Z-ADD     0             NODISC            9 2
     C                   eval      NODISC = TOTINV - WHDIS$
     C                   EXCEPT    TOTL1
     C                   SUB       1             COPY
     C     COPY          IFGT      0
     C                   Z-ADD     0             SUBTOT
     C                   Z-ADD     0             TOTROY
     C                   Z-ADD     0             DELIV
     C                   Z-ADD     0             SPCHG             7 2
     C                   SETOFF                                       97
     C                   GOTO      NXTCPY
     C                   ELSE
     C                   Z-ADD     0             DELIV
     C                   Z-ADD     0             TOTROY
     C                   Z-ADD     0             SUBTOT
     C                   Z-ADD     0             SPCHG
     C                   GOTO      NXT
     C*  33                GOTO END
     C                   ENDIF
     C                   ENDDO                                                  97 DO
      *
     C                   SETOFF                                       253051
     C                   SETOFF                                       2441
     C                   SETOFF                                       4546
     C                   SETOFF                                       353839
     C                   SETON                                        30
      ** IF B/O + ORD DO NOT PRINT
     C     WIQORD        IFEQ      WIQBOO
     C     WIITYP        ANDEQ     ' '
     C     WISIZE        ANDNE     'ROY'
     C                   GOTO      NXTI
     C                   END
      *
      *  IF THE TYPE IS FREIGHT OR SPECIAL DO NOT PRINT UNIT PRICE.
      *
     C     WIITYP        IFEQ      'S'
     C     WIITYP        OREQ      'C'
     C     WIITYP        OREQ      'F'
     C                   SETON                                        38        DON'T PRINT PRC
     C                   ENDIF
     C  N38              SETON                                        39        DON'T PRINT PRC
      ** CHECK IF COMMENT
     C     WIITYP        IFEQ      'C'
     C                   SETON                                        37
     C                   ELSE
     C                   SETOFF                                       37
     C                   END
      *
      * GET SUBTOTAL
      *
     C*          WIITYP    IFNE 'F'
     C*                    ADD  WIEXT$    SUBTOT  92
     C*                    ENDIF
      *
      *    REMOVE DECIMALS FROM QUANTITIES
      *
     C     WISIZE        IFEQ      'ROY'
     C                   Z-ADD     0             SVORD
     C                   Z-ADD     0             SVINV
     C                   Z-ADD     0             SVBOO
     C                   Z-ADD     0             SVSHP
     C                   ELSE
     C                   Z-ADD     WIQORD        SVORD             5 1
     C                   Z-ADD     WIQINV        SVINV             5 1
     C                   Z-ADD     WIQBOO        SVBOO             5 1
     C                   Z-ADD     WIQSHP        SVSHP             5 1
     C                   END
      *
     C                   Z-ADD     WIUPRI        SVUPRI            9 4
      *10/9/96
     C*                    MOVE SVUPRI    TEST    22
     C*          TEST      IFGT *ZEROS
     C                   Z-ADD     WIUPRI        UPRI94            9 4
     C*                    SETON                     20
     C*                    ELSE
     C                   Z-ADD     WIUPRI        UPRI72            7 2
     C     WIITYP        IFEQ      'S'
     C     WIITYP        OREQ      'C'
     C     WIITYP        OREQ      'F'
     C                   Z-ADD     *ZEROS        UPRI72
     C                   Z-ADD     *ZEROS        UPRI94
     C                   ENDIF
     C*                    SETOF                     20
     C*                    ENDIF
     C     SVBOO         COMP      0                                      55
      *
      *    ACCUMULATE ORDER TOTALS FOR EACH INVO
      *
      * GET ITEM DESCRIPTION
      *
     C     KEY15         KLIST
     C                   KFLD                    WIITEM
     C                   KFLD                    WISIZE
     C                   KFLD                    WIWHSE
     C     KEY15         CHAIN     FMINVT                             90
     C     WISIZE        IFNE      'ROY'
     C  N81              EXSR      GETDES
     C   81              EXSR      GETXRF
     C                   ELSE
WJB  C                   MOVEL     WIDES1        DESC
WJB  C                   MOVEL     WIDES1        DESC29
     C                   MOVE      *BLANKS       WIITEM
     C                   END
WJB  C   38              MOVEL     WIDES1        DESC
WJB  C   38              MOVEL     WIDES1        DESC29
      *
     C     WIITYP        IFEQ      'F'
     C                   ADD       WIEXT$        DELIV             9 2
     C**                   GOTO FRT
     C                   ENDIF
     C     WIITYP        IFEQ      'S'
     C                   ADD       WIEXT$        SPCHG
     C                   ENDIF
      * 12/3/96
      * 45 = PRICE OR DISCOUNT OVERRIDDEN
      * 46 = DISCOUNT ON LINE ITEM
      *
     C*          WIOVER    IFEQ 'Y'
     C*          WIUPRI    ANDGT0
     C*          WIUPRI    ANDLTIMSEL1
      *** TEMP FOR L.V.
     C*          IMWHSE    ANDNE'L  '
     C*                    SETON                     45
     C*                    ENDIF
     C*          WIQDDC    IFNE *ZEROS
     C*                    SETON                     46
     C*                    ENDIF
      *
      * CASH AND CARRY DISCOUNT
      *
     C*  43
     C*R 42      WIPPDC    IFNE 'N'
     C* N45N46             SETON                     41
     C*                    ENDIF
     C                   ADD       SVINV         TOTSHP            6 1
     C                   ADD       SVORD         TOTORD            6 1
     C                   ADD       SVBOO         TOTBOO            6 1
    ?C*  ADD SALEABLE CELLS TO PLUGS
     C                   SETOFF                                       99
WJB  C*    WISIZE        IFEQ      '105'
WJB  C*    WISIZE        OREQ      '162'
WJB  C*    WISIZE        OREQ      '288'
WJB  C*    WISIZE        OREQ      '512'
WJB  C     WISIZE        CHAIN     FMSIZC
WJB  C                   If        %Found(FMSIZC) and SCCATG = 'PLUG'
     C     OVRKEY        KLIST
     C                   KFLD                    WIITEM
     C                   KFLD                    WISIZE
     C     WISIZE        CHAIN     FMSIZE                             48
     C                   MOVE      SZSALE        SZSAL@            3
     C     OVRKEY        CHAIN     FOINVT                             49
     C  N49              MOVE      OVSALE        SZSAL@            3
     C  N48
     CORN48              SETON                                        99
     C                   ENDIF
     C                   EXCEPT    DETL1                                                    T.
     C                   ADD       1             LINE
     C   45
     COR 46              EXCEPT    DETCOM                                                   T.
      *
     C   45
     COR 46              ADD       1             LINE
      *
     C     WIITYP        IFNE      'F'
     C     WIITYP        ANDNE     'S'
     C     WISIZE        ANDNE     'ROY'
     C*                    ADD  WIEXT$    SUBTOT  72
     C                   ADD       WIAMT         SUBTOT            7 2
     C                   ENDIF
     C     WISIZE        IFEQ      'ROY'
     C                   ADD       WIAMT         TOTROY            7 2
     C                   ENDIF
      *
     C   47LINE          COMP      33                                 50  50
     C  N47LINE          COMP      34                                 50  50
     C   50              EXCEPT    CONT1                                        CONTINUATION
      *
     C   50              SETON                                        40
     C   50              Z-ADD     0             LINE
     C   50
     CAN 81              Z-ADD     1             LINE
     C                   SETOFF                                       50
      *
     C   40              EXCEPT    HDG1                                         NEXT PAGE
      *
     C                   SETOFF                                       3040
     C     FRT           TAG
     C                   GOTO      NXTI
      *
     C     END           TAG
     C     LDACOP        CHAIN     FOECTL                             96
     C  N96              Z-ADD     LDATE         OCDTIP
     C                   UPDATE    ROECTL
     C                   SETON                                        LR
      *
      **************
      ****  CLEAR  *
      **************
     C     CLEAR         BEGSR
     C                   MOVEA     *BLANKS       #SL
     C                   MOVEA     *BLANKS       #SH
     C                   Z-ADD     *ZEROS        SVBOO
     C                   Z-ADD     *ZEROS        SVINV
     C                   Z-ADD     *ZEROS        SVORD
     C                   Z-ADD     *ZEROS        SVUPRI
     C                   Z-ADD     *ZEROS        SUBTOT
     C                   ENDSR
      *
      *  ***********
      *  * #SLD    *
      *  ***********
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *  ***********
      *  * #SHP    *
      *  ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SHIP TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SHP          BEGSR
      *
     C                   MOVE      *BLANKS       #SH
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSHP1        #SH(#X)
     C                   ADD       1             #X
     C     #WSHP2        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP1
     C                   MOVEL     #WSHP2        #SH(#X)
     C                   ADD       1             #X
     C     #SHP1         TAG
     C     #WSHP3        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP2
     C                   MOVEL     #WSHP3        #SH(#X)
     C                   ADD       1             #X
     C     #SHP2         TAG
     C     #WSHP4        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP3
     C                   MOVEL     #WSHP4        #SH(#X)
     C                   ADD       1             #X
     C     #SHP3         TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WSHCT        CAT       #WSHST:1      WORK1
     C                   MOVEL     #WSHZP        WORK3
     C                   MOVE      #WSHZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C*                    MOVELWORK1     WORK
     C*                    MOVE WORK2     WORK
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *********
      * GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
WJB  C                   MOVEL     DESCO         DESC             30
WJB  C*                  MOVEL     DESCO         DESC29           29
WJB  C                   MOVEL     DESCO         DESC29           30
     C                   ENDSR
      *********
      * GETXRF
      *********
     C     GETXRF        BEGSR
WJB  C                   MOVEL     DESCO         DESC             30
WJB  C*                  MOVEL     DESCO         DESC29           29
WJB  C                   MOVEL     DESCO         DESC29
     C     XRFKEY        KLIST
     C                   KFLD                    CMIREF
     C                   KFLD                    CNITEM
     C                   KFLD                    CNSIZE
     C                   MOVEL     WIITEM        CNITEM
     C                   MOVE      WISIZE        CNSIZE
     C     XRFKEY        CHAIN     FCUSTNO                            90
     C   90              DO
     C                   MOVE      *BLANKS       CNSIZE
     C     XRFKEY        CHAIN     FCUSTNO                            90
     C                   ENDDO
WJB  C   90              MOVEL     WIDES1        DESC
WJB  C   90              MOVEL     WIDES1        DESC29
WJB  C  N90              MOVEL     CNCSDS        DESC
WJB  C  N90              MOVEL     CNCSDS        DESC29
     C   90              MOVE      *BLANKS       CNCST#
     C                   MOVEL     CNCST#        PPART#            6
     C                   ENDSR
      *
      *  ***********
      *  * GTDAT   *
      *  ***********
      *
      *  THIS SUBROUTINE SETS UP THE DATE PRINT
      *
     C     GTDAT         BEGSR
     C                   MOVEL     WHINDT        MM                2 0
     C                   MOVEL     WHINDT        MWRK              4 0
     C                   MOVE      MWRK          DD                2 0
     C                   MOVE      WHINDT        YY                2 0
     C                   ENDSR
      *****
0441 OBIR330A   E            HDG1             09
0442 O                     61MCMSG1              37
0443 O                       WHINDT        Y     77
0444 O                       WHINV#        Z     88
0445 O          E       62   HDG1             10
0446 O                       MCMSG2              37
0447 O          E       63   HDG1             11
0448 O                       MCMSG3              37
0449 O          E            HDG1             12
0450 O                  64   MCMSG4              37
0467 O                                           62 'TEL:'
0468 O                       PHONE               77 ' -   -   -    '
0451 O          E    40      HDG1             13
0452 O                                           31 '* * CONTINUED FROM'
0453 O                                           49 'PREVIOUS PAGE * *'
     O          E            HDG1             14
     O                       #SL(1)              39
     O                       #SH(1)              90
     O          E            HDG1             15
     O                       #SL(2)              39
     O                       #SH(2)              90
     O          E            HDG1             16
     O                       #SL(3)              39
     O                       #SH(3)              90
     O          E            HDG1             17
     O                       #SL(4)              39
     O                       #SH(4)              90
     O          E            HDG1             18
     O                       #SL(5)              39
     O                       #SH(5)              90
     O          E            HDG1             21
     O                       WHCUST        Z     09
     O                       WHPRCD              12
0472 O                       WHPONO              30
0473 O                       WHORD#        Z     39
0474 O                       WHDTOR        Y     49
0475 O                       DTAC          Y     59
0476 O                       WHSHIN              92
0481 O          E            HDG1             22
0482 O                       WHSPIN              92
0483 O          E            HDG1             23 25
0484 O*                      WHTERM              38
0484 O*              70      WHTERM              38
0484 O                       WHTERM              38
0485 O               68                          62 'ROUTE:'
0486 O               68      WHROUT              65
0487 O               68                          71 'STOP:'
0488 O               68      WHSTOP        Z     75
     O              N68      SVIADESC            95
0483 O          E    81      HDG1        1
0484 O                                           25 'SKU NBR.'
     O          E            DETL1       1
CAB  O              N81      SVBOO         4     22
CAB  O               81      PPART#              22
CAB  O                       SVINV         4     16
     O                       SVORD         4     08
     O              N37      WIAMT         L     95
     O              N38      UPRI94        LB    83
CAB  O                       WIITEM              35
CAB  O                       WISIZE              32
WJB  O                       DESC29         B    64                             63->64
WJB  O               99                          66 '@'                         64->66
WJB  O               99      SZSAL@              70                             67->70
     O          E            DETCOM      1
     O               46                          52 'Above Item Reflects'
     O               46                          61 'Discount'
     O               45N46                       52 'Above Billed At Spe'
     O               45N46                       62 'cial Price'
     O          E            CONT1            60
     O                                           44 '* * Continued'
     O                                           61 'On Next Page * *'
     O          E            TOTL1            60
CAB  O                       TOTBOO        4B    22
CAB  O                       TOTSHP        4B    16
     O                       TOTORD        4B    08
     O               27      WHCASH        4     72
     O               27                          52 'Thank You for your'
     O               27                          61 'payment:'
     O              N26      CCPAYTY             86
     O               26                          83 'Check #'
     O               26      PYCHEK              93
     O          E            TOTL1            61
0522 O                     29                    12 '*'
     O               70    29                    24 'DISC.@  %'
     O               70    29TRDPCT        4     23
     O                       WHUPSZ              36
     O                     34                    77 'EOD@  %'
     O                     34EODPCT        4     76
     O*                    28                    69 'Sales Tax'
     O                     28                    69 'S.Tax:   '
     O                     28WHTXJU              69
     O                     31                    58 'Royalty'
     O          E            TOTL1            63
     O               70      TOTINV        L     95
     O              N70      NODISC        L     95
     O               34      EOD$          L     77
     O               28      WHTAX$        L     69
     O               31      TOTROY        L     59
     O                       SPCHG         L     48
     O                       DELIV         L     36
     O               70      WHDIS$        L     24
     O                       SUBTOT        L     12
** MESSAGE
Total Number of Packages this Invoice:
