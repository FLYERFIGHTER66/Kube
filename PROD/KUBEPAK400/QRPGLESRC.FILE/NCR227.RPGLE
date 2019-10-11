    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- SCR225
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCEL CART PUT DOWN SHEET
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  4/04/02 EFD DO NOT USE SHIP DATE AS PART OF PUTORD KEY.
      *
     FNCR227FM  CF   E             WORKSTN
     F                                     SFILE(CRTSFL:RECNO)
     F                                     SFILE(TRYSFL:RECN1)
     FFCALEN    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FNCARTDIC  IF   E           K DISK
     F                                     RENAME(RCART:CARTD)                  |By Date, Item, Time
     FNCARTCC   UF   E           K DISK
     FNPUTORD   UF   E           K DISK
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
      *
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
     D  CRMDY                  1      6  0                                      ARC380
     D  CRCYMD                 7     13  0                                      ARC380
     D  CRYEAR                14     17  0                                      ARC380
     D  CRWEEK                18     19  0                                      ARC380
     D  NXMDY                 20     25  0                                      ARC380
     D  NXCYMD                26     32  0                                      ARC380
     D  NXYEAR                33     36  0                                      ARC380
     D  NXWEEK                37     38  0                                      ARC380
     D  LCANCL               133    133                                         ARC380

      *? Field Definitions
     D  CTITEMKey      S                   LIKE(CTITEM)
     D  ShipDate7      S                   LIKE(CTSHDT)
     D  Screen         S              2S 0 Inz(*Zeros)
     D  ItemDesc       S                   Like(IMDES1)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

      *?      ..................................................................
      *?      :  BEGIN PROGRAM                                                 :
      *?      :................................................................:

    ?C                   DoW       not *InLR
    ?C                   Select
     C                   When      SCREEN = 01
     C                   ExSr      EDIT01
     C                   When      SCREEN = 02
     C                   ExSr      EDIT02
     C                   When      SCREEN = 03
     C                   ExSr      EDIT03
    ?C                   Other
     C                   ExSr      LOAD01
     C                   ExSr      SCRN01
    ?C                   EndSL
    ?C                   EndDO
     C


      *?      ..................................................................
      *?      :  SCRN01  Display Screen 01                                     :
      *?      :................................................................:
    ?C     SCRN01        BegSR
     C                   Eval      SCREEN = 01
      ** WRITE SCRNA
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
    ?C                   EndSR


      *?      ..................................................................
      *?      :  SCRN02  Display Screen 02  (Cart Subfile)                     :
      *?      :................................................................:
    ?C     SCRN02        BegSR
     C                   Eval      SCREEN = 02
     C                   Eval      IMDES1 = ItemDesc
     C                   EXFMT     CRTCTL
    ?C                   EndSR


      *?      ..................................................................
      *?      :  SCRN03  Display Screen 03  (Tray Subfile)                     :
      *?      :................................................................:
    ?C     SCRN03        BegSR
     C                   Eval      SCREEN = 03
     C                   EXFMT     TRYCTL
    ?C                   EndSR


      *?      ..................................................................
      *?      :  LOAD01  Load Screen 01                                        :
      *?      :................................................................:
    ?C     LOAD01        BegSR
      ** Make the Date Tommorrow unless it's currently Saturday... then make it Next Monday
     C     TODAY         IFGE      6
     C                   Z-ADD     NXMDY         SHPDAT
     C                   ELSE
     C                   Eval      SHPDAT = $MDYDate($AddDate($Date(0):1))
     C                   END
     C                   Eval      ShipDate7 = $Date7($DateMDY(SHPDAT))
    ?C                   EndSR


      *?      ..................................................................
      *?      :  LOAD02  Load Screen 02                                        :
      *?      :................................................................:
    ?C     LOAD02        BegSR
     C                   SETON                                        80
     C                   WRITE     CRTCTL
     C                   SETOFF                                       805556
     C                   Z-ADD     1             RECNO             5 0
     C                   Z-ADD     0             OCNTL             6 0
     C                   Z-ADD     0             OCART             8 0
     C                   Z-ADD     0             OORD#             6 0
     C                   Z-ADD     0             OSEQ#             6 0
     C                   Z-ADD     0             SSTRAY
     C                   Z-ADD     0             STRAYS
     C                   Eval      Option02 = *Blanks
     C     ItemCart      KList
     C                   KFld                    ShipDate7
     C                   KFld                    SMaster
     C                   KFld                    Item
     C                   KFld                    Size
     C     ItemCart      SETLL     NCARTDIC
     C     NXTBLD        TAG
     C     ItemCart      READE     NCARTDIC                               90
     C   90              GOTO      ENDBLD
     C     CTCART        IFNE      OCART
     C     CTCNTL        ORNE      OCNTL
     C     CTORD#        ORNE      OORD#
     C     CTSEQ#        ORNE      OSEQ#
     C     RECNO         IFNE      1
     C                   WRITE     CRTSFL
     C                   EndIf
     C                   ADD       1             RECNO
     C                   Z-ADD     RECNO         LSTREC            5 0
     C     CTSTAT        IfNE      'D'
     C                   Z-ADD     1             SSTRAY
     C                   Add       1             STRAYS
     C                   Else
     C                   Z-ADD     0             SSTRAY
     C                   Add       1             STRAYSD
     C                   EndIf
     C     SSCART        IFEQ      CTCART
     C     SSCNTL        ANDEQ     CTCNTL
     C                   SetOn                                        56
     C                   Else
     C                   SetOff                                       56
     C                   EndIf
     C                   Eval      SSCART = CTCART
     C                   Eval      SSCNTL = CTCNTL
     C                   Eval      SSDTLA = CTDTLA
     C                   Eval      SSTIME = CTTIME
     C                   Eval      SSORD# = CTORD#
     C                   Eval      SSSEQ# = CTSEQ#
     C                   Eval      SSLOC  = CTLOC
     C                   ELSE
     C     CTSTAT        IfNE      'D'
     C                   Add       1             SSTRAY
     C                   Add       1             STRAYS
     C                   Else
     C                   Add       1             STRAYSD
     C                   EndIf
     C                   EndIf
     C                   Z-ADD     CTCNTL        OCNTL
     C                   Z-ADD     CTCART        OCART
     C                   Z-ADD     CTORD#        OORD#
     C                   Z-ADD     CTSEQ#        OSEQ#
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C     RECNO         IFNE      1
     C                   WRITE     CRTSFL
     C                   EndIf
     C                   SETON                                        55
     C                   ADD       1             RECNO
     C                   WRITE     CRTSFL
     C                   SETOFF                                       55
     C                   Eval      IMDES1 = ItemDesc
     C                   SetOff                                       56
    ?C                   EndSR


      *?      ..................................................................
      *?      :  LOAD03  Load Screen 03                                        :
      *?      :................................................................:
    ?C     LOAD03        BegSR
     C                   SETON                                        80
     C                   WRITE     TRYCTL
     C                   SETOFF                                       8055
     C                   Z-ADD     0             RECN1             5 0
     C                   Z-ADD     SSCNTL        CONTRL            6 0
     C                   Z-ADD     SSCART        CARTNO
     C     CRTKEY        KLIST
     C                   KFLD                    SSCART
     C                   KFLD                    SSCNTL
     C     CRTKEY        SETLL     NCARTCC
     C     NXTTRY        TAG
     C     CRTKEY        READE     NCARTCC                                90
     C   90              GOTO      ENDTRY
     C     CTSTAT        IFEQ      'D'
     C                   Eval      CTLOC = '*DELETED'
     C                   END
