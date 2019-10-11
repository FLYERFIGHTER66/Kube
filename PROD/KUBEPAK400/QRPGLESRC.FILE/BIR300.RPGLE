      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.      ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR300
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- ORDER PROOF LIST
      *
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    UF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFARHST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FBIR300    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LBSHFR                60     62
     D  LESHFR                63     65
     D  LBORD                 66     71  0
     D  LEORD                 72     77  0
     D  LCHG                  78     78
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
      * RENAME HORDR FIELDS
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   Z-ADD     0             CNT               6 0
      *
      * RANGE OF ORDER NUMBERS
      *
     C     LBORD         IFGT      *ZEROS
     C                   SETON                                        24
     C                   ENDIF
      *
      * RANGE OF SHIP FROMS
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LCHG          IFEQ      'Y'
     C                   SETON                                        63
     C                   ENDIF
      *
     C     LDATE         IFGT      0
     C                   SETON                                        64
     C                   ENDIF
      *
     C*                    EXCPTHDG1
     C                   Z-ADD     0             FIELDA            9 2
      *
     C     NXT           TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      ENDP
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   64OHTDAT        IFNE      LDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   62OHSHFR        IFLT      LBSHFR
     C     OHSHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   24OHORD#        IFLT      LBORD
     C     OHORD#        ORGT      LEORD
     C                   GOTO      NXT
     C                   ENDIF
      *
      * DO NOT PRINT IF ORDER CODED AS A QUOTE  12/9/94
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXT
     C                   END
      *
      * INCLUDE ORDERS FOR ALL DATES NOT PREVIOUSLY PRINTED
      *
     C   63OHOPLP        IFEQ      'Y'
     C                   GOTO      NXT
     C                   END
      *
      * PRINT HEADER RECORD INFORMATION
      *
     C                   MOVEL     *BLANKS       WHDESC
     C     OHSHFR        IFGT      *BLANKS
     C     OHSHFR        CHAIN     FMWHSE                             90
     C                   ENDIF
      *
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
      *
      * GET TELEPHONE NUMBERS
      *
     C     OHCUST        CHAIN     FMCUST                             90
     C     OHCUST        CHAIN     FARHST                             90
      *
     C     OHSHPC        CHAIN     FMSVIA                             88
     C  N88              MOVEL     SVDESC        SHPVIA           30
      *
     C                   EXCEPT    HDG1
     C                   EXCEPT    HDG2
      *
      * SET LOWER LIMITS ON DETAIL LINE ITEM FILE.  PRINT ALL
      * DETAIL LINE ITEMS.
      *
     C                   EXCEPT    HDG3
      *
     C                   MOVE      *BLANKS       LNKEY             6 0
     C                   MOVEL     OHORD#        LNKEY
     C     LNKEY         SETLL     FIORDR
     C     LOOP          TAG
     C                   SETOFF                                           25
     C                   READ(N)   FIORDR                                 25
     C  N25OHORD#        COMP      OIORD#                             2525
     C   25              GOTO      SUBEND
      *
      * BYPASS DELETED LINE ITEMS
      *
     C     OISTAT        COMP      'D'                                    53
     C   53              GOTO      LOOP
     C                   SETOFF                                       84
     C     OIITYP        COMP      'C'                                    85
     C     OIITYP        COMP      'F'                                    86
     C     OIITYP        COMP      'S'                                    87
     C  N85
     CANN86
     CANN87              SETON                                        84
     C                   ADD       OIEXT$        ORDTOT            9 2
     C   84              ADD       OIEXT$        ITMTOT            9 2
     C                   ADD       OIEXT$        LRTOT            10 2
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'F'
     C                   GOTO      NOQTY
     C                   ENDIF
      *
     C     OIQORD        IFGT      *ZEROS
     C     OISEQ#        ANDLT     989
     C                   ADD       OIQORD        TOTQTY           11 1
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       OIQORD        LRQTY            11 1
     C                   ENDIF
      *
     C     NOQTY         TAG
     C                   Z-ADD     OIUPRI        SPRI              9 2
      *
     C   OF              SETON                                        45
     C   45              EXCEPT    HDG3
     C                   SETOFF                                       45
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'N'
     C                   MOVEL     *BLANKS       DESP
     C                   MOVEL     OIDES1        DESP
     C                   GOTO      NOITM
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
      *
     C     NOITM         TAG
      *
     C                   EXCEPT    DTL
     C                   GOTO      LOOP
     C     SUBEND        TAG
     C                   ADD       1             CNT
     C                   MOVEL     'Y'           OHOPLP
     C                   UPDATE    RHORDR
     C     OHTRDC        IFGT      0
     C                   MOVE      OHTRDC        DISC              4 4
     C     ITMTOT        MULT(H)   DISC          TDISC             9 2
     C                   ENDIF
     C                   EXCEPT    TOTL                                         PRT ORDER TOTLS
     C                   Z-ADD     0             ITMTOT
     C                   Z-ADD     0             TDISC
     C     END           TAG
     C*  25                EXCPTHDG1
     C                   GOTO      NXT
      *
     C     ENDP          TAG
     C     CNT           IFEQ      *ZEROS
     C                   SETON                                        95
     C                   ENDIF
     C                   EXCEPT    TOTLR
     C                   SETON                                        LR
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
     C                   MOVEL     DESCO         DESP             38
     C                   ENDSR
      ***********
      * #SLD    *
      ***********
      *
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
      ***********
      * #SHP    *
      ***********
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
     C                   MOVEL     WORK3         WORK2                          19002-1525
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OBIR300    E            HDG1           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG1           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           68 'Order Proof List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG1           1
     O               64                          64 'For Orders Dated:'
     O               64      LDATE         Y     73
     O               63                          61 'All Orders Added or Chan'
     O               63                          82 'ged Since Last Report'
     O               62                         110 'Ship From Range:'
     O               62      LBSHFR             114
     O               62                         116 '-'
     O               62      LESHFR             120
     O          E            HDG2        1  1
     O                                            5 'Order'
     O                                           14 'Order'
     O                                           25 'Requested'
     O                                           33 'Cancel'
     O                                           61 'Slsm  Comm'
     O                                           73 'Slsm  Comm'
     O                                           78 'Inv'
     O                                           80 'B'
     O                                           91 '---Tax---'
     O                                           96 'Frt'
     O                                          106 'Route/'
     O                                          113 'S/A'
     O                                          119 'A/R'
     O          E    45      HDG3           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E    45      HDG3           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           68 'Order Proof List'
     O                       TIMOD              120 '  :  :  '
     O          E    45      HDG3           1
     O               64                          64 'For Orders Dated:'
     O               64      LDATE         Y     73
     O               63                          61 'All Orders Added or Chan'
     O               63                          82 'ged Since Last Report'
     O               62                         110 'Ship From Range:'
     O               62      LBSHFR             114
     O               62                         116 '-'
     O               62      LESHFR             120
     O          E    45      HDG3        1  1
     O                                           26 'Order Number -'
     O                       OHORD#        Z     33
     O                                           48 'Continued From'
     O                                           62 'Previous Page'
     O          E            HDG2           0
     O                                           14 'Number    Date'
     O                                           25 'Ship Date'
     O                                           32 'Date'
     O                                           46 'P.O. Number'
     O                                           61 '# 1   %  '
     O                                           73 '# 2   %  '
     O                                           78 'Only'
     O                                           80 'O'
     O                                           91 'Exemp Jur'
     O                                           97 'Type'
     O                                          106 'Stop  '
     O                                          113 'Cust'
     O                                          120 'Cust'
     O          E            HDG2           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG2           2
     O                       OHORD#        Z      6
     O                       OHDTOR        Y     15
     O                       OHDTRQ        Y     24
     O                       OHDTCN              34 '  /  / 0'
     O                       OHPONO              50
     O                       OHSLM1              54
     O                       OHSCM1        4     61
     O                       OHSLM2              66
     O                       OHSCM2        4     73
     O                       OHIOCD              77
     O                       OHBOCD              80
     O                       OHTXST              86
     O                       OHTXJU              91
     O                       OHPPCD              95
     O                       OHROUT             102
     O                       OHSTOP        Z    106
     O                       OHSACU        Z    113
     O                       OHARCU        Z    120
     O          E            HDG2           1
     O                                            8 'Ship To:'
     O                       OHCUST        Z     15
     O                                           28 'Cust Type:'
     O                       CMCTYP              31
     O                                           60 'Bill To:'
     O                       OHBLCU        Z     67
     O          E            HDG2           1
     O                       #SL(1)              95
     O                       #SH(1)              43
     O          E            HDG2           1
     O                       #SL(2)              95
     O                       #SH(2)              43
     O          E            HDG2           1
     O                       #SL(3)              95
     O                       #SH(3)              43
     O          E            HDG2           1
     O                       #SL(4)              95
     O                       #SH(4)              43
     O          E            HDG2           1
     O                       #SL(5)              95
     O                       #SH(5)              43
     O          E            HDG2           1
     O                                           10 'Tel:'
     O                       CMPHON              23 '   -   -    '
     O                       CMPHO2              38 '   -   -    '
     O                                           46 'Fax:'
     O                       HSFAX               59 '   -   -    '
     O                                           72 'Ship From:'
     O                       OHSHFR              76
     O                       WHDESC             107
     O          E            HDG2        1  1
     O                                            6 'Terms:'
     O                       OHTERM              37
     O                                           47 'Ship Via:'
     O                       SHPVIA              78
     O                                           83 'Type:'
     O                       OHPOS               86
     O                                          100 'Trade Disc:'
     O                       OHTRDC        4    107
     O                                          118 'Price Cd:'
     O                       OHPRCD             120
     O          E            HDG2           1
     O                                           11 'Ship Instr:'
     O                       OHSHIN              42
     O                                           61 'Spec Instr:'
     O                       OHSPIN              92
     O          E            HDG3        1  0
     O                                            5 'T'
     O                                           13 'Reqd'
     O                                           84 '-- Qty --'
     O                                           92 'Unit'
     O                                          120 '- Taxes -'
     O          E            HDG3        1  0
     O                                            3 'Seq'
     O                                            5 'P'
     O                                           13 'Date'
     O                                           26 'Description'
     O                                           58 'Item'
     O                                           69 'Size'
     O                                           77 'Ord'
     O                                           85 'Ship'
     O                                           92 'Price'
     O                                          102 'Amount'
     O                                          106 'UM'
     O                                          110 'Loc'
     O                                          120 'ST CO LC'
     O          E            HDG3           1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DTL            1
     O                    N85OITXLC             120
     O                    N85OITXCT             117
     O                    N85OITXST             114
     O                       OIWHSE             110
     O                       OIUUOM             106
     O              N85      OIEXT$        LB   103
     O               85      FIELDA        2    103
     O               84      SPRI          4     92
     O               84      OIQSHP        L     86
     O               84      OIQORD        L     78
     O                       OISIZE              69
     O                       OIITEM              66
     O                       DESP                53
     O               84      OIDTRQ        Y     14
     O              N84                          13 '        '
     O                       OIITYP               5
     O                       OISEQ#        Z      3
     O          E            TOTL           1
     O                                           77 '------'
     O                                           85 '------'
     O                                          103 '---------'
     O          E            TOTL           1
     O                       ORDTOT        JB   103
     O                       TOTSHP        1B    85
     O                       TOTQTY        1B    77
     O                                           40 'Trade Discount Amount:'
     O                       TDISC         JB    55
     O          E            TOTLR          1
     O               95                          63 '**** No Orders Found For'
     O               95                          79 'Selections ****'
     O*               N95                63 'Final Totals:'
     O*               N95      LRQTY L   81
     O*               N95      LRTOT L  101
