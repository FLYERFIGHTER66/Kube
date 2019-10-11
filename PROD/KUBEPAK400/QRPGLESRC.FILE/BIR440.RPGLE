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
      *  2/08/00 EFD UPDATE MINVT AND LKITM HERE FOR QTYS.
      *  3/02/00 EFD Z-ADD TDATE TO IMDTLS
      * 11/02/00 EFD GET REQ DATES IN SYNC FOR FUTURE ORDER RELEASE
      *  1/25/01 EFD ADD DAILY SALES FILE TO POST.
      *  3/08/01 EFD IF MINVT PROD CLASS BETWEEN 50 AND 70 DO NOT CHG
      *              HEADER REQUESTED DATE.  PER CHRIS
EFD02 * 5/07/01 EFD CALL GETORD$
      * 12/26/01 EFD ADD P.C. DAILY SALES FILE.
      *  7/11/02 EFD ADD POINSETTIA SOLD UPDATE.
      *  7/18/02 EFD CHANGE POINSETTIA SOLD UPDATE CALL TO ADD DATES.
      *
      *
     FFHORDRR   UF   E           K DISK
     FFHORDISCNTIF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    UF   E           K DISK
     FFALITEM   UF   E           K DISK
     FFDLOT     UF   E           K DISK
     FFDLOTRD   UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFOECTL    UF   E           K DISK
     FFIOROY    UF   E           K DISK
     FFMTAXF    UF   E           K DISK
     FFPAYMNT   UF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFARWRK    O  A E             DISK
     FFDSALE    O  A E             DISK
     FFHORDW    O  A E             DISK
     FFIORDW    O  A E             DISK
     FFLOTRN    O  A E           K DISK
     FFSLSDY    UF A E           K DISK
     FFPCSDY    UF A E           K DISK
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** JOBQ Y/N
     D  LDAJBQ                 4      4
      ** ROUTE I.D.
     D  LDARTE                 5      6
      ** ROUTE ALL
     D  LDAALL                 7      9
      ** BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                 10     15  0
      ** ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 16     21  0
      ** FORM NUMBER
     D**                                     21  30 LFORM
      ** PRINTER I.D.
     D  LPRTR                 31     40
      ** INVOICE DATE
     D  LDATE                 41     46  0
      ** SHIP FROM LOCATION
     D  LSHFR                 47     49
      ** BEGINING ORDER NUMBER
     D  LBORD                 50     55  0
      ** ENDING ORDER NUMBER
     D  LEORD                 56     61  0
      ** CANCEL  X=CANCEL
     D  LCANCL                62     62
      ** POINT OF SALE INVOICE Y/N
     D  LPOS                  63     63
      ** IMMEDIATE PRINT  Y/N
     D  LIMED                 64     64
      *? Function Prototypes
     D SELLOTINV       PR                  ExtPgm('SELLOTINV')                  Prototype
     D Dim_ORDER                      6  0                                      Order Number
     D Dim_SEQ#                       3  0                                      Order Seq# to Start
     D Dim_QTY                        7  1                                      Quantity
     D SEL_QTY         S              7  1

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp
      *
      *  GET TIME
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         MULT      10000.01      RDATE             6 0
     C                   MOVEL     RDATE         YY                2 0
     C     YY            IFGT      70
     C                   MOVEL     19            NDATE             2 0          19
     C                   ELSE
     C                   MOVEL     20            NDATE
     C                   ENDIF
     C                   MOVEL     NDATE         SDATE             8 0          19
     C                   MOVE      RDATE         SDATE                          19990815
     C                   MOVEL     'X'           LCANCL
     C     LDACOP        CHAIN     FGLDF                              99
      *
     C     HKEY          KLIST
     C                   KFLD                    CODE
     C                   KFLD                    LDACOP
     C                   KFLD                    LBORD
     C                   MOVE      'R'           CODE              1
     C     HKEY          SETLL     FHORDRR
     C     NXT           TAG
     C                   EXSR      CLEAR
     C                   READ      FHORDRR                                90
     C   90              GOTO      END
      *  Get EOD
     C     OHORD#        Chain     FHORDISCNT
     C                   If        not %Found(FHORDISCNT)
     C                   Eval      ADDSC1 = 0
     C                   EndIf
      *
     C     OHORD#        IFGT      LEORD
     C     LEORD         ANDGT     0
     C                   GOTO      END
     C                   ENDIF
      *
     C     OHHOLD        IFNE      'R'
     C                   GOTO      NXT
     C                   ENDIF
      * DO NOT PROCESS POS INVOICES UNLESS POS SELECTED
     C     LPOS          IFNE      'Y'
     C     OHPOS         ANDEQ     'Y'
     C                   GOTO      NXT
     C                   ENDIF
      * CHECK SHIP FROM
     C     LSHFR         IFNE      *BLANKS
     C     OHSHFR        ANDNE     LSHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
      * 70 - IMMEDIATE INVOICE FROM SHIPPING CONFIRMATION
      *
     C*          OHIMED    IFEQ 'Y'
     C*                    SETON                     70
     C*                    ELSE
     C                   SETOFF                                       70
     C*                    ENDIF
      *  GET INVOICE NUMBER.
      ** IMMED PRINT USE ASSIGNED NUMBER
      *
     C     OHINV#        IFGT      0
     C                   Z-ADD     OHINV#        INVC#             6 0
     C                   ELSE
     C                   Z-ADD     0             ICOMP             2 0
     C     ICOMP         CHAIN     FOECTL                             50
     C                   Z-ADD     OCNINV        INVC#             6 0
     C  N60              Z-ADD     INVC#         LBINV
     C  N60              Z-ADD     0             PK70              7 0
     C                   Z-ADD     INVC#         LEINV
     C                   ADD       1             OCNINV
     C  N50              UPDATE    ROECTL
     C                   SETON                                        60
      ** IF HERE A NEW INVOICE RELEASED
     C                   MOVE      *BLANKS       LCANCL
     C                   END
      *
      *
      * DETERMINE TAXABLE STATUS OF ORDER
      * N40=ORDER IS TAX EXEMPT  40=ORDER IS TAXABLE
      *
     C     OHTXST        IFEQ      'N'
     C                   SETON                                        40
     C                   ENDIF
     C     OHTXJU        CHAIN     FMTAXF                             50
      *
      *  READ IORDR.  ANY RECORD WITH A SHIP CODE 'R' WILL BE INVOICED
      *
     C     OHORD#        SETLL     FIORDR
     C                   CLEAR                   RARWRK
     C                   MOVEL     'N'           ATDEP             1
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
     C***        OIITYP    ANDEQ' '
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
     C                   Z-ADD     0             IMMERC
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
     C  N50IMPCL1        IFGE      '50'
     C     IMPCL1        ANDLE     '70'
     C                   SETON                                        46
     C                   ENDIF
      ** GET QTYS IF NEEDED
     C     OIQINV        IFGT      0
     C     OIQBOO        IFLE      0
     C     OIQORD        SUB       OIQSHP        TSTQTY           11 1
     C                   ADD       OIQINV        TSTQTY
     C                   SUB       OIQINV        IMQTOH
     C                   SUB       TSTQTY        IMQTAL
     C                   ELSE
     C                   SUB       OIQINV        IMQTOH
     C                   SUB       OIQINV        IMQTAL
     C                   Z-ADD     OIQINV        TSTQTY
     C                   END
     C     IMQTAL        IFLT      0
     C                   Z-ADD     0             IMQTAL
     C                   END
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   ADD       OIQINV        IMISSU
     C                   ADD       OIQINV        IMQMTD
     C     OIQINV        MULT(H)   IMUCST        WRKCST           11 4
     C                   ADD       WRKCST        IMCMTD
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C     IMQTOH        MULT      IMUCST        IMCSOH
     C                   ADD       ITMNET        IM$MTD
     C                   Z-ADD     TDATE         IMDTLS
     C  N50              UPDATE    RMINVT
     C     IKEY          CHAIN     FLKITM                             50
     C                   SUB       OIQINV        LKPOH
     C                   SUB       TSTQTY        LKPAL
     C     LKPAL         IFLT      0
     C                   Z-ADD     0             LKPAL
     C                   END
     C  N50              UPDATE    RLKITM
     C                   END
      ** GET POINSETTIAS
     C     IMPCL1        IFGE      '06'
     C     IMPCL1        ANDLE     '09'
     C     OISOW         ANDGT     0
     C                   Z-ADD     OISOW         ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     OIQINV        PQTY              7 0
     C                   Z-ADD     OISOW         SOWCYM
     C                   Z-ADD     OIRVDT        REQCYM
     C                   Z-ADD     ##MDY         SOWDAT
     C                   MOVEL     OIITEM        ITEM
     C                   MOVEL     OISIZE        SIZE
     C                   CALL      'PIRSLD'
     C                   PARM                    ITEM             12
     C                   PARM                    SIZE              3
     C                   PARM                    SOWDAT            6 0
     C                   PARM                    SOWCYM            7 0
     C                   PARM                    REQCYM            7 0
     C                   PARM                    PQTY
     C                   ENDIF                                                  PCL 06/09
      *
     C     IMLOTC        IFEQ      'Y'
     C     OILOTC        ANDEQ     'Y'
     C*    OILOT#        ANDNE     'CustomOrdr'
     C                   EXSR      LOTUPD
     C                   END
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
     C                   Z-ADD     0             #LINNT
     C                   Z-ADD     0             LINCST
     C     OIQINV        IFEQ      *ZEROS
     C     OIRQTY        ANDGT     0.0
     C                   Z-ADD     OIRQTY        OIQINV
     C                   ADD       OIRQTY        OIQSHP
     C                   MOVEL     'F'           OHPOS
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
      *  WRITE DSALE AND LINE ITEM WORK FILE.
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
      * 4/04/97 OK TO HERE CHECK DSALE
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C                   SETON                                        81
     C                   ENDIF
     C     OIQINV        IFEQ      *ZEROS
     C                   SETOFF                                       81
     C                   ENDIF
     C  N81              GOTO      NDSALE
     C                   MOVEL     'A'           SDSTAT
     C                   Z-ADD     OHSACU        SDCUST
     C                   MOVEL     CTYP          SDCODE
     C                   Z-ADD     INVC#         SDINV#
     C   70              Z-ADD     OHINV#        SDINV#
     C                   MOVEL     *BLANKS       SDSUFF
     C                   MOVEL     OIITEM        SDITEM
     C                   MOVEL     OISIZE        SDSIZE
     C                   Z-ADD     OISEQ#        SDSEQ#
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        SDTDAT
     C                   Z-ADD     OIQINV        SDQSHP
     C                   MOVEL     OIUUOM        SDUUOM
     C                   Z-ADD     OIUPRI        SDUPRI
     C                   Z-ADD     OIUCST        SDUCST
     C                   MOVEL     OICTCD        SDCTCD
     C                   MOVEL     OHSLM1        SDSLM1
     C                   Z-ADD     OICOM1        SDCOM1
     C                   MOVEL     OHSLM2        SDSLM2
     C                   Z-ADD     OICOM2        SDCOM2
     C                   MOVEL     TERR          SDTERR
     C                   MOVEL     IMPCL1        SDPCL1
     C                   MOVEL     IMPCL2        SDPCL2
     C                   MOVEL     OHSLST        SDSTST
     C                   MOVEL     OHTXST        SDTXST
     C                   MOVEL     OHTXJU        SDTXJU
     C                   Z-ADD     TOTFET        SDFET$
     C                   Z-ADD     TXPCT1        SDPCT1
     C                   Z-ADD     TXPCT2        SDPCT2
     C                   Z-ADD     TXPCT3        SDPCT3
     C                   Z-ADD     OHCOMP        SDCOMP
     C                   Z-ADD     OIQDDC        SDDIS1
     C                   Z-ADD     OHTRDC        SDTRDC
