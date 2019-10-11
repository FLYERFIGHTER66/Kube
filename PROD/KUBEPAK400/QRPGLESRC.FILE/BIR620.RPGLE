    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR620
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS LISTED BY SHIP VIA
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 1/25/00 GD ADDED B/O CODE
      * 3/16/00 EFD ADD GRAND TOTALS AND UPDATE REQ DATE IN HORDR FROM
      *             IORDR
     FFHORDRSV  IF   E           K DISK
     F                                     RENAME(RHORDR:HORDR)
     FFHORDRHISTO  A E           K DISK
     FFHORDR    UF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR620    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #SH             S             32    DIM(5)
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
     D  LBSVIA                 3      4
     D  LESVIA                 5      6
     D  LADDR                  8      8
     D  LCOMM                  9      9
     D  LBEGDT                33     37  0
     D  LBSHFR                43     45
     D  LESHFR                46     48
     D  LBDATE                49     54  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LX1521               172    172
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      * RENAME HORDR FIELDS
     IHORDR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             90
      *
     C     LBSVIA        IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LADDR         IFEQ      'Y'
     C                   SETON                                        64
     C                   ENDIF
      *
     C     LCOMM         IFEQ      'Y'
     C                   SETON                                        61
     C                   ENDIF
      *
     C     LBDATE        IFGT      0
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
      *
     C                   EXCEPT    HDG
     C                   Z-ADD     1             CUSTC             3 0          CUST TOTAL
     C                   Z-ADD     1             VIA               3 0
      *
     C     NXT           TAG
     C                   SETOFF                                       68
      *
     C                   READ      FHORDRSV                               77
     C   77              GOTO      END
      *
     C                   MOVEL     *BLANKS       CADDR
     C                   MOVEL     *BLANKS       ADDR
     C                   MOVEL     *BLANKS       ADDR1
     C                   MOVEL     *BLANKS       ADDR3
     C   64              EXSR      #SHP
      * UPDATE HEADER JUST DONOT PRINT
     C*          OHCUST    IFEQ 1521
     C*          OHCUST    OREQ 2730
     C*          OHCUST    OREQ 6461
     C*                    GOTO NXT
     C*                    ENDIF
      *
     C     OHCUST        CHAIN     FMCUST                             91
     C     CMBABB        IFGT      *BLANKS
     C                   SETON                                        68
     C                   ENDIF
      *
      * ACTIVE ORDER
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHSHPC        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60OHSHPC        IFLT      LBSVIA
     C     OHSHPC        ORGT      LESVIA
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   63OHSHFR        IFLT      LBSHFR
     C     OHSHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF THIS IS A QUOTE, IF SO, DO NOT PRINT
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VIA           IFGT      1
     C     OHSHPC        ANDNE     OSVIA
     C     OSVIA         ANDGT     *BLANKS
     C*          CUSTOW    ANDGT0
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C   55              EXCEPT    HDG
     C                   Z-ADD     1             VIA
     C                   Z-ADD     1             CUSTC
     C                   SETOFF                                       66
     C                   MOVE      *BLANKS       OSVIA             2
     C                   ENDIF
      *
     C     CUSTC         IFGT      1
     C     OHCUST        ANDNE     OLCUST
     C     OHSHPC        ANDEQ     OSVIA
     C     CUSTOW        ANDGT     0
     C                   Z-ADD     1             CUSTC
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETON                                        88
     C                   EXCEPT    HDG1
     C                   ENDDO
     C                   EXCEPT    TL1
     C                   SETOFF                                       66
     C                   ENDIF
      *
     C                   SETON                                        55
      *
     C                   Z-ADD     0             OLDDTR            6 0
     C                   Z-ADD     0             OLDDTY            7 0
     C     OHORD#        SETLL     FIORDR
     C     NXTI          TAG
     C     OHORD#        READE     FIORDR                                 11
     C   11              GOTO      NXT
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C  N61OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OISEQ#        ORGT      989
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED
      *
     C     OIITYP        IFEQ      ' '
     C     OIQSHP        ANDGE     OIQORD
     C     OIITYP        OREQ      'N'
     C     OIQSHP        ANDGE     OIQORD
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * CHECK DATE RANGE
      *
     C                   Z-ADD     OIDTRQ        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ODATE             5 0
      *
     C     ODATE         IFNE      LBEGDT
     C                   SETOFF                                       55
     C                   GOTO      NXTI
     C                   ENDIF
     C                   Z-ADD     OIDTRQ        OLDDTR            6 0
     C                   Z-ADD     ##CYMD        OLDDTY            7 0
      ** CHANGED NEXT STATEMENT PER CHRIS OVERRIDE DATE IF DIFF
     C******     OHDTRY    IFLT OLDDTY
     C     OHDTRY        IFNE      OLDDTY
     C     OHORD#        CHAIN     FHORDR                             67
     C                   Z-ADD     OLDDTR        OHDTRQ
     C                   Z-ADD     OLDDTY        OHDTRY
     C  N67              UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BIR620'
     C                   Eval      HSTTIME    = $Timestamp()
     C  N67              Write     RHORDRHIST
     C                   END
      *
     C     NODT          TAG
      *
     C     OHCUST        IFEQ      1521                                         KUBE PAK
     C     LX1521        ANDEQ     'Y'
     C     OHCUST        OREQ      2730                                         SPECULATION
     C                   GOTO      NXTI
     C                   ENDIF
      *
