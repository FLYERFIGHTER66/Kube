      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1996
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
      **PROGRAM NAME-------- GRC530
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- GD
      **APPLICATION--------- PRODUCTION REVIEW REPORT PROMPT SCREEN
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  10/18/96  GD - ADD PRINTER FIELD
      *  11/05/96  GD - ADDED LOCATION AND REGION
      *
     FFMINVT    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFPHYTO    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FGRC530FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D                UDS
     D  LBEGDT                 1      6  0
     D  LENDDT                 7     12  0
     D  LBPC                  13     14
     D  LEPC                  15     16
     D  LSUM                  17     17
     D  LJOBQ                 18     18
     D  LFORM                 19     28
     D  LP1COP                29     30  0
     D  LBLIST                31     34
     D  LELIST                35     38
     D  LBSIZE                39     41
     D  LESIZE                42     44
     D  LBPHYT                45     45
     D  LEPHYT                46     46
     D  LBLOC                 47     49
     D  LELOC                 50     52
     D  LREGN                 53     54
     D  LPRTR                 61     70
     D  LBITEM                89    100
     D  LEITEM               101    112
     D  LCANCL               133    133
      *
      ****************************************************************
      ***  VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR
     C     VPRTR         IFLE      *BLANKS
     C     '999'         CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR
     C                   ENDIF
      *
     C                   MOVEL     '*NAR'        VFORM
     C                   MOVEL     'N'           VJOB
     C                   Z-ADD     1             VCOPY
      *
     C     RSTRT         TAG
     C                   Z-ADD     *ZEROS        VBDATE
     C                   Z-ADD     *ZEROS        VEDATE
     C                   MOVEL     *BLANKS       VBLIST
     C                   MOVEL     *BLANKS       VELIST
     C                   MOVEL     *BLANKS       VBITEM
     C                   MOVEL     *BLANKS       VEITEM
     C                   MOVEL     *BLANKS       VBSIZE
     C                   MOVEL     *BLANKS       VESIZE
     C                   MOVEL     *BLANKS       VBPC
     C                   MOVEL     *BLANKS       VEPC
     C                   MOVEL     *BLANKS       VBPHYT
     C                   MOVEL     *BLANKS       VEPHYT
     C                   MOVEL     *BLANKS       VBLOC
     C                   MOVEL     *BLANKS       VELOC
     C                   MOVEL     *BLANKS       VREGN
     C                   SETOFF                                       77
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       192121
     C                   SETOFF                                       222330
     C                   SETOFF                                       242526
     C                   SETOFF                                       272829
     C                   SETOFF                                       313252
     C                   SETOFF                                       405090
     C                   SETOFF                                       783435
      *
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
     C   KF              GOTO      RSTRT
      *
      *** OPTION HELP
      *
     C                   MOVEL     *BLANKS       LCANCL
     C                   Z-ADD     VBDATE        LBEGDT
     C                   Z-ADD     VEDATE        LENDDT
     C                   MOVE      VBLIST        LBLIST
     C                   MOVE      VELIST        LELIST
     C                   MOVEL     VBITEM        LBITEM
     C                   MOVEL     VEITEM        LEITEM
     C                   MOVEL     VBSIZE        LBSIZE
     C                   MOVEL     VESIZE        LESIZE
     C                   MOVE      VBPC          LBPC
     C                   MOVE      VEPC          LEPC
     C                   MOVE      VBPHYT        LBPHYT
     C                   MOVE      VEPHYT        LEPHYT
     C                   MOVE      VBLOC         LBLOC
     C                   MOVE      VELOC         LELOC
     C                   MOVE      VREGN         LREGN
     C                   MOVEL     VFORM         LFORM
     C                   Z-ADD     VCOPY         LP1COP
     C                   MOVE      VJOB          LJOBQ
     C                   MOVEL     VPRTR         LPRTR
      *
     C     VBDATE        IFEQ      *ZEROS
     C     VEDATE        ANDEQ     *ZEROS
     C                   GOTO      NODATE
     C                   ENDIF
      *
     C                   Z-ADD     VBDATE        ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        1011
     C   11              GOTO      NXT
     C     VBDATE        MULT      10000.01      BDATE             6 0
      *
     C                   Z-ADD     VEDATE        ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        12
     C   12              GOTO      NXT
     C     VEDATE        MULT      10000.01      EDATE             6 0
      *
     C     BDATE         IFGT      EDATE
     C                   SETON                                        13
     C   13              GOTO      NXT
     C                   ENDIF
      *
     C                   SETON                                        77
      *
     C     NODATE        TAG
      *
     C     VBLIST        IFEQ      *BLANKS
     C     VELIST        ANDEQ     *BLANKS
     C                   GOTO      NOLIST
     C                   ENDIF
      *
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
     C                   SETON                                        77
      *
     C     NOLIST        TAG
      *
     C     VBITEM        IFEQ      *BLANKS
     C     VEITEM        ANDEQ     *BLANKS
     C                   GOTO      NOITEM
     C                   ENDIF
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
     C                   SETON                                        77
      *
     C     NOITEM        TAG
      *
     C     VBSIZE        IFEQ      *BLANKS
     C     VESIZE        ANDEQ     *BLANKS
     C                   GOTO      NOSIZE
     C                   ENDIF
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
     C     VBSIZE        CHAIN     FMSIZE                             90
     C   90              SETON                                        19
     C   19              GOTO      NXT
      *
     C     VBSIZE        IFGT      VESIZE
     C                   SETON                                        1829
     C   29              GOTO      NXT
     C                   ENDIF
      *
     C                   SETON                                        77
      *
     C     NOSIZE        TAG
      *
     C     VBLOC         IFEQ      *BLANKS
     C     VELOC         ANDEQ     *BLANKS
     C                   GOTO      NOLOC
     C                   ENDIF
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
     C     VBLOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        34
     C   34              GOTO      NXT
      *
     C     VELOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        35
     C   35              GOTO      NXT
      *
     C     VBLOC         IFGT      VELOC
     C                   SETON                                        34
     C                   GOTO      NXT
     C                   ENDIF
     C                   SETON                                        77
      *
     C     NOLOC         TAG
      *
     C     VBPC          IFEQ      *BLANKS
     C     VEPC          ANDEQ     *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
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
     C                   SETON                                        77
      *
     C     NOPC          TAG
      *
     C     VBPHYT        IFEQ      *BLANKS
     C     VEPHYT        ANDEQ     *BLANKS
     C                   GOTO      NOPHYT
     C                   ENDIF
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
     C                   SETON                                        77
      *
     C     NOPHYT        TAG
      *
     C     VFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      NXT
     C                   ENDIF
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        40
     C   40              GOTO      NXT
     C                   ENDIF
      *
     C     VJOB          IFNE      'Y'                                                      Q
     C     VJOB          ANDNE     'N'
     C                   SETON                                        50
     C   50              GOTO      NXT
     C                   ENDIF
      *
     C     VPRTR         IFEQ      *BLANKS
     C                   SETON                                        52
     C   52              GOTO      NXT
     C                   ENDIF
      *
     C  N77              SETON                                        78
     C   78              GOTO      NXT
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
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
     C     ITMKEY        KLIST
     C                   KFLD                    ITEM
     C     ITMKEY        CHAIN     FMINVT                             90
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
      * PHYTSR
      *********
     C     PHYTSR        BEGSR
     C                   MOVEL     VCODE         PHCODE            1
     C                   CALL      'LKPHYT'
     C                   PARM                    PHCODE
     C                   PARM                    PHYDES           30
     C*                    PARM           PHDESS 10
     C*                    PARM           PHCERT  1
     C*                    PARM           PHCHRG  52
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     PHCODE        VCODE
     C                   SETON                                        99
     C                   ENDSR
      *
