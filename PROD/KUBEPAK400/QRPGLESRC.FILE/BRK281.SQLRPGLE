    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
     H*--------------------------------------------------------------          1
     H*                                                                        1
     H*  COPYRIGHT EFD ENTERPRISES, INC.    1999
     H*                                                                        1
     H*       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
     H*       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
     H*       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
     H*       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
     H*       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
     H*       BY EXPRESS WRITTEN PERMISSION OF
     H*            EFD ENTERPRISES, INC.     215-643-5352
     H*
     H*--------------------------------------------------------------
     F**PROGRAM NAME-------- BRK281
     F**COMPANY------------- EFD ENTERPRISES, INC.
     F**SYSTEM-------------- THE GREENHOUSE MANAGEMENT SYSTEM
     F**PROGRAMMER---------- EFD
     F**APPLICATION--------- SELECT CUSTOMER AND CREATE ORDER
     F**DESCRIPTION--------- THIS PROGRAM CREATES ORDER FROM BROKER INPUT
     F**            PLUG AVAILABILITY SCREEN.
     F**             (KUBE PAK USE)
     F**
     F**
     F**
     F**
     F**
     F*            *******************************
     F*            **     PROGRAM CHANGE LOG    **
     F*            *******************************
     F*
     F*            CHANGE--DATE-------DESCRIPTION
     F*
     F**
     F*
     F*
     FBRK281FM  CF   E             WORKSTN
     F                                     SFILE(ORDSFL:RECNO)
     FFMINVT    IF   E           K DISK
     FFDLOTRD   UF   E           K DISK
     FFOECTL    UF   E           K DISK
     FFALITEM   UF A E           K DISK
