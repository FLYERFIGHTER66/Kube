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
      **PROGRAM NAME-------- PUR051
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- COMBINE SAME CUSTOMERS AND SHIP VIA
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFPUUCKSC  UF   E           K DISK
     F                                     RENAME(RPUUCKS:TRUCKS)
     FFPUUCKS   UF   E           K DISK
     FFPUUCKO   UF   E           K DISK
      *
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
     D  LCO                    1      2  0                                      ARC380
     D  BEGDT                  3      8  0                                      ARC380
     D  ENDDT                  9     14  0                                      ARC380
     D  YEAR                  15     18  0                                      ARC380
     D  WEEK                  19     20  0                                      ARC380
      ***********************
      ** START HERE        **
      ***********************
     C     BEGCYM        SETLL     FPUUCKSC
     C     NXT           TAG
     C     BEGCYM        READE     FPUUCKSC                               90
     C   90              GOTO      END
     C     TSSVIA        IFEQ      OVIA
     C     TSCUST        ANDEQ     OCUST
     C                   Z-ADD     TSSEQ#        OSEQ#             6 0
     C                   EXSR      COMB
     C                   END
     C                   MOVEL     TSSVIA        OVIA              2
     C                   Z-ADD     TSCUST        OCUST             6 0
     C                   Z-ADD     TSSEQ#        OSEQ#
     C                   GOTO      NXT
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** COMBINE CUSTOMER  **
      ***********************
     C     COMB          BEGSR
     C                   Z-ADD     0             ORDERS            3 0
     C                   Z-ADD     0             QTY1              7 1
     C                   Z-ADD     0             QTY2              7 1
     C                   Z-ADD     0             QTY3              7 1
     C                   Z-ADD     0             QTY4              7 1
     C                   Z-ADD     TSCUST        CUST              6 0
     C                   MOVEL     TSSVIA        SVIA              2
     C     TRKEY         KLIST
     C                   KFLD                    BEGCYM
     C                   KFLD                    SVIA
     C                   KFLD                    CUST
     C     TRKEY         SETLL     FPUUCKSC
     C                   READ      FPUUCKSC                               91
     C                   Z-ADD     TSSEQ#        SEQ#              6 0
     C                   ADD       TS#ORD        ORDERS
     C                   ADD       TSQTY1        QTY1
     C                   ADD       TSQTY2        QTY2
     C                   ADD       TSQTY3        QTY3
     C                   ADD       TSQTY4        QTY4
     C     NXTCMB        TAG
     C     TRKEY         READE     FPUUCKSC                               91
     C   91              GOTO      ENDCMB
     C                   ADD       TS#ORD        ORDERS
     C                   ADD       TSQTY1        QTY1
     C                   ADD       TSQTY2        QTY2
     C                   ADD       TSQTY3        QTY3
     C                   ADD       TSQTY4        QTY4
     C                   Z-ADD     TSSEQ#        WKSEQ#            6 0
     C     TRSKY         KLIST
     C                   KFLD                    BEGCYM
     C                   KFLD                    WKSEQ#
     C     TRSKY         SETLL     FPUUCKO
     C     NXTCMO        TAG
     C     TRSKY         READE     FPUUCKO                                92
     C  N92              DO
     C                   Z-ADD     SEQ#          TSSEQ#
     C                   UPDATE    RPUUCKO
     C                   GOTO      NXTCMO
     C                   ENDDO
     C                   DELETE    TRUCKS
     C                   GOTO      NXTCMB
     C     ENDCMB        TAG
      ** NOW OUTPUT FIRST RECORD UPDATED
     C                   Z-ADD     SEQ#          WKSEQ#
     C     TRSKY         CHAIN     FPUUCKS                            91
     C                   Z-ADD     ORDERS        TS#ORD
     C                   Z-ADD     QTY1          TSQTY1
     C                   Z-ADD     QTY2          TSQTY2
     C                   Z-ADD     QTY3          TSQTY3
     C                   Z-ADD     QTY4          TSQTY4
     C  N91              UPDATE    RPUUCKS
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     BEGDT         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BEGCYM            7 0
     C                   ENDSR
