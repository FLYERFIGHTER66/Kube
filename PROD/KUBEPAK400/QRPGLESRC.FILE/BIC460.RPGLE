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
      *PROGRAM NAME-------- BIC460
      *SYSTEM-------------- ORDER ENTRY/BILLING
      *APPLICATION--------- PRINT CREDIT MEMOS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMWHSE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFHORCW    IF   E           K DISK
     FBIC460FM  CF   E             WORKSTN
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
      ****************
      *   LDA        *
      ****************
     D                UDS
      * COMPANY
     D  LCO                    1      2  0
      * REPRINT Y/N
     D  LDARPT                 3      3
      * ROUTE I.D.
     D  LDARTE                 4      5
      * ROUTE ALL
     D  LDAALL                 6      8
      * BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                  9     14  0
      * ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 15     20  0
      * INVOICE DATE
     D  LDATE                 21     26  0
      * SHIP FROM LOCATION
     D  LSHFR                 27     29
      * BEGINING ORDER NUMBER
     D  LBORD                 30     35  0
      * ENDING ORDER NUMBER
     D  LEORD                 36     41  0
      * POINT OF SALE INVOICE Y/N
     D  LPOS                  42     42
      * BEGINING DATE
     D  LBDATE                44     49  0
      * ENDING DATE
     D  LEDATE                50     55  0
      * SELECTION PICK SLIP
     D  LSEL                  56     56  0
      * PRODUCT CLASS 1
     D  LBPC                  57     58
      * PRODUCT CLASS 2
     D  LEPC                  59     60
      * ROUTE 1
     D  LBRTE                 61     62
      * ROUTE 2
     D  LERTE                 63     64
      * PHYTO 1
     D  LBPHY                 65     65
      * PHYTO 2
     D  LEPHY                 66     66
      * PREV. PRINTED
     D  LPREV                 67     67
      * SHIP 1
     D  LSHP1                 68     69
      * SHIP 2
     D  LSHP2                 70     71
      * LOCATION 1
     D  LBSHFR                72     74
      * LOCATION 2
     D  LESHFR                75     77
      * TAG
     D  LTAG                  78     78  0
      * DATE
     D  LSTDAT                79     84  0
      * SALE I.D.
     D  LSALE                 85     87
      * DEPARTMENT
     D  LDEPT                 88     90
      * SALE DATE
     D  TYCENB                91     95  0
      * PRINTER ID
     D  LPRTR1               100    109
      * FORMS NUMBER
     D  LFORM                110    119
      * NUMBER OF COPIES
     D  LCOPY                120    121  0
      * JOBQ
     D  LJOBQ                122    122
      * HOLD PRINT OUTPUT
     D  LHOLD                123    126
      * PRINT AND SAVE OUTPUT
     D  LSAVE                127    130
      * CANCEL  X=CANCEL
     D  LCANCL               133    133
      * PRINTER ID PICK SLIP 2
     D  LPRTR2               134    143
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
     C     BEGIN         TAG
     C                   SETON                                        09
     C                   MOVEL     'N'           LDARPT
     C                   Z-ADD     TDATE         LDATE
      *
     C     RSTRTA        TAG
     C   12              SETOFF                                       09
     C                   WRITE     SCRNA
     C                   SETOFF                                       1020
     C                   SETOFF                                       081213
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      BEGIN
      *
     C                   MOVEL     *BLANKS       LCANCL
      *
     C   12              GOTO      REPRNT
      *
     C     LDARPT        IFNE      'Y'                                                      Q
     C     LDARPT        ANDNE     'N'
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     LDARPT        IFEQ      'N'
     C                   GOTO      RSTRTB
     C                   END
      *
     C                   SETON                                        12
     C   09
     CAN 12              GOTO      RSTRTA
      *
     C     REPRNT        TAG
      *
     C     LBINV         IFEQ      0                                                        OS
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LBINV         CHAIN     FHORCW                             98
     C   98              SETON                                        20
     C   20              GOTO      RSTRTA
      *
     C     LBINV         IFGT      0
     C     LEINV         ANDEQ     0
     C                   Z-ADD     LBINV         LEINV
     C                   ENDIF
      *
     C     LEINV         IFEQ      0                                                        OS
     C                   SETON                                        25
     C                   GOTO      RSTRTA
     C                   END
      *
     C     LBINV         IFGT      LEINV                                                    OS
     C                   SETON                                        20
     C                   GOTO      RSTRTA
     C                   END
      *
     C     LBINV         IFNE      OBINV
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBINV         OBINV             6 0
      *
     C     LEINV         IFNE      OEINV
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LEINV         OEINV             6 0
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
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   GOTO      END
      *
     C     RSTRTB        TAG
      *
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       132030
     C                   SETOFF                                       4545
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      BEGIN
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      RSTRTB
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         IDATE             5 0
      *
     C     IDATE         IFLT      YRBEG
     C                   SETON                                        1012
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   ADD       1             FIRST             3 0
     C     IDATE         IFGT      YREND
     C     FIRST         ANDEQ     1
     C                   SETON                                        1013
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     1             SUBST     LBSHFR:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBSHFR        WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       LBSHFR
     C                   MOVEL     WHWHSE        LBSHFR
     C                   MOVEL     WHDESC        VDESC            30
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LBSHFR        CHAIN(N)  FMWHSE                             90
     C   90              SETON                                        20
     C   20              GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBSHFR        IFNE      OSHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBSHFR        OSHFR             3
      *
     C     LBORD         IFGT      0
     C     LEORD         ANDEQ     0
     C                   Z-ADD     LBORD         LEORD
     C                   ENDIF
      *
     C     LBORD         IFGT      LEORD
     C                   SETON                                        30
     C   30              GOTO      RSTRTB
     C                   ENDIF
      *
     C     LBORD         IFNE      OBORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LBORD         OBORD             6 0
      *
     C     LEORD         IFNE      OEORD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LEORD         OEORD             6 0
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRTB
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
     C                   GOTO      RSTRTB
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
     C                   GOTO      RSTRTB
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
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
      * GET USER/DEPT PRINTER
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPINV        LPRTR
     C                   MOVEL     DESHFR        LSHFR
     C     LPRTR         IFLE      *BLANKS
     C                   MOVEL     'PRT01'       LPRTR
     C                   ENDIF
     C                   MOVEL     '*INV'        LFORM1            6
     C                   MOVE      LCO           LFORM1
     C                   MOVEL     LFORM1        LFORM
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     'N'           LPOS              1
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     BEG(1)        ##MDY
     C                   Z-ADD     BEG(1)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YRBEG             5 0
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     DNE(12)       ##MDY
     C                   ELSE
     C                   Z-ADD     DNE(13)       ##MDY
     C                   ENDIF
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YREND             5 0
      *
     C                   Z-ADD     0             LBINV
     C                   Z-ADD     0             LEINV
     C                   Z-ADD     0             LBORD
     C                   Z-ADD     0             LEORD
      *
     C                   Z-ADD     1             VOUT
      *
     C                   ENDSR
      *
