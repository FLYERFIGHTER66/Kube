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
      **PROGRAM NAME-------- TRC510
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER----------
      **APPLICATION---------
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FTRC510FM  CF   E             WORKSTN
     FFTRHDRH   UF   E           K DISK
     F                                     RENAME(RTRHDRH:TRHDRH)
     FFTRHDRHD  UF   E           K DISK
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
     D  LCO                    1      2  0                                      ARC380
     D  LDATE                  3      8  0
     D  LSDATE                 9     15  0
     D  LTRUCK                16     19
     D  LROUT                 20     21
     D  LDIR                  22     22
     D  FILE                  23     32
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LVOUT                134    134  0
      *******************
      * START HERE      *
      *******************
      ** IF LPRTR IS GREATER THAN BLANK WE ARE ON NEXT RUN.
     C     LPRTR         IFGT      *BLANKS
     C                   Z-ADD     LVOUT         VOUT
     C                   GOTO      NORST
     C                   END
     C     RSTART        TAG
     C                   Z-ADD     TDATE         LDATE
     C                   MOVE      *BLANKS       LTRUCK
     C                   MOVE      *BLANKS       LROUT
     C                   MOVEL     'Y'           LDIR
     C                   Z-ADD     1             VOUT
     C                   MOVEL     'P3      '    LPRTR
     C                   MOVEL     '*NAR    '    LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'Y'           LJOBQ
     C                   Z-ADD     1             VOUT
     C     NORST         TAG
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   SETOFF                                       505152
     C                   SETOFF                                       535498
     C                   UNLOCK    FTRHDRH
     C                   UNLOCK    FTRHDRHD
      *
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       40
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        LSDATE
      *
     C     LDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LDATE         ODATE             6 0
      *
      * TRUCK ENTERED
     C     LTRUCK        IFGT      *BLANKS
     C                   MOVEL     LTRUCK        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       TRUCK
     C                   MOVE      *BLANKS       ROUT
     C                   Z-ADD     LDATE         WKDATE            6 0
     C                   CALL      'TRR220'
     C                   PARM                    WKDATE
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C                   MOVEL     TRUCK         LTRUCK
     C                   MOVEL     ROUT          LROUT
     C                   GOTO      NXTA
     C                   END
      ** CHECK IF EXISTS
     C     TRKKEY        KLIST
     C                   KFLD                    LTRUCK
     C                   KFLD                    LSDATE
     C     TRKKEY        CHAIN(N)  FTRHDRH                            20
     C   20              SETON                                        99
     C   20              GOTO      NXTA
     C                   END
      *
     C     LTRUCK        IFNE      OTRUCK
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LTRUCK        OTRUCK            4
      *
      * ROUT  ENTERED
     C     LROUT         IFGT      *BLANKS
     C                   MOVEL     LROUT         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       TRUCK
     C                   MOVE      *BLANKS       ROUT
     C                   Z-ADD     LDATE         WKDATE            6 0
     C                   CALL      'TRR220'
     C                   PARM                    WKDATE
     C                   PARM                    TRUCK             4
     C                   PARM                    ROUT              2
     C                   MOVEL     TRUCK         LTRUCK
     C                   MOVEL     ROUT          LROUT
     C                   GOTO      NXTA
     C                   END
      ** CHECK IF EXISTS
     C     ROTKEY        KLIST
     C                   KFLD                    LSDATE
     C                   KFLD                    LROUT
     C     ROTKEY        CHAIN(N)  FTRHDRHD                           30
     C   30              SETON                                        99
     C   30              GOTO      NXTA
     C                   END
      *
     C     LROUT         IFNE      OROUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LROUT         OROUT             2
      *
     C     LDIR          IFNE      'Y'                                                      Q
     C     LDIR          ANDNE     'N'
     C                   SETON                                        40  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LDIR          IFNE      ODIR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LDIR          ODIR              1
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54  99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
     C                   Z-ADD     VOUT          LVOUT
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
     C   98              GOTO      NXTA
     C                   ENDIF
      * IF TRUCK OR ROUTE SELECTED DISPLAY HEAD AND ASK FOR CHANGES.
     C     LTRUCK        IFLE      *BLANKS
     C     LROUT         ANDLE     *BLANKS
     C                   GOTO      END
     C                   ENDIF
      * SHOW RECORD AND ALLOW UPDATE
     C                   SETOFF                                       0102
     C     LTRUCK        IFGT      *BLANKS
     C                   SETON                                        01
     C                   ELSE
     C                   SETON                                        02
     C                   END
     C   01TRKKEY        CHAIN     FTRHDRH                            20
     C   02ROTKEY        CHAIN     FTRHDRHD                           30
      * SHOW SCREEN B
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
     C   01              UPDATE    TRHDRH
     C   02              UPDATE    RTRHDRH
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** BUILD FILE
     C                   MOVE      TIMOD         FILE
     C                   MOVEL     'TRHD'        FILE
     C                   ENDSR
