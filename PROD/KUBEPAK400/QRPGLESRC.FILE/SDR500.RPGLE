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
      **PROGRAM NAME-------- SDR500
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SEED PRICE LOOK-UP
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSDR500FM  CF   E             WORKSTN
     F                                     SFILE(SEDSFL:RECNO)
     FFSERIES   IF   E           K DISK
     FFSERPRCS  IF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
      ** MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGES
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
     D  CALLED               150    150                                         ARC380
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    SERIES
     C                   PARM                    SPVEND
     C                   PARM                    SEFORM
     C     SERIES        IFGT      *BLANKS
     C                   GOTO      NOTA
     C                   END
      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   MOVE      '0'           *IN
     C                   MOVE      *BLANKS       SERIES
     C     CALLED        IFEQ      'N'
     C                   SETON                                        58
     C                   SETOFF                                       57
     C                   ELSE
     C                   SETOFF                                       58
     C                   SETON                                        57
     C                   END
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   MOVEL     SERIES        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C     9             SUBST     SERIES:2      SEDESC
     C                   CALL      'LKSERI'
     C                   PARM                    SEDESC
     C                   PARM                    SECODE
     C                   MOVE      *BLANKS       SERIES
     C                   MOVEL     SECODE        SERIES
     C                   GOTO      NXTA
     C                   END
     C     SERIES        CHAIN     FSERIES                            10
     C   10              GOTO      NXTA
      *************
      * SCREEN B  *
      *************
     C     NOTA          TAG
     C                   EXSR      BLDSFL
     C     NXTB          TAG
     C                   EXFMT     SEDCTL
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       102030
      ** SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     CALLED        ANDNE     'N'
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     SEDSFL                             90
     C                   GOTO      END
     C                   END
      ** CHECK IF LINE ENTERED
     C     VLINE         IFGT      0
     C     VLINE         ANDLE     LSTREC
     C     CALLED        ANDNE     'N'
     C     VLINE         CHAIN     SEDSFL                             90
     C                   GOTO      END
     C                   END
     C   57              GOTO      NXTB
     C   58              GOTO      RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C                   SETON                                        80
     C                   WRITE     SEDCTL
     C                   SETOFF                                       8077
     C     SERIES        SETLL     FSERPRCS
     C     NXTBLD        TAG
     C     SERIES        READE     FSERPRCS                               90
     C   90              GOTO      ENDBLD
     C     SPVEND        CHAIN     FMVEND                             71
     C   71              GOTO      NXTBLD
     C                   ADD       1             RECNO
     C                   Z-ADD     RECNO         LIN
     C                   Eval      VMNAME24 = VMNAME
     C                   WRITE     SEDSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   SETON                                        77
     C                   ADD       1             RECNO
     C                   Z-Add     *Zero         SPDTLA
     C                   MOVEL     MSG(1)        VMNAME24
     C                   Eval      *In95 = *On
     C                   WRITE     SEDSFL
     C                   Eval      *In95 = *Off
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
** MESSAGES
     ** End of Vendors **
