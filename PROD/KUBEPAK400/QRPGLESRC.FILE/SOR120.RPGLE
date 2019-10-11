      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
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
      *PROGRAM NAME-------- SOR120
      *APPLICATION--------- SHIPPED ORDER HISTORY
      *DESCRIPTION--------- INQUIRY BY CUSTOMER AND ITEM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/03/01 EFD DONOT CLEAR SCREEN A FIELDS.
      *
      *
     FSOR120FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSOHSTCI  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       997778
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       CMNAME
     C*                    MOVEL*BLANKS   VITEM
     C*                    MOVEL*BLANKS   VSIZE
     C*                    MOVEL*BLANKS   VALPHA
     C                   MOVEL     *BLANKS       VSHFR
     C*                    Z-ADD0         VBDATE
     C*                    Z-ADD0         VEDATE
     C*                    Z-ADD0         VCUST
     C                   Z-ADD     0             TOTAMT
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTSHP
     C     NXTA          TAG
     C                   MOVEL     *BLANKS       CMNAME
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       202122
     C                   SETOFF                                       301880
     C                   SETOFF                                       405088
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     VTELE         ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C     VTELE         ANDGT     *BLANKS
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        VCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     VTELE         ANDGT     *BLANKS
     C                   MOVEL     VTELE         CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VTELE
     C                   Z-ADD     CMCUST        VCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         CHAIN     FMCUST                             90
     C   90              SETON                                        1011
     C   11              GOTO      RSTRTA
      *
      * ITEM SEARCH
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C                   MOVEL     *BLANKS       VSHFR             3
     C     11            SUBST     VITEM:2       IMLOOK
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    VSHFR
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VSHFR
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     ITMKEY        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C*                    KFLD           VSHFR
     C     ITMKEY        CHAIN(N)  FMINVT                             90
     C   90              SETON                                        50
     C   50              GOTO      NXTA
     C                   EXSR      GETDES
      *
     C     1             SUBST     VSIZE:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSIZE         IFGT      *BLANKS
     C     VSIZE         CHAIN     FMSIZE                             90
     C   90              SETON                                        13
     C   13              GOTO      NXTA
     C                   ENDIF
      *
     C     VBDATE        IFEQ      0
     C     VEDATE        ANDEQ     0
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     VBDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
     C                   SETON                                        77
     C                   Z-ADD     ##CYMD        CBDATE            7 0
      *
     C     VEDATE        IFEQ      0
     C                   Z-ADD     VBDATE        VEDATE
     C                   ENDIF
      *
     C                   Z-ADD     VEDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        CEDATE            7 0
      *
     C                   SETON                                        78
      *
     C     CBDATE        IFGT      CEDATE
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NODTE         TAG
      *
     C     VSHFR         IFEQ      *BLANKS
     C                   GOTO      NOSHFR
     C                   ENDIF
      *
     C                   MOVEL     VSHFR         TSHFR             1
     C     TSHFR         IFEQ      '?'
     C     TSHFR         OREQ      '/'
     C                   MOVEL     VSHFR         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VSHFR
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        40
     C   40              GOTO      NXTA
     C                   ENDIF
      *
     C                   SETON                                        88
      *
     C     NOSHFR        TAG
      *
     C     RSTRTB        TAG
     C     CIKEY         KLIST
     C                   KFLD                    VCUST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     CIKEY         SETLL     FSOHSTCI
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTI          TAG
     C                   SETOFF                                       90
     C     CIKEY         READE     FSOHSTCI                               90
     C   90              GOTO      DSPL
      *
     C     SOCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     SOSHDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SDATE             6 0
      *
      *
     C   77SOSHDT        IFLT      CBDATE
     C     SOSHDT        ORGT      CEDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   88SOWHSE        IFNE      VSHFR
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     SOQSHP        SHIP
     C                   Z-ADD     SOQORD        ORD
     C                   Z-ADD     SOUPRI        PRICE             8 4
     C                   Z-ADD     SOEXT$        TOTAL             8 2
     C                   ADD       ORD           TOTORD            6 0
     C                   ADD       SHIP          TOTSHP            6 0
     C                   ADD       TOTAL         TOTAMT            8 2
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             SOORD#
     C                   Z-ADD     0             SOINV#
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   Z-ADD     0             PRICE
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             SDATE
     C                   MOVEL     *BLANKS       SOPONO
     C                   MOVEL     '** Total'    DESC1            15
     C                   MOVE      's **   '     DESC1
     C                   MOVE      DESC1         SOPONO
     C                   Z-ADD     TOTORD        ORD
     C                   Z-ADD     TOTSHP        SHIP
     C                   Z-ADD     TOTAMT        TOTAL
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
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
     C                   MOVEL     DESCO         DESC             45
     C                   ENDSR
      *
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            30
     C                   ENDSR
      *
