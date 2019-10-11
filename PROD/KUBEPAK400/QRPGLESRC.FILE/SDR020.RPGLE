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
      **PROGRAM NAME-------- SDR020
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- VENDOR?SERIES X-REF AMINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSERIES   IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFSERPRC   UF A E           K DISK
     FSDR020FM  CF   E             WORKSTN
     F                                     SFILE(ITMSFL:RECNO)
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
     I**                                      1   20LCO                   ARC380
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             VEND
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       SHOWAL
     C                   SETOFF                                       1020
     C                   UNLOCK    FSERPRC
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       1020
      ** CHECK VENDOR
     C     VEND          IFLE      0
     C     ALPHA         ANDLE     *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
     C     VEND          IFLE      0
     C     ALPHA         ANDGT     *BLANKS
     C                   MOVEL     ALPHA         VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP            2 0
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VEND
     C                   GOTO      NXTA
     C                   ENDIF
     C     VEND          CHAIN     FMVEND                             10
     C   10              GOTO      NXTA
      ** CHECK SHOWAL
     C     SHOWAL        IFNE      'Y'
     C     SHOWAL        ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      ** IF HERE SCRNA OK
     C                   EXSR      BLDSFL
     C     NXTFMT        TAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C   99              SETOFF                                       98
     C                   EXFMT     ITMCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTFMT
     C                   ENDDO
     C  NKD              GOTO      NXTFMT
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVEL     '1'           *IN80
     C                   WRITE     ITMCTL
     C                   MOVEL     '0'           *IN80
     C                   MOVE      *BLANKS       SECODE
     C     SECODE        SETLL     FSERIES
     C     NXTBLD        TAG
     C                   READ      FSERIES                                90
     C   90              GOTO      ENDBLD
     C     SEFORM        COMP      2                                  030102
     C     PRCKEY        KLIST
     C                   KFLD                    VEND
     C                   KFLD                    SECODE
     C     PRCKEY        CHAIN     FSERPRC                            91
     C   91              DO
     C                   CLEAR                   RSERPRC
     C     SHOWAL        IFNE      'Y'
     C                   GOTO      NXTBLD
     C                   END                                                    SHOWAL<>Y
     C                   ENDDO                                                  90 DO
     C                   Z-ADD     SPPRC1        PK1
     C                   Z-ADD     SPPRC1        OPK1
     C                   Z-ADD     SPPRC2        PK2
     C                   Z-ADD     SPPRC2        OPK2
     C                   Z-ADD     SPPRC3        PK3
     C                   Z-ADD     SPPRC3        OPK3
     C                   Z-ADD     SPPRO3        PKO3
     C                   Z-ADD     SPQTO3        MUL03
     C                   ADD       1             RECNO
     C                   WRITE     ITMSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   SETOFF                                       010203
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#
     C                   SETOFF                                       010203
     C                   SETOFF                                       101112
     C                   SETOFF                                       15  99
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     ITMSFL                             90
     C   90              GOTO      NXTCHK
     C                   SETOFF                                       1015
      ** GET PAGE
     C     PAGE#         IFLE      0
     C     SECODE        ANDGT     STRTWH
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C     PKO3          IFGT      0
     C     MUL03         ANDLE     0
     C                   SETON                                        101299
     C                   END
     C*          PKO3      IFLE 0
     C*          MUL03     ANDGT0
     C*                    SETON                     111599
     C*                    END
     C     PKO3          IFGT      0
     C     MUL03         ANDGT     0
     C     PKO3          DIV       MUL03         WRK              11 7
     C     WRK           MULT(H)   1000          PK3
     C                   END
     C     SEFORM        COMP      2                                  030102
     C                   UPDATE    ITMSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   SETOFF                                       010203
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     ITMSFL                             90
     C   90              GOTO      NXTPUT
     C     PRCKEY        CHAIN     FSERPRC                            91
     C   91              DO
     C                   CLEAR                   RSERPRC
     C     PK1           ADD       PK2           TSTPRC            9 4
     C                   ADD       PK3           TSTPRC
      ** IF NO PRICES ENTERED DO NOT WRITE NEW RECORD
     C     TSTPRC        IFLE      0
     C                   GOTO      NXTPUT
     C                   END
     C                   Z-ADD     VEND          SPVEND
     C                   MOVEL     SECODE        SPCODE
     C                   MOVEL     'A'           SPSTAT
     C                   ENDDO
     C                   Z-ADD     PK1           SPPRC1
     C                   Z-ADD     PK2           SPPRC2
     C                   Z-ADD     PK3           SPPRC3
     C                   Z-ADD     PKO3          SPPRO3
     C                   Z-ADD     MUL03         SPQTO3
     C                   Z-ADD     TIMOD         SPTIME
     C                   Z-ADD     TDATE         SPDTLA
     C                   MOVEL     VMLOOK        SPVALP
     C                   MOVEL     USERID        SPUSER
     C   91              WRITE     RSERPRC
     C  N91              UPDATE    RSERPRC
      ** SEE IF ANY CHANGES
     C     PK1           IFNE      OPK1
     C     PK2           ORNE      OPK2
     C     PK3           ORNE      OPK3
     C                   CALL      'SDR700'
     C                   PARM                    SECODE
     C                   END
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   SETOFF                                       010203
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
