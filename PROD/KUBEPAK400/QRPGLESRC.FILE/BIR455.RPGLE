      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1998
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
      **PROGRAM NAME-------- BIR455  - CR MEMO PROCESSING PROGRAM
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      *APPLICATION--------- ORDER PROCESSING
      **DESCRIPTION--------- THIS PROGRAM WILL PROCESS ACTIVE CR MEMO
      **                     HEADER RECORDS THAT ARE TO BE RELEASED. IT
      **                     UPDATES THE DAILY LOT CONTROL/CATCH WEIGHT
      **                     FILE, THE ORDER FILES. THE PROGRAM BUILDS
      **                     CR MEMO WORK FILES, AND CLOSES CR MEMO.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  1/25/01 EFD ADD DAILY SALES FILE TO PROGRAM
      *  3/06/01 EFD03 USE DISCOUNTS FROM CRM HEADER
      * 12/26/01 EFD ADD P.C. DAILY SALES FILE.
      *  5/04/02 EFD USE OHPOS TO DECIDE IF AUTO SPREAD CM.
      *
     FFHORCR    UF   E           K DISK
     FFIORCR    UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
     FFMTAXF    IF   E           K DISK
     FFTAXD     UF A E           K DISK
     FFMTERM    IF   E           K DISK
     FFARWRK    O  A E             DISK
     FFDSALE    O  A E             DISK
     FFHORCW    O  A E             DISK
     FFIORCW    O  A E             DISK
     FFSLSDY    UF A E           K DISK
     FFPCSDY    UF A E           K DISK
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
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
      ** BEGINING CREDIT NUMBER
     D  LBCRM                  4      9  0
      ** ENDING CREDIT NUMBER
     D  LECRM                 10     15  0
      ** CREDIT MEMO DATE
     D  LDATE                 16     21  0
      ** CREDIT MEMO END DATE
     D  LENDT                 22     27  0
      ** SHIP FROM LOCATION
     D  LSHFR                 28     30
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 31     31
      ** BILL TO CUSTOMER
     D  LBLCS                 32     37  0
      ** SHIP TO CUSTOMER
     D  LSHCS                 38     43  0
      ** LAST INVOICE CREDITED
     D  LBINV                 44     49  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    113
      ** NUMBER OF COPIES
     D  LCOPY                114    115  0
      ** JOBQ
     D  LJOB                 116    116
      ** HOLD PRINT OUTPUT
     D  LHOLD                117    120
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                121    124
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
      *
      *  GET TIME
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         MULT      10000.01      RDATE             6 0
     C                   Z-ADD     LDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LDATEC            7 0
     C                   MOVEL     RDATE         YY                2 0
     C     YY            IFGT      70
     C                   MOVEL     19            NDATE             2 0          19
     C                   ELSE
     C                   MOVEL     20            NDATE
     C                   ENDIF
     C                   MOVEL     NDATE         SDATE             8 0          19
     C                   MOVE      RDATE         SDATE                          19970815
      *
     C     HKEY          KLIST
     C                   KFLD                    LBCRM
     C     HKEY          SETLL     FHORCR
     C     NXT           TAG
     C                   EXSR      CLEAR
     C                   READ      FHORCR                                 90
     C   90              GOTO      END
     C                   Z-ADD     0             DREC              9 0
     C     OHCRM#        IFGT      LECRM
     C     LECRM         ANDGT     0
     C                   GOTO      END
     C                   ENDIF
      ** CHECK FOR POSTED
     C     OHSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   END
      *
      * CHECK IF SAME SHIP FROM
     C*          LSHFR     IFGT *BLANKS
     C*          OHSHFR    ANDNELSHFR
     C*                    GOTO NXT
     C*                    ENDIF
      *
      * CHECK IF SAME USERID
     C*          USERID    IFNE OHUSER
     C*                    GOTO NXT
     C*                    ENDIF
      *
      *
     C**         OHORDT    IFGT *ZEROS
     C**                   Z-ADDOHORDT    UPDTRQ  60
     C***                  ENDIF
      *
      * DETERMINE TAXABLE STATUS OF ORDER
      *     N40=ORDER IS TAX EXEMPT  40=ORDER IS TAXABLE
      *
     C     OHTXST        IFEQ      'N'
     C                   SETON                                        40
     C                   ENDIF
     C     OHTXJU        CHAIN     FMTAXF                             50
      *
      *  READ IORCR.
      *
     C     OHCRM#        SETLL     FIORCR
     C                   CLEAR                   RARWRK
     C                   MOVEL     'N'           ATDEP             1
     C     NXTI          TAG
     C     OHCRM#        READE     FIORCR                                 20
     C   20              GOTO      HEADER
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
      *  GET S/A CUSTOMER INFORMATION
      *
     C  N61              EXSR      GETTR
      *
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
      ** AFFECT INVENTORY
     C  N50OHAFIV        IFEQ      'Y'
     C                   Z-SUB     OIQCRD        WRKQ             11 1
     C                   ADD       WRKQ          IMQTOH
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C     IKEY          CHAIN     FLKITM                             77
     C                   ADD       WRKQ          LKPOH
     C  N77              UPDATE    RLKITM
     C                   ENDIF                                                  OHAFIV=Y
     C                   ENDIF
      *
      *  DO PRICING CALCULATIONS AND ACCUMULATE TOTALS.
      *
     C     OIITYP        IFEQ      'C'
     C**                   Z-ADD0         WIAMT
     C**                   Z-ADD0         WIUPRI
     C                   GOTO      SKIP
     C                   ENDIF
     C     OIITYP        COMP      'F'                                    42
     C     OIITYP        COMP      'S'                                    43
     C   42
     COR 43              GOTO      ARND
      *
      *
      * ACCUMULATE TAXABLE AMOUNTS AS REQUIRED
      *
     C  N40              ADD       OIEXT$        WKNTAX
     C  N40              GOTO      TXPASS
      *
     C     OITXCD        IFEQ      'N'
     C                   ADD       OIEXT$        WKNTAX            9 4
     C                   GOTO      TXPASS
     C                   ENDIF
      *
     C     OITXST        COMP      'Y'                                    57
     C     OITXCT        COMP      'Y'                                    58
     C     OITXLC        COMP      'Y'                                    59
     C   57OIEXT$        ADD       WKTAX1        WKTAX1
     C   58OIEXT$        ADD       WKTAX2        WKTAX2
     C   59OIEXT$        ADD       WKTAX3        WKTAX3
     C  N57
     CANN58
     CANN59              ADD       OIEXT$        WKNTAX                         NOT TAXABLE
     C     OIPRAL        IFNE      'N'
     C   57              ADD       OIEXT$        WKTXD1
     C   58              ADD       OIEXT$        WKTXD2
     C   59              ADD       OIEXT$        WKTXD3
     C                   ELSE
     C     OHSHFR        IFEQ      'P  '
     C**         OHSHPC    ANDEQ'T '
     C   57              ADD       OIEXT$        WKTXD1
     C   58              ADD       OIEXT$        WKTXD2
     C   59              ADD       OIEXT$        WKTXD3
     C                   ENDIF
     C                   END
      *
     C     TXPASS        TAG
      *
      *  ADD FREIGHT AND SPECIAL CHARGES TO TOTALS.
      *
     C     ARND          TAG
     C   42              Z-ADD     OIEXT$        FRGHT             7 2
     C   42              Z-ADD     OIEXT$        CIAMT             9 4
     C   42              Z-ADD     0             CIUPRI
     C   42              ADD       FRGHT         FRT               7 2
     C   42              Z-ADD     OIEXT$        EXT               9 2
     C   42OHFRTX        COMP      'Y'                                    52
     C** 42 52 40          EXSR ACCOX
     C** 42 52N40
     C** 42N52             ADD  OIEXT$    WKFNTX
     C   43              Z-ADD     OIEXT$        SPCHGE            7 2
     C   43              Z-ADD     OIEXT$        CIAMT
     C   43              Z-ADD     0             CIUPRI
     C   43              ADD       SPCHGE        SPECL             7 2
     C   43              Z-ADD     OIEXT$        EXT
     C   43OHSPTX        COMP      'Y'                                    52
     C** 43 52 40          EXSR ACCOX
     C** 43 52N40
     C** 43N52             ADD  OIEXT$    WKSNTX
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
      *
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C                   SETON                                        81
     C                   ENDIF
     C  N81              GOTO      NDSALE
     C                   MOVEL     'A'           SDSTAT
     C                   Z-ADD     OHSACU        SDCUST
     C                   MOVEL     CTYP          SDCODE
     C                   Z-ADD     OHCRM#        SDINV#
     C                   MOVEL     'CM'          SDSUFF
     C                   MOVEL     OIITEM        SDITEM
     C                   MOVEL     OISIZE        SDSIZE
     C                   Z-ADD     OISEQ#        SDSEQ#
     C                   Z-ADD     LDATEC        SDTDAT
     C                   Z-ADD     OIQCRD        SDQSHP