WJB  C                   ADD       ADDSC1        SDTRDC
     C                   Z-ADD     OHORD#        SDORD#
     C                   MOVEL     OHPONO        SDPONO
     C     IMMERC        IFGT      0
     C                   Z-ADD     IMMERC        SDGSLS
     C                   ELSE
     C                   Z-ADD     GDSALE        SDGSLS
     C                   END
     C                   MOVEL     OIWHSE        SDWHSE
     C                   Z-ADD     LDATE         SDDTLA
     C                   Z-ADD     TIMOD         SDTIME
     C                   MOVEL     USERID        SDUSER
     C**                   MOVELWSID      SDWSID
     C                   MOVEL     OIITYP        SDITYP
     C                   Z-ADD     01            SDTTYP
     C                   MOVEL     OHIOCD        SDIOCD
     C**                   Z-ADDOIEXT$    SDEXT$
      * 5/06/98
     C     OISIZE        IFNE      'AST'
     C                   Z-ADD     #LINNT        SDEXT$
     C                   Z-ADD     LINCST        SDCST$
     C                   ELSE
     C                   Z-ADD     0             SDEXT$
     C                   Z-ADD     0             SDCST$
     C                   Z-ADD     OIQINV        ASTQTY           11 1
     C                   Z-ADD     #LINNT        AST$              9 2
     C                   END
     C*                    Z-ADD#LINNT    SDEXT$
     C                   Z-ADD     LINCST        SDCST$
     C                   MOVEL     OIROUT        SDROUT
     C                   Z-ADD     OISTOP        SDSTOP
     C                   MOVEL     OICWT         SDCWTF
     C                   Z-ADD     OIWGSH        SDWGSH
     C                   Z-ADD     OHARCU        SDARCU
     C                   Z-ADD     OHCUST        SDSHCU
     C                   Z-ADD     OHBLCU        SDBLCU
     C                   MOVEL     OIRSCD        SDRSCD
     C                   MOVEL     OIPRAL        SDPRAL
     C                   MOVEL     OIBPUM        SDBUOM
     C                   MOVEL     OIBLUM        SDBLUM
     C                   Z-ADD     OIMUL2        SDMUL2
     C                   Z-ADD     *ZEROS        SDQCRD
     C                   Z-ADD     OIUWGT        SDUWGT
     C                   MOVEL     IMPCL3        SDPCL3
     C                   MOVEL     OILOTC        SDLOTC
     C                   MOVEL     OILOT#        SDLOT#
     C                   WRITE     RDSALE
      ** UPDATE P.C. DAILY FILE
     C     PCSKEY        KLIST
     C                   KFLD                    SDATE
     C                   KFLD                    IMPCL1
     C     PCSKEY        CHAIN     FPCSDY                             90
     C   90              DO
     C                   CLEAR                   RPCSDY
     C                   Z-ADD     SDATE         SPSHDT
     C                   MOVEL     IMPCL1        SPPCL1
     C                   ENDDO
     C                   ADD       SDEXT$        SPTSLS
     C                   ADD       SDQSHP        SPTSUN
     C   90              WRITE     RPCSDY
     C  N90              UPDATE    RPCSDY
     C     NDSALE        TAG
      *
      * WRITE IORDW
      *
     C                   MOVEL     'A'           WISTAT
     C                   Z-ADD     INVC#         WIINV#
     C                   ADD       2             NWLINE
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
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
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
     C                   Z-ADD     OIORD#        WIORD#
     C                   MOVEL     OIPRAL        WIPRAL
     C                   MOVEL     OIBPUM        WIBUOM
     C                   MOVEL     OISUOM        WISUOM
     C                   MOVEL     OIBLUM        WIBLUM
     C                   MOVEL     OILOTC        WILOTC
     C                   Z-ADD     OITAGS        WITAGS
     C                   MOVEL     OIPPDC        WIPPDC
      *
     C                   WRITE     RIORDW
     C                   SETOFF                                       8183
     C     WIAMT         IFNE      0
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
     C                   SETOFF                                       30
     C     OIQORD        IFLE      OIQSHP
     C                   SETON                                        30
     C                   ENDIF
     C     OIQBOO        IFLE      0.0
     C     OIQINV        ANDGT     0.0
     C                   SETON                                        30
     C                   ENDIF
     C     OIKEY         KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     OIKEY         CHAIN     FIORDR                             50
      *
     C                   MOVE      OIDTRQ        LRQDT             6 0
     C   30              Z-ADD     LDATE         LRQDT
     C  N30OIORDT        IFGT      *ZEROS
     C                   MOVE      OIORDT        LRQDT             6 0
     C                   END
     C                   Z-ADD     LRQDT         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RLRQDT            7 0
     C                   Z-ADD     0             OIQINV
     C                   Z-ADD     0             OIWGSH
      *
      * UPDATE IORDR
      *
     C   30              MOVEL     'D'           OISTAT
     C                   Z-ADD     LDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C**                   MOVELWSID      OIWSID
     C   30              MOVEL     'Y'           OICOFL
     C                   MOVEL     ' '           OINPSL
     C                   Z-ADD     *ZEROS        OIRQTY
     C                   Z-ADD     LRQDT         OIDTRQ
     C                   Z-ADD     *ZEROS        OIORDT
     C                   Z-ADD     RLRQDT        OIRVDT
     C                   MOVEL     'H'           OISHCD
     C                   UPDATE    RIORDR
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
WJB  C*                  Z-ADD     OHTRDC        DISHLD            4 2    52
WJB  C     ADDSC1        ADD       OHTRDC        DISHLD            4 2    52
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
     C*                    ADD  STTAX     TXMMT1
      *
     C*                    ADD  WKTAX2    TXMTX2
     C*                    ADD  WKFTX2    TXMTX2
     C*                    ADD  WKSTX2    TXMTX2
     C     WKFTX2        MULT(H)   WXPCT2        WKFTX2
     C                   ADD       WKFTX2        COTAX
     C     WKSTX2        MULT(H)   WXPCT2        WKSTX2
     C                   ADD       WKSTX2        COTAX
     C*                    ADD  COTAX     TXMMT2
      *
     C*                    ADD  WKTAX3    TXMTX3
     C*                    ADD  WKFTX3    TXMTX3
     C*                    ADD  WKSTX3    TXMTX3
     C     WKFTX3        MULT(H)   WXPCT3        WKFTX3
     C                   ADD       WKFTX3        CYTAX
     C     WKSTX3        MULT(H)   WXPCT3        WKSTX3
     C                   ADD       WKSTX3        CYTAX
     C*                    ADD  CYTAX     TXMMT3
      *
     C     ARNTAX        TAG
     C                   ADD       NETPRC        TXMGRS            9 4
     C     FRT           SUB       WKFNTX        FRTTAX            7 2
     C     SPECL         SUB       WKSNTX        SPCTAX            7 2
     C                   ADD       FRTTAX        TXMGRS
     C                   ADD       SPCTAX        TXMGRS
     C*                    ADD  WKNTAX    TXMRES
     C*                    Z-ADDTDATE     TXTDLA
     C                   Z-ADD     TIMOD         TXTIME
     C                   MOVEL     USERID        TXUSER
     C**                   MOVELWSID      TXWSID
     C                   UPDATE    RMTAXF
      *
      *  CALCULATE TOTAL INVOICE AMOUNT.
      *
     C                   ADD       MRCH$         INVAMT           11 2
     C                   ADD       MRCH$         SLSAMT           11 2
     C                   ADD       STTAX         INVAMT
     C                   ADD       COTAX         INVAMT
     C                   ADD       CYTAX         INVAMT
     C                   ADD       FRT           INVAMT
     C                   ADD       SPECL         INVAMT
     C                   ADD       SPECL         SLSAMT
     C                   ADD       DISCNT        INVAMT
     C                   ADD       DISCNT        SLSAMT
     C*    MRCH$         MULT(H)   EODPCT        EOD$              7 2
     C*                  ADD       EOD$          INVAMT
     C*                  ADD       EOD$          SLSAMT
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
     C*                    MOVELOHSVI2    WHSVI2
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
     C*                    Z-ADDOHVLDC    WHVLDC
     C*                    MOVELOHFVDC    WHFVDC
     C                   Z-ADD(H)  INVAMT        WH$AMT
     C                   MOVEL     OHIMFG        WHIMFG
     C                   MOVEL     OHPOS         WHPOS
     C                   Z-ADD     OHORD#        WHORD#
      *
     C                   WRITE     RHORDW
      *
      *  WRITE ARWRK
      *
     C*                    SETON                     80
     C*                    EXCPT
     C*                    SETOF                     80
      *
     C                   MOVEL     'A'           ATSTAT
     C                   Z-ADD     OHARCU        ATCUST
     C                   Z-ADD     INVC#         ATINV#
     C                   Z-ADD     0             ATSEQ#
     C                   MOVE      *BLANKS       ATSUFF
     C                   MOVEL     OHTYPE        ATCTYP
     C                   MOVEL     OHSLM1        ATSLM1
     C                   Z-ADD     OHSCM1        ATCOM1
     C                   MOVEL     OHSLM2        ATSLM2
     C                   Z-ADD     OHSCM2        ATCOM2
     C                   MOVEL     TERR          ATTERR
     C                   Z-ADD     01            ATTTYP
     C                   Z-ADD     LDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ATTDAT
     C                   Z-ADD     ##CYMD        LDATEC            7 0
     C                   Z-ADD     DUEDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ATDUDT
     C                   Z-ADD     OHCOMP        ATCOMP
     C                   Z-ADD     INVAMT        AT$AMT
     C*                    Z-ADDTRDDIS    ATQDI$
     C*                    Z-ADDQTYDIS    ATDIS$
     C                   Z-ADD     TRDDIS        ATDIS$
     C                   Z-ADD     QTYDIS        ATQDI$
     C                   Z-ADD     FRT           ATFRT$
     C                   Z-ADD     SPECL         ATSPL$
     C                   Z-ADD     STTAX         ATAMT1
     C                   Z-ADD     COTAX         ATAMT2
     C                   Z-ADD     CYTAX         ATAMT2
     C                   Z-ADD     0             ATFET$
     C                   Z-ADD     MRCH$         ATMER$
     C                   Z-ADD     TDATE         ATDTLA
     C                   Z-ADD     TIMOD         ATTIME
     C                   MOVEL     USERID        ATUSER
     C                   Z-ADD     CSHDUE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ATDCDT
     C                   Z-ADD     OHORD#        ATORD#
     C                   Z-ADD     CSHDS$        ATDISC
     C                   Z-ADD     OHCUST        ATSHCU
     C                   Z-ADD     OHSACU        ATSACU
     C                   Z-ADD     OHBLCU        ATBLCU
     C                   MOVEL     OHPOS         ATPOS
     C                   MOVEL     OHPONO        ATPONO
     C                   MOVEL     OHTXJU        ATTAXJ
     C                   MOVEL     OHSHFR        ATSHFR
      ** CHECK FOR PAYMENT
     C     OHORD#        SETLL     FPAYMNT
     C     RRPAY         TAG
     C     OHORD#        READE     FPAYMNT                                90
     C  N90              DO
     C     PYCASH        IFEQ      0
     C                   GOTO      RRPAY
     C                   END
     C     PYSTAT        IFNE      'D'
     C                   Z-ADD     PYCASH        ATINAP
     C                   MOVEL     PYBANK        ATBANK
     C                   MOVEL     PYCRCD        ATCRCD
     C                   Z-ADD     PYCRC#        ATCRC#
     C                   Z-ADD     PYCRCE        ATCRCE
     C                   MOVEL     PYCRCA        ATCRCA
     C                   MOVEL     PYCHEK        ATCKNO
     C                   Z-ADD     LDATEC        PYINDT
     C                   Z-ADD     INVC#         PYINV#
     C                   MOVEL     'D'           PYSTAT
     C                   UPDATE    RPAYMNT
     C                   ELSE
     C                   GOTO      RRPAY
     C                   END
     C                   ENDDO
      *
     C                   WRITE     RARWRK
      *
     C                   ADD       1             ATSEQ#
     C     NXTPAY        TAG
     C     OHORD#        READE     FPAYMNT                                90
     C   90              GOTO      ENDARW
     C  N90              DO
     C     PYSTAT        IFNE      'D'
     C                   ADD       1             ATSEQ#
     C                   Z-ADD     PYCASH        ATINAP
     C                   MOVEL     PYBANK        ATBANK
     C                   MOVEL     PYCRCD        ATCRCD
     C                   Z-ADD     PYCRC#        ATCRC#
     C                   MOVEL     PYCRCA        ATCRCA
     C                   Z-ADD     PYCRCE        ATCRCE
     C                   MOVEL     PYCHEK        ATCKNO
     C                   Z-ADD     LDATEC        PYINDT
     C                   Z-ADD     INVC#         PYINV#
     C                   MOVEL     'D'           PYSTAT
     C                   UPDATE    RPAYMNT
     C                   Z-ADD     0             AT$AMT
     C                   Z-ADD     0             ATQDI$
     C                   Z-ADD     0             ATDIS$
     C                   Z-ADD     0             ATFRT$
     C                   Z-ADD     0             ATSPL$
     C                   Z-ADD     0             ATAMT1
     C                   Z-ADD     0             ATAMT2
     C                   Z-ADD     0             ATAMT2
     C                   Z-ADD     0             WHFET$
     C                   Z-ADD     0             ATMER$
     C                   Z-ADD     0             ATDCDT
     C                   Z-ADD     OHORD#        ATORD#
     C                   Z-ADD     0             ATDISC
     C                   WRITE     RARWRK
     C                   END
     C                   GOTO      NXTPAY
     C                   ENDDO
      *
     C     ENDARW        TAG
      *
      *  UPDATE FSLSDY
      *
     C     SLSKEY        KLIST
     C                   KFLD                    SDATE
     C                   KFLD                    OHSHFR
     C     SLSKEY        CHAIN     FSLSDY                             90
     C   90              DO
     C                   CLEAR                   RSLSDY
     C                   Z-ADD     SDATE         SYSHDT
     C                   MOVEL     OHSHFR        SYSHFR
     C                   ENDDO
     C                   ADD       SLSAMT        SYTSLS
     C   90              WRITE     RSLSDY
     C  N90              UPDATE    RSLSDY
      *
      *  WRITE ARWRK, ORDER HEADER WORK, AND ORDER TOTAL WORK.
      *            INCREMENT NEXT INVOICE NUMBER
      *
     C                   ADD       1             INVC#
      *
      *  RESET TERRITORY SUBR EXECUTE FLAG
     C                   SETOFF                                       61
      *
      *  UPDATE ORDER HEADER RECORD '45' ON INDICATES ACTIVE ITEMS EXIST
      *
     C                   MOVEL     'R'           CODE              1
     C  N45              MOVEL     'D'           OHSTAT
     C  N45              MOVEL     'Y'           OHCOFL
     C                   MOVEL     'H'           OHHOLD
     C                   MOVEL     'Y'           OHIVCD
     C                   MOVEL     ' '           OHIMED
     C                   MOVEL     USERID        OHUSER
     C**                   MOVELWSID      OHWSID
     C                   Z-ADD     TIMOD         OHTIME
     C                   Z-ADD     TDATE         OHDTLA
     C                   Z-ADD     *ZEROS        OHINV#
     C                   Z-ADD     *ZEROS        OHCASH
     C**                   Z-ADD*ZEROS    OHORDT
     C   45
     CANN46OHORDT        IFGT      0
     C     OHPOS         ANDEQ     'F'
     C                   Z-ADD     OHORDT        OHDTRQ
     C                   END
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OHDTRY
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BIR440'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   SETOFF                                       4546
      *
