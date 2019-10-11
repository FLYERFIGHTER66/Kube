     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- NCR230
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT LOCATION SHEETS FOR CARTS  (CALLED)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *  02/21/03   CORRECTED OVERFLOW PROBLEM ON REPORT.  CAB
      *  03/24/03   CORRECTED DELETED RECORD FROM SHOWING ON REPORT. CAB
      *
     FNCARTS    UF   E           K DISK
     FNCART     O  A E           K DISK
     FNCARTCI   IF   E           K DISK
     F                                     RENAME(RCART:CARTCI)
     FNCARTCC   IF   E           K DISK
     F                                     RENAME(RCART:CARTCC)
     FNCARTCR   IF   E           K DISK
     F                                     RENAME(RCART:CARTCR) Prefix(s_)
     FNPUTORDP  UF   E           K DISK
     FNPUTORDI  IF   E           K DISK    RENAME(RPUTORD:RPUTORDs) Prefix(s_)
     FFHORDR    IF   E           K DISK
     FFPPO      IF   E           K DISK
     FFTRAY     IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFIORDRPARTUF   E           K DISK
     FFMINVT    IF   E           K DISK
     FNCARTCTL  UF A E           K DISK
     FFMANUAL   IF   E           K DISK
     FNCR230P   O    E             PRINTER OFLIND(*IN81)
     FNCR230    O    F  120        PRINTER OFLIND(*INOF)
     FNCR230E   O    F  120        PRINTER OFLIND(*INOV)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)              MESSAGES
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

      *? Data Areas
     D ALLOWPARTS      DS                  DTAARA(ALLOWPARTS)
     D  PartsAreOK@                   1A                                        ?Allow Partial Fill
     D  PartsAreOK     S               N                                        ?Allow Partial Fill

      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  VOUT                 131    131  0
     D  LCANCL               133    133

     D  P              S              1A   Inz(*Blanks)
     D  FirstTime      S               N   Inz(*On)
     D  RePrint        S             24A   Inz(*Blanks)

     D  BalanceDue     S              4S 0
     D  QtyOrdr        S              4S 0
     D  QtyRcvd        S              4S 0

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center


      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    CARTNO            8 0
     C                   PARM                    STRDAT            7 0
     C                   PARM                    SMASTER           2 0
     C                   PARM                    CONTRL            6 0

     C                   In        ALLOWPARTS
     C                   IF        PartsAreOK@ = '1'
     C                   Eval      PartsAreOK = *On
     C                   Else
     C                   Eval      PartsAreOK = *Off
     C                   EndIf

     C     MASTKEY       KList
     C                   KFld                    STRDAT
     C                   KFld                    SMASTER
     C     MASTKEY       Chain     FMANUAL
     C                   If        not %Found(FMANUAL)
     C                   Eval      MNSEQD = $Center('Master Not Found':35)
     C                   Else
     C                   Eval      MNSEQD = $Center(MNSEQD:35)
     C                   EndIf

     C                   Z-ADD     STRDAT        STRCYM            7 0
      ** IF CONTROL NUMBER GT 0 THEN REPRINT
     C     CONTRL        IFGT      0
     C                   Eval      REPRINT = '***  R e p r i n t  ***'
     C                   GOTO      PRTONL
     C                   END
     C                   Eval      REPRINT = *Blanks
     C     STRCYM        CHAIN     NCARTCTL                           91
     C   91              DO
     C                   Z-ADD     0             CCCONT
     C                   Z-ADD     STRCYM        CCSHPD
     C                   ENDDO
     C                   ADD       1             CCCONT
     C   91              WRITE     RCARTCTL
     C  N91              UPDATE    RCARTCTL
     C                   Z-ADD     CCCONT        CONTRL
      ***********************
      ** START HERE        **
      ***********************
     C     CartKey       KList
     C                   KFld                    CARTNO
     C                   KFld                    STRCYM
     C                   KFld                    SMASTER
     C*    CARTNO        SETLL     NCARTS
     C     CartKey       SETLL     NCARTS
     C                   SETON                                        OV
     C                   Z-ADD     0             CTCSEQ
     C     NXTCRT        TAG
     C*    CARTNO        READE     NCARTS                                 90
     C     CartKey       READE     NCARTS                                 90
     C                   Eval      KeyItem = %subst(CTITEM:1:11) + ' '
     C   90              GOTO      ENDCRT
      ** CHECK FOR FUTURE WEEK
     C     CTTAG#        CHAIN     FTRAY                              55
     C  N55              DO
     C     TRCRDT        IFGT      STRCYM
     C   OV              DO
     C                   EXCEPT    EHEAD
     C                   SETOFF                                       OV
     C                   ENDDO                                                  OV DO
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C                   EXCEPT    ERROR
     C                   MOVE      *BLANKS       CTLOC
     C                   MOVEL     'ERROR'       CTLOC
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C                   MOVE      *BLANKS       CTBORD
     C                   MOVEL     IMLOOK        CTLOOK
     C                   Z-ADD     CONTRL        CTCNTL
     C                   ADD       1             CTCSEQ
     C                   WRITE     RCART
     C                   DELETE    RCARTS
     C                   GOTO      NXTCRT
     C                   END                                                    TRCRDT>strcy
     C                   ENDDO                                                  N55  DO
      ** GET NEXT ORDER
     C     LOCKEY        KLIST
     C                   KFLD                    STRCYM
     C                   KFLD                    SMASTER
     C                   KFLD                    CTITEM
     C                   KFLD                    CTSIZE
     C     LOCKEY        SETLL     NPUTORDP
     C     NXTLOC        TAG
     C     LOCKEY        READE     NPUTORDP                               91
     C   91              GOTO      ENDLOC
     C     PDQORD        IFLE      PDQSCH
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXTLOC
     C                   END
      ** IF HERE I NEED THIS TRAY
     C     NeedTray      TAG
     C                   MOVEL     PDLOC         CTLOC
     C                   Z-ADD     PDORD#        CTORD#
     C                   Z-ADD     PDSEQ#        CTSEQ#
     C     ORDKEY        KLIST
     C                   KFLD                    CTORD#
     C                   KFLD                    CTSEQ#
     C     CTORD#        CHAIN     FIORDR                             70
     C     CTORD#        IfNe      *Zero
     C     ORDKEY        SETLL     FIORDRPART
     C                   If        %Equal(FIORDRPART)
     C                   Eval      P = 'P'
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   Else
     C     CTTAG#        CHAIN     FTRAY
     C                   If        TRSTAT <> 'A'
     C                   Eval      P = TRSTAT
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   EndIf
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C  N70              DO
     C                   MOVEL     OILOTC        CTLOTC
     C                   MOVEL     OISTA         CTSTA
      ** CHECK BACKORDER
     C     OIPRBO        IFEQ      'B'
     C     OIBOLN        OREQ      'B'
     C                   MOVEL     'B'           CTBORD
     C                   ELSE
     C                   MOVE      *BLANKS       CTBORD
     C                   END                                                    OIPRBO=B
     C                   ENDDO                                                  N70  DO
     C     CTSTA         IFNE      'Y'
     C                   MOVEL     'N'           CTSTA
     C                   END
     C                   ADD       1             PDQSCH
     C                   UPDATE    RPUTORD
     C                   Z-ADD     CCCONT        CTCNTL
     C                   ADD       1             CTCSEQ
     C                   MOVEL     IMLOOK        CTLOOK
     C                   WRITE     RCART
     C                   DELETE    RCARTS
     C                   GOTO      NXTCRT
     C     ENDLOC        TAG
      *  ____________________________________________________________
      *  If no orders found and tray is full, look for partial order
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   If        %SubSt(CTITEM:12:1) = ' '
     C                   Eval      PartItem = %SubSt(CTITEM:1:11) + 'P'
     C     LOCKEY2       KLIST
     C                   KFLD                    STRCYM
     C                   KFLD                    SMASTER
     C                   KFLD                    PartItem         12
     C                   KFLD                    CTSIZE

     C     LOCKEY2       SETLL     NPUTORDP
     C     NXTLOC2       TAG
     C     LOCKEY2       READE     NPUTORDP                               91
     C   91              GOTO      ENDLOC2
     C     PDQORD        IFLE      PDQSCH
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXTLOC2
     C                   END

     C                   If        FirstTime or *In81
     C                   Write     CHGHDR
     C                   Eval      FirstTime = *Off
     C                   EndIf
      *  If using full flat....  delete the partial order record
     C                   Z-ADD     PDORD#        CTORD#
     C                   Z-ADD     PDSEQ#        CTSEQ#
     C     ORDKEY        Chain     FIORDRPART
     C                   If        %Found(FIORDRPART)
     C                   Delete    RIORDRPART
     C                   EndIf
     C                   Eval      PDITEM = CTITEM
     C                   Write     CHGDET
     C                   GOTO      NeedTray
     C                   EndIf
     C     ENDLOC2       TAG
      *  ____________________________________________________________
      *  If no orders found and tray is a partial tray
      *  and partials are OK then put part on full order
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   If        PartsAreOK and
     C                             %SubSt(CTITEM:12:1) = 'P'
     C                   Eval      PartItem = %SubSt(CTITEM:1:11) + ' '

     C     LOCKEY2       SETLL     NPUTORDP
     C     NXTLOC3       TAG
     C     LOCKEY2       READE     NPUTORDP                               91
     C   91              GOTO      ENDLOC3
     C     PDQORD        IFLE      PDQSCH
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXTLOC3
     C                   END

     C*                  If        FirstTime or *In81
     C*                  Write     CHGHDR
     C*                  Eval      FirstTime = *Off
     C*                  EndIf
     C*                  Eval      PDITEM = CTITEM
     C*                  Write     CHGDET
     C                   GOTO      NeedTray
     C                   EndIf
      *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     ENDLOC3       TAG
     C     MINKEY        CHAIN     FMINVT                             70
     C                   Z-ADD     CCCONT        CTCNTL
     C                   MOVE      *BLANKS       CTSTA
     C                   MOVE      *BLANKS       CTLOTC
     C                   MOVE      *BLANKS       CTLOC
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVEL     '99999999'    CTLOC
     C                   MOVEL     IMLOOK        CTLOOK
     C                   ADD       1             CTCSEQ
     C                   WRITE     RCART
     C                   DELETE    RCARTS
     C                   GOTO      NXTCRT
     C     ENDCRT        TAG
      *******************
      ** NOW PRINT REPORT
      *******************
     C     PRTONL        TAG
     C                   SETON                                        OF
     C                   Z-ADD     0             COUNT             3 0
     C                   Z-ADD     0             RBQTY             3 0
     C                   Z-ADD     999999        OLDORD            6 0
     C                   MOVE      *BLANKS       OITEM            12
     C                   MOVE      *BLANKS       OSIZE             3
     C                   MOVE      *Blanks       OTLOC1            6
     C                   MOVE      *Blanks       OTLOC2            6
     C     CRTKEY        KLIST
     C                   KFLD                    CARTNO
     C                   KFLD                    CONTRL
     C     CRTKEY        SETLL     NCARTCI
     C     NXTPRT        TAG
     C     CRTKEY        READE     NCARTCI                                90
     C   90              GOTO      ENDPRT
     C                   Eval      KeyItem = %subst(CTITEM:1:11) + ' '
     C     CTSHDT        IFNE      STRDAT
     C     CTMSTR        OrNE      SMASTER
     C                   GOTO      NXTPRT
     C                   END
     C     CTLOC         IFEQ      'ERROR'
     C     QTY           IFGT      0
     C                   EXCEPT    ITMDTL
     C                   Z-ADD     0             QTY
     C                   MOVE      *BLANKS       OITEM
     C                   END
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    ERRDET
     C                   ADD       1             COUNT
     C                   GOTO      NXTPRT
     C                   END
     C     CTORD#        IFNE      OLDORD
