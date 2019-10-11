      *----------------------------------------------------------      ----
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 2000
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
      *PROGRAM NAME-------- GRS040
      *SYSTEM-------------- PRODUCTION MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE LIST CODES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  6/22/00 EFD ADD PRICES FOR KUBE PAK
      *
     FGRS040FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFLISTCD   UF A E           K DISK
     FFMSIZE    IF   E           K DISK
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
     D  SizeCode                           Like(SZCODE)
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   EXSR      CLRIND
     C                   SETOFF                                       50
     C                   SETON                                        98
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       192026
     C                   SETOFF                                       272899
     C                   SETOFF                                       404132
     C                   SETOFF                                       57
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
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
      * ERROR
     C   99              GOTO      NXTA
      *KF ON SCREEN B
     C   87              GOTO      RSTRT
      *
      * CHECK IF COUNT > 0 IF SO REDISPLAY ELSE UPDATE RECORDS
      *
     C*          COUNT     IFGT 0
     C*                    GOTO NXTA
     C*                    ELSE
     C                   SETON                                        98
     C                   SETOFF                                       111213
     C                   SETOFF                                       141599
     C                   Z-ADD     0             OSEL1             9 4
     C                   Z-ADD     0             OSEL2             9 4
     C                   Z-ADD     0             OSEL3             9 4
     C                   Z-ADD     0             OSEL4             9 4
     C                   Z-ADD     0             OSEL5             9 4
     C                   GOTO      NXTB
     C*                    GOTO RSTRT
     C*                    END                             COUNT>0
      ** SCRNB
     C     NXTB          TAG
     C                   ExSr      CellPrice
     C   99              SETON                                        98
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   SETOFF                                       111213
     C                   SETOFF                                       141599
      ** ALL PRICES MUST BE ENTERED PER BILL 6/23/00
     C     LCSEL1        IFLE      0
     C                   SETON                                        11  99
     C                   END
     C     LCSEL2        IFLE      0
     C                   SETON                                        12  99
     C                   END
     C     LCSEL3        IFLE      0
     C                   SETON                                        13  99
     C                   END
     C     LCSEL4        IFLE      0
     C                   SETON                                        14  99
     C                   END
     C     LCSEL5        IFLE      0
     C                   SETON                                        15  99
     C                   END
     C   99              GOTO      NXTB
      ** SEE IF ANY CHANGES
     C     LCSEL1        IFNE      OSEL1
     C     LCSEL2        ORNE      OSEL2
     C     LCSEL3        ORNE      OSEL3
     C     LCSEL4        ORNE      OSEL4
     C     LCSEL5        ORNE      OSEL5
     C                   SETON                                        98
     C                   Z-ADD     LCSEL1        OSEL1
     C                   Z-ADD     LCSEL2        OSEL2
     C                   Z-ADD     LCSEL3        OSEL3
     C                   Z-ADD     LCSEL4        OSEL4
     C                   Z-ADD     LCSEL5        OSEL5
     C                   ENDIF
     C   98              DO
     C                   SETOFF                                       98
     C                   GOTO      NXTB
     C                   END
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   SETON                                        LR
      *
      **************************
      * SR100A - TOP OF SCREEN
      **************************
     C     SR100A        BEGSR
      *
     C     1             SUBST     VLIST:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VLIST         LCCODE
     C                   CALL      'LKLIST'
     C                   PARM                    LCCODE
     C                   PARM                    LCDESC           30
     C                   MOVEL     *BLANKS       VLIST
     C                   MOVEL     LCCODE        VLIST
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
      *
     C   26              SETON                                        99
     C   26              GOTO      E100A
      *
      * MUST HAVE LIST CODE
      *
     C                   MOVEL     VLIST         LCCODE
     C     LCCODE        IFEQ      *BLANKS
     C                   SETON                                        19
     C                   GOTO      E100A
     C                   ENDIF
      *
      * VALIDATE LIST CODE
      *
     C     LCCODE        CHAIN     FLISTCD                            96
     C   96              CLEAR                   RLISTCD
     C   96              MOVEL     VLIST         LCCODE
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
      *
      **************************
      * CellPrice - Calculate Price per Cell
      **************************
      *
     C     CellPrice     BEGSR
      *
     C                   Eval      SizeCode = *Blanks

     C                   If        %Subst(LCCODE:1:1) >= '0' and
     C                             %Subst(LCCODE:1:1) <= '9'
     C                   Eval      SizeCode = %Trim(SizeCode)+%Subst(LCCODE:1:1)
     C                   EndIf

     C                   If        %Subst(LCCODE:2:1) >= '0' and
     C                             %Subst(LCCODE:2:1) <= '9'
     C                   Eval      SizeCode = %Trim(SizeCode)+%Subst(LCCODE:2:1)
     C                   EndIf

     C                   If        %Subst(LCCODE:3:1) >= '0' and
     C                             %Subst(LCCODE:3:1) <= '9'
     C                   Eval      SizeCode = %Trim(SizeCode)+%Subst(LCCODE:3:1)
     C                   EndIf

     C                   If        %Subst(LCCODE:4:1) >= '0' and
     C                             %Subst(LCCODE:4:1) <= '9'
     C                   Eval      SizeCode = %Trim(SizeCode)+%Subst(LCCODE:4:1)
     C                   EndIf
     C                   Eval      *In30 = *Off
     C     SizeCode      Chain     FMSIZE
     C                   If        %Found(FMSIZE)
     C                   If        LCCODE = 'I512'
     C                   Eval      SZSALE = 400
     C                   EndIf
     C                   Eval      SALEABLE = SZSALE
     C                   If        SZSALE > 1
     C                   Eval      *In30 = *On
     C                   Eval      LCELL1 = LCSEL1 / SZSALE
     C                   Eval      LCELL2 = LCSEL2 / SZSALE
     C                   Eval      LCELL3 = LCSEL3 / SZSALE
     C                   Eval      LCELL4 = LCSEL4 / SZSALE
     C                   Eval      LCELL5 = LCSEL5 / SZSALE
     C                   EndIf
     C                   EndIf
     C                   ENDSR
      **************************
      * SR100B - BOTTOM OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
      *
     C                   SETON                                        50
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
      *  KX OR KJ = OKAY TO DEL
      *
     C  NKX
     CANNKJ              GOTO      RSTRT
     C                   EXSR      OUTREC
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
     C*                    SETOF                     57
     C     LCDESC        IFEQ      *BLANKS
     C                   SETON                                        5799
     C   57              GOTO      ENDB
     C                   ENDIF
      *
     C     LCDESC        IFNE      ODESC
     C                   ADD       1             COUNT             2 0
     C                   MOVEL     LCDESC        ODESC            30
     C                   ENDIF
      *
     C     ENDB          TAG
      *
      * WHAT ACTION NEXT IF COUNT>0 SET OF 98 IF 99 SET ON 98
      *
     C     COUNT         IFGT      0
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
     C   99              SETON                                        98
     C                   ENDSR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C     VACT          IFEQ      'A'
     C                   WRITE     RLISTCD
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RLISTCD
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RLISTCD
     C                   ENDIF
     C                   ENDSR
      *
      * CLEAR INDICATORS
      *
     C     CLRIND        BEGSR
     C                   SETOFF                                       1920
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       272832
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
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVE      *BLANKS       VLIST
     C                   CLEAR                   RLISTCD
     C                   ENDSR
      *
