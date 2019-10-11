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
      *PROGRAM NAME-------- GLC370
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- RECURRING JOURNAL ENTRY POST PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FGLC370FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMAPER    IF   E           K DISK
     FFGLCTL    IF   E           K DISK
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
     D  LACTP                  3      4  0
     D  LBDATE                 5     10  0
     D  LEDATE                11     16  0
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
     C     LCO           CHAIN     FGLCTL                             90
     C  N90GZOKRE        IFNE      'Y'
     C                   SETON                                        20
     C                   ENDIF
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       105051
     C                   SETOFF                                       525354
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR 20
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR 20
     COR KG              GOTO      ENDP
      *
     C   KB              DO
     C                   Z-ADD     LCO           ACCOMP            2 0
     C                   CALL      'LKACTP'
     C                   PARM                    ACCOMP
     C                   PARM                    VACTP
     C                   GOTO      RSTRT
     C                   ENDDO
      *
     C                   Z-ADD     VACTP         LACTP
      *
     C     VACTP         IFEQ      *ZEROS                                                   K
     C     VACTP         ORGT      13                                                       K
     C                   SETON                                        10
     C   10              GOTO      RSTRT
     C                   ENDIF
      *
     C     LCO           CHAIN     FMAPER                             90
     C     BEG(13)       IFEQ      *ZEROS                                                   K
     C     VACTP         ANDEQ     13                                                       K
     C                   SETON                                        10
     C   10              GOTO      RSTRT
     C                   ENDIF
      *
     C                   Z-ADD     VACTP         X                 2 0
     C                   Z-ADD     BEG(X)        LBDATE
     C                   Z-ADD     DNE(X)        LEDATE
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