WJB  C     CTITEM        ORNE      OITEM
WJB  C*    KeyItem       ORNE      OITEM
     C     CTSIZE        ORNE      OSIZE
     C     OITEM         IFGT      *BLANKS
CAB  C                   EXCEPT    ITMDTL
     C                   If        OTLOC1 <> *Blanks or OTLOC2 <> *Blanks
     C                   Except    ORDDTL2
     C                   EndIf
CAB  C   OF              DO
CAB  C                   EXCEPT    HEAD
     C     OTLOC         IFLT      '999999'
     C                   Eval      *In93 = *Off
CAB  C                   GOTO      PASS
     C                   ELSE
     C                   EXCEPT    RDYDTL
     C                   Eval      *In93 = *On
     C                   END
CAB  C                   SETOFF                                       OF
CAB  C                   ENDDO                                                  OF  DO
     C                   END                                                    OITEM>" "
     C**
CAB  C     PASS          TAG
     C                   Z-ADD     0             QTY               3 0

     C     CTORD#        IfNe      *Zero
     C     ORDKEY        SETLL     FIORDRPART
     C                   If        %Equal(FIORDRPART)
     C                   Eval      P = 'P'
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   Else
     C     CTTAG#        CHAIN     FTRAY
     C                   If        TRSTAT <> 'A'
     C                   Eval      P = TRSTAT
     C                   Else
     C                   Eval      P = ' '
     C                   EndIf
     C                   EndIf

     C**
