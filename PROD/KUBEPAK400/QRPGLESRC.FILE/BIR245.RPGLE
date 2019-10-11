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
      *            CHANGE--DATE-------DESCRIPTION
      *  3/24/00 EFD CHANGE INCLUDE COMMENTS 2
      *  5/02/01 EFD DO NOT CLEAR SCREEN A FIELDS
      *
     FBIR245FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORDR    IF   E           K DISK
     FFIORCDO   IF   E           K DISK
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
     D  VCUST@               200    205
      ** CANCEL  X=CANCEL  O=Edit_Order
     D  LCANCL                62     62
      *
     C                   TESTN                   VCUST@               60
     C   60              Eval      VCUST = %Int(%Trim(VCUST@))
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR
     C                   Z-ADD     TDATE         VSHDAT
      *
      *  MAIN FLOW OF PROGRAM
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       CMNAME
     C**                   Z-ADD*ZEROS    VCUST
     C                   Z-ADD     0             OORDER            6 0
     C                   Z-ADD     0             STRDAT            7 0
     C                   Z-ADD     1             VCODE
     C                   Z-ADD     2             VINCL
     C**                   Z-ADDTDATE     VSHDAT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       111213
     C                   SETOFF                                       141718
     C                   SETOFF                                       202125
     C                   SETOFF                                       7780
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
     C   31              SETON                                        1314
     C   13              GOTO      NXTA
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
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        STRDAT
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SDATE             5 0
     C                   SETON                                        77
     C     NODTE         TAG
      *
     C     VCODE         IFLT      1
     C     VCODE         ORGT      3
     C                   SETON                                        17
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCODE         IFEQ      2
     C                   SETON                                        40
     C                   ENDIF
      *
     C     VINCL         IFLT      1
     C     VINCL         ORGT      2
     C                   SETON                                        18
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     VSHFR:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VSHFR         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VSHFR
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        20
     C   20              GOTO      NXTA
     C                   SETON                                        21
     C                   MOVEL     WHDESC        SDESC            20
     C                   ENDIF
      *
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTSHP
      *
      * SET FHORDR BACK TO BEGINING OF CUSTOMER
      *
     C**         VCUST     SETLLFHORCUDT
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C**         VCUST     READEFHORCUDT                 90
     C** 90                GOTO DSPL
      *
     C*          OHCUST    IFGT VCUST
     C*          RECNO     ANDEQ0
     C*                    SETON                     8014
     C*                    GOTO RSTRTA
     C*                    ENDIF
      *
     C*          OHCOMP    IFNE LCO
     C*                    GOTO RSTRTB
     C*                    ENDIF
      *
     C*          VSHFR     IFGT *BLANKS
     C*          VSHFR     ANDNEOHSHFR
     C*                    GOTO RSTRTB
     C*                    ENDIF
      *
     C*          OHQUOT    IFEQ 'Y'
     C*                    GOTO RSTRTB
     C*                    ENDIF
      *
      *  READ IORDR
      *
     C     IORKEY        KLIST
     C                   KFLD                    VCUST
     C                   KFLD                    STRDAT
     C     IORKEY        SETLL     RIORDR
     C                   SETOFF                                       90
     C     NXTI          TAG
     C                   SETOFF                                       88
     C     VCUST         READE     RIORDR                                 90
     C   90              GOTO      DSPL
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
     C     OIORD#        IFNE      OORDER
     C     OIORD#        CHAIN     FHORDR                             91
     C                   If        not %Found(FHORDR)
     C                   Eval      OHORD# = OIORD#
     C                   EndIf
     C                   Z-ADD     OIORD#        OORDER
     C                   END
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
     C                   MOVEL     OIDES1        DESC
     C                   SETON                                        88
     C                   ENDIF
      *
     C                   Z-ADD     OIQORD        QTY
     C                   Z-ADD     OIQSHP        QTYS
     C     OISEQ#        IFLT      989
     C                   ADD       OIQORD        TOTQTY           11 1
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ENDIF
      *
      *  ITEM HAS BEEN SHIPPED
      *
     C                   MOVEL     ' '           SHIPD
     C     OIQORD        IFGT      0
     C     OIQSHP        ANDGE     OIQORD
     C                   MOVEL     '*'           SHIPD
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C     OICOFL        OREQ      'Y'
     C                   MOVEL     '*'           SHIPD
     C                   ENDIF
      *
     C                   MOVEL     OIITEM        ITEM
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C     RECNO         IFEQ      0
     C                   SETON                                        8014
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   ADD       2             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       ITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       OIUUOM
     C                   Z-ADD     TOTQTY        QTY
     C                   Z-ADD     TOTSHP        QTYS
     C                   Z-ADD     0             OIDTRQ
     C                   MOVEL     *BLANKS       SHIPD
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         DESC
     C                   WRITE     RECSFL
     C     DSPSFL        TAG
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C   KK              DO
     C                   If        SFLCSRRRN = 0
     C                   Eval      SFLCSRRRN = 1
     C                   EndIf
     C     SFLCSRRRN     Chain     RECSFL
     C     EDIT_ORD      tag
     C                   call      'BIR100CLO'
     C                   Parm                    OHORD#
     C                   Parm      0             OISEQ#
     C                   If        LCANCL = 'O'
     C                   GOTO      EDIT_ORD
     C                   ELSE
     C                   GOTO      DSPSFL
     C                   ENDIF
     C                   ENDDO
     C   KJ              DO
     C                   If        SFLCSRRRN = 0
     C                   Eval      SFLCSRRRN = 1
     C                   EndIf
     C     SFLCSRRRN     Chain     RECSFL
     C                   call      'BIR338'
     C                   Parm      OHORD#        ORDER155         15 5
     C                   GOTO      DSPSFL
     C                   ENDDO
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
     C                   MOVEL     DESCO         DESC
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
