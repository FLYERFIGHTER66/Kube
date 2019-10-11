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
      *PROGRAM NAME-------- BIR265
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS BY ITEM INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR266FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORDR    IF   E           K DISK
     FFIORDISC  IF   E           K DISK
     FFIORASTD  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFLKITM    IF   E           K DISK
     FFALITEM   IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         VSHDAT
     C                   Z-ADD     1             LCO
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR             3
      *
      *  MAIN FLOW OF PROGRAM
      *
     C     RSTRT         TAG
     C                   SETOFF                                       99
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       VITEM
     C                   MOVEL     *BLANKS       VSIZE
     C                   Z-ADD     1             VCODE
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       303225
     C                   SETOFF                                       809926
     C                   SETOFF                                       354036
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     VITEM         IFEQ      *BLANKS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        261499
     C   26
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VITEM         IFGT      *BLANKS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        261499
     C   26
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VITEM         IFEQ      *BLANKS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        IMLOOK
     C                   MOVE      VSHFR         SHPFR             3
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
     C                   MOVE      *BLANKS       VALPHA
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHSE             3
     C                   MOVEL     IMDES1        DESC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCODE         IFLT      1
     C     VCODE         ORGT      6
     C                   SETON                                        17
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
      * OPEN ITEMS
      *
     C     VCODE         IFEQ      2
     C                   SETON                                        40
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             92
     C   92              SETON                                        35
     C   35              GOTO      RSTRTA
     C                   SETON                                        36
     C                   ENDIF
      * ZERO OUT FIELDS
     C                   Z-ADD     0             TOOH
     C                   Z-ADD     0             LOOH
     C                   Z-ADD     0             TAVAIL
     C                   Z-ADD     0             LOAV
     C                   Z-ADD     0             TAVOPO
     C                   Z-ADD     0             LOONPO
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTSHP
      *
     C  N36              GOTO      ALSHFR
     C     KEYIC         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    VSHFR
     C     KEYIC         CHAIN     FMINVT                             90
     C     KEYIC         CHAIN     FLKITM                             90
      *
     C                   Z-ADD     IMQTOH        LOOH
     C     IMQTOH        SUB       IMQTAL        AVWRK            11 0
     C                   Z-ADD     AVWRK         LOAV
     C     LOAV          ADD       IMQTOO        LOONPO
      *
     C                   EXSR      GETDES
      *
     C     ALSHFR        TAG
     C     KEY18         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     KEY18         SETLL     FMINVT
     C                   Z-ADD     1             FIRST             4 0
     C     AGAIN         TAG
     C                   READ      FMINVT                                 30
     C   30FIRST         IFEQ      1
     C                   SETON                                        2614
     C                   GOTO      RSTRTA
     C                   END
     C     VITEM         IFNE      IMITEM
     C     VSIZE         ORNE      IMSIZE
     C     FIRST         IFEQ      1
     C                   SETON                                        2614
     C   26              GOTO      RSTRTA
     C                   END
     C                   ENDIF
     C     FIRST         IFEQ      1
     C                   EXSR      GETDES
     C                   END
     C     VITEM         IFNE      IMITEM
     C     VSIZE         ORNE      IMSIZE
     C     FIRST         ANDGT     1
     C                   GOTO      NOREC
     C                   ENDIF
      *
     C                   ADD       1             FIRST
     C                   ADD       IMQTOH        TOOH
     C     IMQTOH        SUB       IMQTAL        AVWRK            11 0
     C                   ADD       AVWRK         TAVAIL
     C                   ADD       AVWRK         TAVOPO
     C                   ADD       IMQTOO        TAVOPO
     C                   GOTO      AGAIN
      *
     C     NOREC         TAG
      *  N36               MOVEL'ALL'     VSHFR
      *
      * SET FIORDR BACK TO BEGINING OF ITEM
      *
     C     KITEM         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     KITEMD        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    RVSDT
     C     VSHDAT        IFGT      0
     C                   Z-ADD     VSHDAT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVSDT             7 0
     C                   ELSE
     C                   Z-ADD     0             RVSDT
     C                   ENDIF
     C     KITEMD        SETLL     FIORDISC
     C     KITEMD        SETLL     FIORASTD
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C                   SETOFF                                       9091
     C     KITEM         READE     FIORDISC                               90
     C     KITEM         READE     FIORASTD                               91
     C     NXTI          TAG
     C   90
     CAN 91              GOTO      DSPL
     C   90
     CANN91              GOTO      IAST
     C  N90
     CAN 91              GOTO      IORD
      ** PRINT REGULAR ORDERS FIRST
     C     OIRVDT        IFLE      IARVDT
     C                   GOTO      IORD
     C                   ELSE
     C                   GOTO      IAST
     C                   END
      * IORDR READ
     C     IORD          TAG
     C   36OISHFR        IFNE      VSHFR
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C   40OISTAT        IFEQ      'D'
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C     OIQSHP        ANDEQ     0
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OICOFL        IFEQ      'Y'
     C     VCODE         ANDEQ     2
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OICOFL        IFEQ      'N'
     C     VCODE         ANDEQ     3
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OIORD#        CHAIN     FHORDR                             92
     C   92              GOTO      ENDIOR
     C                   MOVEL     OHNAME        NAME
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OHPOS         IFNE      'S'
     C     VCODE         ANDEQ     4
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OHPOS         IFNE      'F'
     C     VCODE         ANDEQ     5
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OHPOS         IFNE      'P'
     C     VCODE         ANDEQ     6
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     VSHDAT        IFGT      *ZEROS
     C                   Z-ADD     OIDTRQ        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVODT             7 0
     C                   ENDIF
      *
     C     VSHDAT        IFGT      *ZEROS
     C     RVODT         ANDLT     RVSDT
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C     OICOFL        IFEQ      'Y'
     C     OIQSHP        ANDNE     OIQORD
     C                   GOTO      ENDIOR
     C                   ENDIF
      *
     C                   Z-ADD     OIQORD        QTY
     C                   ADD       QTY           TOTQTY            5 0
     C                   Z-ADD     OIQSHP        SHP
     C                   ADD       SHP           TOTSHP            5 0
      *
      * ITEM HAS BEEN SHIPPED
      *
     C     OICOFL        IFEQ      'Y'
     C                   MOVEL     '*'           SHIPD
     C                   ELSE
     C                   MOVEL     *BLANKS       SHIPD
     C                   ENDIF
      * GET SUBFILE FIELD NAMES
     C                   MOVEL     OISHFR        SHFR              3
     C                   Z-ADD     OIDTRQ        DTRQ
     C                   MOVEL     ' '           AST               1
     C                   Z-ADD     OISOW         #CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    #CYMD             7 0          DATE CYYMMDD
     C                   PARM                    #MDY              6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     #MDY          SOWDAT
      ** CHECK IF LOTC
     C     OILOTC        IFEQ      'Y'
     C     ALIKEY        KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     ALIKEY        CHAIN     FALITEM                            57
     C**                   Z-ADDAICUST    SPCD
     C                   SETON                                        57
     C                   ELSE
     C                   SETOFF                                       57
     C                   END
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     ENDIOR        TAG
     C     KITEM         READE     FIORDISC                               90
     C   90              Z-ADD     0             OIRVDT
     C                   GOTO      NXTI
      *
      * IORDAST READ
     C     IAST          TAG
     C   36IASHFR        IFNE      VSHFR
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C   40IASTAT        IFEQ      'D'
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C     IACOFL        IFEQ      'Y'
     C     VCODE         ANDEQ     2
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C     IACOFL        IFNE      'Y'
     C     VCODE         ANDEQ     3
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C     IAORD#        CHAIN     FHORDR                             92
     C   92              GOTO      ENDIST
     C                   MOVEL     OHNAME        NAME
      *
     C     VSHDAT        IFGT      *ZEROS
     C                   Z-ADD     IADTRQ        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVODT             7 0
     C                   ENDIF
     C     VSHDAT        IFGT      *ZEROS
     C     RVODT         ANDLT     RVSDT
     C                   GOTO      ENDIST
     C                   ENDIF
      * 11/19/96 TEMP FIX
     C     IACOFL        IFEQ      'Y'
     C     IAQSHP        ANDNE     IAQORD
     C                   GOTO      ENDIST
     C                   ENDIF
      *
     C                   Z-ADD     IAQORD        QTY
     C                   ADD       QTY           TOTQTY            5 0
     C                   Z-ADD     IAQSHP        SHP
     C                   ADD       SHP           TOTSHP            5 0
      *
      *  ITEM HAS BEEN SHIPPED
      *
     C*****      IACOFL    IFEQ 'Y'
     C     IAQORD        IFLE      IAQSHP
     C                   MOVEL     '*'           SHIPD
     C                   ELSE
     C                   MOVEL     *BLANKS       SHIPD
     C                   ENDIF
      * GET SUBFILE FIELD NAMES
     C                   MOVEL     IASHFR        SHFR
     C                   Z-ADD     IADTRQ        DTRQ
     C                   MOVEL     'A'           AST
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C     ENDIST        TAG
     C     KITEM         READE     FIORASTD                               91
     C   91              Z-ADD     0             IARVDT
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C     RECNO         IFEQ      0
     C     LKSAL         ANDEQ     0
     C                   SETON                                        8014
     C                   GOTO      RSTRT
     C                   ENDIF
     C                   ADD       2             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   Z-ADD     0             SOWDAT
     C                   MOVEL     *ZEROS        OHCUST
     C                   MOVEL     *BLANKS       OHPOS
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OISIZE
     C*                    MOVEL*BLANKS   DESC
     C                   MOVEL     *BLANKS       OIUUOM
     C                   MOVEL     *BLANKS       AST
     C                   MOVEL     *BLANKS       SHFR
     C                   MOVEL     *BLANKS       NAME
     C                   Z-ADD     TOTQTY        QTY
     C                   Z-ADD     TOTSHP        SHP
     C                   Z-ADD     0             DTRQ
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         NAME
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C                   GOTO      RSTRT
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
     C                   MOVEL     DESCO         DESC             40
     C                   ENDSR
      *
