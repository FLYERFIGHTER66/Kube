     H*--------------------------------------------------------------          1
     H*                                                                        1
     H*  COPYRIGHT EFD ENTERPRISES, INC.    1995
     H*                                                                        1
     H*       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
     H*       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
     H*       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
     H*       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
     H*       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
     H*       BY EXPRESS WRITTEN PERMISSION OF
     H*            EFD ENTERPRISES, INC.     215-643-5352
     H*
     H*--------------------------------------------------------------
      *PROGRAM NAME-------- SOR200
      *COMPANY------------- EFD ENTERPRISES, INC.
      *SYSTEM-------------- THE GREENHOUSE MANAGEMENT SYSTEM
      *APPLICATION--------- SHIPPED ORDER HISTORY REPORT.
      *DESCRIPTION--------- PRINT SHIP ORDER HISTORY BY SELECTED CUSTO MER
      *             PRODUCT CLASS AND SHIP DATES.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      * 1/16/99 JJP AS400 NATIVE CREATION OF SAME PROGRAM
      *             PLUS TAKE OUT FUNCTIONALITY OF WIDE VS NON WIDE REPORTING
      *             THIS REPORT WILL ONLY PRINT OUT ON GREEN BAR- CPI-15(198)
      *             FOR CUSTOMER SEARCH CALL NEW NATIVE: CSTALOOK
      *------------------------------------------------------------------------
      **
      *
      *INDICATORS: 1 THRU 52 ARE SETON FOR NUMBER OF WEEKS
      *            61 THRU 68 ARE SETON FOR NUMBER OF REPORT PAGES
      *            U1 WIDE REPORT FORMAT
      *            U2 NARROW REPORT FORMAT
      *
     FFSOHSTPC  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     F*MPRCL  IF  E           K        DISK
     FREPORT1   O    F  198        PRINTER OFLIND(*INOF)
     FREPORT2   O    F  198        PRINTER
     D*-------------------------------------
     D MSG             S             31    DIM(5) CTDATA PERRCD(1)              MESSAGE ARRAY
     D TOT             S              6  0 DIM(52)                              TOTAL ARRAY
     D LIN             S              4  0 DIM(52)                              LINE ITEM ARRAY
     D HED             S              4  0 DIM(52)                              HEADING DATES
     D WK              S              7  0 DIM(52) ASCEND                       WEEK END CYMD D
     D**
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
      *
     D*-------------------------------------
     D                UDS
     D  LDACST                 9     14  0
     D  LDABEG                15     20  0
     D  BEGYMD                21     27  0
     D  LDAEND                28     33  0
     D  ENDYMD                34     40  0
     D  BEGPC                 41     42
     D  ENDPC                 43     44
     D  PRTID                 45     54
     D  COMPNY                55     56  0
     D  CANCEL               133    133
     C*
     C**
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C*                    Z-ADDBEGYMD    BEGDAT  60
     C*                    Z-ADDENDYMD    ENDDAT  60
     C     COMPNY        CHAIN     RMCOMP                             91
     C** IF NO PC FORCE 99 INTO END
     C     ENDPC         IFEQ      *BLANKS
     C                   MOVE      '99'          ENDPC
     C                   END
     C** GET ACTUAL SHIP START AND END DATES
     C                   EXSR      GETSTR
     C** FIND OUT HOW MANY WEEKS
     C*                    MOVELBEGDAT    YRTST   20
     C*          YRTST     IFGT 50
     C*                    Z-ADD0         CENT    10
     C*                    ELSE
     C*                    Z-ADD1         CENT
     C*                    END
     C                   Z-ADD     BEGYMD        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     1             X                 2 0
     C                   MOVEL     ##MDY         HED(X)
     C** GET LAST DAY OF FIRST WEEK
     C                   ADD       6             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
      *
     C                   Z-ADD     ##CYMD        WK(X)
     C     NXTWK         TAG
     C     ##CYMD        IFGE      ENDYMD
     C                   GOTO      ENDWK
     C                   END
     C** GET LAST DAY OF REST OF WEEKS
     C                   ADD       7             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
      *
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   SUB       6             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ADD       1             X
     C                   MOVEL     ##MDY         HED(X)
     C                   Z-ADD     ##CYMD        WK(X)
     C                   ADD       6             ##DDD
     C     X             IFLT      52
     C                   GOTO      NXTWK
     C                   END
     C     ENDWK         TAG
     C** NOW GET PRINT INDICATORS 1 - 52
     C     X             COMP      1                                  01  01
     C     X             COMP      2                                  02  02
     C     X             COMP      3                                  03  03
     C     X             COMP      4                                  04  04
     C     X             COMP      5                                  05  05
     C     X             COMP      6                                  06  06
     C     X             COMP      7                                  07  07
     C     X             COMP      8                                  08  08
     C     X             COMP      9                                  09  09
     C     X             COMP      10                                 10  10
     C     X             COMP      11                                 11  11
     C     X             COMP      12                                 12  12
     C     X             COMP      13                                 13  13
     C     X             COMP      14                                 14  14
     C     X             COMP      15                                 15  15
     C     X             COMP      16                                 16  16
     C     X             COMP      17                                 17  17
     C     X             COMP      18                                 18  18
     C     X             COMP      19                                 19  19
     C     X             COMP      20                                 20  20
     C     X             COMP      21                                 21  21
     C     X             COMP      22                                 22  22
     C     X             COMP      23                                 23  23
     C     X             COMP      24                                 24  24
     C     X             COMP      25                                 25  25
     C     X             COMP      26                                 26  26
     C     X             COMP      27                                 27  27
     C     X             COMP      28                                 28  28
     C     X             COMP      29                                 29  29
     C     X             COMP      30                                 30  30
     C     X             COMP      31                                 31  31
     C     X             COMP      32                                 32  32
     C     X             COMP      33                                 33  33
     C     X             COMP      34                                 34  34
     C     X             COMP      35                                 35  35
     C     X             COMP      36                                 36  36
     C     X             COMP      37                                 37  37
     C     X             COMP      38                                 38  38
     C     X             COMP      39                                 39  39
     C     X             COMP      40                                 40  40
     C     X             COMP      41                                 41  41
     C     X             COMP      42                                 42  42
     C     X             COMP      43                                 43  43
     C     X             COMP      44                                 44  44
     C     X             COMP      45                                 45  45
     C     X             COMP      46                                 46  46
     C     X             COMP      47                                 47  47
     C     X             COMP      48                                 48  48
     C     X             COMP      49                                 49  49
     C     X             COMP      50                                 50  50
     C     X             COMP      51                                 51  51
     C     X             COMP      52                                 52  52
      * ALLOW 26 WEEKS FOR 1ST PRINT , 27 AND AFTER 2ND PRINT
     C   27              SETON                                        62
      *
      ** 61 IS ALWAYS ON
     C                   SETON                                        61
      * NOW GET CUSTOMER AND HEADING INFO
     C     LDACST        IFGT      0
     C     LDACST        CHAIN     RMCUST                             71
     C                   ELSE
     C                   MOVEL     MSG(1)        CMNAME
     C                   END
     C                   SETON                                        OF
     C**
     C* GET SOHST RECORDS
     C                   MOVE      BEGYMD        BEGYM7
     C                   MOVEL     BEGPC         IMPCL1
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVE      *BLANKS       IMSIZE
     C     SOKEY         SETLL     RSOHST
     C** NOW PROCESS RECORDS
     C     NXTSO         TAG
     C     LDACST        READE     RSOHST                                 90
     C   90              EXSR      LINTOT
     C   90              EXSR      FINTOT
     C   90              GOTO      END
     C*** SEE IF IN DATE RANGE
     C     SOSHDT        IFGT      ENDYMD
     C     SOSHDT        ORLT      BEGYMD
     C     SOPCL1        ORGT      ENDPC
     C                   GOTO      NXTSO
     C                   END
     C*
     C**
     C     MINKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    SOWHSE
     C*** SEE IF SAME ITEM
     C     SOITEM        IFNE      OITEM
     C     SOSIZE        ORNE      OSIZE
     C     OITEM         IFGT      *BLANKS
     C                   EXSR      LINTOT
     C                   ELSE
     C                   MOVEL     SOITEM        OITEM
     C                   MOVEL     SOSIZE        OSIZE
     C                   END
     C     MINKEY        CHAIN     FMINVT                             91
     C                   ENDIF
     C*
     C     SOQSHP        IFGT      0
     C                   EXSR      GETCOL
     C                   END
     C*                    MOVELSODES1    DESC   29
     C*                    MOVELSOITEM    OITEM   6
     C                   GOTO      NXTSO
     C*** END PROGRAM
     C*
     C     END           TAG
     C                   SETON                                        LR
     C*
     C*
     C************************
     C** FIRST
     C************************
     C     *INZSR        BEGSR
     C*
     C** KEY VALUE FOR FMINVT
     C**
     C** KEY VALUE FOR FSOHST
     C**
     C     SOKEY         KLIST
     C                   KFLD                    LDACST
     C                   KFLD                    IMPCL1
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    BEGYM7            7 0
     C**
     C                   MOVE      '1'           *IN15
     C**
     C                   ENDSR
     C**
     C************************
     C** FINAL TOTAL
     C************************
     C     FINTOT        BEGSR
     C                   XFOOT     TOT           FTOT              8 0
     C     FTOT          IFGT      0
     C** OF                EXCPTHEAD
     C** OF                SETOF                     OF
     C                   EXCEPT    TOTL
     C                   END
     C                   ENDSR
     C*
     C************************
     C** LINE TOTAL
     C************************
     C     LINTOT        BEGSR
     C                   XFOOT     LIN           LTOT              8 0
     C     LTOT          IFGT      0
     C                   ADD       LIN           TOT
     C   OF              EXCEPT    HEAD
     C   OF              SETOFF                                       OF
     C  N91              DO
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             29
     C                   ENDDO
     C   91              MOVEL     SODES1        DESC             29
     C                   EXCEPT    DETL
     C**                   MOVELSO$ITM    $ITEM
     C                   END
     C                   MOVEL     SOITEM        OITEM            12
     C                   MOVEL     SOSIZE        OSIZE             3
     C                   Z-ADD     0             LIN
     C                   ENDSR
     C************************
     C** GET THE WEEK BUCKET
     C************************
     C     GETCOL        BEGSR
      ** MOVE SATURDAY AND SUNDAY TO NEXT WEEK
     C**                   GOTO SKPCHK
     C                   Z-ADD     SOSHDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C     #Y            IFGT      5
     C                   ADD       2             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        SOSHDT
     C                   END
     C**         SKPCHK    TAG
      *
     C                   Z-ADD     1             X
     C                   Z-ADD     SOSHDT        SODTE6            6 0
     C     SOSHDT        LOOKUP    WK(X)                              71  71
     C*          SODTE6    LOKUPWK,X                 71  71
     C   71              ADD       SOQSHP        LIN(X)
     C                   ENDSR
     C************************
     C** GET ACTUAL START AND END DATES
     C**********************************
     C     GETSTR        BEGSR
     C                   Z-ADD     BEGYMD        NEWEND            7 0
     C                   Z-ADD     ENDYMD        NEWBEG            7 0
     C* GET ITEM RECORDS
     C                   MOVEL     BEGPC         IMPCL1
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVE      *BLANKS       IMSIZE
     C**
     C*
     C* GET SHIPMENT HISTORY
     C*
