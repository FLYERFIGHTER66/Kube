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
      **PROGRAM NAME-------- BIC455
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS ORDER ENTRY/BILLING
      **APPLICATION--------- PRINT CREDIT MEMOS
      **DESCRIPTION--------- THIS PROGRAM PROMPTS FOR REPORT
      **                     OPTIONS AND VALIDATES FIELDS ENTERED.
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      ***FFMCOMP  IF  E           K        DISK
     FFHORCW    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FBIC455FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D @MDY            S              1    DIM(8)
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND
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
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** BEGINING CREDIT NUMBER
     D  LBCRM                  4      9  0
      ** ENDING CREDIT NUMBER
     D  LECRM                 10     15  0
      ** CREDIT MEMO DATE
     D  LDATE                 16     21  0
      ** CREDIT MEMO END DATE
     D  LENDT                 22     27  0
      ** SHIP FROM LOCATION
     D  LSHFR                 28     30
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 31     31
      ** BILL TO CUSTOMER
     D  LBLCS                 32     37  0
      ** SHIP TO CUSTOMER
     D  LSHCS                 38     43  0
      ** LAST INVOICE CREDITED
     D  LBINV                 44     49  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    113
      ** NUMBER OF COPIES
     D  LCOPY                114    115  0
      ** JOBQ
     D  LJOB                 116    116
      ** HOLD PRINT OUTPUT
     D  LHOLD                117    120
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                121    124
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
      *
      *
      * GET USER/DEPT PRINTER
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPINV        VPRTR
     C                   MOVEL     DESHFR        LSHFR
     C                   MOVEL     DESHFR        VSHFR
     C     VPRTR         IFLE      *BLANKS
     C     '999'         CHAIN     FMDEPT                             97
     C                   MOVEL     DEPINV        VPRTR
     C                   ENDIF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     0             CNT               2 0
      *
     C     BEGIN         TAG
     C                   SETOFF                                       101112
     C                   SETOFF                                       151699
     C                   SETOFF                                       201819
     C                   SETON                                        09
     C                   MOVEL     'N'           VRPRNT
     C                   MOVEL     'N'           VJOB
     C                   Z-ADD     0             VBCRM
     C                   Z-ADD     0             VECRM
     C                   Z-ADD     LDACOP        VCO
     C                   Z-ADD     TDATE         VDATE
      *
     C     RSTRTA        TAG
     C   12              SETOFF                                       09
     C                   WRITE     SCRNA
     C                   SETOFF                                       101115
     C                   SETOFF                                       081213
     C                   SETOFF                                       141516
     C                   SETOFF                                       171819
     C                   SETOFF                                       9920
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      BEGIN
      *
     C                   MOVEL     *BLANKS       LCANCL
     C                   MOVE      VRPRNT        LDARPT
     C                   MOVEL     VPRTR         LPRTR
     C                   Z-ADD     VBCRM         LBCRM
     C                   Z-ADD     VECRM         LECRM
     C                   MOVEL     '*INV'        LFORM
     C***                  MOVE VCO       LDACOP
     C                   Z-ADD     VDATE         LDATE
      *
     C   12              GOTO      REPRNT
      *
     C     VRPRNT        IFNE      'Y'                                                      Q
     C     VRPRNT        ANDNE     'N'
     C                   SETON                                        1099
     C   10
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VRPRNT        IFEQ      'N'
     C                   GOTO      RSTRTB
     C                   END
      *
     C                   SETON                                        12
     C   09
     CAN 12              GOTO      RSTRTA
      *
     C     REPRNT        TAG
      *
     C     VBCRM         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        111799
     C   17
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VECRM         IFEQ      *ZEROS                                                   OS
     C                   Z-ADD     VBCRM         VECRM
     C                   Z-ADD     VECRM         LECRM
     C                   END
      *
     C     VBCRM         CHAIN     FHORCW                             97
     C   97              SETON                                        159911
     C   15
     CAN 99              GOTO      RSTRTA
      *
     C     VBCRM         IFGT      VECRM                                                    OS
     C                   SETON                                        1899
     C   18
     CAN 99              GOTO      RSTRTA
     C                   END
      *
     C     ALLOK         TAG
      *
     C     VPRTR         IFEQ      *BLANKS                                                  OS
     C                   SETON                                        0899
     C   08
     CAN 99              GOTO      RSTRTA
     C                   END
      *
     C                   GOTO      END
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       409998
     C                   SETOFF                                       36
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      BEGIN
      *
     C                   MOVEL     '*INV'        LFORM
     C                   Z-ADD     VDATE         LDATE             6 0
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        30
     C   30              GOTO      RSTRTB
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         CDATE             5 0
      *
     C*          VCO       IFEQ *ZEROS                                 K
     C*                    SETON                     32
     C*  32                GOTO RSTRTB
     C*                    ENDIF
      *
     C*          VCO       CHAINFMCOMP              N97
     C*  97                SETON                     32
     C*  32                GOTO RSTRTB
      *
     C     VCO           CHAIN(N)  FMAPER                             97
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        40
     C                   ENDIF
     C                   Z-ADD     ACST01        ##MDY             6 0
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         SDATE             5 0
     C   40              Z-ADD     ACEN12        ##MDY             6 0
     C  N40              Z-ADD     ACEN13        ##MDY             6 0
     C                   EXSR      @DT@A1
     C                   EXSR      @DT@B1
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     CDATE         IFLT      SDATE
     C                   SETON                                        42
     C                   ENDIF
     C     CDATE         IFGT      EDATE
     C                   SETON                                        43
     C                   ENDIF
     C   42
     COR 43              SETON                                        44
      *
     C     VJOB          IFNE      'Y'                                                      Q
     C     VJOB          ANDNE     'N'
     C                   SETON                                        36
     C   36              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VDATE         IFNE      ODATE
     C                   Z-ADD     0             CNT
     C                   ENDIF
      *
     C     CNT           IFEQ      0
     C                   SETON                                        98
     C                   ADD       1             CNT
     C                   Z-ADD     VDATE         ODATE             6 0
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-  . C=1 FOR YY 00-69.@DT@A1
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
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
