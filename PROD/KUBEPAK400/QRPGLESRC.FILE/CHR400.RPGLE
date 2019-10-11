      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- CHR400
      **PROGRAMMER---------- REP
      **APPLICATION--------- REVIEW WEEKLY SPRAY INPUT BY SPRAYER
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FCHR400FM  CF   E             WORKSTN
     F                                     SFILE(SPYSFL:RECNO)
     F                                     SFILE(RECSFL:RECN1)
     FFCHMCTL   IF   E           K DISK
     FFCHMRUN3  IF   E           K DISK
     F                                     RENAME(RCHMRUN:CHMRUN)
     FFCHMRUN4  UF   E           K DISK
     FFCHMJOB   UF   E           K DISK
     FFCHMTOT2  UF   E           K DISK
     FFCHMOZS   IF   E           K DISK
      ****FFCHMOZS1IF  E           K        DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
      *
      ** MESSSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGES
      *
      ** SCREEN DESCRIPTION ARRAY
     D DC              S             10    DIM(42)                              DESC  10
     D SPR             S              4    DIM(42)                              SPRC  10
      ** TOTOL  FILE  ARRAYS
     D IT              S             12    DIM(42)                              ITEM NUMBERS
     D SZ              S              3    DIM(42)                              SIZE CODES
     D PM              S              7  2 DIM(42)                              PPM
     D GL              S              5  0 DIM(42)                              PPM
     D OZ              S              5  2 DIM(42)                              OZ/GAL
     D PL              S              5  0 DIM(42)                              ML/GAL
     D SP              S              4    DIM(42)                              SPRAY
     D TR              S              5  0 DIM(42)                              PPM
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROID                  1     10
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      ***********************
      ** START OR RESTART  **
      ***********************
     C**
     C*****       KEYS
     C**
     C     RU4KEY        KLIST
     C                   KFLD                    CRWKDT
     C                   KFLD                    CRJOB#
     C**
     C     RUNKEY        KLIST
     C                   KFLD                    CRWKDT
     C                   KFLD                    CRSPRY
     C                   KFLD                    CRSPIT
     C                   KFLD                    CRSPSZ
     C                   KFLD                    CRPPM
     C**
     C     JOBKEY        KLIST
     C                   KFLD                    STRDAT
     C                   KFLD                    CJJOB#
     C**
     C     TOTKEY        KLIST
     C                   KFLD                    CTWKDT
     C**
     C     SUBKEY        KLIST
     C                   KFLD                    CTWKDT
     C                   KFLD                    CTLOOK
     C                   KFLD                    CTSPRY
     C                   KFLD                    CTSPIT
     C                   KFLD                    CTPPM
     C**
     C**
     C     HDRKEY        KLIST
     C                   KFLD                    CRWKDT
     C                   KFLD                    CRLOOK
     C                   KFLD                    CRSPRY
     C                   KFLD                    CRSPIT
     C                   KFLD                    CRPPM
     C**
     C     ADDKEY        KLIST
     C                   KFLD                    XXWKDT
     C                   KFLD                    IMLOOK
     C                   KFLD                    XXSPRY
     C                   KFLD                    XXSPIT
     C                   KFLD                    XXPPM
     C**
     C     OZSKEY        KLIST
     C                   KFLD                    COITEM
     C                   KFLD                    COPPM
     C**
     C     MINJOB        KLIST
     C                   KFLD                    CRSPIT
     C                   KFLD                    CRSPSZ
     C********************************************************************
     C**
     C     RSTART        TAG
     C*                    Z-ADD0         FRMDAT
     C*                    Z-ADD0         BEGYY
     C*                    Z-ADD0         BEGWW
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KB              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       1299
      **
      ** CHECK DATE
      **
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C     FRMDAT        CHAIN     FCALEN                             92
     C   92              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
     C*    CL#Y          IFNE      1
     C*                  SETON                                        101199
     C*                  GOTO      NXTA
     C*                  END
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   Z-ADD     CLCYMD        STRDAT            7 0
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   Z-ADD     CLCYMD        STRDAT            7 0
     C                   END                                                    FRMDAT > 0
     C**
      ** CHECK CONTROL FILE
     C**
     C     STRDAT        CHAIN(N)  FCHMCTL                            12
     C   12              DO
     C                   SETON                                        102099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   EXSR      BLDSPY
      ******************
      ** SPRAY SUBFILE *
      ******************
     C     NXTSPY        TAG
     C                   EXFMT     SPYCTL
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   EXSR      CHKSPY
     C                   EXSR      BLDSPY
     C                   GOTO      NXTSPY
      ******************
      ** END PROGRAM  **
      ******************
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SPRAY SFILE **
      ***********************
     C     BLDSPY        BEGSR
     C                   SETON                                        80
     C                   WRITE     SPYCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             X
     C                   MOVE      *BLANKS       DISP
     C                   MOVE      STRDAT        CTWKDT
     C     TOTKEY        SETLL     FCHMTOT2
     C     PASS          TAG
     C                   ADD       1             X
     C     TOTKEY        READE     FCHMTOT2                               95
     C     *IN95         DOWEQ     *OFF
     C**
     C                   MOVEL     CTSPIT        IT(X)
     C                   MOVEL     CTPOLE        PL(X)
     C                   MOVEL     CTSPRY        SP(X)
     C                   MOVEL     CTLOOK        DC(X)
     C                   Z-ADD     CTPPM         PM(X)
     C                   MOVE      CTGALS        GL(X)
     C                   MOVE      CTTRAY        TR(X)
     C                   MOVEL     CTLOOK        DESC1
     C**
     C                   MOVE      CTSPIT        COITEM
     C                   Z-ADD     CTPPM         COPPM
     C     OZSKEY        CHAIN     FCHMOZS                            92
     C     *IN92         IFEQ      *OFF
     C     CTGALS        MULT      COOUNS        OZS               5 2
     C                   MOVE      OZS           OZ(X)
     C                   Z-ADD     OZ(X)         OUNCE
     C                   END
     C**
     C                   Z-ADD     PM(X)         PPM
     C                   MOVEA     SP(X)         SPRAY
     C                   MOVEA     PL(X)         POLES
     C                   Z-ADD     GL(X)         GAL
     C                   Z-ADD     TR(X)         TRAYS
     C***
     C                   ADD       1             RECNO
     C***
     C                   WRITE     SPYSFL
     C                   GOTO      PASS
     C                   ENDDO
     C***
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   MOVEL     MSG(1)        DESC1
     C                   Z-ADD     0             POLES
     C                   Z-ADD     0             OUNCE
     C                   Z-ADD     0             GAL
     C                   Z-ADD     0             PPM
     C                   Z-ADD     0             TRAYS
     C                   Z-ADD     0             X
     C                   ADD       1             RECNO
     C                   MOVE      *BLANKS       SPRAY             4
     C                   WRITE     SPYSFL
     C                   ENDSR
      ***********************
      **  CHECK SPRAY      **
      ***********************
     C     CHKSPY        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C                   MOVE      *BLANKS       OPTION
     C     RECNO         IFLE      LSTREC
     C     RECNO         CHAIN     SPYSFL                             90
     C   90              GOTO      NXTCHK
     C     DISP          IFEQ      'R'
     C                   MOVEA     SP(X)         SPRAY
     C                   MOVEA     DC(X)         DES
     C                   MOVEA     IT(X)         ITEM
     C                   Z-ADD     PM(X)         PPM
