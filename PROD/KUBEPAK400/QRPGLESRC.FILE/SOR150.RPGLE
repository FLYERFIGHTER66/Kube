      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *     THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *     EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *     METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *     TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *     DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *     BY EXPRESS WRITTEN PERMISSION OF:
      *         EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SOR150
      *APPLICATION--------- SHIPPED ORDER HISTORY
      *DESCRIPTION--------- INQUIRY BY PRODUCT CLASS DETAIL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/03/01 EFD DONOT CLEAR SCREEN A FIELDS.
      *
      *
     FSOR150FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSOHSTPI  IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
      *
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
     C                   SETOFF                                       7778
     C                   Z-ADD     1             CNT               5 0
     C                   MOVEL     *BLANKS       OLPRCL
     C*                    MOVEL*BLANKS   VBPC
     C*                    MOVEL*BLANKS   VEPC
     C*                    Z-ADD0         VBDATE
     C*                    Z-ADD0         VEDATE
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTSHP
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101520
     C                   SETOFF                                       3035
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     VBPC          IFEQ      *BLANKS
     C     VEPC          ANDEQ     *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     1             SUBST     VBPC:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VBPC          PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VBPC
     C                   MOVEL     PCPRCL        VBPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     VEPC:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VEPC          PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VEPC
     C                   MOVEL     PCPRCL        VEPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VBPC          CHAIN(N)  FMPRCL                             90
     C   90              SETON                                        10
     C   10              GOTO      NXTA
      *
     C     VEPC          IFEQ      *BLANKS
     C                   MOVEL     VBPC          VEPC
     C                   ENDIF
      *
     C     VEPC          CHAIN(N)  FMPRCL                             90
     C   90              SETON                                        15
     C   15              GOTO      NXTA
      *
     C     VBPC          IFGT      VEPC
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NOPC          TAG
      *
     C     VSHFR         IFEQ      *BLANKS
     C                   GOTO      NOSHFR
     C                   ENDIF
      *
     C     1             SUBST     VSHFR:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VSHFR         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VSHFR
     C                   MOVEL     WHWHSE        VSHFR
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSHFR         CHAIN     FMWHSE                             90
     C   90              SETON                                        20
     C   20              GOTO      NXTA
      *
     C     NOSHFR        TAG
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
     C                   SETON                                        30
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
     C                   SETON                                        35
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        CEDATE            7 0
      *
     C     CBDATE        IFGT      CEDATE
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NODTE         TAG
      *
     C     RSTRTB        TAG
     C                   MOVEL     VBPC          PI                2
     C     PIKEY         KLIST
     C                   KFLD                    PI
     C     PIKEY         SETLL     FSOHSTPI
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTI          TAG
     C                   SETOFF                                       90
     C                   READ      FSOHSTPI                               90
     C   90              GOTO      DSPL
      *
     C     SOCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     SOITEM        IFEQ      *BLANKS
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     SOPCL1        IFEQ      *BLANKS
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VBPC          IFGT      *BLANKS
     C     SOPCL1        ANDLT     VBPC
     C     SOPCL1        ORGT      VEPC
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     SOWHSE        ANDNE     VSHFR
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
     C   77SOSHDT        IFLT      CBDATE
     C     SOSHDT        ORGT      CEDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     SOITEM        ANDNE     OLITEM
     C     SOSIZE        ORNE      OLSIZE
     C     KEY18         KLIST
     C                   KFLD                    OLITEM
     C                   KFLD                    OLSIZE
     C     KEY18         CHAIN(N)  FMINVT                             90
     C  N90              EXSR      GETDES
     C   90              MOVEL     OLDES1        DESC
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     SOPCL1        ANDNE     OLPRCL
     C                   Z-ADD     PCORD         SHIP
     C                   Z-ADD     PCSHP         ORD
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       OLITEM
     C                   MOVEL     *BLANKS       OLSIZE
     C                   Z-ADD     0             OLDATE
     C                   MOVEL     '* Produc'    DESC1            16
     C                   MOVE      't Class '    DESC1
     C                   MOVEL     DESC1         DESC2            24
     C                   MOVE      'Totals *'    DESC2
     C                   MOVEL     DESC2         DESC
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Z-ADD     0             PCORD
     C                   Z-ADD     0             PCSHP
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   ENDIF
      *
     C                   ADD       SOQSHP        SHIP
     C                   ADD       SOQORD        ORD
     C                   ADD       SOQSHP        PCSHP             8 0
     C                   ADD       SOQORD        PCORD             8 0
     C                   ADD       SOQSHP        TOTSHP            8 0
     C                   ADD       SOQORD        TOTORD            8 0
      *
     C                   MOVEL     SOPCL1        OLPRCL            2
     C                   MOVEL     SOITEM        OLITEM           12
     C                   MOVEL     SOSIZE        OLSIZE            3
     C                   MOVEL     SODES1        OLDES1           30
     C                   Z-ADD     SDATE         OLDATE            6 0
     C                   ADD       1             CNT
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Z-ADD     PCORD         ORD
     C                   Z-ADD     PCSHP         SHIP
     C                   Z-ADD     0             OLDATE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       OLITEM
     C                   MOVEL     *BLANKS       OLSIZE
     C                   MOVEL     '* Produc'    DESC1            16
     C                   MOVE      't Class '    DESC1
     C                   MOVEL     DESC1         DESC2            24
     C                   MOVE      'Totals *'    DESC2
     C                   MOVEL     DESC2         DESC
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   ADD       2             RECNO
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   MOVEL     *BLANKS       OLITEM
     C                   MOVEL     *BLANKS       OLSIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       OLPRCL
     C                   Z-ADD     0             OLDATE            6 0
     C                   Z-ADD     TOTORD        ORD
     C                   Z-ADD     TOTSHP        SHIP
     C                   MOVEL     '* End of'    DESC1            16
     C                   MOVE      ' Data * '    DESC1
     C                   MOVEL     DESC1         DESC
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C                   Z-ADD     0             PCORD
     C                   Z-ADD     0             PCSHP
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
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
     C                   MOVEL     DESCO         DESC             25
     C                   ENDSR
      *
