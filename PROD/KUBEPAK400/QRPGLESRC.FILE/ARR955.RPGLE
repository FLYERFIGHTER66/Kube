      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- ARR955
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- DELETE HISTORY RECORDS / SELECTED CUSTOMER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARHIST   UF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FARR950    O    F  120        PRINTER OFLIND(*INOF)
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
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LCUST                  9     14  0
     D  LPRINT                15     15
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
     C                   UNLOCK    FARHIST
      *
     C     LPRINT        IFEQ      'Y'
     C                   SETON                                        77
     C                   ENDIF
      *
WJB01C                   Z-ADD     LDATE         ##MDY             6 0
WJB01C                   CALL      '@DT@A1'
WJB01C                   PARM                    ##MDY             6 0          DATE MDY
WJB01C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
WJB01C                   PARM                    ##ERR             1            ERROR IF = Y
WJB01C                   Z-ADD     ##CYMD        RDATE             7 0
      *
     C     LCO           CHAIN     FMCORG                             88
     C   77              EXCEPT    HDG
      *
     C     LCUST         SETLL     FARHIST
     C     NXT           TAG
     C     LCUST         READE     FARHIST                                90
     C   90              GOTO      END
      *
WJB01C     AHTDAT        IFLE      RDATE
WJB01C     AHTDAT        ANDNE     *ZERO
      *
     C   77              EXSR      REPORT
     C                   DELETE    RARHIS
      *
WJB01C                   ENDIF
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     CNT           IFEQ      0
     C   77              EXCEPT    TNO
     C                   ENDIF
     C                   SETON                                        LR
      *
      *********
      * REPORT
      *********
     C     REPORT        BEGSR
     C                   Z-ADD     AHTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C                   Z-ADD     AHDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DDAT              6 0
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C     AHCUST        CHAIN     FMCUST                             94
     C                   EXCEPT    DETL
     C                   ADD       1             CNT               6 0
      *
     C                   ENDSR
      *
     OARR950    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           59 'Deleted A/R History Reco'
     O                                           78 'rds - For Customer:'
     O                       LCUST         Z     85
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            6 'Cust.'
     O                                           50 'Reference'
     O                                           59 'Trans'
     O                                           67 'Due'
     O                                           96 'Check'
     O          E            HDG            1
     O                                            7 'Number'
     O                                           20 'N  A  M  E'
     O                                           48 'Number'
     O                                           58 'Date'
     O                                           68 'Date'
     O                                           86 'Invoice Amount'
     O                                           97 'Number'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          100 '____'
     O          E            DETL           1
     O                       AHCUST        Z      7
     O              N94      CMNAME              39
     O               94                          33 '*** Customer Not On File'
     O                       AHINV#        Z     47
     O                                           48 '-'
     O                       AHSUFF              50
     O                       TDAT          Y     60
     O                       DDAT          Y     70
     O                       AH$AMT        J     87
     O                       AHCHEK              99
     O          E            TNO            1
     O                                           72 '*** No Items Purged ***'
     O          E            TNO            1
     O                                           72 'No A/R History Records'
     O          E            TNO            1
     O                                           72 ' For Selected Customer'