WJB  C                   If        %SUBST(CTITEM:12:1) = 'P'
WJB  C                   Eval      CTITEMKey = %SUBST(CTITEM:1:11) + ' '
WJB  C                   Else
WJB  C                   Eval      CTITEMKey = CTITEM
WJB  C                   EndIf
     C                   MOVE      *BLANKS       CODE
     C                   ADD       1             RECN1
     C                   Eval      IMDES1 = ItemDesc
     C                   WRITE     TRYSFL
     C                   Z-ADD     RECN1         LSTRC1            5 0
     C                   GOTO      NXTTRY
     C     ENDTRY        TAG
     C                   SETON                                        55
     C                   MOVEL     MSG(1)        IMDES1
     C                   ADD       1             RECN1
     C                   WRITE     TRYSFL
     C                   SETOFF                                       55
    ?C                   EndSR


      *?      ..................................................................
      *?      :  EDIT01  Edit Check Screen 01                                  :
      *?      :................................................................:
    ?C     EDIT01        BegSR
    ?C                   Select
    ?C                   When      *InKF
     C                   ExSr      LOAD01
     C                   ExSr      SCRN01
    ?C                   When      *InKC or *InKG
     C                   MOVEL     'X'           LCANCL
     C                   Eval      *InLR = *On
    ?C                   Other
      ** CHECK INPUT
     C                   SETOFF                                       101112
     C                   SETOFF                                       202122
     C                   SETOFF                                       2324
     C     SHPDAT        IFLE      0
     C                   SETON                                        1011
     C                   EXSR      SCRN01
     C                   LeaveSR
     C                   END
     C     SHPDAT        CHAIN     FCALEN                             10
     C   10              DO
     C                   SETON                                        11
     C                   EXSR      SCRN01
     C                   LeaveSR
     C                   ENDDO                                                  10  DO
     C                   Z-ADD     CLCYMD        SHPCYM            7 0
     C                   SETOFF                                       55
      * CHECK FOR SEARCH
     C     1             SUBST     ITEM:1        VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     ITEM:2        IMLOOK
     C                   MOVEL     SIZE          IMSIZE
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
     C                   EXSR      SCRN01
     C                   LeaveSR
     C                   ENDIF
      ** CHECK ITEM
     C     ITMKEY        KLIST
