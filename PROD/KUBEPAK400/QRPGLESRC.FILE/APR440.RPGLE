      *--------------------------------------------------------------     APR440
      *                                                                   APR440
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          APR440
      *                                                                   APR440
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         APR440
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         APR440
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      APR440
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         APR440
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      APR440
      *       BY EXPRESS WRITTEN PERMISSION OF                            APR440
      *            EFD ENTERPRISES, INC.     215-643-5352                 APR440
      *                                                                   APR440
      *--------------------------------------------------------------     APR440
      *PROGRAM NAME-        APR440                                        APR440
      *SYSTEM-              ACCOUNTS PAYABLE                              APR440
      *APPLICATION-         POST A/P START UP DATA (APENT) TO OPEN        APR440
      *                     INVOICE FILE (APOPN)                          APR440
      *                                                                   APR440
      *                                                                   APR440
      *            CHANGE--DATE-------DESCRIPTION
      *
      *                                                                   APR440
     FFAPENT    UF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FFAPOPN    O  A E           K DISK
      *                                                                   APR440
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      *  RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      *  USER I.D.
     D  USERID               254    261                                         ARC380
      *  SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS                                                       APC500
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *                                                                   APR440
     C     LCO           CHAIN(N)  FAPCTL                             92
     C                   Z-ADD     AZVOUC        VOUCH             6 0
     C                   MOVEL     *BLANKS       AZOKSU
      *
     C     NXT           TAG
     C                   READ      FAPENT                                 90
     C   90              GOTO      END
      *
     C     ANCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     ANSTAT        APSTAT
     C                   Z-ADD     ANVEND        APVEND
     C                   Z-ADD     ANCOMP        APCOMP
     C                   Z-ADD     VOUCH         APVOUC
     C                   MOVEL     ANINV#        APINV#
     C                   Z-ADD     ANSEQ#        APSEQ#
     C                   MOVEL     ANITYP        APITYP
     C                   MOVEL     ANVTYP        APVTYP
     C                   Z-ADD     0             APPONO
     C                   Z-ADD     ANIVDT        APIVDT
     C                   Z-ADD     ANDUDT        APDUDT
     C                   Z-ADD     ANDCDT        APDCDT
     C                   MOVEL     ANVTCD        APVTCD
     C                   Z-ADD     AN$AMT        AP$AMT
     C                   Z-ADD     ANDAVL        APDAVL
     C                   Z-ADD     ANTRAT        APTRAT
     C                   MOVEL     ANDOVT        APDOVT
     C                   Z-ADD     ANDTAK        APDTAK
     C                   Z-ADD     ANPAID        APPAID
     C                   Z-ADD     ANDUE$        APDUE$
     C                   Z-ADD     ANGLAC        APGLAC
     C                   Z-ADD     ANTDAT        APTDAT
     C                   Z-ADD     ANTTYP        APTTYP
     C                   MOVEL     ANTDES        APTDES
     C                   MOVEL     ANLOOK        APLOOK
     C                   MOVEL     ANCLCD        APCLCD
     C                   Z-ADD     ANCHEK        APCHEK
     C                   Z-ADD     ANCKDT        APCKDT
     C                   Z-ADD     ANPSDT        APPSDT
     C                   Z-ADD     ANBTCH        APBTCH
     C                   MOVEL     ANTBPD        APTBPD
     C                   MOVEL     ANMVPC        APMVPC
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     USERID        APUSER
     C                   Z-ADD     ANAPER        APAPER
     C                   Z-ADD     AN$TOP        AP$TOP
     C                   Z-ADD     ANDISC        APDISC
     C                   Z-ADD     ANRVDU        APRVDU
     C                   ADD       1             VOUCH
      *
     C                   WRITE     RAPOPN
     C                   MOVEL     'D'           ANSTAT
     C                   UPDATE    RAPENT
     C                   GOTO      NXT
      *
     C     END           TAG                                                                   APR44
     C     LCO           CHAIN     FAPCTL                             92
     C                   Z-ADD     VOUCH         AZVOUC
     C                   MOVEL     ' '           AZOKSU
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
     C                   SETON                                        LR
      *                                                                   APR440
