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
      *PROGRAM NAME-------- PRGAPDTP
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- PURGE RECORDS FROM APDTP FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPDTP    UF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR940    O    F  120        PRINTER OFLIND(*INOF)
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
     D  LDATE                  3      8  0
     D  LVEND                  9     14  0
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
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        PDATE             7 0
      *
     C     LPRINT        IFEQ      'Y'
     C                   SETON                                        50
     C                   ENDIF
      *
     C   50LCO           CHAIN     FMCORG                             97
      *
     C     LDATE         IFGT      0
     C                   SETON                                        60
     C                   ENDIF
     C     LVEND         IFGT      0
     C                   SETON                                        65
     C                   ENDIF
      *
     C   50              EXCEPT    HDG
      *
      ****************
      ** READ APDTP **
      ****************
     C     NXT           TAG
     C                   READ      FAPDTP                                 90
     C   90              GOTO      END
      *
     C     ATCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LVEND         IFGT      0
     C     ATVEND        ANDNE     LVEND
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LDATE         IFGT      0
     C     ATCYMD        ANDGT     PDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF
     CAN 50              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C   50ATVEND        CHAIN     FMVEND                             92
      *
     C   50FIRST         IFGT      1
     C     ATVEND        ANDNE     OLVEND
     C                   EXCEPT    TL1
     C                   ENDIF
      *
     C   50              EXCEPT    DETL
     C                   SETON                                        77
     C                   ADD       ATPAID        L1PAID           10 2
     C                   Z-ADD     ATVEND        OLVEND            6 0
     C                   ADD       1             FIRST             6 0
      *
      * DELETE FAPDTP RECORD
      *
     C                   DELETE    RAPDTP
     C                   GOTO      NXT
      *
     C     END           TAG
     C   50
     CAN 77              EXCEPT    TL1
     C  N77              EXCEPT    TLR
     C                   SETON                                        LR
      *
     OAPR940    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           63 'Records Purged From Vend'
     O                                           81 'or Payment History'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O               60                          66 'Records Dated On Or Befo'
     O               60                          69 're:'
     O               60      LDATE         Y     78
     O               65                          62 'For Vendor:'
     O               65      LVEND         Z     69
     O          E            HDG            0
     O                                            6 'Vend #'
     O                                           12 'Name'
     O                                           50 'Voucher'
     O                                           61 'Invoice'
     O                                           64 'TP'
     O                                           73 'Amount'
     O                                           83 'Discount'
     O                                           91 'Check#'
     O                                           99 'Date'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       ATCKDT        YB   100
     O                       ATCHEK        ZB    91
     O                       ATDTAK        MB    84
     O                       ATPAID        M     74
     O                       ATITYP              63
     O                       ATINV#              61
     O                       ATVOUC        Z     50
     O              N92      VMNAME              37
     O               92                          30 '* Vendor Not On File *'
     O                       ATVEND        Z      6
     O          E            TL1            1
     O                                           30 '* Vendor Totals *'
     O                       L1PAID        MB    74
     O          E            TLR            1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