CAB2 C     CTORD#        IFEQ      0
CAB2 C     CTLOC         ANDEQ     *BLANKS
CAB2 C                   GOTO      BYPASS
CAB2 C                   END
     C**
     C     CTORD#        IFNE      OLDORD
     C     CTORD#        IFGT      0
     C     CTORD#        CHAIN     FHORDR                             71
     C                   Z-ADD     CTORD#        OLDORD            6 0
     C                   MOVE      CTLOC         OTLOC             6
     C                   MOVE      *Blanks       OTLOC1            6
     C                   MOVE      *Blanks       OTLOC2            6
     C     CTORD#        CHAIN     FPPO                               72
     C  N72              MOVEL     POLOWC        OTLOC1
     C  N72              MOVEL     POLOWF        OTLOC2
     C  N71              MOVEL     OHNAME        NAME             20
     C   71              Eval      Name = 'Order Not Found ===>'
     C   71              Eval      OHORD# = CTORD#
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C     OHSTA         IFEQ      'Y'
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
     C**  PRINTS THE ORDER DETAIL HERE
     C                   EXCEPT    ORDDTL
     C                   ELSE
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   SETOFF                                       55
     C                   EXCEPT    RDYDTL
     C                   Z-ADD     CTORD#        OLDORD
     C                   END                                                    CTORD#=0
     C                   END                                                    CTORD#<>OLDO
     C                   MOVEL     CTITEM        OITEM            12
     C                   MOVE      CTSIZE        OSIZE             3
     C                   MOVE      CTLOC         OTLOC             6
     C     MINKEY        KLIST
