    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
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
      *PROGRAM NAME-------- APR200
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VOUCHER ENTRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 10/17/99 EFD LOG #3 CHG LOGIC FOR DESCRIPTION ON SUB FILE F2
      * 11/17/99 EFD CHANGE SCRNB LOAD FOR CREDITS  LINE 1272 ON
      *
      *
     FAPR200FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFMVEND    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FFAPCTLB   UF A E           K DISK
     FFMTERM    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFAPOPNVE  IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFAPREC    IF   E           K DISK
     FFAPWKINV  IF   E           K DISK
     F                                     RENAME(RAPWK:APWK)
     FFAPWKCK   IF   F  183    08AIDISK    KEYLOC(2)
     FFAPWK     UF A E           K DISK
     FFAPWKS    UF A E           K DISK
     FFAPNXTWIR UF   E           K DISK
      *
     D #VN             S             32    DIM(5)
     D IN              S              1    DIM(10)                              INVOICE # CNVT
     D OUT             S              1    DIM(10)                              INVOICE # CNVT
     D MSG             S             61    DIM(2) CTDATA PERRCD(1)
      *
      * MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
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
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LCANCL               133    133
     D  LVEND                134    139  0
     D  CALLD                140    140

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$WeekDay
    ?D/COPY QFunctDefn,$addDate

     D DaysNeeded      S              2  0                                      END DATES

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
     IRMVEND
     I              VMNAME                      #WVND1
     I              VMADD2                      #WVND2
     I              VMADD3                      #WVND3
     I              VMADD4                      #WVND4
     I              VMCITY                      #WVNCT
     I              VMSTST                      #WVNST
     I              VMZIPD                      #WVNZP
      *
     IFAPWKCK   NS
     I                                 10   15 0CKVEND
     I                                 94   99 0CKDATE
      *
      * DOES THIS COMPANY RUN G/L YES = 88
      *
     C     LCO           CHAIN(N)  FAPCTL                             90
     C                   SETON                                        02
     C                   MOVEL     'N'           RECCHG            1
      *
      * 81 = TRACKS USE TAX
      *
     C     AZUSET        IFEQ      'Y'
     C                   SETON                                        81
     C     AZUSEP        DIV       100           USEPER            7 7
     C                   ENDIF
      *
      * DO NOT ALLOW O/R OF AP GL NUMBER
      *
     C     AZAPGL        IFEQ      'N'
     C                   SETON                                        87
     C                   ENDIF
      *
      * 88 = RUNS GL
      *
     C     AZGL          IFEQ      'Y'
     C                   SETON                                        88
     C                   ENDIF
      *
     C   88              DO
     C     LCO           CHAIN     FGLDF                              90
     C                   Z-ADD     GDAPPY        VAPGL
     C                   Z-ADD     GDAPPY        GLNO
     C                   Z-ADD     GDFRTI        GLFRT             8 0
     C                   Z-ADD     GDAPCH        GLCASH            8 0
     C     GLKEY         CHAIN     FMGLCH                             94
     C  N94              MOVEL     GCDESC        APDESC           30
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
     C                   Z-ADD     TDATE         VDATE
      *
     C                   Z-ADD     LCO           VCO               2 0
     C                   Z-ADD     LVEND         VVEND
     C     LVEND         IFGT      0
     C                   SETON                                        05
     C                   ENDIF
      *
     C                   Z-ADD     0             COMP              2 0
     C                   MOVE      *BLANKS       CALLD
      *
     C     RSTRT         TAG
     C                   SETOFF                                       7785
     C                   Z-ADD     0             FIRST             2 0
     C                   Z-ADD     0             VTOTAL
     C  N05              Z-ADD     0             VVEND
     C                   Z-ADD     0             VVOUCH
     C                   Z-ADD     0             SEQ
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMNAME
     C                   MOVEL     *BLANKS       VTYPE
     C                   MOVEL     *BLANKS       VINV
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   Z-ADD     0             CNT               5 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       131520
     C                   SETOFF                                       212230
     C                   SETOFF                                       313233
     C                   SETOFF                                       3435
     C                   SETOFF                                       848667
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
     C   KD              GOTO      RSTRT
     C   85              GOTO      CHGREC
      *
      * ADD NEW VENDOR
      *
     C   KE              DO
     C                   MOVEL     'Y'           CALLD
     C                   GOTO      END
     C                   END
      *
     C     VVEND         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     VCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        1011
     C   10              GOTO      NXTA
     C     VACTOK        TAG
      *
     C     VVEND         IFEQ      0
     C   12              SETON                                        12
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        12
     C   12              GOTO      NXTA
     C                   MOVE      VMGLAC        GLNO
     C     GLKEY         CHAIN     FMGLCH                             95
     C  N95              MOVEL     GCDESC        DESC
      *
      * CHECK FOR DUPLICATE INVOICE Y OR N
      *
     C     VMCDUP        IFEQ      'Y'
     C                   SETON                                        15
     C                   ENDIF
      *
     C                   EXSR      #VND
     C                   MOVEL     #VN(1)        VEN1             32
     C                   MOVEL     #VN(2)        VEN2             32
     C                   MOVEL     #VN(3)        VEN3             32
     C                   MOVEL     #VN(4)        VEN4             32
     C                   MOVEL     #VN(5)        VEN5             32
      *
      * NO G/L FOR THIS CO
      *
     C     AZGL          IFEQ      'N'
     C                   GOTO      NACTP
     C                   ENDIF
      *
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SCDATE            5 0
      *
     C     SCDATE        IFLT      YRBEG
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   ADD       1             FIRST
     C     SCDATE        IFGT      YREND
     C     FIRST         ANDEQ     1
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     NACTP         TAG
      *
     C     VACT          IFEQ      'A'
     C                   GOTO      NOCHG
     C                   ENDIF
      *
      * REDISPLAY SCREEN FOR CHANGE OR DELETE
      *
     C     VACT          IFEQ      'C'
     C     VACT          OREQ      'D'
     C                   SETON                                        85
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * DATA NEEDED FOR CHANGE OR DELETE
      *
     C     CHGREC        TAG
      * CHECK IF SAERCH NEEDED
     C   KB              DO
     C                   Z-ADD     0             VVOUCH
     C                   MOVE      *BLANKS       VINV
     C                   MOVE      *BLANKS       VTYPE
     C                   MOVE      *BLANKS       AWITYP
     C                   Z-ADD     LCO           CO                2 0
     C                   CALL      'LKAPWK'
     C                   PARM                    VVEND
     C                   PARM                    CO
     C                   PARM                    VVOUCH
     C                   PARM                    VINV
     C                   PARM                    VTYPE
     C                   GOTO      NXTA
     C                   ENDDO
      *
     C     VVOUCH        IFEQ      0
     C                   SETON                                        33
     C   33              GOTO      NXTA
     C                   ENDIF
      *
     C     VINV          IFEQ      *BLANKS
     C                   SETON                                        34
     C   34              GOTO      NXTA
     C                   ENDIF
      *
     C     VTYPE         IFNE      ' '
     C     VTYPE         ANDNE     'I'
     C     VTYPE         ANDNE     'C'
     C     VTYPE         ANDNE     'M'
     C     VTYPE         ANDNE     'F'
     C     VTYPE         ANDNE     'W'
     C                   SETON                                        35
     C   35              GOTO      NXTA
     C                   ENDIF
      *
      * GET RECORD FOR CHANGE OR DELETE
      *
     C                   EXSR      GETWK
     C   13VACT          IFNE      'A'
     C                   SETON                                        33
     C                   GOTO      NXTA
     C                   END
     C     NOCHG         TAG
      *
     C                   MOVEL     VACT          VACTB
     C     VACT          IFEQ      'A'
     C     LCO           CHAIN     FAPCTL                             91
     C                   Z-ADD     AZVOUC        VOUCH
     C                   ADD       1             AZVOUC
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
     C                   ENDIF
      *
     C     VMTMCD        CHAIN     FMTERM                             91
      *
     C                   Z-ADD     VCO           CONO              2 0
     C                   Z-ADD     VDATE         TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        #P                2 0
      *
     C     #P            IFLT      14
     C     VCO           CHAIN     FMAPER                             90
     C                   Z-ADD     #P            X                 2 0
     C                   Z-ADD     BEG(X)        BDATE             6 0
     C                   Z-ADD     DNE(X)        EDATE             6 0
     C                   Z-ADD     #P            ACDT              2 0
     C                   ELSE
     C                   Z-ADD     99            ACDT              2 0
     C                   ENDIF
      *
     C                   Z-ADD     BDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ABDATE            5 0
     C                   Z-ADD     EDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         AEDATE            5 0
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     '  Add   '    ACTION
     C                   GOTO      RSTRTB
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     ' Change '    ACTION
     C                   SETON                                        86  67
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     ' Delete '    ACTION
     C                   SETON                                        868498
     C                   MOVEL     MSG(2)        MESAGE
     C                   ADD       1             CNT
     C                   ENDIF
     C                   SETON                                        89
      *
     C     RSTRTB        TAG
     C   86              GOTO      NXTB
     C                   SETOFF                                       500517
     C                   MOVEL     *BLANKS       VINV#
     C                   MOVEL     *BLANKS       OINV#
     C                   Z-ADD     0             VIDATE
     C                   Z-ADD     VDATE         VIDATE
     C                   Z-ADD     0             OIDATE
     C                   Z-ADD     0             VAMT
     C                   Z-ADD     0             OAMT
     C                   MOVEL     *BLANKS       VTYPE
     C                   MOVEL     *BLANKS       OTYPE
     C                   Z-ADD     0             ODISC             7 2
     C                   Z-ADD     0             VDISC
     C                   MOVEL     *BLANKS       OHOLD
     C                   MOVEL     'N'           VHOLD
     C                   MOVEL     *BLANKS       VDESC
     C                   MOVEL     *BLANKS       ODESC
     C                   Z-ADD     0             VPONO
     C                   Z-ADD     0             OPONO
     C                   Z-ADD     0             VCHECK
     C                   Z-ADD     0             OCHECK
     C                   Z-ADD     0             VCKDTE
     C                   Z-ADD     0             OCKDTE
     C                   Z-ADD     0             CKAMT
     C                   MOVEL     'N'           VUTAX
     C                   MOVEL     'N'           VxTAX
     C                   MOVEL     'N'           OUTAX             1
     C                   MOVEL     'N'           OxTAX             1
     C                   Z-ADD     0             VUTAX$
     C                   Z-ADD     0             VxTAX$
     C                   Z-ADD     0             VxTax$112        11 2
     C                   Move      '1'           FIRSTVU           1
     C                   Move      '1'           FIRSTVx           1
      *
     C     NXTB          TAG
     C                   Z-ADD     VVEND         LSTVND
     C                   SETOFF                                       10
      * 01 = POSITION ON VENDOR # ON RETURN TO SCRNA
     C                   SETON                                        01
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      *
      * DELETE FAPWK RECORD
      *
     C  N84              GOTO      NODEL
     C   84              DO
     C   KF              GOTO      RSTRT
     C   KX              DO
     C                   DELETE    RAPWK
      * GL RECORD
     C                   EXSR      DELGL
     C                   MOVEL     'Y'           RECCHG
     C                   GOTO      RSTRT
     C                   ENDDO
     C                   GOTO      NXTB
     C                   ENDDO
     C     NODEL         TAG
     C                   SETON                                        02
     C                   SETOFF                                       101112
     C                   SETOFF                                       131617
     C                   SETOFF                                       192025
     C                   SETOFF                                       263040
     C                   SETOFF                                       4252
     C                   SETOFF                                       606162
     C                   SETOFF                                       657098
     C                   SETOFF                                       6364
     C                   Z-ADD     0             CNT
     C   KA              DO
     C                   Z-ADD     LCO           CO                2 0
     C                   CALL      'APR01Q'
     C                   PARM                    CO
     C                   PARM                    VVEND
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C                   Z-ADD     VOUCH         LSTVOU
     C   KF              GOTO      RSTRT
      *
      * IF TYPE = D
      *
     C   84              GOTO      NOCHK
      *
     C     VACTB         IFEQ      'A'
     C     VACTB         OREQ      'C'
     C     VACTB         OREQ      'D'
     C                   GOTO      VACBOK
     C                   ENDIF
     C                   SETON                                        17
     C                   SETOFF                                       02
     C   17              GOTO      NXTB
     C     VACBOK        TAG
      *
     C     VINV#         IFEQ      *BLANKS
     C                   SETON                                        1011
     C   11              GOTO      NXTB
     C                   ENDIF
      ** RIGHT JUSTIFY INVOICE NUMBER
     C                   MOVEA     VINV#         IN
     C                   MOVE      *BLANKS       OUT
     C                   Z-ADD     10            X                 2 0
     C                   Z-ADD     10            Y                 2 0
     C     NXTX          TAG
     C     IN(X)         IFGT      *BLANKS
     C                   MOVEL     IN(X)         OUT(Y)
     C                   SUB       1             Y
     C                   END
     C                   SUB       1             X
     C     X             IFGT      0
     C                   GOTO      NXTX
     C                   END
     C                   MOVE      *BLANKS       VINV#
     C                   MOVEA     OUT           VINV#
     C                   MOVEL     VINV#         LSTINV
     C                   MOVEL     VINV#         VINV
      *
     C     VACTB         IFEQ      'C'
     C     VINV#         ANDNE     OINV#
     C                   MOVEL     VINV#         VINV
     C                   Z-ADD     VOUCH         VVOUCH
     C                   EXSR      GETWK
     C  N10
     CANN13              MOVEL     VINV#         OINV#
     C                   GOTO      NXTB
     C                   ENDIF
     C     VINV#         IFNE      OINV#
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VINV#         OINV#            10
      *
     C     VIDATE        IFEQ      0
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   Z-ADD     VIDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        20
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VAMT          IFEQ      0
     C                   SETON                                        30
     C                   Z-ADD     0             OAMT
     C   30              GOTO      NXTB
     C                   ENDIF
      *
     C     VAMT          IFNE      OAMT
     C                   EXSR      TERMS
     C                   ADD       1             CNT
     C                   ENDIF
     C                   Z-ADD     VAMT          OAMT              9 2
      *
     C     VTYPE         IFNE      ' '
     C     VTYPE         ANDNE     'I'
     C     VTYPE         ANDNE     'C'
     C     VTYPE         ANDNE     'M'
     C     VTYPE         ANDNE     'F'
     C     VTYPE         ANDNE     'W'
     C                   SETON                                        40
     C   40              GOTO      NXTB
     C                   ENDIF
      *
     C     VTYPE         IFNE      OTYPE
     C     VTYPE         IFEQ      'M'
     C     VTYPE         orEQ      'W'
     C                   WRITE     SCRBLNK
     C                   END
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     VTYPE         OTYPE             1
      *
      * MANUAL CHECK or wire
      *
     C     VTYPE         IFEQ      'M'
     C     VTYPE         OREQ      'W'
     C                   SETON                                        51
     C                   ELSE
     C                   SETOFF                                       51
     C                   ENDIF
     C     VTYPE         IFEQ      'W'
     C                   SETON                                        53
     C                   If        VCHECK = 0
     C     01            Chain     FAPNXTWIR
     C                   If        %found()
     C                   eval      VCHECK = NWWIRE
     C                   eval      NWWIRE += 1
     C                   UPDATE    RAPNXTWIR
     C                   ENDIF
     C                   ENDIF
     C                   Eval      VCKDTE = UDATE
     C                   ELSE
     C                   SETOFF                                       53
     C                   ENDIF
      *
      * FREIGHT INVOICE
      *
     C     VTYPE         IFEQ      'F'
     C                   SETON                                        52
     C                   ENDIF
      *
     C     AZUSET        IFEQ      'N'
     C                   GOTO      NOUSE
     C                   ENDIF
      *
     C     VUTAX         IFNE      'Y'
     C     VUTAX         ANDNE     'N'
     C                   SETON                                        65
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VxTAX         IFNE      'Y'
     C     VxTAX         ANDNE     'N'
     C                   SETON                                        65
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VUTAX         IFEQ      'Y'
     C     FIRSTVU       ANDEQ     *ON
     C     VAMT          MULT(H)   USEPER        VUTAX$            6 2
     C                   Move      *Off          FirstVU           1
     C                   ENDIF
     C     VxTAX         IFEQ      'Y'
     C     FIRSTVx       ANDEQ     *ON
     C*    VAMT          MULT(H)   USEPER        VxTAX$            6 2
     C                   Z-add     *Zero         VxTAX$            6 2
     C                   Z-add     *Zero         VxTAX$112        11 2
     C*                  Eval      VxTax$ = VAmt - (VAmt/(1+USEPER))
     C                   Eval      VxTax$112 = (VAmt/(1+USEPER))
     C                   Eval      VxTax$112 = VAmt - VxTax$112
     C                   Eval      VxTax$ = VxTax$112
     C                   Move      *Off          FirstVx           1
     C                   ENDIF
     C     NOUSE         TAG
     C     VUTAX         IFNE      OUTAX
     C                   ADD       1             CNT
     C                   END
     C                   MOVEL     VUTAX         OUTAX
     C     VxTAX         IFNE      OxTAX
     C                   ADD       1             CNT
     C                   END
     C                   MOVEL     VxTAX         OxTAX
      *
      *  CHECK IF RECORD EXISTS IN FAPOPN
      *
     C     VMCDUP        IFNE      'Y'
     C                   GOTO      NODUPA
     C                   END
     C     APKEY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VVEND
     C                   KFLD                    VINV#
     C                   KFLD                    VTYPE
     C     APKEY         SETLL     FAPOPNVE
     C     NXTR          TAG
     C     APKEY         READE     FAPOPNVE                               92
     C   92              GOTO      NODUP
     C                   SETON                                        1012
     C   12              GOTO      NXTB
     C     NODUP         TAG
      *
      * CHECK IF RECORD EXISTS IN FAPWK
      *
     C     VACTB         IFEQ      'A'
     C     APKEY         CHAIN     FAPWKINV                           92
     C   92              GOTO      NODUPA
     C                   SETON                                        1012
     C   12              GOTO      NXTB
     C                   END
     C     NODUPA        TAG
      *
     C     VIDATE        IFNE      OIDATE
     C                   ADD       1             CNT
     C                   Z-ADD     VIDATE        OIDATE            6 0
     C                   ENDIF
      *
      * CALC CHECK AMOUNT FOR MANUAL CHECK
      *
