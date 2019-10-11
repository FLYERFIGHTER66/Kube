      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.      ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR608
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- UPDATE AROPN - START UP INVOICE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARENT    UF   E           K DISK
     FFMCUST    UF   E           K DISK
     FFARHST    UF A E           K DISK
     FFMCOMP    IF   E           K DISK
     FFARCTL    UF   E           K DISK
     FFAROPN    O  A E           K DISK
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCOMP                             33
      *
     C     NXT           TAG
     C                   READ      FARENT                                 90
     C   90              GOTO      END
      *
     C     AESTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     AECUST        CHAIN     FMCUST                             97
     C  N97              ADD       AE$AMT        CMARB$
     C  N97              UPDATE    RMCUST
      *
     C                   Z-ADD     AETDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RVDTE             7 0
      *
     C                   EXSR      UAROPN
      *
      * IF NOT INVOICE NO ARHST UPDATE
      *
     C     AETTYP        IFNE      01
     C     AETTYP        ORNE      05
     C                   GOTO      NOARH
     C                   ENDIF
      *
     C                   MOVEL     AETDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         HDATE             6 0
      *
     C     AECUST        CHAIN     FARHST                             96
      *
     C     AETTYP        IFEQ      05
     C                   EXSR      CARHST
     C                   GOTO      NOARH
     C                   ENDIF
      *
     C   96              EXSR      NARHST
     C  N96              EXSR      UARHST
      *
     C     NOARH         TAG
      *
     C                   MOVEL     'D'           AESTAT
     C                   UPDATE    RARENT
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     LCO           CHAIN     FARCTL                             90
     C                   MOVEL     'N'           ACOKSI
     C                   UPDATE    RARCTL
     C                   SETON                                        LR
      **********
      * UAROPN *
      **********
      *
     C     UAROPN        BEGSR
     C                   MOVEL     'A'           ARSTAT
     C                   Z-ADD     AECUST        ARCUST
     C                   Z-ADD     AEINV#        ARINV#
     C                   MOVEL     AESUFF        ARSUFF
     C                   Z-ADD     AESEQ#        ARSEQ#
     C                   MOVEL     AECTYP        ARCTYP
     C                   MOVEL     AESLSM        ARSLM1
     C                   Z-ADD     AECOMM        ARCOM1
     C                   MOVEL     *BLANKS       ARSLM2
     C                   Z-ADD     0             ARCOM2
     C                   MOVEL     AETERR        ARTERR
     C                   Z-ADD     AECOMP        ARCOMP
     C                   Z-ADD     AETTYP        ARTTYP
     C                   Z-ADD     AETDAT        ARTDAT
     C                   Z-ADD     AEDUDT        ARDUDT
     C                   Z-ADD     AE$AMT        AR$AMT
     C     AEQDI$        ADD       AEDIS$        ARDTAK
     C                   Z-ADD     0             ARADJ$
     C                   Z-ADD     0             ARPAID
     C                   Z-ADD     AE$AMT        ARDUE$
     C                   MOVEL     *BLANKS       ARCHEK
     C                   Z-ADD     0             ARCKDT
     C                   Z-ADD     AEGARR        ARGLAC
     C                   MOVEL     *BLANKS       ARDESC
     C                   Z-ADD     TDATE         ARDTLA
     C                   Z-ADD     TIMOD         ARTIME
     C                   MOVEL     USERID        ARUSER
     C                   Z-ADD     AEDCDT        ARDCDT
     C                   Z-ADD     0             ARORD#
     C                   MOVEL     CMLOOK        ARLOOK
     C                   Z-ADD     AESHCU        ARSHCU
     C                   Z-ADD     AESACU        ARSACU
     C                   Z-ADD     AEBLCU        ARBLCU
     C                   MOVEL     *BLANKS       ARPONO
     C                   MOVEL     *BLANKS       ARCRCD
     C                   Z-ADD     0             ARCRC#
     C                   Z-ADD     0             ARCRCE
     C                   MOVEL     *BLANKS       ARCRCA
     C                   WRITE     RAROPN
     C                   ENDSR
      **********
      * NARHST *
      **********
      *
     C     NARHST        BEGSR
     C                   MOVEL     'A'           HSSTAT
     C                   Z-ADD     AECUST        HSCUST
     C                   MOVE      *BLANKS       HSSRCE
     C                   MOVE      *BLANKS       HSSIC#
     C                   MOVE      *BLANKS       HSBDRT
     C                   Z-ADD     0             HSSIZE
     C                   Z-ADD     0             HS#EMP
     C                   Z-ADD     0             HSFNDT
     C                   MOVE      *BLANKS       HSAUDT
     C                   MOVE      *BLANKS       HSCOM1
     C                   MOVE      *BLANKS       HSCOM2
     C                   MOVE      *BLANKS       HSCOM3
     C                   Z-ADD     HDATE         HSDTFS
     C                   Z-ADD     HDATE         HSDTLS
     C                   Z-ADD     AE$AMT        HSAMLS
     C                   Z-ADD     0             HSDTLP
     C                   Z-ADD     0             HSAMLP
     C                   Z-ADD     AE$AMT        HSHARB
     C                   Z-ADD     HDATE         HSDTAR
     C                   Z-ADD     1             HS#INV
     C                   Z-ADD     0             HS#ORD
     C                   Z-ADD     0             HS#CRM
     C                   Z-ADD     0             HSAVOR
     C                   Z-ADD     0             HSTMDL
     C                   Z-ADD     0             HSAVDY
     C                   Z-ADD     0             HS#PAY
     C                   Z-ADD     0             HSFAX
     C                   MOVEL     *BLANKS       HSCRCD
     C                   Z-ADD     0             HSCRC#
     C                   MOVEL     'Y'           HSINCL
     C                   Z-ADD     0             HSCRDT
     C                   Z-ADD     0             HSBANK
     C                   WRITE     RARHST
     C                   ENDSR
      *
      **********
      * UARHST *
      **********
      *
     C     UARHST        BEGSR
     C                   Z-ADD     HDATE         HSDTLS
     C                   Z-ADD     AE$AMT        HSAMLS
     C     CMARB$        IFGT      HSHARB
     C                   Z-ADD     CMARB$        HSHARB
     C                   Z-ADD     HDATE         HSDTAR
     C                   ENDIF
     C                   ADD       1             HS#INV
     C                   UPDATE    RARHST
     C                   ENDSR
      *
      **********
      * CARHST *
      **********
      *
     C     CARHST        BEGSR
     C                   ADD       1             HS#CRM
     C                   UPDATE    RARHST
     C                   ENDSR
      *
