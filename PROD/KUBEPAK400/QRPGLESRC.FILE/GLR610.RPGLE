      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     215-957-1730ESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- GLR610
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- PRELIMINARY CLOSE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 7/28/00 EFD01 REMOVE G/L POSTED DATA FROM GLRJE
      *
      *
     FFGLDET    UF   E           K DISK
     F                                     RENAME(RGLDET:GLDETI)
     FFGLDETO   O  A E           K DISK
     FFGLDCON   UF   E           K DISK
     F                                     RENAME(RGLDCON:GLDCNI)
     FFGLDCONO  O  A E           K DISK
EFD01FFGLRJE    UF   E           K DISK
     FFMAPER    IF   E           K DISK
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
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C     LCO           CHAIN     FMAPER                             92
      *
     C                   Z-ADD     ACST01        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BDATE             7 0
      *
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     ACEN12        ##MDY
     C                   ELSE
     C                   Z-ADD     ACEN13        ##MDY
     C                   ENDIF
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        EDATE             7 0
      *
     C     NXT           TAG
     C                   SETOFF                                       50
     C                   READ      FGLDET                                 90
     C   90              GOTO      ENDDET
      *
     C     GTCYMD        IFGT      EDATE
     C     GTCOMP        ORNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
      * OUTPUT TO NEW GLDET AND DELETE OLD RECORD
      *
     C                   WRITE     RGLDET
     C                   DELETE    GLDETI
     C                   GOTO      NXT
      *
     C     ENDDET        TAG
      *
     C     NXTCON        TAG
     C                   SETOFF                                       50
     C                   READ      FGLDCON                                90
     C   90              GOTO      ENDCON
      *
     C     GTCYMD        IFGT      EDATE
     C     GTCOMP        ORNE      LCO
     C                   GOTO      NXTCON
     C                   ENDIF
      *
      * OUTPUT TO NEW GLDCON AND DELETE OLD RECORD
      *
     C                   WRITE     RGLDCON
     C                   DELETE    GLDCNI
     C                   GOTO      NXTCON
      *
EFD01C     NXTRJE        TAG
EFD01C                   SETOFF                                       50
EFD01C                   READ      FGLRJE                                 90
EFD01C   90              GOTO      ENDCON
EFD01 *
EFD01 * UPDATE GLRJE
EFD01 *
EFD01C                   MOVEL     *BLANKS       GJPP01
EFD01C                   MOVEL     *BLANKS       GJPP02
EFD01C                   MOVEL     *BLANKS       GJPP03
EFD01C                   MOVEL     *BLANKS       GJPP04
EFD01C                   MOVEL     *BLANKS       GJPP05
EFD01C                   MOVEL     *BLANKS       GJPP06
EFD01C                   MOVEL     *BLANKS       GJPP07
EFD01C                   MOVEL     *BLANKS       GJPP08
EFD01C                   MOVEL     *BLANKS       GJPP09
EFD01C                   MOVEL     *BLANKS       GJPP10
EFD01C                   MOVEL     *BLANKS       GJPP11
EFD01C                   MOVEL     *BLANKS       GJPP12
EFD01C                   MOVEL     *BLANKS       GJPP13
EFD01C                   MOVEL     USERID        GJUSER
EFD01C                   Z-ADD     TDATE         GJDTLA
EFD01C                   Z-ADD     TDATE         GJTIME
EFD01 *
EFD01C                   UPDATE    RGLRJE
EFD01C                   GOTO      NXTRJE
      *
     C     ENDCON        TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   ENDSR
      *
