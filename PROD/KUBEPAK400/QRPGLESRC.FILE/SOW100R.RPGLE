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
      **PROGRAM NAME-------- SOW100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD FILE TO PRINT SOW LINE LABELS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFBARCTL   UF   E           K DISK
     FFSOWSCHJ  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFOINVT    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFSOWLAB   O  A E             DISK
     FFTRAYR    O  A E             DISK
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
     D  SOWLN                  1      1  0                                      ARC380
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    SOWLIN            1 0
     C                   PARM                    SOWCYM            7 0
     C                   PARM                    JOB#              4 0
     C                   MOVE      *BLANKS       LCANCL
      ** IF JOB NUMBER EQUAL 9999 PRINT BLANK LABELS
     C     JOB#          IFEQ      9999
     C                   EXSR      BLANK
     C                   GOTO      END
     C                   END
      ** GET THE JOB AND NUMBER OF LABELS
     C     SCHKEY        KLIST
     C                   KFLD                    SOWCYM
     C                   KFLD                    JOB#
     C     SCHKEY        CHAIN     FSOWSCHJ                           91
     C   91              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
      ** GET NUMBER OF LABELS
     C**                   Z-ADDSOSOWT    LABELS  50
     C     SOSOWT        SUB       SOSOWQ        LABELS            5 0
     C     LABELS        IFLT      0
     C                   Z-ADD     0             LABELS
     C                   END
     C     00            CHAIN     FBARCTL                            91
     C                   Z-ADD     BXNXT#        NXT#              8 0
     C                   ADD       LABELS        BXNXT#
     C  N91              UPDATE    RBARCTL
      ** SUBTRACT 1 TO USE LOGIC ALL THRU
     C                   SUB       1             NXT#
     C                   Z-ADD     0             COUNT             5 0
     C     MINKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C     MINKEY        CHAIN     FMINVT                             91
      ** GET COMMON FIELDS
     C                   MOVEL     SOITEM        SLITEM
     C                   SETOFF                                       9899
     C     MINKEY        CHAIN     FOINVT                             98
     C  N98              MOVE      OVSALE        SALE3             3
     C   98SOSIZE        CHAIN     FMSIZE                             99
     C   98
     CANN99              MOVE      SZSALE        SALE3             3
     C  N99              MOVEL     SALE3         SLSIZE
     C   99              MOVEL     SOSIZE        SLSIZE
     C                   MOVEL     SOSIZE        SLSIZE
     C                   MOVE      SOSOWD        SLSOW
     C                   MOVE      SORDYD        SLRDY
     C                   MOVEL     IMDES1        SLDESC
     C                   MOVEL     IMLOC         SLLOC
     C                   MOVEL     IMTPSW        SLTPSW
     C                   MOVEL     IMMSCX        SLMSCX
     C                   MOVEL     IM#SED        SL#SED
     C                   MOVEL     ' '           TRSTAT
     C                   Z-ADD     SOWLIN        TRLIN#
     C                   MOVEL     SOITEM        TRITEM
     C                   MOVEL     SOSIZE        TRSIZE
     C                   Z-ADD     SOSOWD        TRSCYM
     C     SOSOWD        CHAIN     FCALENCY                           92
     C                   MOVEL     CLCENT        YEAR              4 0
     C                   MOVE      CLYEAR        YEAR
     C                   MOVEL     YEAR          TRSCYW
     C                   MOVE      CLWEEK        TRSCYW
     C                   Z-ADD     SORDYD        TRORDT
     C                   Z-ADD     SORDYD        TRCRDT
     C     SORDYD        CHAIN     FCALENCY                           92
     C                   MOVEL     CLCENT        YEAR              4 0
     C                   MOVE      CLYEAR        YEAR
     C                   MOVEL     YEAR          TRACYW
     C                   MOVE      CLWEEK        TRACYW
     C                   Z-ADD     SOJOB#        TRJOB#
     C                   MOVEL     IMPCL1        TRPRDC
     C                   MOVEL     IMLOOK        TRALPH
     C                   Z-ADD     TDATE         TRDTLA
     C                   Z-ADD     TIMOD         TRTIME
     C                   MOVEL     USERID        TRUSER
     C                   MOVEL     'PNS'         TRREAS
      ** OUTPUT RECORDS WITH TAG #
     C     NXT           TAG
     C                   ADD       1             COUNT
     C     COUNT         IFGT      LABELS
     C                   GOTO      END
     C                   END
     C                   ADD       1             NXT#
     C                   Z-ADD     NXT#          SLTAG#
     C                   Z-ADD     NXT#          TRTAG#
     C                   WRITE     RSOWLAB
     C                   WRITE     RTRAYR
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      **********************
      * PRINT BLANK LABELS *
      **********************
     C     BLANK         BEGSR
     C                   Z-ADD     0             COUNT
      ** GET COMMON FIELDS
     C                   MOVE      *BLANKS       SLITEM
     C                   MOVE      *BLANKS       SLSIZE
     C                   MOVE      *BLANKS       SLSOW
     C                   MOVE      *BLANKS       SLRDY
     C                   MOVE      *BLANKS       SLDESC
     C                   MOVE      *BLANKS       SLLOC
     C                   MOVE      *BLANKS       SLTPSW
     C                   MOVEL     *BLANKS       SLMSCX
     C                   MOVEL     *BLANKS       SL#SED
      ** OUTPUT RECORDS WITH NO TAG #
     C     NXTBLK        TAG
     C                   ADD       1             COUNT
     C     COUNT         IFGT      10
     C                   GOTO      ENDBLK
     C                   END
     C                   WRITE     RSOWLAB
     C                   GOTO      NXTBLK
     C     ENDBLK        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
