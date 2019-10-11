0002 H*--------------------------------------------------------------
0003 H*
0004 H*  COPYRIGHT EFD ENTERPRISES, INC.    1997
0005 H*
0006 H*       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
0007 H*       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
0008 H*       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
0009 H*       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
0010 H*       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
0011 H*       BY EXPRESS WRITTEN PERMISSION OF
0012 H*            EFD ENTERPRISES, INC.       215-643-5352
0013 H*
0014 H*--------------------------------------------------------------
0015 F**PROGRAM NAME-------- SPC070
0016 F**COMPANY------------- EFD ENTERPRISES, INC.
0017 F**SYSTEM-------------- PLAINVIEW
0018 F**APPLICATION--------- INQUIRY INTO LOT AVAILABILITY.
0019 F**
0020 F*CHANGE--DATE-------DESCRIPTION
0021 F*  3/08/99 EFD USE F2 INSTEAD OF F12 TO GO FORWARD 4 WEEKS.
0021 F*
0021 FSPC070FM  CF   E             WORKSTN
     F                                     SFILE(LOTSFL:RECNO)
     FFMCUST    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFLCSTAT   IF   E           K DISK
     FFDLOTSDI  IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FSPC070    O    F   85        PRINTER OFLIND(*INOF)
0021 F*
0021 F* DATE SUB ROUTINE ARRAYS
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
0001 D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
0021 F* MESSAGE ARRAY
     D MSG             S             30    DIM(4) CTDATA PERRCD(1)                               @DT
