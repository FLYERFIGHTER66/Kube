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
      *PROGRAM NAME-------- BIR014
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE FREIGHT TYPES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR014FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFFRTYP    UF A E           K DISK
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
     C                   EXSR      CLRIND
     C                   SETOFF                                       50
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       192026
     C                   SETOFF                                       272899
     C                   SETOFF                                       4041
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
     C                   ADD       1             FIRST
     C  N50              EXSR      SR100A
     C   99              GOTO      NXTA
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C     FIRST         IFNE      0
     C                   EXSR      SR100B
     C   25              GOTO      RSTRT
     C                   END
      *ERROR
     C   99              GOTO      NXTA
      *KF ON SCREEN B
     C   87              GOTO      RSTRT
      *
      * CHECK IF COUNT > 0 IF SO REDISPLAY ELSE UPDATE RECORDS
      *
     C     COUNT         IFGT      0
     C                   GOTO      NXTA
     C                   ELSE
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C                   END                                                    COUNT>0
     C     END           TAG
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **************************
      ******     SR100A - TOP OF SCREEN
      **************************
     C     SR100A        BEGSR
      *
     C                   MOVEL     VCODE         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VCODE         FRCODE            1
     C                   CALL      'LKFRTT'
     C                   PARM                    FRCODE
     C                   PARM                    FRDESC           12
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     FRCODE        VCODE
     C                   MOVEL     FRDESC        VDESC            12
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
      * MUST HAVE FREIGHT TYPE
      *
     C                   MOVEL     VCODE         FRCODE
     C     FRCODE        IFEQ      *BLANKS
     C                   SETON                                        9919
     C                   GOTO      E100A
     C                   ENDIF
      *
      * VALIDATE FREIGHT TYPE
      *
     C     CKEY3         KLIST
     C                   KFLD                    FRCODE
     C     CKEY3         CHAIN     FFRTYP                             96
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        23
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        9927
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        9920
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     E100A         TAG
      *
     C                   ENDSR
      *
      **************************
      ******     SR100B - BOTTOM OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
     C                   SETON                                        50
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
      *
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
     C   KC
     COR KG              GOTO      END
      *
      * DESCRIPTION REQUIRED
      *
     C                   SETOFF                                       9957
     C     FRDESC        IFEQ      *BLANKS
     C                   SETON                                        9957
     C                   ENDIF
     C     FRDESC        IFNE      ODESC
     C                   ADD       1             COUNT             2 0
     C                   MOVEL     FRDESC        ODESC            20
     C                   ENDIF
      *
     C     ENDB          TAG
      *
      * WHAT ACTION NEXT IF COUNT>0 SET OF 98 IF 99 SET ON 98
     C     COUNT         IFGT      0
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
     C   99              SETON                                        98
     C                   ENDSR
      *
      *  **********
      *  * OUTREC *
      *  **********
     C     OUTREC        BEGSR
     C     VACT          IFEQ      'A'
     C                   WRITE     RFRTYP
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RFRTYP
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RFRTYP
     C                   ENDIF
     C                   ENDSR
      *
      ****   CLEAR INDICATORS
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
      *  **********
      *  * CLRIT  *
      *  **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VCODE
     C                   MOVE      *BLANKS       FRCODE
     C                   MOVE      *BLANKS       FRDESC
     C                   ENDSR
      *
