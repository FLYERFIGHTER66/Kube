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
      *PROGRAM NAME-------- GLR87B
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- CONVERT GLPRE FROM 400 FORMAT TO 36 FORMAT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFGLPRE    UF   E             DISK
     FGLDET     O  A F  192        DISK
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
      ***********************
      ** READ OLD FILE     **
      ***********************
     C     NXT           TAG
     C                   READ      FGLPRE                                 90
     C   90              GOTO      END
     C     GTSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   END
     C                   EXCEPT    DETADD
     C                   MOVEL     'D'           GTSTAT
     C                   UPDATE    RGLPRE
     C                   GOTO      NXT
      * END JOB
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
      ******************
      * OUTPUT SPECS   *
      ******************
     OGLDET     EADD         DETADD
     O                                            1 'A'
     O                       GTCOMP               3
      *    GENERAL LEDGER ACCOUNT
     O                       GTACCT              11
      *    G/L DETAIL DOLLARS
     O                       GTDOL$              17P
      *    DATE OF TRANSACTION
     O                       GTTDAT              23
      *    G/L DETAIL SOURCE REFERENCE
     O                       GTSRCE              26
      *    PROD CLASS 1
     O                       GTPROD              28
      *    JOURNAL ENTRY PREFIX
     O                       GTJEPR              30
      *    JOURNAL ENTRY NUMBER
     O                       GTJENM              36
      *    JOURNAL ENTRY SUFFIX
     O                       GTJESF              38
      *    JOURNAL ENTRY DESCRIPTION
     O                       GTJEDS              68
      *    ACCT. PERIOD DATE
     O                       GTAPER              72
      *    GENERAL LEDGER DETAIL TYPE
     O                       GTDETT              73
      *    G/L UPDATED FLAG
     O                       GTPOST              74
      *    JOURNAL ENTRY DESCRIPTION
      *   SOURCE DESCRIPTION
     O                       GTSRDS             104
      *    TIME
     O                       GTTIME             110
     I*    USER I.D.
     O                       GTUSER             120
