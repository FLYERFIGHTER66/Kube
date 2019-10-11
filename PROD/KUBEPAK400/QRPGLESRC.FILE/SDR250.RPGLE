      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      **PROGRAM NAME-------- SDR250
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ITEM COST INQUIRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSDR250FM  CF   E             WORKSTN
     FFMINVT    UF   E           K DISK
     FFMINVTL3  IF   E           K DISK    RENAME(RMINVT:SEDINVT) PREFIX(SED)
     FFMINSER   IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFLISTCD   IF   E           K DISK
     FFTCOST    IF   E           K DISK
     FFOCOST    IF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
      *
     D PRC             S              9  4 DIM(3)                               PRICES
     D FCGERM          S                   LIKE(TOGERM)                         Factor Table Germ%
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
      *
     D  WksCount       S              1S 0
      *
     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)
      ****************
      *   START HERE *
      ****************
     C                   MOVE      *BLANKS       SIZE
     C     RSTART        TAG
     C                   Clear                   SCRNB
     C                   Clear                   SCRNC
     C                   MOVE      *BLANKS       ITEM
     C                   SETOFF                                       1011
     C     NXTA          TAG                                                                   ARC38
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       10
     C                   MOVEL     ITEM          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     SIZE          IMSIZE
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR            3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   GOTO      NXTA
     C                   END
      ** CHECK ITEM
     C     MINKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     MINKEY        CHAIN(N)  FMINVT                             10
     C   10              GOTO      NXTA
      ** SEE IF TRANSPLANT FROM
     C     IMTPSW        IFEQ      'P'
     C     IMFRSZ        ANDGT     *BLANKS
     C                   GOTO      RSTRTC
     C                   END
      ********************
      ** SCREEN B       **
      ********************
     C     RSTRTB        TAG
     C                   Z-ADD     0             OLDPRC            9 4
     C                   Z-ADD     0             NEWPRC
     C                   Z-ADD     0             NTRDSC
     C                   Z-ADD     0             NNTPRC
     C                   Z-ADD     0             MARG
     C                   Z-ADD     0             NMRPCT
     C                   MOVE      *BLANKS       OLIST             4
     C                   MOVE      *BLANKS       LIST
     C                   SETOFF                                       6061
     C     ITEM          CHAIN     FMINSER                            88
     C  N88ISCODE        CHAIN     FSERIES                            88
     C   88              DO
     C                   MOVE      *BLANKS       LVNAME
     C                   MOVE      *BLANKS       HVNAME
     C                   MOVE      *BLANKS       SVNAME
     C                   MOVE      *BLANKS       SEFORM
     C                   MOVE      *BLANKS       SEDESC
     C                   MOVE      *BLANKS       SECODE
     C                   Z-ADD     0             SELPRC
     C                   Z-ADD     0             SEHPRC
     C                   Z-ADD     0             SELSPR
     C                   Z-ADD     0             SEHVND
     C                   Z-ADD     0             SELVND
     C                   Z-ADD     0             ISVEND
     C                   GOTO      NOSERI
     C                   ENDDO
     C     NEWVND        TAG
      ** GET SEED INFO
     C     SEHVND        CHAIN     FMVEND                             90
     C   90              MOVE      *BLANKS       HVNAME
     C  N90              MOVEL     VMNAME        HVNAME
     C     SELVND        CHAIN     FMVEND                             90
     C   90              MOVE      *BLANKS       LVNAME
     C  N90              MOVEL     VMNAME        LVNAME
     C     SEVND         CHAIN     FMVEND                             90
     C   90              MOVE      *BLANKS       SVNAME
     C  N90              MOVEL     VMNAME        SVNAME
      ** GET VENDORS COST
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    SECODE
     C     PRCKEY        CHAIN     FSERPRC                            87
     C   87              DO
     C                   Z-ADD     0             SSPRC
     C                   Z-ADD     0             PRC
     C                   GOTO      NOSERI
     C                   ENDDO
      ** GET PRICE EACH
     C     PRC(SEFORM)   DIV(H)    1000          SSPRC
     C                   Z-ADD     PRC(SEFORM)   SELSPR
     C     NOSERI        TAG
     C     SIZE          CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = SZSALE
     C                   EndIf
     C     SZCELL        MULT      IM#SED        #SED              4 0
     C     #SED          MULT(H)   SSPRC         SEDCST
      *? Calculate Sow Factor and Add to Seed Cost
     C                   Eval      SEDIMMULT = 0
     C     IMITEM        Chain     FMINVTL3
     C                   Eval      SMMULT = 1 + (SEDIMMULT/100)
     C                   Eval      SEDCST = SEDCST * SMMULT
      *? Calculate Average Weeks to Grow
     C                   Eval      WksCount = 0
     C                   If        IMWG1 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG2 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG3 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG4 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        WksCount = 0
     C                   Eval      WksCount = 1
     C                   EndIf
     C                   Eval      Wks2Germ  = (IMWG1 + IMWG2 + IMWG3 + IMWG4)/
     C                             WksCount
      ** GET FIXED COST
     C                   Z-ADD     0             FIXCST
     C                   MOVEL     IMTPSW        TSOW              1
     C     RTRY          TAG
     C     TCSKEY        KLIST
     C                   KFLD                    ITEMB
     C                   KFLD                    SIZE
     C                   KFLD                    TSOW
     C                   MOVE      *BLANKS       ITEMB            12
     C                   Eval      TOCOST = 0
     C* wjb              Eval      TOGERM = 100
