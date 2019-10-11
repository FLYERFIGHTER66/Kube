      *****************************************************************
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
      *PROGRAM NAME-------- ARRDAY
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- DAYS TO PAY REPORT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
      *
     FFMCUST    IF   E           K DISK
     FFAROPNCD  IF   E           K DISK
     F                                     RENAME(RAROPN:AROPNI)
     FFAROPN    IF   E           K DISK
     FFARHISTE  IF   E           K DISK
     F                                     RENAME(RARHIS:ARHISI)
     FFARHIST   IF   E           K DISK
     FARRDAY    O    F  132        PRINTER OFLIND(*INOF)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    263
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      ***********
      *   LDA   *
      ***********
     D                UDS
     D  LCO                    1      2  0
     D  LCUST                  3      8  0
     D  BDATE                  9     14  0
     D  EDATE                 15     20  0
     D  BDCYMD                21     27  0
     D  EDCYMD                28     34  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *
     C                   Z-ADD     0             INVDAY            7 0
     C                   Z-ADD     0             INVPAY            5 0
     C     LCUST         SETLL     FARHISTE
     C     NXTHS         TAG
     C     LCUST         READE     FARHISTE                               90
     C   90              GOTO      ENDHST
      ** GET RID OF ALL BUT UNPAID INVOICES
     C     AHTTYP        IFNE      01
     C                   GOTO      NXTHS
     C                   END
      ** CHECK INVOICE DATES
     C     AHTDAT        IFLT      BDCYMD
     C     AHTDAT        ORGT      EDCYMD
     C                   GOTO      NXTHS
     C                   END
      * IF HERE AT LEAST 1 TRANSACTION AGAINST THIS INVOICE
     C     ARHKEY        KLIST
     C                   KFLD                    AHCUST
     C                   KFLD                    AHINV#
     C                   KFLD                    AHSUFF
     C     ARHKEY        SETLL     FARHIST
     C     NXTHSO        TAG
     C     ARHKEY        READE     FARHIST                                90
     C   90              GOTO      NXTHS
     C     AHTTYP        IFEQ      01
     C                   Z-ADD     AHINV#        INV#              6 0
     C                   Z-ADD     AHTDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TRNDDD            5 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TRDATE            6 0
     C                   Z-ADD     AHDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DUEDDD            5 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDATE            6 0
     C                   Z-ADD     AH$AMT        INVAMT            8 2
     C                   Z-ADD     AH$AMT        DUEAMT            8 2
     C                   MOVEL     'N'           PRTD              1
     C                   GOTO      NXTHSO
     C                   END                                                    ARTTYP=01
      ** GET PAYMENT
     C     AHTTYP        IFEQ      02
     C     AHTTYP        OREQ      10
     C                   ADD       AH$AMT        DUEAMT
     C                   Z-SUB     AH$AMT        PAYAMT            8 2
     C                   Z-ADD     AHTDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         PAYDDD            5 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         PDDATE            6 0
     C     PAYDDD        SUB       TRNDDD        #DAYS             5 0
     C                   ADD       #DAYS         INVDAY            7 0
     C                   ADD       1             INVPAY            5 0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C     PRTD          IFEQ      'N'
     C                   EXCEPT    DETL
     C                   MOVEL     'Y'           PRTD
     C                   ELSE
     C                   EXCEPT    DETLPY
     C                   END                                                    PRTD=N
     C                   GOTO      NXTHSO
     C                   END                                                    ARTTYP=02 10
      ** IF HERE NOT PAY OR INV
     C                   ADD       AH$AMT        DUEAMT
     C                   GOTO      NXTHSO
     C     ENDHST        TAG
      *******************
      * AROPN FILE      *
      *******************
     C     LCUST         SETLL     FAROPNCD
     C     NXTAR         TAG
     C     LCUST         READE     FAROPNCD                               90
     C   90              GOTO      ENDAR
      ** GET RID OF ALL BUT UNPAID INVOICES
     C     ARTTYP        IFNE      01
     C     AR$AMT        OREQ      ARDUE$
     C                   GOTO      NXTAR
     C                   END
      ** CHECK INVOICE DATES
     C     ARTDAT        IFLT      BDCYMD
     C     ARTDAT        ORGT      EDCYMD
     C                   GOTO      NXTAR
     C                   END
      * IF HERE AT LEAST 1 TRANSACTION AGAINST THIS INVOICE
     C     AROKEY        KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C     AROKEY        SETLL     FAROPN
     C     NXTARO        TAG
     C     AROKEY        READE     FAROPN                                 90
     C   90              GOTO      NXTAR
     C     ARTTYP        IFEQ      01
     C                   Z-ADD     ARINV#        INV#              6 0
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TRNDDD            5 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TRDATE            6 0
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DUEDDD            5 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDATE            6 0
     C                   Z-ADD     AR$AMT        INVAMT            8 2
     C                   Z-ADD     AR$AMT        DUEAMT            8 2
     C                   MOVEL     'N'           PRTD              1
     C                   GOTO      NXTARO
     C                   END                                                    ARTTYP=01
      ** GET PAYMENT
     C     ARTTYP        IFEQ      02
     C     ARTTYP        OREQ      10
     C                   ADD       AR$AMT        DUEAMT
     C                   Z-SUB     AR$AMT        PAYAMT            8 2
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         PAYDDD            5 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         PDDATE            6 0
     C     PAYDDD        SUB       TRNDDD        #DAYS             5 0
     C                   ADD       #DAYS         INVDAY            7 0
     C                   ADD       1             INVPAY            5 0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C     PRTD          IFEQ      'N'
     C                   EXCEPT    DETL
     C                   MOVEL     'Y'           PRTD
     C                   ELSE
     C                   EXCEPT    DETLPY
     C                   END                                                    PRTD=N
     C                   GOTO      NXTARO
     C                   END                                                    ARTTYP=02 10
      ** IF HERE NOT PAY OR INV
     C                   ADD       AR$AMT        DUEAMT
     C                   GOTO      NXTARO
     C     ENDAR         TAG
     C     INVDAY        IFGT      0
     C     INVDAY        DIV(H)    INVPAY        INVAVG            6 1
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    TOTL
     C                   END
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCUST         CHAIN     FMCUST                             LR
     C                   SETON                                        OF
      *
     C                   ENDSR
      *
      ******************
      * OUTPUT SPECS   *
      ******************
     OARRDAY    E            HEAD           2 03
     O                                           10 'Customer:'
     O                       CMCUST        4     17
     O                       CMNAME              48
     O                                           67 'Days to Pay Report'
     O          E            HEAD           1
     O                                            6 'ARRDAY'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           35 'Invoices Dated:'
     O                       BDATE               44 '  /  /  '
     O                                           54 '- Thru -'
     O                       EDATE               64 '  /  /  '
     O                                           76 'Time:'
     O                       TIMOD               85 '  :  :  '
     O          E            HEAD           0
     O                                            6 'Inv #'
     O                                           17 'Trn Date'
     O                                           28 'Due Date'
     O                                           39 'Pay Date'
     O                                           50 '# Days'
     O                                           61 'Inv Amnt'
     O                                           73 'Pay Amt'
     O                                           84 'Due Amt'
     O          E            HEAD           1
     O                                           20 ' ___________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           85 '____ '
     O          EF           DETL           1
     O                       INV#          4      6
     O                       TRDATE              17 '  /  /  '
     O                       DUDATE              28 '  /  /  '
     O                       PDDATE              39 '  /  /  '
     O                       #DAYS         2     50
     O                       INVAMT        2     61
     O                       PAYAMT        2     73
     O                       DUEAMT        2     84
     O          EF           DETLPY         1
     O                       PDDATE              39 '  /  /  '
     O                       #DAYS         2     50
     O                       PAYAMT        2     73
     O                       DUEAMT        2     84
     O          E            TOTL        1  1
     O                                           24 'Total Number of Days to'
     O                                           29 'Pay:'
     O                       INVDAY        4     38
     O          E            TOTL           1
     O                                           20 'Number of Payments:'
     O                       INVPAY        4     38
     O          E            TOTL           1
     O                                           21 'Average Days to Pay:'
     O                       INVAVG        4     38
