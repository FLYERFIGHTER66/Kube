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
      *PROGRAM NAME-------- QPK200
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDER SPREAD SHEET PROGRAM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENR)
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFIORCUST  IF   E           K DISK
     FFCSTOPN   UF A E           K DISK
     FQPK200    O    F  198        PRINTER OFLIND(*INOF)
     FQPK2002   O    F  198        PRINTER OFLIND(*INOV)
      *
      *-------------------------------------
     D TOT             S              6  0 DIM(52)                              TOTAL ARRAY
     D LIN             S              4  0 DIM(52)                              LINE ITEM ARRAY
     D HED             S              4  0 DIM(52)                              HEADING DATES
     D WK              S              7  0 DIM(52) ASCEND                       WEEK END CYMD
      *-------------------------------------
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
     D  CUSTNO                 3      8  0
     D  OOFROM                29     34  0
     D  OOFCYM                35     41  0
     D  OOTO                  42     47  0
     D  OOTCYM                48     54  0
     D  SIZE1                 63     65
     D  SIZE2                 66     68
     D  SIZE3                 69     71
     D  SIZE4                 72     74
     D  SIZE5                 75     77
     D  SIZE6                 78     80
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      **************
      * START HERE *
      **************
      * GET OPEN ORDERS AND BUILD WORK FILE
     C                   EXSR      GETORD
      * GET DATE HEADINGS
     C                   EXSR      GETHED
      ****************
      * PRINT REPORT *
      ****************
      * SET FILE TO BEGINING AND READ/PRINT
     C                   Z-ADD     0             TST60             6 0
     C                   MOVE      *BLANKS       OITEM            12
     C                   MOVE      *BLANKS       OSIZE             3
     C     TST60         SETLL     FCSTOPN
     C     NXTOPN        TAG
     C     CUSTNO        READE     FCSTOPN                                90
     C   90              GOTO      ENDOPN
     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C     OITEM         IFGT      *BLANKS
      ** NO CHECK FOR OF HERE AS LAST LINE PRINTED WITH SKIP 0
     C                   XFOOT     LIN           LTOT              8 0
     C                   EXCEPT    DETOT
     C                   Z-ADD     0             LIN
     C                   END
     C     MINKY1        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     MINKY1        CHAIN     FMINVT                             60
     C                   MOVEL     IMDES1        DESC             29
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   MOVEL     OIITEM        OITEM
     C                   MOVEL     OISIZE        OSIZE
     C                   END
      ** GET BUCKET TO ADD TO
     C                   Z-ADD     1             X                 4 0
     C     OIRVDT        LOOKUP    WK(X)                              65
     C   65              DO
     C                   ADD       OIQORD        LIN(X)
     C                   ADD       OIQORD        TOT(X)
     C                   ENDDO
     C                   GOTO      NXTOPN
     C     ENDOPN        TAG
     C     OITEM         IFGT      *BLANKS
      ** NO CHECK FOR OF HERE AS LAST LINE PRINTED WITH SKIP 0
     C                   XFOOT     LIN           LTOT
     C                   EXCEPT    DETOT
     C                   Z-ADD     0             LIN
     C                   END
     C                   XFOOT     TOT           FTOT              8 0
     C                   EXCEPT    TOTL
      ** END JOB
     C                   SETON                                        LR
      ***********************
      ** GET OPEN ORDERS   **
      ***********************
     C     GETORD        BEGSR
     C     CUSTNO        SETLL     FIORCUST
     C                   Z-ADD     9999999       BEGCYM            7 0
     C                   Z-ADD     0             ENDCYM            7 0
     C     NXTORD        TAG
     C     CUSTNO        READE     FIORCUST                               90
     C   90              GOTO      ENDORD
     C     OISTAT        IFEQ      'D'
     C     OIQSHP        ORGE      OIQORD
     C     OIRVDT        ORGT      OOTCYM
     C     OIRVDT        ORLT      OOFCYM
     C                   GOTO      NXTORD
     C                   END
     C     OISIZE        IFEQ      SIZE1
     C     OISIZE        OREQ      SIZE2
     C     OISIZE        OREQ      SIZE3
     C     OISIZE        OREQ      SIZE4
     C     OISIZE        OREQ      SIZE5
     C     OISIZE        OREQ      SIZE6
      ** IF HERE WE WANT RECORD CHECK DATE RANGE
     C     OIRVDT        IFLT      BEGCYM
     C                   Z-ADD     OIRVDT        BEGCYM
     C                   END
     C     OIRVDT        IFGT      ENDCYM
     C                   Z-ADD     OIRVDT        ENDCYM
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     MINKEY        CHAIN     FMINVT                             50
     C                   MOVEL     IMLOOK        OILOOK
     C                   WRITE     RCSTOPN
     C                   END
     C                   GOTO      NXTORD
     C     ENDORD        TAG
     C                   ENDSR
      ***********************
      ** GET DATE HEADING  **
      ***********************
     C     GETHED        BEGSR
     C     BEGCYM        CHAIN     FCALENCY                           81
     C   81              DO
     C                   SETON                                        99
     C                   GOTO      ENDHED
     C                   ENDDO
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
      ** GET MONDAY MDY
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             50
     C                   MOVEL     CLDATE        HED(1)
      ** GET WEEK END CYMD
     C                   Z-ADD     7             CL#Y
     C     CALKEY        CHAIN     FCALEX                             50
     C                   Z-ADD     CLCYMD        WK(1)
     C                   MOVE      *ZEROS        *IN
     C                   MOVE      '1'           *IN(1)
      ** NOW GET REST OF DATES
     C                   Z-ADD     1             X                    50
     C     NXTWK         TAG
     C                   ADD       1             X
     C                   MOVE      '1'           *IN(X)
     C                   Z-ADD     CLCYMD        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ADD       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##MDY         CHAIN     FCALEN                             50
      ** GET MONDAY MDY
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             50
     C                   MOVEL     CLDATE        HED(X)
      ** GET WEEK END CYMD
     C                   Z-ADD     7             CL#Y
     C     CALKEY        CHAIN     FCALEX                             50
     C                   Z-ADD     CLCYMD        WK(X)
     C     CLCYMD        IFLT      ENDCYM
     C                   GOTO      NXTWK
     C                   END
     C     ENDHED        TAG
     C     *IN(27)       IFEQ      '1'
     C                   MOVEL     '1'           *IN(62)
     C                   END
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     CUSTNO        CHAIN     FMCUST                             99
     C                   SETON                                        OF
      ** GET SIZE HEADING
     C     SIZE1         IFGT      *BLANKS
     C                   MOVE      SIZE1         SIZE1D            3
     C                   ELSE
     C                   MOVE      *BLANKS       SIZE1D
     C                   END
     C     SIZE2         IFGT      *BLANKS
     C                   MOVE      SIZE2         SIZE2D            4
     C                   MOVEL     '-'           SIZE2D
     C                   ELSE
     C                   MOVE      *BLANKS       SIZE2D
     C                   END
     C     SIZE3         IFGT      *BLANKS
     C                   MOVE      SIZE3         SIZE3D            4
     C                   MOVEL     '-'           SIZE3D
     C                   ELSE
     C                   MOVE      *BLANKS       SIZE3D
     C                   END
     C     SIZE3         IFGT      *BLANKS
     C                   MOVE      SIZE3         SIZE3D            4
     C                   MOVEL     '-'           SIZE3D
     C                   ELSE
     C                   MOVE      *BLANKS       SIZE3D
     C                   END
     C     SIZE4         IFGT      *BLANKS
     C                   MOVE      SIZE4         SIZE4D            4
     C                   MOVEL     '-'           SIZE4D
     C                   ELSE
     C                   MOVE      *BLANKS       SIZE4D
     C                   END
     C     SIZE5         IFGT      *BLANKS
     C                   MOVE      SIZE5         SIZE5D            4
     C                   MOVEL     '-'           SIZE5D
     C                   ELSE
     C                   MOVE      *BLANKS       SIZE5D
     C                   END
     C     SIZE6         IFGT      *BLANKS
     C                   MOVE      SIZE6         SIZE6D            4
     C                   MOVEL     '-'           SIZE6D
     C                   ELSE
     C                   MOVE      *BLANKS       SIZE6D
     C                   END
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OQPK200    E            HEAD           1 03
     O                                            6 'QPK200'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           70 'Open Order Summary for'
     O                                           91 'Requested Date From:'
     O                       OOFROM        Y    100
     O                                          108 ' - To - '
     O                       OOTO          Y    116
     O                       PAGE          Z    180
     O                                          177 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'For the Following Sizes:'
     O                       SIZE1D              77
     O                       SIZE2D              82
     O                       SIZE3D              87
     O                       SIZE4D              92
     O                       SIZE5D              97
     O                       SIZE6D             102
     O                                          172 'Time:'
     O                       TIMOD              180 '  :  :  '
     O          E            HEAD           2
     O                                            9 'Customer:'
     O                       CMCUST        4     16
     O                       CMNAME              47
     O          E            HEAD           1
     O                  02   HED(2)        Y     48
     O                  04   HED(4)        Y     58
     O                  06   HED(6)        Y     68
     O                  08   HED(8)        Y     78
     O                  10   HED(10)       Y     88
     O                  12   HED(12)       Y     98
     O                  14   HED(14)       Y    108
     O                  16   HED(16)       Y    118
     O                  18   HED(18)       Y    128
     O                  20   HED(20)       Y    138
     O                  22   HED(22)       Y    148
     O                  24   HED(24)       Y    158
     O                  26   HED(26)       Y    168
     O          E            HEAD           1
     O                                            5 'Item#'
     O                                           10 'Size'
     O                                           28 'Description'
     O                  01   HED(1)        Y     43
     O                  03   HED(3)        Y     53
     O                  05   HED(5)        Y     63
     O                  07   HED(7)        Y     73
     O                  09   HED(9)        Y     83
     O                  11   HED(11)       Y     93
     O                  13   HED(13)       Y    103
     O                  15   HED(15)       Y    113
     O                  17   HED(17)       Y    123
     O                  19   HED(19)       Y    133
     O                  21   HED(21)       Y    143
     O                  23   HED(23)       Y    153
     O                  25   HED(25)       Y    163
     O                                          180 'TOTAL'
     O          E            DETL           0
     O                       IMITEM              12
     O                       IMSIZE               8
     O                       DESC                38
     O          E            DETOT          0
     O                  01   LIN(1)        4     43
     O                  02   LIN(2)        4     48
     O                  03   LIN(3)        4     53
     O                  04   LIN(4)        4     58
     O                  05   LIN(5)        4     63
     O                  06   LIN(6)        4     68
     O                  07   LIN(7)        4     73
     O                  08   LIN(8)        4     78
     O                  09   LIN(9)        4     83
     O                  10   LIN(10)       4     88
     O                  11   LIN(11)       4     93
     O                  12   LIN(12)       4     98
     O                  13   LIN(13)       4    103
     O                  14   LIN(14)       4    108
     O                  15   LIN(15)       4    113
     O                  16   LIN(16)       4    118
     O                  17   LIN(17)       4    123
     O                  18   LIN(18)       4    128
     O                  19   LIN(19)       4    133
     O                  20   LIN(20)       4    138
     O                  21   LIN(21)       4    143
     O                  22   LIN(22)       4    148
     O                  23   LIN(23)       4    153
     O                  24   LIN(24)       4    158
     O                  25   LIN(25)       4    163
     O                  26   LIN(26)       4    168
     O                       LTOT          2    180
     O          EF           DETOT          1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                          100 '____________________'
     O                                          120 '____________________'
     O                                          140 '____________________'
     O                                          160 '____________________'
     O                                          180 '____________________'
     O          E            TOTL        1  1
     O                                           30 'TOTALS -------------->'
     O                  01   TOT(1)        1     43
     O                  03   TOT(3)        1     53
     O                  05   TOT(5)        1     63
     O                  07   TOT(7)        1     73
     O                  09   TOT(9)        1     83
     O                  11   TOT(11)       1     93
     O                  13   TOT(13)       1    103
     O                  15   TOT(15)       1    113
     O                  17   TOT(17)       1    123
     O                  19   TOT(19)       1    133
     O                  21   TOT(21)       1    143
     O                  23   TOT(23)       1    153
     O                  25   TOT(25)       1    163
     O                       FTOT          1    180
     O          E            TOTL           1
     O                  02   TOT(2)        1     48
     O                  04   TOT(4)        1     58
     O                  06   TOT(6)        1     68
     O                  08   TOT(8)        1     78
     O                  10   TOT(10)       1     88
     O                  12   TOT(12)       1     98
     O                  14   TOT(14)       1    108
     O                  16   TOT(16)       1    118
     O                  18   TOT(18)       1    128
     O                  20   TOT(20)       1    138
     O                  22   TOT(22)       1    148
     O                  24   TOT(24)       1    158
     O                  26   TOT(26)       1    168
     O*------------------------------------ IF GO  BEYOND 26 , PRINT ON 2ND FORM
     OQPK2002   E    62      HEAD           1 03
     O                                            6 'QPK200'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           70 'Open Order Summary for'
     O                                           91 'Requested Date From:'
     O                       OOFROM        Y    100
     O                                          108 ' - To - '
     O                       OOTO          Y    116
     O                       PAGE          Z    180
     O                                          177 'Page:'
     O          E    62      HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'For the Following Sizes:'
     O                       SIZE1D              77
     O                       SIZE2D              82
     O                       SIZE3D              87
     O                       SIZE4D              92
     O                       SIZE5D              97
     O                       SIZE6D             102
     O                                          172 'Time:'
     O                       TIMOD              180 '  :  :  '
     O          E    62      HEAD           2
     O                                            9 'Customer:'
     O                       CMCUST        4     16
     O                       CMNAME              47
     O          E    62      HEAD           1
     O                  28   HED(28)       Y     48
     O                  30   HED(30)       Y     58
     O                  32   HED(32)       Y     68
     O                  34   HED(34)       Y     78
     O                  36   HED(36)       Y     88
     O                  38   HED(38)       Y     98
     O                  40   HED(40)       Y    108
     O                  42   HED(42)       Y    118
     O                  44   HED(44)       Y    128
     O                  46   HED(46)       Y    138
     O                  48   HED(48)       Y    148
     O                  50   HED(50)       Y    158
     O                  52   HED(52)       Y    168
     O          E    62      HEAD           1
     O                                            5 'Item#'
     O                                           10 'Size'
     O                                           28 'Description'
     O                  27   HED(27)       Y     43
     O                  29   HED(29)       Y     53
     O                  31   HED(31)       Y     63
     O                  33   HED(33)       Y     73
     O                  35   HED(35)       Y     83
     O                  37   HED(37)       Y     93
     O                  39   HED(39)       Y    103
     O                  41   HED(41)       Y    113
     O                  43   HED(43)       Y    123
     O                  45   HED(45)       Y    133
     O                  47   HED(47)       Y    143
     O                  49   HED(49)       Y    153
     O                  51   HED(51)       Y    163
     O                  52   HED(52)       Y    173
     O                                          184 'TOTAL'
     O          E    62      DETL           0
     O                       IMITEM              12
     O                       IMSIZE               8
     O                       DESC                38
     O          E    62      DETOT          0
     O                       OITEM               12
     O**                       IMITEM    12
     O                       OSIZE                8
     O**                       IMSIZE     8
     O                       DESC                38
     O                  27   LIN(27)       4     43
     O                  28   LIN(28)       4     48
     O                  29   LIN(29)       4     53
     O                  30   LIN(30)       4     58
     O                  31   LIN(31)       4     63
     O                  32   LIN(32)       4     68
     O                  33   LIN(33)       4     73
     O                  34   LIN(34)       4     78
     O                  35   LIN(35)       4     83
     O                  36   LIN(36)       4     88
     O                  37   LIN(37)       4     93
     O                  38   LIN(38)       4     98
     O                  39   LIN(39)       4    103
     O                  40   LIN(40)       4    108
     O                  41   LIN(41)       4    113
     O                  42   LIN(42)       4    118
     O                  43   LIN(43)       4    123
     O                  44   LIN(44)       4    128
     O                  45   LIN(45)       4    133
     O                  46   LIN(46)       4    138
     O                  47   LIN(47)       4    143
     O                  48   LIN(48)       4    148
     O                  49   LIN(49)       4    153
     O                  50   LIN(50)       4    158
     O                  51   LIN(51)       4    163
     O                  52   LIN(52)       4    168
     O                       LTOT          2    180
     O          EF   62      DETOT          1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                          100 '____________________'
     O                                          120 '____________________'
     O                                          140 '____________________'
     O                                          160 '____________________'
     O                                          180 '____________________'
     O          E    62      TOTL        1  1
     O                                           30 'TOTALS -------------->'
     O                  27   TOT(27)       1     43
     O                  29   TOT(29)       1     53
     O                  31   TOT(31)       1     63
     O                  33   TOT(33)       1     73
     O                  35   TOT(35)       1     83
     O                  37   TOT(37)       1     93
     O                  39   TOT(39)       1    103
     O                  41   TOT(41)       1    113
     O                  43   TOT(43)       1    123
     O                  45   TOT(45)       1    133
     O                  47   TOT(47)       1    143
     O                  49   TOT(49)       1    153
     O                  51   TOT(51)       1    163
     O                       FTOT          1    180
     O          E    62      TOTL           1
     O                  28   TOT(28)       1     48
     O                  30   TOT(30)       1     58
     O                  32   TOT(32)       1     68
     O                  34   TOT(34)       1     78
     O                  36   TOT(36)       1     88
     O                  38   TOT(38)       1     98
     O                  40   TOT(40)       1    108
     O                  42   TOT(42)       1    118
     O                  44   TOT(44)       1    128
     O                  46   TOT(46)       1    138
     O                  48   TOT(48)       1    148
     O                  50   TOT(50)       1    158
     O                  52   TOT(52)       1    168
