    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

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
      **PROGRAM NAME-------- BIR421
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- LAM
      **APPLICATION--------- ORDER ACKNOWLEDGEMENT PRINT
      **DESCRIPTION--------- THIS PROGRAM WILL ORDER ACKNOWLEDGEMENTS
      **                     AND FLAG HORDR AS BEING PRINTED.
      **
      * DATE-INIT------DESCRIPTION
      *  10/11/93 EFD USE CUSTOMER PART NUMBER IF NEEDED
      *  12/12/94 GD  DO NOT PRINT QUOTES
      *  12/18/95 GD  CAT ITEM DESCRIPTIONS
      *   7/02/96 GD  ADD GETDESC SUBR
      *  02/05/97 EFD ADD LOT NUMBERS IF NOT PLV SPEC.
      *  10/27/98 GD  KUBE PAK LAYOUT
      *   9/21/00 EFD ALLOW FOR PRICES WITH 3 DECIMAL AND INC TOT QTY
      *
      *
     FFCUSTNO   IF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFHORDISCNTIF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFOECTL    IF   E           K DISK
     FFMTAXF    IF   E           K DISK
     F*FALITEM IF  E           K        DISK
     F*FCALEN  IF  F      16  6AI     2 DISK
     FBIR421    O    F   80        PRINTER
     F                                     FORMLEN(66)
     F                                     FORMOFL(64)
      *
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      *
      *  LINE COUNTER SPECS, TO SET OVERFLOW AT LINE 65.
      *
      *
     D                UDS
      *    REPRINT Y OR N
     D  LCO                    1      2  0
     D  LDARPT                 3      3                                         |Reprint Y/N
     D  LDABEG                 4      9  0                                      |Beginning Date
     D  LDAEND                10     15  0                                      |Ending Date
     D  LBORD                 16     21  0                                      |Beggining Order
     D  LEORD                 22     27  0                                      |Ending Order
     D  LDASOR                28     33  0                                      |Beggin Day of Cent.
     D  LDAEOR                34     39  0                                      |End Day of Cent.
     D  LDAFRM                40     45
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D* LPLUG                172    172
     D  LSHIP2               180    185  0
     D  LBILL2               186    191  0
     D  LSHPDT               192    197  0

     D  in71           S               N
     D  TaxLiteral     S             68A
     D  Tax$           S              8S 2
      *
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp
      *
     IRHORDR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
     I              OHSLD1                      #WSLD1
     I              OHSLD2                      #WSLD2
     I              OHSLD3                      #WSLD3
     I              OHSLD4                      #WSLD4
     I              OHSLCT                      #WSLCT
     I              OHSLST                      #WSLST
     I              OHSLZP                      #WSLZP
      *
     C     *Entry        PList
     C                   Parm                    LPLUG             1            Plugs/Finished
      *
     C                   If        LPLUG = 'P'
     C                   Eval      *In71 = *On
     C                   Else
     C                   Eval      *In71 = *Off
     C                   EndIf
      *
      * ONE TIME CALCS
