      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC .    ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- APR435
      **SYSTEM-------------- ACCOUNTS PAYABLE
      **APPLICATION--------- CREATE APDTP FILE - VENDOR PAYMENT HISTORYLES
      **
      **
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFTOPAY    UF   E           K DISK                                         APR430
     FFAPOPN    UF   E           K DISK                                         APR430
     FFAPCTL    UF   E           K DISK                                         APR430
     FFMVEND    IF   E           K DISK                                         APR430
     FFAPDTP    O  A E           K DISK
      *
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
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LDISB                  9      9
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C     NXT           TAG
     C                   READ      FTOPAY                                 90
     C   90              GOTO      END
     C     TPSTAT        IFEQ      'D'
     C     TPCOMP        ORNE      LCO
     C                   GOTO      NXT
     C                   END
      *
     C     TPVEND        CHAIN     FMVEND                             12                       APR50
      * UPDATE APOPN
     C     APOKEY        KLIST
     C                   KFLD                    TPVEND
     C                   KFLD                    TPCOMP
     C                   KFLD                    TPVOUC
     C                   KFLD                    TPINV#
     C                   KFLD                    TPSEQ#
     C                   KFLD                    TPITYP
     C     APOKEY        CHAIN     FAPOPN                             77
     C                   ADD       TPDISC        APDTAK
     C                   ADD       TP$TOP        APPAID
     C                   Z-ADD     TPCHEK        APCHEK
     C                   Z-ADD     TPCKDT        APCKDT
     C                   Z-ADD     TDATE         APDTLA
     C                   Z-ADD     TIMOD         APTIME
     C                   MOVEL     USERID        APUSER
     C                   Z-ADD     0             AP$TOP
     C                   Z-ADD     0             APDISC
     C     AP$AMT        SUB       APPAID        APDUE$
     C                   SUB       APDTAK        APDUE$
     C     APDUE$        IFEQ      0.00
     C                   MOVEL     'Y'           APCLCD
     C                   MOVEL     'D'           APSTAT
     C                   END
     C                   MOVE      *BLANKS       APTBPD
     C  N77              UPDATE    RAPOPN
      *
     C                   MOVEL     'A'           ATSTAT
     C                   Z-ADD     TPVEND        ATVEND
     C                   Z-ADD     TPCOMP        ATCOMP
     C                   Z-ADD     TPVOUC        ATVOUC
     C                   MOVEL     TPINV#        ATINV#
     C                   MOVEL     TPITYP        ATITYP
     C                   Z-ADD     TPDTAK        ATDTAK
     C                   Z-ADD     TP$TOP        ATPAID
     C                   Z-ADD     TPCHEK        ATCHEK
     C                   Z-ADD     TPCKDT        ATCKDT
     C                   MOVEL     TPTDES        ATDESC
     C  N12              MOVEL     VMLOOK        ATLOOK
     C                   Z-ADD     TPPONO        ATPONO
     C                   Z-ADD     TPCKDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ATCYMD
      *
     C                   WRITE     RAPDTP
      *
     C                   DELETE    RTOPAY
      *
     C                   GOTO      NXT
      *
     C     END           TAG
      ** UPDATE APCTL
     C     LCO           CHAIN     FAPCTL                             90
     C                   MOVEL     'N'           AZCKR
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TDATE         AZDTCP
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C  N90              UPDATE    RAPCTL
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