EFD02 * GET OPEN ORDER VALUE
EFD02C                   CALL      'GETORD$'
EFD02C                   PARM                    OHORD#
EFD02C                   PARM                    NTOTD             9 2
      *
     C                   GOTO      NXT
      *
     C     END           TAG
      *
      *  ON LAST RECORD UPDATE INVOICE NUMBER IN CONTROL FILE.
      *
     C                   SETON                                        LR
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
     C                   Z-ADD     0             SLSAMT
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
     C                   MOVEL     'A'           SDSTAT
     C                   Z-ADD     OHSACU        SDCUST
     C                   MOVEL     CTYP          SDCODE
     C                   Z-ADD     INVC#         SDINV#
     C** 70                Z-ADDOHINV#    SDINV#
     C                   MOVEL     *BLANKS       SDSUFF
     C                   MOVEL     ORITEM        SDITEM
     C                   MOVEL     ORSIZE        SDSIZE
     C                   Z-ADD     OISEQ#        SDSEQ#
EFD  C                   MOVEL     ORITEM        OIITEM
EFD  C                   MOVEL     ORSIZE        OISIZE
EFD  C                   MOVEL     *BLANKS       OIWHSE
EFD  C     IKEY          CHAIN     FMINVT                             50
EFD  C   50              Z-ADD     GDSALE        SDGSLS
EFD  C  N50IMMERC        IFEQ      0
EFD  C                   Z-ADD     GDSALE        SDGSLS
EFD  C                   ENDIF
EFD  C  N50IMMERC        IFGT      0
EFD  C                   Z-ADD     IMMERC        SDGSLS
EFD  C                   ENDIF
EFD  C*                    END
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
EFD  C                   Z-ADD     ##CYMD        SDTDAT
     C                   Z-ADD     ROYINV        SDQSHP
     C                   MOVEL     'EA'          SDUUOM
     C                   Z-ADD     ORUPRI        SDUPRI
     C                   Z-ADD     0             SDUCST
     C                   MOVEL     OICTCD        SDCTCD
     C                   MOVEL     OHSLM1        SDSLM1
     C                   Z-ADD     0             SDCOM1
     C                   MOVEL     OHSLM2        SDSLM2
     C                   Z-ADD     0             SDCOM2
     C                   MOVEL     TERR          SDTERR
     C                   MOVEL     IMPCL1        SDPCL1
     C                   MOVEL     IMPCL2        SDPCL2
     C                   MOVEL     OHSLST        SDSTST
     C                   MOVEL     OHTXST        SDTXST
     C                   MOVEL     OHTXJU        SDTXJU
     C                   Z-ADD     TOTFET        SDFET$
     C                   Z-ADD     TXPCT1        SDPCT1
     C                   Z-ADD     TXPCT2        SDPCT2
     C                   Z-ADD     TXPCT3        SDPCT3
     C                   Z-ADD     OHCOMP        SDCOMP
     C                   Z-ADD     0             SDDIS1
     C                   Z-ADD     OHTRDC        SDTRDC
