      *
      **PROGRAMMER---------- WJB
      **APPLICATION--------- MONTHLY LATE CHARGE CALCULATION SETUP
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSTATUS   IF   E           K DISK
      *
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
     D  LDATE                  1      6  0                                      ARC380
     D  FIRST                  7      7                                         ARC380
     D  LCANCL               133    133                                         ARC380
      ****************
      * START HERE   *
      ****************
      ** CHECK STATUS FILE
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVE      *BLANKS       FIRST
     C     STKEY         KLIST
     C                   KFLD                    STPROG
     C                   KFLD                    STCOMP
     C                   MOVEL     'QPKARLCM'    STPROG
     C                   Z-ADD     1             STCOMP
     C     STKEY         CHAIN     FSTATUS                            55
     C   55              DO
     C                   Z-ADD     TDATE         LDATE
     C                   GOTO      END
     C                   ENDDO                                                       55 DO
      ** SEE IF ALREADY RUN FOR TODAY
     C     STDATE        IFEQ      TDATE
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
      ** IF NOT RUN TODAY START WITH DAY AFTER LAST RUN DATE
     C                   Z-ADD     STDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ADD       1             ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         LDATE
      ** SEE IF FIRST OF MONTH
     C                   MOVEL     LDATE         MMDD              4 0
     C                   MOVE      MMDD          DD                2 0
     C     DD            IFEQ      01
     C                   MOVEL     'Y'           FIRST
     C                   END
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
