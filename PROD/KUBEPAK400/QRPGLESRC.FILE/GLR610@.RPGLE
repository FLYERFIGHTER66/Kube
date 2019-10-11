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
      *
      *
     FFGLDET    UF   E           K DISK
     F                                     RENAME(RGLDET:GLDETI)
     FFGLDETO   O  A E           K DISK
     FFGLDCON   UF   E           K DISK
     F                                     RENAME(RGLDCON:GLDCNI)
     FFGLDCONO  O  A E           K DISK
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
