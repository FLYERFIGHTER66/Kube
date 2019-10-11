      *--------------------------------------------------------------     APR270
      *                                                                   APR270
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000                          APR270
      *                                                                   APR270
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         APR270
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         APR270
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      APR270
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         APR270
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      APR270
      *       BY EXPRESS WRITTEN PERMISSION OF                            APR270
      *            EFD ENTERPRISES, INC.     215-643-5352                 APR270
      *                                                                   APR270
      *--------------------------------------------------------------     APR270
      *PROGRAM NAME-------- BIR337                                        APR270
      *SYSTEM-------------- ACCOUNTS RECEIVABLE                           APR270
      *APPLICATION--------- DISPLAY A PREVIOUSLY PRINTED INVOICE          APR270
      *                     (CALLED)                                      APR270
      *                                                                   APR270
      *   CHANGE--DATE-------DESCRIPTION
      *  5/24/02 EFD MAKE P5 THE DEFAULT PRINTER                          APR270
      *                                                                   APR270
      *                                                                   APR270
     FBIR337FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     F                                     SFILE(CRMSFL:RECNO)
     FFHORDW    IF   E           K DISK
     FFHORDISCNTIF   E           K DISK
     FFIORDW    IF   E           K DISK
     FFHORCW    IF   E           K DISK
     FFIORCW    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
      *
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
      *                                                                   APR270
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      *  RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      *  SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *  PROGRAM MAIN FLOW.                                               APR270
      *
     D                UDS
     D*                                       1   20LCO
      * REPRINT Y/N
     D*                                       3   3 LDARPT
      * JOBQ Y/N
EFD01D*                                       4   4 LDAJBQ
      * ROUTE I.D.
     D*                                       5   6 LDARTE
      * ROUTE ALL
     D*                                       7   9 LDAALL
      * BEGINING INVOICE NUMBER (REPRINT)
     D*                                      10  150LBINV
      * ENDING INVOICE NUMBER (REPRINT)
     D*                                      16  210LEINV
      * FORM NUMBER
     D***                                    21  30 LFORM
      * PRINTER I.D.
     D*                                      31  40 LPRTR
      * INVOICE DATE
     D*                                      41  460LDATE
      * SHIP FROM LOCATION
     D*                                      47  49 LSHFR
      * BEGINING ORDER NUMBER
     D*                                      50  550LBORD
      * ENDING ORDER NUMBER
     D*                                      56  610LEORD
      * CANCEL  X=CANCEL
     D*                                      62  62 LCANCL
      * POINT OF SALE INVOICE Y/N
     D*                                      63  63 LPOS
      * IMMEDIATE PRINT Y/N
     D*                                      64  64 LIMED
      *
      ** COMPANY
     D  LCO                    1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** ROUTE I.D.
     D  LDARTE                 4      5
      ** CREDIT MEMOS
     D  LBCRM                  4      9  0
     D  LECRM                 10     15  0
      ** ROUTE ALL
     D  LDAALL                 6      8
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
      ** PRINTER I.D.
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    119
      ** NUMBER OF COPIES
     D  LCOPY                120    121  0
      ** JOBQ Y/N
     D  LDAJBQ               122    122
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
      *                                                                   APR270
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
      *                                                                   APR270
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
      *                                                                   APR270
     IRMWHSE
     I              WHUSER                      WUSER
      *
     C     *ENTRY        PLIST
     C                   PARM                    INVINI           15 5
     C                   PARM                    TYPE
     C                   Z-ADD     INVINI        INVIN             6 0
     C                   SETOFF                                       57
     C     INVIN         IFGT      0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     INVIN         VINV
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             TSHIP
     C                   SETON                                        57
     C                   GOTO      PARMIN
     C                   ENDIF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *                                                                   APC540
     C     RSTRT         TAG
     C                   Z-ADD     0             VINV
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             TSHIP
     C                   MOVEL     'IN'          TYPE
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       30
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
      *
     C     PARMIN        TAG
      *
     C     VINV          IFEQ      *ZEROS
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
      *CHECK TYPE
     C     TYPE          IFNE      'IN'
     C     TYPE          ANDNE     'CM'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *  CHECK IF RECORD EXISTS IN FHORDW                                 APR270
      *                                                                   APR270
     C     TYPE          IFNE      'CM'
     C     VINV          CHAIN     FHORDW                             92                       APR27
     C   92              SETON                                        20
     C   20              GOTO      NXTA
      *
     C                   ADD       WHTAX$        TOTAL             8 2
WBADDC                   Z-ADD     WHPRCD        SHPRCD
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
     C                   MOVEL     WIDES1        DESC             26
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
     C                   Clear                   RHORDISCNT
     C     WHORD#        Chain     FHORDISCNT
     C                   If        %Found(FHORDISCNT)
     C                   If        WHTRDC <> *Zero
     C                   Eval      DIS_MERCH = WHDIS$ / WHTRDC
     C                   Else
     C                   Eval      DIS_MERCH = *Zeros
     C                   EndIf
     C                   Eval      EOD$ = DIS_MERCH * ADDSC1
     C                   Eval      TRADE$  = TRADE$ - EOD$
     C                   EndIF

     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG
     COR KF
     CAN 57              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C   KM              EXSR      GETLDA
     C   KM              GOTO      END
     C   KF
     CANN57              GOTO      RSTRT
     C                   GOTO      RSTRT
     C                   ELSE
      ** WE HAVE A CREDIT MEMO
     C     VINV          CHAIN     FHORCW                             92
     C   92              SETON                                        20
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
     COR KG
     COR KF
     CAN 57              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C   KM              EXSR      GETLDC
     C   KM              GOTO      END
     C   KF              GOTO      RSTRT
     C                   GOTO      RSTRT
     C                   END
      *
      *
     C     END           TAG                                                                   APR27
     C                   SETON                                        LR
      ***********
      * GETLDA  *
      ***********
     C     GETLDA        BEGSR
     C                   Z-ADD     WHCOMP        LCO
     C                   MOVEL     'Y'           LDARPT
     C                   MOVEL     'N'           LDAJBQ
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
     C*                    MOVELDEPINV    LPRTR
     C*          LPRTR     IFLE *BLANKS
     C                   MOVEL     'P5   '       LPRTR
     C*                    ENDIF
     C                   ENDSR
      *
      *                                                                   APR270
      *
      *  ***********
      *  * GETLDC  *
      *  ***********
     C     GETLDC        BEGSR
     C                   Z-ADD     CHCOMP        LCO
     C                   MOVEL     'C'           LDARPT
     C                   MOVEL     'N'           LDAJBQ
     C                   MOVEL     *BLANKS       LDARTE
     C                   MOVEL     *BLANKS       LDAALL
     C                   Z-ADD     CHCRM#        LBCRM
     C                   Z-ADD     CHCRM#        LECRM
     C*                    MOVEL'*INV'    LFORM
     C                   Z-ADD     CHDTOR        LDATE
     C                   MOVEL     CHSHFR        LSHFR
     C                   MOVEL     CHPOS         LPOS
     C                   MOVEL     ' '           LCANCL
      *
      * GET USER/DEPT PRINTER
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C*                    MOVELDEPINV    LPRTR
     C*          LPRTR     IFLE *BLANKS
     C                   MOVEL     'P5   '       LPRTR
     C*                    ENDIF
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
