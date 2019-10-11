      ** CHANGE LOG:
      *
      *  #PRICE - ITEM PRICING ROUTINE
      *  DETERMINES HEIRARCHY OF PRICING FOR AN ITEM. THIS ROUTINE
      *  WILL CHECK FOR SEASONAL CODES, CONTRACT PRICING, ITEM MASTER
      *  BASE PRICING, QUANTITY DISCOUNTS, AND MARKUPS. FULL AND
      *  BROKEN CASE PRICES WILL BE USED. PRICING WILL BE DONE
      *  IN THE BASE PRICE UNIT OF MEASURE, AND CONVERTED INTO
      *  THE ORDERED UNIT OF MEASURE. ORDERED U/M, ITEM#,
      *  ORDERED QTY, REQUESTED DATE, BILL TO CUSTOMER, BILL TO
      *  CUSTOMER PRICE CODE AND CONTRACT FLAG, BILL TO CUSTOMER
      *  QUANTITY DISCOUNT, AND BILL TO CUSTOMER TYPE MUST
      *  BE LOADED INTO WORK FIELDS BEFORE EXECUTING.
      *  OUTPUT FIELDS ARE #OPRC, #DISC, #CNTCD, #SNCD, #PRO, #PRO$.
      *
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCONT    IF   E           K DISK
     FFMCCLT    IF   E           K DISK
     FFMPCLS    IF   E           K DISK
     FFSPCPR    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFQDISC    IF   E           K DISK
     FFQDISCO   IF   E           K DISK
      ** MINVT ARRAYS
     D IP1             S              9  4 DIM(5)                               PRICE U/M 1
     D IP2             S              9  4 DIM(5)                               PRICE U/M 2
     D IP3             S              9  4 DIM(5)                               PRICE U/M 3
     D IDQ             S             11  1 DIM(5) ASCEND                        QTY. DISC QTY.
     D IDP             S              4  2 DIM(5)                               QTY. DISC %
      ** MPCLS ARRAYS
     D PQN             S             11  1 DIM(10) ASCEND                       PC QTY
     D PCT             S              5  2 DIM(10)                              PC DISC %
     D PCT4            S              5  4 DIM(10)                              PC DISC 4 DEC
     D PC$             S              9  4 DIM(10)                              PC DISC $
      ** SPCPR ARRAYS
     D SPQ             S             11  1 DIM(5) ASCEND                        PC QTY
     D SPD             S              4  2 DIM(5)                               PC DISC %
      ** FPDISC ARRAYS
     D QQN             S             11  1 DIM(10) ASCEND                       PC QTY
     D QCT             S              5  2 DIM(10)                              PC DISC %
     D QCT4            S              5  4 DIM(10)                              PC DISC 4 DEC
     D QC$             S              9  4 DIM(10)                              PC DISC $
     IRMINVT
     I              IMSEL1                      IP1(1)
     I              IMSEL2                      IP1(2)
     I              IMSEL3                      IP1(3)
     I              IMSEL4                      IP1(4)
     I              IMSEL5                      IP1(5)
     I              IMBCS1                      IP2(1)
     I              IMBCS2                      IP2(2)
     I              IMBCS3                      IP2(3)
     I              IMBCS4                      IP2(4)
     I              IMBCS5                      IP2(5)
     I              IM3CS1                      IP3(1)
     I              IM3CS2                      IP3(2)
     I              IM3CS3                      IP3(3)
     I              IM3CS4                      IP3(4)
     I              IM3CS5                      IP3(5)
     I              IMQLB1                      IDQ(1)
     I              IMQLB2                      IDQ(2)
     I              IMQLB3                      IDQ(3)
     I              IMQLB4                      IDQ(4)
     I              IMQLB5                      IDQ(5)
     I              IMDIS1                      IDP(1)
     I              IMDIS2                      IDP(2)
     I              IMDIS3                      IDP(3)
     I              IMDIS4                      IDP(4)
     I              IMDIS5                      IDP(5)
     IRMPCLS
     I              PCPQN1                      PQN(1)
     I              PCPQN2                      PQN(2)
     I              PCPQN3                      PQN(3)
     I              PCPQN4                      PQN(4)
     I              PCPQN5                      PQN(5)
     I              PCPQN6                      PQN(6)
     I              PCPQN7                      PQN(7)
     I              PCPQN8                      PQN(8)
     I              PCPQN9                      PQN(9)
     I              PCPQN0                      PQN(10)
     I              PCPCT1                      PCT(1)
     I              PCPCT2                      PCT(2)
     I              PCPCT3                      PCT(3)
     I              PCPCT4                      PCT(4)
     I              PCPCT5                      PCT(5)
     I              PCPCT6                      PCT(6)
     I              PCPCT7                      PCT(7)
     I              PCPCT8                      PCT(8)
     I              PCPCT9                      PCT(9)
     I              PCPCT0                      PCT(10)
     I              PCPC$1                      PC$(1)
     I              PCPC$2                      PC$(2)
     I              PCPC$3                      PC$(3)
     I              PCPC$4                      PC$(4)
     I              PCPC$5                      PC$(5)
     I              PCPC$6                      PC$(6)
     I              PCPC$7                      PC$(7)
     I              PCPC$8                      PC$(8)
     I              PCPC$9                      PC$(9)
     I              PCPC$0                      PC$(10)
     IRSPCPR
     I              SPQLB1                      SPQ(1)
     I              SPQLB2                      SPQ(2)
     I              SPQLB3                      SPQ(3)
     I              SPQLB4                      SPQ(4)
     I              SPQLB5                      SPQ(5)
     I              SPDIS1                      SPD(1)
     I              SPDIS2                      SPD(2)
     I              SPDIS3                      SPD(3)
     I              SPDIS4                      SPD(4)
     I              SPDIS5                      SPD(5)
     IRQDISC
      ** QUANTITIES
     I              QCPQN1                      QQN(1)
     I              QCPQN2                      QQN(2)
     I              QCPQN3                      QQN(3)
     I              QCPQN4                      QQN(4)
     I              QCPQN5                      QQN(5)
     I              QCPQN6                      QQN(6)
     I              QCPQN7                      QQN(7)
     I              QCPQN8                      QQN(8)
     I              QCPQN9                      QQN(9)
     I              QCPQN0                      QQN(10)
      ** PERCENT 5.2
     I              QCPCT1                      QCT(1)
     I              QCPCT2                      QCT(2)
     I              QCPCT3                      QCT(3)
     I              QCPCT4                      QCT(4)
     I              QCPCT5                      QCT(5)
     I              QCPCT6                      QCT(6)
     I              QCPCT7                      QCT(7)
     I              QCPCT8                      QCT(8)
     I              QCPCT9                      QCT(9)
     I              QCPCT0                      QCT(10)
      ** PRICE 5.4
     I              QCPC$1                      QC$(1)
     I              QCPC$2                      QC$(2)
     I              QCPC$3                      QC$(3)
     I              QCPC$4                      QC$(4)
     I              QCPC$5                      QC$(5)
     I              QCPC$6                      QC$(6)
     I              QCPC$7                      QC$(7)
     I              QCPC$8                      QC$(8)
     I              QCPC$9                      QC$(9)
     I              QCPC$0                      QC$(10)
     IRQDISCO
      ** QUANTITIES
     I              QCPQN1                      QQN(1)
     I              QCPQN2                      QQN(2)
     I              QCPQN3                      QQN(3)
     I              QCPQN4                      QQN(4)
     I              QCPQN5                      QQN(5)
     I              QCPQN6                      QQN(6)
     I              QCPQN7                      QQN(7)
     I              QCPQN8                      QQN(8)
     I              QCPQN9                      QQN(9)
     I              QCPQN0                      QQN(10)
      ** PERCENT 5.2
     I              QCPCT1                      QCT(1)
     I              QCPCT2                      QCT(2)
     I              QCPCT3                      QCT(3)
     I              QCPCT4                      QCT(4)
     I              QCPCT5                      QCT(5)
     I              QCPCT6                      QCT(6)
     I              QCPCT7                      QCT(7)
     I              QCPCT8                      QCT(8)
     I              QCPCT9                      QCT(9)
     I              QCPCT0                      QCT(10)
      ** PRICE 5.4
     I              QCPC$1                      QC$(1)
     I              QCPC$2                      QC$(2)
     I              QCPC$3                      QC$(3)
     I              QCPC$4                      QC$(4)
     I              QCPC$5                      QC$(5)
     I              QCPC$6                      QC$(6)
     I              QCPC$7                      QC$(7)
     I              QCPC$8                      QC$(8)
     I              QCPC$9                      QC$(9)
     I              QCPC$0                      QC$(10)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMCUST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    #OUM              2
     C                   PARM                    #OQTY             8 1
     C                   PARM                    PRICD             1
     C                   PARM                    #OPRC             9 4
     C                   PARM                    #DISC             4 2
     C                   PARM                    #CNTCD
     C                   PARM                    VOLDSC            4 2
     C                   PARM                    OIFRQD            1
     C                   PARM                    OHORD#
     C                   PARM                    IMORDD
     C     *LIKE         DEFINE    CMCUST        #SCUST                         BILL TO CUST
     C     *LIKE         DEFINE    IMITEM        #ITEM                          ITEM NUMBER
     C     *LIKE         DEFINE    UDATE         #REQDT                         REQUESTED DATE
     C     *LIKE         DEFINE    IMQTOH        #BPQTY                         BASE PRICE QTY
     C     *LIKE         DEFINE    #OPRC         #PRC                           BASE PRICE
     C     *LIKE         DEFINE    CMCTYP        #CTYP                          BILL TO TYPE
     C     *LIKE         DEFINE    CMCTCD        #CTCD                          BILL CONTRACT F
     C                   Z-ADD     0             IP1
     C                   Z-ADD     0             IP2
     C                   Z-ADD     0             IP3
     C                   Z-ADD     0             IDQ
     C                   Z-ADD     0             IDP
     C**                   Z-ADD0         ISQ
     C**                   Z-ADD0         ISP
     C**                   Z-ADD0         ISC
     C                   Z-ADD     0             PQN
     C                   Z-ADD     0             PCT
     C                   Z-ADD     0             PCT4
     C                   Z-ADD     0             PC$
     C                   Z-ADD     0             SPQ
     C                   Z-ADD     0             SPD
     C                   Z-ADD     0             QQN
     C                   Z-ADD     0             QCT
     C                   Z-ADD     0             QCT4
     C                   Z-ADD     0             QC$
     C     PRICD         IFLE      '0'
     C                   MOVEL     '1'           PRICD
     C                   END
     C                   MOVE      PRICD         P                 2 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
      * GET MASTER FILES
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     OHORD#        IFLE      000000
     C                   Z-ADD     TDATE         OHDTRQ
     C                   Z-ADD     TDATE         OHDTOR
     C                   MOVEL     IMWHSE        OHSHFR
     C                   ELSE
     C     OHORD#        CHAIN     FHORDR                             91
     C  N91              MOVEL     OHSHFR        IMWHSE
     C   91              MOVEL     IMWHSE        OHSHFR
     C                   END
     C     ITMKEY        CHAIN     FMINVT                             90
     C     CMCUST        CHAIN     FMCUST                             91
     C                   SETOFF                                       9091
     C                   MOVE      *ZEROS        #OPRC
     C                   MOVE      *ZEROS        #PRC
     C     OIFRQD        IFNE      'Y'
     C                   MOVE      *ZEROS        #DISC
     C                   END
     C                   MOVE      'Y'           #SNCD             1            IN SEASON CODE
     C                   MOVE      'N'           #CNTCD            1            CONTRACT CODE
     C                   MOVE      'N'           #PRO              1
     C                   MOVE      *ZEROS        #PRO$             9 2
      *
      * CONVERT ORDERED QTY INTO BASE PRICE QTY
      *
     C                   MOVE      #OUM          #WRFUM
     C                   Z-ADD     #OQTY         #WRFQT
     C                   EXSR      #CVQT
      *
     C     IMBPUM        IFEQ      IMPUOM
     C                   Z-ADD     #WQT1         #BPQTY
     C                   END
      *
     C     IMBPUM        IFEQ      IMSUOM
     C                   Z-ADD     #WQT2         #BPQTY
     C                   END
      *
     C     IMBPUM        IFEQ      IM3UOM
     C                   Z-ADD     #WQT3         #BPQTY
     C                   END
      *
     C**         IMCWTF    IFEQ 'Y'
     C**                   Z-ADD#WQT#     #BPQTY
     C*                    END
      *
      *
      * SEE IF SALE
     C                   Z-ADD     0             TRY               5 0
     C     SALKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    PCL1
     C                   KFLD                    LIST
     C                   KFLD                    SHFR
      ** TRY ALL COMBINATIONS
     C     SPTRY         TAG
     C                   MOVE      *BLANKS       ITEM             12
     C                   MOVE      *BLANKS       SIZE              3
     C                   MOVE      *BLANKS       PCL1              2
     C                   MOVE      *BLANKS       LIST              4
     C                   MOVE      *BLANKS       SHFR              3
      ** ITEM,SIZE,LOCATION
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVEL     OHSHFR        SHFR
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     1             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY1          TAG
      ** ITEM,SIZE
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVE      *BLANKS       SHFR
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     2             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY2          TAG
      ** ITEM,LOCATION
     C                   MOVEL     IMITEM        ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVEL     OHSHFR        SHFR
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     3             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY3          TAG
      ** SIZE,PRODCL,LOCATION
     C                   MOVE      *BLANKS       ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVEL     IMPCL1        PCL1
     C                   MOVEL     OHSHFR        SHFR
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     4             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY4          TAG
      ** SIZE,PRODCL
     C                   MOVE      *BLANKS       ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVEL     IMPCL1        PCL1
     C                   MOVE      *BLANKS       SHFR
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     5             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY5          TAG
      ** PRODCL,LOCATION
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      IMPCL1        PCL1
     C                   MOVEL     OHSHFR        SHFR
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     6             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY6          TAG
      ** PRODCL
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      IMPCL1        PCL1
     C                   MOVE      *BLANKS       SHFR
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     7             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY7          TAG
      ** SIZE,LISTCD,LOCATION
     C                   MOVE      *BLANKS       ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVE      *BLANKS       PCL1
     C                   MOVEL     OHSHFR        SHFR
     C                   MOVEL     IMLIST        LIST
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     8             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY8          TAG
      ** LISTCD,LOCATION
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       PCL1
     C                   MOVEL     OHSHFR        SHFR
     C                   MOVEL     IMLIST        LIST
     C     SALKEY        CHAIN     FSPCPR                             90
     C  N90              DO
     C                   Z-ADD     9             TRY
     C                   GOTO      SLHIT
     C                   ENDDO
     C     TRY9          TAG
     C                   Z-ADD     0             TRY
      ** LISTCD
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       PCL1
     C                   MOVEL     *BLANKS       SHFR
     C                   MOVEL     IMLIST        LIST
     C     SALKEY        CHAIN     FSPCPR                             90
     C   90              GOTO      ENDSPC
     C     SLHIT         TAG
     C  N90              DO
      ** CHECK SHIP VIA
     C     SPSHVA        IFGT      *BLANKS
     C     SPSHVA        ANDNE     OHSHPC
     C                   GOTO      ENDSPC
     C                   ENDIF
     C     SPDTTU        IFEQ      'R'
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   ELSE
     C                   Z-ADD     OHDTOR        ##MDY
     C                   END
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        IFLT      SPSTCY
     C     ##CYMD        ORGT      SPENCY
     C                   GOTO      ENDSPC
     C                   ENDIF
     C     SPPRIC        IFGT      0.00
     C                   Z-ADD     SPPRIC        #PRC
     C                   ELSE
     C     SPDISC        IFGT      0.00
     C     SPDISC        MULT(H)   .01           WRKD              5 4
     C     1.0           SUB       WRKD          WRKDSC            5 4
     C     IP1(1)        MULT(H)   WRKDSC        #PRC
     C                   END
     C**         SPPRIC    IFGT 0.00
     C**                   Z-ADDSPPRIC    #PRC
     C**                   ELSE
     C**                   Z-ADDIP1,1     #PRC
     C**                   END
     C                   END
     C                   Z-ADD     1             X
     C     #BPQTY        LOOKUP    SPQ(X)                               9090
     C   90              MOVE      SPD(X)        #DISC
     C     VOLDSC        IFGT      #DISC
     C***        COEVD     ANDNE'N'
     C                   Z-ADD     VOLDSC        #DISC
     C                   END
     C                   MOVEL     SPORDD        IMORDD
     C                   GOTO      SLPRC
     C     ENDSPC        TAG
     C     TRY           IFGT      0
     C     SALKEY        READE     FSPCPR                                 90
     C  N90              GOTO      SLHIT
     C     TRY           IFEQ      1
     C                   GOTO      TRY1
     C                   END
     C     TRY           IFEQ      2
     C                   GOTO      TRY2
     C                   END
     C     TRY           IFEQ      3
     C                   GOTO      TRY3
     C                   END
     C     TRY           IFEQ      4
     C                   GOTO      TRY4
     C                   END
     C     TRY           IFEQ      5
     C                   GOTO      TRY5
     C                   END
     C     TRY           IFEQ      6
     C                   GOTO      TRY6
     C                   END
     C     TRY           IFEQ      7
     C                   GOTO      TRY7
     C                   END
     C     TRY           IFEQ      8
     C                   GOTO      TRY8
     C                   END
     C     TRY           IFEQ      9
     C                   GOTO      TRY9
     C                   END
     C                   END                                                    TRY > 0
     C                   ENDDO                                                             W
      *
      * GROUP PRICE DISCOUNT DETERMINED BY PRODUCT CLASS THREE.
      *
     C     PC3PRC        TAG
     C     IMPCL3        IFNE      *BLANKS
      *
     C     DISKEY        KLIST
     C                   KFLD                    OHSHFR
     C                   KFLD                    IMPCL3
     C     DISKEY        CHAIN     FQDISCO                            98
     C     QCDTCD        IFEQ      'R'
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   ELSE
     C                   Z-ADD     OHDTOR        ##MDY
     C                   END
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        IFLT      QCDTBG
     C     ##CYMD        ORGT      QCDTEN
     C                   SETON                                        98
     C                   ENDIF
      ** IF HERE AND 98 IS OFF WE FOUND A GOOD OVERRIDE RECORD
     C   98DISKEY        CHAIN     FQDISC                             98
      *
     C  N98              DO
     C                   MOVE      PRICD         X                 1 0
      ** SEE IF PRICE 1 >0 AND QTY=1 IF SO USE AS BASE PRICE+SEL1(MINVT
     C     QQN(1)        IFEQ      1
     C     QC$(1)        ANDGT     0.00
     C     IP1(X)        ADD       QC$(1)        #PRC
     C     IP1(P)        IFGT      0.00
     C                   Z-ADD     IP1(P)        #PRC
     C                   ELSE
     C                   Z-ADD     IP1(P)        #PRC
     C                   ENDIF                                                  IP1,P>0.00
     C                   ENDIF                                                  QQN,1=1
      ** NOW CHECK FOR DISCOUNT
     C                   Z-ADD     1             X1                5 0
     C     #BPQTY        LOOKUP    QQN(X1)                              9090
     C   90QCT(X1)       IFGT      0
     C                   MOVE      QCT(X1)       #DISC
     C                   ELSE
     C     IP1(X)        ADD       QC$(X1)       #PRC
     C                   END                                                    QCT,X1>0
     C**                   END                             IP1,X >0
     C                   ENDDO                                                  N98 DO
     C                   END                                                    IMPCL3><" "
      *
      *
      * DETERMINE IF CONTRACT PRICE IS AVAILABLE
      *
     C     CMCTCD        IFEQ      'Y'
      *
     C     CNTKEY        KLIST
     C                   KFLD                    CMCUST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     CNTKEY        CHAIN     FMCONT                             98
      *
     C  N98CPSTAT        IFNE      'D'
      *
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CNTREQ            7 0
      *
     C     CNTREQ        IFGE      CPSTCY
      *
     C     CNTREQ        IFLE      CPENCY
      *
     C     CPBLCD        IFEQ      'Y'                                          BLANKET ORDER
      *
     C                   MOVE      CPPRAL        #PRO
     C                   Z-ADD     CPPRMT        #PRO$
     C     CPMRKP        COMP      'N'                                    91    NO MARKUP ALLWD
     C                   MOVE      'Y'           #CNTCD
      *
     C     #OUM          IFEQ      IMPUOM
     C                   Z-ADD(H)  CPCPRC        #PRC
     C                   END
     C     #OUM          IFEQ      IMSUOM
     C                   Z-ADD(H)  CPBRPC        #PRC
     C                   END
     C     #OUM          IFEQ      IM3UOM
     C                   Z-ADD(H)  CP3RPC        #PRC
     C                   END
      *
     C                   ELSE
     C     CPSUTD        IFLE      CPUNIT                                       UNITS CHECKING
      *
     C                   MOVE      CPPRAL        #PRO
     C                   Z-ADD     CPPRMT        #PRO$
     C     CPMRKP        COMP      'N'                                    91    NO MARKUP ALLWD
     C                   MOVE      'Y'           #CNTCD
      *
     C     #OUM          IFEQ      IMPUOM
     C                   Z-ADD(H)  CPCPRC        #PRC
     C                   END
     C     #OUM          IFEQ      IMSUOM
     C                   Z-ADD(H)  CPBRPC        #PRC
     C                   END
     C     #OUM          IFEQ      IM3UOM
     C                   Z-ADD(H)  CP3RPC        #PRC
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C   91              GOTO      ENDMRK
      *
      * GET ITEM BASE PRICE IF NO PRICE YET
      *
     C     #PRC          IFEQ      *ZEROS
     C                   MOVE      PRICD         X                 1 0
      ** CHECK X FOR LESS THAN 6 AND GT 0
     C     X             IFLT      1
     C                   Z-ADD     1             X
     C                   END
     C     X             IFGT      5
     C                   Z-ADD     5             X
     C                   END
      *
     C     #OUM          IFEQ      IMPUOM
      *
     C     IP1(X)        IFEQ      *ZEROS
     C                   Z-ADD(H)  IP1(1)        #PRC
     C                   ELSE
     C                   Z-ADD(H)  IP1(X)        #PRC
     C                   END
      *
     C                   END
      *
     C     #OUM          IFEQ      IMSUOM
     C     IP2(X)        IFEQ      *ZEROS
     C                   Z-ADD(H)  IP2(1)        #PRC
     C                   ELSE
     C                   Z-ADD(H)  IP2(X)        #PRC
     C                   END
     C                   END
      *
     C     #OUM          IFEQ      IM3UOM
     C     IP3(X)        IFEQ      *ZEROS
     C                   Z-ADD(H)  IP3(1)        #PRC
     C                   ELSE
     C                   Z-ADD(H)  IP3(X)        #PRC
     C                   END
     C                   END
     C                   END
      *
      * DETERMINE IF QUANTITY DISCOUNT AVAILABLE
      *
     C     OIFRQD        IFNE      'Y'
     C     CMQDIS        ANDEQ     'Y'
     C                   Z-ADD     1             X
     C     #BPQTY        LOOKUP    IDQ(X)                               9090
     C   90              MOVE      IDP(X)        #DISC
     C                   END
     C     VOLDSC        IFGT      #DISC
     C***        COEVD     ANDNE'N'
     C                   Z-ADD     VOLDSC        #DISC
     C                   END
     C     SLPRC         TAG
      ** 9/04/96
     C     #DISC         IFGT      0.0
     C     #DISC         DIV(H)    100           #DPC              5 4
     C     1.0000        SUB       #DPC          #DCPA             5 4
     C                   MULT(H)   #DCPA         #PRC
     C                   Z-ADD     0             #DISC
     C                   END
      ** 9/04/96
      *
      * DETERMINE IF MARKUP IS AVAILABLE
      *
     C**                   MOVE #CTYP     PCKEY   4
      *
     C     CLKEY         KLIST
     C                   KFLD                    CMCUST
     C                   KFLD                    IMPCL2
     C     CLKEY         CHAIN     FMCCLT                             98
      *
     C  N98CLSTAT        IFNE      'D'
     C                   MOVE      CLCTYP        #CTYP
     C                   END
      *
     C     PCKEY         KLIST
     C                   KFLD                    IMPCL2
     C                   KFLD                    CLCTYP
     C**                   KFLD           IMWHSE
     C     PCKEY         CHAIN     FMPCLS                             98
      *
     C  N98PCSTAT        IFNE      'D'
     C                   Z-ADD     1             X
     C     #BPQTY        LOOKUP    PQN(X)                             90  90
     C  N90              GOTO      ENDMRK
      *
     C     PCT(X)        IFNE      *ZEROS
     C     PCT           DIV       100           PCT4
     C     #PRC          MULT(H)   PCT4(X)       #PRC
     C                   ELSE
     C                   Z-ADD(H)  PC$(X)        #PRC
     C                   END
     C                   END
      *
     C     ENDMRK        TAG
      *
      * CONVERT PRICE FROM BASE PRICE U/M TO ORDERED U/M
      *
     C                   Z-ADD     #PRC          #WRFPR
     C                   MOVE      IMBPUM        #WRFUM
     C                   EXSR      #CVSP
      *
     C     #OUM          IFEQ      IMPUOM
     C                   Z-ADD(H)  #WPR1         #OPRC
     C                   END
      *
     C     #OUM          IFEQ      IMSUOM
     C                   Z-ADD(H)  #WPR2         #OPRC
     C                   END
      *
     C     #OUM          IFEQ      IM3UOM
     C                   Z-ADD(H)  #WPR3         #OPRC
     C                   END
      *
     C     IMCWTF        IFEQ      'Y'
     C                   Z-ADD     #PRC          #OPRC                          ALREADY IN LBS.
     C                   END
      *
     C     ENDPRC        TAG
     C                   MOVE      *ZEROS        *IN
     C                   SETON                                        LR
     C**                   RETRN
      *
      *  ***********
      *  * #CVQT   *
      *  ***********
     C     #CVQT         BEGSR
      * QUANITITY CONVERSION SUBROUTINE
      * #WRFUM - CONTAINS ENTERED UNIT OF MEASURE
      * #WRFQT - CONTAINS ENTERED QUANITITY
      *
     C     *LIKE         DEFINE    IMQTOH        #WQT1
     C     *LIKE         DEFINE    IMQTOH        #WQT2
     C     *LIKE         DEFINE    IMQTOH        #WQT3
     C     *LIKE         DEFINE    IMUWGT        #WQT#
     C     *LIKE         DEFINE    IMUWGT        #WQR#
     C     *LIKE         DEFINE    IMUWGT        WKWGT2
     C     *LIKE         DEFINE    IMUWGT        WKWGT3
     C     *LIKE         DEFINE    IMQTOH        #WRFQT
     C     *LIKE         DEFINE    IMPUOM        #WRFUM
      *
      *  UNIT OF MEASURE EQUAL TO PRIMARY UNIT OF MEASURE
      *
     C     #WRFUM        IFEQ      IMPUOM
      *
     C                   Z-ADD     #WRFQT        #WQT1
     C                   Z-ADD     IMUWGT        #WQR#
     C     #WRFQT        MULT(H)   IMUWGT        #WQT#
      *
     C     IMSUOM        IFNE      *BLANKS
      *
     C     #WQT1         MULT(H)   IMMULT        #WQT2
      *
     C                   END
      *
     C     IM3UOM        IFNE      *BLANKS
      *
     C     #WQT2         MULT(H)   IMMUL2        #WQT3
      *
     C                   END
      *
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO SECONDARY UNIT OF MEASURE
      *
     C     #WRFUM        IFEQ      IMSUOM
      *
     C     IMMULT        IFGT      0
     C     IMUWGT        DIV(H)    IMMULT        WKWGT2
     C                   Z-ADD     WKWGT2        #WQR#
     C                   Z-ADD     #WRFQT        #WQT2
     C     #WQT2         MULT(H)   WKWGT2        #WQT#
      *
     C     #WQT2         DIV(H)    IMMULT        #WQT1
     C                   END
      *
     C     IM3UOM        IFNE      *BLANKS
      *
     C     #WQT2         MULT(H)   IMMUL2        #WQT3
      *
     C                   END
      *
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO THIRD UNIT OF MEASURE
      *
     C     #WRFUM        IFEQ      IM3UOM
      *
     C     IMMULT        IFGT      0
     C     IMMUL2        ANDGT     0
     C     IMUWGT        DIV(H)    IMMULT        WKWGT2
     C     WKWGT2        DIV(H)    IMMUL2        WKWGT3
     C                   Z-ADD     WKWGT3        #WQR#
      *
     C                   Z-ADD     #WRFQT        #WQT3
     C     #WQT3         MULT(H)   WKWGT3        #WQT#
      *
     C     #WQT3         DIV(H)    IMMUL2        #WQT2
      *
     C     #WQT2         DIV(H)    IMMULT        #WQT1
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDSR
      *
      *  ***********
      *  * #CVSP   *
      *  ***********
      * CONVERT SELLING PRICE TO PRICE IN ALTERNATE UNITS OF MEASURE
      * LOAD PRICE INTO FIELD #WRFPR
      * LOAD UNIT OF MEASURE INTO #WRFUM
      *
     C     #CVSP         BEGSR
     C     *LIKE         DEFINE    IP1(1)        #WRFPR
     C     *LIKE         DEFINE    IP1(1)        #WPR1
     C     *LIKE         DEFINE    IP1(1)        #WPR2
     C     *LIKE         DEFINE    IP1(1)        #WPR3
     C**         *LIKE     DEFN IMPUOM    #WRFUM
      *
     C                   Z-ADD     0             #WPR1
     C                   Z-ADD     0             #WPR2
     C                   Z-ADD     0             #WPR3
      *
      *  UNIT OF MEASURE EQUAL TO PRIMARY UNIT OF MEASURE
     C     #WRFUM        IFEQ      IMPUOM
     C                   Z-ADD     #WRFPR        #WPR1
     C     IMSUOM        IFNE      *BLANKS
     C     #WRFPR        DIV(H)    IMMULT        #WPR2
     C     IM3UOM        IFNE      *BLANKS
     C     #WPR2         DIV(H)    IMMUL2        #WPR3
     C                   END
     C                   END
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO SECONDARY UNIT OF MEASURE
     C     #WRFUM        IFEQ      IMSUOM
     C                   Z-ADD     #WRFPR        #WPR2
     C     #WPR2         MULT(H)   IMMULT        #WPR1
     C     IM3UOM        IFNE      *BLANKS
     C     #WPR2         DIV(H)    IMMUL2        #WPR3
     C                   END
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO THIRD UNIT OF MEASURE
     C     #WRFUM        IFEQ      IM3UOM
     C                   Z-ADD     #WRFPR        #WPR3
     C     #WRFPR        MULT(H)   IMMUL2        #WPR2
     C     #WPR2         MULT(H)   IMMULT        #WPR1
     C                   END
      *
      *  ITEM IS CATCH WEIGHT - PRICE IS PER POUND
     C     IMCWTF        IFEQ      'Y'
      *
     C     IMUWGT        MULT(H)   #WRFPR        #WPR1
      *
     C     IMMULT        IFNE      *ZEROS
     C     #WPR1         DIV(H)    IMMULT        #WPR2
     C                   END
      *
     C     IMMUL2        IFNE      *ZEROS
     C     #WPR2         DIV(H)    IMMUL2        #WPR3
     C                   END
      *
     C                   END
      *
     C                   ENDSR
