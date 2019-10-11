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
      **PROGRAM NAME-------- NIGHTCHK
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SET-UP LDA FOR NIGHT PROCESS
      *
      *            CHANGE--DATE-------DESCRIPTION
      * CHANGE LOG:
      *
     FFSYSCTL   IF   E             DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** A/P INSTALLED Y/N
     D  ZZAP                   1      1
      ** G.L. INSTALLED Y/N
     D  ZZGL                   2      2
      ** A/R INSTALLED Y/N
     D  ZZAR                   3      3
      ** GROWER/DISTRIBUTOR  G/D
     D  ZZTYPE                 4      4
      ** S/A INSTALLED Y/N
     D  ZZSA                   5      5
      ** OE/BILLING INSTALLED Y/N
     D  ZZOE                   6      6
      ** INVENTORY INSTALLED Y/N
     D  ZZIC                   7      7
      ** B.O.M. INSTALLED Y/N
     D  ZZBOM                  8      8
      ** SERIALIZED INVENTORY INSTALLED Y/N
     D  ZZSI                   9      9
      ** PAYROLL INSTALLED Y/N
     D  ZZPY                  10     10
      ** SEED INSTALLED Y/N
     D  ZZSEED                11     11
      ** BAR CODE INSTALLED Y/N
     D  ZZBARC                12     12
      ** LOT CONTROL INSTALLED Y/N
     D  ZZLOT                 13     13
      ** SYTEM DATE MDY
     D  SDATE                 14     19  0
      ** SYTEM DATE CYMD
     D  SDTCYM                20     26  0
      ** SYTEM TIME AT BEGINING OF RUN
     D  STIME                 27     32  0
      ** DAY OF WEEK NUMBER 1=MONDAY
     D  SDAYW                 33     33  0
      ** DAY OF CENTURY
     D  SDDD                  34     38  0
      ** USE SIZE CODES Y/N
     D  ZZSIZE                39     39
      ** CUSTOMER MODS LIBRARY NAME
     D  ZZLIB                 40     49
      ** NOTE THE GAP IN POSITIONS TO MAKE COMMON
      ** CANCEL ' ' OR X
     D  CANCEL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C                   MOVE      *BLANKS       CANCEL
     C                   READ      FSYSCTL                                90
     C   90              DO
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C                   TIME                    STIME
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         SDATE
      * GET CYMD
     C                   Z-ADD     SDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        SDTCYM
      * GET DAY OF CENTURY
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SDDD
      *GET DAY OF WEEK
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C                   Z-ADD     #Y            SDAYW
      *
     C     END           TAG
     C                   SETON                                        LR
