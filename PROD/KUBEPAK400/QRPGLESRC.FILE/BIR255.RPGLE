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
      *PROGRAM NAME-------- BIR255
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- OPEN ORDER INQUIRY BY ORDER NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR255FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFIORDRSA  IF   E           K DISK
     FFIORDRPARTIF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
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
     D  PORDER                 3      8S 0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   SETOFF                                       99
     C     RSTRTA        TAG
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOTBOO
     C                   Z-ADD     *ZEROS        VORDER
     C                   Z-ADD     1             VCODE
     C                   If        PORDER <> *Zeros
     C                   Eval      VORDER = PORDER
     C                   Z-ADD     1             VCODE
     C                   Goto      SkipScrnA
     C                   EndIf
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131417
     C                   SETOFF                                       408099
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     SkipScrnA     Tag
     C     VORDER        IFEQ      *ZEROS
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VORDER        CHAIN     FHORDR                             10
     C   10              GOTO      RSTRTA
     C                   MOVEL     OHNAME        SNAME
     C                   MOVEL     OHSLD1        BNAME
      *
     C     OHSHFR        CHAIN     FMWHSE                             92
     C  N92              MOVEL     WHDESC        SHPFRM
      *
     C     VSHDAT        IFEQ      0
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     VSHDAT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        25
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SDATE             5 0
     C     NODTE         TAG
      *
     C     VCODE         IFLT      1
     C     VCODE         ORGT      3
     C                   SETON                                        17
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCODE         IFEQ      2
     C                   SETON                                        40
     C                   ENDIF
      *
      * SET FIORDR BACK TO BEGINING OF ORDER
      *
     C     VORDER        SETLL     FIORDRSA
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C                   SETOFF                                       9088
     C     VORDER        READE     FIORDRSA                               90
     C   90              GOTO      DSPL
      *
     C     OIORD#        IFGT      VORDER
     C     RECNO         ANDEQ     0
     C                   SETON                                        8014
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      *  READ IORDR
      *
     C     OHORD#        SETLL     FIORDRSA
     C                   SETOFF                                       90
     C     NXTI          TAG
     C                   SETOFF                                       88
     C     OHORD#        READE     FIORDRSA                               90
     C   90              GOTO      RSTRTB
     C                   MOVE      *BLANKS       DESC
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
     C     OISEQ#        IFGT      989
     C     OIITYP        OREQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C                   SETON                                        88
     C                   ENDIF
      *
     C     VSHDAT        IFEQ      0
     C                   GOTO      NOCHK
     C                   ENDIF
     C                   Z-ADD     OIDTRQ        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ODATE             5 0
     C     ODATE         IFLT      SDATE
     C                   GOTO      NXTI
     C                   ENDIF
     C     NOCHK         TAG
      *
     C                   Z-ADD     OIQORD        QORD
     C                   Z-ADD     OIQSHP        QSHP
     C     OICOFL        IFEQ      'Y'
     C                   Z-ADD     0             QBOO
     C                   ELSE
     C                   Z-ADD     OIQBOO        QBOO
     C                   END
     C                   MOVEL     OIITEM        ITEM
     C     OrderKey      KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     OrderKey      SetLL     FIORDRPART
     C                   Eval      P = ' '
     C                   If        %Equal(FIORDRPART)
     C                   Eval      P = 'P'
     C                   EndIf
      *
     C     OISEQ#        IFLT      989
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
     C                   ENDIF
      *
     C     OISEQ#        IFGT      989
     C     OIITYP        OREQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OIITYP        OREQ      'N'
     C                   MOVEL     OIDES1        DESC
     C                   SETON                                        88
     C                   ENDIF
      *
      *  ITEM HAS BEEN SHIPPED
      *
     C     OISTAT        IFEQ      'D'
     C     OICOFL        ANDEQ     'Y'
     C                   MOVEL     '*'           SHIPD
     C                   ELSE
     C                   MOVEL     ' '           SHIPD
     C                   ENDIF
      *
     C     OISEQ#        IFLT      989
     C                   ADD       OIQORD        TOTQTY           11 1
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       QBOO          TOTBOO           11 1
     C                   ENDIF
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       ITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       OIUUOM
     C                   MOVEL     *BLANKS       OIDES1
     C                   Z-ADD     0             QORD
     C                   Z-ADD     0             QSHP
     C                   Z-ADD     0             QBOO
     C                   Z-ADD     TOTQTY        QORD
     C                   Z-ADD     TOTQTY        QORDT
     C                   Z-ADD     TOTSHP        QSHP
     C                   Z-ADD     TOTBOO        QBOO
     C                   Z-ADD     0             OIDTRQ
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         DESC
     C                   WRITE     RECSFL
     C     CTRL          TAG
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C   KD              DO
     C                   If        CSRRRN = 0
     C                   Eval      CSRRRN = 1
     C                   EndIf
     C     CSRRRN        CHAIN     RECSFL                             30
     C                   CALL      'BIR103'
     C                   PARM                    OIDTRQ
     C                   PARM                    VORDER
     C                   PARM                    QTYCRT            5 2
     C                   PARM      'Y'           SHOWYN            1
     C                   GOTO      CTRL
     C                   ENDDO
     C   KK              DO
     C                   If        CSRRRN = 0
     C                   Eval      CSRRRN = 1
     C                   EndIf
     C     CSRRRN        Chain     RECSFL
     C                   call      'BIR100CLO'
     C                   Parm                    VORDER
     C                   Parm                    OISEQ#
     C                   GOTO      CTRL
     C                   ENDDO
     C   KI              DO
     C                   call      'TRKORDFEX'
     C                   Parm                    VORDER
     C                   GOTO      CTRL
     C                   ENDDO
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
      *
