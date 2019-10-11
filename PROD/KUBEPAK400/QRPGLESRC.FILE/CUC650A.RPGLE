      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      *PROGRAM NAME--------- CUC65A
      *APPLICATION---------- CUTTING REQUIREMENTS
CAB   *DESCRIPTION---------- CUT TRAY CHANGE REPORT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCALEN    IF   E           K DISK
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
      ** COMPANY NUMBER
     D  LCO                    1      2  0
      ** BEGIN READY DATE
     D  BEGDAT                 3      8  0                                      ARC380
      ** END READY DATE
     D  ENDDAT                 9     14  0                                      ARC380
      ** BEGIN READY DATE CYMD
     D  BEGCYM                15     21  0
      ** ENDING READY DATE CYMD
     D  ENDCYM                22     28  0
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
     C     RSTART        TAG
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     1             LCOPY
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
      *
     C     END           TAG
     C                   SETON                                        LR
      **
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET YESTERDAYS DATE
     C     TDATE         CHAIN     FCALEN                             90
     C   90              MOVEL     'X'           LCANCL
     C                   Z-ADD     CLCYMD        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   SUB       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         BEGDAT
     C                   Z-ADD     ##MDY         ENDDAT
     C     BEGDAT        CHAIN     FCALEN                             90
     C   90              MOVEL     'X'           LCANCL
     C                   Z-ADD     CLCYMD        BEGCYM
     C                   Z-ADD     CLCYMD        ENDCYM
     C                   ENDSR