EFD  C                   MOVEL     OIITEM        ITEM              5
      *
      * COMPUTE PRICE
      *
     C     OIQORD        SUB       OIQSHP        QTYORD                         OPEN QTY
     C                   Z-ADD     OIUPRI        VUPRIC
     C                   Z-ADD     OIQDDC        VDISC
      *
     C                   CALL      '#EXLN'
     C                   PARM                    QTYORD            8 1
     C                   PARM                    VUPRIC            9 4
     C                   PARM                    VDISC             4 2
     C                   PARM                    #LINGR            9 2
     C                   PARM                    #LINNT            9 2
     C                   PARM                    #LINDS            7 2
      *
     C     OIITYP        IFEQ      'F'
     C     OIITYP        OREQ      'S'
     C                   Z-ADD     OIUPRI        #LINNT
     C                   ENDIF
      *
      * ACCUMULATE ORDER, CUSTOMER AND FINAL TOTALS
      *
     C                   ADD       #LINNT        CUSTOT           12 2
     C                   ADD       OIQORD        CUSTOQ           11 1
     C                   ADD       OIQSHP        CUSTOS           11 1
     C                   ADD       QTYORD        CUSTOW           11 1
     C                   ADD       #LINNT        RTETOT           12 2
     C                   ADD       OIQORD        RTETOQ           11 1
     C                   ADD       OIQSHP        RTETOS           11 1
     C                   ADD       QTYORD        RTETOW           11 1
     C                   ADD       #LINNT        FINTOT           12 2
     C                   ADD       OIQORD        FINTOQ           11 1
     C                   ADD       OIQSHP        FINTOS           11 1
     C                   ADD       QTYORD        FINTOW           11 1
      *
     C                   MOVEL     OHSHPC        OSVIA             2
     C                   Z-ADD     OHCUST        OLCUST            6 0
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     KEY18         CHAIN     FMINVT                             50
      *
     C     COMM          TAG
      *
     C     OIITYP        IFEQ      ' '
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        DESC
     C                   ENDIF
      *
     C     VIA           IFEQ      1
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     OHSHPC        CHAIN     FMSVIA                             90
     C  N90              MOVEL     SVDESC        SDESC            28
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C     CUSTC         IFEQ      1
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETON                                        88
     C                   EXCEPT    HDG1
