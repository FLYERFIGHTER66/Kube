      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.     1998
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
      **PROGRAM NAME-------- BIR465  - CREDIT MEMO PRINT PROGRAM
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- THIS PROGRAM WILL PRINT CREDIT MEMOS.
      **
      *
      *   CHANGE--DATE-------DESCRIPTION
      *  8/09/01 EFD ALLOW FOR ROYALTIES NOT PART OF MERCHANDISE.
      *  2/26/03 CAB CHANGED SPECS FOR NEW INVOICES.
      *
     FFHORCW    UF   E           K DISK
     FFHORDW    IF   E           K DISK
     FFIORCW    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFOECTL    UF   E           K DISK
     FBIR465A   O    F  132        PRINTER OFLIND(*INOF)
     F                                     FORMLEN(66)
     F                                     FORMOFL(65)
      *
      * ADDRESS ARRAYS
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** BEGINING CREDIT NUMBER
     D  LBCRM                  4      9  0
      ** ENDING CREDIT NUMBER
     D  LECRM                 10     15  0
      ** CREDIT MEMO DATE
     D  LDATE                 16     21  0
      ** CREDIT MEMO END DATE
     D  LENDT                 22     27  0
      ** SHIP FROM LOCATION
     D  LSHFR                 28     30
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 31     31
      ** BILL TO CUSTOMER
     D  LBLCS                 32     37  0
      ** SHIP TO CUSTOMER
     D  LSHCS                 38     43  0
      ** LAST INVOICE CREDITED
     D  LBINV                 44     49  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    113
      ** NUMBER OF COPIES
     D  LCOPY                114    115  0
      ** JOBQ
     D  LJOB                 116    116
      ** HOLD PRINT OUTPUT
     D  LHOLD                117    120
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                121    124
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
     IRHORCW
     I              CHNAME                      #WSHP1
     I              CHSHP2                      #WSHP2
     I              CHSHP3                      #WSHP3
     I              CHSHP4                      #WSHP4
     I              CHSHCT                      #WSHCT
     I              CHSHST                      #WSHST
     I              CHSHZP                      #WSHZP
     I              CHSLD1                      #WSLD1
     I              CHSLD2                      #WSLD2
     I              CHSLD3                      #WSLD3
     I              CHSLD4                      #WSLD4
     I              CHSLCT                      #WSLCT
     I              CHSLST                      #WSLST
     I              CHSLZP                      #WSLZP
      *
     C*
      *POS
     C                   Z-ADD     1             FIRST             6 0
     C**         LDARPT    IFEQ 'Y'
     C**                   SETON                     44
     C**                   ELSE
     C**                   SETOF                     44
     C**                   END
      *
     C     LBCRM         SETLL     FHORCW
     C     NXT           TAG
     C                   EXSR      CLEAR
     C                   Z-ADD     0             LINE              2 0
     C                   Z-ADD     0             PAGE              2 0
     C                   SETOFF                                       47
     C                   READ      FHORCW                                 90
     C   90              GOTO      END
     C     CHCRM#        IFGT      LECRM
     C                   GOTO      END
     C                   ENDIF
     C     CHAPIN        CHAIN     FHORDW                             94
     C   94              CLEAR                   RHORDW
      *** CHECK FOR SHIP FROM
     C     LSHFR         IFGT      *BLANKS
     C     CHSHFR        ANDNE     LSHFR
     C                   GOTO      NXT
     C                   ENDIF
      *** CHECK FOR COMPANY
