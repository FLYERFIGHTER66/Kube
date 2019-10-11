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
      **PROGRAM NAME-------- @DTCNV
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- INPUT CYMD AND RETURN MDY
      *
      ********************************************************************@DT@A1
      * ##CYMD INPUT DATE CYYMMDD                                         @DT@A1
      * ##MDY OUTPUT DATE MMDDYY IF VALID  90 ON IF ##CYMD = 0            @DT@A1
      * IF ERROR ##ERR = Y                                                @DT@A1
      *
     C     *ENTRY        PLIST
     C                   PARM                    ##CYMD
     C                   PARM                    ##MDY
     C                   PARM                    ##ERR             1
      *
     C                   MOVE      *BLANKS       ##ERR                                         @DT@A
     C                   Z-ADD     0             ##MDY             6 0                         @DT@A
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  9090                   @DT@A
     C   90              GOTO      END@CN                                                      @DT@A
     C                   MOVEL     ##CYMD        ##CYR             3 0
     C                   MOVE      ##CYR         ##MDY
     C                   MOVE      ##CYMD        ##MMDD            4 0
     C                   MOVEL     ##MMDD        ##MDY
     C     END@CN        TAG                                                                   @DT@A
     C   90              MOVEL     'Y'           ##ERR
     C   90              SETOFF                                         90
     C                   SETON                                          LR
