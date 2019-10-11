      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-         APR540
      *SYSTEM-               ACCOUNTS PAYABLE
      *DESCRIPTION-          VENDOR ANALYSIS REPORT NUMBER SEQ
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR540    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LSEQ                  18     18  0
     D  LINCL                 26     26  0
     D  LTYPE                 27     27
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
     C     LCO           CHAIN     FMCORG                             97
      *
     C     LINCL         IFEQ      1
     C                   SETON                                        65
     C                   ENDIF
     C     LINCL         IFEQ      2
     C                   SETON                                        70
     C                   ENDIF
     C     LINCL         IFEQ      3
     C                   SETON                                        60
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     LTYPE         IFGT      *BLANKS
     C                   SETON                                        55
     C                   ENDIF
      *
     C     NXT           TAG
     C                   READ      FMVEND                                 90
     C   90              GOTO      END
      *
     C     VMCONM        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LTYPE         IFGT      *BLANKS
     C     VMTYPE        ANDNE     LTYPE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   70VMYPUR        IFEQ      *ZEROS
     C     VMLYPU        ANDEQ     *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60VMYPUR        IFGT      *ZEROS
     C     VMYPUR        ORLT      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
     C   60VMLYPU        IFGT      *ZEROS
     C     VMLYPU        ORLT      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VMYDAV        SUB       VMYDIT        CDSLST            7 2  20      DISC.LOST THIS
     C     VMLYDV        SUB       VMLYDT        LDSLST            7 2  21      DISC.LOST LAST
     C     VMLYDV        ADD       VMYDAV        VDAV              7 2                      ST
     C     CDSLST        ADD       LDSLST        VLST              7 2                      ST
     C                   ADD       VMYPUR        TVYPUR           11 2          TOT YTD THIS
     C                   ADD       VMLYPU        TVLYPU           11 2          TOT YTD LAST
     C                   ADD       VMPAID        TVYPD            11 2          TOT YTD THIS
     C                   ADD       VMLYPD        TVLYPD           11 2          TOT YTD LAST
     C                   ADD       VMYDIT        TVYDIT            7 2          TOT DIS TAK THS
     C                   ADD       VMLYDT        TVLYDT            7 2          TOT DIS TAK LST
     C  N20              ADD       CDSLST        TCDLST            7 2          TOT DIS LST THS
     C  N21              ADD       LDSLST        TLDLST            7 2          TOT DIS LST LST
     C                   ADD       VDAV          TDAV              7 2                      ST
     C                   ADD       VLST          TLST              7 2                      ST
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETAIL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OAPR540    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           90 'Company:'
     O                       LCO                 93
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           69 'A/P Vendor Analysis'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           22 'Vendor Number Sequence'
     O               65                          66 'All Vendors'
     O               60                          72 'Vendors With No Activity'
     O               70                          70 'Vendors With Activity'
     O               55                         118 'Includes Vendor Type -'
     O               55      LTYPE              120
     O          E            HDG            1
     O                                           71 '------Purchases------'
     O                                           95 '------Payments------'
     O                                          111 '--Discounts--'
     O*                                 108 'Discounts Lost'
     O          E            HDG            1
     O                                            6 'Vendor'
     O                                           44 'Last'
     O                                           58 'This'
     O                                           70 'Last'
     O                                           82 'This'
     O                                           95 'Last'
     O                                          103 'Total'
     O                                          111 'Total'
     O                                          118 'Last'
     O          E            HDG            0
     O                                            6 'Number'
     O                                           22 'Vendor Name'
     O                                           46 'Purchase'
     O                                           58 'Year'
     O                                           70 'Year'
     O                                           82 'Year'
     O                                           95 'Year'
     O                                          103 'Taken'
     O                                          111 'Lost'
     O                                          120 'Payment'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETAIL         1
     O                       VMDTPY             120 '  /  / 0'
     O                    N20VLST          2B   111
     O                       VDAV          2B   103
     O                       VMLYPD        K     96
     O                       VMPAID        K     83
     O                       VMLYPU        K     71
     O                       VMYPUR        K     59
     O                       VMDTLP              46 '  /  / 0'
     O                       VMNAME              37
     O                       VMVEND        Z      6
     O          E            TLR         1  1
     O                                           58 '----------'
     O                                           70 '----------'
     O                                           83 '----------'
     O                                           95 '----------'
     O                                          103 '-------'
     O                                          111 '-------'
     O          E            TLR            1
     O                                           39 'Report Totals:'
     O                       TVYPUR        K     59
     O                       TVYPD         K     83
     O                       TDAV          2B   103
     O          E            TLR            1
     O                       TVLYPU        K     71
     O                       TVLYPD        K     96
     O                       TLST          2B   111
