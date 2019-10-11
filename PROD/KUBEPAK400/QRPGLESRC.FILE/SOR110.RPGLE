      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SOR110
      *APPLICATION--------- SHIPPED ORDER HISTORY
      *DESCRIPTION--------- INQUIRY BY ITEM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSOR110FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSOHSTI   IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
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
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       997778
     C                   MOVEL     *BLANKS       DESC
     C*                    MOVEL*BLANKS   VITEM
     C*                    MOVEL*BLANKS   VSIZE
     C*                    Z-ADD0         VDATE
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTSHP
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       809918
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
      * ITEM SEARCH
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C                   MOVEL     *BLANKS       IMSIZE
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVE      VSIZE         IMSIZE
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
     C     ITMKEY        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C*                    KFLD           VSHFR
     C     ITMKEY        CHAIN(N)  FMINVT                             90
     C   90              SETON                                        12
     C   12              GOTO      NXTA
     C                   EXSR      GETDES
      *
     C     VSIZE         IFGT      *BLANKS
     C     VSIZE         CHAIN     FMSIZE                             90
     C   90              SETON                                        13
     C   13              GOTO      NXTA
     C                   ENDIF
      *
     C                   MOVEL     VSHFR         WHWHSE            3
     C                   MOVEL     VSHFR         TSHFR             1
     C     TSHFR         IFEQ      '?'
     C     TSHFR         OREQ      '/'
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VSHFR
     C                   MOVEL     WHWHSE        VSHFR
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             90
     C   90              SETON                                        14
     C   14              GOTO      NXTA
     C                   ENDIF
      *
     C     VDATE         IFEQ      *ZEROS
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   SETON                                        77
     C                   Z-ADD     ##CYMD        CBDATE            7 0
      *
     C     NODTE         TAG
      *
     C     RSTRTB        TAG
     C     VITEM         SETLL     FSOHSTI
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTI          TAG
     C                   SETOFF                                       90
     C     VITEM         READE     FSOHSTI                                90
     C   90              GOTO      DSPL
      *
     C     SOCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     SOSIZE        IFNE      VSIZE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     SOWHSE        ANDNE     VSHFR
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C*  77      SOSHDT    IFGT CBDATE
 RP  C   77SOSHDT        IFLT      CBDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     SOUPRI        UPRICE            7 2
      *
     C                   Z-ADD     SOSHDT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SDATE
      *
     C                   Z-ADD     SOQSHP        SHIP
     C                   Z-ADD     SOQORD        ORD
     C                   ADD       ORD           TOTORD            6 0
     C                   ADD       SHIP          TOTSHP            6 0
      *
     C     SOCUST        IFGT      *ZEROS
     C     SOCUST        CHAIN     FMCUST                             90
     C   90              MOVEL     '*** Cust'    DES1             16
     C   90              MOVE      'omer Not'    DES1
     C   90              MOVEL     DES1          DES2             24
     C   90              MOVE      ' On File'    DES2
     C   90              MOVEL     DES2          CNAME
     C  N90              MOVEL     CMNAME        CNAME
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             SOORD#
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   Z-ADD     0             SOCUST
     C                   Z-ADD     0             UPRICE
     C                   MOVEL     *BLANKS       CMNAME
     C                   Z-ADD     0             SDATE
     C                   Z-ADD     TOTORD        ORD
     C                   Z-ADD     TOTSHP        SHIP
     C                   MOVEL     '* End of'    DESC1            16
     C                   MOVE      ' Data * '    DESC1
     C                   MOVE      *BLANKS       CNAME
     C                   MOVEL     DESC1         CNAME
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
     C                   MOVEL     DESCO         DESC             50
     C                   ENDSR
      *
