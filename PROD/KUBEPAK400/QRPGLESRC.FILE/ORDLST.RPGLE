      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- ORDLST
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ORDER LIST ORDER ENTRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/02/01 EFD DELETE IORDR RECORD NOT MARK AS DELETED.
      *
     FORDLSTFM  CF   E             WORKSTN
     F                                     SFILE(VLSTSFL:RECNO)
     F                                     SFILE(HLSTSFL:RECN1)
     FFMORLH    IF   E           K DISK
     FFMORLSQ   IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
     FFMINVTLS  IF   E           K DISK
     F                                     RENAME(RMINVT:MINLIS)
     FFMINVTPC  IF   E           K DISK
     F                                     RENAME(RMINVT:MINPC)
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFIORDR    UF A E           K DISK
     FFIORITEM  IF   E           K DISK
     F                                     RENAME(RIORDR:IORDRR)
     FFIORASTI  UF A E           K DISK
     FFIORAST   IF   E           K DISK
     F                                     RENAME(RIORAST:ASTIOR)
     FXATABE1   IF   E           K DISK                                         ?Table File
      *
     D MSG             S             50    DIM(10) CTDATA PERRCD(1)             MESSAGES
     D TSQ             S              4  0 DIM(1000)                            NEW SEQ #'S
     D SZE             S              3    DIM(6)                               SIZES
     D QORD            S              7  0 DIM(6)                               QTY ORD SCREEN
     D QAVL            S              7  0 DIM(6)                               QTY AVAIL
     D PRC             S              8  2 DIM(6)                               PRICE
     D SQ              S              3  0 DIM(6)                               OLD SEQ #'S
     D DEI             S              1    DIM(30)                              DESC WORK ARRAY
     D DEO             S              1    DIM(20)                              DESC WORK ARRAY
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
     D  UseNote        S               N   Inz(*On)
      ****************
      * PASSED PARMS *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    LISTID            6
     C                   PARM                    OHORD#
     C                   PARM                    OHDTRQ
     C                   PARM                    OHSHFR
     C                   PARM                    PRISEQ            3 0
     C                   PARM                    LSTSEQ            3 0          LST SEQ ORD
     C                   PARM                    TOTAST           11 0
     C                   Eval      *In30 = UseNote
     C     LISTID        IFGT      *BLANKS
     C                   MOVEL     LISTID        INLIST            6
     C                   GOTO      SKIPA
     C                   END
     C                   GOTO      GETL
      ***********************
      ** MAIN LINE CODE    **
      ***********************
     C     RSTART        TAG
     C                   MOVE      *ZEROS        *IN
     C**                   CLEARSCRNA
     C                   MOVE      *BLANKS       LISTID
     C                   MOVE      *BLANKS       OLIST             6
     C                   MOVE      *BLANKS       HLDESC
     C     NXTA          TAG
     C                   Eval      PUTSFLRRN = 1
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       102012
     C                   SETOFF                                       9913
      ** CHECK FOR ALPHA SEARCH
     C                   MOVEL     LISTID        SRC               1
     C     SRC           IFEQ      '?'
     C     SRC           OREQ      '/'
     C     GETL          TAG
     C                   MOVE      *BLANKS       DPT               1
     C                   MOVE      LISTID        SLIST             5
     C                   MOVE      *BLANKS       LSTALP            6
     C***                  MOVELSLIST     LSTALP
     C                   CALL      'LKORLS'
     C                   PARM                    LIST              6
     C                   PARM                    NDESC            30
     C     LIST          IFEQ      *BLANKS
     C                   MOVE      *BLANKS       NDESC
     C                   GOTO      NXTA
     C                   END
     C                   MOVEL     LIST          LISTID
     C                   GOTO      SKIPA
     C                   END
     C     LISTID        IFLE      *BLANKS
     C                   MOVE      *BLANKS       NDESC
     C                   SETON                                        1099
     C                   MOVE      *BLANKS       OLIST             6
     C                   GOTO      NXTA
     C                   END
     C     SKIPA         TAG
      ** CHAIN LIST FILE
     C     LISTID        CHAIN     FMORLH                             91
     C   91              MOVE      *BLANKS       NDESC
     C   91              CLEAR                   RMORLH
     C   91              MOVEL     LISTID        HLLIST
     C   91              SETON                                        101299
     C   91              GOTO      NXTA
      *** IF ASSORTMENT ERROR IF FROM OE
     C     HLASST        IFEQ      'Y'
     C     OHORD#        ANDGT     0
     C     INLIST        ANDNE     LISTID
     C                   SETON                                        101399
     C                   GOTO      NXTA
     C                   END                                                    HLASST = Y
      *** IF ASSORTMENT GET PRICE FOT ALL ITEMS
     C     HLASST        IFEQ      'Y'
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVEL     LISTID        IMITEM
     C                   MOVEL     'AST'         IMSIZE
     C                   EXSR      CALPRC
     C                   Z-ADD     #OPRC         APRICE            7 2
     C                   END                                                    HLASST = Y
      ** CHECK REQ DATE
     C     OHDTRQ        IFGT      0
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        20
     C                   ELSE
     C                   SETON                                        20
     C                   END
     C   20              GOTO      NXTA
     C     RSTRTB        TAG
      *** IF ASSORTMENT CHECK IF IN ORDER
     C     HLASST        IFEQ      'Y'
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVEL     LISTID        IMITEM
     C                   MOVEL     'AST'         IMSIZE
     C     FIOITM        SETLL     FIORITEM
     C     NXTACK        TAG
     C     FIOITM        READE     FIORITEM                               90
     C  N90              DO
     C     OISTAT        IFEQ      'A'
     C     OIDTRQ        ANDEQ     OHDTRQ
     C                   Z-ADD     OISEQ#        PRISEQ
     C                   END                                                    OISTAT=A
     C                   GOTO      NXTACK
     C                   ENDDO                                                  N90 DO
     C                   END                                                    HLASST = Y
      ** NOW GET LIST TYPE
     C     HLFORM        IFEQ      'V'
     C                   EXSR      GETV
     C     NXTGTV        TAG
     C                   If        PUTSFLRRN <= 0
     C                   Eval      PUTSFLRRN = 1
     C                   EndIf
     C                   Z-ADD     TOTAST        LSTTOT
     C                   EXFMT     VLSTCTL
     C   KF              GOTO      RSTRTB
     C                   Z-ADD     0             TOTAST
     C     OHORD#        IFGT      0
     C                   EXSR      PUTV
     C                   END
     C   KB              GOTO      END
     C   KK              Do
     C                   If        UseNote
     C                   Eval      UseNote = *Off
     C                   Else
     C                   Eval      UseNote = *On
     C                   EndIf
     C                   Eval      *In30 = UseNote
     C                   Goto      SKIPA
     C                   EndDo
     C   KG              Do
     C     SFLCSRRRN     Chain     VLSTSFL
     C                   If        SFLCSRRRN <> 0
     C                   Call      'VIEWITEM'
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   EndIf
     C                   Goto      SKIPA
     C                   EndDo
     C   KE              DO
     C     HLASST        IFNE      'Y'
     C                   GOTO      GETL
     C                   ELSE
     C                   WRITE     SCRNNCG
     C                   READ      SCRNNCG                                90
     C                   GOTO      NXTGTV
     C                   END
     C                   ENDDO
     C                   GOTO      NXTGTV
     C                   ELSE
     C                   EXSR      GETH
     C     NXTGTH        TAG
     C                   Z-ADD     TOTAST        LSTTOT
     C                   EXFMT     HLSTCTL
     C   KF              GOTO      RSTRTB
     C                   Z-ADD     0             TOTAST
     C     OHORD#        IFGT      0
     C                   EXSR      PUTH
     C                   END
     C   KB              GOTO      END
     C   KK              Do
     C                   If        UseNote
     C                   Eval      UseNote = *Off
     C                   Else
     C                   Eval      UseNote = *On
     C                   EndIf
     C                   Eval      *In30 = UseNote
     C                   GOTO      SKIPA
     C                   EndDo
     C   KG              Do
     C     SFLCSRRRN     Chain     VLSTSFL
     C                   If        SFLCSRRRN <> 0
     C                   Call      'VIEWITEM'
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      PUTSFLRRN = SFLCSRRRN
     C                   EndIf
     C                   Goto      SKIPA
     C                   EndDo
     C   KE              DO
     C     HLASST        IFNE      'Y'
     C                   GOTO      GETL
     C                   ELSE
     C                   WRITE     SCRNNCG
     C                   READ      SCRNNCG                                90
     C                   GOTO      NXTGTH
     C                   END
     C                   ENDDO
     C                   GOTO      NXTGTH
     C                   END
      *
      *** END PROGRAM
     C     END           TAG
     C**                   SETON                     LR
     C                   MOVEA     '0'           *IN
     C                   UNLOCK    FIORDR
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FIORASTI
     C                   RETURN
      ***********************
      ** GET VERTICAL LIST **
      ***********************
     C     GETV          BEGSR
     C                   SETON                                        80
     C                   WRITE     VLSTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTAST
     C                   EXSR      LODSCR
     C                   SETOFF                                       57
      ** IF SELECTED LIST
     C     HLTYPE        IFEQ      'S'
     C     HLLIST        SETLL     FMORLSQ
     C     NXTVS         TAG
     C     HLLIST        READE     FMORLSQ                                90
     C   90              GOTO      ENDV
     C                   ExSr      NOTERDYCSR
     C     ITMKEY        KLIST
     C                   KFLD                    OLITEM
     C                   KFLD                    OLSIZE
     C                   KFLD                    OLWHSE
     C     ITMKEY        CHAIN(N)  FMINVT                             91
     C  N91IMSTAT        COMP      'D'                                    91
     C   91              GOTO      NXTVS
     C     IMQTOH        SUB       IMQTAL        QTYAV
     C                   EXSR      CHKORD
     C                   Z-ADD     OLDO          QTYORD
     C                   ADD       OLDO          QTYAV
     C     HLASST        IFNE      'Y'
     C                   EXSR      CALPRC
     C                   Z-ADD     #OPRC         PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   EXSR      GETDES
     C                   ADD       1             RECNO
     C                   ADD       QTYORD        TOTAST
     C                   WRITE     VLSTSFL
     C                   GOTO      NXTVS
     C                   END
      ** IF PRODUCT CLASS
     C     HLTYPE        IFEQ      'P'
     C     HLPRDC        SETLL     FMINVTPC
     C     NXTVP         TAG
     C     HLPRDC        READE     FMINVTPC                               90
     C   90              GOTO      ENDV
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTVP
     C                   END
     C     OHSHFR        IFGT      *BLANKS
     C     OHSHFR        ANDNE     IMWHSE
     C                   GOTO      NXTVP
     C                   ENDIF
     C     HLSNTS        IFEQ      'I'
     C     IMSIZE        ANDLE     *BLANKS
     C                   GOTO      NXTVP
     C                   END
     C                   Z-ADD     1             X
     C     IMSIZE        LOOKUP    SZE(X)                                 92
     C   92HLSNTS        IFEQ      'O'
     C                   GOTO      NXTVP
     C                   END
     C  N92HLSNTS        IFEQ      'I'
     C                   GOTO      NXTVP
     C                   END
     C     IMQTOH        SUB       IMQTAL        QTYAV
     C                   EXSR      CHKORD
     C                   Z-ADD     OLDO          QTYORD
     C                   ADD       OLDO          QTYAV
     C     HLASST        IFNE      'Y'
     C                   EXSR      CALPRC
     C                   Z-ADD     #OPRC         PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   EXSR      GETDES
     C                   ADD       1             RECNO
     C                   ADD       QTYORD        TOTAST
     C                   WRITE     VLSTSFL
     C                   GOTO      NXTVP
     C                   END
      ** IF LIST CODE
     C     HLTYPE        IFEQ      'L'
     C     HLLSTC        SETLL     FMINVTLS
     C     NXTVL         TAG
     C     HLLSTC        READE     FMINVTLS                               90
     C   90              GOTO      ENDV
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTVL
     C                   END
     C     OHSHFR        IFGT      *BLANKS
     C     OHSHFR        ANDNE     IMWHSE
     C                   GOTO      NXTVL
     C                   ENDIF
     C                   Z-ADD     1             X
     C     IMSIZE        LOOKUP    SZE(X)                                 92
     C   92HLSNTS        IFEQ      'O'
     C                   GOTO      NXTVL
     C                   END
     C  N92HLSNTS        IFEQ      'I'
     C                   GOTO      NXTVL
     C                   END
     C     IMQTOH        SUB       IMQTAL        QTYAV
     C                   EXSR      CHKORD
     C                   Z-ADD     OLDO          QTYORD
     C                   ADD       OLDO          QTYAV
     C     HLASST        IFNE      'Y'
     C                   EXSR      CALPRC
     C                   Z-ADD     #OPRC         PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   EXSR      GETDES
     C                   ADD       1             RECNO
     C                   ADD       QTYORD        TOTAST
     C                   WRITE     VLSTSFL
     C                   GOTO      NXTVL
     C                   END
     C     ENDV          TAG
     C                   Z-ADD     0             QTYAV
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             PRICE
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVEL     MSG(2)        DESC
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   SETON                                        57
     C                   WRITE     VLSTSFL
     C                   SETOFF                                       57
     C                   ENDSR
      ***********************
      ** PUT VERTICAL LIST **
      ***********************
     C     PUTV          BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTAST
     C     NXTPTV        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPTV
     C                   END
     C     RECNO         CHAIN     VLSTSFL                            90
     C   90              GOTO      NXTPTV
      ** CHECK FOR NO CHANGE
     C                   ADD       QTYORD        TOTAST
     C     QTYORD        IFEQ      OLDO
     C                   GOTO      NXTPTV
     C                   END
      ** CHECK IF WE NEED DELETE
     C     QTYORD        IFEQ      0
     C     OLDSEQ        IFGT      0
     C                   EXSR      DELITM
     C                   END
     C                   UPDATE    VLSTSFL
     C                   GOTO      NXTPTV
     C                   END
      ** IF HERE WE NEED TO ADD/UPDATE REC
     C     OLDSEQ        IFGT      0
     C                   EXSR      CHGITM
     C                   Z-ADD     QTYORD        OLDO
     C                   UPDATE    VLSTSFL
     C                   GOTO      NXTPTV
     C                   ELSE
     C                   EXSR      ADDITM
     C                   Z-ADD     QTYORD        OLDO
     C                   Z-ADD     LSTSEQ        OLDSEQ
     C                   UPDATE    VLSTSFL
     C                   GOTO      NXTPTV
     C                   END
     C     ENDPTV        TAG
     C     HLASST        IFEQ      'Y'
     C                   EXSR      UPDAST
     C                   END
     C                   ENDSR
      ************************
      ** GET HORIZONAL LIST **
      ************************
     C     GETH          BEGSR
     C                   SETON                                        80
     C                   WRITE     HLSTCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             TOTAST
     C                   Z-ADD     0             RECN1             5 0
     C                   EXSR      LODSCR
     C     HLTYPE        IFEQ      'S'
     C     HLLIST        SETLL     FMORLSQ
     C                   END
     C     HLTYPE        IFEQ      'P'
     C     HLPRDC        SETLL     FMINVTPC
     C                   END
     C     HLTYPE        IFEQ      'L'
     C     HLLSTC        SETLL     FMINVTLS
     C                   END
     C     NXTH          TAG
      ** IF SELECTED LIST
     C     HLTYPE        IFEQ      'S'
     C     HLLIST        READE     FMORLSQ                                90
     C   90              GOTO      ENDH
     C                   ExSr      NOTERDYCSR
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C     OLITEM        SETLL     FMINVT
     C     NXTHSI        TAG
     C     OLITEM        READE(N)  FMINVT                                 91
     C   91              GOTO      CHKHSI
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTHSI
     C                   END
     C     IMWHSE        IFNE      OHSHFR
     C                   GOTO      NXTHSI
     C                   END
     C                   Z-ADD     1             X                 2 0
     C     IMSIZE        LOOKUP    SZE(X)                                 71
     C  N71              GOTO      NXTHSI
     C                   SETON                                        27
     C     IMQTOH        SUB       IMQTAL        QAVL(X)
     C                   EXSR      CHKORD
     C                   Z-ADD     OLDSEQ        SQ(X)
     C                   Z-ADD     OLDO          QORD(X)
     C                   ADD       OLDO          QAVL(X)
     C     HLASST        IFNE      'Y'
     C                   EXSR      CALPRC
     C                   Z-ADD     #OPRC         PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM#
     C     DESCH         IFLE      *BLANKS
     C                   EXSR      GETDEH
     C                   END
     C                   ADD       20            X
     C                   MOVEL     '0'           *IN(X)
     C                   GOTO      NXTHSI
     C                   END                                                    HLTYPE=S
      ** IF PRODUCT CLASS
     C     HLTYPE        IFEQ      'P'
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C                   MOVE      *BLANKS       OITEM            12
     C     NXTHP         TAG
     C     HLPRDC        READE     FMINVTPC                               90
     C   90              DO
     C                   GOTO      CHKHSI
     C                   ENDDO
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTHP
     C                   END
     C     IMITEM        IFNE      OITEM
     C                   GOTO      CHKHSI
     C     NXTHPI        TAG
     C   90              GOTO      ENDH
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C                   MOVEL     IMITEM        OITEM
     C                   END
     C     OHSHFR        IFGT      *BLANKS
     C     OHSHFR        ANDNE     IMWHSE
     C                   GOTO      NXTHP
     C                   ENDIF
     C                   Z-ADD     1             X                 2 0
     C     IMSIZE        LOOKUP    SZE(X)                                 71
     C  N71              GOTO      NXTHP
     C                   SETON                                        27
     C     IMQTOH        SUB       IMQTAL        QAVL(X)
     C                   EXSR      CHKORD
     C                   Z-ADD     OLDO          QORD(X)
     C                   ADD       OLDO          QAVL(X)
     C                   Z-ADD     OLDSEQ        SQ(X)
     C     HLASST        IFNE      'Y'
     C                   EXSR      CALPRC
     C                   Z-ADD     #OPRC         PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM#
     C     DESCH         IFLE      *BLANKS
     C                   EXSR      GETDEH
     C                   END
     C                   ADD       20            X
     C                   MOVEL     '0'           *IN(X)
     C                   GOTO      NXTHP
     C                   END                                                    HLTYPE=P
      ** IF LIST CODE
     C     HLTYPE        IFEQ      'L'
     C     NXTHL         TAG
     C     HLLSTC        READE     FMINVTLS                               90
     C   90              DO
     C                   GOTO      CHKHSI
     C                   ENDDO
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXTHL
     C                   END
     C     IMITEM        IFNE      OITEM
     C                   GOTO      CHKHSI
     C     NXTHLI        TAG
     C   90              GOTO      ENDH
     C                   SETON                                        212223
     C                   SETON                                        242526
     C                   SETOFF                                       27
     C                   MOVEL     IMITEM        OITEM
     C                   END
     C     OHSHFR        IFGT      *BLANKS
     C     OHSHFR        ANDNE     IMWHSE
     C                   GOTO      NXTHL
     C                   ENDIF
     C                   Z-ADD     1             X
     C     IMSIZE        LOOKUP    SZE(X)                                 71
     C  N71              GOTO      NXTHL
     C                   SETON                                        27
     C     IMQTOH        SUB       IMQTAL        QAVL(X)
     C                   EXSR      CHKORD
     C                   Z-ADD     OLDO          QORD(X)
     C                   ADD       OLDO          QAVL(X)
     C                   Z-ADD     OLDSEQ        SQ(X)
     C     HLASST        IFNE      'Y'
     C                   EXSR      CALPRC
     C                   Z-ADD     #OPRC         PRICE
     C                   ELSE
     C                   Z-ADD     APRICE        PRICE
     C                   END
     C                   MOVEL     IMITEM        ITEM#
     C     DESCH         IFLE      *BLANKS
     C                   EXSR      GETDEH
     C                   END
     C                   ADD       20            X
     C                   MOVEL     '0'           *IN(X)
     C                   GOTO      NXTHL
     C                   END                                                    HLTYPE=L
      ** SEE IF ANY RECORDS SELECTED
     C     CHKHSI        TAG
     C   27              DO
     C                   Z-ADD     QAVL(1)       QTYAV1
     C                   Z-ADD     QORD(1)       QTYOR1
     C                   Z-ADD     PRC(1)        PRIC1
     C                   Z-ADD     QAVL(2)       QTYAV2
     C                   Z-ADD     QORD(2)       QTYOR2
     C                   Z-ADD     PRC(2)        PRIC2
     C                   Z-ADD     QAVL(3)       QTYAV3
     C                   Z-ADD     QORD(3)       QTYOR3
     C                   Z-ADD     PRC(3)        PRIC3
     C                   Z-ADD     QAVL(4)       QTYAV4
     C                   Z-ADD     QORD(4)       QTYOR4
     C                   Z-ADD     PRC(4)        PRIC4
     C                   Z-ADD     QAVL(5)       QTYAV5
     C                   Z-ADD     QORD(5)       QTYOR5
     C                   Z-ADD     PRC(5)        PRIC5
     C                   Z-ADD     QAVL(6)       QTYAV6
     C                   Z-ADD     QORD(6)       QTYOR6
     C                   Z-ADD     PRC(6)        PRIC6
     C                   Z-ADD     SQ(1)         OLSQ1
     C                   Z-ADD     SQ(2)         OLSQ2
     C                   Z-ADD     SQ(3)         OLSQ3
     C                   Z-ADD     SQ(4)         OLSQ4
     C                   Z-ADD     SQ(5)         OLSQ5
     C                   Z-ADD     SQ(6)         OLSQ6
     C                   ADD       1             RECN1