WJB  F*FDLOTDSI  IF   E           K DISK
WJB  FFDLOTSDI  IF   E           K DISK
     F                                     RENAME(RDLOTRD:LOTRD)
     FFDLOT     UF A E           K DISK
     FFHORDR    O  A E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    O  A E           K DISK
     FFIORDRPARTO  A E           K DISK
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  BROKER                 1      1                                         ARC380
     D  BRKORD                 2      7  0                                      ARC380
     D  LDAACT                10     10                                         QPK221
     D  LDAORD                11     16  0                                      QPK221
     D  LDACST                20     25  0                                      QPK221
     D  LDAREQ                30     35  0                                      QPK221
     D  LDADTE                36     41  0                                      QPK221
     D  LDAPRC                42     42  0                                      QPK221
     D  LDACO#                43     44  0                                      QPK221
     D  LDAINV                45     45                                         QPK221
     D  LDABOC                46     46                                         QPK221
     D  LDAODT                47     52  0                                      QPK221
     D  LDAPR1                53     54                                         QPK221
     D  LDAPR2                55     56                                         QPK221
     D  CANCEL               133    133                                         QPK221
     D  LDAINQ               238    243                                         QPK221
     D  LDABIL               244    249  0                                      QPK221
     D  LDATXF               250    250                                         QPK221
     D  LDATXS               251    251                                         QPK221
     D  LDAAR#               252    257  0                                      QPK221
     D  LDPRFL               293    293                                         QPK221

      *? Function Prototypes
    ?D/COPY QFunctDefn,$_IC
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

     D  LRGLOCBlank    S                   Like(LRGLOC)
     D #PartialPCT     S              4S 2                                      ?#PartialPCT
     D #Saleable       S              5S 0                                      ?#Saleable
     D #Cells          S              3S 0                                      ?#Cells
     D #ofCells        S              3S 0                                      ?#ofCells
     D #Discount       S              4S 1                                      ?#Discount

      /Free
    ?   /COPY QFunctDefn,LASTUSEDC1
      /End-Free
     C*                                                                   QPK221
     C**************                                                      QPK220
     C* MAIN ROUTINE *                                                    QPK220
     C***************                                                     QPK220
      /Free
    ?   /COPY QFunctDefn,LASTUSEDC2
      /End-Free
     C     RSTART        TAG
     C                   MOVEL     'Y'           BROKER
     C                   SETOFF                                       U8U1
     C***                  Z-ADD0         RETRY
     C     NXTA          TAG
     C                   WRITE     SCRNA                                                       QPK22
     C                   SETOFF                                       102030
     C                   SETOFF                                       99
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   SETON                                        LR
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C** GET ORDER NUMBER                                                 QPK220
     C                   Z-ADD     0             WCO               2 0
     C     WCO           CHAIN     FOECTL                             90
     C                   Z-ADD     OCNORD        ORDNUM            6 0
     C     OCNORD        ADD       1             OCNORD
     C                   UPDATE    ROECTL                                       UPDATE MCOMP
     C                   Z-ADD     ORDNUM        OHORD#
     C                   Z-ADD     ORDNUM        OIORD#
     C                   Z-ADD     ORDNUM        BRKORD
     C***  VALIDATE DATE                                                  QPK220
     C                   MOVE      SHPDAT        ##MDY                                         QPK22
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C     SHPDAT        ANDNE     *Zero
     C                   SETON                                        9910                     QPK22
     C                   END
     C   99              GOTO      NXTA
     C                   Z-ADD     ##CYMD        REQDAT            7 0                         QPK22
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C*
     C  N99#Y            IFNE      1
     C                   SETON                                        9910
     C                   END
     C*
     C   99              GOTO      NXTA                                                        QPK22
     C                   Z-ADD     SHPDAT        OHDTRQ
     C                   Z-ADD     SHPDAT        OIDTRQ
     C                   MOVE      ##CYMD        OIRVDT                                        QPK22
     C*                                                                   QPK220
     C** CHECK PRODUCT CLASS
     C*                  If        %Subst(SIZE:3:1) = *Blank
     C*                  Eval      SIZE = ' ' + %Subst(SIZE:1:2)
     C*                  EndIf
     C     SIZE          IFNE      '512'
     C     SIZE          ANDNE     '288'
     C     SIZE          ANDNE     '162'
     C     SIZE          ANDNE     '105'
     C     SIZE          ANDNE     '102'
     C*    SIZE          ANDNE     ' 51'
     C*    SIZE          ANDNE     ' 50'
     C     SIZE          ANDNE     '50 '
     C     SIZE          ANDNE     '51 '
     C                   SETON                                        9920
     C                   GOTO      NXTA
     C                   END
     C** CHECK ALPHA SEARCH
     C     ALPHA         IFLT      'A  '
     C                   SETON                                        3099
     C                   GOTO      NXTA
     C                   END
      ** ALL OK IF HERE
     C     RSTFMT        TAG
     C                   EXSR      BLDSFL
     C     RECNO         IFLE      0
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   END
     C     NXTFMT        TAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C   99              SETOFF                                       98
     C                   MOVE      *BLANKS       NEWSIZ
     C                   EXFMT     ORDCTL                                                      QPK22
     C                   SETOFF                                       81
      ** CHECK F KEYS
     C   KF              DO
     C                   EXSR      DELALO
     C                   GOTO      RSTART
     C                   ENDDO
     C   KC
     COR KG              DO
     C                   EXSR      DELALO
     C                   SETON                                        LR
     C                   MOVEL     'X'           CANCEL
     C                   GOTO      END
     C                   ENDDO
     C                   EXSR      CHKSFL
      ** SEE IF NEW SIZE ENTERED
     C*                  If        %Subst(NEWSIZ:3:1) = *Blank
     C*                  Eval      NEWSIZ = ' ' + %Subst(NEWSIZ:1:2)
     C*                  EndIf
     C     NEWSIZ        IFGT      *BLANKS
     C     NEWSIZ        IFNE      '512'
     C     NEWSIZ        ANDNE     '288'
     C     NEWSIZ        ANDNE     '162'
     C     NEWSIZ        ANDNE     '105'
     C     NEWSIZ        ANDNE     '102'
     C*    NEWSIZ        ANDNE     ' 51'
     C*    NEWSIZ        ANDNE     ' 50'
     C     NEWSIZ        ANDNE     '50 '
     C     NEWSIZ        ANDNE     '51 '
     C                   SETON                                        9981
     C                   GOTO      NXTFMT
     C                   END
     C                   EXSR      GETSIZ
     C                   GOTO      NXTFMT
     C                   END
     C   99              GOTO      NXTFMT
     C  N98              SETON                                        98
      ** IF NO ERROR AND NOT F4 REDISPLAY SCREEN
     C  NKB              GOTO      NXTFMT
     C                   SETON                                        U1
     C                   EXSR      PUTORD
     C*                                                                   QPK220
     C     END           TAG                                                                   QPK22
     C                   SETOFF                                       U1
     C                   SETON                                        LR                       QPK22
     C**
     C******************                                                  QPK220
     C* BUILD SUB FILE *                                                  QPK220
     C******************                                                  QPK220
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     ORDCTL
     C                   SETOFF                                       8071
     C                   SETOFF                                       101199
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             PAGE#             4 0
     C                   Z-ADD     0             TOTQTY
