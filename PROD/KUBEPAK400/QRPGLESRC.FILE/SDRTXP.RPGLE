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
      **PROGRAM NAME-------- SDRTXP
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER----------
      **APPLICATION---------
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMINSER   IF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
     FFTCOST    IF   E           K DISK
     FFOCOST    IF   E           K DISK
     FFMINVTL3  IF   E           K DISK    RENAME(RMINVT:SEDINVT) PREFIX(SED)
      *
      * PRICE ARRAY
     D PRC             S              9  4 DIM(3)                               PRICES
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

     D  WksCount       S              1S 0
     D  Wks2Germ       S              4S 2

     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)
      ****************
      *  PARMS       *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE                         TXP FRM SIZE
     C                   PARM                    PLGCST            9 6
     C                   Z-ADD     0             PLGCST
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C   90              GOTO      END
     C                   Z-ADD     0             OLDPRC            9 4
     C                   MOVE      *BLANKS       OLIST             4
     C     IMITEM        CHAIN     FMINSER                            88
     C  N88ISCODE        CHAIN     FSERIES                            88
     C     NEWVND        TAG
      ** GET VENDORS COST
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    SECODE
     C     PRCKEY        CHAIN     FSERPRC                            87
     C   87              DO
     C                   Z-ADD     0             PRC
     C                   Z-ADD     0             SSPRC             7 6
     C                   GOTO      NOSERI
     C                   ENDDO
      ** GET PRICE EACH
     C     PRC(SEFORM)   DIV(H)    1000          SSPRC
     C**                   Z-ADDPRC,SEFORMSELSPR
     C     NOSERI        TAG
     C     IMSIZE        CHAIN     FMSIZE                             90
     C     SZCELL        MULT      IM#SED        #SED              4 0
     C     #SED          MULT(H)   SSPRC         SEDCST            9 4
      ** GET FIXED COST
      *? Calculate Sow Factor and Add to Seed Cost
     C                   Eval      SEDIMMULT = 0
     C     IMITEM        Chain     FMINVTL3
     C                   Eval      SEDCST = SEDCST * ( 1 + ( SEDIMMULT / 100 ))
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
     C                   Z-ADD     0             FIXCST            9 4
     C     TCSKEY        KLIST
     C                   KFLD                    ITEMB
     C                   KFLD                    IMSIZE
     C                   KFLD                    TSOW
     C                   MOVE      *BLANKS       ITEMB            12
     C                   MOVEL     IMTPSW        TSOW              1
     C     RTRY          TAG
     C                   Eval      TOCOST = 0
     C* wjb              Eval      TOGERM = 100
RED |C     TCSKEY        Chain     FOCOST
wjb  C                   Eval      TOGERM = 100
     C     TCSKEY        Chain     FOCOST
wjb  C                   Call      '$FACTGERM'
wjb  C                   Parm                    IMITEM
wjb  C                   Parm                    IMSIZE
wjb  C                   Parm                    GERM              5 4
wjb  C                   If        GERM <> 0
wjb  C                   Eval      TOGERM = GERM * 100
wjb  C                   EndIf
     C                   Eval      FIXCST = Wks2Germ * TOCOST
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
     C     SEDCST        ADD       FIXCST        WRKCST
     C     WRKCST        DIV(H)    SZSALE        PLGCST
     C                   Eval      PLGCST = ( PLGCST * 100 ) / TOGERM
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