*     *** TEST ONLY
*    C**         RECN1     IFGT 500
*    C**                   GOTO ENDH
*    C**                   END
*     *** TEST ONLY
      ** GET TOTAL
     C                   XFOOT     QORD          WRKTOT           11 0
     C                   ADD       WRKTOT        TOTAST
     C                   WRITE     HLSTSFL
     C                   Z-ADD     0             PRC
     C                   Z-ADD     0             QAVL
     C                   Z-ADD     0             QORD
     C                   Z-ADD     0             SQ
     C                   ENDDO
     C                   MOVE      *BLANKS       DESCH
     C     HLTYPE        IFEQ      'P'
     C                   GOTO      NXTHPI
     C                   END
     C     HLTYPE        IFEQ      'L'
     C                   GOTO      NXTHLI
     C                   END
     C                   GOTO      NXTH
     C     ENDH          TAG
     C**                   MOVE *BLANKS   ITEM#
     C**                   MOVELMSG,2     DESCH
     C**                   ADD  1         RECN1
     C**                   WRITEHLSTSFL
     C                   Z-ADD     RECN1         LSTREC
     C                   ENDSR
      **************************
      ** PUT HORIZIONTAL LIST **
      **************************
     C     NOTERDYCSR    BEGSR
     C                   If        UseNote
     C                   Eval      NOTERDYC = OLNOTE
     C                   Else
     C                   Eval      NOTERDYC = OLRDYC
     C                   Eval      Table   = 'RC'
     C                   Eval      TableCd = OLRDYC
    ?C     TableKey      KList
    ?C                   KFld                    Table             2
    ?C                   KFld                    TableCd           6
    ?C     TableKey      Chain     XATABE1                                      ?
     C                   If        %Found(XATABE1)
     C*                  Eval      NOTERDYC = TBSHRT
     C                   EndIf
     C                   EndIf
     C                   If        OLNOTE <> ''
     C                   Eval      *In31 = *On
     C                   Else
     C                   Eval      *In31 = *Off
     C                   EndIf
     C                   ENDSR
      **************************
      ** PUT HORIZIONTAL LIST **
      **************************
     C     PUTH          BEGSR
     C                   Z-ADD     0             RECN1
     C                   Z-ADD     0             TOTAST
     C     NXTPTH        TAG
     C                   ADD       1             RECN1
     C     RECN1         IFGT      LSTREC
     C                   GOTO      ENDPTH
     C                   END
     C     RECN1         CHAIN     HLSTSFL                            90
     C   90              GOTO      NXTPTH
     C                   Z-ADD     QTYOR1        QORD(1)
     C                   Z-ADD     QTYOR2        QORD(2)
     C                   Z-ADD     QTYOR3        QORD(3)
     C                   Z-ADD     QTYOR4        QORD(4)
     C                   Z-ADD     QTYOR5        QORD(5)
     C                   Z-ADD     QTYOR6        QORD(6)
     C                   Z-ADD     OLSQ1         SQ(1)
     C                   Z-ADD     OLSQ2         SQ(2)
     C                   Z-ADD     OLSQ3         SQ(3)
     C                   Z-ADD     OLSQ4         SQ(4)
     C                   Z-ADD     OLSQ5         SQ(5)
     C                   Z-ADD     OLSQ6         SQ(6)
     C                   MOVEL     ITEM#         ITEM
      ** READ ARRAYS
     C                   Z-ADD     0             X
     C     NXTXAD        TAG
     C                   ADD       1             X
     C     X             IFGT      6
     C                   GOTO      NXTPTH
     C                   END
      ** CHECK FOR NO CHANGE
     C     QORD(X)       IFLE      0
     C     SQ(X)         ANDEQ     0
     C                   GOTO      NXTXAD
     C                   END
     C                   ADD       QORD(X)       TOTAST
      ** CHECK IF WE NEED DELETE
     C     QORD(X)       IFEQ      0
     C     SQ(X)         IFGT      0
     C                   Z-ADD     SQ(X)         OLDSEQ
     C                   EXSR      DELITM
     C                   END
     C                   UPDATE    HLSTSFL
     C                   GOTO      NXTXAD
     C                   END
      ** IF HERE WE NEED TO ADD/UPDATE REC
     C                   Z-ADD     SQ(X)         OLDSEQ
     C                   Z-ADD     QORD(X)       QTYORD
     C                   MOVEL     SZE(X)        SIZE
     C     SQ(X)         IFGT      0
     C                   EXSR      CHGITM
     C                   GOTO      NXTXAD
     C                   ELSE
     C                   EXSR      ADDITM
     C                   Z-ADD     LSTSEQ        SQ(X)
     C                   GOTO      NXTXAD
     C                   END
     C     ENDPTH        TAG
     C     HLASST        IFEQ      'Y'
     C                   EXSR      UPDAST
     C                   END
     C                   ENDSR
      ***********************
      ** UPDATE ASST LINE  **
      ***********************
     C     UPDAST        BEGSR
     C                   Z-ADD     PRISEQ        OLDSEQ
     C     IOROLD        CHAIN     FIORDR                             90
     C   90              DO
     C                   CLEAR                   RIORDR
     C                   MOVEL     HLLIST        OIITEM
     C                   MOVEL     'AST'         OISIZE
     C                   MOVEL     OHSHFR        OIWHSE
     C                   ENDDO                                                  90 DO
     C     ITMOKY        CHAIN     FMINVT                             91
     C  N91              DO
     C                   SUB       OIQORD        IMQTAL
     C                   ADD       TOTAST        IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   MOVEL     IMPUOM        OIUUOM
     C                   ENDDO                                                  N91 DO
     C     ITMOKY        CHAIN     FLKITM                             91
     C  N91              DO
     C                   SUB       OIQORD        LKPAL
     C                   ADD       TOTAST        LKPAL
     C                   UPDATE    RLKITM
     C                   ENDDO                                                  N91 DO
     C   90              DO
     C                   Z-ADD     TOTAST        OIQORD
     C                   Z-ADD     0             #OPRC             9 4
     C                   MOVEL     OHPRCD        PRICD             1
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     0             VOLDSC            4 2
     C                   MOVEL     'N'           OIFRQD
     C                   MOVEL     *BLANKS       OICTCD
     C                   MOVEL     *BLANKS       ORDD
     C                   Z-ADD     OIQORD        #OQTY             8 1
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIUUOM
     C                   PARM                    #OQTY
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
      **
     C                   Z-ADD     #OPRC         OIUPRI
     C                   EXSR      #EXLN
     C                   Z-ADD     #LINGR        OIEXT$
     C                   MOVEL     'A'           OISTAT
     C                   MOVEL     IMDES1        OIDES1
     C                   Z-ADD     OHORD#        OIORD#
     C                   Z-ADD     PRISEQ        OISEQ#
     C                   Z-ADD     IMCOMP        OICOMP
     C                   Z-ADD     IMUCST        OIUCST
     C                   MOVEL     'H'           OISHCD
     C                   MOVEL     OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVEL     OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     OHDTRQ        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   MOVE      ' '           OIITYP
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     OHSHFR        OISHFR
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVEL     IMPCL1        OIPRCL
     C                   MOVEL     IMLOOK        OIITMA
     C************         WRITERIORDR
     C                   ENDDO                                                  90 DO
     C  N90              DO
     C                   Z-ADD     TOTAST        OIQORD
     C                   Z-ADD     0             OIQSHP
     C     OHPOS         IFEQ      'P'
     C                   MOVE      'R'           OISHCD
     C                   MOVE      'P'           OIPLPT
     C                   MOVEL     OHPHYT        OIPHYT
     C                   Z-ADD     OIQORD        OIQINV
     C                   Z-ADD     OIQORD        OIQSHP
     C                   END
     C                   Z-ADD     TOTAST        QTYORD
     C                   EXSR      #EXLN
     C                   MOVE      'A'           OISTAT
     C                   Z-ADD     #LINGR        OIEXT$
     C                   UPDATE    RIORDR
     C                   ENDDO                                                  N90 DO
     C                   ENDSR
      ***********************
      ** LOAD SCREENS      **
      ***********************
     C     LODSCR        BEGSR
      ** GET ORDER INFO
     C     OHORD#        IFGT      0
     C     OHORD#        CHAIN     FHORDR                             91
     C*                    ELSE
     C*                    Z-ADD1859      OHCUST
     C*                    Z-ADDTDATE     OHDTRQ
     C*                    MOVELMSG,1     OHNAME
     C                   END
     C                   MOVEL     HLSIZ1        SZE(1)
     C                   MOVEL     HLSIZ2        SZE(2)
     C                   MOVEL     HLSIZ3        SZE(3)
     C                   MOVEL     HLSIZ4        SZE(4)
     C                   MOVEL     HLSIZ5        SZE(5)
     C                   MOVEL     HLSIZ6        SZE(6)
     C                   MOVEL     HLHDG1        HDG1
     C                   MOVEL     HLHDG2        HDG2
     C                   MOVEL     HLHDG3        HDG3
     C                   MOVEL     HLHDG4        HDG4
     C                   MOVEL     HLHDG5        HDG5
     C                   MOVEL     HLHDG6        HDG6
     C                   ENDSR
      **
      * GET DESCRIPTION HORIZONTAL
      **
      ** STRIP THE SIZE NUMBERS FROM THE DESCRIPTION.
     C     GETDEH        BEGSR
     C                   MOVE      *BLANKS       DEI
     C                   MOVE      *BLANKS       DEO
     C                   EXSR      GETDES
     C                   MOVEA     DESC          DEI
     C                   Z-ADD     0             I                 2 0
     C                   Z-ADD     0             O                 2 0
     C     NXTDEH        TAG
     C                   ADD       1             I
     C     I             IFGT      30
     C                   GOTO      FINDEH
     C                   END
     C     DEI(I)        IFLE      'Z'
     C     DEI(I)        ANDNE     '"'
     C     DEI(I)        ANDNE     '.'
     C     DEI(I)        ANDNE     *BLANKS
     C                   GOTO      FINDEH
     C                   END
     C                   GOTO      NXTDEH
      ** NOW MOVE THE REST
     C     FINDEH        TAG
     C                   ADD       1             O
     C                   MOVEL     DEI(I)        DEO(O)
     C                   ADD       1             I
     C     I             IFLE      30
     C     O             ANDLT     20
     C                   GOTO      FINDEH
     C                   END
      ** MOVE THE ARRAY INTO THE DESCRIPTION
     C                   MOVEA     DEO           DESCH
     C                   ENDSR
      **
      * GET PREVIOUS ORDER QTYS.
      **
     C     CHKORD        BEGSR
     C                   Z-ADD     0             OLDO             11 0
     C                   Z-ADD     0             OLDSEQ
      ** IF ASSORTMENT USE DIFF FILE
     C     HLASST        IFEQ      'Y'
     C                   GOTO      CHKAST
     C                   END
     C     FIOITM        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    OHORD#
     C     FIOITM        SETLL     FIORITEM
     C     NXTODE        TAG
     C     FIOITM        READE     FIORITEM                               90
     C   90              GOTO      ENDODE
     C     OISTAT        IFEQ      'A'
     C     OIDTRQ        ANDEQ     OHDTRQ
     C     OIQORD        SUB       OIQSHP        LEFT             11 0
     C                   ADD       LEFT          OLDO
     C                   Z-ADD     OISEQ#        OLDSEQ
     C                   END
     C                   GOTO      NXTODE
      ** CHECK ASSORTMENTS
     C     CHKAST        TAG
     C     ASTKEY        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    PRISEQ
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ASTKEY        CHAIN(N)  FIORASTI                           90
     C  N90              DO
     C**         IASTAT    IFEQ 'A'
     C     IAQORD        SUB       IAQSHP        LEFT
     C                   ADD       LEFT          OLDO
     C                   Z-ADD     IASEQ#        OLDSEQ
     C**                   END
     C                   ENDDO
     C     ENDODE        ENDSR
      **************************
      * GET DESCRIPTION VERTICAL
      **************************
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'P'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC
     C                   ENDSR
      **************************
      * DELETE LINE ITEM
      **************************
     C     DELITM        BEGSR
     C     HLASST        IFEQ      'N'
     C     IOROLD        CHAIN     FIORDR                             90
     C  N90              DO
     C     OHPOS         IFNE      'P'
     C     OIQORD        SUB       OIQSHP        LEFT
     C                   ELSE
     C                   Z-ADD     OIQORD        LEFT
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQINV
     C                   END
     C     ITMOKY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     ITMOKY        CHAIN     FMINVT                             91
     C  N91              DO
     C                   SUB       LEFT          IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   ENDDO                                                  N91 DO
     C     ITMOKY        CHAIN     FLKITM                             91
     C  N91              DO
     C                   SUB       LEFT          LKPAL
     C                   UPDATE    RLKITM
     C                   ENDDO                                                  N91 DO
     C                   Z-ADD     0             OIQBOO
     C**                   MOVEL'D'       OISTAT
     C**                   UPDATRIORDR
     C                   DELETE    RIORDR
     C                   Eval      OLDO = *Zero
     C                   Eval      OLDSEQ = *Zero
     C                   ENDDO                                                  N90 DO
     C                   ELSE                                                   ASST = N
     C                   MOVEL     ITEM          IMITEM
     C                   MOVEL     SIZE          IMSIZE
     C                   MOVEL     OHSHFR        IMWHSE
     C     ASTKEY        CHAIN     FIORASTI                           90
     C  N90              DO
     C     IASTAT        IFEQ      'A'
     C     IAQORD        SUB       IAQSHP        LEFT
     C     ITMAKY        KLIST
     C                   KFLD                    IAITEM
     C                   KFLD                    IASIZE
     C                   KFLD                    IAWHSE
     C     ITMAKY        CHAIN     FMINVT                             91
     C  N91              DO
     C                   SUB       LEFT          IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   ENDDO                                                  N91 DO
     C     ITMAKY        CHAIN     FLKITM                             91
     C  N91              DO
     C                   SUB       LEFT          LKPAL
     C                   UPDATE    RLKITM
     C                   ENDDO                                                  N91 DO
     C                   DELETE    RIORAST
     C                   Eval      OLDO = *Zero
     C                   Eval      OLDSEQ = *Zero
     C                   END                                                    IASTAT=A
     C                   ENDDO                                                  N90 DO
     C                   END                                                    HLASST=N
     C                   ENDSR
      **************************
      * CHANGE LINE ITEM
      **************************
     C     CHGITM        BEGSR
     C     HLASST        IFEQ      'N'
     C     IOROLD        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    OLDSEQ
     C     IOROLD        CHAIN     FIORDR                             90
     C  N90              DO
     C     OIQORD        SUB       OIQSHP        LEFT
     C     ITMOKY        CHAIN     FMINVT                             91
     C  N91              DO
     C                   SUB       LEFT          IMQTAL
     C                   ADD       QTYORD        IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   ENDDO                                                  N91 DO
     C     ITMOKY        CHAIN     FLKITM                             91
     C  N91              DO
     C                   SUB       LEFT          LKPAL
     C                   ADD       QTYORD        LKPAL
     C                   UPDATE    RLKITM
     C                   ENDDO                                                  N91 DO
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     QTYORD        OIQORD
     C     OHPOS         IFEQ      'P'
     C                   MOVE      'R'           OISHCD
     C                   MOVE      'P'           OIPLPT
     C                   MOVEL     OHPHYT        OIPHYT
     C                   Z-ADD     OIQORD        OIQINV
     C                   Z-ADD     OIQORD        OIQSHP
     C                   END
     C                   MOVEL     'A'           OISTAT
     C                   EXSR      #EXLN
     C                   Z-ADD     #LINGR        OIEXT$
     C                   UPDATE    RIORDR
     C                   ENDDO                                                  N90 DO
     C                   ELSE                                                   ASST = N
     C                   MOVEL     ITEM          IMITEM
     C                   MOVEL     SIZE          IMSIZE
     C                   MOVEL     OHSHFR        IMWHSE
     C     ASTKEY        CHAIN     FIORASTI                           90
     C  N90              DO
     C     IAQORD        SUB       IAQSHP        LEFT
     C                   ENDDO
     C   90              DO
     C                   CLEAR                   RIORAST
     C                   Z-ADD     OHORD#        IAORD#
     C                   Z-ADD     PRISEQ        IAPSEQ
     C                   ADD       1             LSTISQ
     C                   Z-ADD     LSTISQ        IASEQ#
     C                   MOVEL     ITEM          IAITEM
     C                   MOVEL     SIZE          IASIZE
     C                   MOVEL     OHSHFR        IAWHSE
     C                   MOVEL     OHSHFR        IASHFR
     C                   Z-ADD     OHDTRQ        IADTRQ
     C                   Z-ADD     TDATE         IADTLA
     C                   Z-ADD     TIMOD         IATIME
     C                   MOVEL     USERID        IAUSER
     C                   Z-ADD     0             LEFT
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        IARVDT
     C                   ENDDO                                                  90 DO
     C     ITMAKY        CHAIN     FMINVT                             91
     C  N91              DO
     C                   SUB       LEFT          IMQTAL
     C                   ADD       QTYORD        IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   ENDDO                                                  N91 DO
     C     ITMAKY        CHAIN     FLKITM                             91
     C  N91              DO
     C                   SUB       LEFT          LKPAL
     C                   ADD       QTYORD        LKPAL
     C                   UPDATE    RLKITM
     C                   ENDDO                                                  N91 DO
     C     IAQORD        IFNE      QTYORD
     C                   MOVE      ' '           IASPFL
     C                   END
     C                   Z-ADD     QTYORD        IAQORD
     C******               ADD  QTYORD    TOTAST 110
     C                   Z-ADD     0             IAQSHP
     C                   MOVEL     'A'           IASTAT
     C                   MOVEL     IMBPUM        IAUUOM
     C                   MOVEL     IMPCL1        IAPRCL
     C                   MOVEL     OHSHPC        IASHPC
     C                   MOVEL     OHROUT        IAROUT
     C                   Z-ADD     OHSTOP        IASTOP
     C  N90              UPDATE    RIORAST
     C   90              WRITE     RIORAST
     C                   END                                                    HLASST=N
     C                   ENDSR
      **************************
      * ADD LINE ITEM
      **************************
     C     ADDITM        BEGSR
     C     HLASST        IFNE      'Y'
     C     NXTTRO        TAG
     C                   ADD       2             LSTSEQ
     C     IORLST        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    LSTSEQ
     C     IORLST        CHAIN     FIORDR                             90
     C  N90              DO
     C                   GOTO      NXTTRO
     C                   ENDDO                                                  N90 DO
     C                   CLEAR                   RIORDR
     C                   Z-ADD     QTYORD        OIQORD
     C     OHPOS         IFEQ      'P'
     C                   MOVE      'R'           OISHCD
     C                   MOVE      'P'           OIPLPT
     C                   MOVEL     OHPHYT        OIPHYT
     C                   Z-ADD     OIQORD        OIQINV
     C                   Z-ADD     OIQORD        OIQSHP
     C                   ELSE
     C                   MOVEL     'H'           OISHCD
     C                   END
     C                   MOVEL     ITEM          OIITEM
     C                   MOVEL     SIZE          OISIZE
     C                   MOVEL     OHSHFR        OIWHSE
     C     ITMOKY        CHAIN     FMINVT                             91
     C  N91              DO
     C                   ADD       QTYORD        IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   MOVEL     IMPUOM        OIUUOM
     C                   ENDDO                                                  N91 DO
     C     ITMOKY        CHAIN     FLKITM                             91
     C  N91              DO
     C                   ADD       QTYORD        LKPAL
     C                   UPDATE    RLKITM
     C                   ENDDO                                                  N91 DO
     C                   Z-ADD     0             #OPRC
     C                   MOVEL     OHPRCD        PRICD             1
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     0             VOLDSC            4 2
     C                   MOVEL     'N'           OIFRQD
     C                   MOVEL     *BLANKS       OICTCD
     C                   MOVEL     *BLANKS       ORDD
     C                   Z-ADD     OIQORD        #OQTY
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIUUOM
     C                   PARM                    #OQTY
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
      **
     C                   Z-ADD     #OPRC         OIUPRI
     C                   EXSR      #EXLN
     C                   Z-ADD     #LINGR        OIEXT$
     C                   MOVEL     'A'           OISTAT
     C                   MOVEL     IMDES1        OIDES1
     C                   Z-ADD     OHORD#        OIORD#
     C                   Z-ADD     LSTSEQ        OISEQ#
     C                   Z-ADD     IMCOMP        OICOMP
     C                   Z-ADD     IMUCST        OIUCST
     C                   MOVEL     OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVEL     OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     OHDTRQ        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   MOVE      ' '           OIITYP
     C                   MOVE      'N'           OIOVER
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     OHSHFR        OISHFR
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVEL     IMPCL1        OIPRCL
     C                   MOVEL     IMLOOK        OIITMA
     C     OHTXST        IFEQ      'Y'
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   ELSE
     C                   MOVE      IMTXBL        OITXCD
     C                   MOVE      IMTCD1        OITXST
     C                   MOVE      IMTCD2        OITXCT
     C                   MOVE      IMTCD3        OITXLC
     C                   END
     C                   WRITE     RIORDR
     C                   ELSE                                                   ASST = N
     C                   MOVEL     ITEM          IMITEM
     C                   MOVEL     SIZE          IMSIZE
     C                   MOVEL     OHSHFR        IMWHSE
     C     ASTKEY        CHAIN     FIORASTI                           90
     C  N90              DO
     C     IAQORD        SUB       IAQSHP        LEFT
     C                   ENDDO
     C   90              DO
     C                   CLEAR                   RIORAST
     C                   Z-ADD     OHORD#        IAORD#
     C                   Z-ADD     PRISEQ        IAPSEQ
     C                   ADD       1             LSTISQ
     C                   Z-ADD     LSTISQ        IASEQ#
     C                   MOVEL     ITEM          IAITEM
     C                   MOVEL     SIZE          IASIZE
     C                   MOVEL     OHSHFR        IAWHSE
     C                   MOVEL     OHSHFR        IASHFR
     C                   Z-ADD     OHDTRQ        IADTRQ
     C                   Z-ADD     TDATE         IADTLA
     C                   Z-ADD     TIMOD         IATIME
     C                   MOVEL     USERID        IAUSER
     C                   Z-ADD     0             LEFT
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        IARVDT
     C                   ENDDO                                                  90 DO
     C     ITMAKY        CHAIN     FMINVT                             91
     C  N91              DO
     C                   SUB       LEFT          IMQTAL
     C                   ADD       QTYORD        IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   ENDDO                                                  N91 DO
     C     ITMAKY        CHAIN     FLKITM                             91
     C  N91              DO
     C                   SUB       LEFT          LKPAL
     C                   ADD       QTYORD        LKPAL
     C                   UPDATE    RLKITM
     C                   ENDDO                                                  N91 DO
     C                   Z-ADD     QTYORD        IAQORD
     C******               ADD  QTYORD    TOTAST 110
     C                   Z-ADD     0             IAQSHP
     C                   MOVEL     'A'           IASTAT
     C                   MOVEL     OHSHPC        IASHPC
     C                   MOVEL     OHROUT        IAROUT
     C                   Z-ADD     OHSTOP        IASTOP
     C                   MOVEL     IMPCL1        IAPRCL
     C  N90              UPDATE    RIORAST
     C   90              WRITE     RIORAST
     C                   END                                                    HLASST=N
     C                   ENDSR
      *****************
      ** CALC PRICE
      *****************
     C     CALPRC        BEGSR
     C     OLDO          IFGT      0
     C                   Z-ADD     OLDO          OIQORD
     C                   ELSE
     C                   Z-ADD     1             OIQORD
     C                   END
     C                   Z-ADD     0             #OPRC
     C                   Z-ADD     OIQORD        #OQTY
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMPUOM
     C                   PARM                    #OQTY
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    IMORDD
     C                   ENDSR
      *****************
      ** CALC EXTENSION
      *****************
     C     #EXLN         BEGSR
      *
      *  SUBROUTINE #EXLN IS USED TO EXTEND THE VALUE OF A ORDER DETAIL
      *  LINE
      *
      *  USER WILL NEED TO LOAD FIELDS AS FOLLOWS
      *       ORDQTY    CONTAINS QUANTITY
      *       VUPRIC    CONTAINS PRICE
      *       VDISC     CONTAINS QUANTITY DISCOUNT PCT.
      *       #WKWGT    CONTAINS WEIGHT PER UNIT OF MEASURE
      *       #CWFLG    CATCH WEIGHT ITEM 'Y' OR 'N'
      *
      *       SUBROUTINE WILL RETURN THE FOLLOWING:
      *
      *       #LINGR    EXTENDED GROSS AMOUNT
      *       #LINNT    EXTENDED NET AMOUNT
      *       #LINDS    DISCOUNT DOLLAR AMOUNT
      *
     C     *LIKE         DEFINE    IMUWGT        #WKWGT
     C                   MOVE      #CWFLG        #CWFLG            1
      *
     C*          #CWFLG    IFEQ 'Y'
     C*          #WRFRQ    MULT #WKWGT    #WRFRQ    H
     C*                    END
      *
      *  EXTEND GROSS AMOUNT
      *
     C     QTYORD        MULT(H)   OIUPRI        #LINGR            9 2
      *
      *  ADJUST FOR DISC. PCT.
      *
     C*          VDISC     IFGT 0
     C*                    MOVE VDISC     WKDISC  44
     C*          1         SUB  WKDISC    WKDISC
     C*          VUPRIC    MULT WKDISC    #PRC    92H
     C*                    ELSE
     C                   Z-ADD     OIUPRI        #PRC              9 2
     C*                    END
      *
      *  CALCULATE LINE NET AMOUNT
      *
     C     QTYORD        MULT(H)   #PRC          #LINNT            9 2
      *
      *  CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       #LINNT        #LINDS            7 2
      *
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVE      '999'         USDEPT            3
     C     USDEPT        CHAIN     FMDEPT                             90
     C     TSTKEY        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    PRISEQ
     C                   Z-ADD     0             LSTISQ            3 0
     C     TSTKEY        SETLL     FIORAST
     C     NXTTST        TAG
     C     TSTKEY        READE     FIORAST                                90
     C  N90              Z-ADD     IASEQ#        LSTISQ
     C  N90              GOTO      NXTTST
     C                   ENDSR
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
     C                   MOVEL     0             #03A                           CYY            @DT@A
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
     C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
     C                   MOVE      #04           #02C              2 0          DD             @DT@A
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
     C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                                      @DT@A
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
     C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
     C     #03A          COMP      070                                  91                     @DT@A
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
     C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
** MESSAGE ARRAY
Dillon Test Customer                                      1
**** End of List ****                                     2
