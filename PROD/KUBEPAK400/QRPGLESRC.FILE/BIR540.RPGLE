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
      *PROGRAM NAME-------- BIR540
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- CREDIT MEMO PROOF LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORCR    IF   E           K DISK
     FFIORCR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR540    O    F  120        PRINTER OFLIND(*INOF)
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
     IRHORCR
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
     C                   SETON                                        8990
     C                   EXCEPT    HDG1
     C                   Z-ADD     0             FIELDA            9 2
     C     SKIP          TAG
      *
     C     NXT           TAG
     C                   READ      FHORCR                                 90
     C   90              GOTO      ENDP
     C     OHTDAT        IFNE      LDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
      *
      *  PRINT HEADER RECORD INFORMATION
      *
     C                   EXCEPT    HDG2
      *
      *  SET LOWER LIMITS ON DETAIL LINE ITEM FILE.  PRINT ALL
      *  DETAIL LINE ITEMS.
      *
     C                   EXCEPT    HDG3
      *
     C                   MOVE      *BLANKS       LNKEY             6 0
     C                   MOVEL     OHCRM#        LNKEY
     C     LNKEY         SETLL     FIORCR
     C     LOOP          TAG
     C                   SETOFF                                           25
     C                   READ      FIORCR                                 25
     C  N25OHCRM#        COMP      OICRM#                             2525
     C   25              GOTO      SUBEND
      *
      *            BYPASS DELETED LINE ITEMS
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
     C                   ADD       OIEXT$        LRTOT            10 2
     C*          OIQORD    IFGT *ZEROS
     C*          OISEQ#    ANDLT900
     C                   ADD       OIQCRD        TOTQTY           11 1
     C                   ADD       OIQCRD        LRQTY            11 1
     C*                    ENDIF
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
     C                   MOVEL     OIDES1        DESP             40
     C                   GOTO      NOITM
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C     NOITM         TAG
      *
     C                   EXCEPT    DTL
     C                   GOTO      LOOP
     C     SUBEND        TAG
     C                   EXCEPT    TOTL                                         PRT ORDER TOTLS
     C     END           TAG
     C   25              EXCEPT    HDG1
     C                   GOTO      NXT
     C     ENDP          TAG
     C                   SETON                                        LR
     CLR                 EXCEPT    TOTLR
      *******
      * GET DESCRIPTION
      *******
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             40
     C                   ENDSR
      *
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
     OBIR540    E            HDG1           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG1           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           71 'Credit Memo Proof List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG1           1
     O                                           66 'For Credit Memos Dated:'
     O                       LDATE         Y     75
     O          E            HDG1           1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG2        1  1
     O                                            5 ' Crm '
     O                                           14 ' Crm '
     O                                           26 'Apply To'
     O                                           40 '-Affect-'
     O                                           50 'Co'
     O                                           64 'Slsm  Comm'
     O                                           76 'Slsm  Comm'
     O                                           91 '--Tax--'
     O                                          113 'S/A'
     O                                          119 'A/R'
     O          E    45      HDG3        1  1 06
     O                                           26 'Credit Number -'
     O                       OHCRM#        Z     33
     O                                           48 'Continued From'
     O                                           62 'Previous Page'
     O          E            HDG2           1
     O                                           14 'Number    Date'
     O                                           26 'Invoice '
     O                                           40 'S/A  I/C'
     O                                           50 'No'
     O                                           64 '# 1   %  '
     O                                           76 '# 2   %  '
     O                                           91 'Exp Jur'
     O                                          113 'Cust'
     O                                          120 'Cust'
     O          E            HDG2           1
     O                                           14 '------    ----'
     O                                           26 '------- '
     O                                           40 '---  ---'
     O                                           50 '--'
     O                                           64 '---   ---'
     O                                           76 '---   ---'
     O                                           91 '--- ---'
     O                                          113 '------'
     O                                          120 '------'
     O          E            HDG2           1
     O                       OHCRM#        Z      6
     O                       OHDTOR        Y     15
     O                       OHAPNO        Z     26
     O                       OHAFSL              34
     O                       OHAFIV              39
     O                       OHCOMP              50
     O                       OHSLM1              57
     O                       OHSCM1        4     64
     O                       OHSLM2              69
     O                       OHSCM2        4     76
     O                       OHTXST              86
     O                       OHTXJU              91
     O                       OHSACU        Z    113
     O                       OHARCU        Z    120
     O          E            HDG2           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG2           1
     O                                           40 'Freight'
     O                                           60 'Discount'
     O                                           80 'Misc. Charge'
     O                                          100 'Tax Amount'
     O          E            HDG2           1
     O                                           40 '-------'
     O                                           60 '--------'
     O                                           80 '------------'
     O                                          100 '----------'
     O          E            HDG2           1
     O                       OHFRT$        4     40
     O                       OHDIS$        4     60
     O                       OHMIS$        4     80
     O                       OHTAX$        4    100
     O          E            HDG2           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG2           1
     O*                                           8 'Ship To:'
     O*                      OHCUST        Z     15
     O*                                          60 'Bill To:'
     O*                      OHBLCU        Z     67
     O                                            8 'Bill To:'
     O                       OHBLCU        Z     15
     O                                           60 'Ship To:'
     O                       OHCUST        Z     67
     O          E            HDG2           1
     O*                      #SL(1)              95
     O*                      #SH(1)              43
     O                       #SH(1)              95
     O                       #SL(1)              43
     O          E            HDG2           1
     O*                      #SL(2)              95
     O*                      #SH(2)              43
     O                       #SH(2)              95
     O                       #SL(2)              43
     O          E            HDG2           1
     O*                      #SL(3)              95
     O*                      #SH(3)              43
     O                       #SH(3)              95
     O                       #SL(3)              43
     O          E            HDG2           1
     O*                      #SL(4)              95
     O*                      #SH(4)              43
     O                       #SH(4)              95
     O                       #SL(4)              43
     O          E            HDG2           1
     O*                      #SL(5)              95
     O*                      #SH(5)              43
     O                       #SH(5)              95
     O                       #SL(5)              43
     O          E            HDG2        1  1
     O                                            6 'Notes:'
     O                       OHCOMM              38
     O          E            HDG2        1  1
     O                                            6 'Terms:'
     O                       OHTERM              37
     O                                           83 'Type:'
     O                       OHTYPE              86
     O                                          100 'Trade Disc:'
     O                       OHTRDC        4    107
     O                                          118 'Price Cd:'
     O                       OHPRCD             120
     O          E            HDG3        1  0
     O                                            5 'T'
     O                                          120 '---Taxes---'
     O          E            HDG3        1  0
     O                                            3 'Seq'
     O                                            5 'p'
     O                                           18 'Description'
     O                                           54 'Item'
     O                                           76 'Qty Ord'
     O                                           86 'Price'
     O                                          100 'Extension'
     O                                          104 'UM'
     O                                          108 'Loc'
     O                                          120 'Ln ST CO LC'
     O          E            HDG3        1  1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DTL            1
     O                       OISEQ#        Z      3
     O                       OIITYP               5
     O               84      OIQCRD        L     77
     O                       OIITEM              62
     O                       OISIZE              65
     O                       DESP                47
     O                       OIWHSE             108
     O                       OIUUOM             104
     O                    N85OITXCD             111
     O                    N85OITXST             114
     O                    N85OITXCT             117
     O                    N85OITXLC             120
     O               84      SPRI          4     87
     O              N85      OIEXT$        LB   101
     O               85      FIELDA        2    101
     O          E            TOTL           1
     O                                           78 '-----------'
     O                                          101 '-----------'
     O          E            TOTL
     O                       ORDTOT        LB   101
     O                       TOTQTY        LB    77
     O          E            TOTLR
     O                                           63 'Final Totals:'
     O                       LRQTY         L     77
     O                       LRTOT         L    101
