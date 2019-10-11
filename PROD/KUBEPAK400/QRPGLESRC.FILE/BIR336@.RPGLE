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
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR336FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORDW    IF   E           K DISK
     FFIORDW    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDARPT                 3      3
     D  LDARTE                 4      5
     D  LDAALL                 6      8
     D  LBINV                  9     14  0
     D  LEINV                 15     20  0
     D  LDATE                 21     26  0
     D  LSHFR                 27     29
     D  LBORD                 30     35  0
     D  LEORD                 36     41  0
     D  LPOS                  42     42
     D  LIMED                 43     43
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LDAJBQ               122    122
     D  LCANCL               133    133
      *
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRT         TAG
     C                   Z-ADD     0             VCUST
     C                   Z-ADD     0             VINV
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             TSHIP
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       CMNAME
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102030
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
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
     C   KB              DO
     C                   Z-ADD     VCUST         WHBLCU
     C                   CALL      'LKCINV'
     C                   PARM                    WHBLCU            6 0
     C                   PARM                    WHCOMP            2 0
     C                   PARM                    WHINV#            6 0
     C                   MOVEL     WHINV#        VINV
     C                   GOTO      NXTA
     C                   ENDDO
      *
      * CHECK FOR ITEM SEARCH
      *
     C   KE              DO
     C                   EXSR      GETITM
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VINV          IFEQ      *ZEROS
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
      * CHECK IF RECORD EXISTS IN FHORDW
      *
     C     VINV          CHAIN     FHORDW                             92
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
     C                   MOVEL     WHTERM        TDESC
     C     WHSHFR        CHAIN     FMWHSE                             90
     C                   MOVEL     WHDESC        SDESC
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
      * READ IORDW
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
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      END
     C   KM              EXSR      GETLDA
     C   KM              GOTO      END
     C   KF              GOTO      RSTRT
     C                   GOTO      RSTRT
      *
     C     END           TAG
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
     C                   MOVEL     '*INV'        LFORM
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
     C                   CALL      'LKITEM'
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
