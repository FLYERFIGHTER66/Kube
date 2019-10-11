      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- QPK360
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY TOP RANKED CUSTOMER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/03/00 EFD ADD LOGIC FOR SEL CUST # AND TYPE RANGE
      *
     FFSHIDCI   IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFSACSUMD  IF   E           K DISK
     F                                     RENAME(RSACSUM:SACSUD)
     FFSACSUMI  IF   E           K DISK
     F                                     RENAME(RSACSUM:SACSUI)
     FFSACSUM   O  A E           K DISK
     FQPK360    O    F  132        PRINTER OFLIND(*INOF)
      *
      * MESSAGE array
     D MSG             S             50    DIM(2) CTDATA PERRCD(1)
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
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
     D  BEGPER                 3      4  0
     D  ENDPER                 5      6  0
     D  NUMCUS                 7     10  0
     D  BEGPC                 11     12
     D  ENDPC                 13     14
     D  RANK                  15     15  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     IRSHIST
      *
     I              SICS01                      CS$(1)
     I              SICS02                      CS$(2)
     I              SICS03                      CS$(3)
     I              SICS04                      CS$(4)
     I              SICS05                      CS$(5)
     I              SICS06                      CS$(6)
     I              SICS07                      CS$(7)
     I              SICS08                      CS$(8)
     I              SICS09                      CS$(9)
     I              SICS10                      CS$(10)
     I              SICS11                      CS$(11)
     I              SICS12                      CS$(12)
     I              SICS13                      CS$(13)
      *
     I              SILS01                      PS$(1)
     I              SILS02                      PS$(2)
     I              SILS03                      PS$(3)
     I              SILS04                      PS$(4)
     I              SILS05                      PS$(5)
     I              SILS06                      PS$(6)
     I              SILS07                      PS$(7)
     I              SILS08                      PS$(8)
     I              SILS09                      PS$(9)
     I              SILS10                      PS$(10)
     I              SILS11                      PS$(11)
     I              SILS12                      PS$(12)
     I              SILS13                      PS$(13)
      *
     I              SICQ01                      CSQ(1)
     I              SICQ02                      CSQ(2)
     I              SICQ03                      CSQ(3)
     I              SICQ04                      CSQ(4)
     I              SICQ05                      CSQ(5)
     I              SICQ06                      CSQ(6)
     I              SICQ07                      CSQ(7)
     I              SICQ08                      CSQ(8)
     I              SICQ09                      CSQ(9)
     I              SICQ10                      CSQ(10)
     I              SICQ11                      CSQ(11)
     I              SICQ12                      CSQ(12)
     I              SICQ13                      CSQ(13)
      *
     I              SILQ01                      PSQ(1)
     I              SILQ02                      PSQ(2)
     I              SILQ03                      PSQ(3)
     I              SILQ04                      PSQ(4)
     I              SILQ05                      PSQ(5)
     I              SILQ06                      PSQ(6)
     I              SILQ07                      PSQ(7)
     I              SILQ08                      PSQ(8)
     I              SILQ09                      PSQ(9)
     I              SILQ10                      PSQ(10)
     I              SILQ11                      PSQ(11)
     I              SILQ12                      PSQ(12)
     I              SILQ13                      PSQ(13)
      *
     C     NXTB          TAG
     C                   READ      FSHIDCI                                90
     C   90              GOTO      ENDB
     C     SICOMP        IFNE      LCO
     C     SICUST        ORLE      0
     C                   GOTO      NXTB
     C                   END
     C     SICUST        IFNE      FSCUST
     C     FSCUST        IFGT      0
     C                   WRITE     RSACSUM
     C                   END
     C                   CLEAR                   RSACSUM
     C                   Z-ADD     SICUST        FSCUST
     C                   END
      ** SEE IF SELECTED PRODUCT CLASS
     C     SIPCL1        IFGE      BEGPC
     C     SIPCL1        ANDLE     ENDPC
     C                   Z-ADD     B             X                 2 0
     C     X             DOUGT     E
     C                   ADD       CS$(X)        FSCUR$
     C                   ADD       PS$(X)        FSLST$
     C                   ADD       CSQ(X)        FSCURU
     C                   ADD       PSQ(X)        FSLSTU
     C                   ADD       1             X
     C                   ENDDO
     C                   END
     C                   GOTO      NXTB
     C     ENDB          TAG
     C     FSCUST        IFGT      0
     C                   WRITE     RSACSUM
     C                   END
      ** NOW PRINT REPORT
     C                   Z-ADD     9999999       FSCUR$
     C                   Z-ADD     999999999     FSCURU
     C     FSCUR$        SETLL     FSACSUMD
     C     FSCURU        SETLL     FSACSUMI
     C     NXT           TAG
     C     RANK          IFEQ      1
     C                   READ      FSACSUMD                               91
     C                   ELSE
     C                   READ      FSACSUMI                               91
     C                   END
     C     FSCUST        CHAIN     FMCUST                             70
     C   70              GOTO      NXT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   END
     C                   ADD       1             NUMB              5 0
     C                   EXCEPT    DETL
     C     NUMB          IFLT      NUMCUS
     C                   GOTO      NXT
     C                   END
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     BEGPER        B                 2 0
     C                   Z-ADD     ENDPER        E                 2 0
     C                   Z-ADD     RANK          R                 2 0
     C     LCO           CHAIN     FMCORG                             90
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OQPK360    E            HEAD           1 03
     O                                            6 'QPK360'
     O                                           20 'Requested by:'
     O                       USERID              31
     O                       RGNAME              60
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           1
     O                       TDATE         Y      8
     O                       MSG(R)              65
     O                       TIMOD               85 '  :  :  '
     O          E            HEAD           2
     O                                           20 'Number of Customers:'
     O                       NUMCUS        4     25
     O                                           40 'For Period:'
     O                       BEGPER        4     43
     O                                           47 'To:'
     O                       ENDPER        4     50
     O                                           62 'For P.C.:'
     O                       BEGPC               65
     O                                           69 'To:'
     O                       ENDPC               72
     O          E            HEAD           1
     O                                           69 '-------Dollars--------'
     O                                           85 '---Quantity---'
     O          E            HEAD           1
     O                                            5 'Rank'
     O                                           15 'Customer'
     O                                           56 'Curr Year'
     O                                           85 'Prior'
     O                                           78 'Curr'
     O                                           69 'Last Year'
     O          E            HEAD           2
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           85 '_____'
     O          EF           DETL           1
     O                       NUMB          4      6
     O                       CMCUST        4     13
     O                       CMNAME              44
     O                       FSCUR$        J     57
     O                       FSLSTU        J     85
     O                       FSCURU        J     78
     O                       FSLST$        J     70
**  HEADINGS
Sales Analysis by Customer - Top Ranked by Dollars
Sales Analysis by Customer - Top Ranked by Units
