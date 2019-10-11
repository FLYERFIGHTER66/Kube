      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIC310
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- REP
      **APPLICATION--------- PROMPT SCREEN FOR PRINTING PICK SLIPS
      **DESCRIPTION--------- THIS PROGRAM ALLOWS FOR AN ENTRY DATE
      **                     THROUGH WHICH PICK SLIPS ARE TO BE RUN.
      **                     PICK SLIPS MAY BE RUN FOR A SELECTED
      **                     COMPANY OR ALL, OR A SELECTED ROUTE OR ALL.
      **
      *            **     PROGRAM CHANGE LOG    **
      * 1/25/99 EFD IF SECOND TIME THRU DO NOT ALLOW ALL SELECTION
      * 1/25/01 EFD ALLOW FOR ENTRY OF 1 AREA (PUT DOWN LOCATION).
      * 3/27/02 EFD ADD LOGIC FOR REPRINT CHANGES.
      * 4/23/02 EFD PRINT AND SAVE PICKS FROM OPTION 4.
      *
     FBIC310FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMCOMP    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFORDCHG   IF   E           K DISK
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
     D                UDS
     D  LCONO                  1      2  0
     D  LJOBQ                  6      6
     D  LPRTR                 17     24
     D  LP2ID                 27     34
     D  LDAPID                17     18
     D  LBEGDT                37     42  0
     D  LENDDT                43     48  0
     D  LSELEC                49     49  0
     D  LBORD                 50     55  0
     D  LPC1                  59     60
     D  LPC2                  61     62
     D  LRTE1                 63     64
     D  LRTE2                 65     66
     D  LPHY1                 67     67
     D  LPHY2                 68     68
     D  LPREV                 69     69
     D  LSHP1                 70     71
     D  LSHP2                 72     73
     D  LLOC1                 74     76
     D  LLOC2                 77     79
     D  LTAG                  80     80  0
     D  LEORD                 81     86  0
     D  AREA                  87     88
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LNEXT                134    134
rpaddD  LCPY1                135    136  0
rpaddD  LCPY2                137    138  0
rpaddD  LPS1                 139    139
rpaddD  LPS2                 140    140
WJB  D  CARTRQ               141    141
WJB  D  ORDSEQ               142    142
WJB  D  MASTERTYPE           999    999
      **
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPPCK        VPRTR             8
     C*                    MOVELDESHFR    VBLOC
     C*                    MOVELDESHFR    VELOC
     C     VPRTR         IFLE      *BLANKS
     C                   MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR
     C*                    MOVELDESHFR    VBLOC
     C*                    MOVELDESHFR    VELOC
     C                   ENDIF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      *BLANKS       AREA
      *
     C                   SETOFF                                       57
     C     LNEXT         IFEQ      'N'
     C                   Z-ADD     LSELEC        VPICK
     C                   MOVE      LCONO         VCO
     C                   MOVEL     LPRTR         DEV1
     C                   MOVEL     LP2ID         DEV2
     C                   Z-ADD     LBEGDT        VBDATE
     C                   Z-ADD     LENDDT        VEDATE
     C                   MOVEL     LRTE1         VBRTE
     C                   MOVEL     LRTE2         VERTE
     C                   MOVEL     LPC1          VBPC
     C                   MOVEL     LPC2          VEPC
     C                   MOVEL     LPHY1         VBPHY
     C                   MOVEL     LPHY2         VEPHY
     C                   MOVEL     LPREV         VPREV
     C                   Z-ADD     LEORD         LSTORD
     C                   Z-ADD     0             VBORD
     C                   Z-ADD     0             VEORD
     C                   MOVEL     LSHP1         VBSHPV
     C                   MOVEL     LSHP2         VESHPV
     C                   MOVEL     LLOC1         VBLOC             3
     C                   MOVEL     LLOC2         VELOC
     C                   Z-ADD     LTAG          VTAG