EFD  C                   UNLOCK    FHORDR
EFD  C                   TIME                    UTIME             6 0
      *
      * 82=DATE SELECTION
      * 83=ORDER NUMBER SELECTION
      *
     C     LDARPT        IFEQ      'Y'
     C                   GOTO      REPRNT
     C                   ENDIF
      *
     C     LDABEG        IFEQ      0
     C     LDAEND        ANDEQ     0
     C                   GOTO      NODATE
     C                   ENDIF
      *
     C                   SETON                                        82
      *
     C     LDABEG        MULT      10000.01      TSTBEG            6 0
     C     LDAEND        MULT      10000.01      TSTEND            6 0
      *
     C     NODATE        TAG
      *
     C     LBORD         IFGT      0
     C                   SETON                                        83
     C                   ENDIF
      *
     C     REPRNT        TAG
      *
      * GET COMPANY CONTROL RECORD
      *
     C     LCO           CHAIN(N)  FOECTL                             90
     C  N90OCCOM1        COMP      *BLANKS                            6161
     C  N90OCCOM2        COMP      *BLANKS                            6262
     C  N90OCCOM3        COMP      *BLANKS                            6363
     C  N90OCCOM4        COMP      *BLANKS                            6464
     C                   MOVEL     OCCOM1        MSG1             30
     C                   MOVEL     OCCOM1        MSG2             30
     C                   MOVEL     OCCOM1        MSG3             30
     C                   MOVEL     OCCOM1        MSG4             30
      *
      *  MAIN LINE CALCS
      *
     C*          LDARPT    IFEQ 'Y'
     C*                    MOVELLBORD     OHORD#  60
     C*          OHORD#    SETLLFHORDR
     C*                    SETON                     55
     C*                    ENDIF
      *
     C*          LDARPT    IFEQ 'N'
     C     LBORD         IFGT      0
     C     LBORD         SETLL     FHORDR
     C                   ELSE
     C                   Z-ADD     0             OHORD#
     C     OHORD#        SETLL     FHORDR
     C                   SETON                                        56
     C                   ENDIF
      *
     C     NEXT          TAG
     C                   SETOFF                                       99
      *
     C     NXTORD        TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      END
      *
     C     LSHIP2        IfNE      *Zero
     C     OHCUST        AndNe     LSHIP2
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C     LBILL2        IfNE      *Zero
     C     OHBLCU        AndNe     LBILL2
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C     LSHPDT        IfNE      *Zero
     C     OHDTRQ        AndNe     LSHPDT
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C                   If        OHLOC = ' '
     C                   Eval      *In72 = *Off
     C                   Else
     C                   Eval      *In72 = *On
     C                   EndIf
      *
     C                   Eval      *In31 = *Off
     C                   Clear                   RHORDISCNT
     C                   Call      'BIR103'
     C                   Parm                    OHDTRQ
     C                   Parm                    OHORD#
     C                   Parm                    Carts             5 2
     C                   Parm      'N'           Show              1
     C     OHORD#        CHAIN     FHORDISCNT                         31
     C                   If        ADDSC1 = *Zero
     C                   Eval      *In31 = *On
      *  note...  if we ever use additional discount fields, this will need to be reworked.
     C                   EndIf
      *
     C     OHCOFL        IFEQ      'Y'
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C   56OHACK         IFEQ      'Y'                                          NO REPRINT
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXTORD
     C                   ENDIF
      *
      *  82 = DATE SELECTION
      *
     C  N82              GOTO      CKORD
     C     OHDTRQ        MULT      10000.01      TSTDAT            6 0
     C   82TSTDAT        IFGT      TSTEND
     C     TSTDAT        ORLT      TSTBEG
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C     CKORD         TAG
      *
     C     LBORD         IFGT      0
     C     OHORD#        ANDLT     LBORD
     C*    OHORD#        ORGT      LEORD
     C                   GOTO      NXTORD
     C                   ENDIF
      *
     C     LEORD         IFGT      0
     C     OHORD#        AndGT     LEORD
     C                   GOTO      END
     C                   ENDIF
      *
     C                   SETOFF                                       222398
     C     OHCUST        CHAIN     FMCUST                             98
     C  N98              Z-ADD     CMPHON        PHONE            10 0
     C                   if        CMBABB = 'MASTR'
     C                   eval      *In70 = *Off                                 Dont Print Terms
     C                   else
     C                   eval      *In70 = *On                                  Print Terms
     C                   endif
      /Free
         in71 = *Off;
         Exec SQL
           Select '1' into :in71 FROM PLUG_ORD WHERE PLORD# = :OHORD#
           Fetch First Row Only;
         *In71 = in71;
      /End-free
     C   98              Z-ADD     0             PHONE
     C     OHBLCU        CHAIN     FMCUST                             98
     C     PHONE         IFEQ      0
     C                   Z-ADD     CMPHON        PHONE
     C                   END
      *
      *  PRINT HEADER RECORD INFORMATION AND UPDATE HEADER FILE
      *
     C                   EXSR      CLEAR
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
      *
     C                   EXCEPT    HDG1                                         HEADINGS
     C                   Z-ADD     0             LINE              2 0
      * SETLL ON IORDR
     C                   Z-ADD     OHORD#        OIORD#            6 0
     C*                    MOVEL*ZERO     IOKEY
     C     OIORD#        SETLL     FIORDR
     C     NXTI          TAG
     C                   READ      FIORDR                                 98
     C   98              GOTO      ENDI
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   END
     C     OIORD#        IFNE      OHORD#
     C                   GOTO      ENDI
     C                   ENDIF
     C     OICOFL        IFEQ      'Y'
     C                   GOTO      ENDI
     C                   ENDIF
     C                   SETOFF                                       253051
     C                   SETOFF                                       353839
     C                   SETOFF                                       44
     C                   SETON                                        30
      *
      * GET DESC FROM MINVT AND CAT
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'N'
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     OIDES1        DESC
     C                   GOTO      NOITM
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             50
     C                   EXSR      GETDES
     C                   SETON                                        44
     C                   MOVEL     OIITEM        OITEM             5
     C     NOITM         TAG
      *
      * GET SIZE DESC
     C     OISIZE        CHAIN     FMSIZE                             91
     C   91              MOVEL     *BLANKS       SZDESC
      *
      *  IF THE TYPE IS FREIGHT OR SPECIAL DO NOT PRINT UNIT PRICE.
      *
     C     OIITYP        COMP      'F'                                    38    FREIGHT
     C  N38OIITYP        COMP      'S'                                    38    SPECIAL
     C  N38OIITYP        COMP      'C'                                    38    COMMENT
     C  N38              SETON                                        39                    PRC
      *
      *     39 = NOT FREIGHT, COMMENT, OR SPECIAL CHARGE
      * 4/05/94
     C**N39                ADD  2         LINE
     C** 39                ADD  1         LINE
      **
     C*          LINE      COMP 35                   50  50
      *
      * 10/11/93 GET CUST PART NO AND DESC IF NEEDED
      *
     C     CNKEY         KLIST
     C                   KFLD                    CMIREF
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   MOVEL     OIITEM        OIKY             15
     C                   MOVE      OISIZE        OIKY
     C     CNKEY         CHAIN     FCUSTNO                            77
     C  N77CNSTAT        COMP      'D'                                    77
     C  N77CNCST#        IFNE      *BLANKS
      *
      * MOORESTOWN ONLY USES 7 POS CUST PART NUMBER
      *
     C                   MOVEL     CNCST#        W7                7
     C                   MOVE      W7            OIITEM
     C                   END
     C  N77CNCSDS        IFNE      *BLANKS
     C                   MOVEL     CNCSDS        OIDES1
     C                   END
      *
      *    REMOVE DECIMALS FROM QUANTITYS
      *
     C                   Z-ADD     OIQORD        SVORD             6 1
     C                   Z-ADD     OIQINV        SVINV             5 0
     C                   Z-ADD     OIQBOO        SVBOO             5 0
     C                   Z-ADD     OIQSHP        SVSHP             5 0
     C                   Z-ADD     OIUPRI        SVUPRI            9 4
     C                   Z-ADD     OIUPRI        UPRI92            7 2
     C                   MOVEL     OIDES1        SVDESC           30
     C                   MOVE      OIUUOM        SVORUM            2
     C                   MOVE      OIUUOM        SVBPUM            2
      *
      *    ACCUMULATE ORDER TOTALS FOR EACH INVOICE
      *
     C                   ADD       SVBOO         GTBOO             5 0
     C                   ADD       SVINV         GTINV             5 0
     C                   ADD       SVORD         GTORD             8 1
      *
     C   50              EXCEPT    CONT1                                        CONTINUATION
      *
     C   50              SETON                                        40
     C   50              Z-ADD     0             LINE
     C                   SETOFF                                       50
      *
     C   40              EXCEPT    HDG1                                         NEXT PAGE
      *
     C                   Z-ADD     OIUPRI        PRICE             6 2
     C                   Z-ADD     OIUPRI        PRICE3            7 3
     C                   MOVE      OIUPRI        TST2              2 0
     C     TST2          IFGT      00
     C                   SETON                                        78
     C                   ELSE
     C                   SETOFF                                       78
     C                   END
      *
     C     OIUPRI        MULT(H)   SVORD         EXTPRICE
     C                   EXCEPT    DETL1                                        NOT C,F,S DET.
     C                   ADD       EXTPRICE      TOTPRICE          8 2
     C                   Z-ADD     0             EXTPRICE          8 2
     C                   Z-ADD     0             PRICE
     C                   Z-ADD     0             PRICE3
     C*  30                EXCPTDETL1                      NOT C,F,S DET.
     C*  30 38             EXCPTIDES1                      DESC. LINE
      *
      * CHECK IF LAST WAS A COMMENT
      *
     C   30
     CAN 39
     CAN 37              SETOFF                                       37
     C   30
     CAN 38
     CANN37              SETON                                        37
     C                   SETOFF                                       3040
      *
     C                   ADD       1             LINE
     C*  44                ADD  2         LINE
     C     LINE          COMP      35                                     50
     C   50              EXCEPT    CONT1                                        CONTINUATION
      *
     C   50              SETON                                        40
     C   50              Z-ADD     0             LINE
     C                   SETOFF                                       50
      *
     C   40              EXCEPT    HDG1                                         NEXT PAGE
      *
     C                   SETOFF                                       3040
      *
     C                   GOTO      NXTI
     C     ENDI          TAG
     C                   ExSr      SalesTax
     C                   EXCEPT    TOTL1
     C                   MOVEL     'Y'           OHACK
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BIR421O'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C     LDARPT        IFEQ      'N'
     C**         LBORD     ANDLE0
     C                   GOTO      NEXT
     C                   ENDIF
     C     LDARPT        IFEQ      'Y'
