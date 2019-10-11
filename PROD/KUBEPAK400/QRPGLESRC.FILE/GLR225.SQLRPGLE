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
      *PROGRAM NAME-------- GLR225
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- THIS PROGRAM DISPLAYS ALL DETAIL TRANS
      *                     FOR AN ACCOUNT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGLR225FM  CF   E             WORKSTN
     F                                     SFILE(DSPSFL:RECNO)
     FFGLDETAC  IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLCTL    IF   E           K DISK
     FFGLBAL    IF   E           K DISK
      *
     D CR              S             11  2 DIM(13)
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
     IRGLBAL
      *
     I              GLT01                       CR(1)
     I              GLT02                       CR(2)
     I              GLT03                       CR(3)
     I              GLT04                       CR(4)
     I              GLT05                       CR(5)
     I              GLT06                       CR(6)
     I              GLT07                       CR(7)
     I              GLT08                       CR(8)
     I              GLT09                       CR(9)
     I              GLT10                       CR(10)
     I              GLT11                       CR(11)
     I              GLT12                       CR(12)
     I              GLT13                       CR(13)
      *
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       GCDESC
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       LSRCE
     C                   MOVEL     'Y'           LTOTAL
     C                   Z-ADD     1             VINCL
     C                   Z-ADD     0             VGL
     C*                    Z-ADD0         VACTP
     C                   Z-ADD     0             TOTBAL           11 2
     C                   Z-ADD     0             BEGBAL           10 2
     C                   Z-ADD     0             PERBAL                         EFD
     C                   SETOFF                                       555677
     C                   SETOFF                                       424360
      *
     C     NXTA          TAG
     C                   Z-ADD     1             FCNT
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       203035
     C                   SETOFF                                       606578    EFD
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
     C     VACTP         IFGT      0                                                        K
     C     VACTP         ANDGT     13                                                       K
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
     C     VACTP         IFGT      0
     C                   SETON                                        60
     C                   Z-ADD     VACTP         P                 2 0
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       PERIOD                         EFD
     C   60              MOVEL     VACTP         PERIOD            3
     C  N60              MOVEL     'ALL'         PERIOD
      *
     C     LTOTAL        IFNE      'Y'
     C     LTOTAL        ANDNE     'N'
     C                   SETON                                        35
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LTOTAL        IFEQ      'N'
     C                   SETON                                        65
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
     C                   Z-ADD     ENDDAT        ENDDTE
      *
      * GET BEGINNING BALANCE
      *
     C     BALKEY        KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VGL
     C     BALKEY        CHAIN     FGLBAL                             31
     C     P             SUB       1             Y                 2 0
     C                   ADD       GLBALT        BEGBAL
     C                   Z-ADD     1             X                 2 0
     C   60X             DOUGT     Y
     C                   ADD       CR(X)         BEGBAL
     C                   ADD       1             X
     C                   ENDDO
