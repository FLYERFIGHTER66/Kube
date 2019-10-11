      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.       1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *****************************************************************
      *PROGRAM NAME--------- APR280
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *DESCRIPTION---------- MANUAL PAY OF OPEN PAYABLE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FAPR280FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFAPOPN    UF   E           K DISK
     FFAPREC    UF A E           K DISK
     FFMVEND    UF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FFAPDTP    O  A E             DISK
     FFAPMTH    O  A E             DISK
     FAPR280    O    F  132        PRINTER OFLIND(*INOF)
      *
     D MSG             S             30    DIM(3) CTDATA PERRCD(1)
      *
      ** MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
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
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      DNE(1)
     I              ACEN02                      DNE(2)
     I              ACEN03                      DNE(3)
     I              ACEN04                      DNE(4)
     I              ACEN05                      DNE(5)
     I              ACEN06                      DNE(6)
     I              ACEN07                      DNE(7)
     I              ACEN08                      DNE(8)
     I              ACEN09                      DNE(9)
     I              ACEN10                      DNE(10)
     I              ACEN11                      DNE(11)
     I              ACEN12                      DNE(12)
     I              ACEN13                      DNE(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
      * 88 = COMPANY RUNS G/L
      *
     C     LCO           CHAIN     FAPCTL                             90
     C     AZGL          IFEQ      'N'
     C                   SETON                                        88
     C                   ENDIF
      *
      * COMPANY DOES NOT RECONCILE CHECKS
      *
     C     AZREC         IFEQ      'Y'
     C                   SETON                                        87
     C                   ENDIF
      *
     C                   Z-ADD     0             CNT               6 0
      *
     C     LCO           CHAIN     FMCORG                             90
      *
      * PROGRAM MAINLINE
      *
     C     RSTRT         TAG
     C                   Z-ADD     *ZEROS        VVEND
     C                   MOVEL     *BLANKS       VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     0             VCHECK
     C                   Z-ADD     0             VCKDTE
     C                   Z-ADD     0             VAMT
     C                   Z-ADD     0             CKNET
     C                   Z-ADD     0             CKTOT
     C                   Z-ADD     0             GROSS
     C                   Z-ADD     0             DSTOT
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101220
     C                   SETOFF                                       212225
     C                   SETOFF                                       262730
     C                   SETOFF                                       313215
     C                   SETOFF                                       404142
     C                   SETOFF                                       891617
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFEQ      *ZEROS
     C                   SETON                                        1017
     C   17              GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1017
     C   17              GOTO      NXTA
      *
     C     VCHECK        IFEQ      *ZEROS
     C                   SETON                                        2021
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     RECKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VCHECK
     C     RECKEY        CHAIN     FAPREC                             90
     C  N90              SETON                                        2022
     C   22              GOTO      NXTA
      *
      * VALIDATE CHECK DATE
      *
     C                   Z-ADD     VCKDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2527
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         CDATE             5 0
      *
      * VALIDATE CHECK DATE TO ACCOUNTING PERIOD DATES IF G/L RUN
      *
     C   88              GOTO      NOGL
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     VCKDTE        TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        #P                2 0
      *
     C     ERR           IFEQ      1
     C     #P            OREQ      0
     C                   SETON                                        3231
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     ACFSST        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ADATE             5 0
      *
      * CANNOT ENTER DATE PRIOR TO START OF FISCAL YEAR
      *
     C     ADATE         IFGT      CDATE
     C                   SETON                                        2526
     C   26              GOTO      NXTA
     C                   ENDIF
      *
     C     #P            IFEQ      99
     C                   SETON                                        89
     C                   GOTO      NOGL
     C                   ENDIF
      *
     C                   Z-ADD     #P            X                 2 0
     C                   Z-ADD     BEG(X)        BDATE             6 0
     C                   Z-ADD     DNE(X)        EDATE             6 0
      *
     C     NOGL          TAG
      *
     C     VAMT          IFEQ      0
     C                   SETON                                        30
     C   30              GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VVEND         VENDOR            6 0
     C                   Z-ADD     VCHECK        CHECK             6 0
     C                   ADD       1             CNT
      *
     C                   EXSR      BLDSFL
      *
      * NO OPEN AP FOR VENDOR
      *
     C   16              GOTO      NXTA
      *
     C     NXTSFL        TAG
     C                   Z-ADD     0             CKTOT
     C                   EXFMT     RECCTL
     C   KF              GOTO      RSTRT
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   EXCEPT    TCHECK
     C                   WRITE     RAPREC
EFD  C                   Z-ADD     0             AMT
EFD  C                   Z-ADD     0             DISC
EFD  C                   Z-ADD     0             PAY
EFD01C                   Z-ADD     0             AK$AMT
EFD01C                   Z-ADD     0             AKDTAK
EFD01C                   Z-ADD     0             AK$NET
     C                   GOTO      RSTRT
     C                   ENDDO
     C  NKA              GOTO      NXTSFL
      *
     C     ENDP          TAG
     C     TPAY          SUB       TDISC         TAMT             11 2
     C     TPAY          IFNE      0
     C                   EXCEPT    TLR
     C                   ENDIF
     C                   SETON                                        LR
      ***********
      * BLDSFL
      ***********
     C     BLDSFL        BEGSR
     C                   SETOFF                                       1030
     C     VVEND         SETLL     FAPOPN
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVEL     'N'           CODE
     C     NXTBLD        TAG
     C                   SETOFF                                       90
     C     VVEND         READE     FAPOPN                                 90
     C   90RECNO         IFEQ      0
     C                   SETON                                        1610
     C                   ENDIF
     C   90              GOTO      ENDBLD
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     APCLCD        IFEQ      'Y'
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     APDUE$        IFEQ      0
     C                   GOTO      NXTBLD
     C                   ENDIF
     C                   Z-ADD     APDUE$        PAY
     C     APDCDT        IFGT      0
     C                   Z-ADD     APDCDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DSDATE            5 0
     C                   ENDIF
     C     DSDATE        IFGE      RDATE
     C                   Z-ADD     APDAVL        DISC
     C                   ELSE
     C                   Z-ADD     0             DISC
     C                   ENDIF
     C                   Z-ADD     APVOUC        VOUCH
     C                   MOVEL     APINV#        INV#
     C                   MOVEL     APITYP        ITYP
     C                   Z-ADD     APDUDT        IDATE
     C                   Z-ADD     APDCDT        DDATE
     C                   ADD       1             RECNO
     C     RECNO         IFGT      100
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********
      * CHKSFL
      ***********
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       103099
     C                   SETOFF                                       40
     C     NXTCHK        TAG
     C                   SETOFF                                       103031
     C                   SETOFF                                       3240
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
      *
     C     CODE          IFEQ      *BLANKS
     C     PAY           ANDEQ     0
     C     DISC          ANDEQ     0
     C                   MOVE      *BLANKS       INV#
     C                   MOVE      *BLANKS       ITYP
     C                   Z-ADD     0             VOUCH
     C                   Z-ADD     0             IDATE
     C                   Z-ADD     0             DDATE
     C                   GOTO      NXTCHK
     C                   ENDIF
      *
     C     CODE          IFNE      'Y'
     C     CODE          ANDNE     'N'
     C                   SETON                                        303199
     C                   ENDIF
      *
     C     PAY           IFEQ      0
     C                   SETON                                        1099
     C                   ENDIF
      *
     C     CODE          IFEQ      'Y'
     C     PAY           SUB       DISC          CKNET            11 2
     C                   ADD       CKNET         CKTOT            11 2
     C                   ADD       PAY           GROSS            11 2
     C                   ADD       DISC          DSTOT             7 2
     C                   ENDIF
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     CKTOT         IFNE      VAMT
     C                   SETON                                        4099
     C                   ENDIF
     C                   ENDSR
      ***********
      * PUTSFL
      ***********
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     CNT           IFEQ      1
     C                   EXCEPT    HDG
     C                   ENDIF
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
      *
     C     CODE          IFEQ      'N'
     C                   GOTO      NXTPUT
     C                   ENDIF
      *
     C                   Z-ADD     0             SEQ#              3 0
     C     APKEY         KLIST
     C                   KFLD                    VENDOR
     C                   KFLD                    LCO
     C                   KFLD                    VOUCH
     C                   KFLD                    INV#
     C                   KFLD                    SEQ#
     C                   KFLD                    ITYP
     C     APKEY         CHAIN     FAPOPN                             92
     C                   ADD       PAY           APPAID
     C     AP$AMT        SUB       APPAID        APDUE$
     C     APDUE$        IFEQ      0
     C                   MOVEL     'Y'           APCLCD
     C                   MOVEL     'D'           APSTAT
     C                   ENDIF
     C                   Z-ADD     VCHECK        APCHEK
     C                   Z-ADD     VCKDTE        APCKDT
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     USERID        APUSER
     C                   UPDATE    RAPOPN
      *
      * APDTP FILE
      *
     C                   MOVEL     'A'           ATSTAT
     C                   Z-ADD     APVEND        ATVEND
     C                   Z-ADD     APCOMP        ATCOMP
     C                   Z-ADD     APVOUC        ATVOUC
     C                   MOVEL     APINV#        ATINV#
     C                   MOVEL     'M'           ATITYP
     C                   Z-ADD     DISC          ATDTAK
     C                   Z-ADD     CHECK         ATCHEK
     C                   Z-ADD     VCKDTE        ATCKDT
     C                   Z-ADD     PAY           ATPAID
     C                   MOVEL     APTDES        ATDESC
     C                   MOVEL     APLOOK        ATLOOK
     C     ATCKDT        MULT      10000.01      ATRVDT            6 0
     C                   MOVEL     ATRVDT        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     0             CENT              1 0
     C                   ELSE
     C                   MOVEL     1             CENT
     C                   ENDIF
     C                   MOVEL     CENT          ATCYMD
     C                   MOVE      ATRVDT        ATCYMD
     C                   WRITE     RAPDTP
      *
      * APMTH FILE
      *
     C                   MOVEL     'A'           AMSTAT
     C                   Z-ADD     APCOMP        AMCOMP
     C                   Z-ADD     CHECK         AMCHEK
     C                   Z-ADD     VCKDTE        AMCKDT
     C                   Z-ADD     APVEND        AMVEND
     C     PAY           ADD       DISC          AM$AMT
     C                   Z-ADD     DISC          AMDTAK
     C                   Z-ADD     PAY           AM$NET
     C                   Z-ADD     VCKDTE        AMTDAT
     C                   MOVEL     MSG(1)        AMTDES
     C                   Z-ADD     EDATE         AMPEDT
     C                   Z-ADD     TDATE         AMDTLA
     C                   Z-ADD     TIMOD         AMTIME
     C                   MOVEL     USERID        AMUSER
     C                   MOVEL     'M'           AMCTYP
     C                   WRITE     RAPMTH
      *
     C   87              EXSR      UAPREC
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETAIL
     C                   ADD       PAY           TPAY             11 2
     C                   ADD       DISC          TDISC             9 2
     C                   GOTO      NXTPUT
      *
     C     ENDPUT        TAG
      *
      * MVEND FILE
      *
     C     VENDOR        CHAIN     FMVEND                             92
     C                   Z-ADD     VCKDTE        VMDTPY
     C                   ADD       VAMT          VMPAID
     C                   ADD       DSTOT         VMYDIT
     C                   Z-ADD     TDATE         VMDTLA
     C                   Z-ADD     TIMOD         VMTIME
     C                   MOVEL     USERID        VMUSER
     C                   UPDATE    RMVEND
     C                   ENDSR
      **********
      * UAPREC *
      **********
     C     UAPREC        BEGSR
      *
      * APREC FILE - DO NOT WRITE IF 'N' RECON CHECKS
      *
     C                   MOVEL     'A'           AKSTAT
     C                   Z-ADD     APCOMP        AKCOMP
     C                   Z-ADD     CHECK         AKCHEK
     C                   Z-ADD     VCKDTE        AKCKDT
     C                   Z-ADD     APVEND        AKVEND
     C     PAY           ADD       DISC          AMT              11 2
     C                   ADD       AMT           AK$AMT
     C                   ADD       DISC          AKDTAK
     C                   ADD       PAY           AK$NET
     C                   Z-ADD     VCKDTE        AKTDAT
     C                   MOVEL     APTDES        AKTDES
     C                   Z-ADD     EDATE         AKPEDT
     C                   Z-ADD     TDATE         AKDTLA
     C                   Z-ADD     TIMOD         AKTIME
     C                   MOVEL     USERID        AKUSER
     C                   MOVEL     'M'           AKCTYP
      *
     C                   ENDSR
      *
     OAPR280    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              77
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           61 'Manual Pay of Open'
     O                                           78 'Payables Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            6 'Check'
     O                                           80 'Amount'
     O                                           91 'Disc'
     O                                          106 'Check'
     O                                          120 'Check'
     O          E            HDG            1
     O                                            4 '#'
     O                                           13 'Vendor'
     O                                           51 'Voucher'
     O                                           62 'Invoice'
     O                                           68 'Type'
     O                                           80 'Paid'
     O                                           92 'Taken'
     O                                          105 'Date'
     O                                          120 'Amount'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETAIL      1  0
     O                       CHECK         Z      6
     O                       VENDOR        Z     13
     O                       VMNAME              44
     O                       VOUCH         Z     51
     O                       INV#                62
     O                       ITYP                66
     O                       PAY           M     81
     O                       DISC          M     92
     O                       VCKDTE        Y    107
     O          E            TCHECK      0  0
     O                       VAMT          M    120
     O          E            TLR         1
     O                                          120 '----------'
     O                                           92 '--------'
     O                                           81 '----------'
     O          E            TLR         1
     O                                           65 'Report Totals ==>'
     O                       TAMT          M    120
     O                       TDISC         M     92
     O                       TPAY          M     81
**
A/P Manual Pay/Open Payable                                                    3