EFD01C     CHCOMP        IFNE      LDACOP
EFD01C                   GOTO      NXT
EFD01C                   ENDIF
      *** CHECK FOR POINT OF SALE
     C**         LDARPT    IFNE 'Y'
     C**         CHPOS     ANDEQ'Y'
     C**         LPOS      ANDNE'Y'
     C**                   GOTO NXT
     C**                   ENDIF
      *** CHECK FOR PRINT STATUS
     C     LDARPT        IFNE      'Y'
     C     CHSTAT        ANDEQ     'P'
     C                   GOTO      NXT
     C                   ENDIF
     C     CHSTAT        COMP      'P'                                    44
     C     CHPOS         IFEQ      'P'
      *** CHECK FOR PRINT/USER ID
     C     LDARPT        IFNE      'Y'
     C     CHUSER        ANDNE     USERID
     C                   GOTO      NXT
     C                   ENDIF
     C                   SETON                                        42
     C                   ELSE
     C                   SETOFF                                       42
     C                   ENDIF
      * CHECK IF CASH AND CARRY DISCOUNT ON REG INVOICE
     C                   SETOFF                                       43
     C  N42              DO
     C     HIKEY         KLIST
     C                   KFLD                    CHCRM#
     C                   KFLD                    SEQ#              3 0
     C                   Z-ADD     996           SEQ#
     C     HIKEY         CHAIN     FIORCW                             98
     C**N98                SETON                     43
     C                   ENDDO
      *
      *   CHECK THE MESSAGES IN THE COMPANY CONTROL FILE.
      *
     C     FIRST         IFEQ      1
     C     CHCOMP        CHAIN     FMCOMP                             98
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
     C     CHTMCD        IFGT      49
     C     CHTMCD        ANDLT     61
     C                   MOVEL     CHTERM        TDESC            20
     C                   ENDIF
     C     CHTMCD        IFEQ      02
     C                   MOVEL     'Deferred'    DDESC            16
     C                   MOVE      ' Invoice'    DDESC
     C                   ELSE
     C                   MOVEL     *BLANKS       DDESC            16
     C                   ENDIF
      *
      * GET CUSTOMER TELE NUMBER
      *
     C     CHCUST        CHAIN     FMCUST                             90
     C                   Z-ADD     1             COPY              1 0
      *
     C     CHSHFR        CHAIN     FMDEPT                             88
     C   88              MOVE      *BLANKS       DEDESC
     C     NXTCPY        TAG
     C                   EXCEPT    HDG1                                         HEADINGS
     C                   Z-ADD     0             LINE
      * 6/11/97
      *
     C     CHCRM#        SETLL     FIORCW
     C     NXTI          TAG
     C     CHCRM#        READE     FIORCW                                 97
      ** PRINT TOTALS
     C   97              DO
     C**         CH$AMT    ADD  CHFET$    TOTINV  92
     C                   Z-ADD     CHTOT$        TOTINV            9 2
     C                   Z-ADD     CHFRT$        DELIV
     C                   MOVE      *BLANK        PCSMSG           38
     C**                   Z-ADDCHTBLK    NOPCS   50 67
     C                   TIME                    TIMOD             6 0
     C                   MOVEL     TIMOD         TIME              4 0
     C                   MOVEL     CHTIME        PTIME             4 0
     C     CHDIS$        IFNE      0.00
     C                   SETON                                        29
     C                   ELSE
     C                   SETOFF                                       29
     C                   END
     C     CHTAX$        IFNE      0.00
     C                   SETON                                        28
     C                   ELSE
     C                   SETOFF                                       28
     C                   END
     C     TOTROY        IFNE      0.00
     C                   SETON                                        31
     C                   ELSE
     C                   SETOFF                                       31
     C                   END
     C                   EXCEPT    TOTL1
     C                   SUB       1             COPY
     C     COPY          IFGT      0
     C                   Z-ADD     0             SUBTOT
     C                   Z-ADD     0             TOTROY            7 2
     C                   Z-ADD     0             DELIV
     C                   SETOFF                                       97
     C                   GOTO      NXTCPY
     C                   ELSE
     C                   Z-ADD     0             DELIV
     C                   Z-ADD     0             SUBTOT
     C                   Z-ADD     0             TOTROY            7 2
     C                   MOVEL     'P'           CHSTAT
     C                   UPDATE    RHORCW
     C                   GOTO      NXT
     C                   ENDIF
     C                   ENDDO                                                  97 DO
      *
     C                   SETOFF                                       253051
     C                   SETOFF                                       2441
     C                   SETOFF                                       4546
     C                   SETOFF                                       353839
     C                   SETON                                        30
      *
      *  IF THE TYPE IS FREIGHT OR SPECIAL DO NOT PRINT UNIT PRICE.
      *
     C     CIITYP        IFEQ      'S'
     C     CIITYP        OREQ      'C'
     C                   SETON                                        38        DON'T PRINT PRC
     C                   ENDIF
     C  N38              SETON                                        39        DON'T PRINT PRC
      ** CHECK IF COMMENT
     C     CIITYP        IFEQ      'C'
     C                   SETON                                        37
     C                   ELSE
     C                   SETOFF                                       37
     C                   END
      *
      * GET SUBTOTAL
      *
     C*          CIITYP    IFNE 'F'
     C*                    ADD  CIEXT$    SUBTOT  92
     C*                    ENDIF
      *
      *    REMOVE DECIMALS FROM QUANTITIES
      *
     C                   Z-ADD     0             SVORD             5 1
     C                   Z-ADD     CIQCRD        SVINV             5 1
     C                   Z-ADD     0             SVBOO             5 1
     C                   Z-ADD     0             SVSHP             5 1
      *
     C                   Z-ADD     CIUPRI        SVUPRI            9 4
      *10/9/96
     C*                    MOVE SVUPRI    TEST    22
     C*          TEST      IFGT *ZEROS
     C*                    Z-ADDCIUPRI    UPRI94  94
     C*                    SETON                     20
     C*                    ELSE
     C                   Z-ADD     CIUPRI        UPRI72            7 2
     C     CIITYP        IFEQ      'S'
     C     CIITYP        OREQ      'C'
     C                   Z-ADD     *ZEROS        UPRI72
     C                   ENDIF
     C*                    SETOF                     20
     C*                    ENDIF
     C     SVBOO         COMP      0                                      55
     C** 55      SVORD     SUB  SVSHP     SVBOO   50
      *
      *    ACCUMULATE ORDER TOTALS FOR EACH INVO
      *
      * GET ITEM DESCRIPTION
      *
     C     KEY15         KLIST
     C                   KFLD                    CIITEM
     C                   KFLD                    CISIZE
     C                   KFLD                    CIWHSE
     C     KEY15         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C   38              MOVEL     CIDES1        DESC
     C                   MOVEL     CHSHFR        TSTSFR            1
     C     TSTSFR        IFEQ      'S'
     C                   Z-ADD     900           LISTCD            4 0
     C                   ELSE
     C                   MOVEL     IMLIST        LISTCD
     C                   END
      *
     C     CIITYP        IFEQ      'F'
     C                   ADD       CIEXT$        DELIV             9 2
     C                   GOTO      FRT
     C                   ENDIF
      * 12/3/96
      * 45 = PRICE OR DISCOUNT OVERRIDDEN
      * 46 = DISCOUNT ON LINE ITEM
      *
     C     CIOVER        IFEQ      'Y'
     C     CIUPRI        ANDGT     0
     C     CIUPRI        ANDLT     IMSEL1
      ***
     C*          IMWHSE    ANDNE'L  '
     C                   SETON                                        45
     C                   ENDIF
     C     CIQDDC        IFNE      *ZEROS
     C                   SETON                                        46
     C                   ENDIF
      *
      * CASH AND CARRY DISCOUNT
      *
     C   43
     COR 42CIPRAL        IFNE      'N'
     C  N45
     CANN46              SETON                                        41
     C                   ENDIF
     C                   EXCEPT    DETL1                                                    T.
     C                   ADD       1             LINE
     C*  45
     C*R 46                EXCPTDETCOM                                 T.
      *
     C   45
     COR 46              ADD       1             LINE
      *
     C     CIITYP        IFNE      'F'
     C     CISIZE        ANDNE     'ROY'
     C*                    ADD  CIEXT$    SUBTOT  72
     C                   ADD       CIEXT$        SUBTOT            7 2
     C                   ENDIF
     C     CISIZE        IFEQ      'ROY'
     C                   ADD       CIEXT$        TOTROY
     C                   ENDIF
      *
     C   47LINE          COMP      33                                 50  50
     C  N47LINE          COMP      34                                 50  50
     C   50              EXCEPT    CONT1                                        CONTINUATION
      *
     C   50              SETON                                        40
     C   50              Z-ADD     0             LINE
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
     C  N96              Z-ADD     LDATE         OCDTCP
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
     C                   Z-ADD     0             TOTROY            7 2
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
     C                   MOVEL     DESCO         DESC             30
     C                   ENDSR
      *
      *  ***********
      *  * GTDAT   *
      *  ***********
      *
      *  THIS SUBROUTINE SETS UP THE DATE PRINT
      *
     C     GTDAT         BEGSR
     C                   MOVEL     CHDTOR        MM                2 0
     C                   MOVEL     CHDTOR        MWRK              4 0
     C                   MOVE      MWRK          DD                2 0
     C                   MOVE      CHDTOR        YY                2 0
     C                   ENDSR
      *****
      *OBIR330A H 00     1P
      *O                                    1 '*'
     O*BIR465A   E            HDG1             06
     O*                                           78 '****Credit Memo****'
     OBIR465A   E            HDG1              9
     O                       CHDTOR        Y     80                             67
     O                       CHCRM#        Z     91                             78
     O          E            HDG1           1 11
     O*                                          20 '****Credit Memo****'       20
     O*                                          40 '****Credit Memo****'       40
     O*                                          58 '***Credit Memo***'         58
     O          E            HDG1           1
     O                                           32 'Credit Memo Applies to'    30
     O                                           48 'Invoice Number:'           46
     O                       CHAPIN        4     57                             55
     O          E            HDG1             14
     O                       #SL(1)              42                             40
     O                       #SH(1)              93                             83
     O          E            HDG1             15
     O                       #SL(2)              42                             40
     O                       #SH(2)              93                             83
     O          E            HDG1             16
     O                       #SL(3)              42                             40
     O                       #SH(3)              93                             83
     O          E            HDG1             17
     O                       #SL(4)              42
     O                       #SH(4)              93
     O          E            HDG1             18
     O                       #SL(5)              42
     O                       #SH(5)              93
