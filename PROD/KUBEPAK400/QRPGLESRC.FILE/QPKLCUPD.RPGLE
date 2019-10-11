      *--------------------------------------------------------------
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- QPKLCUPd
      **APPLICATION--------- DAILY LATE CHARGE UPDATE OF ARLC
      *
      *
     FFARLC     UF   E           K DISK
     FFAROPN    IP   E           K DISK
     FFMCUST    IF   E           K DISK
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
     D                 DS
     D  LCREC                  1      5                                         ARC380
     D  ARSTAT                 1      1                                         ARC380
     D  ARSUFF                 2      3                                         ARC380
     D  ARTTYP                 4      5  0                                      ARC380
      ****************
      * START HERE   *
      ****************
     C     LCREC         IFEQ      'LLC07'
     C     ARCUST        CHAIN     FMCUST                             90
     C     *IN90         IFEQ      *OFF
     C     OPKEY         CHAIN     FARLC                              75
      ** NOW GET DAILY AMOUNT
     C  N75              DO
     C                   Z-ADD     ARDUE$        ARLCDU
     C* no dont do this  Z-ADD     AR$AMT        ARLCAM
     C                   Z-ADD     ARPAID        ARLCPD
     C                   SUB       ARADJ$        ARLCPD
     C                   UPDATE    RARLC
     C                   ENDDO                                                   N75  DO
     C                   ENDIF
     C                   ENDIF
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     OPKEY         KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    SUFF
     C                   MOVE      '  '          SUFF              2
     C                   ENDSR
