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
      *PROGRAM NAME-------- STSCHK
      *SYSTEM-------------- TGMS
      *APPLICATION--------- DISPLAY PROGRAM STATUS FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSTATUS   IF   E           K DISK
     FSTSCHKFM  CF   E             WORKSTN
     F                                     SFILE(STSSFL:RECNO)
      *
     D MSG             S             50    DIM(5) CTDATA PERRCD(1)              Message Array
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
      ***********************
      * SET UP SUB FILE     *
      ***********************
     C                   SETON                                        80
     C                   WRITE     STSCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTSTS        TAG
     C                   READ      FSTATUS                                90
     C   90              GOTO      ENDSTS
     C                   ADD       1             RECNO
     C                   WRITE     STSSFL
     C                   GOTO      NXTSTS
     C     ENDSTS        TAG
     C                   CLEAR                   STSSFL
     C                   ADD       1             RECNO
     C                   MOVEL     MSG(1)        STDESC
     C                   WRITE     STSSFL
     C                   EXFMT     STSCTL
      *** END PROGRAM
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
** MESSAGE ARRAY
*** End of Program List ****
