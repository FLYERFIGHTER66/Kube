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
      *PROGRAM NAME-------- ARC530
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- MONTHLY INVOICE JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFARCTL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FARC530FM  CF   E             WORKSTN
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
     D  LSLSM                 20     21
     D  LSHFR                 22     24
     D  LFRT                  25     25
     D  LSPEC                 26     26
     D  LTAX                  27     27
     D  LARCST                28     33  0
     D  LSHIP                 34     39  0
     D  LINC                  89     89  0
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
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102050
     C                   SETOFF                                       515253
     C                   SETOFF                                       54
     C                   Z-ADD     0             CNT               1 0
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C   KE              GOTO      NXTB
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C                   Z-ADD     VACTP         LACTP
      *
     C     LCO           CHAIN     FMAPER                             90                    K
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        60
     C                   ENDIF
      *
     C   60LACTP         IFEQ      *ZEROS                                                   K
     C     LACTP         ORGT      12                                                       K
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C  N60LACTP         IFEQ      *ZEROS                                                   K
     C     LACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LACTP         IFNE      OACTP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LACTP         OACTP             2 0
      *
     C     LINC          IFEQ      0                                                        K
     C     LINC          ORGT      3                                                        K
     C                   SETON                                        20
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     LINC          IFNE      OINCL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LINC          OINCL             1 0
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
     C                   MOVEL     LFORM         OFORM             4
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
     C                   Z-ADD     0             CNT
     C   98              GOTO      NXTA
     C                   ENDIF
      *
     C                   GOTO      END
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       101112
     C                   SETOFF                                       131820
     C                   SETOFF                                       404559
     C                   SETOFF                                       505152
     C                   SETOFF                                       6170
     C                   Z-ADD     0             CNTB              1 0
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C     VBDATE        IFEQ      *ZEROS
     C     VEDATE        ANDEQ     *ZEROS
     C                   GOTO      SLSM
     C                   ENDIF
      *
     C     VBDATE        IFEQ      *ZEROS
     C     VEDATE        ANDGT     *ZEROS
     C                   SETON                                        1011
     C   10              GOTO      NXTB
     C                   ENDIF
      *
     C                   Z-ADD     VBDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1012
     C                   GOTO      NXTB
     C                   ENDIF
     C                   Z-ADD     ##CYMD        DTEBEG            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C     VEDATE        IFEQ      0
     C                   Z-ADD     VBDATE        VEDATE
     C                   ENDIF
      *
     C                   Z-ADD     VEDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        18
     C                   GOTO      NXTB
     C                   ENDIF
     C                   Z-ADD     ##CYMD        DTEEND            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     BDATE         IFGT      EDATE
     C                   SETON                                        13
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   Z-ADD     DTEBEG        LBDATE            7 0
     C                   Z-ADD     DTEEND        LEDATE            7 0
      *
     C     VBDATE        IFNE      OBDATE
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   Z-ADD     VBDATE        OBDATE            6 0
      *
     C     VEDATE        IFNE      OEDATE
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   Z-ADD     VEDATE        OEDATE            6 0
      *
     C     SLSM          TAG
     C                   SUBST     LSLSM:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LSLSM         SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       LSLSM
     C                   MOVEL     SMSLSM        LSLSM
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LSLSM         IFGT      *BLANKS
     C     LSLSM         CHAIN(N)  FMSLSM                             90
     C   90              SETON                                        20
     C   20              GOTO      NXTB
     C                   ENDIF
      *
     C     LSLSM         IFNE      OSLSM
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LSLSM         OSLSM             2
      *
     C                   SUBST     LSHFR:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       LSHFR
     C                   MOVEL     WHWHSE        LSHFR
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LSHFR         IFGT      *BLANKS
     C     LSHFR         CHAIN(N)  FMWHSE                             91
     C   91              SETON                                        30
     C   30              GOTO      NXTB
     C                   ENDIF
      *
     C     LSHFR         IFNE      OSHFR
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LSHFR         OSHFR             3
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
     C                   Z-ADD     CMCUST        LARCST
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
     C                   Z-ADD     CMCUST        LSHIP
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C     LARCST        IFGT      0
     C     LARCST        CHAIN(N)  FMCUST                             91
     C   91              SETON                                        40
     C   40              GOTO      NXTB
     C                   ENDIF
      *
     C     LARCST        IFNE      OARCST
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   Z-ADD     LARCST        OARCST            6 0
      *
     C     LSHIP         IFGT      0
     C     LSHIP         CHAIN(N)  FMCUST                             91
     C   91              SETON                                        45
     C   45              GOTO      NXTB
     C                   ENDIF
      *
     C     LSHIP         IFNE      OSHIP
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   Z-ADD     LSHIP         OSHIP             6 0
      *
     C     LFRT          IFNE      'Y'
     C     LFRT          ANDNE     'N'
     C                   SETON                                        5052
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LFRT          IFNE      OFRT
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LFRT          OFRT              1
      *
     C     LSPEC         IFNE      'Y'
     C     LSPEC         ANDNE     'N'
     C                   SETON                                        61
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LSPEC         IFNE      OSPEC
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LSPEC         OSPEC             1
      *
     C     LTAX          IFNE      'Y'
     C     LTAX          ANDNE     'N'
     C                   SETON                                        70
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LFRT          IFEQ      'Y'
     C     LSPEC         ANDEQ     'Y'
     C                   SETON                                        5059
     C   59              GOTO      NXTB
     C                   ENDIF
     C     LFRT          IFEQ      'Y'
     C     LTAX          ANDEQ     'Y'
     C                   SETON                                        5059
     C   59              GOTO      NXTB
     C                   ENDIF
     C     LSPEC         IFEQ      'Y'
     C     LTAX          ANDEQ     'Y'
     C                   SETON                                        5059
     C   59              GOTO      NXTB
     C                   ENDIF
      *
     C     LTAX          IFNE      OTAX
     C                   ADD       1             CNTB
     C                   ENDIF
     C                   MOVEL     LTAX          OTAX              1
      *
     C     CNTB          IFGT      0
     C                   SETON                                        55
     C                   Z-ADD     0             CNTB
     C   55              GOTO      NXTB
     C                   ENDIF
      *
     C*  KB                GOTO NXTA
     C                   GOTO      NXTA
      *
     C     END           TAG
      *
     C     VBDATE        IFEQ      0
     C                   Z-ADD     LACTP         X                 2 0
     C                   Z-ADD     BEG(X)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LBDATE            7 0
     C                   Z-ADD     DNE(X)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LEDATE            7 0
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *                                                                ***
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FARCTL                             90
     C                   Z-ADD     1             VOUT
      *
     C                   Z-ADD     1             LINC
     C                   MOVEL     'N'           LFRT
     C                   MOVEL     'N'           LSPEC
     C                   MOVEL     'N'           LTAX
     C                   Z-ADD     0             LARCST
     C                   Z-ADD     0             LSHIP
     C                   Z-ADD     0             LACTP
      *
     C                   ENDSR
      *                                                                ***
