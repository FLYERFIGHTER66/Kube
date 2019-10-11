      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR315
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- PRE INVOICE REGISTER
      *
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFHORDRR   IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFFRTYP    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMTAXF    IF   E           K DISK
     FBIR315    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #SL             S             32    DIM(5)
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
     D  LBRTE                  3      4
     D  LERTE                  5      6
     D  LBSHFR                43     45
     D  LESHFR                46     48
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
     IRHORDR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
     I              OHSLD1                      #WSLD1
     I              OHSLD2                      #WSLD2
     I              OHSLD3                      #WSLD3
     I              OHSLD4                      #WSLD4
     I              OHSLCT                      #WSLCT
     I              OHSLST                      #WSLST
     I              OHSLZP                      #WSLZP
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
      * GET FIRST INVOICE NUMBER
      *
     C     LCO           CHAIN(N)  FMCORG                             50
     C     LCO           CHAIN(N)  FMCOMP                             50
     C                   Z-ADD     MCNINV        INVC#             6 0
      *
      * READ HORDR
      *
     C                   MOVEL     'R'           CODE              1
     C     CODE          SETLL     FHORDRR
     C     RSTRT         TAG
     C     NXT           TAG
     C                   READ      FHORDRR                                90
     C   90              GOTO      ENDP
     C                   Z-ADD     *ZEROS        TRDDIS
     C                   Z-ADD     *ZEROS        QTYDIS
     C     OHHOLD        IFNE      'R'
     C                   GOTO      ENDP
     C                   ENDIF
      *
     C     OHSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     OHDTAC        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DTAC              6 0
      *
     C   62OHSHFR        IFLT      LBSHFR
     C     OHSHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHSHPC        CHAIN     FMSVIA                             90
      *
     C     OHPPCD        CHAIN     FFRTYP                             90
     C   90              MOVEL     *BLANKS       FRDESC
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
      *
     C                   EXCEPT    HDG
      *
      * SET LOWER LIMITS ON THE ORDER LINE ITEM FILE.  ANY RECORD WITH
      * A SHIP CODE OF 'R' WILL BE INVOICED.
      *
     C     OHORD#        SETLL     FIORDR
     C     NXTI          TAG
     C                   SETOFF                                       214142
     C                   SETOFF                                       434445
     C                   READ      RIORDR                                 77
     C   77              GOTO      HEADER
      *
     C     OIORD#        IFNE      OHORD#
     C                   GOTO      HEADER
     C*                    EXCPTTL1
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OICOFL        IFEQ      'Y'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OISHCD        IFEQ      'H'
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * TAXABLE STATUS OF ORDER   40 = NON TAXABLE
      *
     C     OHTXST        IFEQ      'Y'
     C                   SETON                                        40
     C                   GOTO      NOTAX
     C                   ENDIF
      *
     C     OHTXJU        CHAIN     FMTAXF                             50
     C     NOTAX         TAG
      *
     C     OIITYP        IFEQ      ' '
     C                   SETON                                        44
     C                   ENDIF
     C     OIITYP        IFEQ      'C'
     C                   SETON                                        41
     C                   GOTO      SKIP
     C                   ENDIF
     C     OIITYP        IFEQ      'F'
     C                   SETON                                        42
     C     OIQINV        MULT      OIUPRI        ITMNET            9 2
     C                   ADD       ITMNET        NETAMT            9 2
     C                   ENDIF
     C     OIITYP        IFEQ      'S'
     C                   SETON                                        43
     C                   ENDIF
     C   42
     COR 43              GOTO      ARND
      *
      * CHECK FOR BACKORDER AMOUNTS ON RELEASED LINE ITEMS
      *
     C     OIQBOO        IFEQ      *ZEROS
     C                   SETON                                        45
     C                   ENDIF
     C     OIITYP        IFEQ      'N'
     C                   MOVEL     'NON-STOC'    INVWK             9
     C                   MOVE      'K'           INVWK
     C                   MOVEL     INVWK         OIITEM
     C                   ENDIF
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             50
     C                   EXSR      GETDES
     C  N50              Z-ADD     IMUCST        OIUCST                         CURRENT COST
      *
      * DO PRICING CALCULATIONS AND ACCUMULATE TOTALS
      *
      * CHECK IF A SHIP QTY EXISTS
      *
     C     OIQINV        IFEQ      *ZEROS
     C                   Z-ADD     0             SVQORD
     C                   Z-ADD     0             SVQINV
     C                   Z-ADD     0             SVQBOO
     C                   GOTO      SKIP
     C                   ENDIF
      *
     C                   Z-ADD     OIQORD        SVQORD            7 1
     C                   Z-ADD     OIQINV        SVQINV            9 1
     C                   Z-ADD     OIQBOO        SVQBOO            9 1
      *
      * CALCULATE GROSS AMT, NET AMT, DISCOUNT AMOUNT
      *
     C  N44              GOTO      NOITEM
     C*          OIQORD    SUB  OIQSHP    QTYORD           OPEN QTY
     C                   Z-ADD     OIQINV        QTYORD
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
     C                   Z-ADD     #LINNT        VEXT              9 2
     C                   Z-ADD     #LINGR        EXT               9 2
     C                   Z-ADD     #LINNT        ITMNET            9 2
     C                   Z-SUB     #LINDS        QDA               7 2  32
     C     NOITEM        TAG
      *
     C                   ADD       EXT           MRCH$             9 2
     C                   ADD       ITMNET        NETAMT            9 2
     C                   ADD       QDA           QTYDIS            7 2  33
      *
      * ACCUMULATE TAXABLE AMOUNTS AS REQUIRED
      *
     C   40              GOTO      TXPASS
      *
     C     OITXCD        COMP      'N'                                    56
     C   56              GOTO      TXPASS
      *
     C     OITXST        COMP      'Y'                                    57
     C     OITXCT        COMP      'Y'                                    58
     C     OITXLC        COMP      'Y'                                    59
     C   57ITMNET        ADD       WKTAX1        WKTAX1
     C   58ITMNET        ADD       WKTAX2        WKTAX2
     C   59ITMNET        ADD       WKTAX3        WKTAX3
      *
     C     TXPASS        TAG
      *
     C                   MOVEL     OIUUOM        #WRFUM                         CONVERT QTY
     C                   Z-ADD     OIQINV        #WRFQT                         INVOICED INTO
     C                   EXSR      #CVQT                                        PRIMARY U/M
     C                   Z-ADD     #WQT1         SVQINV            9 1
      *
      * ADD FREIGHT AND SPECIAL CHARGES TO TOTALS.
      *
     C     ARND          TAG
     C   42              Z-ADD     OIEXT$        FRGHT             7 2
     C   42              ADD       FRGHT         FRT               7 2
     C   42              Z-ADD     OIEXT$        EXT
     C   42OHFRTX        COMP      'Y'                                    52
     C   42
     CAN 52
     CAN 40              EXSR      ACCOX
      *
     C   43              Z-ADD     OIEXT$        SPCHGE            7 2
     C   43              ADD       SPCHGE        SPECL             7 2
     C   43              Z-ADD     OIEXT$        EXT
     C   43OHSPTX        COMP      'Y'                                    52
     C   43
     CAN 52
     CAN 40              EXSR      ACCOX
      *
     C     SKIP          TAG
      *
     C   OF              EXCEPT    CONT1
     C   OF              EXCEPT    HDG
      *
     C     OISIZE        IFEQ      'ROY'
     C                   Z-ADD     0             SVQORD
     C                   Z-ADD     0             SVQINV
     C                   Z-ADD     0             SVQBOO
     C                   END
     C     OIUUOM        IFGT      *BLANKS
     C                   SETON                                        21
     C                   ENDIF
      *
     C                   EXCEPT    DETAIL
      *
      * CALCULATE TOTAL INVOICE AMOUNT
      *
     C                   ADD       OIEXT$        INVAMT           11 2
     C                   ADD       STTAX         INVAMT
     C                   ADD       COTAX         INVAMT
     C                   ADD       CYTAX         INVAMT
     C                   ADD       FRT           INVAMT
     C                   ADD       SPECL         INVAMT
      *
      * CLEAR DETAIL LINE ITEM WORK FIELDS AND GO TO BEGINING.
      *
     C                   Z-ADD     0             ITMNET
     C                   Z-ADD     0             EXT
     C                   Z-ADD     0             QDA
     C                   Z-ADD     0             FRGHT
     C                   Z-ADD     0             SPCHGE
      *
     C                   GOTO      NXTI
      *
      * START PROCESSING INVOICE TOTALS
      *
     C     HEADER        TAG
      *
      * CALCULATE TRADE DISCOUNT AMT
      *
     C                   Z-ADD     NETAMT        NETPRC            9 2
     C                   Z-ADD     OHTRDC        DISHLD            4 2    52
     C  N52              MOVE      DISHLD        DISREF            4 4
     C  N521             SUB       DISREF        DISREF
     C  N52NETPRC        MULT      DISREF        NETPRC
     C     NETAMT        SUB       NETPRC        TRDDIS            7 2
     C                   Z-SUB     TRDDIS        TRDDIS
      *
      * ACCUMULATE DISCOUNTS
      *
     C                   ADD       TRDDIS        DISCNT            7 2
     C                   ADD       QTYDIS        DISCNT            7 2
     C                   ADD       DISCNT        INVAMT
      *
      * CALCULATE TAX AMOUNT IF ANY
      *
     C                   Z-ADD     0             TAXAMT            9 2
     C  N40              GOTO      ARNTAX
      *
      * ADJUST ACCUMULATED AMOUNTS FOR TRADE DISC
      *
     C  N52WKTAX1        MULT(H)   DISREF        WKTAX1
     C  N52WKTAX2        MULT(H)   DISREF        WKTAX2
     C  N52WKTAX3        MULT(H)   DISREF        WKTAX3
      *
     C     WKTAX1        COMP      TXLIM1                             37
     C     WKTAX2        COMP      TXLIM2                             38
     C     WKTAX3        COMP      TXLIM3                             39
     C   37              Z-ADD     TXLIM1        WKTAX1
     C   38              Z-ADD     TXLIM2        WKTAX2
     C   39              Z-ADD     TXLIM3        WKTAX3
      *
     C     WKTAX1        MULT(H)   TXPCT1        STTAX             7 2          STATE
     C     WKTAX2        MULT(H)   TXPCT2        COTAX             7 2          COUNTY
     C     WKTAX3        MULT(H)   TXPCT3        CYTAX             7 2          CITY
      *
      * CALCULATE FREIGHT AND SPECIAL CHARGES
      * TAX, IF ANY.  - ACCUMULATE TAXABLE AMOUNTS -
      *
     C     WKFTX1        MULT(H)   TXPCT1        WKFTX1
     C                   ADD       WKFTX1        STTAX
     C     WKSTX1        MULT(H)   TXPCT1        WKSTX1
     C                   ADD       WKSTX1        STTAX
      *
     C     WKFTX2        MULT(H)   TXPCT2        WKFTX2
     C                   ADD       WKFTX2        COTAX
     C     WKSTX2        MULT(H)   TXPCT2        WKSTX2
     C                   ADD       WKSTX2        COTAX
      *
     C     WKFTX3        MULT(H)   TXPCT3        WKFTX3
     C                   ADD       WKFTX3        CYTAX
     C     WKSTX3        MULT(H)   TXPCT3        WKSTX3
     C                   ADD       WKSTX3        CYTAX
      *
     C     ARNTAX        TAG
      *
      * WRITE  INVOICE TOTAL AT BOTTOM
      *
     C                   EXCEPT    TL1
      *
      * INCREMENT NEXT INVOICE NUMBER
      *
     C     INVC#         ADD       1             INVC#
      *
     C     END           TAG
      *
     C                   GOTO      RSTRT
     C     ENDP          TAG
     C                   SETON                                        LR
      ***********
      * ACCOX   *
      ***********
      *
      * DETERMINE & ACCUMULATE TAXES FOR FREIGHT & SPECIAL CHARGES
      *
     C     ACCOX         BEGSR
      *
     C     OITXCD        COMP      'N'                                    56
     C   56              GOTO      XACCOX
      *
     C     OITXST        COMP      'Y'                                    57
     C     OITXCT        COMP      'Y'                                    58
     C     OITXLC        COMP      'Y'                                    59
      *
     C   57
     CAN 42OIEXT$        ADD       WKFTX1        WKFTX1            7 2
     C   57
     CAN 43OIEXT$        ADD       WKSTX1        WKSTX1            7 2
      *
     C   58
     CAN 42OIEXT$        ADD       WKFTX2        WKFTX2            7 2
     C   58
     CAN 43OIEXT$        ADD       WKSTX2        WKSTX2            7 2
      *
     C   59
     CAN 42OIEXT$        ADD       WKFTX3        WKFTX3            7 2
     C   59
     CAN 43OIEXT$        ADD       WKSTX3        WKSTX3            7 2
      *
     C     XACCOX        TAG
      *
     C                   SETOFF                                       565758
     C                   SETOFF                                       59
      *
     C                   ENDSR
      *
      ********
      * CLEAR
      ********
     C     CLEAR         BEGSR
      *
     C                   Z-ADD     0             PAGE
     C                   Z-ADD     0             NETAMT
     C                   Z-ADD     0             NETPRC
     C                   Z-ADD     0             MRCH$
     C                   Z-ADD     0             QTYDIS
     C                   Z-ADD     0             FRT
     C                   Z-ADD     0             SPECL
     C                   Z-ADD     0             STTAX
     C                   Z-ADD     0             COTAX
     C                   Z-ADD     0             CYTAX
     C                   Z-ADD     0             TRDDIS
     C                   Z-ADD     0             DISCNT
     C                   Z-ADD     0             INVAMT
     C                   Z-ADD     0             WKTAX1            9 2
     C                   Z-ADD     0             WKTAX2            9 2
     C                   Z-ADD     0             WKTAX3            9 2
     C                   Z-ADD     0             WK112            11 2
     C                   Z-ADD     0             WKFTX1
     C                   Z-ADD     0             WKFTX2
     C                   Z-ADD     0             WKFTX3
     C                   Z-ADD     0             WKSTX1
     C                   Z-ADD     0             WKSTX2
     C                   Z-ADD     0             WKSTX3
     C                   ENDSR
      *
      ***********
      * #CVQT   *
      ***********
     C     #CVQT         BEGSR
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
      * UNIT OF MEASURE EQUAL TO PRIMARY UNIT OF MEASURE
      *
     C     #WRFUM        IFEQ      IMPUOM
     C                   Z-ADD     #WRFQT        #WQT1
     C                   Z-ADD     IMUWGT        #WQR#
     C     #WRFQT        MULT(H)   IMUWGT        #WQT#
     C                   ENDIF
     C     IMSUOM        IFNE      *BLANKS
     C     #WQT1         MULT(H)   IMMULT        #WQT2
     C                   ENDIF
     C     IM3UOM        IFNE      *BLANKS
     C     #WQT2         MULT(H)   IMMUL2        #WQT3
     C                   ENDIF
      *
      * UNIT OF MEASURE EQUAL TO SECONDARY UNIT OF MEASURE
      *
     C*          #WRFUM    IFEQ IMSUOM
     C*          IMUWGT    DIV  IMMULT    WKWGT2    H
     C*                    Z-ADDWKWGT2    #WQR#
     C*                    Z-ADD#WRFQT    #WQT2
     C*          #WQT2     MULT WKWGT2    #WQT#     H
     C*          #WQT2     DIV  IMMULT    #WQT1     H
     C*                    ENDIF
     C*          IM3UOM    IFNE *BLANKS
     C*          #WQT2     MULT IMMUL2    #WQT3     H
     C*                    ENDIF
      *
      * UNIT OF MEASURE EQUAL TO THIRD UNIT OF MEASURE
      *
     C*          #WRFUM    IFEQ IM3UOM
     C*          IMUWGT    DIV  IMMULT    WKWGT2    H
     C*          WKWGT2    DIV  IMMUL2    WKWGT3    H
     C*                    Z-ADDWKWGT3    #WQR#
     C*                    Z-ADD#WRFQT    #WQT3
     C*          #WQT3     MULT WKWGT3    #WQT#     H
     C*          #WQT3     DIV  IMMUL2    #WQT2     H
     C*          #WQT2     DIV  IMMULT    #WQT1     H
     C*                    ENDIF
      *
     C                   ENDSR
      *
      *********
      * GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             43
     C                   ENDSR
      *
      ***********
      * #SLD    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      ***********
      * #SHP    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SHIP TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
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
     C                   MOVEL     WORK3         WORK2                          19002-1525
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OBIR315    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Pre-Invoice Register'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O*                                   6 ' Inv  '
     O*                                  12 'Inv'
     O                                           44 'Order'
     O                                           56 'Order'
     O                                           68 'Ship'
     O                                           76 'Frt '
     O                                          111 'Ship Via             '
     O          E            HDG            1
     O*                                   6 'Number'
     O*                                  13 'Date'
     O                                           20 'Slsp'
     O                                           33 'P.O. Number'
     O                                           45 'Number'
     O                                           56 'Date'
     O                                           68 'Date'
     O                                           76 'Type'
     O                                          111 'Shipping Instructions'
     O          E            HDG            1
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            HDG            1
     O*                        INVC# Z    6
     O*                        TDATE Y   15
     O                       OHSLM1              19
     O                       OHPONO              37
     O                       OHORD#        Z     45
     O                       OHDTOR        Y     57
     O                       DTAC          Y     69
     O                       OHPPCD              74
     O                       FRDESC              87
     O                       SVDESC             120
     O          E            HDG            1
     O                       OHSHIN             120
     O          E            HDG            1
     O                                            8 'Sold To:'
     O                       OHBLCU        Z     16
     O                                           58 'Ship To:'
     O                       OHCUST        Z     66
     O          E            HDG            1
     O                       #SL(1)              42
     O                       #SH(1)              92
     O          E            HDG            1
     O                       #SL(2)              42
     O                       #SH(2)              92
     O          E            HDG            1
     O                       #SL(3)              42
     O                       #SH(3)              92
     O          E            HDG            1
     O                       #SL(4)              42
     O                       #SH(4)              92
     O          E            HDG            1
     O                       #SL(5)              42
     O                       #SH(5)              92
     O          E            HDG            1
     O                                            6 'Terms:'
     O                       OHTERM              38
     O          E            HDG            1
     O                                           26 '- - - - Quantity - - - -'
     O                                           99 'Ordered/'
     O*                                 107 'Unit'
     O          E            HDG            1
     O                                            9 'Ordered'
     O                                           18 'Shipped'
     O                                           26 'B/O'
     O                                           33 'Item'
     O                                           43 'Size'
     O                                           48 'Loc'
     O                                          100 'Pricing UM'
     O                                          108 'Price'
     O                                          119 'Amount'
     O          E            HDG            2
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            DETAIL         1
     O              N41N43N42SVQBOO        4     27
     O              N41N43N42SVQINV        4     18
     O              N41N43N42SVQORD        4      9
     O                       OIITEM              41
     O                       OISIZE              44
     O*                   32             52 '*'
     O                       OIWHSE              48
     O               44      DESP                92
     O               41      OIDES1              79
     O               42      OIDES1              79
     O               43      OIDES1              79
     O                       OIUUOM              95
     O               21                          96 '/'
     O                       OIBPUM              98
     O                       OIUPRI        4    108
     O*                        OIEXT$4  120
     O                       ITMNET        M    120
     O          E            CONT1       1
     O                                           51 '* * Continued'
     O                                           68 'On Next Page * *'
     O          E            TL1         1  1
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            TL1            2
     O                                           20 'Merchandise'
     O                                           32 'Discount*'
     O                                           45 'Freight'
     O                                           65 'Special Charge'
     O                                           75 'State'
     O                                           85 'County'
     O                                           94 'Local'
     O                                          120 'Invoice Amt.'
     O          E            TL1            1
     O                       MRCH$         4B    20
     O                       DISCNT        MB    32
     O                       FRT           4B    45
     O                       SPECL         4B    65
     O                       STTAX         4B    77
     O                       COTAX         4B    86
     O                       CYTAX         4B    95
     O                       INVAMT        MB   120