0021 F* DATE HEADING ARRAYS
     D WK              S              5  0 DIM(4) ASCEND                                         @DT
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
0460 C*********************
0461 C** START SCREEN 1
0462 C*********************
0463 C                   TIME                    TIMOD             6 0
0464 C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C     01            CHAIN     FLCSTAT                            10
     C     RSTART        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       99
     C                   Z-ADD     0             CUST
     C                   Z-ADD     0             VDATE
     C                   MOVE      '1'           TYPE
     C                   MOVE      *BLANKS       SIZCD
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102030
     C                   SETOFF                                       99
     C   KC
     COR KG              GOTO      END
      ** CHECK THE DATE
     C                   SETOFF                                       1099
     C                   Z-ADD     VDATE         ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        99
     C  N99              EXSR      @DT@B1
     C   90              SETON                                        99
     C  N99              Z-ADD     ##DDD         WK(1)
     C  N99              EXSR      @DAYWK
     C     #Y            IFNE      1
     C                   SETON                                        99
     C                   END
     C   99              SETON                                        10
     C   99              GOTO      NXTA
      ** CHECK SIZE CODE
     C                   MOVEL     SIZCD         SITST             1
     C     SITST         IFEQ      '?'
     C                   CALL      'LKSIZE'
     C                   PARM                    SIZCD
     C                   PARM                    SZDESC
     C                   GOTO      NXTA
     C                   ENDIF
     C     SIZCD         IFGT      *BLANKS
     C     SIZCD         CHAIN     FMSIZE                             20
     C   20              SETON                                        99
     C                   END
      **  SKIP TYPE AND CUSTOMER
     C                   GOTO      NOCUST
      ** CHECK CUSTOMER
     C   KA              DO
     C                   MOVEL     *BLANKS       CMLOOK
     C                   CALL      'CSTALOOK'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CNAME
     C                   Z-ADD     CMCUST        CUST
     C                   GOTO      NXTA
     C                   ENDDO
     C     CUST          IFGT      0
     C     TYPE          OREQ      '3'
     C     CUST          CHAIN     FMCUST                             30
     C   30              SETON                                        99
     C                   ENDIF
     C     NOCUST        TAG
     C                   MOVEL     '1'           TYPE
     C   99              GOTO      NXTA
      ** IF HERE ALL OK SET UP HEADER
     C     CUST          IFEQ      0
     C                   MOVE      *BLANKS       CNAME
     C                   MOVEL     MSG(1)        CNAME
     C                   END
     C     SIZCD         IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SZDESC
     C                   MOVEL     MSG(2)        SZDESC
     C                   END
      ** GET HEADING
     C                   EXSR      BLDHED
      ** DISPLAY SCREEN
     C     NXTFMT        TAG
     C                   EXSR      BLDSFL
     C                   EXFMT     LOTCTL
      ** CHECK COMMAND KEYS
     C   KC              GOTO      END
     C   KA              DO
     C                   SUB       28            WK(1)
     C                   EXSR      BLDHED
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KB              DO
     C                   ADD       28            WK(1)
     C                   EXSR      BLDHED
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KM              DO
     C                   SETON                                        OF
     C                   EXSR      PRT
     C                   GOTO      NXTFMT
     C                   ENDDO
     C                   GOTO      RSTART
     C     END           TAG
     C                   SETON                                        LR
      ******************
      * PRINT SUB FILE *
      ******************
     C     PRT           BEGSR
     C                   Z-ADD     RECNO         ORECNO            5 0
     C                   Z-ADD     1             RECNO
     C     NXTPRT        TAG
     C     RECNO         CHAIN     LOTSFL                             90
     C   90              DO
     C                   ADD       1             RECNO
     C     RECNO         IFLE      ORECNO
     C                   GOTO      NXTPRT
     C                   ELSE
     C                   GOTO      ENDPRT
     C                   END
     C                   ENDDO
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   ADD       1             RECNO
     C     RECNO         IFLE      ORECNO
     C                   GOTO      NXTPRT
     C                   ELSE
     C                   GOTO      ENDPRT
     C                   END
     C     ENDPRT        TAG
     C                   Z-ADD     ORECNO        RECNO
     C                   ENDSR
      ******************
      * BUILD SUB FILE *
      ******************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     LOTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             COUNT             5 0
     C     LOTKEY        KLIST
     C                   KFLD                    SIZCD
     C     LOTKEY        SETLL     FDLOTSDI
     C     NXTLOT        TAG
     C                   READ      FDLOTSDI                               50
     C   50              GOTO      ENDLOT
     C     SIZCD         IFGT      *BLANKS
     C     SIZCD         ANDNE     LRSIZE
     C     COUNT         IFGT      0
     C                   EXSR      WRTSFL
     C                   END
     C                   GOTO      ENDLOT
     C                   ENDIF
      ** CHECK IF WE WANT THIS RECORD
     C     TYPE          IFEQ      '2'
     C     LRCUST        ANDNE     0
     C                   GOTO      NXTLOT
     C                   ENDIF
     C     TYPE          IFEQ      '3'
     C     LRCUST        ANDNE     CUST
     C                   GOTO      NXTLOT
     C                   ENDIF
     C                   If        LRGLOC = 'N'
     C                   GOTO      NXTLOT
     C                   ENDIF
     C     LRITEM        IFNE      OITEM
     C     LRSIZE        ORNE      OSIZE
     C     LRCUST        ORNE      OCUST
     C     COUNT         IFGT      0
     C                   EXSR      WRTSFL
     C                   END
     C                   Z-ADD     0             COUNT
     C                   MOVEL     LRITEM        OITEM            12
     C                   MOVEL     LRSIZE        OSIZE             3
     C                   Z-ADD     LRCUST        OCUST             6 0
     C                   ENDIF
     C     LRCUST        IFGT      0
     C                   Z-ADD     LRQTOH        AVAIL
     C                   ADD       LRQTCM        AVAIL            11 1
     C                   SUB       LRQTSL        AVAIL
     C                   ELSE
     C                   Z-ADD     LRQTOH        AVAIL
     C                   END
     C                   SUB       LRQTAL        AVAIL
     C     AVAIL         IFEQ      0
     C                   GOTO      NXTLOT
     C                   ENDIF
     C                   Z-ADD     LRCRDY        ##CYMD
     C                   EXSR      @DT@B1
     C     ##DDD         IFLT      WK(1)
     C     ##DDD         ORGT      WK(4)
     C                   GOTO      NXTLOT
     C                   ENDIF
     C                   ADD       1             COUNT
     C     ##DDD         IFEQ      WK(1)
     C                   Z-ADD     AVAIL         AVAL1
     C                   END
     C     ##DDD         IFEQ      WK(2)
     C                   Z-ADD     AVAIL         AVAL2
     C                   END
     C     ##DDD         IFEQ      WK(3)
     C                   Z-ADD     AVAIL         AVAL3
     C                   END
     C     ##DDD         IFEQ      WK(4)
     C                   Z-ADD     AVAIL         AVAL4
     C                   END
     C                   GOTO      NXTLOT
     C     ENDLOT        TAG
     C     COUNT         IFGT      0
     C                   EXSR      WRTSFL
     C                   END
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       LRSIZE
     C                   MOVE      *BLANKS       OSIZE
     C                   MOVEL     MSG(3)        IMDES1
     C                   MOVE      *BLANKS       CMBABB
     C                   ADD       2             RECNO
     C                   WRITE     LOTSFL
     C                   ENDSR
      *
      ******************
      * WRITE SUB FILE *
      ******************
     C     WRTSFL        BEGSR
     C                   MOVE      *BLANKS       CMBABB
     C     OCUST         IFGT      0
     C     OCUST         CHAIN     FMCUST                             90
     C                   END
     C                   MOVEL     OITEM         ITEM
     C     ITMKEY        KLIST
     C                   KFLD                    OITEM
     C                   KFLD                    OSIZE
     C     ITMKEY        CHAIN     FMINVT                             90
     C                   ADD       1             RECNO
     C                   WRITE     LOTSFL
     C                   Z-ADD     0             AVAL1
     C                   Z-ADD     0             AVAL2
     C                   Z-ADD     0             AVAL3
     C                   Z-ADD     0             AVAL4
     C                   Z-ADD     0             COUNT
     C                   ENDSR
      *********************
      * BUILD WEEK ARRAYS *
      *********************
     C     BLDHED        BEGSR
      ** NOW GET DATE HEADINGS
     C     WK(1)         ADD       7             WK(2)
     C     WK(2)         ADD       7             WK(3)
     C     WK(3)         ADD       7             WK(4)
     C                   Z-ADD     WK(1)         ##DDD
     C                   EXSR      @DT@D0
     C                   MOVEL     ##MDY         WEEK1
     C     ##MDY         CHAIN     FCALEN                             52
     C                   MOVEL     CLYEAR        WEK#1
     C                   MOVE      CLWEEK        WEK#1
     C                   Z-ADD     WK(2)         ##DDD
     C                   EXSR      @DT@D0
     C                   MOVEL     ##MDY         WEEK2
     C     ##MDY         CHAIN     FCALEN                             52
     C                   MOVEL     CLYEAR        WEK#2
     C                   MOVE      CLWEEK        WEK#2
     C                   Z-ADD     WK(3)         ##DDD
     C                   EXSR      @DT@D0
     C                   MOVEL     ##MDY         WEEK3
     C     ##MDY         CHAIN     FCALEN                             52
     C                   MOVEL     CLYEAR        WEK#3
     C                   MOVE      CLWEEK        WEK#3
     C                   Z-ADD     WK(4)         ##DDD
     C                   EXSR      @DT@D0
     C                   MOVEL     ##MDY         WEEK4
     C     ##MDY         CHAIN     FCALEN                             52
     C                   MOVEL     CLYEAR        WEK#4
     C                   MOVE      CLWEEK        WEK#4
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
     C*
