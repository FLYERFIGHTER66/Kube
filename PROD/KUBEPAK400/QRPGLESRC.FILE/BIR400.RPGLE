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
      *PROGRAM NAME-------- BIR400  -  OPEN ORDERS BY CUSTOMER/SHIPDAT
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS LINE ITEMS LISTED BY ITEM,
      *                     SHIP DATE AND CUSTOMER
      *
      *
      *   CHANGE--DATE-------DESCRIPTION
      *
      *
     FIORCUSDT  IF   F   75        DISK
     FFHORDR    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFARHST    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FBIR400    O    F  132        PRINTER OFLIND(*INOF)
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
     D  BEGDTE                 1      6  0
     D  ENDDTE                 7     12  0
     D  BEGCLS                13     14
     D  ENDCLS                15     16
      *
     IIORCUSDT  NS
     I                                  1    6 0OIDTRQ
     I                                  7   12 0OHCUST
     I                                 13   18 0OIORD#
     I                                 19   30  OIITEM
     I                                 31   33  OISIZE
     I                                 34   36  OIWHSE
     I                                 37   38  OIUUOM
     I                                 39   47 4OIUPRI
     I                                 48   56 2OIEXT$
     I                             P   57   62 1OIQORD
     I                             P   63   68 1OIQSHP
     I                             P   69   74 1OIQBOO
     I                                 75   75  OHCOFL
      *
     C*
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
     C     BEGDTE        MULT      10000.01      SDATE             6 0
     C     ENDDTE        MULT      10000.01      EDATE             6 0
      *
     C                   Z-ADD     1             ORD                            ORDER TOTAL
     C                   Z-ADD     1             ORDC                           CUST TOTAL
     C                   Z-ADD     1             FIRST             2 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      IORCUSDT                               77
     C     BEGDTE        MULT      10000.01      STDATE            6 0
     C     ENDDTE        MULT      10000.01      ENDATE            6 0
     C                   MOVE      BEGCLS        CLASS1            2
     C                   MOVE      ENDCLS        CLASS2            2
      *
     C     CLASS2        IFEQ      *BLANKS
     C                   MOVE      '99'          CLASS2
     C                   END
      *
     C   L2              SETOFF                                       4199
     C   L2OICUST        CHAIN     FMCUST                             55
     C   L2OICUST        CHAIN     FARHST                             55
     C   L2
     CANN55              MOVE      CMPHON        HLPHON           10 0
     C   L2
     CANN55HSINCL        COMP      'N'                                    99
     C   L2
     CAN 99              GOTO      END
     C   L2              MOVE      *BLANKS       ADR
     C   L2              SETON                                        77
      *  L2N55             EXSR ADDRTN
     C   L2
     CANN55              Z-ADD     CMARCU        WKCUST            6 0          GET A/R CUST #
     C   L1              EXSR      CHKREC
     C   L1              SETOFF                                       40
      ** IF MARKED NO GOTO END
     C   99              GOTO      END
      *
     C   OF              EXCEPT    HDG
      *
     C                   SETOFF                                       50
      *
     C     RECFLG        IFEQ      '1'
      *
      * CHECK IF DATE IF GT BEG DATE
     C     OIDTRQ        MULT      10000.01      CDATE             6 0
     C     CDATE         COMP      STDATE                               11
      ******   CHECK IF ORDER HEADER RECORD EXISTS, IF NOT, DO NOT PRINT
      *
     C  N11OIORD#        CHAIN     HORDR                              11
      *
      ****** CHECK IF CLOSED ORDER OR DELETED ORDER, IF SO, DO NOT PRINT
      *
     C  N11OHCOFL        COMP      'Y'                                    11
     C  N11OHSTAT        COMP      'D'                                    11
     C   11              GOTO      END
      *
      ******  CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
     C     OIITYP        COMP      'C'                                    51
     C  N51OIITYP        COMP      'F'                                    51
     C  N51OIITYP        COMP      'S'                                    51
     C   51OIITYP        COMP      'C'                                    22
     C  N22
     CAN 51              ADD       OIEXT$        DAYTOT
     C  N22
     CAN 51              ADD       OIEXT$        CUSTOT
     C  N22
     CAN 51              ADD       OIEXT$        FINTOT
     C   51
     CAN 77              EXSR      ADDRTN
      *  51 OF             EXCPTH1
     C   51
     CAN 77
     COR 51
     CAN OF              EXCEPT    P2
     C   51              SETOFF                                           77
     C   51              EXCEPT    COMML
     C   51              GOTO      END
      *
      ****** CHECK IF QTY SHIPPED >= QTY ORDERED, DO NOT PRINT
      *
     C     OIQSHP        COMP      OIQORD                             33  33
     C   33              GOTO      END
      *
      * CHECK PRODUCT CLASS RANGE
     C                   SETOFF                                       61
     C     ENDCLS        IFGT      *BLANKS
     C                   MOVEL     OIITEM        ITKEY            18
     C                   MOVE      OIWHSE        ITKEY
     C     ITKEY         CHAIN     MINVT                              61
     C  N61IMPCL1        COMP      BEGCLS                               61
     C  N61IMPCL1        COMP      ENDCLS                             61
     C                   END
     C   61              GOTO      END
      *
      ******   SET ON GOOD RECORD INDICATOR
      *
     C                   SETON                                        404150
      ******   COMPUTE PRICE
      ******   (DISCOUNTED PRICE IF DISCOUNT APPLICABLE)
      ******   (CHECK CATCH WEIGHT FLAG)
      *
     C     OIQORD        SUB       OIQSHP        #WRFRQ                         QTY OPEN
     C                   Z-ADD     OIUPRI        #PRC
     C                   Z-ADD     OIQDDC        #DISC
     C                   Z-ADD     OIUWGT        #WKWGT
     C                   MOVE      OICWT         #CWFLG
     C                   EXSR      #EXLNO
      *
      ******   ACCUMULATE DATE,CUSTOMER AND FINAL TOTALS
      *
     C                   Z-ADD     OIQORD        WRKORD            7 1
     C                   Z-ADD     OIQSHP        WRKSHP            7 1
     C                   Z-ADD     #WRFRQ        WRKFRQ            7 1
     C                   ADD       #LINNT        DAYTOT           11 2
     C                   ADD       #LINNT        CUSTOT           11 2
     C                   ADD       #LINNT        FINTOT           12 2
     C     WRKORD        ADD       ORCTOT        ORCTOT            9 1
     C     WRKSHP        ADD       SHCTOT        SHCTOT            9 1
     C     WRKFRQ        ADD       OPCTOT        OPCTOT            9 1
     C     WRKORD        ADD       ORGTOT        ORGTOT            9 1
     C     WRKSHP        ADD       SHGTOT        SHGTOT            9 1
     C     WRKFRQ        ADD       OPGTOT        OPGTOT            9 1
     C                   MOVE      *ZEROS        #WRFRQ
     C                   Z-ADD     OIUPRI        SPRI              9 2
      **01/12/93 START
     C                   MOVE      *BLANKS       OUTB              1
     C     OIBOLN        IFEQ      'B'
     C                   MOVE      'B'           OUTB
     C                   END                                                    OIBOLN=B
     C     OIPRBO        IFEQ      'B'
     C                   MOVE      'B'           OUTB
     C                   END                                                    OIPRBO=B
      **01/12/93 END
      *
     C   50
     CAN OF              EXCEPT    H1
     C   77
     CAN 50              EXSR      ADDRTN
     C   77
     CAN 50
     COR OF              EXCEPT    P2
      *
     C   50              EXCEPT    P1
     C   50              SETOFF                                       77
      *  50                EXSR GETCOM
     C   50              MOVE      *ZEROS        OIORD#
      *
     C                   END
      *
     C     END           TAG
      *
      *  CHECK IF CUSTOMER EXCEEDS CREDIT LIMIT
      *
     CL2   WKCUST        CHAIN     MCUST                              55
     CL2   CUSTOT        ADD       CMARB$        CRTVAL           11 2
     CL2   CRTVAL        COMP      CMCRL$                             56
      *
     C     #EXLNO        BEGSR
      *
      *  SUBROUTINE #EXLNO IS USED TO EXTEND THE VALUE OF A ORDER DETAIL
      *  LINE
      *  USE THIS SUBROUTINE WHEN FIELD DEFINITIONS FROM IORDR ARE REQ'D
      *
      *  USER WILL NEED TO LOAD FIELDS AS FOLLOWS
      *       #WRFRQ    CONTAINS QUANTITY
      *       #PRC      CONTAINS PRICE
      *       #DISC     CONTAINS QUANTITY DISCOUNT PCT.
      *       #WKWGT    CONTAINS WEIGHT PER UNIT OF MEASURE
      *       #CWFLG    CATCH WEIGHT ITEM 'Y' OR 'N'
      *
      *       SUBROUTINE WILL RETURN THE FOLLOWING:
      *
      *       #LINGR    EXTENDED GROSS AMOUNT
      *       #LINNT    EXTENDED NET AMOUNT
      *       #LINDS    DISCOUNT DOLLAR AMOUNT
      *
      *
     C                   Z-ADD     #WRFRQ        #WRFRQ           11 1
     C                   Z-ADD     #PRC          #PRC              9 4
     C                   Z-ADD     #DISC         #DISC             4 2
     C                   Z-ADD     #WKWGT        #WKWGT           11 4
     C                   MOVE      #CWFLG        #CWFLG            1
      *
     C     #CWFLG        IFEQ      'Y'
     C     #WRFRQ        MULT(H)   #WKWGT        #WRFRQ
     C                   END
      *
      *  EXTEND GROSS AMOUNT
      *
     C     #WRFRQ        MULT      #PRC          #LINGR            9 2
      *
      *  ADJUST FOR DISC. PCT.
      *
     C     #DISC         IFNE      *ZEROS
     C                   MOVE      #DISC         WKDISC            4 4
     C     1             SUB       WKDISC        WKDISC
     C     #PRC          MULT      WKDISC        #PRC
     C                   END
      *
      *  CALCULATE LINE NET AMOUNT
      *
     C     #WRFRQ        MULT      #PRC          #LINNT            9 2
      *
      *  CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       #LINNT        #LINDS            7 2
      *
     C                   ENDSR
      *   **************************************
      *   * ADDRTN - CONCANT  ADDRESS FIELDS
      *   **************************************
     C     ADDRTN        BEGSR
     C                   MOVEL     OHSVIA        WRKVIA           25
     C                   MOVE      OHSVI2        WRKVIA
      *
     C                   MOVE      OHNAME        SHNAME           30
     C                   Z-ADD     1             Z                 3 0
     C     OHSHP2        IFGT      *BLANKS
     C                   MOVEA     OHSHP2        ADR
     C                   Z-ADD     30            Z
     C     ADR(Z)        DOWEQ     *BLANK
     C                   SUB       1             Z
     C                   END
     C                   ADD       2             Z
     C                   END
      *
     C     OHSHP3        IFGT      *BLANKS
     C                   MOVEA     OHSHP3        WF
     C                   Z-ADD     30            X                 2 0
     C     WF(X)         DOWEQ     *BLANKS
     C                   SUB       1             X
     C                   END
      *
     C                   DO        X             #I                2 0
     C                   MOVE      WF(#I)        ADR(Z)
     C                   ADD       1             Z
     C                   END
     C                   ADD       1             Z
     C                   END
      *
     C     OHSHP4        IFGT      *BLANKS
     C                   MOVEA     OHSHP4        WF
     C                   Z-ADD     30            X                 2 0
     C     WF(X)         DOWEQ     *BLANKS
     C                   SUB       1             X
     C                   END
      *
     C                   DO        X             #I
     C                   MOVE      WF(#I)        ADR(Z)
     C                   ADD       1             Z
     C                   END
     C                   ADD       1             Z
     C                   END
      *
     C                   MOVE      *BLANKS       WF
     C     OHSHCT        IFGT      *BLANKS
     C                   MOVEA     OHSHCT        WF
     C                   Z-ADD     17            X                 2 0
     C     WF(X)         DOWEQ     *BLANKS
     C                   SUB       1             X
     C                   END
      *
     C                   DO        X             #I
     C                   MOVE      WF(#I)        ADR(Z)
     C                   ADD       1             Z
     C                   END
     C                   ADD       1             Z
     C                   END
     C                   MOVE      *BLANKS       WF
     C     OHSHST        IFGT      *BLANKS
     C                   MOVEA     OHSHST        WF
     C                   Z-ADD     2             X                 2 0
     C     WF(X)         DOWEQ     *BLANKS
     C                   SUB       1             X
     C                   END
      *
     C                   DO        X             #I
     C                   MOVE      WF(#I)        ADR(Z)
     C                   ADD       1             Z
     C                   END
     C                   ADD       1             Z
     C                   END
      *
     C                   MOVE      *BLANKS       WF
     C     OHSHZP        IFGT      *BLANKS
     C                   MOVEA     OHSHZP        WF
     C                   Z-ADD     9             X                 2 0
      *
     C                   DO        X             #I
      *
     C     #I            IFEQ      6
     C     WF(#I)        IFGT      *BLANKS
     C                   MOVE      '-'           ADR(Z)
     C                   ADD       1             Z
     C                   END
     C                   END
      *
     C                   MOVE      WF(#I)        ADR(Z)
     C                   ADD       1             Z
     C                   END
     C                   END
     C                   ENDSR
      *************************************************************
      *                                                           *
      * CHKREC -- CHECK IF STOCK ITEMS EXIST WITHIN SELECTION     *
      *           CRITERIA.                                       *
      *************************************************************
     C     CHKREC        BEGSR
     C                   MOVE      *BLANKS       CDXKEY           21
     C                   MOVE      *BLANKS       CDXKY1           12
     C                   MOVE      *BLANKS       RECFLG            1
     C     OIDTRQ        MULT      10000.01      REVDAT            6 0
     C     REVDAT        IFLE      ENDATE
     C     REVDAT        IFGE      STDATE
     C                   MOVEL     OICUST        CDXKY1
     C                   MOVE      REVDAT        CDXKY1
     C                   MOVEL     CDXKY1        CDXKEY
     C     CDXKEY        SETLL     IOCDX
     C     LOOP          TAG
     C                   SETOFF                                       21
     C                   READ      IOCDX                                  21
     C  N21LICUST        COMP      OICUST                             2121
     C  N21LIDTRQ        COMP      OIDTRQ                             2121
     C   21              GOTO      ENDCHK
      *
     C     LISTAT        IFEQ      'A'
     C     LIITYP        IFEQ      ' '
     C                   MOVEL     LIITEM        ITKEY
     C                   MOVE      LIWHSE        ITKEY
     C     ITKEY         CHAIN     MINVT                              61
     C  N61              MOVE      IMPCL1        LIPRCL
     C                   END
     C                   END
      *
     C     LISTAT        IFEQ      'A'
     C     LIITYP        IFEQ      ' '
     C     LIPRCL        IFGE      CLASS1
     C     LIPRCL        IFLE      CLASS2
     C     LIQSHP        IFLT      LIQORD
     C                   MOVE      '1'           RECFLG
     C                   GOTO      ENDCHK
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   GOTO      LOOP
     C                   END
     C                   END
      *
     C     ENDCHK        ENDSR
     OBIR400    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                       PAGE          Z    120
     O                                          114 'Page'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           55 'Open Orders By'
     O                                           74 'Customer/Ship Date'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           58 'Reqd'
     O                                           73 'Unit'
     O                                           84 'Unit'
     O                                           93 'Orig.'
     O                                          107 'Qty Shipped'
     O                                          119 'Quantity'
     O                                          132 'Open Order'
     O          E            HDG            1
     O                                           11 'Order /Seq#'
     O                                           16 'Item'
     O                                           20 'B/O'
     O                                           36 'Description'
     O                                           62 'Ship Date UM'
     O                                           74 'Weight'
     O                                           84 'Price'
     O                                           95 'Qty Ord.'
     O                                          105 'To Date'
     O                                          117 'Open'
     O                                          129 'Value'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            P2          1  0
     O                                            5 'Cust:'
     O                       OICUST        Z     12
     O                       SHNAME              43
     O                                           50 'Phone:'
     O                       HLPHON              65 '   -   -    '
     O                                           78 'Ship Via:'
     O                       WRKVIA             104
     O          E            P2          1  0
     O                                            5 'Addr:'
     O                       ADR                132
     O          E            P2             2
     O                                           24 '________________________'
     O                                           47 '_______________________'
     O                                           69 '______________________'
     O          E            P1             1
     O                       OIORD#        Z      6
     O                       OISEQ#              11 ' 0. '
     O                       ITEM                17
     O                       OUTB                19
     O                       DESC           B    50
     O                       OIDTRQ        Y     59
     O                       OIUUOM              62
     O                       OIUWGT        4     74
     O                       SPRI          4     84
     O                       WRKORD        4     95
     O                       WRKSHP        4    107
     O                       WRKFRQ        4B   119
     O                       #LINNT        4B   132
     O          E            COMML          1
     O                       OIORD#        Z      6
     O                       OISEQ#              11 ' 0. '
     O                       OIDES1              50
     O                 N22   OIEXT$        4    132
     O          T    L1 40               1  2
     O                                           61 'TOTAL VALUE FOR DAY'
     O                       OIDTRQ        Y     71
     O                       DAYTOT        4B   132
     O          T    L2 41N99               1
     O                                           61 'Total Value For Customer'
     O                       OICUST        Z     74
     O                       ORCTOT        4B    95
     O                       SHCTOT        4B   107
     O                       OPCTOT        4B   119
     O                       CUSTOT        4B   132
     O          T    L2 41N99               1
     O                                          111 'A/R OPEN BALANCE'
     O                       CMARB$        4    132
     O          T    L2 41N99               1
     O                                          111 'CREDIT LIMIT'
     O                       CMCRL$        4    132
     O          T    L2 41 56               2
     O         AND  N99
     O                                          127 'EXCEEDS CREDIT LIMIT'
     O                                          132 '***'
     O          E            TLR         2
     O                                           71 'Report Totals:'
     O                       ORGTOT        4B    95
     O                       SHGTOT        4B   107
     O                       OPGTOT        4B   119
     O                       FINTOT        4B   132
