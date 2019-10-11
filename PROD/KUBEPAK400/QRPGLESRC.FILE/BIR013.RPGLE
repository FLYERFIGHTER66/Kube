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
      *PROGRAM NAME-------- BIR013
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE SHIP VIA CODES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 4/05/99 EFD ON IS A RESERVED CODE FOR SHIP WITH NEXT.
      *
      *
     FBIR013FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMSVIA    UF A E           K DISK
     F*MGLCH  IF  E           K        DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
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
     C                   SETOFF                                       2799
     C                   SETOFF                                       325777
     C                   Z-ADD     0             COUNT             2 0
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
     C                   ENDIF
     C     FIRST         IFNE      0
     C                   EXSR      SR100B
     C   25              GOTO      RSTRT
     C                   ENDIF
      *
      * ERROR
      *
     C   99              GOTO      NXTA
      *
      * KF ON SCREEN B
      *
     C   87              GOTO      RSTRT
      *
      * REDISPLAY SCREEN ON R D I
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
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **************************
      * SR100A - TOP OF SCREEN
      **************************
     C     SR100A        BEGSR
      *
     C                   SETOFF                                       212223
      * MUST HAVE SHIP VIA CODE
      *
     C     1             SUBST     VCODE:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VCODE         SVCODE            2
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     SVCODE        VCODE
     C                   MOVEL     SVDESC        VDESC
     C                   SETON                                        99
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
      *
     C   26              SETON                                        99
     C   26              GOTO      ENDA
      *
     C     VCODE         IFEQ      *BLANKS
     C                   SETON                                        991910
     C                   GOTO      ENDA
     C                   ENDIF
      *
      * VALIDATE SHIP VIA CODE
      *
     C     CKEY2         KLIST
     C                   KFLD                    VCODE
     C     CKEY2         CHAIN     FMSVIA                             96
     C  N96              MOVEL     SVDESC        VDESC
      *
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        992710
     C   99              GOTO      ENDA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        992010
     C   99              GOTO      ENDA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C     VCODE         ANDEQ     'ON'
     C                   SETON                                        107799
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C   21              MOVEL     *BLANKS       SVDESC
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     ENDA          TAG
      *
     C                   ENDSR
      *
      **************************
      * SR100B - BOTTOM OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
     C                   SETON                                        50
      *
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
     C   KC
     COR KG              GOTO      END
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C  NKX              GOTO      RSTRT
     C   KX              EXSR      OUTREC
     C                   GOTO      RSTRT
      *
     C     NODEL         TAG
      *
      * DESCRIPTION REQUIRED
      *
     C                   SETOFF                                       9957
     C     VDESC         IFEQ      *BLANKS
     C                   SETON                                        9957
     C   57
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
     C     VDESC         IFNE      ODESC
     C                   ADD       1             COUNT             2 0
     C                   MOVEL     VDESC         ODESC            30
     C                   ENDIF
      *
     C*  KA                DO
     C*                    EXSR LOOK
     C*                    Z-ADDGLNO      SVPGLN
     C*                    SETON                     99
     C*                    GOTO ENDB
     C*                    ENDDO
      *
     C*          SVPGLN    IFGT 0
     C*          GLKEY     CHAINFMGLCH               90
     C*  90                SETON                     4099
     C*  40                GOTO ENDB
     C*                    ENDIF
      *
     C*  KB                DO
     C*                    EXSR LOOK
     C*                    Z-ADDGLNO      SVFGLN
     C*                    SETON                     99
     C*                    GOTO ENDB
     C*                    ENDDO
      *
     C*          SVFGLN    IFGT 0
     C*          GLKEY     CHAINFMGLCH               90
     C*  90                SETON                     4299
     C*  42                GOTO ENDB
     C*                    ENDIF
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
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVEL     VCODE         SVCODE
     C                   MOVEL     VDESC         SVDESC
     C   21              WRITE     RMSVIA
     C   22              UPDATE    RMSVIA
     C   23              DELETE    RMSVIA
     C                   ENDSR
      *
      * CLEAR INDICATORS
      *
     C     CLRIND        BEGSR
     C                   SETOFF                                       1920
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       2732
     C                   SETOFF                                       3350
     C                   SETOFF                                       616263
     C                   SETOFF                                       5657
     C                   SETOFF                                       808899
     C                   ENDSR
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       99
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VCODE
     C                   MOVE      *BLANKS       VDESC
     C                   Z-ADD     0             SVPACK
     C                   ENDSR
      **********
      *  LOOK  *
      **********
     C*          LOOK      BEGSR
     C*                    MOVEL*BLANKS   GCLOOK
     C*                    Z-ADDLCO       VCO     20
     C*                    CALL 'LKGLCH'
     C*                    PARM           GCLOOK
     C*                    PARM           VCO
     C*                    PARM           GCGLNO
     C*                    PARM           GCDESC
     C*                    MOVELGCGLNO    GLNO    80
     C*                    ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C*          GLKEY     KLIST
     C*                    KFLD           LCO
     C*                    KFLD           GLNO    80
      *
     C                   MOVEL     'ON'          VCODE
     C     CKEY2         CHAIN(N)  FMSVIA                             90
     C   90              DO
     C                   MOVEL     'ON'          SVCODE
     C                   Z-ADD     0             SVPACK
     C                   Z-ADD     0             SVFGLN
     C                   Z-ADD     0             SVPGLN
     C                   MOVEL     MSG(1)        SVDESC
     C                   WRITE     RMSVIA
     C                   ENDDO
     C                   ENDSR
      *
** Message array
Ship With Next Order
