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
      *PROGRAM NAME-------- GRS010
      *SYSTEM-------------- PRODUCTION MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE PHYTO CODES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGRS010FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFPHYTO    UF A E           K DISK
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
     C                   MOVEL     *BLANKS       VCODE
     C                   EXSR      CLRIT
     C                   EXSR      CLRIND
     C                   SETOFF                                       50
     C                   SETON                                        98
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
     C   KM
     COR KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   ADD       1             FIRST
      *
     C  N50              EXSR      SR100A
     C   99              GOTO      NXTA
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
      *
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
      * CHECK IF COUNT > 0 IF SO REDISPLAY ELSE UPDATE RECORDS
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
     C     VCODE         IFEQ      '?'
     C     VCODE         OREQ      '/'
     C                   MOVEL     VCODE         PHCODE
     C                   CALL      'LKPHYT'
     C                   PARM                    PHCODE
     C                   PARM                    PHYDES           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     PHCODE        VCODE
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
      * MUST HAVE PHYTO CODE
      *
     C                   MOVEL     VCODE         PHCODE
      *
      * VALIDATE PHYTO CODE
      *
     C     CKEY1         KLIST
     C                   KFLD                    PHCODE
     C     CKEY1         CHAIN     FPHYTO                             96
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
     C   22
     COR 23PHSTAT        IFEQ      'D'
     C                   SETON                                          9940
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
      ***************************
      * SR100B - BOTTOM OF SCREEN
      ***************************
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
     C     PHYDES        IFEQ      *BLANKS
     C                   SETON                                        9957
     C   57
     CAN 99              GOTO      ENDB
     C                   ENDIF
     C     PHYDES        IFNE      ODESC
     C                   ADD       1             COUNT             2 0
     C                   MOVEL     PHYDES        ODESC            30
     C                   ENDIF
      *
     C     PHCERT        IFNE      'Y'                                                      Q
     C     PHCERT        ANDNE     'N'
     C                   SETON                                        3299
     C                   GOTO      ENDB
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
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVE      'A'           PHSTAT
     C     VACT          IFEQ      'A'
     C                   WRITE     RPHYTO
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RPHYTO
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RPHYTO
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
     C                   MOVE      *BLANKS       PHCODE
     C                   MOVE      *BLANKS       PHYDES
     C                   MOVE      *BLANKS       PHDESS
     C                   MOVE      *BLANKS       PHCERT
     C                   Z-ADD     *ZEROS        PHCHRG
     C                   ENDSR
      *
