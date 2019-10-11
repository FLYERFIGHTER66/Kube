      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-        GLR522
      **COMPANY-             EFD ENTERPRISES, INC.
      **SYSTEM-              EFDGL
      **APPLICATION-         GENERAL LEDGER INCOME STATEMENT
      **DESCRIPTION-         THIS PROGRAM PRINTS AN INCOME STATEMENT, IN
      **                     A FREE FORMAT.  THE USER SETS UP THE FORMAT
      **                     FILE IN PROGRAM GLR050  (SPREAD SGEET)
      ** CHANGE LOG
      *
      * MAIN INDICATORS
      *  61=CURRENT YEAR DOLLARS
      *  62=LAST YEAR DOLLARS
      *  63=BUDGET DOLLARS
      *
      *
     FFGLFMH    IF   E           K DISK
     FFGLFMI    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FFGLBUD    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR522    O    F  198        PRINTER OFLIND(*INOF)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              HEADING DESC
      * GLBAL ARRAY
     D CR              S             11  2 DIM(13)                              THIS YEAR
     D LR              S             11  2 DIM(13)                              LAST YEAR
      * GLBUD ARRAY
     D BUD             S             11  2 DIM(13)                              BUDG THIS YEAR
      * WORK ARRAY
     D WK              S             11  2 DIM(13)                              WORK ARRAY
      * MAPER ARRAY
     D PST             S              6  0 DIM(13)
     D PED             S              6  0 DIM(13)
      * TOTAL AND PRINT ARRAYS
     D PRT             S              9  0 DIM(14)                              PRINT LINE
     D TL0             S              9  0 DIM(14)                              TOT LEVEL 0
     D TL1             S              9  0 DIM(14)                              TOT LEVEL 1
     D TL2             S              9  0 DIM(14)                              TOT LEVEL 2
     D TL3             S              9  0 DIM(14)                              TOT LEVEL 3
     D TL4             S              9  0 DIM(14)                              TOT LEVEL 4
     D TL5             S              9  0 DIM(14)                              TOT LEVEL 5
     D TL6             S              9  0 DIM(14)                              TOT LEVEL 6
     D TL7             S              9  0 DIM(14)                              TOT LEVEL 7
     D TL8             S              9  0 DIM(14)                              TOT LEVEL 8
     D TL9             S              9  0 DIM(14)                              TOT LEVEL 9
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
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
     D  FORMAT                 5     12
     D  LBEGDT                13     18  0
     D  LENDDT                19     24  0
     D  OPTION                25     25  0
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
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
      *
     I              GLL01                       LR(1)
     I              GLL02                       LR(2)
     I              GLL03                       LR(3)
     I              GLL04                       LR(4)
     I              GLL05                       LR(5)
     I              GLL06                       LR(6)
     I              GLL07                       LR(7)
     I              GLL08                       LR(8)
     I              GLL09                       LR(9)
     I              GLL10                       LR(10)
     I              GLL11                       LR(11)
     I              GLL12                       LR(12)
     I              GLL13                       LR(13)
      *
     IRGLBUD
     I              GBC01                       BUD(1)
     I              GBC02                       BUD(2)
     I              GBC03                       BUD(3)
     I              GBC04                       BUD(4)
     I              GBC05                       BUD(5)
     I              GBC06                       BUD(6)
     I              GBC07                       BUD(7)
     I              GBC08                       BUD(8)
     I              GBC09                       BUD(9)
     I              GBC10                       BUD(10)
     I              GBC11                       BUD(11)
     I              GBC12                       BUD(12)
     I              GBC13                       BUD(13)
      *
     IRMAPER
     I              ACST01                      PST(01)
     I              ACST02                      PST(02)
     I              ACST03                      PST(03)
     I              ACST04                      PST(04)
     I              ACST05                      PST(05)
     I              ACST06                      PST(06)
     I              ACST07                      PST(07)
     I              ACST08                      PST(08)
     I              ACST09                      PST(09)
     I              ACST10                      PST(10)
     I              ACST11                      PST(11)
     I              ACST12                      PST(12)
     I              ACST13                      PST(13)
     I              ACEN01                      PED(01)
     I              ACEN02                      PED(02)
     I              ACEN03                      PED(03)
     I              ACEN04                      PED(04)
     I              ACEN05                      PED(05)
     I              ACEN06                      PED(06)
     I              ACEN07                      PED(07)
     I              ACEN08                      PED(08)
     I              ACEN09                      PED(09)
     I              ACEN10                      PED(10)
     I              ACEN11                      PED(11)
     I              ACEN12                      PED(12)
     I              ACEN13                      PED(13)
      *
      *
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
      *
      *
     C     END           TAG
     C                   SETOFF                                       U1U2U3
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
     C                   Z-ADD     0             TL0
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
     C     BALKEY        CHAIN     FMGLCH                             90
     C   90              GOTO      NXTI
     C                   Z-ADD     0             WK
     C   61              DO
     C     BALKEY        CHAIN     FGLBAL                             92
     C   92              GOTO      NXTI
     C                   Z-ADD     CR            WK
     C                   ENDDO                                                  61  DO
     C   62              DO
     C     BALKEY        CHAIN     FGLBAL                             92
     C   92              GOTO      NXTI
     C                   Z-ADD     LR            WK
     C                   ENDDO                                                  62  DO
     C   63              DO
     C     BALKEY        CHAIN     FGLBUD                             92
     C   92              GOTO      NXTI
     C                   Z-ADD     BUD           WK
     C                   ENDDO                                                  63  DO
     C                   Z-ADD     P             X                 2 0
     C     X             DOUEQ     0
     C                   ADD       WK(X)         TL0(X)
     C                   SUB       1             X
     C                   ENDDO                                                  X=0  DO
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
     C                   EXSR      GETPRT
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
      ** GET PRINT ARRAY   **
      ***********************
     C     GETPRT        BEGSR
      ** PRT COMMING IN
      * 1 THRU 13 BALANCE DETERMINED BY INDICATORS
     C                   XFOOT     PRT           PRTTOT            9 0
     C     A             IFGT      0
     C     PRTTOT        DIV(H)    P             PRT(A)
     C                   END
     C                   Z-ADD     PRTTOT        PRT(T)
     C     ENDPRT        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCO           CHAIN     FMCORG                             88
     C     LCO           CHAIN     FMAPER                             88
      *  DETERMINE TYPE OF REPORT TO PRINT
      *
     C                   Z-ADD     LACTP         P                 2 0
     C                   MOVEA     '0'           *IN
     C                   Z-ADD     0             X                 2 0
     C     X             DOUEQ     P
     C                   ADD       1             X
     C                   MOVEL     '1'           *IN(X)
     C                   ENDDO
     C     P             IFLE      13
     C     P             ADD       1             A                 2 0
     C     P             ADD       2             T                 2 0
     C                   ELSE
     C                   Z-ADD     0             A
     C     P             ADD       1             T
     C                   ENDIF
     C     OPTION        SUB       5             O5                5 0
     C     O5            ADD       60            O6                5 0
     C                   SETON                                        OF
     C                   SETOFF                                       616263
     C                   MOVEA     '1'           *IN(O6)
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OGLR522    E            HEAD           1 03
     O                                            6 'GLR522'
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
     O                                           61 'Profit and Loss Stateme'
     O                                           63 'nt'
     O                                           71 'Format:'
     O                       FORMAT              80
     O                       TIMOD              120 '  :  :  '
     O          E            HEAD           1
     O                                            7 'Option:'
     O                       MSG(O5)             38
     O                                           52 'For Period:'
     O                       LACTP               55
     O                       LBEGDT        Y     66
     O                                           68 '-'
     O                       LENDDT        Y     77
     O          E            HD1         0  0
     O                       GHDESC              80
     O          E            HDG            1                                   GLR520
     O                       PST(01)             42 '  /  /  '
     O               02      PST(02)             54 '  /  /  '
     O               03      PST(03)             66 '  /  /  '
     O               02N03                       66 'Monthly'
     O               02N03                       78 '   YTD  '
     O               04      PST(04)             78 '  /  /  '
     O               03N04                       78 'Monthly'
     O               03N04                       90 '   YTD  '
     O               05      PST(05)             90 '  /  /  '
     O               04N05                       90 'Monthly'
     O               04N05                      102 '   YTD  '
     O               06      PST(06)            102 '  /  /  '
     O               05N06                      102 'Monthly'
     O               05N06                      114 '   YTD  '
     O               07      PST(07)            114 '  /  /  '
     O               06N07                      114 'Monthly'
     O               06N07                      126 '   YTD  '
     O               08      PST(08)            126 '  /  /  '
     O               07N08                      126 'Monthly'
     O               07N08                      128 '   YTD  '
     O               09      PST(09)            138 '  /  /  '
     O               08N09                      138 'Monthly'
     O               08N09                      150 '   YTD  '
     O               10      PST(10)            150 '  /  /  '
     O               09N10                      150 'Monthly'
     O               09N10                      162 '   YTD  '
     O               11      PST(11)            162 '  /  /  '
     O               10N11                      162 'Monthly'
     O               10N11                      174 '   YTD  '
     O               12      PST(12)            174 '  /  /  '
     O               11N12                      174 'Monthly'
     O               11N12                      186 '   YTD  '
     O               13   N77PST(13)            186 '  /  /  '
     O               12N13                      186 'Monthly'
     O               12N13                      198 '   YTD  '
     O          E            HDG            0                                   GLR520
     O                       PED(01)             42 '  /  /  '
     O               02      PED(02)             54 '  /  /  '
     O               03      PED(03)             66 '  /  /  '
     O               02N03                       66 'Monthly'
     O               02N03                       78 '   YTD  '
     O               04      PED(04)             78 '  /  /  '
     O               03N04                       78 'Monthly'
     O               03N04                       90 '   YTD  '
     O               05      PED(05)             90 '  /  /  '
     O               04N05                       90 'Monthly'
     O               04N05                      102 '   YTD  '
     O               06      PED(06)            102 '  /  /  '
     O               05N06                      102 'Monthly'
     O               05N06                      114 '   YTD  '
     O               07      PED(07)            114 '  /  /  '
     O               06N07                      114 'Monthly'
     O               06N07                      126 '   YTD  '
     O               08      PED(08)            126 '  /  /  '
     O               07N08                      126 'Monthly'
     O               07N08                      128 '   YTD  '
     O               09      PED(09)            138 '  /  /  '
     O               08N09                      138 'Monthly'
     O               08N09                      150 '   YTD  '
     O               10      PED(10)            150 '  /  /  '
     O               09N10                      150 'Monthly'
     O               09N10                      162 '   YTD  '
     O               11      PED(11)            162 '  /  /  '
     O               10N11                      162 'Monthly'
     O               10N11                      174 '   YTD  '
     O               12      PED(12)            174 '  /  /  '
     O               11N12                      174 'Monthly'
     O               11N12                      186 '   YTD  '
     O               13   N77PED(13)            186 '  /  /  '
     O               12N13                      186 'Monthly'
     O               12N13                      198 '   YTD  '
     O*
     O          E            HDG            1
     O                                           63 '________________________'
     O                                           87 '________________________'
     O                                          111 '________________________'
     O                                          135 '________________________'
     O                                          159 '________________________'
     O                                          183 '________________________'
     O                                          198 '_______________'
     O          E            SIDE1       0  0
     O                       GHDESC              40
     O          E            TDASH       0  1
     O                                           50 '_________'
     O                                           63 '_________'
     O                                           76 '_________'
     O                                           93 '_________'
     O                                          106 '_________'
     O                                          119 '_________'
     O          E            TEQUAL      0  1
     O                                           50 '========='
     O                                           63 '========='
     O                                           76 '========='
     O                                           93 '========='
     O                                          106 '========='
     O                                          119 '========='
     O          E            TL          0  1
     O                       GHDESC              40
     O          E            TL          0  0
     O                       PRT(1)        J     42
     O                       PRT(2)        J     54
     O                       PRT(3)        J     66
     O               02      PRT(4)        J     78
     O               03      PRT(5)        J     90
     O               04      PRT(6)        J    102
     O               05      PRT(7)        J    114
     O               06      PRT(8)        J    126
     O               07      PRT(9)        J    138
     O               08      PRT(10)       J    150
     O               09      PRT(11)       J    162
     O               10      PRT(12)       J    174
     O               11      PRT(13)       J    186
     O               12      PRT(14)       J    198
     O          E            SPACE1         1
** MESSAGE
Current Year Whole Dollars
Last Year Whole Dollars
Budget Whole Dollars
