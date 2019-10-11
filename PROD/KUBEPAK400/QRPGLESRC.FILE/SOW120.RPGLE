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
      **PROGRAM NAME-------- SOW120
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD FILE TO PRINT SOW LINE LABELS
      *                      AFTER CANCEL RESTART.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    IF   E           K DISK
     FFSOWLAB   O  A E             DISK
     FFTRAY     IF   E           K DISK
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
     D  SOWLN                  1      1  0                                      ARC380
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    BEGLAB            8 0
     C                   PARM                    ENDLAB            8 0
     C                   MOVE      *BLANKS       LCANCL
      ** SET TO FIRST LABEL
     C     BEGLAB        SETLL     FTRAY
     C     NXT           TAG
     C                   READ      FTRAY                                  90
     C   90              GOTO      END
     C     TRTAG#        IFGT      ENDLAB
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
     C                   WRITE     RSOWLAB
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
