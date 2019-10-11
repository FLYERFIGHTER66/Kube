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
      **PROGRAM NAME-------- GRS500  -  PRODUCTION REVIEW REPORT
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT SYSTEM
      **APPLICATION--------- PRODUCTION
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/05/96 GD ADD LOCATION PARAMETERS
      *  2/14/97 EFD ADD FSLOT BALANCES.
      *
      *
      *
     FFDLOTRDR  IF   E           K DISK
     FFIORITEM  IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFSLOT     IF   E           K DISK
     FGRS530    O    F  132        PRINTER OFLIND(*INOF)
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
     D  LBITEM                89    100
     D  LEITEM               101    112
     D  LCANCL               133    133
      *
     C   OF              SETON                                        OF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        CURDAT            7 0
     C                   Z-ADD     1             ITM               3 0
     C                   Z-ADD     1             FIRST             5 0
     C                   MOVEL     '00'          MCCOMP
     C     LREGN         IFGT      *BLANKS
     C                   MOVEL     '*ALL'        REGN              4
     C                   SETON                                        68
     C                   ELSE
     C                   MOVEL     LREGN         REGN
     C                   END
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
      *
      *  GET SELECTIONS
      *
     C     LBITEM        IFGT      *BLANKS
     C                   SETON                                        6066
     C                   ENDIF
      *
     C     LBEGDT        IFGT      *ZEROS
     C     LBEGDT        MULT      10000.01      BDAT1             6 0
     C                   MOVEL     BDAT1         YY                2 0
     C                   MOVE      BDAT1         BDATE             7 0
     C     YY            IFLE      70
     C                   MOVEL     1             BDATE
     C                   ELSE
     C                   MOVEL     0             BDATE
     C                   END
     C     LENDDT        MULT      10000.01      EDAT1             6 0
     C                   MOVEL     EDAT1         YY                2 0
     C                   MOVE      EDAT1         EDATE             7 0
     C     YY            IFLE      70
     C                   MOVEL     1             EDATE
     C                   ELSE
     C                   MOVEL     0             EDATE
     C                   END
     C                   SETON                                        6165
     C                   ENDIF
      *
     C     LBLIST        IFGT      *BLANKS
     C                   SETON                                        6365
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        6265
     C                   ENDIF
      *
     C     LBSIZE        IFGT      *BLANKS
     C                   SETON                                        6466
     C                   ENDIF
      *
     C     LBPHYT        IFGT      *BLANKS
     C                   SETON                                        6766
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS
     C                   SETON                                        6869
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      RDLOTRD                                77
     C   77              GOTO      END
     C                   SETOFF                                       80
      *
      * ONLY RANGE OF READY DATES
      *
     C                   Z-ADD     LRCRDY        WK6               6 0
     C     WK6           MULT      100.0001      SHPDTE            6 0
     C   61LRCRDY        IFLT      BDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   61LRCRDY        IFGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ONLY RANGE OF LIST CODES
      *
     C   63ITMKEY        CHAIN     FMINVT                             50
     C   63IMLIST        IFLT      LBLIST
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   63IMLIST        IFGT      LELIST
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ONLY RANGE OF ITEMS
      *
     C   60LRITEM        IFLT      LBITEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60LRITEM        IFGT      LEITEM
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ONLY RANGE OF SIZES
      *
     C   64LRSIZE        IFLT      LBSIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   64LRSIZE        IFGT      LESIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ONLY RANGE OF LOCATIONS
      *
     C     LRCLOC        IFEQ      *BLANKS
     C                   MOVEL     LRGLOC        LRCLOC
     C                   END
     C   69LRCLOC        IFLT      LBLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   69LRCLOC        IFGT      LELOC
     C                   GOTO      NXT
     C                   ENDIF
      *
      * SELECTED REGION
      *
     C     LREGN         IFGT      *BLANKS
     C     LRCLOC        CHAIN     FMWHSE                             90
     C     LREGN         IFNE      WHREG
     C                   GOTO      NXT
     C                   END
     C                   END
      *
      * ONLY RANGE OF PRODUCT CLASSES
      *
     C   62LRPRCL        IFLT      LBPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   62LRPRCL        IFGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ONLY RANGE OF PHYTO CODES
      *
     C   67LRCPHY        IFLT      LBPHYT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   67LRCPHY        IFGT      LEPHYT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LRITEM        IFEQ      SAVITM
     C     LRSIZE        ANDEQ     SAVSZE
     C                   GOTO      NOCHG
     C                   ENDIF
      *
     C   55              DO
     C                   EXCEPT    TL1P
     C                   EXSR      GETSHP
     C     TQNALL        SUB       TLQTAV        TQTREQ           11 120
     C                   EXCEPT    TL1
     C                   Z-ADD     *ZEROS        TQNALL
     C                   Z-ADD     *ZEROS        TQFAL
     C                   Z-ADD     LRCRDY        WK6               6 0
     C     WK6           MULT      100.0001      SHPDTE            6 0
     C                   ENDDO
      *
     C                   Z-ADD     1             ITM
     C                   Z-ADD     1             FIRST
     C     ITMKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C     ITMKEY        CHAIN     FMINVT                             50
     C                   EXSR      GETDES
      *
     C     NOCHG         TAG
      *
     C     FIRST         IFEQ      1
     C     ITMKEY        SETLL     FIORITEM
     C     NXTR          TAG
     C     ITMKEY        READE     FIORITEM                               90
     C  N90              DO
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTR
     C                   ENDIF
     C**         OILOTC    IFEQ 'Y'
     C**                   GOTO NXTR
     C**                   ENDIF
     C     OIQORD        SUB       OIQSHP        QNALL            11 1
     C                   SUB       OIQTAL        QNALL
      ** GET DATE
     C                   Z-ADD     OISOW         ##MDY
     C                   EXSR      @DT@A1
     C     CURDAT        IFGE      ##CYMD
     C                   ADD       QNALL         TQNALL           11 140
     C                   ELSE
     C                   ADD       QNALL         TQFAL            11 141
     C                   END
     C                   GOTO      NXTR
     C                   ENDDO
     C                   EXCEPT    HDG1
     C                   SETOFF                                       4041
     C                   ENDIF
      *
     C     LRQTOH        SUB       LRQTAL        QTAV             11 1
     C                   ADD       LRQTOH        TLQTOH           12 1
     C                   ADD       LRQTAL        TLQTAL           12 1
     C                   ADD       QTAV          TLQTAV           12 1
      *
     C                   MOVEL     LRITEM        SAVITM           12
     C                   MOVEL     LRSIZE        SAVSZE            3
     C     ITM           IFEQ      1
     C                   SETON                                        50
     C                   ENDIF
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     LRCUST        IFGT      *ZEROS
     C     LRCUST        CHAIN     FMCUST                             90
     C                   SETON                                        80
     C                   ENDIF
     C                   EXCEPT    DTL1
     C                   SETON                                        55
     C                   ADD       1             ITM
     C                   ADD       1             FIRST
     C                   SETOFF                                       50
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1P
     C                   EXSR      GETSHP
     C     TQNALL        SUB       TLQTAV        TQTREQ           11 120
     C                   EXCEPT    TL1
     C                   SETON                                        LR
      *
      **********
      * GETSHP
      **********
     C     GETSHP        BEGSR
     C                   Z-ADD     0             SHP#              5 0
     C                   Z-ADD     BDATE         NBDATE            6 0
      ** GET FSLOT TO FIRST RECORD OF ITEM
     C     SLTKEY        KLIST
     C                   KFLD                    IMCOMP
     C                   KFLD                    SAVITM
     C                   KFLD                    SAVSZE
     C                   KFLD                    NBDATE
     C     SLTCMP        KLIST
     C                   KFLD                    IMCOMP
     C                   KFLD                    SAVITM
     C                   KFLD                    SAVSZE
     C     SLTKEY        SETLL     FSLOT
     C     NXTSLT        TAG
     C     SLTCMP        READE     RSLOT                                  91
     C   91              GOTO      ENDSLT
      ** CHECK DATES
     C     MLSHPD        MULT      100.0001      SHPDTE            6 0
     C     EDATE         IFGT      0
     C     MLSHPD        ANDGT     EDATE
     C                   GOTO      ENDSLT
     C                   END
      *
     C   69MLSLOC        IFLT      LBLOC
     C                   GOTO      NXTSLT
     C                   ENDIF
      *
     C   69MLSLOC        IFGT      LELOC
     C                   GOTO      NXTSLT
     C                   ENDIF
      *
      * SELECTED REGION
      *
     C     LREGN         IFGT      *BLANKS
     C     MLSLOC        CHAIN     FMWHSE                             90
     C     LREGN         IFNE      WHREG
     C                   GOTO      NXTSLT
     C                   END
     C                   END
      *
     C     MLQTOH        SUB       MLQTAO        QTAV             11 1
     C     MLQTOH        SUB       MLQTAL        QTNEED           11 1
     C                   ADD       MLQTOH        SLQTOH           12 1
     C                   ADD       MLQTAL        SLQTAL           12 1
     C                   ADD       QTAV          SLQTAV           12 1
     C                   ADD       QTNEED        SLQTND           12 1
     C                   ADD       MLQTAO        SLQTAO           12 1
      ** SEE IF WE NEED HEADING
     C     SHP#          IFEQ      0
     C  NOF              EXCEPT    SHPHED
     C                   END
     C                   ADD       1             SHP#
     C   OF              DO
     C                   EXCEPT    HDG
     C                   EXCEPT    SHPHED
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DTL1S
     C                   GOTO      NXTSLT
     C     ENDSLT        TAG
     C                   ADD       SLQTOH        TLQTOH           12 1
     C                   ADD       SLQTAO        TLQTAL           12 1
     C                   ADD       SLQTAV        TLQTAV           12 1
     C                   EXCEPT    TL1S
     C                   ENDSR
      *
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
     C                   MOVEL     DESCO         DESP             50
     C                   ENDSR
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
     OGRS530    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           62 'Production Rev'
     O                                           72 'iew Report'
     O                       TIMOD              120 '  :  :  '
     O          E   N65      HDG            1
     O                                            1 ' '
     O          E    65      HDG         1  1
     O               61                          16 'For Ready Dates:'
     O               61      LBEGDT        Y     25
     O               61                          27 '-'
     O               61      LENDDT        Y     36
     O               63                          66 'For List Codes:'
     O               63      LBLIST              71
     O               63                          73 '-'
     O               63      LELIST              78
     O               62                         112 'For Product Classes:'
     O               62      LBPC               115
     O               62                         117 '-'
     O               62      LEPC               120
     O          E    66      HDG            1
     O               60                          10 'For Items:'
     O               60      LBITEM              23
     O               60                          25 '-'
     O               60      LEITEM              38
     O               64                          66 'For Size Codes:'
     O               64      LBSIZE              70
     O               64                          72 '-'
     O               64      LESIZE              76
     O               67                         112 'For Phyto Codes:'
     O               67      LBPHYT             114
     O               67                         116 '-'
     O               67      LEPHYT             118
     O          E    68      HDG            1
     O               69                          14 'For Locations:'
     O               69      LBLOC               18
     O               69                          20 '-'
     O               69      LELOC               24
     O                                          112 'For Region:'
     O                       REGN               117
     O          E            HDG            1
     O                                           78 'Ready'
     O                                           97 'Qty'
     O                                          108 'Qty'
     O                                          119 'Qty'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           16 'Size'
     O                                           70 'Code'
     O                                           89 'Phyto'
     O                                           37 'Description/P.C.'
     O                                           83 'Loc'
     O                                           77 'Date'
     O                                           97 'O/H'
     O                                          109 'Alloc'
     O                                          120 'Avail'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           HDG1           1
     O                       LRSIZE              16
     O                       LRITEM              12
     O                       DESP                67
     O                       LRPRCL              70
     O          EF   40      HDG1           1
     O                                           88 'Qty Not Alloc. Past Sow'
     O                                           94 'Date:'
     O                       TQNALL        M    109
     O          EF   41      HDG1           1
     O                                           84 'Qty.Not Alloc. Future'
     O                                           94 'Sow Date:'
     O                       TQFAL         M    109
     O          EF           DTL1           1
     O                       QTAV          M    120
     O                       LRQTAL        M    109
     O                       LRQTOH        M     98
     O                       LRCPHY              87
     O*                        SHPDTEY   82
     O                       LRCLOC              83
     O                       SHPDTE        Y     79
     O                       LRCODE              70
     O               80                          13 'Reserved for:'
     O                       LRCUST        ZB    20
     O                       CMNAME         B    51
     O          E            TL1P           1
     O                                          120 '---------'
     O                                          109 '---------'
     O                                           98 '---------'
     O          E            TL1P           1
     O                                           82 'Production Totals ====>'
     O                       TLQTAV        M    120
     O                       TLQTAL        M    109
     O                       TLQTOH        M     98
     O          EF           SHPHED         1
     O                                           55 'Qty. Ordered'
     O          EF           DTL1S          1
     O                       QTAV          M    120
     O                       MLQTAO        M    109
     O                       MLQTOH        M     98
     O                       MLSLOC              83
     O                       SHPDTE        Y     79
     O                       MLQTAL        M     55
     O**               80                13 'Reserved for:'
     O**                       MLCUSTZB  20
     O**                       CMNAME B  51
     O          EF           TL1S           1
     O                                          120 '---------'
     O                                          109 '---------'
     O                                           98 '---------'
     O                                           55 '---------'
     O          EF           TL1S           2
     O                                           82 'Shipping Totals ======>'
     O                       SLQTAV        MB   120
     O                       SLQTAO        MB   109
     O                       SLQTOH        MB    98
     O                       SLQTAL        MB    55
     O          EF           TL1            1
     O                                          120 '========='
     O                                          109 '========='
     O                                           98 '========='
     O          EF           TL1            2
     O               20                          45 'Quantity Required ===>'
     O               20      TQTREQ        MB    58
     O                                           82 'Item Totals ====>'
     O                       TLQTAV        MB   120
     O                       TLQTAL        MB   109
     O                       TLQTOH        MB    98
