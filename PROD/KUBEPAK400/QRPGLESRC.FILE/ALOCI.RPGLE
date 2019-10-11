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
      **PROGRAM NAME-------- ALOCI
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ALLOCATE ORDER LINE ITEMS AT SELL TIME.
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  6/01/97 EFD ADD FLOTND
      *
     FFMINVT    UF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFDLOTRDD  UF   E           K DISK
     FFLOTND    UF A E           K DISK
     FFALITEM   O  A E             DISK
      **
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
     D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
      ** MINVT ARRAYS
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM 4
     D IGE             S              4  0 DIM(4)                               END WKS GERM 4
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
     D IGB7            S              7  0 DIM(4)                               BEG WKS GERM 7
     D IGE7            S              7  0 DIM(4)                               END WKS GERM 7
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
     IRMINVT
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    PHYTO             1
     C                   PARM                    REQDAT            6 0
     C                   PARM                    BLCUST            6 0
     C                   PARM                    ORDQTY           11 1
     C                   PARM                    ALQTY            11 1
     C                   PARM                    SHPREG            2            SHP FRM REGN
     C                   PARM                    COMP              2 0
     C                   PARM                    ORDER#            6 0
     C                   PARM                    SEQ#              3 0
      ********
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C                   MOVE      REQDAT        BYR               2 0
     C     ORDQTY        SUB       ALQTY         NEED             11 1
     C     ORDQTY        SUB       ALQTY         LTDHLD           11 1
     C                   Z-ADD     REQDAT        ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        REVDAT            7 0
     C                   Z-ADD     ##CYMD        SHPCYM            7 0
      ** GET TO PREV MONDAY DATE
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     #Y            IFNE      1
     C     #Y            SUB       1             #L                2 0
     C                   SUB       #L            #Y
     C                   SUB       #L            ##DDD
     C                   EXSR      @DT@D0
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        REVDAT            7 0
     C                   END
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ITMKEY        CHAIN     FMINVT                             89
      ** GET ALL LOTS STILL GOOD AND AVAILABLE
     C   89              Z-ADD     0             IMWKAV
     C     IMWKAV        MULT      7             DAYS              5 0
      ** USE 26 WEEKS AS DEFAULT IF DAYS = 0
     C     DAYS          IFEQ      0
     C     52            MULT      7             DAYS
     C                   END
     C                   SUB       DAYS          ##DDD
     C                   EXSR      @DT@D0
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        BADDAT            7 0
      ** CHECK FOR AVAIL
     C     LOTKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    CODE
     C                   KFLD                    CUST
     C                   KFLD                    REVDAT
     C     LOTCMP        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    CODE
     C                   KFLD                    CUST
      ** CHECK FOR AVAIL THIS CUSTOMER
     C                   Z-ADD     BLCUST        CUST              6 0
     C                   MOVE      'R'           CODE              1
     C     LOTKEY        SETLL     FDLOTRDD
     C     NXTCST        TAG
     C     LOTCMP        READE     FDLOTRDD                               90
     C   90              GOTO      ENDCST
     C     LRCRDY        IFLT      BADDAT
     C                   GOTO      ENDCST
     C                   END
     C     LRCPHY        IFLT      PHYTO
     C                   GOTO      NXTCST
     C                   END
      ** IF HERE LOT IS AVAILABLE TO THIS CUSTOMER
     C     LRQTOH        SUB       LRQTAL        LEFT             11 1
     C     LEFT          IFLE      0
     C                   GOTO      NXTCST
     C                   END
      ** CHECK IF SAME REGION
     C     LRCLOC        CHAIN     FMWHSE                             90
     C  N90WHREG         IFNE      SHPREG
     C                   GOTO      NXTCST
     C                   END
     C                   EXSR      PUTAL
     C     NEED          IFGT      0
     C                   GOTO      NXTCST
     C                   ELSE
     C                   GOTO      END
     C                   END
     C     ENDCST        TAG
      ** CHECK FOR AVAIL FROM NOT RESERVED LOTS
     C                   Z-ADD     0             CUST              6 0
     C                   MOVE      'A'           CODE              1
     C     LOTKEY        SETLL     FDLOTRDD
     C     NXTAV         TAG
     C     LOTCMP        READE     FDLOTRDD                               90
     C   90              GOTO      END
     C     LRCRDY        IFLT      BADDAT
     C                   GOTO      END
     C                   END
     C     LRCPHY        IFLT      PHYTO
     C                   GOTO      NXTAV
     C                   END
      ** IF HERE LOT IS AVAILABLE TO THIS CUSTOMER
     C     LRQTOH        SUB       LRQTAL        LEFT             11 1
     C     LEFT          IFLE      0
     C                   GOTO      NXTAV
     C                   END
      ** CHECK IF SAME REGION
     C     LRCLOC        CHAIN     FMWHSE                             90
     C  N90WHREG         IFNE      SHPREG
     C                   GOTO      NXTAV
     C                   END
     C                   EXSR      PUTAL
     C     NEED          IFGT      0
     C                   GOTO      NXTAV
     C                   END
      *** END PROGRAM
     C     END           TAG
      ** UPDATE MINVT
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C  N89              UPDATE    RMINVT
     C                   EXSR      UPLOTD
     C                   SETON                                        LR
      ****************************
      ** PUT ALLOCATIONS RECORD **
      ****************************
     C     PUTAL         BEGSR
      ** GET ALITEM RECORD FIELDS
     C                   Z-ADD     ORDER#        AIORD#
     C                   Z-ADD     SEQ#          AIOSEQ
     C                   Z-ADD     REVDAT        AISHPD
     C                   MOVE      'A'           AISTAT
     C                   MOVEL     IMITEM        AIITEM
     C                   MOVEL     IMSIZE        AISIZE
     C                   MOVEL     IMWHSE        AIWHSE
     C                   Z-ADD     LRSOWD        AISOWD
     C                   MOVEL     LRGLOC        AIGLOC
     C                   MOVEL     LRPHYT        AIPHYT
     C                   Z-ADD     LRCRDY        AICRDY
     C                   MOVEL     LRCPHY        AICPHY
     C                   MOVEL     LRCLOC        AICLOC
     C                   MOVEL     LRCODE        AICODE
     C                   Z-ADD     CUST          AICUST
     C                   MOVEL     'O'           AITYPE
     C                   MOVEL     'N'           AIFORC
     C                   Z-ADD     COMP          AICOMP
     C                   Z-ADD     TDATE         AIDTLA
     C                   Z-ADD     TIMOD         AITIME
     C                   MOVEL     USERID        AIUSER
     C                   MOVEL     IMPCL1        AIPRCL
     C                   Z-ADD     0             AIMAN#
     C                   Z-ADD     0             AISUB#
     C                   Z-ADD     0             AISEQ#
      ** IF MORE AVAILABLE THAN WE NEED USE IT AND END SUBR
     C     LEFT          IFGE      NEED
     C                   ADD       NEED          LRQTAL
     C                   ADD       NEED          IMQTAL
     C                   ADD       NEED          ALQTY
     C                   UPDATE    RDLOTRD
     C                   Z-ADD     NEED          AIQTOA
     C                   WRITE     RALITEM
     C                   Z-ADD     0             NEED
     C                   GOTO      ENDPUT
     C                   END
      ** IF HERE WE NEED MORE THAN AVAILABLE IN THIS LOT
     C                   ADD       LEFT          LRQTAL
     C                   ADD       LEFT          IMQTAL
     C                   ADD       LEFT          ALQTY
     C                   UPDATE    RDLOTRD
     C                   Z-ADD     LEFT          AIQTOA
     C                   WRITE     RALITEM
     C                   SUB       LEFT          NEED
     C     ENDPUT        ENDSR
      ****************************
      ** UPDATE LOTND RECORD    **
      ****************************
     C     UPLOTD        BEGSR
     C     WHREG         IFEQ      'W'
     C                   MOVEL     'Y'           PHY               1
     C                   ELSE
     C                   MOVEL     'B'           PHY               1
     C                   END
      ** FIRST TRY FOR RESERVED CUSTOMER
     C                   Z-ADD     BLCUST        CUST
     C                   MOVEL     'R'           LNCODE
     C     LTNKEY        CHAIN     FLOTND                             66
     C  N66              DO
     C                   ADD       LTDHLD        LNQTOO
     C                   Z-ADD     TIMOD         LNTIME
     C                   Z-ADD     TDATE         LNDTLA
     C                   MOVEL     USERID        LNUSER
     C                   MOVEL     IMLIST        LNLIST
     C                   UPDATE    RLOTND
     C                   GOTO      ENLOTD
     C                   ENDDO
     C     LTNKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    PHY
     C                   KFLD                    REVDAT
     C                   KFLD                    WHREG
     C                   KFLD                    LNCODE
     C                   KFLD                    CUST
      ** NOW TRY NO CUSTOMER
     C                   Z-ADD     0             CUST
     C                   MOVEL     'A'           LNCODE
     C     LTNKEY        CHAIN     FLOTND                             66
     C   66              DO
     C                   CLEAR                   RLOTND
     C                   MOVEL     'A'           LNSTAT
     C                   MOVEL     IMITEM        LNITEM
     C                   MOVEL     IMSIZE        LNSIZE
     C                   MOVEL     PHY           LNPHYT
     C                   MOVEL     WHREG         LNREGN
     C                   Z-ADD     REVDAT        LNCRDY
     C                   MOVEL     'A'           LNCODE
     C                   Z-ADD     0             LNCUST
     C                   MOVEL     IMLOOK        LNALPH
     C                   MOVEL     IMPCL1        LNPRCL
     C                   Z-ADD     0             LNQTOH
     C                   Z-ADD     0             LNQTOO
     C                   Z-ADD     0             LNQTAL
     C                   Z-ADD     0             LNALTO
     C                   Z-ADD     0             LNALFR
     C                   ENDDO
     C                   ADD       LTDHLD        LNQTOO
     C                   Z-ADD     TIMOD         LNTIME
     C                   Z-ADD     TDATE         LNDTLA
     C                   MOVEL     USERID        LNUSER
     C                   MOVEL     IMLIST        LNLIST
     C   66              WRITE     RLOTND
     C  N66              UPDATE    RLOTND
     C     ENLOTD        ENDSR
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
0055 C********************************************************************@DT@D0
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
