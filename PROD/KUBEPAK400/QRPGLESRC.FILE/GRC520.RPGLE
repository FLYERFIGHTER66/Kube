      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1995
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
      **PROGRAM NAME-------- GRC510
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- GD
      **APPLICATION--------- WEEKLY PRODUCTION LIST  PROMPT SCREEN
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  10/18/96  GD - ADD PRINTER FIELD
      *
     FFMINVT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FGRC520FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LJOBQ                  6      6
     D  LFORM                  7     16
     D  LP1COP                25     26  0
     D  LBEGDT                37     42  0
     D  LENDDT                43     48  0
     D  LPRTR                 61     69
     D  LBEGIT                89    100
     D  LENDIT               104    115
     D  LSLOC                116    118
     D  LRLOC                119    121
     D  LREAS                122    124
     D  LCANCL               133    133
     D  LUSER                134    141
      *
      ****************************************************************
      ***  VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR             8
     C     VPRTR         IFLE      *BLANKS
     C                   MOVEL     'PRT01'       VPRTR
     C                   ENDIF
      *
     C                   MOVEL     '*NAR'        VFORM
     C                   MOVEL     'N'           VJOB
     C                   Z-ADD     1             VCOPY
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131420
     C                   SETOFF                                       212324
     C                   SETOFF                                       253031
     C                   SETOFF                                       404550
     C                   SETOFF                                       5299
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
      *** OPTION HELP
      *
     C                   MOVEL     VBITEM        LBEGIT
     C                   MOVEL     VEITEM        LENDIT
     C                   MOVEL     VSLOC         LSLOC
     C                   MOVEL     VRLOC         LRLOC
     C                   MOVEL     FLREAS        LREAS
     C                   MOVEL     FLUSER        LUSER
     C                   MOVEL     *BLANKS       LCANCL
     C     VBDATE        IFGT      *ZEROS
     C     VBDATE        MULT      10000.01      BDATE
     C                   ENDIF
     C                   Z-ADD     BDATE         LBEGDT
     C     VEDATE        IFGT      *ZEROS
     C     VEDATE        MULT      10000.01      EDATE
     C                   ENDIF
     C                   Z-ADD     EDATE         LENDDT
     C                   MOVEL     VFORM         LFORM
     C                   Z-ADD     VCOPY         LP1COP
     C                   MOVE      VJOB          LJOBQ
     C                   MOVEL     VPRTR         LPRTR
      *
     C     1             SUBST     VBITEM:1      VITST             1
     C     VITST         IFEQ      '?'
     C                   MOVEL     *BLANKS       IMLOOK           15
     C     11            SUBST     VBITEM:2      IMLOOK
     C                   MOVEL     '   '         SHPFR
     C                   CALL      'ITMALOOK'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        VBITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHSE
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     VEITEM:1      VITST             1
     C     VITST         IFEQ      '?'
     C                   MOVEL     *BLANKS       IMLOOK           15
     C     11            SUBST     VEITEM:2      IMLOOK
     C                   MOVEL     '   '         SHPFR
     C                   CALL      'ITMALOOK'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        VEITEM
     C                   MOVEL     IMSIZE        VSIZE             3
     C                   MOVEL     IMWHSE        VWHSE             3
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBITEM        IFEQ      *BLANKS                                                  K
     C     VEITEM        ANDGT     *BLANKS                                                  K
     C                   SETON                                        1011
     C   11              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBITEM        IFEQ      *BLANKS                                                  K
     C     VEITEM        ANDGT     *BLANKS                                                  K
     C                   SETON                                        1011
     C   11              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBITEM        IFEQ      *BLANKS                                                  K
     C                   GOTO      NOITEM
     C                   ENDIF
      *
     C                   MOVEL     VBITEM        ITEM             12
     C     KEY12         KLIST
     C                   KFLD                    ITEM
     C     KEY12         SETLL     FMINVT
     C                   READ      FMINVT                                 90
     C   90              SETON                                        1012
     C   12              GOTO      RSTRTA
      *
     C     IMITEM        IFNE      VBITEM
     C                   SETON                                        1012
     C   12              GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VEITEM        ITEM             12
     C     KEY12         SETLL     FMINVT
     C                   READ      FMINVT                                 90
     C   90              SETON                                        13
     C   13              GOTO      RSTRTA
      *
     C     IMITEM        IFNE      VEITEM
     C                   SETON                                        13
     C   13              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBITEM        IFGT      VEITEM
     C                   SETON                                        1014
     C   14              GOTO      RSTRTA
     C                   ENDIF
      *
     C     NOITEM        TAG
      *
     C     VBDATE        IFGT      *ZEROS                                                   K
     C     VEDATE        ANDEQ     *ZEROS                                                   K
     C                   SETON                                        2021
     C   21              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBDATE        IFGT      *ZEROS                                                   K
     C     VEDATE        ANDEQ     *ZEROS                                                   K
     C                   SETON                                        2021
     C   21              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBDATE        IFGT      *ZEROS                                                   K
     C     VBDATE        MULT      100.0001      BDATE             6 0                      K
     C     VEDATE        MULT      100.0001      EDATE             6 0                      K
     C                   ENDIF
     C     BDATE         IFGT      EDATE                                                    K
     C                   SETON                                        2022
     C   22              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBDATE        IFGT      *ZEROS                                                   K
     C                   Z-ADD     VBDATE        ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        2023
     C   23              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VEDATE        IFGT      *ZEROS                                                   K
     C                   Z-ADD     VEDATE        ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        25
     C   25              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VSLOC         IFGT      *BLANKS
     C                   MOVEL     VSLOC         WHWHSE            3
     C     KEY3          KLIST
     C                   KFLD                    WHWHSE
     C     KEY3          CHAIN     FMWHSE                             90
     C   90              SETON                                        30
     C   30              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VRLOC         IFGT      *BLANKS
     C                   MOVEL     VRLOC         WHWHSE            3
     C     KEY3          CHAIN     FMWHSE                             90
     C   90              SETON                                        31
     C   31              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        45
     C   45              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VJOB          IFNE      'Y'                                                      Q
     C     VJOB          ANDNE     'N'
     C                   SETON                                        50
     C   50              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPRTR         IFEQ      *BLANKS
     C                   SETON                                        52
     C   52              GOTO      RSTRTA
     C                   ENDIF
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
      *****
