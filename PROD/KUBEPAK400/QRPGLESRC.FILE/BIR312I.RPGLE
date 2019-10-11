      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.      1995
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR312I
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **APPLICATION--------- SUMMARY PICK SLIP BY ITEM NUMBER
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORITEM  UF   E           K DISK
     FFIORASTD  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR312    O    F  132        PRINTER OFLIND(*INOF)
      *
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
      *********
      *  LDA  *
      *********
     D                UDS
      * COMPANY
     D  LCONO                  1      2  0
      * REPRINT Y/N
     D  LDARPT                 3      3
      * ROUTE I.D.
     D  LDARTE                 4      5
      * ROUTE ALL
     D  LDAALL                 6      8
      * BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                  9     14  0
      * ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 15     20  0
      * INVOICE DATE
     D  LDATE                 21     26  0
      * SHIP FROM LOCATION
     D  LSHFR                 27     29
      * BEGINING ORDER NUMBER
     D  LBORD                 30     35  0
      * ENDING ORDER NUMBER
     D  LEORD                 36     41  0
      * BEGINING DATE
     D  LBEGDT                44     49  0
      * ENDING DATE
     D  LENDDT                50     55  0
      * SELECTION PICK SLIP
     D  LSEL                  56     56  0
      * PRODUCT CLASS 1
     D  LPC1                  57     58
      * PRODUCT CLASS 2
     D  LPC2                  59     60
      * ROUTE 1
     D  LRTE1                 61     62
      * ROUTE 2
     D  LRTE2                 63     64
      * PHYTO 1
     D  LPHY1                 65     65
      * PHYTO 2
     D  LPHY2                 66     66
      * PREV. PRINTED
     D  LPREV                 67     67
      * SHIP 1
     D  LSHP1                 68     69
      * SHIP 2
     D  LSHP2                 70     71
      * LOCATION 1
     D  LLOC1                 72     74
      * LOCATION 2
     D  LLOC2                 75     77
      * TAG
     D  LTAG                  78     78  0
      * DATE
     D  LSTDAT                79     84  0
      * SALE I.D.
     D  LSALE                 85     87
      * DEPARTMENT
     D  LDEPT                 88     90
      * SALE DATE
     D  TYCENB                91     95  0
      * PRINTER ID
     D  LPRTR1               100    109
      * FORMS NUMBER
     D  LFORM                110    119
      * NUMBER OF COPIES
     D  LCOPY                120    121  0
      * JOBQ
     D  LJOBQ                122    122
      * HOLD PRINT OUTPUT
     D  LHOLD                123    126
      * PRINT AND SAVE OUTPUT
     D  LSAVE                127    130
      * CANCEL  X=CANCEL
     D  LCANCL               133    133
      * PRINTER ID PICK SLIP 2
     D  LPRTR2               134    143
      *
      ********************************
      *  READ BOTH FILES FIRST TIME  *
      ********************************
     C                   MOVE      *BLANKS       SITEM            12
     C     SITEM         SETLL     FIORITEM
     C     SITEM         SETLL     FIORASTD
     C                   EXSR      GETIOR
     C                   EXSR      GETIOA
      *
     C     NXT           TAG
     C   90
     CAN 91              GOTO      END
      ** WHAT IS USED   51=IORDR   52=IORAST
      *   91 NO MORE ASSORTMENTS
     C   91              DO
     C                   MOVEL     OIITEM        PITEM            12
     C                   MOVEL     OISIZE        PSIZE             3
     C                   MOVEL     OIWHSE        PWHSE             3
     C                   Z-ADD     OIORD#        PORD#             6 0
     C                   Z-ADD     OIDTRQ        DTRQ              6 0
     C                   Z-ADD(H)  IOROPN        QTYOPN            8 0
     C                   SETON                                        51
     C                   SETOFF                                       52
     C                   GOTO      IO
     C                   ENDDO
      * 90 ON NO MORE IORDR
     C   90              DO
     C                   MOVEL     IAITEM        PITEM            12
     C                   MOVEL     IASIZE        PSIZE             3
     C                   MOVEL     IAWHSE        PWHSE             3
     C                   Z-ADD     IAORD#        PORD#             6 0
     C                   Z-ADD     IADTRQ        DTRQ
     C                   Z-ADD(H)  IASOPN        QTYOPN
     C                   SETON                                        52
     C                   SETOFF                                       51
     C                   GOTO      IO
     C                   ENDDO
      *              OR ITEM THE SAME AND OISIZE LESS THAN IASIZE
     C     OIITEM        IFEQ      IAITEM
     C     OISIZE        ANDEQ     IASIZE
     C                   MOVEL     OIITEM        PITEM            12
     C                   MOVEL     OISIZE        PSIZE             3
     C                   MOVEL     OIWHSE        PWHSE             3
     C                   Z-ADD     OIORD#        PORD#             6 0
     C                   Z-ADD     OIDTRQ        DTRQ              6 0
     C                   Z-ADD(H)  IOROPN        QTYOPN            8 0
     C                   SETON                                        51
     C                   SETOFF                                       52
     C                   GOTO      IO
     C                   END
      * IORDR FIRST IF LOWER IORSAT ITEM
     C     OIITEM        IFLT      IAITEM
     C                   MOVEL     OIITEM        PITEM            12
     C                   MOVEL     OISIZE        PSIZE             3
     C                   MOVEL     OIWHSE        PWHSE             3
     C                   Z-ADD     OIORD#        PORD#             6 0
     C                   Z-ADD     OIDTRQ        DTRQ
     C                   Z-ADD(H)  IOROPN        QTYOPN
     C                   SETON                                        51
     C                   SETOFF                                       52
     C                   GOTO      IO
     C                   END
      * IF HEAR USE FIORAST
     C                   MOVEL     IAITEM        PITEM            12
     C                   MOVEL     IASIZE        PSIZE             3
     C                   MOVEL     IAWHSE        PWHSE             3
     C                   Z-ADD     IAORD#        PORD#             6 0
     C                   Z-ADD     IADTRQ        DTRQ
     C                   Z-ADD(H)  IASOPN        QTYOPN
     C                   SETON                                        52
     C                   SETOFF                                       51
     C                   GOTO      IO
      * HERE AFTER DECIDE WHICH RECORD
     C     IO            TAG
     C     PORD#         CHAIN     FHORDR                             77
     C                   MOVEL     OHNAME        SHNAME           20
     C   55PITEM         IFNE      OITEM
     C     PSIZE         ORNE      OSIZE
     C                   Z-ADD     1             PSD
     C                   EXCEPT    TL1
     C                   ENDIF
      *
      *  GET ITEM MASTER RECORD
      *
     C     KEY18         KLIST
     C                   KFLD                    PITEM
     C                   KFLD                    PSIZE
     C                   KFLD                    PWHSE
     C     KEY18         CHAIN     FMINVT                             75
     C                   EXSR      GETDES
      *
     C                   MOVEL     PITEM         OITEM            12
     C                   MOVEL     PSIZE         OSIZE             3
     C   OF              Z-ADD     1             PSD
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     PSD           IFEQ      1
     C                   SETON                                        58
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   SETON                                        55
     C                   ADD       1             PSD               5 0
     C                   SETON                                        55
     C                   ADD       QTYOPN        TOTQTY           11 0
     C   51              DO
     C     OIDES2        IFGT      *BLANKS
     C                   EXCEPT    DETL2
     C                   ENDIF
     C                   ENDDO
     C   51              DO
     C                   MOVEL     'P'           OISPFL
     C  N90              UPDATE    RIORDR
     C                   EXSR      GETIOR
     C                   ENDDO
     C   52              DO
     C                   MOVEL     'P'           IASPFL
     C  N91              UPDATE    RIORAST
     C                   EXSR      GETIOA
     C                   ENDDO
     C                   GOTO      NXT
      *
     C     END           TAG
     C     TOTQTY        IFGT      *ZEROS
     C                   EXCEPT    TL1
     C                   ENDIF
     C                   SETON                                        LR
      *
      **********
      * GET IORDR
      **********
     C     GETIOR        BEGSR
     C     NXTIO         TAG
     C                   READ      FIORITEM                               90
     C   90              Z-ADD     0             IOROPN
     C   90              GOTO      ENDIO
      *
     C     OISTAT        IFEQ      'D'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'C'
     C     OISIZE        OREQ      'AST'
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C     LPREV         IFEQ      'N'
     C     OISPFL        ANDEQ     'P'
     C                   GOTO      NXTIO
     C                   ENDIF
      *
      *  GET DAY OF CENTURY
      *
     C     OIRVDT        IFLT      BDATE
     C     OIRVDT        ORGT      EDATE
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C   10OIPRCL        IFLT      LPC1
     C     OIPRCL        ORGT      LPC2
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C   11OIROUT        IFLT      LRTE1
     C     OIROUT        ORGT      LRTE2
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C   12OIORD#        IFLT      LBORD
     C     OIORD#        ORGT      LEORD
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C   13OICOMP        IFNE      LCONO
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C   16OISHFR        IFLT      LLOC1
     C     OISHFR        ORGT      LLOC2
     C                   GOTO      NXTIO
     C                   ENDIF
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED, DO NOT PRINT
      *
     C     OIQSHP        IFGE      OIQORD
     C                   GOTO      NXTIO
     C                   ENDIF
     C     OIQORD        SUB       OIQSHP        IOROPN           11 1          OPEN QTY
      ****** END IORDR
      *
     C     OIORD#        CHAIN     FHORDR                             22
      *
     C   14OHPHYT        IFLT      LPHY1
     C     OHPHYT        ORGT      LPHY2
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C   15OHSHPC        IFLT      LSHP1
     C     OHSHPC        ORGT      LSHP2
     C                   GOTO      NXTIO
     C                   ENDIF
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXTIO
     C                   ENDIF
     C     ENDIO         ENDSR
      *
      **********
      * GET IORAST
      **********
     C     GETIOA        BEGSR
     C     NXTIA         TAG
     C                   READ      FIORASTD                               91
     C   91              Z-ADD     0             IASOPN
     C   91              GOTO      ENDIA
      *
     C     IASTAT        IFEQ      'D'
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C     LPREV         IFEQ      'N'
     C     IASPFL        ANDEQ     'P'
     C                   GOTO      NXTIA
     C                   ENDIF
      *
      *  GET DAY OF CENTURY
      *
     C     IARVDT        IFLT      BDATE
     C     IARVDT        ORGT      EDATE
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C   10IAPRCL        IFLT      LPC1
     C     IAPRCL        ORGT      LPC2
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C   11IAROUT        IFLT      LRTE1
     C     IAROUT        ORGT      LRTE2
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C   12IAORD#        IFLT      LBORD
     C     IAORD#        ORGT      LEORD
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C   16IASHFR        IFLT      LLOC1
     C     IASHFR        ORGT      LLOC2
     C                   GOTO      NXTIA
     C                   ENDIF
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED, DO NOT PRINT
      *
     C     IAQSHP        IFGE      IAQORD
     C                   GOTO      NXTIA
     C                   ENDIF
     C     IAQORD        SUB       IAQSHP        IASOPN           11 1          OPEN QTY
      *
     C     IAORD#        CHAIN     FHORDR                             22
      *
     C   14OHPHYT        IFLT      LPHY1
     C     OHPHYT        ORGT      LPHY2
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C   13OHCOMP        IFNE      LCONO
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C   15OHSHPC        IFLT      LSHP1
     C     OHSHPC        ORGT      LSHP2
     C                   GOTO      NXTIA
     C                   ENDIF
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXTIA
     C                   ENDIF
     C     ENDIA         ENDSR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'P'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             36
     C                   ENDSR
      **********
      * *INZR
      **********
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *  GET DAY OF CENTURY
      *
     C                   Z-ADD     LBEGDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BDATE             7 0
     C                   Z-ADD     LENDDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        EDATE             7 0
     C                   Z-ADD     1             PSD
      *
     C     LCONO         CHAIN     FMCORG                             88
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        10
     C                   ENDIF
      *
     C     LRTE1         IFGT      *BLANKS
     C                   SETON                                        11
     C                   ENDIF
      *
     C     LBORD         IFGT      *ZEROS
     C                   SETON                                        12
     C                   ENDIF
      *
     C     LCONO         IFGT      *ZEROS
     C                   SETON                                        13
     C                   ENDIF
      *
     C     LPHY1         IFGT      *BLANKS
     C                   SETON                                        14
     C                   ENDIF
      *
     C     LSHP1         IFGT      *BLANKS
     C                   SETON                                        15
     C                   ENDIF
      *
     C     LLOC1         IFGT      *BLANKS
     C                   SETON                                        16
     C                   ENDIF
      *
     C                   SETON                                        OF
     C                   ENDSR
      ********************************************************************
      *
     OBIR312    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCONO               98                             APR500
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           67 'Summary Pick Slips B'
     O                                           73 'y Item'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           60 'Quantity'
     O                                           73 'Invoice'
     O                                           84 'Ord'
     O                                           90 'Ship'
     O                                           97 'Ship'
     O          E            HDG            1
     O                                            5 'Item/'
     O                                           15 'Size'
     O                                           40 'Description/Variety'
     O                                           59 'To Ship'
     O                                           64 'Ast'
     O                                           73 'Comment'
     O                                           83 '#'
     O                                           90 'Via'
     O                                           97 'Date'
     O                                          107 'Ship To'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O               58      PITEM               12
     O               58      PSIZE               15
     O               58      DESP                52
     O                       QTYOPN        4     60
     O                       PORD#         Z     86
     O**                       OHPHYT    62
     O               52                          64 'Ast'
     O                       OHSHPC              90
     O                       DTRQ          Y     99
     O                       SHNAME             120
     O          E            DETL2          1
     O                       OIDES2              46
     O          E            TL1            1
     O                                           60 '---------'
     O          E            TL1            2
     O                       TOTQTY        4B    60
