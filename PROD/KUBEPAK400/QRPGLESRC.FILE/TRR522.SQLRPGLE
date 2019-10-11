      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- TRR522
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT MASTER TRUCK SCHEDULE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFTRSCHDT  IF   E           K DISK
      *FFTRHDRHRIF  E           K        DISK
     FFTRHDRW   IF   E           K DISK
     FFOECTL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCMDIR    IF   E           K DISK
     FTRR522    O    F   80        PRINTER OFLIND(*INOF)
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
     D  LDATE                  3      8  0
     D  LSDATE                 9     15  0
     D  LTRUCK                16     19
     D  LROUT                 20     21
     D  LDIR                  22     22
     D  LPRTR2                90     99
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *******************
      * START HERE      *
      *******************
     C     LSDATE        SETLL     FTRHDRW
     C     NXT           TAG
     C     LSDATE        READE     FTRHDRW                                90
     C   90              GOTO      END
     C     LROUT         IFGT      *BLANKS
     C     THROUT        ANDNE     LROUT
     C                   GOTO      NXT
     C                   END
     C     LTRUCK        IFGT      *BLANKS
     C     THTRK#        ANDNE     LTRUCK
     C                   GOTO      NXT
     C                   END
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C*          THTRK#    IFLE *BLANKS
     C*                    MOVELTHROUT    THTRK#
     C*                    END
     C                   EXCEPT    TRKHED
      ** GET DETAIL RECS
     C     TRKKEY        KLIST
     C                   KFLD                    THTRK#
     C                   KFLD                    THSHDT
     C                   Z-ADD     0             STOP              3 0
     C                   Z-ADD     0             TQTY1             5 0
     C                   Z-ADD     0             TQTY2             5 0
     C                   Z-ADD     0             TQTY3             5 0
WJB  C                   Z-ADD     0             TQTY4             5 0
     C     TRKKEY        SETLL     FTRSCHDT
     C     NXTD          TAG
     C     TRKKEY        READE     FTRSCHDT                               90
     C   90              GOTO      ENDTRK
     C                   ADD       1             STOP
     C                   ADD       TRQTY1        TQTY1                                         QPK53
     C                   ADD       TRQTY2        TQTY2                                         QPK53
     C                   ADD       TRQTY3        TQTY3                                         QPK53
WJB  C                   ADD       TRQTY4        TQTY4                                         QPK53
     C                   ADD       TRQTY1        LRQTY1            5 0                         QPK52
     C                   ADD       TRQTY2        LRQTY2            5 0                         QPK52
     C                   ADD       TRQTY3        LRQTY3            5 0                         QPK52
     C                   ADD       TRQTY4        LRQTY4            5 0                         QPK52
     C                   Z-ADD     TRQTY1        QTY1              5 0                         QPK53
     C                   Z-ADD     TRQTY2        QTY2              5 0                         QPK53
     C                   Z-ADD     TRQTY3        QTY3              5 0                         QPK53
     C                   Z-ADD     TRQTY4        QTY4              5 0                         QPK53
     C     TRCUST        CHAIN     FMCUST                             21
     C                   Z-ADD     TRCUST        CUS#              4 0                         QPK52
     C                   MOVEL     CMNAME        CUSNAM           22                           QPK52
WJB  C                   MOVEL     CMNAME        CUSNAM17         17                           QPK52
     C                   MOVEL     CMCITY        CUSCTY           15                           QPK52
WJB  C                   MOVEL     CMCITY        CUSCTY13         13                           QPK52
     C     CMFILL        COMP      'NT'                                   26
     C     TRCUST        CHAIN     FCMDIR                             25
     C  N25              DO
     C     CMDR01        IFLE      *BLANKS
     C     CMSTAT        OREQ      'D'
     C                   SETON                                        25
     C                   END
     C                   ENDDO                                                  N25  DO
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    CUST1
     C                   GOTO      NXTD
      ** END OF TRUCK
     C     ENDTRK        TAG
     C                   EXCEPT    TRKTOT
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    LRTOT
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C     01            CHAIN     FOECTL                             90
     C                   MOVE      OCHDG1        VHDG1             4
     C                   MOVE      OCHDG2        VHDG2             4
     C                   MOVE      OCHDG3        VHDG3             4
     C                   MOVE      OCHDG4        VHDG4             4
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OTRR522    E            HEAD           1 03
     O                                            6 'TRR522'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           45 'Kube-Pak'
     O                       PAGE          Z     80
     O                                           76 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           52 'Master Truck Schedule'
     O                                           71 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            TRKHED         1                                   QPK530
     O                                            7 'Truck:'                    QPK520
     O                       THTRK#              12                             QPK520
     O                                           25 'Ship Date:'                QPK520
     O                       LDATE         Y     34                             QPK520
     O                                           44 'Driver:'
     O                       THDRIV              51
     O                                           63 '1st Stop:'
     O                       THSTOP              74
     O          E            TRKHED         0                                   QPK530
     O**                       THCOMM    45
     O*                                          52 'D'
     O*                                          54 'T'
     O                                           48 'Zip'
     O                                           56 'Zone'
     O                                           58 'D'
     O                                           60 'T'
     O                       VHDG1               65
     O                       VHDG2               70
     O                       VHDG4               75
     O                       VHDG3               80
     O          E            TRKHED         1                                   QPK520
     O                                           65 '____'
     O                                           70 '____'
     O                                           75 '____'
     O                                           80 '____'
     O          EF           CUST1          1                                   QPK530
     O                       STOP          Z      3                             QPK530
     O                       CUS#          Z      8                             QPK530
     O              N21      CUSNAM17            26                             QPK530
     O              N21      CUSCTY13            40                             QPK530
     O              N21      CMSTST              43                             QPK530
     O*             N21 25                       52 'D'
     O*             N21 26                       54 'N'
     O              N21      CMZIP               53
     O              N21      CMUPSZ              55
     O              N21 25                       58 'D'
     O              N21 26                       60 'N'
     O               21                          43 ' ** Customer NOT on file'  QPK530
     O               21                          47 ' ** '                      QPK530
     O                       QTY1          Z     65                             QPK530
     O                       QTY2          Z     70                             QPK530
     O                       QTY4          Z     75                             QPK530
     O                       QTY3          Z     80                             QPK530
     O          E            TRKTOT      1  2                                   QPK530
     O                                           52 '** Truck Totals **'        QPK530
     O                       TQTY1         Z     65                             QPK530
     O                       TQTY2         Z     70                             QPK530
     O                       TQTY4         Z     75                             QPK530
     O                       TQTY3         Z     80                             QPK530
     O          E            LRTOT       1  1                                   QPK530
     O                                           52 '** Final Totals **'        QPK530
     O                       LRQTY1        Z     65                             QPK530
     O                       LRQTY2        Z     70                             QPK530
     O                       LRQTY4        Z     75                             QPK530
     O                       LRQTY3        Z     80                             QPK530