RPADDC     *IN75         IFEQ      *OFF
RPADDC                   Z-ADD     TR(X)         C1TRAY
RPADDC                   Z-ADD     GL(X)         C1GAL
RPADDC                   Z-ADD     PL(X)         C1POLE
RPADDC**
RPADDC                   MOVE      IT(X)         COITEM
RPADDC                   Z-ADD     PPM           COPPM
RPADDC     OZSKEY        CHAIN     FCHMOZS                            92
RPADDC     *IN92         IFEQ      *OFF
RPADDC     C1GAL         MULT      COOUNS        OZS               5 2
RPADDC                   Z-ADD     OZS           C1OUZ
RPADDC                   END
RPADDC                   END
     C**
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       8075
     C**
     C                   Z-ADD     0             RECN1             5 0
     C                   MOVE      STRDAT        CRWKDT
     C                   MOVEA     SP(X)         WRSPRY            4
     C                   MOVEL     WRSPRY        CRSPRY
     C                   MOVEA     IT(X)         CRSPIT
     C                   MOVEL     '700'         CRSPSZ
     C                   Z-ADD     PPM           CRPPM
     C     RUNKEY        SETLL     FCHMRUN3
     C     NXTNCK        TAG
     C     RUNKEY        READE     FCHMRUN3                               91
     C     *IN91         DOWEQ     *OFF
     C**
     C                   MOVE      CRJOB#        CJJOB#
     C     JOBKEY        CHAIN     FCHMJOB                            95
     C**
     C     MINJOB        CHAIN     FMINVT                             94
     C     CRNOS         IFEQ      'N'
     C                   MOVEL     'North'       DIRECT
     C                   ELSE
     C                   MOVEL     'South'       DIRECT
     C                   END
     C**
     C                   ADD       1             RECN1
     C                   WRITE     RECSFL
     C                   GOTO      NXTNCK
     C                   ENDDO                                                  N91 DO
     C**
     C     RECN1         IFGE      1
     C                   Z-ADD     RECN1         LSTN1             5 0
     C     NXTNC1        TAG
     C                   EXFMT     RECCTL
     C   KF              GOTO      ENDCHK
     C                   Z-ADD     0             CHNG              5 0
     C                   Z-ADD     0             RECN1
     C     NXTNC2        TAG
     C                   ADD       1             RECN1
     C     RECN1         IFLE      LSTN1
     C     RECN1         CHAIN     RECSFL                             90
     C   90              GOTO      NXTNC2
