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
      *PROGRAM NAME-------- ARC310
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- AGING REPORTS PROMPTS
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FARC310FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LDATE                  3      8  0
     D  LBCUST                 9     14  0
     D  LECUST                15     20  0
     D  LBSLSM                21     22
     D  LESLSM                23     24
     D  LDAYS                 25     27  0
     D  LINCL                 28     28
     D  DETSUM                29     29
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
     C                   MOVEL     'S'           DETSUM
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       414250
     C                   SETOFF                                       515253
     C                   SETOFF                                       5415
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LDATE         ODATE             6 0
      *
     C     LINCL         IFNE      'Y'                                                      Q
     C     LINCL         ANDNE     'N'
     C                   SETON                                        20
     C   20              GOTO      RSTRT
     C                   ENDIF
      *
     C     LINCL         IFNE      OINCL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LINCL         OINCL             1
      * CHECK DETAIL OR SUMMARY
     C     DETSUM        IFNE      'S'
     C     DETSUM        ANDNE     'D'
     C                   SETON                                        15
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C   KB              DO
     C                   Z-ADD     0             CMCUST
     C                   MOVEL     *BLANKS       CMLOOK           15
     C                   MOVEL     'A'           CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   Z-ADD     CMCUST        LBCUST
     C                   GOTO      RSTRT
     C                   ENDDO
      *
     C   KD              DO
     C                   Z-ADD     0             CMCUST
     C                   MOVEL     *BLANKS       CMLOOK
     C                   MOVEL     'A'           CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   Z-ADD     CMCUST        LECUST
     C                   GOTO      RSTRT
     C                   ENDDO
      *
     C     LBCUST        IFEQ      0                                                        OS
     C     LECUST        ANDGT     0                                                        OS
     C                   SETON                                        3031
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBCUST        IFGT      0                                                        OS
     C     LECUST        ANDEQ     0                                                        OS
     C                   Z-ADD     LBCUST        LECUST
     C                   ENDIF
      *
     C     LBCUST        IFGT      LECUST                                                   OS
     C                   SETON                                        3032
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBCUST        IFNE      OCUSTB
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBCUST        OCUSTB            6 0
      *
     C     LECUST        IFNE      OCUSTE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LECUST        OCUSTE            6 0
      *
      * SALESPERSON  LOOKUP
      *
     C     1             SUBST     LBSLSM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBSLSM        SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       LBSLSM
     C                   MOVEL     SMSLSM        LBSLSM
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     1             SUBST     LESLSM:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LESLSM        SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       LESLSM
     C                   MOVEL     SMSLSM        LESLSM
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBSLSM        IFGT      *BLANKS                                                  OS
     C     LESLSM        ANDEQ     *BLANKS                                                  OS
     C                   MOVEL     LBSLSM        LESLSM
     C                   ENDIF
      *
     C     LBSLSM        IFEQ      *BLANKS                                                  OS
     C     LESLSM        ANDGT     *BLANKS                                                  OS
     C                   SETON                                        4041
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBSLSM        IFGT      LESLSM                                                   OS
     C                   SETON                                        4042
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LBSLSM        IFNE      OSLSB
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBSLSM        OSLSB             2
      *
     C     LESLSM        IFNE      OSLSE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LESLSM        OSLSE             2
      *
     C     LDAYS         IFNE      ODAYS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LDAYS         ODAYS             3 0
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
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VOUT          OOUT              1 0
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
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   SETOFF                                       98
     C                   Z-ADD     TDATE         LDATE
     C                   MOVEL     'N'           LINCL
     C                   Z-ADD     0             LBCUST
     C                   Z-ADD     0             LECUST
     C                   MOVEL     *BLANKS       LBSLSM
     C                   MOVEL     *BLANKS       LESLSM
     C                   Z-ADD     0             LDAYS
     C                   Z-ADD     1             VOUT
     C                   ENDSR
      *
