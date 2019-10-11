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
      *PROGRAM NAME-------- FXTINVT
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE FTINVT AS NEEDED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFTINVT    UF   E             DISK
      *
     C     NXT           TAG
     C                   READ      FTINVT                                 90
     C  N90              DO
     C     ITTYPE        IFNE      'A'
     C                   GOTO      NXT
     C                   ENDIF
     C                   Z-SUB     ITTQTY        ITTQTY
     C                   UPDATE    RTINVT
     C                   GOTO      NXT
     C                   ENDDO
     C     END           TAG
     C                   SETON                                        LR
