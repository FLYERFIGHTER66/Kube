      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME--------- APC310
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- VOUCHER POST PROMPT SCREEN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMUSER    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FFAPCTLB   IF   E           K DISK
     FAPC310FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
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
     D                UDS
     D  LCO                    1      2  0
     D  LUSER                  3     12
     D  LRPT                  13     13
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      *BLANKS       LCANCL
      *
     C                   MOVEL     USERID        LUSER
     C                   MOVEL     'Y'           LRPT
     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102050
     C                   SETOFF                                       515254
     C                   SETOFF                                       7077
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      *
     C*          LUSER     IFGT *BLANKS
     C     LUSER         CHAIN     FMUSER                             10
     C   10              GOTO      RSTRT
     C     CTLKEY        KLIST
     C                   KFLD                    ABCOMP
     C                   KFLD                    ABUSER
     C                   KFLD                    ABTYPE
     C                   MOVEL     'VOUCH'       ABTYPE
     C                   Z-ADD     LCO           ABCOMP
     C                   MOVEL     LUSER         ABUSER
     C     CTLKEY        CHAIN     FAPCTLB                            70
     C  N70ABOK          IFEQ      'N'
     C                   SETON                                        77
     C   77              GOTO      RSTRT
     C                   END
     C*                    ELSE
     C                   SETON                                        70
     C*                    ENDIF                           LUSER>" "
     C  N77
     CAN 70              DO
     C     LCO           CHAIN     FAPCTL                             80
     C     AZOKP         IFEQ      'N'
     C                   SETON                                        77
     C   77              GOTO      RSTRT
     C                   END
     C                   ENDDO
      *
     C     LUSER         IFNE      OUSER
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LUSER         OUSER            10
      *
     C     LRPT          IFNE      'Y'
     C     LRPT          ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LRPT          IFNE      ORPT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LRPT          ORPT              1
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      RSTRT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
