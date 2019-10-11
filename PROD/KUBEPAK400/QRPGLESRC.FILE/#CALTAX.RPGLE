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
      **PROGRAM NAME-------- #CALTAX
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- EFDSYS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCULATE TAXES AND TAX BASE AMOUNTS
      *                      (CALLED)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTAXF    IF   E           K DISK
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
      * INPUT PARMS  *
      ****************
      *
     C     *ENTRY        PLIST
     C                   PARM                    TAXJU             3            JURISTICTION
     C                   PARM                    MERCH$           11 2
     C                   PARM                    FRGHT$           11 2
     C                   PARM                    SPECL$           11 2
     C                   PARM                    TAXFRT            1            Y/N
     C                   PARM                    TAXSPC            1            Y/N
     C                   PARM                    BASE1            11 2          TAXABLE $
     C                   PARM                    BASE2            11 2          TAXABLE $
     C                   PARM                    BASE3            11 2          TAXABLE $
     C                   PARM                    TAX1             11 2          STATE TAX $
     C                   PARM                    TAX2             11 2          COUNTY TAX $
     C                   PARM                    TAX3             11 2          LOCAL TAX $
      *
      ****************
      ** START HERE **
      ****************
      *
      *  GET TAX RECORD
     C     TAXJU         CHAIN     FMTAXF                             90
     C   90              DO
     C                   Z-ADD     0             BASE1
     C                   Z-ADD     0             BASE2
     C                   Z-ADD     0             BASE3
     C                   Z-ADD     0             TAX1
     C                   Z-ADD     0             TAX2
     C                   Z-ADD     0             TAX3
     C                   GOTO      END
     C                   ENDDO
      ** GET STATE TAX BASE
     C                   Z-ADD     MERCH$        BASE1
     C                   Z-ADD     0             BASE2
     C                   Z-ADD     0             BASE3
     C                   Z-ADD     0             TAX1
     C                   Z-ADD     0             TAX2
     C                   Z-ADD     0             TAX3
     C     TAXFRT        IFEQ      'Y'
     C                   ADD       FRGHT$        BASE1
     C                   END
     C     TAXSPC        IFEQ      'Y'
     C                   ADD       SPECL$        BASE1
     C                   END
      ** GET COUNTY
     C     TXPCT2        IFGT      .0000
     C                   Z-ADD     BASE1         BASE2
     C     TXPCT2        DIV       100           RATE2             9 6
     C                   ELSE
     C                   Z-ADD     0             RATE2
     C                   END
      ** GET LOCAL
     C     TXPCT3        IFGT      .0000
     C                   Z-ADD     BASE1         BASE3
     C     TXPCT3        DIV       100           RATE3             9 6
     C                   ELSE
     C                   Z-ADD     0             RATE3
     C                   END
      ** GET STATE CHECKED LAST IN CASE NO STATE BUT LOCAL
     C     TXPCT1        IFGT      .0000
     C     TXPCT1        DIV       100           RATE1             9 6
     C                   ELSE
     C                   Z-ADD     0             BASE1
     C                   Z-ADD     0             RATE1
     C                   END
      * CHECK LIMITS
     C     BASE1         IFGT      TXLIM1
     C                   Z-ADD     TXLIM1        BASE1
     C                   END
      *
     C     BASE2         IFGT      TXLIM2
     C                   Z-ADD     TXLIM2        BASE2
     C                   END
      *
     C     BASE3         IFGT      TXLIM3
     C                   Z-ADD     TXLIM3        BASE3
     C                   END
      * CALCULATE TAXES
     C     BASE1         MULT(H)   RATE1         TAX1
     C     BASE2         MULT(H)   RATE2         TAX2
     C     BASE3         MULT(H)   RATE3         TAX3
      * END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