0006 C********************************************************************
0007 C* FIGURES OUT DAY OF THE WEEK THAT ENTERED DATE IS.
0008 C* ##DDD INPUT DATE DDDDD - RESULT FROM @DT@B2
0009 C* #Y OUTPUT INDEX REFLECTING DAY OF WEEK
0011 C********************************************************************
0003 CSR   @DAYWK        BEGSR
0285 CSR   ##DDD         DIV       7.0000        #WKS             10 5
0286 CSR                 MOVE      #WKS          ##R               5 5
0287 CSR   ##R           MULT(H)   7             #Y                1 0
     C*
0288 CSR   #Y            IFGT      7
0289 CSR   #Y            SUB       7             #Y
     CSR                 END
     C*
     CSR   #Y            IFEQ      0
     CSR                 Z-ADD     7             #Y
     CSR                 END
     C*
0293 CSR                 ENDSR
      *
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
0007 C* CONVERT DAY OF CENTURY DDDDD TO MMDDYY                            @DT@D0
0008 C* ##DDD INPUT DAY OF CENTURY.                                       @DT@D0
0009 C* ##MDY OUTPUT DATE MMDDYY.                                         @DT@D0
0010 C* INDICATOR 90 IS A MINUS DATE.                                     @DT@D0
0011 C* INDICATORS 91-93 USED.                                            @DT@D0
0012 C********************************************************************@DT@D0
0003 CSR   @DT@D0        BEGSR                                                                 @DT@D
0013 CSR                 Z-ADD     0             ##MDY             6 0                         @DT@D
0014 C                   SETOFF                                       919293                   @DT@D
0015 C* TEST IF ZERO OR NEGATIVE                                          @DT@D0
0016 C     ##DDD         SUB       1             #05               5 0  90      REDUCE DDD BY 1@DT@D
0017 C   90              GOTO      @DT@DX                                       ERROR          @DT@D
0018 C* CALCULATE YEARS AND DAY OF YEAR                                   @DT@D0
0019 C     #05           DIV       365           #03               3 0          CYY            @DT@D
0020 C                   MVR                     #03A              3 0          DDD            @DT@D
0021 C* CALCULATE # OF LEAPS                                              @DT@D0
0022 C     #03           DIV       4             #02               2 0    92    # LEAPS        @DT@D
0023 C                   MVR                     #01               1 0    91    LEAP YEAR      @DT@D
     C   92
