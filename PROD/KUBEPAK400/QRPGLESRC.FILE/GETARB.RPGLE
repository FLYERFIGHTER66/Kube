      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- GETARB
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GET TOTAL A/R BALANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    IF   E           K DISK
     FFAROPN    IF   E           K DISK
      *
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
      ****************
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    CMCUST
     C                   PARM                    TOTAR            11 2
     C                   PARM                    CMCRL$            9 2
     C                   Z-ADD     0             TOTAR
     C                   Z-ADD     0             CMCRL$
      ** GET MCUST
     C     CMCUST        CHAIN     FMCUST                             90
     C   90              GOTO      END
     C     CMCUST        SETLL     FAROPN
     C     NXTAR         TAG
     C     CMCUST        READE     FAROPN                                 92
     C   92              GOTO      END
     C     ARSEQ#        IFEQ      000
     C                   ADD       ARDUE$        TOTAR
     C                   END
     C                   GOTO      NXTAR
     C     END           TAG
     C                   SETON                                        LR
