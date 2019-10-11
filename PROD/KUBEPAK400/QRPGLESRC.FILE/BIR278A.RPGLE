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
      **PROGRAM NAME-------- BIR278A
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- RE-ACTIVATE ORDER FROM CREDIT MEMO ENTRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDR    UF   E           K DISK
     FFIORDR    UF   E           K DISK
     FFHORDW    IF   E           K DISK
     FFIORDW    IF   E           K DISK
     FFPPI      IF   E           K DISK
     FFPPO      UF A E           K DISK
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
      ** COMPANY
     D  LCO                    1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** BEGINING CREDIT NUMBER
     D  LBCRM                  4      9  0
      ** ENDING CREDIT NUMBER
     D  LECRM                 10     15  0
      ** CREDIT MEMO DATE
     D  LDATE                 16     21  0
      ** CREDIT MEMO END DATE
     D  LENDT                 22     27  0
      ** SHIP FROM LOCATION
     D  LSHFR                 28     30
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 31     31
      ** BILL TO CUSTOMER
     D  LBLCS                 32     37  0
      ** SHIP TO CUSTOMER
     D  LSHCS                 38     43  0
      ** LAST INVOICE CREDITED
     D  LBINV                 44     49  0
      ** ORDER NUMBER
     D  LORD#                 50     55  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    113
      ** NUMBER OF COPIES
     D  LCOPY                114    115  0
      ** JOBQ
     D  LJOB                 116    116
      ** HOLD PRINT OUTPUT
     D  LHOLD                117    120
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                121    124
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C     LBINV         CHAIN     FHORDW                             90
     C   90              GOTO      END
     C     WHORD#        CHAIN     FHORDR                             90
     C   90              GOTO      END
     C                   MOVEL     'A'           OHSTAT
     C                   MOVEL     'N'           OHCOFL
     C                   MOVEL     'H'           OHHOLD
     C                   Z-ADD     TIMOD         OHTIME
     C                   Z-ADD     TDATE         OHDTLA
     C                   MOVEL     USERID        OHUSER
     C                   UPDATE    RHORDR
      ** GET FPPO
     C     LBINV         CHAIN     FPPI                               91
     C  N91              DO
     C     WHORD#        CHAIN     FPPO                               92
     C                   Z-ADD     WHORD#        POORD#
     C                   MOVEL     PITAKN        POTAKN
     C                   MOVEL     PIENTR        POENTR
     C   92              WRITE     RPPO
     C  N92              UPDATE    RPPO
     C                   ENDDO
      ** NOW GET DETAIL LINES
     C     LBINV         SETLL     FIORDW
     C     NXTINV        TAG
     C     LBINV         READE     FIORDW                                 90
     C   90              GOTO      END
     C     IORKEY        KLIST
     C                   KFLD                    WHORD#
     C                   KFLD                    WISEQ#
     C     IORKEY        CHAIN     FIORDR                             91
     C   91              GOTO      NXTINV
      ** CHECK TYPE
     C     OIITYP        IFNE      ' '
     C                   Z-ADD     0             OIQSHP
     C                   GOTO      ACTOK
     C                   END
      ** IF LINE ITEM AND NO SHIP SKIP RECORD
     C     WIQINV        IFLE      0
     C                   GOTO      NXTINV
     C                   END
      ** IF LINE ITEM RESET FIELDS
     C                   SUB       WIQINV        OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIQINV
     C     ACTOK         TAG
     C                   MOVEL     'A'           OISTAT
     C                   MOVEL     'N'           OICOFL
     C                   MOVEL     'H'           OISHCD
     C                   Z-ADD     TIMOD         OITIME
     C                   Z-ADD     TDATE         OIDTLA
     C                   MOVEL     USERID        OIUSER
     C                   UPDATE    RIORDR
     C                   GOTO      NXTINV
      ** END JOB
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
