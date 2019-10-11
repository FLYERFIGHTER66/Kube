      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR252
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- UNCONFIRMED OPEN ORDERS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FBIR252FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFHORRQS   IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
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
      *
     D  OISEQ#         S              3P 0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DESHFR        VSHFR
      *
      *  MAIN FLOW OF PROGRAM
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       5055
     C                   MOVEL     'N'           VINCL
     C                   Z-ADD     TDATE         VDATE
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102030
     C                   SETOFF                                       5055
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      EOJ
      *
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
      *
     C     1             SUBST     VSHFR:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VSHFR         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VSHFR
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        20
     C   20              GOTO      NXTA
     C                   SETON                                        21
     C                   ENDIF
      *
     C     VSHFR         IFEQ      *BLANKS
     C                   MOVEL     'ALL'         WHDESC
     C                   ENDIF
      *
     C     VINCL         IFNE      'Y'
     C     VINCL         ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VINCL         IFEQ      'Y'
     C                   SETON                                        50
     C                   ENDIF
     C     VINCL         IFEQ      'N'
     C                   SETON                                        55
     C                   ENDIF
      *
      * SET FHORDR BACK TO BEGINING OF DATE
      *
     C     RELOAD        TAG
     C   50              Z-ADD     0             DDATE             6 0
     C   55              Z-ADD     VDATE         DDATE             6 0
     C                   MOVEL     'A'           STAT              1
     C     HKEY          KLIST
     C                   KFLD                    STAT
     C                   KFLD                    DDATE
     C     HKEY          SETLL     FHORRQS
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTI          TAG
     C                   SETOFF                                       9077
     C   55HKEY          READE     FHORRQS                                90
     C   50              READ      FHORRQS                                90
     C   90              GOTO      DSPL
     C                   IF        OHCUST > 990000
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OHSTAT        IFEQ      'D'
     C                   GOTO      DSPL
     C                   ENDIF
      *
     C     OHCOMP        IFNE      LCO
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   21VSHFR         IFNE      OHSHFR
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OHHOLD        IFEQ      'R'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C   55OHDTRQ        IFNE      VDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OHDTAC        IFGT      0
     C                   MOVEL     'B/O'         BO
     C                   ELSE
     C                   MOVEL     *BLANKS       BO
     C                   ENDIF
      *
     C   50              Z-ADD     OHDTRQ        ##MDY
     C   50              CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
     C   50              CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C   50              Z-ADD     ##DDD         HDATE             5 0
      *
     C   50HDATE         IFGT      BDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             OHORD#
     C                   Z-ADD     0             OHDTOR
     C                   Z-ADD     0             OHCUST
     C                   Z-ADD     0             OHDTRQ
     C                   MOVEL     *BLANKS       OHNAME
     C                   MOVEL     *BLANKS       OHSHPC
     C                   MOVE      *BLANKS       BO
     C                   MOVE      *BLANKS       OHPOS
     C                   MOVEL     '* End of'    DESC1            16
     C                   MOVE      ' Data * '    DESC1
     C                   MOVEL     DESC1         OHNAME
     C                   WRITE     RECSFL
     C     DSPSFL        TAG
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      EOJ
     C   KE              GOTO      RELOAD
     C   KK              DO
     C                   If        SFLCSRRRN = 0
     C                   Eval      SFLCSRRRN = 1
     C                   EndIf
     C     SFLCSRRRN     Chain     RECSFL
     C                   call      'BIR100CLO'
     C                   Parm                    OHORD#
     C                   Parm      0             OISEQ#
     C                   GOTO      DSPSFL
     C                   ENDDO
     C                   GOTO      RSTRTA
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            30
     C                   ENDSR
      *
