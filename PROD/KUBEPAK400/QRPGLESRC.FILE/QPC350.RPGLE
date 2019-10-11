      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- QPC350
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALES ANALYSIS BY P/C DETAIL SELECTED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMPRCL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FQPK350FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
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
     D                UDS
     D  LCO                    1      2  0
     D  LBPC                  11     12
     D  LEPC                  13     14
     D  BDATE                 15     21  0
     D  EDATE                 22     28  0
     D  CUSTNO                29     34  0
     D  BEGTYP                35     36
     D  ENDTYP                37     38
     D  LBDATE                39     44  0
     D  LEDATE                45     50  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
WJB  D  PRINTDTL             172    172
WJB  D  PRINTPRCL            173    173
WJB  D  PRINTCUST            174    174
      *
     C                   SETOFF                                       98
      *
     C                   Z-ADD     0             LBDATE
     C                   Z-ADD     0             LEDATE
     C                   Z-ADD     0             CUSTNO
     C                   MOVE      *BLANKS       BEGTYP
     C                   MOVE      *BLANKS       ENDTYP
     C                   MOVE      *BLANKS       ALPHA
WJB  C                   MOVE      'Y'           PRINTDTL
WJB  C                   MOVE      'Y'           PRINTPRCL
WJB  C                   MOVE      'Y'           PRINTCUST
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101150
     C                   SETOFF                                       515260
     C                   SETOFF                                       616212
WJB  C                   SETOFF                                       636465
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      END
     C                   MOVEL     *BLANKS       LCANCL
      *
     C     LBDATE        IFEQ      0                                                        K
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     LBDATE        ##MDY                                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        BDATE             7 0
      *
     C     LEDATE        IFEQ      0                                                        K
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     LEDATE        ##MDY                                      K
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        EDATE             7 0
     C     EDATE         IFLT      BDATE
     C                   SETON                                        101112
     C                   GOTO      NXTA
     C                   END
      *
      *
     C     1             SUBST     LBPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LBPC          VPRCL             2
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LBPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     1             SUBST     LEPC:1        VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     LEPC          VPRCL
     C                   EXSR      PCSR
     C                   MOVEL     VPRCL         LEPC
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LBPC          CHAIN     FMPRCL                             91
     C   91              SETON                                        52
     C   52              GOTO      NXTA
      *
     C     LBPC          IFGT      *BLANKS                                                  K
     C     LBPC          ANDGT     LEPC
     C                   SETON                                        51
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
     C     LEPC          ANDEQ     *BLANKS
     C                   MOVEL     LBPC          LEPC
     C                   ENDIF
      *
     C     LBPC          IFEQ      *BLANKS                                                  K
     C     LEPC          ANDGT     *BLANKS
     C                   SETON                                        51
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LEPC          IFGT      *BLANKS                                                  K
     C     LEPC          CHAIN     FMPRCL                             91
     C   91              SETON                                        60
     C   60              GOTO      NXTA
     C                   ENDIF
      *
     C     BEGTYP        IFEQ      *BLANKS                                                  K
     C     ENDTYP        ANDGT     *BLANKS
     C                   SETON                                        61
     C                   GOTO      NXTA
     C                   ENDIF
     C     BEGTYP        IFGT      *BLANKS                                                  K
     C     ENDTYP        ANDEQ     *BLANKS
     C                   MOVEL     BEGTYP        ENDTYP
     C                   ENDIF
      *
     C     BEGTYP        IFGT      ENDTYP                                                   K
     C                   SETON                                        61
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     CUSTNO        IFGT      0
     C     CUSTNO        CHAIN     FMCUST                             62
     C   62              GOTO      NXTA
     C                   MOVE      *BLANKS       ALPHA
     C                   END
     C     ALPHA         IFGT      *BLANKS
     C                   MOVEL     ALPHA         CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   Z-ADD     CMCUST        CUSTNO
     C                   END
      *
WJB  C                   If        PRINTDTL <> 'Y' and PRINTDTL <> 'N'
WJB  C                   Eval      *In63 = *On
WJB  C                   GOTO      NXTA
WJB  C                   END
      *
WJB  C                   If        PRINTPRCL <> 'Y' and PRINTPRCL <> 'N'
WJB  C                   Eval      *In64 = *On
WJB  C                   GOTO      NXTA
WJB  C                   END
      *
WJB  C                   If        PRINTCUST <> 'Y' and PRINTCUST <> 'N'
WJB  C                   Eval      *In65 = *On
WJB  C                   GOTO      NXTA
WJB  C                   END
      *
     C     END           TAG
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C                   SETON                                        LR
      *
      *********
      * PCSR
      *********
     C     PCSR          BEGSR
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   MOVEL     PCDESC        VDESC            30
     C                   ENDSR
