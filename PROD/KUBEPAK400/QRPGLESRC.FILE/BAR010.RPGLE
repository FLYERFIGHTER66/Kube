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
      **PROGRAM NAME-------- BAR010
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BAR CODE CONTROL FILE MAINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FBAR010FM  CF   E             WORKSTN
     FFBARCTL   UF A E           K DISK
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
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   Z-ADD     0             CONO                                          ARC38
     C                   Z-ADD     0             TAG#
     C                   SETOFF                                         20
     C                   SETON                                        10
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CKECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KF              GOTO      END
      ** GET COMPANY
     C     CONO          CHAIN     FBARCTL                            50
     C   50              DO
     C                   CLEAR                   RBARCTL
     C                   Z-ADD     CONO          BXCOMP
     C                   Z-ADD     0             TAG#
     C                   ENDDO
     C                   Z-ADD     BXNXT#        TAG#
     C     NXTA1         TAG
     C                   SETOFF                                       10
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CKECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KF              GOTO      END
     C     TAG#          IFLE      0
     C                   SETON                                        20
     C                   GOTO      NXTA1
     C                   ELSE
     C                   SETOFF                                       20
     C                   END
      ** OUTPUT THE FILE
     C                   Z-ADD     TAG#          BXNXT#
     C                   MOVEL     USERID        BXUSER
     C                   Z-ADD     TDATE         BXDTLA
     C                   Z-ADD     TIMOD         BXTIME
     C   50              WRITE     RBARCTL
     C  N50              UPDATE    RBARCTL
     C                   GOTO      RSTART
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
