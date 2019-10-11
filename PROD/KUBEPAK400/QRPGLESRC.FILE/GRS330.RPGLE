      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- GRS330  -  PRODUCTION REVIEW INQUIRY
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **APPLICATION--------- PRODUCTION
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FGRS330FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFDLOTRDR  IF   E           K DISK
     FFIORITEM  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFPHYTO    IF   E           K DISK
      *
     D @MDY            S              1    DIM(8)
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND
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
      *
     C     RSTRTA        TAG
     C                   Z-ADD     *ZEROS        VBDATE
     C                   Z-ADD     *ZEROS        VEDATE
     C                   Z-ADD     *ZEROS        TQTOH
     C                   Z-ADD     *ZEROS        TQTAV
     C                   Z-ADD     *ZEROS        TQTAL
     C                   MOVEL     *BLANKS       VBLIST
     C                   MOVEL     *BLANKS       VELIST
     C                   MOVEL     *BLANKS       VBITEM
     C                   MOVEL     *BLANKS       VEITEM
     C                   MOVEL     *BLANKS       VBSIZE
     C                   MOVEL     *BLANKS       VESIZE
     C                   MOVEL     *BLANKS       VBLOC
     C                   MOVEL     *BLANKS       VELOC
     C                   MOVEL     *BLANKS       VBPC
     C                   MOVEL     *BLANKS       VEPC
     C                   MOVEL     *BLANKS       VBPHYT
     C                   MOVEL     *BLANKS       VEPHYT
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       192121
     C                   SETOFF                                       222330
     C                   SETOFF                                       242526
     C                   SETOFF                                       272829
     C                   SETOFF                                       313233
     C                   SETOFF                                       405090
     C                   SETOFF                                       4142
     C                   SETOFF                                       78
     C                   SETOFF                                       606162
     C                   SETOFF                                       636465
     C                   SETOFF                                       6768
      *
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C   KA              DO
     C                   MOVEL     *BLANKS       CMLOOK
     C                   CALL      'CSTALOOK'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   ENDDO
      *
     C                   SETOFF                                       636465
     C                   SETOFF                                       6768
     C     VBDATE        IFEQ      *ZEROS
     C     VEDATE        ANDEQ     *ZEROS
     C                   GOTO      NODTE
     C                   ENDIF
      *
      *  GET DAY OF CENTURY
      *
     C                   SETON                                        61
     C                   Z-ADD     VBDATE        ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        1019
     C   10              GOTO      NXT
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C                   Z-ADD     VEDATE        ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        12
     C   12              GOTO      NXT
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        1119
     C   11              GOTO      NXT
     C                   ENDIF
     C     NODATE        TAG
      *
     C     NODTE         TAG
      *
     C     VBLIST        IFEQ      *BLANKS
     C     VELIST        ANDEQ     *BLANKS
     C                   GOTO      NOLIST
     C                   ENDIF
      *
     C                   SETON                                        63
     C     VBLIST        IFEQ      '? '
     C                   MOVEL     VBLIST        VLIST             4
     C                   EXSR      LISTSR
     C                   MOVEL     VLIST         VBLIST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VELIST        IFEQ      '? '
     C                   MOVEL     VELIST        VLIST
     C                   EXSR      LISTSR
     C                   MOVEL     VLIST         VELIST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VBLIST        CHAIN     FLISTCD                            90
     C   90              SETON                                        1424
     C   14              GOTO      NXT
      *
     C     VELIST        CHAIN     FLISTCD                            90
     C   90              SETON                                        15
     C   15              GOTO      NXT
      *
     C     VBLIST        IFGT      VELIST
     C                   SETON                                        2425
     C   25              GOTO      NXT
     C                   ENDIF
      *
     C     NOLIST        TAG
      *
     C     VBITEM        IFEQ      *BLANKS
     C     VEITEM        ANDEQ     *BLANKS
     C                   GOTO      NOITEM
     C                   ENDIF
     C                   SETON                                        60
      *
     C                   MOVEL     VBITEM        VITEM            12
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C                   EXSR      ITMSRC
     C                   MOVEL     VITEM         VBITEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     VEITEM        VITEM            12
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C                   EXSR      ITMSRC
     C                   MOVEL     VITEM         VEITEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     VBITEM        ITEM             12
     C                   EXSR      ITEMLK
     C   90              SETON                                        26
     C   16              GOTO      NXT
      *
     C                   MOVEL     VEITEM        ITEM             12
     C                   EXSR      ITEMLK
     C   90              SETON                                        17
     C   17              GOTO      NXT
      *
     C     VBITEM        IFGT      VEITEM
     C                   SETON                                        1627
     C   27              GOTO      NXT
     C                   ENDIF
      *
     C     NOITEM        TAG
      *
     C     VBSIZE        IFEQ      *BLANKS
     C     VESIZE        ANDEQ     *BLANKS
     C                   GOTO      NOSIZE
     C                   ENDIF
     C                   SETON                                        64
      *
     C     VBSIZE        IFEQ      '? '
     C                   MOVEL     VBSIZE        VSIZE             3
     C                   EXSR      SIZESR
     C                   MOVEL     VSIZE         VBSIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VESIZE        IFEQ      '? '
     C                   MOVEL     VESIZE        VSIZE
     C                   EXSR      SIZESR
     C                   MOVEL     VSIZE         VESIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VBSIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        2818
     C   28              GOTO      NXT
      *
     C     VESIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        19
     C   19              GOTO      NXT
      *
     C     VBSIZE        IFGT      VESIZE
     C                   SETON                                        1829
     C   29              GOTO      NXT
     C                   ENDIF
      *
     C     NOSIZE        TAG
      *
     C     VBLOC         IFEQ      *BLANKS
     C     VELOC         ANDEQ     *BLANKS
     C                   GOTO      NOLOC
     C                   ENDIF
     C                   SETON                                        68
      *
     C     VBLOC         IFEQ      '? '
     C                   MOVEL     VBLOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VBLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VELOC         IFEQ      '? '
     C                   MOVEL     VELOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VELOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VBLOC         IFGT      VELOC
     C                   SETON                                        33
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NOLOC         TAG
      *
     C     VBPC          IFEQ      *BLANKS
     C     VEPC          ANDEQ     *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
     C                   SETON                                        62
      *
     C     VBPC          IFEQ      '? '
     C                   MOVEL     VBPC          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VBPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VEPC          IFEQ      '? '
     C                   MOVEL     VEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         VEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VBPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        2031
     C   20              GOTO      NXT
      *
     C     VEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        21
     C   21              GOTO      NXT
      *
     C     VBPC          IFGT      VEPC
     C                   SETON                                        2032
     C   32              GOTO      NXT
     C                   ENDIF
      *
     C     NOPC          TAG
      *
     C     VBPHYT        IFEQ      *BLANKS
     C     VEPHYT        ANDEQ     *BLANKS
     C                   GOTO      NOPHYT
     C                   ENDIF
     C                   SETON                                        67
      *
     C     VBPHYT        IFEQ      '? '
     C                   MOVEL     VBPHYT        VCODE             1
     C                   EXSR      PHYTSR
     C                   MOVEL     VCODE         VBPHYT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VEPHYT        IFEQ      '? '
     C                   MOVEL     VEPHYT        VCODE
     C                   EXSR      PHYTSR
     C                   MOVEL     VCODE         VEPHYT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VBPHYT        CHAIN     FPHYTO                             90
     C   90              SETON                                        22
     C   22              GOTO      NXT
      *
     C     VEPHYT        CHAIN     FPHYTO                             90
     C   90              SETON                                        23
     C   23              GOTO      NXT
      *
     C     NOPHYT        TAG
      *
      * SUBFILE SCREEN
      *
     C     VBITEM        SETLL     FDLOTRDR
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      *BLANKS       RGNAM
     C     REGN          IFEQ      *BLANKS
     C                   MOVEL     'ALL'         RGNAM
     C                   ELSE
     C                   MOVEL     REGN          RGNAM
     C                   END
     C                   MOVE      *BLANKS       CDNAM
     C     LOTTYP        IFEQ      *BLANKS
     C                   MOVEL     'ALL'         CDNAM
     C                   ELSE
     C                   MOVEL     LOTTYP        CDNAM
     C                   END
     C     NXTL          TAG
     C                   READ      FDLOTRDR                               77
     C   77              GOTO      DSPL
     C                   SETOFF                                       80
     C     LRQTOH        IFEQ      0
     C                   GOTO      NXTL
     C                   ENDIF
      *
      ** CHECK IF TYPE SELECTED
     C     LOTTYP        IFGT      *BLANKS
     C     LOTTYP        ANDNE     LRCODE
     C                   GOTO      NXTL
     C                   ENDIF
     C     LOTTYP        IFEQ      'R'
     C     VSCUST        ANDGT     0
     C     VSCUST        ANDNE     LRCUST
     C                   GOTO      NXTL
     C                   ENDIF
      * ONLY RANGE OF READY DATES
      *
     C  N61              GOTO      NCDTE
     C                   Z-ADD     LRCRDY        ##CYMD
     C***                  EXSR @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         LDATE             5 0
     C     LDATE         IFLT      BDATE
     C     LDATE         ORGT      EDATE
     C                   GOTO      NXTL
     C                   ENDIF
     C     NCDTE         TAG
      *
      *
      * ONLY RANGE OF LIST CODES
      *
     C  N63              GOTO      NCLIST
     C     ITMKEY        CHAIN     FMINVT                             50
     C     IMLIST        IFLT      VBLIST
     C     IMLIST        ORGT      VELIST
     C                   GOTO      NXTL
     C                   ENDIF
     C     NCLIST        TAG
      *
      * ONLY RANGE OF ITEMS
      *
     C  N60              GOTO      NCITEM
     C**         LRITEM    IFLT VBITEM
     C     LRITEM        IFGT      VEITEM
     C                   GOTO      DSPL
     C                   ENDIF
     C     NCITEM        TAG
      *
      * ONLY RANGE OF SIZES
      *
     C  N64              GOTO      NCSIZE
     C     LRSIZE        IFLT      VBSIZE
     C     LRSIZE        ORGT      VESIZE
     C                   GOTO      NXTL
     C                   ENDIF
     C     NCSIZE        TAG
      *
      * ONLY RANGE OF LOCATIONS
      *
     C  N68              GOTO      NCLOC
     C     LRCLOC        IFLT      VBLOC
     C     LRCLOC        ORGT      VELOC
     C                   GOTO      NXTL
     C                   ENDIF
     C     NCLOC         TAG
      *
      * ONLY RANGE OF PRODUCT CLASSES
      *
     C  N62              GOTO      NCPC
     C     LRPRCL        IFLT      VBPC
     C     LRPRCL        ORGT      VEPC
     C                   GOTO      NXTL
     C                   ENDIF
     C     NCPC          TAG
      *
      * ONLY RANGE OF PHYTO CODES
      *
     C  N67              GOTO      NCPHYT
     C     LRCPHY        IFLT      VBPHYT
     C     LRCPHY        ORGT      VEPHYT
     C                   GOTO      NXTL
     C                   ENDIF
     C     NCPHYT        TAG
      ** CHECK IF REGION SELECTED
     C     REGN          IFGT      *BLANKS
     C     LRCLOC        CHAIN     FMWHSE                             90
     C   90              MOVE      *BLANKS       WHREG
     C     WHREG         IFNE      REGN
     C                   GOTO      NXTL
     C                   END
     C                   END
      *
     C                   Z-ADD     LRCRDY        CDTE              6 0
     C     CDTE          MULT      100.0001      CRDY              6 0
     C                   Z-ADD     LRQTOH        QTOH              7 0
     C                   Z-ADD     LRQTAL        QTAL              7 0
     C     QTOH          SUB       QTAL          QTAV              7 0
     C                   ADD       QTOH          TQTOH             7 0
     C                   ADD       QTAL          TQTAL             7 0
     C                   ADD       QTAV          TQTAV             7 0
      *
     C     ITMKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C     ITMKEY        CHAIN     FMINVT                             50
     C                   EXSR      GETDES
      *
     C*          FIRST     IFEQ 1
     C     ITMKEY        SETLL     FIORITEM
     C     NXTR          TAG
     C     ITMKEY        READE     FIORITEM                               90
     C  N90              DO
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTR
     C                   ENDIF
     C     OILOTC        IFEQ      'Y'
     C                   GOTO      NXTR
     C                   ENDIF
     C     OIQORD        SUB       OIQSHP        QNAL              7 0
     C                   ADD       QNAL          TQNALL           11 140
     C                   GOTO      NXTR
     C                   ENDDO
      *
     C                   ADD       1             RECNO
     C                   MOVE      *BLANKS       SELECT
     C                   WRITE     RECSFL
     C                   GOTO      NXTL
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             QTOH
     C                   Z-ADD     0             QTAL
     C                   Z-ADD     0             QTAV
     C                   Z-ADD     TQTOH         QTOH
     C                   Z-ADD     TQTAL         QTAL
     C                   Z-ADD     TQTAV         QTAV
     C                   Z-ADD     0             CRDY
     C                   MOVEL     *BLANKS       LRITEM
     C                   MOVEL     *BLANKS       LRSIZE
     C                   MOVEL     *BLANKS       LRPRCL
     C                   MOVEL     *BLANKS       LRCPHY
     C                   MOVEL     *BLANKS       LRCLOC
     C                   MOVEL     *BLANKS       LRCODE
     C                   MOVEL     *BLANKS       DESP
     C                   MOVEL     '* End of'    DESC1            16
     C                   MOVE      ' Data * '    DESC1
     C                   MOVEL     DESC1         DESP
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      END
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             49
     C                   ENDSR
      *
      *********
      * LISTSR
      *********
     C     LISTSR        BEGSR
     C                   MOVEL     VLIST         LCCODE
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE
     C                   PARM                    LCDESC           30
     C                   MOVEL     *BLANKS       VLIST
     C                   MOVEL     LCCODE        VLIST
     C                   SETON                                        99
     C                   ENDSR
      *
      *********
      * ITMSRC
      *********
     C     ITMSRC        BEGSR
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVE      *BLANKS       SHPFR             3
     C                   CALL      'ITMALOOK'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHS              3
     C                   ENDSR
      *********
      * ITEMLK
      *********
     C     ITEMLK        BEGSR
     C*                    MOVELITEM      ITMKEY
     C*          ITMKEY    CHAINFMINVT               90
     C                   ENDSR
      *********
      * SIZESR
      *********
     C     SIZESR        BEGSR
     C                   MOVEL     VSIZE         SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   MOVEL     SZDESC        VDESC            10
     C                   SETON                                        99
     C                   ENDSR
      *********
      * PCSR
      *********
     C     PCSR          BEGSR
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC
     C                   SETON                                        99
     C                   ENDSR
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   SETON                                        99
     C                   ENDSR
      *********
      * PHYTSR
      *********
     C     PHYTSR        BEGSR
     C                   MOVEL     VCODE         PHCODE            1
     C                   CALL      'LKPHYT'
     C                   PARM                    PHCODE
     C                   PARM                    PHYDES           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     PHCODE        VCODE
     C                   SETON                                        99
     C                   ENDSR
      *********
      * GETCST
      *********
     C     GETCST        BEGSR
     C                   MOVE      *BLANKS       CMLOOK           15
     C                   CALL      'CSTALOOK'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   Z-ADD     CMCUST        VSCUST
     C***                  MOVELCMNAME    VSNAME
     C     CMCUST        CHAIN     FMCUST                             90
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
      *****
      ********************************************************************@DT@B1
      * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE  @DT@B1
      * ##CYMD INPUT DATE CYYMMDD                                         @DT@B1
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B1
      * INDICATORS USED 90-92.                                            @DT@B1
      ********************************************************************@DT@B1
     C     @DT@B1        BEGSR                                                                 @DT@B
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE       @DT@B
      * CONVERT YEAR TO DAYS                                              @DT@B1
     C                   MOVEL     ##CYMD        #03               3 0          YY             @DT@B
     C     #03           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
     C     #03           DIV       4             #03                      93    # OF LEAPS     @DT@B
     C                   MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C   91
     CANN93#03           SUB       1             #03                                           @DT@B
     C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
      * CONVERT MONTH TO DAYS                                             @DT@B1
     C                   MOVE      ##CYMD        #04               4 0          MMDD           @DT@B
     C                   MOVEL     #04           #02A                           MM             @DT@B
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
     C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CAN 92
     CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12  @DT@B
      * ADD DAY OF MONTH                                                  @DT@B1
     C                   MOVE      ##CYMD        #02               2 0          DD             @DT@B
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
     C   90              Z-ADD     0             ##DDD                                         @DT@B
     C                   SETOFF                                       919293                   @DT@B
     C                   ENDSR                                                                 @DT@B
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
