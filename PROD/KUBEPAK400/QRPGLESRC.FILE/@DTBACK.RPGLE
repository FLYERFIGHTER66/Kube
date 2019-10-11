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
      **PROGRAM NAME-------- @DTBACK
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INPUT MDY AND A NUMBER OF MONTHS RETURN
      *                      CALCULATED MDY.
      *
      ********************************************************************@DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * IF ERROR ##ERR = Y                                                @DT@A1
      *
     C     *ENTRY        PLIST
     C                   PARM                    ##MDYI            6 0
     C                   PARM                    ##MTHS            3 0
     C                   PARM                    ##NMDY            6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDYI        ##MDY
      *
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        WRKDAT            7 0
      *
      ** CALC NUMBER OF YEARS TO SUBTRACT
     C                   Z-ADD     0             YEARS             6 0
     C     ##MTHS        IFGE      12
     C     ##MTHS        DIV       12            WRKYRS            3 0
     C     10000         MULT      WRKYRS        YEARS
     C     WRKYRS        MULT      12            LESMTH            3 0
     C                   SUB       LESMTH        ##MTHS
     C                   END
      ** NOW GET THE REMAINING MONTHS
     C                   Z-ADD     0             WRKMTH            2 0
     C     ##MTHS        IFGT      0
     C                   MOVEL     ##MDY         CMTH              2 0
     C     CMTH          IFGT      ##MTHS
     C                   Z-ADD     ##MTHS        WRKMTH
     C     WRKMTH        MULT      100           MONTHS            4 0
     C                   SUB       MONTHS        WRKDAT
     C                   ELSE
     C                   SUB       CMTH          ##MTHS
     C                   ADD       10000         YEARS
     C     12            SUB       CMTH          WRKMTH
     C     WRKMTH        MULT      100           MONTHS            4 0
     C                   ADD       MONTHS        WRKDAT
     C                   END
     C                   END
      ** NOW TAKE OUT THE YEARS
     C                   SUB       YEARS         WRKDAT
      ** NOW GET MONTH END DAY
     C                   MOVE      01            WRKDAT
     C                   Z-ADD     WRKDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     31            DD                2 0
     C                   MOVEL     ##MDY         MMDD              4 0
     C     NXTMTH        TAG
     C                   MOVE      DD            MMDD
     C                   MOVEL     MMDD          ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SUB       1             DD
     C     DD            IFGE      28
     C                   GOTO      NXTMTH
     C                   ELSE
     C                   MOVEL     'Y'           ##ERR
     C                   Z-ADD     0             ##MDY
     C                   GOTO      END
     C                   END
     C                   ELSE
     C                   Z-ADD     ##MDY         ##NMDY
     C                   MOVE      *BLANKS       ##ERR
     C                   END
      *
      * END JOB
     C     END           TAG
     C                   SETON                                          LR
