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
      *PROGRAM NAME-------- BIR245
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS BY CUSTOMER INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR248FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORDRSP  IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     D                UDS
     D  LCO                    1      2  0
      *
      * MAIN FLOW OF PROGRAM
      *
     C                   SETOFF                                       99
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       VPONO
     C                   Z-ADD     0             VCUST
     C                   Z-ADD     1             VCODE
     C                   Z-ADD     1             VINCL
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       303540
     C                   SETOFF                                       809918
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
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
     C     VCUST         CHAIN     FMCUST                             31
     C   31              SETON                                        1011
     C   11              GOTO      NXTA
     C                   MOVEL     CMNAME        SNAME
     C     CMBLCU        CHAIN     FMCUST                             90
     C                   MOVEL     CMNAME        BNAME
      *
     C     VCODE         IFLT      1
     C     VCODE         ORGT      3
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCODE         IFEQ      2
     C                   SETON                                        40
     C                   ENDIF
      *
     C     VINCL         IFLT      1
     C     VINCL         ORGT      3
     C                   SETON                                        35
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     0             TOTQTY
      *
      * SET FHORDR BACK TO BEGINING OF CUSTOMER
      *
     C     VCUST         SETLL     FHORDRSP
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C     VCUST         READE     FHORDRSP                               90
     C   90              GOTO      DSPL
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OHCUST        IFGT      VCUST
     C     RECNO         ANDEQ     0
     C                   SETON                                        8014
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPONO         IFGT      *BLANKS
     C     OHPONO        ANDNE     VPONO
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      *  READ IORDR
      *
     C     OHORD#        SETLL     FIORDR
     C                   SETOFF                                       90
     C     NXTI          TAG
     C                   SETOFF                                       88
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      RSTRTB
      *
     C   40OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C     OIQSHP        ANDEQ     0
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
     C     VINCL         IFEQ      1
     C     OISEQ#        ANDGT     990
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VINCL         IFEQ      1
     C     OISIZE        ANDEQ     'TAG'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VINCL         IFEQ      1
     C     OIITYP        ANDNE     ' '
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VINCL         IFEQ      2
     C     OISIZE        ANDNE     'TAG'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OISEQ#        IFLT      990
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C                   ENDIF
      *
     C     OISEQ#        IFGT      990
     C     OIITYP        OREQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C                   MOVEL     OIDES1        DESC
     C                   SETON                                        88
     C                   ENDIF
      *
     C                   Z-ADD     OIQORD        QTY
     C     OISEQ#        IFLT      900
     C                   ADD       OIQORD        TOTQTY           11 1
     C                   ENDIF
      *
      * ITEM HAS BEEN SHIPPED
      *
     C                   MOVEL     ' '           SHIPD
     C     OISTAT        IFEQ      'D'
     C     OICOFL        ANDEQ     'Y'
     C                   MOVEL     '*'           SHIPD
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVEL     *BLANKS       OHPONO
     C                   MOVEL     *BLANKS       DESC
     C                   Z-ADD     TOTQTY        QTY
     C                   Z-ADD     0             OIDTRQ
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVEL     DESC1         DESC
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
     C                   MOVEL     DESCO         DESC             22
     C                   ENDSR
      *
