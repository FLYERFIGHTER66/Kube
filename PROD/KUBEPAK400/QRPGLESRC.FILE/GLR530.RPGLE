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
      **PROGRAM NAME-------- GLR530
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- EFDGL
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT FORMATED GL TRIAL BALANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFGLFMH    IF   E           K DISK
     FFGLFMI    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FGLR530    O    F  120        PRINTER OFLIND(*INOF)
      *
      * GLBAL ARRAY
     D CR              S             11  2 DIM(13)
      * TOTAL AND PRINT ARRAYS
     D PRT             S             11  2 DIM(4)                               PRINT LINE
     D TL0             S             11  2 DIM(4)                               TOT LEVEL 0
     D TL1             S             11  2 DIM(4)                               TOT LEVEL 1
     D TL2             S             11  2 DIM(4)                               TOT LEVEL 2
     D TL3             S             11  2 DIM(4)                               TOT LEVEL 3
     D TL4             S             11  2 DIM(4)                               TOT LEVEL 4
     D TL5             S             11  2 DIM(4)                               TOT LEVEL 5
     D TL6             S             11  2 DIM(4)                               TOT LEVEL 6
     D TL7             S             11  2 DIM(4)                               TOT LEVEL 7
     D TL8             S             11  2 DIM(4)                               TOT LEVEL 8
     D TL9             S             11  2 DIM(4)                               TOT LEVEL 9
     D TLT             S             11  2 DIM(4)                               TOT FINAL
      *
      *
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
     D  LACTP                  3      4  0
     D  LBEGDT                 5     10  0                                      GLR360
     D  LENDDT                11     16  0                                      GLR360
     D  FORMAT                17     24                                         GLR360
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     IRGLBAL
      *
     I              GLT01                       CR(1)
     I              GLT02                       CR(2)
     I              GLT03                       CR(3)
     I              GLT04                       CR(4)
     I              GLT05                       CR(5)
     I              GLT06                       CR(6)
     I              GLT07                       CR(7)
     I              GLT08                       CR(8)
     I              GLT09                       CR(9)
     I              GLT10                       CR(10)
     I              GLT11                       CR(11)
     I              GLT12                       CR(12)
     I              GLT13                       CR(13)
      ***********************
      ** START HERE        **
      ***********************
     C     HEDKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    FORMAT
     C     HEDKEY        SETLL     FGLFMH
     C     NXT           TAG
     C     HEDKEY        READE     FGLFMH                                 90
     C   90              GOTO      END
      ** CHECK FOR REVERSE SIGN
     C     GHRVSN        IFEQ      'Y'
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
      ** GOTO SELECTED TYPE SUB ROUTINE
     C     GHLVBR        IFEQ      'H'
     C                   EXSR      TOP
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '0'
     C                   EXSR      SIDE
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '1'
     C                   EXSR      DETAIL
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '2'
     C                   EXSR      LV2
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '3'
     C                   EXSR      LV3
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '4'
     C                   EXSR      LV4
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '5'
     C                   EXSR      LV5
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '6'
     C                   EXSR      LV6
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '7'
     C                   EXSR      LV7
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '8'
     C                   EXSR      LV8
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      '9'
     C                   EXSR      LV9
     C                   GOTO      NXT
     C                   END
     C     GHLVBR        IFEQ      'T'
     C                   EXSR      TOT
     C                   GOTO      NXT
     C                   END
      ** END OF JOB
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** TOP OF REPORT     **
      ***********************
     C     TOP           BEGSR
     C**                   SETON                     OF
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   EXCEPT    HD1
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   MOVEL     'Y'           NEDHDG            1
     C                   ENDSR
      ***********************
      ** SIDE OFF REPORT   **
      ***********************
     C     SIDE          BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C     NEDHDG        IFEQ      'Y'
     C                   EXCEPT    HDG
     C                   MOVEL     'N'           NEDHDG
     C                   END
     C                   ENDDO                                                   OF  DO
     C     NEDHDG        IFEQ      'Y'
     C                   EXCEPT    HDG
     C                   MOVEL     'N'           NEDHDG
     C                   END
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   EXCEPT    SIDE1
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** DETAIL LINES      **
      ***********************
     C     DETAIL        BEGSR
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   EXCEPT    HDG
     C                   MOVEL     'N'           NEDHDG
     C                   ENDDO                                                   OF  DO
     C     NEDHDG        IFEQ      'Y'
     C                   EXCEPT    HDG
     C                   MOVEL     'N'           NEDHDG
     C                   END
     C                   EXCEPT    DETH
      ** NOW GET THE LINES
     C     IKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    FORMAT
     C                   KFLD                    GHGRUP
     C     IKEY          SETLL     FGLFMI
     C                   Z-ADD     0             TL0
     C     NXTI          TAG
     C     IKEY          READE     FGLFMI                                 91
     C   91              GOTO      ENDI
     C     BALKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GIGLAC
     C     BALKEY        CHAIN     FMGLCH                             92
     C  N92BALKEY        CHAIN     FGLBAL                             92
     C   90              GOTO      NXTI
     C                   Z-ADD     0             PRT
     C                   Z-ADD     GLBALT        PRT(1)
     C                   Z-ADD     CR(P)         PRT(2)
     C                   Z-ADD     P             X                 2 0
     C     X             DOUEQ     0
     C                   ADD       CR(X)         PRT(3)
     C                   SUB       1             X
     C                   ENDDO                                                  X=0  DO
     C     PRT(1)        ADD       PRT(3)        PRT(4)
     C                   ADD       PRT           TL0
     C   55              Z-SUB     PRT           PRT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   EXCEPT    HDG
     C                   ENDDO                                                   OF  DO
     C                   EXCEPT    DETL
     C                   GOTO      NXTI
      ** END PRINT TOTALS
     C     ENDI          TAG
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   EXCEPT    HDG
     C                   ENDDO                                                   OF  DO
     C                   ADD       TL0           TL1
     C  N55              Z-ADD     TL0           PRT
     C   55              Z-SUB     TL0           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 2 TOTAL     **
      ***********************
     C     LV2           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C  N55              Z-ADD     TL1           PRT
     C   55              Z-SUB     TL1           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 3 TOTAL     **
      ***********************
     C     LV3           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C  N55              Z-ADD     TL2           PRT
     C   55              Z-SUB     TL2           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 4 TOTAL     **
      ***********************
     C     LV4           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C                   ADD       TL3           TL4
     C  N55              Z-ADD     TL3           PRT
     C   55              Z-SUB     TL3           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C                   Z-ADD     0             TL3
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 5 TOTAL     **
      ***********************
     C     LV5           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C                   ADD       TL3           TL4
     C                   ADD       TL4           TL5
     C  N55              Z-ADD     TL4           PRT
     C   55              Z-SUB     TL4           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C                   Z-ADD     0             TL3
     C                   Z-ADD     0             TL4
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 6 TOTAL     **
      ***********************
     C     LV6           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C                   ADD       TL3           TL4
     C                   ADD       TL4           TL5
     C                   ADD       TL5           TL6
     C  N55              Z-ADD     TL5           PRT
     C   55              Z-SUB     TL5           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C                   Z-ADD     0             TL3
     C                   Z-ADD     0             TL4
     C                   Z-ADD     0             TL5
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 7 TOTAL     **
      ***********************
     C     LV7           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C                   ADD       TL3           TL4
     C                   ADD       TL4           TL5
     C                   ADD       TL5           TL6
     C                   ADD       TL6           TL7
     C  N55              Z-ADD     TL6           PRT
     C   55              Z-SUB     TL6           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C                   Z-ADD     0             TL3
     C                   Z-ADD     0             TL4
     C                   Z-ADD     0             TL5
     C                   Z-ADD     0             TL6
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 8 TOTAL     **
      ***********************
     C     LV8           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C                   ADD       TL3           TL4
     C                   ADD       TL4           TL5
     C                   ADD       TL5           TL6
     C                   ADD       TL6           TL7
     C                   ADD       TL7           TL8
     C  N55              Z-ADD     TL7           PRT
     C   55              Z-SUB     TL7           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C                   Z-ADD     0             TL3
     C                   Z-ADD     0             TL4
     C                   Z-ADD     0             TL5
     C                   Z-ADD     0             TL6
     C                   Z-ADD     0             TL7
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** LEVEL 9 TOTAL     **
      ***********************
     C     LV9           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C                   ADD       TL3           TL4
     C                   ADD       TL4           TL5
     C                   ADD       TL5           TL6
     C                   ADD       TL6           TL7
     C                   ADD       TL7           TL8
     C                   ADD       TL8           TL9
     C  N55              Z-ADD     TL8           PRT
     C   55              Z-SUB     TL8           PRT
     C                   EXCEPT    TDASH
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C                   Z-ADD     0             TL3
     C                   Z-ADD     0             TL4
     C                   Z-ADD     0             TL5
     C                   Z-ADD     0             TL6
     C                   Z-ADD     0             TL7
     C                   Z-ADD     0             TL8
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** FINAL   TOTAL     **
      ***********************
     C     TOT           BEGSR
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO                                                   OF  DO
     C     GHSPBF        IFGT      0
     C                   Z-ADD     GHSPBF        NO
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ADD       TL1           TL2
     C                   ADD       TL2           TL3
     C                   ADD       TL3           TL4
     C                   ADD       TL4           TL5
     C                   ADD       TL5           TL6
     C                   ADD       TL6           TL7
     C                   ADD       TL7           TL8
     C                   ADD       TL8           TL9
     C  N55              Z-ADD     TL9           PRT
     C   55              Z-SUB     TL9           PRT
     C                   EXCEPT    TEQUAL
     C                   EXCEPT    TL
     C                   Z-ADD     0             TL1
     C                   Z-ADD     0             TL2
     C                   Z-ADD     0             TL3
     C                   Z-ADD     0             TL4
     C                   Z-ADD     0             TL5
     C                   Z-ADD     0             TL6
     C                   Z-ADD     0             TL7
     C                   Z-ADD     0             TL8
     C                   Z-ADD     0             TL9
     C     GHSPAF        IFGT      0
     C                   Z-ADD     GHSPAF        NO                5 0
     C                   EXSR      SPACE
     C                   ENDIF
     C                   ENDSR
      ***********************
      ** SPACE  ROUTINE    **
      ***********************
     C     SPACE         BEGSR
      ** NO CONTAINS THE NUMBER OF SPACES
     C     NO            DOUEQ     0
     C                   EXCEPT    SPACE1
     C                   SUB       1             NO
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCO           CHAIN     FMCORG                             88
     C                   SETON                                        OF
     C                   Z-ADD     LACTP         P                 2 0
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OGLR530    E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           57 'Formatted Trial Balance'
     O                                           68 'By Account'
     O                                           76 'Format:'
     O                       FORMAT              85
     O                       TIMOD              120 '  :  :  '
     O          E            HEAD           1
     O                                           52 'For Period:'
     O                       LACTP               55
     O                       LBEGDT        Y     66
     O                                           68 '-'
     O                       LENDDT        Y     77
     O          E            HD1         0  0
     O                       GHDESC              80
     O          E            HDG            1
     O                                           68 'Prior'
     O          E            HDG            1
     O                                            8 'G/L'
     O                                           69 'Year End'
     O                                           84 'Current'
     O                                           97 'YTD'
     O                                          114 'Current'
     O          E            HDG            0
     O                                           10 'Account'
     O                                           30 'Description'
     O                                           69 'Balance'
     O                                           84 'Period'
     O                                           99 'Balance'
     O                                          114 'Balance'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            SIDE1       0  0
     O                       GHDESC              40
     O          E            DETH        0  1
     O                       GHDESC              40
     O          E            DETL        0  1
     O                       GIGLAC              10 '    -    '
     O                       GCDESC              41
     O                       PRT(1)        J     69
     O                       PRT(2)        J     84
     O                       PRT(3)        J     99
     O                       PRT(4)        J    114
     O          E            TDASH       0  1
     O                                           68 '_________'
     O                                           83 '_________'
     O                                           98 '_________'
     O                                          113 '_________'
     O          E            TEQUAL      0  1
     O                                           68 '========='
     O                                           83 '========='
     O                                           98 '========='
     O                                          113 '========='
     O          E            TL          0  0
     O                       GHDESC              40
     O                       PRT(1)        J     69
     O                       PRT(2)        J     84
     O                       PRT(3)        J     99
     O                       PRT(4)        J    114
     O          E            SPACE1         1
