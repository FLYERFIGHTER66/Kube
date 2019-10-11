      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.       1999
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
      *PROGRAM NAME-------- APR275
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- CHANGE DUE DATES IN APOPN FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPR275FM  CF   E             WORKSTN
     FFAPOPN    UF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMTERM    IF   E           K DISK
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
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       88
     C                   Z-ADD     0             VVOUCH
     C                   MOVEL     *BLANKS       VINV#
     C                   MOVEL     *BLANKS       VTYPE
     C                   Z-ADD     0             VIDATE
     C                   Z-ADD     0             VDDATE
     C                   Z-ADD     0             VAMT
     C                   Z-ADD     0             CNT               2 0
     C                   MOVEL     *BLANKS       VMNAME
     C                   Z-ADD     *ZEROS        VVEND
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       101220
     C                   SETOFF                                       304041
     C                   SETOFF                                       425060
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
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1012
     C   10              GOTO      NXTA
      *
     C   KD              DO
     C                   Z-ADD     VVEND         APVEND
     C                   CALL      'LKAPOPN'
     C                   PARM                    APVEND            6 0
     C                   PARM                    VCO               2 0
     C                   PARM                    APVOUC            6 0
     C                   PARM                    APINV#           10
     C                   PARM                    APITYP            1
     C                   PARM                    APSEQ#            3 0
     C                   PARM                    APTDES           30
     C                   MOVEL     APVOUC        VVOUCH
     C                   MOVEL     APINV#        VINV#
     C                   MOVEL     APITYP        VTYPE
     C                   MOVEL     '001'         SEQ               3
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VVOUCH        IFEQ      *ZEROS
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VINV#         IFEQ      *BLANKS
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VTYPE         IFEQ      'I'
     C                   SETON                                        4042
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VTYPE         IFNE      ' '
     C     VTYPE         ANDNE     'F'
     C     VTYPE         ANDNE     'C'
     C                   SETON                                        4041
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     0             VSEQ              3 0
     C     APKEY         KLIST
     C                   KFLD                    VVEND
     C                   KFLD                    VCO
     C                   KFLD                    VVOUCH
     C                   KFLD                    VINV#
     C                   KFLD                    VSEQ
     C                   KFLD                    VTYPE
     C     APKEY         CHAIN     FAPOPN                             92
     C   92              SETON                                        6012
     C   60              GOTO      NXTA
      *
     C     VMTMCD        CHAIN     FMTERM                             91
      *
     C                   Z-ADD     APDUDT        VIDATE
     C                   Z-ADD     APDCDT        VDDATE
     C                   Z-ADD     APDAVL        VAMT
      *
     C     NXTB          TAG
     C                   Z-ADD     0             CNT
     C   99              SETOFF                                       88
     C                   WRITE     SCRNB
     C                   SETOFF                                       101112
     C                   SETOFF                                       202130
     C                   SETOFF                                       313260
     C                   SETOFF                                       99
     C                   READ      SCRNB                                  90
      *
     C   KF              GOTO      RSTRTA
      *
     C                   Z-ADD     VIDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        101199
     C                   GOTO      NXTB
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         IDATE             6 0
      *
     C                   Z-ADD     VIDATE        APDUDT
     C     VIDATE        MULT      10000.01      RVDATE            6 0
     C                   MOVEL     RVDATE        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     19            CYR               2 0
     C                   ELSE
     C                   MOVEL     20            CYR
     C                   ENDIF
     C                   MOVEL     CYR           APRVDU
     C                   MOVE      RVDATE        APRVDU
      *
     C     OIDATE        IFNE      VIDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VIDATE        OIDATE            6 0
      *
     C     VDDATE        IFGT      0
     C                   Z-ADD     VDDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   ENDIF
     C     VDDATE        IFGT      0
     C     ##ERR         ANDEQ     'Y'
     C                   SETON                                        202199
     C                   GOTO      NXTB
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DDATE             6 0
      *
     C     VDDATE        IFGT      0
     C                   Z-ADD     VDDATE        APDCDT
     C                   ENDIF
      *
     C     ODDATE        IFNE      VDDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VDDATE        ODDATE            6 0
      *
     C     IDATE         IFLT      DDATE
     C                   SETON                                        121199
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     APDCDT        IFEQ      0
     C                   Z-ADD     0             VAMT
     C                   ENDIF
      *
     C     VAMT          IFGT      0
     C     APDCDT        ANDEQ     0
     C                   SETON                                        303199
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VAMT          IFGT      0
     C     VAMT          ANDGE     APDUE$
     C                   SETON                                        303299
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   Z-ADD     VAMT          APDAVL
      *
     C     OAMT          IFNE      VAMT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VAMT          OAMT              7 2
      *
     C     CNT           IFGT      0
     C                   SETON                                        88
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   UPDATE    RAPOPN
     C                   GOTO      RSTRTA
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           VCO               2 0
      *
     C                   ENDSR
