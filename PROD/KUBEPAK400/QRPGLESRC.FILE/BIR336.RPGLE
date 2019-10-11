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
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR336
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- DISPLAY A PREVIOUSLY PRINTED INVOICE
      *
      *   CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR336FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     F                                     SFILE(CRMSFL:RECNO)
     FFHORDW    IF   E           K DISK
     FFHORDISCNTIF   E           K DISK
     FFIORDW    IF   E           K DISK
     FFHORCW    IF   E           K DISK
     FFIORCW    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFPPI      IF   E           K DISK
      *
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *  PROGRAM MAIN FLOW.
      *
     D                UDS
      ** COMPANY
     D  LCO                    1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** ROUTE I.D.
     D  LDARTE                 4      5
      ** ROUTE ALL
     D  LDAALL                 6      8
      ** BEGINING CREDIT NUMBER
     D  LBCRM                  4      9  0
      ** ENDING CREDIT NUMBER
     D  LECRM                 10     15  0
      ** BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                  9     14  0
      ** ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 15     20  0
      ** INVOICE DATE
     D  LDATE                 21     26  0
      ** SHIP FROM LOCATION
     D  LSHFR                 27     29
      ** BEGINING ORDER NUMBER
     D  LBORD                 30     35  0
      ** ENDING ORDER NUMBER
     D  LEORD                 36     41  0
      ** POINT OF SALE INVOICE Y/N
     D  LPOS                  42     42
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 43     43
      ** BEGINING DATE
     D  LBEGDT                44     49  0
      ** ENDING DATE
     D  LENDDT                50     55  0
      ** SELECTION PICK SLIP
     D  LSELEC                56     56  0
      ** PRODUCT CLASS 1
     D  LPC1                  57     58
      ** PRODUCT CLASS 2
     D  LPC2                  59     60
      ** ROUTE 1
     D  LRTE1                 61     62
      ** ROUTE 2
     D  LRTE2                 63     64
      ** PHYTO 1
     D  LPHY1                 65     65
      ** PHYTO 2
     D  LPHY2                 66     66
      ** PREV. PRINTED
     D  LPREV                 67     67
      ** SHIP 1
     D  LSHP1                 68     69
      ** SHIP 2
     D  LSHP2                 70     71
      ** LOCATION 1
     D  LLOC1                 72     74
      ** LOCATION 2
     D  LLOC2                 75     77
      ** TAG
     D  LTAG                  78     78  0
      ** DATE
     D  LSTDAT                79     84  0
      ** SALE I.D.
     D  LSALE                 85     87
      ** DEPARTMENT
     D  LDEPT                 88     90
      ** SALE DATE
     D  TYCENB                91     95  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    119
      ** NUMBER OF COPIES
     D  LCOPY                120    121  0
      ** JOBQ
     D  LJOB                 122    122
      ** HOLD PRINT OUTPUT
     D  LHOLD                123    126
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                127    130
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
      ** PRINTER ID PICK SLIP 2
     D  LPRT2                134    143
      ** JULIAN DATE
     D  LJUL                 144    148  0
      *
     D  DIS_MERCH      S                   Like(WHMER$)
      *                                                                   APR270
     IRHORDW
     I              WHNAME                      #WSHP1
     I              WHSHP2                      #WSHP2
     I              WHSHP3                      #WSHP3
     I              WHSHP4                      #WSHP4
     I              WHSHCT                      #WSHCT
     I              WHSHST                      #WSHST
     I              WHSHZP                      #WSHZP
     I              WHSLD1                      #WSLD1
     I              WHSLD2                      #WSLD2
     I              WHSLD3                      #WSLD3
     I              WHSLD4                      #WSLD4
     I              WHSLCT                      #WSLCT
     I              WHSLST                      #WSLST
     I              WHSLZP                      #WSLZP
      *
     IRHORCW
     I              CHNAME                      #WSHP1
     I              CHSHP2                      #WSHP2
     I              CHSHP3                      #WSHP3
     I              CHSHP4                      #WSHP4
     I              CHSHCT                      #WSHCT
     I              CHSHST                      #WSHST
     I              CHSHZP                      #WSHZP
     I              CHSLD1                      #WSLD1
     I              CHSLD2                      #WSLD2
     I              CHSLD3                      #WSLD3
     I              CHSLD4                      #WSLD4
     I              CHSLCT                      #WSLCT
     I              CHSLST                      #WSLST
     I              CHSLZP                      #WSLZP
      *
     IRMWHSE
     I              WHUSER                      WUSER
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *                                                                   APC540
     C     RSTRT         TAG
     C                   Z-ADD     0             VCUST
     C                   Z-ADD     0             VINV
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             TSHIP
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       TYPE
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       30
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   MOVEL     'N'           LDARPT
     C                   GOTO      END
     C                   ENDDO
      *
     C     VCUST         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        VCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      *ZEROS
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         CHAIN     FMCUST                             90
     C   90              SETON                                        10
     C   10              GOTO      NXTA
      *
      *
     C   KB              Z-ADD     VCUST         WHBLCU
     C   KB              MOVE      *BLANKS       TYPE
     C   KB              CALL      'LKCINV'
     C                   PARM                    WHBLCU            6 0
     C                   PARM                    WHCOMP            2 0
     C                   PARM                    WHINV#            6 0
     C                   PARM                    TYPE              2
     C   KB              MOVEL     WHINV#        VINV
     C   KB              GOTO      NXTA
      ** CHECK FOR ITEM SEARCH
     C   KE              DO
     C                   EXSR      GETITM
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VINV          IFEQ      *ZEROS
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      * CHECK TYPE
     C     TYPE          IFNE      *BLANKS
     C     TYPE          ANDNE     'IN'
     C     TYPE          ANDNE     'CM'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   END
      *
      *  CHECK IF RECORD EXISTS IN FHORDW
      *
     C     TYPE          IFNE      'CM'
     C     VINV          CHAIN     FHORDW                             92
     C   92              SETON                                        20
     C  N20              DO
     C     VCUST         IFNE      WHARCU
     C                   SETON                                        2021
     C                   END
     C                   ENDDO
     C   20              GOTO      NXTA
      *
     C                   EXSR      #SLD
     C                   MOVEL     #SL(1)        CUS1             32
     C                   MOVEL     #SL(2)        CUS2             32
     C                   MOVEL     #SL(3)        CUS3             32
     C                   MOVEL     #SL(4)        CUS4             32
     C                   MOVEL     #SL(5)        CUS5             32
     C                   EXSR      #SHP
     C                   MOVEL     #SH(1)        SHP1             32
     C                   MOVEL     #SH(2)        SHP2             32
     C                   MOVEL     #SH(3)        SHP3             32
     C                   MOVEL     #SH(4)        SHP4             32
     C                   MOVEL     #SH(5)        SHP5             32
      *
     C                   MOVEL     WHTERM        TDESC
     C     WHSHFR        CHAIN     FMWHSE                             90
     C                   MOVEL     WHDESC        SDESC
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
      *  READ IORDW
      *
     C     WHINV#        SETLL     FIORDW
     C                   SETOFF                                       90
     C     NXTI          TAG
     C     WHINV#        READE     FIORDW                                 90
     C   90              GOTO      DSPL
      *
     C                   Z-ADD     WIQSHP        QSHIP             5 0
     C                   Z-ADD     WIQBOO        QTYBO             3 0
     C                   MOVEL     WIDES1        DESC
     C                   Z-ADD     WIUPRI        UPRICE            8 4
     C                   Z-ADD     WIAMT         LAMT              8 2
      *
     C                   ADD       QSHIP         TSHIP             5 0
     C                   ADD       WIAMT         TOTAL             8 2
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C     WHINV#        CHAIN     FPPI                               81
     C                   ADD       2             RECNO
     C                   Z-ADD     TSHIP         QSHIP
     C                   Z-ADD     TOTAL         LAMT
     C                   Z-ADD     0             UPRICE
     C                   Z-ADD     0             QTYBO
     C                   MOVEL     *BLANKS       WIITEM
     C                   MOVEL     *BLANKS       WISIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       WIBUOM
     C                   MOVEL     '* Total '    DESC1            16
     C                   MOVE      'Invoice '    DESC1
     C                   MOVEL     '*'           DESC2             1
     C                   MOVEL     DESC1         DESC3            17
     C                   MOVE      DESC2         DESC3
     C                   MOVEL     DESC3         DESC

     C                   Eval      WHMER$8 = WHMER$
     C                   Eval      WH$AMT9 = WH$AMT
     C                   Eval      TRADE$  = WHDIS$
     C     WHORD#        Chain     FHORDISCNT
     C                   If        %Found(FHORDISCNT)
     C                   Eval      DIS_MERCH = WHDIS$ / WHTRDC
     C                   Eval      EOD$ = DIS_MERCH * ADDSC1
     C                   Eval      TRADE$  = TRADE$ - EOD$
     C                   EndIF

     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              DO
     C                   MOVEL     'N'           LDARPT
     C                   GOTO      END
     C                   ENDDO
     C   KM              EXSR      GETLDA
     C   KM              GOTO      END
     C   KF              GOTO      RSTRT
     C                   GOTO      RSTRT
     C                   ELSE
      ** WE HAVE A CREDIT MEMO
     C     VINV          CHAIN     FHORCW                             92
     C   92              SETON                                        20
     C  N20              DO
     C     VCUST         IFNE      CHARCU
     C                   SETON                                        2021
     C                   END
     C                   ENDDO
     C   20              GOTO      NXTA
      *
     C                   EXSR      #SLD
     C                   MOVEL     #SL(1)        CUS1             32
     C                   MOVEL     #SL(2)        CUS2             32
     C                   MOVEL     #SL(3)        CUS3             32
     C                   MOVEL     #SL(4)        CUS4             32
     C                   MOVEL     #SL(5)        CUS5             32
     C                   EXSR      #SHP
     C                   MOVEL     #SH(1)        SHP1             32
     C                   MOVEL     #SH(2)        SHP2             32
     C                   MOVEL     #SH(3)        SHP3             32
     C                   MOVEL     #SH(4)        SHP4             32
     C                   MOVEL     #SH(5)        SHP5             32
      *
     C                   MOVEL     CHTERM        TDESC
     C     CHSHFR        CHAIN     FMWHSE                             90
     C**                   MOVELCHCOMM    SDESC
     C     CHAPIN        CHAIN     FHORDW                             90
     C   90              MOVE      *BLANKS       WHPONO
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     CRMCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
      *  READ IORCW
      *
     C     CHCRM#        SETLL     FIORCW
     C                   SETOFF                                       90
     C     NXTC          TAG
     C     CHCRM#        READE     FIORCW                                 90
     C   90              GOTO      DSPC
      *
     C                   Z-ADD     CIQCRD        QSHIP             5 0
     C                   MOVEL     CIDES1        DESCC
     C                   Z-ADD     CIUPRI        UPRICE            8 4
     C                   Z-ADD     CIEXT$        LAMT              8 2
      *
     C                   ADD       QSHIP         TSHIP             5 0
     C                   ADD       CIEXT$        TOTAL             8 2
      *
     C                   ADD       1             RECNO
     C                   WRITE     CRMSFL
     C                   GOTO      NXTC
      *
     C     DSPC          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     TSHIP         QSHIP
     C                   Z-ADD     TOTAL         LAMT
     C                   Z-ADD     0             UPRICE
     C                   Z-ADD     0             QTYBO
     C                   MOVEL     *BLANKS       CIITEM
     C                   MOVEL     *BLANKS       CISIZE
     C                   MOVEL     *BLANKS       DESCC
     C                   MOVEL     *BLANKS       CIUUOM
     C                   MOVEL     '* Total '    DESC1            16
     C                   MOVE      'Credit  '    DESC1
     C                   MOVEL     '**'          DESC2             1
     C                   MOVEL     DESC1         DESC3            17
     C                   MOVE      DESC2         DESC3
     C                   MOVEL     DESC3         DESCC
     C                   WRITE     CRMSFL
     C                   EXFMT     CRMCTL
     C   KC
     COR KG              DO
     C                   MOVEL     'N'           LDARPT
     C                   GOTO      END
     C                   ENDDO
     C   KM              EXSR      GETLDC
     C   KM              GOTO      END
     C   KF              GOTO      RSTRT
     C                   GOTO      RSTRT
     C                   END
      *
     C     END           TAG
     C                   SETON                                        LR
      *  ***********
      *  * GETLDA  *
      *  ***********
     C     GETLDA        BEGSR
     C                   Z-ADD     WHCOMP        LCO
     C                   MOVEL     'Y'           LDARPT
     C                   MOVEL     'N'           LJOB
     C                   MOVEL     *BLANKS       LDARTE
     C                   MOVEL     *BLANKS       LDAALL
     C                   Z-ADD     WHINV#        LBINV
     C                   Z-ADD     WHINV#        LEINV
     C***                  MOVEL'*INV'    LFORM
     C                   Z-ADD     WHINDT        LDATE
     C                   MOVEL     WHSHFR        LSHFR
     C                   MOVEL     WHPOS         LPOS
     C                   MOVEL     *BLANKS       LCANCL
      *
      * GET USER/DEPT PRINTER
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPINV        LPRTR
     C     LPRTR         IFLE      *BLANKS
     C                   MOVEL     'PRT01'       LPRTR
     C                   ENDIF
     C                   ENDSR
      *
      *  ***********
      *  * GETLDC  *
      *  ***********
     C     GETLDC        BEGSR
     C                   Z-ADD     CHCOMP        LCO
     C                   MOVEL     'C'           LDARPT
     C                   MOVEL     'N'           LJOB
     C                   MOVEL     *BLANKS       LDARTE
     C                   MOVEL     *BLANKS       LDAALL
     C                   Z-ADD     CHCRM#        LBCRM
     C                   Z-ADD     CHCRM#        LECRM
     C*                    MOVEL'*INV'    LFORM
     C                   Z-ADD     CHDTOR        LDATE
     C                   MOVEL     CHSHFR        LSHFR
     C                   MOVEL     CHPOS         LPOS
     C                   MOVEL     *BLANKS       LCANCL
      *
      * GET USER/DEPT PRINTER
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPINV        LPRTR
     C     LPRTR         IFLE      *BLANKS
     C                   MOVEL     'PRT01'       LPRTR
     C                   ENDIF
     C                   ENDSR
      *
      ***********
      * GETITM  *
      ***********
     C     GETITM        BEGSR
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       IMDES1
     C                   SETOFF                                       10
     C     NXTB          TAG
     C                   EXFMT     SCRNB
     C   KC
     COR KF
     COR KG              GOTO      ENDB
     C                   SETOFF                                       10
     C                   MOVEL     ITEM          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   CALL      'ITMALOOK'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   MOVEL     IMWHSE        USDEPT
     C     IMITEM        IFLE      *BLANKS
     C                   GOTO      NXTB
     C                   END
     C                   ENDIF
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    USDEPT
     C     ITMKEY        CHAIN     FMINVT                             10
     C   10              GOTO      NXTB
      * GET INVOICE
     C                   Z-ADD     0             WIINV#
     C                   Z-ADD     01            IMCOMP
     C                   CALL      'LKITIV'
     C                   PARM                    VCUST
     C                   PARM                    IMCOMP
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    WIINV#
     C                   Z-ADD     WIINV#        VINV
     C     ENDB          TAG
     C                   ENDSR
      *
      ***********
      * #SLD    *
      ***********
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
      ************
      *  #SHP    *
      ************
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
