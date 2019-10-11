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
      **PROGRAM NAME-------- GETSTB#
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCULATE THE NUMBER OF LINES ON A/P CHECK
      *                         (CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFTOPAYCV  IF   E           K DISK
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
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    TPCOMP
     C                   PARM                    CHK#              6 0
     C                   PARM                    TPVEND
     C                   PARM                    STUBC             5 0
     C     TOPCVK        KLIST
     C                   KFLD                    TPCOMP
     C                   KFLD                    CHK#
     C                   KFLD                    TPVEND
      * CALC THE NUMBER OF CHECKS TO VOID FOR STUB OVERFLOW
     C                   Z-ADD     0             STUBC
     C     TOPCVK        SETLL     FTOPAYCV
     C     NXTCVK        TAG
     C     TOPCVK        READE     FTOPAYCV                               90
     C   90              GOTO      ENDCVK
     C                   ADD       1             STUBC
     C                   GOTO      NXTCVK
     C     ENDCVK        TAG
     C                   SETON                                        LR
