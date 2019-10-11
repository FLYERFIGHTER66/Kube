      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.   1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- GRS540
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- PRINTING OF ALLOCATED PICK TICKETS
      **
      *
      *
     FFIORDR    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFALITEM   IF   E           K DISK
     FFFRTYP    IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FGRS540    O    F  132        PRINTER
      *
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
     D #SL             S             32    DIM(5)
     D #SH             S             32    DIM(5)
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
      *** RENAME HORDR FIELDS
     IRHORDR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
     I              OHSLD1                      #WSLD1
     I              OHSLD2                      #WSLD2
     I              OHSLD3                      #WSLD3
     I              OHSLD4                      #WSLD4
     I              OHSLCT                      #WSLCT
     I              OHSLST                      #WSLST
     I              OHSLZP                      #WSLZP
      *
      *  GET DAY OF CENTURY
      *
     C     LBDATE        IFGT      *ZEROS
     C                   SETON                                        19
     C                   Z-ADD     LBDATE        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LEDATE        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         EDATE             5 0
     C                   ENDIF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     1             PACK              4 0
      *
     C     LBSHFR        IFGT      *BLANKS
     C                   SETON                                        15
     C                   ENDIF
     C     NXTH          TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      END
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C   15OHSHFR        IFLT      LBSHFR
     C     OHSHFR        ORGT      LESHFR
     C                   GOTO      NXTH
     C                   ENDIF
      *
      *** FIND A LINE ITEM TO PRINT ON PICK SLIP
      *
     C     NXT           TAG
     C                   Z-ADD     0             LINE
      *
     C     OHORD#        SETLL     FIORDR
     C     NXTI          TAG
     C     OHORD#        READE     RIORDR                                 77
     C   77              GOTO      NXTH
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OISIZE        IFEQ      'ROY'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'N'
     C     OISIZE        OREQ      'TAG'
     C                   GOTO      NXTI
     C                   ENDIF
      *
      *  GET DAY OF CENTURY
      *
     C     OIDTRQ        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C                   ENDIF
     C     RSHDT         IFGT      *ZEROS
     C     RSHDT         ANDLT     BDATE
     C     RSHDT         ORGT      EDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   SETOFF                                       202155
     C                   SETOFF                                       2223
     C                   Z-ADD     1             PHEAD
     C                   Z-ADD     1             PGE               3 0
      *
      *
      * NO ALLOCATIONS
      *
     C     KEY9          CHAIN     FALITEM                            92
     C   92              GOTO      NXTI
      *
     C     OHSHPC        CHAIN     FMSVIA                             98
     C     OHSLM1        CHAIN     FMSLSM                             98
     C  N98              MOVEL     SMNAME        SNAME            17
     C     OHCUST        CHAIN     FMCUST                             98
      *
     C                   EXSR      #SLD
     C                   EXSR      #SHP
      *
     C                   MOVEL     OHTMCD        TERMCD            2
     C     TERMCD        CHAIN     FMTERM                             98
     C                   MOVEL     TCDESC        TERM             12
     C     OHPPCD        CHAIN     FFRTYP                             90
     C                   MOVEL     FRDESC        PPCD              8
      *
     C     OHROUT        IFGT      *BLANKS
     C                   SETON                                        20
     C                   ENDIF
      *
     C     OHSTOP        IFGT      *ZEROS
     C                   SETON                                        21
     C                   ENDIF
      *
     C     OHSPIN        IFGT      *BLANKS
     C                   SETON                                        22
     C                   ENDIF
      *
     C     OHSHIN        IFGT      *BLANKS
     C                   SETON                                        23
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C                   Z-ADD     OIORD#        OLDORD            6 0
     C     OHORD#        SETLL     FIORDR
     C     NXTA          TAG
     C                   READ      RIORDR                                 77
     C   77              EXCEPT    TL1
     C   77              GOTO      END
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     OISIZE        IFEQ      'ROY'
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'N'
     C                   GOTO      NXTI
     C                   ENDIF
      *
      *  GET DAY OF CENTURY
      *
     C   19OIDTRQ        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         RSHDT             5 0
     C                   ENDIF
     C   19OIDTRQ        IFGT      *ZEROS
     C     RSHDT         ANDLT     BDATE
     C     RSHDT         ORGT      EDATE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     OIORD#        IFNE      OLDORD
     C   55              EXCEPT    TL1
     C                   Z-ADD     *ZEROS        TOTORD
     C                   ADD       1             OHORD#
     C                   Z-ADD     1             PACK
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C     IMPCL1        CHAIN(N)  FMPRCL                             90
      * GENUS = 2
     C     PCPRP1        IFEQ      2
     C     IMDES1        ANDEQ     *BLANKS
     C     IMDES2        CAT       DESP:1        NDES             46
     C                   ENDIF
      * VARIETY = 2
     C     PCPRP3        IFEQ      2
     C     IMDES3        ANDEQ     *BLANKS
     C     DESP          CAT       IMDES2:1      NDES             46
     C                   ENDIF
      * COMMON NAME = 2
     C     PCPRP4        IFEQ      2
     C     IMDES4        ANDEQ     *BLANKS
     C     IMDES2        CAT       DESP:1        NDES             46
     C                   ENDIF
      *
     C     NOITM         TAG
     C                   Z-ADD     OIQORD        QORD              7 0
     C     OISEQ#        IFLT      900
     C                   SETON                                        40
     C                   ADD       QORD          TOTORD            7 0
     C                   ENDIF
      *
     C                   EXCEPT    DETL
      *
     C     KEY9          KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     KEY9          SETLL     FALITEM
      *
     C     NXTAL         TAG
     C     KEY9          READE     FALITEM                                91
     C   91              SETON                                        50
     C   91              EXCEPT    TAL
     C   91              GOTO      NXTA
      *
     C                   Z-ADD     AICRDY        NCRDY             6 0
     C     NCRDY         MULT      100.0001      CRDY              6 0
     C                   Z-ADD     AISOWD        NSOWD             6 0
     C     NSOWD         MULT      100.0001      SOWD              6 0
     C                   Z-ADD     AIQTOA        QALLOC            6 0
     C                   ADD       AIQTOA        TIALL             6 0
      *
     C                   EXCEPT    DETLA
      *
     C                   ADD       1             PHEAD             5 0
     C                   SETON                                        55
     C                   SETOFF                                       50
     C                   ADD       1             LINE              2 0
     C     LINE          COMP      35                                 50  50
     C   50              EXCEPT    MSGLN
     C   50              ADD       1             PGE
     C   50              EXCEPT    HDG
     C   50              Z-ADD     0             LINE
     C   50              SETOFF                                       50
     C                   GOTO      NXTAL
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *  ***********
      *  * #SLD    *
      *  ***********
      *
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
      *  ***********
      *  * #SHP    *
      *  ***********
      *
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
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'P'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             40
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
      ********************************************************************@DT@B1
     OGRS540    E            HDG              03
     O                       PROGID              10
     O                                           30 'Requested by:'
     O                       USERID              41
     O                                           70 'Allocated Pick Ticket'
     O                                          116 'Page:'
     O                       PGE           Z    120
     O          E            HDG              04
     O                       TDATE         Y     18
     O                                            9 'Run Date:'
     O                                           63 'Ship From:'
     O                       OHSHFR              67
     O                       TIMOD              120 '  :  :  '
     O                                          111 'Time:'
     O          E            HDG              06
     O                       OHBLCU        Z     24
     O                       OHCUST        Z     84
     O          E            HDG              07
     O                                           16 'Bill'
     O                                           76 'Ship'
     O                       #SL(1)              50
     O                       #SH(1)             110
     O          E            HDG              08
     O                                           16 ' To '
     O                                           76 ' To '
     O                       #SL(2)              50
     O                       #SH(2)             110
     O          E            HDG              09
     O                       #SL(3)              50
     O                       #SH(3)             110
     O          E            HDG              10
     O                       #SL(4)              50
     O                       #SH(4)             110
     O          E            HDG              11
     O                       #SL(5)              50
     O                       #SH(5)             110
     O          E            HDG              12
     O                       CMPHON              90 '   -   -    '
     O          E            HDG              14
     O                       OHORD#        Z      8
     O                       OHDTOR        Y     19
     O                       OHSPIN              53
     O                       OHPONO             120
     O                       TERM                66
     O          E            HDG              15
     O                       OHSHIN              53
     O          E            HDG              16
     O                       OHDTRQ        Y     19
     O                       SVDESC              53
     O                       PPCD                65
     O                       SNAME              120
     O          E            HDG            1 18
     O                                           99 '-Current-'
     O                                          120 '-Original-'
     O          E            HDG            0
     O                                           11 'Description'
     O                                           45 'Item'
     O                                           56 'Size'
     O                                           65 'Req Date'
     O                                           73 'Ordered'
     O                                           80 'Alloc'
     O                                           89 'Rdy Date'
     O                                           93 'Loc'
     O                                           99 'Phyto'
     O                                          108 'Sow Date'
     O                                          114 'Loc'
     O                                          120 'Phyto'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           0
     O                       DESP                40
     O                       OIITEM              53
     O                       OISIZE              56
     O                       OIDTRQ        Y     65
     O                       QORD          4     72
     O          E            DETLA          1
     O                       QALLOC        4     78
     O                       CRDY          Y     89
     O                       AICLOC              93
     O                       AICPHY              97
     O                       SOWD          Y    108
     O                       AIGLOC             114
     O                       AIPHYT             118
     O          E            MSGLN          1
     O                                           43 '* * Continued'
     O                                           60 'On Next Page * *'
     O          E            TAL            1
     O                       TIALL         4B    78
     O                                           80 '*'
     O          E            TL1            1 58
     O                       TOTORD        4      7
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
