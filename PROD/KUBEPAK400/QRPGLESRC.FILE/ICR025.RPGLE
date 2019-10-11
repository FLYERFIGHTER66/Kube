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
      *PROGRAM NAME-------- ICR025
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ITEM SEASON DATES
      *
      *
      *    DATE----INIT-------DESCRIPTION
      *
     FICR025FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMITSES   UF A E           K DISK
     FFMINVT    IF   E           K DISK
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   SETOFF                                       5023
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       2699
     C                   SETOFF                                       101112
     C                   SETOFF                                       2087
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C   KF              GOTO      RSTRT
      *
     C                   ADD       1             FIRST
     C  N50              EXSR      SR100A
     C   KF              GOTO      RSTRT
     C   99              GOTO      NXTA
      *
     C   KF              GOTO      RSTRT
      *
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C     FIRST         IFNE      0
     C                   EXSR      SR100B
      *
      * ERROR
      *
     C   99              GOTO      NXTA
      *
      * KF ON SCREEN B
      *
     C   87              GOTO      RSTRT
     C                   END
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              DELETE    RMITSES
     C                   GOTO      RSTRT
      *
     C     NODEL         TAG
      *
     C     CNTB          IFGT      1
     C                   SETOFF                                       88
     C                   END
      *
      * CHECK IF COUNT > 0 IF SO REDISPLAY ELSE UPDATE RECORDS
      *
     C     COUNT         IFGT      0
     C                   GOTO      NXTA
     C                   ELSE
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C                   END
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **************************
      * SR100A - TOP OF SCREEN
      **************************
     C     SR100A        BEGSR
      *
      *
      * SEE IF WE NEED ITEM SEARCH
      *
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C                   MOVEL     *BLANKS       SHPFR             3
     C     11            SUBST     VITEM:2       IMLOOK
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C                   SETOFF                                       212223
     C                   SETOFF                                       101112
     C                   SETOFF                                       19
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
      *
     C   26              SETON                                        99
     C   26              GOTO      E100A
      *
      * MUST HAVE ITEM, SIZE IS OPTIONAL
      *
     C     VITEM         IFEQ      *BLANKS
     C                   SETON                                        199910
     C                   GOTO      E100A
     C                   ENDIF
      *
      * VALIDATE ITEM NUMBER
      *
     C     IKEY2         KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     IKEY2         CHAIN     FMINVT                             95
     C   95              SETON                                        199910
     C   19              GOTO      E100A
     C                   EXSR      GETDES
      *
      *  READ ITEM SEASON DATE FILE
      *
     C     SKEY          KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C     SKEY          CHAIN     FMITSES                            96
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        101199
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        101299
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     E100A         TAG
      *
     C   KF              GOTO      RSTRT
     C                   ENDSR
      *
      ****************************
      * SR100B - BOTTOM OF SCREEN
      ****************************
      *
     C     SR100B        BEGSR
      *
     C                   SETOFF                                       904042
     C                   SETON                                        50
      *
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        88
     C                   ADD       1             CNTB              2 0
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C   KC
     COR KG              GOTO      END
      *
     C     ISBEG         IFEQ      *ZEROS
     C                   SETON                                        4099
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     ISBEG         IFNE      OBEG
     C                   ADD       1             COUNT
     C                   MOVEL     ISBEG         OBEG              4 0
     C                   ENDIF
      *
     C                   MOVEL     ISBEG         IMTH              2 0
     C                   MOVE      ISBEG         IDAY              2 0
      *
     C     IMTH          IFLT      1
     C     IMTH          ORGT      12
     C                   SETON                                        4099
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     IDAY          IFLT      1
     C     IDAY          ORGT      31
     C                   SETON                                        4099
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     ISEND         IFEQ      *ZEROS
     C                   SETON                                        4299
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     ISEND         IFNE      OEND
     C                   ADD       1             COUNT
     C                   MOVEL     ISEND         OEND              4 0
     C                   ENDIF
      *
     C                   MOVEL     ISEND         EMTH              2 0
     C                   MOVE      ISEND         EDAY              2 0
      *
     C     EMTH          IFLT      1
     C     EMTH          ORGT      12
     C                   SETON                                        4099
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     EDAY          IFLT      1
     C     EDAY          ORGT      31
     C                   SETON                                        4299
     C                   GOTO      ENDB
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
     C                   MOVEL     VITEM         ISITEM
     C                   MOVEL     VSIZE         ISSIZE
     C   21              WRITE     RMITSES
     C   22              UPDATE    RMITSES
     C   23              DELETE    RMITSES
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VITEM
     C                   MOVE      *BLANKS       VSIZE
     C                   Z-ADD     *ZEROS        ISBEG
     C                   Z-ADD     *ZEROS        ISEND
     C                   MOVE      *BLANKS       ISCOMM
     C                   MOVE      *BLANKS       DESP
     C                   Z-ADD     *ZEROS        CNTB
     C                   ENDSR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP
     C                   ENDSR
      *