EFD01C                   Z-ADD     0             CKAMT
     C   51              Z-ADD     VAMT          CKAMT             9 2
     C     VTYPE         IFEQ      'M'
     C     VTYPE         orEQ      'W'
     C*          VTYPE     OREQ 'C'
     C                   Z-ADD     0             VDISC
     C                   Z-ADD     0             TCTRAT
     C                   Z-ADD     VIDATE        VIDDTE
     C                   ENDIF
     C     VIDDTE        IFNE      OIDDTE
     C                   ADD       1             CNT
     C                   Z-ADD     VIDDTE        OIDDTE            6 0
     C                   ENDIF
      *
     C  N50              DO
     C                   SETON                                        50
     C                   GOTO      NXTB
     C                   ENDDO
      *
     C     SCRBOT        TAG
      *
     C                   Z-ADD     VIDDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        60
     C                   GOTO      NXTB
     C                   ENDIF
     C     VIDDTE        IFNE      OIDDTE
     C                   ADD       1             CNT
     C                   Z-ADD     VIDDTE        OIDDTE            6 0
     C                   ENDIF
      *
     C     VDISC         IFNE      ODISC
     C                   ADD       1             CNT
     C                   Z-ADD     VDISC         ODISC
     C                   ENDIF
      *
     C     VHOLD         IFNE      'N'
     C     VHOLD         ANDNE     'H'
     C                   SETON                                        70
     C   70              GOTO      NXTB
     C                   ENDIF
     C     VHOLD         IFNE      OHOLD
     C                   ADD       1             CNT
     C                   MOVEL     VHOLD         OHOLD
     C                   END
      *
     C     TCTRAT        IFNE      OCTRAT
     C     VDISC         IFEQ      0
     C                   MOVE      TCTRAT        #DISWK
     C     VAMT          MULT(H)   #DISWK        VDISC
     C                   Z-ADD     VDISC         ODISC
     C                   END
     C                   ADD       1             CNT
     C                   Z-ADD     TCTRAT        OCTRAT
     C                   END
      *
     C     VDESC         IFNE      ODESC
     C                   ADD       1             CNT
     C                   MOVEL     VDESC         ODESC
     C                   END
      *
     C     VPONO         IFNE      OPONO
     C                   ADD       1             CNT
     C                   Z-ADD     VPONO         OPONO
     C                   END
      *
     C     VUTAX         IFNE      OUTAX
     C                   ADD       1             CNT
     C                   MOVEL     VUTAX         OUTAX
     C                   END
      *
     C     VxTAX         IFNE      OxTAX
     C                   ADD       1             CNT
     C                   MOVEL     VxTAX         OxTAX
     C                   END
      *
     C     VTYPE         IFNE      'M'
     C     VTYPE         andNE     'W'
     C                   Z-ADD     0             VCHECK
     C                   Z-ADD     0             VCKDTE
     C                   GOTO      NOMAN
     C                   ENDIF
      *
     C     VCHECK        IFEQ      0
     C                   SETON                                        6226
     C                   SETON                                        5051
     C   26              GOTO      NXTB
     C                   ENDIF
      *
     C     VCHECK        IFNE      OCHECK
     C                   ADD       1             CNT
     C                   Z-ADD     VCHECK        OCHECK
     C                   END
      *
     C                   Z-ADD     VCKDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        6163
     C                   GOTO      NXTB
     C                   ENDIF
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         MCDATE            5 0
      *
      * IS CHECK DATE WITHIN ACCTG PERIOD
      *
     C  N88              GOTO      NOCKAP
     C     MCDATE        IFLT      ABDATE
     C     MCDATE        ORGT      AEDATE
     C                   SETON                                        6164
     C                   ENDIF
     C     NOCKAP        TAG
      *
     C     VCKDTE        IFNE      OCKDTE
     C                   ADD       1             CNT
     C                   Z-ADD     VCKDTE        OCKDTE
     C                   END
      *
      *
      * DOES THIS COMPANY RUN CHECK RECON
      *
     C     AZREC         IFEQ      'N'
     C                   GOTO      NOCKR
     C                   ENDIF
      *
     C     REKEY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VCHECK
     C     REKEY         CHAIN     FAPREC                             19
     C  N19              DO
     C     AKVEND        IFNE      VVEND
     C     AKCKDT        ORNE      VCKDTE
     C                   SETON                                        6225
     C                   GOTO      NXTB
     C                   ENDIF
     C                   ENDDO
      * CHECK IN APWRK
     C                   MOVEL     VCO           APCKEY            8
     C                   MOVE      VCHECK        APCKEY
     C     APCKEY        CHAIN     FAPWKCK                            19
     C  N19              DO
     C     CKVEND        IFNE      VVEND
     C     CKDATE        ORNE      VCKDTE
     C                   SETON                                        6225
     C                   GOTO      NXTB
     C                   ENDIF
     C                   ENDDO
      *
     C     NOCKR         TAG
      *
     C     NOMAN         TAG
      *
     C     VAPGL         IFNE      GDAPPY
     C                   Z-ADD     VAPGL         GLNO
     C     GLKEY         CHAIN     FMGLCH                             10
     C   10              SETON                                        16
     C   16              GOTO      NXTB
     C  N16              MOVEL     GCDESC        APDESC           30
     C                   ENDIF
      *
     C     NOCHK         TAG
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C   98
     CANN84              MOVEL     MSG(1)        MESAGE
     C   98
     CAN 84              MOVEL     MSG(2)        MESAGE
     C                   Z-ADD     0             CNT
     C   98              GOTO      NXTB
     C                   ENDIF
      *
     C                   EXSR      GETREC
     C     VACTB         IFEQ      'A'
     C                   WRITE     RAPWK
     C                   SETON                                        7718
     C                   MOVEL     'Y'           RECCHG
     C                   ENDIF
     C     VACTB         IFEQ      'C'
     C                   UPDATE    RAPWK
     C                   MOVEL     'Y'           RECCHG
     C                   ENDIF
      *
      * N88 COMPANY DOES NOT RUN G/L
      *
     C  N88              GOTO      RSTRT
      *
     C                   MOVEL     VINV#         LSTINV
     C                   ADD       VAMT          VTOTAL
     C     VVEND         CHAIN     FMVEND                             90
      *
     C     VTYPE         IFEQ      'C'
     C                   Z-SUB     VAMT          DAMT              9 2
     C                   ELSE
     C                   Z-ADD     VAMT          DAMT
     C                   ENDIF
      *
     C     RSTRTS        TAG
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C                   EXSR      BLDSFL
     C     NXTSFL        TAG
     C                   EXFMT     RECCTL
     C   KB              DO
     C     LINE          CHAIN     RECSFL                             90
     C                   EXSR      LOOK
      ** CHECK WHAT DESCRIPTION
     C     GLKEY         CHAIN     FMGLCH                             10
     C  N10              DO
     C     ODESC         IFEQ      *BLANKS
     C                   MOVEL     GCDESC        DESC
     C                   MOVE      *BLANKS       ODESC
     C                   ELSE
     C                   MOVEL     APTDES        DESC
     C                   MOVEL     APTDES        ODESC
     C                   END
     C                   ENDDO
     C                   UPDATE    RECSFL
     C                   ENDDO
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   SETOFF                                       86
     C     VACT          IFNE      'C'
     C                   GOTO      RSTRTB
     C                   ELSE
     C                   GOTO      RSTRT
     C                   END
     C                   ENDDO
     C                   GOTO      NXTSFL
      *
     C     END           TAG
      ** UPDATE APCTL AND APCTLB
     C     RECCHG        IFEQ      'Y'
     C     LCO           CHAIN     FAPCTL                             90
     C                   MOVEL     'N'           AZOKP
     C                   UPDATE    RAPCTL
     C     CTLKEY        KLIST
     C                   KFLD                    ABCOMP
     C                   KFLD                    ABUSER
     C                   KFLD                    ABTYPE
     C                   Z-ADD     LCO           ABCOMP
     C                   MOVEL     USERID        ABUSER
     C                   MOVEL     'VOUCH'       ABTYPE
     C     CTLKEY        CHAIN     FAPCTLB                            90
     C                   MOVEL     'N'           ABOK
     C   90              WRITE     RAPCTLB
     C  N90              UPDATE    RAPCTLB
     C                   END
      **
     C                   SETON                                        LR
      *
      ***********
      * BLDSFL
      ***********
     C     BLDSFL        BEGSR
     C                   SETOFF                                       1030
     C                   Z-ADD     DAMT          BAL
     C                   Z-ADD     LCO           APCOMP
     C                   Z-ADD     VOUCH         APVOUC
     C                   Z-ADD     VVEND         APVEND
     C                   MOVEL     VINV#         APINV#
     C                   Z-ADD     0             APSEQ#
     C                   MOVEL     VTYPE         APITYP
     C     APWSKY        KLIST
     C                   KFLD                    APCOMP
     C                   KFLD                    APVOUC
     C                   KFLD                    APVEND
     C                   KFLD                    APINV#
     C                   KFLD                    APITYP
     C                   KFLD                    APSEQ#
     C     APWSTS        KLIST
     C                   KFLD                    APCOMP
     C                   KFLD                    APVOUC
     C                   KFLD                    APVEND
     C                   KFLD                    APINV#
     C                   KFLD                    APITYP
     C     APWSKY        SETLL     FAPWKS
     C     NXBLD1        TAG
     C     APWSTS        READE     FAPWKS                                 90
     C   90              GOTO      ENBLD1
     C     APITYP        IFNE      VTYPE
     C                   GOTO      ENBLD1
     C                   END
     C                   Z-ADD     APGLAC        GLNO
     C                   Z-ADD     APGLAC        OGLNO
     C     AP$AMT        IFGE      0
     C                   Z-ADD     AP$AMT        DEBIT
     C                   Z-ADD     0             CREDIT
     C                   ELSE
     C                   Z-ADD     0             DEBIT
     C                   Z-SUB     AP$AMT        CREDIT
     C                   END
     C                   SUB       DEBIT         BAL
     C                   ADD       CREDIT        BAL
     C                   ADD       1             RECNO
      ** CHECK WHAT DESCRIPTION
     C     GLKEY         CHAIN     FMGLCH                             10
     C  N10              DO
     C     APTDES        IFEQ      GCDESC
     C                   MOVEL     GCDESC        DESC
     C                   MOVE      *BLANKS       ODESC
     C                   ELSE
     C                   MOVEL     APTDES        DESC
     C                   MOVEL     APTDES        ODESC
     C                   END
     C                   ENDDO
     C                   WRITE     RECSFL
     C                   GOTO      NXBLD1
     C     ENBLD1        TAG
      *
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             OGLNO
     C                   Z-ADD     0             APSEQ#
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C*                    MOVEL*BLANKS   DESC
     C     NXTBLD        TAG
     C     RECNO         IFEQ      0
     C     VTYPE         ANDNE     'F'                                                      Y
     C     VTYPE         ANDNE     'C'                                                      Y
     C                   Z-ADD     VMGLAC        GLNO
     C                   Z-ADD     VMGLAC        OGLNO
     C     GLKEY         CHAIN     FMGLCH                             10
     C  N10              MOVEL     GCDESC        DESC
     C                   MOVE      *BLANKS       ODESC
     C                   Z-ADD     DAMT          DEBIT
     C                   ENDIF
     C     RECNO         IFEQ      0
     C     VTYPE         ANDEQ     'F'                                                      Y
     C                   Z-ADD     GLFRT         GLNO
     C                   Z-ADD     GLFRT         OGLNO
     C     GLKEY         CHAIN     FMGLCH                             10
     C  N10              MOVEL     GCDESC        DESC
     C                   MOVE      *BLANKS       ODESC
     C                   Z-ADD     DAMT          DEBIT
     C                   ENDIF
     C     RECNO         IFEQ      0
     C     VTYPE         ANDEQ     'C'                                                      Y
     C                   Z-ADD     VMGLAC        GLNO
     C                   Z-ADD     VMGLAC        OGLNO
     C     GLKEY         CHAIN     FMGLCH                             10
     C  N10              MOVEL     GCDESC        DESC
     C  N10              MOVE      *BLANKS       ODESC
     C                   Z-SUB     DAMT          CREDIT
     C                   ENDIF
     C     RECNO         IFGE      1
     C                   Z-ADD     0             GLNO
     C                   Z-ADD     0             OGLNO
     C                   Z-ADD     0             DEBIT
     C                   Z-ADD     0             CREDIT
     C                   MOVEL     *BLANKS       DESC
     C                   MOVEL     *BLANKS       ODESC
     C                   ENDIF
     C                   ADD       1             RECNO
     C     RECNO         IFGT      50
     C                   GOTO      ENDBLD
     C                   ENDIF
     C                   SETOFF                                       1030
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   SETOFF                                       1030
     C                   ENDSR
      *
      ***********
      * CHKSFL
      ***********
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     DAMT          BAL
     C                   SETOFF                                       103031
     C                   SETOFF                                       324011
     C                   SETOFF                                       99
     C     NXTCHK        TAG
     C                   SETOFF                                       1030
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
     C     GLNO          IFLE      0
     C     DEBIT         ANDLE     0
     C     CREDIT        ANDLE     0
     C                   SETOFF                                       1030
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       ODESC
     C                   Z-ADD     0             OGLNO
     C                   GOTO      NXTCHK
     C                   UPDATE    RECSFL
     C                   ENDIF
     C     GLKEYO        KLIST
     C                   KFLD                    VCO
     C                   KFLD                    OGLNO
     C     GLKEYO        CHAIN     FMGLCH                             10
     C  N10              MOVEL     GCDESC        DESCO            30
     C   10              MOVE      *BLANKS       DESCO
     C     GLKEY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    GLNO
     C     GLKEY         CHAIN     FMGLCH                             10
     C   10              SETON                                        1199
      ** IF ODESC IS BLANK OLD RECORD USED THE GL DESC.
     C     ODESC         IFLE      *BLANKS
     C     DESCO         ANDEQ     DESC
     C   10              MOVE      *BLANKS       DESC
     C  N10              MOVEL     GCDESC        DESC
     C                   ENDIF
     C     OGLNO         IFLE      0
     C                   MOVEL     GCDESC        DESC
     C                   END
     C  N10              DO
     C     DEBIT         IFLE      0
     C     CREDIT        ANDLE     0
     C                   SETON                                        303199
     C                   ENDIF
     C     DEBIT         IFGT      0
     C     CREDIT        ANDGT     0
     C                   SETON                                        303299
     C                   ENDIF
     C                   SUB       DEBIT         BAL
     C                   ADD       CREDIT        BAL
     C                   ENDDO
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C     BAL           IFNE      0
     C                   SETON                                        4099
     C                   ENDIF
     C     CHKEND        TAG
     C                   ENDSR
      ***********
      * PUTSFL
      ***********
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   ENDIF
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
      *
     C     GLKEY         CHAIN     FMGLCH                             10
     C     DESC          IFLE      *BLANKS
     C                   MOVEL     GCDESC        DESC
     C                   END
      *
     C     GLNO          IFEQ      0
     C     APSEQ#        IFLE      0
     C                   GOTO      NXTPUT
     C                   ELSE
     C                   Z-ADD     LCO           APCOMP
     C                   Z-ADD     VOUCH         APVOUC
     C                   Z-ADD     VVEND         APVEND
     C                   MOVEL     VINV#         APINV#
     C                   MOVEL     VTYPE         APITYP
     C     APWSKY        CHAIN     FAPWKS                             92
     C  N92              DELETE    RAPWKS
     C                   GOTO      NXTPUT
     C                   END
     C                   ENDIF
     C                   MOVEL     '01'          TYPE              2
     C     GLDFK         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    TYPE
      *
      * EXPENSE RECORD
      *
     C     APSEQ#        IFLE      0
     C                   ADD       1             SEQ               3 0
     C                   Z-ADD     SEQ           APSEQ#
     C                   ELSE
     C                   Z-ADD     APSEQ#        SEQ
     C                   END
     C                   MOVEL     'A'           APSTAT
     C                   Z-ADD     LCO           APCOMP
     C                   Z-ADD     VOUCH         APVOUC
     C                   Z-ADD     VVEND         APVEND
     C                   MOVEL     VINV#         APINV#
     C                   MOVEL     VTYPE         APITYP
     C     APWSKY        CHAIN     FAPWKS                             92
     C                   MOVEL     VPONO         APPONO
     C                   Z-ADD     VIDATE        APIVDT
     C     DEBIT         IFNE      0
     C                   Z-ADD     DEBIT         AP$AMT
     C                   ENDIF
     C     CREDIT        IFNE      0
     C                   Z-SUB     CREDIT        AP$AMT
     C                   ENDIF
     C                   Z-ADD     GLNO          APGLAC
     C                   MOVEL     DESC          APTDES
     C                   Z-ADD     TDATE         APTDAT
     C                   Z-ADD     AWAPER        APAPER
     C                   Z-ADD     #P            APPERD
     C   92              WRITE     RAPWKS
     C  N92              UPDATE    RAPWKS
      *
     C                   GOTO      NXTPUT
      *
     C     ENDPUT        TAG
     C                   MOVEL     'Y'           RECCHG
     C                   ENDSR
      ********
      * LOOK *
      ********
     C     LOOK          BEGSR
     C     GLKEYO        CHAIN     FMGLCH                             10
     C                   MOVEL     *BLANKS       GCLOOK
     C                   Z-ADD     0             GLNO
     C                   CALL      'LKGLCH'
     C                   PARM                    GCLOOK
     C                   PARM                    VCO
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   Z-ADD     GCGLNO        GLNO
      ** IF ODESC IS BLANK OLD RECORD USED THE GL DESC.
     C     ODESC         IFLE      *BLANKS
     C     DESCO         ANDEQ     DESC
     C                   MOVEL     GCDESC        DESC
     C                   ENDIF
     C     OGLNO         IFLE      0
     C                   MOVEL     GCDESC        DESC
     C                   END
     C                   Z-ADD     GCGLNO        OGLNO
     C                   ENDSR
      *
      ***********
      * GETREC  *
      ***********
     C     GETREC        BEGSR
     C                   MOVEL     'A'           AWSTAT
     C                   Z-ADD     LCO           AWCOMP
     C                   Z-ADD     VOUCH         AWVOUC
     C                   Z-ADD     VVEND         AWVEND
     C                   MOVEL     VINV#         AWINV#
     C                   Z-ADD     1             AWSEQ#
     C                   MOVEL     VTYPE         AWITYP
     C                   MOVEL     *BLANKS       AWVTYP
     C                   MOVEL     VPONO         AWPONO
     C                   Z-ADD     VIDATE        AWIVDT
     C     VIDDTE        MULT      10000.01      RVDATE            6 0
     C                   MOVEL     RVDATE        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     19            CYR               2 0
     C                   ELSE
     C                   MOVEL     20            CYR
     C                   ENDIF
     C                   MOVEL     CYR           AWRVDU            6 0
     C                   MOVE      RVDATE        AWRVDU
     C                   Z-ADD     VIDDTE        AWDUDT
     C                   Z-ADD     VDDDTE        AWDCDT
     C                   MOVEL     VMTMCD        AWVTCD
     C     VTYPE         IFEQ      'C'
     C                   Z-SUB     VAMT          AW$AMT
     C                   ELSE
     C                   Z-ADD     VAMT          AW$AMT
     C                   ENDIF
     C                   Z-ADD     VDISC         AWDAVL
     C                   Z-ADD     TCTRAT        AWTRAT
     C     VTYPE         IFEQ      'M'
     C     VTYPE         orEQ      'W'
     C                   Z-ADD     GLCASH        AWGLAC
     C                   ELSE
     C                   Z-ADD     VAPGL         AWGLAC
     C                   ENDIF
     C                   Z-ADD     TDATE         AWTDAT
     C                   Z-ADD     0             AWTTYP
     C                   MOVEL     VDESC         AWTDES
     C                   MOVEL     VMLOOK        AWLOOK
     C     VTYPE         IFEQ      'M'
     C     VTYPE         orEQ      'W'
     C                   Z-ADD     VCHECK        AWCHEK
     C                   Z-ADD     VCKDTE        AWCKDT
     C                   ELSE
     C                   Z-ADD     0             AWCHEK
     C                   Z-ADD     0             AWCKDT
     C                   ENDIF
     C                   Z-ADD     0             AWBTCH
     C                   MOVEL     *BLANKS       AWTBPD
      * IMMEDIATE PAY
     C     VTYPE         IFEQ      'I'
     C                   MOVEL     'Y'           AWTBPD
     C                   ENDIF
      * HELD INVOICE
     C     VHOLD         IFEQ      'H'
     C                   MOVEL     'H'           AWTBPD
     C                   ENDIF
      *
     C     VTYPE         IFNE      'I'
     C     VHOLD         ANDNE     'H'
     C                   MOVEL     'N'           AWTBPD
     C                   ENDIF
      *
     C                   Z-ADD     TDATE         AWDTLA
     C                   Z-ADD     TIMOD         AWTIME
     C                   MOVEL     USERID        AWUSER
     C                   Z-ADD     VDATE         AWAPER
     C                   Z-ADD     ACDT          AWPERD
     C                   MOVEL     VUTAX         AWUTAX
     C                   Z-ADD     VUTAX$        AWUTX$
     C                   MOVEL     VxTAX         AWxTAX
     C                   Z-ADD     VxTAX$        AWxTX$
     C                   ENDSR
      *
      *******************
      * GET APWK RECORD *
      *******************
     C     GETWK         BEGSR
     C                   SETOFF                                         1013
     C                   Z-ADD     000           SEQ               3 0
     C     AWKEY         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VVEND
     C                   KFLD                    VINV
     C                   KFLD                    VTYPE
     C**                   KFLD           SEQ
     C     AWKEY         CHAIN     FAPWKINV                           93
     C   93              SETON                                        1013
      *
     C     AWSTAT        IFEQ      'D'
     C                   SETON                                        1013
     C                   ENDIF
     C   10              GOTO      ENGETW
      *
      * LOAD FIELDS FOR CHANGE OR DELETE
      *
     C                   Z-ADD     AWCOMP        VCO
     C                   MOVEL     AWUTAX        VUTAX
     C                   MOVEL     AWxTAX        VxTAX
     C                   MOVEL     AWUTAX        OUTAX
     C                   Z-ADD     AWUTX$        VUTAX$
     C                   Z-ADD     AWxTX$        VxTAX$
     C                   Z-ADD     AWVEND        VVEND
     C                   Z-ADD     AWVOUC        VOUCH
     C                   MOVEL     AWINV#        VINV#
     C                   MOVEL     AWINV#        OINV#
     C                   Z-ADD     AWIVDT        VIDATE
     C                   Z-ADD     AWIVDT        OIDATE
     C     AWITYP        IFNE      'C'
     C                   Z-ADD     AW$AMT        VAMT
     C                   Z-ADD     AW$AMT        OAMT
     C                   ELSE
     C                   Z-SUB     AW$AMT        VAMT
     C                   Z-SUB     AW$AMT        OAMT
     C                   END
     C                   MOVEL     AWITYP        VTYPE
     C                   MOVEL     AWITYP        OTYPE
     C                   Z-ADD     AWDUDT        VIDDTE
     C                   Z-ADD     AWDUDT        OIDDTE
     C                   Z-ADD     AWDAVL        VDISC
     C                   Z-ADD     AWDAVL        ODISC
     C                   Z-ADD     AWTRAT        TCTRAT
     C                   Z-ADD     AWTRAT        OCTRAT            4 2
     C                   MOVEL     AWPONO        VPONO
     C                   MOVEL     AWPONO        OPONO             6 0
     C                   MOVEL     AWTDES        VDESC
     C                   MOVEL     AWTDES        ODESC
     C                   MOVEL     AWTBPD        VHOLD
     C                   MOVEL     AWTBPD        OHOLD             1
     C                   Z-ADD     AWCHEK        VCHECK
     C                   Z-ADD     AWCHEK        OCHECK            6 0
     C                   Z-ADD     AWCKDT        VCKDTE
     C                   Z-ADD     AWCKDT        OCKDTE            6 0
     C                   Z-ADD     AWGLAC        VAPGL
     C*                    Z-ADDAWDCDT    DISDTE
     C                   SETON                                        50
     C     AWKEY1        KLIST
     C                   KFLD                    AWUSER
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWVOUC
     C                   KFLD                    VVEND
     C                   KFLD                    VINV
     C                   KFLD                    VTYPE
     C                   KFLD                    AWSEQ#
     C     AWKEY1        CHAIN     FAPWK                              93
     C     ENGETW        ENDSR
      *
      *********************
      * DELETE GL RECORDS *
      *********************
     C     DELGL         BEGSR
     C     APWSKY        SETLL     FAPWKS
     C     NXDELG        TAG
     C     APWSTS        READE     FAPWKS                                 90
     C  N90              DO
     C                   DELETE    RAPWKS
     C                   GOTO      NXDELG
     C                   ENDDO
     C                   ENDSR
      *
      ***********
      * TERMS   *
      ***********
     C     TERMS         BEGSR
     C                   SETOFF                                       59
     C     VMTMCD        CHAIN     FMTERM                             55
     C   55              GOTO      CALDT1
     C                   Z-ADD     TCTRAT        OCTRAT
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
     C                   Z-ADD     VIDATE        DUDT
     C                   Z-ADD     VIDATE        CSHDUE
     C                   MOVE      0             #DISWK            4 4
     C                   GOTO      ECALDT
      *
      * CALCULATE FOR TERMS TYPE '1'
      *
     C     TYP01         TAG
     C                   Z-ADD     VIDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         IDATE             5 0
     C                   Z-ADD     ##DDD         INDTE             5 0
     C                   ADD       TCTDAS        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         DUDT              6 0
      *
     C                   ADD       TCTDAY        IDATE
     C                   Z-ADD     IDATE         ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVE      ##MDY         CSHDUE            6 0
     C                   Z-ADD     CSHDUE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
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
     C                   MOVEL     VIDATE        #WMMDD            4 0
     C                   MOVEL     #WMMDD        #WMM              2 0
     C                   MOVE      #WMMDD        #WDD              2 0
     C                   MOVE      VIDATE        #WYY              2 0
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
     C   58TCDBCO        COMP      0                                      59
     C  N58TCDACO        COMP      0                                      59
     C   59              MOVE      TDATE         CSHDUE
     C   58
     CANN59              MOVE      TCDBCO        #WMMDD
     C  N58
     CANN59              MOVE      TCDACO        #WMMDD
     C  N59              MOVEL     #WMMDD        CSHDUE
     C  N59              MOVE      #WYY          CSHDUE
     C                   Z-ADD     CSHDUE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DIDTE             5 0
     C                   GOTO      ECALDT
      *
      * CALCULATE TERMS TYPE '3'
      *
     C     TYP03         TAG
      *
     C                   MOVE      TCNDUE        DUDT
      *
     C     TCDDUE        IFEQ      0
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
     C     VAMT          MULT(H)   #DISWK        DVAL                           NOT FRGHT/CRM
      *
      *  LOAD WORK FIELDS.
      *
     C     ETERMS        TAG
      *
     C                   Z-ADD     DUDT          VIDDTE
      *  Calculate the Latest Wednesday this can be paid.
     C                   If        $Weekday($DateMDY(VIDDTE):'WED') > 1
     C                   Eval      VIDDTE = $MDYDate(
     C                             $AddDate($DateMDY(VIDDTE):
     C                             -$Weekday($DateMDY(VIDDTE):'WED')+1))
     C                   EndIf
      *  See if we have enough time to pay on selected Wednesday (If not bump it back a week)
     C                   Eval      DaysNeeded = 4
     C                   DoW       $AddDate($DateMDY(VIDDTE):DaysNeeded) >=
     C                             $DateMDY(DUDT)
     C                   Eval      VIDDTE =
     C                             $MDYDate($AddDate($DateMDY(VIDDTE):-7))
     C                   EndDo
      *  If we should have paid this in the past, put the next wednesday as the pay date.
     C                   If        $DateMDY(VIDDTE) < $Date(0)
     C                   Eval      VIDDTE = $MDYDate(
     C                             $AddDate($Date(0):
     C                             -$Weekday($Date(0):'WED')+8))
     C                   EndIf

     C     VTYPE         IFEQ      'C'                                          NEW
     C                   Z-ADD     VIDATE        VIDDTE                         NEW
     C                   ENDIF                                                  NEW
     C     RDATE         IFLE      DIDTE
     C     DVAL          ANDGT     0
     C                   Z-ADD     CSHDUE        VDDDTE            6 0
     C                   Z-ADD     DVAL          VDISC
     C                   Z-ADD     DVAL          ODISC
     C                   ELSE
     C                   Z-ADD     0             VDDDTE
     C                   Z-ADD     0             VDISC
     C                   Z-ADD     0             ODISC
     C                   Z-ADD     0             Y                 2 0
     C                   ENDIF
      *
     C                   ENDSR
      ***********
      * #VND    *
      ***********
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE VENDOR
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
     C     #VND          BEGSR
      *
     C                   MOVE      *BLANKS       #VN
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WVND1        #VN(#X)
     C                   ADD       1             #X
     C     #WVND2        COMP      *BLANKS                            929291
     C   91              GOTO      #VND1
     C                   MOVEL     #WVND2        #VN(#X)
     C                   ADD       1             #X
     C     #VND1         TAG
     C     #WVND3        COMP      *BLANKS                            929291
     C   91              GOTO      #VND2
     C                   MOVEL     #WVND3        #VN(#X)
     C                   ADD       1             #X
     C     #VND2         TAG
     C     #WVND4        COMP      *BLANKS                            929291
     C   91              GOTO      #VND3
     C                   MOVEL     #WVND4        #VN(#X)
     C                   ADD       1             #X
     C     #VND3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WVNCT        CAT       #WVNST:1      WORK1
     C                   MOVEL     #WVNZP        WORK3
     C                   MOVE      #WVNZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #VN(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
**  BOTTOM OF SCREEN MESSAGES
       Validate Data - Change or Press Enter to Accept
 Verify Delete - Press F23 to DELETE - or - F6 for NO DELETE
