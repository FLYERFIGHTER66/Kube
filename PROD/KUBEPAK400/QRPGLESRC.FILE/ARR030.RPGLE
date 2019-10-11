      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- ARR030
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- SALESPERSON MASTER FILE MAINTENANCE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSLSM    UF A E           K DISK
     FFMTERR    IF   E           K DISK
     FFMSTAT    IF   E           K DISK
     FARR030FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     D MSG             S             20    DIM(5) CTDATA PERRCD(1)
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
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C                   UNLOCK    FMSLSM
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131499
     C                   SETOFF                                       151650
     C                   SETOFF                                       909192
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C   KM              MOVEL     'X'           LLIST
     C   KM              GOTO      END
      *
      * SALESPERSON  LOOKUP
      *
     C     1             SUBST     VSLS:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VSLS          SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLS
     C                   MOVEL     SMSLSM        VSLS
     C                   MOVEL     SMNAME        SNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C     VACT          OREQ      'I'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        1099
     C   10
     CAN 99              GOTO      RSTRTA
     C     VACTOK        TAG
      *
      * TEST SALESPERSON CODE
      *
     C     VSLS          IFEQ      *BLANKS
     C                   SETON                                        111499
     C   11
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VSLS          SMSLSM            2
     C     KEY2          KLIST
     C                   KFLD                    SMSLSM
     C     KEY2          CHAIN     FMSLSM                             90
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        121499
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C   90VACT          IFEQ      'A'
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        131499
     C*  99                EXSR CLRIT
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        1650
     C                   ENDIF
      *
     C     VACT          IFEQ      'I'
     C                   SETON                                        50
     C                   ENDIF
      *
     C     ENDA          TAG
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     'N'           SMAGNT
     C                   MOVEL     MSG(1)        VMODE            10
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'I'
     C                   MOVEL     MSG(4)        VMODE
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       349899
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              GOTO      NODEL
     C                   GOTO      RSTRTA
      *
     C     NODEL         TAG
      *
      * TEST FOR VALID TERRITORY
      *
     C     SMTERR        IFEQ      *BLANKS
     C                   SETON                                        2099
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     1             SUBST     SMTERR:1      VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     SMTERR        TETERR            2
     C                   CALL      'LKTERR'
     C                   PARM                    TETERR
     C                   PARM                    TEDESC           30
     C                   MOVEL     *BLANKS       SMTERR
     C                   MOVEL     TETERR        SMTERR
     C                   MOVEL     TEDESC        TENAME
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     SMTERR        CHAIN     FMTERR                             31
     C   31              SETON                                        202199
     C   21
     CAN 99              GOTO      RSTRTB
      *
     C     SMTERR        IFNE      OTERR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     SMTERR        OTERR             2
      *
      * TEST SALESPERSON NAME
      *
     C     SMNAME        IFEQ      *BLANKS
     C                   SETON                                        2399
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     SMNAME        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMADD2        IFNE      OADD2
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMADD3        IFNE      OADD3
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMADD4        IFNE      OADD4
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMCITY        IFNE      OCITY
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C                   MOVEL     SMNAME        ONAME            30
     C                   MOVEL     SMADD2        OADD2            30
     C                   MOVEL     SMADD3        OADD3            30
     C                   MOVEL     SMADD4        OADD4            30
     C                   MOVEL     SMCITY        OCITY            18
      *
      * TEST FOR STATE CODE VALID IF ENTERED
      *
     C     SMSTST        IFGT      *BLANKS
     C     SMSTST        CHAIN     FMSTAT                             34
     C   34              SETON                                        2499
     C   24
     CAN 99              GOTO      RSTRTB
     C                   ENDIF
      *
     C     SMSTST        IFNE      OSTST
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMZIP         IFNE      OZIP
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMPHON        IFNE      OPHON
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMFAX         IFNE      OFAX
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMCOMM        IFNE      OCOMM
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C                   MOVEL     SMSTST        OSTST             2
     C                   MOVEL     SMZIP         OZIP              9
     C                   MOVEL     SMPHON        OPHON            10 0
     C                   MOVEL     SMFAX         OFAX             10 0
     C                   Z-ADD     SMCOMM        OCOMM             5 2
     C                   MOVEL     SMEML         OEMAL            33
      *
      * TEST OUTSIDE AGENT
      *
     C     SMAGNT        IFNE      'Y'
     C     SMAGNT        ANDNE     'N'
     C                   SETON                                        2599
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     SMAGNT        IFNE      OAGNT
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C     SMEML         IFNE      OEMAL
     C                   ADD       1             CNT
     C                   ENDIF
      *
     C                   MOVEL     SMAGNT        OAGNT             1
      *
     C  N50CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * UPDATE SALESPERSON MASTER FILE ON DISK
      *
     C     VACT          IFEQ      'I'
     C                   GOTO      ENDB
     C                   ENDIF
     C     VACT          IFEQ      'A'
     C                   WRITE     RMSLSM
     C                   GOTO      ENDB
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMSLSM
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMSLSM
     C                   ENDIF
     C     ENDB          TAG
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *  CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VSLS
     C                   MOVE      *BLANKS       SMTERR
     C                   MOVE      *BLANKS       TENAME
     C                   MOVE      *BLANKS       SMNAME
     C                   MOVE      *BLANKS       SNAME
     C                   MOVE      *BLANKS       SMADD2
     C                   MOVE      *BLANKS       SMADD3
     C                   MOVE      *BLANKS       SMADD4
     C                   MOVE      *BLANKS       SMCITY
     C                   MOVE      *BLANKS       SMSTST
     C                   MOVE      *BLANKS       SMZIP
     C                   MOVE      *BLANKS       SMEML
     C                   Z-ADD     *ZEROS        SMPHON
     C                   Z-ADD     *ZEROS        SMFAX
     C                   Z-ADD     *ZEROS        SMCOMM
     C     ECLR          ENDSR
**
   Add
  Change
  Delete
  Inquire
