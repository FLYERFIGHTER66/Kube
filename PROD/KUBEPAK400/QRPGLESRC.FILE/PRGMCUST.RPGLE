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
      **PROGRAM NAME-------- PRGMCUST
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- GINNY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    UF   E           K DISK
     FFCMDIR    UF   E           K DISK
     FFARHST    UF   E           K DISK
     FFCUSTCOM  UF   E           K DISK
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
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
      ***********************
      ** READ FMCUST       **
      ***********************
     C     NXT           TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      END
     C     CMSTAT        IFNE      'D'
     C                   GOTO      NXT
     C                   END
      ** GET ARHST RECORD
     C     CUSKEY        KLIST
     C                   KFLD                    CMCUST
     C     CUSKEY        CHAIN     FARHST                             71
     C  N71              DELETE    RARHST
      ** GET CMDIR RECORD
     C     CUSKEY        CHAIN     FCMDIR                             71
     C  N71              DELETE    RCMDIR
      ** GET CUSTCOM RECORD
     C     CUSKEY        CHAIN     FCUSTCOM                           71
     C  N71              DELETE    RCUSTCOM
      ** DELETE FMCUST REC
     C                   DELETE    RMCUST
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
