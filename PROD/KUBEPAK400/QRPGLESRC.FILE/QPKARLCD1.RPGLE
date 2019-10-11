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
      **PROGRAM NAME-------- QPARLCD
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DAILY LATE CHARGE CALCULATION
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    IF   E           K DISK
     FFAROPNDD  IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FFARLC     UF A E           K DISK
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
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   Z-ADD     0             CMCUST
     C     CMCUST        SETLL     FMCUST
     C                   EXSR      INIT
     C   99              GOTO      END
     C     NXTCST        TAG
     C                   READ      FMCUST                                 90
     C** 90                GOTO END
     C   90              GOTO      RSTART
      ** PUT SELECTION HERE   TEMP USE RICHARD SMITH FOR TEST
     C     CMCUST        IFNE      5729
     C                   GOTO      NXTCST
     C                   END
      ** GET AR BALANCE
     C                   EXSR      GETBAL
     C     BAL           IFLE      0
     C                   GOTO      NXTCST
     C                   END
      ** IF HERE THEY HAVE A BALANCE
     C                   Z-SUB     NEG           TEST             11 2
     C     CMCUST        SETLL     FAROPNDD
     C     NXTWRK        TAG
     C     CMCUST        READE     FAROPNDD                               91
     C   91              GOTO      NXTCST
      ** ONLY GET HEADER RECORDS WITH A BALANCE
     C     ARSEQ#        IFNE      000
     C     ARDUE$        OREQ      0.00
     C     ARTTYP        ORNE      01
     C                   GOTO      NXTWRK
     C                   END
     C     TEST          IFGT      0
     C     TEST          IFGE      ARDUE$
     C                   SUB       ARDUE$        TEST
     C                   GOTO      NXTWRK
     C                   END                                                    TEST>ARDUE$
      ** IF HERE ARDUE>TEST
     C                   SUB       TEST          ARDUE$
     C                   Z-ADD     0             TEST
     C                   END                                                    TEST>0
      ** NOW CALC OVER DUE DAYS
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      NXTWRK
     C                   END
     C                   Z-ADD     ##DDD         DDDAYS            5 0
     C     TDDAYS        SUB       DDDAYS        WKDAYS            5 0
     C     WKDAYS        IFLE      0
     C                   GOTO      NXTWRK
     C                   END
     C     LCKEY         KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C     LCKEY         CHAIN     FARLC                              75
     C   75              Z-ADD     0             ARLCAM
      ** NOW GET DAILY AMOUNT
     C     ARDUE$        MULT(H)   WKPCT         WKAMT            10 9
     C                   ADD       WKAMT         ARLCAM
     C**         WKAMT     MULT WKDAYS    ARLCAM    H
     C                   Z-ADD     WKDAYS        ARLCDY
     C   75              WRITE     RARLC
     C  N75              UPDATE    RARLC
     C                   GOTO      NXTWRK
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET CUST BALANCE  **
      ***********************
     C     GETBAL        BEGSR
     C                   Z-ADD     0             BAL              11 2
     C                   Z-ADD     0             NEG              11 2
     C     CMCUST        SETLL     FAROPNDD
     C     NXTBAL        TAG
     C     CMCUST        READE     FAROPNDD                               91
     C   91              GOTO      ENDBAL
      ** ONLY GET HEADER RECORDS WITH A BALANCE
     C     ARSEQ#        IFNE      000
     C     ARDUE$        OREQ      0.00
     C                   GOTO      NXTBAL
     C                   END
     C                   ADD       ARDUE$        BAL
     C     ARDUE$        IFLT      0
     C                   ADD       ARDUE$        NEG
     C                   END
     C                   GOTO      NXTBAL
     C     ENDBAL        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C**         *INZSR    BEGSR
     C     INIT          BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C     TDATE         IFLE      0
     C                   Z-ADD     31502         TDATE
     C                   ELSE
     C     TDDAYS        ADD       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDATE             6 0
     C                   END
     C**                   MOVE TMWRK     TDATE   60
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        IFGT      1020606
     C                   SETON                                        99
     C                   END
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TDDAYS            5 0
     C                   Z-ADD     1             LCO               2 0
     C     LCO           CHAIN     FARCTL                             LR
     C     ACLCPC        DIV       100           BPCT              4 4
     C     BPCT          DIV       360           WKPCT            10 9
     C                   ENDSR
