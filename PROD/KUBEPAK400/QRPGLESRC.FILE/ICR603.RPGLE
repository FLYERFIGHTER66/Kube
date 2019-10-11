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
      *PROGRAM NAME-------- ICR602
      *SYSTEM-------------- INVENTORY CONTROL
      *DESCRIPTION--------- PHYSICAL INVENTORY TRANSACTION REGISTER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFTINVTIS  IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FICR602    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LSEQ                   3      3  0
     D  LDATE                  4      9  0
     D  LUSER                 10     19
     D  LLOC                  21     23
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
     C     LSEQ          IFEQ      1
     C                   SETON                                        01
     C                   ENDIF
     C     LSEQ          IFEQ      2
     C                   SETON                                        02
     C                   ENDIF
      *
     C     LLOC          IFGT      *BLANKS
     C                   SETON                                        09
     C                   ENDIF
      *
     C                   Z-ADD     1             CNT
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C                   MOVEL     *BLANKS       ITITEM
     C     ITITEM        SETLL     FTINVTIS
     C     NXT           TAG
     C                   SETOFF                                       212324
     C                   SETOFF                                       252728
     C                   SETOFF                                       808182
     C                   SETOFF                                       83
     C                   READ      FTINVTIS                               90
     C   90              GOTO      ENDP
      *
     C     ITSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ITTYPE        IFNE      'P'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ITTDAT        IFNE      LDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LUSER         IFGT      *BLANKS
     C     ITUSER        ANDNE     LUSER
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LLOC          IFGT      *BLANKS
     C     ITTWSE        ANDNE     LLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ITTWSE        CHAIN     FMWHSE                             22
      *
      * SETUP FOR OUTPUT
      *
     C     KEY18         KLIST
     C                   KFLD                    ITITEM
     C                   KFLD                    ITSIZE
     C                   KFLD                    ITTWSE
     C     KEY18         CHAIN     FMINVT                             33
     C                   EXSR      GETDES
      *
      * ADD QUANTITY TO APPROPRIATE TRANSACTION TYPE ITEM TOTAL
      *
     C                   ADD       ITTQTY        RTOT             11 1          RECEIPTS
      *
     C                   Z-ADD     ITTQTY        QTY               7 1
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL1
     C                   SETON                                        77
      *
     C                   ADD       1             CNT               4 0
      *
      * ADD ITEM TOTALS TO LOCATION TOTALS
      *
     C                   ADD       RTOT          WRTOT            11 1
      *
     C                   GOTO      NXT
      *
      * ADD LOCATION TOTALS TO COMPANY TOTALS
      *
     C                   ADD       WRTOT         FRTOT            11 1
      *
     C     ENDP          TAG
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      *********
      * GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             28
     C                   ENDSR
      *
     OICR602    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          114 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           49 'Physical'
     O                                           71 'Inventory Transaction'
     O                                           80 'Register'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           12 'In Order By:'
     O                                           24 'Item Number'
     O                                           65 'Transactions Dated:'
     O                       LDATE         Y     74
     O          E            HDG            1
     O                                           64 'For Location:'
     O               09      LLOC                68
     O              N09                          68 'ALL'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           16 'Size'
     O                                           20 'Loc'
     O                                           33 'Description'
     O                                           55 'UM'
     O                                           64 'User'
     O                                           83 'Count'
     O                                          105 'Comment'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL1       1  1
     O                       ITTREF             120
     O                       QTY           MB    83
     O                       ITUSER              70
     O                       ITTUOM              55
     O                       DESP           B    50
     O                       ITTWSE         B    20
     O                       ITSIZE              16
     O                       ITITEM              12
     O          E            TLR            1
     O                                           70 '** Report Totals:'
     O                       RTOT          M     83
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
