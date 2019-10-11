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
      *PROGRAM NAME-------- ARR950
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- MARK A/R HISTORY RECORDS FOR DELETION
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAHSEL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFARHIST   UF   E           K DISK
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
     C     LPRINT        IFEQ      'Y'
     C                   SETON                                        77
     C                   ENDIF
      *
     C   77LCO           CHAIN     FMCORG                             88
     C   77              EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FAHSEL                                 90
     C   90              GOTO      END
      *
     C     ARKEY         KLIST
     C                   KFLD                    RHCUST
     C                   KFLD                    RHINV#
      *
     C     ARKEY         SETLL     FARHIST
     C     NXTAR         TAG
     C                   SETOFF                                       30
     C     ARKEY         READE     FARHIST                                91
     C   91              GOTO      NXT
      *
     C                   DELETE    RARHIS
      *
     C  N77              GOTO      NXTAR
      *
     C     AHCUST        CHAIN     FMCUST                             20
      *
     C     AHSUFF        IFGT      *BLANKS
     C                   SETON                                        30
     C                   ENDIF
      *
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
      *
     C                   EXCEPT    DETL
     C                   ADD       1             CNT               6 0
     C                   GOTO      NXTAR
      *
     C     END           TAG
     C   77CNT           IFEQ      0
     C                   EXCEPT    TNO
     C                   ENDIF
     C                   SETON                                        LR
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
     O                                           64 'A/R History Deletion Ref'
     O                                           78 'erence Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           65 'For Items Dated On Or Be'
     O                                           70 'fore:'
     O                       LDATE         Y     79
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
     O                       CMNAME              39
     O                       AHINV#        Z     47
     O               30                          48 '-'
     O                       AHSUFF              50
     O                       TDAT          Y     60
     O                       DDAT          Y     70
     O                       AH$AMT        J     87
     O                       AHCHEK              99
     O          E            TNO            1
     O                                           72 '*** No Items Deleted ***'
