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
      **PROGRAM NAME-------- SOWBLD
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD TEMP TEST FILE FOR SOW LINE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFLABL     IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFSOWSCH   O  A E             DISK
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
      * READ LABEL   *
      ****************
     C     NXT           TAG
     C                   READ      FLABL                                  90                   ARC38
     C   90              GOTO      END
     C     MINKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C                   MOVEL     'A'           SOSTAT
     C     1000000       ADD       LASOWD        SOSOWD
     C                   Z-ADD     LAREQD        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        SORDYD
     C                   MOVEL     LAITEM        SOITEM
     C                   MOVEL     LASIZE        SOSIZE
     C                   MOVEL     LALOOK        SOLOOK
     C                   Z-ADD     LAQSOW        SOORDQ
     C                   Z-ADD     LAQSOW        SOSOWT
     C                   MOVE      LASIZE        SOCELL
     C                   Z-ADD     IM#SED        SO#SED
     C                   MOVEL     LASEDR        SOTRYC
     C                   MOVEL     IMALTP        SOALTP
     C                   MOVE      IMMSCX        SOMSCX
     C                   MOVE      IMTPSW        SOTPSW
     C                   MOVE      IMLOC         SOLOC
     C                   ADD       1             JOB               4 0
     C                   Z-ADD     JOB           SOJOB#
     C                   WRITE     RSOWSCH
     C                   GOTO      NXT
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
