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
      *PROGRAM NAME--------- APR450
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- UPDATE APDET WITH ACCTG PERIOD DATE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPDET    UF   E             DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FAPR450    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   Z-ADD     1             CNT               6 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C     NXT           TAG
     C                   READ      FAPDET                                 90
     C   90              GOTO      END
      *
     C     ADCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ADPERD        IFNE      99
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     ADAPER        TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        #P                2 0
      *
     C     #P            IFEQ      99
     C                   GOTO      NOUPD
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   MOVE      DNE(#P)       #Y                2 0
     C                   Z-ADD     DNE(#P)       ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        PEREND            7 0
      *
     C                   MOVE      #P            ADPERD
     C                   Z-ADD     TIMOD         ADTIME
     C                   MOVEL     USERID        ADUSER
     C                   Z-ADD     TDATE         ADDTLA
     C                   UPDATE    RAPDET
      *
     C                   GOTO      NXT
      *
     C     NOUPD         TAG
     C     CNT           IFEQ      1
     C                   EXCEPT    HDG
     C                   ENDIF
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C     ADCKDT        IFGT      0
     C                   SETON                                        89
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   ADD       1             CNT
     C                   SETON                                        77
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              EXCEPT    TLR
     C                   SETON                                        LR
      *
     OAPR450    E            HDG            1 03
     O                       PROGID              10                             GLR360
     O                       RGNAMC              75                             GLR360
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1                                   GLR360
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           71 'A/P Detail Date Update'
     O                       TIMOD              120 '  :  :  '                  GLR360
     O          E            HDG            2                                   GLR360
     O                                           70 'Records With Unidentifie'
     O                                           77 'd Dates'
     O          E            HDG            1                                   GLR360
     O                                           33 'Acctg'
     O          E            HDG            1                                   GLR360
     O                                            6 'Vendor'
     O                                           13 'Vouc'
     O                                           24 'Invoice #'
     O                                           33 'Date'
     O                                           50 'Description'
     O                                           72 'Check#'
     O                                           81 'Date'
     O                                           95 'Account'
     O                                          120 'Amount'
     O          E            HDG            1                                   GLR360
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1                                   GLR360
     O                       ADVEND        Z      6
     O                       ADVOUC        Z     13
     O                       ADINV#              24
     O                       ADAPER        Y     34
     O                       ADTDES              65
     O                       ADCHEK        Z     72
     O               89      ADCKDT        Y     81
     O                       ADGLA1              95 '  -    -    '
     O                       AD$AMT        JB   120
     O          E            TLR         2  1
     O                                           51 '**** The records printed'
     O                                           75 ' have an invalid account'
     O                                           99 'ing period date ****    '
      *
