      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1998
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
      **PROGRAM NAME-------- APLA
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALL NEW ITEM ALPHA SEARCH AVAILABLE ONLY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FALPAFM    CF   E             WORKSTN
     FFMDEPT    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
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
     D  LDAPTO                 1      1  0                                      ARC380
      *************
      * START HERE
      *************
     C** 90                GOTO END
     C     RSTART        TAG
     C                   SETOFF                                       10
     C                   MOVE      *BLANKS       VALPHA
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  61
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                         1020
      ** CHECK ALPHA
     C     VALPHA        COMP      *BLANKS                            1010
     C  N10SIZE          COMP      *BLANKS                            1010
     C  N10              DO
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C                   ENDDO
     C                   SETOFF                                       10
      ** CHECK SIZE
     C                   MOVEL     SIZE          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       SIZE
     C                   MOVEL     SZCODE        SIZE
     C                   GOTO      NXTA
     C                   END
     C     SIZE          IFGT      *BLANKS
     C     SIZE          CHAIN     FMSIZE                             20
     C   20              GOTO      NXTA
     C                   END
     C                   MOVEL     SIZE          IMSIZE
      *** CALL ITEM LOOK
     C                   CALL      'LKITEMA'
     C                   PARM                    VALPHA
     C                   PARM                    IMITEM           12
     C                   PARM                    IMSIZE            3
     C                   PARM                    IMWHSE            3
     C                   PARM                    IMDES1           30
     C                   PARM                    IMDES2           30
     C                   PARM                    IMDES3           30
     C                   PARM                    IMDES4           30
     C                   PARM                    DESHFR
     C                   GOTO      NXTA
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                          LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             90
     C* N90      DESHFR    IFLE *BLANKS
     C*                    SETON                     90
     C*                    END
     C*  90                WRITESCRNE
     C*  90                READ SCRNE                    91
     C                   ENDSR