wjb  C                   Eval      FCGERM = 100
     C     TCSKEY        Chain     FOCOST
wjb  C                   Call      '$FACTGERM'
wjb  C                   Parm                    ITEM
wjb  C                   Parm                    SIZE
wjb  C                   Parm                    GERM              5 4
wjb  C                   If        GERM <> 0
wjb  C                   Eval      FCGERM = GERM * 100
wjb  C                   EndIf
     C                   Eval      TOTOVR = Wks2Germ * TOCOST
     C                   Eval      FIXCST = TOTOVR
     C     TCSKEY        SETLL     FTCOST
     C     NXTCST        TAG
     C     TCSKEY        READE     FTCOST                                 90
     C   90              DO
     C     FIXCST        IFEQ      0
     C     TSOW          ANDGT     *BLANKS
     C                   MOVE      *BLANKS       TSOW
     C                   GOTO      RTRY
     C                   ENDIF
     C                   ENDDO
     C  N90              DO
     C     TCQTY         MULT(H)   TCUCST        WRKCST            9 4
     C                   ADD       WRKCST        FIXCST
     C                   GOTO      NXTCST
     C                   ENDDO
     C     SEDCST        ADD       FIXCST        TOTCST
     C                   Eval      TRAYCOST = TOTCST
     C* WJB              Eval      TOTCST = ( TOTCST * 100 ) / TOGERM
