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
      **PROGRAM NAME-------- CSR010
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SERIES MASTER MAINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCSTOPT  UF A E           K DISK
     FFMVEND    IF   E           K DISK
     FCSR010FM  CF   E             WORKSTN
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
     C                   MOVEA     '0'           *IN
     C                   UNLOCK    FMCSTOPT
     C                   CLEAR                   RMCSTOPT
     C                   MOVE      *BLANKS       ACTION
     C                   MOVE      *BLANKS       OPTION
     C                   MOVE      *BLANKS       OPDESC
     C                   MOVE      *BLANKS       ODESC
     C                   MOVE      *BLANKS       OPDATR
     C                   MOVE      *BLANKS       ODATR
     C                   MOVE      *BLANKS       VMNAME
     C                   MOVE      *BLANKS       VLOOK
     C                   Z-ADD     0             OPVEND
     C                   Z-ADD     0             OVEND
     C                   Z-ADD     0             VMCOMP            2 0
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       1020
     C                   SETOFF                                       212223
      ** CHECK ACTION
     C     ACTION        IFNE      'A'
     C     ACTION        ANDNE     'C'
     C     ACTION        ANDNE     'D'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
      ** CHECK OPTION
     C     OPTION        IFLE      *BLANK
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
     C                   MOVEL     OPTION        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C     9             SUBST     OPTION:2      OPDESC
     C                   CALL      'LKCOPT'
     C                   PARM                    OPDESC
     C                   PARM                    OPCODE
     C                   MOVE      *BLANKS       OPTION
     C                   MOVEL     OPCODE        OPTION
     C                   GOTO      NXTA
     C                   END
     C     OPTION        CHAIN     FMCSTOPT                           91
     C   91ACTION        IFEQ      'C'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   END
     C   91ACTION        IFEQ      'D'
     C                   SETON                                        2023
     C                   GOTO      NXTA
     C                   END
     C  N91ACTION        IFEQ      'A'
     C                   SETON                                        2021
     C                   CLEAR                   RMCSTOPT
     C                   GOTO      NXTA
     C                   END
      ** IF HERE I HAVE A GOOD RECORD OR NO RECORD ON AN ADD
     C     ACTION        IFEQ      'D'
     C     NXTBD         TAG
     C                   WRITE     SCRNBD
     C                   READ      SCRNBD                                 90
     C   KF              GOTO      RSTART
     C  NKJ
     CANNKX              GOTO      NXTBD
     C                   DELETE    RMCSTOPT
     C                   GOTO      RSTART
     C                   END
     C   91              DO
     C                   CLEAR                   RMCSTOPT
     C                   MOVEL     OPTION        OPCODE
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       98  99
     C  N91OPVEND        IFGT      0
     C     OPVEND        CHAIN     FMVEND                             80
     C                   END
      *** SCREEN B
     C     NXTB          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       102030
     C                   SETOFF                                           99
      ** CHECK DESCRIPTION
     C     OPDESC        IFLE      *BLANKS
     C                   SETON                                        1099
     C                   GOTO      NXTB
     C                   END
      ** CHECK ALPHA SEARCH
     C     OPLOOK        IFLE      *BLANKS
     C                   MOVEL     OPDESC        OPLOOK
     C                   END
      ** CHECK DATES REQUIRED
     C     OPDATR        IFNE      'Y'
     C     OPDATR        ANDNE     'N'
     C                   SETON                                        2099
     C                   GOTO      NXTB
     C                   END
      ** CHECK VENDOR
     C     OPVEND        IFLE      0
     C     VLOOK         ANDGT     *BLANKS
     C                   MOVEL     VLOOK         VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VLOOK
     C                   Z-ADD     VMVEND        OPVEND
     C                   GOTO      NXTB
     C                   ENDIF
     C     OPVEND        IFGT      0
     C     OPVEND        CHAIN     FMVEND                             30
     C   30              DO
     C                   SETON                                        99
     C                   MOVE      *BLANKS       VMNAME
     C                   GOTO      NXTB
     C                   ENDDO                                                  30  DO
     C                   ELSE
     C                   MOVE      *BLANKS       VMNAME
     C                   END
      ** SEE IF CHANGED
     C     OPDESC        IFNE      ODESC
     C     OPDATR        ORNE      ODATR
     C     OPVEND        ORNE      OVEND
     C                   SETOFF                                       98
     C                   MOVEL     OPDESC        ODESC            30
     C                   MOVEL     OPDATR        ODATR             1
     C                   Z-ADD     OPVEND        OVEND             6 0
     C                   END
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   END
      ** UPDATE FILE
     C   91              WRITE     RMCSTOPT
     C  N91              UPDATE    RMCSTOPT
     C                   GOTO      RSTART
      ** END PROGRAM
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
