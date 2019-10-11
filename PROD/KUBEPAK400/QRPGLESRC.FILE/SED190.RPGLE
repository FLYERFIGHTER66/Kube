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
      **PROGRAM NAME-------- SED190
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SOW LINE REQUIREMENTS UPDATE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSED190FM  CF   E             WORKSTN
     F                                     SFILE(SOWSFL:RECNO)
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFMINVT    IF   E           K DISK
     FFSEDREQ   UF   E           K DISK
     FFSEDREQW  IF   E           K DISK
     F                                     RENAME(RSEDREQ:SEDREQ)
      * DATE ARRAYS
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
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
     I**                                      1   1 CANCEL                ARC380
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   MOVEL     'A'           SHOWAL
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             TODAT             6 0
     C                   Z-ADD     0             BEGYY
     C                   Z-ADD     0             BEGWW
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                         99
      ** CHECK INPUT
      **
      ** CHECK DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C                   Z-ADD     FRMDAT        ##MDY
     C                   EXSR      @DT@A1
     C   90              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
     C     FRMDAT        CHAIN     FCALEN                             92
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   END                                                    FRMDAT > 0
      ** CHECK WHAT TO SHOW
     C     SHOWAL        IFNE      'A'
     C     SHOWAL        ANDNE     'C'
     C                   SETON                                        2599
     C                   GOTO      NXTA
     C                   END
      ** GET DATES
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C                   Z-ADD     CLDATE        TODAT
      *** OUTPUT SUB FILE
     C                   EXSR      BLDSFL
     C     NXTB          TAG
     C                   EXFMT     SOWCTL
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                          80
     C                   WRITE     SOWCTL
     C                   SETOFF                                         80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVEL     BEGYY         SRSOWW
     C                   MOVE      BEGWW         SRSOWW
     C                   MOVE      *BLANKS       SRALPH
     C     REQKEY        KLIST
     C                   KFLD                    SRSOWW
     C                   KFLD                    SRALPH
     C     REQKEY        SETLL     FSEDREQW
     C     NXTBLD        TAG
     C     SRSOWW        READE     SEDREQ                                 90
     C   90              GOTO      ENDBLD
      ** CHECK IF CHANGED
     C     SHOWAL        IFEQ      'C'
     C     SRCHG1        ANDNE     'Y'
     C     SRCHG2        ANDNE     'Y'
     C     SRCHG3        ANDNE     'Y'
     C     SRCHG4        ANDNE     'Y'
     C                   GOTO      NXTBLD
     C                   ENDIF
      ** BUILD RECORD
     C     ITMKEY        KLIST
     C                   KFLD                    SRITEM
     C                   KFLD                    SRSIZE
     C     ITMKEY        CHAIN     FMINVT                             80
     C     SRCHG1        COMP      'Y'                                    41
     C     SRCHG2        COMP      'Y'                                    42
     C     SRCHG3        COMP      'Y'                                    43
     C     SRCHG4        COMP      'Y'                                    44
     C                   Z-ADD     SRNFX1        NEWFX1               51
     C                   Z-ADD     SRNFX2        NEWFX2               52
     C                   Z-ADD     SRNFX3        NEWFX3               53
     C                   Z-ADD     SRNFX4        NEWFX4               54
     C                   Z-ADD     SRTRY1        TRY1
     C                   Z-ADD     SRTRY2        TRY2
     C                   Z-ADD     SRTRY3        TRY3
     C                   Z-ADD     SRTRY4        TRY4
     C                   Z-ADD     SRFIX1        FIX1
     C                   Z-ADD     SRFIX2        FIX2
     C                   Z-ADD     SRFIX3        FIX3
     C                   Z-ADD     SRFIX4        FIX4
     C                   Z-ADD     SRFIX4        FIX4
     C                   ADD       1             RECNO
     C                   WRITE     SOWSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        ENDSR
      *
      ***********************
      ** OUTPUT TO FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     RECNO         OREC              5 0
     C                   Z-ADD     1             RECNO
     C     REQKY1        KLIST
     C                   KFLD                    SRITEM
     C                   KFLD                    SRSIZE
     C                   KFLD                    SRSOWW
     C     NXTPUT        TAG
     C     RECNO         CHAIN     SOWSFL                             90
     C   90              DO
     C                   ADD       1             RECNO
     C     RECNO         IFLE      OREC
     C                   GOTO      NXTPUT
     C                   ELSE
     C                   GOTO      ENDPUT
     C                   END
     C                   ENDDO
     C     REQKY1        CHAIN     FSEDREQ                            91
     C  N91              DO
     C                   MOVE      'N'           SRCHG1
     C                   Z-ADD     NEWFX1        SRNFX1
     C                   MOVE      'N'           SRCHG2
     C                   Z-ADD     NEWFX2        SRNFX2
     C                   MOVE      'N'           SRCHG3
     C                   Z-ADD     NEWFX3        SRNFX3
     C                   MOVE      'N'           SRCHG4
     C                   Z-ADD     NEWFX4        SRNFX4
     C                   UPDATE    RSEDREQ
     C                   ENDDO
     C                   ADD       1             RECNO
     C     RECNO         IFLE      OREC
     C                   GOTO      NXTPUT
     C                   END
     C     ENDPUT        ENDSR
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
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
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
