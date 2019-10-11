      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       E F D ENTERPRISES,INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR730
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- YEAR-END PROCESSING MAINTAIN 1099 DATA
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFV1099    UF A E           K DISK
     FFMVEND    UF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FAPR730FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     C                   Z-ADD     1             CNT               2 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FAPCTL                             90
     C                   Z-ADD     AZPRCO        VCO
      *
     C     NXT           TAG
     C                   SETOFF                                       20
     C                   Z-ADD     *ZEROS        VVEND
     C                   Z-ADD     *ZEROS        YMPAID
      *
     C     NXTA          TAG
     C                   MOVEL     *BLANKS       VYORN
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       221521
     C                   SETOFF                                       30
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     01            VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   Z-ADD     VMVEND        VVEND
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1012
     C   10
     CAN 12              GOTO      NXTA
      *
     C     VYEAR         IFGT      2025                                                     L
     C     VYEAR         ORLT      1995                                                     L
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           IFEQ      *ZEROS
     C                   SETON                                        15
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCO           CHAIN     FMCORG                             90
     C   90              SETON                                        15
     C   15              GOTO      NXTA
      *
      *  CHECK IF V1099 RECORD FOR THIS VENDOR
      *
     C     VKEY          KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VVEND
     C     VKEY          CHAIN     FV1099                             90
     C   90              SETON                                        20
      *
     C   20VYORN         IFNE      'Y'
     C     VYORN         ANDNE     'N'
     C                   SETON                                        22
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VYORN         IFEQ      'N'
     C                   Z-ADD     *ZEROS        VVEND
     C                   SETOFF                                       20
     C                   GOTO      NXTA
     C                   ELSE
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   Z-ADD     1             CNT               2 0
     C                   WRITE     SCRNB
     C                   SETOFF                                       303132
     C                   SETOFF                                       4098
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      NXT
      *
     C     YMPAID        IFNE      OPAID
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     YMPAID        OPAID            11 2
      *
     C     VMTXID        IFNE      OTXID
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMTXID        OTXID             9
      *
     C     VMTXID        IFGT      *BLANKS
     C     VMTXCD        ANDNE     'F'
     C     VMTXCD        ANDNE     'S'
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMTXCD        IFNE      OTXCD
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMTXCD        OTXCD             1
      *
     C     VMFLAG        IFEQ      4
     C                   SETON                                        31
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VMFLAG        IFEQ      4
     C     VMFLAG        OREQ      0
     C                   GOTO      NOCHK
     C                   ENDIF
      *
     C     VMTXID        IFEQ      *BLANKS
     C                   SETON                                        40
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     NOCHK         TAG
     C     VMFLAG        IFNE      OFLAG
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VMFLAG        OFLAG             1 0
      *
     C     CNT           IFGT      1
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   MOVEL     'A'           YMSTAT
     C   20              Z-ADD     VCO           YMCONO
     C   20              Z-ADD     VVEND         YMVEND
     C   20              Z-ADD     VYEAR         YMYEAR
     C                   MOVEL     *BLANKS       YMPRTD
     C   20              WRITE     RYVEND
     C  N20              UPDATE    RYVEND
     C                   UPDATE    RMVEND
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
