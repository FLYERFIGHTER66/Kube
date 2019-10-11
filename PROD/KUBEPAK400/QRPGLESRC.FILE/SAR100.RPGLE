      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1997
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SAR100
      **COMPANY------------- EFD ENTERPRISES INC.
      **APPLICATION--------- TGMS
      **DESCRIPTION--------- THIS PROGRAM DISPLAYS SALES FOR ALL
      **                     LOCATIONS FOR A SPECIFIC DATE
      **
      *  DATE   INIT   DESCRIPTION
      *
      *
     FSAR100FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSLSDY    IF   E           K DISK
     FFSLSDYYR  IF   E           K DISK
     F                                     RENAME(RSLSDY:SLSDYA)
     FFMWHSE    IF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S              9    DIM(7) CTDATA PERRCD(1)
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         VDATE
      *
      *  MAIN FLOW OF PROGRAM
     C     RSTRTA        TAG
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       111213
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C                   Z-ADD     VDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C   90              SETON                                        10
     C   10              GOTO      NXTA
     C                   EXSR      @DAYWK
      *
     C                   MOVEL     VDATE         MMDD              4 0
     C                   MOVE      VDATE         YY                2 0
     C     YY            IFGT      70
     C                   MOVEL     19            NDATE             2 0
     C                   ENDIF
     C     YY            IFLT      70
     C                   MOVEL     20            NDATE
     C                   ENDIF
     C                   MOVE      MMDD          DTE               6 0
     C                   MOVEL     YY            DTE
     C                   MOVEL     NDATE         SDATE             8 0          19
     C                   MOVE      DTE           SDATE                          19970815
      *
      * SET FSLSDY BACK TO BEGINING OF DATE
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     SDATE         SETLL     FSLSDY
     C     NXTI          TAG
     C     SDATE         READE     FSLSDY                                 90
     C   90              GOTO      DSPL
      *
     C     SYSHFR        CHAIN     FMWHSE                             91
     C   91              SETON                                        20
      *
     C                   Z-ADD     SYTSLS        CURSLS
     C                   ADD       SYTSLS        TOTSLS            9 2
     C                   MOVEL     SYSHDT        YEAR              4 0
     C     YEAR          SUB       1             PRIOR             4 0
      *
     C     PYKEY         KLIST
     C                   KFLD                    SYDYYR
     C                   KFLD                    SYSHFR
     C     PYKEY         SETLL     FSLSDYYR
     C     NXTP          TAG
     C     PYKEY         READE     FSLSDYYR                               92
     C   92              GOTO      NPY
     C                   MOVEL     SYSHDT        PYEAR             4 0
     C                   MOVE      SYSHDT        PDATE             6 0
     C     PDATE         MULT      100.0001      PYDATE
     C     PYEAR         IFNE      PRIOR
     C                   GOTO      NXTP
     C                   ENDIF
     C     NPY           TAG
     C                   Z-ADD     SYTSLS        PRYSLS
     C                   ADD       SYTSLS        TOTPRY            9 2
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   MOVEL     *BLANKS       WHDESC
     C                   Z-ADD     TOTSLS        CURSLS
     C                   Z-ADD     TOTPRY        PRYSLS
     C                   MOVEL     '* Daily '    DESC1            16
     C                   MOVE      'Totals *'    DESC1
     C                   MOVE      DESC1         WHDESC
     C                   SETON                                        88
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C                   Z-ADD     0             TOTSLS
     C                   Z-ADD     0             TOTPRY
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
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
0006 C********************************************************************
0007 C* FIGURES OUT DAY OF THE WEEK THAT ENTERED DATE IS.
0008 C* ##DDD INPUT DATE DDDDD - RESULT FROM @DT@B2
0009 C* #Y OUTPUT INDEX REFLECTING DAY OF WEEK
0011 C********************************************************************
0003 C     @DAYWK        BEGSR
0285 C     ##DDD         DIV       7.0000        #WKS             10 5
0286 C                   MOVE      #WKS          ##R               5 5
0287 C     ##R           MULT(H)   7             #Y                1 0
     C*
     C     #Y            IFGT      7
     C     #Y            SUB       7             #Y
     C                   END
     C*
     C     #Y            IFEQ      0
     C                   Z-ADD     7             #Y
     C                   END
     C*
     C                   MOVEL     MSG(#Y)       DOW               9
     C                   ENDSR
      *
** MESSAGE
 Monday
 Tuesday
Wednesday
Thrusday
 Friday
Saturday
 Sunday
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
