      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1996
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
      **PROGRAM NAME-------- GETRDY
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS DISTRIBUTION.
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET READY DATE FORM SOW DATE.
      *                      (THIS IS A CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
      **
      ** MINVT ARRAYS
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM 4
     D IGE             S              4  0 DIM(4)                               END WKS GERM 4
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
     IRMINVT
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    SOWDAT            7 0          CYMD
     C                   PARM                    REQDAT            7 0          CYMD
      ********
     C                   Z-ADD     0             REQDAT
     C                   Z-ADD     SOWDAT        REVDAT            7 0
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     ITMKEY        CHAIN     FMINVT                             90
     C   90              GOTO      END
     C     IGB(1)        IFLT      01
     C                   GOTO      END
     C                   END
     C     IGB(1)        IFLT      100
     C                   EXSR      GTGRMW
     C                   ELSE
     C                   EXSR      GTGRMD
     C                   END
     C     GRMWKS        IFEQ      0
     C                   GOTO      END
     C                   END
      ** NOW GET SOW DATE
     C                   Z-ADD     REVDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BASE              5 0
     C     GRMWKS        MULT      7             WRK               5 0
     C     BASE          ADD       WRK           ##DDD
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
      ** GET TO MONDAY DAY 1
     C     #Y            SUB       1             #Y
     C                   SUB       #Y            ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        REQDAT
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      **********************
      * GET GERM BY WEEK # *
      **********************
     C     GTGRMW        BEGSR
      ** GET CALENDAR RECORD
     C     SOWDAT        CHAIN     FCALENCY                           90
     C   90              GOTO      ENDX
     C                   Z-ADD     1             X                 1 0
     C     NXTX          TAG
      ** FIRST CHECK FOR SAME YEAR WEEKS
     C     CLWEEK        IFGE      IGB(X)
     C     CLWEEK        ANDLE     IGE(X)
     C                   Z-ADD     IGW(X)        GRMWKS            4 0
     C                   GOTO      ENDX
     C                   ENDIF
      ** NOW CHECK FOR DIFF YEAR WEEKS
     C     IGE(X)        IFLT      IGB(X)
     C     CLWEEK        IFGE      IGB(X)
     C     CLWEEK        ANDLE     53
     C                   Z-ADD     IGW(X)        GRMWKS
     C                   GOTO      ENDX
     C                   ENDIF
     C     CLWEEK        IFLE      IGE(X)
     C     CLWEEK        ANDGT     0
     C                   Z-ADD     IGW(X)        GRMWKS
     C                   GOTO      ENDX
     C                   ENDIF
     C                   END                                                    IGE < IGB
     C                   ADD       1             X
     C     X             IFLE      4
     C                   GOTO      NXTX
     C                   END
     C     ENDX          TAG
     C                   ENDSR
      **********************
      * GET GERM BY DATE   *
      **********************
     C     GTGRMD        BEGSR
     C                   MOVE      REVDAT        MMDD              4 0
     C                   Z-ADD     0             X
     C     NXTD          TAG
     C                   ADD       1             X
     C     X             IFGT      4
     C                   GOTO      ENDD
     C                   END
      ** CHECK WHAT RANGE
     C     IGB(X)        IFLE      IGE(X)
     C     MMDD          IFGE      IGB(X)
     C     MMDD          ANDLE     IGE(X)
     C                   Z-ADD     IGW(X)        GRMWKS
     C                   GOTO      ENDD
     C                   ENDIF
     C                   ELSE
     C     MMDD          IFGE      IGB(X)
     C     MMDD          ANDLE     1231
     C                   Z-ADD     IGW(X)        GRMWKS
     C                   GOTO      ENDD
     C                   ENDIF
     C     MMDD          IFLE      IGE(X)
     C     MMDD          ANDGE     0101
     C                   Z-ADD     IGW(X)        GRMWKS
     C                   GOTO      ENDD
     C                   ENDIF
     C                   ENDIF
     C                   GOTO      NXTD
     C     ENDD          TAG
     C                   ENDSR
