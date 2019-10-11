      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- SOW115
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- REPRINT LABELS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSOW115FM  CF   E             WORKSTN
     FFTRAY     IF   E           K DISK
     FFTRAYR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFOINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFSOWLAB   O  A E             DISK
      *
      *
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             BTAG#
     C                   Z-ADD     0             ETAG#
     C                   MOVEL     RPRTR         PRTID
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       1020
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      ** CHECK TAG#
     C                   SETOFF                                       11
     C     BTAG#         CHAIN     FTRAY                              10
     C   10              SETON                                        11
     C   10BTAG#         CHAIN     FTRAYR                             10
     C   10              GOTO      NXTA
      ** CHECK PRINTER
     C     PRTID         IFNE      'P4'
     C     PRTID         ANDNE     'R1'
     C     PRTID         ANDNE     'R2'
     C     PRTID         ANDNE     'L4'
     C     PRTID         ANDNE     'L2'
     C     PRTID         ANDNE     'L7'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
     C                   MOVEL     PRTID         RPRTR
      ** SET TO FIRST LABEL
     C     BTAG#         SETLL     FTRAY
     C     BTAG#         SETLL     FTRAYR
     C     NXT           TAG
     C  N11              READ      FTRAY                                  90
     C   11              READ      FTRAYR                                 90
     C   90              GOTO      END
     C     TRTAG#        IFGT      ETAG#
     C                   GOTO      END
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    TRITEM
     C                   KFLD                    TRSIZE
     C     MINKEY        CHAIN     FMINVT                             91
      ** GET COMMON FIELDS
     C                   MOVEL     TRITEM        SLITEM
     C                   MOVEL     TRSIZE        SLSIZE
     C                   MOVE      TRSCYM        SLSOW
     C                   MOVE      TRORDT        SLRDY
     C                   MOVEL     IMDES1        SLDESC
     C                   MOVEL     IMLOC         SLLOC
     C                   MOVEL     IMTPSW        SLTPSW
     C                   MOVEL     IMMSCX        SLMSCX
     C                   MOVEL     IM#SED        SL#SED
     C                   Z-ADD     TRTAG#        SLTAG#
     C     MINKEY        CHAIN     FOINVT                             98
     C  N98              MOVE      OVSALE        SALE3             3
     C   98TRSIZE        CHAIN     FMSIZE                             99
     C   98
     CANN99              MOVE      SZSALE        SALE3             3
     C  N99              MOVEL     SALE3         SLSIZE
     C   99              MOVEL     TRSIZE        SLSIZE
     C                   MOVEL     TRSIZE        SLSIZE
     C                   WRITE     RSOWLAB
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
