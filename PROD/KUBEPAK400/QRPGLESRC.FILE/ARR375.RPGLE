      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.      ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR375
      *APPLICATION--------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- CREDIT CHECK REPORT
      *
      *
      *       CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORSCOR  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFARHST    IF   E           K DISK
     FARR375    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LINCL                  4      4
     D  LBTERM                 5      6
     D  LETERM                 7      8
     D  BDATE                  9     13  0
     D  EDATE                 14     18  0
     D  LBCUST                19     24  0
     D  LECUST                25     30  0
     D  LBTYPE                31     32
     D  LETYPE                33     34
     D  LBDATE                35     40  0
     D  LEDATE                41     46  0
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
     C                   Z-ADD     1             SLS               4 0
     C                   Z-ADD     1             CNT               4 0
      *
     C     BDATE         IFEQ      0
     C                   SETON                                        65
     C                   ENDIF
      *
     C     LBCUST        IFGT      0
     C                   SETON                                        61
     C                   ENDIF
      *
     C     LBTERM        IFGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LBTYPE        IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LINCL         IFEQ      'Y'
     C                   SETON                                        20
     C                   ENDIF
      *
     C     LCO           CHAIN(N)  FMCORG                             90
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
      *
     C                   READ      FIORSCOR                               77
     C   77              GOTO      END
     C     CNT           IFGT      1
     C*  56      OIORD#    IFNE SAVORD
     C                   EXSR      PRTLN
     C                   SETOFF                                       56
     C                   ENDIF
     C   55OISLM1        IFNE      SAVSLS
     C                   EXCEPT    TL1
     C                   Z-ADD     1             SLS
     C                   SETOFF                                       55
     C                   ENDIF
      *
      * ACTIVE ORDER
      *
     C     OISTAT        IFEQ      'D'
     C     OIDTRQ        OREQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   65              GOTO      NODT
      *
     C     OIDTRQ        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     OIDTRQ        ##MDY
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
     C     ODATE         IFLT      BDATE
     C     ODATE         ORGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NODT          TAG
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED
      *
     C     OIQSHP        IFGE      OIQORD
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C                   GOTO      NXT
     C                   ENDIF
     C     OISEQ#        IFGT      989
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ACCUMULATE ORDER TOTAL AND FINAL TOTAL
      *
     C                   ADD       OIEXT$        ORDTOT            9 2
      *
     C                   SETON                                        5556
     C                   Z-ADD     OIORD#        SAVORD            6 0
     C                   MOVEL     OISLM1        SAVSLS            2
     C                   ADD       1             CNT
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *********
      * PRTLN
      *********
     C     PRTLN         BEGSR
      *
     C     SAVORD        CHAIN     FHORDR                             11
     C   11              GOTO      ENDPRT
      *
      * CHECK IF THIS IS A QUOTE, IF SO, DO NOT PRINT
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      ENDPRT
     C                   ENDIF
      *
      * CHECK IF CLOSED ORDER OR DELETED ORDER, IF SO, DO NOT PRINT
      *
     C     OHCOFL        IFEQ      'Y'
     C     OHSTAT        OREQ      'D'
     C                   GOTO      ENDPRT
     C                   ENDIF
      *
     C   61OHBLCU        IFLT      LBCUST
     C     OHBLCU        ORGT      LECUST
     C                   GOTO      ENDPRT
     C                   ENDIF
      *
     C   62OHTMCD        IFLT      LBTERM
     C     OHTMCD        ORGT      LETERM
     C                   GOTO      ENDPRT
     C                   ENDIF
      *
     C     OHBLCU        CHAIN(N)  FMCUST                             90
     C   60CMCTYP        IFLT      LBTYPE
     C     CMCTYP        ORGT      LETYPE
     C                   SETOFF                                       55
     C                   GOTO      ENDPRT
     C                   ENDIF
      *
     C   20CMCRL$        IFGT      *ZEROS
     C     CMARB$        ADD       CMVOPO        TOTAL             9 2
     C                   ENDIF
     C   20TOTAL         IFLT      CMCRL$
     C                   GOTO      ENDPRT
     C                   ENDIF
      *
     C                   Z-ADD     CMCRL$        CRDLMT            7 0
      *
     C     OHBLCU        CHAIN(N)  FARHST                             90
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                         OF
     C     SLS           IFEQ      1
     C                   SETON                                        40
     C                   ENDIF
     C                   ADD       ORDTOT        SLSTOT            9 2
     C                   ADD       ORDTOT        FINTOT            9 2
     C                   EXCEPT    DETL
     C                   ADD       1             SLS
     C     ENDPRT        TAG
     C                   Z-ADD     *ZEROS        ORDTOT
     C                   ENDSR
      *
      *
     OARR375    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           69 'Credit Check Report'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O              N65                          20 'Requested Ship Dates'
     O              N65      LBDATE        Y     29
     O              N65                          31 '-'
     O              N65      LEDATE        Y     39
     O               60                         112 'Customer Types'
     O               60      LBTYPE             115
     O               60                         117 '-'
     O               60      LETYPE             120
     O          E            HDG            1
     O                                           10 'Ship'
     O                                           48 'T'
     O                                           55 'Order'
     O                                           62 'Ship'
     O                                           67 'Term'
     O                                           76 'Merch'
     O                                           84 'Credit'
     O                                           92 'Last'
     O                                          106 'Account'
     O          E            HDG            1
     O                                            3 'Sls'
     O                                           10 'Date'
     O                                           31 'Bill To Customer'
     O                                           48 'P'
     O                                           56 'Number'
     O                                           61 'Via'
     O                                           67 'Code'
     O                                           76 'Total'
     O                                           83 'Limit'
     O                                           91 'Pay'
     O                                          106 'Balance'
     O                                          115 'Phone #'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O               40      SAVSLS               2
     O                       OHDTRQ        Y     11
     O                       OHBLCU        Z     18
     O                       OHSLD1              49
     O                       CMPHON             120 '   -   -    '
     O                       CMARB$        JB   107
     O                       HSDTLP              95 '  /  / 0'
     O                       CRDLMT        ZB    86
     O                       ORDTOT        JB    78
     O                       OHTMCD              66
     O                       OHSHPC              61
     O                       SAVORD        Z     56
     O                       CMCTYP              49
     O          E            TL1            1
     O                                           78 '----------'
     O          E            TL1            1
     O                       SLSTOT        JB    78
     O          E            TLR            1
     O                                           78 '==========='
     O          E            TLR            1
     O                                           62 'Report Totals:'
     O                       FINTOT        JB    78
      *
