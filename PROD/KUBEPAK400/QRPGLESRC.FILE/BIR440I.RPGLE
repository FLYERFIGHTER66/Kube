    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC       ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR440  - INVOICE PROCESSING PROGRAM
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- ORDER PROCESSING
      **DESCRIPTION--------- THIS PROGRAM WILL PROCESS ACTIVE ORDER
      **                     HEADER RECORDS THAT ARE TO BE RELEASED. IT
      **                     UPDATES THE DAILY LOT CONTROL/CATCH WEIGHT
      **                     FILE, THE ORDER FILES. THE PROGRAM BUILDS
      **                     INVOICE WORK FILES, AND CLOSES ORDERS.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  4/18/88 - EFD,DWC
      *            PUT PRODUCT CLASS IN THE INVOICE WORK FILE FOR
      *            PRINTING SUMMARY INVOICES.
      * 10/11/88 - EFD,DWC
      *            ADD NEW ROUTINE TO HANDLE ORDERS THAT WERE
      *            INVOICED THRU SHIPPING CONFIRMATION
      * 11/19/90 EFD ADD LOT # TO DSALE FILE
      *  8/02/96 EFD USE GETDESC PROGRAM FOR DESCRIPTION.
      *  8/22/96 GD  DELETE FET$
      *  9/18/96 GD  NATIVE
      * 10/25/96 EFD CLOSE ORDER IF OPEN LINES GE SEQ # 991
      *  1/08/97 EFD ADD NEW FILE FOR ROYALTY ETC.
      *  4/02/97 EFD ADD GL NUMBERS AND NEW FIELDS IN HORDW/IORDW
      * 12/13/97 EFD ADD INVOICE REV DATE TO IORDW CYMD
      *
      *
     FFHORDR    UF   E           K DISK
     FFHORDISCNTIF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFOECTL    UF   E           K DISK
     FFIOROY    IF   E           K DISK
     FFMTAXF    IF   E           K DISK
     FFMTERM    IF   E           K DISK
      *FFHORWOTMIF  E           K        DISK
      *F            RHORDW                            KRENAMEHORDW
     FFHORDWTM  UF A E           K DISK
     FFIORDWTM  UF A E           K DISK
      *
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
     D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
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
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp
      *
      ****************
      *
     C     *ENTRY        PLIST
     C                   PARM                    LDACOP            2 0
     C                   PARM                    LDATE             6 0
     C                   PARM                    LBORD             6 0
     C                   PARM                    LEORD             6 0
     C                   PARM                    LIMED             1
     C                   PARM                    OHINV#            6 0
      *
      *  GET TIME
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C*          HKEY      KLIST
     C*                    KFLD           LBORD
     C     NXT           TAG
     C                   EXSR      CLEAR
     C     LBORD         CHAIN     FHORDR                             90
     C   90              GOTO      END
     C*          OHORD#    IFGT LEORD
     C*          LEORD     ANDGT0
     C*                    GOTO END
     C*                    ENDIF
      *
     C     OHHOLD        IFNE      'R'
     C                   GOTO      END
     C                   ENDIF
      *
      *  Get EOD
     C                   Clear                   RHORDISCNT
     C     OHORD#        Chain     FHORDISCNT
     C     ADDSC1        Div       -100          EODPCT            5 5
      *
     C     OHINV#        IFGT      0
     C                   EXSR      DELPRV
     C                   Z-ADD     OHINV#        INVC#
     C  N60              Z-ADD     INVC#         LBINV             6 0
     C                   ELSE
     C                   Z-ADD     OHCOMP        LDACOP
     C                   Z-ADD     0             CO0               2 0
     C     CO0           CHAIN     FOECTL                             50
     C                   Z-ADD     OCNINV        INVC#             6 0
     C                   Z-ADD     OCNINV        OHINV#
     C  N60              Z-ADD     INVC#         LBINV
     C  N60              Z-ADD     0             PK70              7 0
     C                   ADD       1             OCNINV
     C  N50              UPDATE    ROECTL
     C                   SETON                                        60
     C                   END
      * CHECK SHIP FROM
     C*          LSHFR     IFNE *BLANKS
     C*          OHSHFR    ANDNELSHFR
     C*                    GOTO NXT
     C*                    ENDIF
      ** IMMED PRINT USE ASSIGNED NUMBER
     C*  70                DO
     C*                    Z-ADDOHINV#    INVC#
     C*                    ENDDO                            70 DO
      *
     C     OHORDT        IFGT      *ZEROS
     C                   Z-ADD     OHORDT        UPDTRQ            6 0
     C                   ENDIF
      *
      * DETERMINE TAXABLE STATUS OF ORDER
      *     N40=ORDER IS TAX EXEMPT  40=ORDER IS TAXABLE
      *
     C     OHTXST        IFEQ      'N'
     C                   SETON                                        40
     C                   ENDIF
     C     OHTXJU        CHAIN     FMTAXF                             50
      *
      *  READ IORDR.  ANY RECORD WITH A SHIP CODE 'R' WILL BE INVOICED
      *
     C     OHORD#        SETLL     FIORDR
     C     NXTI          TAG
     C     OHORD#        READE     FIORDR                                 20
     C   20              GOTO      HEADER
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
     C     OICOFL        IFEQ      'Y'
     C                   GOTO      NXTI
     C                   ENDIF
     C     OISHCD        IFNE      'R'
     C**         OIITYP    ANDEQ' '
     C     OISEQ#        ANDLT     991
     C                   SETON                                        45
     C                   GOTO      NXTI
     C                   ENDIF
      *
      *  GET S/A CUSTOMER INFORMATION
      *
     C  N61              EXSR      GETTR
      *
      * CHECK FOR BACKORDER AMOUNTS ON RELEASED LINE ITEMS
      *
     C  N45OIQORD        IFGT      OIQSHP
     C     OIQBOO        ANDGT     0
     C                   SETON                                        45
     C                   ENDIF
     C     OIITYP        IFEQ      'N'
     C                   MOVEL     'NON-STOC'    INVWK             9
     C                   MOVE      'K'           INVWK
     C                   ENDIF
     C     OIITYP        IFEQ      ' '
     C     IKEY          KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     IKEY          CHAIN     FMINVT                             50
     C  N50              Z-ADD     IMUCST        OIUCST                         CURRENT COST
     C                   ENDIF
      *
      *  DO PRICING CALCULATIONS AND ACCUMULATE TOTALS.
      *
     C     OIITYP        IFEQ      'C'
     C                   GOTO      SKIP
     C                   ENDIF
     C     OIITYP        COMP      'F'                                    42
     C     OIITYP        COMP      'S'                                    43
     C   42
     COR 43              GOTO      ARND
      *
      *  CHECK IF A SHIP QTY EXISTS.
      *
     C     OIQINV        IFEQ      *ZEROS
     C     OIRQTY        ANDGT     0.0
     C                   Z-ADD     OIRQTY        OIQINV
     C                   ADD       OIRQTY        OIQSHP
     C                   ENDIF
     C     OIQINV        IFEQ      *ZEROS
     C                   GOTO      SKIP
     C                   ENDIF
      *
      * CALCULATE TOTAL WHOLE CASE, BROKEN CASE
      *
     C     OIUUOM        IFEQ      IMPUOM
     C                   ADD       OIQINV        TBLK
     C                   ELSE
     C                   ADD       OIQINV        TBRK
     C                   ENDIF
      *
      *   CALCULATE GROSS AMT, NET AMT, DISCOUNT AMOUNT
      *
     C     OICWT         IFEQ      'Y'
     C                   Z-ADD     1             #WRFRQ
     C                   Z-ADD     OIWGSH        #WKWGT
     C                   ELSE
     C                   Z-ADD     OIQINV        #WRFRQ
     C                   Z-ADD     OIUWGT        #WKWGT
     C                   ENDIF
      *
     C                   Z-ADD     OIUPRI        #PRC
     C                   Z-ADD     OIQDDC        #DISC
     C                   MOVE      OICWT         #CWFLG
     C                   EXSR      #EXLNO
     C                   Z-ADD     #LINGR        EXT               9 2
     C                   Z-ADD     #LINNT        ITMNET            9 2
     C                   Z-SUB     #LINDS        QDA               7 2
      *
     C                   ADD       EXT           MRCH$             9 2
     C                   ADD       ITMNET        NETAMT            9 2
     C                   ADD       QDA           QTYDIS            7 2
     C     OIPPDC        IFEQ      'Y'
     C                   ADD       EXT           DSCPRC           11 2
     C                   ENDIF
      *
      * ACCUMULATE TAXABLE AMOUNTS AS REQUIRED
      *
     C  N40              ADD       ITMNET        WKNTAX            9 4
     C  N40              GOTO      TXPASS
      *
     C     OITXCD        IFEQ      'N'
     C                   ADD       ITMNET        WKNTAX            9 4
     C                   GOTO      TXPASS
     C                   ENDIF
      ** SKIP TAX IF HEADER SET TO TAX EXEMPT
     C** 40                GOTO TXPASS
      *
     C     OITXST        COMP      'Y'                                    57
     C     OITXCT        COMP      'Y'                                    58
     C     OITXLC        COMP      'Y'                                    59
     C   57ITMNET        ADD       WKTAX1        WKTAX1
     C   58ITMNET        ADD       WKTAX2        WKTAX2
     C   59ITMNET        ADD       WKTAX3        WKTAX3
     C  N57
     CANN58
     CANN59              ADD       ITMNET        WKNTAX                         NOT TAXABLE
      *
     C     TXPASS        TAG
      *
      *  CALCULATE TOTAL COST AND PROFIT PERCENT
      *
     C     OICWT         IFEQ      'Y'
     C     OIWGSH        MULT(H)   OIUCST        LINCST            9 4
     C                   ELSE
     C     OIQINV        MULT      OIUCST        LINCST
     C                   ENDIF
      *
     C                   ADD       LINCST        TOTCST            9 4
     C     ITMNET        SUB       LINCST        LINPFT            9 4
     C                   ADD       LINPFT        TOTPFT            9 4
     C     LINCST        COMP      0                                  3636
     C   36LINPFT        DIV(H)    LINCST        PRCNT             7 4
     C     PRCNT         MULT(H)   100           LINPFP            5 2
      *
     C                   MOVEL     OIUUOM        #WRFUM                         CONVERT QTY
     C                   Z-ADD     OIQINV        #WRFQT                         INVOICED INTO
     C                   EXSR      #CVQT                                        PRIMARY U/M
     C                   Z-ADD     #WQT1         SVQINV           11 1
      *
      * ACCUMULATE TOTAL WEIGHT SHIPPED
      *
     C                   ADD       OIWGSH        TOTLBS           11 4
      *
      *  ADD FREIGHT AND SPECIAL CHARGES TO TOTALS.
      *
     C     ARND          TAG
     C   42              Z-ADD     OIEXT$        FRGHT             7 2
     C   42              ADD       FRGHT         FRT               7 2
     C   42              Z-ADD     OIEXT$        EXT
     C   42OHFRTX        COMP      'Y'                                    52
     C   42
     CAN 52
     CAN 40              EXSR      ACCOX
     C   42
     CAN 52
     CANN40
     COR 42
     CANN52              ADD       OIEXT$        WKFNTX
     C   43              Z-ADD     OIEXT$        SPCHGE            7 2
     C   43              ADD       SPCHGE        SPECL             7 2
     C   43              Z-ADD     OIEXT$        EXT
     C   43OHSPTX        COMP      'Y'                                    52
     C   43
     CAN 52
     CAN 40              EXSR      ACCOX
     C   43
     CAN 52
     CANN40
     COR 43
     CANN52              ADD       OIEXT$        WKSNTX
      *
      *  WRITE  LINE ITEM WORK FILE.
      *
     C     SKIP          TAG
     C     OIITYP        IFEQ      ' '
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   MOVEL     OIITEM        ITEM             12
     C                   MOVE      OISIZE        SIZE              3
     C                   CALL      'GETDESC'
     C                   PARM                    ITEM
     C                   PARM                    SIZE
     C                   PARM                    OIWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   ELSE
     C                   MOVEL     OIDES1        DESCO
     C                   MOVE      OIDES2        DESCO
     C                   END
      *   4/04/97 OK TO HERE CHECK DSALE
     C     OIQINV        IFNE      *ZEROS
     C                   SETON                                        81
     C                   ENDIF
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C                   SETON                                        81
     C                   ENDIF
      *
      * WRITE IORDW
      *
     C                   MOVEL     'A'           WISTAT
     C                   Z-ADD     INVC#         WIINV#
     C                   ADD       2             NWLINE
     C                   MOVEL     'A'           WISTAT
     C                   Z-ADD     NWLINE        WISEQ#
     C                   MOVEL     OIITEM        WIITEM
     C                   MOVEL     OISIZE        WISIZE
     C                   MOVEL     DESCO         WIDES1
     C                   MOVE      DESCO         WIDES2
     C                   Z-ADD     OICOMP        WICOMP
     C                   MOVEL     OIWHSE        WIWHSE
     C                   MOVEL     OIBIN#        WIBIN#
     C                   MOVEL     OIUUOM        WIUUOM
     C                   Z-ADD     OIMULT        WIMULT
     C                   Z-ADD     OIUWGT        WIUWGT
     C                   Z-ADD     OIUCST        WIUCST
     C                   Z-ADD     OIUPRI        WIUPRI
     C                   Z-ADD     OIQDDC        WIQDDC
     C                   Z-ADD     OIEXT$        WIEXT$
     C                   Z-ADD     OIQORD        WIQORD
     C                   Z-ADD     OIQSHP        WIQSHP
     C                   Z-ADD     OIQBOO        WIQBOO
     C                   Z-ADD     OIROY         WIROY
     C                   Z-ADD     OIAMT1        WIAMT1
     C                   Z-ADD     OIAMT2        WIAMT2
     C                   Z-ADD     OIAMT3        WIAMT3
     C                   Z-ADD     OIDISC        WIDISC
     C                   MOVEL     OISHCD        WISHCD
     C                   MOVEL     OIOVER        WIOVER
     C                   MOVEL     OIBOCD        WIBOCD
     C                   MOVEL     OISLM1        WISLM1
     C                   MOVEL     OISLM2        WISLM2
     C                   Z-ADD     OICOM1        WICOM1
     C                   Z-ADD     OICOM2        WICOM2
     C                   Z-ADD     OICUST        WICUST
     C                   Z-ADD     OIDTRQ        WIDTRQ
     C                   Z-ADD     LDATE         WIDTLA
     C                   Z-ADD     LDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        WIRIND
     C                   Z-ADD     TIMOD         WITIME
     C                   MOVEL     USERID        WIUSER
     C**                   MOVELWSID      WIWSID
     C                   Z-ADD     OITRDC        WITRDC
     C                   MOVEL     OICTCD        WICTCD
     C                   MOVEL     ' '           WICOFL
     C                   MOVEL     OIITYP        WIITYP
     C                   Z-ADD     OIQINV        WIQINV
     C                   Z-ADD     EXT           WIAMT
     C                   Z-ADD     LINCST        WICST
     C                   Z-ADD     LINPFT        WIPRT
     C                   Z-ADD     LINPFP        WIPRCT
     C                   MOVEL     OICWT         WICWT
     C                   Z-ADD     OILBS#        WILBS#
     C                   Z-ADD     OIWGSH        WIWHSH
     C                   MOVEL     OIRSCD        WIRSCD
     C                   Z-ADD     OISEQP        WISEQP
