      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR375
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- S/A BY TOP RANKED CUSTOMERS UNITS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSHISTSU  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR375    O    F  132        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      *
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LRANK                  6     11  0
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
     D  PC                   172    181  0
     D                                     DIM(10)
     D  LPC01                172    172  0
     D  LPC02                173    173  0
     D  LPC03                174    174  0
     D  LPC04                175    175  0
     D  LPC05                176    176  0
     D  LPC06                177    177  0
     D  LPC07                178    178  0
     D  LPC08                179    179  0
     D  LPC09                180    180  0
     D  LPC10                181    181  0
     D  LPCFR                182    182  0
     D  LPCTO                183    183  0
     D  CT                   184    203
     D                                     DIM(10)
     D  LCT01                184    185
     D  LCT02                186    187
     D  LCT03                188    189
     D  LCT04                190    191
     D  LCT05                192    193
     D  LCT06                194    195
     D  LCT07                196    197
     D  LCT08                198    199
     D  LCT09                200    201
     D  LCT10                202    203
     D  LCTFR                204    205
     D  LCTTO                206    207
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
     IRSHISTS
      *
     I              SHCS01                      CS$(1)
     I              SHCS02                      CS$(2)
     I              SHCS03                      CS$(3)
     I              SHCS04                      CS$(4)
     I              SHCS05                      CS$(5)
     I              SHCS06                      CS$(6)
     I              SHCS07                      CS$(7)
     I              SHCS08                      CS$(8)
     I              SHCS09                      CS$(9)
     I              SHCS10                      CS$(10)
     I              SHCS11                      CS$(11)
     I              SHCS12                      CS$(12)
     I              SHCS13                      CS$(13)
      *
     I              SHLS01                      PS$(1)
     I              SHLS02                      PS$(2)
     I              SHLS03                      PS$(3)
     I              SHLS04                      PS$(4)
     I              SHLS05                      PS$(5)
     I              SHLS06                      PS$(6)
     I              SHLS07                      PS$(7)
     I              SHLS08                      PS$(8)
     I              SHLS09                      PS$(9)
     I              SHLS10                      PS$(10)
     I              SHLS11                      PS$(11)
     I              SHLS12                      PS$(12)
     I              SHLS13                      PS$(13)
      *
     I              SHCQ01                      CSQ(1)
     I              SHCQ02                      CSQ(2)
     I              SHCQ03                      CSQ(3)
     I              SHCQ04                      CSQ(4)
     I              SHCQ05                      CSQ(5)
     I              SHCQ06                      CSQ(6)
     I              SHCQ07                      CSQ(7)
     I              SHCQ08                      CSQ(8)
     I              SHCQ09                      CSQ(9)
     I              SHCQ10                      CSQ(10)
     I              SHCQ11                      CSQ(11)
     I              SHCQ12                      CSQ(12)
     I              SHCQ13                      CSQ(13)
      *
     I              SHLQ01                      PSQ(1)
     I              SHLQ02                      PSQ(2)
     I              SHLQ03                      PSQ(3)
     I              SHLQ04                      PSQ(4)
     I              SHLQ05                      PSQ(5)
     I              SHLQ06                      PSQ(6)
     I              SHLQ07                      PSQ(7)
     I              SHLQ08                      PSQ(8)
     I              SHLQ09                      PSQ(9)
     I              SHLQ10                      PSQ(10)
     I              SHLQ11                      PSQ(11)
     I              SHLQ12                      PSQ(12)
     I              SHLQ13                      PSQ(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LRANK         IFGT      0
     C                   SETON                                        88
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             90
     C     LCO           CHAIN     FMAPER                             90
     C     ACMPCN        COMP      'M'                                525251
     C                   Z-ADD     LMONTH        P                 2 0
     C                   Z-ADD     1             FIRST             4 0
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     LMONTH        ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FSHISTSU                               90
     C   90              GOTO      END
      *
     C     SHSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SHCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SHCUST        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
      * # OF CUSTOMERS TO RANK
      *
     C     LRANK         IFGT      0
     C     FIRST         ANDGT     LRANK
     C                   SETON                                        77
     C                   ENDIF
      *
     C     SHCUST        CHAIN     FMCUST                             90
      *
      * Insert here
     C                   MOVEA     '00'          *IN(75)
     C                   EXSR      CHKPC
      *
     C                   EXSR      CHKCT
     C  N75
     CANN76              GOTO      NXT
      *
     C                   Z-ADD     CSQ(P)        CQTY              8 0
     C                   ADD       CSQ(P)        RCYCPQ            9 0
     C  N77              ADD       CSQ(P)        CCYCPQ            9 0
     C                   ADD       CS$(P)        RCYCPS           10 2
     C  N77              ADD       CS$(P)        CCYCPS           10 2
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        CYTDQ             8 0
     C  N77              ADD       CSQ(X)        CCYTDQ            9 0
     C                   ADD       CSQ(X)        RCYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C     CYTDQ         IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        PYTDQ             8 0
     C  N77              ADD       PSQ(X)        CPYTDQ            9 0
     C                   ADD       PSQ(X)        RPYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        CYTDS             9 2
     C  N77              ADD       CS$(X)        CCYTDS           10 2
     C                   ADD       CS$(X)        RCYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        PYTDS             9 2
     C  N77              ADD       PS$(X)        CPYTDS           10 2
     C                   ADD       PS$(X)        RPYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C  N77              EXCEPT    DETL
     C                   SETOFF                                       10
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              EXCEPT    TLR1
     C   88              EXSR      PERCNT
     C                   EXCEPT    TLR
     C   88              EXCEPT    TLR77
     C                   SETON                                        LR
      *
      ********
      * PERCNT
      ********
      *
     C     PERCNT        BEGSR
     C     CCYCPS        IFGT      0
     C     CCYCPS        DIV       RCYCPS        CPSPER            5 4
     C     CPSPER        MULT      100           PERCPS            5 2
     C                   ENDIF
     C     CCYTDS        IFGT      0
     C     CCYTDS        DIV       RCYTDS        CYSPER            5 4
     C     CYSPER        MULT      100           PERCYS            5 2
     C                   ENDIF
     C     CPYTDS        IFGT      0
     C     CPYTDS        DIV       RPYTDS        PPSPER            5 4
     C     PPSPER        MULT      100           PERPPS            5 2
     C                   ENDIF
     C     CCYCPQ        IFGT      0
     C     CCYCPQ        DIV       RCYCPQ        CPQPER            5 4
     C     CPQPER        MULT      100           PERCPQ            5 2
     C                   ENDIF
     C     CCYTDQ        IFGT      0
     C     CCYTDQ        DIV       RCYTDQ        CYQPER            5 4
     C     CYQPER        MULT      100           PERCYQ            5 2
     C                   ENDIF
     C     CPYTDQ        IFGT      0
     C     CPYTDQ        DIV       RPYTDQ        PPQPER            5 4
     C     PPQPER        MULT      100           PERPPQ            5 2
     C                   ENDIF
     C                   ENDSR
      ********
      * CHECK PRICE CATAGORY SUBROUTINE
      ********
      *
     C     CHKPC         BEGSR
     C                   DO        10            II                2 0
     C                   MOVEL     PC(II)        PRCCDE            1 0
     C     PRCCDE        IFNE      *ZEROS
     C     PRCCDE        IFEQ      CMPRCD
     C                   MOVE      *ON           *IN75
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      * Check Price Code Range
     C     LPCFR         IFNE      *ZEROS
     C     CMPRCD        IFGE      LPCFR
     C     CMPRCD        IFLE      LPCTO
     C                   MOVE      *ON           *IN75
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ********
      * CHECK CUSTOMER TYPE SUBROUTINE
      ********
      *
     C     CHKCT         BEGSR
     C                   DO        10            II                2 0
     C                   MOVEL     CT(II)        CSTTYP            2
     C     CSTTYP        IFNE      *BLANKS
     C     CSTTYP        IFEQ      SHCUTP
     C                   MOVE      *ON           *IN76
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      *
      * CHECK CUSTOMER TYPE RANGE
     C     LCTFR         IFNE      *BLANKS
     C     SHCUTP        IFNE      *BLANKS
     C     SHCUTP        IFGE      LCTFR
     C     SHCUTP        IFLE      LCTTO
     C                   MOVE      *ON           *IN76
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *
     OSAR375    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           50 'Sales Analysis By'
     O                                           72 'Customer - Top Ranked'
     O                                           87 'By Sales Units'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           23 '# of Customers to Rank:'
     O               88      LRANK         Z     30
     O              N88                          30 'ALL'
     O                                           50 'For Period:'
     O                       LMONTH              53
     O                                           59 'From:'
     O                       BEGDAT        Y     68
     O                                           72 'To:'
     O                       ENDDAT        Y     81
     O          E            HDG            1
     O                                           48 '--------'
     O                                           65 'SALES DOLLARS'
     O                                           77 '--------'
     O                                           95 '-----------'
     O                                          107 'QUANTITIES'
     O                                          120 '----------'
     O          E            HDG            1
     O                                           49 'Current'
     O                                           64 'Current'
     O                                           77 'Last'
     O                                           92 'Current'
     O                                          106 'Current'
     O                                          120 'Last'
     O          E            HDG            0
     O                                            8 'Customer'
     O                                           47 'Month'
     O                                           61 'YTD'
     O                                           77 'Year'
     O                                           91 'Month'
     O                                          105 'YTD'
     O                                          120 'Year'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       SHCUST        Z      6
     O                       CMNAME              37
     O                       PYTDQ         KB   120
     O                       CYTDQ         KB   107
     O                       CQTY          KB    92
     O                       PYTDS         KB    78
     O                       CYTDS         KB    64
     O                       CS$(P)        KB    49
     O          E            TLR1           1
     O                                          119 '----------'
     O                                          106 '----------'
     O                                           91 '----------'
     O                                           77 '-----------'
     O                                           63 '-----------'
     O                                           48 '----------'
     O          E            TLR1           1
     O                                           27 'Totals - Customers'
     O                                           35 'Listed:'
     O                       CPYTDQ        K    120
     O                       CCYTDQ        K    107
     O                       CCYCPQ        K     92
     O                       CPYTDS        K     78
     O                       CCYTDS        K     64
     O                       CCYCPS        K     49
     O          E            TLR            1
     O              N77                         119 '----------'
     O              N77                         106 '----------'
     O              N77                          91 '----------'
     O              N77                          77 '-----------'
     O              N77                          63 '-----------'
     O              N77                          48 '----------'
     O               77                         119 '=========-'
     O               77                         106 '=========='
     O               77                          91 '=========='
     O               77                          77 '==========='
     O               77                          63 '==========='
     O               77                          48 '=========='
     O          E            TLR            2
     O               77                          35 'Company Totals:'
     O              N77                          35 'Report Totals:'
     O                       RPYTDQ        K    120
     O                       RCYTDQ        K    107
     O                       RCYCPQ        K     92
     O                       RPYTDS        K     78
     O                       RCYTDS        K     64
     O                       RCYCPS        K     49
     O          E            TLR77          1
     O                                           24 '% of Ranked Customers'
     O                                           35 'to Totals:'
     O                       PERCPS        K     49
     O                       PERCYS        K     64
     O                       PERPPS        K     78
     O                       PERCPQ        K     92
     O                       PERCYQ        K    107
     O                       PERPPQ        K    120
