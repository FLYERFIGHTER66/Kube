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
      **PROGRAM NAME--------
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER----------
      **APPLICATION---------
      *
      *            CHANGE--DATE-------DESCRIPTION
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
     D  LCO                    1      2  0                                      ARC380
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OXX        E            HEAD           1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       PAGE          Z     85
     O                                           81 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           24 'Time:'
     O                       TIMOD               33 '  :  :  '
     O                                           77 'User Date:'
     O                       UDATE         Y     85
