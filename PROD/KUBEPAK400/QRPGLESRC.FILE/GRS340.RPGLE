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
      **PROGRAM NAME-------- GRS340
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- ALLOCATIONS BY ITEMNUMBER
      **DESCRIPTION--------- THIS PROGRAM DISPLAYS ALL LINE ITEMS THAT
      **                     EXIST FOR ANY SELECTED AN ITEM
      *
      *
     FGRS340FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFALITEML  IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C                   SETOFF                                       99
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       VITEM
     C                   MOVEL     *BLANKS       VSIZE
     C                   Z-ADD     1             FIRST             3 0
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       8099
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C                   MOVEL     *BLANKS       IMLOOK           15
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVEL     '   '         SHPFR
     C                   CALL      'ITMALOOK'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHSE             3
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VITEM         IFEQ      *BLANKS
     C                   SETON                                        1014
     C   10              GOTO      NXT
     C                   ENDIF
      *
     C     VSIZE         IFEQ      '? '
     C                   MOVEL     VSIZE         SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    OIWHSE            3
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        1014
     C   10              GOTO      NXT
      *
     C                   EXSR      GETDES
      *
     C     KEY15         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE             3
     C     KEY15         CHAIN     FALITEML                           90
     C   90              SETON                                        1114
     C   11              GOTO      RSTRTA
      *
      * SET FALITEM BACK TO BEGINING OF ITEM
      *
     C     KEY15         SETLL     FALITEML
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TALLOC
     C     NXTI          TAG
     C                   Z-ADD     1             FIRST
     C                   SETOFF                                       9088
     C     KEY15         READE     FALITEML                               90
     C   90              GOTO      DSPL
      *
     C     AIORD#        CHAIN     FHORDR                             94
     C     KEY9          KLIST
     C                   KFLD                    AIORD#
     C                   KFLD                    AIOSEQ
     C     KEY9          CHAIN     FIORDR                             95
     C     OIQORD        SUB       OIQSHP        QOPEN             6 0
     C     QOPEN         IFLE      *ZEROS
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     AICRDY        NCRDY             6 0
     C     NCRDY         MULT      100.0001      CRDY              6 0
     C                   Z-ADD     AISOWD        NSOWD             6 0
     C     NSOWD         MULT      100.0001      SOWD              6 0
     C                   Z-ADD     AIQTOA        QALLOC            6 0
     C                   ADD       QALLOC        TALLOC            6 0
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             QOPEN
     C                   Z-ADD     TALLOC        QALLOC
     C                   Z-ADD     *ZEROS        OIDTRQ
     C                   Z-ADD     *ZEROS        CRDY
     C                   Z-ADD     *ZEROS        SOWD
     C                   MOVEL     *BLANKS       AICLOC
     C                   MOVEL     *BLANKS       AIGLOC
     C                   MOVEL     *BLANKS       AICPHY
     C                   MOVEL     *BLANKS       AIPHYT
     C                   MOVEL     *BLANKS       OHNAME
     C                   MOVEL     *BLANKS       AICODE
     C                   Z-ADD     0             OIDTRQ
     C                   Z-ADD     0             OISEQ#
     C                   Z-ADD     0             AIORD#
     C                   Z-ADD     0             OHORD#
     C                   MOVEL     '* End of'    DESC1            16
     C                   MOVE      ' Data  *'    DESC1
     C                   MOVE      DESC1         OHNAME
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
     C                   MOVEL     *BLANKS       DESCO            80
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             80
     C                   ENDSR
      *
