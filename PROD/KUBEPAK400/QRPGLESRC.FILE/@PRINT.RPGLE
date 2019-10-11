      *--------------------------------------------------------------     APC500
      *                                                                   APC500
      *   COPYRIGHT EFD ENTERPRISES, INC.    1998                         APC500
      *                                                                   APC500
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         APC500
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         APC500
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      APC500
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         APC500
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      APC500
      *       BY EXPRESS WRITTEN PERMISSION OF                            APC500
      *            EFD ENTERPRISES, INC.     215-643-5352                 APC500
      *                                                                   APC500
      *--------------------------------------------------------------     APC500
      *PROGRAM NAME-         @PRINT                                       APC500
      *APPLICATION-          GLOBAL PROMPT TO GET PRINTER, FORMS ETC.     APC500
      *                                                                   APC500
      *                                                                   APC500
      *            CHANGE--DATE-------DESCRIPTION
      *                                                                   APC500
      *                                                                   APC500
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
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
     D                UDS                                                       APC500
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     66
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR            10
     C     VPRTR         IFLE      *BLANKS
     C                   MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR
     C                   ENDIF
      *
     C                   MOVEL     VPRTR         LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     1             LCOPY
      *
     C     END           TAG                                                                   APC50
     C                   SETON                                        LR
      *
