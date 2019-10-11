      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR455
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SUMMARY S/A BY SALESPERSON AND CUSTOMER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFSHIDSCI  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FSAR455    O    F  132        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
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
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LDORP                  6      6
     D  LGROSS                 7      7
     D  LFSLS                 11     12
     D  LTSLS                 13     14
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     IRSHIST
      *
     I              SICS01                      CS$(1)
     I              SICS02                      CS$(2)
     I              SICS03                      CS$(3)
     I              SICS04                      CS$(4)
     I              SICS05                      CS$(5)
     I              SICS06                      CS$(6)
     I              SICS07                      CS$(7)
     I              SICS08                      CS$(8)
     I              SICS09                      CS$(9)
     I              SICS10                      CS$(10)
     I              SICS11                      CS$(11)
     I              SICS12                      CS$(12)
     I              SICS13                      CS$(13)
      *
     I              SILS01                      PS$(1)
     I              SILS02                      PS$(2)
     I              SILS03                      PS$(3)
     I              SILS04                      PS$(4)
     I              SILS05                      PS$(5)
     I              SILS06                      PS$(6)
     I              SILS07                      PS$(7)
     I              SILS08                      PS$(8)
     I              SILS09                      PS$(9)
     I              SILS10                      PS$(10)
     I              SILS11                      PS$(11)
     I              SILS12                      PS$(12)
     I              SILS13                      PS$(13)
      *
     I              SICQ01                      CSQ(1)
     I              SICQ02                      CSQ(2)
     I              SICQ03                      CSQ(3)
     I              SICQ04                      CSQ(4)
     I              SICQ05                      CSQ(5)
     I              SICQ06                      CSQ(6)
     I              SICQ07                      CSQ(7)
     I              SICQ08                      CSQ(8)
     I              SICQ09                      CSQ(9)
     I              SICQ10                      CSQ(10)
     I              SICQ11                      CSQ(11)
     I              SICQ12                      CSQ(12)
     I              SICQ13                      CSQ(13)
      *
     I              SILQ01                      PSQ(1)
     I              SILQ02                      PSQ(2)
     I              SILQ03                      PSQ(3)
     I              SILQ04                      PSQ(4)
     I              SILQ05                      PSQ(5)
     I              SILQ06                      PSQ(6)
     I              SILQ07                      PSQ(7)
     I              SILQ08                      PSQ(8)
     I              SILQ09                      PSQ(9)
     I              SILQ10                      PSQ(10)
     I              SILQ11                      PSQ(11)
     I              SILQ12                      PSQ(12)
     I              SILQ13                      PSQ(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LFSLS         IFGT      *BLANKS
     C                   SETON                                        22
     C                   ENDIF
      *
     C                   Z-ADD     1             NSLS              4 0
     C                   Z-ADD     1             NCUS              4 0
      *
     C     LCO           CHAIN     FMCORG                             88
      *
      * GET PERIOD
     C                   Z-ADD     LMONTH        P                 2 0
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     LMONTH        ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
      *
     C     NXT           TAG
     C                   SETOFF                                       77
     C                   READ      FSHIDSCI                               90
     C   90              GOTO      END
      *
     C     SISTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SICOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SISLSM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SIITEM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SICUST        IFEQ      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   22SISLSM        IFLT      LFSLS
     C     SISLSM        ORGT      LTSLS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NSLS          IFEQ      1
     C                   SETOFF                                       77
     C     SISLSM        CHAIN     FMSLSM                             90
     C                   SETON                                        88
     C   90              SETON                                        77
     C                   EXCEPT    HDG
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C     SICUST        CHAIN     FMCUST                             90
     C     NCUS          IFNE      1
     C     SICUST        ANDNE     OCUST
     C     SISLSM        ANDEQ     OSLSM
     C                   EXCEPT    TL1
     C                   ENDIF
      *
     C     NCUS          IFNE      1
     C     SICUST        ANDNE     OCUST
     C     SISLSM        ANDNE     OSLSM
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2D
     C                   EXCEPT    TL2
     C                   EXCEPT    HDG
      *
     C     SISLSM        CHAIN     FMSLSM                             90
     C   90              SETON                                        77
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C                   ADD       CS$(P)        CCYCPS            9 2          $ MTD
     C                   ADD       CS$(P)        SCYCPS           10 2
     C                   ADD       CS$(P)        RCYCPS           10 2
     C                   ADD       CSQ(P)        CCYCPQ            8 0          QTY MTD
     C                   ADD       CSQ(P)        SCYCPQ            9 0
     C                   ADD       CSQ(P)        RCYCPQ            9 0
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        CCYTDQ            8 0
     C                   ADD       CSQ(X)        SCYTDQ            9 0
     C                   ADD       CSQ(X)        RCYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        CPYTDQ            8 0
     C                   ADD       PSQ(X)        SPYTDQ            9 0
     C                   ADD       PSQ(X)        RPYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        CCYTDS            9 2
     C                   ADD       CS$(X)        SCYTDS           10 2
     C                   ADD       CS$(X)        RCYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        CPYTDS            9 2
     C                   ADD       PS$(X)        SPYTDS           10 2
     C                   ADD       PS$(X)        RPYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      *
     C                   ADD       1             NCUS
     C                   ADD       1             NSLS
     C                   MOVEL     SISLSM        OSLSM             2
     C                   Z-ADD     SICUST        OCUST             6 0
     C                   MOVEL     CMNAME        ONAME            30
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   EXCEPT    HDG1
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2D
     C                   EXCEPT    TL2
     C                   EXCEPT    TLRD
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OSAR455    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          115 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           49 'Sales Analysis By'
     O                                           70 'Salesperson/Customer'
     O                                           88 'Dollars and Units'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           52 'For Period'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O          E            HDG            1
     O               22                          62 'Salespersons:'
     O               22      LFSLS               65
     O               22                          67 '-'
     O               22      LTSLS               70
     O          E            HDG1           1
     O                                           12 'Salesperson:'
     O                       SISLSM              15
     O              N77      SMNAME         B    46
     O               77                          39 '** Salesperson Not On F'
     O               77                          45 'ile **'
     O          E            HDG1           1
     O                                           48 '--------'
     O                                           65 'SALES DOLLARS'
     O                                           77 '--------'
     O                                           95 '-----------'
     O                                          107 'QUANTITIES'
     O                                          120 '----------'
     O          E            HDG1           1
     O                                           49 'Current'
     O                                           64 'Current'
     O                                           77 'Last'
     O                                           92 'Current'
     O                                          106 'Current'
     O                                          120 'Last'
     O          E            HDG1           0
     O                                            8 'Customer'
     O                                           48 'Period'
     O                                           62 'YTD'
     O                                           77 'Year'
     O                                           91 'Period'
     O                                          104 'YTD'
     O                                          120 'Year'
     O          E            HDG1           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           TL1            1
     O                       OCUST         Z      6
     O                       ONAME               37
     O                       CPYTDQ        KB   120
     O                       CCYTDQ        KB   106
     O                       CCYCPQ        KB    92
     O                       CPYTDS        KB    78
     O                       CCYTDS        KB    64
     O                       CCYCPS        KB    49
     O          E            TL2D           1
     O                                          119 '----------'
     O                                          105 '----------'
     O                                           91 '----------'
     O                                           77 '----------'
     O                                           63 '----------'
     O                                           48 '----------'
     O          E            TL2            1
     O                                           34 'Total Salesperson:'
     O                       SPYTDQ        KB   120
     O                       SCYTDQ        KB   106
     O                       SCYCPQ        KB    92
     O                       SPYTDS        KB    78
     O                       SCYTDS        KB    64
     O                       SCYCPS        KB    49
     O          E            TLRD           1
     O                                          119 '=========='
     O                                          105 '=========='
     O                                           91 '=========='
     O                                           77 '=========='
     O                                           63 '=========='
     O                                           48 '=========='
     O          E            TLR            1
     O                                           34 'Report Totals:'
     O                       RPYTDQ        KB   120
     O                       RCYTDQ        KB   106
     O                       RCYCPQ        KB    92
     O                       RPYTDS        KB    78
     O                       RCYTDS        KB    64
     O                       RCYCPS        KB    49
      **
