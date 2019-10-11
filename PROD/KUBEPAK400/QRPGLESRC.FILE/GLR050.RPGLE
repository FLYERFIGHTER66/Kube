      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-        GLR050
      **COMPANY-             EFD ENTERPRISES, INC.
      **SYSTEM-              GLAPPR
      **DESCRIPTION-         THIS PROGRAM SUPPORTS G/L FORMAT FILE
      **                     MAINTENANCE
      *
      * CHANGE LOG:
      *
      *
     FGLR050FM  CF   E             WORKSTN
     F                                     SFILE(GRPSFL:RECNO)
     F                                     SFILE(DETSFL:RECN1)
     F                                     SFILE(DELSFL:RECN2)
     FFGLREF    UF A E           K DISK
     FFGLFMH    UF A E           K DISK
     FFGLFMI    UF A E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLCTL    IF   E           K DISK
      *
      ** ARRAY WITH ACCOUNT TYPE
     D AY              S              9    DIM(4) CTDATA PERRCD(1)              ACC. TYPES
      ** ARRAY WITH EXISTING GROUP NUMBERS
     D EX              S              5  0 DIM(9999)                            RECNO OF SFL
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
      * IF NO GLCTL END PROGRAM CHECKED IN *INZ
     C   99              GOTO      END
      *
      * MAIN LOGIC
      *
     C     RSTART        TAG
     C                   Z-ADD     LCO           GHCOMP
     C                   MOVE      '0'           *IN
     C                   MOVEL     'A'           VACT
     C                   MOVE      *BLANKS       VREF
     C                   MOVE      *BLANKS       DETEXT            1
     C                   MOVE      *BLANKS       VNAME
     C*          GZNMCO    IFEQ 1
     C*                    Z-ADDGZPRCO    VCO     20
     C*                    SETON                     55
     C*                    ELSE
     C*                    Z-ADDGZPRCO    VCO
     C*                    SETOF                     55
     C*                    END
     C                   Z-ADD     LCO           VCO               2 0
      ************
      * SCREEN A *
      ************
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                           40
      *
     C   KC
     COR KG              GOTO      END
      *
     C                   MOVEL     VREF          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     *BLANKS       GXLOOK           15
     C                   MOVEL     *BLANKS       GXRTYP
     C                   CALL      'LKGLRF'
     C                   PARM                    GXLOOK
     C                   PARM                    GXRPRT
     C                   PARM                    GXRTYP
     C                   MOVEL     *BLANKS       VREF
     C                   MOVEL     GXRPRT        VREF
     C**                   MOVELGXLOOK    VDESC
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
     C                   SETOFF                                       99
      *
      *****TEST ACTION CODE
      *
     C     VACT          IFNE      'A'
     C     VACT          ANDNE     'C'
     C     VACT          ANDNE     'D'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VREF          IFEQ      *BLANKS
     C                   SETON                                        12
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   MOVEL     VREF          GHRPRT
     C     REFKEY        KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VREF
     C     REFKEY        CHAIN     FGLREF                             12
     C   12              MOVEL     'N'           REFEX             1
     C  N12              MOVEL     'Y'           REFEX
      ** ON ADD CANNOT EXIST
     C     VACT          IFEQ      'A'
     C  N12              SETON                                        13
     C   13              GOTO      NXTA
     C                   ENDIF
      ** ON CHSNGE/DELETE HAS TO EXIST
     C     VACT          IFNE      'A'
     C   12              SETON                                        14
     C   14              GOTO      NXTA
     C                   ENDIF
      *
      * DELETE SELECTED
     C     VACT          IFEQ      'D'
     C                   SETON                                        40
     C     NXTDSC        TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KX              DO
     C                   EXSR      DELRPT
     C                   GOTO      RSTART
     C                   ENDDO
     C   KF              GOTO      RSTART
     C                   GOTO      NXTDSC
     C                   END
      *
      ************
      * SCREEN B *
      ************
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   SETOFF                                       102030
     C                   SETOFF                                           40
      *
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C   KB              DO
     C                   GOTO      NXTA
     C                   ENDDO
      * CHECK REPORT SEARCH NAME
     C     GXLOOK        IFLE      *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   END
      * CHECK TYPE
     C     GXRTYP        IFLT      1
     C     GXRTYP        ORGT      5
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   END
      * CHECK DEPARTMENT REPORT
     C     GXRPDP        IFNE      'Y'
     C     GXRPDP        ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   END
     C     REFEX         IFEQ      'N'
     C                   MOVEL     'A'           GXSTAT
     C                   Z-ADD     LCO           GXCOMP
     C                   MOVEL     VREF          GXRPRT
     C                   WRITE     RGLREF
     C                   ELSE
     C                   UPDATE    RGLREF
     C                   END
      ******************
      * GROUP SUB FILE *
      ******************
      * GET GROUP SUB FILE
     C                   EXSR      BLDGRP
     C     NXTGRP        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     GRPCTL
      *
     C                   SETOFF                                       U1U2
      ** CANNOT BAILOUT OF ADD IF DETAIL RECORDS EXIST
     C   KC
     COR KF
     COR KG              DO
     C   KC
     COR KG              SETON                                        U1
     C   KF              SETON                                        U2
     C     VACT          IFEQ      'A'
     C     DETEXT        ANDEQ     'Y'
     C     NXF6          TAG
     C                   WRITE     SCRNDE
     C                   READ      SCRNDE                                 90
     C   KF              GOTO      NXTGRP
     C  NKX              GOTO      NXF6
     C                   EXSR      DELRPT
     C                   GOTO      RSTART
     C                   ENDIF
     C                   ENDDO
     C   KC
     COR U1
     COR KG              GOTO      END
     C   U2
     COR KF              GOTO      RSTART
      *
     C   KB              DO
     C                   EXSR      F2CHK
     C                   GOTO      NXTGRP
     C                   ENDDO
     C                   EXSR      CHKGRP
     C   99              GOTO      NXTGRP
     C  NKD              GOTO      NXTGRP
      ** OUTPUT THE RECORDS
     C                   EXSR      PUTGRP
     C                   GOTO      RSTART
      **
     C     END           TAG
     C                   SETON                                        LR
      ************************
      * BUILD GROUP SUB FILE *
      ************************
     C     BLDGRP        BEGSR
     C                   Z-ADD     0             EX
     C                   Z-ADD     0             LSTGRP
     C                   SETON                                        80
     C                   WRITE     GRPCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LINE
     C     REFKEY        SETLL     FGLFMH
     C                   MOVE      *BLANKS       FUNCT
     C     NXBGRP        TAG
     C     REFKEY        READE     FGLFMH                                 90
     C   90              GOTO      ENBGRP
     C                   SETON                                        10        PROT GROUP
     C                   MOVE      'Y'           EXIST
     C                   MOVEL     GHLVBR        OLLVBR
     C                   ADD       1             RECNO
     C                   Z-ADD     GHGRUP        E                 4 0
     C                   Z-ADD     GHGRUP        LSTGRP            4 0
     C                   Z-ADD     GHGRUP        OLGRUP
     C                   Z-ADD     RECNO         EX(E)
     C                   MOVEL     'Y'           CHKD
     C                   WRITE     GRPSFL
     C                   GOTO      NXBGRP
     C     ENBGRP        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   EXSR      BLDBGP
     C                   Z-ADD     RECNO         LSTREC
     C     LSTGRP        IFLE      0
     C                   Z-ADD     10            LSTGRP
     C                   END
     C                   SETOFF                                       98
     C                   ENDSR
      ************************
      * CHECK GROUP SUB FILE *
      ************************
     C     CHKGRP        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVEL     *BLANKS       TSLVBR            1
     C                   Z-ADD     0             LSTGRP            4 0
     C                   SETOFF                                       060712
     C                   SETOFF                                       272156
     C                   SETOFF                                       202530
     C                   SETOFF                                       354099
     C     NXCGRP        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENCGRP
     C                   END
     C     RECNO         CHAIN     GRPSFL                             90
     C   90              GOTO      NXCGRP
     C                   SETOFF                                       0511
     C                   SETOFF                                       263136
     C                   SETOFF                                       4122
     C     EXIST         IFEQ      'Y'
     C                   SETON                                        10        PROT GRP#
     C                   ELSE
     C                   SETOFF                                       10
     C                   END
     C     FUNCT         IFEQ      'D'
     C     OLLVBR        IFEQ      '1'
     C                   SETON                                        71
     C                   EXSR      DELDET
     C                   SETOFF                                       71
     C     FUNCT         IFNE      'D'
     C                   GOTO      ENGRPD
     C                   END
     C                   Z-ADD     OLGRUP        GRUP              4 0
     C     GRPKEY        CHAIN     FGLFMH                             90
     C  N90              DELETE    RGLFMH
     C                   MOVEL     'N'           GHRVSN
     C                   MOVE      *BLANKS       FUNCT
     C                   MOVE      *BLANKS       EXIST
     C                   MOVE      *BLANKS       OLLVBR
     C                   MOVE      *BLANKS       CHKD
     C                   Z-ADD     0             GHSPAF
     C                   Z-ADD     0             GHSPBF
     C                   Z-ADD     0             GHGRUP
     C                   Z-ADD     0             OLGRUP
     C                   MOVE      *BLANKS       GHDESC
     C                   MOVE      *BLANKS       GHLVBR
     C                   UPDATE    GRPSFL
     C                   GOTO      NXCGRP
     C                   END
     C     EXIST         IFNE      'Y'
     C     OLGRUP        IFGT      0
     C                   Z-ADD     OLGRUP        E
     C                   Z-ADD     0             EX(E)
     C                   END
     C                   Z-ADD     0             GHGRUP
     C                   Z-ADD     0             OLGRUP
     C                   MOVE      *BLANKS       GHDESC
     C                   MOVE      *BLANKS       GHLVBR
     C                   MOVE      *BLANKS       OLLVBR
     C                   Z-ADD     0             GHSPBF
     C                   Z-ADD     0             GHSPAF
     C                   MOVEL     'N'           GHRVSN
     C                   END
     C                   MOVE      *BLANKS       FUNCT
     C                   GOTO      NOCHKG
     C                   ENDIF
     C     ENGRPD        TAG
     C     GHLVBR        IFEQ      '?'
     C     GHLVBR        OREQ      '/'
     C                   EXSR      GETTYP
     C                   ENDIF
      * CHECK FUNCTION
     C     FUNCT         IFNE      'R'
     C     FUNCT         ANDNE     *BLANK
     C                   SETON                                        050699
     C                   ENDIF
     C     FUNCT         IFEQ      'R'
     C     GHLVBR        ANDNE     '1'
     C                   SETON                                        050799
     C                   END
      ** CHECK TEXT
     C     EXIST         IFEQ      'Y'
     C     GHDESC        ANDLE     *BLANKS
     C                   SETON                                        202299
     C                   END
     C     GHGRUP        IFGT      0
     C     GHDESC        ANDLE     *BLANKS
     C                   SETON                                        202299
     C                   END
     C     GHGRUP        IFLE      0
     C     GHDESC        ANDGT     *BLANKS
     C     OLGRUP        IFGT      0
     C                   Z-ADD     OLGRUP        E
     C                   Z-ADD     0             EX(E)
     C                   END
     C     NXTADG        TAG
     C                   ADD       5             LSTGRP
     C                   Z-ADD     LSTGRP        E
     C     EX(E)         IFGT      0
     C                   GOTO      NXTADG
     C                   END
     C                   Z-ADD     LSTGRP        EX(E)
     C                   Z-ADD     LSTGRP        GHGRUP
     C                   Z-ADD     LSTGRP        OLGRUP
     C                   END
     C     GHGRUP        IFGT      0
     C     GHGRUP        ANDNE     OLGRUP
     C                   Z-ADD     GHGRUP        E
     C     EX(E)         IFNE      RECNO
     C     EX(E)         ANDGT     0
     C                   SETON                                        111299
     C                   ELSE
     C                   Z-ADD     RECNO         EX(E)
     C     OLGRUP        IFGT      0
     C                   Z-ADD     OLGRUP        E
     C                   Z-ADD     0             EX(E)
     C                   END                                                    OLGRUP>0
     C                   Z-ADD     GHGRUP        OLGRUP
     C                   END                                                    EX,E><RECNO
     C                   END                                                    GHGRUP>0
      ** CHECK TYPE IF IT WAS 1 AND CHANGED SHOW SCREEN TO DELETE DET
     C     GHLVBR        IFNE      '1'
     C     OLLVBR        ANDEQ     '1'
     C                   SETOFF                                       71
     C                   EXSR      DELDET
     C                   END
      ** CHECK TYPE
     C     EXIST         IFEQ      'Y'
     C     GHDESC        ORGT      *BLANKS
     C     GHLVBR        IFNE      'H'
     C     GHLVBR        ANDNE     '0'
     C     GHLVBR        ANDNE     '1'
     C     GHLVBR        ANDNE     '2'
     C     GHLVBR        ANDNE     '3'
     C     GHLVBR        ANDNE     '4'
     C     GHLVBR        ANDNE     '5'
     C     GHLVBR        ANDNE     '6'
     C     GHLVBR        ANDNE     '7'
     C     GHLVBR        ANDNE     '8'
     C     GHLVBR        ANDNE     '9'
     C     GHLVBR        ANDNE     'T'
     C                   SETON                                        252699
     C                   ELSE
     C                   MOVEL     GHLVBR        OLLVBR
     C                   END
     C                   END
      ** CHECK SPACE BEFORE
     C     GHSPBF        IFLT      0
     C     GHSPBF        ORGT      3
     C                   SETON                                        303199
     C                   END
      ** CHECK SPACE AFTER
     C     GHSPAF        IFLT      0
     C     GHSPAF        ORGT      3
     C                   SETON                                        353699
     C                   END
      ** CHECK REVERSE SIGN
     C     GHLVBR        IFNE      'H'
     C     GHLVBR        ANDNE     '0'
     C     GHRVSN        IFNE      'Y'
     C     GHRVSN        ANDNE     'N'
     C                   SETON                                        404199
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       GHRVSN
     C                   END
      ** IF TYPE 1 CHECK DETAIL
     C     GHLVBR        IFEQ      '1'
     C                   MOVEL     GHLVBR        HLVBR             1
     C     FUNCT         IFNE      'R'
     C     CHKD          ANDEQ     'Y'
     C                   EXSR      CHKDET
     C                   ELSE
     C                   EXSR      GETDET
     C                   END
     C     RECNO         CHAIN     GRPSFL                             90
     C  N25
     CANN26              MOVEL     'Y'           CHKD
     C                   MOVEL     HLVBR         GHLVBR
     C     FUNCT         IFEQ      'R'
     C                   MOVE      *BLANKS       FUNCT
     C                   END
     C                   END
      ** TAG FOR DELETE FUNCTION
     C     NOCHKG        TAG
     C                   UPDATE    GRPSFL
     C     GHLVBR        IFGT      *BLANKS
     C     GHGRUP        ANDGT     LSTGRP
     C                   MOVEL     GHLVBR        TSLVBR            1
     C                   Z-ADD     GHGRUP        LSTGRP
     C                   END
     C                   GOTO      NXCGRP
     C     ENCGRP        TAG
     C  N99              DO
     C     TSLVBR        IFNE      'T'
     C                   SETON                                        56  99
     C                   END
     C                   ENDDO                                                  N99 DO
     C   99              SETOFF                                       98
     C  N99              SETON                                        98
     C                   ENDSR
      ************************
      *   PUT GROUP SUB FILE *
      ************************
     C     PUTGRP        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C     NXPGRP        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENPGRP
     C                   END
     C     RECNO         CHAIN     GRPSFL                             90
     C   90              GOTO      NXPGRP
      ** CHECK FOR DELETE
     C     FUNCT         IFEQ      'D'
     C     EXIST         ANDEQ     'Y'
     C     GRPKEY        KLIST
     C                   KFLD                    VCO
     C                   KFLD                    GHRPRT
     C                   KFLD                    GRUP
     C                   Z-ADD     OLGRUP        GRUP              4 0
     C     GRPKEY        CHAIN     FGLFMH                             90
     C  N90              DELETE    RGLFMH
     C                   GOTO      NXPGRP
     C                   END
     C     GHGRUP        IFLE      0
     C                   GOTO      NXPGRP
     C                   END
      ** SAVE FIELDS
     C                   Z-ADD     GHGRUP        GRUP
     C                   MOVEL     GHLVBR        LVBR              1
     C                   Z-ADD     GHSPBF        SPBF              1 0
     C                   Z-ADD     GHSPAF        SPAF              1 0
     C                   MOVEL     GHRVSN        RVSN              1
     C                   MOVEL     GHDESC        DESC             40
     C     GRPKEY        CHAIN     FGLFMH                             90
     C   90              DO
     C                   MOVEL     'A'           GHSTAT
     C                   Z-ADD     GRUP          GHGRUP
     C                   ENDDO
     C                   Z-ADD     GRUP          GHGRUP
     C                   MOVEL     LVBR          GHLVBR
     C                   Z-ADD     SPBF          GHSPBF
     C                   Z-ADD     SPAF          GHSPAF
     C                   MOVEL     RVSN          GHRVSN
     C                   MOVEL     DESC          GHDESC
     C   90              WRITE     RGLFMH
     C  N90              UPDATE    RGLFMH
     C                   GOTO      NXPGRP
     C     ENPGRP        TAG
     C                   ENDSR
      ************************
      * REVIEW ALL DETAIL    *
      ************************
     C     F2CHK         BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C     NXF2          TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDF2
     C                   END
     C     RECNO         CHAIN     GRPSFL                             90
     C   90              GOTO      NXF2
     C     GHLVBR        IFEQ      '1'
     C                   EXSR      GETDET
     C                   END
     C                   GOTO      NXF2
     C     ENDF2         ENDSR
      ************************
      * GET LINE TYPE        *
      ************************
     C     GETTYP        BEGSR
     C                   SETOFF                                       71
     C                   MOVE      *BLANKS       TYPCD
     C     NXTTYP        TAG
     C                   WRITE     SCRNTYP
     C                   READ      SCRNTYP                                90
     C     TYPCD         IFNE      'H'
     C     TYPCD         ANDNE     '0'
     C     TYPCD         ANDNE     '1'
     C     TYPCD         ANDNE     '2'
     C     TYPCD         ANDNE     '3'
     C     TYPCD         ANDNE     '4'
     C     TYPCD         ANDNE     '5'
     C     TYPCD         ANDNE     '6'
     C     TYPCD         ANDNE     '7'
     C     TYPCD         ANDNE     '8'
     C     TYPCD         ANDNE     '9'
     C     TYPCD         ANDNE     'T'
     C                   SETON                                        71
     C                   GOTO      NXTTYP
     C                   ENDIF
     C                   MOVEL     TYPCD         GHLVBR
     C                   ENDSR
      ************************
      * CHECK FOR DETAIL RECS*
      ************************
     C     CHKDET        BEGSR
     C     DETKEY        SETLL     FGLFMI
     C     DETKEY        READE     FGLFMI                                 90
     C   90              DO
     C                   SETON                                        262799
     C                   ENDDO
     C                   ENDSR
      ************************
      * CHECK FOR DELETE DET *
      ************************
     C     DELDET        BEGSR
     C                   SETON                                        80
     C                   WRITE     DELCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECN2             5 0
     C     DETKEY        KLIST
     C                   KFLD                    GHCOMP
     C                   KFLD                    GHRPRT
     C                   KFLD                    GHGRUP
     C     DETKEY        SETLL     FGLFMI
     C     NXDDEL        TAG
     C     DETKEY        READE     FGLFMI                                 90
     C   90              GOTO      ENDEL
     C     GHCOMP        IFGT      0
     C                   Z-ADD     GHCOMP        COMP              2 0
     C                   ELSE
     C                   Z-ADD     01            COMP
     C                   END
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GIGLAC
     C     GLKEY         CHAIN     FMGLCH                             91
     C   91              MOVE      *BLANKS       GCDESC
     C                   ADD       1             RECN2
     C                   WRITE     DELSFL
     C                   GOTO      NXDDEL
      ** SHOW SUBFILE
     C     ENDEL         TAG
     C                   EXFMT     DELCTL
     C   KF              DO
     C                   MOVEL     '1'           GHLVBR
     C                   MOVEL     ' '           FUNCT
     C                   GOTO      NODDEL
     C                   ENDDO
     C  NKX              GOTO      ENDEL
     C     DETKEY        SETLL     FGLFMI
     C     NXDDE1        TAG
     C     DETKEY        READE     FGLFMI                                 90
     C   90              GOTO      NODDEL
     C                   DELETE    RGLFMI
     C                   GOTO      NXDDE1
     C                   MOVEL     'D'           FUNCT
     C     NODDEL        TAG
     C                   ENDSR
      ************************
      * UPDATE DETAIL RECORDS*
      ************************
     C     GETDET        BEGSR
     C                   SETON                                        80
     C                   WRITE     DETCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     0             LSTDSQ            3 0
     C     DETKEY        SETLL     FGLFMI
     C     NXDBLD        TAG
     C     DETKEY        READE(N)  FGLFMI                                 90
     C   90              GOTO      ENDBLD
     C     GHCOMP        IFGT      0
     C                   Z-ADD     GHCOMP        COMP              2 0
     C                   ELSE
     C                   Z-ADD     01            COMP
     C                   END
     C     GLKEY         CHAIN     FMGLCH                             91
     C                   MOVE      *BLANKS       SRCH
     C   91              MOVE      *BLANKS       GCDESC
     C   91              MOVE      *BLANKS       ATYPE
     C  N91              MOVEL     AY(GCATYP)    ATYPE
     C                   MOVEL     'Y'           DEXIST
     C                   ADD       1             RECN1
     C                   Z-ADD     GISEQ#        LSTDSQ
     C                   WRITE     DETSFL
     C                   GOTO      NXDBLD
     C     ENDBLD        TAG
      ** BUILD EXTRA RECORDS
     C     RECN1         ADD       100           LSTRD             5 0
     C                   Z-ADD     0             GIGLAC
     C                   Z-ADD     0             GISEQ#
     C                   MOVE      *BLANKS       GCDESC
     C                   MOVE      *BLANKS       SRCH
     C                   MOVE      *BLANKS       DEXIST
     C                   MOVE      *BLANKS       ATYPE
     C     RECN1         DOUGT     LSTRD
     C                   ADD       1             RECN1
     C                   WRITE     DETSFL
     C                   ENDDO
      ** SHOW SUBFILE
     C     NXTDSF        TAG
     C                   EXFMT     DETCTL
      ** CHECK F KEYS
     C   KF              DO
     C                   EXSR      CHKDET
     C                   GOTO      ENDDSF
     C                   ENDDO
      ** CHECK INPUT
     C                   Z-ADD     0             RECN1
     C                   Z-ADD     0             DETCNT            5 0
     C                   SETOFF                                       727374
     C                   SETOFF                                       757677
     C                   SETOFF                                       7879
     C     CKDET         TAG
     C                   ADD       1             RECN1
     C     RECN1         IFGT      LSTRD
     C                   GOTO      ENDCSF
     C                   END
     C                   SETOFF                                       72  75
     C     RECN1         CHAIN     DETSFL                             90
     C   90              GOTO      CKDET
      ** CHECK SEARCH
     C     SRCH          IFNE      '?'
     C     SRCH          ANDNE     '/'
     C     SRCH          ANDNE     'D'
     C     SRCH          ANDNE     *BLANKS
     C                   SETON                                        757679
     C                   ENDIF
     C     SRCH          IFEQ      '?'
     C     SRCH          OREQ      '/'
     C                   MOVE      *BLANKS       GCLOOK
     C                   Z-ADD     0             GCGLNO
     C                   Z-ADD     LCO           GCCOMP
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   Z-ADD     GCGLNO        GIGLAC
     C                   MOVE      *BLANKS       SRCH
     C                   ENDIF
      ** CK GL NO
     C     GIGLAC        IFGT      0
     C     GLKEY         CHAIN     FMGLCH                             72
     C   72              DO
     C                   MOVE      *BLANKS       GCDESC
     C                   SETON                                        7379
     C                   MOVE      *BLANKS       ATYPE
     C                   ENDDO
     C                   ELSE                                                   GIGLAC>0
     C                   MOVE      *BLANKS       ATYPE
     C                   MOVE      *BLANKS       GCDESC
     C                   END
      ******   CHECK THAT REPORT TYPE AND G/L ACCOUNT TYPE MATCH
      ******   REPORT TYPE 1 USES ACCOUNT TYPES 1 AND 2
      ******   REPORT TYPE 2 USES ACCOUNT TYPES 3 AND 4
      ******   REPORT TYPE 3 USES ANY ACCOUNT TYPE 1 - 4
      ******   REPORT TYPE 4 USES ACCOUNT TYPES 3 AND 4
      ******   REPORT TYPE 5 USES ANY ACCOUNT TYPE 1 - 4
     C     GIGLAC        IFGT      0
      ** REPORT TYPE 1
     C     GXRTYP        IFEQ      1
     C     GCATYP        IFNE      1
     C     GCATYP        ANDNE     2
     C                   SETON                                        727479
     C                   END
     C                   END
      ** REPORT TYPE 2
     C     GXRTYP        IFEQ      2
     C     GCATYP        IFNE      3
     C     GCATYP        ANDNE     4
     C                   SETON                                        727479
     C                   END
     C                   END
      ** REPORT TYPE 4
     C     GXRTYP        IFEQ      4
     C     GCATYP        IFNE      3
     C     GCATYP        ANDNE     4
     C                   SETON                                        727479
     C                   END
     C                   END
     C  N72              MOVEL     AY(GCATYP)    ATYPE
     C  N72              ADD       1             DETCNT
     C                   ENDIF                                                  GIGLAC>0
     C                   UPDATE    DETSFL
     C                   GOTO      CKDET
      ** END CHECK
     C     ENDCSF        TAG
      ** IF ANY ERRORS
     C  N79DETCNT        IFGE      1
     C                   SETON                                        78
     C                   ELSE
     C                   SETON                                        7975
     C                   END
     C   79              SETOFF                                       78
     C   79              GOTO      NXTDSF
     C  NKA              GOTO      NXTDSF
      ** OUTPUT DETAIL RECS
     C                   Z-ADD     0             RECN1
     C     NXDOUT        TAG
     C                   ADD       1             RECN1
     C     RECN1         IFGT      LSTRD
     C                   GOTO      ENDDSF
     C                   END
     C     RECN1         CHAIN     DETSFL                             90
     C   90              GOTO      NXDOUT
     C                   Z-ADD     GIGLAC        HDGLAC            8 0
     C     DOUTKY        KLIST
     C                   KFLD                    GHCOMP
     C                   KFLD                    GHRPRT
     C                   KFLD                    GIGRUP
     C                   KFLD                    GISEQ#
     C     GISEQ#        IFGT      0
     C     DOUTKY        CHAIN     FGLFMI                             87
     C                   ELSE
     C                   SETON                                        87
     C                   END
     C     SRCH          IFEQ      'D'
     C     GIGLAC        ORLE      0
     C  N87              DELETE    RGLFMI
     C                   GOTO      NXDOUT
     C                   ENDIF
     C   87              DO
     C                   MOVEL     'A'           GISTAT
     C                   Z-ADD     GHCOMP        GICOMP
     C                   Z-ADD     GHCOMP        GICOMD
     C                   MOVEL     GHRPRT        GIRPRT
     C                   Z-ADD     GHGRUP        GIGRUP
     C                   ADD       1             LSTDSQ
     C                   Z-ADD     LSTDSQ        GISEQ#
     C                   ENDDO                                                  87  DO
     C                   MOVEL     'Y'           DETEXT
     C                   Z-ADD     HDGLAC        GIGLAC
     C   87              WRITE     RGLFMI
     C  N87              UPDATE    RGLFMI
     C                   GOTO      NXDOUT
      ** END SR
     C     ENDDSF        TAG
     C                   ENDSR
      ************************
      * BUILD BLANK GRP RECS *
      ************************
     C     BLDBGP        BEGSR
     C                   Z-ADD     LSTREC        RECNO
     C                   SETOFF                                       10
     C                   MOVEL     'N'           GHRVSN
     C                   MOVE      *BLANKS       EXIST
     C                   MOVE      *BLANKS       OLLVBR
     C                   MOVE      *BLANKS       CHKD
     C                   Z-ADD     0             GHSPAF
     C                   Z-ADD     0             GHSPBF
     C                   Z-ADD     0             GHGRUP
     C                   Z-ADD     0             OLGRUP
     C                   MOVE      *BLANKS       GHDESC
     C                   MOVE      *BLANKS       GHLVBR
      ** BUILD BLANK RECORDS
     C     RECNO         ADD       100           TSTREC            5 0
     C     RECNO         DOUGT     TSTREC
     C                   ADD       1             RECNO
     C                   WRITE     GRPSFL
     C                   ENDDO
     C                   ENDSR
      **************************
      ** DELETE ENTIRE REPORT **
      **************************
     C     DELRPT        BEGSR
     C     REFKEY        CHAIN     FGLREF                             12
     C  N12              DELETE    RGLREF
     C     REFKEY        SETLL     FGLFMH
     C     NXDELR        TAG
     C     REFKEY        READE     FGLFMH                                 90
     C   90              GOTO      ENDLGP
     C                   DELETE    RGLFMH
     C                   GOTO      NXDELR
     C     ENDLGP        TAG
     C     REFKEY        SETLL     FGLFMI                                 90
     C     NXDLGP        TAG
     C     REFKEY        READE     FGLFMI                                 90
     C   90              GOTO      ENDDGP
     C                   DELETE    RGLFMI
     C                   GOTO      NXDLGP
     C     ENDDGP        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     0             VCO
     C     LCO           CHAIN     FGLCTL                             99
      ** IF NO CONTROL RECORD GET OUT OF PROGRAM
     C   99              DO
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   ENDDO
     C                   ENDSR
      *
** ACCOUNT TYPE ARRAY
Asset
Liability
Income
Expense
