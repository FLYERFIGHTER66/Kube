      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- GETCSLS
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET CUST SALES
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCUST    IF   E           K DISK
     FFSOHSTCI  IF   E           K DISK
     FFIORCUST  IF   E           K DISK
     FFCUSTSLA  IF   E           K DISK
     F                                     RENAME(RCUSTSLS:CUSTSL)
     FFCUSTSLS  UF A E           K DISK
     FGETCSLS   O    F  120        PRINTER OFLIND(*INOF)
      *
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
     D  SOFROM                 3      8  0
     D  SOFCYM                 9     15  0
     D  SOTO                  16     21  0
     D  SOTCYM                22     28  0
     D  OOFROM                29     34  0
     D  OOFCYM                35     41  0
     D  OOTO                  42     47  0
     D  OOTCYM                48     54  0
     D  CTYP1                 55     56
     D  CTYP2                 57     58
     D  CTYP3                 59     60
     D  CTYP4                 61     62
     D  SIZE1                 63     65
     D  SIZE2                 66     68
     D  SIZE3                 69     71
     D  SIZE4                 72     74
     D  SIZE5                 75     77
     D  SIZE6                 78     80
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      ***********************
      ** GET LAST YEAR SALES*
      ***********************
     C     NXTLST        TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      ENDLST
     C     CMCTYP        IFNE      CTYP1
     C     CMCTYP        ANDNE     CTYP2
     C     CMCTYP        ANDNE     CTYP3
     C     CMCTYP        ANDNE     CTYP4
     C                   GOTO      NXTLST
     C                   END
     C     CMSTAT        IFNE      'A'
     C                   GOTO      NXTLST
     C                   END
     C     CMCUST        CHAIN     FCUSTSLS                           51
     C   51              DO
     C                   Z-ADD     CMCUST        CSCUST
     C                   Z-ADD     CMARCU        CSARCU
     C                   ENDDO                                                  51  DO
     C                   Z-ADD     0             CSSLS$
     C     CMCUST        SETLL     FSOHSTCI
     C     NXTSOH        TAG
     C     CMCUST        READE     FSOHSTCI                               91
     C  N91              DO
     C     SOSHDT        IFGE      SOFCYM
     C     SOSHDT        ANDLE     SOTCYM
     C     SOSIZE        IFEQ      SIZE1
     C     SOSIZE        OREQ      SIZE2
     C     SOSIZE        OREQ      SIZE3
     C     SOSIZE        OREQ      SIZE4
     C     SOSIZE        OREQ      SIZE5
     C     SOSIZE        OREQ      SIZE6
     C                   ADD       SOEXT$        CSSLS$
     C                   END
     C                   END
     C                   GOTO      NXTSOH
     C                   ENDDO                                                  91 DO
     C   51              WRITE     RCUSTSLS
     C  N51              UPDATE    RCUSTSLS
     C                   GOTO      NXTLST
     C     ENDLST        TAG
      ** NOW GET OPEN ORDERS AND
     C     NXTCST        TAG
     C                   READ      FCUSTSLA                               91
     C   91              GOTO      END
     C     CSSLS$        IFLE      0
     C                   GOTO      END
     C                   END
     C     CSCUST        CHAIN     FMCUST                             70
     C     CSCUST        SETLL     FIORCUST
     C                   Z-ADD     0             CSOPN$            9 2
     C     NXTOPN        TAG
     C     CSCUST        READE     FIORCUST                               92
     C  N92              DO
     C     OIRVDT        IFGE      OOFCYM
     C     OIRVDT        ANDLE     OOTCYM
     C     OISTAT        IFEQ      'A'
     C     OISIZE        IFEQ      SIZE1
     C     OISIZE        OREQ      SIZE2
     C     OISIZE        OREQ      SIZE3
     C     OISIZE        OREQ      SIZE4
     C     OISIZE        OREQ      SIZE5
     C     OISIZE        OREQ      SIZE6
     C                   ADD       OIEXT$        CSOPN$
     C                   END
     C                   END
     C                   END
     C                   GOTO      NXTOPN
     C                   ENDDO                                                  N92  DO
      ** NOW PRINT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C     CSOPN$        IFLT      CSSLS$
     C                   SETON                                        77
     C                   ELSE
     C                   SETOFF                                       77
     C                   END
     C                   EXCEPT    DETL
     C                   GOTO      NXTCST
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     CTYP1         IFLE      *BLANKS
     C                   MOVEL     '??'          CTYP1
     C                   END
     C     CTYP2         IFLE      *BLANKS
     C                   MOVEL     '??'          CTYP2
     C                   END
     C     CTYP3         IFLE      *BLANKS
     C                   MOVEL     '??'          CTYP3
     C                   END
     C     CTYP4         IFLE      *BLANKS
     C                   MOVEL     '??'          CTYP4
     C                   END
     C     SIZE1         IFLE      *BLANKS
     C                   MOVEL     '???'         SIZE1
     C                   END
     C     SIZE2         IFLE      *BLANKS
     C                   MOVEL     '???'         SIZE2
     C                   END
     C     SIZE3         IFLE      *BLANKS
     C                   MOVEL     '???'         SIZE3
     C                   END
     C     SIZE4         IFLE      *BLANKS
     C                   MOVEL     '???'         SIZE4
     C                   END
     C     SIZE5         IFLE      *BLANKS
     C                   MOVEL     '???'         SIZE5
     C                   END
     C     SIZE6         IFLE      *BLANKS
     C                   MOVEL     '???'         SIZE6
     C                   END
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OGETCSLS   E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           70 'Customer Plug Order'
     O                                           88 'Comparison Report'
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           33 'Shipped from:'
     O                       SOFROM        Y     42
     O                                           48 'Thru:'
     O                       SOTO          Y     57
     O                                           76 'Open Orders from:'
     O                       OOFROM        Y     85
     O                                           91 'Thru:'
     O                       SOTO          Y    100
     O                                          111 'Time:'
     O                       TIMOD              120 '  :  :  '
     O          E            HEAD           0
     O                                            6 'Cust #'
     O                                           10 'CT'
     O                                           15 'Name'
     O                                           46 'City'
     O                                           63 'St'
     O                                           75 'Telephone #'
     O                                           89 'Open Orders'
     O                                          103 'Last Yr Sls'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                          100 '____________________'
     O                                          103 '___'
     O          EF           DETL           1
     O                       CSCUST        4      6
     O                       CMCTYP              10
     O                       CMNAME              41
     O                       CMCITY              60
     O                       CMSTST              63
     O                       CMPHON              76 '   -   -    '
     O                       CSOPN$        K     89
     O                       CSSLS$        K    103
     O               77                         105 '**'