WJB  C*                  KFLD                    CTITEM
WJB  C                   KFLD                    KeyItem          12
     C                   KFLD                    CTSIZE
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C                   MOVE      *BLANKS       OSTA
     C                   MOVE      *BLANKS       OBORD
     C                   END                                                    ORD/ITM/SIZ
     C                   ADD       1             COUNT
     C                   ADD       1             QTY
     C     CTLOC         IFGE      '999999'
     C                   ADD       1             RBQTY
     C                   END
     C                   MOVEL     CTSTA         OSTA              1
     C                   MOVEL     CTBORD        OBORD             1
CAB2 C     BYPASS        TAG
     C                   GOTO      NXTPRT
     C     ENDPRT        TAG
     C     QTY           IFGT      0
     C                   EXCEPT    ITMDTL
     C                   END
     C     RBQTY         IFGT      0
     C                   EXCEPT    TOTR
     C                   END
     C     COUNT         IFGT      0
     C                   EXCEPT    TOTL
     C                   END
      ** GET SUMMARY
     C                   MOVE      *BLANKS       IMITEM
     C                   Z-ADD     0             QTY
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    SUMHED
     C     CRTKEY        SETLL     NCARTCC
     C     NXTSUM        TAG
     C     CRTKEY        READE     NCARTCC                                90
     C   90              GOTO      ENDSUM
     C                   Eval      KeyItem = %subst(CTITEM:1:11) + ' '
     C**