EFD  C     P             IFEQ      1
EFD  C                   Z-ADD     GLBALT        BEGBAL
EFD  C                   ENDIF
      *
     C     VINCL         IFEQ      1
     C                   MOVEL     'All Entr'    SELECT           16
     C                   MOVE      'ies     '    SELECT
     C  N77              ADD       BEGBAL        TOTBAL           11 2
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
     C  N77              ADD       BEGBAL        TOTBAL           11 2
     C                   ENDIF
      *
      * SET FGLDET BACK TO BEGINING OF ACCOUNT NUMBER
      *
     C     ACCT          KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VGL
     C     ACCT          SETLL     FGLDETAC
     C                   MOVE      '1'           *IN80
     C                   WRITE     DSPCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTB          TAG
     C                   SETOFF                                       90
     C     ACCT          READE     FGLDETAC                               90
     C   90              GOTO      DSPL
      *
     C     GTSTAT        IFEQ      'D'
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     GTAPER        IFEQ      9999
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
     C   60PER           IFNE      P
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   60
     COR 65              GOTO      NXT
      *
     C     FCNT          IFEQ      1
     C                   GOTO      NXT
     C                   ENDIF
     C     GTAPER        IFNE      OLDPER
     C                   ADD       1             RECNO
     C                   Z-ADD     0             BEGBAL
     C                   MOVEL     GTTDAT        OTDAT             6 0
     C                   Z-ADD     0             GTTDAT
     C                   MOVEL     GTAPER        OAPER             4 0
     C                   Z-ADD     0             GTAPER
     C                   MOVEL     GTSRCE        OSRCE             3
     C                   MOVEL     *BLANKS       GTSRCE
     C                   MOVEL     GTDOL$        ODOL$            11 2
     C                   Z-ADD     0             GTDOL$
     C                   MOVEL     GTJEDS        OJEDS            30
     C                   MOVEL     *BLANKS       GTJEDS
     C                   MOVEL     POST          OPOST             1
     C                   MOVEL     *BLANKS       POST
     C                   Z-ADD     PERBAL        GTDOL$
     C                   MOVEL     '* Period'    DESC1            16
     C                   MOVE      ' Total  '    DESC1
     C                   MOVEL     DESC1         GTJEDS
     C                   SETON                                        78
     C                   WRITE     DSPSFL
     C                   SETOFF                                       78
     C                   Z-ADD     OTDAT         GTTDAT
     C                   Z-ADD     OAPER         GTAPER
     C                   Z-ADD     ODOL$         GTDOL$
     C                   MOVEL     OSRCE         GTSRCE
     C                   MOVEL     OJEDS         GTJEDS
     C                   MOVEL     OPOST         POST
     C                   Z-ADD     0             PERBAL
     C                   ADD       1             FCNT              2 0
     C                   ADD       1             RECNO
     C                   ENDIF
      *
     C     NXT           TAG
     C                   ADD       1             FCNT              2 0
     C                   ADD       GTDOL$        TOTBAL
     C                   ADD       GTDOL$        PERBAL           11 2
     C                   Z-ADD     GTAPER        OLDPER            4 0
      *
     C                   ADD       1             RECNO
     C     RECNO         IFGT      1
     C                   SETON                                        55
     C                   ENDIF
      /Free
        Vend# = *Zeros;
        Vendor = *Blanks;
        If %subst(GTJEDS:1:1) = 'V';
          Vend# = %int(%Trim(%subst(GTJEDS:3:6)));
          Exec SQL // Get Vendor name for vendor coded in description
            Select VMNAME  into :vendor from FMVEND where VMVEND = :Vend#;
        EndIf;
      /End-Free
     C                   WRITE     DSPSFL
      /Free
        Vend# = *Zeros;
        Vendor = *Blanks;
      /End-Free
     C                   GOTO      NXTB
      *
     C     DSPL          TAG
     C                   SETON                                        55        EFD
     C                   SETON                                        56
     C  N60              DO
     C                   ADD       1             RECNO
     C                   MOVEL     *BLANKS       GTSRCE
     C                   MOVEL     '* Period'    DESC1            16
     C                   MOVE      ' Total  '    DESC1
     C                   MOVEL     DESC1         GTJEDS
     C                   SETON                                        78
     C                   Z-ADD     PERBAL        GTDOL$
     C  N65              WRITE     DSPSFL                                       EFDN65
     C                   Z-ADD     0             PERBAL                         EFD
     C                   ENDDO
     C                   ADD       2             RECNO
     C                   Z-ADD     0             BEGBAL
     C                   Z-ADD     0             GTACCT
     C                   Z-ADD     0             GTAPER                         EFD
     C                   Z-ADD     0             GTJENM
     C                   Z-ADD     0             GTTDAT
     C                   MOVEL     *BLANKS       GTSRCE
     C                   MOVEL     *BLANKS       GTJEDS
     C                   MOVEL     *BLANKS       POST
     C                   Z-ADD     TOTBAL        GTDOL$
     C  N77              MOVEL     '* Ending'    DESC1            16
     C  N77              MOVE      ' Balance'    DESC1
     C   77              MOVEL     '* Detail'    DESC1            16
     C   77              MOVE      ' Total  '    DESC1
     C                   MOVEL     DESC1         GTJEDS
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
