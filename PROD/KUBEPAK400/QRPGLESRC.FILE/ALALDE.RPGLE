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
      *PROGRAM NAME-------- ALALDE
      *SYSTEM-------------- TGMS
      *APPLICATION--------- DELETE UNNEEDED FALITEM RECORDS
      *?                                                              ?
      *? |?  Edit Log                                                ?|
      *? |                                                           ?|
      *? |WJB10/20/05?-Changed to not de-allocate fixers          ?|
      *? |   mm/dd/yy?-                                           ?|
      *?|                                                            |?
      *
     FFIORDR    IF   E           K DISK
     FFDSALEO   IF   E           K DISK
     FFALITEM   UF   E             DISK
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
     D  LDAPTO                 1      1  0
      ***********************
      ** READ FALITEM      **
      ***********************
     C     NXTALI        TAG
     C                   READ      FALITEM                                90
     C   90              GOTO      END
WJB  C*    AIORD#        IFEQ      999999
WJB  C     AIORD#        IFGE      999990
WJB  C                   GOTO      NXTALI
WJB  C                   END
     C     IORKEY        KLIST
     C                   KFLD                    AIORD#
     C                   KFLD                    AIOSEQ
     C     AIORD#        CHAIN     FDSALEO                            52
      ** LEAVE UNPOSTED ORDER RECORDS IF FALITEM
     C  N52SDSTAT        IFNE      'D'
     C                   GOTO      NXTALI
     C                   END
     C     IORKEY        CHAIN     FIORDR                             50
     C  N50OISTAT        IFEQ      'D'
     C     OIQINV        ANDLE     0
     C                   SETON                                        50
     C                   ENDIF
     C  N50OIITEM        IFNE      AIITEM
     C     OISIZE        ORNE      AISIZE
     C                   SETON                                        50
     C                   ENDIF
     C   50              DELETE    RALITEM
     C  N50OICUST        IFEQ      4496
     C                   Z-ADD     OICUST        AICUST
     C                   UPDATE    RALITEM
     C                   END
     C                   GOTO      NXTALI
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
