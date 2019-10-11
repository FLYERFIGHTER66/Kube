      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES  1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- GRS350
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- ALLOCATIONS BY ORDER NUMBER
      **DESCRIPTION--------- THIS PROGRAM DISPLAYS ALL LINE ITEMS THAT
      **                     EXIST FOR ANY SELECTED OPEN ORDER.
      *
      *
     FGRS350FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFIORDR    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFALITEM   IF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C                   SETOFF                                       99
     C     RSTRTA        TAG
     C                   Z-ADD     *ZEROS        VORDER
     C                   Z-ADD     1             FIRST             3 0
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       8099
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     VORDER        IFEQ      *ZEROS
     C                   SETON                                        101499
     C   10
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VORDER        CHAIN     FALITEM                            90
     C   90              SETON                                        1114
     C   11              GOTO      RSTRTA
      *
     C     VORDER        CHAIN     FHORDR                             90
      *
      * SET FIORDR BACK TO BEGINING OF ORDER
      *
     C     VORDER        SETLL     FIORDR
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C     NXTI          TAG
     C                   Z-ADD     1             FIRST
     C                   Z-ADD     *ZEROS        TIALL
     C                   SETOFF                                       9088
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      DSPL
      *
     C     OICOFL        IFEQ      'Y'
     C     OISTAT        OREQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OIITYP        IFNE      ' '
     C     OISIZE        OREQ      'TAG'
     C     OISIZE        OREQ      'ROY'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OIQORD        SUB       OIQSHP        QOPEN             6 0
     C                   SETON                                        50
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     FIRST         IFEQ      1
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C                   SETON                                        88
     C                   ENDIF
      *
     C     KEY9          KLIST
     C                   KFLD                    VORDER
     C                   KFLD                    OISEQ#
     C     KEY9          SETLL     FALITEM
      *
     C                   Z-ADD     1             ALLOC             4 0
     C     NXTA          TAG
     C     KEY9          READE     FALITEM                                91
     C   91ALLOC         IFEQ      1
     C                   SETON                                        14
     C                   GOTO      NALL
     C                   ENDIF
     C     NOALL         TAG
     C   91              SETON                                        50
     C   91              GOTO      TOTITM
     C                   ADD       1             ALLOC
      *
     C                   Z-ADD     AICRDY        NCRDY             6 0
     C     NCRDY         MULT      100.0001      CRDY              6 0
     C                   Z-ADD     AISOWD        NSOWD             6 0
     C     NSOWD         MULT      100.0001      SOWD              6 0
     C                   Z-ADD     AIQTOA        QALLOC            6 0
     C                   ADD       AIQTOA        TIALL             6 0
      *
     C     FIRST         IFGT      1
     C                   SETOFF                                       88
     C                   MOVEL     *BLANKS       DESC
     C                   ENDIF
      *
     C     NALL          TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   ADD       1             FIRST
     C                   Z-ADD     0             QOPEN
     C   14              GOTO      NOALL
     C                   GOTO      NXTA
      *
     C     TOTITM        TAG
     C                   ADD       1             RECNO
     C                   Z-ADD     TIALL         QALLOC
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       AICLOC
     C                   MOVEL     *BLANKS       AIGLOC
     C                   MOVEL     *BLANKS       AICPHY
     C                   MOVEL     *BLANKS       AIPHYT
     C                   MOVEL     *BLANKS       AICODE
     C                   Z-ADD     0             CRDY
     C                   Z-ADD     *ZEROS        OIDTRQ
     C                   Z-ADD     0             SOWD
     C                   MOVEL     '* Item T'    DESC1            16
     C                   MOVE      'otals * '    DESC1
     C                   MOVE      DESC1         DESC
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             QOPEN
     C                   Z-ADD     0             QALLOC
     C                   Z-ADD     *ZEROS        OIDTRQ
     C                   Z-ADD     *ZEROS        CRDY
     C                   Z-ADD     *ZEROS        SOWD
     C                   MOVEL     *BLANKS       AICLOC
     C                   MOVEL     *BLANKS       AIGLOC
     C                   MOVEL     *BLANKS       AICPHY
     C                   MOVEL     *BLANKS       AIPHYT
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       AICODE
     C                   Z-ADD     0             OIDTRQ
     C                   MOVEL     '* End of'    DESC1            16
     C                   MOVE      ' Order *'    DESC1
     C                   MOVE      DESC1         DESC
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             32
     C                   ENDSR
      *
