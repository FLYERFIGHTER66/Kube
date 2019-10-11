     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
     H FixNbr(*INPUTPACKED)
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES  1998
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR237
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- FUTURE ORDER RELEASE
      **
      ** CHANGE LOG:
      *   8/17/00 EFD MODIFY FOR KUBE PAK (NO NEW ORDER)
      *
      *
     FBIR237FM  CF   E             WORKSTN
     F                                     SFILE(ORDSFL:RECNO)
     FBIR237P   O    E             PRINTER USROPN  OFLIND(*In14)
     FFHORDR    UF A E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFHORDISCNTUF A E           K DISK
     FFHORDRCSTMUF A E           K DISK
     FFIORDR    UF A E           K DISK
     FFOECTL    UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFLKITM    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMSIZCPLUGIF   E           K DISK
RPADDFFIORDRWK  UF A E           K DISK    Prefix(WRK_)
     FPLUG_ORD  IF   E           K DISK
     FFALITEM   UF A E           K DISK
     FFIORDRPARTUF A E           K DISK    Prefix(PART_)
     FFBIR237   O  A E             DISK
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                          PROGRAM NAME
     D  RLIBR                 81     90                                          RUN LIBRARY
     D  USERID               254    263                                          SER I.D.
     D  SLIBR                314    323                                          SOURCE LIBRARY
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCONO                  1      2  0
     D  LCALL                  3      5
     D  LJOBQ                  6      6
     D  LP1ID                 17     26
     D  LP2ID                 27     36
     D  LBEGDT                37     42  0
     D  LENDDT                43     48  0
     D  LSELEC                49     49  0
     D  LBORD                 50     55  0
     D  LPC1                  59     60
     D  LPC2                  61     62
     D  LRTE1                 63     64
     D  LRTE2                 65     66
     D  LPHY1                 67     67
     D  LPHY2                 68     68
     D  LPREV                 69     69
     D  LSHP1                 70     71
     D  LSHP2                 72     73
     D  LLOC1                 74     76
     D  LLOC2                 77     79
     D  LTAG                  80     80  0
     D  LEORD                 81     86  0
     D  LCANCL               133    133
     D  PASSED               134    134N
     D  POrder               135    140  0
     D  PDate                141    146  0

     D WRK_DS          DS                  INZ
     D   WRK_OIORD#                                                             |K 006          6
     D   WRK_OISEQ#                                                             |K 003          9
     D   WRK_OIITEM                                                             |K 012         21
     D   WRK_OISIZE                                                             |K 003         24
     D   WRK_OIRVDT                                                             |K 007         31
     D   WRK_OIQORD                                                             |K 011P ==> 00637
     D   WRK_OIDES1
     D   WRK_OIDES2
     D   WRK_OIQSHP
     D   WRK_OIQBOO
     D   WRK_OICUST
     D   WRK_OIDTRQ
     D   WRK_OIQINV
     D   WRK_OIPLPT
     D   WRK_OIROUT
     D   WRK_OISTOP
     D   WRK_OILOTC
     D   WRK_OIBORQ
     D   WRK_OIITMA
     D   WRK_OIRVCD
     D   WRK_OIORDT
     D   WRK_OILOT#
     D   WRK_KEY                     42    OverLay(WRK_DS:1) INZ
     D ORD_DS          DS                  INZ
     D       OIORD#                                                             |K 006
     D       OISEQ#                                                             |K 003
     D       OIITEM                                                             |K 012
     D       OISIZE                                                             |K 003
     D       OIRVDT                                                             |K 007
     D       OIQORD                                                             |K 011P ==> 006
     D       OIDES1
     D       OIDES2
     D       OIQSHP
     D       OIQBOO
     D       OICUST
     D       OIDTRQ
     D       OIQINV
     D       OIPLPT
     D       OIROUT
     D       OISTOP
     D       OILOTC
     D       OIBORQ
     D       OIITMA
     D       OIRVCD
     D       OIORDT
     D       OILOT#
     D   ORD_KEY                     42    OverLay(ORD_DS:1) INZ

      *? Fields
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   TempDate      S              7S 0 Inz(*Zeros)                          ?Test Field
     D   PrintWS       S               N   Inz(*Off)                            ?Print Worksheet ?
     D   PrintNotice   S               N   Inz(*Off)                            ?Print Notice ?
     D   FirstCall     S               N   Inz(*On)                             ?1st call to SCR420R
     D   OVR1          S               N   Inz(*Off)                            ?OVRPRTF 1 in effect
     D   OVR2          S               N   Inz(*Off)                            ?OVRPRTF 2 in effect
     D   OrgOrd        S                   Like(VORDER)                         ?Original Order #
     D   FirstSeq      S                   Like(OISEQ#)                         ?First Seq New Order
     D   ViewOrder     S              6P 0                                      ?Order to View
     D   ViewSeq       S              3P 0                                      ?Seq to View
     D   Comment       S                   Like(OIDES1)                         ?Comment Line
     D   FirstTime     S               N   Inz(*On)                             ?First Program Cycle
     D   FirstRec      S               N   Inz(*On)                             ?First Detail Record
     D   OffSet        S              1S 0 Inz(0)                               ?OffSet New/Old Seq#

      *? Data Areas
     D TRR560DF        DS                  DTAARA(TRR560DF)
     D  FinishPRT              1     10                                         ?Dft Chart Printer

      *? Arrays
     D   MSG           S            100A   Dim(0005) CtData PerRcd(1)           ?Message Array
     D   Cmd           S            100A   Dim(0004) CtData PerRcd(1)           ?System Commands

      *? Function Prototypes
     D BIR103WCL       PR                  ExtPgm('BIR103WCL')
     D   #Date                        6P 0 Const
     D   #SelOrder                    6P 0 Const
     D   #CartCount                   5P 2
     D   #Show                        1A   Const
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date8
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,QCmdExc

      ***********************
      ** START UP ROUTINE  **
      ***********************
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     TDATE         LDATE             6 0
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVE      '999'         USDEPT            3
     C     USDEPT        CHAIN     FMDEPT                             90
     C                   MOVEL     DESHFR        VWHS              3
     C     DEPPCK        IFLE      *BLANKS
     C                   MOVEL     'PRT01'       DEPPCK
     C                   END
     C     DEPPC2        IFLE      *BLANKS
     C                   MOVEL     'PRT01'       DEPPC2
     C                   END
     C                   MOVEL     DEPPCK        LP1ID
     C                   MOVEL     DEPPC2        LP2ID
     C                   Z-ADD     1             LTAG
     C                   MOVEL     'Y'           LPREV
     C                   Z-ADD     01            LCONO
     C                   Z-ADD     0             LBEGDT
     C                   Z-ADD     0             LENDDT
     C                   MOVE      *BLANKS       LPC1
     C                   MOVE      *BLANKS       LPC2
     C                   MOVE      *BLANKS       LRTE1
     C                   MOVE      *BLANKS       LRTE2
     C                   MOVE      *BLANKS       LPHY1
     C                   MOVE      *BLANKS       LPHY2
     C                   MOVE      *BLANKS       LSHP1
     C                   MOVE      *BLANKS       LSHP2
     C*                  SETOFF                                       16
     C                   MOVEL     'N'           LABHUN            1
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVEL     'N'           VPICK
wjb  C                   MOVEL     'N'           VSETDN
wjb  C                   MOVEL     'N'           VCHGNOT
     C     RSTART        TAG
     C                   SETON                                        OF
     C                   SETOFF                                         1240
     C                   SETOFF                                       102030
     C                   SETOFF                                       113132
     C                   SETOFF                                       272829
     C                   SETOFF                                       21
     C                   Z-ADD     0             VORDER
     C                   Z-ADD     0             OORD
     C                   If        FirstTime and Passed
     C                   Eval      FirstTime = *Off
     C                   Eval      VPICK = 'N'
     C                   Eval      VORDER = POrder
     C                   Eval      VDATE  = PDate
     C                   Goto      Edit_ScrnA
     C                   EndIf
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  91
     C     Edit_ScrnA    TAG
     C                   SETOFF                                       101320
     C                   SETOFF                                       25  99
wjb  C                   SETOFF                                       2226
     C   KC
     COR KG              DO
     C                   GOTO      EOJ
     C                   ENDDO
     C   KF              GOTO      RSTART
      *
     C     VORDER        CHAIN(N)  FHORDR                             92
     C   92              SETON                                        1099
     C   10              GOTO      NXTA
     C                   Z-ADD     VORDER        OORD              6 0
      ** CHECK IF OPEN
     C     OHSTAT        IFEQ      'D'
     C                   SETON                                        101399
     C                   ENDIF
      *  CHECK DATE
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     ##CYMD        ORCYMD            7 0
      *  CHECK PICK SLIP BASE
     C     VPICK         IFNE      'Y'
     C     VPICK         ANDNE     'N'
     C                   SETON                                        2599
     C                   GOTO      NXTA
     C                   END
      *
     C     VSETDN        IFNE      'Y'
     C     VSETDN        ANDNE     'N'
     C                   SETON                                        2299
     C                   GOTO      NXTA
     C                   else
     C                   If        VSETDN = 'Y'
     C                   Eval      PrintWS   = *On                              |Setdown Worksheet
     C                   Else
     C                   Eval      PrintWS   = *Off
     C                   EndIf
     C                   END
      *
     C     VCHGNOT       IFNE      'Y'
     C     VCHGNOT       ANDNE     'N'
     C                   SETON                                        2699
     C                   GOTO      NXTA
     C                   else
     C                   If        VCHGNOT     = 'Y'
     C                   Eval      PrintNotice = *On
     C                   Else
     C                   Eval      PrintNotice = *Off
     C                   EndIf
     C                   END
      *
     C                   EXSR      BLDSFL
     C                   SETOFF                                       112123
     C                   SETOFF                                       66
     C                   SETOFF                                       9899
      **
     C     NXTFMT        TAG
     C   99              SETOFF                                       98
     C                   EXFMT     ORDCTL
     C                   SETOFF                                       662123
     C                   SETOFF                                           99
     C                   If        Passed and *InKF
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf
      ********* RELEASE ALL  ? ************
     C   KA              DO
     C                   EXSR      RELSFL
     C                   GOTO      NXTFMT
     C                   ENDDO
      ********* CLEAR  ORDER ? ************
     C   KJ              DO                                                     *In10
     C                   SETOFF                                       98
     C                   SETON                                        23
     C     NXTKX         TAG
     C                   EXFMT     ORDCTL
     C   KF              DO                                                     *In06
     C                   SETOFF                                       23
     C                   GOTO      NXTFMT
     C                   ENDDO                                                  KF DO
     C  NKJ              GOTO      NXTKX
     C                   EXSR      DELORD
     C                   EXSR      BLDSFL
     C                   GOTO      NXTFMT
     C                   ENDDO                                                  KY DO
      ********* END DELETE ORDER **********
      ** NOW CHECK IF ALL OK
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C   KF              GOTO      RSTART
      ** IF NOTHING RELEASED DISPLAY SCREEN.
     C     TOTSHP        IFLE      0
     C                   SETON                                        6699
     C                   GOTO      NXTFMT
     C                   END
     C   KH              Do
     C                   Eval      CartCount = Carts('Y')
     C                   GOTO      NXTFMT
     C                   EndDo
     C  N16
     CANNKD              GOTO      NXTFMT
      ** PUT OUT ORDER
     C   KD              EXSR      PUTSFL
     C   16              EXSR      WRTSFL
     C                   If        Porder = 0
     C                   GOTO      RSTART
     C                   Else
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf
      *
     C     EOJ           TAG
     C     VPICK         IFEQ      'Y'
     C                   Z-ADD     VDATE         LBEGDT
     C                   Z-ADD     VDATE         LENDDT
     C                   MOVEL     'FUT'         LCALL
     C                   MOVEL     '5'           LSELEC
     C                   ELSE
     C                   MOVE      *BLANKS       LCALL
     C                   MOVE      'X'           LCANCL
     C                   END
     C                   SETON                                        LR
     C                   If        OVR1
WJB  C                   Eval      Command = Cmd(3)                             ?Remove Override
WJB  C                   ExSr      $Command
     C                   EndIf
     C                   If        OVR2
WJB  C                   Eval      Command = Cmd(4)                             ?Remove Override
WJB  C                   ExSr      $Command
     C                   EndIf
      ********************
      * BUILD SUB FILE   *
      ********************
     C     BLDSFL        BEGSR
      *
      * SET FIORDR BACK TO BEGINING OF ORDER
      *
     C                   Z-ADD     0             OLD               5 0
     C                   Z-ADD     0             LINE              5 0
     C                   SETOFF                                       2799
     C     VORDER        SETLL     FIORDR
     C                   MOVE      '1'           *IN80
     C                   WRITE     ORDCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTOPN
     C                   Z-ADD     0             TOTPRV
     C     NXTORD        TAG
     C                   SETOFF                                       99
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      ENDI
     C                   SETOFF                                       101112
     C                   SETOFF                                       25
     C     OISTAT        IFEQ      'D'
     C*    OIITYP        ORNE      ' '
     C*    OIQORD        ORLE      OIQSHP
     C     OIITYP        OREQ      ' '
     C     OIQORD        andle     OIQSHP
     C     OIITYP        ORne      ' '
     C     OIITYP        andne     'C'
     C                   GOTO      NXTORD
     C                   ENDIF
      **
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C                   If        OIITYP = 'C'
     C                   Eval      SIPRBO = '*'
     C                   Eval      *In12  = *On
     C                   Eval      DESC   = OIDES1
     C                   Eval      ITEM   = OIITEM
     C                   Eval      QTYSHP = *Zero
     C                   Eval      QTYOPN = *Zero
     C                   Eval      QTYPRV = *Zero
     C                   Eval      QTYORD = *Zero
     C                   Else
     C                   Eval      SIPRBO = OIPRBO
     C                   Eval      *In12  = *Off
     C     KEY18         CHAIN     FMINVT                             90
     C     KEY18         CHAIN     FLKITM                             90
     C  N90              DO
     C                   MOVEL     LKDES1        DESC
     C**         LKPOH     SUB  LKPAL     QTYAVL
     C                   ENDDO
     C   90              DO
     C                   MOVEL     IMDES1        DESC
     C                   ENDDO
      ** BUILD RECORD FOR ITEMS STOCK/NON STOCK
     C                   Z-ADD     OIQORD        QTYOPN
     C                   If        OIOVER <> 'Y'
     C                   EXSR      CALPRC
     C                   EndIf
     C                   Z-ADD     OIUPRI        UPRICE            9 4
     C                   Z-ADD     OIRQTY        QTYSHP
     C                   ADD       OIRQTY        TOTSHP
     C                   Z-ADD     OIQORD        QTYORD
     C                   ADD       OIQORD        TOTORD
     C                   Z-ADD     OIQSHP        QTYPRV
     C                   ADD       OIQSHP        TOTPRV
     C     OIQORD        SUB       OIQSHP        QTYOPN
     C                   ADD       QTYOPN        TOTOPN
     C                   MOVEL     OIITEM        ITEM
     C                   Endif
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   GOTO      NXTORD
      *
     C     ENDI          TAG
     C                   SETON                                        12
     C                   SETOFF                                       41
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(1)        DESC
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     0             QTYSHP
     C                   Z-ADD     0             QTYPRV
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             OIDTRQ
     C                   MOVE      *BLANKS       OIPRBO
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   WRITE     ORDSFL
     C                   Z-ADD     RECNO         TRECNO            5 0
     C                   SETOFF                                       12
     C     RECNO         IFGT      7
     C                   SETON                                        97
     C                   ELSE
     C                   SETOFF                                       97
     C                   END
     C                   ENDSR
      ********************
      * DELETE ORDER     *
      ********************
     C     DELORD        BEGSR
     C     VORDER        SETLL     FIORDR
     C     NXTDEL        TAG
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      ENDDEL
     C                   Z-ADD     0             OIRQTY
     C*wjb OIORDT        IFGT      0
     C     OISIZE        SETLL     FMSIZCPLUG
     C                   If        OIORDT > 0 and not %Equal(FMSIZCPLUG)
     C                   Z-ADD     OIORDT        OIDTRQ
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   END
     C                   UPDATE    RIORDR
RPADDC     LOCKEY        CHAIN     FIORDRWK                           99
RPADDC     *IN99         IFEQ      *OFF
RPADDC                   DELETE    RIORDRWK
RPADDC                   ENDIF
     C                   GOTO      NXTDEL
     C     ENDDEL        TAG
     C                   ENDSR
      ********************
      * RELEASE ALL      *
      ********************
     C     RELSFL        BEGSR
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTOPN
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       1011
     C                   SETOFF                                       9899
     C     NXTREL        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDREL
     C                   END
     C                   SETOFF                                       1012
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTREL
     C     OISEQ#        IFEQ      0
     C                   GOTO      NXTREL
     C                   END
     C                   If        OIITYP = *Blanks
     C                   Eval      *In12  = *Off
     C     QTYSHP        IFLE      0
     C                   Z-ADD     QTYOPN        QTYSHP
     C                   END
     C                   ADD       QTYOPN        TOTOPN
     C                   ADD       QTYORD        TOTORD
     C                   ADD       QTYSHP        TOTSHP
     C                   Else
     C                   Eval      *In12  = *On
     C                   EndIf
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTREL
      *
     C     ENDREL        TAG
     C                   ENDSR
      ********************
      * CHECK SUB FILE   *
      ********************
     C     CHKSFL        BEGSR
     C                   Eval      CartCount = Carts('N')
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTOPN
     C                   Z-ADD     0             RECNO
     C                   SETOFF                                       1011
     C                   SETOFF                                       9899
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C                   SETOFF                                       1012
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTCHK
     C     OISEQ#        IFEQ      0
     C                   GOTO      NXTCHK
     C                   END
     C     QTYSHP        IFGT      QTYOPN
     C                   SETON                                        101199
     C                   END
     C                   ADD       QTYOPN        TOTOPN
     C                   ADD       QTYORD        TOTORD
     C                   ADD       QTYSHP        TOTSHP
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTCHK
      *
     C     ENDCHK        TAG
     C     TRECNO        CHAIN     ORDSFL                             90
     C  N90              DO
     C                   SETON                                        12
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(1)        DESC
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   UPDATE    ORDSFL
     C                   ENDDO
     C                   SETOFF                                       12
     C  N99              SETON                                        98
     C     RECNO         IFGT      7
     C                   SETON                                        97
     C                   ELSE
     C                   SETOFF                                       97
     C                   END
     C                   ENDSR
      ********************
      * UPDATE ORDER     *
      ********************
     C     PUTSFL        BEGSR
     C     VORDER        Chain     PLUG_ORD
     C                   Eval      FOORD# = VORDER
     C                   Eval      FODTRL = VDATE
     C                   Eval      FOPLUG = %Found(PLUG_ORD)
     C                   Eval      FODTLA = $MDYDate($Date(0))
     C                   Eval      FOTIME = $Now()
     C                   Eval      FOUSER = $User()
     C                   Write     RBIR237
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTOPN
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             OISEQ             3 0
     C                   Z-ADD     0             LFTOPN            5 0
     C                   SETOFF                                       991011
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C                   SETOFF                                       10
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTPUT
     C     OIKEY         KLIST
     C                   KFLD                    VORDER
     C                   KFLD                    OISEQ#
     C     OIKEY         CHAIN     FIORDR                             91
     C   91              GOTO      NXTPUT
     C                   Z-ADD     QTYSHP        OIRQTY
     C                   ADD       QTYSHP        TOTSHP
     C     OIRQTY        IFGT      0
     C     OIORDT        IFLE      0
     C                   Z-ADD     OIDTRQ        OIORDT
     C                   END
     C                   Z-ADD     VDATE         OIDTRQ
     C                   Z-ADD     ORCYMD        OIRVDT
     C                   MOVEL     'Y'           OINPSL
     C                   ELSE
     C*wjb OIORDT        IFGT      0
wjb  C     OISIZE        SETLL     FMSIZCPLUG
wjb  C                   If        OIORDT > 0 and not %Equal(FMSIZCPLUG)
     C                   Z-ADD     OIORDT        OIDTRQ
     C                   Z-ADD     OIORDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVEL     'N'           OINPSL
     C                   END
     C                   END
     C                   UPDATE    RIORDR

WJB  C                   Eval      PrintWS = *Off
RPADDC     LOCKEY        CHAIN     FIORDRWK                           99
RPADDC                   Z-ADD     ORCYMD        OIRVDT
WJB  C                   Z-ADD     OIRQTY        OIQORD

WJB  C                   If        not %Found(FIORDRWK)

     C                   Eval      WRK_OIORD# = OIORD#
     C                   Eval      WRK_OISEQ# = OISEQ#
     C                   Eval      WRK_OIITEM = OIITEM
     C                   Eval      WRK_OISIZE = OISIZE
     C                   Eval      WRK_OIDES1 = OIDES1
     C                   Eval      WRK_OIRVDT = *Zero
     C                   Eval      WRK_OIQORD = *Zero

WJB  C                   If        OIRQTY > 0
     C                   ExSr      Notice
RPADDC                   WRITE     RIORDRWK
WJB  C                   EndIf

RPADDC                   ELSE

     C                   ExSr      Notice

WJB  C                   If        OIRQTY > 0
RPADDC                   UPDATE    RIORDRWK
WJB  C                   Else
WJB  C                   Delete    RIORDRWK
WJB  C                   EndIf

RPADDC                   ENDIF

WJB  C                   ExSr      Worksheet

     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   If        %Open(BIR237P)
     C                   Close     BIR237P
     C                   EndIf
      ** GET ORDER HEADER
     C     VORDER        CHAIN     FHORDR                             71
     C     TOTSHP        IFGT      0
     C     OHORDT        IFLE      0
     C                   Z-ADD     OHDTRQ        OHORDT
     C                   END
     C                   Z-ADD     VDATE         OHDTRQ
     C                   Z-ADD     ORCYMD        OHDTRY
     C                   ELSE
     C     OHORDT        IFGT      0
     C                   Z-ADD     OHORDT        OHDTRQ
     C                   Z-ADD     OHORDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OHDTRY
     C                   END
     C                   END
     C  N71              UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR237_1'
     C                   Eval      HSTTIME    = $Timestamp()
     C  N71              Write     RHORDRHIST
     C                   ENDSR
      ********************
      * Move Allocations *
      ********************
     C     MOVEALOC      BEGSR

     C     *Like         Define    AIQTOA        Left2Move
     C     *Like         Define    AIQTOA        MovedThisTime
     C     *Like         Define    AIORD#        AI_Ord
     C     *Like         Define    AIOSEQ        AI_Seq

     C                   Eval      AI_Ord = OrgOrd
     C                   Eval      AI_Seq = OISEQ#
     C                   Eval      Left2Move = QtyShp

     C     AIKEY         SetLL     FALITEM
     C     AIKEY         KList
     C                   KFld                    AI_Ord
     C                   KFld                    AI_Seq
     C     AIKEY         ReadE     FALITEM
     C                   DoU       Left2Move <= *Zero or %EOF(FALITEM)
     C                   If        not %EOF(FALITEM)

     C                   If        Left2Move    <= AIQTOA
     C                   Eval      MovedThisTime = Left2Move
     C                   Else
     C                   Eval      MovedThisTime = AIQTOA
     C                   ENDIF

     C                   Eval      Left2Move -= MovedThisTime
     C                   Eval      AIQTOA    -= MovedThisTime
     C                   Eval      AIDTLA     = $MDYDate($Date(0))
     C                   Eval      AITIME     = $Now()
     C                   Eval      AIUSER     = 'BIR237off1'
     C                   Update    RALITEM

     C                   Eval      AIORD#     = VORDER
     C                   Eval      AIOSEQ    += Offset
     C                   Eval      AISHPD     = VDATE7
     C                   Eval      AIQTOA     = MovedThisTime
     C                   Eval      AIDTLA     = $MDYDate($Date(0))
     C                   Eval      AITIME     = $Now()
     C                   Eval      AIUSER     = 'BIR237off2'
     C                   Write     RALITEM

     C                   ENDIF
     C     AIKEY         ReadE     FALITEM
     C                   ENDDO

     C                   ENDSR
      ********************
      * WRITE NEW ORDER  *
      ********************
     C     WRTSFL        BEGSR

     C                   EXSR      DELORD

     C     VORDER        Chain     PLUG_ORD
     C                   Eval      FOORD# = VORDER
     C                   Eval      FODTRL = VDATE
     C                   Eval      FOPLUG = %Found(PLUG_ORD)
     C                   Eval      FODTLA = $MDYDate($Date(0))
     C                   Eval      FOTIME = $Now()
     C                   Eval      FOUSER = $User()
     C                   Write     RBIR237
      *  Get next available Order Number
     C                   Eval      FirstRec = *On
     C                   Z-Add     *Zero         CTL0              2 0
     C     CTL0          Chain     FOECTL
     C                   If        %Found(FOECTL)
     C                   Eval      OrgOrd = VORDER
     C                   Eval      VORDER = OCNORD
     C                   Eval      OCNORD = OCNORD + 1
     C                   Update    ROECTL
     C                   Endif

     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOTORD
     C                   Z-ADD     0             TOTOPN
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             OISEQ             3 0
     C                   Z-ADD     0             LFTOPN            5 0
     C                   SETOFF                                       991011

     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        VDATE7            7 0

     C     NXTPUT2       TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT2
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTPUT2
     C     OIKEY2        KLIST
     C                   KFLD                    OrgOrd
     C                   KFLD                    OISEQ#
     C                   If        QTYSHP > *Zero or ( OIITYP = 'C'
     C                               and ( SIPRBO = 'M' or SIPRBO = 'C' ) )
     C     OIKEY2        CHAIN     FIORDR                             91
     C   91              GOTO      NXTPUT2
     C                   If        FirstRec
     C                   Eval      FirstRec = *Off
     C                   Eval      OffSet = 0
     C                   If        OISEQ# <= 2
     C                   Eval      OffSet = 3 - OISEQ#
     C                   ENDIF
     C                   ENDIF
     C                   ExSr      MoveAloc
     C     OIKEY2        CHAIN     FIORDRPART
     C                   If        %Found(FIORDRPART)
     C                   Delete    RIORDRPART
     C                   Eval      Part_OIORD#  = VORDER
     C                   Eval      Part_OISEQ# += Offset
     C                   Write     RIORDRPART
     C                   EndIf

     C                   If        OIITYP = *Blanks
      * Line Item Logic
      *    Deduct Quantity from original Order
     C                   Eval      OIQORD = OIQORD - QTYSHP                      QTY ORDERED
     C*                  Eval      OIQSHP = OIQSHP + QTYSHP                      QTY SHIPPED
      * If line previously shipped and has a backorder qty, relieve B/O as well.
     C                   If        OIQBOO > 0
     C                   If        OIQBOO >= QTYSHP
     C                   Eval      OIQBOO = OIQBOO - QTYSHP
     C                   Else
     C                   Eval      OIQBOO = *Zero
     C                   EndIf
     C                   EndIf

      * If line is now completely shipped, mark as closed.
     C                   If        OIQORD <= OIQSHP or OIQORD <= *Zero
     C                   Eval      OICOFL = 'Y'
     C                   Eval      OISTAT = 'D'
     C                   Eval      OISHCD = 'N'
     C                   EndIf

      * Recalculate the extended price on the line.
     C                   Eval      OIEXT$ = OIQORD * OIUPRI

     C                   UPDATE    RIORDR
     C                   Else
      * Comment Line Logic
      *    If it's a comment being moved, delete from original Order
     C                   If        OIITYP = 'C' and SIPRBO = 'M'
     C                   DELETE    RIORDR
     C                   EndIf
     C                   EndIf

      * Write New Order Details
     C                   If        FirstSeq = 0
     C                   Eval      FirstSeq = OISEQ# + OffSet
     C                   EndIf

     C                   Eval      OISTAT = 'A'                                  STATUS
     C                   Eval      OIORD# = VORDER                               ORDER NUMBER (New)
     C                   Eval      OISEQ# = OISEQ# + Offset                      ORDER SEQ#
     C                   Eval      OIDTRQ = VDATE                                REQ SHIP DATE
     C                   Eval      OIRVDT = VDATE7                               REQ SHIP DATE CYMD
     C                   Eval      OIQORD = QTYSHP                               QTY ORDERED
     C                   Eval      OIPLPT = 'N'                                  PICK LIST PRINTED
?????C                   Eval      OINPSL = 'N'                                  NO PICK FUT REL
     C                   Eval      OIEXT$ = QTYSHP * OIUPRI                      EXT AMOUNT

     C                   Eval      OIQSHP = *Zero                                QTY SHIPPED
     C                   Eval      OIQBOO = *Zero                                QTY BACKORDERED
     C                   Eval      OIQINV = *Zero                                INV QTY SHIPPED
     C                   Eval      OIORDT = *Zero                                HOLD ORIG REQ SHIP
     C                   Eval      OIRQTY = *Zero                                PRE RELEASE QTY
     C                   Eval      OIDTLA = $MDYDate($Date(0))                   LAST ACTIVITY DATE
     C                   Eval      OITIME = $Now()                               TIME
     C                   Eval      OIUSER = $User()                              USER
     C                   Eval      OICOFL = 'N'

     C                   Eval      TOTSHP = TOTSHP + QTYSHP
     C                   WRITE     RIORDR

WJB  C                   Eval      PrintWS = *Off

     C                   Eval      WRK_OIORD# = OIORD#
     C                   Eval      WRK_OISEQ# = OISEQ# + OffSet
     C                   Eval      WRK_OIITEM = OIITEM
     C                   Eval      WRK_OISIZE = OISIZE
     C                   Eval      WRK_OIDES1 = OIDES1
     C                   Eval      WRK_OIRVDT = *Zero
     C                   Eval      WRK_OIQORD = *Zero

RPADDC                   WRITE     RIORDRWK

WJB  C                   ExSr      Worksheet
WJB  C                   EndIf

     C                   GOTO      NXTPUT2
     C     ENDPUT2       TAG
     C                   If        %Open(BIR237P)
     C                   Close     BIR237P
     C                   EndIf

      ** Write an "Off Master" Comment on Line 2
     C                   Eval      Comment = ' OFF MASTER ORDER ('
     C                             + %Trim(%Char(OrgOrd)) + ')'
     C                   ExSr      CrtComment

      ** WRT ORDER HEADER
     C     OrgOrd        CHAIN(N)  FHORDR                             71
     C                   Eval      OHORD# = VORDER                               Order Number
     C                   Eval      OHDTOR = $MDYDate($Date(0))                   ORDER DATE
     C                   Eval      OHDTRQ = VDATE                                REQ SHIP DATE
     C                   Eval      OHDTRY = VDATE7                               REQ. DATE CYMD
     C                   Eval      OHDTCN = VDATE                                CANCEL DATE
     C                   Eval      OHTDAT = $MDYDate($Date(0))                   DATE OF TRANS
     C                   Eval      OHDTLA = $MDYDate($Date(0))                   LAST ACTIVITY DATE
     C                   Eval      OHTIME = $Now()                               TIME
     C                   Eval      OHUSER = $User()                              USER
     C                   Eval      OHORDY = $Date7($Date(0))                     ORDER DATE CYMD
     C                   Eval      OHORDT = VDATE                                ORIGINAL REQ DATE
     C                   Eval      OHINV# = *Zero                                INVOICE NUMBER
     C                   Eval      OHIVCD = *Blanks                              INVOICED CODE

     C                   WRITE     RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR237_2'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST

      ** WRT DISCOUNT FILE
     C     OrgOrd        CHAIN     FHORDISCNT
     C                   If        %Found(FHORDISCNT)
     C                   Eval      ADORD# = VORDER                               Order Number
     C                   WRITE     RHORDISCNT
     C                   EndIf

      ** WRT CUSTOM ORDER RECORD
     C     OrgOrd        CHAIN     FHORDRCSTM
     C                   If        %Found(FHORDRCSTM)
     C                   Eval      COORD# = VORDER                               Order Number
     C                   WRITE     RHORDRCSTM
     C                   EndIf

      *? Update the Inventory Allocation File (FALITEM) for both Orders
     C                   Call      'FIXFALITE1'                                  Original Order
     C                   Parm                    OrgOrd
     C                   Call      'FIXFALITE1'                                  Off Master Order
     C                   Parm                    VORDER
      *  Clear out Finished Scans
     C                   Call      'NCR730'                                      Original Order
     C                   Parm                    OrgOrd

      *? Now go take a look at the new Order just created
     C                   Call      'BIR100CLO'
     C                   Parm      VORDER        ViewOrder
     C                   Parm      FirstSeq      ViewSeq

     C                   Eval      FirstSeq = 0

     C                   ENDSR
      *?  ...........................................................
      *?  :      CrtComment - Create a Comment Line in Order        :
      *?  :.........................................................:
      *       Creates a comment line based on the current item.
     C     CrtComment    BEGSR
     C                   Clear                   RIORDR
     C                   Eval      OISTAT = 'A'                                 STATUS
     C                   Eval      OIORD# = VORDER                              ORDER NUMBER
     C* WJB              Eval      OISEQ# = 1                                   SEQ NUMBER
WJB  C                   Eval      OISEQ# = 2                                   SEQ NUMBER
     C                   Eval      OICOMP = 1                                   COMPANY #
     C                   Eval      OISHCD = 'N'                                 SHIP RELEASE CODE
     C                   Eval      OIOVER = '5'                                 OVERRIDE CODE
     C                   Eval      OIBOCD = 'Y'                                 ITEM B/O ALLOWED
     C                   Eval      OISLM1 = '01'                                SALESPERSON 1
     C                   Eval      OICUST = OHCUST                              CUSTOMER #
     C                   Eval      OIDTRQ = VDATE                               REQ SHIP DATE
     C                   Eval      OIDTLA = $MDYDate($Date(0))                  LAST ACTIVITY DATE
     C                   Eval      OITIME = $Now()                              TIME
     C                   Eval      OIUSER = $User()                             USER
     C                   Eval      OIITYP = 'C'                                 ITEM TYPE
     C                   Eval      OIDTRQ = VDate                               HOLD ORIG REQ SHIP D
     C                   Eval      OIRVDT = VDate7                              REQ SHIP DATE CYMD
     C                   Eval      OIALPH = OHALPH                              Customer Alpha
     C                   Eval      OIDES1 = Comment
     C                   WRITE     RIORDR
     C                   ENDSR
      ***********************
      ** CALC PRICE        **
      ***********************
      ** SUBROUTINE ASSUMES YOU HAVE CHAINED TO FMINVT
     C     CALPRC        BEGSR
      ** GET MARKET PRICE
     C                   Z-ADD     0             #OPRC             9 2
     C                   Z-ADD     0             OIQDDC            4 2
     C                   Z-ADD     0             OHBLCU            6 0
     C                   Z-ADD     0             OHORD#            6 0
     C                   MOVEL     '1'           PRICD             1
     C                   MOVEL     'N'           OICTCD            1
     C                   MOVEL     'N'           OIFRQD            1
     C                   Z-ADD     0             VOLDSC            4 2
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMBPUM
     C                   PARM                    QTYOPN
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    IMORDD
     C                   Z-ADD     #OPRC         UPRICE
     C                   ENDSR

      *?  ...........................................................
      *?  :      Notice - Print Order Change Notice                 :
      *?  :.........................................................:

      *?      If the order being modified is currently in the process
      *?      of being shipped, print an "Order Change Notice" to let
      *?      the shipping folks know that an order they are working
      *?      on has been changed.

WJB  C     Notice        BEGSR

     C                   If        PrintNotice

WJB  C                   Eval      PrintWS = *Off
WJB  C                   Eval      TempDate = $Date7($AddDate($Date(0):1))
WJB  C                   If            WRK_KEY <> ORD_KEY
WJB  C                             and WRK_OIRVDT<= $Date7($AddDate($Date(0):1))
WJB  C                             and WRK_OIRVDT <> 0                          |Zero if New WRK rcd
WJB  C                             or  WRK_KEY <> ORD_KEY
WJB  C                             and OIRVDT <= $Date7($AddDate($Date(0):1))
WJB  C                   ExSr      Print_ERR
WJB  C                   Eval      PrintWS = *On
WJB  C                   EndIf

WJB  C                   EndIf

WJB  C                   Eval      WRK_DS  = ORD_DS

     C                   ENDSR

      *?  ...........................................................
      *?  :      Worksheet - Print Location Worksheet               :
      *?  :.........................................................:

WJB  C     Worksheet     BEGSR

     C                   If        PrintWS

WJB  C                   If        FirstCall
WJB  C                   Eval      FirstCall = *Off
WJB  C                   Eval      Command = Cmd(2)                             ?Short Paper 8.5x11
WJB  C                   ExSr      $Command
     C                   Eval      OVR2 = *On
WJB  C                   EndIf

WJB  C                   Eval      STDATE = %Char($Date8($date(OIRVDT)))
WJB  C                   Call      'SCR420R'
WJB  C                   PARM                    STDATE            8
WJB  C                   PARM                    OIITEM
WJB  C                   PARM                    OISIZE
     C                   EndIf

     C                   ENDSR

      *?  ...........................................................
      *?  :      Print_ERR - Print error report for Items Changed   :
      *?  :.........................................................:

     C     Print_ERR     BEGSR

     C                   If        not %Open(BIR237P)
     C                   In        TRR560DF
     C                   Eval      Command = Cmd(1)                             ?Short Paper 8.5x11
     C                   ExSr      $Command
     C                   Eval      OVR1 = *On
     C                   Open      BIR237P
     C                   Write     Header
     C                   Eval      *In14 = *Off
     C                   EndIf

     C                   If        *In14
     C                   Write     Header
     C                   Eval      *In14 = *Off
     C                   EndIf

     C                   If        WRK_OIRVDT <> *Zero
     C                   Eval      ShipDtO = $MDYDate($Date(WRK_OIRVDT))
     C                   Else
     C                   Eval      ShipDtO = *Zero
     C                   EndIF
     C                   Eval      ShipDtC = $MDYDate($Date(OIRVDT))
     C                   Write     Detail

     C                   ENDSR

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put vaiable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C                   DoW       %Scan('|P':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(FinishPRT): Command :
     C                               %SCAN('|P': Command))
     C                   EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

     C                   EndSR


RPADD ********************************************************************
RPADD * ?INIT - Program Initialization and Housekeeping                 ?*
RPADD ********************************************************************
RPADDCSR   *INZSR        BEGSR
RPADD *
     C                   In        TRR560DF
RPADDC     LOCKEY        KLIST
RPADDC                   KFLD                    VORDER
RPADDC                   KFLD                    OISEQ#
RPADD *
RPADDC                   ENDSR
       //?  ...........................................................
       //?  :   SUB-PROCEDURES                                        :
       //?  :.........................................................:
       //?Carts - Use a Work File to Calculate Carts for Selected Items
     P Carts           B
     D Carts           PI             6S 1
     D  Show                          1A         Const
     D  ShipDate7      S              7S 0
     D  Count          S              5P 2
     D  ThisSeq#       S              3S 0
     D  ThisSize       S              3A
     D  ThisRec        S                         Like(RECNO)
      /Free

         //?First clear out this order from the Work File.
         Exec SQL    // Delete this Order (Just in Case)
           Delete From FIORDRWORK Where OIORD# = :VOrder;

         //?Add Release Quantity to Work File.
         ThisRec = 1;
         Chain ThisRec ORDSFL;
         // DoW not %EOF(BIR237FM) and OIDTRQ <>0;
         // DoW ThisRec <= 200 and OIDTRQ <>0;
         DoW ThisRec <= RECNO and OIDTRQ <>0;
           ShipDate7 = $Date7($Date(0)); // Use Today's Date
           ThisSeq#  = OISEQ#;
           ThisSize  = OISIZE;
           Exec SQL // Insert into Work File
             INSERT INTO FIORDRWORK
              (  OISTAT
              ,  OIORD#
              ,  OISEQ#
              ,  OIITEM
              ,  OISIZE
              ,  OIDES1
              ,  OIQORD
              ,  OIRVDT  )
             Values
              (  'A'
              , :VOrder
              , :ThisSeq#
              , :ITEM
              , :ThisSize
              , :DESC
              , :QTYSHP
              , :ShipDate7 );
           ThisRec += 1;
           Chain ThisRec ORDSFL;
         EndDo;

         //?Get the Number of Carts
         CallP BIR103WCL($MDYDATE($DATE(0)):VOrder:Count:Show);

         //?Clear out the Work File
         Exec SQL    // Delete this Order (Maintenance)
           Delete From FIORDRWORK Where OIORD# = :VOrder;

         Return Count;

      /End-Free
     P Carts           E
** MESSAGE
----* End of Order *                                       1
----* End of Items *                                       2
                                                           3
                                                           4
                                                           5
** Commands
OVRPRTF FILE(BIR237P) FORMTYPE(*NAR) CPI(12) PAGRTT(0) OVRSCOPE(*JOB) OUTQ(|P~~~~~~~~)
OVRPRTF FILE(SCR420P) FORMTYPE(*NAR) CPI(12) PAGRTT(0) OVRSCOPE(*JOB) OUTQ(|P~~~~~~~~) HOLD(*YES)
DLTOVR FILE(BIR237P) LVL(*JOB)
DLTOVR FILE(SCR420P) LVL(*JOB)
