      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDE      RED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXC      EPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *----------------------------------------------------------      ----
      *PROGRAM NAME-------- BIR009
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE DEPARTMENTS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR009FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMDEPT    UF A E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMCORG    IF   E           K DISK
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
     D  LLIST                  1      1
     D  LCANCL               133    133
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222388
     C                   SETOFF                                       98
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     1             SUBST     VDEPT:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VDEPT         DEDEPT            3
     C                   CALL      'LKDEPT'
     C                   PARM                    DEDEPT
     C                   PARM                    DEDESC           30
     C                   MOVEL     *BLANKS       VDEPT
     C                   MOVEL     DEDEPT        VDEPT
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
      * VALIDATE DEPARTMENT
      *
     C     VDEPT         CHAIN     FMDEPT                             96
      *
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        2022
     C   22              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        2023
     C   23              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        88
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     'N'           DECCAL
     C                   MOVEL     'N'           DEALL
     C                   MOVEL     'N'           DEAPCK
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   Z-ADD     0             CNT               2 0
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       103035
     C                   SETOFF                                       363740
     C                   SETOFF                                       414250
     C                   SETOFF                                       556045
     C                   SETOFF                                       5152
     C                   SETOFF                                       6263
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRT
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              EXSR      OUTREC
     C   KX              EXSR      CLRIT
     C                   GOTO      NXTA
      *
     C     NODEL         TAG
      *
      * TEST DESCRIPTION
      *
     C     DEDESC        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     DESHFR        IFEQ      *BLANKS
     C                   GOTO      NOSHFR
     C                   ENDIF
      *
     C     1             SUBST     DESHFR:1      VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     DESHFR        WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       DESHFR
     C                   MOVEL     WHWHSE        DESHFR
     C                   MOVEL     WHDESC        SDESC            30
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     DESHFR        CHAIN     FMWHSE                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTB
      *
     C     NOSHFR        TAG
      *
     C     DECCAL        IFNE      'Y'
     C     DECCAL        ANDNE     'N'
     C                   SETON                                        35
     C   35              GOTO      NXTB
     C                   ENDIF
      *
     C     DECCAL        IFEQ      'N'
     C     DECANC        ANDGT     0
     C                   SETON                                        36
     C   36              GOTO      NXTB
     C                   ENDIF
      *
     C     DECCAL        IFEQ      'N'
     C     DECCDE        ANDGT     *BLANKS
     C                   SETON                                        37
     C   37              GOTO      NXTB
     C                   ENDIF
      *
     C     DEMINP        IFGT      5
     C                   SETON                                        4041
     C   41              GOTO      NXTB
     C                   ENDIF
      *
     C     DEMAXP        IFGT      5
     C                   SETON                                        45
     C   45              GOTO      NXTB
     C                   ENDIF
      *
     C     DEMINP        IFEQ      0
     C     DEMAXP        ANDEQ     0
     C                   GOTO      NOCHK
     C                   ENDIF
      *
     C     DEMINP        IFEQ      DEMAXP
     C                   SETON                                        4042
     C   42              GOTO      NXTB
     C                   ENDIF
      *
      *
     C     DEOVR1        IFGT      *BLANKS
     C     DEOVR1        CHAIN     FMUSER                             92
     C   92              SETON                                        5051
     C   51              GOTO      NXTB
     C                   ENDIF
      *
     C     DEOVR1        IFEQ      *BLANKS
     C                   SETON                                        5052
     C   52              GOTO      NXTB
     C                   ENDIF
      *
     C     DEOVR2        IFGT      *BLANKS
     C     DEOVR2        CHAIN     FMUSER                             92
     C   92              SETON                                        55
     C   55              GOTO      NXTB
     C                   ENDIF
      *
     C     NOCHK         TAG
      *
     C     DEAPCK        IFNE      'Y'
     C     DEAPCK        ANDNE     'N'
     C                   SETON                                        60
     C   60              GOTO      NXTB
     C                   ENDIF
      *
     C     DEALL         IFNE      'Y'
     C     DEALL         ANDNE     'N'
     C                   SETON                                        62
     C   62              GOTO      NXTB
     C                   ENDIF
      *
     C     DECONO        IFGT      0
     C     DECONO        CHAIN     FMCORG                             90
     C   90              SETON                                        63
     C   63              GOTO      NXTB
     C                   ENDIF
      *
     C                   ADD       1             CNT
     C     CNT           IFEQ      1
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVEL     VDEPT         DEDEPT
     C     VACT          IFEQ      'A'
     C                   WRITE     RMDEPT
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMDEPT
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMDEPT
     C                   ENDIF
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       99
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VDEPT
     C                   MOVE      *BLANKS       DEDESC
     C                   MOVEL     *BLANKS       DEPINV
     C                   MOVEL     *BLANKS       DEPPCK
     C                   MOVEL     *BLANKS       DEPPC2
     C                   MOVEL     *BLANKS       DEPREP
     C                   MOVEL     *BLANKS       DEPPO
     C                   MOVEL     *BLANKS       DECCDE
     C                   MOVEL     *BLANKS       DEOVR1
     C                   MOVEL     *BLANKS       DEOVR2
     C                   MOVEL     *BLANKS       DECCAL
     C                   MOVEL     *BLANKS       DEAPCK
     C                   MOVEL     *BLANKS       DEALL
     C                   Z-ADD     *ZEROS        DECANC
     C                   Z-ADD     *ZEROS        DEMINP
     C                   Z-ADD     *ZEROS        DEMAXP
     C                   Z-ADD     *ZEROS        DECONO
     C                   ENDSR
      *
