      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDE      RED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXC      EPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *----------------------------------------------------------      ----
      **PROGRAM NAME-------- BIR085
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **DESCRIPTION--------- ENTER/UPDATE ALTERNATE PRICE CODE
      **
      *
      *    DATE----INIT-------DESCRIPTION
      *
     FBIR085FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMALTP    UF A E           K DISK
      *
      **************************************
      ** START OF MAINLINE CODE           **
      **************************************
      *
     C     RSTRT         TAG
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       50
     C  N45              EXSR      CLRIT
     C   45              SETON                                        50
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       113020
     C                   SETOFF                                       2799
     C                   SETOFF                                       404144
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
     C   KM              CALL      'BIR185CL'
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   ADD       1             FIRST             2 0
     C  N50              EXSR      SR100A
     C   99              GOTO      NXTA
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C*          FIRST     IFNE 0
     C                   EXSR      SR100B
     C*  45                GOTO RSTRT
     C*                    END
      *ERROR
     C   99              GOTO      NXTA
      *KF ON SCREEN B
     C   87              GOTO      RSTRT
      *REDISPLAY SCREEN ON R D I
     C     COUNT         IFGT      0
     C                   GOTO      NXTA
     C                   ELSE
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C                   END                                                    COUNT>0
     C     END           TAG
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **************************
      ******     SR100A - TOP OF SCREEN
      **************************
     C     SR100A        BEGSR
      *
     C     VALTP         IFEQ      '? '
     C                   MOVEL     VALTP         ALCODE            1
     C                   CALL      'LKALTP'
     C                   PARM                    ALCODE
     C                   MOVEL     ALCODE        VALTP
     C                   Z-ADD     ALBDTE        VBDTE
     C                   Z-ADD     ALEDTE        VEDTE
     C                   Z-ADD     ALUPRI        VUPRC
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C                   SETOFF                                       212223
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
      *
     C   26              SETON                                        99
     C   26              GOTO      E100A
      *
      ****   PRICE CODE IS A REQUIRED FIELD
      *
     C     VALTP         IFEQ      *BLANKS
     C                   SETON                                        3099
     C   30              GOTO      E100A
     C                   ENDIF
      *
     C     VALTP         CHAIN     FMALTP                             96
      *
     C  N96VACT          IFEQ      'A'
     C                   SETON                                        9930
     C   30              GOTO      E100A
     C                   ENDIF
      *
     C   96VACT          IFNE      'A'
     C                   SETON                                        9930
     C   30              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C                   Z-ADD     ALBDTE        VBDTE
     C                   Z-ADD     ALEDTE        VEDTE
     C                   Z-ADD     ALUPRI        VUPRC
     C                   ENDIF
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     E100A         TAG
      *
     C                   ENDSR
      *
      **************************
      ******     SR100B - BOTTOM OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
     C                   SETON                                        50
     C                   SETOFF                                       993045
     C                   SETOFF                                       606162
      *
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
      ****   DATES REQUIRED
      *
     C     VBDTE         IFEQ      *ZEROS
     C                   SETON                                        6199
     C   61              GOTO      ENDB
     C                   ENDIF
      *
     C                   MOVEL     VBDTE         BMD               4 0
     C                   MOVE      VBDTE         BYR               2 0
     C                   MOVE      VBDTE         BYEAR             4 0
     C                   MOVEL     BMD           RDATE             6 0
     C                   MOVE      BYR           RDATE
     C                   Z-ADD     RDATE         ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        6199
     C   61              GOTO      ENDB
      *
     C     VEDTE         IFEQ      *ZEROS
     C                   SETON                                        6299
     C   62              GOTO      ENDB
     C                   ENDIF
      *
     C                   MOVEL     VEDTE         EMD               4 0
     C                   MOVE      VEDTE         EYR               2 0
     C                   MOVE      VEDTE         EYEAR             4 0
     C                   MOVEL     EMD           SDATE             6 0
     C                   MOVE      EYR           SDATE
     C                   Z-ADD     SDATE         ##MDY             6 0
     C                   EXSR      @DT@A1
     C   90              SETON                                        6299
     C   62              GOTO      ENDB
      *
     C     EYEAR         IFLT      BYEAR
     C                   SETON                                        6199
     C   61              GOTO      ENDB
     C                   ENDIF
      *
     C     BYEAR         IFEQ      BYEAR
     C     BMD           ANDGT     EMD
     C                   SETON                                        6199
     C   61              GOTO      ENDB
     C                   ENDIF
      *
      ****   PRICE REQUIRED
      *
     C     VUPRC         IFEQ      *ZEROS
     C                   SETON                                        6099
     C   60              GOTO      ENDB
     C                   ENDIF
      *
     C     ENDB          TAG
      *
      * WHAT ACTION NEXT IF COUNT>0 SET OF 98 IF 99 SET ON 98
     C     COUNT         IFGT      0
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
     C   99              SETON                                        98
      *
     C                   ENDSR
      *  **********
      *  * OUTREC *
      *  **********
     C     OUTREC        BEGSR
     C                   MOVEL     VALTP         ALCODE
     C                   Z-ADD     VBDTE         ALBDTE
     C                   Z-ADD     VEDTE         ALEDTE
     C                   Z-ADD     VUPRC         ALUPRI
     C   21              WRITE     RMALTP
     C   22              UPDATE    RMALTP
     C   23              DELETE    RMALTP
     C                   ENDSR
      *
      *  **********
      *  * CLRIT  *
      *  **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       VACT
     C                   MOVEL     *BLANKS       VALTP
     C                   Z-ADD     *ZEROS        VUPRC
     C                   ENDSR
      *
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