WJB17C                   Z-ADD     OISEQ#        WISEQP
     C                   MOVEL     OIPRAL        WIPRAL
     C                   MOVEL     OIBPUM        WIBUOM
     C                   MOVEL     OISUOM        WISUOM
     C                   MOVEL     OIBLUM        WIBLUM
     C                   MOVEL     OILOTC        WILOTC
     C                   Z-ADD     OITAGS        WITAGS
     C                   MOVEL     OIPPDC        WIPPDC
     O*???            N46N50   IMPCL1   384
      *
     C                   WRITE     RIORDW
     C                   SETOFF                                       8183
     C     WIAMT         IFGT      0.00
     C                   Z-ADD     OIQINV        ROYINV           11 1
     C                   ELSE
     C                   Z-ADD     0             ROYINV
     C                   END
      *
      * WRITE LOT CONTROL/ CATCH WEIGHT INFO OUT
      *
     C*          OIITYP    IFEQ ' '
     C*          OICWT     COMP 'Y'                      10
     C*                    END
      *
      *  CLOSE LINE ITEMS
      *
      **         OIQBOO    COMP 0                        30
     C     OIQORD        IFEQ      OIQSHP
     C                   SETON                                        30
     C                   ENDIF
     C   30              MOVEL     OIORD#        REFKEY            9
     C   30              MOVE      OISEQ#        REFKEY
     C     OIKEY         KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     OIKEY         CHAIN     FIORDR                             50
      *
     C     OIORDT        IFGT      *ZEROS
     C                   MOVE      OIORDT        LRQDT             6 0
     C                   ELSE
     C                   MOVE      OIDTRQ        LRQDT             6 0
     C                   END
     C     LRQDT         MULT      10000.01      RLRQDT            6 0
     C                   Z-ADD     OIORD#        OLORD#            6 0
     C                   Z-ADD     OICOMP        OLCOMP            2 0
      ** SEE IF WE NEED ROYALTY REC
     C     OIITYP        IFEQ      ' '
     C                   EXSR      GETROY
     C                   END
      *
      *  CLEAR DETAIL LINE ITEM WORK FIELDS AND GO TO BEGINING.
      *
     C                   Z-ADD     0             ITMNET
     C                   Z-ADD     0             EXT
     C                   Z-ADD     0             QDA
     C                   Z-ADD     0             LINCST
     C                   Z-ADD     0             LINPFT
     C                   Z-ADD     0             PRCNT
     C                   Z-ADD     0             LINPFP
     C                   Z-ADD     0             FRGHT
     C                   Z-ADD     0             SPCHGE
     C                   GOTO      NXTI
      *
      *  START PROCESSING INVOICE TOTALS AND UPDATING HEADER FILE.
      *
     C     HEADER        TAG
      *
      *  CALCULATE DUE DATES FOR DISCOUNT AND NET AMOUNT
      *
     C                   EXSR      CALDT
      *
      *  CALCULATE TRADE DISCOUNT AMT.
      *
     C                   Z-ADD     NETAMT        NETPRC            9 4
     C*                  Z-ADD     OHTRDC        DISHLD            4 2    52