0024 CAN 91              SETOFF                                       91        1900 NOT LEAP  @DT@D
0025 C     #03A          ADD       1             #03A                           ADD TO DDD BY 1@DT@D
0026 C* IF LEAP YEAR, REDUCE # OF LEAPS BY ONE.                           @DT@D0
0027 CSR 91#02           SUB       1             #02                                           @DT@D
0028 CSR   #03A          SUB       #02           #03A                 92                       @DT@D
0029 C* IF DAYS NOT POSITIVE, ADJUST YEARS.                               @DT@D0
0030 CSRN92#03A          ADD       365           #03A                                          @DT@D
0031 C  N92#03           SUB       1             #03                    91      NO LONGER LEAP @DT@D
0032 C* DETERMINE IF NEW YEAR IS A LEAP.                                  @DT@D0
     CSRN92
0033 CANN91#01           COMP      1                                      91    IS A LEAP      @DT@D
0034 C* IF LEAP YEAR WAS MINUS                                            @DT@D0
     CSRN92
0035 CAN 91#03A          ADD       1             #03A                                          @DT@D
0036 C*                                                                   @DT@D0
0037 CSR   @DT@DA        TAG                                                                   @DT@D
0038 C* CALCULATE MONTH AND DAY.                                          @DT@D0
0039 CSR                 Z-ADD     2             #02                    9293                   @DT@D
0040 C* LEAP YEAR.                                                        @DT@D0
0041 CSR 91#03A          COMP      60                                 93  92                   @DT@D
     CSR 91
0042 CAN 93#03A          SUB       1             #03A                                          @DT@D
     CSR 91
0043 CAN 92              Z-ADD     3             #02                                           @DT@D
0044 CSRN92#03A          LOOKUP    #JD(#02)                           93  93                   @DT@D
0045 C*                                                                   @DT@D0
0046 CSR   #02           SUB       1             #02                                           @DT@D
0047 CSR   #03A          SUB       #JD(#02)      #03A                                          @DT@D
0048 CSR                 Z-ADD     #03A          #04               4 0                         @DT@D
0049 CSR                 MOVEL     #02           #04                                           @DT@D
0050 CSR                 Z-ADD     #03           ##MDY                                         @DT@D
0051 CSR                 MOVEL     #04           ##MDY                                         @DT@D
0052 C*                                                                   @DT@D0
0053 CSR                 SETOFF                                       919293                   @DT@D
0054 CSR   @DT@DX        ENDSR                                                                 @DT@D
0055 C********************************************************************@DT@D0
      ******************
      * OUTPUT SPECS   *
      ******************
     OSPC070    E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           65 'Availability Selected'
     O                                           71 'Weeks'
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           43 'Last Date Fixed:'
     O                       LSFXMD        Y     52
     O                                           76 'Time:'
     O                       TIMOD               85 '  :  :  '
     O          E            HEAD           1
     O                                           11 'Size Code:'
     O                       SIZCD               15
     O                       SZDESC              26
     O          E            HEAD           1
     O                                           10 'Customer:'
     O                       CNAME               41
     O                       WEK#1               54 ' 0-  '
     O                       WEK#2               62 ' 0-  '
     O                       WEK#3               70 ' 0-  '
     O                       WEK#4               78 ' 0-  '
     O          E            HEAD           1
     O                                           22 'Item Size Description'
     O                                           47 'Broker'
     O                       WEEK1         Y     54
     O                       WEEK2         Y     62
     O                       WEEK3         Y     70
     O                       WEEK4         Y     78
     O          EF           DETL           1
     O                       ITEM                 6
     O                       LRSIZE              10
     O                       IMDES1              41
     O                       CMBABB              47
     O                       AVAL1         K     55
     O                       AVAL2         K     63
     O                       AVAL3         K     71
     O                       AVAL4         K     79
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
**  MESSAGE ARRAY
    *** All Customers ***                                  1
All Sizes                                                  2
    *** End of Data ***                                    3