CAB  C                   CLEAR                   XXJOB#
CAB  C                   CLEAR                   XXSECT
CAB  C                   CLEAR                   XXBAY
CAB  C                   CLEAR                   XXNOS
CAB  C                   CLEAR                   XXSPOL
CAB  C                   CLEAR                   XXSLOR
CAB  C                   CLEAR                   XXEPOL
CAB  C                   CLEAR                   XXELOR
     C     OPTION        IFEQ      'C'
     C                   MOVE      CRJOB#        XXJOB#            6 0
CAB  C                   MOVE      CRSECT        XXSECT            2 0
CAB  C                   MOVE      CRBAY         XXBAY             2 0
CAB  C                   MOVE      CRNOS         XXNOS             1
CAB  C                   MOVE      CRSPOL        XXSPOL            2 0
CAB  C                   MOVE      CRSLOR        XXSLOR            1
CAB  C                   MOVE      CREPOL        XXEPOL            2 0
CAB  C                   MOVE      CRELOR        XXELOR            1
     C                   EXSR      RECCHG
RPADDC                   MOVE      *ON           *IN75
     C                   ADD       1             CHNG
     C                   ENDIF                                                  OPTION=C
     C     CHNG          IFGT      0
     C                   SUB       1             RECNO
     C                   GOTO      NXTCHK
     C                   END                                                    CHNG>1
     C                   GOTO      NXTNC2
     C                   END                                                    RECN1<LSTN1
     C                   GOTO      NXTNC1
     C                   END
     C                   END
     C                   GOTO      NXTCHK
     C                   END
     C     ENDCHK        ENDSR
      ***********************
      ** GET CHANGES        *
      ***********************
     C***
     C     RECCHG        BEGSR
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       1920
     C                   Z-ADD     0             NEWSL
     **
      ** BUILD BOTTOM OF SCREEN
     **
     C     RUNKEY        CHAIN     FCHMRUN3                           91
     C     DC(1)         IFGT      *BLANKS
     C                   Z-ADD     1             SL#               2 0
     C                   SETON                                        01
     C                   MOVEL     DC(SL#)       DES01
     C                   MOVEL     SP(SL#)       SPR01
     C                   Z-ADD     PM(SL#)       PPM01
     C                   END
     C     DC(2)         IFGT      *BLANKS
     C                   Z-ADD     2             SL#
     C                   SETON                                        02
     C                   MOVEL     DC(SL#)       DES02
     C                   MOVEL     SP(SL#)       SPR02
     C                   Z-ADD     PM(SL#)       PPM02
     C                   END
     C     DC(3)         IFGT      *BLANKS
     C                   Z-ADD     3             SL#
     C                   SETON                                        03
     C                   MOVEL     DC(SL#)       DES03
     C                   MOVEL     SP(SL#)       SPR03
     C                   Z-ADD     PM(SL#)       PPM03
     C                   END
     C     DC(4)         IFGT      *BLANKS
     C                   Z-ADD     4             SL#
     C                   SETON                                        04
     C                   MOVEL     DC(SL#)       DES04
     C                   MOVEL     SP(SL#)       SPR04
     C                   Z-ADD     PM(SL#)       PPM04
     C                   END
     C     DC(5)         IFGT      *BLANKS
     C                   Z-ADD     5             SL#
     C                   SETON                                        05
     C                   MOVEL     DC(SL#)       DES05
     C                   MOVEL     SP(SL#)       SPR05
     C                   Z-ADD     PM(SL#)       PPM05
     C                   END
     C     DC(6)         IFGT      *BLANKS
     C                   Z-ADD     6             SL#
     C                   SETON                                        06
     C                   MOVEL     DC(SL#)       DES06
     C                   MOVEL     SP(SL#)       SPR06
     C                   Z-ADD     PM(SL#)       PPM06
     C                   END
     C     DC(7)         IFGT      *BLANKS
     C                   Z-ADD     7             SL#
     C                   SETON                                        07
     C                   MOVEL     DC(SL#)       DES07
     C                   MOVEL     SP(SL#)       SPR07
     C                   Z-ADD     PM(SL#)       PPM07
     C                   END
     C     DC(8)         IFGT      *BLANKS
     C                   Z-ADD     8             SL#
     C                   SETON                                        08
     C                   MOVEL     DC(SL#)       DES08
     C                   MOVEL     SP(SL#)       SPR08
     C                   Z-ADD     PM(SL#)       PPM08
     C                   END
     C     DC(9)         IFGT      *BLANKS
     C                   Z-ADD     9             SL#
     C                   SETON                                        09
     C                   MOVEL     DC(SL#)       DES09
     C                   MOVEL     SP(SL#)       SPR09
     C                   Z-ADD     PM(SL#)       PPM09
     C                   END
     C     DC(10)        IFGT      *BLANKS
     C                   Z-ADD     10            SL#
     C                   SETON                                        10
     C                   MOVEL     DC(SL#)       DES10
     C                   MOVEL     SP(SL#)       SPR10
     C                   Z-ADD     PM(SL#)       PPM10
     C                   END
     C     DC(11)        IFGT      *BLANKS
     C                   Z-ADD     11            SL#
     C                   SETON                                        11
     C                   MOVEL     DC(SL#)       DES11
     C                   MOVEL     SP(SL#)       SPR11
     C                   Z-ADD     PM(SL#)       PPM11
     C                   END
     C     DC(12)        IFGT      *BLANKS
     C                   Z-ADD     12            SL#
     C                   SETON                                        12
     C                   MOVEL     DC(SL#)       DES12
     C                   MOVEL     SP(SL#)       SPR12
     C                   Z-ADD     PM(SL#)       PPM12
     C                   END
     C     DC(13)        IFGT      *BLANKS
     C                   Z-ADD     13            SL#
     C                   SETON                                        13
     C                   MOVEL     DC(SL#)       DES13
     C                   MOVEL     SP(SL#)       SPR13
     C                   Z-ADD     PM(SL#)       PPM13
     C                   END
     C     DC(14)        IFGT      *BLANKS
     C                   Z-ADD     14            SL#
     C                   SETON                                        14
     C                   MOVEL     DC(SL#)       DES14
     C                   MOVEL     SP(SL#)       SPR14
     C                   Z-ADD     PM(SL#)       PPM14
     C                   END
     C     DC(15)        IFGT      *BLANKS
     C                   Z-ADD     15            SL#
     C                   SETON                                        15
     C                   MOVEL     DC(SL#)       DES15
     C                   MOVEL     SP(SL#)       SPR15
     C                   Z-ADD     PM(SL#)       PPM15
     C                   END
     C     DC(16)        IFGT      *BLANKS
     C                   Z-ADD     16            SL#
     C                   SETON                                        16
     C                   MOVEL     DC(SL#)       DES16
     C                   MOVEL     SP(SL#)       SPR16
     C                   Z-ADD     PM(SL#)       PPM16
     C                   END
     C     DC(17)        IFGT      *BLANKS
     C                   Z-ADD     17            SL#
     C                   SETON                                        17
     C                   MOVEL     DC(SL#)       DES17
     C                   MOVEL     SP(SL#)       SPR17
     C                   Z-ADD     PM(SL#)       PPM17
     C                   END
     C     DC(18)        IFGT      *BLANKS
     C                   Z-ADD     18            SL#
     C                   SETON                                        18
     C                   MOVEL     DC(SL#)       DES18
     C                   MOVEL     SP(SL#)       SPR18
     C                   Z-ADD     PM(SL#)       PPM18
     C                   END
     C     DC(19)        IFGT      *BLANKS
     C                   Z-ADD     19            SL#
     C                   SETON                                        19
     C                   MOVEL     DC(SL#)       DES19
     C                   MOVEL     SP(SL#)       SPR19
     C                   Z-ADD     PM(SL#)       PPM19
     C                   END
     C     DC(20)        IFGT      *BLANKS
     C                   Z-ADD     20            SL#
     C                   SETON                                        20
     C                   MOVEL     DC(SL#)       DES20
     C                   MOVEL     SP(SL#)       SPR20
     C                   Z-ADD     PM(SL#)       PPM20
     C                   END
     C**
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
     C**
     C   KC              GOTO      ENDC
     C**
      ** CHECK NEW CHEMICAL
     C**
     C     NEWSL         IFGT      0
     C                   EXSR      SUBRUN
     C                   EXSR      ADDRUN
     C                   END
     C   KC              GOTO      ENDC
     C     ENDC          TAG
     C**
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       161718
     C                   SETOFF                                       1920
     C                   SETOFF                                       30
     C                   ENDSR
      ***********************
      ** SUBRUN SUBROUTINE **
      ***********************
     C     SUBRUN        BEGSR
     C**
     C                   Z-ADD     NEWSL         SL#
     C                   Z-ADD     XXJOB#        CRJOB#
     C                   MOVE      STRDAT        NRWKDT            7 0
     C**                   MOVE STRDAT    NRWKDT  70
     C                   MOVEL     IT(SL#)       NRSPIT           12
     C                   MOVEL     DC(SL#)       NRLOOK           15
     C                   MOVEL     SP(SL#)       NRSPRY            5
     C                   MOVEL     '700'         NRSPSZ            5
     C                   MOVEL     PM(SL#)       NRPPM             7 2
     C**
     C     RU4KEY        CHAIN     FCHMRUN4                           89
     C**
     C                   MOVE      CRJOB#        CJJOB#
     C     JOBKEY        CHAIN     FCHMJOB                            95
     C**
     C                   MOVE      STRDAT        CTWKDT
     C                   MOVE      CRLOOK        CTLOOK
     C                   MOVE      CRSPIT        CTSPIT           12
     C                   MOVE      CRSPRY        CTSPRY            5
     C                   MOVEL     '700'         CTSPSZ            3
     C                   MOVE      CRPPM         CTPPM             7 2
     C**
     C                   Z-ADD     0             XXGALS
     C                   Z-ADD     0             WRKTRY
     C                   Z-ADD     0             WRPOLE
     C                   Z-ADD     0             WRKPOL
     C                   Z-ADD     0             WRKGAL
     C                   Z-ADD     0             GALWRK
     C                   Z-ADD     0             GALS
     C                   Z-ADD     0             TST44
     C**
     C     SUBKEY        CHAIN     FCHMTOT2                           88
     C     *IN88         IFEQ      *OFF
     C***
     C     CRTRAY        DIV       100           GALWRK            9 4
     C                   MOVEL     GALWRK        GALS              5 0
     C                   MOVE      GALWRK        TST44             4 4
     C     TST44         IFGT      .0000
     C                   ADD       1             GALS
     C                   MOVEL     GALS          WRKGAL            5 0
     C     CTGALS        SUB       WRKGAL        XXGALS            5 0
     C                   Z-ADD     XXGALS        CTGALS
RPADDC                   Z-ADD     CTGALS        C1GAL
     C                   END
     C***
     C     CTTRAY        SUB       CRTRAY        WRKTRY            5 0
     C     CRTRAY        DIV       55            WRPOLE            5 0
     C     CTPOLE        SUB       WRPOLE        WRKPOL            5 0
     C                   Z-ADD     WRKPOL        CTPOLE
RPADDC                   Z-ADD     CTPOLE        C1POLE
     C                   Z-ADD     WRKTRY        CTTRAY
RPADDC                   Z-ADD     CTTRAY        C1TRAY
     C                   END
     C**
RPADDC                   MOVE      CTSPIT        COITEM
RPADDC                   Z-ADD     CTPPM         COPPM
RPADDC     OZSKEY        CHAIN     FCHMOZS                            92
RPADDC     *IN92         IFEQ      *OFF
RPADDC     C1GAL         MULT      COOUNS        OZS               5 2
RPADDC                   Z-ADD     OZS           C1OUZ
RPADDC                   END
     C**
     C**
     C                   MOVEL     NRSPIT        CRSPIT
     C                   MOVEL     NRSPRY        CRSPRY
rpaddC                   MOVEL     NRLOOK        CRLOOK
     C                   MOVEL     NRPPM         CRPPM
     C**
     C                   MOVEL     NRSPIT        CJSPIT
     C                   MOVEL     NRPPM         CJPPM
     C**
     C                   UPDATE    RCHMRUN
     C                   UPDATE    RCHMJOB
     C                   UPDATE    RCHMTOT1
     C**
     C                   ENDSR
      ***********************
      ** ADDRUN SUBROUTINE **
      ***********************
     C     ADDRUN        BEGSR
     C**
     C                   Z-ADD     0             YYGALS
     C                   Z-ADD     0             YYTRAY
     C                   Z-ADD     0             YYPOLE
     C**
     C                   Z-ADD     NEWSL         SL#
     C                   MOVE      STRDAT        XXWKDT            7 0
rpaddC                   MOVE      CRLOOK        IMLOOK
     C                   MOVEL     IT(SL#)       XXSPIT           12
     C                   MOVEL     SP(SL#)       XXSPRY            5
     C                   MOVEL     '700'         XXSPSZ            3
     C                   MOVEL     PM(SL#)       XXPPM             7 2
     C**
     C     ADDKEY        CHAIN     FCHMTOT2                           88
     C     *IN88         IFEQ      *OFF
     C***
     C     CTGALS        ADD       WRKGAL        YYGALS            5 0
     C                   Z-ADD     YYGALS        CTGALS
     C     CTPOLE        ADD       WRPOLE        YYPOLE            5 0
     C                   Z-ADD     YYPOLE        CTPOLE
     C     CTTRAY        ADD       CRTRAY        YYTRAY            5 0
     C                   Z-ADD     YYTRAY        CTTRAY
     C                   END
     C**
     C                   UPDATE    RCHMTOT1
     C**
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C     CALKY1        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKY1        CHAIN     FCALEX                             92
     C                   Z-ADD     CLDATE        FRMDAT
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   ENDSR
**  MESSAGES
* End *
