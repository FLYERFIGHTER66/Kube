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
      **PROGRAM NAME-------- PRGORDRR
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **DESCRIPTION--------- THIS PROGRAM GETS THE DATE AND SHIP
      **                     FROM DATA TO DETERMINE WHICH FIORDW RECORDS
      **                     SHOULD BE DELETED.  THOSE RECORDS
      **                     ARE DELETED.
      **
      *            **     PROGRAM CHANGE LOG    **
      * 1/01/98 EFD ADD LOGIC FOR LASTMONTH FILES AND AUTO SAVE LAST 9
      *             MONTHS OF INVOICES, AND PURGE THE REST
      *11/17/00 EFD ADD LOGIC FOR BIC990 INPUT DATE TO PURGE THRU.
      *
      *
     FFIORAST   UF   E           K DISK
     FFIORDR    UF   E           K DISK
     FFIORDRO   O  A E           K DISK
     F                                     RENAME(RIORDR:OIORDR)
     FFHORDR    UF   E           K DISK
     FFHORDRO   O  A E           K DISK
     F                                     RENAME(RHORDR:OHORDR)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LDACO                  1      2  0
     D  LACTP                  3      4  0
     D  LTRANS                 5      5
     D  LDABEG                 6     11  0
     D  LDAEND                12     17  0
     D  LPURGE                18     18
     D  LMTRAN                19     27
     D  LMSALE                28     36
     D  LHORDW                37     45
     D  LIORDW                46     54
     D  LTINVT                55     63
     D  LLIBR                 64     73
     D  LTAXDS                75     83
     D  LBU                   84     84
     D  LHORDR                85     93
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LIORDR               172    180
     D  WTDTCY               181    187  0
     D  RTDTCY               188    194  0
      **
      *
      *
      * GET FHORDR
      *
     C     NXTH          TAG
     C                   READ      FHORDR                                 90
     C   90              GOTO      ENDH
      *
     C     OHCOMP        IFNE      LDACO
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C     OHDTAC        IFGT      WTDTCY
     C     OHSTAT        ORNE      'D'
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C     OHORD#        SETLL     FIORDR
     C     NXTI          TAG
     C     OHORD#        READE     FIORDR                                 91
     C  N91              DO
     C                   WRITE     OIORDR
     C                   DELETE    RIORDR
     C                   GOTO      NXTI
     C                   ENDDO
      *
     C                   WRITE     OHORDR
     C                   DELETE    RHORDR
     C                   GOTO      NXTH
      * FIOWAST JUST DELETE RECORDS DO NOT SAVE THEM
     C     ENDH          TAG
     C                   READ      FIORAST                                90
     C   90              GOTO      END
     C     IAORD#        CHAIN     FHORDR                             60
     C   60              DELETE    RIORAST
     C                   GOTO      ENDH
      *
     C     END           TAG
     C                   SETON                                        LR
