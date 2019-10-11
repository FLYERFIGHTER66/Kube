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
      *PROGRAM NAME-------- BIR002
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE PRODUCT CLASSES
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FBIR002FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMPRCL    UF A E           K DISK
     FFMINVTPC  IF   E           K DISK
     FFSYSCTL   IF   E           K DISK
      *
     D CK              S              2  0 DIM(4)
     D MSG             S             36    DIM(4) CTDATA PERRCD(1)
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
     D  LLIST                  3      3
     D  LCANCL               133    133
      *
      * PROGRAM MAINLINE
      *
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'G'
     C                   SETON                                        01
     C                   MOVEL     MSG(1)        IDESC
     C                   MOVEL     MSG(3)        CAVAIL
     C                   ELSE
     C                   SETON                                        02
     C                   MOVEL     MSG(2)        IDESC
     C                   MOVEL     MSG(4)        CAVAIL
     C                   ENDIF
      *
     C     RSTRT         TAG
     C                   EXSR      CLRIT
     C                   EXSR      CLRIND
     C                   UNLOCK    FMPRCL
     C                   SETOFF                                       50
     C                   SETON                                        98
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       192026
     C                   SETOFF                                       279957
     C                   SETOFF                                       323540
     C                   SETOFF                                       41
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
      * REDISPLAY SCREEN ON D I
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
      **********
      * SR100A *
      **********
     C     SR100A        BEGSR
      *
     C     1             SUBST     VPRCL:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC
     C                   SETON                                        99
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C                   SETOFF                                       212223
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
     C   26VACT          COMP      'I'                                262624     INQUIRE
      *
     C   26              SETON                                        99
     C   26              GOTO      ENDA
      *
      * MUST HAVE PRODUCT CLASS
      *
     C     VPRCL         IFEQ      *BLANKS
     C                   SETON                                        991910
     C                   GOTO      ENDA
     C                   ENDIF
      *
      * VALIDATE PRODUCT CLASS
      *
     C     VPRCL         CHAIN     FMPRCL                             96
     C  N96              MOVEL     PCDESC        VDESC
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
     C  N23              MOVEL     'A'           PCSTAT
     C   21              MOVEL     *BLANKS       VDESC
      *
     C     VACT          IFEQ      'I'
     C                   SETON                                          77
     C                   ENDIF
      *
     C  N99              SETON                                        50
      *
     C                   Z-ADD     0             FIRST             2 0
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     'N'           PCSUMF
     C                   MOVEL     'N'           PCEVD
     C                   Z-ADD     1             PCPRI1
     C                   Z-ADD     2             PCPRI2
     C                   Z-ADD     3             PCPRI3
     C                   Z-ADD     4             PCPRI4
     C                   Z-ADD     1             PCPRP1
     C                   Z-ADD     2             PCPRP2
     C                   Z-ADD     3             PCPRP3
     C                   Z-ADD     4             PCPRP4
     C                   Z-ADD     1             PCPRR1
     C                   Z-ADD     2             PCPRR2
     C                   Z-ADD     3             PCPRR3
     C                   Z-ADD     4             PCPRR4
     C                   ENDIF
      *
     C     ENDA          TAG
      *
     C                   ENDSR
      *
      **********
      * SR100B *
      **********
     C     SR100B        BEGSR
      *
     C                   SETON                                        50
     C                   SETOFF                                       6061
      *
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
     C   KC
     COR KG              GOTO      END
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C     VPRCL         CHAIN     FMINVTPC                           90
     C  N90              SETON                                          9941    57
     C   99              GOTO      ENDB
      *
      *  KX = OKAY TO DEL
      *
     C   KX              DELETE    RMPRCL
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
      * IF DISTRIBUTOR - NO PLANT AVAIL DATES
      *
     C   02              GOTO      NOAVL
     C     PCSDTF        IFEQ      *ZEROS
     C     PCSDTT        OREQ      *ZEROS
     C                   SETON                                        406299
     C   40
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
     C                   MOVEL     PCSDTF        SMM               2 0
     C                   MOVE      PCSDTF        SDD               2 0
      *
     C     SMM           IFEQ      *ZEROS
     C     SMM           ORGT      12
     C                   SETON                                        626399
     C   63
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
     C     SDD           IFEQ      *ZEROS
     C     SDD           ORGT      31
     C                   SETON                                        626399
     C   63
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
     C                   MOVEL     PCSDTT        EMM               2 0
     C                   MOVE      PCSDTT        EDD               2 0
      *
     C     EMM           IFEQ      *ZEROS
     C     EMM           ORGT      12
     C                   SETON                                        646699
     C   66
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
     C     EDD           IFEQ      *ZEROS
     C     EDD           ORGT      31
     C                   SETON                                        646699
     C   66
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
     C     NOAVL         TAG
      *
     C     PCSUMF        IFNE      'Y'
     C     PCSUMF        ANDNE     'N'
     C                   SETON                                        6099
     C   60
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
     C     PCEVD         IFNE      'Y'
     C     PCEVD         ANDNE     'N'
     C                   SETON                                        6199
     C   61
     CAN 99              GOTO      ENDB
     C                   ENDIF
      *
      * VALIDATE ORDER OF DESCRIPTIONS DURING PRING
      *
     C                   SETOFF                                       353637
     C                   Z-ADD     PCPRI1        I1                1 0
     C                   Z-ADD     PCPRI2        I2                1 0
     C                   Z-ADD     PCPRI3        I3                1 0
     C                   Z-ADD     PCPRI4        I4                1 0
     C                   EXSR      CHKIT
     C   99              SETON                                          35
     C   99              GOTO      ENDB
     C                   Z-ADD     PCPRP1        I1                1 0
     C                   Z-ADD     PCPRP2        I2                1 0
     C                   Z-ADD     PCPRP3        I3                1 0
     C                   Z-ADD     PCPRP4        I4                1 0
     C                   EXSR      CHKIT
     C   99              SETON                                          36
     C   99              GOTO      ENDB
      *
     C                   Z-ADD     PCPRR1        I1                1 0
     C                   Z-ADD     PCPRR2        I2                1 0
     C                   Z-ADD     PCPRR3        I3                1 0
     C                   Z-ADD     PCPRR4        I4                1 0
     C                   EXSR      CHKIT
     C   99              SETON                                          37
     C   99              GOTO      ENDB
     C     ENDB          TAG
      *
      * WHAT ACTION NEXT IF COUNT>0 SET OF 98 IF 99 SET ON 98
     C  N77COUNT         IFGT      0
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETON                                        98
     C                   ENDIF
      *
     C   77              GOTO      RSTRT
      *
     C   99              SETON                                        98
     C                   ENDSR
      *
      **********
      * OUTREC *
      **********
     C     OUTREC        BEGSR
     C                   MOVEL     VPRCL         PCPRCL
     C                   MOVEL     VDESC         PCDESC
     C                   Z-ADD     TDATE         PCDTLA
     C                   Z-ADD     TIMOD         PCTIME
     C                   MOVEL     USERID        PCUSER
     C   21              WRITE     RMPRCL
     C   22              UPDATE    RMPRCL
     C                   ENDSR
      **********
      * CLRIND *
      **********
     C     CLRIND        BEGSR
     C                   SETOFF                                       192077
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C                   SETOFF                                       273235
     C                   SETOFF                                       335040
     C                   SETOFF                                       616263
     C                   SETOFF                                       717273
     C                   SETOFF                                       646566
     C                   SETOFF                                       555657
     C                   SETOFF                                       808899
     C                   SETOFF                                       41
     C                   ENDSR
      *
      **********
      * CHKIT  *
      **********
      *
     C     CHKIT         BEGSR
      *
      * VALIDATE ORDER OF DESCRIPTIONS DURING PRING
      *
     C     I1            ADD       I2            TEST              3 0
     C                   ADD       I3            TEST
     C                   ADD       I4            TEST
      *
     C     TEST          IFGT      10
     C     TEST          ORLT      1
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
      *
     C     I1            IFGT      4
     C     I2            ORGT      4
     C     I3            ORGT      4
     C     I4            ORGT      4
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
      *
     C                   Z-ADD     0             CK
     C     I1            IFGT      0
     C                   ADD       1             CK(I1)
     C                   ENDIF
     C     I2            IFGT      0
     C                   ADD       1             CK(I2)
     C                   ENDIF
     C     I3            IFGT      0
     C                   ADD       1             CK(I3)
     C                   ENDIF
     C     I4            IFGT      0
     C                   ADD       1             CK(I4)
     C                   ENDIF
     C     CK(1)         IFEQ      0
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
      *
     C                   Z-ADD     1             X                 1 0
     C     X             DOUEQ     5
     C     CK(X)         IFGT      1
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
     C     X             ADD       1             X1                1 0
     C     X1            IFLE      4
     C     CK(X)         ANDEQ     0
     C     CK(X1)        ANDGT     0
     C                   SETON                                          99
     C                   GOTO      ENDCK
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
     C     ENDCK         ENDSR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   SETOFF                                       9977
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       VPRCL
     C                   MOVE      *BLANKS       VDESC
     C                   Z-ADD     *ZEROS        PCSDTF
     C                   Z-ADD     *ZEROS        PCSDTT
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      *
**  BOTTOM OF SCREEN MESSAGES
Genus  Species  Variety  Common Name
Desc 1  Desc 2   Desc 3   Desc 4
            Plants Available - From:
         Inventory Available - From:
