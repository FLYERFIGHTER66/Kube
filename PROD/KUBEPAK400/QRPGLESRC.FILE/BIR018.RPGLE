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
      *PROGRAM NAME-------- BIR018
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE FREIGHT ZONES.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  7/02/02 EFD ALLOW CODES 1-3 TO BE NO CHARGE.      PER BILL
      *
     FBIR018FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFUZONE    UF A E           K DISK
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
     C                   EXSR      CLRIND
     C                   UNLOCK    FUZONE
     C                   SETOFF                                       50
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       192021
     C                   SETOFF                                       222699
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C   KF              GOTO      RSTRT
     C                   ADD       1             FIRST
     C  N50              EXSR      SR100A
     C   99              GOTO      NXTA
      *
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C     FIRST         IFNE      0
     C                   EXSR      SR100B
     C   25              GOTO      RSTRT
     C                   END
      *
      * ERROR
      *
     C   99              GOTO      NXTA
      *
      * KF ON SCREEN B
      *
     C   87              GOTO      RSTRT
      *
      * CHECK IF CNT   > 0 IF SO REDISPLAY ELSE UPDATE RECORDS
      *
     C     CNT           IFGT      0
     C                   GOTO      NXTA
     C                   ELSE
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C                   END                                                    CNT  >0
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      *********
      * SR100A
      *********
     C     SR100A        BEGSR
      *
     C                   MOVEL     VZONE         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VZONE         FZONE             1
     C                   CALL      'LKFRTZ'
     C                   PARM                    FZONE
     C                   PARM                    FUDESC           20
     C                   MOVEL     *BLANKS       VZONE
     C                   MOVEL     FZONE         VZONE
     C                   MOVEL     FUDESC        VDESC            20
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        26
     C   26              GOTO      E100A
     C     VACTOK        TAG
      *
      * MUST HAVE FREIGHT ZONE
      *
     C     VZONE         IFEQ      *BLANKS
     C                   SETON                                        991920
     C                   GOTO      E100A
     C                   ENDIF
      *
      * VALIDATE FREIGHT ZONE
      *
     C                   MOVEL     VZONE         FZONE
     C                   Z-ADD     LCO           FUCONO
     C     CKEY3         KLIST
     C                   KFLD                    FUCONO
     C                   KFLD                    FZONE
     C     CKEY3         CHAIN     FUZONE                             96
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        23
     C                   ENDIF
      *
     C  N96VACT          IFEQ      'A'
     C                   SETON                                        991921
     C   21              GOTO      E100A
     C                   END
      *
     C   96VACT          IFNE      'A'
     C                   SETON                                        991922
     C   99              GOTO      E100A
     C                   END
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     E100A         TAG
      *
     C                   ENDSR
      *
      *********
      * SR100B
      *********
      *
     C     SR100B        BEGSR
      *
     C                   SETON                                        50
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
      *  KX = OKAY TO DEL
      *
     C  NKX              GOTO      RSTRT
     C   KX              EXSR      OUTREC
     C                   GOTO      RSTRT
      *
     C     NODEL         TAG
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
      *
     C   KC
     COR KG              GOTO      END
      *
      * DESCRIPTION REQUIRED
      *
     C                   SETOFF                                       9957
     C     FUDESC        IFEQ      *BLANKS
     C                   SETON                                        9957
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     FUDESC        IFNE      ODESC
     C                   ADD       1             CNT               2 0
     C                   MOVEL     FUDESC        ODESC            20
     C                   ENDIF
      *
      * CHARGE REQUIRED IF VZONE GT 3
      *
     C                   SETOFF                                       9955
     C     FUCHRG        IFEQ      0
     C     VZONE         ANDGT     '3'
     C                   SETON                                        9955
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     FUCHRG        IFNE      OCHRG
     C                   ADD       1             CNT               2 0
     C                   Z-ADD     FUCHRG        OCHRG             5 2
     C                   ENDIF
      *
     C     ENDB          TAG
      *
      * WHAT ACTION NEXT IF CNT  >0 SET OF 98 IF 99 SET ON 98
     C     CNT           IFGT      0
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
     C   99              SETON                                        98
      *
     C                   ENDSR
      *  **********
      *  * OUTREC *
      *  **********
     C     OUTREC        BEGSR
     C     VACT          IFEQ      'A'
     C                   WRITE     RUZONE
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RUZONE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RUZONE
     C                   ENDIF
     C                   ENDSR
      *
      * CLEAR INDICATORS
      *
     C     CLRIND        BEGSR
     C                   SETOFF                                       1920
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       2728
     C                   SETOFF                                       404150
     C                   SETOFF                                       333435
     C                   SETOFF                                       555657
     C                   SETOFF                                       808899
     C                   ENDSR
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       VACT
     C                   MOVEL     *BLANKS       VZONE
     C                   MOVEL     *BLANKS       FZONE
     C                   Z-ADD     0             FUCHRG
     C                   MOVE      *BLANKS       FUDESC
     C                   ENDSR
      *
