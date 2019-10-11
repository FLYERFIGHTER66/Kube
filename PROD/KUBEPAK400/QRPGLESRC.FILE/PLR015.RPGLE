0003 H*--------------------------------------------------------------
0004 H*
0005 H*  COPYRIGHT EFD ENTERPRISES, INC.    1995
0006 H*
0007 H*       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
0008 H*       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
0009 H*       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
0010 H*       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
0011 H*       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
0012 H*       BY EXPRESS WRITTEN PERMISSION OF
0013 H*            EFD ENTERPRISES, INC.       215-643-5352
0014 H*
0015 H*--------------------------------------------------------------
0016 F**PROGRAM NAME-------- PLR015
0017 F**COMPANY------------- EFD ENTERPRISES, INC.
0018 F**SYSTEM-------------- PLAINVIEW
0020 F**APPLICATION--------- GREATE CALENDAR FILE.
0023 F**
0024 F**
0026 F**
0027 F**
0033 F*
0034 F*            CHANGE--DATE-------DESCRIPTION
     F*
     F**
     FFCALEN    UF A E           K DISK
0001 D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
0001 D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
     C************************************
     C** MAIN LINE CODE
     C******************************************
      **01/02/06 IS A MONDAY
     C                   Z-ADD     010206        ##MDY
     C                   MOVE      ##MDY         CLYEAR
     C                   Z-ADD     CLYEAR        TSTYR             2 0
     C** THE FOLLOWING IS A DUMMY CHAIN
     C     ##MDY         CHAIN     FCALEN                             91
     C                   Z-ADD     0             YRCNT             3 0
     C                   MOVEL     'A'           CLSTAT
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C******************************************
     C     NXTYR         TAG
     C                   ADD       1             YRCNT
     C     YRCNT         IFGT      10
     C                   GOTO      END
     C                   END
     C** GET A MONDAY
     C     #Y            IFNE      1
     C     8             SUB       #Y            TST               2 0
     C                   ADD       TST           ##DDD
     C                   Z-ADD     TST           #Y
     C                   END
     C                   EXSR      @DT@D0
     C                   EXSR      @DT@A1
     C                   MOVEL     ##CYMD        NCYY              3 0
     C     CLYEAR        IFLT      TSTYR
     C                   Z-ADD     20            CLCENT
     C                   ELSE
     C                   Z-ADD     19            CLCENT
     C                   END
     C**                   MOVE NCYY      CLYEAR
     C                   Z-ADD     1             CLWEEK
     C                   GOTO      NXTDAY
     C     NXTWK         TAG
     C                   EXSR      @DT@D0
     C                   EXSR      @DAYWK
     C                   MOVE      ##MDY         YRTST             2 0
     C**         YRTST     IFNE CLYEAR
     C**                   GOTO NXTYR
     C**                   END
     C                   ADD       1             CLWEEK
     C     CLWEEK        IFEQ      53
     C     CLYEAR        ANDNE     98
     C                   Z-ADD     1             CLWEEK
     C                   ADD       1             CLYEAR
     C                   GOTO      NXTYR
     C                   END
     C     CLWEEK        IFEQ      54
     C     CLYEAR        ANDEQ     98
     C                   Z-ADD     1             CLWEEK
     C                   ADD       1             CLYEAR
     C                   GOTO      NXTYR
     C                   END
     C     NXTDAY        TAG
     C                   Z-ADD     ##MDY         CLDATE
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        CLCYMD
     C                   Z-ADD     #Y            CL#Y
     C                   WRITE     RCALEN
     C                   ADD       1             ##DDD
     C                   EXSR      @DT@D0
     C                   ADD       1             #Y
     C     #Y            IFGT      7
     C                   GOTO      NXTWK
     C                   END
     C                   GOTO      NXTDAY
0005 C**************
     C     END           TAG
     C                   SETON                                        LR
     C********************************************************************@DT@A1