WJB  C     ADDSC1        Add       OHTRDC        DISHLD            4 2    52
     C  N52              MOVE      DISHLD        DISREF            4 4
     C  N521             SUB       DISREF        DISREF
     C  N52NETPRC        MULT      DISREF        NETPRC
     C  N52WKNTAX        MULT      DISREF        WKNTAX
     C     NETAMT        SUB       NETPRC        TRDDIS            7 2
     C                   Z-SUB     TRDDIS        TRDDIS
      *
      *  ACCUMULATE DISCOUNTS.
      *
     C                   ADD       TRDDIS        DISCNT            7 2
     C                   ADD       QTYDIS        DISCNT
      *
      *  CALCULATE TAX AMOUNT IF ANY.
      *
     C                   Z-ADD     0             TAXAMT            9 4
     C  N40              GOTO      ARNTAX
      *
      *            ADJUST ACCUMULATED AMOUNTS FOR TRADE DISC.
      *
     C  N52WKTAX1        MULT(H)   DISREF        WKTAX1
     C  N52WKTAX2        MULT(H)   DISREF        WKTAX2
     C  N52WKTAX3        MULT(H)   DISREF        WKTAX3
      *
     C     WKTAX1        COMP      TXLIM1                             37                       BIR44
     C     WKTAX2        COMP      TXLIM2                             38                       BIR44
     C     WKTAX3        COMP      TXLIM3                             39                       BIR44
     C   37              Z-ADD     TXLIM1        WKTAX1                                        BIR44
     C   38              Z-ADD     TXLIM2        WKTAX2                                        BIR44
     C   39              Z-ADD     TXLIM3        WKTAX3                                        BIR44
      *
     C     TXPCT1        DIV(H)    100           WXPCT1            7 6
     C     TXPCT2        DIV(H)    100           WXPCT2            7 6
     C     TXPCT3        DIV(H)    100           WXPCT3            7 6
     C     WKTAX1        MULT(H)   WXPCT1        STTAX             7 2          STATE
     C     WKTAX2        MULT(H)   WXPCT2        COTAX             7 2          COUNTY
     C     WKTAX3        MULT(H)   WXPCT3        CYTAX             7 2          CITY
      *
      *  CALCULATE FREIGHT AND SPECIAL CHARGES
      *  TAX, IF ANY.  - ACCUMULATE TAXABLE AMOUNTS -
      *
     C*                    ADD  WKTAX1    TXMTX1
     C*                    ADD  WKFTX1    TXMTX1
     C*                    ADD  WKSTX1    TXMTX1
     C     WKFTX1        MULT(H)   WXPCT1        WKFTX1
     C                   ADD       WKFTX1        STTAX
     C     WKSTX1        MULT(H)   WXPCT1        WKSTX1
     C                   ADD       WKSTX1        STTAX
     C**                   ADD  STTAX     TXMMT1
      *
     C*                    ADD  WKTAX2    TXMTX2
     C*                    ADD  WKFTX2    TXMTX2
     C*                    ADD  WKSTX2    TXMTX2
     C     WKFTX2        MULT(H)   WXPCT2        WKFTX2
     C                   ADD       WKFTX2        COTAX
     C     WKSTX2        MULT(H)   WXPCT2        WKSTX2
     C                   ADD       WKSTX2        COTAX
     C**                   ADD  COTAX     TXMMT2
      *
     C*                    ADD  WKTAX3    TXMTX3
     C*                    ADD  WKFTX3    TXMTX3
     C*                    ADD  WKSTX3    TXMTX3
     C     WKFTX3        MULT(H)   WXPCT3        WKFTX3
     C                   ADD       WKFTX3        CYTAX
     C     WKSTX3        MULT(H)   WXPCT3        WKSTX3
     C                   ADD       WKSTX3        CYTAX
     C**                   ADD  CYTAX     TXMMT3
      *
     C     ARNTAX        TAG
     C**                   ADD  NETPRC    TXMGRS
     C     FRT           SUB       WKFNTX        FRTTAX            7 2
     C     SPECL         SUB       WKSNTX        SPCTAX            7 2
      *
      *  CALCULATE TOTAL INVOICE AMOUNT.
      *
     C                   ADD       MRCH$         INVAMT           11 2
     C                   ADD       STTAX         INVAMT
     C                   ADD       COTAX         INVAMT
     C                   ADD       CYTAX         INVAMT
     C                   ADD       FRT           INVAMT
     C                   ADD       SPECL         INVAMT
     C                   ADD       DISCNT        INVAMT
     C*    MRCH$         MULT(H)   EODPCT        EOD$              7 2
     C*                  ADD       EOD$          INVAMT
      ** GET TOTAL TAX
     C     COTAX         ADD       STTAX         WHTAX$
     C                   ADD       CYTAX         WHTAX$
      *
      *  CALCULATE DISCOUNT BASED ON TERMS.
      *
     C     DSCPRC        MULT(H)   #DISWK        CSHDS$            7 2
      *
      *  CALCULATE TOTAL PROFIT PERCENT.
      *
     C     TOTCST        COMP      0                                  3636
     C   36TOTPFT        DIV(H)    TOTCST        TOTPT             7 4
     C     TOTPT         MULT(H)   100           TOTPFP            5 2
      *
      *  WRITE ORDER HEADER WORK  HORDW
      *
     C                   MOVEL     'A'           WHSTAT
     C                   Z-ADD     INVC#         WHINV#
     C                   Z-ADD     OHCOMP        WHCOMP
     C                   Z-ADD     OHCUST        WHCUST
     C                   MOVEL     OHNAME        WHNAME
     C                   MOVEL     OHSHP2        WHSHP2
     C                   MOVEL     OHSHP3        WHSHP3
     C                   MOVEL     OHSHP4        WHSHP4
     C                   MOVEL     OHSHCT        WHSHCT
     C                   MOVEL     OHSHST        WHSHST
     C                   MOVEL     OHSHZP        WHSHZP
     C***                  MOVELOHSVI2    WHSVI2
     C                   MOVEL     OHPONO        WHPONO
     C                   Z-ADD     OHDTOR        WHDTOR
     C                   Z-ADD     OHDTRQ        WHDTRQ
     C                   Z-ADD     OHDTCN        WHDTCN
     C                   MOVEL     OHSHIN        WHSHIN
     C                   MOVEL     OHSPIN        WHSPIN
     C                   MOVEL     OHTERM        WHTERM
     C                   Z-ADD     OHTRAT        WHTRAT
     C                   Z-ADD     OHTDAY        WHTDAY
     C                   MOVEL     OHTXST        WHTXST
     C                   MOVEL     OHTXJU        WHTXJU
     C                   Z-ADD     STTAX         WHAMT1
     C                   Z-ADD     COTAX         WHAMT2
     C                   Z-ADD     CYTAX         WHAMT3
     C                   MOVEL     OHTYPE        WHTYPE
     C                   MOVEL     OHSHPC        WHSHPC
     C                   MOVEL     OHSTA         WHSTA
     C                   MOVEL     OHACK         WHACK
     C                   MOVEL     OHSLD1        WHSLD1
     C                   MOVEL     OHSLD2        WHSLD2
     C                   MOVEL     OHSLD3        WHSLD3
     C                   MOVEL     OHSLD4        WHSLD4
     C                   MOVEL     OHSLCT        WHSLCT
     C                   MOVEL     OHSLST        WHSLST
     C                   MOVEL     OHSLZP        WHSLZP
     C                   MOVEL     OHSLM1        WHSLM1
     C                   Z-ADD     OHSCM1        WHSCM1
     C                   MOVEL     OHSLM2        WHSLM2
     C                   Z-ADD     OHSCM2        WHSCM2
     C                   Z-ADD     MRCH$         WHMER$
     C                   Z-ADD     DISCNT        WHDIS$
     C                   Z-ADD     FRT           WHFRT$
     C                   Z-ADD     SPECL         WHMIS$
     C                   Z-ADD     TOTFET        WHFET$
     C                   MOVEL     OHIOCD        WHIOCD
     C                   MOVEL     OHBOCD        WHBOCD
     C                   MOVEL     OHCOFL        WHCOFL
     C                   MOVEL     OHHOLD        WHHOLD
     C                   MOVEL     OHPLPT        WHPLPT
     C                   MOVEL     OHIVCD        WHIVCD
     C                   Z-ADD     TDATE         WHDTLA
     C                   Z-ADD     TIMOD         WHTIME
     C                   MOVEL     USERID        WHUSER
     C**                   MOVELWSID      WHWSID
     C                   MOVEL     OHPRCD        WHPRCD
     C                   Z-ADD     OHTRDC        WHTRDC
