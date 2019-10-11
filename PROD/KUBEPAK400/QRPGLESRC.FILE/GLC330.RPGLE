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
      *PROGRAM NAME-------- GLC330
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- JOURNAL ENTRY POST PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 6/3/00 EFD01 ONLY DISPLAY SCREEN ON ERROR - DELETE PRINTER
      *
      *
     FFGLCTL    IF   E           K DISK
     FGLC330FM  CF   E             WORKSTN
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
      * VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FGLCTL                             90
     C  N90GZOKP         IFNE      'Y'
     C                   SETON                                        10
     C                   ENDIF
      *
     C     RSTRT         TAG
EFD01C   10              WRITE     SCRNA
EFD01C   10              READ      SCRNA                                  90
     C   KC
     COR 10
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR 10
     COR KG              GOTO      ENDP
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
