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
      *PROGRAM NAME-------- BIR240
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS BY CUSTOMER INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/10/01 EFD CHANGE TO FIT ON SMALL SCREEN. PER BILL
      *  5/10/01 EFD DO NOT CLEAR SCREEN A FIELDS. PER BILL
      *
      *
     FBIR240FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORCSBL  IF   E           K DISK
     FFHORWOR   IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
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
      *  MAIN FLOW OF PROGRAM
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     *ZEROS        VCUST
     C                   Z-ADD     1             VCODE
     C                   Z-ADD     1             VINCL
     C                   Z-ADD     TDATE         VSHDAT
     C                   SETOFF                                       99
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       CMNAME
     C*                    Z-ADD*ZEROS    VCUST
     C*                    Z-ADD1         VCODE
     C*                    Z-ADD1         VINCL
     C*                    Z-ADDTDATE     VSHDAT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       203035
     C                   SETOFF                                       4581
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
     C                   SETON                                        1012
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCUST         IFGT      *ZEROS
     C     VTELE         ANDGT     *BLANKS
     C                   SETON                                        1012
     C                   GOTO      RSTRTA
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
      *
     C     VCUST         CHAIN     FMCUST                             31
     C   31              SETON                                        1011
     C   11              GOTO      NXTA
     C                   MOVEL     CMNAME        CUSNAM           30
      *
     C     VSHDAT        IFEQ      0
     C                   GOTO      NODAT
     C                   ENDIF
      *
     C                   Z-ADD     VSHDAT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
     C     NODAT         TAG
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
     C     VSHFR         CHAIN     FMWHSE                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTA
     C                   ENDIF
      *
     C     VCODE         IFLT      1
     C     VCODE         ORGT      3
     C                   SETON                                        35
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCODE         IFEQ      2
     C                   SETON                                        40
     C                   ELSE
     C                   SETOFF                                       40
     C                   END
      *
     C     VINCL         IFLT      1
     C     VINCL         ORGT      4
     C                   SETON                                        45
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTSHP
     C**                   Z-ADD0         TOTAMT
      *
      * SET FHORDR BACK TO BEGINING OF CUSTOMER
      *
     C     VCUST         SETLL     FHORCSBL
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C                   SETOFF                                       9088
     C     VCUST         READE     FHORCSBL                               90
     C   90              GOTO      DSPL
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VPONO         IFGT      *BLANKS
     C     OHPONO        ANDNE     VPONO
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     OHSHFR        ANDNE     VSHFR
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OHORD#        CHAIN     FHORWOR                            92
     C  N92              Z-ADD     WHINV#        ORD#              6 0
     C   92              Z-ADD     OHORD#        ORD#
     C                   MOVEL     OHNAME        SNAME            13
      *
      *  READ IORDR
      *
     C     OHORD#        SETLL     FIORDR
     C                   Z-ADD     0             OLORD#            6 0
     C                   SETOFF                                       90
     C     NXTI          TAG
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      RSTRTB
      *
     C   40OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C     OIQSHP        ANDEQ     *ZEROS
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OICOFL        IFEQ      'Y'
     C     VCODE         ANDEQ     2
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OICOFL        IFNE      'Y'
     C     VCODE         ANDEQ     3
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VSHDAT        IFGT      *ZEROS
     C                   Z-ADD     VSHDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVSDT             7 0
     C                   ENDIF
      *
     C     OIRVDT        IFLT      RVSDT
     C                   GOTO      NXTI
     C                   END
      *
     C     VINCL         IFEQ      1
     C     OISEQ#        ANDGT     989
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VINCL         IFEQ      1
     C     OIITYP        ANDNE     ' '
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VINCL         IFLT      3
     C     OISIZE        ANDEQ     'TAG'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VINCL         IFEQ      3
     C     OISIZE        ANDNE     'TAG'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OIORD#        IFEQ      OLORD#
     C                   SETON                                        88
     C                   ENDIF
      *
     C     OISEQ#        IFLE      990
     C     OIITYP        ANDNE     'C'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'S'
     C     OIITYP        ANDNE     'N'
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        DESC
     C                   ENDIF
      *
     C                   Z-ADD     OIQORD        QTY
     C**                   Z-ADDOIQSHP    QTYS
     C*                    Z-ADDOIUPRI    UPRICE
     C*                    Z-ADDOIEXT$    EXT     82
     C*                    ADD  EXT       TOTAMT  82
     C     OISEQ#        IFLE      990
     C     OISIZE        ANDNE     'ROY'
     C                   ADD       OIQORD        TOTQTY           11 1
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ENDIF
      *
     C     OISIZE        IFEQ      'ROY'
     C                   Z-ADD     *ZEROS        QTY
     C                   ENDIF
      *
      *  ITEM HAS BEEN SHIPPED
      *
     C                   MOVEL     ' '           SHIPD
     C     OIQSHP        IFGE      OIQORD
     C     OISTAT        ANDEQ     'D'
     C     OICOFL        ANDEQ     'Y'
     C                   MOVEL     '*'           SHIPD
     C**                   Z-ADDOHDTAC    OIDTRQ
     C                   ELSE
     C                   MOVEL     *BLANKS       SHIPD
     C                   ENDIF
      ** SMALL SCREEN FIELDS
     C                   MOVEL     OHPONO        PONO
     C                   MOVEL     OIITEM        ITEM
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Z-ADD     OHORD#        OLORD#            6 0
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             ORD#
     C                   Z-ADD     0             OHDTOR
     C                   MOVEL     *BLANKS       ITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       OIUUOM
     C                   Z-ADD     TOTQTY        QTY
     C**                   Z-ADDTOTSHP    QTYS
     C**                   Z-ADDTOTAMT    EXT
     C**                   Z-ADD0         UPRICE
     C                   Z-ADD     0             OIDTRQ
     C                   Z-ADD     0             OICUST
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     *BLANKS       SNAME
     C                   MOVEL     *BLANKS       PONO
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      ' **     '    DESC1
     C                   MOVEL     DESC1         DESC
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
     C                   MOVEL     DESCO         DESC
     C                   ENDSR
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
