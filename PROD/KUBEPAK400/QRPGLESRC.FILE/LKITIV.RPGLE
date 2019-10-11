      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- LKCITIV
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **DESCRIPTION--------- CUSTOMER/ITEM INVOICE LOOKUP
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FLKITIVFM  CF   E             WORKSTN
     F                                     SFILE(INVSFL:RECNO)
     FFMCUST    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFIORWCID  IF   E           K DISK
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMCUST
     C                   PARM                    WICOMP
     C                   PARM                    WIITEM
     C                   PARM                    WISIZE
     C                   PARM                    WIWHSE
     C                   PARM                    WIINV#
      ** GET CUSTOMER
     C     CMCUST        CHAIN     FMCUST                             90
      ** GET ITEM
     C     MINKEY        KLIST
     C                   KFLD                    WIITEM
     C                   KFLD                    WISIZE
     C                   KFLD                    WIWHSE
     C     MINKEY        CHAIN     FMINVT                             90
      ** GET DESCRIPTION
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC
     C     INVKEY        KLIST
     C                   KFLD                    CMCUST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
      *
     C                   Z-ADD     0             LINE              5 0
     C     INVKEY        SETLL     FIORWCID
     C                   MOVE      '1'           *IN80
     C                   WRITE     INVCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     INVKEY        READE     RIORDW                                 50
     C   50              GOTO      DSPL
      *
     C                   Z-ADD     WIQORD        QTYORD
     C                   Z-ADD     WIQSHP        QTYSHP
     C                   Z-ADD     WIQCRM        QTYCRD
     C                   Z-ADD     WIAMT         AMOUNT
     C                   ADD       1             RECNO
     C                   WRITE     INVSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
      *
     C     NXTFMT        TAG
     C                   EXFMT     INVCTL
     C   KF              DO
     C                   Z-ADD     *ZEROS        WICOMP
     C                   Z-ADD     *ZEROS        WIINV#
     C                   GOTO      END
     C                   ENDDO
     C     LINE          IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
     C*          LINE#     IFGT LSTREC
     C*                    SETON                     90
     C*                    GOTO NXTFMT
     C*                    END
      ** GET THE SELECTED ITEM
     C                   Z-ADD     LINE          RECNO
     C     RECNO         CHAIN     INVSFL                             90
     C   90              GOTO      NXTFMT
     C     END           TAG
     C                   SETON                                        LR
      **
