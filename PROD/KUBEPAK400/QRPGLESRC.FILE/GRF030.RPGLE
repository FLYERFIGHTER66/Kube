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
     F**PROGRAM NAME-------- BRK280
     F**COMPANY------------- EFD ENTERPRISES, INC.
     F**SYSTEM-------------- THE GREENHOUSE MANAGEMENT SYSTEM
     F**PROGRAMMER---------- EFD
     F**APPLICATION--------- SELECT CUSTOMER AND CREATE ORDER
     F**DESCRIPTION--------- THIS PROGRAM CREATES ORDER FROM BROKER INPUT
     F**            PLUG AVAILABILITY SCREEN.
     F**
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
      *  2/20/99 GD USE PHONE # FROM CUST FILE IF NOT ENTERED ON SCRNB
      *  3/06/99 GD MOVE A INTO OHSTAT
     F*
     F**
     F*
     F*
     FGRF030FM  CF   E             WORKSTN
     F                                     SFILE(ORDSFL:RECNO)
     FFIORDRGRIFUF A E           K DISK    prefix(GRF_)
     F                                     RENAME(RIORDR:GRIFFSPEC)
     FFMCUST    UF A E           K DISK
     FFARHST    O  A E           K DISK
     FFOECTL    UF   E           K DISK
     FFARCTL    UF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFBROKER   IF   E           K DISK
     FFMCDEF    IF   E           K DISK
     FFDLOTRDC  UF A E           K DISK
     FFALITEM   UF A E           K DISK
     FFDLOTDSI  IF   E           K DISK
     F                                     RENAME(RDLOTRD:LOTRD)
     FFHORDR    O  A E           K DISK
     FFIORDR    O  A E           K DISK
     FQPRINT    O    F  132        PRINTER OFLIND(*INOF)
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
     D  OIORD#                 9     14S 0
     D  ind03                133    133
     C**************************
     C** SET UP BROKER AND BILL TO
     C**************************
     C                   EXSR      GETBRK
     C   99              SETON                                        LR
     C   99              GOTO      END
     C*                                                                   QPK221
     C**************                                                      QPK220
     C* MAIN ROUTINE *                                                    QPK220
     C***************                                                     QPK220
     C     RSTART        TAG
     C                   SETOFF                                       U8U1
     C                   Z-ADD     0             CMCUST
     C                   Z-ADD     01            VCO               2 0
     C     NXTA          TAG
     C                   WRITE     SCRNA                                                       QPK22
     C                   SETOFF                                       102030
     C                   SETOFF                                       99
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              DO
     C                   SETON                                        LR
     C                   Eval      ind03 = 'X'
     C                   GOTO      END
     C                   ENDDO
     C** ***                                                              QPK220
     C***  VALIDATE DATE                                                  QPK220
     C                   MOVE      SHPDAT        ##MDY                                         QPK22
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'                                                         QPK22
     C                   SETON                                        9910                     QPK22
     C                   GOTO      NXTA
     C                   END
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
     C     SIZE          IFNE      '512'
     C     SIZE          ANDNE     '288'
     C     SIZE          ANDNE     '162'
     C     SIZE          ANDNE     '105'
     C     SIZE          ANDNE     '   '
     C                   SETON                                        9920
     C                   GOTO      NXTA
     C                   END
     C** CHECK ALPHA SEARCH
     C*    ALPHA         IFLT      'A  '
     C*                  SETON                                        3099
     C*                  GOTO      NXTA
     C*                  END
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
     C                   EXFMT     ORDCTL                                                      QPK22
      ** CHECK F KEYS
     C   KF              GOTO      RSTFMT
     C   KC
     COR KG              DO
     C                   Eval      ind03 = 'X'
     C                   GOTO      END
     C                   ENDdo
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C  N98              SETON                                        98
      ** IF NO ERROR AND NOT F4 REDISPLAY SCREEN
     C  NKB              GOTO      NXTFMT
      ** GET SHIP TO CUSTOMER
     C                   MOVE      *BLANKS       CMLOOK
     C     NXTC          TAG
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
      ** CHECK IF CUST ENTERED
     C     CUSTNO        IFGT      0
     C                   EXSR      BLDCUS
     C   10              GOTO      NXTC
     C  N10              GOTO      NXTB1
     C                   END
     C     CMLOOK        IFGT      *BLANKS
     C                   EXSR      GETCUS
     C   10              GOTO      NXTC
     C  N10              GOTO      NXTB1
     C                   END
      ** IF HERE NOTHING ENTERED
     C***                  GOTO NXTFMT
     C     NXTB1         TAG
     C     CMCUST        IFLE      0
     C                   SETON                                        U1
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETOFF                                       U1
     C                   SETON                                        98
     C                   END
      ** GET HEADER INFO
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C   KA              DO
     C                   EXSR      GETCUS
     C     CMCUST        IFLE      0
     C                   SETON                                        U1
     C                   SETOFF                                       98
     C                   ELSE
     C                   SETOFF                                       U1
     C                   SETON                                        98
     C                   END
     C                   ENDDO
     C   KE              EXSR      GETSHV
     C   KC              GOTO      END
     C                   EXSR      CHKSHP
     C   99              GOTO      NXTB
     C  NKB              GOTO      NXTB