WJB  C                   Eval      TOTCST = ( TOTCST * 100 ) / FCGERM
      ** GET PRICE
     C     IMLIST        IFGT      *BLANKS
     C     IMLIST        CHAIN     FLISTCD                            51
     C                   Z-ADD     LCSEL5        UPRICE
     C                   ELSE
     C                   Z-ADD     IMSEL5        UPRICE
     C                   END
      ** CALC TRADE DISCOUNT
     C     UPRICE        IFGT      0.0000
     C*    UPRICE        MULT      .20           TRDSC
     C     UPRICE        MULT      .23           TRDSC
     C     UPRICE        SUB       TRDSC         NETPRC
     C     NETPRC        SUB(H)    TOTCST        MARGIN                 55
     C     MARGIN        DIV(H)    NETPRC        MARWRK            9 6
     C     MARWRK        MULT      100           MARPCT            9 4
     C                   ELSE
     C                   Z-ADD     0             TRDSC
     C                   Z-ADD     0             NETPRC
     C                   Z-ADD     0             MARGIN
     C                   Z-ADD     0             MARPCT
     C                   END
      *********************
      ** DISPLAY SCREEN B *
      *********************
     C     NXTB          TAG
      ** SEE IF PRICE CHANGE NEEDED
     C   60              DO
     C                   SETOFF                                       61
     C     NEWPRC        IFGT      0.0000
     C     LIST          ORGT      *BLANKS
     C     LIST          IFNE      IMLIST
     C                   SETON                                        61
     C                   ELSE
     C     NEWPRC        IFNE      IMSEL5
     C                   SETON                                        61
     C                   END
     C                   END
     C                   END
     C                   ENDDO
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
      ** CHECK FOR NEW VENDOR
     C   KB              DO
     C                   CALL      'SDR500'
     C                   PARM                    ISCODE
     C                   PARM                    SPVEND
     C                   PARM                    SEFORM
     C                   Z-ADD     SPVEND        ISVEND
     C                   GOTO      NEWVND
     C                   ENDDO
      ** SEE IF WE NEED TO CALC NEW PRICE
     C     NEWPRC        IFNE      OLDPRC
     C     LIST          ORNE      OLIST
     C                   SETON                                        60
     C                   EXSR      GETNEW
     C   10              GOTO      NXTB
     C                   END
      ** SEE IF WE NEED TO UPDATE PRICE IN MINVT
     C   KD              DO
     C     LIST          IFLE      *BLANKS
     C     NEWPRC        ORLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTB
     C                   END
      ** IF HERE UPDATE MINVT
     C     LIST          CHAIN     FLISTCD                            91
     C     MINKEY        CHAIN     FMINVT                             90
     C   91              Z-ADD     NEWPRC        IMSEL5
     C  N91              DO
     C                   Z-ADD     LCSEL1        IMSEL1
     C                   Z-ADD     LCSEL2        IMSEL2
     C                   Z-ADD     LCSEL3        IMSEL3
     C                   Z-ADD     LCSEL4        IMSEL4
     C                   Z-ADD     LCSEL5        IMSEL5
     C                   ENDDO
     C                   MOVEL     LIST          IMLIST
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   MOVEL     USERID        IMUSER
     C  N90              UPDATE    RMINVT
     C                   GOTO      RSTRTB
     C                   ENDDO
     C                   GOTO      NXTB
      ********************
      ** SCREEN C       **
      ********************
     C     RSTRTC        TAG
     C                   Z-ADD     0             OLDPRC            9 4
     C                   Z-ADD     0             NEWPRC
     C                   Z-ADD     0             NTRDSC
     C                   Z-ADD     0             NNTPRC
     C                   Z-ADD     0             MARG
     C                   Z-ADD     0             NMRPCT
     C                   MOVE      *BLANKS       OLIST             4
     C                   MOVE      *BLANKS       LIST
     C                   SETOFF                                       6061
     C     ITEM          CHAIN     FMINSER                            88
     C  N88ISCODE        CHAIN     FSERIES                            88
     C   88              DO
     C                   MOVE      *BLANKS       LVNAME
     C                   MOVE      *BLANKS       HVNAME
     C                   MOVE      *BLANKS       SVNAME
     C                   MOVE      *BLANKS       SEFORM
     C                   MOVE      *BLANKS       SEDESC
     C                   MOVE      *BLANKS       SECODE
     C                   Z-ADD     0             SELPRC
     C                   Z-ADD     0             SEHPRC
     C                   Z-ADD     0             SELSPR
     C                   Z-ADD     0             SEHVND
     C                   Z-ADD     0             SELVND
     C                   Z-ADD     0             ISVEND
     C                   GOTO      NOSER1
     C                   ENDDO
      ** GET VENDORS COST
     C*          PRCKEY    KLIST
     C*                    KFLD           SEVND
     C*                    KFLD           SECODE
     C     PRCKEY        CHAIN     FSERPRC                            87
     C   87              DO
     C                   Z-ADD     0             SSPRC
     C                   Z-ADD     0             PRC
     C                   GOTO      NOSER1
     C                   ENDDO
     C                   EXSR      GETPLG
      ** GET PRICE EACH
     C     NOSER1        TAG
     C     SIZE          CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = 100
     C                   EndIf
     C     SZCELL        MULT      IM#SED        #SED              4 0
     C     #SED          MULT(H)   PLPRC         PLGCST
      ** GET FIXED COST
      *? Calculate Average Weeks to Grow
     C                   Eval      SEDIMMULT = 0
     C*    IMITEM        Chain     FMINVTL3
     C*                  Eval      SMMULT = 1 + (SEDIMMULT/100)
     C*                  Eval      SEDCST = SEDCST * SMMULT
      *? Calculate Average Weeks to Grow
     C                   Eval      WksCount = 0
     C                   If        IMWG1 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG2 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG3 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG4 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        WksCount = 0
     C                   Eval      WksCount = 1
     C                   EndIf
     C                   Eval      TRAWTG    = (IMWG1 + IMWG2 + IMWG3 + IMWG4)/
     C                             WksCount
     C                   Z-ADD     0             FIXCST
     C                   MOVEL     IMTPSW        TSOW              1
     C     RTRY1         TAG
     C*          TCSKEY    KLIST
     C*                    KFLD           ITEMB
     C*                    KFLD           SIZE
     C*                    KFLD           TSOW
     C                   MOVE      *BLANKS       ITEMB            12
     C     TCSKEY        Chain     FOCOST
     C                   Eval      TRAWKOVRHD = TOCOST
     C                   Eval      TRAOVRHD = TRAWTG * TRAWKOVRHD
