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
      **PROGRAM NAME-------- CHGTAX
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- CHANGE TAX STATUS OR ORDER DETAIL FILE
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
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
      ** SKIP COMMENT
     C     OIITYP        IFEQ      'C'
     C                   GOTO      NXTIOR
     C                   END
      ** IF EXEMPT MOVE NO
     C     OHTXST        IFEQ      'Y'
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
     C                   END
      ** GET STOCK INVENTORY
     C     OIITYP        IFEQ      ' '
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     MINKEY        CHAIN     FMINVT                             91
     C     OHTXST        IFEQ      'Y'
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   ELSE
     C                   MOVEL     IMTXBL        OITXCD
     C                   MOVEL     IMTCD1        OITXST
     C                   MOVEL     IMTCD2        OITXCT
     C                   MOVEL     IMTCD3        OITXLC
     C                   END
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
     C                   END
      ** GET FREIGHT
     C     OIITYP        IFEQ      'F'
     C                   MOVE      OHFRTX        OITXCD
     C                   MOVE      OHFRTX        OITXST
     C                   MOVE      OHFRTX        OITXCT
     C                   MOVE      OHFRTX        OITXLC
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
     C                   END
      ** GET SPECIAL CHARGE
     C     OIITYP        IFEQ      'S'
     C                   MOVE      OHSPTX        OITXCD
     C                   MOVE      OHSPTX        OITXST
     C                   MOVE      OHSPTX        OITXCT
     C                   MOVE      OHSPTX        OITXLC
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
     C                   END
      ** GET NON STOCK INVENTORY
     C     OIITYP        IFEQ      'N'
     C     OHTXST        IFEQ      'Y'
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   ELSE
     C                   MOVE      'Y'           OITXCD
     C                   MOVE      'Y'           OITXST
     C                   MOVE      'Y'           OITXCT
     C                   MOVE      'Y'           OITXLC
     C                   END
     C                   UPDATE    RIORDR
     C                   GOTO      NXTIOR
     C                   END
      ** SHOULD NEVER GET HERE
     C                   GOTO      NXTIOR
      *
     C     END           TAG
     C                   SETON                                        LR
