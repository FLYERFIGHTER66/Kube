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
      *PROGRAM NAME-------- ICC220
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- CALL INVENTORY BALANCE INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FICC220FM  CF   E             WORKSTN
     FFMSIZE    IF   E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0
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
     C     VALPHA        COMP      *BLANKS                              1010
     C   10              GOTO      NXTA
     C   10              GOTO      NXTA
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
     C                   MOVEL     *BLANKS       SHPFR
      * CALL ITEM LOOK
     C                   CALL      'ICR220'
     C                   PARM                    VALPHA
     C                   PARM                    IMITEM           12
     C                   PARM                    IMSIZE            3
     C                   PARM                    IMWHSE            3
     C                   PARM                    IMDES1           30
     C                   PARM                    IMDES2           30
     C                   PARM                    IMDES3           30
     C                   PARM                    IMDES4           30
     C                   PARM                    SHPFR             3
     C                   GOTO      NXTA
      * END PROGRAM
     C     END           TAG
     C                   SETON                                          LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
