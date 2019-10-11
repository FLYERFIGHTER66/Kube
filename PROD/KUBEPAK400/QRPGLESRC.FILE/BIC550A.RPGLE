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
      *PROGRAM NAME--------- BIC550A
      *APPLICATION---------- ORDER ENTRY
      *DESCRIPTION---------- DAILY BILLING POST
      *                      AUTO LOAD PROMPTS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
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
     D  LOKAY                  3      3
     D  LSLSJ                  4      4
     D  LSRCE                  5      7
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      ** THE FOLLOWING USED IN GLR70
      * COMPANY NUMBER
     D  GLCO                 201    202  0                                      ARC380
      * POST G/L Y/N
     D  GLPST                203    203
      * PRINT REPORT Y/N (ONLY IF POST = N)
     D  PRTRPT               204    204
      * APPLICATION
     D  APPL                 205    207
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             VOUT              1 0
     C                   Z-ADD     01            LCO
     C                   Z-ADD     LCO           GLCO
     C                   MOVEL     'Y'           LSLSJ
     C                   MOVEL     'Y'           GLPST
     C                   MOVEL     'Y'           PRTRPT
     C                   MOVEL     'DOP'         LSRCE
     C                   MOVEL     'DOP'         APPL
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
      *
     C     END           TAG
     C                   SETON                                        LR
      *