WJB  C*    REQDAT        SETLL     FDLOTDSI
WJB  C     *LoVal        SETLL     FDLOTSDI
     C     NXTBLD        TAG
WJB  C*    REQDAT        READE(N)  FDLOTDSI                               90
WJB  C                   READ(N)   FDLOTSDI                               90
WJB  C   90              GOTO      ENDBLD
WJB  C                   If        LRCRDY > REQDAT
WJB  C                   GoTo      NXTBLD
WJB  C                   EndIf
WJB  C                   If        LRGLOC = '997'
WJB  C                   GoTo      NXTBLD
WJB  C                   EndIf
WJB  C                   If        SELCUST > *Zero and
WJB  C                             LRCUST <> SELCUST
WJB  C                   GoTo      NXTBLD
WJB  C                   EndIf
WJB  C                   If        LRGLOC = 'N'
WJB  C                   GoTo      NXTBLD
WJB  C                   EndIf
WJB  C                   If        LRCUST = 999990
WJB  C                   GoTo      NXTBLD
WJB  C                   EndIf
WJB  C*                  If        LRCRDY <= $Date7($Monday($Date(0):'SAT'))
WJB  C*                            and LRGLOC <> 'R'
WJB  C*                  GoTo      NXTBLD
WJB  C*                  EndIf
WJB  C                   If        LRGLOC = 'N'
WJB  C                   GoTo      NXTBLD
WJB  C                   EndIf
     C                   If        LRCUST = 999997
WJB  C                   If        LRGLOC <> 'R'                                Only show partials
WJB  C                   GoTo      NXTBLD                                       if they are scanned
WJB  C                   EndIf                                                  into the ready bay.
      /FREE
         //? Get Totals
         exec sql
           SELECT  LDPRTT * 100
           INTO    :PartPCT
           FROM    FLOSSLOT
           WHERE   LDITEM=:LRITEM
             and   LDSIZE=:LRSIZE
             and   LDSOWD=:LRSOWD
             and   LDREDY=:LRCRDY  ;
      /END-FREE
     C                   Eval      *In40 = *On
     C                   Else
     C                   Eval      partpct = 0
     C                   Eval      *In40 = *Off
     C                   EndIf
WJB  C                   Eval      ITEM5 = LRITEM
WJB  C                   Eval      DATE4 =%Int(%SubSt(%Trim(%Char(LRCRDY)):4:4))
     C     MINKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              GOTO      NXTBLD
     C     LRQTOH        SUB       LRQTAL        QTYAV
WJB  C*                  If        LRGLOC <> 'R'                                If not scanned in RB
WJB  C*                  SUB       1             QTYAV                          subtract 1 from the
WJB  C*                  EndIf                                                  available quantity.
WJB  C* On 2/22/2018 we decided not to do this subtract 1 anymore per Bill S.
     C     QTYAV         IFLE      0
     C                   GOTO      NXTBLD
     C                   END
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             QTYAL
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C     PAGE#         IFLE      0
     C*    IMSIZE        ANDEQ     SIZE
     C     IMSIZE        ANDGE     SIZE
     C     IMLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
     C******************                                                  QPK220
     C* CHECK SUB FILE *                                                  QPK220
     C******************                                                  QPK220
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTQTY
     C                   SETOFF                                       101199
     C                   SETOFF                                       71
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTCHK
     C     QTYORD        IFEQ      QTYAL
     C                   ADD       QTYORD        TOTQTY
     C                   GOTO      NXTCHK
     C                   END
     C                   SETOFF                                       10
     C     LOTKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRCRDY
     C                   KFLD                    LRGLOC
     C                   KFLD                    LRCLOC
     C                   KFLD                    LRCODE
     C                   KFLD                    LRCUST
     C     LOTKEY        CHAIN     FDLOTRD                            55
     C     LRQTOH        SUB       LRQTAL        AVAIL            11 1
     C     QTYAL         ADD       AVAIL         TSTAV            11 1
     C     TSTAV         IFLT      QTYORD
     C                   SETON                                        101199
     C                   Z-ADD     AVAIL         QTYAV
     C                   UPDATE    ORDSFL
     C                   ELSE
     C     QTYORD        SUB       QTYAL         NEWAL            11 1
     C                   ADD       NEWAL         LRQTAL
