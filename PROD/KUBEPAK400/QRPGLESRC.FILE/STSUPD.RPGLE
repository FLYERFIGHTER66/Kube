      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- STSUPD
      *SYSTEM-------------- CROSS APPLICATION
      *APPLICATION--------- UPDATE PROGRAM STATUS FILE
      *                     (CALLED AT END OF PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSTATUS   UF A E           K DISK
      *
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
     D  LPROG                201    210
     D  LCOMP                211    212  0
     D  LACTP                213    214  0
     D  LDESC                215    244
      *********************
      * GET STATUS RECORD *
      *********************
     C     STATKY        KLIST
     C                   KFLD                    LPROG
     C                   KFLD                    LCOMP
     C     STATKY        CHAIN     FSTATUS                            91
     C   91              DO
     C                   MOVEL     LPROG         STPROG
     C                   Z-ADD     LCOMP         STCOMP
     C                   ENDDO
     C                   Z-ADD     TDATE         STDATE
     C                   Z-ADD     TIMOD         STTIME
     C                   MOVEL     USERID        STUSER
     C                   Z-ADD     LACTP         STACTP
     C                   MOVEL     LDESC         STDESC
     C   91              WRITE     RSTATUS
     C  N91              UPDATE    RSTATUS
      ** END PROGRAM
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
