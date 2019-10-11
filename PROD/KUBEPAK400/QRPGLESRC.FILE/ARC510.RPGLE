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
      *PROGRAM NAME-------- ARC510
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- PRINT STATEMENTS PROMPT SCREEN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * EFD01 11/12/02 CHANGE DEFAULTS
      *
      *
     FFARCTL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FARC510FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LBCUST                 9     14  0
     D  LECUST                15     20  0
     D  LZERO                 21     21
     D  LCRED                 22     22
     D  LSDATE                23     29  0
     D  LC1                   67     67  0
     D  LC2                   68     68  0
     D  LC3                   69     69  0
     D  LC4                   70     70  0
     D  LC5                   71     71  0
     D  LC6                   72     72  0
     D  LC7                   73     73  0
     D  LC8                   74     74  0
     D  LC9                   75     75  0
     D  LCYCL9                75     75  0
     D  LBFDTE                76     81  0
     D  LSHTOT                82     82
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     D  LEMAILIT             172    172
      *
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     'Y'           LJOBQ
     C                   MOVEL     'Y'           EMAILIT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101120
     C                   SETOFF                                       213040
     C                   SETOFF                                       605051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
      * CHECK FOR A VALID DATE
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        LSDATE            7 0
      *
     C     LDATE         IFNE      ODATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LDATE         ODATE             6 0
      *
     C     LZERO         IFNE      'Y'                                                      Q
     C     LZERO         ANDNE     'N'
     C                   SETON                                        40
     C   40              GOTO      NXTA
     C                   ENDIF
      *
     C     LZERO         IFNE      OZERO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LZERO         OZERO             1
      *
     C     LCRED         IFNE      'Y'                                                      Q
     C     LCRED         ANDNE     'N'
     C                   SETON                                        60
     C   60              GOTO      NXTA
     C                   ENDIF
      *
     C     LCRED         IFNE      OCRED
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LCRED         OCRED             1
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
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
     C                   SETON                                        53
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      NXTA
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
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VOUT          OOUT              1 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      NXTA
     C                   ENDIF

     C                   MOVE      EMAILIT       LEMAILIT
      *
     C                   SETOFF                                       98
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101120
     C                   SETOFF                                       213040
     C                   SETOFF                                       605051
     C                   SETOFF                                       525354
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KB              DO
     C                   Z-ADD     0             CMCUST
     C     CMCUST        CHAIN     FMCUST                             90
     C                   MOVEL     *BLANKS       CMLOOK           15
     C                   MOVEL     'A'           CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   Z-ADD     CMCUST        LBCUST
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C   KD              DO
     C                   Z-ADD     0             CMCUST
     C     CMCUST        CHAIN     FMCUST                             90
     C                   MOVEL     *BLANKS       CMLOOK           15
     C                   MOVEL     'A'           CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   Z-ADD     CMCUST        LECUST
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C     LBCUST        IFEQ      0
     C     LECUST        ANDEQ     0
     C                   GOTO      NOCUST
     C                   ENDIF
      *
     C     LBCUST        IFGT      0
     C     LECUST        ANDEQ     0
     C                   Z-ADD     LBCUST        LECUST
     C                   ENDIF
      *
     C     LECUST        IFLT      LBCUST
     C                   SETON                                        20
     C   20              GOTO      NXTB
     C                   ENDIF
      *
     C     LBCUST        CHAIN     FMCUST                             91
     C   91              SETON                                        20
     C   20              GOTO      NXTB
      *
     C     LECUST        CHAIN     FMCUST                             91
     C   91              SETON                                        21
     C   21              GOTO      NXTB
      *
     C     LBCUST        IFNE      OBCUST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LBCUST        OBCUST            6 0
      *
     C     LECUST        IFNE      OECUST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LECUST        OECUST            6 0
      *
     C     NOCUST        TAG
      *
     C     LSHTOT        IFNE      'Y'
     C     LSHTOT        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   77              GOTO      NOBF
      *
     C                   Z-ADD     LBFDTE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LBFDTE        IFNE      OBFDTE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LBFDTE        OBFDTE            6 0
     C     NOBF          TAG
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      NXTB
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FARCTL                             90
     C                   MOVEL     ACSTMP        LPRTR
     C                   MOVEL     'ARSTMT'      FORM1             8
     C                   MOVE      LCO           FORM1
     C                   MOVEL     FORM1         LFORM
      *
      * ACSTTP = STATEMENT TYPE
      *
     C     ACSTTP        IFEQ      1
     C                   SETON                                        77
     C                   ENDIF
      *
     C*??????              Z-ADDACDTPR    ##MDY
     C                   Z-ADD     TDATE         LDATE
     C                   Z-ADD     0             LBCUST
     C                   Z-ADD     0             LECUST
     C                   Z-ADD     1             LC1
     C                   Z-ADD     0             LC2
     C                   Z-ADD     0             LC3
     C                   Z-ADD     0             LC4
     C                   Z-ADD     0             LC5
     C                   Z-ADD     0             LC6
     C                   Z-ADD     0             LC7
     C                   Z-ADD     0             LC8
     C                   Z-ADD     0             LC9
     C                   MOVEL     'N'           LZERO
WJB  C*                  MOVEL     'Y'           LCRED
WJB  C                   MOVEL     'N'           LCRED
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             LBFDTE
      *
     C                   ENDSR
      *
