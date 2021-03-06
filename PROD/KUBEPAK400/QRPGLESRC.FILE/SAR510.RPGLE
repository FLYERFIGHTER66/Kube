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
      *PROGRAM NAME-------- SAR510
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY ITEM/COMPARATIVE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSHISTSI  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR510    O    F  120        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LGRPRO                 6      6
     D  LDORP                  7      7
     D  LBPC                   8      9
     D  LEPC                  10     11
     D  LACTIV                12     12
     D  LPROG                 29     36
     D  LNAME                 37     66
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
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
     C     LACTIV        IFEQ      'Y'
     C                   SETON                                        22
     C                   END
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        24
     C                   ENDIF
      *
     C     LDORP         IFEQ      '$'
     C                   SETON                                        77
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C     LCO           CHAIN     FMAPER                             88
     C     ACMPCN        COMP      'M'                                525251
      *
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
     C                   READ      FSHISTSI                               90
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
     C     SHITEM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   24SHPCL1        IFLT      LBPC
     C     SHPCL1        ORGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C     KEY18         CHAIN     FMINVT                             90
      *
     C                   EXSR      GETDES
      *
      * CURRENT YTD QUANTITY
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        CYTDQ             8 0
     C                   ADD       CSQ(X)        RCYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * CURRENT YTD SALES
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        CYTDS             9 2
     C                   ADD       CS$(X)        RCYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * PRIOR YTD QUANTITY
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        PYTDQ             8 0
     C                   ADD       PSQ(X)        RPYTDQ            9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * PRIOR YTD SALES
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        PYTDS             9 2
     C                   ADD       PS$(X)        RPYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   22PYTDQ         IFEQ      0
     C     CYTDQ         ANDEQ     0
     C     PYTDS         ANDEQ     0
     C     CYTDS         ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
     C     CYTDS         SUB       PYTDS         DIF$              9 2
     C                   ADD       DIF$          DIF$LR           10 2
     C     CYTDQ         SUB       PYTDQ         DIFQ              8 0
     C                   ADD       DIFQ          DIFQLR            9 0
      *
     C   77              GOTO      NOPER
     C     CYTDS         IFGT      0
     C     PYTDS         ANDGT     0
     C     DIF$          DIV       PYTDS         PER               6 4
     C     PER           MULT      100           PER$              6 2
     C                   ENDIF
     C     CYTDQ         IFGT      0
     C     PYTDQ         ANDGT     0
     C     DIFQ          DIV       PYTDQ         PER               6 4
     C     PER           MULT      100           PERQ              6 2
     C                   ENDIF
      *
     C     NOPER         TAG
      *
     C                   EXCEPT    DETL
     C                   SETOFF                                       10
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              GOTO      NOPLR
     C     RCYTDS        IFGT      0
     C     RPYTDS        ANDGT     0
     C     DIF$LR        DIV       RPYTDS        PERLR             6 4
     C     PERLR         MULT      100           PER$LR            6 2
     C                   ENDIF
     C     RCYTDQ        IFGT      0
     C     RPYTDQ        ANDGT     0
     C     DIFQLR        DIV       RPYTDQ        PERLR             6 4
     C     PERLR         MULT      100           PERQLR            6 2
     C                   ENDIF
     C     NOPLR         TAG
      *
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             30
     C     DESP          IFEQ      *BLANKS
     C                   SETON                                        77
     C                   ENDIF
     C                   ENDSR
      *
     OSAR510    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           67 'Comparative Sales Analys'
     O                                           77 'is By Item'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           53 'Thru Period:'
     O                       LMONTH              56
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O               24                          16 'Product Classes:'
     O               24      LBPC                19
     O               24                          21 '-'
     O               24      LEPC                24
     O          E            HDG            1
     O                                           58 '------'
     O                                           75 'SALES DOLLARS'
     O                                           85 '------'
     O                                           98 '---------'
     O                                          110 'QUANTITIES'
     O                                          120 '--------'
     O          E            HDG            1
     O                                           58 'Current'
     O                                           73 'Last'
     O               77                          83 '$'
     O              N77                          83 '%'
     O                                           99 'Current'
     O                                          109 'Last'
     O               77                         118 '$'
     O              N77                         118 '%'
     O          E            HDG            0
     O                                           15 'Item       Size'
     O                                           47 'YTD'
     O                                           64 'Year'
     O                                           77 'Diff'
     O                                           90 'YTD'
     O                                          106 'Year'
     O                                          120 'Diff'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       SHITEM              12
     O                       SHSIZE              15
     O                       DESP                46
     O               77      DIFQ          KB   120
     O              N77      PERQ          KB   120
     O                       PYTDQ         KB   110
     O                       CYTDQ         KB   100
     O               77      DIF$          KB    87
     O              N77      PER$          KB    87
     O                       PYTDS         KB    74
     O                       CYTDS         KB    59
     O          E            TLR            1
     O                                          109 '----------'
     O                                           86 '-----------'
     O                                           58 '----------'
     O          E            TLR            1
     O                                          119 '----------'
     O                                           99 '----------'
     O                                           73 '-----------'
     O          E            TLR            1
     O                                           33 'Report Totals:'
     O                       RPYTDQ        KB   110
     O               77      DIF$LR        KB    87
     O              N77      PER$LR        KB    87
     O                       RCYTDS        KB    59
     O          E            TLR            1
     O               77      DIFQLR        KB   120
     O              N77      PERQLR        KB   120
     O                       RCYTDQ        KB   100
     O                       RPYTDS        KB    74
