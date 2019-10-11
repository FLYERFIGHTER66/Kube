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
      *PROGRAM NAME-------- ARR002
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- ENTER/UPDATE BANK MASTER FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 5/26/00 EFD01 CORRECT LINE # MOVE FIELD INTO OLD
      *
      *
     FARR002FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMBANK    UF A E           K DISK
     FFMCORG    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
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
     C                   Z-ADD     01            LCO
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101219
     C                   SETOFF                                       202122
     C                   SETOFF                                       232427
EFD01C                   SETOFF                                       66
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
     C                   MOVEL     VCODE         BACODE
     C                   CALL      'LKBANK'
     C                   PARM                    BACODE
     C                   PARM                    BADESC
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     BACODE        VCODE
     C                   MOVEL     BADESC        VDESC
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
     C     VCODE         CHAIN     FMBANK                             96
     C  N96              MOVEL     BADESC        VDESC
     C  N96              Z-ADD     BAGLNO        VGLNO
      *
     C     VCODE         IFEQ      *BLANKS
     C                   SETON                                        1912
     C   19              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   SETON                                        21
     C  N96              SETON                                        2712
     C   27              GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        2012
     C   20              GOTO      NXTA
     C                   ENDIF
      *
     C   21              MOVEL     *BLANKS       VDESC
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
     C     VACT          IFEQ      'C'
     C     VACT          OREQ      'I'
     C     VACT          OREQ      'D'
     C     GKEY          CHAIN     FMGLCH                             90
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   Z-ADD     0             CNT               2 0
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       102030
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
     C     VDESC         IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VDESC         IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
EFD01C                   MOVEL     VDESC         ODESC            30
      *
     C     LCO           IFEQ      0
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             90
     C   90              SETON                                        20
     C   10              GOTO      NXTB
      *
     C   KB              DO
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     LCO           VCO               2 0
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     GCGLNO        GLNO              8 0
     C                   Z-ADD     GLNO          VGLNO
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C     GKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VGLNO
EFD01C  N66GKEY          CHAIN     FMGLCH                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTB
      *
     C     VGLNO         IFNE      OGLNO
     C                   ADD       1             CNT
     C                   ENDIF
EFD01C                   MOVEL     VGLNO         OGLNO             8 0
      *
     C     CNT           IFEQ      1
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
     C                   MOVEL     VCODE         BACODE
     C                   Z-ADD     LCO           BACOMP
     C                   MOVEL     VDESC         BADESC
     C                   Z-ADD     VGLNO         BAGLNO
     C                   Z-ADD     TDATE         BADTLA
     C                   Z-ADD     TIMOD         BATIME
     C                   MOVEL     USERID        BAUSER
     C   21              WRITE     RMBANK
     C   22              UPDATE    RMBANK
     C   23              DELETE    RMBANK
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       9977
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VCODE
     C                   MOVE      *BLANKS       VDESC
     C                   Z-ADD     0             VGLNO
     C                   ENDSR
      *
