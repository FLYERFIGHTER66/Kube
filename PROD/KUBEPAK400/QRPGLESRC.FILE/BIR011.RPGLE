      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF:
      *              EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR011
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- DEFINE COMPANY NAME
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR011FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMCORG    UF A E           K DISK
      *
      * WORK ARRAYS FOR NAME
     D NMI             S              1    DIM(30)                              NAME IN
     D NMO             S              1    DIM(30)                              NAME OUT
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
     C     RSTRT         TAG
     C                   EXSR      CLRIT
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1020
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      NXTA
     C     VACTOK        TAG
      *
      * MUST HAVE COMPANY NUMBER
      *
     C                   MOVE      LCO           LCOR              2
     C     LCOR          IFEQ      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * VALIDATE COMPANY NUMBER
      *
     C     LCO           CHAIN     FMCORG                             96
      *
     C  N96VACT          IFEQ      'A'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   96VACT          IFEQ      'C'
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCO           IFGT      0
     C                   SETOFF                                       98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       10
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     RGNAME        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     RGNAME        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGNAME        ONAME            30
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * CENTER NAME
     C                   MOVE      *BLANKS       NMI
     C                   MOVE      *BLANKS       NMO
     C                   MOVEA     RGNAME        NMI
     C                   MOVE      *BLANKS       RGNAMC
      *
      * FIND OUT HOW MANY BLANKS
      *
     C                   Z-ADD     30            X                 2 0
     C     NXTX2         TAG
     C     NMI(X)        IFLE      *BLANKS
     C                   SUB       1             X
     C                   GOTO      NXTX2
     C                   END
     C     X             IFLE      28
     C     30            SUB       X             X1                2 0
     C     X1            DIV       2             Y                 2 0
     C                   ADD       1             Y
     C                   Z-ADD     1             X
     C     NXTY2         TAG
     C                   MOVEL     NMI(X)        NMO(Y)
     C                   ADD       1             X
     C                   ADD       1             Y
     C     X             IFLE      30
     C     Y             ANDLE     30
     C                   GOTO      NXTY2
     C                   END
     C                   ELSE
     C                   MOVEA     NMI           NMO
     C                   END
     C                   MOVEA     NMO           RGNAMC
      *
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       10
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     RGNAME        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTC
     C                   ENDIF
      * CENTER NAME
     C                   MOVE      *BLANKS       NMI
     C                   MOVE      *BLANKS       NMO
     C                   MOVEA     RGNAME        NMI
     C                   MOVE      *BLANKS       RGNAMC
      *
      * FIND OUT HOW MANY BLANKS
      *
     C                   Z-ADD     30            X                 2 0
     C     NXTX1         TAG
     C     NMI(X)        IFLE      *BLANKS
     C                   SUB       1             X
     C                   GOTO      NXTX1
     C                   END
     C     X             IFLE      28
     C     30            SUB       X             X1                2 0
     C     X1            DIV       2             Y                 2 0
     C                   ADD       1             Y
     C                   Z-ADD     1             X
     C     NXTY          TAG
     C                   MOVEL     NMI(X)        NMO(Y)
     C                   ADD       1             X
     C                   ADD       1             Y
     C     X             IFLE      30
     C     Y             ANDLE     30
     C                   GOTO      NXTY
     C                   END
     C                   ELSE
     C                   MOVEA     NMI           NMO
     C                   END
     C                   MOVEA     NMO           RGNAMC
      *
     C     RGNAME        IFNE      ONAME
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGNAME        ONAME            30
      *
     C     RGADR1        IFNE      OADR1
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGADR1        OADR1            30
     C     RGADR2        IFNE      OADR2
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGADR2        OADR2            30
     C     RGADR3        IFNE      OADR3
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGADR3        OADR3            30
     C     RGCITY        IFNE      OCITY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGCITY        OCITY            18
     C     RGSTST        IFNE      OSTST
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGSTST        OSTST             2
     C     RGZIP         IFNE      OZIP
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGZIP         OZIP              9
     C     RGEML         IFNE      OEML
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGEML         OEML             33
     C     RGURL         IFNE      OURL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RGURL         OURL             50
     C     RGTEL         IFNE      OTEL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     RGTEL         OTEL             10 0
     C     RGFAX         IFNE      OFAX
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     RGFAX         OFAX             10 0
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   Z-ADD     LCO           RGCOMP
     C     VACT          IFEQ      'A'
     C                   WRITE     RMCORG
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMCORG
     C                   ENDIF
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       99
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       LCO
     C                   MOVE      *BLANKS       RGADR1
     C                   MOVE      *BLANKS       RGADR2
     C                   MOVE      *BLANKS       RGADR3
     C                   MOVE      *BLANKS       RGCITY
     C                   MOVE      *BLANKS       RGSTST
     C                   MOVE      *BLANKS       RGZIP
     C                   MOVE      *BLANKS       RGTEL
     C                   MOVE      *BLANKS       RGFAX
     C                   MOVE      *BLANKS       RGTXID
     C                   MOVE      *BLANKS       RGNAME
     C                   MOVE      *BLANKS       RGNAMC
     C                   ENDSR
      *
