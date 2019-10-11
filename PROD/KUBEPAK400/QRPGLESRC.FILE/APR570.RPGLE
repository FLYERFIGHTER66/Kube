      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
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
      *PROGRAM NAME--------- APR570
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *DESCRIPTION---------- USE TAX REPORT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFUSETAX   IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR570    O    F  120        PRINTER OFLIND(*INOF)
      *
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
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
     D  LBDATE                 6     11  0
     D  LEDATE                12     17  0
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
     C                   Z-ADD     LBDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BDATE             7 0
     C                   Z-ADD     LEDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        EDATE             7 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             FIRST             6 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       88
     C                   READ      FUSETAX                                90
     C   90              GOTO      END
      *
     C     UXCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     UXDATE        IFLT      BDATE
     C     UXDATE        ORGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     UXDATE        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         RDATE             6 0
      *
     C     UXVEND        CHAIN     FMVEND                             96
      *
     C                   ADD       UXTAX$        TOTTAX            8 2                      MP
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C     UXTAX$        IFNE      0
     C                   EXCEPT    DETL
     C                   SETON                                        77
     C                   ENDIF
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                          LR
      *
     OAPR570    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           59 'Use Tax For Period'
     O                       LBDATE        Y     68
     O                                           70 '-'
     O                       LEDATE        Y     79
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            6 'Vendor'
     O                                           15 'Name'
     O                                           44 'Vouch'
     O                                           55 'Invoice'
     O                                           62 'Date'
     O                                           80 'Description'
     O                                          106 'Inv Amt'
     O                                          119 'Use Tax'
     O          E            HDG            2
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            DETL           1
     O                       UXVEND        Z      6
     O                       VMNAME              37
     O                       UXVOUC        Z     44
     O                       UXINV#              55
     O                       RDATE         Y     64
     O                       UXTDES              95
     O                       UX$AMT        4    107
     O                       UXTAX$        4    120
     O          E            TLR         2
     O                                          107 'Total Use Tax ==>'
     O                       TOTTAX        4    120
     O          E            TLRN        2
     O                                           50 'There Are No Records Ava'
     O                                           74 'ilable For This Accounti'
     O                                           83 'ng Period'
      *
