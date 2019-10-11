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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR110
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- INVENTORY ITEM MASTER LISTING
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    IF   E           K DISK
     FFMINVTPC  IF   E           K DISK
     F                                     RENAME(RMINVT:MINVT)
     FFMWHSE    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FICR110    O    F  120        PRINTER OFLIND(*INOF)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LBITEM                 3     14
     D  LEITEM                15     26
     D  LBSIZE                27     29
     D  LESIZE                30     32
     D  LBLOC                 33     35
     D  LELOC                 36     38
     D  LBVEND                39     44  0
     D  LEVEND                45     50  0
     D  LPC1                  51     52
     D  LPC2                  53     54
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LBITEM        IFGT      *BLANKS                                       ITM RANGE
     C                   SETON                                        40
     C                   ENDIF
      *
     C     LBSIZE        IFGT      *BLANKS                                       SIZE RANGE
     C                   SETON                                        41
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS                                       LOC RANGE
     C                   SETON                                        42
     C                   ENDIF
      *
     C     LBVEND        IFGT      0                                             VEND RANGE
     C                   SETON                                        43
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS                                       PC RANGE
     C                   SETON                                        44
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
     C                   Z-ADD     1             X
      *
      * MOVE DOTS TO PRINT FIELDS
      *
     C                   MOVE      '.....'       DOTS              9
     C                   MOVEL     '....'        DOTS
     C                   MOVE      '......'      DOTS2            12
     C                   MOVEL     '......'      DOTS2
     C                   MOVE      *BLANKS       BLNKLN          120
      *
     C                   MOVEL     '99999999'    ITM9             15
     C                   MOVE      '9999999'     ITM9
      *
     C     LBITEM        IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LBSIZE        IFGT      *BLANKS
     C                   SETON                                        64
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS
     C                   SETON                                        61
     C                   ENDIF
      *
     C     LBVEND        IFGT      *ZEROS
     C                   SETON                                        62
     C                   ENDIF
      *
      * PRODUCT CLASS RANGE
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
      *
     C     NXT           TAG
     C  N63              READ      RMINVT                                 90
     C   63              READ      MINVT                                  90
     C   90              GOTO      END
      *
      * CHECK FOR VALID RECORD
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     IMCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60IMITEM        IFLT      LBITEM
     C     IMITEM        ORGT      LEITEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   61IMWHSE        IFLT      LBLOC
     C     IMWHSE        ORGT      LELOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   62IMVEND        IFLT      LBVEND
     C     IMVEND        ORGT      LEVEND
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   63IMPCL1        IFLT      LPC1
     C     IMPCL1        ORGT      LPC2
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   64IMSIZE        IFLT      LBSIZE
     C     IMSIZE        ORGT      LESIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHAIN FIRST TIME TO PRODUCT CLASS CONTROL FILE -
      *
     C     IMPCL1        CHAIN     FMPRCL                             22
     C     PCSTAT        IFEQ      'D'
     C                   SETON                                        22
     C                   ENDIF
     C  N22              MOVEL     PCDESC        PRCL1            28
      *
      * CHAIN SECOND TIME TO PRODUCT CLASS CONTROL FILE -
      *
     C     IMPCL2        IFEQ      *BLANKS                                                  =0
     C                   GOTO      PRC3
     C                   ENDIF
     C     IMPCL2        CHAIN     FMPRCL                             23
     C     PCSTAT        IFEQ      'D'
     C                   SETON                                        23
     C                   ENDIF
     C  N23              MOVEL     PCDESC        PRCL2            28
      *
      * CHAIN THIRD TIME TO PRODUCT CLASS CONTROL FILE -
      *
     C     PRC3          TAG
     C     IMPCL3        IFEQ      *BLANKS                                                  =B
     C                   GOTO      WHSE
     C                   ENDIF
     C     IMPCL2        CHAIN     FMPRCL                             25
     C     PCSTAT        IFEQ      'D'
     C                   SETON                                        25
     C                   ENDIF
     C  N25              MOVEL     PCDESC        PRCL3            28
      *
      * CHAIN TO LOCATION MASTER FOR LOCATION DESCRIPTION
      *
     C     WHSE          TAG
     C     IMWHSE        CHAIN     FMWHSE                             33
     C     WHSTAT        IFEQ      'D'
     C                   SETON                                        33
     C                   ENDIF
      *
      * CHAIN TO VENDOR MASTER ONLY IF VENDOR NUMBER PRESENT IN
      * INVENTORY ITEM MASTER RECORD
      *
     C     IMVEND        IFEQ      *ZEROS
     C                   GOTO      NOVEND
     C                   ENDIF
     C     IMVEND        CHAIN     FMVEND                             44
     C     VMSTAT        IFEQ      'D'
     C                   MOVEL     'Deleted'     VMNAME
     C                   ENDIF
      *
     C     NOVEND        TAG
     C     X             IFGT      3
     C                   EXCEPT    HDG
     C                   Z-ADD     1             X
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   ADD       1             X                 2 0
     C                   ADD       1             CTR               6 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      **
     OICR110    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           66 'Inventory Item Master'
     O                                           74 'Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           24 '- Selection Criteria-'
     O                                           36 'Item:'
     O              N40                          42 'ALL'
     O               40                          42 'From'
     O               40      LBITEM              55
     O               40                          62 'To'
     O               40      LEITEM              75
     O                                          103 'Location:'
     O              N42                         109 'ALL'
     O               42                         109 'From'
     O               42      LBLOC              113
     O               42                         116 'To'
     O               42      LELOC              120
     O          E            HDG            1
     O                                           36 'Size:'
     O              N41                          42 'ALL'
     O               41                          42 'From'
     O               41      LBSIZE              46
     O               41                          50 'To'
     O               41      LESIZE              54
     O                                           67 'Vendor:'
     O              N43                          72 'ALL'
     O               43                          72 'From'
     O               43      LBVEND        Z     79
     O               43                          82 'To'
     O               43      LEVEND        Z     89
     O                                          103 'Prod Class:'
     O              N44                         109 'ALL'
     O               44                         109 'From'
     O               44      LPC1               112
     O               44                         116 'To'
     O               44      LPC2               120
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG            1
     O                                           30 'Item Information'
     O                                           57 'Price U/M 1'
     O                                           76 'Price U/M 2'
     O                                           91 'Price U/M 3'
     O                                          108 'Qty Levels'
     O                                          120 'Disc Pct'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       DOTS                10
     O                                            5 'Item'
     O                       IMITEM              23
     O                       IMSIZE              27
     O                                           45 '1:'
     O                       IMSEL1        1     57
     O                       IMBCS1        1     76
     O                       IM3CS1        1     91
     O                       IMQLB1        1    108
     O                       IMDIS1        1    120
     O          E            DETL           1
     O                       DOTS                10
     O                                            7 'Desc 1'
     O                       IMDES1              41
     O                                           45 '2:'
     O                       IMSEL2        1     57
     O                       IMBCS2        1     76
     O                       IM3CS2        1     91
     O                       IMQLB2        1    108
     O                       IMDIS2        1    120
     O          E            DETL           1
     O                       DOTS                10
     O                                            7 'Desc 2'
     O                       IMDES2              41
     O                                           45 '3:'
     O                       IMSEL3        1     57
     O                       IMBCS3        1     76
     O                       IM3CS3        1     91
     O                       IMQLB3        1    108
     O                       IMDIS3        1    120
     O          E            DETL           1
     O                       DOTS                10
     O                                            7 'Desc 3'
     O                       IMDES3              41
     O                                           45 '4:'
     O                       IMSEL4        1     57
     O                       IMBCS4        1     76
     O                       IM3CS4        1     91
     O                       IMQLB4        1    108
     O                       IMDIS4        1    120
     O          E            DETL           1
     O                       DOTS                10
     O                                            7 'Desc 4'
     O                       IMDES4              41
     O                                           45 '5:'
     O                       IMSEL5        1     57
     O                       IMBCS5        1     76
     O                       IM3CS5        1     91
     O                       IMQLB5        1    108
     O                       IMDIS5        1    120
     O          E            DETL           1
     O                       DOTS                10
     O                                            9 'Alpha Sr'
     O                       IMLOOK              26
     O                       IMUCST        1     68
     O                       DOTS2               55
     O                                           52 'Unit Cost'
     O                       IMLCST        1     97
     O                       DOTS2               85
     O                                           82 'Last Cost'
     O                                          116 'Lot Control.'
     O                       IMLOTC             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            9 'Location'
     O                       IMWHSE              14
     O              N33      WHDESC              45
     O               33                          29 'Inactive Location'
     O                       DOTS2               55
     O                                           49 'Vendor'
     O                       IMVEND        Z     61
     O                       VMNAME              92
     O                                          116 'Taxable.....'
     O                       IMTXBL             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            5 'Area'
     O                       IMBIN#              17
     O                       DOTS2               55
     O                                           54 'Vendor Item'
     O                       IMVITM              92
     O                                          116 'State.......'
     O                       IMTCD1             120
     O          E            DETL           1
     O                       DOTS                10
     O*                                   8 'Company'
     O*                        IMCOMP    13
     O*                        COMPNM B  41
     O                       DOTS2               55
     O                                           50 'Royalty'
     O                       IMROYL        1     66
     O                                           82 'Germ Weeks..'
     O                       IMWG1         Z     85
     O                       IMBD1               92 '  /  '
     O                       IMED1               98 '  /  '
     O                                          116 'County......'
     O                       IMTCD2             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            9 'Prd Cl 1'
     O                       IMPCL1              13
     O              N22      PRCL1          B    42
     O               22                          36 'Inactive Product Class'
     O                       DOTS2               55
     O                                           54 'Cycle Count'
     O                       IMCYCD              66
     O                       IMWG2         Z     85
     O                       IMBD2               92 '  /  '
     O                       IMED2               98 '  /  '
     O                                          116 'City........'
     O                       IMTCD3             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            9 'Prd Cl 2'
     O                       IMPCL2              13
     O              N23      PRCL2          B    42
     O               23                          36 'Inactive Product Class'
     O                       IMQEOQ              66 '    ,     0. '
     O                       DOTS2               55
     O                                           53 'Reorder Pt'
     O                       IMWG3         Z     85
     O                       IMBD3               92 '  /  '
     O                       IMED3               98 '  /  '
     O                                          116 'Backorder...'
     O                       IMBOOK             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            9 'Prd Cl 3'
     O                       IMPCL3              13
     O              N25      PRCL3          B    42
     O               25                          36 'Inactive Product Class'
     O                       IMQREO              66 '    ,     0. '
     O                       DOTS2               55
     O                                           46 'EOQ'
     O                       IMWG4         Z     85
     O                       IMBD4               92 '  /  '
     O                       IMED4               98 '  /  '
     O                                          116 'Post Detail.'
     O                       IMDSHF             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            8 'U/M-Pri'
     O                       IMPUOM              13
     O                       DOTS                31
     O                                           29 'U/M-3rd'
     O                       IM3UOM              34
     O                       IMLEAD        Z     66
     O                       DOTS2               55
     O                                           52 'Lead Time'
     O                                          116 'Price List..'
     O                       IMPRPL             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            8 'U/M-Sec'
     O                       IMSUOM              13
     O                       DOTS                31
     O                                           31 'U/M-Price'
     O                       IMBPUM              34
     O                       IMSOWC              66
     O                       DOTS2               55
     O                                           51 'Sow Code'
     O                       DOTS2               82
     O                                           80 'Seeds/Cell'
     O                       IM#SED              90
     O                                          116 'Factor Tabl.'
     O                       IMFTAB             120
     O          E            DETL           1
     O                       DOTS                10
     O                                            7 'Mult 1'
     O                       IMMULT        3     19
     O                       DOTS                31
     O                                           28 'Mult 2'
     O                       IMMUL2        3     40
     O                       IMTRYC              66
     O                       DOTS2               55
     O                                           52 'Tray Code'
     O                       DOTS2               82
     O                                           78 'Type/Sow'
     O                       IMTPSW              90
     O                                          116 'Weeks Avail.'
     O                       IMWKAV             120
     O          E            DETL           1
     O                                           16 'Consldte Qty...'
     O                       IMCNSF              18
     O                                           31 'Sq Ft....'
     O                       IMCUBE        1     40
     O                       IMLOC               66
     O                       DOTS2               55
     O                                           51 'Loc Code'
     O                       DOTS2               82
     O                                           80 'Misc Codes'
     O                       IMMSCX              90
     O                       IMUWGT             120 '      0.    '
     O                                          109 'Wgt..'
     O          E            DETL           1
     O                                           13 'Sales.......'
     O                       IMMERC              23 '    -    '
     O                                           55 'Cost/Goods..'
     O                       IMCOGS              65 '    -    '
     O                                           82 'Inventory...'
     O                       IMINVN              92 '    -    '
     O          E            DETL           1
     O                       BLNKLN             120
     O          T    LR                     1
     O                                           19 'Total Number of'
     O                                           35 'Items Listed:  '
     O                       CTR           1     42
