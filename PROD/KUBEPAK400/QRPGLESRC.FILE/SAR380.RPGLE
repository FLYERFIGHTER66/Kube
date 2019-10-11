      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1996
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
      **PROGRAM NAME-------- SAR380
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT INC.
      **DESCRIPTION--------- S/A BY CUSTOMER/PRODUCT CLASS
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFSHIDCPC  IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR380    O    F  132        PRINTER OFLIND(*INOF)
     D*
      ** SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      ** MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D END             S              6  0 DIM(13)                              END DATES
      ** PROGRAM ARRAYS
     D TYS             S              7  0 DIM(13)                              CUR CYMD
     D LYS             S              7  0 DIM(13)                              LAST CYMD
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
      *
     D                UDS
     D  LSDTE                  1      6  0
     D  LCO                    9     10  0
     D  LFORM                 17     20
     D  LCOPY                 25     26  0
     D  LEDTE                 31     36  0
     D  LJOB                  41     41
     D  LSTYPE                42     43
     D  LETYPE                44     45
     D  LSPC                  46     47
     D  LEPC                  48     49
     D  LCUST                 50     55  0
     D  LCANCL               133    133
     IRSHIST
      *
      * CURRENT YR SALES
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
      * PRIOR YR SALES
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
      * CURRENT YR QTY
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
      * PRIOR YR QTY
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
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      END(1)
     I              ACEN02                      END(2)
     I              ACEN03                      END(3)
     I              ACEN04                      END(4)
     I              ACEN05                      END(5)
     I              ACEN06                      END(6)
     I              ACEN07                      END(7)
     I              ACEN08                      END(8)
     I              ACEN09                      END(9)
     I              ACEN10                      END(10)
     I              ACEN11                      END(11)
     I              ACEN12                      END(12)
     I              ACEN13                      END(13)
      *
     C   OF              SETON                                        OF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     1             NPC               4 0
     C                   Z-ADD     1             NCUS              4 0
     C     LCO           CHAIN     FMCOMP                             88
      *
     C     NXT           TAG
     C                   READ      FSHIDSPC                               90
     C   90              GOTO      END
     C     SISTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
     C     SICOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
     C     SIPCL1        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
     C     SIITEM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
     C     SICUST        IFEQ      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LSTYPE        IFGT      *BLANKS
     C     SICUST        CHAIN(N)  FMCUST                             90
     C     CMCTYP        IFLT      LSTYPE
     C     CMCTYP        ORGT      LETYPE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LCUST         IFGT      *ZEROS
     C     SICUST        ANDNE     LCUST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LSPC          IFGT      *BLANKS
     C     SIPCL1        ANDLT     VSPC
     C     SIPCL1        ORGT      VEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NPC           IFEQ      1
     C     SIPCL1        CHAIN     FMPRCL                             90
     C                   EXCEPT    HDG
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C                   EXSR      GETDAT
      *
     C     SICUST        CHAIN     FMCUST                             90
     C     NCUS          IFNE      1
     C     SICUST        ANDNE     OCUST
     C     SISLSM        ANDEQ     OSLSM
     C   21              EXCEPT    TL1
     C   20              EXCEPT    TL1B
     C                   ENDIF
      *
     C     NCUS          IFNE      1
     C     SICUST        ANDNE     OCUST
     C     SISLSM        ANDNE     OSLSM
     C   21              EXCEPT    TL1
     C   20              EXCEPT    TL1B
     C   21              EXCEPT    TL2
     C   20              EXCEPT    TL2B
     C                   EXCEPT    HDG
     C     SISLSM        CHAIN     FMSLSM                             90
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C                   XFOOT     CS$           CTSLS             9 2
     C                   XFOOT     CSQ           CTQTY            11 1
     C                   XFOOT     PS$           PTSLS             9 2
     C                   XFOOT     PSQ           PTQTY            11 1
     C                   ADD       CS$(P)        TCCS              9 2
     C                   ADD       CSQ(P)        TCCQ             11 1
     C                   ADD       PS$(P)        TCPS              9 2
     C                   ADD       PSQ(P)        TCPQ             11 1
     C                   ADD       CTSLS         TCYS              9 2
     C                   ADD       CTQTY         TCYQ             11 1
     C                   ADD       PTSLS         TCRS              9 2
     C                   ADD       PTQTY         TCRQ             11 1
     C                   ADD       CS$(P)        TSCS              9 2
     C                   ADD       CSQ(P)        TSCQ             11 1
     C                   ADD       PS$(P)        TSPS              9 2
     C                   ADD       PSQ(P)        TSPQ             11 1
     C                   ADD       CTSLS         TSYS              9 2
     C                   ADD       CTQTY         TSYQ             11 1
     C                   ADD       PTSLS         TSRS              9 2
     C                   ADD       PTQTY         TSRQ             11 1
     C                   ADD       CS$(P)        TRCS              9 2
     C                   ADD       CSQ(P)        TRCQ             11 1
     C                   ADD       PS$(P)        TRPS              9 2
     C                   ADD       PSQ(P)        TRPQ             11 1
     C                   ADD       CTSLS         TRYS              9 2
     C                   ADD       CTQTY         TRYQ             11 1
     C                   ADD       PTSLS         TRRS              9 2
     C                   ADD       PTQTY         TRRQ             11 1
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
     C   21              EXCEPT    TL1
     C   20              EXCEPT    TL1B
     C   21              EXCEPT    TL2
     C   20              EXCEPT    TL2B
     C   21              EXCEPT    TLR
     C   20              EXCEPT    TLRB
     C                   SETON                                        LR
      *********
      * GETDAT
      *********
     C     GETDAT        BEGSR
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     13
     C                   Z-ADD     BEG(X)        ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        TYS(X)
     C     BEG(X)        SUB       1             ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        LYS(X)
     C                   ADD       1             X
     C                   ENDDO
      * GET END DATES
     C                   ENDSR
      *
     C                   MOVEL     LSDTE         MS                2 0
     C                   MOVE      LSDTE         MYS               4 0
     C                   MOVEL     01            MYS
      *MOVE 7196 INTO ##MDY
     C                   MOVEL     MS            ##MDY
     C                   MOVE      MYS           ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        STRDAT            7 0
      *
     C                   MOVEL     LEDTE         MS                2 0
     C                   MOVE      LEDTE         MYS               4 0
     C                   MOVEL     01            MYS
     C                   MOVEL     MS            ##MDY
     C                   MOVE      MYS           ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        ENDDAT            7 0
      *
     C                   Z-ADD     1             X
     C     STRDAT        LOOKUP    LYS(X)                                 65
     C   65              DO
     C     NXTLS         TAG
     C     ENDDAT        IFLE      LYE(X)
     C                   ADD       LS$(X)        TSLS
     C                   ADD       LSQ(X)        TQTY
     C                   ADD       1             X
     C     X             IFLE      13
     C                   GOTO      NXTLS
     C                   ELSE
     C                   GOTO      ENDLS
     C                   ENDIF
     C                   ELSE
     C                   GOTO      ENDALL
     C                   END
     C                   ENDDO
     C     ENDLS         TAG
     C                   Z-ADD     1             X
     C  N65STRDAT        LOOKUP    TYS(X)                                 65
     C     NXTCS         TAG
     C     ENDDAT        IFLE      TYE(X)
     C                   ADD       CS$(X)        TSLS
     C                   ADD       CSQ(X)        TQTY
     C                   ADD       1             X
     C     X             IFLE      13
     C                   GOTO      NXTCS
     C                   ELSE
     C                   GOTO      ENDCS
     C                   ENDIF
     C                   ELSE
     C                   GOTO      ENDALL
     C                   END
     C                   ENDDO
     C     ENDCS         TAG
     C     ENDALL        ENDSR
      *
     OSAR380    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                       PAGE          1    120
     O                                          115 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           57 'Sales Analysis By'
     O                                           80 'Customer/Product Class'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           50 'For Period:'
     O                                           59 'From'
     O                       LSDTE         Y     65
     O                                           68 'To'
     O                       LEDTE         Y     74
     O          E            HDG1           1
     O                                           14 'Product Class:'
     O                       SIPCL1              17
     O                       PCDESC              48
     O          E            HDG1           0
     O                                            8 'Customer'
     O                                           23 'Item'
     O                                           78 'Total Sales'
     O                                          106 'Total Quantity'
     O          E            HDG1           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           TL1            1
     O                       OCUST         Z      6
     O                       ONAME               37
     O          E            TL2         1  1
     O               21                          60 'Total Customer:'
     O               21      TSRQ          KB   119
     O               21      TSPQ          KB   105
     O               21      TSYQ          KB    91
     O               21      TSCQ          KB    77
     O          E            TLR         2  1
     O               21                          60 'Report Totals:'
     O               21      TRRQ          KB   119
     O               21      TRPQ          KB   105
     O               21      TRYQ          KB    91
     O               21      TRCQ          KB    77
      **
