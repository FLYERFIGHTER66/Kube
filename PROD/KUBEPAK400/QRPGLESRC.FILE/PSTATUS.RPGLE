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
      *PROGRAM NAME-------- PSTATUS
      *SYSTEM-------------- PRINTER STATUS PROMPT SCREEN
      *DESCRIPTION--------- THIS PROGRAM PROMPTS FOR PRINTER
      *                     OPTIONS AND VALIDATES FIELDS ENTERED.
      *                     THIS PROGRAM IS USED WHEN REPORTS HAVE
      *                     NO SPECIFIC PROMPT SCREEN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FPSTATFM   CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D                UDS
     D  LFORM                  1      4
     D  LCOPY                  5      6  0
     D  LPRTR                  7     16
     D  LHOLD                 17     20
     D  LSAVE                 21     24
     D  LJOB                  25     25
     D  LPROG                 26     33
     D  LNAME                 34     63
     D  LCANCL               133    133
      *
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR
     C     VPRTR         IFLE      *BLANKS
     C                   MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        VPRTR
     C                   ENDIF
      *
     C                   Z-ADD     1             VOUT
     C                   MOVEL     '*NAR'        VFORM
     C                   MOVEL     01            VCOPY
     C                   MOVEL     'Y'           LJOB
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102030
     C                   SETOFF                                       52
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C                   MOVE      ' '           LCANCL
     C                   MOVEL     VFORM         LFORM
     C                   Z-ADD     VCOPY         LCOPY
     C                   MOVEL     VPRTR         LPRTR
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        10
     C   10              GOTO      RSTRT
     C                   ENDIF
      *
     C     VCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        20
     C   20              GOTO      RSTRT
     C                   ENDIF
      *
     C     VPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        52
     C   52              GOTO      RSTRT
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        30
     C   30              GOTO      RSTRT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      **
