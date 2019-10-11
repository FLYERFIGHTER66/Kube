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
      *PROGRAM NAME-------- SOR180
      *APPLICATION--------- SHIPPED ORDER HISTORY
      *DESCRIPTION--------- INQUIRY BY CUSTOMER/PURCHASE ORDER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/03/01 EFD DONOT CLEAR SCREEN A FIELDS.
      *
      *
     FSOR180FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSOHSTCP  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
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
     C                   MOVEL     *BLANKS       CMNAME
     C**                   Z-ADD*ZEROS    VCUST
     C**                   Z-ADD*ZEROS    VDATE
     C                   Z-ADD     *ZEROS        TOTORD
     C                   Z-ADD     *ZEROS        TOTSHP
     C                   Z-ADD     *ZEROS        TOTAMT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       20
     C                   SETOFF                                       809918
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     VCUST         IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1114
     C   11              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1214
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      *ZEROS
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
     C     VCUST         CHAIN     FMCUST                             31
     C   31              SETON                                        1114
     C   11              GOTO      RSTRTA
      *
     C     VDATE         IFEQ      0
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   SETON                                        77
     C                   Z-ADD     ##CYMD        CBDATE            7 0
      *
     C     NODTE         TAG
      *
     C     VCUST         SETLL     FSOHSTCP
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTI          TAG
     C                   SETOFF                                       90
     C     VCUST         READE     FSOHSTCP                               90
     C   90              GOTO      DSPL
      *
     C     SOCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   77SOSHDT        IFLT      CBDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     SOSHDT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SDATE
      *
     C                   Z-ADD     SOQORD        ORD
     C                   Z-ADD     SOQSHP        SHIP
     C                   ADD       SHIP          TOTSHP            6 0
     C                   ADD       ORD           TOTORD            6 0
     C                   ADD       SOEXT$        TOTAMT            9 2
      *
     C     SOITEM        IFEQ      *BLANKS
     C                   GOTO      NOITEM
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    SOWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C  N90              EXSR      GETDES
     C  N90              GOTO      DESOK
     C     NOITEM        TAG
     C     SODES1        IFGT      *BLANKS
     C                   MOVEL     SODES1        DESC
     C                   ENDIF
     C     SODES1        IFEQ      *BLANKS
     C                   MOVEL     '*** Item'    DES1             16
     C                   MOVE      ' Not On '    DES1
     C                   MOVEL     DES1          DES2             24
     C                   MOVE      'File ***'    DES2
     C                   MOVEL     DES2          DESC
     C                   ENDIF
     C     DESOK         TAG
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             SOORD#
     C                   Z-ADD     0             SOINV#
     C                   Z-ADD     0             SOORDT
     C                   Z-ADD     0             ORD
     C                   Z-ADD     0             SHIP
     C                   MOVEL     *BLANKS       SOPONO
     C                   MOVEL     *BLANKS       SOITEM
     C                   MOVEL     *BLANKS       SOSIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       SOUUOM
     C                   Z-ADD     0             SDATE
     C                   Z-ADD     TOTSHP        SHIP
     C                   Z-ADD     TOTORD        ORD
     C                   Z-ADD     TOTAMT        SOEXT$
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         DESC
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
     C                   MOVEL     DESCO         DESC             33
     C                   ENDSR
      *
