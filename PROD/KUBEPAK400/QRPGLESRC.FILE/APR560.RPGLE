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
      *PROGRAM NAME--------- APR560
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *DESCRIPTION---------- G/L DETAIL UPDATE
      *                      THIS PROGRAM CREATES A G/L DETAIL RECORD
      *                      FOR EVERY A/P DETAIL RECORD.  THE FLAGS IN
      *                      A/P DETAIL WILL BE UPDATED.
      *
      *
      *
     FFAPDET    UF   E           K DISK
     FFAPOPN    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
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
     D JEDS            DS            30    OCCURS(1) INZ
     D  J1                     1      2    INZ('V ')
     D  ADVEND                 3      8  0 INZ
     D  J2                     9     11    INZ(' D ')
     D  ADIVDT                12     17  0 INZ
     D  J3                    18     20    INZ(' I ')
     D  ADINV#                21     30    INZ
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXT           TAG
     C                   SETOFF                                       0102
     C                   READ      FAPDET                                 90
     C   90              GOTO      END
      *
      * ALREADY UPDATED
      *
     C     ADGLUD        IFEQ      'Y'                                                      TED
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     ADCOMP        CONO              2 0
     C                   Z-ADD     ADAPER        TRNDAT            6 0
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
     C     ADPAID        IFEQ      'Y'                                                      ED
     C                   EXSR      APAID
     C                   ENDIF
      *
     C                   EXSR      GETGL
     C                   Z-ADD     ADGLA1        GTACCT
     C                   Z-ADD     ADGL$1        GTDOL$
     C                   WRITE     RGLPRE
     C                   EXSR      UPDDET
     C                   GOTO      NXT
      *
     C     END           TAG
      *
      * UPDATE CONTROL FILE WITH DATE OF G/L TRANSFER
      *
     C     LCO           CHAIN     FAPCTL                             90
     C                   Z-ADD     TDATE         AZDTGL
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
      *
     C                   SETON                                        LR
      *
      *********
      * APAID *
      *********
     C     APAID         BEGSR
     C     APKEY         KLIST
     C                   KFLD                    ADVEND
     C                   KFLD                    ADCOMP
     C                   KFLD                    ADVOUC
     C                   KFLD                    ADINV#
     C                   KFLD                    ADSEQ#
     C                   KFLD                    ADITYP
     C     APKEY         CHAIN     FAPOPN                             51
     C  N51APDUE$        IFEQ      *ZEROS
     C                   SETON                                        51
     C                   ENDIF
     C                   ENDSR
      *********
      * GETGL *
      *********
     C     GETGL         BEGSR
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     ADCOMP        GTCOMP
     C                   Z-ADD     ADAPER        GTTDAT
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
     C                   Z-ADD     ADVEND        GTVEND
     C                   MOVEL     *BLANKS       GTJESF
     C*                    MOVELADVOUC    JEDSA  13
     C*                    MOVE ADVEND    JEDSA
     C*                    MOVELADINV#    JEDSB  12
     C*                    MOVE ADITYP    JEDSB  12
     C*                    MOVELJEDSA     GTJEDS
     C*                    MOVE JEDSB     GTJEDS
     C                   MOVEL     JEDS          GTJEDS
     C                   MOVE      ADAPER        ACTY              2 0
     C                   MOVEL     ACTY          ACTP              4 0
     C                   MOVE      #P            ACTP
     C                   MOVEL     ACTP          GTAPER
     C                   MOVEL     *BLANKS       GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C                   MOVEL     ADTDES        GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   Z-ADD     TDATE         GTDTLA
     C                   MOVEL     USERID        GTUSER
     C                   ENDSR
      *
      **********
      * UPDDET *
      **********
     C     UPDDET        BEGSR
     C                   MOVEL     'Y'           ADGLUD
     C   51              MOVEL     'Y'           ADPAID
     C                   Z-ADD     TDATE         ADDTLA
     C                   Z-ADD     TIMOD         ADTIME
     C                   MOVEL     USERID        ADUSER
     C                   UPDATE    RAPDET
     C                   ENDSR
      *
