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
      **PROGRAM NAME-------- TIMENT
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PROJECT ENTRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FTIMENTFM  CF   E             WORKSTN
     F                                     SFILE(TIMSFL:RECNO)
     FFTIME     UF A E           K DISK
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
     D  LDAPTO                 1      1  0                                      ARC380
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     TDATE         DATE
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
      ** CHECK DATE
     C                   SETOFF                                       10
     C                   Z-ADD     DATE          ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        TSTDAT            7 0
      ** BUILD SUBFILE
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   EXFMT     TIMCTL
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     TIMCTL
     C                   SETOFF                                       80  98
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTAL
     C     TSTDAT        SETLL     FTIME
     C     NXTBLD        TAG
     C     TSTDAT        READE     FTIME                                  90
     C   90              GOTO      ENDBLD
     C                   MOVEL     TTSTAT        STAT
     C                   MOVEL     TTCOMP        COMP
     C                   Z-ADD     TTHOUR        HOURS
     C                   ADD       TTHOUR        TOTAL
     C                   MOVEL     TTPROG        PROG
     C                   MOVEL     TTINIT        INIT
     C                   MOVEL     TTREQB        REQB
     C                   MOVEL     TTDES1        DES1
     C                   MOVEL     TTDES2        DES2
     C                   ADD       1             RECNO
     C                   WRITE     TIMSFL
     C                   GOTO      NXTBLD
      ** END BLD OUTPUT 20 BLANK RECORDS
     C     ENDBLD        TAG
     C                   MOVE      *BLANKS       STAT
     C                   MOVE      *BLANKS       COMP
     C                   Z-ADD     0             HOURS
     C                   MOVE      *BLANKS       PROG
     C                   MOVE      *BLANKS       INIT
     C                   MOVE      *BLANKS       REQB
     C                   MOVE      *BLANKS       DES1
     C                   MOVE      *BLANKS       DES2
     C                   Z-ADD     0             TTTIME
     C                   Z-ADD     0             TTSEQ#
     C     RECNO         ADD       20            LSTREC            5 0
     C     RECNO         DOUGE     LSTREC
     C                   ADD       1             RECNO
     C                   WRITE     TIMSFL
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** OUTPUT SUB FILE   **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             LSTSEQ            3 0
     C     TIMKEY        KLIST
     C                   KFLD                    TTDATE
     C                   KFLD                    TTTIME
     C                   KFLD                    TTSEQ#
     C                   Z-ADD     TSTDAT        TTDATE
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     TIMSFL                             90
     C   90              GOTO      NXTPUT
     C     TTSEQ#        IFGT      0
     C     TIMKEY        CHAIN     FTIME                              71
     C                   ELSE
     C     DES1          IFLE      *BLANKS
     C     DES2          ANDLE     *BLANKS
     C                   GOTO      NXTPUT
     C                   END
     C     LSTSEQ        ADD       1             TTSEQ#
     C                   Z-ADD     TTSEQ#        LSTSEQ
     C                   SETON                                        71
     C                   TIME                    TTTIME
     C                   END
     C                   MOVEL     STAT          TTSTAT
     C                   MOVEL     COMP          TTCOMP
     C                   Z-ADD     HOURS         TTHOUR
     C                   MOVEL     PROG          TTPROG
     C                   MOVEL     INIT          TTINIT
     C                   MOVEL     REQB          TTREQB
     C                   MOVEL     DES1          TTDES1
     C                   MOVEL     DES2          TTDES2
     C   71              WRITE     RTIME
     C  N71              UPDATE    RTIME
     C                   GOTO      NXTPUT
     C     ENDPUT        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
