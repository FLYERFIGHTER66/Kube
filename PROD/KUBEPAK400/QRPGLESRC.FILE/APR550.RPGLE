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
      *PROGRAM NAME--------- APR550
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *DESCRIPTION-          G/L DETAIL UPDATE.
      *                      THIS PROGRAM CREATES A G/L DETAIL RECORD
      *                      FOR EVERY GROSS CHECK AMOUNT, DISC.TAKEN,
      *                      AND NET CHECK AMOUNT IN THE A/P MONTH FILE.
      *                      THE FLAGS IN A/P MONTH WILL BE UPDATED.
      *                      THE A/P DEFAULT ACCOUNT NUMBER FROM THE
      *                      G/L DEFAULT FILE IS USED FOR A/P MONTH RECS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/26/99 EFD CHANGE LOGIC FOR ACTPER CALC.
      *
      *
     FFAPMTH    UF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFGLPRE    O  A E             DISK
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
      *
     D JEDS            DS            30    OCCURS(1) INZ
     D  J1                     1      3    INZ('Ck ')
     D  AMCHEK                 4      9  0 INZ
     D  J2                    10     13    INZ(' Dt ')
     D  AMCKDT                14     19  0 INZ
     D  J3                    20     24    INZ(' Vnd ')
     D  AMVEND                25     30  0 INZ
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      * GET G/L DEFAULT FOR A/P MONTH RECORD.
      *
     C                   MOVEL     '01'          TYPE              2
     C     KEYGL         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    TYPE
     C     KEYGL         CHAIN     FGLDF                              97
      *
     C     NXT           TAG
     C                   SETOFF                                       0102
     C                   READ      FAPMTH                                 90
     C   90              GOTO      END
      *
      * ALREADY UPDATED
      *
     C     AMGLUD        IFEQ      'Y'                                                      TED
     C                   GOTO      NXT
     C                   ENDIF
      *
      * IF A VOID CHECK DON'T CREATE GLDET REC - ONLY UPDATE APMTH
      *
     C     AMCTYP        IFEQ      '5'                                                      YPE
     C                   EXSR      UPDMTH
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     AMCOMP        CONO              2 0
     C                   Z-ADD     AMCKDT        TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        #P                2 0
      *
     C     AMDTAK        IFEQ      0                                                        EN
     C                   SETON                                        11
     C                   ENDIF
      *
     C                   Z-SUB     AMDTAK        SVDTAK           11 2
     C                   Z-SUB     AM$NET        SV$NET           11 2          REVERSE SIGNS
      *
     C                   EXSR      GETGL
     C                   Z-ADD     GDAPPY        GTACCT
     C                   Z-ADD     AM$AMT        GTDOL$
     C                   WRITE     RGLPRE
     C                   Z-ADD     GDAPCH        GTACCT
     C                   Z-ADD     SV$NET        GTDOL$
     C                   WRITE     RGLPRE
     C     AMDTAK        IFNE      0                                            NEW         EN
     C                   Z-ADD     GDAPDS        GTACCT
     C                   Z-ADD     SVDTAK        GTDOL$
     C                   WRITE     RGLPRE
     C                   ENDIF                                                  NEW
     C                   EXSR      UPDMTH
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      **********
      * UPDMTH *
      **********
     C     UPDMTH        BEGSR
     C                   MOVEL     'Y'           AMGLUD
     C                   Z-ADD     TDATE         AMDTLA
     C                   Z-ADD     TIMOD         AMTIME
     C                   MOVEL     USERID        AMUSER
     C                   UPDATE    RAPMTH
     C                   ENDSR
      *                                                                ***
      *********
      * GETGL *
      *********
     C     GETGL         BEGSR
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     AMCOMP        GTCOMP
     C                   Z-ADD     AMCKDT        GTTDAT
     C                   Z-ADD     GTTDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        GTCYMD
     C                   MOVEL     'A/P'         GTSRCE
     C                   MOVEL     'A/P'         GTAPPL
     C                   MOVEL     *BLANKS       GTPROD
     C                   MOVEL     *BLANKS       GTJEPR
     C                   Z-ADD     *ZEROS        GTJENM
     C                   Z-ADD     AMVEND        GTVEND
     C                   MOVEL     *BLANKS       GTJESF
     C*                    MOVELAMCHEK    JEDSA  13
     C*                    MOVE AMCKDT    JEDSA
     C*                    MOVE AMVEND    JEDSB   7
     C*                    MOVELJEDSA     GTJEDS
     C*                    MOVE JEDSB     GTJEDS
     C                   MOVEL     JEDS          GTJEDS
     C     #P            IFNE      99
     C                   MOVE      AMCKDT        ACTY              2 0
     C                   MOVEL     ACTY          ACTP              4 0
     C                   MOVE      #P            ACTP
     C                   ELSE
     C                   Z-ADD     9999          ACTP
     C                   END
     C                   MOVEL     ACTP          GTAPER
     C                   MOVEL     *BLANKS       GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C                   MOVEL     AMTDES        GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   Z-ADD     TDATE         GTDTLA
     C                   MOVEL     USERID        GTUSER
     C                   ENDSR
      *