EFD  C     OIUUOM        IFGT      *BLANKS
 |   C                   MOVEL     OIUUOM        SDUUOM
 |   C                   ELSE
 |   C                   MOVEL     'EA'          SDUUOM
EFD  C                   ENDIF
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
     C                   Z-ADD     OHCRM#        SDORD#
     C***                  MOVELOHPONO    SDPONO
     C                   MOVEL     OIWHSE        SDWHSE
     C                   Z-ADD     LDATE         SDDTLA
     C                   Z-ADD     TIMOD         SDTIME
     C                   MOVEL     USERID        SDUSER
     C**                   MOVELWSID      SDWSID
     C                   MOVEL     OIITYP        SDITYP
     C                   Z-ADD     05            SDTTYP
     C                   MOVEL     ' '           SDIOCD
     C                   Z-ADD     OIEXT$        SDEXT$
     C**                   Z-ADD#LINNT    SDEXT$
     C                   Z-ADD     0             SDCST$
     C***                  MOVELOIROUT    SDROUT
     C***                  Z-ADDOISTOP    SDSTOP
     C                   MOVEL     OICWT         SDCWTF
     C                   Z-ADD     OIWGSH        SDWGSH
     C                   Z-ADD     OHARCU        SDARCU
     C                   Z-ADD     OHCUST        SDSHCU
     C                   Z-ADD     OHBLCU        SDBLCU
     C                   MOVEL     OIRSCD        SDRSCD
     C                   MOVEL     OIPRAL        SDPRAL
     C                   MOVEL     OIBPUM        SDBUOM
     C                   MOVEL     OISUOM        SDBLUM
     C                   Z-ADD     OIMUL2        SDMUL2
     C                   Z-ADD     *ZEROS        SDQCRD
     C                   Z-ADD     OIUWGT        SDUWGT
     C                   MOVEL     IMPCL3        SDPCL3
     C                   MOVEL     OILOTC        SDLOTC
     C                   MOVE      *BLANKS       SDLOT#
     C                   MOVEL     OHAFIV        SDAFIV
     C                   MOVEL     OHAFSL        SDAFSL
     C                   WRITE     RDSALE
     C                   ADD       1             DREC
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
     C                   ADD       SDEXT$        SPTCRM
     C                   ADD       SDQSHP        SPTCUN
     C   90              WRITE     RPCSDY
     C  N90              UPDATE    RPCSDY
     C     NDSALE        TAG
      *
      * WRITE IORCW
      *
     C                   MOVEL     'A'           CISTAT
     C                   Z-ADD     OICRM#        CICRM#
     C                   Z-ADD     OISEQ#        CISEQ#
     C                   Z-ADD     OISEQ#        CISEQP
     C                   MOVEL     OIITEM        CIITEM
     C                   MOVEL     OISIZE        CISIZE
     C                   MOVEL     DESCO         CIDES1
     C                   MOVE      DESCO         CIDES2
     C                   Z-ADD     OICOMP        CICOMP
     C                   MOVEL     OIWHSE        CIWHSE
     C                   MOVEL     OIBIN#        CIBIN#
     C                   MOVEL     OIUUOM        CIUUOM
     C                   Z-ADD     OIMULT        CIMULT
     C**                   Z-ADDOIUWGT    CIUWGT
     C                   Z-ADD     OIUCST        CIUCST
     C                   Z-ADD     OIQDDC        CIQDDC
     C                   Z-ADD     OIEXT$        CIEXT$
     C                   Z-ADD     OIUPRI        CIUPRI
     C                   Z-ADD     OIQINV        CIQINV
     C                   Z-ADD     OIQCRD        CIQCRD
     C                   Z-ADD     OIAMT1        CIAMT1
     C                   Z-ADD     OIAMT2        CIAMT2
     C                   Z-ADD     OIAMT3        CIAMT3
     C                   Z-ADD     OIDISC        CIDISC
     C***                  MOVELOISHCD    CISHCD
     C                   MOVEL     OIOVER        CIOVER
     C**                   MOVELOIBOCD    CIBOCD
     C                   MOVEL     OISLM1        CISLM1
     C                   MOVEL     OISLM2        CISLM2
     C                   Z-ADD     OICOM1        CICOM1
     C                   Z-ADD     OICOM2        CICOM2
     C                   Z-ADD     OICUST        CICUST
     C**                   Z-ADDOIDTRQ    CIDTRQ
     C                   Z-ADD     LDATE         CIDTLA
     C                   Z-ADD     LDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CIRIND
     C                   Z-ADD     TIMOD         CITIME
     C                   MOVEL     USERID        CIUSER
     C**                   MOVELWSID      CIWSID
     C                   Z-ADD     OITRDC        CITRDC
     C                   MOVEL     OICTCD        CICTCD
     C**                   MOVEL' '       CICOFL
     C                   MOVEL     OIITYP        CIITYP
     C                   MOVEL     OICWT         CICWT
     C                   Z-ADD     OILBS#        CILBS#
     C                   Z-ADD     OIWGSH        CIWGSH
     C                   MOVEL     OIRSCD        CIRSCD
     C                   Z-ADD     OISEQP        CISEQP
     C                   MOVEL     OIPRAL        CIPRAL
     C                   MOVEL     OIBPUM        CIBPUM
     C                   MOVEL     OISUOM        CISUOM
     C**                   MOVELOIBLUM    CIBLUM
     C                   MOVEL     OILOTC        CILOTC
     C**                   Z-ADDOITAGS    CITAGS
     C                   MOVEL     OIPRAL        CIPRAL
     C                   MOVEL     OIITMA        CIITMA
     C**                   MOVELOIPRCL    CIPRCL
      *
     C                   WRITE     RIORCW
     C                   SETOFF                                       8183
      *
      * WRITE LOT CONTROL/ CATCH WEIGHT INFO OUT
      *
     C*          OIITYP    IFEQ ' '
     C*          OICWT     COMP 'Y'                      10
     C*                    END
      *
      *  CLOSE LINE ITEMS
      *
     C**         OIQBOO    COMP 0                        30
     C*          OIQORD    IFEQ OIQSHP
     C*                    SETON                     30
     C*                    ENDIF
     C**                   MOVELOIORD#    REFKEY  9
     C** 30                MOVE OISEQ#    REFKEY
      *
      *
      * UPDATE IORDR
      *
     C                   MOVEL     'D'           OISTAT
     C                   Z-ADD     LDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C**                   MOVELUSERID    OIUSER
     C**                   MOVELWSID      OIWSID
     C                   UPDATE    RIORCR
     C**                   Z-ADDOIORD#    OLORD#  60
     C**                   Z-ADDOICOMP    OLCOMP  20
      *
      *  CLEAR DETAIL LINE ITEM WORK FIELDS AND GO TO BEGINING.
      *
     C**                   Z-ADD0         ITMNET
     C                   Z-ADD     0             EXT
     C**                   Z-ADD0         QDA
     C**                   Z-ADD0         LINCST
     C***                  Z-ADD0         LINPFT
     C**                   Z-ADD0         PRCNT
     C**                   Z-ADD0         LINPFP
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
     C                   Z-ADD     OHTRDC        DISHLD            4 2    52
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
      *
      *            ADJUST ACCUMULATED AMOUNTS FOR C&C OR SALE DISC
      *
     C     OHCCDS        DIV(H)    100           WKCC              7 4
     C     WKTXD1        MULT(H)   WKCC          WKSUB1            9 2
     C     WKTXD2        MULT(H)   WKCC          WKSUB2            9 2
     C     WKTXD3        MULT(H)   WKCC          WKSUB3            9 2
     C     WKTAX1        SUB       WKSUB1        WKTAX1                                        BIR44
     C     WKTAX2        SUB       WKSUB2        WKTAX2                                        BIR44
     C     WKTAX3        SUB       WKSUB3        WKTAX3                                        BIR44
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
      *  CALCULATE FREIGHT AND SPECIAL CHARGES
      *
     C     ARNTAX        TAG
      * GET INTO HEADER FIELDS
     C                   MOVEL     'A'           CHSTAT
     C                   Z-ADD     OHCRM#        CHCRM#
     C                   Z-ADD     OHCOMP        CHCOMP
     C                   Z-ADD     OHCUST        CHCUST
     C                   Z-ADD     OHORDY        CHORDY
     C                   MOVEL     OHNAME        CHNAME
     C                   MOVEL     OHSHP2        CHSHP2
     C                   MOVEL     OHSHP3        CHSHP3
     C                   MOVEL     OHSHP4        CHSHP4
     C                   MOVEL     OHSHCT        CHSHCT
     C                   MOVEL     OHSHST        CHSHST
     C                   MOVEL     OHSHZP        CHSHZP
     C                   Z-ADD     OHDTOR        CHDTOR
     C                   MOVEL     OHCOMM        CHCOMM
     C                   MOVEL     OHPOS         CHPOS
     C                   MOVEL     OHTERM        CHTERM
     C                   Z-ADD     OHTRAT        CHTRAT
     C                   Z-ADD     OHTDAY        CHTDAY
     C                   MOVEL     OHTXST        CHTXST
     C                   MOVEL     OHTXJU        CHTXJU
     C                   Z-ADD     OHAMT1        CHAMT1
     C                   Z-ADD     OHAMT2        CHAMT2
     C                   Z-ADD     OHAMT3        CHAMT3
     C                   MOVEL     OHTYPE        CHTYPE
     C**                   MOVELOHSHPC    WHSHPC
     C**                   MOVELOHSTA     WHSTA
     C**                   MOVELOHACK     WHACK
     C                   MOVEL     OHSLD1        CHSLD1
     C                   MOVEL     OHSLD2        CHSLD2
     C                   MOVEL     OHSLD3        CHSLD3
     C                   MOVEL     OHSLD4        CHSLD4
     C                   MOVEL     OHSLCT        CHSLCT
     C                   MOVEL     OHSLST        CHSLST
     C                   MOVEL     OHSLZP        CHSLZP
     C                   MOVEL     OHSLM1        CHSLM1
     C                   Z-ADD     OHSCM1        CHSCM1
     C                   MOVEL     OHSLM2        CHSLM2
     C                   Z-ADD     OHSCM2        CHSCM2
     C                   Z-ADD     OHMER$        CHMER$
     C                   Z-ADD     OHDIS$        CHDIS$
     C                   Z-ADD     OHFRT$        CHFRT$
     C                   Z-ADD     OHMIS$        CHMIS$
     C**                   Z-ADDTOTFET    CHFET$
     C                   Z-ADD     OHTAX$        CHTAX$
     C                   Z-ADD     OHTDAT        CHTDAT
     C                   Z-ADD     TDATE         CHDTLA
     C                   Z-ADD     TIMOD         CHTIME
     C                   MOVEL     USERID        CHUSER
     C                   MOVEL     OHPRCD        CHPRCD
     C                   Z-ADD     OHTRDC        CHTRDC
     C                   MOVEL     OHTMCD        CHTMCD
     C                   Z-ADD     OHTDAS        CHTDAS
     C                   Z-ADD     OHAPNO        CHAPIN
     C                   Z-ADD     OHINDT        CHINDT
     C                   MOVEL     OHFRTX        CHFRTX
     C                   MOVEL     OHSPTX        CHSPTX
     C                   MOVEL     OHTXID        CHTXID
     C                   MOVEL     OHROUT        CHROUT
     C                   Z-ADD     OHSTOP        CHSTOP
     C                   Z-ADD     OHARCU        CHARCU
     C                   Z-ADD     OHSACU        CHSACU
     C                   Z-ADD     OHBLCU        CHBLCU
     C**                   Z-ADDTBLK      CHTBLK
     C**                   Z-ADDTBRK      WHTBRK
     C                   MOVEL     OHALPH        CHALPH
     C                   MOVEL     OHSHFR        CHSHFR
     C                   MOVEL     OHREAS        CHREAS
     C                   Z-ADD     OHTOT$        CHTOT$
     C                   MOVEL     OHPOS         CHPOS
     C                   MOVEL     OHSALE        CHSALE
     C                   MOVEL     OHAFIV        CHAFIV
     C                   MOVEL     OHAFSL        CHAFSL
     C                   Z-ADD     CHTAX$        STTAX
      *
     C     TAXKEY        KLIST
     C                   KFLD                    OHCOMP
     C                   KFLD                    OHTXJU
     C                   KFLD                    YEAR
     C                   KFLD                    MTH
     C                   MOVE      LDATE         YY                2 0
     C     YY            IFGT      90
     C                   MOVEL     19            YEAR              4 0
     C                   ELSE
     C                   MOVEL     20            YEAR
     C                   END
     C                   MOVE      YY            YEAR
     C                   MOVEL     LDATE         MTH               2 0
     C     RETAX         TAG
     C     TAXKEY        CHAIN     FTAXD                              67
     C   67              DO
     C                   CLEAR                   RTAXD
     C                   MOVEL     OHTXJU        TDTXJU
     C                   Z-ADD     OHCOMP        TDCOMP
     C                   Z-ADD     YEAR          TDYEAR
     C                   Z-ADD     MTH           TDMTH
     C                   ENDDO
     C     TDCLOS        IFEQ      'Y'
     C                   ADD       1             MTH
     C     MTH           IFGT      12
     C                   Z-ADD     1             MTH
     C                   ADD       1             YEAR
     C                   END
     C                   GOTO      RETAX
     C                   END
     C**                   ADD  NETPRC    TXMGRS
     C                   ADD       CHMER$        TDMGRS
     C                   ADD       CHFRT$        TDMGRS
     C                   ADD       CHMIS$        TDMGRS
     C                   ADD       CHDIS$        TDMGRS
     C                   ADD       CHAMT1        TDMTX1
     C                   ADD       CHAMT1        TDMRES
     C                   ADD       CHAMT2        TDMTX2
     C                   ADD       CHAMT3        TDMTX3
     C                   ADD       CHTAX$        TDAMT1
     C**                   ADD  COTAX     TDAMT2
     C**                   ADD  CYTAX     TDAMT3
     C  N67              UPDATE    RTAXD
     C   67              WRITE     RTAXD
      *
      *  CALCULATE TOTAL INVOICE AMOUNT.
      *
     C                   Z-ADD     OHTOT$        INVAMT           11 2
      *
      *  CALCULATE DISCOUNT BASED ON TERMS.
      *
     C**         DSCPRC    MULT #DISWK    CSHDS$  72H
     C                   Z-ADD(H)  0             CSHDS$            7 2
      *  WRITE CR MEMO HEADER WORK  HORCW
      *
      *
      *  WRITE HORCW RECORD
     C                   WRITE     RHORCW
      *
      *  WRITE ARWRK
      *
     C                   MOVEL     'A'           ATSTAT
     C                   Z-ADD     OHARCU        ATCUST
     C                   Z-ADD     OHCRM#        ATINV#
      ** USE OHPOS FOR AUTO SPREAD Y/N
     C     OHPOS         IFEQ      'Y'
     C                   Z-ADD     OHAPNO        ATIAPP
     C                   ELSE
     C                   Z-ADD     0             ATIAPP
     C                   END
     C                   Z-ADD     0             ATSEQ#
     C                   MOVEL     'CM'          ATSUFF
     C                   MOVEL     OHTYPE        ATCTYP
     C                   MOVEL     OHSLM1        ATSLM1
     C                   Z-ADD     OHSCM1        ATCOM1
     C                   MOVEL     OHSLM2        ATSLM2
     C                   Z-ADD     OHSCM2        ATCOM2
     C                   MOVEL     TERR          ATTERR
     C                   Z-ADD     05            ATTTYP
     C                   Z-ADD     LDATEC        ATTDAT
     C                   Z-ADD     DUEDTC        ATDUDT
     C                   Z-ADD     OHCOMP        ATCOMP
     C                   Z-ADD     INVAMT        AT$AMT
      ** TEMP FOR KUBE PAK TIL TRADE DISC FIXED
