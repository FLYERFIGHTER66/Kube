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
      *PROGRAM NAME-------- BIR017
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE FREIGHT CODES.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR017FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFFPERC    UF A E           K DISK
      *
     D @@NM            S             17    DIM(2) CTDATA PERRCD(1)
     D MSG             S             20    DIM(3) CTDATA PERRCD(1)
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
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   Z-ADD     LCO           FPCONO
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102021
     C                   SETOFF                                       222430
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   SETOFF                                       99
      *
     C                   MOVEL     FPCODE        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       FPCODE
     C                   CALL      'LKFRCD'
     C                   PARM                    FPCONO
     C                   PARM                    FPCODE
     C                   GOTO      NXTA
     C                   ENDIF
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
      * MUST HAVE FREIGHT CODE
      *
     C     FPCODE        IFLE      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * VALIDATE FREIGHT CODE
      *
     C     CKEY8         KLIST
     C                   KFLD                    FPCONO
     C                   KFLD                    FPCODE
     C     CKEY8         CHAIN     FFPERC                             98
      *
     C  N98VACT          IFEQ      'A'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   98VACT          IFNE      'A'
     C                   SETON                                        2024
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TYPE REQUIRED
      *
     C     FPTYPE        IFNE      'F'
     C     FPTYPE        ANDNE     'P'
     C     FPTYPE        ANDNE     'C'
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     FPTYPE        IFEQ      'P'
     C                   MOVEL     @@NM(1)       CHGDES
     C                   ELSE
     C                   MOVEL     @@NM(2)       CHGDES
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
     C                   SETOFF                                       98
      *
     C     FPTYPE        IFEQ      'F'
     C                   MOVEL     MSG(1)        TDESC
     C                   ENDIF
     C     FPTYPE        IFEQ      'P'
     C                   MOVEL     MSG(2)        TDESC
     C                   ENDIF
     C     FPTYPE        IFEQ      'C'
     C                   MOVEL     MSG(3)        TDESC
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101520
     C                   SETOFF                                       30
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              GOTO      NODEL
     C                   GOTO      RSTRT
      *
     C     NODEL         TAG
      *
      * VALIDATE PERCENT OR CHARGE
      *
     C     FPTYPE        IFEQ      'P'
     C     FPCHRG        ANDLE     0
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     FPTYPE        IFNE      'P'
     C     FPCHRG        ANDLE     0
     C                   SETON                                        15
     C                   GOTO      NXTB
     C                   ENDIF
      *
      * MAXIMUM CAN NOT BE LESS THAN MINIMUM
      *
     C     FPMIN         IFGT      0
     C     FPMAX         ANDGT     0
     C     FPMAX         ANDLT     FPMIN
     C                   SETON                                        20
     C   20              GOTO      NXTB
     C                   ENDIF
      ** DESC
     C     FPDESC        IFLE      *BLANKS
     C                   MOVE      *BLANKS       ODESC            30
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   END
      *
     C     FPDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     FPDESC        ODESC
      *
     C     FPTYPE        IFNE      OTYPE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     FPTYPE        OTYPE             6
      *
     C     FPMIN         IFNE      OMIN
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     FPMIN         OMIN              9 2
      *
     C     FPMAX         IFNE      OMAX
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     FPMAX         OMAX              9 2
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   WRITE     RFPERC
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RFPERC
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RFPERC
     C                   ENDIF
      *
     C                   GOTO      RSTRT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      * CLRIT
      *
     C     CLRIT         BEGSR
     C                   MOVE      ' '           VACT
     C                   MOVE      *BLANKS       FPCODE
     C                   Z-ADD     0             FPCHRG
     C                   Z-ADD     0             FPMIN
     C                   Z-ADD     0             FPMAX
     C                   MOVE      ' '           FPTYPE
     C                   ENDSR
      *
** MESSAGE
Percentage:
Charge Amount:
** TYPE
# of Units x Rate
Percent of Order
Standard Charge
