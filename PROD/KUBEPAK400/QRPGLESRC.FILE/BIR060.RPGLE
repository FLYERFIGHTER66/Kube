      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRIS   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR060
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- MAINTAIN PRODUCT CLASS/CUSTOMER TYPE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR060FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMPCLS    UF A E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMCTYP    IF   E           K DISK
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
     D  LLIST                  1      1
     D  LCANCL               133    133
      *
     C     1000000000    MULT      10            LIMIT            12 1
     C                   SUB       .1            LIMIT
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       98
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     *BLANKS       VTYPE
     C                   MOVEL     *BLANKS       TDESC
     C                   MOVEL     *BLANKS       PDESC
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             PCPQN1
     C                   Z-ADD     0             PCPQN2
     C                   Z-ADD     0             PCPQN3
     C                   Z-ADD     0             PCPQN4
     C                   Z-ADD     0             PCPQN5
     C                   Z-ADD     0             PCPQN6
     C                   Z-ADD     0             PCPQN7
     C                   Z-ADD     0             PCPQN8
     C                   Z-ADD     0             PCPQN9
     C                   Z-ADD     0             PCPQN0
     C                   Z-ADD     0             PCPCT1
     C                   Z-ADD     0             PCPCT2
     C                   Z-ADD     0             PCPCT3
     C                   Z-ADD     0             PCPCT4
     C                   Z-ADD     0             PCPCT5
     C                   Z-ADD     0             PCPCT6
     C                   Z-ADD     0             PCPCT7
     C                   Z-ADD     0             PCPCT8
     C                   Z-ADD     0             PCPCT9
     C                   Z-ADD     0             PCPCT0
     C                   Z-ADD     0             PCPC$1
     C                   Z-ADD     0             PCPC$2
     C                   Z-ADD     0             PCPC$3
     C                   Z-ADD     0             PCPC$4
     C                   Z-ADD     0             PCPC$5
     C                   Z-ADD     0             PCPC$6
     C                   Z-ADD     0             PCPC$7
     C                   Z-ADD     0             PCPC$8
     C                   Z-ADD     0             PCPC$9
     C                   Z-ADD     0             PCPC$0
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       101112
     C                   SETOFF                                       132030
     C                   SETOFF                                       616277
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C     1             SUBST     VPRCL:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        PDESC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     VTYPE:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     VTYPE         CTTYPE            2
     C                   CALL      'LKTYPE'
     C                   PARM                    CTTYPE
     C                   PARM                    CTDESC           30
     C                   MOVEL     *BLANKS       VTYPE
     C                   MOVEL     CTTYPE        VTYPE
     C                   MOVEL     CTDESC        TDESC
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        1011
     C   11              GOTO      NXTA
     C     VACTOK        TAG
      *
      * VALIDATE PRODUCT CLASS
      *
     C     VPRCL         CHAIN     FMPRCL                             96
     C   96              SETON                                        20
     C   96              WRITE     SCRNA
     C   96              READ      SCRNA                                  88
     C   20              GOTO      NXTA
     C                   MOVEL     PCDESC        PDESC
      *
      * VALIDATE TYPE CODE
      *
     C     VTYPE         CHAIN     FMCTYP                             95
     C   95              SETON                                        30
     C   30              GOTO      NXTA
     C                   MOVEL     CTDESC        TDESC
      *
     C     KEYC          KLIST
     C                   KFLD                    VPRCL
     C                   KFLD                    VTYPE
     C     KEYC          CHAIN     FMPCLS                             91
      *
     C  N91VACT          IFEQ      'A'
     C                   SETON                                        1061
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   91VACT          IFNE      'A'
     C                   SETON                                        1062
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        77
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       395051
     C                   SETOFF                                       525354
     C                   SETOFF                                       555657
     C                   SETOFF                                       5859
     C                   SETOFF                                       9091
     C                   SETOFF                                       98
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              DELETE    RMPCLS
     C   KX              GOTO      RSTRTA
     C                   GOTO      RSTRTA
      *
     C     NODEL         TAG
      *
      * QTY 1
      *
     C     PCPQN1        IFEQ      *ZEROS
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPCT1        IFEQ      *ZEROS
     C     PCPC$1        ANDEQ     *ZEROS
     C                   SETON                                        31
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPCT1        IFGT      *ZEROS
     C     PCPC$1        ANDGT     *ZEROS
     C                   SETON                                        31
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN1        IFNE      OQ1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN1        OQ1              11 1
      *
     C     PCPQN1        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 2
      *
     C*          PCPQN1    IFNE LIMIT
     C     PCPQN2        IFLE      PCPQN1
     C                   SETON                                        32
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN2        IFGT      *ZEROS
     C     PCPCT2        ANDEQ     *ZEROS
     C     PCPC$2        ANDEQ     *ZEROS
     C                   SETON                                        33
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN2        IFGT      *ZEROS
     C     PCPCT2        ANDGT     *ZEROS
     C     PCPC$2        ANDGT     *ZEROS
     C                   SETON                                        33
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN2        IFNE      OQ2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN2        OQ2              11 1
      *
     C     PCPQN2        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 3
      *
     C     PCPQN2        IFNE      LIMIT
     C     PCPQN3        ANDLE     PCPQN2
     C                   SETON                                        34
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN3        IFGT      *ZEROS
     C     PCPCT3        ANDEQ     *ZEROS
     C     PCPC$3        ANDEQ     *ZEROS
     C                   SETON                                        35
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN3        IFGT      *ZEROS
     C     PCPCT3        ANDGT     *ZEROS
     C     PCPC$3        ANDGT     *ZEROS
     C                   SETON                                        35
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN3        IFNE      OQ3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN3        OQ3              11 1
      *
     C     PCPQN3        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 4
      *
     C     PCPQN3        IFNE      LIMIT
     C     PCPQN4        ANDLE     PCPQN3
     C                   SETON                                        36
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN4        IFGT      *ZEROS
     C     PCPCT4        ANDEQ     *ZEROS
     C     PCPC$4        ANDEQ     *ZEROS
     C                   SETON                                        37
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN4        IFGT      *ZEROS
     C     PCPCT4        ANDGT     *ZEROS
     C     PCPC$4        ANDGT     *ZEROS
     C                   SETON                                        37
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN4        IFNE      OQ4
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN4        OQ4              11 1
      *
     C     PCPQN4        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 5
      *
     C     PCPQN4        IFNE      LIMIT
     C     PCPQN5        ANDLE     PCPQN4
     C                   SETON                                        38
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN5        IFGT      *ZEROS
     C     PCPCT5        ANDEQ     *ZEROS
     C     PCPC$5        ANDEQ     *ZEROS
     C                   SETON                                        39
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN5        IFGT      *ZEROS
     C     PCPCT5        ANDGT     *ZEROS
     C     PCPC$5        ANDGT     *ZEROS
     C                   SETON                                        39
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN5        IFNE      OQ5
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN5        OQ5              11 1
      *
     C     PCPQN5        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 6
      *
     C     PCPQN5        IFNE      LIMIT
     C     PCPQN6        ANDLE     PCPQN5
     C                   SETON                                        50
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN6        IFGT      *ZEROS
     C     PCPCT6        ANDEQ     *ZEROS
     C     PCPC$6        ANDEQ     *ZEROS
     C                   SETON                                        51
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN6        IFGT      *ZEROS
     C     PCPCT6        ANDGT     *ZEROS
     C     PCPC$6        ANDGT     *ZEROS
     C                   SETON                                        51
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN6        IFNE      OQ6
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN6        OQ6              11 1
      *
     C     PCPQN6        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 7
      *
     C     PCPQN6        IFGT      0
     C     PCPQN6        ANDNE     LIMIT
     C     PCPQN7        ANDLE     PCPQN6
     C                   SETON                                        52
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN7        IFGT      *ZEROS
     C     PCPCT7        ANDEQ     *ZEROS
     C     PCPC$7        ANDEQ     *ZEROS
     C                   SETON                                        53
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN7        IFGT      *ZEROS
     C     PCPCT7        ANDGT     *ZEROS
     C     PCPC$7        ANDGT     *ZEROS
     C                   SETON                                        53
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN7        IFNE      OQ7
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN7        OQ7              11 1
      *
     C     PCPQN7        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 8
      *
     C     PCPQN7        IFGT      0
     C     PCPQN7        ANDNE     LIMIT
     C     PCPQN8        ANDLE     PCPQN7
     C                   SETON                                        54
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN8        IFGT      *ZEROS
     C     PCPCT8        ANDEQ     *ZEROS
     C     PCPC$8        ANDEQ     *ZEROS
     C                   SETON                                        55
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN8        IFGT      *ZEROS
     C     PCPCT8        ANDGT     *ZEROS
     C     PCPC$8        ANDGT     *ZEROS
     C                   SETON                                        55
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN8        IFNE      OQ8
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN8        OQ8              11 1
      *
     C     PCPQN8        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 9
      *
     C     PCPQN8        IFGT      0
     C     PCPQN8        ANDNE     LIMIT
     C     PCPQN9        ANDLE     PCPQN8
     C                   SETON                                        56
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN9        IFGT      *ZEROS
     C     PCPCT9        ANDEQ     *ZEROS
     C     PCPC$9        ANDEQ     *ZEROS
     C                   SETON                                        57
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN9        IFGT      *ZEROS
     C     PCPCT9        ANDGT     *ZEROS
     C     PCPC$9        ANDGT     *ZEROS
     C                   SETON                                        57
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN9        IFNE      OQ9
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN9        OQ9              11 1
      *
     C     PCPQN9        IFEQ      LIMIT
     C                   GOTO      ENDCK
     C                   ENDIF
      *
      * QTY 10
      *
     C     PCPQN9        IFGT      0
     C     PCPQN9        ANDNE     LIMIT
     C     PCPQN0        ANDNE     LIMIT
     C                   SETON                                        58
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN0        IFGT      *ZEROS
     C     PCPCT0        ANDEQ     *ZEROS
     C     PCPC$0        ANDEQ     *ZEROS
     C                   SETON                                        59
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN0        IFGT      *ZEROS
     C     PCPCT0        ANDGT     *ZEROS
     C     PCPC$0        ANDGT     *ZEROS
     C                   SETON                                        59
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     PCPQN0        IFNE      OQ0
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     PCPQN0        OQ0              11 1
      *
     C     ENDCK         TAG
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
      * OUTPUT RECORD
      *
     C                   MOVEL     VPRCL         PCPCL2
     C                   MOVEL     VTYPE         PCCTYP
     C     VACT          IFEQ      'A'
     C                   WRITE     RMPCLS
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMPCLS
     C                   ENDIF
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C                   SETON                                        LR
      *