A    C                   MOVE      BEGYMD        BEGYM7
     C     SOKEY         SETLL     RSOHST
     C** NOW PROCESS RECORDS
     C     NXTSO1        TAG
     C                   READ      RSOHST                                 90
     C   90              GOTO      ENDSTR
     C*** SEE IF SAME CUSTOMER
     C     LDACST        IFNE      SOCUST
     C     SOPCL1        ORGT      ENDPC
     C                   GOTO      ENDSTR
     C                   END
     C*** SEE IF IN DATE RANGE
     C     SOSHDT        IFGT      ENDYMD
     C     SOSIZE        OREQ      'ROY'
     C                   GOTO      NXTSO1
     C                   END
     C*
     C*
     C     SOQSHP        IFGT      0
     C     SOSHDT        IFLT      NEWBEG
     C     SOSHDT        ANDGE     BEGYMD
     C                   Z-ADD     SOSHDT        NEWBEG
     C                   END
     C     SOSHDT        IFGT      NEWEND
     C     SOSHDT        ANDLE     ENDYMD
     C                   Z-ADD     SOSHDT        NEWEND
     C                   END
     C                   END
     C                   GOTO      NXTSO1
     C     ENDSTR        TAG
     C** NOW GET MONDAY DATES
     C**                   MOVELCENT      ##CYMD
     C                   MOVE      NEWBEG        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C** GET TO A MONDAY DATE
     C     #Y            IFNE      1
     C                   SUB       1             #Y
     C                   SUB       #Y            ##DDD
     C                   END
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C**                   Z-ADD##MDY     NEWBEG  60
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
      *
     C                   Z-ADD     ##CYMD        BEGYMD
     C** NOW GET MONDAY DATES END
     C*                    MOVELCENT      ##CYMD
     C                   MOVE      NEWEND        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C** GET TO A MONDAY DATE
     C     #Y            IFNE      1
     C                   SUB       1             #Y
     C                   SUB       #Y            ##DDD
     C                   END
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C**                   Z-ADD##MDY     NEWEND  60
     C                   ADD       13            ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ENDYMD
     C                   ENDSR
      ***********
     OREPORT1   E            HEAD           1 02
     O                       MCNAME              87
     O          E            HEAD           1
     O                                            6 'SOR200'
     O                       MSG(2)              75
     O                       LDABEG        Y     84
     O                                           89 'THRU'
     O                       LDAEND        Y     98
     O                       PAGE1         Z    160
     O                                          158 'PAGE:'
     O          E            HEAD           2
     O                       TIMOD                8 '  :  :  '
     O                                           18 'FOR:'
     O                       LDACST        4     25
     O                       CMNAME              56
     O                       TDATE         Y    162
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
     O                                            5 'ITEM#'
     O                                           10 'SIZE'
     O                                           28 'DESCRIPTION'
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
     O          EF           DETL           0
     O                       OITEM               12
     O                       OSIZE                8
     O**                       IMITEM    12
     O**                       IMSIZE     8
     O                       DESC                38
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
     O          EF           DETL           1
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
     OREPORT2   E    62      HEAD           1 03
     O                       MCNAME              87
     O          E    62      HEAD           1
     O                                            6 'SOR200'
     O                       MSG(2)              75
     O                       LDABEG        Y     84
     O                                           89 'THRU'
     O                       LDAEND        Y     98
     O                       PAGE2         Z    160
     O                                          158 'PAGE:'
     O                                          162 '-A'
     O          E    62      HEAD           1
     O                       TIMOD                8 '  :  :  '
     O                                           18 'FOR:'
     O                       LDACST        4     25
     O                       CMNAME              56
     O                       TDATE         Y    162
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
     O                                            5 'ITEM#'
     O                                           10 'SIZE'
     O                                           28 'DESCRIPTION'
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
     O          EF   62      DETL           0
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
     O          EF   62      DETL           1
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
**  MESSAGE ARRAY
ALL CUSTOMERS SELECTED    **                               1
SHIPMENT HISTORY SUMMARY FROM -                            2
