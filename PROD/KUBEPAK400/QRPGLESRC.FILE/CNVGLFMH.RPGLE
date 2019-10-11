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
      **PROGRAM NAME-------- CNVGLFMH
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- COPY SS.GLFMH TO GLFMI BEFORE CONVERT
      *                      COPY SS.GLREF TO GLREF BEFORE CONVERT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FGLFMHIN   IF   F  128    14AIDISK    KEYLOC(2)
     FGLREFIN   IF   F   32    25AIDISK    KEYLOC(2)
     FFGLFMH    O  A E             DISK
     FFGLREF    O  A E             DISK
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
     IGLFMHIN   NS
     I*    STATUS
     I                                  1    1  GHSTAT
     I*    COMPANY NUMBER
     I*   COMPANY - CAN BE 00 FOR
     I*   CONSOLIDATED REPORTS.
     I                                  2    3 0GHCOMP
     I*    REPORT REFERENCE
     I                                  4   11  GHRPRT
     I*    GROUP NUMBER
     I                                 12   15 0GHGRUP
     I*    REPORT DESCRIPTION
     I                                 16   55  GHDESC
     I*    SPACE BEFORE
     I                                 56   56 0GHSPBF
     I*    SPACE AFTER
     I                                 57   57 0GHSPAF
     I*    REVERSE SIGN
     I                                 58   58 0RVSN
     I*    LEVEL BREAK PRINT CODE
     I                                 59   59  GHLVBR
     I*    FORMAT FILE DEPT SEQUENCE
     I                                 60   63 0GHDPSQ
     I*    REPORT REFERENCE TYPE
     I                                 64   64 0GHRTYP
      *
     IGLREFIN   NS
     I*    STATUS
     I                                  1    1  GXSTAT
     I*    ALPHA SEARCH
     I                                  2   16  GXLOOK
     I*    COMPANY NUMBER
     I                                 17   18 0GXCOMP
     I*    REPORT REFERENCE
     I                                 19   26  GXRPRT
     I*    REPORT REFERENCE TYPE
     I                                 27   27 0GXRTYP
     I*    FORMAT FILE DEPT SEQUENCE
     I                                 28   31 0DPSQ
      ****************
      * GET GLFMH    *
      ****************
     C     NXTGLH        TAG
     C                   READ      GLFMHIN                                90                   ARC38
     C   90              GOTO      ENDGLH
     C     GHSTAT        IFEQ      'D'
     C                   GOTO      NXTGLH
     C                   END
      ** TRANSLATE REVERSE SIGN
     C     RVSN          IFEQ      1
     C                   MOVEL     'Y'           GHRVSN
     C                   ELSE
     C                   MOVEL     'N'           GHRVSN
     C                   END
     C                   WRITE     RGLFMH
     C                   GOTO      NXTGLH
     C     ENDGLH        TAG
     C     NXTREF        TAG
     C                   READ      GLREFIN                                90
     C   90              GOTO      ENDREF
     C     GXSTAT        IFEQ      'D'
     C                   GOTO      NXTREF
     C                   END
     C                   Z-ADD     DPSQ          GXDPSQ
     C                   WRITE     RGLREF
     C                   GOTO      NXTREF
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
