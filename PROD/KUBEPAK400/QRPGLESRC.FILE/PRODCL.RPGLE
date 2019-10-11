      *--------------------------------------------------------------     PRODCL
      *                                                                   PRODCL
      *** COPYRIGHT <C> BY EFD ENTERPRISES INC.     1998                  PRODCL
      *                                                                   PRODCL
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         PRODCL
      *       E F D ENTERPRISES INC. ALL RIGHTS RESERVED.  THE            PRODCL
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      PRODCL
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         PRODCL
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      PRODCL
      *       BY EXPRESS WRITTEN PERMISSION OF                            PRODCL
      *       EFD ENTERPRISES, INC.     215-643-5352                      PRODCL
      *                                                                   PRODCL
      *--------------------------------------------------------------     PRODCL
      *                                                                   PRODCL
      ****  CHANGE LOG                                                    PRODCL
      *                                                                   PRODCL
      *  INDICATORS USED:                                                 PRODCL
      *  01 - DISPLAY FIRST SCREEN                                        PRODCL
      *  10 - INVALID COMPANY NUMBER                                      PRODCL
      *  11 - INVALID "FROM" DATE                                         PRODCL
      *  12 - INVALID 'TO' DATE                                           PRODCL
      *  14 - INVALID PRODUCT CLASS ON LINE 01                            PRODCL
      *  15 - INVALID PRODUCT CLASS ON LINE02                             PRODCL
      *  16 - INVALID PRODUCT CLASS ON LINE 03                            PRODCL
      *  17 - INVALID PRODUCT CLASS ON LINE 04                            PRODCL
      *  18 - INVALID PRODUCT CLASS ON LINE 5                             PRODCL
      *  19 - INVALID PROCUST CLASS ON LINE 6                             PRODCL
      *  20 - INVALID PRODUCT CLASS ON LINE 7                             PRODCL
      *  21 - INVALID PRODUCT CLASS ON LINE 8                             PRODCL
      *  22 - INVALID PRODUCT CLASS ON LINE 9                             PRODCL
      *  23 - INVALID PRODUCT CLASS ON LINE 10                            PRODCL
      *  24 - INVALID PRODUCT CLASS ON LINE 11                            PRODCL
      *  25 - INVALID PRODUCT CLASS ON LINE 12                            PRODCL
      *  26 - INVALID PRODUCT CLASS ON LINE 13                            PRODCL
      *  27 - INVALID PRODUCT CLASS ON LINE 14                            PRODCL
      *  28 - INVALID PRODUCT CLASS ON LINE 15                            PRODCL
      *  29 - INVALID PRODUCT CLASS ON LINE 16                            PRODCL
      *  30 - INVALID PRODUCT CLASS ON LINE 17                            PRODCL
      *  31 - INVALID PRODUCT CLASS ON LINE 18                            PRODCL
      *  32 - INVALID PRODUCT CLASS ON LINE 19                            PRODCL
      *  33 - INVALID PRODUCT CLASS ON LINE 20                            PRODCL
      *  35 - PRODUCT CLASS NOT IN MCPTS                                  PRODCL
      *  50 - FROM DAY IS > 'TO' DAY                                      PRODCL
      *                                                                   PRODCL
      *************************************************                   PRODCL
      *                                                                   PRODCL
     FPRODCLFM  CF   E             WORKSTN                                      PRODCL
     FFMPRCL    IF   E           K DISK
     D DES             S             30    DIM(20)                                               PRO
     D @MDY            S              1    DIM(8)                                                PRO
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  PC                     1     40                                         PRODCL
     D                                     DIM(20)                                               PRO
     D  CO#                   41     42  0
     D  FROM                  43     49  0
     D  TO                    50     56  0
     D  JOBQ                  57     57
     D  LCANCL                58     58
     D  LPRTR                100    109
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
     ISCRNA
     I              PC1                         PC(01)
     I              PC2                         PC(02)
     I              PC3                         PC(03)
     I              PC4                         PC(04)
     I              PC5                         PC(05)
     I              PC6                         PC(06)
     I              PC7                         PC(07)
     I              PC8                         PC(08)
     I              PC9                         PC(09)
     I              PC10                        PC(10)
     I              PC11                        PC(11)
     I              PC12                        PC(12)
     I              PC13                        PC(13)
     I              PC14                        PC(14)
     I              PC15                        PC(15)
     I              PC16                        PC(16)
     I              PC17                        PC(17)
     I              PC18                        PC(18)
     I              PC19                        PC(19)
     I              PC20                        PC(20)
     I              PC1DES                      DES(01)
     I              PC2DES                      DES(02)
     I              PC3DES                      DES(03)
     I              PC4DES                      DES(04)
     I              PC5DES                      DES(05)
     I              PC6DES                      DES(06)
     I              PC7DES                      DES(07)
     I              PC8DES                      DES(08)
     I              PC9DES                      DES(09)
     I              PC10DS                      DES(10)
     I              PC11DS                      DES(11)
     I              PC12DS                      DES(12)
     I              PC13DS                      DES(13)
     I              PC14DS                      DES(14)
     I              PC15DS                      DES(15)
     I              PC16DS                      DES(16)
     I              PC17DS                      DES(17)
     I              PC18DS                      DES(18)
     I              PC19DS                      DES(19)
     I              PC20DS                      DES(20)
      *                                                                   PRODCL
      ***************                                                     PRODCL
      * START HERE  *                                                     PRODCL
      ***************                                                     PRODCL
     C     RSTART        TAG
     C                   CLEAR                   SCRNA
     C                   CALL      '#DFTPRT'
     C                   PARM                    USERID
     C                   PARM                    PROGID
     C                   PARM                    PRT
     C                   MOVE      '0'           *IN
     C                   MOVE      01            CO#                                           PRODC
     C                   MOVE      TDATE         TODATE                                        PRODC
     C                   MOVE      TDATE         FRMDTE                                        PRODC
     C                   MOVE      'N'           JOBQ
     C                   MOVE      *BLANKS       LCANCL
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C   11              DO
     C                   CALL      '#CHGPRT'
     C                   PARM                    USERID
     C                   PARM                    PROGID
     C                   PARM                    PRT
     C                   ENDDO                                                  KC/KG DO
      ** VERIFY FIELDS
     C                   MOVE      '0'           *IN
      * CHECKING FOR VALID FROM & TO DATES                                PRODCL
      *                                                                   PRODCL
     C                   MOVE      FRMDTE        ##MDY                                         PRODC
     C                   EXSR      @DT@A1                                                      PRODC
     C   90              SETON                                        9911                     PRODC
     C   99              GOTO      NXTA                                                        PRODC
      *                                                                   PRODCL
     C                   MOVE      ##CYMD        FROM                                          PRODC
      *                                                                   PRODCL
     C                   MOVE      TODATE        ##MDY                                         PRODC
     C                   EXSR      @DT@A1                                                      PRODC
     C   90              SETON                                        9912                     PRODC
     C   99              GOTO      NXTA                                                        PRODC
      *                                                                   PRODCL
     C                   MOVE      ##CYMD        TO                                            PRODC
      *                                                                   PRODCL
      ******************************************                          PRODCL
      * COMPARING FROM-TO DATES - FROM DATE MUST BE LOWER                 PRODCL
      **********************************************                      PRODCL
      *                                                                   PRODCL
     C     FROM          COMP      TO                                 44                       PRODC
     C   44              SETON                                        9911                     PRODC
     C   99              GOTO      NXTA                                                        PRODC
      *                                                                   PRODCL
      *** CHECK JOBQ RESPONSE
     C     JOBQ          IFNE      'Y'
     C     JOBQ          ANDNE     'N'
     C                   SETON                                        9959
     C                   GOTO      NXTA
     C                   END
      *                                                                   PRODCL
      ******************************************                          PRODCL
      * CHECKING FOR VALID PRODUCT CLASS                                  PRODCL
      ******************************************                          PRODCL
      *                                                                   PRODCL
     C                   Z-ADD     01            XX                2 0                         PRODC
     C     RDAGN         TAG                                                                   PRODC
     C                   MOVEL     02            KEY2              4                           PRODC
     C     PC(XX)        COMP      *BLANKS                              6060                   PRODC
     C   60              GOTO      BYPASS                                                      PRODC
     C                   MOVEL     PC(XX)        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       PC(XX)
     C                   MOVEL     PCPRCL        PC(XX)
     C                   ENDIF
     C     PC(XX)        CHAIN     FMPRCL                             35                       PRODC
     C   35XX            COMP      01                                     14                   PRODC
     C   35XX            COMP      02                                     15                   PRODC
     C   35XX            COMP      03                                     16                   PRODC
     C   35XX            COMP      04                                     17                   PRODC
     C   35XX            COMP      05                                     18                   PRODC
     C   35XX            COMP      06                                     19                   PRODC
     C   35XX            COMP      07                                     20                   PRODC
     C   35XX            COMP      08                                     21                   PRODC
     C   35XX            COMP      09                                     22                   PRODC
     C   35XX            COMP      10                                     23                   PRODC
     C   35XX            COMP      11                                     24                   PRODC
     C   35XX            COMP      12                                     25                   PRODC
     C   35XX            COMP      13                                     26                   PRODC
     C   35XX            COMP      14                                     27                   PRODC
     C   35XX            COMP      15                                     28                   PRODC
     C   35XX            COMP      16                                     29                   PRODC
     C   35XX            COMP      17                                     30                   PRODC
     C   35XX            COMP      18                                     31                   PRODC
     C   35XX            COMP      19                                     32                   PRODC
     C   35XX            COMP      19                                     33                   PRODC
     C   35XX            COMP      20                                     34                   PRODC
     C   35              SETON                                        9936                     PRODC
     C   99              GOTO      NXTA                                                        PRODC
      *                                                                   PRODCL
     C  N99              MOVE      PCDESC        DES(XX)                                       PRODC
     C     BYPASS        TAG                                                                   PRODC
     C  N99XX            IFLT      20                                                          PRODC
     C                   ADD       1             XX                                            PRODC
     C                   GOTO      RDAGN                                                       PRODC
     C                   END                                                                   PRODC
     C  NKE              GOTO      NXTA
      *                                                                   PRODCL
     C     END           TAG                                                                   PRODC
     C                   MOVE      PRT           LPRTR
     C                   SETON                                        LR                       PRODC
      *                                                                   PRODCL
      *                                                                   PRODCL
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ******************
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
