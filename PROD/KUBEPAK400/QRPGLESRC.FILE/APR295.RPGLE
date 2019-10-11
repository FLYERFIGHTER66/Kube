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
      *PROGRAM NAME-------- APR295
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- PUT AN OPEN PAYABLE ON HOLD
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FAPR295FM  CF   E             WORKSTN
     FFAPOPN    UF   E           K DISK
     FFMVEND    IF   E           K DISK
      *
     D MSG             S              8    DIM(2) CTDATA PERRCD(1)
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
     C                   Z-ADD     LCO           VCO               2 0
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       88
     C                   Z-ADD     0             VVOUCH
     C                   MOVEL     *BLANKS       VINV#
     C                   MOVEL     *BLANKS       VTYPE
     C                   Z-ADD     0             CNT               2 0
     C                   MOVEL     *BLANKS       VMNAME
     C                   Z-ADD     0             VVEND
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101220
     C                   SETOFF                                       304050
     C                   SETOFF                                       6077
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C     VVEND         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     VCO           VMCOMP            2 0
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
     C     VVEND         IFEQ      0
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
     C                   Z-ADD     0             SEQ               3 0
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VVOUCH        IFEQ      0
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VINV#         IFEQ      *BLANKS
     C                   SETON                                        40
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VTYPE         IFNE      ' '
     C     VTYPE         ANDNE     'F'
     C     VTYPE         ANDNE     'C'
     C                   SETON                                        50
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     APKEY         KLIST
     C                   KFLD                    VVEND
     C                   KFLD                    VCO
     C                   KFLD                    VVOUCH
     C                   KFLD                    VINV#
     C                   KFLD                    APSEQ#
     C                   KFLD                    VTYPE
     C     APKEY         CHAIN     FAPOPN                             92
     C   92              SETON                                        6012
     C   60              GOTO      NXTA
      *
     C     APTBPD        IFEQ      'Y'
     C                   SETON                                        7712
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     APTBPD        IFEQ      'H'
     C                   MOVEL     MSG(1)        STATUS
     C                   ELSE
     C                   MOVEL     MSG(2)        STATUS
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   ADD       1             CNT
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       10
     C                   READ      SCRNB                                  90
      *
     C                   SETOFF                                       90
     C   KF              GOTO      RSTRTA
      *
     C     VHOLD         IFNE      'Y'
     C     VHOLD         ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C                   SETON                                        88
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VHOLD         IFEQ      'Y'
     C                   MOVEL     'H'           APTBPD
     C                   ENDIF
     C     VHOLD         IFEQ      'N'
     C                   MOVEL     ' '           APTBPD
     C                   ENDIF
     C                   UPDATE    RAPOPN
      *
     C                   GOTO      RSTRTA
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
**
On Hold
Not Held
