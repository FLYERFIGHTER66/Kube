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
      **PROGRAM NAME-        GLR510
      **COMPANY-             EFD ENTERPRISES, INC.
      **SYSTEM-              EFDGL
      **APPLICATION-         GENERAL LEDGER BALANCE SHEET
      **DESCRIPTION-         THIS PROGRAM PRINTS A BALANCE SHEET, IN
      **                     A FREE FORMAT.  THE USER SETS UP THE FORMAT
      **                     FILE IN PROGRAM GLR050
      ** CHANGE LOG
      *
      *
      *
     FFGLFMH    IF   E           K DISK
     FFGLFMI    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FFGLBALT   IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR510    O    F  120        PRINTER OFLIND(*INOF)
      *
      * GLBAL ARRAY
     D CR              S             11  2 DIM(13)                              THIS YEAR
     D LR              S             11  2 DIM(13)                              LAST YEAR
      * GLBAL ARRAY
     D GBP             S             11  2 DIM(13)                              THIS YEAR
     D GBN             S             11  2 DIM(13)                              LAST YEAR
      * TOTAL AND PRINT ARRAYS
     D PRT             S             11  2 DIM(6)                               PRINT LINE
     D TL0             S             11  2 DIM(6)                               TOT LEVEL 0
     D TL1             S             11  2 DIM(6)                               TOT LEVEL 1
     D TL2             S             11  2 DIM(6)                               TOT LEVEL 2
     D TL3             S             11  2 DIM(6)                               TOT LEVEL 3
     D TL4             S             11  2 DIM(6)                               TOT LEVEL 4
     D TL5             S             11  2 DIM(6)                               TOT LEVEL 5
     D TL6             S             11  2 DIM(6)                               TOT LEVEL 6
     D TL7             S             11  2 DIM(6)                               TOT LEVEL 7
     D TL8             S             11  2 DIM(6)                               TOT LEVEL 8
     D TL9             S             11  2 DIM(6)                               TOT LEVEL 9
     D TLT             S             11  2 DIM(6)                               TOT FINAL
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
     IRGLBALT
     I              GBT01                       GBP(1)
     I              GBT02                       GBP(2)
     I              GBT03                       GBP(3)
     I              GBT04                       GBP(4)
     I              GBT05                       GBP(5)
     I              GBT06                       GBP(6)
     I              GBT07                       GBP(7)
     I              GBT08                       GBP(8)
     I              GBT09                       GBP(9)
     I              GBT10                       GBP(10)
     I              GBT11                       GBP(11)
     I              GBT12                       GBP(12)
     I              GBT13                       GBP(13)
     I              GBL01                       GBN(1)
     I              GBL02                       GBN(2)
     I              GBL03                       GBN(3)
     I              GBL04                       GBN(4)
     I              GBL05                       GBN(5)
     I              GBL06                       GBN(6)
     I              GBL07                       GBN(7)
     I              GBL08                       GBN(8)
     I              GBL09                       GBN(9)
     I              GBL10                       GBN(10)
     I              GBL11                       GBN(11)
     I              GBL12                       GBN(12)
     I              GBL13                       GBN(13)
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
     C  N90BALKEY        CHAIN     FGLBAL                             92
     C   92              Z-ADD     0             CR
     C  N90BALKEY        CHAIN     FGLBALT                            92
     C   92              Z-ADD     0             GBP
     C   90              GOTO      NXTI
     C                   ADD       CR(P)         TL0(1)
     C                   ADD       LR(P)         TL0(2)
     C                   ADD       GBP(P)        TL0(4)
     C                   ADD       GBN(P)        TL0(5)
     C                   Z-ADD     P             X                 2 0
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
      * 1=CURR PERIOD
      * 2=LAST YEAR CUR PER
      * 4=CURR YTD
      * 5=LAST YEAR YTD
     C     PRT(2)        IFNE      0
     C     PRT(1)        SUB       PRT(2)        VAR              11 2
     C     VAR           DIV(H)    PRT(2)        WRKPCT           11 4
     C     WRKPCT        MULT(H)   100           PRT(3)
     C                   ELSE
     C                   Z-ADD     0             PRT(3)
     C                   END
     C     PRT(5)        IFNE      0
     C     PRT(4)        SUB       PRT(5)        VAR
     C     VAR           DIV(H)    PRT(5)        WRKPCT
     C     WRKPCT        MULT(H)   100           PRT(6)
     C                   ELSE
     C                   Z-ADD     0             PRT(6)
     C                   END
     C                   GOTO      ENDPRT
     C     ENDPRT        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCO           CHAIN     FMCORG                             88
      *  DETERMINE TYPE OF REPORT TO PRINT
      *
     C                   MOVEA     '0'           *IN
     C                   Z-ADD     OPTION        O                 2 0
     C     O             ADD       10            O1                2 0
     C     O             ADD       60            O6                3 0
     C                   SETON                                        OF
     C                   Z-ADD     LACTP         P                 2 0
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OGLR510    E            HEAD           1 03
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
     O                                           61 'Profit and Loss Stateme'
     O                                           63 'nt'
     O                                           71 'Format:'
     O                       FORMAT              80
     O                       TIMOD              120 '  :  :  '
     O          E            HEAD           1
     O                                           52 'For Period:'
     O                       LACTP               55
     O                       LBEGDT        Y     66
     O                                           68 '-'
     O                       LENDDT        Y     77
     O          E            HD1         0  0
     O                       GHDESC              80
     O          E            HDG         1  1                                   GLR520
     O                                           55 '-----------'               GLR520
     O                                           70 'Current Period'            GLR520
     O                                           80 '---------'                 GLR520
     O                                           95 '----------'                GLR520
     O                                          108 'Year-To-Date'              GLR520
     O                                          120 '-----------'               GLR520
     O          E            HDG            1                                   GLR520
     O                                           54 'Current'                   GLR520
     O                                           67 'Prior'                     GLR520
     O                                           81 'Variance'                  GLR520
     O                                           93 'Current'                   GLR520
     O                                          105 'Prior'                     GLR520
     O                                          120 'Variance'                  GLR520
     O          E            HDG            0                                   GLR520
     O                                           53 'Total'                     GLR520
     O                                           67 'Total'                     GLR520
     O                                           81 'Percent'                   GLR520
     O                                           92 'Total'                     GLR520
     O                                          105 'Total'                     GLR520
     O                                          120 'Percent'                   GLR520
     O          E            HDG            1
     O**                                 24 '________________________'
     O                                           48 '                   _____'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            SIDE1       0  0
     O                       GHDESC              40
     O          E            TDASH       0  1
     O                                           54 '_________'
     O                                           67 '_________'
     O                                           80 '_________'
     O                                           93 '_________'
     O                                          106 '_________'
     O                                          119 '_________'
     O          E            TEQUAL      0  1
     O                                           54 '========='
     O                                           67 '========='
     O                                           80 '========='
     O                                           93 '========='
     O                                          106 '========='
     O                                          119 '========='
     O          E            TL          0  0
     O                       GHDESC              42
     O                       PRT(6)        L    120
     O                       PRT(5)        L    107
     O                       PRT(4)        L     94
     O                       PRT(3)        L     81
     O                       PRT(2)        L     68
     O                       PRT(1)        L     55
     O          E            SPACE1         1