WJB  C                   Eval      LRQTAV = LRQTOH - LRQTAL
     C                   UPDATE    RDLOTRD
     C     FDLOTKEY      KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRWHSE
     C                   KFLD                    LRSOWD
     C                   KFLD                    LRGLOCBlank
     C                   KFLD                    LRCRDY
     C                   Eval      LRGLOCBlank = *Blanks
     C     FDLOTKEY      Chain     FDLOT
     C                   If        %Found(FDLOT)
     C                   Eval      LDQTAL = LDQTAL + NEWAL
     C                   Eval      LDQTAV = LDQTAV - NEWAL
     C                   Update    RDLOT
     C                   Else

     C                   Eval      LDSTAT = 'A'
     C                   Eval      LDITEM = LRITEM
     C                   Eval      LDSIZE = LRSIZE
     C                   Eval      LDWHSE = *Blanks                             Always Blank
     C                   Eval      LDSOWD = LRSOWD
     C                   EVAL      LDGLOC = *Blanks                             Always Blank
     C                   EVAL      LDPHYT = *Blanks                             Always Blank
     C                   EVAL      LDFIXD = 'N'
     C                   EVAL      LDAREA = *Blanks                             Always
     C                   Eval      LDCOMP = 1
     C                   Eval      LDSHPD = LRCRDY
     C                   Eval      LDCOST = *Zero
     C                   Eval      LDVEND = *Zero
     C                   Eval      LDQTOH = *Zero
      *
     C                   Eval      LDQTAL = NEWAL
     C                   Eval      LDQTAV =-NEWAL
      *
     C                   Eval      LDQTSP = *Zero
     C                   Eval      LDQTAJ = *Zero
     C                   Eval      LDQFIX = *Zero
     C                   Eval      LDQDMP = *Zero
     C                   Eval      LDQTXP = *Zero
     C                   Eval      LDDTLA = $MDYDate($Date(0))
     C                   Eval      LDTIME = $Now()
     C                   Eval      LDUSER = $User()
     C                   Eval      LDPCQT = *Zero
     C                   Eval      LDALPH = LRALPH
     C                   Eval      LDCRDY = LRCRDY
     C                   Eval      LDSOWN = *Zero
     C                   Eval      LDSDLT = *Blanks
     C                   Eval      LDGERM = *Zeros
     C                   Eval      LDDESC = LRDESC
     C                   Eval      LDPRCL = LRPRCL
     C                   Write     RDLOT
     C                   ENDIF
     C                   Z-ADD     QTYORD        QTYAL
     C                   UPDATE    ORDSFL
     C                   END
     C                   ADD       QTYORD        TOTQTY
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C  N99TOTQTY        IFLE      0
     C                   SETON                                        9971
     C                   END
     C                   ENDSR
     C*********************                                               QPK220
     C* RELEIVE ALLOCATED *                                               QPK220
     C*********************                                               QPK220
     C     DELALO        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTQTY
     C     NXTDEL        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDDEL
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTDEL
     C     QTYORD        IFLE      0
     C                   GOTO      NXTDEL
     C                   END
     C     LOTKEY        CHAIN     FDLOTRD                            55
     C                   SUB       QTYAL         LRQTAL
     C                   UPDATE    RDLOTRD
     C                   GOTO      NXTDEL
     C     ENDDEL        TAG
     C                   ENDSR
     C******************                                                  QPK220
     C* GET NEW SIZE   *                                                  QPK220
     C******************                                                  QPK220
     C     GETSIZ        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             PAGE#
     C     NXTSIZ        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDSIZ
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTSIZ
     C*    LRSIZE        IFEQ      NEWSIZ
     C     LRSIZE        IfGE      NEWSIZ
     C     PAGE#         AndLE     0
     C                   Z-ADD     RECNO         PAGE#
     C                   GOTO      ENDSIZ
     C                   END
     C                   GOTO      NXTSIZ
     C     ENDSIZ        TAG
     C     PAGE#         IFLE      0
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   ENDSR
     C******************                                                  QPK220
     C* OUTPUT ORDER   *                                                  QPK220
     C******************                                                  QPK220
     C     PUTORD        BEGSR
      ** GET ORDER NUMBER
     C                   Z-ADD     01            VCO               2 0
     C                   Z-ADD     ORDNUM        OHORD#
     C                   Z-ADD     ORDNUM        OIORD#
     C                   Z-ADD     ORDNUM        BRKORD
     C                   MOVEL     'A'           OHSTAT
     C                   MOVEL     'N'           OHIMED
     C                   MOVEL     'N'           OHIOCD
     C                   MOVEL     'P'           OHPPCD
     C                   MOVEL     '*NONE'       OHOLST
     C                   WRITE     RHORDR
     C                   Eval      HSTUSER    = $User()
     C                   Eval      HSTPROGRAM = 'BIR281'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   EXSR      PUTSFL
     C                   ENDSR
     C*************************                                           QPK220
     C* OUTPUT DETAIL RECORDS *                                           QPK220
     C*************************                                           QPK220
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTAL             5 0
     C                   Z-ADD     0             TOTL$             9 2
     C                   Z-ADD     20            OISEQ#
      ** BUILDD IORDR COMMON FIELDS
     C                   MOVEL     'A'           OISTAT
     C                   Z-ADD     01            OICOMP
     C                   MOVEL     *BLANKS       OIITYP
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTPUT
     C     QTYORD        IFLE      0
     C                   GOTO      NXTPUT
     C                   END
     C                   ADD       3             OISEQ#
      ** DO NOT UPDATE HERE IT IS ALLOCATED IN CHECK ROUTINE
     C     LOTKEY        CHAIN(N)  FDLOTRD                            55
     C*                    ADD  QTYORD    LRQTAL
     C*          LRQTOH    SUB  LRQTAL    LRQTAV
     C*                    UPDATRDLOTRD
     C     ALIKEY        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    OISEQ#
     C     ALIKEY        CHAIN     FALITEM                            77
     C   77              DO
     C                   CLEAR                   RALITEM
     C                   Z-ADD     OHORD#        AIORD#
     C                   Z-ADD     OISEQ#        AIOSEQ
     C                   Z-ADD     REQDAT        AISHPD
     C                   ENDDO
     C                   MOVEL     'A'           AISTAT
     C                   MOVEL     LRITEM        AIITEM
     C                   MOVEL     LRSIZE        AISIZE
     C                   Z-ADD     LRSOWD        AISOWD
     C                   MOVEL     LRGLOC        AIGLOC
     C                   Z-ADD     LRCRDY        AICRDY
     C                   Z-ADD     LRCUST        AICUST
     C                   Z-ADD     LRCOMP        AICOMP
     C                   Z-ADD     QTYORD        AIQTOA
     C                   Z-ADD     TDATE         AIDTLA
     C                   Z-ADD     TIMOD         AITIME
     C                   MOVEL     USERID        AIUSER
     C                   MOVEL     LRPRCL        AIPRCL
     C   77              WRITE     RALITEM
     C  N77              UPDATE    RALITEM
     C     MINKEY        CHAIN     FMINVT                             61
      *  Get Sow Date
     C                   Call      'GETGERM'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM      OIRVDT        REQDAT            7 0          CYMD
     C     OISOW         PARM                    SOWDAT            7 0          CYMD

     C                   Eval      OIDTLA = $MDYDate($Date(0))
     C                   Eval      OIUSER = $User()
     C                   Eval      OITIME = $Now()

     C                   MOVEL     LRITEM        OIITEM
     C                   MOVEL     LRSIZE        OISIZE
     C                   MOVEL     IMDES1        OIDES1
     C                   MOVEL     IMDES2        OIDES2
     C                   MOVEL     IMBIN#        OIBIN#
     C                   MOVEL     IMWHSE        OIWHSE
     C                   Z-ADD     0             #OPRC
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     IMMULT        OIMULT
     C                   Z-ADD     IMMUL2        OIMUL2
     C                   MOVEL     'Y'           OILOTC
     C                   MOVEL     'N'           OITXCD
     C                   MOVEL     'N'           OITXST
     C                   MOVEL     'N'           OITXCT
     C                   MOVEL     'N'           OITXLC
