      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.         2002
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *****************************************************************
      *PROGRAM NAME-------- APR247
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- VENDOR INVOICE INQUIRY.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPR247FM  CF   E             WORKSTN
     F                                     SFILE(PMTSFL:RECNO)
     FFAPDTP    IF   E           K DISK
     FFAPOPNVE  IF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
      * WORK ARRAYS FOR SCAN
     D IN              S              1    DIM(15)
     D OUT             S              1    DIM(15)
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
     C                   Z-ADD     1             LCO
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       VMNAME
     C**                   Z-ADD0         VVEND
     C                   Z-ADD     0             TPAID
     C**                   MOVEL*BLANKS   VINV#
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       203040
     C                   SETOFF                                       606125
     C                   SETOFF                                       77
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     LCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1012
     C   12              GOTO      NXTA
      *
      *
     C     VINV#         IFLE      *BLANKS
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   MOVE      *BLANKS       IN
     C                   MOVE      *BLANKS       OUT
     C                   MOVEA     VINV#         IN
     C                   Z-ADD     0             X                 2 0
     C                   Z-ADD     0             Y                 2 0
     C     NXTX          TAG
     C                   ADD       1             X
     C     X             IFLT      11
     C     IN(X)         IFGT      *BLANK
     C                   ADD       1             Y
     C                   MOVE      IN(X)         OUT(Y)
     C                   END
     C                   GOTO      NXTX
     C                   END
     C                   MOVEA     OUT           OUTTST           10
     C     VVEND         SETLL     FAPDTP
     C     OPNKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VVEND
     C     OPNKEY        SETLL     FAPOPNVE
     C                   MOVE      '1'           *IN80
     C                   WRITE     PMTCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C     NXTO          TAG
     C     OPNKEY        READE     FAPOPNVE                               90
     C   90              GOTO      DSPL1
      *
     C     APSTAT        IFEQ      'D'
     C     APPAID        OREQ      AP$AMT
     C                   GOTO      NXTO
     C                   END
     C     OUTTST:Y      SCAN      APINV#                                 89
      *
     C*          ATINV#    IFNE VINV#                                  #
     C  N89              GOTO      NXTO
     C*                    ENDIF
      *
     C                   MOVEL     APINV#        INV#
     C                   MOVEL     APITYP        ITYP
     C                   Z-ADD     APIVDT        INVDAT
     C                   Z-ADD     APDUDT        DUEDAT
     C                   Z-ADD     AP$AMT        INVAMT
     C                   Z-ADD     APPAID        PAID
     C                   Z-ADD     APCHEK        CHECK
     C                   Z-ADD     APCKDT        CKDT
     C                   ADD       1             RECNO
     C                   WRITE     PMTSFL
     C                   ADD       PAID          TPAID             9 2
     C                   GOTO      NXTO
      *
     C     DSPL1         TAG
      *
     C     NXTP          TAG
     C     VVEND         READE     FAPDTP                                 90
     C   90              GOTO      DSPL2
      *
     C     ATCOMP        IFNE      LCO                                                      #
     C                   GOTO      NXTP
     C                   ENDIF
      *
     C     OUTTST:Y      SCAN      ATINV#                                 89
     C*          ATINV#    IFNE VINV#                                  #
     C  N89              GOTO      NXTP
     C**                   ENDIF
      *
     C                   MOVEL     ATINV#        INV#
     C                   MOVEL     ATITYP        ITYP
     C                   Z-ADD     0             INVDAT
     C                   Z-ADD     0             DUEDAT
     C                   Z-ADD     0             INVAMT
     C                   Z-ADD     ATPAID        PAID
     C                   Z-ADD     ATCHEK        CHECK
     C                   Z-ADD     ATCKDT        CKDT
     C                   ADD       1             RECNO
     C                   WRITE     PMTSFL
     C                   ADD       ATPAID        TPAID             9 2
     C                   GOTO      NXTP
      *
     C     DSPL2         TAG
     C                   ADD       2             RECNO
     C                   MOVE      *BLANKS       INV#
     C                   MOVE      *BLANKS       ITYP
     C                   Z-ADD     0             INVDAT
     C                   Z-ADD     0             DUEDAT
     C                   Z-ADD     0             INVAMT
     C                   Z-ADD     0             PAID
     C                   Z-ADD     0             CHECK
     C                   Z-ADD     0             CKDT
     C                   MOVEL     '** END *'    INV#
     C                   WRITE     PMTSFL
     C                   ADD       1             FCNT              2 0
     C                   EXFMT     PMTCTL
     C   KC
     COR KG              GOTO      ENDP
      *
     C                   GOTO      RSTRTA
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      **
