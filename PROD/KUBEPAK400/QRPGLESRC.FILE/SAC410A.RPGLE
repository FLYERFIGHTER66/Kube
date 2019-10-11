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
      *PROGRAM NAME-------- SAC410A
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY PRODUCT CLASS SUMMARY
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/08/01 EFD SET UP PARMS FOR AUTO RUN
      *
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
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
     C                   Z-ADD     01            LCO
     C                   Z-ADD     1             LDOLUN
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     '*NO'         LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   MOVE      *BLANKS       LCANCL
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      * GET YESTERDAY, NIGHT RUNS AT 1:00 AM
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   SUB       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TRNDAT
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     0             ACTPER            2 0
     C                   Z-ADD     0             BEGDAT            6 0
     C                   Z-ADD     0             ENDDAT            6 0
     C                   Z-ADD     0             BGCYMD            7 0
     C                   Z-ADD     0             ENCYMD            7 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C     ACTPER        IFLE      12
     C     ACTPER        ANDGE     1
     C                   Z-ADD     ACTPER        LMONTH
     C                   ELSE
     C                   MOVEL     'X'           LCANCL
     C                   END
      *
      *
     C     END           TAG
     C                   SETON                                        LR
      *
