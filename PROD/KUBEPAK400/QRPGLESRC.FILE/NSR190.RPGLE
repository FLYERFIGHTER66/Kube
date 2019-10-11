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
      **PROGRAM NAME-------- PSR190
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD WEEKLY PLUG LOCATION FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  2/28/02 EFD ADD DELETE ROUTINE IF ANY ORDERS CANCELLED
      *  2/28/02 EFD ONLY USE LOTC Y ITEMS.
      *  3/18/02 EFD DELETE BACK ORDERED ITEMS.
      *  3/22/02 EFD ADD NEW FIELDS TO PUTORD.
      *  5/06/04 WJB OPTIONALLY INCLUDE/OMMIT KP ORDERS
      *
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFCALENCY  IF   E           K DISK
     FFIORDR    IF   E           K DISK
     F                                     RENAME(RIORDR:IORDR)
     FFIORDRSL  IF   E           K DISK
     FFIORDRPARTIF   E           K DISK
     FFMANUALD  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFPPO      IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FNTRORDO   UF   E           K DISK
     FNPLGSCTL  UF   E           K DISK
     FNPUTORDA  UF   E           K DISK
     F                                     RENAME(RPUTORD:PUTORD)
     FNPUTORD   UF A E           K DISK
      *
      * WORK ARRAYS FOR LOCATION MOVE
     D LIN             S              1    DIM(8)                               LOCATION IN
     D LOUT            S              1    DIM(8)                               LOCATION OUT
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
     D  PLDATE                11     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
WJB  D  LX1521               144    144
WJB  D  LMASTER              145    146  0
      ***********************
      ** START HERE        **
      ***********************
     C     PLDATE        CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        WKCYMD            7 0
      ** GET THURSDAY DATE FOR READY BAY CHECK
     C     CLCYMD        SETLL     FCALENCY
     C     NXTCAL        TAG
     C                   READP     FCALENCY                               90
     C  N90              DO
     C     CL#Y          IFNE      5
     C                   GOTO      NXTCAL
     C                   END                                                    CL#Y<>5
     C                   ENDDO                                                  N90  DO
     C                   Z-ADD     CLCYMD        THRCYM            7 0
      ** DELETE ANY UNNEEDED RECORDS
     C                   EXSR      DELCHK
     C     WKCYMD        SETLL     FIORDRSL
     C     NXT           TAG
     C     WKCYMD        READE     FIORDRSL                               91
     C   91              GOTO      END

     C                   If        LMASTER <> *Zero
     C     DatSeqOrd     KList
     C                   KFld                    WKCYMD
     C                   KFld                    LMASTER
     C                   KFld                    OIORD#
     C     DatSeqOrd     Chain     FMANUALD                           91
     C   91              GOTO      NXT
     C                   EndIf

     C     OIITYP        IFGT      *BLANKS
     C     OICUST        OREQ      2730
WJB  C     OICUST        OREQ      1521
WJB  C     LX1521        ANDEQ     'Y'
WJB  C     OISTAT        OREQ      'D'
     C                   GOTO      NXT
     C                   END
     C     OIQORD        SUB       OIQSHP        OPEN             11 1
     C                   If        OIRQTY > 0                                   Use off Master QTY
     C                   Z-Add     OIRQTY        OPEN
     C                   EndIf
     C     OPEN          IFLE      0
     C                   GOTO      NXT
     C                   END
     C     OIITEM        IFNE      IMITEM
     C     OISIZE        ORNE      IMSIZE
     C     ITMKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     ITMKEY        CHAIN     FMINVT                             92
     C   92              GOTO      NXT
     C*                  MOVE      IMBIN#        LOC               1
     C                   MOVE      ' '           LOC               1
     C                   END
     C*    IMLOTC        IFNE      'N'
     C*                  GOTO      NXT
     C*                  END
     C     OIORD#        CHAIN     FHORDR                             93
     C   93              GOTO      NXT
