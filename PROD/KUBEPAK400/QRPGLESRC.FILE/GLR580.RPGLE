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
      **PROGRAM NAME-        GLR580
      **COMPANY-             EFD ENTERPRISES, INC.
      **SYSTEM-              EFDGL
      **APPLICATION-         GENERAL LEDGER INCOME STATEMENT
      **DESCRIPTION-         THIS PROGRAM PRINTS AN INCOME STATEMENT, IN
      **                     A FREE FORMAT.  THE USER SETS UP THE FORMAT
      **                     FILE IN PROGRAM GLR050
      **                     USER SELECTS % OF SALES EXPENSES OR PROFIT
      ** CHANGE LOG
      *
      *
      * MAIN INDICATORS
      * 61 - PERCENT OF SALES
      * 62 - PERCENT OF EXPENSES
      * 63 - PERCENT OF PROFIT
      *
     FFGLFMH    IF   E           K DISK
     FFGLFMI    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
     FFGLBALS   IF   E           K DISK
     FFGLBALT   IF   E           K DISK
     FFGLBUD    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR580    O    F  198        PRINTER OFLIND(*INOF)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              HEADING DESC
      * GLBAL ARRAY
     D CR              S             11  2 DIM(13)                              THIS YEAR
     D LR              S             11  2 DIM(13)                              LAST YEAR
      * GLBALT ARRAY
     D GBP             S             11  2 DIM(13)                              THIS YEAR
     D GBN             S             11  2 DIM(13)                              LAST YEAR
      * GLBALS ARRAY
     D SCR             S             11  2 DIM(13)                              THIS YEAR
     D SLR             S             11  2 DIM(13)                              LAST YEAR
     D BCR             S             11  2 DIM(13)                              BUDGET
      * GLBUD ARRAY
     D BUD             S             11  2 DIM(13)                              BUDG THIS YEAR
      * TOTAL AND PRINT ARRAYS
     D PRT             S             11  2 DIM(12)                              PRINT LINE
     D TL0             S             11  2 DIM(12)                              TOT LEVEL 0
     D TL1             S             11  2 DIM(12)                              TOT LEVEL 1
     D TL2             S             11  2 DIM(12)                              TOT LEVEL 2
     D TL3             S             11  2 DIM(12)                              TOT LEVEL 3
     D TL4             S             11  2 DIM(12)                              TOT LEVEL 4
     D TL5             S             11  2 DIM(12)                              TOT LEVEL 5
     D TL6             S             11  2 DIM(12)                              TOT LEVEL 6
     D TL7             S             11  2 DIM(12)                              TOT LEVEL 7
     D TL8             S             11  2 DIM(12)                              TOT LEVEL 8
     D TL9             S             11  2 DIM(12)                              TOT LEVEL 9
     D TLT             S             11  2 DIM(12)                              TOT FINAL
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
     IRGLBALS
     I              GST01                       SCR(1)
     I              GST02                       SCR(2)
     I              GST03                       SCR(3)
     I              GST04                       SCR(4)
     I              GST05                       SCR(5)
     I              GST06                       SCR(6)
     I              GST07                       SCR(7)
     I              GST08                       SCR(8)
     I              GST09                       SCR(9)
     I              GST10                       SCR(10)
     I              GST11                       SCR(11)
     I              GST12                       SCR(12)
     I              GST13                       SCR(13)
     I              GSL01                       SLR(1)
     I              GSL02                       SLR(2)
     I              GSL03                       SLR(3)
     I              GSL04                       SLR(4)
     I              GSL05                       SLR(5)
     I              GSL06                       SLR(6)
     I              GSL07                       SLR(7)
     I              GSL08                       SLR(8)
     I              GSL09                       SLR(9)
     I              GSL10                       SLR(10)
     I              GSL11                       SLR(11)
     I              GSL12                       SLR(12)
     I              GSL13                       SLR(13)
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
     C   92              Z-ADD     0             LR
     C  N90BALKEY        CHAIN     FGLBALT                            92
     C   92              Z-ADD     0             GBP
     C   92              Z-ADD     0             GBN
     C  N90BALKEY        CHAIN     FGLBUD                             92
     C   92              Z-ADD     0             BUD
     C   90              GOTO      NXTI
     C                   ADD       CR(P)         TL0(1)
     C                   ADD       BUD(P)        TL0(3)
     C                   ADD       LR(P)         TL0(5)
     C                   ADD       GBP(P)        TL0(7)
     C                   ADD       GBN(P)        TL0(11)
     C                   Z-ADD     P             X                 2 0
     C     X             DOUEQ     0
     C                   ADD       BUD(X)        TL0(9)
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
      * PRINT COMING IN
      * 1=CURR PERIOD
      * 3=BUDGET CURR PER
      * 5=LAST YEAR CUR PER
      * 7=CURR YTD
      * 9=BUD YTD
      *11=LAST YEAR YTD
      *
     C     SCR(P)        IFNE      0
     C     PRT(1)        DIV(H)    SCR(P)        WRK114           11 4
     C     WRK114        MULT(H)   100           PRT(2)
     C                   ELSE
     C                   Z-ADD     0             PRT(2)
     C                   END
     C     BCR(P)        IFNE      0
     C     PRT(3)        DIV(H)    BCR(P)        WRK114
     C     WRK114        MULT(H)   100           PRT(4)
     C                   ELSE
     C                   Z-ADD     0             PRT(4)
     C                   END
     C     SCR(P)        IFNE      0
     C     PRT(5)        DIV(H)    SCR(P)        WRK114
     C     WRK114        MULT(H)   100           PRT(6)
     C                   ELSE
     C                   Z-ADD     0             PRT(6)
     C                   END
     C     COMYTD        IFNE      0
     C     PRT(7)        DIV(H)    COMYTD        WRK114
     C     WRK114        MULT(H)   100           PRT(8)
     C                   ELSE
     C                   Z-ADD     0             PRT(8)
     C                   END
     C     BUDYTD        IFNE      0
     C     PRT(9)        DIV(H)    BUDYTD        WRK114
     C     WRK114        MULT(H)   100           PRT(10)
     C                   ELSE
     C                   Z-ADD     0             PRT(10)
     C                   END
     C     COMYTD        IFNE      0
     C     PRT(11)       DIV(H)    COMYTD        WRK114
     C     WRK114        MULT(H)   100           PRT(12)
     C                   ELSE
     C                   Z-ADD     0             PRT(12)
     C                   END
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
     C                   MOVEL     MSG(O)        OPTH             30
     C                   MOVEL     '1'           *IN(O6)
     C                   SETON                                        OF
     C                   Z-ADD     LACTP         P                 2 0
      ** GET COMPARE BUDGET ARRAY BASED ON IND 61 62 63
     C   61              Z-ADD     30010000      GIGLAC
     C   62              Z-ADD     50010000      GIGLAC
     C   63              Z-ADD     99010000      GIGLAC
     C     BALKEY        CHAIN     FGLBALS                            91
     C   91              DO
     C                   Z-ADD     0             SCR
     C                   Z-ADD     0             SLR
     C                   ENDDO
     C                   Z-ADD     SCR           BCR
     C                   Z-ADD     0             GIGLAC
     C                   Z-ADD     0             BUDYTD           11 2
      *** GET YTD BALANCES
     C     P             DOUEQ     0
     C                   ADD       BCR(P)        COMYTD
     C                   SUB       1             P
     C                   ENDDO
     C                   Z-ADD     LACTP         P                 2 0
     C   61              Z-ADD     30000000      GIGLAC
     C   62              Z-ADD     50000000      GIGLAC
     C   63              Z-ADD     99000000      GIGLAC
     C     BALKEY        CHAIN     FGLBALS                            91
     C   91              DO
     C                   Z-ADD     0             SCR
     C                   Z-ADD     0             SLR
     C                   ENDDO
     C                   Z-ADD     0             GIGLAC
     C                   Z-ADD     0             COMYTD           11 2
     C                   Z-ADD     0             COMLTD           11 2
      *** GET YTD BALANCES
     C     P             DOUEQ     0
     C                   ADD       SCR(P)        COMYTD
     C                   ADD       SLR(P)        COMLTD
     C                   SUB       1             P
     C                   ENDDO
     C                   Z-ADD     LACTP         P                 2 0
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OGLR580    E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          117 'Page:'
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
     O                       OPTH                38
     O                                           52 'For Period:'
     O                       LACTP               55
     O                       LBEGDT        Y     66
     O                                           68 '-'
     O                       LENDDT        Y     77
     O          E            HD1         0  0
     O                       GHDESC              80
     O          E            HDG            1                                   GLR520
     O                                           69 '------------------------'  GLR520
     O                                           71 '--'                        GLR520
     O                                           85 'Current Period'            GLR520
     O                                          109 '------------------------'  GLR520
     O                                          111 '--'                        GLR520
     O                                          142 '------------------------'  GLR520
     O                                          155 'Year-To-Date'              GLR520
     O                                          177 '----------------------'    GLR520
     O          E            HDG            1                                   GLR520
     O                                           59 'Current Year'              GLR520
     O               61                          67 '% Sale'                    GLR520
     O               62                          67 '% Exp.'                    GLR520
     O               63                          67 '%Prof.'                    GLR520
     O                                           81 'Budget'                    GLR520
     O                                           88 '% Bud.'                    GLR520
     O                                          104 'Prior Year'                GLR520
     O               61                         111 '% Sale'                    GLR520
     O               62                         111 '% Exp.'                    GLR520
     O               63                         111 '%Prof.'                    GLR520
     O                                          125 'Current Year'              GLR520
     O               61                         133 '% Sale'                    GLR520
     O               62                         133 '% Exp.'                    GLR520
     O               63                         133 '%Prof.'                    GLR520
     O                                          147 'Budget'                    GLR520
     O                                          155 '% Bud.'                    GLR520
     O                                          169 'Prior Year'                GLR520
     O               61                         177 '% Sale'                    GLR520
     O               62                         177 '% Exp.'                    GLR520
     O               63                         177 '%Prof.'                    GLR520
     O          E            HDG            1
     O                                           60 '      ______________'
     O                                           80 '____________________'
     O                                          100 '____________________'
     O                                          120 '____________________'
     O                                          140 '____________________'
     O                                          160 '____________________'
     O                                          180 '_________________   '
     O          E            SIDE1       0  0
     O                       GHDESC              40
     O          E            TDASH       0  1
     O                                          176 '----'
     O                                          169 '---------'
     O                                          154 '----'
     O                                          147 '---------'
     O                                          132 '----'
     O                                          125 '---------'
     O                                          110 '----'
     O                                          103 '---------'
     O                                           88 '----'
     O                                           81 '---------'
     O                                           66 '----'
     O                                           59 '---------'
     O          E            TEQUAL      0  1
     O                                          176 '===='
     O                                          169 '========='
     O                                          154 '===='
     O                                          147 '========='
     O                                          132 '===='
     O                                          125 '========='
     O                                          110 '===='
     O                                          103 '========='
     O                                           88 '===='
     O                                           81 '========='
     O                                           66 '===='
     O                                           59 '========='
     O          E            TL          0  0
     O                       GHDESC              45
     O                       PRT(12)       J    177
     O                       PRT(11)       J    170
     O                       PRT(10)       J    155
     O                       PRT(9)        J    148
     O                       PRT(8)        J    133
     O                       PRT(7)        J    126
     O                       PRT(6)        J    111
     O                       PRT(5)        J    104
     O                       PRT(4)        J     89
     O                       PRT(3)        J     82
     O                       PRT(2)        J     67
     O                       PRT(1)        J     60
     O          E            SPACE1         1
** MESSAGE
Percent of Sales
Percent of Expenses
Percent of Profit