WJB  C                   ADD       ADDSC1        SDTRDC
     C                   Z-ADD     OHORD#        SDORD#
     C                   MOVEL     OHPONO        SDPONO
     C                   MOVEL     OIWHSE        SDWHSE
     C                   Z-ADD     LDATE         SDDTLA
     C                   Z-ADD     TIMOD         SDTIME
     C                   MOVEL     USERID        SDUSER
     C***                  MOVELWSID      SDWSID
     C                   MOVEL     OIITYP        SDITYP
     C                   Z-ADD     01            SDTTYP
     C                   MOVEL     OHIOCD        SDIOCD
     C**                   Z-ADDOIEXT$    SDEXT$
     C                   Z-ADD     #LINNT        SDEXT$
     C                   Z-ADD     LINCST        SDCST$
     C                   MOVEL     OIROUT        SDROUT
     C                   Z-ADD     OISTOP        SDSTOP
     C                   MOVEL     OICWT         SDCWTF
     C                   Z-ADD     OIWGSH        SDWGSH
     C                   Z-ADD     OHARCU        SDARCU
     C                   Z-ADD     OHCUST        SDSHCU
     C                   Z-ADD     OHBLCU        SDBLCU
     C                   MOVEL     OIRSCD        SDRSCD
     C                   MOVEL     OIPRAL        SDPRAL
     C                   MOVEL     OIBPUM        SDBUOM
     C                   MOVEL     OIBLUM        SDBLUM
     C                   Z-ADD     OIMUL2        SDMUL2
     C                   Z-ADD     *ZEROS        SDQCRD
     C                   Z-ADD     OIUWGT        SDUWGT
     C                   MOVEL     IMPCL3        SDPCL3
     C                   MOVEL     OILOTC        SDLOTC
     C                   MOVEL     OILOT#        SDLOT#
     C                   WRITE     RDSALE
     C                   Z-ADD     0             ORQINV
     C                   UPDATE    RIOROY
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
     C* N75                SETON                     79
     C* N75                EXCPT
     C*                    SETOF                     79
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
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DTNUMB            5 0
     C                   ADD       TCTDAS        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         DUEDTE            6 0
      *  CALCULATE DISCOUNT DUE DATE.
      *
     C                   ADD       TCTDAY        DTNUMB
     C                   Z-ADD     DTNUMB        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
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
      *  **************
      *  * LOT UPDATE *
      *  **************
      *
     C     LOTUPD        BEGSR
      /Free
         SEL_QTY = OIQINV;
         SELLOTINV(OIORD#:OISEQ#:SEL_QTY);
      /End-Free
     C*                  Call      'SELLOTINV'
     C*                  Parm                    OIORD#
     C*                  Parm                    OISEQ#
     C*                  Parm                    OIQINV
     C                   LeaveSR
      ** The Rest of this Subroutine is obsolete...  do not run it !!
      ** GET QUANTITY TO RELIEVE SHIPPED
     C                   Z-ADD     OIQINV        LOTQTY           11 1
      ** GET QUANTITY TO RELIEVE ALLOCATED
     C     OIQORD        SUB       OIQSHP        ALAQTY           11 1
     C                   SUB       OIQBOO        ALAQTY
     C                   ADD       LOTQTY        ALAQTY
      ** GET ITEM ALLOCATION RECORDS
     C     ALIKEY        KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     ALIKEY        SETLL     FALITEM
     C     NXTALI        TAG
     C     ALIKEY        READE     RALITEM                                90
     C   90              GOTO      ENDALI
     C     ALAQTY        IFLE      AIQTOA
     C     AIQTOA        SUB       ALAQTY        LEFTAL           11 1
     C     AIQTOA        SUB       LOTQTY        LEFLOT           11 1
     C     LOTKEY        KLIST
     C                   KFLD                    AIITEM
     C                   KFLD                    AISIZE
     C                   KFLD                    AIWHSE
     C                   KFLD                    AISOWD
     C                   KFLD                    AIGLOC
      ** UPDATE ORIG LOT INFO
     C     LOTKEY        CHAIN     FDLOT                              91
     C  N91              DO
     C                   SUB       ALAQTY        LDQTAL
     C                   SUB       LOTQTY        LDQTOH
     C     LDQTOH        SUB       LDQTAL        LDQTAV
     C                   ADD       LOTQTY        LDQTSP
     C                   Z-ADD     TDATE         LDDTLA
     C                   Z-ADD     TIMOD         LDTIME
     C                   MOVEL     USERID        LDUSER
     C                   UPDATE    RDLOT
     C                   ENDDO
      ** UPDATE LOT READY DATE INFO
     C                   MOVEL     'A'           CODE              1
     C     LTRKEY        KLIST
     C                   KFLD                    AIITEM
     C                   KFLD                    AISIZE
     C                   KFLD                    AISOWD
     C                   KFLD                    AICRDY
     C                   KFLD                    AIGLOC
     C*                    KFLD           CODE
     C*                    KFLD           AICUST
     C     LTRKEY        CHAIN     FDLOTRD                            91
     C  N91              DO
     C                   SUB       ALAQTY        LRQTAL
     C                   SUB       LOTQTY        LRQTOH
     C                   Z-ADD     TDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   MOVEL     USERID        LRUSER
      ** GET RID OF REC IF NO QTY ON HAND
     C     LRQTOH        IFGT      0
     C                   UPDATE    RDLOTRD
     C                   ELSE
     C                   DELETE    RDLOTRD
     C                   END
     C                   ENDDO
      ** OUTPUT LOTRN RECORD
     C                   MOVEL     LRITEM        FLITEM
     C                   MOVEL     LRSIZE        FLSIZE
     C                   MOVEL     LRWHSE        FLWHSE
     C                   MOVEL     LRSOWD        FLSOWD
     C                   MOVEL     LRGLOC        FLGLOC
     C                   MOVEL     LRPHYT        FLPHYT
     C                   Z-ADD     LRCOMP        FLCOMP
     C                   MOVEL     LRCPHY        FLLPHY
     C                   MOVEL     LRCPHY        FLNPHY
     C                   Z-ADD     LRCRDY        FLLRDY
     C                   Z-ADD     LRCRDY        FLNRDY
     C                   MOVEL     LRCLOC        FLLLOC
     C                   MOVEL     LRCLOC        FLNLOC
     C                   MOVEL     LRCODE        FLLCOD
     C                   MOVEL     LRCODE        FLNCOD
     C                   Z-ADD     LRCUST        FLLCST
     C                   Z-ADD     LRCUST        FLNCST
     C                   Z-SUB     LOTQTY        FLQTY
     C                   Z-ADD     0             FLSOWN
     C                   MOVEL     'SLD'         FLREAS
     C                   Z-ADD     RDATE         FLACTD
     C                   Z-ADD     TIMOD         FLTIME
     C                   MOVEL     USERID        FLUSER
     C                   WRITE     RLOTRN
      ** GET RID OF BALANCE
     C                   Z-ADD     0             LOTQTY
     C                   Z-ADD     0             ALAQTY
     C                   SUB       LOTQTY        AIQTOA
     C     AIQTOA        IFGT      0
     C                   UPDATE    RALITEM
     C                   ELSE
     C                   DELETE    RALITEM
     C                   END
     C                   GOTO      ENDALI
     C                   END                                                    LOQ<ALLOC
      ** IF HERE NOT ENOUGH IN 1 ALITEM RECORD TO GET RID OF BALANCE
     C     ALAQTY        SUB       AIQTOA        LEFTAL           11 1
     C     LOTQTY        SUB       AIQTOA        LEFLOT           11 1
      ** UPDATE ORIG LOT INFO
     C     LOTKEY        CHAIN     FDLOT                              91
     C  N91              DO
     C                   SUB       AIQTOA        LDQTAL
     C                   SUB       AIQTOA        LDQTOH
     C     LDQTOH        SUB       LDQTAL        LDQTAV
     C                   ADD       AIQTOA        LDQTSP
     C                   Z-ADD     TDATE         LDDTLA
     C                   Z-ADD     TIMOD         LDTIME
     C                   MOVEL     USERID        LDUSER
     C                   UPDATE    RDLOT
     C                   ENDDO
      ** UPDATE LOT READY DATE INFO
     C     LTRKEY        CHAIN     FDLOTRD                            91
     C  N91              DO
     C                   SUB       AIQTOA        LRQTAL
     C                   SUB       AIQTOA        LRQTOH
     C                   Z-ADD     TDATE         LRDTLA
     C                   Z-ADD     TIMOD         LRTIME
     C                   MOVEL     USERID        LRUSER
      ** GET RID OF REC IF NO QTY ON HAND
     C     LRQTOH        IFGT      0
     C                   UPDATE    RDLOTRD
     C                   ELSE
     C                   DELETE    RDLOTRD
     C                   END
     C                   ENDDO
      ** OUTPUT LOTRN RECORD
     C                   MOVEL     LRITEM        FLITEM
     C                   MOVEL     LRSIZE        FLSIZE
     C                   MOVEL     LRWHSE        FLWHSE
     C                   MOVEL     LRSOWD        FLSOWD
     C                   MOVEL     LRGLOC        FLGLOC
     C                   MOVEL     LRPHYT        FLPHYT
     C                   Z-ADD     LRCOMP        FLCOMP
     C                   MOVEL     LRCPHY        FLLPHY
     C                   MOVEL     LRCPHY        FLNPHY
     C                   Z-ADD     LRCRDY        FLLRDY
     C                   Z-ADD     LRCRDY        FLNRDY
     C                   MOVEL     LRCLOC        FLLLOC
     C                   MOVEL     LRCLOC        FLNLOC
     C                   MOVEL     LRCODE        FLLCOD
     C                   MOVEL     LRCODE        FLNCOD
     C                   Z-ADD     LRCUST        FLLCST
     C                   Z-ADD     LRCUST        FLNCST
     C                   Z-SUB     AIQTOA        FLQTY
     C                   Z-ADD     0             FLSOWN
     C                   MOVEL     'SLD'         FLREAS
     C                   Z-ADD     RDATE         FLACTD
     C                   Z-ADD     TIMOD         FLTIME
     C                   MOVEL     USERID        FLUSER
     C                   WRITE     RLOTRN
      ** GET RID OF BALANCE
     C                   Z-ADD     LEFLOT        LOTQTY
     C                   Z-ADD     LEFTAL        ALAQTY
     C                   DELETE    RALITEM
     C                   GOTO      NXTALI
      ** END OF ALLOCATION RECORDS CHECK IF ANY QTY LEFT.
     C     ENDALI        TAG
     C                   ENDSR
      *