WJB  C*    OHORD#        ANDLT     LDAEOR
WJB  C     OHORD#        ANDLT     LEORD
     C                   GOTO      NEXT
     C                   ENDIF
     C     END           TAG
     C                   SETON                                        LR
      **
      * GET DESCRIPTION
      **
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             30
     C                   ENDSR
      *
      **************
      ****  CLEAR  *
      **************
     C     CLEAR         BEGSR
     C                   MOVE      *BLANKS       SVORUM
     C                   MOVE      *BLANKS       SVBPUM
     C                   Z-ADD     *ZEROS        SVBOO
     C                   Z-ADD     *ZEROS        SVINV
     C                   Z-ADD     *ZEROS        SVORD
     C                   Z-ADD     *ZEROS        SVUPRI
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
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
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
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      /Free
      //========================================================================
       Begsr SalesTax;
      //========================================================================
         TXPCT1 = 0;
         Chain (OHTXJU) FMTAXF;
         Select;
           When TXPCT1 = 0;    // No Sales Tax in this Jurisdiction
             evalr TaxLiteral = 'No Sales Tax charged in ' + %trim(TXJUNM)+':';
           When OHTXST = 'Y';  // Tax Exempt
             evalr TaxLiteral = 'Sales Tax Exempt from ' + %trim(TXJUNM) + ':';
           Other;              // Customer pays Applicable Sales Tax
             evalr TaxLiteral = 'Sales Tax for ' + %trim(TXJUNM) + ' ($' +
                   %char(TOTPRICE) + '@' + %char(TXPCT1) + '%):';
             Tax$ = (TOTPRICE * TXPCT1)/100;
             TOTPRICE += Tax$;
         EndSl;
       EndSr;
      /End-Free
      *****
     OBIR421    E            HDG1             02
     O               40                          31 '* * Continued From'
     O               40                          49 'Previous Page * *'
     O*         E            HDG1           1 08
     O*                      PHONE               60 '   -   -    '
     O          E            HDG1           1 08
     O                       #SL(1)              40
     O                       #SH(1)              80
     O          E            HDG1           1
     O                       #SL(2)              40
     O                       #SH(2)              80
     O          E            HDG1           1
     O                       #SL(3)              40
     O                       #SH(3)              80
     O          E            HDG1           1
     O                       #SL(4)              40
     O                       #SH(4)              80
     O          E            HDG1           1
     O                       #SL(5)              40
     O                       #SH(5)              80
     O          E            HDG1             17
     O                       OHCUST        Z      8
     O                       OHPONO              26
     O                       OHORD#        Z     35
     O                       OHDTOR        Y     45
     O               71      OHDTRQ        Y     56
     O              N71      OHDTCN        Y     56
     O                       OHPRCD              62
     O               70      OHTRDC        4     71
      *  Add OHSPIN back in on a separate line
