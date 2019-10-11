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
      *PROGRAM NAME-------- GLR87A
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- CONVERT GLPRE FROM 36 FPOMAT TO 400 FORMAT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FGLDET     UF   F  192        DISK
     FFGLPRE    O  A E             DISK
     D*    WORKSTATION I.D.
     D** COMBINED WITH ABOVE                119 120 GTWSID
     D*    FILLER, EFD
     D*                                     121 152 GTMFIL
     D*    FILLER, GLDET
     D*                                     153 160 GTOFIL
     D*    FILLER, USER
     D*                                     161 192 GTUFIL
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
     IGLDET     NS
     I*    STATUS
     I                                  1    1  GTSTAT
     I*    COMPANY
     I                                  2    3 0GTCOMP
     I*    GENERAL LEDGER ACCOUNT
     I                                  4   11 0GTACCT
     I*    G/L DETAIL DOLLARS
     I                             P   12   17 2GTDOL$
     I*    DATE OF TRANSACTION
     I                                 18   23 0GTTDAT
     I*    G/L DETAIL SOURCE REFERENCE
     I                                 24   26  GTSRCE
     I*    PROD CLASS 1
     I                                 27   28  GTPROD
     I*    JOURNAL ENTRY PREFIX
     I                                 29   30  GTJEPR
     I*    JOURNAL ENTRY NUMBER
     I                                 31   36 0GTJENM
     I*    JOURNAL ENTRY SUFFIX
     I                                 37   38  GTJESF
     I*    JOURNAL ENTRY DESCRIPTION
     I                                 39   68  GTJEDS
     I*    ACCT. PERIOD DATE
     I                                 69   72 0GTAPER
     I*    GENERAL LEDGER DETAIL TYPE
     I                                 73   73  GTDETT
     I*    G/L UPDATED FLAG
     I                                 74   74  GTPOST
     I*    JOURNAL ENTRY DESCRIPTION
     I                                 75  104  GTSRDS
     I*    TIME
     I                                105  110 0GTTIME
     I*    USER I.D.
     I                                111  120  GTUSER
      ***********************
      ** READ OLD FILE     **
      ***********************
     C     NXT           TAG
     C                   READ      GLDET                                  90
     C   90              GOTO      END
     C     GTSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   END
     C                   Z-ADD     GTAPER        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        GTCYMD
     C                   MOVEL     'S36'         GTAPPL
     C                   Z-ADD     0             GTVEND
     C                   WRITE     RGLPRE
     C                   EXCEPT    DETUPD
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
     OGLDET     E            DETUPD
     O                                            1 'D'