RPADDC                   Z-ADD     LCPY1         CPY1
RPADDC                   Z-ADD     LCPY2         CPY2
RPADDC                   MOVEL     LPS1          PS1
RPADDC                   MOVEL     LPS2          PS2
     C                   SETON                                        57
     C                   GOTO      RSTRT
     C                   END
     C                   Z-ADD     1             VPICK
     C                   Z-ADD     TDATE         VBDATE
     C                   Z-ADD     TDATE         VEDATE
     C                   MOVE      *BLANKS       VBPC
     C                   MOVE      *BLANKS       VEPC
     C                   MOVE      *BLANKS       VBRTE
     C                   MOVE      *BLANKS       VERTE
     C                   MOVE      *BLANKS       VBPHY
     C                   MOVE      *BLANKS       VEPHY
     C                   Z-ADD     1             VTAG
     C                   MOVE      '01'          VCO
     C                   MOVE      'Y'           VPREV
WJB  C                   MOVE      'N'           CARTRQ
      ** IF USER KUBE USE P7 ONLY
     C     USERID        IFNE      'KUBE'
     C                   MOVEL     VPRTR         DEV1
     C                   MOVEL     'P8'          DEV2
RPADDC                   Z-ADD     1             CPY1
RPADDC                   Z-ADD     2             CPY2
RPADDC                   MOVE      'N'           PS1
RPADDC                   MOVE      'N'           PS2
     C                   ELSE
     C                   MOVEL     'P7      '    DEV1
RPADDC                   Z-ADD     1             CPY2
RPADDC                   MOVE      'N'           PS1
RPADDC                   Z-ADD     0             CPY2
RPADDC                   MOVE      *BLANKS       PS2
     C                   MOVE      *BLANKS       DEV2
     C                   END
     C                   MOVE      *BLANKS       LCANCL
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131418
     C                   SETOFF                                       202425
     C                   SETOFF                                       304050
     C                   SETOFF                                       212223
     C                   SETOFF                                       319066
     C                   SETOFF                                       607071
rpaddC                   SETOFF                                       676869
     C                   SETOFF                                       7273U1
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KD              MOVEL     'F'           LCANCL
     C   KD              GOTO      END
     C                   MOVE      *BLANKS       LCANCL
      *
      ********** MOVE INTO LDA
      *
     C                   Z-ADD     VPICK         LSELEC
     C                   MOVE      VCO           LCONO
     C                   MOVEL     DEV1          LPRTR
     C                   MOVEL     DEV2          LP2ID
     C                   Z-ADD     VBDATE        LBEGDT
     C                   Z-ADD     VEDATE        LENDDT
     C                   MOVEL     VBRTE         LRTE1
     C                   MOVEL     VERTE         LRTE2
     C                   MOVEL     VBPC          LPC1
     C                   MOVEL     VEPC          LPC2
     C                   MOVEL     VBPHY         LPHY1
     C                   MOVEL     VEPHY         LPHY2
     C                   MOVEL     VPREV         LPREV
     C                   Z-ADD     VBORD         LBORD
     C                   Z-ADD     VEORD         LEORD
     C                   MOVEL     VBSHPV        LSHP1
     C                   MOVEL     VESHPV        LSHP2
     C                   MOVEL     VBLOC         LLOC1
     C                   MOVEL     VELOC         LLOC2
     C                   Z-ADD     VTAG          LTAG
