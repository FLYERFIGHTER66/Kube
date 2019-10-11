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
      **PROGRAM NAME-------- PUTDWN
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT PUT DOWN REPORT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  1/26/01 EFD IF SPEC ITEM MOVE BLANKS INTO STA. PER DEE
      *
     FPUTDWNFL  IF   E             DISK
     F                                     RENAME(PUTDWNFL:PDOWN)
     FFPPO      IF   E           K DISK
     FPUTDWN    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LDAPTO                 1      1  0                                      ARC380
      ***********************
      ** START HERE        **
      ***********************
     C     NXT           TAG
     C                   READ      PUTDWNFL                               90
     C   90              GOTO      END
     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C     TOTQTY        IFGT      0
     C   OF              EXCEPT    HEAD
     C                   EXCEPT    TOTL
     C                   END
     C                   MOVEL     OIITEM        OITEM            12
     C                   MOVEL     OISIZE        OSIZE             3
     C                   MOVEL     OIDES1        ODES1            30
     C                   Z-ADD     0             TOTQTY            6 0
     C                   SETON                                        OF
     C                   END
     C     LOC           IFLE      *BLANKS
     C                   MOVEL     OHLOC         LOCAT             6
     C                   ELSE
     C     OIORD#        CHAIN     FPPO                               71
     C     LOC           IFEQ      '1'
     C                   MOVEL     POLOWC        LOCAT
     C                   ELSE
     C                   MOVEL     POLOWF        LOCAT
     C                   END
     C                   END
     C                   Z-ADD     OIQORD        QTYORD            6 0
     C                   ADD       OIQORD        TOTQTY
      ** IF LOT CONTROL BLANK OUT STA
     C     OILOTC        IFEQ      'Y'
     C                   MOVE      *BLANKS       OHSTA
     C                   END
     C   OF              EXCEPT    HEAD
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      ** END PROG
     C     END           TAG
     C     TOTQTY        IFGT      0
     C   OF              EXCEPT    HEAD
     C                   EXCEPT    TOTL
     C                   END
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OPUTDWN    E            HEAD           1 12
     O                                            6 'PUTDWN'
     O                                           21 'Requested by:'
     O                       USERID              32
     O                                           60 'Customer Location for'
     O                                           72 'Below Item.'
     O                       PAGE          Z    110
     O                                          104 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           42 'For:'
     O                       OITEM               55
     O                       OSIZE               55
     O                       ODES1               86
     O                                          102 'Time:'
     O                       TIMOD              110 '  :  :  '
     O          E            HEAD           1
     O                                           14 '--Order---'
     O          E            HEAD           0
     O                                           10 'Req. Date'
     O                                           14 'Lin'
     O                                           21 'Number'
     O                                           28 'Cust #'
     O                                           33 'Name'
     O                                           66 'Qty.Ord.'
     O                                           72 'STA'
     O                                           77 'B/O'
     O                                           90 'Loc.'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           90 '__________'
     O          EF           DETL           1
     O                       OIDTRQ        Y     10
     O                       OISEQ#        4     14
     O                       OIORD#        4     21
     O                       OHCUST        4     28
     O                       OHNAME              59
     O                       QTYORD        4     66
     O                       OHSTA               72
     O                       OIPRBO              76
     O                       LOCAT               90
     O                                          110 '_____________'
     O          EF           TOTL           1
     O                                           66 '======'
     O          EF           TOTL           1
     O                                           58 'Total Quantity=========>'
     O                       TOTQTY        1     66
     O          E            TOTL           1 61
     O                                           25 'Ready Bay___________'
     O                                           46 'Pick-Up_____________'
     O                                           67 'Total_______________'
     O                                           88 'Master Qty__________'
     O                                          109 'Diff.+/-____________'