WJB  O          E            HDG1             18
WJB  O                       OHSPIN              80
     O          E            HDG1             19
     O                       OHSPIN              80
     O                       OHTERM              38
     O                       OHSHIN              80
     O          E   N31      HDG1           1 22
     O                                           21 'Early Order Discount'
     O                                           30 'Applies:'
     O                       ADDSC1              38 '  .   %'
     O          E    31      HDG1             22
     O                                           74 ' '
     O          E    71      DETL1          1
     O                       OIDTRQ        Y      9
     O               39      OITEM               15
     O               39      SZCODE              19
     O                       DESC           B    50
     O                       SVORD         4     58
     O              N78      PRICE         4     67
     O               78      PRICE3        4     68
     O                       EXTPRICE      K     80
     O          E   N71      DETL1          1
     O               39      OITEM               06                             15
     O               39      SZCODE              10                             18
     O                       DESC           B    41                             61
     O                       SVORD         4     59
     O              N78      PRICE         4     67
     O               78      PRICE3        4     68
     O                       EXTPRICE      K     80
     O          E            CONT1            61
     O                                           08 'Printed:'
     O                       UDATE               17 '  /  /  '
     O                       UTIME               26 '  :  :  '
     O                                           51 '* * Continued'
     O                                           68 'On Next Page * *'
     O          E            TOTL1          1 61
     O                       TaxLiteral          68
     O                       Tax$                80 '    , $0.  -'
     O          E            TOTL1          1
     O                                           08 'Printed:'
     O                       UDATE               17 '  /  /  '
     O                       UTIME               26 '  :  :  '
     O                       GTORD         2B    58
     O                                           49 'Total Quantity ==>'
     O                                           68 'Total:'
     O                       TOTPRICE       B    80 '    , $0.  -'
     O          E            TOTL1          1
     O                       Carts         2     78
     O                                           72 'Carts: '
     O          E    72      TOTL1          1
     O                       OHLOC               80
     O                                           72 'Truck: '
     O          E   N72      TOTL1
     O                                           72 'Stop: '
     O                                           80 '_______'
     O                                           57 'Route: '
     O                                           65 '_______'
