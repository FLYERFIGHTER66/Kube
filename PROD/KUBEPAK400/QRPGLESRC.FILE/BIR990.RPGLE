      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, LTD.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR990
      **COMPANY------------- EFD ENTERPRISES LTD.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- CONTROL MONTH END PROCESS IN DIS.
      **DESCRIPTION--------- SELECTS RECORDS TO BE PURGED FROM THE
      **                     MSALE, AND MTRAN FILES.
      **                     OPTIONALLY PRINTS A REPORT OF FILE
      **                     STATUS.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  6/07/96 GD CHANGED REPORT TO PRINT ON NARROW PAPER
      *  1/01/98 EFD ADDED LAST MONTH FILE LOGIC
      *  4/16/98 EFD CLOSE TAX FILE FOR THIS PERIOD
      *
     FFMSALE    UF   E           K DISK
     FFMSALEO   O  A E             DISK
     F                                     RENAME(RMSALE:OMSALE)
     FFMTRAN    UF   E             DISK
     FFMTRANO   O  A E             DISK
     F                                     RENAME(RMTRAN:OMTRAN)
     FFTAXDS    UF   E             DISK
     FFTAXDSO   O  A E             DISK
     F                                     RENAME(RTAXDS:OTAXDS)
     FFMCORG    IF   E           K DISK
     FFOECTL    UF   E           K DISK
     FFTAXD     UF   E           K DISK
     FBIR990    O    F  132        PRINTER OFLIND(*INOF)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *                                                                   ARC380
     D                UDS
     D  LCO                    1      2  0
     D  LDAPER                 3      4  0
     D  LDAPPR                 5      5
     D  LDABEG                 6     11  0
     D  LDAEND                12     17  0
     D  LPURGE                18     18
     D  LMTRAN                19     27
     D  LMSALE                28     36
     D  LHORDW                37     45
     D  LIORDW                46     54
     D  LTINVT                55     63
     D  LLIBR                 64     74
     D  LTAXDS                75     83
     D  LDAMSV                84     84
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             90                    Y
     C     LCO           CHAIN     FOECTL                             97                    Y
     C     LDAPPR        IFEQ      'Y'                                          PRIOR PERIODS
     C                   SETON                                        21
     C                   ENDIF
     C     LPURGE        IFEQ      'Y'                                          PURGE       S
     C                   SETON                                        20
     C                   ENDIF
      *
      *  MOVE ACCOUNTING PERIOD DATES INTO CENTURY DATES
      *
     C                   Z-ADD     LDABEG        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C                   Z-ADD     LDAEND        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      ** SETOF NON POSTED GL FLAGS
     C                   SETOFF                                       515253
      * GET TAX FILE INFO
     C                   MOVE      LDAEND        TXW               2 0
     C     TXW           IFLT      90
     C                   MOVEL     20            TAXYR             4 0
     C                   ELSE
     C                   MOVEL     19            TAXYR
     C                   END
     C                   MOVE      TXW           TAXYR
     C                   MOVEL     LDAEND        TAXMTH            2 0
     C     NXTTAX        TAG
     C                   READ      FTAXD                                  90
     C   90              GOTO      ENDTAX
     C     TDYEAR        IFEQ      TAXYR
     C     TDMTH         ANDEQ     TAXMTH
     C                   MOVEL     'C'           TDCLOS
     C                   UPDATE    RTAXD
     C                   END
     C                   GOTO      NXTTAX
     C     ENDTAX        TAG
      *
      * PROCESS MSALE FILE
      *
     C     READSA        TAG
     C                   SETOFF                                       3099
     C                   READ      FMSALE                                 99
     C   99              GOTO      ENDRD1                                       EOF
     C     OCGL          IFEQ      'Y'
     C     MSGLUD        ANDNE     'Y'
     C                   SETON                                        52
     C                   GOTO      READSA
     C                   ENDIF
     C     MSSHPR        IFEQ      99
     C                   SETON                                        53
     C                   GOTO      READSA
     C                   ENDIF
     C     MSSTAT        IFEQ      'D'
     C                   SETON                                        30
     C                   ADD       1             WKTOTR
     C                   ADD       1             WKTOTP            6 0
     C                   ENDIF
     C     MSSTAT        IFNE      'D'
     C                   ADD       1             WKTOTR            6 0
     C                   EXSR      TSTPR
     C   30              ADD       1             WKTOTC            6 0
     C  N30              ADD       1             WKTOTA            6 0
     C                   ENDIF
      *
     C   30              WRITE     OMSALE                                                   D
     C   30
     CAN 20              DELETE    RMSALE                                                   D
      *
     C                   GOTO      READSA
     C     ENDRD1        TAG
      *
      **   PROCESS MTRAN FILE
      *
     C     READTR        TAG
     C                   SETOFF                                       3099
     C                   READ      FMTRAN                                 99
     C   99              GOTO      ENDRD2                                       EOF
      ** IF GL IS RUN FOR THIS COMPANY
     C     OCGL          IFEQ      'Y'
     C     MTGLUD        ANDNE     'Y'
     C                   SETON                                        51
     C                   GOTO      READTR
     C                   ENDIF
     C     MTSTAT        CASEQ     'D'           CNTPR1                         DELETED REC
     C     MTSTAT        CASNE     'D'           CNTAC1                         ACTIVE REC
     C                   END
     C   30              WRITE     OMTRAN                                                   D
     C   30
     CAN 20              DELETE    RMTRAN                                                   D
     C                   GOTO      READTR
      *
     C     ENDRD2        TAG
      *
      **   PROCESS TAXDS FILE
      *
     C     READTX        TAG
     C                   SETOFF                                       3099
     C                   READ      FTAXDS                                 99
     C   99              GOTO      ENDTX                                        EOF
     C                   EXSR      CHKTAX
     C   30              WRITE     OTAXDS                                                   D
     C   30
     CAN 20              DELETE    RTAXDS                                                   D
     C                   GOTO      READTX
      *
     C     ENDTX         TAG
     C                   Z-ADD     TDATE         OCDTMC
     C  N97              UPDATE    ROECTL
      *
     C                   SETON                                        LR
      *
      *  ***********
      *  * CNTAC1  *
      *  ***********
      *
      *  THIS SUBROUTINE PROCESSES ACTIVE RECORDS IN THE MTRAN FILE
      *
     C     CNTAC1        BEGSR
     C                   ADD       1             WKTOR1            6 0
     C                   EXSR      TSTPR1
     C   30              ADD       1             WKTOC1            6 0
     C  N30              ADD       1             WKTOA1            6 0
     C                   ENDSR
      *
      *  ***********
      *  * CNTPR1  *
      *  ***********
      *
      *  PROCESS RECORDS ALREADY MARKED FOR REMOVAL IN MTRAN
      *
     C     CNTPR1        BEGSR
     C                   ADD       1             WKTOR1            6 0
     C                   ADD       1             WKTOP1            6 0
     C                   ENDSR
      *  ***********
      *  * TSTPR   *
      *  ***********
      *
      *  TEST FOR PURGE OPTIONS - MSALE FILE
      *
     C     TSTPR         BEGSR
      *
     C     MSTDAT        IFGT      *ZEROS
     C                   Z-ADD     MSTDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         MSDATE            5 0
     C                   ELSE
     C                   Z-ADD     1             MSDATE
     C                   ENDIF
      *
     C     MSCOMP        IFNE      LCO
     C                   GOTO      ENDMS
     C                   ENDIF
     C     MSDATE        IFGT      EDATE
     C                   GOTO      ENDMS
     C                   ENDIF
     C  N21MSDATE        IFLT      BDATE
     C                   GOTO      ENDMS
     C                   ENDIF
     C                   SETON                                        30
      *
     C     ENDMS         ENDSR
      *  ***********
      *  * TSTPR1  *
      *  ***********
      *
      *  TEST FOR PURGE OPTIONS - MTRAN FILE
      *
     C     TSTPR1        BEGSR
      *
     C     MTTDAT        IFGT      *ZEROS
     C                   Z-ADD     MTTDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         MTDATE            5 0
     C                   ELSE
     C                   Z-ADD     1             MTDATE
     C                   ENDIF
      *
     C     MTCOMP        IFNE      LCO
     C                   GOTO      ENDMT
     C                   ENDIF
     C     MTDATE        IFGT      EDATE
     C                   GOTO      ENDMT
     C                   ENDIF
     C  N21MTDATE        IFLT      BDATE
     C                   GOTO      ENDMT
     C                   ENDIF
     C                   SETON                                        30
      *
     C     ENDMT         ENDSR
      *
      *  ***********
      *  * CHKTAX  *
      *  ***********
      *
      *  THIS SUBROUTINE CHECK DATES IN FTAXDS FOR PURGE
      *
     C     CHKTAX        BEGSR
     C                   SETOFF                                       30
     C                   Z-ADD     TDTDLA        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TXDATE            5 0
      *
     C     TXDATE        IFGT      EDATE
     C                   GOTO      ENDTS
     C                   ENDIF
     C                   SETON                                        30
      *
     C     ENDTS         ENDSR
      *
     OBIR990    T    LR                     1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAME              75
     O                                          118 'Page: 1'
     O          T    LR                     1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                          110 'Time:'
     O                       TIMOD              120 '  :  :  '
     O          T    LR
     O                                           51 'Dist. Closing Report'
     O          T    LR                       09
     O                                           43 'Closing Parameters'
     O          T    LR                     2 12
     O                                           31 'Company Selection'
     O                       LCO                 46
     O          T    LR                     2
     O                                           30 'Period Selection'
     O                       LDAPER              46
     O                       LDABEG        Y     62
     O                                           64 '-'
     O                       LDAEND        Y     73
     O          T    LR                     2
     O                                           35 'Process Prior Periods'
     O                       LDAPPR              45
     O          T    LR                     2
     O                                           30 'File Save Option'
     O                       LDAMSV              45
     O**      T  2     LR
     O**                                 35 'Closing Report Option'
     O**                       LDAMRP    45
     O          T    LR                     2
     O                                           31 'File Purge Option'
     O                       LPURGE              45
     O          T    LR                  1  2
     O                                           25 'File Status'
     O                                           69 'FMSALE'
     O                                           84 'FMTRAN'
     O          T    LR                     2
     O                                           37 'Total Number of Records'
     O                       WKTOTR        Z     69
     O                       WKTOR1        Z     84
     O          T    LR                     2
     O                                           26 'Open Records'
     O                       WKTOTA        Z     69
     O                       WKTOA1        Z     84
     O          T    LR                     2
     O                                           34 'Records Already Mark'
     O                                           48 'ed For Removal'
     O                       WKTOTP        Z     79
     O                       WKTOP1        Z     84
     O          T    LR                     2
     O                                           34 'Records Marked For R'
     O                                           51 'emoval This Cycle'
     O                       WKTOTC        Z     69
     O                       WKTOC1        Z     84
     O          T    LR 51                  2
     O                                           34 'There are records in'
     O                                           59 'MTRAN That have NOT been'
     O                                           84 'posted to General Ledger'
     O          T    LR 52                  2
     O                                           34 'There are records in'
     O                                           59 'MSALE That have NOT been'
     O                                           84 'posted to General Ledger'
     O          T    LR 53                  2
     O                                           34 'There are records in'
     O                                           59 'MSALE That have NOT been'
     O                                           84 'posted to Sales History '
      *
