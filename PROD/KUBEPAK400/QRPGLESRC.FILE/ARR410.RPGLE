      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      *PROGRAM NAME-------- ARR410
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- CM/OA  REPORT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    IF   E           K DISK
     FFAROPNAL  IF   E           K DISK
     FARR410    O    F  120        PRINTER OFLIND(*INOF)
      *
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
     D                UDS
     D  LCO                    1      2  0
     D  LCUST                  3      8  0
     D  LOPT                  10     10
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *****************
      *  START HERE   *
      *****************
      *
      ** SEE IF CUST NO IF SO SET FAROPNAL
     C     LCUST         IFGT      0
     C     LCUST         CHAIN     FMCUST                             90
     C   90              GOTO      END
     C                   ELSE                                                   LCUST>0
     C                   MOVE      *BLANKS       CMLOOK
     C                   END                                                    LCUST>0
      ** SETLL ON FAROPNAL
     C     CMLOOK        SETLL     FAROPNAL
     C     NXTOPA        TAG
     C                   Z-ADD     0             TOTOA             9 2
     C                   Z-ADD     0             TOTCM             9 2
     C                   Z-ADD     0             TOTIN             9 2
     C     NXTOP1        TAG
     C                   READ      FAROPNAL                               90
     C   90              DO
     C     TOTOA         IFLT      0
     C     TOTCM         ORLT      0
     C     TOTIN         IFGT      0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    SPREAD
     C                   END                                                    TOTIN>0
     C                   END                                                    TOTOA<0
     C                   GOTO      END
     C                   ENDDO                                                  90  DO
     C     ARCOMP        IFNE      LCO
     C                   GOTO      NXTOP1
     C                   END                                                    ARCOMP><LCO
      ** CHECK IF SAME CUST
     C     ARCUST        IFNE      OCUST
     C     LCUST         IFGT      0
     C     ARCUST        ANDLT     LCUST
     C                   GOTO      NOSPRD
     C                   ENDIF                                                  ARCUST<LCUST
     C     OCUST         IFGT      0
     C     TOTOA         IFLT      0
     C     TOTCM         ORLT      0
     C     TOTIN         IFGT      0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF DO
     C                   EXCEPT    SPREAD
     C                   END                                                    TOTIN>0
     C                   END                                                    TOTOA<0
     C                   END                                                    OCUST>0
     C     NOSPRD        TAG
     C                   Z-ADD     0             TOTOA             9 2
     C                   Z-ADD     0             TOTCM             9 2
     C                   Z-ADD     0             TOTIN             9 2
     C     LCUST         IFGT      0
     C     ARCUST        ANDGT     LCUST
     C                   GOTO      END
     C                   ENDIF                                                  LCUST>0
     C                   Z-ADD     ARCUST        OCUST             6 0
     C     ARCUST        CHAIN     FMCUST                             91
     C                   ENDIF                                                  ARCUST><OCUS
      ** NOW GET TOTATL
     C     ARSEQ#        IFNE      000
     C                   GOTO      NXTOP1
     C                   END                                                    ARSEQ#><000

     C     ARTTYP        IFEQ      01
     C     ARTTYP        OREQ      07                                           LATE CHG.
     C     ARDUE$        IFGT      0
     C                   ADD       ARDUE$        TOTIN
     C                   END                                                    ARDUE$>0
     C                   END                                                    ARTTYP=01/07

     C     ARTTYP        IFEQ      03
     C     ARDUE$        IFLT      0
     C                   ADD       ARDUE$        TOTOA
     C                   END                                                    ARDUE$<0
     C                   END                                                    ARTTYP=3

     C     ARTTYP        IFEQ      10
     C     ARDUE$        IFLT      0
     C                   ADD       ARDUE$        TOTOA
     C                   END                                                    ARDUE$<0
     C                   END                                                    ARTTYP=3

     C     ARTTYP        IFEQ      05
     C     ARDUE$        IFLT      0
     C                   ADD       ARDUE$        TOTCM
     C                   END                                                    ARDUE$<0
     C                   END                                                    ARTTYP=05

     C                   GOTO      NXTOP1
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
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TDCYMD            7 0
     C                   SETON                                        OF
     C                   ENDSR
      **
      ******************
      * OUTPUT SPECS   *
      ******************
     OARR410    E            HEAD           1 03
     O                                            6 'ARR410'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           56 'Open Credit Memos and'
     O                                           72 'On-Account Cash'
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           76 'Time:'
     O                       TIMOD               85 '  :  :  '
     O          EF           HEAD           0
     O                                            8 'Customer'
     O                                           50 'On-Account'
     O                                           63 'Credit Memo'
     O                                           76 'Invoices'
     O          EF           HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          EF           SPREAD         1
     O                       OCUST         4      6
     O                       CMNAME              37
     O                       TOTOA         K     50
     O                       TOTCM         K     63
     O                       TOTIN         K     76
