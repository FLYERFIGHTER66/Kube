0015 H*--------------------------------------------------------------
0016 F**PROGRAM NAME-------- GRS212SH
0017 F**COMPANY------------- KUBE-PAK
0019 F**PROGRAMMER---------- JJP
0020 F**APPLICATION--------- SOW SCHEDULE SUMMARY BY WEEK.
0021 F**DATE WRITTEN-------- 02/20/99
0022 F**DESCRIPTION--------- PRINT THE SOW SCHEDULE BY WEEK
0024 F**
0025 F**
0027 F**
0028 F**
0029 F**
0030 F*            *******************************
0031 F*            **     PROGRAM CHANGE LOG    **
0032 F*            *******************************
0033 F*
0034 F*            CHANGE--DATE-------DESCRIPTION
0035 F*
0035 F*________________________________________________________________________
0035 F*  01/01/03   CHANGED REPORT TO REFLECT ADDITION OF QTY 105 AND THE
0035 F*             ELIMINATION OF QTY 128, 84.  ALSO, TOOK OUT THE
0035 F*             DECIMAL POSITION FOR ALL QTY'S. CHANGED THE PAGE SIZE
0033 F*             TO PRINT ON A 8 1/2 BY 11.             CHAS. BUCK
0033 F*------------------------------------------------------------------------
0036 F**   INDICATOR USAGE SUMMARY
0037 F*
0038 F*  51 : LOKUP OPCODE FOR TABLE TABSIZ.
0038 F*  90 : READ OPCODE FOR THE FOLABLLA FILE.
0033 F*------------------------------------------------------------------------
     FFOLABLLB  IF   E           K DISK
WJB  FFMINVT    IF   E           K DISK
     FQSYSPRT   O    F   86        PRINTER
      *------------------------------------------------------------------------
WJB  D SIZ             S              3    DIM(9) CTDATA PERRCD(1)              SIZE TABLE
WJB  D SUF             S              2    DIM(9) ALT(SIZ)                      ?SIZE SUFFIX
WJB  D QTY             S              6  0 DIM(9)                               SIZE TABLE
WJB  D TOT             S              7  0 DIM(9)                               QUANTITY
      *-------------------------------------
      *
      * ****  MAINLINE CALCS
      *
     C  N15              EXSR      $FIRST

     C                   Z-ADD     LOREQD        HDATE             6 0
     C                   Z-ADD     LOWEEK        HWEEK             2 0

     C     LOOP          TAG
     C                   READ      ROLABL                                 90
     C     *IN90         IFEQ      '1'
     C                   EXSR      $RPRNT

     C     CTN           IFGE      60
     C                   EXSR      $HEAD
     C                   END

     C                   XFOOT     TOT           FTOT              7 0
     C                   EXCEPT    TOTL
     C                   GOTO      END
     C                   END
     C**
     C     *IN16         IFEQ      '0'
     C                   Z-ADD     LOREQD        HDATE             6 0
     C                   Z-ADD     LOWEEK        HWEEK             2 0
     C                   SETON                                        16
     C                   END
     C**
     C**
     C     LOREQD        IFNE      HDATE
     C                   EXSR      $RPRNT
     C                   END
     C**
     C** --- PROCESS DETAIL RECORD ACCUMULATE TOTALS
     C                   EXSR      $DETL
     C**
     C                   GOTO      LOOP
     C**
     C*** END PROGRAM
     C*
     C     END           TAG
     C                   SETON                                        LR
     C*
     C*
     C************************
     C** $DETL
     C************************
     C     $DETL         BEGSR
     C                   MOVE      '0'           *IN51
     C                   Z-ADD     1             X                 1 0
     C** ACCUMULATE QTY FOR THE WEEK
     C                   IF        LOSIZE = '72 '
     C                   Eval      X = 9                                        Put in with S-50
     C                   Else
     C     LOSIZE        LOOKUP    SIZ(X)                                 51
     C                   ENDIF
     C*
     C     *IN51         IFEQ      '1'
      *
WJB  C     LOSIZE        IFEQ      '105'
WJB  C     LOSIZE        OREQ      '50 '
WJB  C     ITMKEY        KLIST
WJB  C                   KFLD                    LOITEM
WJB  C                   KFLD                    LOSIZE
WJB  C     ITMKEY        CHAIN     FMINVT                             91
WJB  C     *IN91         IFEQ      '0'
WJB  C     IMTPSW        ANDNE     'R'
WJB  C     IMTPSW        ANDNE     'G'
WJB  C                   ADD       1             X
WJB  C                   ENDIF
WJB  C                   ENDIF
     C                   ADD       LOQSOW        QTY(X)
     C                   END
     C**
     C                   ENDSR
