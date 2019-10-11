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
      *PROGRAM NAME-------- ARC950
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- DELETE ITEMS IN A/R HISTORY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  WJB01 03/24/04 CHANGE LOGIC TO REQUIRE A DATE, AND FOR THE CUSTOMER
      *                 NUMBER TO OPTIONAL WITH THAT DATE.  THIS ENHANCES
      *                 THE FUNCTIONALITY OF THE PROGRAM TO ALLOW A SPECIFIC
      *                 CUSTOMER'S ACCOUNT TO BE CLEARED PRIOR TO A CERTAIN
      *                 DATE.  ALSO ADDED WARNING WHEN PROCESSING WITHOUT
      *                 SPECIFYING AN ACCOUNT NUMBER TO LET USER KNOW THAT
      *                 ALL ACCOUNTS WILL BE CLEARED PRIOR TO GIVEN
      *                 DATE.  PROGRAM ARR950 WILL ALSO BE CHANGED TO
      *                 ACCOMPLISH THIS MODIFICATION.
      *
     FARC950FM  CF   E             WORKSTN
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
     D  LDATE                  3      8  0
     D  LCUST                  9     14  0
     D  LPRINT                15     15
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         CDATE             5 0
      *
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             LDATE
     C                   Z-ADD     0             LCUST
     C                   MOVEL     'N'           LPRINT
      *
     C     CHG           TAG
WJB01C                   Z-ADD     *ZERO         FIRST
WJB01C                   Z-ADD     *ZERO         ODATE             6 0
WJB01C                   Z-ADD     *ZERO         OCUST             6 0
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       132030
WJB01C                   SETOFF                                       28
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
WJB01C     *IN28         IFEQ      *ON
WJB01C                   Z-ADD     *ZERO         FIRST
WJB01C                   ENDIF
      *
     C   KD              DO
     C                   Z-ADD     0             CMCUST            6 0
     C*          CMCUST    CHAINFMCUST               90
     C                   MOVEL     *BLANKS       CMLOOK           15
     C                   MOVEL     'A'           CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME           30
     C                   Z-ADD     CMCUST        LCUST
     C                   GOTO      NXT
     C                   ENDDO
      *
WJB01C*          LDATE     IFEQ 0
WJB01C*                    GOTO NODATE
WJB01C*                    ENDIF
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXT
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
     C                   ADD       1             FIRST             2 0
     C     FIRST         IFEQ      1
     C     RDATE         ANDGT     CDATE
     C                   SETON                                        1012
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LDATE         IFNE      ODATE
WJB01C     LCUST         ORNE      OCUST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LDATE         ODATE             6 0
WJB01C                   Z-ADD     LCUST         OCUST
      *
     C     NODATE        TAG
      *
WJB01C                   SETOFF                                       99
WJB01C     LCUST         IFEQ      0
WJB01C                   SETON                                        99
WJB01C                   ENDIF
      *
WJB01C*          LDATE     IFEQ 0                                      Q
WJB01C*          LCUST     ANDEQ0
WJB01C*                    SETON                     1013
WJB01C*                    GOTO NXT
WJB01C*                    ENDIF
      *
WJB01C*          LDATE     IFGT 0                                      Q
WJB01C*          LCUST     ANDGT0
WJB01C*                    SETON                     20
WJB01C*                    GOTO NXT
WJB01C*                    ENDIF
      *
     C     LPRINT        IFNE      'Y'                                                      Q
     C     LPRINT        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNT           IFGT      0
WJB01C*                    SETON                     98
WJB01C  N99              SETON                                        98
     C                   Z-ADD     0             CNT
WJB01C   99
WJB01C*  98                GOTO NXT
WJB01COR 98              GOTO      NXT
     C                   ENDIF
      *
     C   99
WJB01CANN01              GOTO      NXT
WJB01C   28              GOTO      CHG
      *
     C     LPRINT        IFEQ      'N'                                                      Q
     C                   MOVEL     '*NO'         LSAVE
     C                   MOVEL     '*NO'         LHOLD
     C                   GOTO      ENDP
     C                   ENDIF
      *
     C                   SETOFF                                       9899
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM             4
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
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
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   Z-ADD     0             CNT
     C   98              GOTO      NXTB
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
