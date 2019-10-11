    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR650
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- ORDER DUE DATE MODIFICATION
      *
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  4/28/00 EFD ADD SUMMARY PICK SLIP OPTION
      *  5/12/00 EFD ADD TOTAL QTY OPEN AND ARRANGE SCREEN FIELDS
      *  3/07/01 EFD UPDATE OHDTRY WHEN WE UPDATE OHDTRQ.
      *
     FBIR650FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFIORDR    UF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFMCORG    IF   E           K DISK
     FFOECTL    IF   E           K DISK
RPADDFFIORDRWK  UF A E           K DISK
     FBIR650    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #SH             S             32    DIM(5)
     D #SL             S             32    DIM(5)
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  SUMM                   3      3
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

     IRHORDR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
     I              OHSLD1                      #WSLD1
     I              OHSLD2                      #WSLD2
     I              OHSLD3                      #WSLD3
     I              OHSLD4                      #WSLD4
     I              OHSLCT                      #WSLCT
     I              OHSLST                      #WSLST
     I              OHSLZP                      #WSLZP
      * ONLY CLEAR DATE ON FIRST CYCLE
     C     01            CHAIN     FOECTL                             91
     C                   Z-ADD     OCRQDT        CDATE
     C                   Z-ADD     0             NDATE
     C     RSTRTA        TAG
     C                   UNLOCK    FIORDR
     C                   UNLOCK    FHORDR
     C                   SETOFF                                       5060
     C                   Z-ADD     0             VORDER
     C                   SETOFF                                       77
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102030
     C                   SETOFF                                       313235
     C                   SETOFF                                       4042
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C                   SETOFF                                       1011
      *
     C     VORDER        IFEQ      0
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C                   ENDIF
      *
     C     VORDER        CHAIN     FHORDR                             10
     C   10              GOTO      NXTA
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
      *
     C                   EXSR      #SHP
     C                   MOVEL     #SH(1)        SHP1
     C                   MOVEL     #SH(2)        SHP2
     C                   MOVEL     #SH(3)        SHP3
     C                   MOVEL     #SH(4)        SHP4
     C                   MOVEL     #SH(5)        SHP5
     C                   EXSR      #SLD
     C                   MOVEL     #SL(1)        SLD1
     C                   MOVEL     #SL(2)        SLD2
     C                   MOVEL     #SL(3)        SLD3
     C                   MOVEL     #SL(4)        SLD4
     C                   MOVEL     #SL(5)        SLD5
      *
     C     OHQUOT        IFEQ      'Y'
     C                   SETON                                        10
     C   10              GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     CDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     NDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3031
     C                   GOTO      NXTA
     C                   ENDIF
     C                   Z-ADD     ##CYMD        NDATEC            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         NDTE              5 0
      *
     C     NDTE          IFLT      TDTE
     C     CNT           ANDEQ     1
     C                   SETON                                        3032
     C                   ADD       1             CNT
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VAUDIT        IFNE      'Y'                                                      Q
     C     VAUDIT        ANDNE     'N'
     C                   SETON                                        35
     C   35              GOTO      NXTA
     C                   ENDIF
      *
     C     VSUMM         IFNE      'Y'                                                      Q
     C     VSUMM         ANDNE     'N'
     C                   SETON                                        35
     C   35              GOTO      NXTA
     C                   ENDIF
      * IF VSUMM EVER = Y MOVE Y INTO SUMM FOR CL
     C     VSUMM         IFEQ      'Y'                                                      Q
     C     SUMM          ANDEQ     'N'
     C                   MOVEL     'Y'           SUMM
     C                   ENDIF
      *
     C     VSUMM         IFEQ      'Y'                                                      Q
     C     FIRST         ANDEQ     1
     C                   EXSR      SCNC
     C                   ENDIF
      *
     C     VAUDIT        IFEQ      'Y'                                                      Q
     C     CHDG          ANDEQ     1
     C                   SETON                                        88
     C     LCO           CHAIN     FMCORG                             97
     C                   EXCEPT    HDG
     C                   ADD       1             CHDG
     C                   ENDIF
      *
     C     VFORCE        IFNE      'Y'                                                      Q
     C     VFORCE        ANDNE     'N'
     C                   SETON                                        40
     C   40              GOTO      NXTA
     C                   ENDIF
      *
     C     VFORCE        IFEQ      'Y'                                                      Q
     C                   SETON                                        42
     C                   ENDIF
      *
     C   KA              GOTO      BEGB
     C  N77              GOTO      BEGB
     C                   GOTO      NXTA
      *
     C     BEGB          TAG
     C                   EXSR      GETOPN
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C                   ADD       1             FIRST
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      *
     C   60              GOTO      NOREC
     C     VORDER        SETLL     FIORDR
     C     AGN           TAG
     C     VORDER        READE     FIORDR                                 91
     C   91              GOTO      EORD
     C     OIDTRQ        IFEQ      CDATE
     C     OICOFL        ANDNE     'Y'
     C   OF              EXCEPT    HDG
     C   88              EXCEPT    DETL
     C   OF              SETOFF                                       OF
     C                   Z-ADD     NDATE         OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     NDATEC        OIRVDT            7 0
RPADDC                   Z-ADD     NDATE         OIORDT
      *
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     VSUMM         OISPFL
     C                   SETON                                        50
     C                   UPDATE    RIORDR
