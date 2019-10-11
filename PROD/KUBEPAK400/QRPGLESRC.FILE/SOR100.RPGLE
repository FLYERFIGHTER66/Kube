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
      *PROGRAM NAME-------- SOR100
      *APPLICATION--------- SHIPPED ORDER HISTORY
      *DESCRIPTION--------- INQUIRY BY CUSTOMER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/16/00 EFD ADD SIZE/ITEM TO LOGICAL FILE
      *  5/03/01 EFD DONOT CLEAR SCREEN A FIELDS.
      *  5/16/02 EFD SHORTEN ITEM NUMBER AND INCREASE DESCRIPTION.
      *  8/22/02 EFD ADD PRINT OPTION.
      *
     FSOR100FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSOHSTCS  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FSOR100    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR
      *
      * MAIN FLOW OF PROGRAM
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       77
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       VDESC
     C*                    Z-ADD0         VCUST
     C*                    Z-ADD0         VBDATE
     C*                    Z-ADD0         VEDATE
     C*                    Z-ADD0         CBDATE
     C*                    Z-ADD0         CEDATE
     C                   Z-ADD     0             TOTQTY
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       803050
     C                   SETOFF                                       7077
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C     VCUST         IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
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
     C     VCUST         CHAIN     FMCUST                             90
     C   90              SETON                                        1011
     C   11              GOTO      NXTA
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
     C     VSHFR         IFEQ      *BLANKS
     C                   SETOFF                                       50
     C                   GOTO      NOSHFR
     C                   ENDIF
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
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        40
     C   40              GOTO      NXTA
     C                   MOVEL     WHDESC        VDESC            30
      *
     C                   SETON                                        50
      *
     C     NOSHFR        TAG
      *
     C                   MOVEL     *ZEROS        SOORD#
     C     CEDATE        IFGT      0
     C                   Z-ADD     CEDATE        SOSHDT
     C                   ELSE
     C                   Z-ADD     9999999       SOSHDT
     C                   END
     C     CKEY          KLIST
     C                   KFLD                    VCUST
     C                   KFLD                    SOSHDT
     C                   KFLD                    SOORD#
     C     CKEY          SETLL     FSOHSTCS
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C     NXTI          TAG
     C                   SETOFF                                       90
     C     VCUST         READE     FSOHSTCS                               90
     C   90              GOTO      DSPL
      *
     C     SOCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   50SOWHSE        IFNE      VSHFR
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
     C                   Z-ADD     SOQSHP        QTY
     C                   ADD       QTY           TOTQTY            6 0
      *
     C     SOITEM        IFEQ      *BLANKS
     C                   GOTO      NOITEM
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C                   KFLD                    SOWHSE
     C                   MOVEL     SOITEM        ITEM
     C     KEY18         CHAIN     FMINVT                             90
     C  N90              EXSR      GETDES
     C  N90              GOTO      DESOK
     C     NOITEM        TAG
     C     SODES1        IFGT      *BLANKS
     C                   MOVEL     SODES1        DESC
     C                   ENDIF
     C     SODES1        IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       DESC
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
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   Z-ADD     0             SOORD#
     C                   Z-ADD     0             SOORDT
     C                   Z-ADD     0             QTY
     C                   MOVEL     *BLANKS       ITEM
     C                   MOVEL     *BLANKS       SOSIZE
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       SOUUOM
     C                   Z-ADD     0             SDATE
     C                   Z-ADD     TOTQTY        QTY
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         DESC
     C                   WRITE     RECSFL
     C     NXTDSP        TAG
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
      *
     C   KL              DO                                                     PRINT
     C                   EXSR      PRINT
     C                   GOTO      NXTDSP
     C                   ENDDO                                                  KL  DO
      *
     C   KA              DO                                                     PRINT
     C                   If        CSRRRN <> 0
     C     CSRRRN        Chain     RECSFL
     C                   Call      'BIR338'
     C                   Parm      SOORD#        Inv#             15 5
     C                   GOTO      NXTDSP
     C                   Else
     C                   GOTO      NXTDSP
     C                   EndIf
     C                   EndDo
      *
     C                   MOVEL     *BLANKS       VSHFR
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
      * PRINT
      *********
     C     PRINT         BEGSR
     C                   SETON                                        OF
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTQTY            6 0
     C     NXTPRT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFLE      LSTREC
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPRT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   ADD       QTY           TOTQTY            6 0
     C                   GOTO      NXTPRT
     C                   ENDIF                                                  RECNO<LSTREC
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   EXCEPT    TOTL
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
     C                   ENDSR
      *
      ******************
      * OUTPUT SPECS   *
      ******************
     OSOR100    E            HEAD           1 03
     O                                            6 'SOR100'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           61 'Customer Shipped Order'
     O                                           69 'History'
     O                       PAGE          Z     80
     O                                           76 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           25 'For:'
     O                       VCUST         4     32
     O                       CMNAME              63
     O                                           71 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            HEAD           2
     O                                           32 'Ship Dates:'
     O                       VBDATE        Y     41
     O                                           43 '-'
     O                       VEDATE        Y     52
     O          E            HEAD           0
     O                                            6 'Order'
     O                                           13 'Date'
     O                                           20 'Item'
     O                                           27 'Size'
     O                                           40 'Description'
     O                                           62 'UM'
     O                                           70 'Shipd'
     O                                           78 'Date'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          EF           DETL           1
     O                       SOORD#        4      6
     O                       SOORDT        Y     15
     O                       ITEM                22
     O                       SOSIZE              27
     O                       DESC                59
     O                       SOUUOM              62
     O                       QTY           K     71
     O                       SDATE         Y     80
     O          EF           TOTL           1
     O                                           62 '*** Total ***'
     O                       TOTQTY        K     71
