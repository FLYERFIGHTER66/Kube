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
      *PROGRAM NAME-------- PHYPMT
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- PHYSICAL INVENTORY PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FPHYPMTFM  CF   E             WORKSTN
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     F*FLISTCD IF  E           K        DISK
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
     D  LBCODE                 3      4
     D  LECODE                 5      6
     D  LBLOC                  7      9
     D  LELOC                 10     12
     D  LBLIST                13     16
     D  LELIST                17     20
     D  LBPC                  21     22
     D  LEPC                  23     24
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
      * GET USER/DEPT PRINTER
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        LPRTR
      *
      * ENTER PHYSICAL COUNT
      *
     C     LPROG         IFEQ      'ICC605  '
     C                   SETON                                        77
     C                   ENDIF
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       25
     C                   SETOFF                                       404142
     C                   SETOFF                                       45
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
      *
     C     LBLOC         IFEQ      *BLANKS
     C     LELOC         ANDEQ     *BLANKS
     C                   GOTO      NOLOC
     C                   ENDIF
      *
     C     1             SUBST     LBLOC:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBLOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LBLOC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LELOC:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     LELOC         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         LELOC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBLOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        2021                  K
     C   21              GOTO      RSTRTA
      *
     C     LELOC         IFEQ      *BLANKS
     C                   MOVEL     LBLOC         LELOC
     C                   ENDIF
      *
     C     LELOC         CHAIN     FMWHSE                             90
     C   90              SETON                                        25                    K
     C   25              GOTO      RSTRTA
      *
     C     LBLOC         IFGT      LELOC
     C                   SETON                                        2022                  K
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBLOC         IFNE      OBLOC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBLOC         OBLOC             3
      *
     C     LELOC         IFNE      OELOC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LELOC         OELOC             3
      *
     C     NOLOC         TAG
      *
      * CHECK PC
      *
     C     LBPC          IFEQ      *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     1             SUBST     LBPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBPC          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LBPC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     1             SUBST     LEPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LEPC
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C     LEPC          ANDEQ     *BLANKS
     C                   MOVEL     LBPC          LEPC
     C                   ENDIF
      *
     C     LBPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        4041                  K
     C   41              GOTO      RSTRTA
      *
     C     LEPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        45                    K
     C   45              GOTO      RSTRTA
      *
     C     LBPC          IFGT      LEPC
     C                   SETON                                        4042                  K
     C   22              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBPC          IFNE      OBPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBPC          OBPC              2
      *
     C     LEPC          IFNE      OEPC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LEPC          OEPC              2
      *
     C     NOPC          TAG
      *
     C     LBCODE        IFNE      OBCODE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBCODE        OBCODE            2
      *
     C     LECODE        IFNE      OECODE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LECODE        OECODE            2
      *
     C     LBLIST        IFNE      OBLIST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBLIST        OBLIST            4
      *
     C     LELIST        IFNE      OELIST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LELIST        OELIST            4
      *
     C   77              GOTO      NOPRT
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
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
     C     NOPRT         TAG
      *
      ** CHECK IF CHANGES
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTA
     C                   END
     C                   GOTO      END
      ** NO DEPARTMENT
     C     NODEPT        TAG
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C     END           TAG
     C                   SETON                                        LR
      *********
      * PCSR
      *********
     C     PCSR          BEGSR
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC            30
     C                   ENDSR
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            30
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             VOUT
      *
     C     USERID        CHAIN     FMUSER                             91
     C  N91              DO
     C     USDEPT        CHAIN     FMDEPT                             91
     C                   ENDDO
     C  N91DESHFR        IFLE      *BLANKS
     C                   SETON                                        91
     C                   END
     C                   ENDSR