WJB  C     ORDERKEY      KLIST
WJB  C                   KFLD                    OIORD#
WJB  C                   KFLD                    OISEQ#
WJB  C     ORDERKEY      SetLL     FIORDRPART
WJB  C                   If        %Equal(FIORDRPART)
WJB  C                   Eval      OIITEM = %subst(OIITEM:1:11)+'P'
WJB  C                   EndIf
     C     PUTKEY        KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C                   KFLD                    WKCYMD
     C     PUTKEY        CHAIN     NPUTORD                            94
     C   94              DO
     C                   CLEAR                   RPUTORD
     C                   Z-ADD     OHORD#        PDORD#
     C                   Z-ADD     OISEQ#        PDSEQ#
     C                   Z-ADD     WKCYMD        PDSHPD
     C                   Z-ADD     LMASTER       PDMSTR
     C                   ENDDO                                                  94 DO
     C     LOC           IFLE      *BLANKS
     C                   MOVEL     OHLOC         PDLOC
     C                   ELSE
     C     OIORD#        CHAIN     FPPO                               71
     C     LOC           IFEQ      '1'
     C                   MOVEL     POLOWC        PDLOC
     C                   ELSE
     C                   MOVEL     POLOWF        PDLOC
     C                   END
     C                   END
      ** RIGHT JUSTIFY LOCATION
     C                   MOVE      *BLANKS       LIN
     C                   MOVE      *BLANKS       LOUT
     C                   MOVEA     PDLOC         LIN
     C                   Z-ADD     8             X                 2 0
     C                   Z-ADD     8             Y                 2 0
     C     NXTX          TAG
     C     LIN(X)        IFGT      *BLANKS
      ** CHECK IF WE NEED A ZERO FOR POST
     C     Y             IFEQ      7
     C     LIN(X)        ANDLT     '0'
     C     LOUT(8)       ANDGE     '0'
     C                   MOVE      '0'           LOUT(Y)
     C                   SUB       1             Y
     C                   END                                                    Y=7
     C                   MOVE      LIN(X)        LOUT(Y)
     C                   SUB       1             Y
     C                   END                                                    LIN,X>" "
     C                   SUB       1             X
     C     X             IFGT      0
     C                   GOTO      NXTX
     C                   END
     C                   MOVE      *BLANKS       PDLOC
     C                   MOVEA     LOUT          PDLOC
     C                   Z-ADD     OHCUST        PDCUST
     C                   Z-ADD     OHORDY        PDORDY
     C                   MOVEL     OIITEM        PDITEM
     C                   MOVEL     OISIZE        PDSIZE
     C                   Z-ADD     OPEN          PDQORD
     C                   MOVEL     IMLOOK        PDLOOK
     C                   MOVE      ' '           PDLOTC
      ** CHECK STA
     C*    OHSTA         IFEQ      'Y'
     C*                  MOVEL     'Y'           PDSTA
     C*                  ELSE
     C                   MOVE      *BLANKS       PDSTA
     C*                  END
      ** CHECK IF READY BAY ORDER
     C*    PDORDY        IFGE      THRCYM
     C*                  MOVEL     'Y'           PDRDYB
     C*                  ELSE
     C                   MOVE      *BLANKS       PDRDYB
     C*                  END                                                    PDORDY>THRCY
      ** CHECK BACKORDER
     C     OIPRBO        IFEQ      'B'
     C     OIBOLN        OREQ      'B'
     C                   MOVEL     'B'           PDBORD
     C                   ELSE
     C                   MOVE      *BLANKS       PDBORD
     C                   END                                                    OIPRBO=B
     C   94              WRITE     RPUTORD
     C  N94              UPDATE    RPUTORD
     C                   GOTO      NXT
      *** END PROGRAM
     C     END           TAG
     C                   Z-ADD     0             PSCOMP
     C     PSCOMP        CHAIN     NPLGSCTL                           59
     C     WKCYMD        IFGT      PSFILD
     C                   Z-ADD     WKCYMD        PSFILD
     C                   END
     C                   Z-ADD     TIMOD         PSTIME
     C                   Z-ADD     TDATE         PSDTLA
     C                   MOVEL     USERID        PSUSER
     C  N59              UPDATE    RPLGSCTL
     C                   SETON                                        LR
      ***********************
      ** CHECK FOR DELETES **
      ***********************
     C     DELCHK        BEGSR
     C     WKCYMD        SETLL     NPUTORDA
     C     NXTDEL        TAG
     C     WKCYMD        READE     NPUTORDA                               91
     C   91              GOTO      ENDDEL
     C     IORKEY        KLIST
     C                   KFLD                    PDORD#
     C                   KFLD                    PDSEQ#
     C     IORKEY        CHAIN     FIORDR                             92
     C  N92              DO
     C     PDSHPD        IFEQ      OIRVDT
     C     PDITEM        ANDEQ     OIITEM
     C     PDSIZE        ANDEQ     OISIZE
WJB  C     OISTAT        ANDNE     'D'
     C                   GOTO      NXTDEL
     C                   END
     C                   ENDDO                                                   N92 DO
      ** IF NO REC SEE IF TAGS COMMITTED
     C     TROKEY        KLIST
     C                   KFLD                    PDSHPD
     C                   KFLD                    PDMSTR
     C                   KFLD                    PDORD#
     C                   KFLD                    PDSEQ#
     C     TROKEY        SETLL     NTRORDO
     C     NXTDL1        TAG
     C     TROKEY        READE     NTRORDO                                93
     C   93              GOTO      ENDDL1
     C                   Z-ADD     0             TOORD#
     C                   Z-ADD     0             TOSEQ#
     C                   UPDATE    RTRORD
     C                   GOTO      NXTDL1
     C     ENDDL1        TAG
     C                   DELETE    PUTORD
     C                   GOTO      NXTDEL
     C     ENDDEL        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
