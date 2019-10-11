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
      *PROGRAM NAME-        GLR020
      *SYSTEM-              GENERAL LEDGER
      *APPLICATION-         ENTER RECURRING JOURNAL ENTRIES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGLR020FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFGLRJE    UF A E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FFMAPER    IF   E           K DISK
      *
      * SKIP PERIOD ARRAYS
     D SIN             S              1    DIM(13)                              FROM SCREEN
     D SOU             S              1    DIM(13)                              FROM RECORD
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
      *
     ISCRNB
     I              GJSP01                      SIN(1)
     I              GJSP02                      SIN(2)
     I              GJSP03                      SIN(3)
     I              GJSP04                      SIN(4)
     I              GJSP05                      SIN(5)
     I              GJSP06                      SIN(6)
     I              GJSP07                      SIN(7)
     I              GJSP08                      SIN(8)
     I              GJSP09                      SIN(9)
     I              GJSP10                      SIN(10)
     I              GJSP11                      SIN(11)
     I              GJSP12                      SIN(12)
     I              GJSP13                      SIN(13)
     IRGLRJE
     I              GJSP01                      SOU(1)
     I              GJSP02                      SOU(2)
     I              GJSP03                      SOU(3)
     I              GJSP04                      SOU(4)
     I              GJSP05                      SOU(5)
     I              GJSP06                      SOU(6)
     I              GJSP07                      SOU(7)
     I              GJSP08                      SOU(8)
     I              GJSP09                      SOU(9)
     I              GJSP10                      SOU(10)
     I              GJSP11                      SOU(11)
     I              GJSP12                      SOU(12)
     I              GJSP13                      SOU(13)
      ***********************
      ** MAIN LINE CODE    **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             JENM
     C                   Z-ADD     0             JENMO             6 0
     C                   MOVE      *BLANKS       JEPR
     C                   MOVE      *BLANKS       JEPRO             2
     C                   MOVEL     'RE'          JESF
     C                   MOVEL     'RE'          JESFO             2
     C                   MOVE      *BLANKS       JEDS
     C                   MOVE      '0'           *IN
      *
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** FUNCTION KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       103025
     C                   SETOFF                                       202122
     C                   SETOFF                                       40  42
     C                   SETOFF                                       99
      ** ACTION CODE
     C     ACTION        IFNE      'A'
     C     ACTION        ANDNE     'C'
     C     ACTION        ANDNE     'D'
     C     ACTION        ANDNE     'R'
     C     ACTION        ANDNE     'S'
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   END
      ** JOURNAL NUMBER
     C     JENM          IFLE      0
     C                   SETON                                        20  99
     C                   GOTO      NXTA
     C                   END
     C     GLRKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    JEPR
     C                   KFLD                    JENM
     C                   KFLD                    JESF
     C     JEPR          IFNE      JEPRO
     C     JENM          ORNE      JENMO
     C                   CLEAR                   RGLRJE
     C     GLRKEY        CHAIN     FGLRJE                             77
      *
     C   77ACTION        IFNE      'A'
     C                   SETON                                        202199
     C                   GOTO      NXTA
     C                   END
      *
     C  N77ACTION        IFEQ      'A'
     C                   SETON                                        202299
     C                   GOTO      NXTA
     C                   END
      *
     C                   Z-ADD     JENM          JENMO
     C                   MOVEL     JEPR          JEPRO
     C                   MOVEL     JESF          JESFO
     C  N77              DO
     C                   MOVEL     GJJEDS        JEDS
     C                   ENDDO
     C                   END
      * DESCRIPTION
     C     JEDS          IFLE      *BLANKS
     C                   SETON                                        30  99
     C                   GOTO      NXTA
     C                   END
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
      * B SCREEN GET PERIODS TO POST
     C     LCO           CHAIN     FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        9733
     C                   ELSE
     C     ACST13        IFGT      0
     C                   SETOFF                                       97
     C                   ELSE
     C                   SETON                                        97
     C                   END
     C                   END
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETON                                        272829
     C                   SETON                                        303132
     C                   SETON                                        33
     C     GJPP01        IFEQ      'Y'
     C                   SETOFF                                       21
     C                   END
     C     GJPP02        IFEQ      'Y'
     C                   SETOFF                                       22
     C                   END
     C     GJPP03        IFEQ      'Y'
     C                   SETOFF                                       23
     C                   END
     C     GJPP04        IFEQ      'Y'
     C                   SETOFF                                       24
     C                   END
     C     GJPP05        IFEQ      'Y'
     C                   SETOFF                                       25
     C                   END
     C     GJPP06        IFEQ      'Y'
     C                   SETOFF                                       26
     C                   END
     C     GJPP07        IFEQ      'Y'
     C                   SETOFF                                       27
     C                   END
     C     GJPP08        IFEQ      'Y'
     C                   SETOFF                                       28
     C                   END
     C     GJPP09        IFEQ      'Y'
     C                   SETOFF                                       29
     C                   END
     C     GJPP10        IFEQ      'Y'
     C                   SETOFF                                       30
     C                   END
     C     GJPP11        IFEQ      'Y'
     C                   SETOFF                                       31
     C                   END
     C     GJPP12        IFEQ      'Y'
     C                   SETOFF                                       32
     C                   END
     C  N97GJPP13        IFEQ      'Y'
     C                   SETOFF                                       33
     C                   END
     C                   MOVE      SOU           SIN
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       139899
     C     NXTB          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      * FUNCTION KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       13  99
      * CHECK FIELDS
     C                   Z-ADD     1             X                 2 0
     C     NXTX          TAG
     C     SIN(X)        IFNE      *BLANKS
     C     SIN(X)        ANDNE     'S'
     C                   MOVEL     '1'           *IN(X)
     C                   MOVEL     '1'           *IN(99)
     C                   END
     C                   ADD       1             X
     C     X             IFLE      13
     C                   GOTO      NXTX
     C                   END
     C   99              DO
     C                   SETOFF                                       98
     C                   GOTO      NXTB
     C                   ENDDO
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   END
     C                   SETOFF                                       11
     C                   SETOFF                                       313233
     C                   SETOFF                                       40  99
      *** GET ACCOUNT INFO
     C                   EXSR      BLDSFL
      *** DISPLAY SUB FILE
     C     NXTSFL        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     RECCTL
      ** F KEYS
     C   KF              GOTO      RSTART
     C   KB              DO
     C                   EXSR      GETGL
     C                   GOTO      NXTSFL
     C                   ENDDO
     C   KE              DO
     C                   EXSR      BLDMOR
     C                   GOTO      NXTSFL
     C                   ENDDO
      ** CHECK FOR ZERO BALANCE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO
     C                   GOTO      NXTSFL
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET G/L NUMBER    **
      ***********************
     C     GETGL         BEGSR
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      ENDGET
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVE      *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       GCLOOK
     C     GCGLNO        IFLE      0
     C                   GOTO      ENDGET
     C                   END
     C     GLKEY         KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
     C     GLKEY         CHAIN     FMGLCH                             90
     C   90              GOTO      ENDGET
     C                   Z-ADD     GCGLNO        GLNO
     C                   MOVEL     GCDESC        DESC
     C                   UPDATE    RECSFL
     C     ENDGET        TAG
     C                   ENDSR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80  98
     C                   SETOFF                                       103099
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTDEB
     C                   Z-ADD     0             TOTCRD
     C                   Z-ADD     0             TOTBAL
     C                   Z-ADD     0             GJSEQ#
     C     GLRKEY        SETLL     FGLRJE
     C     NXTBLD        TAG
     C     GLRKEY        READE     FGLRJE                                 90
     C   90              GOTO      ENDBLD
     C                   Z-ADD     GJGLAC        GLNO
     C     GJ$AMT        IFGE      0
     C                   Z-ADD     GJ$AMT        DEBIT
     C                   Z-ADD     0             CREDIT
     C                   ELSE
     C                   Z-SUB     GJ$AMT        CREDIT
     C                   Z-ADD     0             DEBIT
     C                   END
     C                   ADD       DEBIT         TOTDEB
     C                   ADD       CREDIT        TOTCRD
     C                   MOVEL     GJDDES        DESC
     C                   ADD       1             RECNO
     C     GLCKEY        CHAIN     FMGLCH                             90
     C                   MOVEL     GCDESC        ODESC
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     GJSEQ#        LSTSEQ            3 0
     C     RECNO         ADD       50            TSTREC            5 0
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             GJSEQ#
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C     NXTBD1        TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     RECNO         IFLT      TSTREC
     C                   GOTO      NXTBD1
     C                   END
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** BUILD MORE RECS   **
      ***********************
     C     BLDMOR        BEGSR
     C     LSTREC        ADD       50            TSTREC            5 0
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             GJSEQ#
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C     NXTMOR        TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     RECNO         IFLT      TSTREC
     C                   GOTO      NXTMOR
     C                   END
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             TOTDEB
     C                   Z-ADD     0             TOTCRD
     C                   Z-ADD     0             TOTBAL
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       11
     C                   SETOFF                                       313233
     C                   SETOFF                                       40  99
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
     C                   SETOFF                                       1030
     C     GLNO          IFLE      0
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C                   GOTO      NCGL
     C                   END
     C     GLCKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLNO
     C     GLCKEY        CHAIN     FMGLCH                             90
     C   90              SETON                                        101199
     C   90              MOVE      *BLANKS       GCDESC
     C     DEBIT         IFNE      0
     C     CREDIT        ANDNE     0
     C                   SETON                                        303299
     C                   END
     C     DEBIT         IFEQ      0
     C     CREDIT        ANDEQ     0
     C                   SETON                                        303199
     C                   END
     C     DEBIT         IFLT      0
     C     CREDIT        ORLT      0
     C                   SETON                                        303399
     C                   END
     C     DESC          IFEQ      ODESC
     C                   MOVEL     GCDESC        DESC
     C                   MOVEL     GCDESC        ODESC
     C                   END
     C                   ADD       DEBIT         TOTDEB
     C                   ADD       CREDIT        TOTCRD
      ** NO GL NUMBER ENTERED
     C     NCGL          TAG
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     TOTDEB        SUB       TOTCRD        TOTBAL
     C     TOTBAL        IFNE      0
     C                   SETON                                        4099
     C                   END
     C  N99              SETON                                        98
     C                   ENDSR
      **********************
      **  PUT SUB FILE    **
      **********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
     C                   SETOFF                                       1030
     C     GWRKYD        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    JEPRO
     C                   KFLD                    JENMO
     C                   KFLD                    JESFO
     C                   KFLD                    GJSEQ#
     C     GWRKYD        CHAIN     FGLRJE                             88
     C     GLNO          IFLE      0
     C     GJSEQ#        IFGT      0
     C  N88              DELETE    RGLRJE
     C                   END                                                    GJSEQ#>0
     C                   GOTO      NXTPUT
     C                   END                                                    GLNO=0
      * IF HERE GOOD RECORD
     C     GJSEQ#        IFLE      0
     C                   ADD       1             LSTSEQ
     C                   Z-ADD     LSTSEQ        GJSEQ#
     C                   END
     C     DEBIT         IFGT      0
     C                   Z-ADD     DEBIT         GJ$AMT
     C                   ELSE
     C                   Z-SUB     CREDIT        GJ$AMT
     C                   END
     C                   Z-ADD     LCO           GJCOMP
     C                   MOVEL     JEPR          GJJEPR
     C                   Z-ADD     JENM          GJJENM
     C                   MOVEL     JESF          GJJESF
     C                   MOVEL     JEDS          GJJEDS
     C                   MOVEL     DESC          GJDDES
     C                   MOVEL     'A'           GJSTAT
     C  N88              Z-ADD     TDATE         GJUPDT
     C                   Z-ADD     GLNO          GJGLAC
     C                   MOVE      *BLANKS       GJJETP
     C                   MOVE      *BLANKS       GJSHFR
     C   88              DO
     C                   Z-ADD     TDATE         GJENDT
     C                   MOVE      *BLANKS       GJPP01
     C                   MOVE      *BLANKS       GJPP02
     C                   MOVE      *BLANKS       GJPP03
     C                   MOVE      *BLANKS       GJPP04
     C                   MOVE      *BLANKS       GJPP05
     C                   MOVE      *BLANKS       GJPP06
     C                   MOVE      *BLANKS       GJPP07
     C                   MOVE      *BLANKS       GJPP08
     C                   MOVE      *BLANKS       GJPP09
     C                   MOVE      *BLANKS       GJPP10
     C                   MOVE      *BLANKS       GJPP11
     C                   MOVE      *BLANKS       GJPP12
     C                   MOVE      *BLANKS       GJPP13
     C                   END
     C                   Z-ADD     TDATE         GJDTLA
     C                   Z-ADD     TIMOD         GJTIME
     C                   MOVEL     USERID        GJUSER
     C                   MOVE      SIN           SOU
     C  N88              UPDATE    RGLRJE
     C   88              WRITE     RGLRJE
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C     LCO           CHAIN     FGLCTL                             91
     C                   MOVEL     'N'           GZOKRE
     C  N90              UPDATE    RGLCTL
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCO           CHAIN(N)  FGLCTL                             90
     C     LCO           CHAIN(N)  FMAPER                             90
     C                   Z-ADD     ACFSST        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TSTBEG            7 0
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     ACEN12        ##MDY
     C                   END
     C     ACEN13        IFGT      0
     C                   SETOFF                                       97
     C                   Z-ADD     ACEN13        ##MDY
     C                   ELSE
     C                   Z-ADD     ACEN12        ##MDY
     C                   SETON                                        97
     C                   END
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TSTEND            7 0
      *
     C                   ENDSR
