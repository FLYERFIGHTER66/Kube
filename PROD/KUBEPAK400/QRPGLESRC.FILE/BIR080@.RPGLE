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
      *PROGRAM NAME-------- BIR080
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE CUSTOMER TYPE/PRODUCT CLASS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR080FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMCCLT    UF A E           K DISK
     FFMCUST    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
EFD01FFMCTYP    IF   E           K DISK
      *
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
      *
     C     RSTRT         TAG
     C                   MOVEL     *BLANKS       VDESC
     C                   MOVEL     *BLANKS       CDESC
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       50
     C  N45              EXSR      CLRIT
     C   45              SETON                                        50
     C                   SETON                                        98
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       133020
     C                   SETOFF                                       2799
     C                   SETOFF                                       404144
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
     C                   ADD       1             FIRST             2 0
     C  N50              EXSR      SR100A
     C   99              GOTO      NXTA
     C   50FIRST         IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C     FIRST         IFNE      0
     C                   EXSR      SR100B
     C   45              GOTO      RSTRT
     C                   END
      *ERROR
     C*  99                GOTO NXTA
      *KF ON SCREEN B
     C   87              GOTO      RSTRT
      *
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C*                    END                             COUNT>0
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
     C     CLCUST        IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        CLCUST
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
      *  TELEPHONE # SEARCH
      *
     C     CLCUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C     VTELE         ANDGT     *BLANKS
     C                   MOVEL     VTELE         CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VTELE
     C                   Z-ADD     CMCUST        CLCUST
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C                   SETOFF                                       212223
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
      *
     C   26              SETON                                        99
     C   26              GOTO      E100A
      *
      * CUSTOMER NUMBER IS A REQUIRED FIELD
      *
     C     CLCUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        111099
     C   11              GOTO      E100A
     C                   ENDIF
      *
      * ENTRIES IN BOTH FIELDS
      *
     C     CLCUST        IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        121099
     C   12              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     CLCUST        CMCUST            6 0
     C     KEY6          KLIST
     C                   KFLD                    CMCUST
     C     KEY6          CHAIN     FMCUST                             90
     C   90              SETON                                        101399
     C   13              GOTO      E100A
     C                   ENDIF
      *
      * MUST HAVE PRODUCT CLASS
      *
     C     1             SUBST     CLPC2:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     CLPC2         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       CLPC2
     C                   MOVEL     PCPRCL        CLPC2
     C                   MOVEL     PCDESC        VDESC            30
     C                   SETON                                        99
     C                   GOTO      E100A
     C                   ENDIF
      *
     C     CLPC2         IFEQ      *BLANKS
     C                   SETON                                        3099
     C                   GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     CLPC2         CHAIN     FMPRCL                             96
     C  N96PCSTAT        COMP      'D'                                    96
     C   96              SETON                                        3099
     C   30              GOTO      E100A
     C                   ENDIF
      *
      * VALIDATE CUSTOMER/PRODUCT CLASS
      *
     C     KEY8          KLIST
     C                   KFLD                    CLCUST
     C                   KFLD                    CLPC2
     C     KEY8          CHAIN     FMCCLT                             96
      *
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        992744
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        992044
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C   22
     COR 23
     COR 25CLSTAT        IFEQ      'D'
     C                   SETON                                        994044
     C   99              GOTO      E100A
     C                   ENDIF
      *
     C   21              MOVEL     'A'           CLSTAT
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
     C     E100A         TAG
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
     C                   SETOFF                                       995745
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
     C   KC
     COR KG              GOTO      END
      *
      * TYPE REQUIRED
      *
     C     1             SUBST     CLCTYP:1      VITST1            1
     C     VITST1        IFEQ      '?'
     C     VITST1        OREQ      '/'
     C                   MOVEL     CLCTYP        CTTYPE            2
     C                   CALL      'LKTYPE'
     C                   PARM                    CTTYPE
     C                   PARM                    CTDESC           30
     C                   MOVEL     *BLANKS       CLCTYP
     C                   MOVEL     CTTYPE        CLCTYP
     C                   MOVEL     CTDESC        CDESC            30
     C                   SETON                                        45
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     CLCTYP        IFEQ      *BLANKS
     C                   SETON                                        9957
     C   57              GOTO      ENDB
     C                   ENDIF
      *
     C     CLCTYP        IFNE      OTYPE
     C                   ADD       1             COUNT             2 0
     C                   MOVEL     CLCTYP        OTYPE             2
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
      *
     C                   ENDSR
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVE      'A'           CLSTAT
     C   21              WRITE     RMCCLT
     C   22              UPDATE    RMCCLT
     C   23              DELETE    RMCCLT
     C                   ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       289911
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       CMNAME
     C                   Z-ADD     *ZEROS        CLCUST
     C                   MOVE      *BLANKS       CLPC2
     C                   MOVE      *BLANKS       CLCTYP
     C                   ENDSR
      *
