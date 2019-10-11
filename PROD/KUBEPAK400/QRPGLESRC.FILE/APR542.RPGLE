      *--------------------------------------------------------------     APR540
      *                                                                   APR540
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997                          APR540
      *                                                                   APR540
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         APR540
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         APR540
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      APR540
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         APR540
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      APR540
      *       BY EXPRESS WRITTEN PERMISSION OF                            APR540
      *            EFD ENTERPRISES, INC.     215-643-5352                 APR540
      *                                                                   APR540
      *--------------------------------------------------------------     APR540
      *PROGRAM NAME-         APR540                                       APR540
      *SYSTEM-               ACCOUNTS PAYABLE                             APR540
      *DESCRIPTION-          VENDOR ANALYSIS REPORT ALPHA                 APR540
      *
      *
      *
      *
     FFMVENDAL  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR540    O    F  120        PRINTER OFLIND(*INOF)                        APR540
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
     D                UDS                                                       APC540
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
     C     NXT           TAG                                                                   APR54
     C                   READ      FMVENDAL                               90
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
     C     VMYDAV        SUB       VMYDIT        CDSLST            7 2  20      DISC.LOST THIS APR54
     C     VMLYDV        SUB       VMLYDT        LDSLST            7 2  21      DISC.LOST LAST APR54
     C     VMLYDV        ADD       VMYDAV        VDAV              7 2                      ST APR54
     C     CDSLST        ADD       LDSLST        VLST              7 2                      ST APR54
     C                   ADD       VMYPUR        TVYPUR           11 2          TOT YTD THIS   APR54
     C                   ADD       VMLYPU        TVLYPU           11 2          TOT YTD LAST   APR54
     C                   ADD       VMPAID        TVYPD            11 2          TOT YTD THIS   APR54
     C                   ADD       VMLYPD        TVLYPD           11 2          TOT YTD LAST   APR54
     C                   ADD       VMYDIT        TVYDIT            7 2          TOT DIS TAK THSAPR54
     C                   ADD       VMLYDT        TVLYDT            7 2          TOT DIS TAK LSTAPR54
     C  N20              ADD       CDSLST        TCDLST            7 2          TOT DIS LST THSAPR54
     C  N21              ADD       LDSLST        TLDLST            7 2          TOT DIS LST LSTAPR54
     C                   ADD       VDAV          TDAV              7 2                      ST APR54
     C                   ADD       VLST          TLST              7 2                      ST APR54
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETAIL
     C                   GOTO      NXT
      *
     C     END           TAG                                                                   APR54
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *                                                                   APR540
     OAPR540    E            HDG            1 03                                APR540
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
     O                                           69 'A/P Vendor Analysis'       APR540
     O                       TIMOD              120 '  :  :  '                  APR540
     O          E            HDG            2
     O                                           21 'Vendor Alpha Sequence'
     O               65                          65 'All Vendors'               APR540
     O               60                          72 'Vendors With No Activity'
     O               70                          70 'Vendors With Activity'
     O               55                         118 'Includes Vendor Type -'
     O               55      LTYPE              120
     O          E            HDG            1
     O                                           44 'Date'                      APR540
     O                                           71 '------Purchases------'     APR540
     O                                           95 '------Payments------'      APR540
     O                                          111 '--Discounts--'             APR540
     O                                          118 'Date'                      APR540
     O          E            HDG            1
     O                                            6 'Vendor'                    APR540
     O                                           44 'Last'                      APR540
     O                                           58 'This'                      APR540
     O                                           70 'Last'                      APR540
     O                                           82 'This'                      APR540
     O                                           95 'Last'                      APR540
     O                                          103 'Total'                     APR540
     O                                          111 'Total'                     APR540
     O                                          118 'Last'                      APR540
     O          E            HDG            0
     O                                            6 'Number'                    APR540
     O                                           22 'Vendor Name'               APR540
     O                                           46 'Purchase'                  APR540
     O                                           58 'Year'                      APR540
     O                                           70 'Year'                      APR540
     O                                           82 'Year'                      APR540
     O                                           95 'Year'                      APR540
     O                                          103 'Taken'                     APR540
     O                                          111 'Lost'                      APR540
     O*                                 107 'Year'                        APR540
     O                                          120 'Payment'                   APR540
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETAIL         1                                   APR540
     O                       VMDTPY             120 '  /  / 0'                  APR540
     O              N20      VLST          2B   111                             APR540
     O                       VDAV          2B   103                             APR540
     O                       VMLYPD        K     96                             APR540
     O                       VMPAID        K     83                             APR540
     O                       VMLYPU        K     71                             APR540
     O                       VMYPUR        K     59                             APR540
     O                       VMDTLP              46 '  /  / 0'                  APR540
     O                       VMNAME              37                             APR540
     O                       VMVEND        Z      6                             APR540
     O          E            TLR         1  1                                   APR540
     O                                           58 '----------'                APR540
     O                                           70 '----------'                APR540
     O                                           82 '----------'                APR540
     O                                           95 '----------'                APR540
     O                                          103 '-------'                   APR540
     O                                          111 '-------'                   APR540
     O          E            TLR            1                                   APR540
     O                                           39 'Report Totals:'            APR540
     O                       TVYPUR        K     59                             APR540
     O                       TVYPD         K     83                             APR540
     O                       TDAV          2B   103                             APR540
     O          E            TLR            1                                   APR540
     O                       TVLYPU        K     71                             APR540
     O                       TVLYPD        K     96                             APR540
     O                       TLST          2B   111                             APR540
