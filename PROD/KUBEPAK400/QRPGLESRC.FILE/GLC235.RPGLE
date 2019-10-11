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
      *PROGRAM NAME-------- GLC235
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- JOURNAL ENTRY POST PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FGLR235FM  CF   E             WORKSTN
     F***                                           KID    WSID
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
      *
      * VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      ENDP
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