WJB  C                   ADD       ADDSC1        WHTRDC
     C                   MOVEL     OHTMCD        WHTMCD
     C                   Z-ADD     OHTDAS        WHTDAS
     C                   Z-ADD     OHORD#        WHORD#
     C                   Z-ADD     LDATE         WHINDT
     C*                    Z-ADDLDATE     ##MDY
     C*                    CALL '@DT@A1'
     C*                    PARM           ##MDY   60       DATE MDY
     C*                    PARM           ##CYMD  70       DATE CYYMMDD
     C*                    PARM           ##ERR   1        ERROR IF = Y
     C*                    Z-ADD##CYMD    WHINDT
     C                   Z-ADD     LDATE         WHTDAT
     C                   MOVEL     OHUPSZ        WHUPSZ
     C                   MOVEL     OHFRTX        WHFRTX
     C                   MOVEL     OHSPTX        WHSPTX
     C                   MOVEL     OHTXID        WHTXID
     C                   MOVEL     OHROUT        WHROUT
     C                   Z-ADD     OHSTOP        WHSTOP
     C                   Z-ADD     OHARCU        WHARCU
     C                   Z-ADD     OHSACU        WHSACU
     C                   Z-ADD     OHBLCU        WHBLCU
     C                   Z-ADD     TBLK          WHTBLK
     C                   Z-ADD     TBRK          WHTBRK
     C                   Z-ADD     OHDTAC        WHDTAC
     C                   MOVEL     OHALPH        WHALPH
     C                   MOVEL     OHSHFR        WHSHFR
     C                   MOVEL     OHPLST        WHPLST
     C                   MOVEL     LIMED         WHIMED
     C                   Z-ADD     OHCASH        WHCASH
     C                   Z-ADD     OHORDT        WHORDT
     C                   MOVEL     OHOLST        WHOLST
     C                   MOVEL     OHLOC         WHLOC
     C                   MOVEL     OHPHYT        WHPHYT
     C**                   Z-ADDOHVLDC    WHVLDC
     C**                   MOVELOHFVDC    WHFVDC
     C                   Z-ADD(H)  INVAMT        WH$AMT
     C                   MOVEL     OHIMFG        WHIMFG
     C                   MOVEL     OHPOS         WHPOS
     C                   Z-ADD     OHORD#        WHORD#
      *
     C                   WRITE     RHORDW
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BIR440I'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
      *
     C***                  GOTO NXT
      *
     C     END           TAG
      *
      *  ON LAST RECORD UPDATE INVOICE NUMBER IN CONTROL FILE.
      *
     C***                  Z-ADDINVC#     LEINV
     C                   SETON                                        LR
      **********
      * DELPRV *
      **********
      *  DELETE PREVIOUS RUN FROM TEMP FILE
      *
     C     DELPRV        BEGSR
     C     OHINV#        CHAIN     FHORDWTM                           90
     C  N90              DELETE    RHORDW
     C     OHINV#        SETLL     FIORDWTM
     C     NXTDEL        TAG
     C     OHINV#        READE     FIORDWTM                               90
     C  N90              DO
     C                   DELETE    RIORDW
     C                   GOTO      NXTDEL
     C                   ENDDO
     C                   ENDSR
      *********
      * CLEAR *
      *********
      *  CLEAR WORK FIELDS AT NEW HEADER.
      *
     C     CLEAR         BEGSR
     C                   Z-ADD     0             NWLINE            3 0
     C                   Z-ADD     0             NETAMT
     C                   Z-ADD     0             NETPRC
     C                   Z-ADD     0             DSCPRC
     C                   Z-ADD     0             MRCH$
     C                   Z-ADD     0             QTYDIS
     C                   Z-ADD     0             TOTCST
     C                   Z-ADD     0             TOTPFT
     C                   Z-ADD     0             TOTFET            7 2
     C                   Z-ADD     0             TOTLBS
     C                   Z-ADD     0             FRT
     C                   Z-ADD     0             SPECL
     C                   Z-ADD     0             DUEDTE
     C                   Z-ADD     0             DTNUMB
     C                   Z-ADD     0             CSHDUE
     C                   Z-ADD     0             STTAX
     C                   Z-ADD     0             COTAX
     C                   Z-ADD     0             CYTAX
     C                   Z-ADD     0             TRDDIS
     C                   Z-ADD     0             DISCNT
     C                   Z-ADD     0             INVAMT
     C                   Z-ADD     0             CSHDS$
     C                   Z-ADD     0             TOTPT
     C                   Z-ADD     0             TOTPFP
     C                   Z-ADD     0             FRTTAX
     C                   Z-ADD     0             SPCTAX
     C                   Z-ADD     0             WKTAX1            9 4
     C                   Z-ADD     0             WKTAX2            9 4
     C                   Z-ADD     0             WKTAX3            9 4
     C                   Z-ADD     0             WK112            11 4
     C                   Z-ADD     0             WKNTAX
     C                   Z-ADD     0             WKFNTX
     C                   Z-ADD     0             WKSNTX
     C                   Z-ADD     0             WKFTX1
     C                   Z-ADD     0             WKFTX2
     C                   Z-ADD     0             WKFTX3
     C                   Z-ADD     0             WKSTX1
     C                   Z-ADD     0             WKSTX2
     C                   Z-ADD     0             WKSTX3
     C                   Z-ADD     0             TBLK             11 1
     C                   Z-ADD     0             TBRK             11 1
     C                   Z-ADD     0             PK30              3 0
     C                   Z-ADD     0             PK114            11 4
     C                   ENDSR
      *
      **************
      ****  GETROY *
      **************
      *
     C     GETROY        BEGSR
     C     ROYKEY        KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     ROYKEY        CHAIN     FIOROY                             77
     C   77              GOTO      ENDROY
     C     ROYINV        MULT(H)   ORUPRI        #LINNT
     C                   Z-ADD     #LINNT        WIEXT$
     C                   Z-ADD     #LINNT        WIAMT
     C                   Z-ADD     0             LINCST
     C                   Z-ADD     0             LINPFT
     C                   Z-ADD     0             LINPFP
     C                   ADD       #LINNT        MRCH$
     C                   Z-ADD     0             ORQINV
     C                   ADD       2             NWLINE
     C                   MOVEL     'A'           WISTAT
     C                   Z-ADD     INVC#         WIINV#
     C                   Z-ADD     NWLINE        WISEQ#
     C                   Z-ADD     OISEQ#        WISEQP
     C                   MOVE      ORITEM        WIITEM
     C                   MOVE      ORSIZE        WISIZE
     C                   MOVEL     ORDES1        WIDES1
     C                   MOVE      *BLANKS       WIDES2
     C                   Z-ADD     OICOMP        WICOMP
     C                   MOVE      *BLANKS       WIWHSE
     C                   MOVE      *BLANKS       WIBIN#
     C                   MOVE      *BLANKS       WIUUOM
     C                   Z-ADD     0             WIMULT
     C                   Z-ADD     0             WIUWGT
     C                   Z-ADD     0             WIUCST
     C                   Z-ADD     ORUPRI        WIUPRI
     C                   Z-ADD     0             WIQDDC
     C                   Z-ADD     0             WIQORD
     C                   Z-ADD     0             WIQSHP
     C                   Z-ADD     0             WIQBOO
     C                   Z-ADD     0             WIROY
     C                   Z-ADD     0             WIAMT1
     C                   Z-ADD     0             WIAMT2
     C                   Z-ADD     0             WIAMT3
     C                   Z-ADD     0             WIDISC
     C                   MOVEL     OISHCD        WISHCD
     C                   MOVEL     OIOVER        WIOVER
     C                   MOVEL     OIBOCD        WIBOCD
     C                   MOVEL     OISLM1        WISLM1
     C                   MOVEL     OISLM2        WISLM2
     C                   Z-ADD     0             WICOM1
     C                   Z-ADD     0             WICOM2
     C                   Z-ADD     OICUST        WICUST
     C                   Z-ADD     OIDTRQ        WIDTRQ
     C                   Z-ADD     LDATE         WIDTLA
     C                   Z-ADD     TIMOD         WITIME
     C                   MOVEL     USERID        WIUSER
     C***                  MOVELWSID      WIWSID
     C                   Z-ADD     0             WITRDC
     C                   MOVEL     OICTCD        WICTCD
     C                   MOVEL     ' '           WICOFL
     C                   MOVEL     ' '           WIITYP
     C                   Z-ADD     ROYINV        WIQINV
     C                   Z-ADD     0             WICST
     C                   Z-ADD     0             WIPRT
     C                   Z-ADD     0             WIPRCT
     C                   MOVE      *BLANKS       WICWT
     C                   Z-ADD     0             WILBS#
     C                   Z-ADD     0             WIWHSH
     C                   MOVEL     OIRSCD        WIRSCD
     C                   Z-ADD     OISEQ#        WISEQP
     C                   MOVEL     *BLANKS       WIPRAL
     C                   MOVEL     *BLANKS       WIBUOM
     C                   MOVEL     *BLANKS       WISUOM
     C                   MOVEL     *BLANKS       WIBLUM
     C                   MOVEL     *BLANKS       WIMUL2
     C                   MOVEL     *BLANKS       WILOTC
     C                   Z-ADD     OHORD#        WIORD#
     C                   MOVEL     OHSHFR        WISHFR
     C                   Z-ADD     0             WITAGS
     C                   MOVEL     0             WIPPDC
     C                   Z-ADD     0             WIGLNO
     C                   MOVEL     *BLANKS       WIITAL
     C                   MOVEL     ORDES1        WIALPH
     C                   MOVEL     *BLANKS       WIPRCL
      *
     C                   WRITE     RIORDW
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   MOVEL     ORITEM        ITEM             12
     C                   MOVE      ORSIZE        SIZE              3
     C                   CALL      'GETDESC'
     C                   PARM                    ITEM
     C                   PARM                    SIZE
     C                   PARM                    OIWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C     ENDROY        ENDSR
      *  ***********
      *  * ACCOX   *
      *  ***********
      *  DETERMINE AND ACCUMULATE TAXES FOR FREIGHT AND SPECIAL CHARGE
      *  LINES
      *
     C     ACCOX         BEGSR
      *
     C     OITXCD        COMP      'N'                                    56
     C   56
     CAN 42              ADD       OIEXT$        WKFNTX            7 2
     C   56
     CAN 43              ADD       OIEXT$        WKSNTX            7 2
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
      *******************
      ****  CALDT       *
      *******************
      *
     C     CALDT         BEGSR
      *
      *            DETERMINE TYPE OF TERMS
      *
     C                   MOVEL     OHTMCD        TERMCD            2
     C     TERMCD        CHAIN     FMTERM                             75
     C   75              GOTO      CALDT1
      *
     C     TCTRTP        COMP      1                                      21
     C     TCTRTP        COMP      2                                      22
     C     TCTRTP        COMP      3                                      23
     C   21
     COR 22
     COR 23              MOVE      TCTRAT        #DISWK
     C   21              GOTO      TYP01
     C   22              GOTO      TYP02
     C   23              GOTO      TYP03
      *
     C     CALDT1        TAG
     C                   MOVE      LDATE         DUEDTE
     C                   MOVE      LDATE         CSHDUE
     C                   MOVE      *ZEROS        #DISWK            4 4
     C                   GOTO      ECALDT
      *
      *            CALCULATE FOR TERMS TYPE '1'
      *
     C     TYP01         TAG
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   EXSR      @DT@B2
     C                   Z-ADD     ##DDD         DTNUMB            5 0
     C                   ADD       TCTDAS        ##DDD
     C                   EXSR      @DT@D0
     C                   MOVE      ##MDY         DUEDTE            6 0
      *  CALCULATE DISCOUNT DUE DATE.
      *
     C                   ADD       TCTDAY        DTNUMB
     C                   Z-ADD     DTNUMB        ##DDD
     C                   EXSR      @DT@D0
     C                   MOVE      ##MDY         CSHDUE            6 0
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '2'
      *
     C     TYP02         TAG
      *
      * GET CURRENT DAY OF MONTH FOR CUTOFF TEST
      *
     C                   MOVEL     LDATE         #WMMDD            4 0
     C                   MOVEL     #WMMDD        #WMM              2 0
     C                   MOVE      #WMMDD        #WDD              2 0
     C                   MOVE      LDATE         #WYY              2 0
      *
      * TEST TO SEE IF LESS THAN OR EQUAL TO CUTOFF DATE
      *
     C     #WDD          COMP      TCCUTO                               2828
     C   28#WMM          ADD       TCMBCO        #WMM
     C  N28#WMM          ADD       TCMACO        #WMM
      *
      * TEST TO SEE IF MONTHS EXCEEDS 12
      *
     C     #WMM          COMP      12                                 27
     C   27#WMM          SUB       12            #WMM
     C   27#WYY          ADD       1             #WYY
      *
     C                   MOVEL     #WMM          #WMMDD
     C   28              MOVE      TCNBCO        #WMMDD
     C  N28              MOVE      TCNACO        #WMMDD
     C                   MOVEL     #WMMDD        DUEDTE
     C                   MOVE      #WYY          DUEDTE
      *
      * CALCULATE DISCOUNT DUE DATE
      *
     C   28TCDBCO        COMP      *ZEROS                                 29
     C  N28TCDACO        COMP      *ZEROS                                 29
     C   29              MOVE      LDATE         CSHDUE
     C   28
     CANN29              MOVE      TCDBCO        #WMMDD
     C  N28
     CANN29              MOVE      TCDACO        #WMMDD
     C  N29              MOVEL     #WMMDD        CSHDUE
     C  N29              MOVE      #WYY          CSHDUE
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '3'
      *
     C     TYP03         TAG
      *
     C                   MOVE      TCNDUE        DUEDTE
      *
     C     TCDDUE        COMP      *ZEROS                                 29
     C   29              MOVE      LDATE         CSHDUE
     C  N29              MOVE      TCDDUE        CSHDUE
      *
     C     ECALDT        ENDSR
      *
      **************
      ****  GETTR  *
      **************
      *
     C     GETTR         BEGSR
      *
      * USES S/A CUSTOMER NUMBER FOR DSALE UPDATE
      *
     C     OHSACU        CHAIN     FMCUST                             50
     C  N50              MOVE      CMTERR        TERR              2
     C  N50              MOVE      CMCTYP        CTYP              2
     C                   SETON                                        61
     C                   ENDSR
      *********
      * #CVQT *
      *********
     C     #CVQT         BEGSR
      * QUANITITY CONVERSION SUBROUTINE
      * #WRFUM - CONTAINS ENTERED UNIT OF MEASURE
      * #WRFQT - CONTAINS ENTERED QUANITITY
      *
      *  ***********
      *  * #CVQT   *
      *  ***********
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
     C                   Z-ADD     #WRFQT        #WQT1
     C                   Z-ADD     IMUWGT        #WQR#
     C     #WRFQT        MULT(H)   IMUWGT        #WQT#
      *
     C     IMSUOM        IFNE      *BLANKS
     C     #WQT1         MULT(H)   IMMULT        #WQT2
     C                   END
      *
     C     IM3UOM        IFNE      *BLANKS
     C     #WQT2         MULT(H)   IMMUL2        #WQT3
     C                   END
      *
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO SECONDARY UNIT OF MEASURE
      *
     C     IMSUOM        IFGT      *BLANKS
     C     #WRFUM        IFEQ      IMSUOM
      *
     C     IMUWGT        DIV(H)    IMMULT        WKWGT2
     C                   Z-ADD     WKWGT2        #WQR#
     C                   Z-ADD     #WRFQT        #WQT2
     C     #WQT2         MULT(H)   WKWGT2        #WQT#
      *
     C     #WQT2         DIV(H)    IMMULT        #WQT1
      *
     C     IM3UOM        IFNE      *BLANKS
     C     #WQT2         MULT(H)   IMMUL2        #WQT3
     C                   END
      *
     C                   END
     C                   END
      *
      *  UNIT OF MEASURE EQUAL TO THIRD UNIT OF MEASURE
      *
     C     IM3UOM        IFGT      *BLANKS
     C     #WRFUM        IFEQ      IM3UOM
      *
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
      *
     C                   END
     C                   END
      *
     C                   ENDSR
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
     C     #WRFRQ        MULT(H)   #PRC          #LINGR            9 2
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
     C     #WRFRQ        MULT(H)   #PRC          #LINNT            9 2
      *
      *  CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       #LINNT        #LINDS            7 2
      *
     C                   ENDSR
      *
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
     C                   MOVEL     0             #03A                           CYY            @DT@A
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
     C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
     C                   MOVE      #04           #02C              2 0          DD             @DT@A
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
     C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                                      @DT@A
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
     C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
     C     #03A          COMP      070                                  91                     @DT@A
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
     C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
      *
      ********************************************************************@DT@B2
      * CONVERT MMDDYY TO DAY OF CENTURY DDDDD. INDICATOR 90 NEGATIVE DATE@DT@B2
      * ##MDY INPUT DATE MMDDYY                                           @DT@B2
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B2
      * INDICATORS USED 90-92                                             @DT@B2
      ********************************************************************@DT@B2
     C     @DT@B2        BEGSR                                                                 @DT@B
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      NEG DATE       @DT@B
      * CONVERT YEAR TO DAYS                                              @DT@B2
     C                   MOVE      ##MDY         #02               2 0          YY             @DT@B
     C     #02           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
     C     #02           DIV       4             #02                  91        # OF LEAPS -1  @DT@B
     C   91              MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C     #02           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
      * CONVERT MONTH TO DAYS                                             @DT@B2
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@B
     C                   MOVEL     #04           #02A                           MM             @DT@B
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
     C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CANN92##DDD         SUB       1             ##DDD                          LEAP MM 03-12  @DT@B
      * ADD DAY OF MONTH                                                  @DT@B2
     C                   MOVE      #04           #02                            DD             @DT@B
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
     C   90              Z-ADD     0             ##DDD                                         @DT@B
     C                   SETOFF                                         9192                   @DT@B
     C                   ENDSR                                                                 @DT@B
      ********************************************************************@DT@D0
      * CONVERT DAY OF CENTURY DDDDD TO MMDDYY                            @DT@D0
      * ##DDD INPUT DAY OF CENTURY.                                       @DT@D0
      * ##MDY OUTPUT DATE MMDDYY.                                         @DT@D0
      * INDICATOR 90 IS A MINUS DATE.                                     @DT@D0
      * INDICATORS 91-93 USED.                                            @DT@D0
      ********************************************************************@DT@D0
     C     @DT@D0        BEGSR                                                                 @DT@D
     C                   Z-ADD     0             ##MDY             6 0                         @DT@D
     C                   SETOFF                                       919293                   @DT@D
      * TEST IF ZERO OR NEGATIVE                                          @DT@D0
     C     ##DDD         SUB       1             #05               5 0  90      REDUCE DDD BY 1@DT@D
     C   90              GOTO      @DT@DX                                       ERROR          @DT@D
      * CALCULATE YEARS AND DAY OF YEAR                                   @DT@D0
     C     #05           DIV       365           #03               3 0          CYY            @DT@D
     C                   MVR                     #03A              3 0          DDD            @DT@D
      * CALCULATE # OF LEAPS                                              @DT@D0
     C     #03           DIV       4             #02               2 0    92    # LEAPS        @DT@D
     C                   MVR                     #01               1 0    91    LEAP YEAR      @DT@D
     C   92
     CAN 91              SETOFF                                       91        1900 NOT LEAP  @DT@D
     C     #03A          ADD       1             #03A                           ADD TO DDD BY 1@DT@D
      * IF LEAP YEAR, REDUCE # OF LEAPS BY ONE.                           @DT@D0
     C   91#02           SUB       1             #02                                           @DT@D
     C     #03A          SUB       #02           #03A                 92                       @DT@D
      * IF DAYS NOT POSITIVE, ADJUST YEARS.                               @DT@D0
     C  N92#03A          ADD       365           #03A                                          @DT@D
     C  N92#03           SUB       1             #03                    91      NO LONGER LEAP @DT@D
      * DETERMINE IF NEW YEAR IS A LEAP.                                  @DT@D0
     C  N92
     CANN91#01           COMP      1                                      91    IS A LEAP      @DT@D
      * IF LEAP YEAR WAS MINUS                                            @DT@D0
     C  N92
     CAN 91#03A          ADD       1             #03A                                          @DT@D
      *                                                                   @DT@D0
     C     @DT@DA        TAG                                                                   @DT@D
      * CALCULATE MONTH AND DAY.                                          @DT@D0
     C                   Z-ADD     2             #02                    9293                   @DT@D
      * LEAP YEAR.                                                        @DT@D0
     C   91#03A          COMP      60                                 93  92                   @DT@D
     C   91
     CAN 93#03A          SUB       1             #03A                                          @DT@D
     C   91
     CAN 92              Z-ADD     3             #02                                           @DT@D
     C  N92#03A          LOOKUP    #JD(#02)                           93  93                   @DT@D
      *                                                                   @DT@D0
     C     #02           SUB       1             #02                                           @DT@D
     C     #03A          SUB       #JD(#02)      #03A                                          @DT@D
     C                   Z-ADD     #03A          #04               4 0                         @DT@D
     C                   MOVEL     #02           #04                                           @DT@D
     C                   Z-ADD     #03           ##MDY                                         @DT@D
     C                   MOVEL     #04           ##MDY                                         @DT@D
      *                                                                   @DT@D0
     C                   SETOFF                                       919293                   @DT@D
     C     @DT@DX        ENDSR                                                                 @DT@D
**  02 03 04 05 06 07 08 09 10 11 12 DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334365