WJB  C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     ITMKEY        CHAIN     FMINVT                             13
     C                   Eval      ItemDesc = IMDES1
     C
     C   13              EXSR      SCRN01
     C   13              LeaveSR
    ?C                   EndSL
      *?      Passed all edits... load & display screen 02
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   EndSR


      *?      ..................................................................
      *?      :  EDIT02  Edit Screen 2 (Cart Subfile)                          :
      *?      :................................................................:
    ?C     EDIT02        BegSR
    ?C                   Select
    ?C                   When      *InKF
     C                   ExSr      LOAD01
     C                   ExSr      SCRN01
    ?C                   When      *InKC or *InKG
     C                   MOVEL     'X'           LCANCL
     C                   Eval      *InLR = *On
    ?C                   Other
     C                   ReadC     CRTSFL
     C                   DoW       not %EOF(NCR227FM)
    ?C                   Select
    ?C                   When      Option02 = *Blanks
     C*                  Do        Nothing
    ?C                   When      Option02 = '4'
     C                   Eval      @SSCART    = %char(  SSCART     )
     C                   Eval      @ShipDate7 = %char(  ShipDate7  )
     C                   Eval      @SSCNTL    = %char(  SSCNTL     )
     C                   Call      'NCR225'
     C                   Parm                    @SSCART           8
     C                   Parm                    @ShipDate7        7
     C                   Parm                    @SSCNTL           6
    ?C                   When      Option02 = '5'
     C                   ExSr      LOAD03
     C                   ExSr      SCRN03
    ?C                   When      Option02 = '6'
     C                   Call      'NCR230CL'
     C                   Parm                    SSCART
     C                   Parm                    ShipDate7
     C                   Parm                    SMaster
     C                   Parm                    SSCNTL
    ?C                   EndSL
     C                   Eval      OPTION02 = *Blanks
     C                   Update    CRTSFL
     C                   ReadC     CRTSFL
     C                   EndDo
     C                   ExSr      SCRN02
    ?C                   EndSL
    ?C                   EndSR


      *?      ..................................................................
      *?      :  EDIT03  Edit Screen 03                                        :
      *?      :................................................................:
    ?C     EDIT03        BegSR
    ?C                   Select
    ?C                   When      *InKF
     C                   ExSr      LOAD01
     C                   ExSr      SCRN01
    ?C                   When      *InKC or *InKG
     C                   MOVEL     'X'           LCANCL
     C                   Eval      *InLR = *On
    ?C                   Other
     C                   ExSr      SCRN02
    ?C                   EndSL
    ?C                   EndSR


      *?      ..................................................................
      *?      :  *InzSR  Initialization Subroutine                             :
      *?      :................................................................:
    ?C     *InzSR        BegSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     TDATE         CHAIN     FCALEN                             90
     C                   Z-ADD     CL#Y          TODAY             1 0
     C                   MOVE      *BLANKS       LCANCL
    ?C                   EndSR
** MESSAGE ARRAY
End Of Cart List ******                    1