?    C                   SETOFF                                       OF
?    C                   ENDDO
?    C                   EXCEPT    DTL2
?    C   OF              DO
?    C                   EXCEPT    HDG
?    C                   SETON                                        88
?    C                   EXCEPT    HDG1
?    C                   ENDDO
     C                   Z-ADD     1             CUSTC             3 0
     C                   SETOFF                                       OF88
     C                   ENDIF
      *
      *
     C*  OF                DO
     C*                    EXCPTHDG
     C*                    SETON                     88
     C*                    EXCPTHDG1
     C*                    SETOF                     OF88
     C*                    EXCPTDTL2
     C*                    ENDDO
      *
     C*  OF                DO
     C*                    EXCPTHDG
     C*                    SETON                     88
     C*                    EXCPTHDG1
     C*                    SETOF                     OF88
     C                   EXCEPT    DTL3
     C                   Z-ADD     CMCRL$        OCRL$             9 2
     C                   Z-ADD     CMARB$        OARB$            11 2
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETON                                        88
     C                   EXCEPT    HDG1
     C                   SETOFF                                       OF88
     C*                    EXCPTDTL2
     C                   ENDDO
     C*                    ENDDO
     C                   ADD       1             CUSTC             3 0
     C                   ADD       1             VIA               3 0
     C                   SETON                                        66
     C                   GOTO      NXTI
      *
     C     END           TAG
     C     CUSTOW        IFGT      0
     C                   EXCEPT    TL1
     C                   ENDIF
     C   55              EXCEPT    TL2
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            35
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             46
     C                   ENDSR
      *
      ***********
      * #SHP    *
      ***********
      *
     C     #SHP          BEGSR
      *
     C                   MOVE      *BLANKS       #SH
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSHP1        #SH(#X)
     C                   ADD       1             #X
     C     #WSHP2        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP1
     C                   MOVEL     #WSHP2        #SH(#X)
     C                   ADD       1             #X
     C     #SHP1         TAG
     C     #WSHP3        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP2
     C                   MOVEL     #WSHP3        #SH(#X)
     C                   ADD       1             #X
     C     #SHP2         TAG
     C     #WSHP4        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP3
     C                   MOVEL     #WSHP4        #SH(#X)
     C                   ADD       1             #X
     C     #SHP3         TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WSHCT        CAT       #WSHST:1      WORK1
     C                   MOVEL     #WSHZP        WORK3
     C                   MOVE      #WSHZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C     #SH(2)        CAT       #SH(3):1      ADDR             61
     C     ADDR          CAT       #SH(4):1      ADDR1            92
     C     ADDR1         CAT       #SH(5):1      ADDR3           125
     C                   MOVEL     ADDR3         CADDR           115
      *
     C                   ENDSR
      *
     OBIR620    E            HDG            1 03
     O                                            6 'BIR620'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           71 'Open Orders By Ship Via'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG1           0
     O                                           20 'Requested Ship Date:'
     O                       LBDATE        Y     29
     O                                          110 'Ship From Range:'
     O               63      LBSHFR             114
     O               63                         116 '-'
     O               63      LESHFR             120
     O              N63                         114 'ALL'
     O                                           62 'Ship Via:'
     O                       OHSHPC              65
     O               88                          65 '(Continued)'
     O          E            HDG1           1
     O                                           65 '____________'
     O          E            HDG1           1
     O                                           15 'Ship Via Range:'
     O               60      LBSVIA              18
     O               60                          21 'To'
     O               60      LESVIA              24
     O              N60                          21 'ALL'
     O                       SVDESC              85
     O          E            HDG1           1
     O*                                  69 'Ship'
     O                                           77 'Reqd'
     O                                           91 'Unit'
     O                                          111 '- - Quantity - -'
     O                                          120 'Order'
     O          E            HDG1           0
     O                                            5 'Ord #'
     O                                           18 'Item/Size'
     O                                           23 'B/O'
     O                                           50 'Description'
     O                                           79 'Shp Date'
     O                                           82 'UM'
     O                                           91 'Price'
     O                                           98 'Qrd'
     O                                          105 'Shpd'
     O                                          111 'Open'
     O                                          120 'Value'
     O          E            HDG1           1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O*       E 10             DTL2
     O          E            DTL2        1  1
     O                                            9 'Customer:'
     O                       OICUST        Z     16
     O                                           17 '-'
     O                       #WSHP1              47
     O                                           55 'Broker:'
     O               68      CMBABB              61
     O                                           68 'Phone:'
     O                       CMPHON              81 '   -   -    '
     O                                           91 'Ship Via:'
     O                       SDESC              120
     O*       E  1             DTL2
     O*                                  24 '________________________'
     O*                                  47 '_______________________'
     O*       E  2             DTL2
     O          E            DTL2           0
     O                       CADDR              120
WJB  O                                           91 'Frt Zone:'
WJB  O                       OHUPSZ              93
     O          E            DTL2           2
     O                                           24 '     ___________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DTL3           1
     O                       #LINNT        MB   120
     O                       QTYORD        4B   111
     O                       OIQSHP        4    105
     O                       OIQORD        4     99
     O                       OIUPRI        M     92
     O                       OIUUOM              82
     O                       OIDTRQ              79 '  /  / 0'
     O                       DESC           B    70
     O*                        OIWHSE    23
     O                       OIPRBO              22
     O                       OISIZE              19
     O                       ITEM                16
     O                       OISEQ#        Z     10
     O                       OIORD#        Z      6
     O          E            TL1         1  1
     O                       CUSTOT        MB   120
     O*                        CUSTOW4B 111
     O                       CUSTOS        4B   105
     O                       CUSTOQ        4B    99
     O                                           13 'Credit Limit:'
     O                       OCRL$         LB    25
     O                                           92 'Customer Totals:'
     O          E            TL1            1
     O                                           92 'A/R Balance:'
     O                       OARB$         LB   120
     O          E            TL2         1  2
     O                       RTETOT        MB   120
     O*                        RTETOW4B 111
     O                       RTETOS        4B   105
     O                       RTETOQ        4B    99
     O                                           92 'Ship Via Totals:'
     O          E            TLR         1  2
     O                       FINTOT        MB   120
     O*                        FINTOW4B 111
     O                       FINTOS        4B   105
     O                       FINTOQ        4B    99
     O                                           92 '** Grand Totals:'
