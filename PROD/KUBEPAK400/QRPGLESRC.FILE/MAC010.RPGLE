    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

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
      *PROGRAM NAME-------- MAC010
      *SYSTEM-------------- ORDER ENTRY/BILLING
      *APPLICATION--------- PRINT BROKER INVOICE MANIFEST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMCUST    IF   E           K DISK
     FMAC010FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
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
      ****************
      *   LDA        *
      ****************
     D                UDS
      * COMPANY
     D  LCO                    1      2  0
      * REPRINT Y/N
     D  LDARPT                 3      3
      * BEGINING DATE
     D  BEGDAT                 5     10  0
      * ENDING DATE
     D  ENDDAT                11     16  0
      * BROKER NUMBER
     D  CUSTNO                17     22  0
      * PRINTER ID
     D  LPRTR                100    109
      * FORMS NUMBER
     D  LFORM                110    119
      * NUMBER OF COPIES
     D  LCOPY                120    121  0
      * JOB Q Y/N
     D  LJOBQ                122    122
      * HOLD PRINT OUTPUT
     D  LHOLD                123    126
      * PRINT AND SAVE OUTPUT
     D  LSAVE                127    130
      * CANCEL  X=CANCEL
     D  LCANCL               133    133
      *
     C     BEGIN         TAG
     C                   SETON                                        09
     C                   MOVEL     'N'           LDARPT
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     '*NAR'        LFORM
      *
     C     RSTRTA        TAG
     C                   Z-ADD     0             CNT               2 0
     C                   WRITE     SCRENA
     C                   READ      SCRENA                                 90
     C   KC
     COR KG              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO                                                  KC/KG DO
     C   KF              GOTO      BEGIN
     C                   SETOFF                                       101120
wjb  C                   SETOFF                                       202122
     C                   SETOFF                                       3031
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
      *
     C                   MOVEL     *BLANKS       LCANCL
      * CHECK BEG DATE
     C     BEGDAT        IFLE      0
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     BEGDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     ##CYMD        TESTBG            7 0
      *
      * CHECK END DATE
     C     ENDDAT        IFLE      0
     C                   SETON                                        2021
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     ENDDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2021
     C                   GOTO      RSTRTA
     C                   END
     C     TESTBG        IFGT      ##CYMD
     C                   SETON                                        1011
     C                   GOTO      RSTRTA
     C                   END
wjb  C                   If        $Date(##CYMD) >= $Date(0)
wjb  C                   SETON                                        2022
wjb  C                   GOTO      RSTRTA
wjb  C                   END
      * CHECK IF CUSTOMER ENTERED
     C     CUSTNO        IFGT      0
     C     CUSTNO        CHAIN     FMCUST                             30
     C   30              GOTO      RSTRTA
      ** CHECK IF BROKER
     C     CMCUST        IFNE      CMARCU
     C                   SETON                                        3031
     C                   GOTO      RSTRTA
     C                   ENDIF
     C                   END                                                    CISTNO > 0
      * CHECK IF CUSTOMER ALPHA ENTERED
     C     ALPHA         IFGT      *BLANKS
     C                   MOVEL     ALPHA         CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   Z-ADD     CMCUST        CUSTNO
     C                   GOTO      RSTRTA
     C                   END
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        52
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      RSTRTA
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
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C                   GOTO      END
      *
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   MOVEL     'XERPRT01'    LPRTR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      * GET BEGDATE
     C                   Z-ADD     TDATE         ENDDAT
      * GET LAST SATURDAY'S DATE
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
      ** GET TO FRIDAY
     C     #Y            IFNE      5
     C     #Y            SUB       5             #WRK              2 0
     C     6             ADD       #WRK          #NY               2 0
     C                   ELSE
     C                   Z-ADD     6             #NY
     C                   END
     C                   SUB       #NY           ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         BEGDAT
      **
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     0             CUSTNO
      *
     C                   ENDSR
      *
