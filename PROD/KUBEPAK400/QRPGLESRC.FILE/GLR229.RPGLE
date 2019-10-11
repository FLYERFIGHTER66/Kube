      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- GLR228
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- THIS PROGRAM DISPLAYS ALL DETAIL TRANS
      *                     FOR AN ACCOUNT WITH VENDOR NAME
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  1/25/01 EFD ADD RANGE OF ACCOUNTING PERIODS
      *
     FGLR229FM  CF   E             WORKSTN
     F                                     SFILE(DSPSFL:RECNO)
     FFGLDACCT  IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLCTL    IF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
      *
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       GCDESC
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       LSRCE
     C                   Z-ADD     1             VINCL
     C                   Z-ADD     0             VGL
     C*                    Z-ADD0         VACTP
     C*                    Z-ADD0         EACTP
     C                   Z-ADD     0             TOTBAL           11 2
     C                   Z-ADD     0             BEGBAL           11 2
     C                   SETOFF                                       555677
     C                   SETOFF                                       4243
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       2030
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C   KD              EXSR      RSTRTB
     C   KD              GOTO      NXTA
      *
     C   KB              DO
     C                   Z-ADD     VCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VGL           IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VGL           IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VGL           IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     GCGLNO        VGL
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     GLKEY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VGL
     C     GLKEY         CHAIN     FMGLCH                             90
     C   90              SETON                                        1012
     C   12              GOTO      NXTA
      *
     C     VACTP         IFLE      0                                                        K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     VACTP         P                 2 0
      *
     C     EACTP         IFLE      0
     C                   Z-ADD     VACTP         EACTP
     C                   END
     C     EACTP         IFLE      0                                                        K
     C     EACTP         ORGT      13                                                       K
     C                   SETON                                        22
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     EACTP         PE                2 0
     C     EACTP         IFLT      VACTP
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VINCL         IFEQ      0
     C     VINCL         ORGT      3
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LSRCE         IFGT      *BLANKS
     C                   SETON                                        77
     C                   ENDIF
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     VCO           CONO
     C                   Z-ADD     VACTP         ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     BEGDAT        BEGDTE
     C                   Z-ADD     EACTP         ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ENDDAT        ENDDTE
      *
     C     VINCL         IFEQ      1
     C                   MOVEL     'All Entr'    SELECT           16
     C                   MOVE      'ies     '    SELECT
     C                   ENDIF
     C     VINCL         IFEQ      2
     C                   SETON                                        42
     C                   MOVEL     'Unposted'    SELECT           16
     C                   MOVE      ' Entries'    SELECT
     C                   ENDIF
     C     VINCL         IFEQ      3
     C                   SETON                                        43
     C                   MOVEL     'Posted E'    SELECT           16
     C                   MOVE      'ntries  '    SELECT
     C                   ENDIF
      *
      * SET FGLDET BACK TO BEGINING OF ACCOUNT NUMBER
      *
     C     ACCT          KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VGL
     C     ACCT          SETLL     FGLDACCT
     C                   MOVE      '1'           *IN80
     C                   WRITE     DSPCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTB          TAG
     C                   SETOFF                                       90
     C                   MOVEL     *BLANKS       VNAME
     C     ACCT          READE     FGLDACCT                               90
     C   90              GOTO      DSPL
      *
     C     GTSTAT        IFEQ      'D'
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   77GTSRCE        IFNE      LSRCE
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   42GTPOST        IFEQ      'Y'
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   43GTPOST        IFNE      'Y'
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     GTPOST        IFEQ      'Y'
     C                   MOVEL     '*'           POST
     C                   ELSE
     C                   MOVEL     *BLANKS       POST
     C                   ENDIF
      *
     C                   MOVE      GTAPER        PER               2 0
     C     PER           IFLT      P
     C     PER           ORGT      PE
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     GTVEND        IFGT      0
     C     GTVEND        CHAIN     FMVEND                             91
     C  N91              MOVEL     VMNAME        VNAME
     C   91              MOVEL     MSG(1)        VNAME
     C                   ENDIF
      *
     C                   ADD       GTDOL$        TOTBAL
      *
     C                   ADD       1             RECNO
     C     RECNO         IFGT      1
     C                   SETON                                        55
     C                   ENDIF
     C                   WRITE     DSPSFL
     C                   GOTO      NXTB
      *
     C     DSPL          TAG
     C                   SETON                                        56
     C                   ADD       2             RECNO
     C                   Z-ADD     0             GTTDAT
     C                   Z-ADD     0             GTVEND
     C                   MOVEL     *BLANKS       GTSRCE
     C                   MOVEL     *BLANKS       POST
     C                   Z-ADD     0             GTCON#
     C                   Z-ADD     TOTBAL        GTDOL$
     C                   MOVEL     '<== Tota'    DESC1            16
     C                   MOVE      'l Detail'    DESC1
     C                   MOVEL     DESC1         VNAME
     C                   WRITE     DSPSFL
     C                   EXFMT     DSPCTL
     C   KC
     COR KG              GOTO      END
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     C     RSTRTB        BEGSR
     C     NXTSR         TAG
     C                   Z-ADD     0             VLINE
     C                   WRITE     SCRNB
     C                   SETOFF                                       10
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KF              GOTO      NXTA
      *
     C     VLINE         IFEQ      0
     C     VLINE         ORGT      10
     C                   SETON                                        10
     C                   GOTO      NXTSR
     C                   ENDIF
      *
     C     VLINE         IFEQ      01
     C                   MOVEL     'ADJ'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      02
     C                   MOVEL     'A/L'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      03
     C                   MOVEL     'A/P'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      04
     C                   MOVEL     'CAS'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      05
     C                   MOVEL     'DIS'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      06
     C                   MOVEL     'INV'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      07
     C                   MOVEL     'J/E'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      08
     C                   MOVEL     'L/C'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      09
     C                   MOVEL     'NAR'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      10
     C                   MOVEL     'P/R'         LSRCE
     C                   ENDIF
     C     VLINE         IFEQ      11
     C                   MOVEL     'SLS'         LSRCE
     C                   ENDIF
      *
     C*                    GOTO NXTA
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FGLCTL                             90
     C                   Z-ADD     GZPRCO        VCO
      *
     C                   ENDSR
      *
**
Vendor Not On File **
