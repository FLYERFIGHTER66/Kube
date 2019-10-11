      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR370
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- S/A BY TOP RANKED CUSTOMERS DOLLARS
      *
      *
      *
      *
      *
     FFSHISTST  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR370    O    F  132        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      *
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
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LRANK                  6     11  0
     D  EMONTH                12     13  0
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
     D  PC                   172    191
     D                                     DIM(10)
     D  LPC01                172    173
     D  LPC02                174    175
     D  LPC03                176    177
     D  LPC04                178    179
     D  LPC05                180    181
     D  LPC06                182    183
     D  LPC07                184    185
     D  LPC08                186    187
     D  LPC09                188    189
     D  LPC10                190    191
     D  LPCFR                192    193
     D  LPCTO                194    195
     D  CT                   196    215
     D                                     DIM(10)
     D  LCT01                196    197
     D  LCT02                198    199
     D  LCT03                200    201
     D  LCT04                202    203
     D  LCT05                204    205
     D  LCT06                206    207
     D  LCT07                208    209
     D  LCT08                210    211
     D  LCT09                212    213
     D  LCT10                214    215
     D  LCTFR                216    217
     D  LCTTO                218    219
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
     C                   Z-ADD     EMONTH        P                 2 0
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
     C                   Z-ADD     EMONTH        ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGD              6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCY              7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FSHISTST                               90
      *
     C   90              GOTO      END
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
     C                   Z-ADD     SHCSTL        CURR$            10 2
     C                   ADD       SHCSTL        RCYCPS           10 2
     C  N77              ADD       SHCSTL        CCYCPS           10 2
      *
     C                   Z-ADD     SHPSTL        LAST$            10 2
     C                   ADD       SHPSTL        RLYCPS           10 2
     C  N77              ADD       SHPSTL        CLYCPS           10 2
      *
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        CYTDS             9 2
     C  N77              ADD       CS$(X)        CCYTDS           10 2
     C                   ADD       CS$(X)        RCYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C     CYTDS         IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
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
     C     CLYCPS        IFGT      0
     C     CLYCPS        DIV       RLYCPS        CPSPER            5 4
     C     CPSPER        MULT      100           PERLPS            5 2
     C                   ENDIF
     C     CCYTDS        IFGT      0
     C     CCYTDS        DIV       RCYTDS        CYSPER            5 4
     C     CYSPER        MULT      100           PERCYS            5 2
     C                   ENDIF
     C     CPYTDS        IFGT      0
     C     CPYTDS        DIV       RPYTDS        PPSPER            5 4
     C     PPSPER        MULT      100           PERPPS            5 2
     C                   ENDIF
     C                   ENDSR
      *
      ********
      * CHECK PRODUCT CATAGORY SUBROUTINE
      ********
      *
     C     CHKPC         BEGSR
     C                   DO        10            II                2 0
     C                   MOVEL     PC(II)        PRCCDE            2
     C     PRCCDE        IFNE      *BLANKS
     C     PRCCDE        IFEQ      SHPCL1
     C                   MOVE      *ON           *IN75
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      * CHECK PRODUCT CATAGORY  RANGE
     C     LPCFR         IFNE      *BLANKS
     C     SHPCL1        IFNE      *BLANKS
     C     SHPCL1        IFGE      LPCFR
     C     SHPCL1        IFLE      LPCTO
     C                   MOVE      *ON           *IN75
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
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
     OSAR370    E            HDG            1 03
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
     O                                           58 'Sales Analysis - Top'
     O                                           82 'Ranked By Sales Dollars'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           23 '# of Customers to Rank:'
     O               88      LRANK         Z     30
     O              N88                          30 'ALL'
     O                                           52 'For Period:'
     O                       LMONTH        4     55
     O                                           57 '-'
     O                       EMONTH        4     59
     O                       BEGDAT        Y     68
     O                                           70 '-'
     O                       ENDDAT        Y     79
     O          E            HDG            1
     O                                           64 '-----Current Year-----'
     O                                           91 '------Last Year------'
     O          E            HDG            1
     O                                           50 'Selected'
     O                                           64 'Year to'
     O                                           78 'Selected'
     O                                           91 'Year to'
     O          E            HDG            0
     O                                           15 'Customer'
     O                                           49 'Period'
     O                                           62 'Date'
     O                                           77 'Period'
     O                                           90 'Date'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O**                                120 '________________________'
     O          EF           DETL           1
     O                       SHCUST        Z      6
     O                       CMNAME              37
     O                       CURR$         KB    51
     O                       CYTDS         KB    65
     O                       LAST$         KB    79
     O                       PYTDS         KB    93
     O          E            TLR1           1
     O                                           92 '----------'
     O                                           78 '-----------'
     O                                           64 '-----------'
     O                                           50 '----------'
     O          E            TLR1           1
     O                                           20 'Totals - Customers'
     O                                           28 'Listed:'
     O                       CPYTDS        K     93
     O                       CLYCPS        K     79
     O                       CCYTDS        K     65
     O                       CCYCPS        K     50
     O          E            TLR            1
     O                                           92 '=========='
     O                                           78 '==========='
     O                                           64 '==========='
     O                                           50 '=========='
     O          E            TLR            1
     O               77                          35 'Company Totals:'
     O              N77                          35 'Report Totals:'
     O                       RPYTDS        K     93
     O                       RLYCPS        K     79
     O                       RCYTDS        K     65
     O                       RCYCPS        K     50
     O          E            TLR77          1
     O                                           24 '% of Ranked Customers'
     O                                           35 'to Totals:'
     O                       PERCPS        K     49
     O                       PERCYS        K     64
     O                       PERLPS        K     79
     O                       PERPPS        K     93
