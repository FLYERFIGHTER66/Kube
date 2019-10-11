      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- ICR700
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- MONTH END CLOSING
      **DESCRIPTION--------- THIS PROGRAM ZEROS OUT THE MONTH-TO-DATE
      **                     RECEIPTS, ADJUSTMENTS, SALES AND ISSUES.
      **                     IT ALSO ROLLS THE YEAR-TO-DATE BUCKETS
      **                     IN THE INVENTORY MASTER FILE.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    UF   E           K DISK
     FFMAPER    IF   E           K DISK
      *
     D QTY             S             11  1 DIM(13)
     D DOL             S              9  2 DIM(13)
     D CST             S              9  2 DIM(13)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      ** USER I.D.
     D  USERID               254    261                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           IFLE      0
     C                   Z-ADD     01            LCO
     C                   END
     C     LCO           CHAIN     FMAPER                             98        GET ACCT PERIOD
     C  N98ACMPCN        IFEQ      'P'
     C                   SETON                                        10
     C                   ENDIF
      *
      * ROLL Y-T-D BUCKETS, AND CLEAR MONTH-TO-DATE FIELDS.
      *
     C                   MOVEL     *BLANKS       IKEY             12
     C     IKEY          SETLL     FMINVT
     C     NXT           TAG
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     IMQM12        IMQM13
     C                   Z-ADD     IMQM11        IMQM12
     C                   Z-ADD     IMQM10        IMQM11
     C                   Z-ADD     IMQM09        IMQM10
     C                   Z-ADD     IMQM08        IMQM09
     C                   Z-ADD     IMQM07        IMQM08
     C                   Z-ADD     IMQM06        IMQM07
     C                   Z-ADD     IMQM05        IMQM06
     C                   Z-ADD     IMQM04        IMQM05
     C                   Z-ADD     IMQM03        IMQM04
     C                   Z-ADD     IMQM02        IMQM03
     C                   Z-ADD     IMQM01        IMQM02
     C                   Z-ADD     IMQMTD        IMQM01
     C                   Z-ADD     IM$M12        IM$M13
     C                   Z-ADD     IM$M11        IM$M12
     C                   Z-ADD     IM$M10        IM$M11
     C                   Z-ADD     IM$M09        IM$M10
     C                   Z-ADD     IM$M08        IM$M09
     C                   Z-ADD     IM$M07        IM$M08
     C                   Z-ADD     IM$M06        IM$M07
     C                   Z-ADD     IM$M05        IM$M06
     C                   Z-ADD     IM$M04        IM$M05
     C                   Z-ADD     IM$M03        IM$M04
     C                   Z-ADD     IM$M02        IM$M03
     C                   Z-ADD     IM$M01        IM$M02
     C                   Z-ADD     IM$MTD        IM$M01
     C                   Z-ADD     IMCM12        IMCM13
     C                   Z-ADD     IMCM11        IMCM12
     C                   Z-ADD     IMCM10        IMCM11
     C                   Z-ADD     IMCM09        IMCM10
     C                   Z-ADD     IMCM08        IMCM09
     C                   Z-ADD     IMCM07        IMCM08
     C                   Z-ADD     IMCM06        IMCM07
     C                   Z-ADD     IMCM05        IMCM06
     C                   Z-ADD     IMCM04        IMCM05
     C                   Z-ADD     IMCM03        IMCM04
     C                   Z-ADD     IMCM02        IMCM03
     C                   Z-ADD     IMCM01        IMCM02
     C                   Z-ADD     IMCMTD        IMCM01
      *
     C                   Z-ADD     0             IMQMTD
     C                   Z-ADD     0             IM$MTD
     C                   Z-ADD     0             IMCMTD
     C                   Z-ADD     0             IMMREC
     C                   Z-ADD     0             IMISSU
     C                   Z-ADD     0             IMMADJ
      *
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   MOVEL     USERID        IMUSER
      *
      * CALCULATE BEGINNING ON HAND QTY FOR ALL UOM
      *
     C                   Z-ADD     IMQTOH        #QTY1
     C                   Z-ADD     IMQ2OH        #QTY2
     C                   Z-ADD     IMQ3OH        #QTY3
     C                   EXSR      #PRUM
     C                   Z-ADD     #PRQTY        IMBPOH
      *
     C                   UPDATE    RMINVT
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     C     #PRUM         BEGSR
      *  #PRUM - PRIMARY UNIT OF MEASURE QUANTITY ROUTINE CONVERTS
      *  QUANTITIES IN ALL UNITS OF MEASURE INTO PRIMARY UOM
      *  ITEM MASTER QUANTITY FIELDS MUST BE Z-ADDED INTO
      *  #QTY1, #QTY2, #QTY3 BEFORE EXECUTING SUBROUTINE.
      *  OUTPUT FIELD IS #PRQTY
      *
     C     *LIKE         DEFINE    IMQTOH        #QTY1
     C     *LIKE         DEFINE    IMQ2OH        #QTY2
     C     *LIKE         DEFINE    IMQ3OH        #QTY3
     C     *LIKE         DEFINE    IMQTOH        #PRQTY
     C     *LIKE         DEFINE    IMQTOH        #WK1
     C     *LIKE         DEFINE    IMQTOH        #WK2
      *
     C                   Z-ADD     0             #WK1
     C                   Z-ADD     0             #WK2
     C                   Z-ADD     #QTY1         #PRQTY
      *
     C     #QTY3         IFNE      0
     C     IMMUL2        ANDNE     0
     C     #QTY3         DIV(H)    IMMUL2        #WK2
     C     #WK2          ADD       #QTY2         #QTY2
     C                   ENDIF
      *
     C     #QTY2         IFNE      0
     C     IMMULT        ANDNE     0
     C     #QTY2         DIV(H)    IMMULT        #WK1
     C                   ENDIF
     C                   ADD       #WK1          #PRQTY
      *
     C                   ENDSR
      *
