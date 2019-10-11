    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- ALFDL2
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCULATE ALOLOCATIONS TO LOTS
      *           NOTE: ONLY ALLOCATE IF AFTER SOW DATE WEEK.
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 3/07/97 EFD ONLY ALLOCATE IF PAST FIX WEEK AND ONLY ALLOCATE
      *             FOR THE REQUESTED SHIP WEEK.
      * 3/16/97 EFD ADD LAST WEEK FIXED FROM STAT FILE.
      * 1/09/03 CAB CHANGED RIGHT HAND MARGIN PRINTING OVER PAGE.
      *10/20/05 WJB CHANGED TO IGNORE FIXER ALLOCATIONS
      *
     FFALITEM   UF   E           K DISK
     FFALITEMN  UF A E           K DISK
     F                                     RENAME(RALITEM:ALITEM)
     FFMINVT    IF   E           K DISK
     FFDSALEO   IF   E           K DISK
     FFLCSTAT   IF   E           K DISK
     FFIORDISC  IF   E           K DISK
     FFDLOTIRD  UF   E           K DISK
     FCALCALO   O    F  132        PRINTER OFLIND(*INOF)
      *
      * DATE SUB ROUTINE ARRAYS
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
0001 D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
      ****************
     D ThisMonday7     S              7S 0
     D AlocMonday7     S              7S 0
     D ThisWed7        S              7S 0
     D Today           S              7S 0
      *? Function Prototypes
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
      *
      ***********************
      * READ IORDR RECORD   *
      ***********************
     C                   SETON                                        OF
     C     NXTIOR        TAG
     C                   READ      FIORDISC                               90
     C   90              GOTO      END
     C     OIITYP        IFNE      ' '
     C     OIDTRQ        ORLE      0
     C     OIRVDT        ORLE      970601
WJB  C*    OIORD#        OReq      999999                                                     051020
WJB  C     OIORD#        ORGE      999990
     C                   GOTO      NXTIOR
     C                   END
      ** IF DELETED CHECK IF PROCESSED THRU DAILY ORDER POST
     C     OISTAT        IFEQ      'D'
     C     OIORD#        CHAIN     FDSALEO                            55
     C   55              GOTO      NXTIOR
     C     SDSTAT        IFEQ      'D'
     C                   GOTO      NXTIOR
     C                   END
     C                   END
      ** IF VAUGHN OR EXPRESS SPEC SKIP RECORD ADDED MICHELS
     C     OICUST        IFEQ      488
     C     OICUST        OREQ      137
     C     OICUST        OREQ      190
     C                   GOTO      NXTIOR
     C                   END
      ** IF SOW DATE GT THIS WEEK SKIP RECORD
      ** CHANGE TO FIX WEEK
     C     OISOW         IFGT      0
     C     OISOW         ANDGT     ThisMonday7
WJB  C*                  Z-ADD     OISOW         ##MDY
WJB  C*                  EXSR      @DT@A1
WJB  C*                  EXSR      @DT@B1
WJB  C*    ##DDD         IFGT      SOWTST
     C                   GOTO      NXTIOR
WJB  C*                  END
     C                   END
      *? Omit if not a lot order and Ship Date in Ready Bay or earlier
