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
      *PROGRAM NAME-------- GETPDAT
      *SYSTEM-------------- CROSS APPLICATION
      *APPLICATION--------- GET ACCOUNTING PERIOD FROM TRANS DATE
      *                     (THIS IS A CALLED PROGRAM)
      *
     FFMAPER    IF   E           K DISK
      *
      * MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D END             S              6  0 DIM(13)                              END DATES
     D BD              S              7  0 DIM(13)                              BEG CYMD
     D ED              S              7  0 DIM(13)                              END CYMD
      *
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      END(1)
     I              ACEN02                      END(2)
     I              ACEN03                      END(3)
     I              ACEN04                      END(4)
     I              ACEN05                      END(5)
     I              ACEN06                      END(6)
     I              ACEN07                      END(7)
     I              ACEN08                      END(8)
     I              ACEN09                      END(9)
     I              ACEN10                      END(10)
     I              ACEN11                      END(11)
     I              ACEN12                      END(12)
     I              ACEN13                      END(13)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
      * ERROR CODES
      *   1 - INVALID COMPANY
      *   2 - INVALID TRNDAT PASSED
      *   3 - BEG DATE IS 0 FOR REQUESTED PERIOD
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             ENDDAT
     C                   Z-ADD     0             BGCYMD
     C                   Z-ADD     0             ENCYMD
     C                   Z-ADD     0             ERR
     C                   Z-ADD     CONO          CO                2 0
     C     CO            CHAIN     FMAPER                             90
     C   90              Z-ADD     1             ERR
     C   90              GOTO      EOJ
     C                   Z-ADD     TRNDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   Z-ADD     2             ERR
     C                   GOTO      EOJ
     C                   END
     C                   Z-ADD     ##CYMD        TDTE              7 0
     C                   Z-ADD     1             X                 2 0
     C     X             DOUEQ     13
     C                   Z-ADD     BEG(X)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BD(X)
     C                   Z-ADD     END(X)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ED(X)
     C     TDTE          IFGE      BD(X)
     C     TDTE          ANDLE     ED(X)
     C                   Z-ADD     X             ACTPER
     C                   SETON                                        50
     C                   GOTO      ENDL
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C     ENDL          TAG
     C  N50              Z-ADD     99            ACTPER
     C   50              Z-ADD     BEG(X)        BEGDAT
     C   50              Z-ADD     END(X)        ENDDAT
     C   50              Z-ADD     BD(X)         BGCYMD
     C   50              Z-ADD     ED(X)         ENCYMD
     C     EOJ           TAG
     C                   SETON                                        LR
      **
