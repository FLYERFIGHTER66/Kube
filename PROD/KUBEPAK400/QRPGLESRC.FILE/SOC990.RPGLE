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
      *PROGRAM NAME--------- SOC990
      *APPLICATION---------- SHIPPED ORDER HISTORY
      *DESCRIPTION---------- PURGE RECORDS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/20/00 EFD USE F8 INSTEAD OF F20 FOR BILL
      *
     FSOC990FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D  LDATE                  3      8  0
     D  LPDATE                 9     15  0
     D  LOKAY                 16     16
     D  LFILE                 17     26
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##CYMD        SUB       10000         TSTDAT            7 0
      *
     C                   Z-ADD     0             LDATE
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1011
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C                   Z-ADD     LDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        LPDATE
     C     LPDATE        IFGT      TSTDAT
     C                   SETOFF                                       98
     C                   SETON                                        1011
     C                   Z-ADD     0             LPDATE
     C                   GOTO      RSTRT
     C                   END
      *
     C     LDATE         IFNE      OLDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LDATE         OLDATE            6 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98              GOTO      RSTRT
     C                   ENDIF
      ** GET FILE NAME
     C                   MOVE      *BLANKS       LFILE
     C                   MOVEL     'FSOH'        LFILE
     C                   MOVE      LDATE         LFILE
      *
     C   KH              DO
     C                   MOVE      'Y'           LOKAY
     C                   GOTO      END
     C                   ENDDO
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