RPADDC     LOCKEY        CHAIN     FIORDRWK                           99
RPADDC                   Z-ADD     NDATE         OIDTRQ
RPADDC                   Z-ADD     NDATE         OIORDT
RPADDC                   Z-ADD     TDATE         OIDTLA
RPADDC                   Z-ADD     NDATEC        OIRVDT            7 0
RPADDC     *IN99         IFEQ      *ON
RPADDC                   WRITE     RIORDRWK
RPADDC                   ELSE
RPADDC                   UPDATE    RIORDRWK
RPADDC                   ENDIF
     C                   GOTO      AGN
     C                   ENDIF
      *
     C     OIDTRQ        IFNE      CDATE
     C     OIDTRQ        ANDNE     999999
     C     OIDTRQ        ANDNE     000000
     C     OICOFL        ANDNE     'Y'
     C                   SETON                                        55
     C                   ENDIF
     C                   GOTO      AGN
      *
     C     EORD          TAG
     C   55
     CANN42              GOTO      NHORD
     C                   Z-ADD     NDATE         OHDTRQ
     C                   Z-ADD     NDATEC        OHDTRY
     C                   Z-ADD     TDATE         OHDTLA
     C                   MOVEL     USERID        OHUSER
     C                   Z-ADD     TIMOD         OHTIME
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BIR650'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C     NHORD         TAG
      *
     C  N50              SETON                                        60
     C   60              Z-ADD     CDATE         CBDATE
     C   60              GOTO      NXTB
      *
     C     NOREC         TAG
     C                   GOTO      RSTRTA
     C*  50                GOTO RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      ********
      * SCNC
      ********
     C     SCNC          BEGSR
     C     NXTC          TAG
     C                   WRITE     SCRNC
     C                   SETOFF                                       505152
     C                   SETOFF                                       5354
     C                   READ      SCRNC                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        50
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LPRTR         IFNE      OPRTR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LPRTR         OPRTR            10
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        51
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LFORM         IFNE      OFORM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LFORM         OFORM            10
      *
     C     LCOPY         IFEQ      0                                                        OS
     C                   SETON                                        52
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LCOPY         IFNE      OCOPY
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     LCOPY         OCOPY             2 0
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        53
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     LJOBQ         IFNE      OJOBQ
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     LJOBQ         OJOBQ             1
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        54
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     VOUT          IFNE      OOUT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VOUT          OOUT              1 0
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C                   ENDSR
      *
      ***********************
      ** GET QTY OPEN      **
      ***********************
     C     GETOPN        BEGSR
     C                   Z-ADD     0             TOTQTY
     C     VORDER        SETLL     FIORDR
     C     NXTOPN        TAG
     C     VORDER        READE(N)  FIORDR                                 91
     C   91              GOTO      ENDOPN
     C     OISTAT        IFEQ      'D'
     C     OIITYP        ORNE      ' '
     C                   GOTO      NXTOPN
     C                   END
     C     OIQORD        SUB       OIQSHP        WRKOPN           11 1
     C                   ADD       WRKOPN        TOTQTY
     C                   GOTO      NXTOPN
     C     ENDOPN        TAG
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TDTE              5 0
      *
     C                   MOVEL     'N'           VAUDIT
     C                   MOVEL     'N'           VFORCE
     C                   MOVEL     'Y'           LJOBQ
     C                   MOVEL     'N'           VSUMM
     C                   MOVEL     'N'           SUMM
     C                   Z-ADD     1             CHDG              5 0
     C                   Z-ADD     1             CNT               5 0
     C                   Z-ADD     1             FIRST             5 0
     C                   Z-ADD     1             VOUT
      *
RPADD *
RPADDC     LOCKEY        KLIST
RPADDC                   KFLD                    VORDER
RPADDC                   KFLD                    OISEQ#
RPADD *
     C                   ENDSR
      *                                                                ***
      ***********
      * #SLD    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      ***********
      * #SHP    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SHIP TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SHP          BEGSR
      *
     C                   MOVE      *BLANKS       #SH
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSHP1        #SH(#X)
     C                   ADD       1             #X
     C     #WSHP2        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP1
     C                   MOVEL     #WSHP2        #SH(#X)
     C                   ADD       1             #X
     C     #SHP1         TAG
     C     #WSHP3        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP2
     C                   MOVEL     #WSHP3        #SH(#X)
     C                   ADD       1             #X
     C     #SHP2         TAG
     C     #WSHP4        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP3
     C                   MOVEL     #WSHP4        #SH(#X)
     C                   ADD       1             #X
     C     #SHP3         TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WSHCT        CAT       #WSHST:1      WORK1
     C                   MOVEL     #WSHZP        WORK3
     C                   MOVE      #WSHZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2                          19002-1525
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
     OBIR650    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           60 'Audit Report - Order'
     O                                           78 'Due Dates Changed'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           72 'Original'
     O                                           82 '  New  '
     O          E            HDG            1
     O                                           37 'Order #'
     O                                           43 'Seq #'
     O                                           48 'Item'
     O                                           60 'Size'
     O                                           72 'Ship Date'
     O                                           84 'Ship Date'
     O          E            HDG            2
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            DETL           1
     O                       OIORD#        Z     36
     O                       OISEQ#        Z     42
     O                       OIITEM              56
     O                       OISIZE              59
     O                       OIDTRQ        Y     71
     O                       NDATE         Y     83
      *
