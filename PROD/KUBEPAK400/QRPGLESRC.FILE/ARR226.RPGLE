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
      *PROGRAM NAME-------- ARR226
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- A/R HISTORY INQUIRY - CALLED PROGRAM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARHIDTE  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFARHST    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FARR225FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
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
     D  LCUST                  3      8  0
     D  LHIST                  9      9

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$isDate#

      *? Work Field Definitions
    ?D SaveStart       S                   Like(StartDate)
    ?D StartDate7      S             +1    Like(StartDate)

      *
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
     C                   Eval      StartDate7 = $Date7($Date(0))
     C                   Eval      StartDate  = $MDYDate($Date(0))
     C                   Eval      SaveStart  = StartDate
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       CSNAME
     C                   Z-ADD     LCUST         VACUST
     C                   Z-ADD     *ZEROS        VSCUST
     C                   Z-ADD     *ZEROS        TOTAR
     C                   Z-ADD     *ZEROS        VDATE            06 0
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       111214
     C                   SETOFF                                       151617
     C                   SETOFF                                       182240
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     CMCUST        VACUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C     VATELE        ANDGT     *BLANKS
     C                   MOVEL     VATELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VATELE
     C                   Z-ADD     CMCUST        VACUST
     C*                    MOVELCMNAME    VANAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1114
     C   11              GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1214
     C   12              GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        CHAIN     FMCUST                             31
     C   31              SETON                                        1114
     C   11              GOTO      NXTA
     C                   MOVEL     CMNAME        ANAME            30
      *
     C     VDATE         IFEQ      0
     C                   GOTO      NODTE
     C                   ENDIF
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        40
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VDATE         MULT      10000.01      RVDATE            6 0
     C                   MOVEL     RVDATE        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     0             CENT              1 0
     C                   ELSE
     C                   MOVEL     1             CENT
     C                   ENDIF
     C                   MOVEL     CENT          DATERV            7 0
     C                   MOVE      RVDATE        DATERV
     C     NODTE         TAG
      *
      * SHIP TO CUSTOMER
      *
     C     VSCUST        IFEQ      *ZEROS
     C     VSALPH        ANDGT     *BLANKS
     C                   MOVEL     VSALPH        CMLOOK
     C                   CALL      'LKCUSTK'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VSALPH
     C                   MOVEL     CMNAME        CSNAME
     C                   Z-ADD     CMCUST        VSCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VSCUST        IFEQ      *ZEROS
     C     VSALPH        ANDEQ     *BLANKS
     C     VSTELE        ANDGT     *BLANKS
     C                   MOVEL     VSTELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VSTELE
     C                   Z-ADD     CMCUST        VSCUST
     C                   MOVEL     CMNAME        CSNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSCUST        IFGT      *ZEROS
     C     VSALPH        ANDGT     *BLANKS
     C                   SETON                                        1517
     C   17              GOTO      NXTA
     C                   ENDIF
      *
     C     VSCUST        IFGT      *ZEROS
     C     VSCUST        CHAIN     FMCUST                             31
     C  N31              MOVEL     CMNAME        CSNAME           30
     C   31              SETON                                        1615
     C   16              GOTO      NXTA
     C                   ENDIF
      *
      * SET TO STARTING RECORD
      *
     C     ARKEY         KLIST
     C                   KFLD                    VACUST
     C*                  KFLD                    DATERV
     C                   KFLD                    StartDate7
     C     VACUST        CHAIN     FMCUST                             90
     C     ARKEY         SETLL     FARHIDTE
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C                   Eval      *In50 = *Off
     C   KA              GOTO      SCRC
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      ENDP
      *
     C     NXTI          TAG
     C     VACUST        READE     FARHIDTE                               90
     C   90              GOTO      DSPL
     C     AHCOMP        IFNE      LCO                                                      #
     C                   GOTO      NXTI
     C                   ENDIF
     C     VSCUST        IFGT      *ZEROS
     C     AHSHCU        ANDNE     VSCUST
     C                   GOTO      NXTI
     C                   ENDIF
     C                   EXSR      ARTYP
      *
     C     AHSHCU        IFEQ      VACUST
     C                   SETON                                        74
     C                   ENDIF
      *
     C*    AHSHCU        IFNE      VACUST
     C     AHSHCU        CHAIN(N)  FMCUST                             91
     C                   MOVEL     CMNAME        SHNAME           14
     C*                  ENDIF
      *
     C                   Z-ADD     AHTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C                   Z-ADD     AHDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDT              6 0
      *
     C                   ADD       AH$AMT        TOTAR            11 2
      *
     C                   ADD       1             RECNO
     C                   If        RECNO >= 9997
     C                   Eval      *In50 = *On
     C                   Eval      *In90 = *On
     C   90              GOTO      DSPL
     C                   Else
     C                   WRITE     RECSFL
     C                   Z-ADD     AHINV#        OINV              6 0
     C                   MOVEL     *BLANKS       SHNAME
     C                   GOTO      NXTI
     C                   EndIf
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             AHINV#
     C                   MOVEL     *BLANKS       AHSUFF
     C                   MOVEL     *BLANKS       TYPE
     C                   Z-ADD     0             AHTDAT
     C                   Z-ADD     0             AHDUDT
     C                   Z-ADD     0             AHSHCU
     C                   Z-ADD     0             AHDUE$
     C                   Z-ADD     0             AH$AMT
     C                   Z-ADD     TOTAR         AHDUE$
     C                   MOVEL     *BLANKS       AHCHEK
     C                   MOVEL     *BLANKS       SHNAME
     C                   MOVEL     '*End/Dat'    DESC1            10
     C                   MOVE      'a*'          DESC1
     C                   MOVEL     DESC1         AHCHEK
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      ENDP
     C   KA              GOTO      SCRC
     C                   If        SaveStart <> StartDate
     C                   If        not $isDate#(StartDate:'*MDY')
     C                   Eval      StartDate  = 0
     C                   Eval      StartDate7 = 0
     C                   Else
     C                   Eval      StartDate7 = $Date7($DateMDY(StartDate))
     C                   EndIf
     C                   Eval      SaveStart  = StartDate
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     ARKEY         SETLL     FARHIDTE
     C                   Goto      NXTI
     C                   EndIf
     C                   GOTO      RSTRTA
      *
      * CALCULATE A/R HISTORY FIELDS
      *
     C     SCRC          TAG
     C                   SETOFF                                       10
     C                   Z-ADD     *ZEROS        SVAVL$
     C     VACUST        CHAIN     FARHST                             96
     C   96              GOTO      ENDP
      *
     C                   MOVEL     CMTMCD        TRMKEY            2
     C     TRMKEY        CHAIN     FMTERM                             86
      *
     C     HSSIZE        MULT      1000          VBUSSZ            8 0          IN THOUSANDS
      *
     C     VACUST        CHAIN     FMCUST                             96
     C     CMCITY        CAT       CMSTST:1      WORK1            21
     C     WORK1         CAT       CMZIP:1       CSZ              31
     C     CMCRL$        IFGT      *ZEROS
     C     CMCRL$        SUB       CMARB$        SVAVL$           11 2
     C                   ENDIF
      *
     C     ENDAR         TAG
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
     C   KC
     COR KG              GOTO      ENDP
     C   KD              GOTO      RSTRTA
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      *********
      * ARTYP     DETERMINES A/R TYPES
      *********
      *
     C     ARTYP         BEGSR
     C     AHTTYP        IFEQ      01
     C                   MOVEL     'Inv '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      02
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      03
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      04
     C                   MOVEL     'Adj '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      05
     C                   MOVEL     'Crm '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      06
     C                   MOVEL     'L/C '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      07
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      08
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C                   ENDSR
      *
     C     #INSZR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       CSNAME
      *
     C                   Z-ADD     LCUST         VACUST
      *
     C                   ENDSR
      *
