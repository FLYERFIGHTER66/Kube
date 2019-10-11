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
      *PROGRAM NAME-------- ARC560
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *SYSTEM-------------- SALESPERSON COMMISSION PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSLSM    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FARC560FM  CF   E             WORKSTN
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LBSLS                  3      4
     D  LESLS                  5      6
     D  LACTP                  7      8  0
     D  LBDATE                 9     15  0
     D  LEDATE                16     22  0
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             CNT               3 0
      *
     C     LCO           CHAIN     FARCTL                             90
     C  N90ACPCOM        IFEQ      'N'
     C                   SETON                                        77
     C                   ENDIF
      *
     C  N77              GOTO      NXT
      *
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C                   GOTO      END
      *
     C     NXT           TAG
     C                   Z-ADD     0             CNT               3 0
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       205051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
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
     C                   GOTO      NXT
     C                   ENDDO
     C                   Z-ADD     VACTP         LACTP
      *
     C     LBSLS         IFEQ      *BLANKS
     C     LESLS         ANDEQ     *BLANKS
     C                   GOTO      NOSLS
     C                   ENDIF
      *
     C     1             SUBST     LBSLS:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBSLS         VSLS              2
     C                   EXSR      SLSSR
     C                   MOVEL     VSLS          LBSLS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     1             SUBST     LESLS:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     LESLS         VSLS              2
     C                   EXSR      SLSSR
     C                   MOVEL     VSLS          LESLS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LBSLS         CHAIN     FMSLSM                             90
     C   90              SETON                                        1011
     C   11              GOTO      NXT
      *
     C     LBSLS         IFGT      *BLANKS
     C     LESLS         ANDEQ     *BLANKS
     C                   MOVEL     LBSLS         LESLS
     C                   ENDIF
      *
     C     LESLS         CHAIN     FMSLSM                             90
     C   90              SETON                                        15
     C   15              GOTO      NXT
      *
     C     LBSLS         IFGT      LESLS
     C                   SETON                                        1012                  K
     C   12              GOTO      NXT
     C                   ENDIF
      *
     C     LBSLS         IFNE      OBSLS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBSLS         OBSLS             2
      *
     C     LESLS         IFNE      OESLS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LESLS         OESLS             2
      *
     C     NOSLS         TAG
      *
     C     LACTP         IFLE      *ZEROS                                                   K
     C     LACTP         ORGT      13                                                       K
     C                   SETON                                        20
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     LACTP         X                 2 0
     C                   Z-ADD     BEG(X)        BDATE             6 0
     C                   Z-ADD     DNE(X)        EDATE             6 0
      *
     C                   Z-ADD     BDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LBDATE
      *
     C                   Z-ADD     EDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LEDATE
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      NXT
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
     C   98              GOTO      NXT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
      *********
      * SLSSR
      *********
     C     SLSSR         BEGSR
     C                   MOVEL     VSLS          SMSLSM
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLS
     C                   MOVEL     SMSLSM        VSLS
     C                   MOVEL     SMNAME        SNAME            30
     C                   ENDSR
      *
