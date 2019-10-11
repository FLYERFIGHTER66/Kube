    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- ALALOV
      *SYSTEM-------------- TGMS
      *APPLICATION--------- CHECK FALITEM FOR OVER ALLOCATIONS.
      *?                                                              ?
      *? |?  Edit Log                                                ?|
      *? |                                                           ?|
      *? |WJB10/20/05?-Changed to not de-allocate fixers          ?|
      *? |   mm/dd/yy?-                                           ?|
      *?|                                                            |?
      *
     FFALITEM   UF   E           K DISK
     FFIORDISC  UF   E           K DISK
      *
      * DATE ROUTINE ARRAYS
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0
      ****************
     D ThisMonday7     S              7S 0
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
      ****************
      * READ IORDR   *
      ****************
     C     NXTIOR        TAG
     C                   READ      FIORDISC                               90
     C   90              GOTO      END
WJB  C*    OIORD#        IFEQ      999999
WJB  C     OIORD#        IFGE      999990
WJB  C                   GOTO      NXTIOR
WJB  C                   END
     C     OIITYP        IFNE      ' '
     C                   GOTO      NXTIOR
     C                   END
      ** IF DELETED CHECK IF PROCESSED THRU DAILY ORDER POST
     C     OISTAT        IFEQ      'D'
     C     OIQINV        ANDEQ     0
     C                   GOTO      NXTIOR
     C                   END
      ** IF VAUGHN OR EXPRESS SPEC SKIP RECORD   ADDED MICHELS
     C     OICUST        IFEQ      488
     C     OICUST        OREQ      137
     C     OICUST        OREQ      190
     C                   GOTO      NXTIOR
     C                   END
      ** IF SOW DATE GT THIS WEEK SKIP RECORD
     C     OISOW         IFGT      0
WJB  C     OISOW         ANDGT     ThisMonday7
WJB  C*                  Z-ADD     OISOW         ##MDY
WJB  C*                  EXSR      @DT@A1
WJB  C*                  EXSR      @DT@B1
WJB  C*    ##DDD         IFGE      SOWTST
     C                   GOTO      NXTIOR
WJB  C*                  END
     C                   END
      ** IF HERE WE NEED THIS REC.
     C                   EXSR      CHKALO
     C                   GOTO      NXTIOR
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** CHECK IF ALLOCATED *
      ***********************
     C     CHKALO        BEGSR
     C                   Z-ADD     0             ALLO             11 1
     C                   Z-ADD     0             OIQTAL
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
     C                   ADD       AIQTOA        OIQTAL
     C     ALLO          IFGT      NEED
     C     ALLO          SUB       NEED          NEWALO           11 1
     C                   SUB       NEWALO        AIQTOA
     C                   SUB       NEWALO        ALLO
     C                   SUB       NEWALO        OIQTAL
     C     AIQTOA        IFGT      0
     C                   UPDATE    RALITEM
     C                   ELSE
     C                   DELETE    RALITEM
     C                   END
     C                   END
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   UPDATE    RIORDR
     C                   SUB       ALLO          NEED
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET DATES
     C                   Z-ADD     TDATE         ##MDY
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     9             SUB       #Y            #Y1               2 0
     C     ##DDD         ADD       #Y1           SOWTST            5 0
     C                   Eval      ThisMonday7 = $Date7($Monday($Date(0):'SAT'))
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
      ********************************************************************@DT@B1
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
