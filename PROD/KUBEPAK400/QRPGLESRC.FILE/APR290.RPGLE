      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR290
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- COMPANY A/P SUMMARY BALANCE
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FAPR290FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFAPOPN    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
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
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           VCO               2 0
      *
     C     RSTRTA        TAG
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     0             APCURR
     C                   Z-ADD     0             APPAST
     C                   Z-ADD     0             APFUT
     C                   Z-ADD     0             TOTAL
     C                   Z-ADD     0             APAGE1
     C                   Z-ADD     0             APAGE2
     C                   Z-ADD     0             APAGE3
     C                   Z-ADD     0             APAGE4
     C                   Z-ADD     0             APAGE5
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1020
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             6 0
      *
     C     LCO           CHAIN     FAPCTL                             90
     C   90              SETON                                        10
     C   10              GOTO      NXTA
     C                   Z-ADD     AZAGPY        SVAGDY            3 0
     C                   Z-ADD     AZAGP2        SVAGD2            3 0
     C                   Z-ADD     AZAGP3        SVAGD3            3 0
     C                   Z-ADD     AZAGP4        SVAGD4            3 0
      *
     C                   EXSR      AGDATS
     C                   EXSR      SUMRY
      *
     C     LCO           CHAIN     FMCORG                             90
      *
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      ***********
      * AGDATS  *
      ***********
      * FIRST AGING BUCKET
     C     AGDATS        BEGSR
     C                   Z-ADD     RDATE         ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD1            6 0
     C     RDATE         ADD       SVAGDY        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD5            6 0
      * SECOND AGING BUCKET
     C     RDATE         ADD       SVAGDY        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD2            6 0
     C     RDATE         ADD       SVAGD2        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD6            6 0
      * THIRD AGING BUCKET
     C     RDATE         ADD       SVAGD2        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD3            6 0
     C     RDATE         ADD       SVAGD3        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD7            6 0
      * FOURTH AGING BUCKET
     C     RDATE         ADD       SVAGD3        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD4            6 0
     C     RDATE         ADD       SVAGD4        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVASD8            6 0
     C                   Z-ADD     ##MDY         SVASD9            6 0
     C                   ENDSR
      ***********
      * SUMRY   *
      ***********
     C     SUMRY         BEGSR
     C                   Z-ADD     0             APVEND
     C                   Z-ADD     0             APVOUC
     C                   MOVE      *BLANKS       APINV#
     C                   Z-ADD     0             APSEQ#
     C                   MOVE      *BLANKS       APITYP
     C     APKEY         KLIST
     C                   KFLD                    APVEND
     C                   KFLD                    VCO
     C                   KFLD                    APVOUC
     C                   KFLD                    APINV#
     C                   KFLD                    APSEQ#
     C                   KFLD                    APITYP
     C     APKEY         SETLL     FAPOPN
     C     AGAIN         TAG                                                    READ AGAIN
     C                   SETOFF                                       92
      *
     C                   READ      FAPOPN                                 92
     C   92              GOTO      ENDA
      *
     C     APCOMP        IFNE      VCO                                                      #
     C                   GOTO      AGAIN
     C                   ENDIF
      *
     C     APDUE$        IFEQ      0                                                        #
     C                   GOTO      AGAIN
     C                   ENDIF
      *
     C     APSTAT        IFEQ      'D'                                                      #
     C                   GOTO      AGAIN
     C                   ENDIF
      *
     C                   EXSR      AGING
     C                   GOTO      AGAIN
      *
     C     ENDA          ENDSR
      *
      ***********
      * AGING   *
      ***********
     C     AGING         BEGSR
     C                   SETOFF                                       181920
     C                   SETOFF                                       2122
     C                   Z-ADD     APDUDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SVDUDT            5 0             DUE DATE
     C     SVDUDT        SUB       RDATE         RESULT            5 0                      OF
     C     RESULT        IFLT      0                                                        OF
     C                   ADD       APDUE$        APPAST
     C                   ADD       1             CNT7              5 0
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFEQ      0                                                        OF
     C                   ADD       APDUE$        APCURR
     C                   ADD       1             CNT8              5 0
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      0                                                        OF
     C     RESULT        ANDLE     AZAGPY                                                   OF
     C                   ADD       APDUE$        APAGE1           12 2
     C                   ADD       APDUE$        APFUT            12 2
     C                   ADD       1             CNT1              5 0
     C                   ADD       1             CNT9              5 0
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      AZAGPY                                                   OF
     C     RESULT        ANDLE     AZAGP2                                                   OF
     C                   ADD       APDUE$        APAGE2           12 2
     C                   ADD       APDUE$        APFUT
     C                   ADD       1             CNT2              5 0
     C                   ADD       1             CNT9              5 0
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      AZAGP2                                                   OF
     C     RESULT        ANDLE     AZAGP3                                                   OF
     C                   ADD       APDUE$        APAGE3           12 2
     C                   ADD       APDUE$        APFUT
     C                   ADD       1             CNT3              5 0
     C                   ADD       1             CNT9              5 0
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      AZAGP3                                                   OF
     C     RESULT        ANDLE     AZAGP4                                                   OF
     C                   ADD       APDUE$        APAGE4           12 2
     C                   ADD       APDUE$        APFUT
     C                   ADD       1             CNT4              5 0
     C                   ADD       1             CNT9              5 0
     C                   GOTO      EAGE
     C                   ENDIF
     C                   ADD       APDUE$        APAGE5           12 2
     C                   ADD       APDUE$        APFUT
     C                   ADD       1             CNT5              5 0
     C                   ADD       1             CNT9              5 0
     C     EAGE          TAG
      *
     C                   ADD       APDUE$        TOTAL            12 2          TOTAL A/P
     C                   ADD       1             CNT6              5 0
      *
     C                   ENDSR
      *
