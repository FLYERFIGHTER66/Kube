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
      **PROGRAM NAME-------- CNVGLFMI
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- COPY SS.GLFMI TO GLFMI BEFORE CONVERT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FGLFMIIN   IF   F  128    14AIDISK    KEYLOC(2)
     FFGLFMI    O  A E             DISK
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
      *
     IGLFMIIN   NS  01
     I*    STATUS
     I                                  1    1  GISTAT
     I*    COMPANY NUMBER
     I*   CAN BE 00 FOR CONSOLI-
     I*   DATED REPORTS.
     I                                  2    3 0GICOMP
     I*    REPORT REFERENCE
     I                                  4   11  GIRPRT
     I*    GROUP NUMBER
     I                                 12   15 0GIGRUP
     I*    G/L SEQUENCE NUMBER
     I                                 16   18 0GISEQ#
     I*    COMPANY NUMBER
     I                                 19   20 0GICOMD
     I*    G/L ACCOUNT NUMBER
     I                                 21   28 0GIGLAC
     I*    FORMAT FILE DEPT SEQUENCE
     I                                 29   32 0GIDPSQ
      ****************
      * GET GLFMH    *
      ****************
     C     NXTGLI        TAG
     C                   READ      GLFMIIN                                90                   ARC38
     C   90              GOTO      ENDGLI
     C     GISTAT        IFEQ      'D'
     C                   GOTO      NXTGLI
     C                   END
     C                   WRITE     RGLFMI
     C                   GOTO      NXTGLI
     C     ENDGLI        TAG
      ** END PROGRAM
     C     ENDREF        TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
