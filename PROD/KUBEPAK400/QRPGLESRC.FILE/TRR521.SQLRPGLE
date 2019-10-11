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
      **PROGRAM NAME-------- TRR521
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT MASTER TRUCK SCHEDULE GET SORT OK
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFTRHDRHR  IF   E           K DISK
     FFTRHDRW   O  A E           K DISK
      *
      *
      * WORK ARRAYS
     D IN              S              1    DIM(4)                               TRUCK IN
     D OUT             S              1    DIM(4)                               TRUCK OUT
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
     C     LSDATE        SETLL     FTRHDRHR
     C     NXT           TAG
     C     LSDATE        READE     FTRHDRHR                               90
     C   90              GOTO      END
     C     LROUT         IFGT      *BLANKS
     C     THROUT        ANDNE     LROUT
     C                   GOTO      NXT
     C                   END
     C     LTRUCK        IFGT      *BLANKS
     C     THTRK#        ANDNE     LTRUCK
     C                   GOTO      NXT
     C                   END
      ** MOVE TRUCK NUMBER
     C                   Z-ADD     5             I                 5 0
     C                   Z-ADD     4             O                 5 0
     C                   Z-ADD     0             O0                1 0
     C                   MOVE      *BLANKS       IN
     C                   MOVE      *BLANKS       OUT
     C                   MOVEA     THTRK#        IN
     C     NXTI          TAG
     C                   SUB       1             I
     C     I             IFLE      0
     C                   GOTO      ENDI
     C                   END
     C     IN(I)         IFLE      *BLANKS
     C                   GOTO      NXTI
     C                   END
      ** MOVE THE REST
     C                   MOVE      IN(I)         OUT(O)
     C                   SUB       1             O
     C                   GOTO      NXTI
     C     ENDI          TAG
     C                   MOVEA     OUT           THTRKW
     C                   WRITE     RTRHDRW
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
