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
      **PROGRAM NAME-------- GRS212P
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SEED REQUIREMENTS BY SELECTION SCREEN
      *
      //--------------------------------------------------------------------
      *            CHANGE--DATE-------DESCRIPTION
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * VV01    02/13/19   Vimala V     Include Week as key field to file FCALEX for EndWeek check
      //--------------------------------------------------------------------
      *
      *
     FGRS212FM  CF   E             WORKSTN
     FFLCSTAT   IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
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
     D  CANCEL                 1      1                                         ARC380
      ** TYPE IS REPORT TYPE W=WEEK  S=SEASON
     D  TYPE                   2      2
      ** FROM DATE MDY
     D  FRMDAT                 3      8  0
      ** TO DATE MDY
     D  TODAT                  9     14  0
      ** RESET FLAGS  Y/N
     D  RESET                 15     15
      ** SHOW ALL OR UN-FLAGGED  A/U
     D  SHOWAL                16     16
      ** PRINTER I.D.
     D  PRTID                 17     26
      ** SET FLAGS  Y/N
     D  SETFLG                27     27
      ** FROM DATE YEAR IE 1998
     D  BEGYY                 28     31  0
      ** FROM DATE WEEK #
     D  BEGWW                 32     33  0
      ** TO DATE YEAR IE 1998
     D  ENDYY                 34     37  0
      ** TO DATE WEEK #
     D  ENDWW                 38     39  0
      ** SOW OR SHIP
     D  DORS                  40     40
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   MOVE      *BLANKS       CANCEL
     C                   MOVEL     'S'           DORS
     C                   MOVE      *BLANKS       PRTID
     C                   MOVEL     'P9'          PRTID
     C                   MOVEL     'S'           TYPE
     C                   MOVEL     'N'           RESET
     C                   MOVEL     'N'           SETFLG
     C                   MOVEL     'A'           SHOWAL
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             TODAT
     C                   Z-ADD     0             BEGYY
     C                   Z-ADD     0             ENDYY
     C                   Z-ADD     0             BEGWW
     C                   Z-ADD     0             ENDWW
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
     COR KG              DO
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                         99
      ** CHECK INPUT
      **
      ** CHECK START DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
      ** Keylist to read FCALEX
VV01 C     CALKEY        KLIST
  |  C                   KFLD                    CLCENT
  |  C                   KFLD                    CLYEAR
  |  C                   KFLD                    CLWEEK
VV01 C                   KFLD                    CL#Y
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
VV01 C                   MOVE      BEGWW         CLWEEK

VV01 C*    CALKEY        KLIST
  |  C*                  KFLD                    CLCENT
  |  C*                  KFLD                    CLYEAR
  |  C*                  KFLD                    BEGWW
VV01 C*                  KFLD                    CL#Y

     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   END                                                    FRMDAT > 0
      ** CHECK END DATE
VV01 C*    FRMDAT        IFLE      0
      **
VV01 C     TODAT         IFLE      0
     C     ENDYY         ANDLE     0
     C     ENDWW         ANDLE     0
     C                   SETON                                        30  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     TODAT         IFGT      0
     C                   Z-ADD     TODAT         ##MDY
     C                   EXSR      @DT@A1
     C   90              DO
     C                   SETON                                        3099
     C                   GOTO      NXTA
     C                   ENDDO
     C     TODAT         CHAIN     FCALEN                             92
     C                   MOVEL     CLCENT        ENDYY
     C                   MOVE      CLYEAR        ENDYY
     C                   Z-ADD     CLWEEK        ENDWW
     C                   ELSE                                                    TODAT > 0
     C                   MOVEL     ENDYY         CLCENT
     C                   MOVE      ENDYY         CLYEAR
VV01 C                   MOVE      ENDWW         CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        4099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        TODAT
     C                   END                                                     TODAT > 0
      ** CHECK DET OR SUMMARY
     C     DORS          IFNE      'S'
     C     DORS          ANDNE     'R'
     C     DORS          ANDNE     'B'
     C                   SETON                                        1199
     C                   GOTO      NXTA
     C                   END
      ** CHECK PRINTER I.D.
     C     PRTID         IFLE      *BLANKS
     C                   SETON                                        5099
     C                   GOTO      NXTA
     C                   END
      *** SEE WHERE WE ARE
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
     C                   GOTO      END
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
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
     C     01            CHAIN     FLCSTAT                            10
     C   10              SETOFF                                       10
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