EFD03C                   Z-ADD     OHDIS$        ATDIS$
     C*                    Z-ADDTRDDIS    ATDIS$
     C                   Z-ADD     QTYDIS        ATQDI$
     C*                    Z-ADDFRT       ATFRT$
     C*                    Z-ADDSPECL     ATSPL$
     C                   Z-ADD     OHFRT$        ATFRT$
     C                   Z-ADD     OHMIS$        ATSPL$
     C                   Z-ADD     STTAX         ATAMT1
     C                   Z-ADD     COTAX         ATAMT2
     C                   Z-ADD     CYTAX         ATAMT2
     C                   Z-ADD     CHMER$        ATMER$
     C                   Z-ADD     TDATE         ATDTLA
     C                   Z-ADD     TIMOD         ATTIME
     C                   MOVEL     USERID        ATUSER
     C                   Z-ADD     CSHDUC        ATDCDT
     C                   Z-ADD     0             ATORD#
     C                   Z-ADD     CSHDS$        ATDISC
     C                   Z-ADD     OHCUST        ATSHCU
     C                   Z-ADD     OHSACU        ATSACU
     C                   Z-ADD     OHBLCU        ATBLCU
     C                   MOVEL     OHPOS         ATPOS
     C                   MOVE      *BLANKS       ATPONO
     C                   MOVEL     OHTXJU        ATTAXJ
     C                   MOVEL     OHSHFR        ATSHFR
      *
     C                   WRITE     RARWRK
      *
      *  UPDATE FSLSDY
      *
     C                   MOVEL     RDATE         YY                2 0
     C     YY            IFGT      70
     C                   MOVEL     19            NDATE             2 0          19
     C                   ELSE
     C                   MOVEL     20            NDATE
     C                   ENDIF
     C                   MOVEL     NDATE         SDATE             8 0          19
     C                   MOVE      RDATE         SDATE                          19970815
      * GET NET TOTAL FOR HISTORY FILES
     C     CHTOT$        SUB       CHFRT$        SLSAMT           11 2
     C                   SUB       CHTAX$        SLSAMT
     C**                   ADD  CHMIS$    SLSAMT
     C     SLSKEY        KLIST
     C                   KFLD                    SDATE
     C                   KFLD                    OHSHFR
     C     SLSKEY        CHAIN     FSLSDY                             90
     C   90              DO
     C                   CLEAR                   RSLSDY
     C                   Z-ADD     SDATE         SYSHDT
     C                   MOVEL     OHSHFR        SYSHFR
     C                   ENDDO
     C                   ADD       SLSAMT        SYTCRM
     C   90              WRITE     RSLSDY
     C  N90              UPDATE    RSLSDY
      *
      *
      *  WRITE ARWRK, ORDER HEADER WORK, AND ORDER TOTAL WORK.
      *
      *  RESET TERRITORY SUBR EXECUTE FLAG
     C                   SETOFF                                       61
      *
     C                   MOVEL     'D'           OHSTAT
     C                   UPDATE    RHORCR
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   Z-ADD     OHCRM#        LECRM
     C                   SETON                                        LR
      *********
      * CLEAR *
      *********
      *  CLEAR WORK FIELDS AT NEW HEADER.
      *
     C     CLEAR         BEGSR
     C                   Z-ADD     0             NETAMT            9 4
     C                   Z-ADD     0             NETPRC
     C**                   Z-ADD0         DSCPRC
     C**                   Z-ADD0         MRCH$
     C                   Z-ADD     0             QTYDIS            7 2
     C***                  Z-ADD0         TOTCST
     C***                  Z-ADD0         TOTPFT
     C                   Z-ADD     0             TOTFET            7 2
     C**                   Z-ADD0         TOTLBS
     C                   Z-ADD     0             FRT
     C                   Z-ADD     0             SPECL
     C                   Z-ADD     0             DUEDTE
     C                   Z-ADD     0             DUEDTC
     C                   Z-ADD     0             DTNUMB
     C                   Z-ADD     0             CSHDUE
     C                   Z-ADD     0             STTAX             7 2
     C                   Z-ADD     0             COTAX             7 2
     C                   Z-ADD     0             CYTAX             7 2
     C                   Z-ADD     0             TRDDIS
     C                   Z-ADD     0             DISCNT
     C                   Z-ADD     0             INVAMT
     C                   Z-ADD     0             CSHDS$
     C**                   Z-ADD0         TOTPT
     C**                   Z-ADD0         TOTPFP
     C                   Z-ADD     0             WKTAX1            9 4
     C                   Z-ADD     0             WKTAX2            9 4
     C                   Z-ADD     0             WKTAX3            9 4
     C                   Z-ADD     0             WKTXD1            9 4
     C                   Z-ADD     0             WKTXD2            9 4
     C                   Z-ADD     0             WKTXD3            9 4
     C                   Z-ADD     0             WK112            11 4
     C                   Z-ADD     0             WKNTAX
     C**                   Z-ADD0         WKFNTX
     C**                   Z-ADD0         WKSNTX
     C**                   Z-ADD0         WKFTX1
     C**                   Z-ADD0         WKFTX2
     C**                   Z-ADD0         WKFTX3
     C**                   Z-ADD0         WKSTX1
     C**                   Z-ADD0         WKSTX2
     C**                   Z-ADD0         WKSTX3
     C                   Z-ADD     0             TBLK             11 1
     C                   Z-ADD     0             TBRK             11 1
     C                   Z-ADD     0             PK30              3 0
     C                   Z-ADD     0             PK114            11 4
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
     C  N75              SETON                                        79
     C                   SETOFF                                       79
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
     C                   Z-ADD     LDATEC        DUEDTC            7 0
     C                   MOVE      LDATE         DUEDTE
     C                   MOVE      LDATE         CSHDUE
     C                   Z-ADD     LDATEC        CSHDUC            7 0
     C                   MOVE      *ZEROS        #DISWK            4 4
     C                   GOTO      ECALDT
      *
      *            CALCULATE FOR TERMS TYPE '1'
      *
     C     TYP01         TAG
     C                   Z-ADD     LDATEC        ##CYMD
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
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         DUEDTE            6 0
     C                   Z-ADD     ##CYMD        DUEDTC
      *  CALCULATE DISCOUNT DUE DATE.
      *
     C                   ADD       TCTDAY        DTNUMB
     C                   Z-ADD     DTNUMB        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         CSHDUE            6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSHDUC
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
     C                   Z-ADD     DUEDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DUEDTC
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
     C                   Z-ADD     CSHDUE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSHDUC
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
     C                   Z-ADD     DUEDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        DUEDTC
     C                   Z-ADD     CSHDUE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        CSHDUC
      *
     C     ECALDT        ENDSR
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
      *
