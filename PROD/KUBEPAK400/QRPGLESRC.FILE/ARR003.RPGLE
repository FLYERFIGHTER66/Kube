      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR003
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- ENTER/UPDATE CREDIT CARD MASTER FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FARR003FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMCRED    UF A E           K DISK
     FFMBANK    IF   E           K DISK
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
     D  LLIST                  3      3
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101219
     C                   SETOFF                                       202122
     C                   SETOFF                                       232427
     C                   SETOFF                                       66
      *
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     1             SUBST     VCODE:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VCODE         CCCODE
     C                   CALL      'LKCRED'
     C                   PARM                    CCCODE
     C                   PARM                    CCDESC
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     CCCODE        VCODE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C     VACT          OREQ      'I'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VCODE         CHAIN     FMCRED                             96
      *
     C     VCODE         IFEQ      *BLANKS
     C                   SETON                                        1912
     C   19              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        2712
     C   27              GOTO      NXTA
     C                   SETON                                        21
     C                   ENDIF
      *
     C   96VACT          IFNE      'A'
     C                   SETON                                        2012
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'C'
     C                   SETON                                        22
     C                   ENDIF
      *
     C     VACT          IFEQ      'I'
     C                   SETON                                        7724
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        8823
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     VACT          OREQ      'I'
     C                   SETON                                        66
     C                   ENDIF
      *
     C     RSTRTB        TAG
      *
     C     NXTB          TAG
     C                   Z-ADD     0             CNT               2 0
     C                   WRITE     SCRNB
     C                   SETOFF                                       575898
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
      *  KX = OKAY TO DEL
      *
     C   KX              GOTO      NODEL
     C                   GOTO      RSTRT
     C     NODEL         TAG
      *
      * TEST DESCRIPTION
      *
     C     CCDESC        IFEQ      *BLANKS
     C                   SETON                                        57
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     CCDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   MOVEL     CCDESC        ODESC            30
     C                   ENDIF
      *
     C     1             SUBST     CCBANK:1      VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     CCBANK        BACODE
     C                   CALL      'LKBANK'
     C                   PARM                    BACODE
     C                   PARM                    BADESC
     C                   MOVEL     *BLANKS       CCBANK
     C                   MOVEL     BACODE        CCBANK
     C                   MOVEL     BADESC        BDESC
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C  N66CCBANK        CHAIN     FMBANK                             90
     C   90              SETON                                        58
     C   58              GOTO      NXTB
      *
     C     CCBANK        IFNE      OBANK
     C                   ADD       1             CNT
     C                   MOVEL     CCBANK        OBANK             3
     C                   ENDIF
      *
     C  N66CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C   77              GOTO      RSTRT
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   SETON                                        LR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVEL     VCODE         CCCODE
     C                   Z-ADD     TDATE         CCDTLA
     C                   Z-ADD     TIMOD         CCTIME
     C                   MOVEL     USERID        CCUSER
     C   21              WRITE     RMCRED
     C   22              UPDATE    RMCRED
     C   23              DELETE    RMCRED
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       9977
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VCODE
     C                   MOVE      *BLANKS       CCDESC
     C                   MOVEL     *BLANKS       CCBANK
     C                   Z-ADD     0             CCTELE
     C                   ENDSR
      *
