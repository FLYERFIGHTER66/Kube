      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1995
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
      **PROGRAM NAME-------- GRC510
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- GD
      **APPLICATION--------- WEEKLY PRODUCTION LIST  PROMPT SCREEN
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  10/18/96  GD - ADD PRINTER FIELD
      *
     FFMWHSE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FGRC510FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LBEGDT                 1      6  0
     D  LLOC                   7      9
     D  LJOBQ                 18     18
     D  LFORM                 19     28
     D  LP1COP                29     30  0
     D  LPRTR                 31     39
     D  LBEGIT                89    103
     D  LCANCL               133    133
      *
      ****************************************************************
      ***  VALIDATE RESPONSES ON PROMPT SCREEN A
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR             8
     C     VPRTR         IFLE      *BLANKS
     C                   MOVEL     'PRT01'       VPRTR
     C                   ENDIF
      *
     C                   MOVEL     '*NAR'        VFORM
     C                   MOVEL     'N'           VJOB
     C                   Z-ADD     1             VCOPY
      *
     C     RSTRTA        TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101530
     C                   SETOFF                                       405052
     C                   SETOFF                                       99
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KG              GOTO      ENDP
      *
      *** OPTION HELP
      *
     C                   MOVEL     *BLANKS       LCANCL
     C                   Z-ADD     VDATE         LBEGDT
     C                   MOVEL     VFORM         LFORM
     C                   Z-ADD     VCOPY         LP1COP
     C                   MOVE      VJOB          LJOBQ
     C                   MOVEL     VPRTR         LPRTR
      *
     C     VDATE         IFEQ      *ZEROS                                                   K
     C                   SETON                                        10
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VLOC          IFGT      *BLANKS
     C                   MOVEL     VLOC          WHWHSE            3
     C     KEY3          KLIST
     C                   KFLD                    WHWHSE
     C     KEY3          CHAIN     FMWHSE                             90
     C   90              SETON                                        15
     C   15              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        30
     C   30              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        40
     C   40              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VJOB          IFNE      'Y'                                                      Q
     C     VJOB          ANDNE     'N'
     C                   SETON                                        50
     C   50              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VPRTR         IFEQ      *BLANKS
     C                   SETON                                        52
     C   52              GOTO      RSTRTA
     C                   ENDIF
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