RPADDC                   Z-ADD     CPY1          LCPY1
RPADDC                   Z-ADD     CPY2          LCPY2
RPADDC                   MOVEL     PS1           LPS1
RPADDC                   MOVEL     PS2           LPS2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
      *
      *   CHECK FOR VALID CART REQUIRMENTS (CARTRQ)
      *
     C     CARTRQ        IFNE      'Y'
     C     CARTRQ        ANDNE     'N'
     C                   SETON                                        24
     C                   GOTO      RSTRT
     C                   ENDIF
     C     CARTRQ        IFEQ      'Y'
     C     VPICK         ANDNE     5
     C                   SETON                                        2425
     C                   GOTO      RSTRT
     C                   ENDIF
      *
      *   CHECK FOR VALID PICK SLIP SELECTION
      *
     C     VPICK         IFLT      1
     C     VPICK         ORGT      9
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
      *   CHECK FOR IF ORDERS TO REPRINT
      *
     C     VPICK         IFEQ      4
     C     000000        SETLL     FORDCHG
     C                   READ      FORDCHG                                18
     C   18              SETON                                        10
     C   18              GOTO      RSTRT
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   GOTO      NOSEL
     C                   ENDIF
      *
      *  CHECK FOR A VALID DATE.
      *
     C     VBDATE        IFEQ      *ZEROS
     C                   GOTO      NODTE
     C                   ENDIF
     C                   Z-ADD     VBDATE        ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        1112
     C   12              GOTO      RSTRT
      *
     C     VEDATE        IFLE      0
     C     VBDATE        ANDGT     0
     C                   Z-ADD     VBDATE        VEDATE
     C                   Z-ADD     VEDATE        LENDDT
     C                   END
     C                   Z-ADD     VEDATE        ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        13
     C   13              GOTO      RSTRT
      *
      * CHECK END DATE IS > BEG DATE
      *
      *  GET DAY OF CENTURY
     C                   Z-ADD     LBEGDT        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LENDDT        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         EDATE             5 0
     C*          VBDATE    MULT 10000.01  BDATE   60
     C*          VEDATE    MULT 10000.01  EDATE   60
      *
     C     BDATE         IFGT      EDATE
     C                   SETON                                        1114
     C   14              GOTO      RSTRT
     C                   ENDIF
     C     NODTE         TAG
      *
     C     VBORD         IFGT      *ZEROS
     C     VBORD         CHAIN     FHORDR                             90
     C   90              SETON                                        2021
     C   20              GOTO      RSTRT
     C                   ENDIF
      *
     C     VBORD         IFGT      *ZEROS
     C     VEORD         ANDLE     0
     C                   Z-ADD     VBORD         VEORD
     C                   Z-ADD     VEORD         LEORD
     C                   ENDIF
     C     VBORD         IFGT      *ZEROS
     C     VBORD         ANDGT     VEORD
     C                   SETON                                        2122
     C   22              GOTO      RSTRT
     C                   ENDIF
     C     VBORD         IFLE      *ZEROS
     C     LNEXT         ANDEQ     'N'
     C                   SETON                                        2123
     C                   GOTO      RSTRT
     C                   ENDIF
      *
      *  PRODUCT CLASS
      *
     C     VBPC          IFGT      VEPC
     C                   SETON                                        40
     C   40              GOTO      RSTRT
     C                   ENDIF
      *
     C     VBPC          IFEQ      *BLANKS
     C     VEPC          ANDGT     *BLANKS
     C                   SETON                                        40
     C   40              GOTO      RSTRT
     C                   ENDIF
      *
      * SHIP VIA CODES
      *
     C     VBSHPV        IFGT      VESHPV
     C                   SETON                                        62
     C   62              GOTO      RSTRT
     C                   ENDIF
      *
     C     VBSHPV        IFEQ      *BLANKS
     C     VESHPV        ANDGT     *BLANKS
     C                   SETON                                        62
     C   62              GOTO      RSTRT
     C                   ENDIF
      *
      * LOCATION CODES
      *
     C     VBLOC         IFGT      VELOC
     C                   SETON                                        64
     C   64              GOTO      RSTRT
     C                   ENDIF
      *
     C     VBLOC         IFEQ      *BLANKS
     C     VELOC         ANDGT     *BLANKS
     C                   SETON                                        64
     C   64              GOTO      RSTRT
     C                   ENDIF
      *
      *  ROUTE
      *
     C     VBRTE         IFGT      VERTE
     C                   SETON                                        50
     C   50              GOTO      RSTRT
     C                   ENDIF
      *
     C     VBRTE         IFEQ      *BLANKS
     C     VERTE         ANDGT     *BLANKS
     C                   SETON                                        50
     C   50              GOTO      RSTRT
     C                   ENDIF
      *
      * PHYTO CODES
      *
     C     VBPHY         IFGT      VEPHY
     C                   SETON                                        60
     C   60              GOTO      RSTRT
     C                   ENDIF
      * GET AREA RIGHT JUSTIFIED
     C     AREA          IFGT      *BLANKS
     C                   MOVE      AREA          TST1              1
     C     TST1          IFLE      *BLANKS
     C                   MOVEL     AREA          TST1
     C                   MOVE      *BLANKS       AREA
     C                   MOVE      TST1          AREA
     C                   END
     C                   END
      *
     C     VBPHY         IFEQ      *BLANKS
     C     VEPHY         ANDGT     *BLANKS
     C                   SETON                                        60
     C   60              GOTO      RSTRT
     C                   ENDIF
      *
      *  CHECK ORDER TYPE
      *
     C     VTAG          IFLT      1                                                        Q
     C     VTAG          ORGT      3
     C                   SETON                                        66
     C   66              GOTO      RSTRT
     C                   ENDIF
      *
      *  CHECK COMPANY NUMBER.
      *
     C     VCO           IFEQ      *ZEROS
     C                   SETON                                        30
     C   30              GOTO      RSTRT
     C                   ENDIF
      *
     C     VCO           CHAIN     FMCOMP                             90
     C   90              SETON                                        30
     C   30              GOTO      RSTRT
      *
      * CHECK FOR VALID RESPONSE TO PRINT PREVIOUSLY PRINTED ORDERS
      *
     C     VPREV         IFNE      'Y'                                                      Q
     C     VPREV         ANDNE     'N'
     C                   SETON                                        7072
     C   70              GOTO      RSTRT
     C                   ENDIF
      *
     C     VPREV         IFEQ      'N'                                                      Q
     C     VPICK         ANDGE     5                                                        Q
     C                   SETON                                        7172
     C   71              GOTO      RSTRT
     C                   ENDIF
      * COME HERE ON OPTION 4
     C     NOSEL         TAG
      *
      * CHECK FOR A VALID DEVICE
      *
     C     DEV1          IFEQ      *BLANKS
     C                   SETON                                        65
     C   65              GOTO      RSTRT
     C                   ENDIF
     C     DEV2          IFGT      *BLANKS
     C                   SETON                                        U1
     C                   ELSE
     C                   SETOFF                                       U1
     C                   ENDIF
      *
      *
      * CHECK FOR VALIB NUMBER OF COPIES
      *
     C     CPY1          IFEQ      *ZERO
     C                   SETON                                        73
     C   73              GOTO      RSTRT
     C                   ENDIF
     C     DEV2          IFGT      *BLANKS
     C     CPY2          IFEQ      *ZEROS
     C                   SETON                                        68
     C   68              GOTO      RSTRT
     C                   ENDIF
     C                   ENDIF
      *
      *
      *
      * CHECK FOR VALIB PRINT & SAVE Y OR N
      *
     C     PS1           IFNE      'Y'
     C     PS1           IFNE      'N'
     C                   SETON                                        67
     C   67              GOTO      RSTRT
     C                   ENDIF
     C                   ENDIF
     C     DEV2          IFGT      *BLANKS
     C     PS2           IFNE      'Y'
     C     PS2           IFNE      'N'
     C                   SETON                                        69
     C   69              GOTO      RSTRT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     END           TAG
     C     LCANCL        IFNE      'X'
     C                   MOVEL     'N'           LNEXT
     C                   ELSE
     C                   MOVE      *BLANKS       LNEXT
     C                   END
     C                   SETON                                        LR
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
