      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- APR221
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- CHECK FOR NEGATIVE CHECKS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPOPN    UF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
      ** VENDORS TO MARK NO PAY
     D VEN             S              6  0 DIM(200)                             VENDOR NUMBERS
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
     C                   SETOFF                                       90
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             CNT               4 0
     C                   Z-ADD     1             FIRST             4 0
     C                   Z-ADD     1             FINV              4 0
     C                   Z-ADD     1             CNTV              4 0
     C                   Z-ADD     0             VEN
     C                   Z-ADD     0             V                 3 0
     C                   Z-ADD     0             L2NET$
      *
     C     NXT           TAG
     C                   READ(N)   FAPOPN                                 90
     C   90              GOTO      END
      *
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APTBPD        IFNE      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'C'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNTV          IFGT      1
     C                   GOTO      NOT1
     C                   ENDIF
     C     APVEND        CHAIN     FMVEND                             12
     C     NOT1          TAG
      *
     C     FIRST         IFEQ      1
     C                   GOTO      NOCHK
     C                   ENDIF
      *
     C     APVEND        IFNE      OLVEND
     C     L2NET$        IFLT      0
     C                   ADD       1             V
     C                   Z-ADD     OLVEND        VEN(V)
     C                   SETON                                          71
     C                   ENDIF
     C                   Z-ADD     0             L2NET$
     C                   ENDIF
      *
     C     APVEND        IFNE      OLVEND
     C                   Z-ADD     1             CNT
     C                   ENDIF
      *
      * AT NEW VENDOR, CHAIN TO GET VENDOR NAME
      *
     C     APVEND        CHAIN     FMVEND                             12
      *
     C     NOCHK         TAG
      *
      * CALCULATE NET DUE AND ACCUMULATE DATE AND COMPANY TOTALS
      *
     C                   Z-SUB     APDISC        APDISC
     C     APITYP        IFEQ      'C'
     C                   Z-SUB     APDISC        APDISC
     C                   ENDIF
     C                   ADD       APDUE$        L2$AMT           11 2
     C                   ADD       APDISC        L2DISC            7 2
     C                   ADD       AP$TOP        L2NET$           11 2
      *
     C     CNT           IFEQ      1
     C                   SETON                                        40
     C                   ENDIF
      *
     C                   Z-ADD     APVEND        OLVEND            6 0
     C                   ADD       1             CNT
     C                   ADD       1             CNTV
     C                   ADD       1             FIRST
     C                   SETOFF                                       40  72
      *
     C                   GOTO      NXT
     C     END           TAG
     C     L2NET$        IFLT      0
     C                   ADD       1             V
     C                   Z-ADD     OLVEND        VEN(V)
     C                   SETON                                          71
     C                   ENDIF
      * SEE IF ANY NEG CHECKS
     C   71              EXSR      NOPAY
      *
     C                   SETON                                        LR
      *
      ******************
      *  NO PAY        *
      ******************
     C     NOPAY         BEGSR
     C     PAYKEY        KLIST
     C                   KFLD                    VEN(X)
     C                   KFLD                    LCO
     C                   Z-ADD     0             X                 4 0
     C     NXTPAY        TAG
     C                   ADD       1             X
     C     X             IFGT      V
     C                   GOTO      ENDPAY
     C                   END
     C     PAYKEY        SETLL     FAPOPN
     C     NXTNOP        TAG
     C     PAYKEY        READE     FAPOPN                                 90
     C   90              GOTO      NXTPAY
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXTNOP
     C                   ENDIF
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXTNOP
     C                   ENDIF
      *
     C     APTBPD        IFNE      'Y'
     C                   GOTO      NXTNOP
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'C'
     C                   GOTO      NXTNOP
     C                   ENDIF
     C                   Z-ADD     0             AP$TOP
     C                   Z-ADD     0             APDISC
     C                   MOVE      *BLANKS       APTBPD
     C                   UPDATE    RAPOPN
     C                   GOTO      NXTNOP
     C     ENDPAY        TAG
     C                   ENDSR
