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
      *PROGRAM NAME-------- FXIORAST
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE FIORAST AS NEEDED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORAST   UF   E             DISK
      *
     C     NXT           TAG
     C                   READ      FIORAST                                90
     C                   SETOFF                                       50
     C   90              GOTO      END
     C                   Z-ADD     IADTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        IARVDT
     C                   UPDATE    RIORAST
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
