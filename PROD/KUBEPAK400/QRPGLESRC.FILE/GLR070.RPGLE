      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-        GLR070
      *SYSTEM-              GENERAL LEDGER
      *APPLICATION-         ENTER ALLOCATIONS JOURNAL ENTRIES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGLR070FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFGLALO    UF A E           K DISK
     FFGLALOIN  IF   E           K DISK
     F                                     RENAME(RGLALO:GLALOI)
     FFGLALOTO  IF   E           K DISK
     F                                     RENAME(RGLALO:GLALOT)
     FFMGLCH    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFGLCTL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
      *
      * TYPE DESCRIPTIONS
     D MSG             S              9    DIM(4) CTDATA PERRCD(1)              TYPE DESC
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
     D ERR1            DS            60    OCCURS(1) INZ
     D  J1                     1     20    INZ('Already Allocated On')
     D  J2                    21     29    INZ(' Prefix: ')
     D  JEPR1                 30     31
     D  J3                    32     40    INZ(' Number: ')
     D  JENM1                 41     46  0
     D  J4                    47     55    INZ(' Suffix: ')
     D  JESF1                 56     57
     D ERR2            DS            70    OCCURS(1) INZ
     D  K1                     1      4    INZ('Used')
     D  K2                     5     23    INZ(' As An Allocate To ')
     D  K3                    24     42    INZ('Account On Prefix: ')
     D  JEPR2                 43     44
     D  K4                    45     53    INZ(' Number: ')
     D  JENM2                 54     59  0
     D  K5                    60     68    INZ(' Suffix: ')
     D  JESF2                 69     70
      *
     IGLALOI
     I              GASTAT                      ISTAT
     I              GACOMP                      ICOMP
     I              GAJEPR                      IJEPR
     I              GAJENM                      IJENM
     I              GAJESF                      IJESF
     I              GASEQ#                      ISEQ#
     I              GAJEDS                      IJEDS
     I              GAFRAC                      IFRAC
     I              GATOAC                      ITOAC
     I              GAPCT                       IAPCT
     I              GA$AMT                      I$AMT
     I              GADDES                      IDDES
     I              GAJETP                      IJETP
     I              GADTLA                      IDTLA
     I              GATIME                      ITIME
     I              GAUSER                      IUSER
      *
     IGLALOT
     I              GASTAT                      ISTAT
     I              GACOMP                      ICOMP
     I              GAJEPR                      IJEPR
     I              GAJENM                      IJENM
     I              GAJESF                      IJESF
     I              GASEQ#                      ISEQ#
     I              GAJEDS                      IJEDS
     I              GAFRAC                      IFRAC
     I              GATOAC                      ITOAC
     I              GAPCT                       IAPCT
     I              GA$AMT                      I$AMT
     I              GADDES                      IDDES
     I              GAJETP                      IJETP
     I              GADTLA                      IDTLA
     I              GATIME                      ITIME
     I              GAUSER                      IUSER
      *
      ***********************
      ** MAIN LINE CODE    **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             JENM
     C                   Z-ADD     0             JENMO             6 0
     C                   Z-ADD     0             OFRMAC            8 0
     C                   Z-ADD     0             FRMACT
     C                   MOVE      *BLANKS       GCDESC
     C                   MOVE      *BLANKS       JEPR
     C                   MOVE      *BLANKS       JEPRO             2
     C                   MOVEL     'AL'          JESF
     C                   MOVEL     'AL'          JESFO             2
     C                   MOVE      *BLANKS       JEDS
     C                   MOVE      '0'           *IN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C**                   WRITESCRNW1
      ** FUNCTION KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       103025
     C                   SETOFF                                       202122
     C                   SETOFF                                       404142
     C                   SETOFF                                       464748
     C                   SETOFF                                       99
      ** ACTION CODE
     C     ACTION        IFNE      'A'
     C     ACTION        ANDNE     'C'
     C     ACTION        ANDNE     'D'
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
     C                   CLEAR                   RGLALO
     C     GLRKEY        CHAIN     FGLALO                             77
     C   77ACTION        IFNE      'A'
     C                   SETON                                        202199
     C                   GOTO      NXTA
     C                   END
     C  N77ACTION        IFEQ      'A'
     C                   SETON                                        202299
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     JENM          JENMO
     C                   MOVEL     JEPR          JEPRO
     C                   MOVEL     JESF          JESFO
     C  N77              DO
     C                   MOVEL     GAJEDS        JEDS
     C                   Z-ADD     GAFRAC        FRMACT
     C     FRMKEY        CHAIN     FMGLCH                             40
     C                   GOTO      NXTA
     C                   ENDDO
     C                   END
      * DESCRIPTION
     C     JEDS          IFLE      *BLANKS
     C                   SETON                                        30  99
     C                   GOTO      NXTA
     C                   END
      ** ACCOUNT NUMBER
     C   KB              DO
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVE      *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   Z-ADD     GCGLNO        FRMACT
     C                   GOTO      NXTA
     C                   ENDDO
     C     FRMKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    FRMACT
     C     FRMKEY        CHAIN     FMGLCH                             40
     C   40              DO
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDDO
      * CANNOT USE PROFIT/LOSS ACCOUNT
     C     FRMACT        IFEQ      GDINC$
     C                   SETON                                        404199
     C                   GOTO      NXTA
     C                   END
     C     FRMKEY        CHAIN     FGLALOIN                           90
     C  N90JEPR          IFNE      IJEPR
     C     JENM          ORNE      IJENM
     C     JESF          ORNE      IJESF
     C                   SETON                                        404647
     C                   SETON                                        42
     C                   MOVEL     IJEPR         JEPR1
     C                   Z-ADD     IJENM         JENM1
     C                   MOVEL     IJESF         JESF1
     C                   WRITE     SCRNA1
     C                   GOTO      NXTA
     C                   ENDIF
     C     FRMKEY        CHAIN     FGLALOTO                           90
     C  N90              DO
     C                   SETON                                        404648
     C                   SETON                                        42
     C                   MOVEL     IJEPR         JEPR2
     C                   Z-ADD     IJENM         JENM2
     C                   MOVEL     IJESF         JESF2
     C                   WRITE     SCRNA1
     C                   GOTO      NXTA
     C                   ENDDO
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     GCATYP        TYPE              1 0
     C                   MOVEL     GCDESC        FRMDES
     C                   MOVEL     MSG(TYPE)     FRTDES
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       139899
     C                   SETOFF                                       11
     C                   SETOFF                                       313233
     C                   SETOFF                                       40  99
      * GET ACCOUNT INFO
     C                   EXSR      BLDSFL
      * DISPLAY SUB FILE
     C     NXTSFL        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     RECCTL
      * F KEYS
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
     C                   Z-ADD     0             TOTPCT
     C                   Z-ADD     0             TOTBAL
     C                   Z-ADD     0             GASEQ#
     C     GLRKEY        SETLL     FGLALO
     C     NXTBLD        TAG
     C     GLRKEY        READE     FGLALO                                 90
     C   90              GOTO      ENDBLD
     C                   Z-ADD     GATOAC        GLNO
     C                   Z-ADD     GAPCT         PCT
     C                   ADD       PCT           TOTPCT
     C**                   MOVELGJDDES    DESC
     C                   ADD       1             RECNO
     C     GLCKEY        CHAIN     FMGLCH                             90
     C                   MOVEL     GCDESC        ODESC
     C                   MOVEL     GCDESC        DESC
     C                   MOVEL     MSG(GCATYP)   TOTYPE
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     GASEQ#        LSTSEQ            3 0
     C     RECNO         ADD       50            TSTREC            5 0
     C                   Z-ADD     0             PCT
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             GASEQ#
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C                   MOVE      *BLANKS       TOTYPE
     C     NXTBD1        TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     RECNO         IFLT      TSTREC
     C                   GOTO      NXTBD1
     C                   END
     C     100           SUB       TOTPCT        TOTBAL
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** BUILD MORE RECS   **
      ***********************
     C     BLDMOR        BEGSR
     C     LSTREC        ADD       50            TSTREC            5 0
     C                   Z-ADD     0             PCT
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             GASEQ#
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C                   MOVE      *BLANKS       TOTYPE
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
     C                   Z-ADD     0             TOTPCT
     C                   Z-ADD     0             TOTBAL
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       111213
     C                   SETOFF                                       1415
     C                   SETOFF                                       32  40
     C                   SETOFF                                           99
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
     C                   SETOFF                                       102030
     C     GLNO          IFLE      0
     C                   Z-ADD     0             PCT
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C                   MOVE      *BLANKS       TOTYPE
     C                   SETOFF                                       102030
     C                   GOTO      NCGL
     C                   END
     C     GLCKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLNO
     C     GLCKEY        CHAIN     FMGLCH                             90
     C   90              SETON                                        101199
     C   90              MOVE      *BLANKS       DESC
     C   90              MOVE      *BLANKS       TOTYPE
     C  N90              DO
     C     GLNO          IFEQ      FRMACT
     C                   SETON                                        101299
     C                   END
      ** CANNOT USE PROFIT/LOSS ACCOUNT
     C     GLNO          IFEQ      GDINC$
     C                   SETON                                        101399
     C                   END
     C     GLCKEY        CHAIN     FGLALOIN                           90
     C  N90              DO
     C                   SETON                                        101499
     C                   ENDDO
     C     GCATYP        IFNE      TYPE
     C                   SETON                                        102015
     C                   SETON                                        99
     C                   END
     C                   ENDDO                                                  N90 DO
     C     PCT           IFLT      0.01
     C     PCT           ORGT      99.99
     C                   SETON                                        303299
     C                   END
     C     DESC          IFEQ      ODESC
     C                   MOVEL     GCDESC        DESC
     C                   MOVEL     GCDESC        ODESC
     C                   END
     C                   MOVEL     MSG(GCATYP)   TOTYPE
     C                   ADD       PCT           TOTPCT
      ** NO GL NUMBER ENTERED
     C     NCGL          TAG
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     100           SUB       TOTPCT        TOTBAL
     C  N99TOTBAL        IFNE      0.00
     C                   SETON                                        4099
     C                   END
     C  N99              SETON                                        98
     C   99              SETOFF                                       98
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
     C                   KFLD                    GASEQ#
     C     GWRKYD        CHAIN     FGLALO                             88
     C     GLNO          IFLE      0
     C     GASEQ#        IFGT      0
     C  N88              DELETE    RGLALO
     C                   END                                                    GASEQ#>0
     C                   GOTO      NXTPUT
     C                   END                                                    GLNO=0
      * IF HERE GOOD RECORD
     C     GASEQ#        IFLE      0
     C                   ADD       1             LSTSEQ
     C                   Z-ADD     LSTSEQ        GASEQ#
     C                   END
     C                   Z-ADD     0             GA$AMT
     C                   Z-ADD     PCT           GAPCT
     C                   Z-ADD     LCO           GACOMP
     C                   MOVEL     JEPR          GAJEPR
     C                   Z-ADD     JENM          GAJENM
     C                   MOVEL     JESF          GAJESF
     C                   MOVEL     JEDS          GAJEDS
     C                   MOVEL     DESC          GADDES
     C                   MOVEL     'A'           GASTAT
     C  N88              Z-ADD     TDATE         GAUPDT
     C                   Z-ADD     FRMACT        GAFRAC
     C                   Z-ADD     GLNO          GATOAC
     C                   MOVE      *BLANKS       GAJETP
     C   88              DO
     C                   Z-ADD     TDATE         GAENDT
     C                   END
     C                   Z-ADD     TDATE         GADTLA
     C                   Z-ADD     TIMOD         GATIME
     C                   MOVEL     USERID        GAUSER
     C  N88              UPDATE    RGLALO
     C   88              WRITE     RGLALO
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
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
     C     LCO           CHAIN(N)  FGLDF                              90
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
** TYPE DESCRIPTION
Asset
Liability
Income
Expense
