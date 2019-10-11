    ?H/COPY QFunctDefn,@CopyRight
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- GRS020
      *SYSTEM-------------- PRODUCTION MASTER FILES
      *APPLICATION--------- PRODUCTION TABLE MASTER FILE MAINTENANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFPTABLE   UF A E           K DISK
     FGRS020FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     D MSG             S             20    DIM(5) CTDATA PERRCD(1)
      *
      * PROGRAM MAINLINE
      *
    ?D/COPY QFunctDefn,QCMDEXC

     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131499
     C                   SETOFF                                       1516
     C                   SETOFF                                       909192
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
      *
     C     1             SUBST     VTABID:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     *BLANKS       PTABID            2
     C                   CALL      'LKFACT'
     C                   PARM                    PTABID
     C                   PARM                    PTDESC           30
     C                   MOVEL     *BLANKS       VTABID
     C                   MOVEL     PTABID        VTABID
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C     VACT          OREQ      'R'
     C     VACT          OREQ      'I'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        1099
     C   10
     CAN 99              GOTO      RSTRTA
     C     VACTOK        TAG
      *
      * TEST TABLE ID
      *
     C     VTABID        IFEQ      *BLANKS
     C                   SETON                                        111499
     C   11
     CAN 99              GOTO      RSTRTA
     C                   ENDIF
      *
     C                   MOVEL     VTABID        PTABID
     C*          KEY3      KLIST
     C*                    KFLD           VTABID
     C     PTABID        CHAIN     FPTABLE                            90
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
     C     VACT          IFNE      'R'
     C     PTSTAT        ANDEQ     'D'
     C                   SETON                                        151499
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        131499
     C   99              EXSR      CLRIT
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
     C     ENDA          TAG
      *
      *      LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE            10
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'R'
     C                   MOVEL     MSG(4)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'I'
     C                   MOVEL     MSG(5)        VMODE
     C                   SETON                                        50
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       2918
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       394041
     C                   SETOFF                                       424344
     C                   SETOFF                                       454647
     C                   SETOFF                                       484950
     C                   SETOFF                                       515253
     C                   SETOFF                                       545556
     C                   SETOFF                                       575859
     C                   SETOFF                                       606162
     C                   SETOFF                                       636465
     C                   SETOFF                                       666768
     C                   SETOFF                                       697071
     C                   SETOFF                                       727374
     C                   SETOFF                                       757677
     C                   SETOFF                                       787980
     C                   SETOFF                                       818283
     C                   SETOFF                                       848583
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C     PTDESC        IFEQ      *BLANKS
     C                   SETON                                        18
     C                   ENDIF
      *
      * TEST AT LEAST ONE FACTOR ENTERED
      *
     C     PTBQ01        IFEQ      *ZEROS
     C     PTEQ01        OREQ      *ZEROS
     C                   SETON                                        2029
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ01        IFGT      PTEQ01
     C                   SETON                                        2129
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN01        IFGT      *ZEROS
     C     PTPE01        ANDGT     *ZEROS
     C                   SETON                                        22
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN01        IFEQ      *ZEROS
     C     PTPE01        ANDEQ     *ZEROS
     C                   SETON                                        22
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ02        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ02        IFLT      PTEQ01
     C                   SETON                                        3335
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ02        IFGT      PTEQ02
     C                   SETON                                        3135
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN02        IFGT      *ZEROS
     C     PTPE02        ANDGT     *ZEROS
     C                   SETON                                        32
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN02        IFEQ      *ZEROS
     C     PTPE02        ANDEQ     *ZEROS
     C                   SETON                                        32
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     PTBQ03        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ03        IFLT      PTEQ02
     C                   SETON                                        3839
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ03        IFGT      PTEQ03
     C                   SETON                                        3639
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN03        IFGT      *ZEROS
     C     PTPE03        ANDGT     *ZEROS
     C                   SETON                                        37
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN03        IFEQ      *ZEROS
     C     PTPE03        ANDEQ     *ZEROS
     C                   SETON                                        37
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ04        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ04        IFLT      PTEQ03
     C                   SETON                                        4345
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ04        IFGT      PTEQ04
     C                   SETON                                        4145
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN04        IFGT      *ZEROS
     C     PTPE04        ANDGT     *ZEROS
     C                   SETON                                        42
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN04        IFEQ      *ZEROS
     C     PTPE04        ANDEQ     *ZEROS
     C                   SETON                                        42
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ05        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ05        IFLT      PTEQ04
     C                   SETON                                        4849
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ05        IFGT      PTEQ05
     C                   SETON                                        4649
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN05        IFGT      *ZEROS
     C     PTPE05        ANDGT     *ZEROS
     C                   SETON                                        47
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN05        IFEQ      *ZEROS
     C     PTPE05        ANDEQ     *ZEROS
     C                   SETON                                        47
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ06        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ06        IFLT      PTEQ05
     C                   SETON                                        5355
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ06        IFGT      PTEQ06
     C                   SETON                                        5155
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN06        IFGT      *ZEROS
     C     PTPE06        ANDGT     *ZEROS
     C                   SETON                                        52
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN06        IFEQ      *ZEROS
     C     PTPE06        ANDEQ     *ZEROS
     C                   SETON                                        52
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ07        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ07        IFLT      PTEQ06
     C                   SETON                                        5859
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ07        IFGT      PTEQ07
     C                   SETON                                        5659
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN07        IFGT      *ZEROS
     C     PTPE07        ANDGT     *ZEROS
     C                   SETON                                        57
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN07        IFEQ      *ZEROS
     C     PTPE07        ANDEQ     *ZEROS
     C                   SETON                                        57
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ08        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ08        IFLT      PTEQ07
     C                   SETON                                        6365
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ08        IFGT      PTEQ08
     C                   SETON                                        6165
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN08        IFGT      *ZEROS
     C     PTPE08        ANDGT     *ZEROS
     C                   SETON                                        62
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN08        IFEQ      *ZEROS
     C     PTPE08        ANDEQ     *ZEROS
     C                   SETON                                        62
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ09        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ09        IFLT      PTEQ08
     C                   SETON                                        6869
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ09        IFGT      PTEQ09
     C                   SETON                                        6669
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN09        IFGT      *ZEROS
     C     PTPE09        ANDGT     *ZEROS
     C                   SETON                                        67
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN09        IFEQ      *ZEROS
     C     PTPE09        ANDEQ     *ZEROS
     C                   SETON                                        67
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ10        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ10        IFLT      PTEQ09
     C                   SETON                                        7375
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ10        IFGT      PTEQ10
     C                   SETON                                        7175
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN10        IFGT      *ZEROS
     C     PTPE10        ANDGT     *ZEROS
     C                   SETON                                        72
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN10        IFEQ      *ZEROS
     C     PTPE10        ANDEQ     *ZEROS
     C                   SETON                                        72
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ11        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ11        IFLT      PTEQ10
     C                   SETON                                        7879
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ11        IFGT      PTEQ11
     C                   SETON                                        7679
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN11        IFGT      *ZEROS
     C     PTPE11        ANDGT     *ZEROS
     C                   SETON                                        77
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN11        IFEQ      *ZEROS
     C     PTPE11        ANDEQ     *ZEROS
     C                   SETON                                        77
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ12        IFEQ      *ZEROS
     C                   GOTO      NOMORE
     C                   ENDIF
      *
     C     PTBQ12        IFLT      PTEQ11
     C                   SETON                                        8385
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTBQ12        IFGT      PTEQ12
     C                   SETON                                        8185
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN12        IFGT      *ZEROS
     C     PTPE12        ANDGT     *ZEROS
     C                   SETON                                        82
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     PTUN12        IFEQ      *ZEROS
     C     PTPE12        ANDEQ     *ZEROS
     C                   SETON                                        82
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     NOMORE        TAG
      *
     C     CNT           IFGT      0
     C     VACT          ANDNE     'I'
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VACT          IFEQ      'I'
     C                   GOTO      ENDB
     C                   ENDIF
     C     VACT          IFEQ      'A'
     C                   WRITE     RPTABLE
     C                   GOTO      ENDB
     C                   ENDIF
     C     VACT          IFEQ      'R'
     C                   MOVEL     'A'           PTSTAT
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     'D'           PTSTAT
     C                   ENDIF
     C                   UPDATE    RPTABLE
     C     ENDB          TAG
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C*                  Call      '#SF_TEST'
     C                   CallP     QCmdExc('SBMJOB CMD(CALL PGM(#SF_TEST))':30)
      *
      *  CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VTABID
     C                   MOVE      *BLANKS       PTDESC
     C                   MOVE      *BLANKS       PTCTYP
     C                   MOVE      *ZEROS        PTBQ01
     C                   MOVE      *ZEROS        PTBQ02
     C                   MOVE      *ZEROS        PTBQ03
     C                   MOVE      *ZEROS        PTBQ04
     C                   MOVE      *ZEROS        PTBQ05
     C                   MOVE      *ZEROS        PTBQ06
     C                   MOVE      *ZEROS        PTBQ07
     C                   MOVE      *ZEROS        PTBQ08
     C                   MOVE      *ZEROS        PTBQ09
     C                   MOVE      *ZEROS        PTBQ10
     C                   MOVE      *ZEROS        PTBQ11
     C                   MOVE      *ZEROS        PTBQ12
     C                   MOVE      *ZEROS        PTEQ01
     C                   MOVE      *ZEROS        PTEQ02
     C                   MOVE      *ZEROS        PTEQ03
     C                   MOVE      *ZEROS        PTEQ04
     C                   MOVE      *ZEROS        PTEQ05
     C                   MOVE      *ZEROS        PTEQ06
     C                   MOVE      *ZEROS        PTEQ07
     C                   MOVE      *ZEROS        PTEQ08
     C                   MOVE      *ZEROS        PTEQ09
     C                   MOVE      *ZEROS        PTEQ10
     C                   MOVE      *ZEROS        PTEQ11
     C                   MOVE      *ZEROS        PTEQ12
     C                   MOVE      *ZEROS        PTUN01
     C                   MOVE      *ZEROS        PTUN02
     C                   MOVE      *ZEROS        PTUN03
     C                   MOVE      *ZEROS        PTUN04
     C                   MOVE      *ZEROS        PTUN05
     C                   MOVE      *ZEROS        PTUN06
     C                   MOVE      *ZEROS        PTUN07
     C                   MOVE      *ZEROS        PTUN08
     C                   MOVE      *ZEROS        PTUN09
     C                   MOVE      *ZEROS        PTUN10
     C                   MOVE      *ZEROS        PTUN11
     C                   MOVE      *ZEROS        PTUN12
     C                   MOVE      *ZEROS        PTPE01
     C                   MOVE      *ZEROS        PTPE02
     C                   MOVE      *ZEROS        PTPE03
     C                   MOVE      *ZEROS        PTPE04
     C                   MOVE      *ZEROS        PTPE05
     C                   MOVE      *ZEROS        PTPE06
     C                   MOVE      *ZEROS        PTPE07
     C                   MOVE      *ZEROS        PTPE08
     C                   MOVE      *ZEROS        PTPE09
     C                   MOVE      *ZEROS        PTPE10
     C                   MOVE      *ZEROS        PTPE11
     C                   MOVE      *ZEROS        PTPE12
     C     ECLR          ENDSR
**
   Add
  Change
  Delete
Reactivate
 Inquiry