CAB2 C     CTLOC         IFEQ      *BLANKS
CAB2 C     CTORD#        ANDEQ     0
CAB2 C                   GOTO      NXTSUM
CAB2 C                   END
     C**
WJB  C     CTSHDT        IFNE      STRDAT
     C     CTMSTR        OrNE      SMASTER
WJB  C                   GOTO      NXTSUM
WJB  C                   END
WJB  C*    CTITEM        IFNE      IMITEM
WJB  C     KeyItem       IFNE      IMITEM
     C     CTSIZE        ORNE      IMSIZE
     C     QTY           IFGT      0
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   ExSr      CalcItmSum
     C                   EXCEPT    ITMSUM
     C                   END                                                    QTY>0
     C     MINKEY        CHAIN     FMINVT                             70
     C                   MOVEL     IMITEM        ITEM              5
     C                   MOVEL     IMSIZE        SIZE              3
     C                   If        %subst(CTITEM:12:1) = 'P'
     C                   Eval      P     = 'P'
     C                   Else
     C                   Eval      P     = *Blanks
     C                   EndIf
     C                   Z-ADD     0             QTY
     C                   END                                                    CTITEM><IMIT
     C                   ADD       1             QTY
     C                   GOTO      NXTSUM
      ** END OF SUMMARY
     C     ENDSUM        TAG
     C     QTY           IFGT      0
     C                   ExSr      CalcItmSum
     C                   EXCEPT    ITMSUM
CAB2 C                   EXCEPT    TOTQ
     C                   END
     C                   SETON                                        LR
      ***********************
      **         CalcItmSum - Calculate Item Summary for inclusion on summary line
      ***********************
     C     CalcItmSum    BegSr

     C     ItmSumKey     KList
     C                   KFld                    STRCYM
     C                   KFld                    SMASTER
     C                   KFld                    IMITEM
     C                   KFld                    IMSIZE

     C                   Eval      QtyOrdr = *Zero
     C                   Eval      QtyRcvd = *Zero

     C     ItmSumKey     SetLL     NCARTCR
     C     ItmSumKey     ReadE     NCARTCR
     C                   DoW       not %EOF(NCARTCR)
     C                   If        s_CTSTAT = 'A'
     C                   Eval      QtyRcvd = QtyRcvd + 1
     C                   EndIf
     C     ItmSumKey     ReadE     NCARTCR
     C                   EndDo

     C     ItmSumKey     SetLL     NPUTORDI
     C     ItmSumKey     ReadE     NPUTORDI
     C                   DoW       not %EOF(NPUTORDI)
     C                   Eval      QtyOrdr = QtyOrdr + s_PDQORD
     C     ItmSumKey     ReadE     NPUTORDI
     C                   EndDo

     C                   Eval      BalanceDue = QtyOrdr - QtyRcvd
     C                   If        BalanceDue < *Zero
     C                   Eval      BalanceDue = *Zero
     C                   EndIf

     C                   EndSr
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     CARTNO        CART4             4 0
     C                   Z-ADD     TIMOD         CTTIME
     C                   Z-ADD     TDATE         CTDTLA
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************  PRINT CONTROL NUMBER ABOVE CLIP
     ONCR230    E            HEAD           1 03
     O                                           68 'Control Number:'
     O                       CONTRL        1     74
      ****************** SKIP ALLOWS FOR CLIPBOARD USE
     O          E            HEAD           1 12
     O                                            6 'NCR230'
     O                                           16 'Scanner:'
     O                       USERID              27
     O**                                 21 'Requested by:'
     O**                       USERID    32
     O                                           50 'Customer Location for'
     O                                           58 'Cart #:'
     O                       CART4         4     62
     O                       PAGE          Z     80
     O                                           77 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'Time:'
     O                       TIMOD               80 '  :  :  '
     O                       REPRINT             52
     O          E            HEAD           1
     O                                            7 'Master:'
     O                       MNSEQ#              10
     O                       MNSEQD              58
     O          E            HEAD           1
