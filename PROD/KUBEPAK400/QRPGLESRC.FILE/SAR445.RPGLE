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
      *PROGRAM NAME-------- SAR445
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- DETAIL S/A BY SALESPERSON $ AND UNITS
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
     FFMINVT    IF   E           K DISK
     FSAR445    O    F  120        PRINTER OFLIND(*INOF)
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
     C     LCO           CHAIN     FMCORG                             88
      *
      * GET PERIOD
      *
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
     C                   SETOFF                                       7798
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
     C     SICQTL        IFEQ      0
     C     SILQTL        ANDEQ     0
     C     SICSTL        ANDEQ     0
     C     SIPSTL        ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NSLS          IFEQ      1
     C     SISLSM        CHAIN     FMSLSM                             90
     C   90              SETON                                        77
     C                   EXCEPT    HDG
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C     SICUST        CHAIN     FMCUST                             90
      *
     C     NCUS          IFEQ      1
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
     C     NCUS          IFGT      1
     C     SICUST        ANDNE     OCUST
     C     SISLSM        ANDEQ     OSLSM
     C                   EXCEPT    TL1
     C  NOF              EXCEPT    DETL1
     C                   ENDIF
      *
     C     NSLS          IFGT      1
     C     SISLSM        ANDNE     OSLSM
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C                   EXCEPT    HDG
      *
     C     SISLSM        CHAIN     FMSLSM                             90
     C   90              SETON                                        77
     C                   EXCEPT    HDG1
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    SIITEM
     C                   KFLD                    SISIZE
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        98
      *
     C                   EXSR      GETDES
      *
     C                   Z-ADD     CSQ(P)        CQTY              8 0
     C                   ADD       CSQ(P)        CCYCPQ            9 0
     C                   ADD       CSQ(P)        SCYCPQ            9 0
     C                   ADD       CSQ(P)        RCYCPQ            9 0
     C                   ADD       CS$(P)        CCYCPS           10 2
     C                   ADD       CS$(P)        SCYCPS           10 2
     C                   ADD       CS$(P)        RCYCPS           10 2
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        CYTDQ             8 0
     C                   ADD       CSQ(X)        CCYTDQ            9 0
     C                   ADD       CSQ(X)        SCYTDQ            9 0
     C                   ADD       CSQ(X)        RCYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        PYTDQ             8 0
     C                   ADD       PSQ(X)        CPYTDQ            9 0
     C                   ADD       PSQ(X)        SPYTDQ            9 0
     C                   ADD       PSQ(X)        RPYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        CYTDS             9 2
     C                   ADD       CS$(X)        CCYTDS           10 2
     C                   ADD       CS$(X)        SCYTDS           10 2
     C                   ADD       CS$(X)        RCYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        PYTDS             9 2
     C                   ADD       PS$(X)        CPYTDS           10 2
     C                   ADD       PS$(X)        SPYTDS           10 2
     C                   ADD       PS$(X)        RPYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C     SISLSM        CHAIN     FMSLSM                             90
     C   90              SETON                                        77
     C                   EXCEPT    HDG1
     C                   EXCEPT    DETL1
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   ADD       1             NCUS
     C                   ADD       1             NSLS
     C                   MOVEL     SISLSM        OSLSM             2
     C                   MOVEL     SICUST        OCUST             6 0
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             34
     C                   ENDSR
      *
     OSAR445    E            HDG            1 03
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
     O                                           70 'Salesperson - Detail'
     O                                           88 'Units and Dollars'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           52 'For Period:'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O          E            HDG1           1
     O                                           12 'Salesperson:'
     O                       SISLSM              15
     O              N77      SMNAME              46
     O               77                          40 '** Salesperson Not On Fi'
     O               77                          45 'le **'
     O                                           65 '--------'
     O                                           79 'SALES DOLLARS'
     O                                           88 '--------'
     O                                          100 '--------'
     O                                          111 'QUANTITIES'
     O                                          120 '--------'
     O          E            HDG1           1
     O                                           63 'Current'
     O                                           76 'Current'
     O                                           87 'Last'
     O                                           99 'Current'
     O                                          110 'Current'
     O                                          120 'Last'
     O          E            HDG1           1
     O                                            8 'Customer'
     O                                           23 'Item'
     O                                           63 'Period'
     O                                           74 'YTD'
     O                                           87 'YTD'
     O                                           98 'Period'
     O                                          108 'YTD'
     O                                          120 'YTD'
     O          E            HDG1           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O*       EF 1             DETL1
     O          E            DETL1          1
     O                       SICUST        Z      6
     O                       CMNAME              37
     O          EF           DETL           1
     O                       SIITEM              12
     O                       SISIZE              15
     O                       PYTDQ         KB   120
     O                       CYTDQ         KB   110
     O                       CQTY          KB   100
     O                       PYTDS         KB    90
     O                       CYTDS         KB    77
     O                       CS$(P)        KB    64
     O               98                          38 '** Item Not On File **'
     O              N98      DESP           B    50
     O          E            TL1            1
     O                                          119 '--------'
     O                                          109 '--------'
     O                                           99 '--------'
     O                                           89 '-----------'
     O                                           76 '-----------'
     O                                           63 '----------'
     O          E            TL1            1
     O                                           50 'Total Customer:'
     O                       CPYTDQ        KB   120
     O                       CCYTDQ        KB   110
     O                       CCYCPQ        KB   100
     O                       CPYTDS        KB    90
     O                       CCYTDS        KB    77
     O                       CCYCPS        KB    64
     O          E            TL2            1
     O                                          119 '========'
     O                                          109 '========'
     O                                           99 '========'
     O                                           89 '==========='
     O                                           76 '==========='
     O                                           63 '=========='
     O          E            TL2            1
     O                                           50 'Total Salesperson:'
     O                       SCYTDQ        KB   110
     O                       SPYTDS        KB    90
     O                       SCYCPS        KB    64
     O          E            TL2            1
     O                       SPYTDQ        KB   120
     O                       SCYCPQ        KB   100
     O                       SCYTDS        KB    77
     O          E            TLR         1  1
     O                                           50 'Report Totals:'
     O                       RCYTDQ        KB   110
     O                       RPYTDS        KB    90
     O                       RCYCPS        KB    64
     O          E            TLR            1
     O                       RPYTDQ        KB   120
     O                       RCYCPQ        KB   100
     O                       RCYTDS        KB    77
      **
