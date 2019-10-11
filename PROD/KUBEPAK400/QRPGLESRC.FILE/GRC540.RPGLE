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
      **PROGRAM NAME-------- GRC540
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- GD
      **APPLICATION--------- ALLOCATED PICK LIST  PROMPT SCREEN
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMWHSE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FGRC540FM  CF   E             WORKSTN
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
     D  LBDATE                 1      6  0
     D  LEDATE                 7     12  0
     D  LJOBQ                 18     18
     D  LFORM                 19     22
     D  LP1COP                29     30  0
     D  LPRTR                 31     39
     D  LBSHFR                40     42
     D  LESHFR                43     45
     D  LCANCL               133    133
      *
      ****************************************************************
      ***  VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR             8
     C     VPRTR         IFLE      *BLANKS
     C     '999'         CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR
     C                   ENDIF
      *
     C                   MOVEL     '*NAR'        VFORM
     C                   MOVEL     'N'           VJOB
     C                   Z-ADD     1             VCOPY
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101530
     C                   SETOFF                                       111220
     C                   SETOFF                                       405052
     C                   SETOFF                                       9921
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
      *** OPTION HELP
      *
     C                   MOVEL     *BLANKS       LCANCL
     C                   Z-ADD     VBDATE        LBDATE
     C                   Z-ADD     VEDATE        LEDATE
     C                   MOVEL     VFORM         LFORM
     C                   Z-ADD     VCOPY         LP1COP
     C                   MOVE      VJOB          LJOBQ
     C                   MOVEL     VPRTR         LPRTR
     C                   MOVEL     VBSHFR        LBSHFR
     C                   MOVEL     VESHFR        LESHFR
      *
     C     VBDATE        IFEQ      *ZEROS                                                   K
     C                   SETON                                        1011
     C   11              GOTO      RSTRTA
     C                   ENDIF
      *
      *  CHECK FOR A VALID DATE.
      *
     C                   Z-ADD     VBDATE        ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        1011
     C   11              GOTO      RSTRTA
      *
     C     VEDATE        IFEQ      *ZEROS                                                   K
     C                   SETON                                        15
     C   15              GOTO      RSTRTA
     C                   ENDIF
      *
     C                   Z-ADD     VEDATE        ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        15
     C   15              GOTO      RSTRTA
      *
     C     VBDATE        MULT      10000.01      BDATE             6 0
     C     VEDATE        MULT      10000.01      EDATE             6 0
      *
     C     VBDATE        IFGT      *ZEROS
     C     BDATE         ANDGT     EDATE
     C                   SETON                                        11
     C   11              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBSHFR        IFEQ      '? '
     C                   MOVEL     VBSHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VBSHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VESHFR        IFEQ      '? '
     C                   MOVEL     VESHFR        VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VESHFR
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBSHFR        IFGT      *BLANKS
     C     VBSHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        20
     C   20              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VESHFR        IFGT      *BLANKS
     C     VESHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        21
     C   21              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VBSHFR        IFGT      *BLANKS
     C     VBSHFR        ANDGT     VESHFR
     C                   SETON                                        20
     C   20              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        40
     C   40              GOTO      RSTRTA
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
      **
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-  . C=1 FOR YY 00-69.@DT@A1
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