wjb  C                   MOVEL     IMTXBL        OITXCD
wjb  C                   MOVEL     IMTCD1        OITXST
wjb  C                   MOVEL     IMTCD2        OITXCT
wjb  C                   MOVEL     IMTCD3        OITXLC
     C                   MOVEL     'N'           OIOVER
     C                   MOVEL     IMBPUM        OIBPUM
     C                   MOVEL     IMBPUM        OIUUOM
     C                   MOVEL     IMBPUM        OISUOM
     C                   MOVEL     IMBPUM        OIBLUM
     C                   Z-ADD     IMUCST        OIUCST
     C                   Z-ADD     IMUWGT        OIUWGT
     C                   Z-ADD     QTYORD        OIQORD
     C                   Z-ADD     QTYORD        #OQTY             8 1
     C                   Z-ADD     QTYORD        OIQTAL
     C                   MOVEL     IMLOOK        OIITMA
     C                   MOVEL     IMPCL1        OIPRCL
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIUUOM
     C                   PARM                    #OQTY
     C                   PARM                    PRICD             1
     C                   PARM                    #OPRC             9 4
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC            4 2
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    IMORDD
     C                   CALL      '$ITEMPRICE'
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM      '5'           PRICD
     C                   PARM                    #OPRC             9 4
     C                   Z-ADD     #OPRC         OIUPRI
     C     QTYORD        MULT      OIUPRI        OIEXT$
     C                   Z-ADD     IMROYL        OIROY
     C                   ADD       QTYORD        TOTAL