0469 O          E            HDG1             22
0470 O                       CHCUST        Z     10                              7
0471 O                       CHSLM1              15                             11
0472 O                       WHPONO              32                             27
0473 O                       CHORD#        Z     40                             34
0474 O                       CHINDT        Y     52                             44
0481 O          E            HDG1             23
0482 O                       CHCOMM             102                             85
0483 O          E            HDG1             24 25                             25
0484 O                       CHTERM              42                             40
     O          E            DETL1       1
     O              N37      CIEXT$        L     99                             84
CAB  O              N38      UPRI72        LB    87                             74
WJB  O                       CIITEM              43                             37 44
WJB  O                       CISIZE              30                             24 31
CAB  O                       DESC           B    69                             60
CAB  O              N38      SVINV         4     16                             13
     O          E            CONT1            60
     O                                           44 '* * Continued'             44
     O                                           61 'On Next Page * *'          61
     O          E            TOTL1            62
     O                     29                    27 '*DISCOUNTS'                21
     O                     28                    72 'Sales Tax'                 60
     O                     31                    60 'Royalty'                   50
     O          E            TOTL1            63
     O               28      CHTAX$        M     72                             60
     O               31      TOTROY        M     61                             51
     O                       SUBTOT        M     15                             11
     O                       DELIV         M     37                             31
     O                       CHDIS$        M     27                             21
     O                       TOTINV        M     99                             84
