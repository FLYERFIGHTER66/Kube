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
      *APPLICATION--------- GET PERIOD DATES FROM ACCOUNTING PERIOD
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
      *
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D END             S              6  0 DIM(13)                              END DATES
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
     C                   PARM                    ERR               1 0
      * ERROR CODES
      *   1 - INVALID COMPANY
      *   2 - INVALID PERIOD
      *   3 - BEG DATE IS 0 FOR REQUESTED PERIOD
      *
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             ENDDAT
     C                   Z-ADD     0             BGCYMD
     C                   Z-ADD     0             ENCYMD
     C                   Z-ADD     0             ERR
     C     CONO          CHAIN     FMAPER                             90
     C   90              Z-ADD     1             ERR
     C   90              GOTO      EOJ
     C                   Z-ADD     ACTPER        D                 2 0
     C     D             IFLT      1
     C                   Z-ADD     2             ERR
     C                   GOTO      EOJ
     C                   END
     C     BEG(D)        IFEQ      0
     C                   Z-ADD     3             ERR
     C                   GOTO      EOJ
     C                   END
     C                   Z-ADD     BEG(D)        BEGDAT
     C                   Z-ADD     END(D)        ENDDAT
     C                   Z-ADD     BEG(D)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BGCYMD
     C                   Z-ADD     END(D)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ENCYMD
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
