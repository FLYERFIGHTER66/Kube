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
      *PROGRAM NAME-------- ARC580
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- SUMMARY MONTH END PROMPT SCREEN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FARC580FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
      * MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
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
     D  LACTP                  3      4  0
     D  LBDATE                 5     11  0
     D  LEDATE                12     18  0
     D  LINC                  89     89  0
     D  LINV                  90     90
     D  LCM                   91     91
     D  LCASH                 92     92
     D  LSALE                 93     93
     D  LLATE                 94     94
     D  LTAX                  95     95
     D  LAGE                  96     96
     D  LGL                   97     97
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
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      DNE(1)
     I              ACEN02                      DNE(2)
     I              ACEN03                      DNE(3)
     I              ACEN04                      DNE(4)
     I              ACEN05                      DNE(5)
     I              ACEN06                      DNE(6)
     I              ACEN07                      DNE(7)
     I              ACEN08                      DNE(8)
     I              ACEN09                      DNE(9)
     I              ACEN10                      DNE(10)
     I              ACEN11                      DNE(11)
     I              ACEN12                      DNE(12)
     I              ACEN13                      DNE(13)
      *
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LACTP
     C                   Z-ADD     1             LINC
      *
     C                   Z-ADD     1             CNT               2 0
     C                   MOVE      'Y'           LINV
     C                   MOVE      'Y'           LCM
     C                   MOVE      'Y'           LCASH
     C                   MOVE      'Y'           LSALE
     C                   MOVE      'Y'           LLATE
     C                   MOVE      'Y'           LTAX
     C                   MOVE      'Y'           LAGE
     C                   MOVE      'Y'           LGL
      *
     C                   SETOFF                                       88
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
      *
     C     CNT           IFGT      1
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C                   SETON                                        88
     C                   GOTO      NXTA
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNTB              2 0
     C                   SETOFF                                       101520
     C                   SETOFF                                       253032
     C                   SETOFF                                       343540
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
      *
     C     LINV          IFNE      'Y'
     C     LINV          ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LINV          IFNE      OINV
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LINV          OINV              1
      *
     C     LCM           IFNE      'Y'
     C     LCM           ANDNE     'N'
     C                   SETON                                        15
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LCM           IFNE      OCM
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LCM           OCM               1
      *
     C     LCASH         IFNE      'Y'
     C     LCASH         ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LCASH         IFNE      OCASH
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LCASH         OCASH             1
      *
     C     LSALE         IFNE      'Y'
     C     LSALE         ANDNE     'N'
     C                   SETON                                        25
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LSALE         IFNE      OSALE
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LSALE         OSALE             1
      *
     C     LLATE         IFNE      'Y'
     C     LLATE         ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LLATE         IFNE      OLATE
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LLATE         OLATE             1
      *
     C     LTAX          IFNE      'Y'
     C     LTAX          ANDNE     'N'
     C                   SETON                                        32
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LTAX          IFNE      OTAX
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LTAX          OTAX              1
      *
     C     LAGE          IFNE      'Y'
     C     LAGE          ANDNE     'N'
     C                   SETON                                        34
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LAGE          IFNE      OAGE
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LAGE          OAGE              1
      *
     C     LGL           IFNE      'Y'
     C     LGL           ANDNE     'N'
     C                   SETON                                        35
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LGL           IFNE      OGL
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LGL           OGL               1
      *
     C     CNTB          IFGT      0
     C                   SETON                                        98
     C   98              GOTO      NXTB
     C                   ENDIF
      *
     C     NXTC          TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNTC              2 0
     C                   SETOFF                                       105051
     C                   SETOFF                                       525354
     C                   READ      SCRNC                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   Z-ADD     LACTP         VACTP             2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   Z-ADD     VACTP         LACTP
     C                   GOTO      NXTC
     C                   ENDDO
      *
     C     LACTP         IFLE      *ZEROS                                                   K
     C     LACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LACTP         IFNE      OACTP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LACTP         OACTP             2 0
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNTC
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNTC
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNTC
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNTC
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNTC
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
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     LACTP         X                 2 0
     C                   Z-ADD     BEG(X)        LBDATE
     C                   Z-ADD     DNE(X)        LEDATE
     C                   EXSR      LDLDA
      *
     C     CNTC          IFGT      0
     C                   SETON                                        97
     C   97              GOTO      NXTC
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********
      * LDLDA   *
      ***********
     C     LDLDA         BEGSR
     C                   Z-ADD     1             LINC
     C                   ENDSR
      *
