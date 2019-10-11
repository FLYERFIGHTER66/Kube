      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1996
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
      **PROGRAM NAME-------- CHGPRC
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- CHANGE PRICE CODE IN ORDER DETAIL FILE
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    IF   E           K DISK
     FFIORDR    UF   E           K DISK
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    OHORD#
      * GET ORDER HEADER
     C     OHORD#        CHAIN     FHORDR                             90
     C   90              GOTO      END
     C     OHORD#        SETLL     FIORDR
     C     NXTIOR        TAG
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      END
      ** SKIP ALL EXCEPT STOCK ITEMS
     C     OIITYP        IFNE      ' '
     C     OIOVER        OREQ      'Y'
     C                   GOTO      NXTIOR
     C                   END
      ** GET STOCK INVENTORY
     C                   Z-ADD     OIUPRI        #OPRC
     C                   Z-ADD     OIQORD        ORDQTY            8 1
     C                   MOVEL     OHPRCD        PRICD
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIUUOM
     C                   PARM                    ORDQTY
     C                   PARM                    PRICD             1
     C                   PARM                    #OPRC             9 4
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC            4 2
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
     C     #OPRC         IFEQ      OIUPRI
     C                   GOTO      NXTIOR
     C                   END
     C                   Z-ADD     #OPRC         #PRC              9 4
     C                   Z-ADD     0             OIQDDC
     C     OIQORD        MULT(H)   OIUPRI        #LINGR            9 2
      *
      *  CALCULATE LINE NET AMOUNT
      *
     C     OIQORD        MULT(H)   #PRC          OIEXT$
      *
      *  CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       OIEXT$        OIDISC
     C                   Z-ADD     #OPRC         OIUPRI
     C                   MOVEL     PRICD         OIOVER
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
      *
     C     END           TAG
     C                   SETON                                        LR
