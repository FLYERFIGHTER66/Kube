      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR325
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- CREATE TOPAY FILE FOR CHECK PRINTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPOPNCK  IF   E           K DISK
     FFTOPAY    O  A E           K DISK
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LDATE                 61     66  0
     D  LCHECK                67     72  0
     D  LVOID                 73     75  0
     D  LRERUN                76     76
     D  LFORMR                77     80
     D  LPRTRR                81     90
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXT           TAG
     C                   READ      FAPOPNCK                               90
     C   90              GOTO      END
      *
     C     APTBPD        IFNE      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'C'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     APSTAT        TPSTAT
     C                   Z-ADD     APVEND        TPVEND
     C                   Z-ADD     APCOMP        TPCOMP
     C                   Z-ADD     APVOUC        TPVOUC
     C                   MOVEL     APINV#        TPINV#
     C                   Z-ADD     APSEQ#        TPSEQ#
     C                   MOVEL     APITYP        TPITYP
     C                   MOVEL     APVTYP        TPVTYP
     C                   MOVEL     APPONO        TPPONO
     C                   Z-ADD     APIVDT        TPIVDT
     C                   Z-ADD     APDUDT        TPDUDT
     C                   Z-ADD     APDCDT        TPDCDT
     C                   MOVEL     APVTCD        TPVTCD
     C                   Z-ADD     AP$AMT        TP$AMT
     C                   Z-ADD     APDAVL        TPDAVL
     C                   Z-ADD     APTRAT        TPTRAT
     C                   MOVEL     APDOVT        TPDOVT
     C                   Z-ADD     APDISC        TPDTAK
     C                   Z-ADD     APPAID        TPPAID
     C                   Z-ADD     APDUE$        TPDUE$
     C                   Z-ADD     APGLAC        TPGLAC
     C                   Z-ADD     APTDAT        TPTDAT
     C                   Z-ADD     APTTYP        TPTTYP
     C                   MOVEL     APTDES        TPTDES
     C                   MOVEL     APLOOK        TPLOOK
     C                   MOVEL     APCLCD        TPCLCD
     C*                    Z-ADDAPCHEK    TPCHEK
     C*                    Z-ADDAPCKDT    TPCKDT
     C                   Z-ADD     APPSDT        TPPSDT
     C                   Z-ADD     APBTCH        TPBTCH
     C                   MOVEL     APTBPD        TPTBPD
     C                   MOVEL     APMVPC        TPMVPC
     C                   Z-ADD     TDATE         TPDTLA
     C                   Z-ADD     TIMOD         TPTIME
     C                   MOVEL     USERID        TPUSER
     C                   Z-ADD     APAPER        TPAPER
     C                   Z-ADD     AP$TOP        TP$TOP
     C                   Z-ADD     APDISC        TPDISC
     C                   Z-ADD     APRVDU        TPRVDU
      *
     C                   WRITE     RTOPAY
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
