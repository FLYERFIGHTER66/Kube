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
      *PROGRAM NAME-------- BIR008
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE ACCOUNTING PERIODS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FBIR008FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMAPER    UF A E           K DISK
     FFMCORG    IF   E           K DISK
      *
     D ST              S              6  0 DIM(13)
     D EN              S              6  0 DIM(13)
     D CE              S              2  0 DIM(13)
     D ENY             S              2  0 DIM(13)
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
     IRMAPER
     I              ACST01                      ST(01)
     I              ACST02                      ST(02)
     I              ACST03                      ST(03)
     I              ACST04                      ST(04)
     I              ACST05                      ST(05)
     I              ACST06                      ST(06)
     I              ACST07                      ST(07)
     I              ACST08                      ST(08)
     I              ACST09                      ST(09)
     I              ACST10                      ST(10)
     I              ACST11                      ST(11)
     I              ACST12                      ST(12)
     I              ACST13                      ST(13)
     I              ACEN01                      EN(01)
     I              ACEN02                      EN(02)
     I              ACEN03                      EN(03)
     I              ACEN04                      EN(04)
     I              ACEN05                      EN(05)
     I              ACEN06                      EN(06)
     I              ACEN07                      EN(07)
     I              ACEN08                      EN(08)
     I              ACEN09                      EN(09)
     I              ACEN10                      EN(10)
     I              ACEN11                      EN(11)
     I              ACEN12                      EN(12)
     I              ACEN13                      EN(13)
     I              ACCN01                      CE(01)
     I              ACCN02                      CE(02)
     I              ACCN03                      CE(03)
     I              ACCN04                      CE(04)
     I              ACCN05                      CE(05)
     I              ACCN06                      CE(06)
     I              ACCN07                      CE(07)
     I              ACCN08                      CE(08)
     I              ACCN09                      CE(09)
     I              ACCN10                      CE(10)
     I              ACCN11                      CE(11)
     I              ACCN12                      CE(12)
     I              ACCN13                      CE(13)
      *
     ISCRNA
     I              ACST01                      ST(01)
     I              ACST02                      ST(02)
     I              ACST03                      ST(03)
     I              ACST04                      ST(04)
     I              ACST05                      ST(05)
     I              ACST06                      ST(06)
     I              ACST07                      ST(07)
     I              ACST08                      ST(08)
     I              ACST09                      ST(09)
     I              ACST10                      ST(10)
     I              ACST11                      ST(11)
     I              ACST12                      ST(12)
     I              ACST13                      ST(13)
     I              ACEN01                      EN(01)
     I              ACEN02                      EN(02)
     I              ACEN03                      EN(03)
     I              ACEN04                      EN(04)
     I              ACEN05                      EN(05)
     I              ACEN06                      EN(06)
     I              ACEN07                      EN(07)
     I              ACEN08                      EN(08)
     I              ACEN09                      EN(09)
     I              ACEN10                      EN(10)
     I              ACEN11                      EN(11)
     I              ACEN12                      EN(12)
     I              ACEN13                      EN(13)
      *
     C     RSTRT         TAG
     C                   SETOFF                                       505155
     C                   SETON                                        98
     C                   Z-ADD     0             FIRST             2 0
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       204041
     C                   SETOFF                                       505526
     C                   SETOFF                                       99
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
     C  N50
     CANN51              EXSR      SR100A
     C   99              GOTO      NXTA
      *
     C     NXTB          TAG
     C   50
     CANN51              WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       204041
     C                   SETOFF                                       4243
     C                   SETOFF                                       99
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C   KF              GOTO      RSTRT
      *
     C   50
     CANN51              EXSR      SR100B
     C   99              GOTO      NXTB
      *
     C     NXTC          TAG
     C   51              WRITE     SCRNA
     C                   SETOFF                                       0304
     C                   SETOFF                                       101112
     C                   SETOFF                                       204041
     C                   SETOFF                                       424385
     C                   SETOFF                                       626364
     C                   SETOFF                                       656667
     C                   SETOFF                                       686970
     C                   SETOFF                                       717273
     C                   SETOFF                                       747576
     C                   SETOFF                                       777879
     C                   SETOFF                                       808182
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       391415
     C                   SETOFF                                       161718
     C                   SETOFF                                       194445
     C                   SETOFF                                       464748
     C                   SETOFF                                       495657
     C                   SETOFF                                       585952
     C                   SETOFF                                       5354
     C                   SETOFF                                       99
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C   KF              GOTO      RSTRT
     C   51              EXSR      SR100C
     C   KF              GOTO      RSTRT
     C   99              GOTO      NXTC
      *
      * REDISPLAY SCREEN ON D
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
     C                   EXSR      CENT
     C                   EXSR      OUTREC
     C                   GOTO      RSTRT
     C                   END                                                    COUNT>0
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      *************************
      * SR100A - TOP OF SCREEN
      *************************
     C     SR100A        BEGSR
      *
     C                   SETOFF                                       101112
     C                   SETOFF                                       135055
     C                   SETOFF                                       212223
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
      *
     C   26              SETON                                        99
     C   26              GOTO      ENDA
      *
      * MUST HAVE COMPANY NUMBER
      *
     C     VCO           IFEQ      *ZEROS                                                   K
     C                   SETON                                        101199
     C                   GOTO      ENDA
     C                   ENDIF
      *
      * VALIDATE COMPANY NUMBER
      *
     C     VCO           CHAIN     FMCORG                             95
     C  N95              MOVEL     RGNAME        VNAME
     C   95              SETON                                        101199
     C   11              GOTO      ENDA
      *
      * VALIDATE COMPANY NUMBER
      *
     C     CKEY          KLIST
     C                   KFLD                    VCO
     C     CKEY          CHAIN     FMAPER                             96
     C  N96              MOVEL     ACMPCN        OMPCN             1
      *
     C     VACT          IFEQ      'A'
     C  N96              SETON                                        991012
     C   12              GOTO      ENDA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C   96              SETON                                        991013
     C   13              GOTO      ENDA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        88
     C                   ADD       1             CNTB              2 0
     C                   GOTO      ENDA
     C                   ENDIF
      *
     C                   SETON                                        5055
      *
     C     ENDA          ENDSR
      *
      **************************
      * SR100B - MIDDLE OF SCREEN
      **************************
      *
     C     SR100B        BEGSR
      *
     C                   SETOFF                                       101112
     C                   SETOFF                                       13
     C                   SETOFF                                       282920
     C                   SETOFF                                       414243
     C                   SETON                                        50
     C   KF              SETON                                        87
     C   KF              GOTO      ENDB
      *
     C   KC
     COR KG              GOTO      END
      *
      * MONTH/PERIOD REQUIRED
      *
     C     ACMPCN        IFNE      'P'
     C     ACMPCN        ANDNE     'M'
     C                   SETON                                        9910
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        01
     C                   SETOFF                                       02
     C                   ENDIF
      *
     C     ACMPCN        IFEQ      'P'
     C                   SETON                                        02
     C                   SETOFF                                       01
     C                   ENDIF
      *
     C   01              MOVEL     ' Month'      MONTH
     C   01              MOVE      'Number'      MONTH
     C   02              MOVEL     'Period'      MONTH
     C   02              MOVE      ' Number'     MONTH
      *
     C     ACFSST        IFEQ      *ZEROS
     C                   SETON                                        111299
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C                   Z-ADD     ACFSST        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        111399
     C                   GOTO      ENDB
     C                   ENDIF
      *
     C                   Z-ADD     ACFSST        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         FSST              5 0
      *
     C     VACT          IFEQ      'A'
     C                   Z-ADD     ACFSST        ST(01)
     C                   ENDIF
      *
     C  N99              SETON                                        51
     C  N99              SETOFF                                       50
      *
     C     ENDB          TAG
     C                   ENDSR
      *
      **************************
      * SR100C - BOTTOM OF SCREEN
      **************************
      *
     C     SR100C        BEGSR
     C                   SETON                                        51
     C                   SETOFF                                       030432
     C                   SETOFF                                       993130
     C                   SETOFF                                       616263
     C                   SETOFF                                       646566
     C                   SETOFF                                       676869
     C                   SETOFF                                       707172
     C                   SETOFF                                       737475
     C                   SETOFF                                       767778
     C                   SETOFF                                       798081
     C                   SETOFF                                       828384
     C                   SETOFF                                       858960
      *
     C   KF              SETON                                        86
     C   KF              GOTO      ENDC
      *
     C   KC
     COR KG              GOTO      END
      *
     C                   EXSR      CKDAT
     C   99              GOTO      ENDC
      *
     C                   Z-ADD     ST(01)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4499
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(02)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4599
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(03)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4699
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(04)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4799
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(05)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4899
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(06)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4999
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(07)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4699
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(08)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4799
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(09)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        5899
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(10)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        5999
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(11)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        5299
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(12)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        5399
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C   02              Z-ADD     ST(13)        ##MDY
     C   02              CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        5499
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(01)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3399
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(02)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3499
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(03)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3599
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(04)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3699
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(05)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3799
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(06)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3899
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(07)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3999
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(08)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1499
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(09)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1599
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(10)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1699
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(11)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1799
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(12)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1899
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C   02              Z-ADD     EN(13)        ##MDY
     C   02              CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1999
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(01)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST01              5 0
     C   99              GOTO      ENDC
      *
     C     ST(01)        IFNE      ACFSST
     C                   SETON                                        6199
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(01)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN01              5 0
     C   99              GOTO      ENDC
      *
     C     EN01          IFLT      ST01
     C                   SETON                                        6299
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(02)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST02              5 0
      *
     C     ST02          SUB       EN01          DIF2              5 0
     C     DIF2          IFNE      1
     C                   SETON                                        6399
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(02)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN02              5 0
     C   99              GOTO      ENDC
      *
     C     EN02          IFLT      ST02
     C                   SETON                                        6499
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(03)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST03              5 0
      *
     C     ST03          SUB       EN02          DIF3              5 0
     C     DIF3          IFNE      1
     C                   SETON                                        6599
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(03)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN03              5 0
     C   99              GOTO      ENDC
      *
     C     EN03          IFLT      ST03
     C                   SETON                                        6699
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(04)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST04              5 0
      *
     C     ST04          SUB       EN03          DIF4              5 0
     C     DIF4          IFNE      1
     C                   SETON                                        6799
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(04)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN04              5 0
     C   99              GOTO      ENDC
      *
     C     EN04          IFLT      ST04
     C                   SETON                                        6899
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(05)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST05              5 0
      *
     C     ST05          SUB       EN04          DIF5              5 0
     C     DIF5          IFNE      1
     C                   SETON                                        6999
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(05)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN05              5 0
     C   99              GOTO      ENDC
      *
     C     EN05          IFLT      ST05
     C                   SETON                                        7099
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(06)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST06              5 0
      *
     C     ST06          SUB       EN05          DIF6              5 0
     C     DIF6          IFNE      1
     C                   SETON                                        7199
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(06)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN06              5 0
     C   99              GOTO      ENDC
      *
     C     EN06          IFLT      ST06
     C                   SETON                                        7299
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(07)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST07              5 0
      *
     C     ST07          SUB       EN06          DIF7              5 0
     C     DIF7          IFNE      1
     C                   SETON                                        7399
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(07)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN07              5 0
     C   99              GOTO      ENDC
      *
     C     EN07          IFLT      ST07
     C                   SETON                                        7499
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(08)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST08              5 0
      *
     C     ST08          SUB       EN07          DIF8              5 0
     C     DIF8          IFNE      1
     C                   SETON                                        7599
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(08)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN08              5 0
     C   99              GOTO      ENDC
      *
     C     EN08          IFLT      ST08
     C                   SETON                                        7699
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(09)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST09              5 0
      *
     C     ST09          SUB       EN08          DIF9              5 0
     C     DIF9          IFNE      1
     C                   SETON                                        7799
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(09)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN09              5 0
     C   99              GOTO      ENDC
      *
     C     EN09          IFLT      ST09
     C                   SETON                                        7899
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(10)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST10              5 0
      *
     C     ST10          SUB       EN09          DIF10             5 0
     C     DIF10         IFNE      1
     C                   SETON                                        7999
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(10)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN10              5 0
     C   99              GOTO      ENDC
      *
     C     EN10          IFLT      ST10
     C                   SETON                                        8099
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(11)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST11              5 0
      *
     C     ST11          SUB       EN10          DIF11             5 0
     C     DIF11         IFNE      1
     C                   SETON                                        8199
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(11)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN11              5 0
     C   99              GOTO      ENDC
      *
     C     EN11          IFLT      ST11
     C                   SETON                                        8299
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     ST(12)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ST12              5 0
      *
     C     ST12          SUB       EN11          DIF12             5 0
     C     DIF12         IFNE      1
     C                   SETON                                        8399
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   Z-ADD     EN(12)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN12              5 0
     C   99              GOTO      ENDC
      *
     C     EN12          IFLT      ST12
     C                   SETON                                        8499
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C   02              GOTO      PER13
     C                   ADD       1             FIRST             2 0
     C     FIRST         IFGT      1
     C                   GOTO      PER13
     C                   ENDIF
     C     EN12          SUB       EN11          DIFEND            5 0
     C     FIRST         IFEQ      1
     C     DIFEND        ANDGT     35
     C                   SETON                                        0399
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C     PER13         TAG
     C   02              Z-ADD     ST(13)        ##MDY
     C   02              CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C   02              CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C   02              Z-ADD     ##DDD         ST13              5 0
      *
     C   02ST13          SUB       EN12          DIF13             5 0
     C   02DIF13         IFNE      1
     C                   SETON                                        8599
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C   02              Z-ADD     EN(13)        ##MDY
     C   02              CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C   02              CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EN13              5 0
     C   99              GOTO      ENDC
      *
     C     EN13          IFLT      ST13
     C                   SETON                                        8999
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C                   ADD       1             FIRST             2 0
     C     FIRST         IFGT      1
     C                   GOTO      ENDC
     C                   ENDIF
     C     EN13          SUB       EN12          DIFEND            5 0
     C     DIFEND        IFGT      35
     C                   SETON                                        04
     C                   GOTO      ENDC
     C                   ENDIF
      *
     C     ENDC          TAG
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
     C                   MOVEL     VCO           ACCOMP
     C   01              Z-ADD     0             ST(13)
     C   01              Z-ADD     0             EN(13)
     C   21              WRITE     RMAPER
     C   22              UPDATE    RMAPER
     C   23              DELETE    RMAPER
     C                   ENDSR
      *
      **********
      * CKDAT  *
      **********
     C     CKDAT         BEGSR
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     1             Z                 2 0
     C     NXTS          TAG
     C     ST(X)         IFEQ      *ZEROS
     C                   SETON                                        303199
     C                   GOTO      ECKDAT
     C                   ENDIF
     C                   ADD       1             X
     C   01X             IFGT      12
     C                   GOTO      NXTE
     C                   ENDIF
     C   02X             IFGT      13
     C                   GOTO      NXTE
     C                   ENDIF
     C                   GOTO      NXTS
     C     NXTE          TAG
     C     EN(Z)         IFEQ      *ZEROS
     C                   SETON                                        303299
     C                   GOTO      ECKDAT
     C                   ENDIF
     C                   ADD       1             Z
     C   01Z             IFGT      12
     C                   GOTO      ECKDAT
     C                   ENDIF
     C   02Z             IFGT      13
     C                   GOTO      ECKDAT
     C                   ENDIF
     C                   GOTO      NXTE
     C     ADDDAT        TAG
      *
     C     ECKDAT        ENDSR
      *
      **********
      * CENT   *  CALCULATE CENTURY IE 19 OR 20
      **********
     C     CENT          BEGSR
     C                   Z-ADD     1             Q                 2 0
     C     NXTQ          TAG
     C                   Z-ADD     EN(Q)         ENY(Q)
     C     ENY(Q)        IFGT      60
     C                   Z-ADD     19            CE(Q)
     C                   ELSE
     C                   Z-ADD     20            CE(Q)
     C                   ENDIF
     C                   ADD       1             Q
     C   01Q             IFGT      12
     C                   GOTO      ENDQ
     C                   ENDIF
     C   02Q             IFGT      13
     C                   GOTO      ENDQ
     C                   ENDIF
     C                   GOTO      NXTQ
     C     ENDQ          ENDSR
      *