WJB  C*                  ADD       OIEXT$        TOTL$
     C                   MOVEL     OIITEM        ITEM              7
      ** Add Logic For Partial Tray Repricing and a comment Line
      /FREE
        If LRCUST <> 999997;
          OIITYP = ' ';
          TOTL$ += OIEXT$;
          Write RIORDR;
         Else;
       // Create Partial Line;
          OIITYP = ' ';
          #PartialPCT = PARTPCT/100;
          If #PartialPCT = *Zero;
            #PartialPCT = 1;
          EndIf;
          OIOVER = 'Y';
          OIUPRI *= (#PartialPCT);
          OIEXT$ = OIUPRI;
          TOTL$ += OIEXT$;
          Write RIORDR;
          OIPCTF = PARTPCT;
          Write RIORDRPART;
       // Create Comment Line
          OISEQ# += 1;
          OIITYP = 'C';
          OIQORD = *Zero;
          OIQSHP = *Zero;
          OIUPRI = *Zero;
          OIEXT$ = *Zero;
          #Saleable = $Saleable(OISIZE);
          #Cells    = #Saleable*(#PartialPCT);
          #ofCells  = #Saleable;
          #Discount = (1-(#Cells/#Saleable))*100;
          OIDES1 = 'Adj: (' + %Trim(%EditC(#Cells:'Z')) +
                   ' of '+ %Trim(%EditC(#ofCells:'Z')) + ') Disc: ' +
                   %Trim(%EditW(#Discount:'   .0%'));
          Write RIORDR;
          OISEQ# -= 1;
        ENDIF;

      /End-Free
      ** PUT IORDR HERE
WJB  C*                  WRITE     RIORDR
     C     IMROYL        IFGT      0.0000
     C     IMVEND        ANDGT     0
     C     OISEQ#        ANDLE     990
     C                   EXSR      ROYAL
     C                   END
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   ENDSR
      **************************
      * CALCULATE ROYALTIES    *
      **************************
      *
     C     ROYAL         BEGSR
?    C                   Z-ADD     OIQORD        QTYOR
?    C                   Z-ADD     OIQSHP        QTYSHP
?    C                   CALL      'GETROY'
?    C                   PARM                    OICOMP
?    C                   PARM                    OIORD#
?    C                   PARM                    OISEQ#
?    C                   PARM                    IMITEM
?    C                   PARM                    IMSIZE
?    C                   PARM                    IMWHSE
?    C                   PARM                    QTYOR            11 1
?    C                   PARM                    QTYSHP           11 1
?    C                   PARM                    DESCR            60
?    C                   PARM                    ORUPRI            9 4
?    C                   PARM                    OREXT$            9 2
     C     OREXT$        IFGT      0.00
     C                   MOVEL     DESCR         ROYDES           30
     C                   ADD       OREXT$        TOTL$
     C                   END
      ****
     C     ENDROY        ENDSR
     C**
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
