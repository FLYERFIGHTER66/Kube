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
      *PROGRAM NAME-------- SOR140
      *APPLICATION--------- SHIPPED ORDER HISTORY
      *DESCRIPTION--------- INQUIRY BY PRODUCT CLASS SUMMARY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/03/01 EFD DONOT CLEAR SCREEN A FIELDS.
      *
      *
     FSOR140FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSOHSTPI  IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
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
     D  LCANCL               133    133
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       997778
     C                   Z-ADD     1             CNT
     C*                    MOVEL*BLANKS   OLPRCL
     C                   MOVEL     *BLANKS       OLDESC
     C                   MOVEL     *BLANKS       VDESC
     C*                    MOVEL*BLANKS   VSHFR
     C*                    Z-ADD0         VBDATE
     C*                    Z-ADD0         VEDATE
     C                   Z-ADD     0             TOTDOL
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   Z-ADD     0             DOL
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       809918
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C                   MOVEL     VSHFR         TSHFR             1
     C     TSHFR         IFEQ      '?'
     C     TSHFR         OREQ      '/'
     C                   MOVEL     VSHFR         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VSHFR
     C                   MOVEL     WHWHSE        VSHFR
     C                   MOVEL     WHDESC        VDESC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             90
     C   90              SETON                                        14
     C   14              GOTO      NXTA
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
     C     CBDATE        IFGT      CEDATE
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NODTE         TAG
      *
     C     RSTRTB        TAG
     C                   MOVEL     *BLANKS       PI                2
     C     PIKEY         KLIST
     C                   KFLD                    PI
     C     PIKEY         SETLL     FSOHSTPI
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C     NXTI          TAG
     C                   SETOFF                                       90
     C                   READ      FSOHSTPI                               90
     C   90              GOTO      DSPL
      *
     C     SOCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     SOPCL1        IFEQ      *BLANKS
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     SOWHSE        ANDNE     VSHFR
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   77SOSHDT        IFLT      CBDATE
     C     SOSHDT        ORGT      CEDATE
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
     C     SOPCL1        CHAIN(N)  FMPRCL                             90
     C   90              MOVEL     '** Inval'    DES1             16
     C   90              MOVE      'id Produ'    DES1
     C   90              MOVEL     DES1          DES2             24
     C   90              MOVE      'ct Class'    DES2
     C   90              MOVEL     DES2          PCDESC
      *
     C     CNT           IFGT      1
     C     SOPCL1        ANDNE     OLPRCL
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Z-ADD     0             SHIP
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             DOL
     C                   ENDIF
      *
     C                   ADD       1             CNT               6 0
     C                   MOVEL     SOPCL1        OLPRCL            2
     C                   MOVEL     PCDESC        OLDESC           30
     C                   ADD       SOQSHP        SHIP
     C                   ADD       SOQORD        ORD
     C                   ADD       SOEXT$        DOL
     C                   ADD       SOQSHP        TOTSHP            8 0
     C                   ADD       SOQORD        TOTORD            8 0
     C                   ADD       SOEXT$        TOTDOL           10 2
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   ADD       2             RECNO
     C                   Z-ADD     0             DOL
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   MOVEL     *BLANKS       OLPRCL
     C                   MOVEL     *BLANKS       OLDESC
     C                   Z-ADD     TOTORD        ORD
     C                   Z-ADD     TOTSHP        SHIP
     C                   Z-ADD     TOTDOL        DOL
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         OLDESC
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
