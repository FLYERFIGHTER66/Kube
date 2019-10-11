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
      **PROGRAM NAME-------- ICR710
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- CONTROL MONTH END PROCESS IN INVENTORY
      **DESCRIPTION--------- SELECTS RECORDS TO BE PURGED FROM THE
      **                     TINVT FILE.  OPTIONALLY PRINTS A REPORT
      **                     OF FILE STATUS.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  1/01/98 EFD ADD LAST MONTH FILE LOGIC
wjb   *  1/30/07 WJB Modified date comparison to use CYMD field instead of MDY field.
      *
     FFTINVT    UF   E             DISK
     FFTINVTO   O  A E             DISK
     F                                     RENAME(RTINVT:OTINVT)
     FFMCORG    IF   E           K DISK
     FICR710    O    F  132        PRINTER OFLIND(*INOF)
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
      *
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
     D  LBU                   84     84
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
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
     C     LDAPPR        IFEQ      'Y'                                                      S
     C                   SETON                                        21
     C                   ENDIF
      *
     C                   Z-ADD     0             WKTOTR            9 0          TOTAL RECORDS
     C                   Z-ADD     0             WKTOTA            9 0          ACTIVE RECORDS
     C                   Z-ADD     0             WKTOTP            9 0          ALREADY MARKED
     C                   Z-ADD     0             WKTOTC            9 0          MARK THIS CYCLE
      *
      *  REVERSE DATES FOR COMPARISON TINVT FILE.
      *
     C                   Z-ADD     LDABEG        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        WRKBEG            7 0
     C                   Z-ADD     LDAEND        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        WRKEND            7 0
      *
     C     LCO           CHAIN     FMCORG                             75
      *
     C     NXT           TAG
     C                   SETOFF                                       30
     C                   READ      FTINVT                                 90
     C   90              GOTO      END
      *
     C     ITSTAT        IFEQ      'D'
     C                   ADD       1             WKTOTR
     C                   SETON                                        30
     C                   ELSE
     C                   EXSR      CNTAC
     C                   ENDIF
      *
     C   30              WRITE     OTINVT
     C     LPURGE        IFEQ      'Y'
     C   30              DELETE    RTINVT
     C   30              ADD       1             WKTOTC
     C                   END
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *  ***********
      *  * CNTAC   *
      *  ***********
      *  THIS SUBROUTINE PROCESSES ACTIVE RECORDS IN THE TINVT FILE
      *
     C     CNTAC         BEGSR
     C                   ADD       1             WKTOTR
     C                   EXSR      TSTPR
     C  N30              ADD       1             WKTOTA
     C                   ENDSR
      *  ***********
      *  * TSTPR   *
      *  ***********
      *  TEST FOR PURGE OPTIONS - TINVT FILE
      *
     C     TSTPR         BEGSR
     C     ITTCOM        COMP      LCO                                    30
     C   30
wjb  C*AN 21ITYDAT        COMP      WRKEND                               3030
wjb  CAN 21ITYDAT        COMP      WRKEND                               3030
     C   30
wjb  C*ANN21ITYDAT        COMP      WRKBEG                             30  30
wjb  CANN21ITYDAT        COMP      WRKBEG                             30  30
     C   30
wjb  C*ANN21ITYDAT        COMP      WRKEND                               3030
wjb  CANN21ITYDAT        COMP      WRKEND                               3030
     C   30ITGLUD        COMP      'Y'                                    30
      *
     C                   ENDSR
      *
     OICR710    E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                          120 'Page: 1'
     O          E            TLR            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           72 'Inventory Closing Report'
     O                                          110 'Time:'
     O                       TIMOD              120 '  :  :  '
     O          E            TLR              09
     O                                           69 'Closing Parameters'
     O          E            TLR            2 12
     O                                           57 'Company Selection'
     O                       LCO                 72
     O          E            TLR            2
     O                                           56 'Period Selection'
     O                       LDAPER              72
     O                       LDABEG        Y     88
     O                                           90 '-'
     O                       LDAEND        Y     99
     O          E            TLR            2
     O                                           61 'Process Prior Periods'
     O                       LDAPPR              71
     O          E            TLR            2
     O                                           56 'File Save Option'
     O                       LSAVE               71
     O          E            TLR            2
     O                                           57 'File Purge Option'
     O                       LPURGE              71
     O          E            TLR         1  2
     O                                           51 'File Status'
     O                                           93 'FTINVT'
     O          E            TLR            2
     O                                           63 'Total Number of Records'
     O                       WKTOTR        Z     90
     O          E            TLR            2
     O                                           52 'Open Records'
     O                       WKTOTA        Z     90
     O          E            TLR            2
     O                                           60 'Records Deleted This'
     O                                           77 ' Cycle           '
     O                       WKTOTC        Z     90
