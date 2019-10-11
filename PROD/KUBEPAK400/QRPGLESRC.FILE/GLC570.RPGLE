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
      *PROGRAM NAME-------- GLC570
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- TRIAL BALANCE BY ACCOUNT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFMAPER    IF   E           K DISK
     FGLC570FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LCO                    1      2  0                                      GLR360
     D  LACTPb                 3      4  0                                      Beginning Period
     D  LBEGDT                 5     10  0                                      GLR360
     D  LENDDT                11     16  0                                      GLR360
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LACTPe               172    173  0                                      Ending Period
     D  LYEAR                174    177  0                                      Year Selected
     D  Libraries            178    277                                         Ending Period
      *
     D                 DS
     D  Libs                   1    100A
     D  Lib                          10A   DIM(10) OVERLAY(Libs)
      *
     D  YearsDS        DS                  Inz
     D  Year01                        4S 0
     D  Year02                        4S 0
     D  Year03                        4S 0
     D  Year04                        4S 0
     D  Year05                        4S 0
     D  Year06                        4S 0
     D  Year07                        4S 0
     D  Year08                        4S 0
     D  Year09                        4S 0
     D  Year10                        4S 0
     D  Years                         4S 0 DIM(10) OVERLAY(YearsDS)
      *
     C                   Eval      Libs = Libraries
     C     1             Do        10            X                 2 0
     C                   If        Lib(X) <> *Blanks
     C                   Eval      Years(X) = %Int(%subst(Lib(X):6:2))+2000
     C                   EndIf
     C                   EndDo

     C                   Z-ADD     1             VOUT
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       105051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTPb
     C                   GOTO      RSTRT
     C                   ENDDO
      *
     C   KD              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTPe
     C                   GOTO      RSTRT
     C                   ENDDO
      *
     C   KK              DO
     C                   Eval      *In60 = *Off
     C     RSTRTB        TAG
     C                   EXFMT     SCRNB
     C                   Eval      *In60 = *Off
     C     LYEAR         LOOKUP    YEARS                                  60
     C                   If        *In60 or LYEAR = *YEAR
     C                   MOVE      'Y'           LCANCL
     C                   Eval      *InLR = *On
     C                   GOTO      END
     C                   Else
     C                   GOTO      RSTRTB
     C                   EndIf
     C                   ENDDO
      *
     C                   Z-ADD     VACTPb        LACTPb
     C                   Z-ADD     VACTPe        LACTPe
      * Beginning Period
     C     VACTPb        IFLE      *ZEROS                                                   K
     C     VACTPb        ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      * Ending Period
     C     VACTPe        IFLE      *ZEROS                                                   K
     C     VACTPe        ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     ACST13        IFEQ      *ZEROS                                                   K
     C     VACTPb        ANDEQ     13                                                       K
     C     ACST13        orEQ      *ZEROS                                                   K
     C     VACTPe        ANDEQ     13                                                       K
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     VACTPb        ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDATb           6 0
     C                   PARM                    ENDDATb           6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     VACTPe        ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDATe           6 0
     C                   PARM                    ENDDATe           6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     BEGDATb       LBEGDT
     C                   Z-ADD     ENDDATe       LENDDT
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRT
     C                   ENDIF
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
     C     END           TAG
     C                   SETON                                        LR
      **