WJB  O                                           46 'B/O'
CAB  O          E            HEAD           1
WJB  O                                            4 'Loc.'
WJB  O                                           15 'Customer'
WJB  O                                           34 'Order#'
WJB  O                                           41 'Item'
WJB  O                                           47 'STA'
     O                                           61 'Description'
     O                                           80 'Qty.'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          EF           ORDDTL      1  0
     O                       OTLOC                6
WJB  O                       NAME                27
WJB  O                       OHORD#        4     34
     O          EF           ORDDTL2     1  0
     O                                           25 '    Multiple Locations: ('
     O                       OTLOC               32
     O                                           35 ') ('
     O                       OTLOC1              42
     O                                           45 ') ('
     O                       OTLOC2              51
     O                                           52 ')'
     O          EF           RDYDTL      1  1
     O                       CTLOC                8
     O                       MSG(1)              39
     O          EF           ITMDTL         1
     O                       QTY           4     80
WJB  O                       IMDES1              77
WJB  O                       OSTA                46
WJB  O                       OBORD               45
WJB  O                       P                   44
WJB  O                       SIZE                43
WJB  O                       ITEM                40
     O          EF           ERRDET      1  1
     O                                            5 'Tag#:'
     O                       CTTAG#        4     13
     O                       ITEM                19
     O                       IMDES1              50
     O                       MSG(2)              81
     O          EF           TOTR           1
     O                                           80 '----'
     O          EF           TOTR           1
     O                                           75 'Total Extra Cart ====>'
     O                       RBQTY         2     80
     O          EF           TOTL        1  1
     O                                           70 'Total trays==========>'
     O                       COUNT         2     80
     O          EF           SUMHED      1  1
     O                                           60 ' Master '
     O                                           50 'Cart'
     O                                           40 '--------Summary---------'
     O          EF           SUMHED         0
     O                                           80 'Bal.'
     O                                           70 'Recvd'
     O                                           60 'Quantity'
     O                                           50 'Qty.'
     O                                           28 'Description'
     O                                           15 'Size'
     O                                            9 'Item'
     O          EF           SUMHED         1
     O                                           20 '     _______________'
     O                                           40 '____________________'
     O                                           50 '__________'
     O          EF           ITMSUM         1
     O                       BalanceDue    4     80
     O                       QtyRcvd       4     70
     O                       QtyOrdr       4     60
     O                       QTY           4     50
     O                       IMDES1              46
     O                       IMSIZE              15
     O                       ITEM                10
     O                       P                   11
CAB2 O          EF           TOTQ        1  1
CAB2 O                                           25 'Total trays==========>'
CAB2 O                       COUNT         2     38
      ******************
      * ERROR REPORT   *
      ******************
     ONCR230E   E            EHEAD          1 03
     O                                           68 'Control Number:'
     O                       CONTRL        1     74
     O          E            EHEAD          1
     O                                            7 'NCR230E'
     O                                           16 'Scanner:'
     O                       USERID              27
     O                                           50 'Customer Location for'
     O                                           58 'Cart #:'
     O                       CART4         4     62
     O                       PAGE          Z     80
     O                                           77 'Page:'
     O          E            EHEAD          1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           45 'Error List'
     O                                           72 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            EHEAD          1
     O                                            7 'Master:'
     O                       MNSEQ#              10
     O                       MNSEQD              58
     O          E            EHEAD          0
     O                                            5 'Item '
     O                                            9 'Size'
     O                                           21 'Description'
     O                                           80 'Ready Date'
     O          E            EHEAD          1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O          E            ERROR          1
     O                                           12 'Tag Number:'
     O                       CTTAG#        4     20
     O          E            ERROR          1
     O                       ITEM                 5
     O                       CTSIZE               9
     O                       IMDES1              40
     O                       MSG(2)              71
     O                       TRCRDT              80 ' -  /  /  '
** Messages
Extra Cart ******                          1
Tray is for a Future Week:                 2
