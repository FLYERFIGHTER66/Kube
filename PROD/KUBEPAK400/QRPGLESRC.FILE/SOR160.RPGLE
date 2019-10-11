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
      *PROGRAM NAME-------- SOR160
      *APPLICATION--------- SHIPPED ORDER HISTORY
      *DESCRIPTION--------- INQUIRY BY ORDER NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 5/20/00 EFD01 MOVE ** NOT ON FILE ** DESCRIPTIONS IF REC DEL
      *
      *
     FSOR160FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSOHSTO   IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
EFD01D MSG             S             30    DIM(2) CTDATA PERRCD(1)
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
     C                   Z-ADD     *ZEROS        TOTQTY
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       809918
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     VORDER        IFEQ      *ZEROS
     C                   SETON                                        14
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VORDER        CHAIN(N)  FSOHSTO                            90
     C   90              SETON                                        14
     C   14              GOTO      NXTA
      *
EFD01C                   MOVEL     *BLANKS       CMNAME
     C     SOCUST        CHAIN(N)  FMCUST                             90
EFD01C   90              MOVEL     MSG(1)        CMNAME
EFD01C   90              MOVE      SOLOOK        CMNAME
      *
     C                   Z-ADD     *ZEROS        SOCUST
     C                   Z-ADD     *ZEROS        SOSHDT
      *
     C     VORDER        SETLL     FSOHSTO
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTI          TAG
     C                   SETOFF                                       90
     C     VORDER        READE     FSOHSTO                                90
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
     C                   Z-ADD     SOQSHP        QTY
     C                   ADD       QTY           TOTQTY            6 0
      *
EFD01C   90              MOVEL     *BLANKS       DESC
     C     SOITEM        IFGT      *BLANKS
     C     KEY18         KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    SOWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C  N90              EXSR      GETDES
EFD01C   90              MOVEL     SODES1        DESC
EFD01C     DESC          IFEQ      *BLANKS
EFD01C                   MOVEL     MSG(2)        DESC
EFD01C                   MOVEL     SOITAL        ITAL             11
EFD01C                   MOVE      ITAL          DESC
EFD01C                   ENDIF
     C*  90                MOVEL'*** Item'DES1   16
     C*  90                MOVE ' Not On 'DES1
     C*  90                MOVELDES1      DES2   24
     C*  90                MOVE 'File ***'DES2
     C*  90                MOVELDES2      DESC
     C                   ELSE
EFD01C                   MOVEL     SODES1        DESC
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             SOORD#
     C                   Z-ADD     0             SOORDT
     C                   Z-ADD     0             QTY
     C                   MOVEL     *BLANKS       SOITEM
     C                   MOVEL     *BLANKS       SOSIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       SOUUOM
     C                   Z-ADD     0             SDATE
     C                   Z-ADD     TOTQTY        QTY
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
     C                   MOVEL     DESCO         DESC             26
     C                   ENDSR
EFD01 *
**
* Cust Deleted-
* Item Deleted-
