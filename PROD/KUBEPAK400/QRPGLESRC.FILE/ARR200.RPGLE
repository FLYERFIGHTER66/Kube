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
      *PROGRAM NAME-------- ARR200
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- SUMMARY ENTRY
      *DESCRIPTION--------- THIS PROGRAM ALLOWS FOR ENTRY OF
      *                     SUMMARY INVOICE, CREDIT MEMO, &
      *                     LATE CHARGE INFORMATION.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFAROPN    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFARENT    UF A E           K DISK
     FARR200FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      * MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
      *
     D MSG             S             62    DIM(4) CTDATA PERRCD(1)
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
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LCANCL               133    133
      *
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      DNE(1)
     I              ACEN02                      DNE(2)
     I              ACEN03                      DNE(3)
     I              ACEN04                      DNE(4)
     I              ACEN05                      DNE(5)
     I              ACEN06                      DNE(6)
     I              ACEN07                      DNE(7)
     I              ACEN08                      DNE(8)
     I              ACEN09                      DNE(9)
     I              ACEN10                      DNE(10)
     I              ACEN11                      DNE(11)
     I              ACEN12                      DNE(12)
     I              ACEN13                      DNE(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           VCO               2 0
      *
     C                   Z-ADD     0             SEQ#              3 0
     C     ARKEY         KLIST
     C                   KFLD                    VCUST
     C                   KFLD                    VINV#
     C                   KFLD                    VINVSF
     C                   KFLD                    SEQ#
      *
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    VGLNO
      *
     C     LCO           CHAIN     FARCTL                             90
      *
      * 75 = RUNS G/L YES
      *
     C     ACGL          IFEQ      'Y'
     C                   SETON                                        75
     C                   ENDIF
     C     ACGL          IFEQ      'N'
     C                   SETON                                        76
     C                   SETOFF                                       75
     C                   ENDIF
      *
     C   75              DO
      *
      * GET EARLIEST AND LAST ACCTG PERIOD DATE
      *
     C     LCO           CHAIN     FMAPER                             90
     C                   Z-ADD     BEG(1)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YRBEG             5 0
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     DNE(12)       ##MDY
     C                   ELSE
     C                   Z-ADD     DNE(13)       ##MDY
     C                   ENDIF
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         YREND             5 0
     C                   ENDDO                                                  88 DO
      *
     C                   MOVEL     '01'          GDTYPE            2
     C     GLDKEY        KLIST
     C                   KFLD                    VCO
     C                   KFLD                    GDTYPE
     C     GLDKEY        CHAIN     FGLDF                              90
     C                   Z-ADD     GDSALE        VGLNO
     C     GLKEY         CHAIN     FMGLCH                             91
      *
     C     RSTRT         TAG
     C                   Z-ADD     1             CNT               2 0
     C                   Z-ADD     0             VSELEC
     C                   Z-ADD     0             VCUST
     C                   Z-ADD     0             FIRST             2 0
     C                   EXSR      CLEAR
     C                   SETOFF                                       98
     C                   MOVEL     *BLANKS       VALPHA
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       102005
     C                   SETOFF                                       111214
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     VSELEC        IFLT      1
     C     VSELEC        ORGT      3
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1114
     C   11              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1214
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     CMCUST        VCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCUST         CHAIN(N)  FMCUST                             31
     C   31              SETON                                        1114
     C   11              GOTO      NXTA
     C                   MOVEL     CMSLSM        VSLSM
     C                   MOVEL     CMTMCD        TMCD              2
     C     TMCD          CHAIN(N)  FMTERM                             55
      *
     C     VSELEC        IFEQ      1
     C                   Z-ADD     01            AETTYP
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VSELEC        IFEQ      2
     C                   MOVEL     'CM'          VINVSF
     C                   Z-ADD     05            AETTYP
     C                   SETON                                        05
     C                   GOTO      RSTRTC
     C                   ENDIF
      *
     C     VSELEC        IFEQ      3
     C                   MOVEL     'LC'          VINVSF
     C                   Z-ADD     07            AETTYP
     C                   SETON                                        07
     C                   GOTO      RSTRTD
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   Z-ADD     0             FIRST             2 0
     C                   MOVEL     *BLANKS       VACT
     C                   MOVEL     MSG(3)        MESS
     C                   Z-ADD     0             VINV#
     C                   SETOFF                                       88
     C                   EXSR      CLEAR
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             TOTAL
     C                   SETOFF                                       101213
     C                   SETOFF                                       142030
     C                   SETOFF                                       212223
     C                   SETOFF                                       616263
     C                   SETOFF                                       4045
     C                   SETOFF                                       9098
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL            1
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLEAR
     C   KF
     COR KD              GOTO      RSTRT
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTB
     C     VACTOK        TAG
      *
     C     VACT          IFNE      OLACT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VACT          OLACT             1
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        88
     C                   ENDIF
      *
     C     VINV#         IFEQ      0
     C                   SETON                                        1213
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VINV#         IFNE      OLINV#
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VINV#         OLINV#            6 0
      *
     C     1             SUBST     VSHFR:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     VSHFR         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VSHFR
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        18
     C   18              GOTO      NXTB
     C                   ENDIF
      *
     C     VSHFR         IFNE      OSHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VSHFR         OSHFR             3
      *
     C     ARKEY         CHAIN     FARENT                             90
     C   90VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   SETON                                        1215
     C   15              GOTO      NXTB
     C                   ENDIF
      *
     C  N90VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   EXSR      GETFLD
     C                   ENDIF
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        1214
     C   14              GOTO      NXTB
     C                   ENDIF
      *
      *
     C     ARKEY         CHAIN(N)  FAROPN                             90
     C  N90              SETON                                        1214
     C   14              GOTO      NXTB
      *
     C     NXTB1         TAG
     C   88              MOVEL     MSG(2)        MESS
      *
     C                   WRITE     SCRNB1
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             TOTAL
     C                   SETOFF                                       101213
     C                   SETOFF                                       142030
     C                   SETOFF                                       212223
     C                   SETOFF                                       404515
     C                   SETOFF                                       616263
     C                   SETOFF                                       359098
     C                   READ      SCRNB1                                 90
     C   KC
     COR KG              MOVE      'X'           LCANCL            1
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLEAR
     C   KF              GOTO      RSTRT
      *
     C  N88              GOTO      AOCB
     C   KX              GOTO      UPDB
     C  NKX              GOTO      NXTB1
      *
     C     AOCB          TAG
      *
     C   KB              DO
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVEL     *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     GCGLNO        VGLNO
     C                   GOTO      NXTB1
     C                   ENDDO
      *
     C     VTDATE        IFEQ      *ZEROS
     C                   SETON                                        20
     C   20              GOTO      NXTB1
     C                   ENDIF
      *
     C                   Z-ADD     VTDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2061
     C   61              GOTO      NXTB1
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TRDATE            5 0
      *
     C   75TRDATE        IFLT      YRBEG
     C                   SETON                                        2062
     C                   GOTO      NXTB1
     C                   ENDIF
      *
     C                   ADD       1             FIRST
     C   75TRDATE        IFGT      YREND
     C     FIRST         ANDEQ     1
     C                   SETON                                        2063
     C                   GOTO      NXTB1
     C                   ENDIF
      *
     C                   Z-ADD     ##CYMD        AETDAT
      *
     C     VTDATE        IFNE      OTDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VTDATE        OTDATE            6 0
      *
     C     VDDATE        IFEQ      0
     C                   EXSR      TERMS
     C                   Z-ADD     DUDT          VDDATE
     C                   ENDIF
      *
     C                   Z-ADD     VDDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2122
     C   22              GOTO      NXTB1
     C                   ENDIF
     C                   Z-ADD     ##CYMD        AEDUDT
      *
     C     AEDUDT        IFLT      AETDAT
     C                   SETON                                        2123
     C   23              GOTO      NXTB1
     C                   ENDIF
      *
     C     VDDATE        IFNE      ODDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VDDATE        ODDATE            6 0
      *
     C     1             SUBST     VSLSM:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VSLSM         SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLSM
     C                   MOVEL     SMSLSM        VSLSM
     C                   GOTO      NXTB1
     C                   ENDIF
      *
      * TEST SALESPERSON CODE
      *
     C     VSLSM         IFEQ      *BLANKS
     C                   SETON                                        30
     C   30              GOTO      NXTB1
     C                   ENDIF
      *
     C     VSLSM         CHAIN     FMSLSM                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTB1
      *
     C     VSLSM         IFNE      OSLSM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VSLSM         OSLSM             2
      *
     C     VTOTAL        IFLE      0
     C                   SETON                                        40
     C                   GOTO      NXTB1
     C                   ENDIF
      *
     C     VTOTAL        IFNE      OTOTAL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VTOTAL        OTOTAL            9 2
      *
     C     GLKEY         CHAIN     FMGLCH                             91
     C   91              SETON                                        35
     C   35              GOTO      NXTB1
      *
     C     VGLNO         IFNE      OGLNO
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VGLNO         OGLNO             8 0
      *
     C                   ADD       VMERCH        TOTAL            11 2
     C                   SUB       VQDISC        TOTAL
     C                   SUB       VTDISC        TOTAL
     C                   ADD       VFRT          TOTAL
     C                   ADD       VSPCHG        TOTAL
     C                   ADD       VSTTAX        TOTAL
     C                   ADD       VCOTAX        TOTAL
     C                   ADD       VCYTAX        TOTAL
      *
     C     TOTAL         IFNE      VTOTAL
     C                   SETON                                        45
     C                   GOTO      NXTB1
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   Z-ADD     0             CNT
     C                   MOVEL     MSG(1)        MESS
     C   98              GOTO      NXTB1
     C                   ENDIF
      *
     C     UPDB          TAG
     C                   EXSR      UARENT
     C                   GOTO      RSTRTB
      *
     C     RSTRTC        TAG
     C                   SETOFF                                       88
     C                   MOVEL     MSG(4)        MESS
     C                   Z-ADD     0             VINV#
     C                   EXSR      CLEAR
     C                   MOVEL     'CM'          VINVSF
     C                   Z-ADD     0             FIRST
     C     NXTC          TAG
     C                   WRITE     SCRNC
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             TOTAL
     C                   SETOFF                                       101213
     C                   SETOFF                                       142030
     C                   SETOFF                                       212223
     C                   SETOFF                                       404515
     C                   SETOFF                                       616263
     C                   SETOFF                                       9098
     C                   READ      SCRNC                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL            1
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLEAR
     C   KD
     COR KF              GOTO      RSTRT
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTC
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTC
     C     VACTC         TAG
      *
     C     VACT          IFNE      OLACT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VACT          OLACT             1
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        88
     C                   ENDIF
      *
     C     VINV#         IFEQ      0
     C                   SETON                                        1213
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     VINV#         IFNE      OLINV#
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VINV#         OLINV#            6 0
      *
     C     1             SUBST     VSHFR:1       VTST1             1
     C     VTST1         IFEQ      '?'
     C     VTST1         OREQ      '/'
     C                   MOVEL     VSHFR         VWHSE             3
     C                   EXSR      LOCSR
     C                   MOVEL     VWHSE         VSHFR
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VSHFR         IFGT      *BLANKS
     C     VSHFR         CHAIN     FMWHSE                             91
     C   91              SETON                                        18
     C   18              GOTO      NXTC
     C                   ENDIF
      *
     C     VSHFR         IFNE      OSHFR
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VSHFR         OSHFR             3
      *
     C     ARKEY         CHAIN     FARENT                             90
     C   90VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   SETON                                        1215
     C   15              GOTO      NXTC
     C                   ENDIF
      *
     C  N90VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   EXSR      GETFLD
     C                   ENDIF
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        1214
     C   14              GOTO      NXTC
     C                   ENDIF
      *
     C                   Z-ADD     0             SEQ#              3 0
     C     ARKEY         CHAIN(N)  FAROPN                             90
     C  N90              SETON                                        1214
     C   14              GOTO      NXTC
      *
     C     NXTC1         TAG
     C   88              MOVEL     MSG(2)        MESS
     C                   WRITE     SCRNC1
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             TOTAL
     C                   SETOFF                                       101213
     C                   SETOFF                                       142030
     C                   SETOFF                                       212223
     C                   SETOFF                                       404515
     C                   SETOFF                                       616263
     C                   SETOFF                                       9098
     C                   READ      SCRNC1                                 90
     C   KC
     COR KG              MOVE      'X'           LCANCL            1
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLEAR
     C   KF              GOTO      RSTRT
      *
     C  N88              GOTO      AOCC
     C   KX              GOTO      UPDC
     C  NKX              GOTO      NXTC1
      *
     C     AOCC          TAG
      *
     C   KB              DO
     C                   Z-ADD     LCO           GCCOMP
     C                   MOVEL     *BLANKS       GCLOOK
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    GCCOMP
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     GCGLNO        VGLNO
     C                   GOTO      NXTC1
     C                   ENDDO
      *
     C     VTDATE        IFEQ      *ZEROS
     C                   SETON                                        20
     C   20              GOTO      NXTC1
     C                   ENDIF
      *
     C                   Z-ADD     VTDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2061
     C   61              GOTO      NXTC1
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TRDATE            5 0
      *
     C   75TRDATE        IFLT      YRBEG
     C                   SETON                                        2062
     C                   GOTO      NXTC1
     C                   ENDIF
      *
     C                   ADD       1             FIRST
     C   75TRDATE        IFGT      YREND
     C     FIRST         ANDEQ     1
     C                   SETON                                        2063
     C                   GOTO      NXTC1
     C                   ENDIF
      *
     C                   Z-ADD     ##CYMD        AETDAT
      *
     C     VTDATE        IFNE      OTDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VTDATE        OTDATE            6 0
      *
     C     VDDATE        IFEQ      0
     C                   Z-ADD     VTDATE        VDDATE
     C                   ENDIF
      *
     C                   Z-ADD     VDDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2122
     C   22              GOTO      NXTC1
     C                   ENDIF
     C                   Z-ADD     ##CYMD        AEDUDT
      *
     C     AEDUDT        IFLT      AETDAT
     C                   SETON                                        2123
     C   23              GOTO      NXTC1
     C                   ENDIF
      *
     C     1             SUBST     VSLSM:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VSLSM         SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLSM
     C                   MOVEL     SMSLSM        VSLSM
     C                   GOTO      NXTB
     C                   ENDIF
      *
      * TEST SALESPERSON CODE
      *
     C     VSLSM         IFEQ      *BLANKS
     C                   SETON                                        30
     C   30              GOTO      NXTC1
     C                   ENDIF
      *
     C     VSLSM         CHAIN     FMSLSM                             90
     C   90              SETON                                        30
     C   30              GOTO      NXTC1
      *
     C     VSLSM         IFNE      OSLSM
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VSLSM         OSLSM             2
      *
     C     VTOTAL        IFLE      0
     C                   SETON                                        40
     C                   GOTO      NXTC1
     C                   ENDIF
      *
     C     VTOTAL        IFNE      OTOTAL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VTOTAL        OTOTAL            9 2
      *
     C     GLKEY         CHAIN     FMGLCH                             91
     C   91              SETON                                        35
     C   35              GOTO      NXTC1
      *
     C                   ADD       VMERCH        TOTAL            11 2
     C                   SUB       VQDISC        TOTAL
     C                   SUB       VTDISC        TOTAL
     C                   ADD       VFRT          TOTAL
     C                   ADD       VSPCHG        TOTAL
     C                   ADD       VSTTAX        TOTAL
     C                   ADD       VCOTAX        TOTAL
     C                   ADD       VCYTAX        TOTAL
      *
     C     TOTAL         IFNE      VTOTAL
     C                   SETON                                        45
     C                   GOTO      NXTC1
     C                   ENDIF
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   Z-ADD     0             CNT
     C                   MOVEL     MSG(1)        MESS
     C   98              GOTO      NXTC1
     C                   ENDIF
      *
     C     UPDC          TAG
     C                   EXSR      UARENT
     C                   GOTO      RSTRTC
      *
     C     RSTRTD        TAG
     C                   Z-ADD     0             VINV#
     C                   MOVEL     MSG(3)        MESS
     C                   EXSR      CLEAR
     C                   MOVEL     'LC'          VINVSF
     C     NXTD          TAG
     C                   WRITE     SCRND
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101213
     C                   SETOFF                                       142030
     C                   SETOFF                                       212223
     C                   SETOFF                                       4045
     C                   SETOFF                                       9098
     C                   READ      SCRND                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL            1
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLEAR
     C   KD
     COR KF              GOTO      RSTRT
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTD
     C                   ENDIF
     C                   SETON                                        10
     C   10              GOTO      NXTD
     C     VACTD         TAG
      *
     C     VACT          IFNE      OLACT
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VACT          OLACT             1
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        88
     C                   ENDIF
      *
     C     VINV#         IFEQ      0
     C                   SETON                                        1213
     C                   GOTO      NXTD
     C                   ENDIF
      *
     C     VINV#         IFNE      OLINV#
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VINV#         OLINV#            6 0
      *
     C     ARKEY         CHAIN     FARENT                             90
     C   90VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   SETON                                        1215
     C   15              GOTO      NXTD
     C                   ENDIF
      *
     C  N90VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   EXSR      GETFLD
     C                   ENDIF
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        1214
     C   14              GOTO      NXTD
     C                   ENDIF
      *
     C                   Z-ADD     0             SEQ#              3 0
     C     ARKEY         CHAIN(N)  FAROPN                             90
     C  N90              SETON                                        1214
     C   14              GOTO      NXTD
      *
     C     NXTD1         TAG
     C                   WRITE     SCRND1
     C                   Z-ADD     0             CNT               2 0
     C                   Z-ADD     0             TOTAL
     C                   SETOFF                                       101213
     C                   SETOFF                                       142030
     C                   SETOFF                                       212223
     C                   SETOFF                                       404515
     C                   SETOFF                                       9098
     C                   READ      SCRND1                                 90
     C   KC
     COR KG              MOVE      'X'           LCANCL            1
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLEAR
     C   KF              GOTO      RSTRT
      *
      *
     C  N88              GOTO      AOCD
     C   KX              GOTO      UPDD
     C  NKX              GOTO      NXTD1
      *
     C     AOCD          TAG
      *
     C     VTDATE        IFEQ      *ZEROS
     C                   SETON                                        20
     C   20              GOTO      NXTD1
     C                   ENDIF
      *
     C                   Z-ADD     VTDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C   20              GOTO      NXTD1
     C                   ENDIF
     C                   Z-ADD     ##CYMD        AETDAT
      *
     C     VTDATE        IFNE      OTDATE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VTDATE        OTDATE            6 0
      *
     C     VDDATE        IFEQ      0
     C                   EXSR      TERMS
     C                   Z-ADD     DUDT          VDDATE
     C                   ENDIF
      *
     C                   Z-ADD     VDDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        22
     C   22              GOTO      NXTD1
     C                   ENDIF
     C                   Z-ADD     ##CYMD        AEDUDT
      *
     C     AEDUDT        IFLT      AETDAT
     C                   SETON                                        2123
     C   23              GOTO      NXTD
     C                   ENDIF
      *
     C     VTOTAL        IFLE      0
     C                   SETON                                        40
     C                   GOTO      NXTD1
     C                   ENDIF
      *
     C     VTOTAL        IFNE      OTOTAL
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VTOTAL        OTOTAL            9 2
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   Z-ADD     0             CNT
     C                   MOVEL     MSG(1)        MESS
     C   98              GOTO      NXTD1
     C                   ENDIF
      *
     C     UPDD          TAG
     C                   EXSR      UARENT
     C                   GOTO      RSTRTD
      *
     C     END           TAG
     C                   SETON                                        LR
      *********
      * CLEAR *
      *********
      *
     C     CLEAR         BEGSR
     C                   Z-ADD     0             VINV#
     C                   MOVEL     *BLANKS       VINVSF
     C                   MOVEL     *BLANKS       VSHFR
     C                   Z-ADD     0             VTOTAL
     C                   Z-ADD     0             VMERCH
     C                   Z-ADD     0             VQDISC
     C                   Z-ADD     0             VTDISC
     C                   Z-ADD     0             VFRT
     C                   Z-ADD     0             VSPCHG
     C                   Z-ADD     0             VSTTAX
     C                   Z-ADD     0             VCOTAX
     C                   Z-ADD     0             VCYTAX
     C                   Z-ADD     0             VTDATE
     C                   Z-ADD     0             VDDATE
     C  N07              Z-ADD     GDSALE        VGLNO
     C                   ENDSR
      **********
      * GETFLD *
      **********
      *
     C     GETFLD        BEGSR
     C                   Z-ADD     AETDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         VTDATE
     C                   Z-ADD     AEDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         VDDATE
     C                   MOVEL     AESUFF        VINVSF
     C                   MOVEL     AESLSM        VSLSM
     C                   MOVEL     AESHFR        VSHFR
     C                   Z-ADD     AE$AMT        VTOTAL
     C                   Z-ADD     AEQDI$        VQDISC
     C                   Z-ADD     AEDIS$        VTDISC
     C                   Z-ADD     AEFRT$        VFRT
     C                   Z-ADD     AESPL$        VSPCHG
     C                   Z-ADD     AEAMT1        VSTTAX
     C                   Z-ADD     AEAMT2        VCOTAX
     C                   Z-ADD     AEAMT3        VCYTAX
     C                   Z-ADD     AEMER$        VMERCH
     C                   ENDSR
      **********
      * UARENT *
      **********
      *
     C     UARENT        BEGSR
     C                   MOVEL     'A'           AESTAT
     C                   Z-ADD     VCUST         AECUST
     C                   Z-ADD     VCUST         AESHCU
     C                   Z-ADD     VCUST         AESACU
     C                   Z-ADD     VCUST         AEBLCU
     C                   Z-ADD     VINV#         AEINV#
     C                   MOVEL     VINVSF        AESUFF
     C                   MOVEL     VSLSM         AESLSM
     C                   MOVEL     CMTERR        AETERR
     C                   Z-ADD     VCO           AECOMP
     C                   MOVEL     VSHFR         AESHFR
     C  N05              Z-ADD     VTOTAL        AE$AMT
     C   05              Z-SUB     VTOTAL        AE$AMT
     C                   Z-ADD     VQDISC        AEQDI$
     C                   Z-ADD     VTDISC        AEDIS$
     C  N05              Z-ADD     VFRT          AEFRT$
     C   05              Z-SUB     VFRT          AEFRT$
     C  N05              Z-ADD     VSPCHG        AESPL$
     C   05              Z-SUB     VSPCHG        AESPL$
     C  N05              Z-ADD     VSTTAX        AEAMT1
     C   05              Z-SUB     VSTTAX        AEAMT1
     C  N05              Z-ADD     VCOTAX        AEAMT2
     C   05              Z-SUB     VCOTAX        AEAMT2
     C  N05              Z-ADD     VCYTAX        AEAMT3
     C   05              Z-SUB     VCYTAX        AEAMT3
     C  N05              Z-ADD     VMERCH        AEMER$
     C   05              Z-SUB     VMERCH        AEMER$
     C                   Z-ADD     GDARRC        AEGARR
     C   07              Z-ADD     GDLCHG        AEGSAL
     C     VMERCH        IFNE      0
     C  N07              Z-ADD     VGLNO         AEGSAL
     C                   ENDIF
     C                   Z-ADD     DVAL          AEDISC
     C                   Z-ADD     TDATE         AEDTLA
     C                   Z-ADD     TIMOD         AETIME
     C                   MOVEL     USERID        AEUSER
     C     VACT          IFEQ      'A'
     C                   WRITE     RARENT
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RARENT
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RARENT
     C                   ENDIF
     C                   ENDSR
      *
      ***********
      * TERMS   *
      ***********
     C     TERMS         BEGSR
     C                   SETOFF                                       59
     C                   MOVEL     CMTMCD        TMCD              2
     C     TMCD          CHAIN(N)  FMTERM                             55
     C   55              GOTO      CALDT1
      *
     C                   MOVE      TCTRAT        #DISWK
      *
     C     TCTRTP        IFEQ      1
     C                   GOTO      TYP01
     C                   ENDIF
     C     TCTRTP        IFEQ      2
     C                   GOTO      TYP02
     C                   ENDIF
     C     TCTRTP        IFEQ      3
     C                   GOTO      TYP03
     C                   ENDIF
      *
     C     CALDT1        TAG
     C                   Z-ADD     VTDATE        DUDT
     C                   Z-ADD     VTDATE        CSHDUE
     C                   MOVE      *ZEROS        #DISWK            4 4
     C                   GOTO      ECALDT
      *
      * CALCULATE FOR TERMS TYPE '1'
      *
     C     TYP01         TAG
     C                   Z-ADD     VTDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         IDATE             5 0
     C                   Z-ADD     ##DDD         INDTE             5 0
     C                   ADD       TCTDAS        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         DUDT              6 0
      *
     C                   ADD       TCTDAY        IDATE
     C                   Z-ADD     IDATE         ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         CSHDUE            6 0
     C                   Z-ADD     CSHDUE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DIDTE             5 0
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '2'
      *
     C     TYP02         TAG
      *
      * GET CURRENT DAY OF MONTH FOR CUTOFF TEST
      *
     C                   MOVEL     VTDATE        #WMMDD            4 0
     C                   MOVEL     #WMMDD        #WMM              2 0
     C                   MOVE      #WMMDD        #WDD              2 0
     C                   MOVE      VTDATE        #WYY              2 0
      *
      * TEST TO SEE IF LESS THAN OR EQUAL TO CUTOFF DATE
      *
     C     #WDD          COMP      TCCUTO                               5858
     C   58#WMM          ADD       TCMBCO        #WMM
     C  N58#WMM          ADD       TCMACO        #WMM
      *
      * TEST TO SEE IF MONTHS EXCEEDS 12
      *
     C     #WMM          COMP      12                                 54
     C   54#WMM          SUB       12            #WMM
     C   54#WYY          ADD       1             #WYY
      *
     C                   MOVEL     #WMM          #WMMDD
     C   58              MOVE      TCNBCO        #WMMDD
     C  N58              MOVE      TCNACO        #WMMDD
     C                   MOVEL     #WMMDD        DUDT
     C                   MOVE      #WYY          DUDT
      *
      * CALCULATE DISCOUNT DUE DATE
      *
     C   58TCDBCO        COMP      *ZEROS                                 59
     C  N58TCDACO        COMP      *ZEROS                                 59
     C   59              MOVE      TDATE         CSHDUE
     C   58
     CANN59              MOVE      TCDBCO        #WMMDD
     C  N58
     CANN59              MOVE      TCDACO        #WMMDD
     C  N59              MOVEL     #WMMDD        CSHDUE
     C  N59              MOVE      #WYY          CSHDUE
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '3'
      *
     C     TYP03         TAG
      *
     C                   MOVE      TCNDUE        DUDT
      *
     C     TCDDUE        IFEQ      *ZEROS
     C                   Z-ADD     TDATE         CSHDUE
     C                   ELSE
     C                   Z-ADD     TCDDUE        CSHDUE
     C                   ENDIF
      *
     C     ECALDT        TAG
      *
      * CALCULATE DISCOUNT AVAILABLE BASED ON TERMS
      *
     C                   Z-ADD     0             DVAL              7 2
     C     VTOTAL        MULT(H)   #DISWK        DVAL                           NOT FRGHT/CRM
      *
     C     ETERMS        TAG
     C                   ENDSR
      *
      *********
      * LOCSR
      *********
     C     LOCSR         BEGSR
     C                   MOVEL     VWHSE         WHWHSE            3
     C                   CALL      'LKLOCA'
     C                   PARM                    WHWHSE
     C                   PARM                    WHDESC           30
     C                   MOVEL     *BLANKS       VWHSE
     C                   MOVEL     WHWHSE        VWHSE
     C                   MOVEL     WHDESC        VDESC            30
     C                   ENDSR
      *
**  BOTTOM OF SCREEN MESSAGES
       Validate Data - Change or Press Enter to Accept
 Verify Delete - Press F23 to DELETE - or - F6 for NO DELETE
 If No Due Date Is Entered - It Will Calculate Based On Terms
   If No Due Date Is Entered - C/M Date Will Become Due Date