0006 C* VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
0007 C* YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
0008 C* ##MDY INPUT DATE MMDDYY                                           @DT@A1
0009 C* ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
0010 C* C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
0002 CSR   @DT@A1        BEGSR                                                                 @DT@A
0011 CSR                 MOVE      ##MDY         #03A              3 0          MYY            @DT@A
0012 CSR                 MOVEL     0             #03A                           CYY            @DT@A
0013 CSR                 MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
0014 CSR                 MOVEL     ##MDY         #02B              2 0          MM             @DT@A
0015 CSR                 MOVE      #04           #02C              2 0          DD             @DT@A
0016 CSR                 Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
0017 CSRN90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
0018 CSRN90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
0019 CSRN90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
0020 CSRN90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
0021 CSR   #02B          COMP      07                                 92        MM 08-12       @DT@A
0022 CSR 921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
0023 CSR   #02           DIV       2             #02                                           @DT@A
0024 CSR                 MVR                     #02                  92        31 DAY MONTH   @DT@A
     CSR 91
0025 CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
0026 CSR   #02B          COMP      02                                     91    FEB            @DT@A
0027 CSRN91                                                                                    @DT@A
0028 COR 90              GOTO      @DT@AX                                                      @DT@A
0029 CSR   #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
0030 CSR                 MVR                     #02                      91    LEAP YEAR      @DT@A
0031 CSR   #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     CSRN91
0032 CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
0033 CSR   @DT@AX        TAG                                                    GOOD DATE      @DT@A
0034 CSR                 MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
0035 CSR                 MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
0036 CSR   #03A          COMP      070                                  91                     @DT@A
0037 CSR 91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
0038 CSR 90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
0039 CSR                 SETOFF                                       9192                     @DT@A
0040 CSR                 ENDSR                                                                 @DT@A
0041 C********************************************************************@DT@A1
0006 C********************************************************************@DT@B1
0007 C* CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE  @DT@B1
0008 C* ##CYMD INPUT DATE CYYMMDD                                         @DT@B1
0009 C* ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B1
0010 C* INDICATORS USED 90-92.                                            @DT@B1
0011 C********************************************************************@DT@B1
0003 CSR   @DT@B1        BEGSR                                                                 @DT@B
0012 CSR                 Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE       @DT@B
0013 C* CONVERT YEAR TO DAYS                                              @DT@B1
0014 CSR                 MOVEL     ##CYMD        #03               3 0          YY             @DT@B
0015 CSR   #03           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
0016 CSR   #03           DIV       4             #03                      93    # OF LEAPS     @DT@B
0017 CSR                 MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     CSR 91
0018 CANN93#03           SUB       1             #03                                           @DT@B
0019 CSR   #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
0020 C* CONVERT MONTH TO DAYS                                             @DT@B1
0021 CSR                 MOVE      ##CYMD        #04               4 0          MMDD           @DT@B
0022 CSR                 MOVEL     #04           #02A                           MM             @DT@B
0023 CSR   #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
0024 CSR   #02A          COMP      02                                 92        GT FEB         @DT@B
     CSR 91
     CAN 92
0025 CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12  @DT@B
0026 C* ADD DAY OF MONTH                                                  @DT@B1
0027 CSR                 MOVE      ##CYMD        #02               2 0          DD             @DT@B
0028 CSR   #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
0029 CSR 90              Z-ADD     0             ##DDD                                         @DT@B
0030 CSR                 SETOFF                                       919293                   @DT@B
0031 CSR                 ENDSR                                                                 @DT@B
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
0032 C********************************************************************@DT@B1
0003 CSR   @DT@D0        BEGSR                                                                 @DT@D
0004 C********************************************************************@DT@D0
0005 C* COPYRIGHT MITTS DATA SYSTEMS, LTD. 1979                           @DT@D0
0006 C********************************************************************@DT@D0
0007 C* CONVERT DAY OF CENTURY DDDDD TO MMDDYY                            @DT@D0
0008 C* ##DDD INPUT DAY OF CENTURY.                                       @DT@D0
0009 C* ##MDY OUTPUT DATE MMDDYY.                                         @DT@D0
0010 C* INDICATOR 90 IS A MINUS DATE.                                     @DT@D0
0011 C* INDICATORS 91-93 USED.                                            @DT@D0
0012 C********************************************************************@DT@D0
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
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
