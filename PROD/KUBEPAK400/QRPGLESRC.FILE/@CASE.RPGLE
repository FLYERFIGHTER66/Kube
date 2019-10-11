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
      **PROGRAM NAME-------- @CASE
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CONVERT LOWER CASE TO UPPER CASE
      *                        (CALLED PROGRAM0
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      ** LOWER CASE
     D LO              C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
      ** UPPER CASE
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
      **
     C     *ENTRY        PLIST
     C                   PARM                    ##UPC            60
     C                   PARM                    ##LWC            60
     C     LO:UP         XLATE     ##UPC         ##LWC
     C                   SETON                                        LR
