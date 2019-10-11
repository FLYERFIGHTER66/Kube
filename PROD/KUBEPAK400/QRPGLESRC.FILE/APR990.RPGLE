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
      **PROGRAM NAME-------- APR990
      **SYSTEM-------------- ACCOUNTS PAYABLE
      **APPLICATION--------- MONTH END PROCESS
      **DESCRIPTION-         SELECTS RECORDS TO BE PURGED FROM THE
      **                     APDET AND APMTH FILES.
      **                     OPTIONALLY PRINTS A REPORT OF FILE
      **                     STATUS.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPDET    UF   E           K DISK
     F                                     RENAME(RAPDET:APDETI)
     FFAPDETO   O  A E           K DISK
     FFAPMTH    UF   E           K DISK
     F                                     RENAME(RAPMTH:APMTHI)
     FFAPMTHO   O  A E           K DISK
     FFAPOPN    UF   E           K DISK
     F                                     RENAME(RAPOPN:APOPNI)
     FFAPOPNVE  IF   E           K DISK
     F                                     RENAME(RAPOPN:APOPNVE)
     FFAPOPNO   O  A E           K DISK
     FFAPDTP    UF   E           K DISK
     F                                     RENAME(RAPDTP:APDTPI)
     FFAPDTPO   O  A E           K DISK
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
     D  LCO                    1      2  0
      *  PERIOD SELECTION
     D  LDAPER                 3      4  0
      *  SELECTED PERIOD START DATE
     D  LDABEG                10     15  0
      *  SELECTED PERIOD END DATE
     D  LDAEND                16     21  0
     D  LRPT                  23     23
     D  LPURGE                24     24
     D  LOPNDT                25     30  0
     D  LDTPDT                31     36  0
     D  LAPDET                43     51
     D  LAPMTH                52     60
     D  LAPOPN                61     69
     D  LAPDTP                70     78
     D  LLIBR                 88     97
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
      * APDET FILE
      *
     C     NXTD          TAG
     C                   READ      FAPDET                                 90
     C   90              GOTO      ENDD
      *
     C     ADCOMP        IFNE      LCO
     C                   GOTO      NXTD
     C                   ENDIF
     C     ADSTAT        IFEQ      'X'
     C                   GOTO      NXTD
     C                   ENDIF
      * CHECK IF IN DATE RANGE TO PURGE
     C                   Z-ADD     ADAPER        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      NXTD
     C                   ENDIF
     C     ##CYMD        IFLE      WRKDAT
     C                   WRITE     RAPDET
     C                   MOVEL     'X'           ADSTAT
     C                   UPDATE    APDETI
     C                   END
     C                   GOTO      NXTD
     C     ENDD          TAG
      *
      * APMTH FILE
      *
     C     NXTM          TAG
     C                   READ      FAPMTH                                 90
     C   90              GOTO      ENDM
      *
     C     AMCOMP        IFNE      LCO
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     AMSTAT        IFEQ      'X'
     C                   GOTO      NXTM
     C                   END
      *
      * CHECK IF IN DATE RANGE TO PURGE
     C                   Z-ADD     AMPEDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      NXTM
     C                   ENDIF
     C     ##CYMD        IFLE      WRKDAT
     C                   WRITE     RAPMTH
     C                   MOVEL     'X'           AMSTAT
     C                   UPDATE    APMTHI
     C                   END
     C                   GOTO      NXTM
     C     ENDM          TAG
      *
      ** CHECK IF PURGE OF APOPN NEEDED
      *
     C     LOPNDT        IFGT      0
     C                   Z-ADD     LOPNDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      ENDO
     C                   END
     C                   Z-ADD     ##CYMD        OPNDAT            7 0
     C                   ELSE
     C                   GOTO      ENDO
     C                   END
     C     NXTO          TAG
     C                   READ      FAPOPN                                 90
     C   90              GOTO      ENDO
     C     APCLCD        IFNE      'Y'
     C*          APSTAT    OREQ 'X'
     C                   GOTO      NXTO
     C                   END
     C                   Z-ADD     APTDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      NXTO
     C                   END
     C     ##CYMD        IFLE      OPNDAT
     C                   WRITE     RAPOPN
     C                   MOVEL     'X'           APSTAT
     C                   UPDATE    APOPNI
     C                   END
     C                   GOTO      NXTO
     C     ENDO          TAG
      *
      *
      ** CHECK IF PURGE OF APDTP NEEDED
      *
     C     LDTPDT        IFGT      0
     C                   Z-ADD     LDTPDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   GOTO      ENDP
     C                   END
     C                   Z-ADD     ##CYMD        DPTDAT            7 0
     C                   ELSE
     C                   GOTO      ENDP
     C                   END
     C     NXTP          TAG
     C                   READ      FAPDTP                                 90
     C   90              GOTO      ENDP
     C     ATSTAT        IFEQ      'X'
     C                   GOTO      NXTP
     C                   END
     C     OPNKEY        KLIST
     C                   KFLD                    ATCOMP
     C                   KFLD                    ATVEND
     C                   KFLD                    ATINV#
     C                   KFLD                    ATITYP
      ** DO NOT PURGE IF STILL IN AP OPEN
     C     OPNKEY        CHAIN     FAPOPNVE                           90
     C  N90              GOTO      NXTP
     C     ATCYMD        IFLE      DPTDAT
     C                   WRITE     RAPDTP
     C                   MOVEL     'X'           ATSTAT
     C                   UPDATE    APDTPI
     C                   END
     C                   GOTO      NXTP
     C     ENDP          TAG
      *
      * END PROGRAM
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             WKTOTR            9 0          TOTAL RECORDS
     C                   Z-ADD     0             WKTOTA            9 0          ACTIVE RECORDS
     C                   Z-ADD     0             WKTOTP            9 0          ALREADY MARKED
     C                   Z-ADD     0             WKTOTC            9 0          MARK THIS CYCLE
     C                   Z-ADD     0             WKTOR1            9 0
     C                   Z-ADD     0             WKTOA1            9 0
     C                   Z-ADD     0             WKTOP1            9 0
     C                   Z-ADD     0             WKTOC1            9 0
      *
      *
     C                   Z-ADD     LDAEND        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        WRKDAT            7 0
      *
      *
     C                   ENDSR
      *