HERE C                   Eval      FIXCST = TRAOVRHD
     C     TCSKEY        SETLL     FTCOST
     C     NXTCS2        TAG
     C     TCSKEY        READE     FTCOST                                 90
     C   90              DO
     C     FIXCST        IFEQ      0
     C     TSOW          ANDGT     *BLANKS
     C                   MOVE      *BLANKS       TSOW
     C                   GOTO      RTRY1
     C                   ENDIF
     C                   ENDDO
     C  N90              DO
     C     TCQTY         MULT(H)   TCUCST        WRKCST            9 4
     C                   ADD       WRKCST        FIXCST
     C                   GOTO      NXTCS2
     C                   ENDDO
     C     PLGCST        ADD       FIXCST        TOTCST
      ** GET PRICE
     C     IMLIST        IFGT      *BLANKS
     C     IMLIST        CHAIN     FLISTCD                            51
     C                   Z-ADD     LCSEL5        UPRICE
     C                   ELSE
     C                   Z-ADD     IMSEL5        UPRICE
     C                   END
      ** CALC TRADE DISCOUNT
     C     UPRICE        IFGT      0.0000
     C*    UPRICE        MULT      .20           TRDSC
     C     UPRICE        MULT      .23           TRDSC
     C     UPRICE        SUB       TRDSC         NETPRC
     C     NETPRC        SUB(H)    TOTCST        MARGIN                 55
     C     MARGIN        DIV(H)    NETPRC        MARWRK            9 6
     C     MARWRK        MULT      100           MARPCT            9 4
     C                   ELSE
     C                   Z-ADD     0             TRDSC
     C                   Z-ADD     0             NETPRC
     C                   Z-ADD     0             MARGIN
     C                   Z-ADD     0             MARPCT
     C                   END
      *********************
      ** DISPLAY SCREEN C *
      *********************
     C     NXTC          TAG
      ** SEE IF PRICE CHANGE NEEDED
     C   60              DO
     C                   SETOFF                                       61
     C     NEWPRC        IFGT      0.0000
     C     LIST          ORGT      *BLANKS
     C     LIST          IFNE      IMLIST
     C                   SETON                                        61
     C                   ELSE
     C     NEWPRC        IFNE      IMSEL5
     C                   SETON                                        61
     C                   END
     C                   END
     C                   END
     C                   ENDDO
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
      ** SEE IF WE NEED TO CALC NEW PRICE
     C     NEWPRC        IFNE      OLDPRC
     C     LIST          ORNE      OLIST
     C                   SETON                                        60
     C                   EXSR      GETNEW
     C   10              GOTO      NXTC
     C                   END
      ** SEE IF WE NEED TO UPDATE PRICE IN MINVT
     C   KD              DO
     C     LIST          IFLE      *BLANKS
     C     NEWPRC        ORLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTC
     C                   END
      ** IF HERE UPDATE MINVT
     C     LIST          CHAIN     FLISTCD                            91
     C     MINKEY        CHAIN     FMINVT                             90
     C   91              Z-ADD     NEWPRC        IMSEL5
     C  N91              DO
     C                   Z-ADD     LCSEL1        IMSEL1
     C                   Z-ADD     LCSEL2        IMSEL2
     C                   Z-ADD     LCSEL3        IMSEL3
     C                   Z-ADD     LCSEL4        IMSEL4
     C                   Z-ADD     LCSEL5        IMSEL5
     C                   ENDDO
     C                   MOVEL     LIST          IMLIST
     C                   Z-ADD     TDATE         IMDTLA
     C                   Z-ADD     TIMOD         IMTIME
     C                   MOVEL     USERID        IMUSER
     C  N90              UPDATE    RMINVT
     C                   GOTO      RSTRTC
     C                   ENDDO
     C                   GOTO      NXTC
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** CALC NEW PRICE    **
      ***********************
     C     GETNEW        BEGSR
     C                   MOVEL     LIST          TST1
     C     TST1          IFEQ      '/'
     C     TST1          OREQ      '?'
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE            4
     C                   PARM                    LCDESC           30
     C                   END
      ** GET PRICE
     C     LIST          IFGT      *BLANKS
     C*                  MOVE      LIST          TST1              1
     C*    TST1          IFLE      *BLANKS
     C*                  MOVEL     LIST          LST3              3
     C*                  MOVE      *BLANKS       LIST
     C*                  MOVE      LST3          LIST
     C*                  END
     C     LIST          CHAIN     FLISTCD                            10
     C                   Z-ADD     LCSEL5        NEWPRC
     C   10              MOVE      *BLANKS       OLIST
     C   10              GOTO      ENDNEW
     C                   END
      ** CALC TRADE DISCOUNT
     C*    NEWPRC        MULT      .20           NTRDSC
     C     NEWPRC        MULT      .23           NTRDSC
     C     NEWPRC        SUB       NTRDSC        NNTPRC
     C     NNTPRC        SUB(H)    TOTCST        MARG                   56
     C     MARG          DIV(H)    NNTPRC        MARWRK            9 6
     C     MARWRK        MULT      100           NMRPCT            9 4
     C                   Z-ADD     NEWPRC        OLDPRC
     C                   MOVEL     LIST          OLIST
     C     ENDNEW        ENDSR
      ***********************
      ** GET PLUG PRICE    **
      ***********************
     C     GETPLG        BEGSR
      ** GET VENDORS COST
     C*          PRCKEY    KLIST
     C*                    KFLD           SEVND
     C*                    KFLD           SECODE
     C     MINFRM        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMFRSZ
     C     MINFRM        CHAIN(N)  FMINVT                             10
      ** GET PRICE EACH
     C     PRC(SEFORM)   DIV(H)    1000          SSPRC                          ?Seed Price
     C     IMSIZE        CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = 100
     C                   EndIf
     C                   Z-ADD     SZCELL        SEDCEL                         ?Number of Cells
     C                   Z-ADD     SZSALE        PLGCEL                         ?Saleable Cells
     C                   Z-ADD     IM#SED        F#SED                          ?Seeds per Cell
     C                   MOVEL     IMTPSW        FTSOW             1
     C     SEDCEL        MULT      F#SED         #SED              4 0          ?Number of Seeds
     C     #SED          MULT(H)   SSPRC         SEDCST                         ?Seed Cost
      *? Calculate Average Weeks to Grow
     C                   Eval      SEDIMMULT = 0
     C     IMITEM        Chain     FMINVTL3
     C                   Eval      SMMULT = 1 + (SEDIMMULT/100)
     C                   Eval      SEDCST = SEDCST * SMMULT
      *? Calculate Average Weeks to Grow
     C                   Eval      WksCount = 0
     C                   If        IMWG1 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG2 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG3 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        IMWG4 <> 0
     C                   Eval      WksCount = WksCount + 1
     C                   EndIf
     C                   If        WksCount = 0
     C                   Eval      WksCount = 1
     C                   EndIf
     C                   Eval      PLGWTG    = (IMWG1 + IMWG2 + IMWG3 + IMWG4)/
     C                             WksCount
      ** GET ORIGINAL ITEM AND SIZE
     C     MINKEY        CHAIN(N)  FMINVT                             10
     C     IMSIZE        CHAIN     FMSIZE                             90
     C                   If        IMTPSW = 'R'
     C                   Eval      SZCELL = 100
     C                   EndIf
      ** GET FIXED COST
     C                   Z-ADD     0             FIXPLG                         ?Fix Cost of Plug
     C     RTR1          TAG
     C     TCSKY         KLIST
     C                   KFLD                    ITEMB
     C                   KFLD                    IMFRSZ
     C                   KFLD                    FTSOW
     C                   MOVE      *BLANKS       ITEMB            12
     C     TCSKY         Chain     FOCOST
