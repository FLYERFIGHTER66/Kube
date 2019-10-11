    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1998
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
      **PROGRAM NAME-------- NSLCHG
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CHANGE ORDER LOCATION IN HORDR
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/15/01 EFD ALLOW ENTRY BY MORE THAN 1 USER.
      *  5/06/04 WJB INCLUDE ACCT 1521.
      *
     FNSLCHGFM  CF   E             WORKSTN
     F                                     SFILE(LOCSFL:RECNO)
     FFMCUST    IF   E           K DISK
     FFTRSCHDCO IF   E           K DISK
     FFHORDRCD  IF   E           K DISK
     F                                     RENAME(RHORDR:HORDRI)
     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFMANUALD  IF   E           K DISK
     FFPPO      UF A E           K DISK
     FNPLGSCTL  UF A E           K DISK
      *
      * DATE ROUTINE ARRAY
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)                               @DT
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

     D LastTruck       S                   Like(TRTRK#)
     D Field           S              1S 0

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             SHPWK
     C                   SETOFF                                       101516
     C                   SETOFF                                       20
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
      * CHECK DATE
     C                   SETOFF                                       101516
     C                   SETOFF                                       20
     C     SHPWK         IFLE      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     SHPWK         ##MDY
     C                   EXSR      @DT@A1
     C   90              DO
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDDO                                                  90 DO
     C                   Z-ADD     ##CYMD        SHPWKY            7 0
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C*    #Y            IFNE      1
     C*                  SETON                                        1015
     C*                  GOTO      NXTA
     C*                  END
     C     LX1521        IFNE      'Y'
     C     LX1521        ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
      ** IF HERE DATE OK
     C     RSTRTB        TAG
     C                   SETOFF                                       98
     C                   EXSR      BLDSFL
     C     LSTREC        IFLE      0
     C                   SETON                                        1016
     C                   GOTO      NXTA
     C                   END
     C     NXTB          TAG
     C   99              SETOFF                                       98
     C                   EXFMT     LOCCTL
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTB
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDDO
     C  NKA              GOTO      NXTB
      ** IF HERE PUT OUT RECORDS
     C                   EXSR      PUTSFL
      ** UPDATE CONTROL FILE
     C                   Z-ADD     0             PSCOMP
     C     PSCOMP        CHAIN     NPLGSCTL                           57
     C   57              DO
     C                   CLEAR                   RPLGSCTL
     C                   MOVEL     'A'           PSSTAT
     C                   Z-ADD     0             PSCOMP
     C                   ENDDO
     C     SHPWKY        IFGT      PSLOCD
     C                   Z-ADD     SHPWKY        PSLOCD
     C                   END
     C                   Z-ADD     TIMOD         PSTIME
     C                   Z-ADD     TDATE         PSDTLA
     C                   MOVEL     USERID        PSUSER
     C   57              WRITE     RPLGSCTL
     C  N57              UPDATE    RPLGSCTL
     C                   GOTO      RSTART
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        8071
     C                   WRITE     LOCCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C     DateMast      KList
     C                   KFld                    SHPWKY
     C                   KFld                    SMASTER
     C                   If        SMASTER = *Zero
     C     SHPWKY        SETLL     FHORDRCD
     C                   Else
     C     DateMast      SETLL     FMANUALD
     C                   EndIf
     C     NXTBLD        TAG
     C                   If        SMASTER = *Zero
     C     SHPWKY        READE(N)  FHORDRCD                               90
     C   90              GOTO      ENDBLD
     C                   Else
     C     DateMast      READE     FMANUALD                               90
     C   90              GOTO      ENDBLD
     C     MNORD#        Chain(N)  FHORDR                             90
     C   90              GOTO      NXTBLD
     C                   EndIf
     C     OHSTAT        IFNE      'A'
WJB  C     OHCUST        OREQ      1521
WJB  C     LX1521        ANDEQ     'Y'
     C     OHCUST        OREQ      2730
     C                   GOTO      NXTBLD
     C                   ENDIF
     C     OHCUST        CHAIN     FMCUST                             91
     C     CMARCU        IFEQ      1098
     C                   GOTO      NXTBLD
     C                   END
      ** GET LOCATIONS
     C     OHORD#        CHAIN(N)  FPPO                               91
     C   91              DO
     C                   MOVE      *BLANKS       LOCWC
     C                   MOVE      *BLANKS       LOCWF
     C                   ENDDO
     C  N91              DO
     C                   MOVEL     POLOWC        LOCWC
     C                   MOVEL     POLOWF        LOCWF
     C                   ENDDO
      ** OUTPUT RECORD
     C
     C     TruckKey      KList
     C                   KFld                    SHPWKY
     C                   KFld                    OHCUST
     C                   KFld                    OHORD#

     C                   ADD       1             RECNO
     C                   Z-ADD     OHORD#        ORD
     C                   MOVEL     OHLOC         LOC
     C                   MOVEL     OHLOC         OLOC
     C                   MOVEL     LOCWC         OLOCWC
     C                   MOVEL     LOCWF         OLOCWF

     C                   Eval      LastTruck = *Blanks
     C                   Eval      Field = 1
     C     TruckKey      SetLL     FTRSCHDCO
     C     TruckKey      ReadE     FTRSCHDCO
     C                   DoW       not %EOF(FTRSCHDCO) and Field < 4
     C                   Call      'TRKSTOP#'
     C                   Parm                    TRTRK#
     C                   Parm                    SHPWKY
     C                   Parm                    TRSTOP
     C                   Parm                    STOP#             2
     C                   Select
     C                   When      TRTRK# = LastTruck
      *                  Do Nothing
     C                   When      Field = 1
     C                   Eval      LOC = %trim(TRTRK#) + '-' + STOP#
     C                   Eval      Field = 2
     C                   When      Field = 2
     C                   Eval      LOCWC = %trim(TRTRK#) + '-' + STOP#
     C                   Eval      Field = 3
     C                   When      Field = 3
     C                   Eval      LOCWF = %trim(TRTRK#) + '-' + STOP#
     C                   Eval      Field = 4
     C                   EndSl
     C                   Eval      LastTruck = TRTRK#
     C     TruckKey      ReadE     FTRSCHDCO
     C                   EndDo
     C                   WRITE     LOCSFL
     C                   GOTO      NXTBLD
      ** END SUB FILE
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   Z-ADD     0             ORD
     C                   MOVE      *BLANKS       LOC
     C                   MOVEL     MSG(1)        OHNAME
     C                   ADD       1             RECNO
     C                   WRITE     LOCSFL
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
      ** RIGHT NOW THERE IS NO CHECKING DONE
     C                   Z-ADD     0             RECNO
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     LOCSFL                             90
     C   90              GOTO      NXTPUT
      ** IF NO CHANGE DONOT UPDATE. IN CASE UPDATED BY OTHER USER
     C     LOC           IFEQ      OLOC
     C     LOCWC         ANDEQ     OLOCWC
     C     LOCWF         ANDEQ     OLOCWF
     C                   GOTO      NXTPUT
     C                   ENDIF
     C     ORD           CHAIN     FHORDR                             91
     C     ORD           CHAIN     FPPO                               92
     C                   MOVEL     LOC           OHLOC
     C  N91              UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'NSLCHG'
     C                   Eval      HSTTIME    = $Timestamp()
     C  N91              Write     RHORDRHIST
     C   92              DO
     C                   CLEAR                   RPPO
     C                   Z-ADD     ORD           POORD#
     C                   ENDDO
     C                   MOVEL     LOCWC         POLOWC
     C                   MOVEL     LOCWF         POLOWF
     C   92              WRITE     RPPO
     C  N92              UPDATE    RPPO
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
WJB  C                   MOVE      'Y'           LX1521
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
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
** MESSAGE ARRAY
    **** ENO OF DATA ***                         1