0003 C********************************************************************
     C************************
     C** FIRST
     C************************
     C     $FIRST        BEGSR
     C**
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TIMWRK           12 0
     C                   MOVE      TIMWRK        TDATE             6 0
     C                   MOVE      '1'           *IN15
     C**
     C                   EXSR      $HEAD
     C                   ENDSR
0003 C********************************************************************
     C************************
     C** $HEAD
     C************************
     C     $HEAD         BEGSR
     C**
     C                   EXCEPT    HEAD
     C                   Z-ADD     6             CTN               5 0
     C*
     C                   ENDSR
     C*********************************************************************
     C** $RPRNT
     C************************
     C     $RPRNT        BEGSR
     C*
     C     CTN           IFGE      60
     C                   EXSR      $HEAD
     C                   END
     C**
     C                   ADD       QTY           TOT
     C                   XFOOT     QTY           XTOT              7 0
     C                   EXCEPT    DETL
     C                   ADD       2             CTN
     C                   Z-ADD     *ZEROS        QTY
     C                   Z-ADD     LOREQD        HDATE
     C                   Z-ADD     LOWEEK        HWEEK             2 0
     C                   ENDSR
      * ------------------------------------------------------------------------
     OQSYSPRT   E            HEAD           2 02
     O                                            8 'GRS212SH'
     O                       TDATE         Y     17
     O                                           43 'SOW SCHEDULE SUMMARY BY'
     O                                           48 'WEEK'
     O                                           65 '* REQUEST DATE *'
     O                       PAGE          Z     79
     O                                           75 'PAGE:'
     O          E            HEAD           1
     O                                            5 'WEEK'
     O                                           13 'DATE'
     O                       SIZ(1)              20
     O                       SIZ(2)              26
     O                       SIZ(3)              32
     O                       SIZ(4)              38
     O                       SIZ(5)              44
WJB  O                       SIZ(6)              50
WJB  O                       SIZ(7)              56
WJB  O                       SIZ(8)              62
WJB  O                       SIZ(9)              68

     O                       SUF(1)              17
     O                       SUF(2)              23
     O                       SUF(3)              29
     O                       SUF(4)              35
     O                       SUF(5)              41
     O                       SUF(6)              47
     O                       SUF(7)              53
     O                       SUF(8)              59
     O                       SUF(9)              65

     O* instructed to remove by B.S.             62 'R'
     O                                           80 'TOTAL'
     O          E            HEAD           2
     O                                            5 '----'
     O                                           13 '----'
     O                                           20 '---'
     O                                           26 '---'
     O                                           32 '---'
     O                                           38 '---'
     O                                           44 '---'
     O                                           50 '---'
     O                                           56 '---'
     O                                           62 '---'
     O                                           68 '---'
     O                                           80 '-----'
     O          EF           DETL           2
     O                       HWEEK         Z      3
     O                       HDATE         Y     13
     O                       QTY(1)        4     20
     O                       QTY(2)        4     26
     O                       QTY(3)        4     32
     O                       QTY(4)        4     38
     O                       QTY(5)        4     44
     O                       QTY(6)        4     50
     O                       QTY(7)        4     56
     O                       QTY(8)        4     62
     O                       QTY(9)        4     68
     O                       XTOT          4     80
     O          E            TOTL        1  0
     O                                           13 'TOTALS ----->'
     O                       TOT(1)        4     20
     O                       TOT(3)        4     32
     O                       TOT(5)        4     44
     O                       TOT(7)        4     56
     O                       TOT(9)        4     68
     O          E            TOTL        1  1
     O                                           13 '       ----->'
     O                       TOT(2)        4     26
     O                       TOT(4)        4     38
     O                       TOT(6)        4     50
     O                       TOT(8)        4     62
     O                       FTOT          4     80
     O*------
** SIZE TABLE
512
288
162
105R-  SOW TYPE =  "R"  NOT MIX 40
105S-  SOW TYPE <> "R"
102
51
50 R-  SOW TYPE =  "R"  NOT MIX 40
50 S-  SOW TYPE <> "R"