wjb  C                   Call      '$FACTGERM'
wjb  C                   Parm                    ITEM
wjb  C                   Parm                    IMFRSZ
wjb  C                   Parm                    GERM
wjb  C                   If        GERM <> 0
wjb  C                   Eval      FCGERM = GERM * 100
wjb  C                   EndIf
     C                   Eval      PLGWKOVRHD = TOCOST
     C                   Eval      PLGOVRHD = PLGWTG * PLGWKOVRHD
     C* wjb              Eval      PLGGERM = TOGERM
wjb  C                   Eval      PLGGERM = FCGERM
     C                   Eval      FIXPLG = PLGOVRHD
     C     TCSKY         SETLL     FTCOST
     C     NXTCS1        TAG
     C     TCSKY         READE     FTCOST                                 90
     C   90              DO
     C     FIXPLG        IFEQ      0
     C     FTSOW         ANDGT     *BLANKS
     C                   MOVE      *BLANKS       FTSOW
     C                   GOTO      RTR1
     C                   ENDIF
     C                   ENDDO
     C  N90              DO
     C     TCQTY         MULT(H)   TCUCST        WRKCST            9 4
     C                   ADD       WRKCST        FIXPLG
     C                   GOTO      NXTCS1
     C                   ENDDO
     C     SEDCST        ADD       FIXPLG        TOTPLG
     C                   Eval      TOTPLGCOST = ( TOTPLG * 100 ) / PLGGERM
     C     TOTPLG        DIV(H)    PLGCEL        PLPRC
     C                   Eval      PLPRC = ( PLPRC * 100 ) / PLGGERM
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
