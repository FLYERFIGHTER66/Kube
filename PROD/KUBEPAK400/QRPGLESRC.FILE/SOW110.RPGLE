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
      **PROGRAM NAME-------- SOW110
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- REPRINT LABELS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSOW110FM  CF   E             WORKSTN
     FFTRAY     IF   E           K DISK
     F                                     RENAME(RTRAY:TRAYI)
     FFTRAYR    IF   E           K DISK
     F                                     RENAME(RTRAYR:TRAYIR)
     FFTRAYJ    IF   E           K DISK
     FFTRAYJR   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFOINVT    IF   E           K DISK
     FFCALEX    IF   E           K DISK
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
     C                   Z-ADD     0             TAG#
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
     C     TAG#          CHAIN     FTRAY                              10
     C   10TAG#          CHAIN     FTRAYR                             10
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
      ** IF HERE INPUT OK SHOW TAG INFO
     C     MINKEY        KLIST
     C                   KFLD                    TRITEM
     C                   KFLD                    TRSIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C                   Z-ADD     TRORDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         RDYDAT
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   MOVEL     TRSCYW        CLCENT
     C                   MOVEL     TRSCYW        WRK40             4 0
     C                   MOVE      WRK40         CLYEAR
     C                   MOVE      TRSCYW        CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLDATE        SOWDAT
      ** GET BEG AND END TAG NUMBER.
     C     TRYKEY        KLIST
     C                   KFLD                    TRSCYW
     C                   KFLD                    TRJOB#
     C     TRYKEY        SETLL     FTRAYJ
     C     TRYKEY        SETLL     FTRAYJR
     C                   Z-ADD     0             BEGTAG
     C     NXTTRY        TAG
     C     TRYKEY        READE     FTRAYJ                                 91
     C   91TRYKEY        READE     FTRAYJR                                91
     C   91              GOTO      ENDTRY
     C     BEGTAG        IFLE      0
     C                   Z-ADD     TRTAG#        BEGTAG
     C                   END
     C                   Z-ADD     TRTAG#        ENDTAG
     C                   GOTO      NXTTRY
     C     ENDTRY        TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      ** IF HERE BUILD LABEL FILE
     C                   MOVEL     IMITEM        SLITEM
     C                   MOVEL     IMSIZE        SLSIZE
     C                   MOVEL     IMDES1        SLDESC
     C                   MOVEL     IMLOC         SLLOC
     C                   MOVEL     IMTPSW        SLTPSW
     C                   MOVEL     IMMSCX        SLMSCX
     C                   MOVEL     IM#SED        SL#SED
     C                   Z-ADD     TAG#          SLTAG#
     C                   MOVEL     SOWDAT        SLSOW
     C                   MOVEL     RDYDAT        SLRDY
     C     MINKEY        CHAIN     FOINVT                             98
     C  N98              MOVE      OVSALE        SALE3             3
     C   98IMSIZE        CHAIN     FMSIZE                             99
     C   98
     CANN99              MOVE      SZSALE        SALE3             3
     C  N99              MOVEL     SALE3         SLSIZE
     C   99              MOVEL     IMSIZE        SLSIZE
     C                   MOVEL     IMSIZE        SLSIZE
     C                   WRITE     RSOWLAB
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