WJB   *   CREATE THE ORDER HERE
     C   KB              EXSR      OUTCUS
     C   KB              EXSR      PUTORD
     C*                                                                   QPK220
     C     END           TAG                                                                   QPK22
     C                   SETOFF                                       U1
     C                   SETON                                        LR                       QPK22
     C*                  Eval      ind03 = 'X'
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
     C     REQDAT        SETLL     FIORDRGRIF
     C     NXTBLD        TAG
     C     REQDAT        READE(N)  FIORDRGRIF                             90
     C   90              GOTO      ENDBLD
     C                   If        GRF_OISIZE <> SIZE
     C                             and SIZE <> ' '
     C                   Goto      NXTBLD
     C                   EndIf
     C     GRF_OIQORD    IFLE      0
     C                   GOTO      NXTBLD
     C                   Else
     C                   Eval      LRITEM = GRF_OIITEM
     C                   Eval      LRSIZE = GRF_OISIZE
     C                   Eval      LRSOWD = GRF_OISOW
     C                   Eval      LRCRDY = GRF_OIRVDT
     C                   Eval      LRCUST = GRF_OICUST
     C                   Eval      QTYAV  = GRF_OIQORD
     C                   Clear                   RMINVT
     C     MINKEY        CHAIN     FMINVT
     C                   EndIf
     C                   If            ALPHA <> *Blanks
     C                             and ALPHA <> 'A'
     C                             and %subst(GRF_OIITMA:1:%Len(%Trim(ALPHA)))
     C                              <> %Trim(ALPHA)
     C                   Goto      NXTBLD
     C                   EndIf
     C                   Eval      QTYORD = *Zero
     C                   Eval      TOT_AVAIL = QTYAV
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C     PAGE#         IFLE      0
     C     IMSIZE        IFEQ      SIZE
     C     IMLOOK        ANDGE     ALPHA
     C                   Z-ADD     RECNO         PAGE#
     C                   END
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
     C     QTYORD        IFLE      0
     C                   GOTO      NXTCHK
     C                   END
     C                   SETOFF                                       10
     C*    LOTKEY        CHAIN(N)  FDLOTRD                            55
     C*    LRQTOH        SUB       LRQTAL        AVAIL            11 1
     C*    AVAIL         IFLT      QTYORD
     C                   SETOFF                                       101199
     C                   Eval      QTYAV = TOT_AVAIL - QTYORD
     C                   If        QTYORD > TOT_AVAIL
     C                   SETON                                        101199
     C                   Z-ADD     TOT_AVAIL     QTYAV
     C                   END
     C                   UPDATE    ORDSFL
     C                   ADD       QTYORD        TOTQTY
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C  N99TOTQTY        IFLE      0
     C                   SETON                                        9971
     C                   END
     C                   ENDSR
     C******************                                                  QPK220
     C* OUTPUT ORDER   *                                                  QPK220
     C******************                                                  QPK220
     C     PUTORD        BEGSR
      ** GET ORDER NUMBER
     C                   Z-ADD     01            VCO               2 0
     C                   Z-ADD     0             WCO               2 0
     C     WCO           CHAIN     FOECTL                             90
     C                   MOVE      OCNORD        ORDNUM            6 0
     C     OCNORD        ADD       1             OCNORD
     C                   UPDATE    ROECTL                                       UPDATE MCOMP
     C                   Z-ADD     ORDNUM        OHORD#
     C                   Z-ADD     ORDNUM        OIORD#
     C                   MOVEL     'A'           OHSTAT
     C                   MOVEL     'N'           OHIMED
     C                   MOVEL     'N'           OHIOCD
     C                   MOVEL     'P'           OHPPCD
     C                   MOVEL     '*NONE'       OHOLST
     C                   MOVEL     '000001'      OHPLST
     C                   Z-ADD     CMCUST        OHCUST
     C                   Z-ADD     CMCUST        OHSACU
     C                   Z-ADD     CMCUST        OICUST
     C                   MOVEL     CMNAME        OHNAME
     C                   MOVEL     CMADD2        OHSHP2
     C                   MOVEL     CMADD3        OHSHP3
     C                   MOVEL     CMADD4        OHSHP4
     C                   MOVEL     CMCITY        OHSHCT
     C                   MOVEL     CMSTST        OHSHST
     C                   MOVEL     CMZIP         OHSHZP
     C                   MOVEL     SHPVIA        OHSHPC
     C     SHPVIA        CHAIN     FMSVIA                             50
     C**                   MOVELSVDESC    OHSVIA
     C                   MOVE      CMSLSM        OHSLM1
     C                   Z-ADD     CMCOMM        OHSCM1
     C                   MOVE      CMSLSM        OISLM1
     C                   Z-ADD     CMCOMM        OICOM1
     C                   MOVEL     CMCTYP        OHTYPE
     C                   MOVEL     CMSHIN        OHSHIN
     C                   MOVEL     CMSPIN        OHSPIN
     C                   MOVEL     CMLOOK        OHALPH
     C                   MOVEL     CMLOOK        OIALPH
     C                   MOVEL     CMUPSZ        OHUPSZ
     C                   WRITE     RHORDR
     C                   EXCEPT    HEAD
     C                   EXSR      PUTSFL
     C                   EXCEPT    TOTL
     C                   WRITE     SCRNBO
     C                   READ      SCRNBO                                 90
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
     C                   Z-ADD     OHCUST        OICUST
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVEL     'N'           OIFRQD
     C                   MOVEL     'N'           OIPPDC
     C                   MOVEL     'N'           OISTA
     C                   MOVEL     OHCOFL        OICOFL
     C     COMM1         IFGT      *BLANKS
     C                   MOVEL     COMM1         OIDES1
     C                   MOVEL     'C'           OIITYP
     C                   WRITE     RIORDR
     C                   ADD       2             OISEQ#
     C                   END
     C     COMM2         IFGT      *BLANKS
     C                   MOVEL     COMM2         OIDES1
     C                   MOVEL     'C'           OIITYP
     C                   WRITE     RIORDR
     C                   ADD       2             OISEQ#
     C                   END
     C     COMM3         IFGT      *BLANKS
     C                   MOVEL     COMM3         OIDES1
     C                   MOVEL     'C'           OIITYP
     C                   WRITE     RIORDR
     C                   ADD       2             OISEQ#
     C                   END
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
     C*    LOTKEY        CHAIN     FDLOTRD                            55
     C*                  ADD       QTYORD        LRQTAL
     C*    LRQTOH        SUB       LRQTAL        LRQTAV
     C*                  UPDATE    RDLOTRD
     C     ALIKEY        KLIST
     C                   KFLD                    OHORD#
     C                   KFLD                    OISEQ#
     C*    ALIKEY        CHAIN     FALITEM                            77
     C*  77              DO
     C*                  CLEAR                   RALITEM
     C*                  Z-ADD     OHORD#        AIORD#
     C*                  Z-ADD     OISEQ#        AIOSEQ
     C*                  Z-ADD     REQDAT        AISHPD
     C*                  ENDDO
     C*                  MOVEL     'A'           AISTAT
     C*                  MOVEL     LRITEM        AIITEM
     C*                  MOVEL     LRSIZE        AISIZE
     C*                  Z-ADD     LRSOWD        AISOWD
     C*                  MOVEL     LRGLOC        AIGLOC
     C*                  Z-ADD     LRCRDY        AICRDY
     C*                  Z-ADD     LRCUST        AICUST
     C*                  Z-ADD     LRCOMP        AICOMP
     C*                  Z-ADD     QTYORD        AIQTOA
     C*                  Z-ADD     TDATE         AIDTLA
     C*                  Z-ADD     TIMOD         AITIME
     C*                  MOVEL     USERID        AIUSER
     C*                  MOVEL     LRPRCL        AIPRCL
     C*  77              WRITE     RALITEM
     C* N77              UPDATE    RALITEM
     C     MINKEY        KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C     MINKEY        CHAIN     FMINVT                             61
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
     C                   Z-ADD     #OPRC         OIUPRI
     C     QTYORD        MULT      OIUPRI        OIEXT$
     C                   Z-ADD     IMROYL        OIROY
     C                   ADD       QTYORD        TOTAL
     C                   ADD       OIEXT$        TOTL$
     C                   MOVEL     OIITEM        ITEM              7
     C                   EXCEPT    DETL
      ** PUT IORDR HERE
     C                   WRITE     RIORDR
     C                   ExSr      ChgAlloc
     C     IMROYL        IFGT      0.0000
     C     IMVEND        ANDGT     0
     C     OISEQ#        ANDLE     990
     C                   EXSR      ROYAL
     C                   END
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   ENDSR
      *?  ...........................................................
      *?  :      ChgAlloc - Change Inventory Allocations            :
      *?  :.........................................................:
     C     ChgAlloc      BEGSR

      *?  FIORDRGRIF - Decrease Quantity Ordered
    ?C     GRIFFORD      Chain     FIORDRGRIF
    ?C     GRIFFORD      KLIST
    ?C                   KFLD                    GRF_OIRVDT
    ?C                   KFLD                    GRF_OISTAT
    ?C                   KFLD                    GRF_OISIZE
    ?C                   KFLD                    GRF_OIITMA
    ?C                   KFLD                    GRF_OIITEM
    ?C                   KFLD                    GRF_OIORD#
    ?C                   KFLD                    GRF_OISEQ#
     C                   Eval      GRF_OIQORD = GRF_OIQORD - OIQORD
    ?C                   Update    GRIFFSPEC
      *?  FDLOTRD    - Decrease On Hand and Aloc For Griffin Spec Order (If Zero, Delete Record)
    ?C     GRIFFLOTRD    Chain     FDLOTRDC
     C                   If        %Found(FDLOTRDC)
    ?C     GRIFFLOTRD    KLIST
    ?C                   KFLD                    GRF_OICUST
    ?C                   KFLD                    GRF_OIITEM
    ?C                   KFLD                    GRF_OISIZE
    ?C                   KFLD                    GRF_OIRVDT
     C                   Eval      LRQTOH     = GRF_OIQORD
     C                   Eval      LRQTAL     = GRF_OIQORD
    ?C                   Update    RDLOTRD
     C                   Eval      LRQTOH     = *Zero
     C                   Eval      LRQTAL     = *Zero
    ?C     NEWLOTRD      Chain     FDLOTRDC
    ?C     NEWLOTRD      KLIST
    ?C                   KFLD                    OICUST
    ?C                   KFLD                    LRITEM
    ?C                   KFLD                    LRSIZE
    ?C                   KFLD                    LRCRDY
     C                   Eval      LRCUST     = OICUST
     C                   Eval      LRQTOH     = LRQTOH + OIQORD
     C                   Eval      LRQTAL     = LRQTAL + OIQORD
     C                   If        %Found(FDLOTRDC)
    ?C                   Update    RDLOTRD
     C                   Else
    ?C                   Write     RDLOTRD
     C                   EndIf
     C                   EndIf
      *?  FALITEM    - Decrease On Hand and Aloc (If Zero, Delete Record)
    ?C     GRIFFALLOC    Chain     FALITEM
    ?C     GRIFFALLOC    KLIST
    ?C                   KFLD                    GRF_OIORD#
    ?C                   KFLD                    GRF_OISEQ#
     C                   If        %Found(FALITEM)
     C                   Eval      AIQTOA     = GRF_OIQORD
    ?C                   Update    RALITEM
     C                   Eval      AIQTOA     = *Zero
    ?C     NEWALLOC      Chain     FALITEM
    ?C     NEWALLOC      KLIST
    ?C                   KFLD                    OIORD#
    ?C                   KFLD                    OISEQ#
     C                   Eval      AIORD#     = OIORD#
     C                   Eval      AIOSEQ     = OISEQ#
     C                   Eval      AICUST     = OICUST
     C                   Eval      AIQTOA     = AIQTOA + OIQORD
     C                   If        %Found(FALITEM)
    ?C                   Update    RALITEM
     C                   Else
    ?C                   Write     RALITEM
     C                   EndIf
     C                   EndIf
     C                   ENDSR

     C**************                                                      QPK220
     C* GET SHIP VIA                                                      QPK220
     C**************                                                      QPK220
     C     GETSHV        BEGSR
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC
     C                   MOVEL     SVCODE        SHPVIA
     C     SVCODE        CHAIN     FMSVIA                             50
     C   50              MOVE      *BLANKS       SVDESC
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
?    C     OIORD#        PARM      OIORD#        ORDER             6 0
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
     C                   EXCEPT    ROYL
     C                   ADD       OREXT$        TOTL$
     C                   END
      ****
     C     ENDROY        ENDSR
      *
     C**************                                                      QPK220
     C* GET BROKER                                                        QPK220
     C**************                                                      QPK220
     C     GETBRK        BEGSR
     C*    2386          CHAIN     FBROKER                            99
     C*  99              GOTO      ENDBRK
     C     002386        CHAIN(N)  FMCUST                             99
     C   99              GOTO      ENDBRK
     C*                  Z-ADD     CMCUST        LDABIL
     C                   Z-ADD     CMCUST        OHBLCU
     C                   Z-ADD     CMCUST        OHARCU
     C                   Z-ADD     01            OHCOMP
     C                   Z-ADD     TDATE         OHDTOR
     C                   Z-ADD     TDATE         OHDTCN
     C                   MOVEL     CMNAME        BRKNAM
     C                   MOVEL     CMNAME        OHSLD1
     C                   MOVEL     CMADD2        OHSLD2
     C                   MOVEL     CMADD3        OHSLD3
     C                   MOVEL     CMADD4        OHSLD4
     C                   MOVEL     CMCITY        OHSLCT
     C                   MOVEL     CMSTST        OHSLST
     C                   MOVEL     CMZIP         OHSLZP
     C                   MOVEL     'A'           OHSTAT
     C                   MOVEL     CMTMCD        OHTMCD
     C                   MOVEL     OHTMCD        TMCD              2
     C     TMCD          CHAIN     FMTERM                             97
     C                   Z-ADD     TCTRAT        OHTRAT
     C                   Z-ADD     TCTDAY        OHTDAY
     C                   Z-ADD     TCTDAS        OHTDAS
     C                   MOVEL     TCDESC        OHTERM
     C                   Z-ADD     CMTRDC        OHTRDC
     C                   Z-ADD     CMTRDC        OITRDC
     C                   Z-ADD     CMPRCD        OHPRCD
     C                   MOVEL     CMBOOK        OHBOCD
     C                   MOVEL     CMTXST        OHTXST
     C                   MOVEL     CMTXJU        OHTXJU
     C                   MOVE      *BLANKS       OHSTA
     C                   MOVE      *BLANKS       OISTA
     C                   MOVEL     CMCTYP        OHTYPE
     C                   Z-ADD     TDATE         OHTDAT
     C                   Z-ADD     TDATE         OHDTLA
     C                   Z-ADD     TIMOD         OHTIME
     C                   MOVEL     USERID        OHUSER
     C                   Z-ADD     TDATE         OHTDAT
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   MOVEL     'N'           OHFRTX
     C                   MOVEL     'N'           OHSPTX
     C                   MOVEL     CMTXID        OHTXID
     C                   MOVEL     'Y'           OHLOTC
     C                   SETOFF                                       99
     C                   MOVEL     CMPORQ        PORQ              1
     C                   MOVEL     CMCTCD        OICTCD
     C     ENDBRK        ENDSR
     C**
     C**************                                                      QPK220
     C* BUILD CUSTOMER                                                    QPK220
     C**************                                                      QPK220
     C     BLDCUS        BEGSR
     C                   SETOFF                                       10
     C     CUSTNO        CHAIN(N)  FMCUST                             99
     C   99              SETON                                        10  U1
     C  N99              SETON                                        98
     C  N99              Z-ADD     CMCUST        OHCUST
     C  N99              Z-ADD     CMCUST        OHSACU
     C  N99              Z-ADD     CMCUST        OICUST
     C  N99              MOVEL     CMNAME        OHNAME
     C  N99              MOVEL     CMADD2        OHSHP2
     C  N99              MOVEL     CMADD3        OHSHP3
     C  N99              MOVEL     CMADD4        OHSHP4
     C  N99              MOVEL     CMCITY        OHSHCT
     C  N99              MOVEL     CMSTST        OHSHST
     C  N99              MOVEL     CMZIP         OHSHZP
     C**N99                MOVELCMSVCD    OHSVIA
     C  N99              MOVEL     CMSVCD        SHPVIA
     C  N99SHPVIA        CHAIN     FMSVIA                             50
     C   50
     CANN99              MOVE      *BLANKS       SVDESC
     C                   MOVE      CMSLSM        OHSLM1
     C  N99              Z-ADD     CMCOMM        OHSCM1
     C                   MOVE      CMSLSM        OISLM1
     C  N99              Z-ADD     CMCOMM        OICOM1
     C                   MOVEL     CMCTYP        OHTYPE
     C  N99              MOVEL     CMSHIN        OHSHIN
     C  N99              MOVEL     CMSPIN        OHSPIN
     C  N99              MOVEL     CMLOOK        OHALPH
     C  N99              MOVEL     CMLOOK        OIALPH
     C  N99              MOVEL     CMUPSZ        OHUPSZ
     C  N99              MOVE      CMPHON        PHON3
     C  N99              MOVEL     CMPHON        PHONE1
     C  N99              MOVEL     PHONE1        PHON1
     C  N99              MOVE      PHONE1        PHON2
     C   99              SETOFF                                       98
     C   99              Z-ADD     0             OHCUST
     C   99              Z-ADD     0             OICUST
     C   99              MOVEL     *BLANKS       OHNAME
     C   99              MOVEL     *BLANKS       OHSHP2
     C   99              MOVEL     *BLANKS       OHSHP3
     C   99              MOVEL     *BLANKS       OHSHP4
     C   99              MOVEL     *BLANKS       OHSHCT
     C   99              MOVEL     *BLANKS       OHSHST
     C   99              MOVEL     *BLANKS       OHSHZP
     C** 99                MOVEL*BLANKS   OHSVIA
     C   99              MOVEL     *BLANKS       SHPVIA
     C   99              SETON                                        20
     C                   ENDSR
     C**
     C**************                                                      QPK220
     C* GET CUSTOMER                                                      QPK220
     C**************                                                      QPK220
     C     GETCUS        BEGSR
     C                   CALL      'CSTALOOK'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     CMCUST        CUSTNO
     C     CUSTNO        IFEQ      0
     C                   SETOFF                                       10
     C                   GOTO      ENDCUS
     C                   ENDIF
     C                   EXSR      BLDCUS
     C     ENDCUS        ENDSR
     C**************                                                      QPK220
     C* CHKSHP     *                                                      QPK220
     C**************                                                      QPK220
     C     CHKSHP        BEGSR
     C                   SETOFF                                       991015
     C                   SETOFF                                       202122
     C                   SETOFF                                       232430
     C                   SETOFF                                       405051
     C  N98OHNAME        IFEQ      *BLANKS
     C                   SETON                                        20  99
     C                   END
     C  N98OHSHP2        IFEQ      *BLANKS
     C                   SETON                                        21  99
     C                   END
     C  N98OHSHCT        IFEQ      *BLANKS
     C                   SETON                                        22  99
     C                   END
     C  N98OHSHST        IFEQ      *BLANKS
     C                   SETON                                        23  99
     C                   END
     C  N98OHSHZP        IFLE      *BLANKS
     C                   SETON                                        24  99
     C                   END
     C  N98PHON1         IFLE      '000'
     C                   SETON                                        30  99
     C                   END
     C  N98PHON2         IFLE      '000'
     C                   SETON                                        30  99
     C                   END
     C  N98PHON3         IFLE      '0000'
     C                   SETON                                        30  99
     C                   END
     C  N99
     CANN98              MOVEL     PHON1         PHONE1            6 0
     C  N99
     CANN98              MOVE      PHON2         PHONE1
     C  N99
     CANN98              MOVEL     PHONE1        TELNO            10 0
     C  N99
     CANN98              MOVE      PHON3         TELNO
     ****  VALIDATE DATE
     C     SHPVIA        IFEQ      *BLANKS
     C                   SETON                                        50  99
     C                   MOVE      *BLANKS       OHSHPC
     C                   END
     C     SHPVIA        IFNE      OHSHPC
     C     SHPVIA        CHAIN     FMSVIA                             50
     C   50              MOVE      *BLANKS       SVDESC
     C   50              SETON                                        99
     C  N50              MOVE      SHPVIA        OHSHPC            2
     C   50              MOVE      *BLANKS       OHSHPC
     C**N50                MOVELSVDESC    OHSVIA
     C                   END
      ** DO NOT CHECK P.O.# PER BILL 2/15/99
      ** Now do CHECK P.O.# PER BILL BEHR 1/13/06
     C*          PORQ      IFEQ 'Y'
     C*          BRKPO     ANDLE*BLANKS
     C*                    SETON                     5199
     C*                    ENDIF
     C     BRKPO         IFEQ      *BLANKS
     C                   SETON                                        5199
     C                   ENDIF
     C                   ENDSR
     C********************                                                QPK220
     C* OUTPUT CUSTOMER **                                                QPK220
     C********************                                                QPK220
     C     OUTCUS        BEGSR
      ** IF U1 AND NOT 99 ADD CUSTOMER
     C   U1
     CANN99              DO
     C     BRCUST        CHAIN(N)  FMCUST                             99
     C                   Z-ADD     *ZEROS        COKEY             2 0
     C     COKEY         CHAIN     FARCTL                             97
     C                   Z-ADD     ACNCUS        CMCUST                         GET NEXT CUST#
     C                   Z-ADD     ACNCUS        CMSACU                                     T#
     C                   ADD       1             ACNCUS            6 0          UPDATE CUST#
     C                   UPDATE    RARCTL
     C     VCO           CHAIN(N)  FMCDEF                             98
     C                   MOVEL     CDSLSM        CMSLSM                         SALESMAN #
     C                   MOVE      CDTERR        CMTERR                         TERRITORY
     C                   Z-ADD     CDCOMM        CMCOMM                         COMMISSION %
     C                   Z-ADD     CDCRL$        CMCRL$                         CREDIT LIMIT
     C                   MOVEL     CDTMCD        CMTMCD                         TERMS CODE
     C                   MOVE      CDCODF        CMCODF                         COD FLAG
     C                   MOVE      CDAPLC        CMAPLC                         APPLY LATE CHRG
     C                   MOVE      CDSMCD        CMSMCD                         SEND STATEMENT
     C                   MOVE      CDCOPY        CMCOPY                         STATE/INV COPY
     C                   MOVE      CDARCD        CMARCD                         A/R CODE
     C                   Z-ADD     CDPRCD        CMPRCD                         PRICE CODE
     C                   MOVE      CDCTCD        CMCTCD                         CONTRACT
     C                   MOVE      CDQDIS        CMQDIS                         QTY DISC
     C                   Z-ADD     CDTRDC        CMTRDC                         TRADE DISC%
     C                   Z-ADD     1             CMSMCD                         STMT CYCLE
     C                   MOVE      CDBOOK        CMBOOK                         B/O
     C                   MOVE      CDTXST        CMTXST                         TAX EXEMPT
     C                   MOVE      CDSHIN        CMSHIN                         SHIPPING INSTR
     C                   MOVE      CDFRTZ        CMUPSZ                         UPS ZONE
     C                   MOVE      CDPDSL        CMDSHF                         POST SLS HIS
     C                   MOVE      CDSVIA        CMSVCD
     C                   MOVE      'N'           CMJOBR
     C                   MOVE      'N'           CMPORQ
     C                   MOVE      'Y'           CMACK
     C                   MOVEL     OHNAME        CMNAME
     C                   MOVEL     OHSHP2        CMADD2
     C                   MOVEL     OHSHP3        CMADD3
     C                   MOVEL     OHSHP4        CMADD4
     C                   MOVEL     OHSHCT        CMCITY
     C                   MOVEL     OHSHST        CMSTST
     C                   MOVEL     OHSHZP        CMZIP
     C**                   MOVELOHSVIA    CMSVCD
     C                   MOVEL     CMNAME        CMLOOK
     C                   Z-ADD     TELNO         CMPHON
     C                   MOVEL     CMUPSZ        OHUPSZ
     C                   MOVEL     'NJ'          CMTXJU
     C                   Z-ADD     CMCUST        HSCUST
     C                   MOVEL     'A'           HSSTAT
     C                   MOVEL     'Y'           HSINCL
     C                   WRITE     RMCUST
     C                   WRITE     RARHST
     C                   ENDDO
     C   LR
     CANNLR              UPDATE    RMCUST                                       DUMMY UPDATE
     C                   MOVEL     BRKPO         OHPONO
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      *
     OQPRINT    E            HEAD           1 03
     O                                            6 'GRF030'
     O                                           35 'GRIFFIN SPEC'
     O                       PAGE          Z     66
     O                                           62 'PAGE:'
     O          E            HEAD           2
     O                       TIMOD                8 '  :  :  '
     O                       TDATE         Y     66
     O          E            HEAD           2
     O                                           10 'USER I.D.:'
     O                       USERID              19
     O                                           32 'BROKER NAME:'
     O                       BRKNAM              63
     O                                           70 'ORDER:'
     O                       ORDNUM        Z     77
     O          E            HEAD           2
     O                                           20 'REQUESTED SHIP DATE:'
     O                       SHPDAT        Y     29
     O                                           50 'CUSTOMER P.O.#:'
     O                       BRKPO               66
     O          E            HEAD           1
     O                                            8 'SHIP TO:'
     O                       CMCUST        Z     15
     O                     U1                    77 '**** ADDED CUSTOMER ****'
     O          E            HEAD           1
     O                       OHNAME              39
     O          E            HEAD           1
     O                       OHSHP2              39
     O          E            HEAD           1
     O                       OHSHP3              39
     O          E            HEAD           1
     O                       OHSHP4              39
     O          E            HEAD           2
     O                       OHSHCT              27
     O                       OHSHST              30
     O                       OHSHZP              42
     O          E            HEAD           2
     O                                            6 'PHONE:'
     O*                30      PHON1     10
     O*                30                11 '-'
     O*                30      PHON2     14
     O*                30                15 '-'
     O*                30      PHON3     19
     O*               N30      TELNO     19 '   -   -    '
     O                       CMPHON              19 '   -   -    '
     O                                           30 'SHIP VIA:'
     O                       SVCODE              33
     O                       SVDESC              64
     O          E            HEAD           1
     O                                            9 'COMMENTS:'
     O          E            HEAD           1
     O                       COMM1               40
     O          E            HEAD           1
     O                       COMM2               40
     O          E            HEAD           3
     O                       COMM3               40
     O          E            HEAD           2
     O                                           38 'ITEM #'
     O                                           48 'SIZE'
     O                                           21 'DESCRIPTION'
     O                                           58 'QUANTITY'
     O                                           65 'PRICE'
     O                                           77 'TOTAL PRICE'
     O          EF           DETL           1
     O                       OIQORD        1     55
     O                       ITEM                44
     O                       OISIZE              48
     O                       IMDES1              35
     O                       OIUPRI        4     65
     O                       OIEXT$        K     77
     O          EF           ROYL           1
     O                       ROYDES              35
     O                       ORUPRI        4     65
     O                       OREXT$        K     77
     O          E            TOTL        2  1
     O                                           43 'TOTALS =========>'
     O                       TOTAL         1     55
     O                       TOTL$         J     77