WJB  C     OILOTC        IfEQ      'Y'
WJB  C     OILOT#        andEQ     'CustomOrdr'
WJB  C     OIRVDT        andLE     AlocMonday7
WJB  C     OILOTC        OrNe      'Y'
WJB  C     OIRVDT        andLE     AlocMonday7
WJB  C                   GOTO      NXTIOR
WJB  C                   END
      ** IF HERE WE NEED THIS REC.
     C                   EXSR      CHKALO
     C     NEED          IFLE      0
     C                   GOTO      NXTIOR
     C                   END
      ** WE NEED TO GET ALLOCATION RECORD
     C                   EXSR      GETALO
     C                   GOTO      NXTIOR
     C     ENDIOR        TAG
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** CHECK IF ALLOCATED *
      ***********************
     C     CHKALO        BEGSR
     C                   Z-ADD     0             ALLO             11 1
     C     OIQORD        SUB       OIQSHP        NEED             11 1
     C                   ADD       OIQINV        NEED
     C     NEED          IFLE      0
     C                   GOTO      ENDCHK
     C                   END
      ** SEE HOW MANY ALLOCATED
     C     ALIKEY        KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     ALIKEY        SETLL     FALITEM
     C     NXTCHK        TAG
     C     ALIKEY        READE     RALITEM                                91
     C   91              GOTO      ENDCHK
     C     AIITEM        IFNE      OIITEM
     C     AISIZE        ORNE      OISIZE
     C                   DELETE    RALITEM
     C                   GOTO      NXTCHK
     C                   ENDIF
      *** NOW GET COUNT
     C                   ADD       AIQTOA        ALLO
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   SUB       ALLO          NEED
     C                   ENDSR
      ***********************
      ** GET ALLOCATIONS   **
      ***********************
     C     GETALO        BEGSR
     C     OICUST        IFNE      4496
     C                   Z-ADD     0             AICUST
     C                   ELSE
     C                   Z-ADD     OICUST        AICUST
     C                   END
     C                   Z-ADD     0             WKS               2 0
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     MINKEY        CHAIN     FMINVT                             61
     C     IMLOTC        IFNE      'Y'
     C     OILOT#        orEQ      'CustomOrdr'
     C                   GOTO      ENDGT
     C                   END
      ** SEE IF ANY LOTS AVAILABLE
     C     LOTKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    AICUST
     C                   KFLD                    LRCRDY
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C     NXTTRY        TAG
     C                   Z-ADD     ##CYMD        LRCRDY
     C     LOTKEY        CHAIN     FDLOTIRD                           93
     C                   Z-ADD     0             NWAL             11 1
     C  N93              DO
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C     LRQTAV        IFGT      0
     C     LRQTAV        IFGT      NEED
     C                   ADD       NEED          LRQTAL
     C                   Z-ADD     NEED          NWAL
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C                   UPDATE    RDLOTRD
     C                   ELSE
     C                   Z-ADD     LRQTAV        USED             11 1
     C                   ADD       USED          LRQTAL
     C                   Z-ADD     USED          NWAL
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C                   UPDATE    RDLOTRD
     C                   END
     C                   END
      ** OUTPUT FALITEM
     C     ALKEY         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    LRCRDY
     C                   KFLD                    LRCLOC
     C                   KFLD                    AICUST
     C     NWAL          IFGT      0
     C     ALKEY         SETLL     FALITEMN
     C     NXTA1         TAG
     C     ALKEY         READE     FALITEMN                               66
     C  N66AIORD#        IFNE      OIORD#
     C     AIOSEQ        ORNE      OISEQ#
     C                   GOTO      NXTA1
     C                   END
     C  N66              DO
     C                   ADD       NWAL          AIQTOA
     C                   ENDDO
     C   66              DO
     C                   CLEAR                   ALITEM
     C                   Z-ADD     OIORD#        AIORD#
     C                   Z-ADD     OISEQ#        AIOSEQ
     C                   Z-ADD     LRCRDY        AISHPD
     C                   Z-ADD     LRCRDY        AICRDY
     C                   Z-ADD     LRSOWD        AISOWD
     C                   Z-ADD     0             AICUST
     C                   Z-ADD     IMCOMP        AICOMP
     C                   MOVE      'A'           AISTAT
     C                   MOVEL     IMITEM        AIITEM
     C                   MOVEL     IMSIZE        AISIZE
     C                   MOVEL     LRGLOC        AIGLOC
     C                   MOVEL     LRPHYT        AIPHYT
     C                   MOVEL     IMPCL1        AIPRCL
     C                   Z-ADD     NWAL          AIQTOA
     C                   MOVEL     USERID        AIUSER
     C                   Z-ADD     TDATE         AIDTLA
     C                   Z-ADD     TIMOD         AITIME
     C                   WRITE     ALITEM
     C                   ENDDO
     C                   SUB       NWAL          NEED
     C                   END
     C                   ENDDO
     C     NEED          IFLE      0
     C                   GOTO      ENDGT
     C                   END
      ** CHECK IF ANY WEEKS LEFT
      ** 3/07/97 ONLY ALLOCATE AGAINST THIS WEEK
     C                   ADD       1             WKS
     C**         WKS       IFLE 4
     C**                   Z-ADDLDSHPD    ##CYMD
     C**                   EXSR @DT@B1
     C**                   SUB  7         ##DDD
     C**                   EXSR @DT@D0
     C**                   EXSR @DT@A1
     C**                   GOTO NXTTRY
     C**                   END
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    LOTHED
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    NOLOT
     C     ENDGT         TAG
     C                   UNLOCK    FALITEMN
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET DATES FINAL UPLOAD.
     C     01            CHAIN     FLCSTAT                            90
     C                   Z-ADD     LSFNLD        ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         SOWTST            5 0
     C                   SETON                                        OF
WJB  C                   Eval      ThisMonday7 = $Date7($Monday($Date(0):'SAT'))
WJB   *? Get Today's Date in cyymmdd
WJB  C                   Eval      Today = $Date7($Date(0))
WJB   *? Get This Week's Wednesday date in cyymmdd
WJB  C                   Eval      ThisWed7 =
WJB  C                             $Date7($addDate($Monday($Date(0):'SAT'):2))
WJB   *? If we are before this Week's Wednesday date use this weeks Monday Date
WJB  C                   If        Today <= ThisWed7
WJB  C                   Eval      AlocMonday7 = $Date7($Monday($Date(0):'SAT'))
WJB   *? If we are after this Week's Wednesday date use next weeks Monday Date
WJB  C                   Else
WJB  C                   Eval      AlocMonday7 =
WJB  C                             $Date7($addDate($Monday($Date(0):'SAT'):7))
WJB  C                   EndIf
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
     C     #02A          IFLE      0
     C                   Z-ADD     1             #02A
     C                   END
     C     #02A          IFGT      12
     C                   Z-ADD     12            #02A
     C                   END
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
0006 C********************************************************************@DT@D0
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
      ********************************************************************@DT@B1
      ******************
      * OUTPUT SPECS   *
      ******************
     OCALCALO   E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
CAB  O***                                65 'Lot Unavailable Report'
CAB  O                                           61 'Lot Unavailable Report'
CAB  O***                      PAGE  Z   85
CAB  O                       PAGE          Z     81
CAB  O***                                81 'Page:'
CAB  O                                           77 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           24 'Time:'
     O                       TIMOD               33 '  :  :  '
CAB  O***                                77 'User Date:'
CAB  O                                           73 'User Date:'
CAB  O***                      UDATE Y   85
CAB  O                       UDATE         Y     81
     O          E            LOTHED         1
     O                                            7 'Order #'
     O                                           11 'Seq'
     O                                           14 'Item'
     O                                           28 'Size'
     O                                           44 'Description'
     O                                           68 'Req Date'
     O                                           80 'Quantity'
     O          EF           NOLOT          1
     O                       OIORD#        Z      7
     O                       OISEQ#        Z     11
     O                       OIITEM              24
     O                       OISIZE              28
     O                       OIDES1              59
     O                       NEED          4     80
     O                       OIDTRQ        Y     68
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
