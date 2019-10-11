      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.         1999
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
      *PROGRAM NAME-------- APR245
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- VENDOR PAYMENT HISTORY INQUIRY.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPR245FM  CF   E             WORKSTN
     F                                     SFILE(PMTSFL:RECNO)
     FFAPDTPVD  IF   E           K DISK
     FFMVEND    IF   E           K DISK
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
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       VMNAME
     C                   Z-ADD     0             VVEND
     C                   Z-ADD     0             TPAID
     C                   Z-ADD     0             VDATE
     C                   Z-ADD     0             RDATE
     C                   MOVEL     *BLANKS       VINV#
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             RDATE
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
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C     Search        AndNe     *BLANKS
    ?C                   Call      'LKVEND'
    ?C                   Parm                    Search                         ?
    ?C                   Parm                    Account           6            ?
     C                   Move      Account       VVEND
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
     C     VDATE         IFGT      0
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RDATE             7 0
     C                   ENDIF
     C     VDATE         IFGT      0
     C     ##ERR         ANDEQ     'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VINV#         IFGT      *BLANKS
     C                   SETON                                        77
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      ENDP
      *
     C     VVEND         SETLL     FAPDTPVD
     C                   MOVE      '1'           *IN80
     C                   WRITE     PMTCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C                   SETOFF                                       90
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      ENDP
      *
     C     NXTP          TAG
     C     VVEND         READE     FAPDTPVD                               90
     C   90              GOTO      DSPL2
      *
     C     ATCOMP        IFNE      LCO                                                      #
     C                   GOTO      NXTP
     C                   ENDIF
      *
     C   77ATINV#        IFNE      VINV#                                                    #
     C                   GOTO      NXTP
     C                   ENDIF
      *
     C     VDATE         IFGT      0
     C     ATCYMD        ANDGT     RDATE
     C                   GOTO      NXTP
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   WRITE     PMTSFL
     C                   ADD       ATPAID        TPAID             9 2
     C                   GOTO      NXTP
      *
     C     DSPL2         TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             ATVOUC
     C                   Z-ADD     0             ATCKDT
     C                   MOVEL     *BLANKS       ATINV#
     C                   MOVEL     *BLANKS       ATITYP
     C                   Z-ADD     0             ATCHEK
     C                   MOVEL     *BLANKS       ATDESC
     C                   Z-ADD     TPAID         ATPAID
     C                   MOVEL     '* Total '    DESC1            10
     C                   MOVE      '* '          DESC1
     C                   MOVE      DESC1         ATDESC
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
