    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR100
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- ORDER ENTRY
      **
      ** VOLUME DISCOUNTS LOADED IN V1DIS AND V2DIS
      **
      ** RESERVED IORDR SEQ #
      * 001 - TAG ORDER NUMBER
      ** 10/02/98 ROYALTIES BY LINE
      * 991 - ROYALTY CHARGE.
      * 992 - ROYALTY CHARGE.
      * 993 - ROYALTY CHARGE.
      * 994 - ROYALTY CHARGE.
      * 995 - ROYALTY CHARGE.
      *
      * 997 - PACKING CHARGE
      *
      * 998 - PHYTO CHARGE.
      * 999 - PHYTO CERTIFICATE REQUIRED.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/14/96 EFD USE NEW PRODUCT CLASS FILE
      *  5/22/96 EFD CRIPPLE ORDER LIST CHECK  SEARCH ON VMORLS
      *  6/13/96 GD UNCRIPPLE ORDER LIST CHECK  SEARCH ON VMORLS
      *  6/11/96 EFD ADD "TAG"  TO TAG ORDER HEADER ORDER LIST #.
      *  6/20/96 EFD 99 RETURN TO NXTC IF ERROR ON LINE NUMBER.
      ***7/18/96 GD  CHANGED "SPECIAL CHARGE" MSG TO SAY HANDLING CHRG
      *  7/24/96 GD  CHG PPD/COLL TO FRT TYPE WITH SEARCH ON FFRTYP
      *  7/24/96 GD  ADDED GETNOT SUBR TO DISPLAY CUSTOMER NOTES
      *  8/09/96 EFD ADD GL NUMBER TO SPECIAL CHARGE.
      *  9/03/96 GD  ADD ARHST FILE & DISPLAY C.C. EXP DATE
      *  9/10/96 EFD CHANGE PACKING CHARGES TO SPECIAL CHARGE.
      *  9/16/96 GD  MOVEL *BLANKS INTO OHOPLP ON CHANGE
      * 10/02/96 EFD CHECK FOR LINE 0 OR GT 991 ON INSERT.
      * 10/23/96 EFD ADD ALLOCATION BY SOW WEEK.
      * 11/07/96 EFD FOR PLAINVIEW IF SPEC PRICE Y CARRY PRICE TIL CHGD
      *  1/31/97 EFD ADD LOGIC FOR SPEC ORDERS.
      *  2/11/97 EFD CHANGE FREIGHT AND SPEC CHARGE DESCRIPTIONS (PHIL)
      *  3/05/97 EFD DISPLAY UNIT PRICE NOT EXTENTED PRICE.(PHIL)
      * 10/01/98 EFD SWITCH POSITIONS OF ITEM / SIZE DO NOT CLEAR SIZE.
      * 10/02/98 EFD CALC ROYALTIES BY LINE.
      * 10/17/98 EFD ADD NEW ITEM ALPHA.   LINE 3375
      * 11/12/98 EFD SKIP 1 LINE BETWEEN DETAIL LINES.
      * 12/14/98 EFD IF NOT LOT CONTROL DO NOT CHECK FOR MONDAY DATE
      *  1/02/99 EFD ADD LOGIC FOR B-BACKORDER CODE.
      *  7/23/99 EFD ADD LOGIC Y2K TEMP NOT PACKED DATES
      * 10/22/99 EFD ADD LOGIC FOR NO ROYALTY IF UNIT PRICE = 0.00
      *  3/02/00 EFD Z-ADD TDATE TO IMDTLO
      *  4/17/01 EFD CLEAR INDICATORS.
EFD01 *  5/07/01 EFD CALL GETORD$
      * 11/08/01 EFD ADD 84 TRAY DELETE FILE
      *  3/27/02 EFD ADD LOGIC FOR PICK SLIP REPRINT ON CHANGES
      *  5/16/02 EFD USE CANCEL DATE FOR DATE WANTED.
      * 11/17/02 EFD CHANGE 84 TRAYS TO 105 TRAYS.
EFD02 * 10/30/02 GD CHANGE TO GET Y IN OIPPDC FIELD
      *  9/30/03 EFD DO NOT ALLOW ENTRY OF P-STATUS ITEMS
      *  4/27/04 WJB ADDED LOGIC TO DELETE FUT. ORD. RLS. ITEMS W/ ORDER DELETE
      *  1/17/19 WJB19 Logic changes to adjustment logic
      *
      *  INDICATORS
      *  01 - ADD AN ORDER (ENTIRE ORDER)
      *  02 - CHANGE AN EXISTING ORDER (ENTIRE ORDER)
      *  03 - DELETE AN EXISTING ORDER (ENTIRE ORDER)
      *  04 - REACHED FIRST VOLUME DISCOUNT LEVEL.
      *  05 - REACHED SECOND VOLUME DISCOUNT LEVEL.
      *  06 - TAGS WANTED.
      *  07 - MORE DESCRIPTION AVAILABLE
      *  60 - PASSED IN ORDER NUMBER
      *  98 - DENOTES AN ORDER FOR KUBE-PAK RESOW (CUST 1990)
      *
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   12/10/18  S.Uthaya      Added New Function F8 - ShipTo and
      *                                 F16- Directions for Selected Customer
      * WJB     12/13/18  WJB           Added Comment in FIORDRB2BC File
      * SUD02   06/04/19  S.Uthaya      Change flow for Ship-To Master Logic
      * SUD03   06/04/19  S.Uthaya      Added New F7=ShiptoEdit Function Key
      //--------------------------------------------------------------------
     FBIR100FM  CF   E             WORKSTN
     F                                     SFILE(ORDSFL:RECNO)
     F******                                  RECN1 KSFILE LSTSFL
     F                                     DEVID(WSID)
     FFMCUST    IF   E           K DISK
     FFMINVT    UF   E           K DISK
WJB  FFMINVTVD  IF   E           K DISK    rename(RMINVT:VDMINVT) Prefix(VD)
      *FFLKITM  UF  E           K        DISK
      *FFMVEND  IF  E           K        DISK
     FFMWHSE    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFPHYTO    IF   E           K DISK
     FFHORDR    UF A E           K DISK
     FFHORDISCNTUF A E           K DISK
     FFHORDRCSTMUF A E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    UF A E           K DISK
     FFIORESOW  UF A E           K DISK
WJB  FFIORDRWK  UF   E           K DISK
WJB  FFIORDRPARTO  A E           K DISK
     FFPPO      UF A E           K DISK
?    FFIORDRSA  IF   E           K DISK
     F                                     RENAME(RIORDR:IORDR)
     FFFPERC    IF   E           K DISK
     FFALITEM   UF A E           K DISK
     F*UZONE  IF  E           K        DISK
     FFMORLH    IF   E           K DISK
     FFMTAXF    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFOECTL    UF   E           K DISK
     FFARCTL    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFIADD     IF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMSTAT    IF   E           K DISK
     FFFRTYP    IF   E           K DISK
     FFCUSTCOM  IF   E           K DISK
     FFTAGXR    UF A E           K DISK
     FFORDCHG   UF A E           K DISK
     FFMCUSTC   IF   F  640     6AIDISK    KEYLOC(2)
     FFMCUSTB   IF   F  640     6AIDISK    KEYLOC(2)
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFARHST    IF   E           K DISK
     FFORDOVR   O  A E             DISK
     FFCUTDEL   O  A E             DISK
SUD01FFHORDRSHTLUF A E           K DISK
      ** MESSAGE ARRAY
     D MSG             S             60    DIM(30) CTDATA PERRCD(1)             MESSAGES
WJB   ** JUST ONE ARRAY
WJB  D JUST1A          S             10    DIM(18) CTDATA PERRCD(1)             ACTIONS SCREEN
WJB  D CODE1A          S              1    DIM(18) ALT(JUST1A)
      ** VOLUME DISCOUNT ARRAYS
     D V1QT            S              5  0 DIM(2)                               5 % ARRAY
     D V2QT            S              5  0 DIM(2)                               10 % ARRAY
      ** MINVT ARRAYS
     D IP1             S              9  4 DIM(5)                               PRICE U/M 1
     D IP2             S              9  4 DIM(5)                               PRICE U/M 2
     D IP3             S              9  4 DIM(5)                               PRICE U/M 3
     D IDQ             S             11  1 DIM(5)                               QTY. DISC QTY.
     D IDP             S              4  2 DIM(5)                               QTY. DISC %
     D ISQ             S             11  1 DIM(13)                              SOLD QTY 13 MO
     D ISP             S              9  2 DIM(13)                              SOLD PRICE 13
     D ISC             S              9  2 DIM(13)                              SOLD COST 13 M
     D IGB             S              4  0 DIM(4)                               BEG WKS GERM
     D IGE             S              4  0 DIM(4)                               END WKS GERM
     D IGW             S              2  0 DIM(4)                               # OF WKS GERM
      ** MCUST ARRAYS
     D RT              S              2    DIM(7)                               ROUTE M THR S
     D ST              S              3  0 DIM(7)                               STOP #
      *
     D SHPCFM          C                   CONST('BIR235ICL')
     D PICK            C                   CONST('#PRINTPICK')
     D LINE1           S                   Like(OISEQ#)
     D LINES           S                   Like(OISEQ#)
     D STEP            S                   Like(OISEQ#)
     D SaveSeq#        S                   Like(OISEQ#)
     D SaveOIITEM      S                   Like(OIITEM)
     D SaveOISIZE      S                   Like(OISIZE)
     D SaveOIRVCD      S                   Like(OIRVCD)
     D SaveOIALPH      S                   Like(OIALPH)
     D SaveOIITMA      S                   Like(OIITMA)
     D SaveText        S             13A
     D OrigOIDTRQ      S                   Like(OIDTRQ)
     D OrigOIQORD      S                   Like(OIQORD)
     D Balance         S                   Like(OIQORD)
     D SaveOIDTRQ      S                   Like(OIDTRQ)
     D SaveOIRVDT      S                   Like(OIRVDT)
     D HoldAVAIL       S                   Like(AVAILABLE)
     D NotAvailH       S                   Like(NotAvail)
     D Comment         S                   Like(OIDES1)
     D EarlyDate       S                   Like(ResowDate)
     D Actions         S              9A   Inz('ABCDIJRPN')
     D ScreenA_1st     S               N   Inz(*Off)
     D ScreenA_2nd     S               N   Inz(*Off)
     D ChkMrk1         S               N   Inz(*Off)
     D One             S              6  0 Inz(1)
     D TRUE            S               N   Inz(*On)
     D PARTSEQ#        S                   Like(OISEQ#)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * Job Name
     D  JOBID                244    253                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
SUD01D  RunDate              276    281S 0
  |  D  RunTime              282    287S 0
SUD01D  Pgm                  334    343
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  BROKER                 1      1                                         ARC380
     D  BRKORD                 2      7  0                                      ARC380
     D  PASSED                 8      8
     D  PASORD                 9     14  0
     D  PASLIN                15     17  0
WJB  D                 DS
WJB  D  JUST1                  1      9
WJB  D  ADD                    1      1
WJB  D  CHG                    2      2
WJB  D  DELE                   3      3
WJB  D  INSERT                 4      4
WJB  D  BO                     5      5
WJB  D  ADJUST                 6      6
WJB  D  RESOW                  7      7
WJB  D  PARTSP                 8      8
WJB  D  NAGERM                 9      9
WJB  D                 DS
WJB  D  P_AND_BOLN             1      2
WJB  D  PARTIAL                1      1
WJB  D  BOLN                   2      2
     D
      /Free
         dcl-pr #TAXINQ_NY extpgm ;
         end-pr ;

         dcl-pr #TAXINQ_PA extpgm ;
           Zip5 char(5) const ;
         end-pr ;
         dcl-s Restart_B ind;
         dcl-pr BIR104              extpgm;
           order                    zoned(6:0) const;
           startLine                zoned(3:0) const;
           insert                   zoned(3:0) const;
         end-pr;

SUD01 *?Procedure Prototype Declaration : Call ShipTo Maintenance Program
  |     Dcl-Pr SHR010 ExtPgm;
  |        PDs Like(ShiPtoDs);
  |     End-Pr;
  |   *
  |   *?Procedure Prototype Declaration : Call Diretions Maintenance Program
  |     Dcl-Pr DIR010 ExtPgm;
  |        PCust Packed(6);
  |        PSeq# Packed(3);
  |     End-Pr;
  |   *
  |   *?ShipTo Data Structure :
  |     Dcl-Ds ShipToDs Qualified;
  |        Number Packed(6:0);
  |        Seq#   Packed(3:0);
  |        Name   Char(30);
  |        CName  Char(30);
  |        Adr1   Char(30);
  |        Adr2   Char(30);
  |        Adr3   Char(30);
  |        Adr4   Char(30);
  |        City   Char(18);
  |        State  Char(2);
  |        Zip    Char(9);
  |        Phone  Packed(10:0);
  |        TaxE   Char(1);
  |        TaxJ   Char(3);
  |        Pgm    Char(10);
SUD01   End-Ds;

       //Dcl-S IndicatorPtr  pointer INZ(%ADDR(*IN));
       //Dcl-DS IndDS based(IndicatorPtr);
       //  in01_AddMode        char(3) pos(01);
       //  in02_ChangeMode     char(3) pos(02);
       //  in03_DeleteMode     char(3) pos(03);
       //  in55_BrokerOrder    char(3) pos(55);
       //END-DS;
      /End-Free

    ?D/COPY QFunctDefn,$ErrMsg

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Day
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Year
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Month
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$center
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$addDate
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$_LOT
      *
     IRMCUST
     I              CMRTE1                      RT(1)
     I              CMRTE2                      RT(2)
     I              CMRTE3                      RT(3)
     I              CMRTE4                      RT(4)
     I              CMRTE5                      RT(5)
     I              CMRTE6                      RT(6)
     I              CMRTE7                      RT(7)
     I              CMSTP1                      ST(1)
     I              CMSTP2                      ST(2)
     I              CMSTP3                      ST(3)
     I              CMSTP4                      ST(4)
     I              CMSTP5                      ST(5)
     I              CMSTP6                      ST(6)
     I              CMSTP7                      ST(7)
     IRMINVT
     I              IMSEL1                      IP1(1)
     I              IMSEL2                      IP1(2)
     I              IMSEL3                      IP1(3)
     I              IMSEL4                      IP1(4)
     I              IMSEL5                      IP1(5)
     I              IMBCS1                      IP2(1)
     I              IMBCS2                      IP2(2)
     I              IMBCS3                      IP2(3)
     I              IMBCS4                      IP2(4)
     I              IMBCS5                      IP2(5)
     I              IM3CS1                      IP3(1)
     I              IM3CS2                      IP3(2)
     I              IM3CS3                      IP3(3)
     I              IM3CS4                      IP3(4)
     I              IM3CS5                      IP3(5)
     I              IMQLB1                      IDQ(1)
     I              IMQLB2                      IDQ(2)
     I              IMQLB3                      IDQ(3)
     I              IMQLB4                      IDQ(4)
     I              IMQLB5                      IDQ(5)
     I              IMDIS1                      IDP(1)
     I              IMDIS2                      IDP(2)
     I              IMDIS3                      IDP(3)
     I              IMDIS4                      IDP(4)
     I              IMDIS5                      IDP(5)
     I              IMQM01                      ISQ(1)
     I              IMQM02                      ISQ(2)
     I              IMQM03                      ISQ(3)
     I              IMQM04                      ISQ(4)
     I              IMQM05                      ISQ(5)
     I              IMQM06                      ISQ(6)
     I              IMQM07                      ISQ(7)
     I              IMQM08                      ISQ(8)
     I              IMQM09                      ISQ(9)
     I              IMQM10                      ISQ(10)
     I              IMQM11                      ISQ(11)
     I              IMQM12                      ISQ(12)
     I              IMQM13                      ISQ(13)
     I              IM$M01                      ISP(1)
     I              IM$M02                      ISP(2)
     I              IM$M03                      ISP(3)
     I              IM$M04                      ISP(4)
     I              IM$M05                      ISP(5)
     I              IM$M06                      ISP(6)
     I              IM$M07                      ISP(7)
     I              IM$M08                      ISP(8)
     I              IM$M09                      ISP(9)
     I              IM$M10                      ISP(10)
     I              IM$M11                      ISP(11)
     I              IM$M12                      ISP(12)
     I              IM$M13                      ISP(13)
     I              IMCM01                      ISP(1)
     I              IMCM02                      ISP(2)
     I              IMCM03                      ISP(3)
     I              IMCM04                      ISP(4)
     I              IMCM05                      ISP(5)
     I              IMCM06                      ISP(6)
     I              IMCM07                      ISP(7)
     I              IMCM08                      ISP(8)
     I              IMCM09                      ISP(9)
     I              IMCM10                      ISP(10)
     I              IMCM11                      ISP(11)
     I              IMCM12                      ISP(12)
     I              IMCM13                      ISP(13)
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
      *
     IFMCUSTC   NS
     I*    STATUS
     I                                  1    1  CKSTAT
     I                                 10   39  CKNAME
EFD01I                             P  377  381 2CKVOPO
     I                             P  408  413 2CKARB$
     I                             P  539  544 2CKCUR$
     I                             P  545  550 2CKAR1$
     I                             P  551  556 2CKAR2$
     I                             P  557  562 2CKAR3$
     I                             P  563  568 2CKAR4$
     I                             P  569  574 2CKFUT$
     IFMCUSTB   NS
     I*    STATUS
     I                                  1    1  BCSTAT
     I                                 10   39  BCNAME
     I                                 40   69  BCADD2
     I                                 70   99  BCADD3
     I                                100  129  BCADD4
     I                                130  147  BCCITY
     I                                148  149  BCSTST
     I                                150  154  BCZIPA
     I                                155  158  BCZIPB
      ****************
      * SET UP       *
      ****************
      *
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVE      '999'         USDEPT            3
     C     USDEPT        CHAIN     FMDEPT                             90
     C                   Z-ADD     0.00          V1DIS             4 2
     C                   Z-ADD     999999999     V1QT(1)
     C                   Z-ADD     999999999     V1QT(2)
     C                   Z-ADD     00.00         V2DIS             4 2
     C                   Z-ADD     999999999     V2QT(1)
     C                   Z-ADD     999999999     V2QT(2)
     C                   SETOFF                                       16
     C                   MOVEL     'N'           LABHUN            1
      * GET DEFAULT SHIP DATE
     C                   Z-ADD     01            OEC               2 0
     C     OEKEY         CHAIN(N)  FOECTL                             90
     C                   Z-ADD     OCRQDT        VRQDTE
      *
      ** CHECK IF FROM BROKER ORDER
     C     BROKER        IFEQ      'Y'
     C     BRKORD        CHAIN     FHORDR                             99
     C                   END
     C                   MOVE      'A'           VACT
     C                   MOVE      'N'           RPPCK
      *
     C                   Write     ASSUME
      /EJECT
      *// -----------------------------------------------------------------------------------------
      *// :                                                                                       :
      *// :    N E W   O R D E R                                                                  :
      *// :                                                                                       :
      *// -----------------------------------------------------------------------------------------
      *
      *
      * NEW ORDER
      *
     C     NXTO          TAG
     C                   CLEAR                   *IN
     C                   EXSR      CLRA
     C                   UNLOCK    FMINVT
     C                   UNLOCK    FHORDR
     C                   UNLOCK    FIORDR
     C                   UNLOCK    FPPO
     C                   UNLOCK    FOECTL
     C                   UNLOCK    FTAGXR
     C                   Z-ADD     0             VOLDSC
     C                   Z-ADD     0             VSSEQ#
     C                   MOVE      *BLANKS       OHTXST
     C                   Z-ADD     0             DTCN
      ** PUT DEFAULTS HERE
     C                   MOVEL     'Y'           LABYN             1
     C                   SETOFF                                       010203
     C                   SETOFF                                       0405
     C                   SETOFF                                       16
     C                   MOVEL     '000001'      VFRTCD
      ** POS CURSOR BASED ON ACTION
     C                   SETOFF                                       7677
     C     VACT          IFEQ      'A'
     C                   SETON                                        77
     C                   ELSE
     C                   SETON                                        76
     C                   END
      *
      /EJECT
      *// -----------------------------------------------------------------------------------------
      *// :                                                                                       :
      *// :    S C R E E N   A                                                                    :
      *// :                                                                                       :
      *// -----------------------------------------------------------------------------------------
      ***** SCREEN A
     C     RSTRTA        TAG
     C     BROKER        IFEQ      'Y'
     C                   SETON                                        55
     C                   Z-ADD     BRKORD        VORDER
     C                   MOVEL     'Y'           ORDENT
     C                   Z-ADD     TDATE         VORDTE
     C                   MOVEL     'N'           VINVCD
     C                   MOVEL     'N'           VTXFRG
     C                   MOVEL     'N'           VTXSPC
WJB  C                   MOVEL     'Y'           VTXFRG
WJB  C                   MOVEL     'Y'           VTXSPC
     C                   MOVEL     'N'           VSTA
     C                   MOVEL     'N'           VLOTC
     C                   MOVEL     'P'           VPPCOL
     C                   MOVEL     *BLANKS       VPURCH
     C                   Z-ADD     0             ORQDTE
     C                   Z-ADD     OHDTRQ        ORQDTE
     C                   Z-ADD     OHDTRQ        VRQDTE
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
      *
     C     PASSED        IFEQ      'Y'
     C     BAIL          IFEQ      'Y'
     C     *IN16         ANDEQ     *OFF
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
     C                   Eval      Looping = *Zero
     C                   MOVE      'Y'           BAIL              1
     C                   MOVE      *ON           *IN60
     C     PASORD        CHAIN     FHORDR                             99
      /Free
        *In84 = is_B2B_Order(PASORD);
        *In85 = is_KP_Order(PASORD);
      /End-Free
     C                   Z-ADD     PASORD        VORDER
     C                   MOVE      'C'           VACT
     C                   GOTO      SKIPA
     C                   ENDIF
      *
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       171867
     C                   SETOFF                                       2021
     C                   SETOFF                                       3031
     C                   SETOFF                                       90
     C                   READ      SCRNA                                  90
     C     SKIPA         TAG
     C   KC
     COR KG              GOTO      END
      *
     C   KI              CALL      'BIR235CL'
     C   KI              GOTO      RSTRTA
     C   KF              GOTO      NXTO
     C   16              GOTO      SCRBN
      *
      *****TEST ACTION CODE
      *
     C     VACT          IFNE      'A'
     C     VACT          ANDNE     'C'
     C     VACT          ANDNE     'D'
WJB  C     VACT          ANDNE     'Y'
     C                   SETON                                        10
     C   10              SETOFF                                       010203
     C   10              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          COMP      'A'                                    01
     C     VACT          COMP      'C'                                    02
     C     VACT          COMP      'D'                                    03
     C     VACT          COMP      'Y'                                    19
      * START WITH TAGS WANTED
     C**   01                SETON                     06
     C  N01              SETOFF                                       06
      *
      * CHANGE OR DELETE ORDERS
      *
     C     VACT          IFNE      'A'
     C     VACT          ANDNE     'Y'
     C                   GOTO      NOADD
     C                   ENDIF
      *
      *  SHIP TO CUSTOMER ALPHA SEARCH
      *
     C     VSCUST        IFEQ      *ZEROS
     C     VSALPH        ANDGT     *BLANKS
     C***        VSTELE    ANDEQ*BLANKS
     C                   MOVEL     VSALPH        CMLOOK           15
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VSALPH
     C                   Z-ADD     CMCUST        VSCUST
     C                   MOVEL     CMNAME        VSNAME
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
      *  SHIP TO TELEPHONE # SEARCH
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
     C                   MOVEL     CMNAME        VSNAME
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
      *****BOTH FIELDS BLANK ON OTHER THAN ADD
      *
     C     VSCUST        IFLE      0
     C     VSALPH        ANDEQ     *BLANKS
     C     VSTELE        ANDEQ     *BLANKS
     C                   SETON                                        17
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
      *****ENTRIES IN BOTH FIELDS
      *
     C     VSCUST        IFGT      *ZEROS
     C     VSALPH        ANDGT     *BLANKS
     C                   SETON                                        14
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     VSCUST        IFGT      *ZEROS
     C     VSTELE        ANDGT     *BLANKS
     C                   SETON                                        11
     C   11              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VSALPH        IFGT      *BLANKS
     C     VSTELE        ANDGT     *BLANKS
     C                   SETON                                        11
     C   11              GOTO      RSTRTA
     C                   ENDIF
      *
      *  CHECK SHIP TO CUSTOMER NUMBER
      *
     C     KEY6          KLIST
     C                   KFLD                    VSCUST
     C     KEY6          CHAIN(N)  FMCUST                             90
     C   90              SETON                                        17
     C  N90CMSTAT        IFEQ      'D'
     C                   SETON                                        17
     C                   ENDIF
     C   17              GOTO      RSTRTA
RP   C                   MOVE      *OFF          *IN75
RP   C     CMBABB        IFNE      *BLANKS
RP   C                   MOVE      *ON           *IN75
RP   C                   ENDIF
     C                   Z-ADD     CMPRCD        PRICD             1 0
     C*******              Z-ADDCM#FLT    FLATS  111
     C                   Z-ADD     0             FLATS            11 1
     C                   MOVEL     CMACK         VACK              1
     C                   MOVEL     CMNAME        VSNAME
     C                   MOVEL     CMZIP         VZIPA1            5
     C                   MOVE      CMZIP         VZIPA2            4
     C                   MOVEL     CMPORQ        POREQ             1
     C     DESHFR        IFEQ      *BLANKS
     C     CMSHFR        ANDGT     *BLANKS
     C                   MOVEL     CMSHFR        VSHFR
     C                   END
     C                   Z-ADD     CMSACU        OHSACU
     C                   Z-ADD     CMBLCU        OHBLCU
      /Free
        *In85 = is_KP_Order(VSCUST);
      /End-Free
      ** GET PHYTO CODE
     C     CMPHYT        IFGT      *BLANKS
     C                   MOVEL     CMPHYT        OHPHYT
     C                   ELSE
     C     CMSTST        CHAIN(N)  FMSTAT                             90
     C  N90              MOVEL     STPHYT        OHPHYT
     C                   END
      ** GET CUSTOMER NOTES
     C                   EXSR      GETNOT
      **
     C     VSHFR         IFGT      *BLANKS
     C                   EXSR      GETSFR
     C                   ENDIF
     C                   MOVEL     CMSVCD        VSVCD
     C     VSVCD         IFGT      *BLANKS
     C                   EXSR      GETSHV
     C                   ENDIF
     C                   MOVEL     CMTMCD        VTRMCD            2
     C                   EXSR      GETTRM
     C                   MOVEL     CMORLS        VMORLS
     C     VMORLS        IFGT      *BLANKS
     C     VMORLS        ANDNE     '*NONE'
     C                   EXSR      GETORL
     C                   ENDIF
     C                   MOVEL     CMTXST        VTXST
     C                   MOVEL     CMTXJU        VTXJU
     C                   MOVEL     CMUPSZ        VUPSZ
     C                   MOVEL     CMSLSM        VSLSM1
     C                   EXSR      GETSLP
     C                   MOVEL     SMNAME        SNAME1
     C                   Z-ADD     CMARCU        ARCUST            6 0
     C                   Z-ADD     CMBLCU        BLCUST            6 0
      *
      * GET BILL TO CUSTOMER DATA
      *
     C     VSCUST        IFNE      BLCUST
     C     BLCUST        CHAIN     FMCUSTB                            90
     C   90              SETON                                        18
     C  N90BCSTAT        IFEQ      'D'
     C                   SETON                                        18
     C   18              GOTO      NOBLTO
     C                   ENDIF
     C                   MOVEL     BCNAME        VNAM1B
     C                   MOVEL     BCADD2        VADD2B
     C                   MOVEL     BCADD3        VADD3B
     C                   MOVEL     BCADD4        VADD4B
     C                   MOVEL     BCCITY        VCITYB
     C                   MOVEL     BCSTST        VSTATB
     C                   MOVEL     BCZIPA        VZIPB1
     C                   MOVEL     BCZIPB        VZIPB2
     C                   ELSE
     C     NOBLTO        TAG
     C                   MOVEL     CMNAME        VNAM1B
     C                   MOVEL     CMADD2        VADD2B
     C                   MOVEL     CMADD3        VADD3B
     C                   MOVEL     CMADD4        VADD4B
     C                   MOVEL     CMCITY        VCITYB
     C                   MOVEL     CMSTST        VSTATB
     C                   MOVEL     CMZIP         VZIPB1            5
     C                   MOVE      CMZIP         VZIPB2            4
     C                   ENDIF
      *

     C     NOADD         TAG
      *
      *  CHECK ORDER NUMBER
      *
     C  N16
     CANN55VORDER        IFGT      *ZEROS
     C     VACT          ANDEQ     'A'
     C                   SETON                                        1329
     C   13              GOTO      RSTRTA
     C                   ENDIF
      *
     C  N16VORDER        IFEQ      *ZEROS
     C     VACT          ANDNE     'A'
     C                   SETON                                        2029
     C   20              GOTO      RSTRTA
     C                   ENDIF
      *
     C     VACT          IFNE      'A'
     C     VORDER        CHAIN(N)  FHORDR                             21
      /Free
        *In84 = is_B2B_Order(VORDER);
        *In85 = is_KP_Order(VORDER);
      /End-Free
     C  N21OHSTAT        IFEQ      'D'
     C                   SETON                                        21
     C                   ENDIF
     C  N21OHCOFL        IFEQ      'Y'
     C                   SETON                                        21
     C                   ENDIF
WJB  C     VACT          IFEQ      'Y'
WJB  C     VSCUST        ANDEQ     *ZEROS
WJB  C                   SETON                                        14
WJB  C                   GOTO      RSTRTA
WJB  C                   ENDIF
WJB  C     *IN21         IFEQ      *OFF
WJB  C     VACT          ANDEQ     'Y'
WJB  C                   CALL      'BIR107'
WJB  C                   PARM                    VORDER
WJB  C                   PARM                    VSCUST
WJB  C                   MOVE      'C'           VACT
WJB  C                   Z-ADD     *ZERO         VSCUST
WJB  C                   GOTO      RSTRTA
WJB  C                   ENDIF
     C  N21              EXSR      BLDORD
     C                   ENDIF
     C   21              GOTO      RSTRTA
      *
      *  CHECK COMPANY NUMBER & GET NEXT ORDER NUMBER
      *
     C     VCO           IFEQ      *ZEROS
     C                   SETON                                        14
     C   14              GOTO      RSTRTA
     C                   ENDIF
     C     VCO           CHAIN     FARCTL                             90
     C   90              SETON                                        14
     C   14              GOTO      RSTRTA
     C                   Z-ADD     1             SVFRMY            3 0
     C     ACAGPY        ADD       1             SVFRM2            3 0
     C     ACAGP2        ADD       1             SVFRM3            3 0
     C     ACAGP3        ADD       1             SVFRM4            3 0
     C                   Z-ADD     ACAGP3        COOVER            3 0
      *
     C  N55VACT          IFEQ      'A'
     C     OEKEY         KLIST
     C                   KFLD                    OEC
     C                   Z-ADD     00            OEC               2 0
     C     OEKEY         CHAIN     FOECTL                             90
     C                   MOVE      OCNORD        VORDER
     C     OCNORD        ADD       1             OCNORD
     C                   UPDATE    ROECTL
     C                   ENDIF
      *  CHECK QUOTE FIELD
      *
     C     VQUOTE        IFNE      'Y'
     C     VQUOTE        ANDNE     'N'
     C     VQUOTE        ANDNE     ' '
     C                   SETON                                        15
     C   15              GOTO      RSTRTA
     C                   ENDIF
      *  CHECK REPRINT PICK SLIP
      *
     C     RPPCK         IFNE      'Y'
     C     RPPCK         ANDNE     'N'
     C                   SETON                                        30
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     RPPCK         IFEQ      'Y'
     C     VACT          ANDNE     'C'
     C                   SETON                                        3031
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
      * 9/3/96
     C     CMBLCU        CHAIN     FARHST                             90
     C  N90HSCRDT        IFEQ      *ZEROS
     C                   GOTO      NOCC
     C                   ENDIF
     C                   MOVEL     TDATE         TMTH              2 0
     C                   MOVE      TDATE         TYR               2 0
     C                   MOVEL     HSCRDT        CMTH              2 0
     C                   MOVE      HSCRDT        CYR               2 0
     C     CYR           IFLT      TYR
     C                   SETON                                        67
     C                   ENDIF
     C     CYR           IFEQ      TYR
     C     CMTH          ANDLT     TMTH
     C                   SETON                                        67
     C                   ENDIF

     C     NOCC          TAG
     C                   SETON                                        16
     C     ARCUST        IFNE      VSCUST
     C     ARCUST        CHAIN     FMCUSTC                            90
     C  N90              MOVEL     CKNAME        ARNAME           30
     C     CKCUR$        ADD       CKFUT$        CURAR            11 2
     C                   Z-ADD     CKAR1$        AR1              11 2
     C                   Z-ADD     CKAR2$        AR2              11 2
     C                   Z-ADD     CKAR3$        AR3              11 2
     C                   Z-ADD     CKAR4$        AR4              11 2
     C                   Z-ADD     CKARB$        TOTAR            11 2
     C                   ELSE
     C                   MOVEL     CMNAME        ARNAME
     C     CMCUR$        ADD       CMFUT$        CURAR            11 2
     C                   Z-ADD     CMAR1$        AR1              11 2
     C                   Z-ADD     CMAR2$        AR2              11 2
     C                   Z-ADD     CMAR3$        AR3              11 2
     C                   Z-ADD     CMAR4$        AR4              11 2
     C                   Z-ADD     CMARB$        TOTAR            11 2
     C                   ENDIF
      ** GET OPEN ORDERS
     C                   CALL      'GETOORD'
     C                   PARM                    VSCUST
WJB  C*                    PARM           TOTDOL
WJB  C                   PARM                    TOT$9             9 2
     C                   PARM                    OPNFLT
WJB  C                   Z-ADD     TOT$9         TOTDOL
     C                   Z-ADD     FLATS         OPNFLT
     C   KF              SETOFF                                       16
     C   KF              GOTO      NXTO
     C                   GOTO      RSTRTA
      *
      /EJECT
      *// -----------------------------------------------------------------------------------------
      *// :                                                                                       :
      *// :    S C R E E N  "B"  N E W                                                            :
      *// :                                                                                       :
      *// -----------------------------------------------------------------------------------------

     C     SCRBN         TAG
     C  N55              MOVE      *BLANKS       ORDENT

     C     SCRB          TAG
RP   C                   MOVE      *OFF          *IN75
RP   C     CMBABB        IFNE      *BLANKS
RP   C                   MOVE      *ON           *IN75
RP   C                   ENDIF
     C     VACT          IFEQ      'A'
     C     ORDENT        ANDNE     'Y'
     C                   Z-ADD     TDATE         VORDTE
     C                   MOVEL     'N'           VINVCD
     C                   MOVEL     'N'           VTXFRG
     C                   MOVEL     'N'           VTXSPC
WJB  C                   Eval      VTXFRG = 'Y'
WJB  C                   Eval      VTXSPC = 'Y'
     C                   MOVEL     'N'           VSTA
     C                   MOVEL     'N'           VLOTC
     C                   MOVEL     'P'           VPPCOL
     C                   MOVEL     *BLANKS       VPURCH
     C                   Z-ADD     0             ORQDTE
     C     DESHFR        IFGT      *BLANKS
     C                   MOVE      DESHFR        VSHFR
     C                   ENDIF
     C                   EXSR      GETSFR
     C                   ENDIF
      /Free
SUD01      If VSSEQ# = *Zeros;
  |           Chain (VORDER:VSCUST) FHORDRSHTL;
  |           If %Found;
  |              VSSEQ# = OSSEQ#;
  |           Endif;
  |        Endif;
SUD01 /End-Free
     C     VACT          IFEQ      'A'
     C                   MOVEL     ' Add  '      VMODE
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     'Change'      VMODE
     C                   ENDIF
      *// -----------------------------------------------------------------------------------------
      *// :                                                                                       :
      *// :    S C R E E N  "B"  D E L E T E                                                      :
      *// :                                                                                       :
      *// -----------------------------------------------------------------------------------------
     C     VACT          IFEQ      'D'
     C                   MOVEL     'Delete'      VMODE
      /EJECT
     C     NXTBD         TAG
     C                   WRITE     SCRNBD
     C                   READ      SCRNBD                                 90
     C   KF
     CAN 60              MOVE      *ON           *INLR
     C   KF
     CAN 60              RETURN
     C   KF              GOTO      NXTO
     C   KJ
     COR KX              DO
     C                   EXSR      DELORD
     C                   EXSR      CLRA
     C                   SETOFF                                       1654
     C   60              MOVE      *ON           *INLR
     C   60              RETURN
     C  N60              GOTO      NXTO
     C                   ENDDO
     C                   GOTO      NXTBD
     C                   ENDIF
      *
     C                   Clear                   RHORDISCNT
     C     VORDER        Chain(N)  FHORDISCNT
     C                   If        %Found(FHORDISCNT)
     C                   Eval      EOD = ADDSC1
     C                   Else
     C                   Eval      EOD = *Zero
     C                   EndIf
      /Free
       If VMODE = 'Change';
         Exec SQL // Add Order to Auto Acknowledge File
           Insert into Auto_Acknowledge_Changed_Orders Values(:VORDER);
       ENDIF;
      /End-Free

      /EJECT
      *// -----------------------------------------------------------------------------------------
      *// :                                                                                       :
      *// :    S C R E E N  "B"                                                                   :
      *// :                                                                                       :
      *// -----------------------------------------------------------------------------------------
     C     RSTRTB        TAG
      *
     C     VORDER        Chain     FHORDRCSTM
     C                   If        %Found(FHORDRCSTM)
     C                   Eval      CUSTOMYN = 'Y'
     C                   Else
     C                   Eval      CUSTOMYN = 'N'
     C                   EndIf
     C     PASSED        IFEQ      'Y'
     C     *INKL         ANDNE     *ON
     C*                  EVAL      PASSED = 'N'
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       293031
     C                   SETOFF                                       323334
     C                   SETOFF                                       353637
     C                   SETOFF                                       383940
     C                   SETOFF                                       414243
     C                   SETOFF                                       444546
     C                   SETOFF                                       474849
     C                   SETOFF                                       616890
     C                   SETOFF                                       76
     C                   ELSE
     C                   WRITE     SCRNB
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       262728
     C                   SETOFF                                       293031
     C                   SETOFF                                       323334
     C                   SETOFF                                       353637
     C                   SETOFF                                       383940
     C                   SETOFF                                       414243
     C                   SETOFF                                       444546
     C                   SETOFF                                       474849
     C                   SETOFF                                       616890
     C                   SETOFF                                       7662
     C                   READ      SCRNB                                  90
SUD02C                   Eval      Restart_B = *Off
     C                   ENDIF
RP   C   KI              MOVE      *OFF          *IN75                          Unprotect EOD
WJB  C   KI              MOVE      *ON           *IN62                          Position to EOD
WJB  C   KI              MOVE      *ON           *INKL
RP   C   KI              GOTO      RSTRTB
      ** IF IN MIDDLE OF ORDER CANNOT END HERE
     C     ORDENT        IFNE      'Y'
     C   KC
     CAN 60
     COR KF
     CAN 60
     COR KG
     CAN 60              MOVE      *ON           *INLR
     C   KC
     CAN 60
     COR KF
     CAN 60
     COR KG
     CAN 60              RETURN
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRA
     C   KF              GOTO      NXTO
     C                   ELSE
     C   KF              GOTO      STRDET
     C                   END
SUD03 /Free
  |
  |   *?  // On F20 = ShipToEdit Function Key
  |       If *InKU = *On;
  |          ShipToDs.Number = VSCUST;
  |          ShipToDs.Seq#   = VSSEQ#;
  |          ShipToDs.Name   = CMNAME;
  |          ShipToDs.Adr1   = CMADD2;
  |          ShipToDs.Adr2   = CMADD3;
  |          ShipToDs.Adr3   = CMADD4;
  |          ShipToDs.Adr4   = *Blanks;
  |          ShipToDs.City   = CMCITY;
  |          ShipToDs.State  = CMSTST;
  |          ShipToDs.Zip    = VZIPA1 + VZIPA2;
  |          ShipToDs.Phone  = CMPHON;
  |          ShipToDs.TaxE   = VTXST;
  |          ShipToDs.TaxJ   = VTXJU;
  |          ShipToDs.Pgm    = 'BIR100E';
  |          SHR010(ShipToDs);
  |
  |   *?     // Update ShipTo Values in SCRNB
  |          VSCUST = ShipToDs.Number;
  |          VSSEQ# = ShipToDs.Seq#;
  |          CMNAME = ShipToDs.Name;
  |          CMADD2 = ShipToDs.Adr1;
  |          CMADD3 = ShipToDs.Adr2;
  |          CMADD4 = ShipToDs.Adr3;
  |          CMCITY = ShipToDs.City;
  |          CMSTST = ShipToDs.State;
  |          VZIPA1 = %Subst(ShipToDs.Zip:1:5);
  |          VZIPA2 = %Subst(ShipToDs.Zip:6:4);
  |          CMPHON = ShipToDs.Phone;
  |          VTXST  = ShipToDs.TaxE;
  |          VTXJU  = ShipToDs.TaxJ;
  |          *InKU = *Off;
  |          Restart_B = *On;
  |   /End-free
  |  C                   GOTO      RSTRTB
  |   /Free
SUD03     Endif;
SUD01
  |   *?  // On F8 = ShipTo Function Key
  |       If *InKH = *On;
  |          If Not *IN84;
  |             ShipToDs.Number = VSCUST;
  |             ShipToDs.Seq#   = VSSEQ#;
  |             ShipToDs.Name   = CMNAME;
  |             ShipToDs.Adr1   = CMADD2;
  |             ShipToDs.Adr2   = CMADD3;
  |             ShipToDs.Adr3   = CMADD4;
  |             ShipToDs.Adr4   = *Blanks;
  |             ShipToDs.City   = CMCITY;
  |             ShipToDs.State  = CMSTST;
  |             ShipToDs.Zip    = VZIPA1 + VZIPA2;
  |             ShipToDs.Phone  = CMPHON;
  |             ShipToDs.TaxE   = VTXST;
  |             ShipToDs.TaxJ   = VTXJU;
  |             ShipToDs.Pgm    = Pgm;
  |             SHR010(ShipToDs);
  |
  |   *?        // Update ShipTo Values in SCRNB
  |             VSCUST = ShipToDs.Number;
  |             VSSEQ# = ShipToDs.Seq#;
  |             CMNAME = ShipToDs.Name;
  |             CMADD2 = ShipToDs.Adr1;
  |             CMADD3 = ShipToDs.Adr2;
  |             CMADD4 = ShipToDs.Adr3;
  |             CMCITY = ShipToDs.City;
  |             CMSTST = ShipToDs.State;
  |             VZIPA1 = %Subst(ShipToDs.Zip:1:5);
  |             VZIPA2 = %Subst(ShipToDs.Zip:6:4);
  |             CMPHON = ShipToDs.Phone;
  |             VTXST  = ShipToDs.TaxE;
  |             VTXJU  = ShipToDs.TaxJ;
SUD01           *InKh = *Off;
SUD01        Endif;
SUD02        Restart_B = *On;
  |   /End-free
  |  C                   GOTO      RSTRTB
  |   /Free
  |       Endif;
  |
  |   *?  // On F16 = Directions Function Key
  |       If *InKQ = *On;
  |          DIR010(VSCUST:VSSEQ#);
  |   /End-free
  |  C                   GOTO      RSTRTB
  |   /Free
  |
  |       Endif;
  |   /End-free
SUD01
      *
     C                   If        USERID <> 'BILL'
     C                             and USERID <> 'BILLB'
WJB   *  When I was working on this, Bill SPECIFICALLY said he just wanted the program to loop if
WJB   *  there was an error on the Order Header screen, so if the User ID is BILL, do not bail out.
     C                   Add       1             Looping           2 0
     C                   If        Looping > 50
     C                   Eval      Looping = *Zero
     C                   Eval      PASSED = 'N'
     C                   EndIf
     C                   EndIf

     C*          VCUSTB    IFNE VBCUST
     C*                    SETOF                     90
     C*          VCUSTB    CHAINFMCUST              N90
     C*                    ENDIF
      *
      /Free
       If VTXST = 'Y';
         VTXFRG = 'N';
         VTXSPC = 'N';
        else;
         VTXFRG = 'Y';
         VTXSPC = 'Y';
       ENDIF;
      /End-Free
     C     VRQDTE        IFEQ      *ZEROS
     C                   SETON                                        4824
     C   48              GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     VRQDTE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        4824
     C                   GOTO      RSTRTB
     C                   END
     C                   Z-ADD     ##CYMD        RDATE             7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C     #Y            IFNE      1
     C     VLOTC         ANDEQ     'Y'
     C                   SETON                                        2476
     C                   GOTO      RSTRTB
     C                   END
      ** Check if Custom Flag Set
     C                   If        not %Found(FHORDRCSTM)
     C                             and CUSTOMYN = 'Y'
     C                   Eval      COORD# = VORDER
     C                   Eval      COPROJ = 'N'
     C                   Write     RHORDRCSTM
     C                   EndIf
     C                   If        %Found(FHORDRCSTM)
     C                             and CUSTOMYN = 'N'
     C                   Delete    RHORDRCSTM
     C                   EndIf
     C     VORDER        Chain     FHORDRCSTM
      ** Check Early Order Discount (EOD)
     C     VORDER        Chain     FHORDISCNT
     C                   If        %Found(FHORDISCNT)
     C                   Eval      ADDSC1 = EOD
     C                   Update    RHORDISCNT
     C                   Else
     C                   If        EOD <> *Zero
     C                   Clear                   RHORDISCNT
     C                   Eval      ADORD# = VORDER
     C                   Eval      ADDSC1 = EOD
     C                   Write     RHORDISCNT
     C                   EndIf
     C                   EndIf
      ** GET ROUTE AND STOP
     C*    VRQDTE        IFNE      ORQDTE
     C*                  Z-ADD     ST(#Y)        VSTOP
     C*                  MOVEL     RT(#Y)        VROUTE
     C*                  END
     C                   Z-ADD     *Zero         VSTOP
     C                   MOVEL     *Blanks       VROUTE
      *
     C     POREQ         IFEQ      'Y'
     C     VPURCH        ANDEQ     *BLANKS
     C                   SETON                                        21
     C   21              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VORDTE        IFEQ      *ZEROS
     C                   SETON                                        61
     C   61              GOTO      RSTRTB
     C                   ENDIF
      *
     C                   Z-ADD     VORDTE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        61
     C                   END
     C   61              GOTO      RSTRTB
      *
     C                   Z-ADD     ##CYMD        ODATE             7 0
     C     RDATE         IFLT      ODATE
     C                   SETON                                        2324
     C   23              GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMPRCD        IFEQ      *ZEROS
     C     CMPRCD        ORGT      5
     C                   SETON                                        25
     C   25              GOTO      RSTRTB
     C                   ENDIF
     C                   MOVEL     CMPRCD        PRICD
     C     VACT          IFEQ      'C'
     C     CMPRCD        ANDNE     OHPRCD
WJB  C     BROKER        OREQ      'Y'
     C                   MOVEL     'Y'           PRCCHG
     C                   ELSE
     C                   MOVEL     'N'           PRCCHG
     C                   ENDIF
      *
      *  CHECK DATE WANTED
      *
     C     DTCN          IFLE      0
     C                   SETON                                        26
     C                   GOTO      RSTRTB
     C                   ENDIF
     C                   Z-ADD     DTCN          ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        26
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      *  LOCATION LOOKUP
      *
     C*                    MOVELVSHFR     TST1    1
     C*          TST1      IFEQ '?'
     C*          TST1      OREQ '/'
     C*                    MOVELVSHFR     WHWHSE  3
      *                    CALL 'LKLOCA'
     C*                    PARM           WHWHSE
     C*                    PARM           WHDESC 30
     C*                    MOVEL*BLANKS   VSHFR
     C*                    MOVELWHWHSE    VSHFR
     C*                    GOTO RSTRTB
     C*                    ENDIF
      *
     C*          VSHFR     IFGT *BLANKS
     C*                    EXSR GETSFR
     C*  26                GOTO RSTRTB
     C*                    ENDIF
      *
      *  SHIP VIA LOOKUP
      *
     C                   MOVEL     VSVCD         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VSVCD         SVCODE            2
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC           30
     C                   MOVEL     *BLANKS       VSVCD
     C                   MOVEL     SVCODE        VSVCD
     C                   EXSR      GETSHV
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      GETSHV
     C   27              GOTO      RSTRTB
      *
      *
      *  TERMS CODE LOOKUP
      *
     C                   MOVEL     VTRMCD        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VTRMCD        TCTERM
     C                   CALL      'LKTERM'
     C                   PARM                    TCTERM
     C                   PARM                    TCDESC
     C                   MOVEL     *BLANKS       VTRMCD
     C                   MOVEL     TCTERM        VTRMCD
     C                   EXSR      GETTRM
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VTRMCD        IFEQ      *BLANKS
     C                   SETON                                        31
     C   31              GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      GETTRM
     C   31              GOTO      RSTRTB
      *
      *  ORDER LIST LOOKUP
      *
     C                   MOVEL     VMORLS        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VMORLS        OLLIST            6
     C                   CALL      'LKORLS'
     C                   PARM                    OLLIST
     C                   PARM                    OLDESC           30
     C                   MOVEL     *BLANKS       VMORLS
     C                   MOVEL     OLLIST        VMORLS
     C                   EXSR      GETORL
     C                   GOTO      RSTRTB
     C                   ENDIF
      * VMORLS
     C     VMORLS        IFGT      *BLANKS
     C     VMORLS        ANDNE     '*NONE'
     C                   EXSR      GETORL
     C   42              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VINVCD        IFNE      'Y'
     C     VINVCD        ANDNE     'N'
     C                   SETON                                        28
     C   28              GOTO      RSTRTB
     C                   ENDIF
      *
      ****   FREIGHT CODE LOOKUP
     C   KA              DO
     C                   CALL      'LKFRCD'
     C                   PARM                    VCO
     C                   PARM                    VFRTCD
     C                   ENDDO
      ****   VALIDATE FREIGHT CODE
WJB  C*    VFRTCD        IFGT      *BLANKS
     C     CKEY8         KLIST
     C                   KFLD                    VCO
     C                   KFLD                    VFRTCD
     C     CKEY8         CHAIN(N)  FFPERC                             90
     C   90              SETON                                        29
     C   29              GOTO      RSTRTB
WJB  C*                  ENDIF
      *
     C     CMBOOK        IFNE      'Y'
     C     CMBOOK        ANDNE     'N'
     C                   SETON                                        30
     C   30              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VLOTC         IFNE      'Y'
     C     VLOTC         ANDNE     'N'
     C                   SETON                                        32
     C   32              GOTO      RSTRTB
     C                   ENDIF
      *
      *  FREIGHT TYPE LOOKUP
      *
     C                   MOVEL     VPPCOL        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VPPCOL        FRCODE            1
     C                   CALL      'LKFRTT'
     C                   PARM                    FRCODE
     C                   PARM                    FRDESC           12
     C                   MOVEL     *BLANKS       VPPCOL
     C                   MOVEL     FRCODE        VPPCOL
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VPPCOL        IFEQ      *BLANKS
     C                   SETON                                        33
     C   33              GOTO      RSTRTB
     C                   ENDIF
      *
      * VPPCOL
     C     VPPCOL        IFGT      *BLANKS
     C                   EXSR      GETPPC
     C   33              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VTXST         IFNE      'Y'
     C     VTXST         ANDNE     'N'
     C                   SETON                                        34
     C   34              GOTO      RSTRTB
     C                   ENDIF
      *
      *  TAX JURISDICTION LOOKUP
      *
     C                   MOVEL     VTXJU         TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VTXJU         TXTXJU            3
     C                   CALL      'LKTAXJ'
     C                   PARM                    TXTXJU
     C                   PARM                    TXJUNM           30
     C                   MOVEL     *BLANKS       VTXJU
     C                   MOVEL     TXTXJU        VTXJU
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      ****   VALIDATE FREIGHT CODE
      *
     C*          VUPSZ     IFGT *BLANKS
     C*          CKEY3     KLIST
     C*                    KFLD           VCO
     C*                    KFLD           VUPSZ
     C*          CKEY3     CHAINFUZONE               90
     C*                    SETON                     47
     C*  47                GOTO RSTRTB
     C*                    ENDIF
      * TAX JURISTICTION IS A MANDATORY FIELD
     C                   SETOFF                                       9044
     C     VTXJU         CHAIN(N)  FMTAXF                             90
     C   90              SETON                                        44
     C                   If        CMSTST <> 'NY'
     C                             and CMSTST <> 'PA'
     C                             and %Trim(VTXJU) <> CMSTST
     C                             and (VSVCD <> '02' and VSVCD <> '42')
     C                   Eval      *In44 = *On
     C                   Eval      *In90 = *On
     C                   ENDIF
     C                   If        (VSVCD = '02' or VSVCD = '42')
     C                             and VTXJU <> 'NJ'
     C                   Eval      *In44 = *On
     C                   Eval      *In90 = *On
     C                   ENDIF
     C                   If        CMSTST = 'NY'
     C                             and %SubSt(TXJUNM:1:8) <> 'New York'
     C                             and (VSVCD <> '02' and VSVCD <> '42')
     C                   Eval      *In44 = *On
     C                   Eval      *In90 = *On
     C                   ENDIF
     C                   If        CMSTST = 'PA'
     C                             and %SubSt(VTXJU:1:2) <> 'PA'
     C                             and (VSVCD <> '02' and VSVCD <> '42')
     C                   Eval      *In44 = *On
     C                   Eval      *In90 = *On
     C                   ENDIF
     C   44              GOTO      RSTRTB

      *
      /Free
         // Check the Tax Jurisdiction

         //If VTXST = 'N';
         //  Restart_B = *off;
         //  Select;
         //    When VTXJU = 'NY';
         //      //CallP #TAXINQ_NY();
         //      *In44 = *On;
         //      Restart_B = *on;
         //    When VTXJU = 'PA';
         //      //CallP #TAXINQ_PA(%subst(%trim(CMZIP):1:5));
         //      *In44 = *On;
         //      Restart_B = *on;
         //  ENDSL;
         //ENDIF;

      /End-Free
     C                   if        Restart_B = *On
     C                   GOTO      RSTRTB
     C                   endif

      *
     C     VUPSZ         IFEQ      '?'
     C     VUPSZ         OREQ      '/'
     C                   MOVE      *BLANKS       FZONE             1
     C                   CALL      'LKFRTZ'
     C                   PARM                    FZONE
     C                   PARM                    FUDESC           20
     C                   MOVE      *BLANKS       VUPSZ
     C                   MOVEL     FZONE         VUPSZ
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     VTXFRG        IFNE      'Y'
     C     VTXFRG        ANDNE     'N'
     C                   SETON                                        35
     C   35              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VTXSPC        IFNE      'Y'
     C     VTXSPC        ANDNE     'N'
     C                   SETON                                        36
     C   36              GOTO      RSTRTB
     C                   ENDIF
      *
     C     VACK          IFNE      'Y'
     C     VACK          ANDNE     'N'
     C                   SETON                                        68
     C   68              GOTO      RSTRTB
     C                   ENDIF
     C     VACK          IFEQ      'N'
     C                   MOVEL     'Y'           ACKP              1
     C                   ELSE
     C                   MOVEL     'N'           ACKP              1
     C                   ENDIF
      *
     C     VSTA          IFGT      *BLANKS
     C     VSTA          ANDNE     'Y'
     C     VSTA          ANDNE     'N'
     C                   SETON                                        37
     C   37              GOTO      RSTRTB
     C                   ENDIF
      *
      *  SALESPERSON 1 LOOKUP
      *
     C                   MOVEL     VSLSM1        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VSLSM1        VSLSM             2
     C                   EXSR      LKPSLP
     C                   MOVEL     VSLSM         VSLSM1            2
     C                   MOVEL     SMNAME        SNAME1
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      GETSLP
     C   38              GOTO      RSTRTB
      *
      *  SALESPERSON 2 LOOKUP
      *
     C     VSLSM2        IFEQ      *BLANKS
     C                   GOTO      NOSLP
     C                   ENDIF
     C                   MOVEL     VSLSM2        TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVEL     VSLSM2        VSLSM
     C                   EXSR      LKPSLP
     C                   MOVEL     VSLSM         VSLSM2
     C                   MOVEL     SMNAME        SNAME2
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C                   EXSR      GETSL2
     C   38              GOTO      RSTRTB

     C     NOSLP         TAG
      **************************
      * OUTPUT HEADER RECORD   *
      **************************
     C                   MOVE      'A'           OHSTAT
     C     VORDER        CHAIN     FHORDR                             66
     C     VORDER        CHAIN     FPPO                               51
     C  N51              Eval      ENTEREDBY = POENTR
     C   51              Eval      ENTEREDBY = *Blanks
     C   66              CLEAR                   RHORDR
     C   66              MOVE      'A'           OHSTAT
     C   01              Z-ADD     VORDER        OHORD#
     C                   Z-ADD     VCO           OHCOMP
     C                   Z-ADD     VSCUST        OHCUST
     C                   MOVEL     CMNAME        OHNAME
     C                   MOVEL     CMADD2        OHSHP2
     C                   MOVEL     CMADD3        OHSHP3
     C                   MOVEL     CMADD4        OHSHP4
     C                   MOVEL     CMCITY        OHSHCT
     C                   MOVEL     CMSTST        OHSHST
     C                   MOVEL     VZIPA1        OHSHZP
     C                   MOVE      VZIPA2        OHSHZP
     C                   MOVEL     VPURCH        OHPONO
     C                   Z-ADD     VORDTE        OHDTOR
     C                   Z-ADD     VORDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OHORDY
     C                   Z-ADD     VRQDTE        OHDTRQ
     C                   Z-ADD     VRQDTE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OHDTRY
     C                   Z-ADD     DTCN          OHDTCN
     C                   MOVEL     CMSHIN        OHSHIN
     C                   MOVEL     CMSPIN        OHSPIN
     C                   MOVEL     TCTERM        OHTMCD
     C                   MOVEL     TCDESC        OHTERM
     C                   Z-ADD     TCTRAT        OHTRAT
     C                   Z-ADD     TCTDAY        OHTDAY
      ** SEE IF TAX STATUS CHANGED
     C     VTXST         IFNE      OHTXST
     C     OHTXST        ANDGT     *BLANKS
     C                   MOVEL     'C'           TAXCHG            1
     C                   ELSE
     C                   MOVE      *BLANKS       TAXCHG            1
     C                   END
     C                   MOVEL     VTXST         OHTXST
     C                   MOVEL     VTXJU         OHTXJU
     C   01              Z-ADD     0             OHAMT1
     C   01              Z-ADD     0             OHAMT2
     C   01              Z-ADD     0             OHAMT3
     C                   MOVEL     CMCTYP        OHTYPE
     C                   MOVEL     VSVCD         OHSHPC
      ** SEE IF STA CHANGED
     C     VSTA          IFNE      OHSTA
     C     OHSTA         ANDGT     *BLANKS
     C                   MOVEL     'C'           STACHG            1
     C                   ELSE
     C                   MOVE      *BLANKS       STACHG            1
     C                   END
     C                   MOVEL     VSTA          OHSTA
     C                   MOVEL     ACKP          OHACK
     C                   MOVEL     VNAM1B        OHSLD1
     C                   MOVEL     VADD2B        OHSLD2
     C                   MOVEL     VADD3B        OHSLD3
     C                   MOVEL     VADD4B        OHSLD4
     C                   MOVEL     VCITYB        OHSLCT
     C                   MOVEL     VSTATB        OHSLST
     C                   MOVEL     VZIPB1        OHSLZP
     C                   MOVE      VZIPB2        OHSLZP
     C                   MOVE      VSLSM1        OHSLM1
     C                   Z-ADD     CMCOMM        OHSCM1
     C                   MOVE      VSLSM2        OHSLM2
     C                   Z-ADD     VCOMM2        OHSCM2
     C   01              Z-ADD     0             OHFRT$
     C   01              Z-ADD     0             OHMER$
     C   01              Z-ADD     0             OHDIS$
     C   01              Z-ADD     0             OHMIS$
     C   01              Z-ADD     0             OHTAX$
     C                   MOVEL     VINVCD        OHIOCD
     C                   MOVEL     CMBOOK        OHBOCD
     C   01              MOVEL     'N'           OHCOFL
     C   01VINVCD        IFEQ      'Y'
     C                   MOVEL     'R'           OHHOLD
     C                   MOVEL     'N'           OHIVCD
     C                   MOVEL     'P'           OHPLPT
     C                   ELSE
     C                   MOVEL     'N'           OHHOLD
     C                   MOVEL     'N'           OHIVCD
     C                   MOVEL     ' '           OHPLPT
     C                   END
     C   01              Z-ADD     TDATE         OHTDAT
     C                   Z-ADD     TDATE         OHDTLA
     C                   Z-ADD     TIMOD         OHTIME
     C                   MOVEL     USERID        OHUSER
     C**                   MOVELSVDESC    OHSVIA
     C                   MOVEL     VPPCOL        OHPPCD
     C                   Z-ADD     PRICD         OHPRCD
     C                   Z-ADD     CMTRDC        OHTRDC
     C                   MOVEL     VTRMCD        OHTMCD
     C                   Z-ADD     TCTDAS        OHTDAS
     C   01              Z-ADD     0             OHINV#
     C   01              Z-ADD     0             OHINDT
     C                   MOVEL     VUPSZ         OHUPSZ
     C                   MOVEL     VTXFRG        OHFRTX
     C                   MOVEL     VTXSPC        OHSPTX
     C                   MOVEL     CMTXID        OHTXID
     C                   MOVEL     VROUTE        OHROUT
     C                   Z-ADD     VSTOP         OHSTOP
     C                   Z-ADD     CMARCU        OHARCU
     C                   Z-ADD     CMSACU        OHSACU
     C                   Z-ADD     CMBLCU        OHBLCU
     C   01              Z-ADD     0             OHTBLK
     C   01              Z-ADD     0             OHTBRK
     C   01              Z-ADD     0             OHDTAC
     C                   MOVEL     CMLOOK        OHALPH
     C                   MOVEL     VSHFR         OHSHFR
     C                   MOVEL     VFRTCD        OHPLST
     C   01              Z-ADD     0             OHCASH
     C   01              Z-ADD     VRQDTE        OHORDT
     C                   MOVEL     VMORLS        OHOLST
     C                   MOVEL     VLOC          OHLOC
     C**                   MOVE SVDESC    OHSVI2
     C**                   Z-ADDVOLDSC    OHVLDC
     C**   N77             MOVEL'N'       OHFVDC
     C**    77             MOVEL'Y'       OHFVDC
     C   01              MOVEL     'N'           OHQTPR
     C                   MOVEL     VQUOTE        OHQUOT
     C                   MOVEL     VLOTC         OHLOTC
     C                   MOVEL     'N'           OHIMFG
     C   66              WRITE     RHORDR
     C   66              Eval      HSTUSER    = USERID
     C   66              Eval      HSTPROGRAM = 'BIR100'
     C   66              Eval      HSTTIME    = $Timestamp()
     C   66              Write     RHORDRHIST
     C  N66              MOVEL     *BLANKS       OHOPLP
     C  N66              UPDATE    RHORDR
     C  N66              Eval      HSTUSER    = USERID
     C  N66              Eval      HSTPROGRAM = 'BIR100'
     C  N66              Eval      HSTTIME    = $Timestamp()
     C  N66              Write     RHORDRHIST
SUD01C                   Exsr      WriteUpdRec
     C  N66
     CAN 55              CALL      'CHGTAX'
     C                   PARM                    OHORD#
      ** GET ORDER USER INFO
     C   51              DO
     C                   CLEAR                   RPPO
     C                   MOVEL     USERID        POENTR
     C                   Z-ADD     VORDER        POORD#
     C                   ENDDO
     C**                   MOVELTAKN      POTAKN
     C   51              WRITE     RPPO
     C  N51              UPDATE    RPPO
     C  N66STACHG        IFEQ      'C'
     C                   CALL      'CHGSTA'
     C                   PARM                    OHORD#
     C                   ENDIF
     C  N66TAXCHG        IFEQ      'C'
     C                   CALL      'CHGTAX'
     C                   PARM                    OHORD#
     C                   ENDIF
     C  N66PRCCHG        IFEQ      'Y'
     C                   CALL      'CHGPRC'
     C                   PARM                    OHORD#
     C                   ENDIF
     C   01              Z-ADD     7             LSTSEQ
     C   01              Z-ADD     VRQDTE        VREQDT
     C                   Z-ADD     VORDER        LDAORD
     C                   SETOFF                                       21
     C                   MOVE      'N'           VOVER
     C                   Z-ADD     0             VUPRIC
     C     BROKER        IFEQ      'Y'
     C                   EXSR      BRKFIX
     C                   END
      /EJECT
      *  At this point in the program, the Ship Via and Default Date have been validated,
      *  so use Program $COMMENT to maintaing the Ship Via and PO Comments on the Details File
     C                   Z-Add     VORDER        Order#
     C                   CALL      '$COMMENT'                                   |Ship Via Comment
     C                   PARM                    Order#            6 0
      *
      **************************
      * DETAIL LINE ENTRY      *
      **************************
     C     STRDET        TAG
     C   55              MOVEL     'C'           VACT
     C                   MOVE      VACT          ACTNCD
     C** 01                EXSR GETPHY
     C                   EXSR      BLDSFL
     C   KK              DO
     C                   UNLOCK    FIORDR
     C                   MOVE      *BLANKS       LISTID
     C     VMORLS        IFNE      '*NONE'
     C                   MOVEL     VMORLS        LISTID
     C                   END
     C                   Z-ADD     0             PRISEQ
     C                   Z-ADD     0             TOTAST
     C                   CALL      'ORDLST'
     C                   PARM                    LISTID            6
     C                   PARM                    OHORD#
     C                   PARM                    OHDTRQ
     C                   PARM                    OHSHFR
     C                   PARM                    PRISEQ            3 0
     C                   PARM                    LSTSEQ
     C                   PARM                    TOTAST           11 0
     C                   EXSR      BLDSFL
     C                   ENDDO
     C                   SETON                                        30
     C                   Z-ADD     0             SFL1              1 0
      /EJECT
     C     NXTC          TAG
     C*          ACTNCD    IFNE 'A'
     C*                    Z-ADDLINE      PAGE#
     C*                    END
     C     CMFILL        IFEQ      'NT'
     C                   SETON                                        71
     C                   ELSE
     C                   SETOFF                                       71
     C                   END
      **GD
     C  N40              EXSR      CLRD
     C** 8/28              EXSR ACTTYP
     C** 8/28              EXSR GTLNTP
     C     SFL1          IFEQ      0
     C                   Z-ADD     1             PAGE#
     C                   Z-ADD     1             SFL1
     C                   ELSE
     C     PAGE#         IFLE      0
     C     PAGE#         ORGT      990
      ** KUBE PAK 10/28/98 SET LINE TO LINE 1
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   END
      ** GET THE PAGE NUMBER INTO CTL
     C                   SETON                                        81
      /Free

         Exec SQL
           SELECT  Case when sum(OIRQTY) <> 0 then sum(OIRQTY/SZPCRT)
                   else sum((OIQORD-OIQSHP)/SZPCRT) end as Carts
           Into    :SCARTS
           FROM    FIORDR, FMSIZE
           WHERE   OISIZE = SZCODE
             and   OIITYP <> 'C'
             and   OIORD# = :VORDER
             and   OISTAT = 'A';

      /End-Free
     C                   WRITE     ORDCTL
     C                   SETOFF                                       81
      ** POS CURSOR BASED ON ACTION
     C  N40              DO
     C                   SETOFF                                       3067
     C     ACTNCD        IFEQ      'A'
     C                   SETON                                        30
     C                   ELSE
     C                   SETON                                        67
     C                   END
     C                   ENDDO                                                  N40  DO
     C     PASSED        IFEQ      'Y'
     C     ChkMrk1       AndEq     *Off
     C                   MOVE      'C'           ACTNCD
     C                   Eval      ChkMrk1 = *On
     C*     PASLIN        IFGT      *ZERO
     C*                   Z-ADD     PASLIN        LINE
     C*                   Z-ADD     *ZERO         PASLIN
     C*                   ENDIF
      /Free
          If PASLIN > *Zero;
            monitor;
              Line = PASLIN;
              on-error;
              Line = 0;
            ENDMON;
            PASLIN = 0;
          EndIf;
      /End-Free
     C                   ENDIF
     C                   EXFMT     ORDCTL
     C                   SETON                                        40
     C                   SETOFF                                       414299
     C                   SETOFF                                       5726
     C                   SETOFF                                       3067
      *  B2BCOMMENT LOGIC WAS HERE...  moved 1/25/19
      ** PUT COMMAND KEYS HERE
      ******** RETURN TO PREVIOUS SCREEN
     C   KL              MOVEL     'Y'           ORDENT            1
     C   KL              GOTO      SCRB
      ******** PRINT PICK
     C   KF              SETON                                        09
     C   KF              CALL      PICK
     C                   PARM                    VORDER
     C   KF              GOTO      NXTC
      ******** ORDER ACKNOWLEDGEMENT
     C   KG              SETON                                        09
     C   KG              CALL      'EMLACK'
     C                   PARM                    VORDER
     C   KG              GOTO      NXTC
      ******** ZERO ALL ORDER $
     C   KU              SETON                                        09
     C                   MOVE      VORDER        VORDER@           6
     C   KU              CALL      'ZEROORDER'
     C                   PARM                    VORDER@
     C   KU              GOTO      NXTC
      ******** SHIP CONFIRM
     C   KI              SETON                                        09
     C  NKI              SETOFF                                       09
      ******** NEW ORDER
     C  NKB              SETOFF                                       08
     C   KI
     COR KB              SETON                                        08
     C   08TOTLNE        IFEQ      0
     C                   SETON                                        57
     C                   GOTO      NXTC
     C                   END
      ******** ONLY BUILD TAG ORDER ON AN ADD
     C   08
     CAN 01
     CAN 06TOTTAG        IFGT      0
     C                   EXSR      BTGORD
     C                   ENDIF
     C   08              DO
EFD01C                   UNLOCK    FIORDR
EFD01C                   CALL      'GETORD$'
EFD01C                   PARM                    OHORD#
EFD01C                   PARM                    NTOTD             9 2
     C                   Call      'BIR103A'
     C                   Parm                    VORDER
     C                   ENDDO
     C   08              SETOFF                                       16
WJB  C                   MOVE      VORDER        CORDER                         CONFIRM ORDER
     C   08
WJB  CAN 09              CALL      SHPCFM
WJB  C                   PARM                    CORDER            6
     C   08              EXSR      LockCustom
     C   08              EXSR      CLRA
     C   08
     CANN55              GOTO      NXTO
     C   08
     CAN 55              GOTO      END
      * CHANGE DISCOUNTS
     C   KH              DO
     C                   EXSR      CHGDSC
     C                   SETOFF                                       40
     C                   SETON                                        30
     C                   GOTO      NXTC
     C                   ENDDO
      * INQUIRY OPTIONS
     C   KD              DO
     C     SFLRRN        CHAIN     ORDSFL                             92
     C                   CALL      'BIR103'
     C                   PARM                    LSTDAT
     C                   PARM                    VORDER
     C                   PARM                    CARTS             5 2
     C                   PARM      'Y'           SHOWYN            1
     C                   GOTO      NXTC
     C                   ENDDO
     C   KE              DO
     C                   EXSR      GETINQ
     C                   GOTO      NXTC
     C                   ENDDO
     C   KA              DO
     C                   EXSR      ADDDSC
     C                   GOTO      NXTC
     C                   ENDDO
     C   KJ
     COR KX              DO
     C                   SETON                                        54
     C                   EXFMT     ORDCTL
     C   KJ
     CAN 54
     COR KX
     CAN 54              DO
     C                   EXSR      DELORD
     C                   EXSR      CLRA
     C                   SETOFF                                       1654
     C                   GOTO      NXTO
     C                   ENDDO
     C                   GOTO      NXTC
     C                   ENDDO
      *
      * GET ORDER LIST
     C   KK              DO
     C                   UNLOCK    FIORDR
     C                   MOVE      *BLANKS       LISTID
     C     VMORLS        IFNE      '*NONE'
     C                   MOVEL     VMORLS        LISTID
     C                   END
     C                   Z-ADD     SEQ           PRISEQ
     C                   Z-ADD     0             TOTAST
     C                   CALL      'ORDLST'
     C                   PARM                    LISTID            6
     C                   PARM                    OHORD#
     C                   PARM                    OHDTRQ
     C                   PARM                    OHSHFR
     C                   PARM                    PRISEQ            3 0
     C                   PARM                    LSTSEQ
     C                   PARM                    TOTAST           11 0
     C                   EXSR      BLDSFL
     C                   GOTO      NXTC
     C                   ENDDO
      *
      * CHECK ACTION CODE
      *
     C                   EXSR      CHKACT
      *
      * CHECK LINE TYPE
      *
     C                   EXSR      CHKTYP
      *
     C   99              GOTO      NXTC
      ** IF DELETE DISPLAY RECORD AND VERIFY
      *
     C     ACTNCD        IFEQ      'D'
     C                   EXSR      DELLIN
     C                   EXSR      BLDSFL
     C                   Z-ADD     0             FIRST
     C                   SETOFF                                       40
     C                   GOTO      NXTC
     C                   END
WJB   *
WJB   ** IF ADJUST: ADJUST QUANTITY & PRICE OF ONE TRAY (REFERENCE ORIGINAL #)
WJB  C     ACTNCD        IFEQ      'J'

     C                   Z-Add     *zero         TEST4S2           4 2

     C     ALIKEY        Chain(n)  FALITEM
     C                   Eval      TEST4S2 =
     C                             $LotPartPct(AIITEM:AISIZE:AISOWD:AICRDY)
     C                   If        %Found(FALITEM) and AIGLOC <> 'R'
     C                             and
     C                             $LotPartPct(AIITEM:AISIZE:AISOWD:AICRDY)>0
     C                             and
     C                             $LotPartPct(AIITEM:AISIZE:AISOWD:AICRDY)<1

     C                   Unlock    FIORDR
     C                   Call      'LOT_TRN_J'
     C                   Parm                    AIORD#
     C                   Parm                    AIOSEQ
     C                   Parm                    AIITEM
     C                   Parm                    AISIZE
     C                   Parm                    AICRDY
     C                   Parm                    AISOWD
     C                   Parm                    AISHPD
     C                   Parm                    ONE
     C                   Parm                    TRUE
     C*                  Eval      OISEQ# += 2
    ?C*                  Write     RIORDRPART                                   ?Write Partial Rcd.
     C                   Else
WJB  C                   EXSR      ADJLIN
     C                   EndIf

WJB  C                   EXSR      BLDSFL
WJB  C                   Z-ADD     0             FIRST
WJB  C                   SETOFF                                       40
WJB  C                   GOTO      NXTC
WJB  C                   END
WJB   *
WJB   ** IF RESOW: BACKORDER ENTIRE LINE & ADD COMMENT LINE NOTING THAT THIS
WJB   *            LINE WAS RESOWN FOR A GIVEN DATE.
WJB  C     ACTNCD        IFEQ      'R'
WJB  C                   EXSR      RESLIN                                       RESOWN LINE
WJB  C                   EXSR      BLDSFL
WJB  C                   Z-ADD     0             FIRST
WJB  C                   SETOFF                                       40
WJB  C                   GOTO      NXTC
WJB  C                   END
WJB   *
WJB   ** IF PARTIAL:
WJB   **    BACKORDERS PART OF A LINE WITHIN THE ORDER.  CHANGES ORIGINAL
WJB   **    LINE TO AVAILABLE QUANTITY & CREATES NEW LINE W/ B/O QUANTITY.
WJB  C     ACTNCD        IFEQ      'P'
WJB  C                   EXSR      PRTLIN                                       PARTIAL B/O
WJB  C                   EXSR      BLDSFL
WJB  C                   Z-ADD     0             FIRST
WJB  C                   SETOFF                                       40
WJB  C                   GOTO      NXTC
WJB  C                   END
WJB   *
WJB   ** IF N/A: THIS LINE DID NOT / WILL NOT SHIP DUE TO POOR GERMINATION.
WJB  C     ACTNCD        IFEQ      'N'
WJB  C                   EXSR      NAGLIN                                       N/A POOR GERM
WJB  C                   EXSR      BLDSFL
WJB  C                   Z-ADD     0             FIRST
WJB  C                   SETOFF                                       40
WJB  C                   GOTO      NXTC
WJB  C                   END
      ** IF BACKORDER GET NEW DATE
      *
     C     ACTNCD        IFEQ      'B'
     C                   EXSR      BCKORD
     C                   EXSR      BLDSFL
     C                   Z-ADD     0             FIRST
     C                   SETOFF                                       4052
     C                   GOTO      NXTC
     C                   END
      *
      ** CHECK LINE NUMBER ON INSERT
     C     ACTNCD        IFEQ      'I'
     C                   Z-ADD     LINE          SEQ
     C     SEQ           IFLE      0
     C     SEQ           ORGE      991
     C                   SETON                                        202126
     C                   SETON                                        99
     C                   GOTO      NXTC
     C                   END
     C     OIKEY         CHAIN     FIORDR                             90
     C  N90              SETON                                        202126
     C  N90              SETON                                        99
     C  N90              GOTO      NXTC
     C                   Eval      OISEQ# = SEQ
     C                   END
      *  IF COMMENT, FREIGHT, SPECIAL CHARGE GET INFO
      *
     C     LINTYP        IFNE      ' '
     C     LINTYP        ANDNE     'N'
     C                   EXSR      GETFSC
     C                   EXSR      BLDSFL
     C                   Z-ADD     0             FIRST
     C                   GOTO      NXTC
     C                   ENDIF
      ** CHECK IF SIZE WANTED
     C                   MOVEL     VSIZE         TST1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      *BLANKS       SZCODE            3
     C                   CALL      'LKSIZE'
     C                   PARM                    SZCODE
     C                   PARM                    SZDESC           10
     C                   MOVEL     *BLANKS       VSIZE
     C                   MOVEL     SZCODE        VSIZE
     C                   GOTO      NXTC
     C                   END
      *
      ** SEE IF WE NEED ITEM SEARCH
     C     1             SUBST     VITEM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   EXSR      ITMSRC
     C                   SETOFF                                       303132
     C                   SETOFF                                       333536
     C                   SETON                                        40
     C                   GOTO      NXTC
     C                   END
      ** CHECK ITEM NUMBER
     C     ITCKEY        KLIST
     C                   KFLD                    VITEM
     C                   KFLD                    VSIZE
     C                   KFLD                    VWHS
     C     LINTYP        IFEQ      ' '
     C     ITCKEY        CHAIN(N)  FMINVT                             31
     C  N31              DO
     C                   EXSR      GETAV
     C     IMSTAT        IFEQ      'D'
     C     IMSTAT        OREQ      'P'
     C                   SETON                                        31
     C                   END
     C                   ENDDO
     C   31              SETON                                        30
     C   31              SETOFF                                       07
     C   31              GOTO      NXTC
     C                   MOVEL     IMPCL1        OIPRCL
      ** CHECK IF WE NEED TO OUTPUT 105 DELETE REC
WJB  C*    IMSIZE        IFEQ      '105'
WJB  C*    IMFRSZ        ANDEQ     'CUT'
WJB  C     IMFRSZ        IFEQ      'CUT'
     C     VACT          ANDNE     'A'
     C                   CLEAR                   RCUTDEL
WJB  C     VendKey       KList
WJB  C                   KFld                    IMITEM
WJB  C                   KFld                    IMSIZE
WJB  C     VendKey       Chain     FMINVTVD
WJB  C                   If        %Found(FMINVTVD)
WJB  C                   Z-ADD     VDIMVEND      CDVEND
WJB  C                   EndIf
     C                   Z-ADD     OHORD#        CDORD#
     C                   Z-ADD     OHCUST        CDCUST
     C                   MOVEL     IMITEM        CDITEM
     C                   MOVEL     IMSIZE        CDSIZE
     C     ACTNCD        IFNE      'A'
     C                   Z-ADD     OISOW         CDOSOW
     C                   Z-ADD     OIRVDT        CDOREQ
     C                   Z-ADD     OIQORD        CDOQTY
     C                   END
     C                   MOVEL     ACTNCD        CDACT
     C                   TIME                    CDTIME
     C                   Z-ADD     TDATEC        CDCHDT
     C                   MOVEL     USERID        CDUSER
     C                   MOVEL     'Y'           T84               1
     C                   ELSE
     C                   MOVEL     'N'           T84
     C                   END
     C                   EXSR      GETDES
     C     VITEM         CHAIN     FIADD                              31
     C  N31              SETON                                        07
     C   31              DO
     C                   SETOFF                                       07
     C                   SETOFF                                       31
     C                   ENDDO
     C                   END
      ** SEE IF WE NEED ORDER LIST
     C     FIRST         IFEQ      0
     C     VSIZE         ANDEQ     'AST'
     C                   MOVEL     VITEM         LISTID
     C                   UNLOCK    FIORDR
     C     SEQ           IFGT      0
     C                   Z-ADD     SEQ           PRISEQ
     C                   ELSE
     C     LSTSEQ        ADD       2             PRISEQ
     C                   END
     C                   Z-ADD     0             TOTAST
     C                   CALL      'ORDLST'
     C                   PARM                    LISTID            6
     C                   PARM                    OHORD#
     C                   PARM                    OHDTRQ
     C                   PARM                    OHSHFR
     C                   PARM                    PRISEQ            3 0
     C                   PARM                    LSTSEQ
     C                   PARM                    TOTAST           11 0
     C                   Z-ADD     TOTAST        QTYORD
      **
     C     QTYORD        IFEQ      0
     C                   SETOFF                                       40
     C                   GOTO      NXTC
     C                   END
     C                   ENDIF
      ** CHECK QUANTITY
     C*    QTYORD        IFLE      0
     C*                  SETON                                        404142
     C*                  GOTO      NXTC
     C*                  END
      * CHECK AVAILABLE DATE
     C                   SETOFF                                       902476
     C     FIRST         IFNE      0
     C                   Z-ADD     VREQDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RQYYMD            7 0
     C                   Z-ADD     ##CYMD        OIRVDT
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                          24
     C                   END
     C   24              GOTO      NXTC
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C     #Y            IFNE      1
     C     IMLOTC        ANDEQ     'Y'
     C                   SETON                                        2476
     C                   GOTO      NXTC
     C                   END
     C                   MOVE      ' '           FLAG
      ** DO NOT CHECK IF NOT LOT CONTROL
     C     IMLOTC        IFNE      'Y'
     C     VLOTC         OREQ      'Y'
     C     QTYORD        OREQ      OIQTAL
     C     QTYORD        OREQ      S_OIQTAL
     C     OHSTA         OREQ      'Y'
     C     FLAG          OREQ      'Y'
     C                   GOTO      ALOK
     C                   END
      ** GET AVAILABLE TO SELL
     C                   EXSR      GETAV
      *** CHECK IF ORDERED IS AVAILABLE AND IF NOT IF ENOUGH TIME
      *** TO CULTIVATE.
     C     QTYORD        IFGT      VAVAIL
     C     #QORID        ANDNE     'Y'
     C     IMSIZE        ANDNE     'TAG'
     C                   CALL      'GETAVAL'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    OIRVDT
     C**                   PARM           AVADAT  60
     C                   PARM                    AVDMDY            8 0
     C                   PARM                    ERCODE            1
     C                   PARM                    AVCOMM           30
     C                   PARM                    SESBEG            4 0
     C                   PARM                    SESEND            4 0
     C                   MOVEL     ERCODE        OOREAS
     C     ERCODE        IFEQ      '1'                                          --|
      /Free
        //  Get the substitute item
        //  This logic only executes if ERCODE = '1' so we don't need to compare dates
         AVSUBITEM = *Blanks;
         AVSUBSIZE = *Blanks;
         Exec SQL // Get Sub item
           Select AVSUBITEM, AVSUBSIZE
             into :AVSUBITEM, :AVSUBSIZE
             from FMAVDTE
            WHERE AVITEM = :IMITEM and AVSIZE = ' ' ;
         Exec SQL // Get Sub item / Size
           Select AVSUBITEM, AVSUBSIZE
             into :AVSUBITEM, :AVSUBSIZE
             from FMAVDTE
            WHERE AVITEM = :IMITEM and AVSIZE = :IMSIZE;
      /End-Free
     C                   SETON                                        51          |
     C                   SETOFF                                       5253        |
     C                   WRITE     SCRNCE                                         |
     C                   READ      SCRNCE                                 90      |
      ** SEE IF WE GET FROM SPEC
     C   KF              DO
     C                   Z-ADD     1             SPCL#             1 0
     C                   EXSR      SPCL
     C     FLAG          IFEQ      'Y'
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   KK              MOVEL     'Y'           #QORID                           |
     C   KK              EXSR      OUTOVR
     C   KK              GOTO      ALOK
     C  NKK              GOTO      NXTC                                           |
     C                   END                                                    --|
      ** CHECK IF OUT OF SEASON
     C     ERCODE        IFEQ      '2'                                          --||
     C     ERCODE        OREQ      '3'                                           -||
     C                   SETON                                        53          ||
     C                   SETOFF                                       5251        ||
     C                   WRITE     SCRNCE                                         ||
     C                   READ      SCRNCE                                 90      ||
      ** SEE IF WE GET FROM SPEC
     C   KF              DO
     C                   Z-ADD     2             SPCL#             1 0
     C                   EXSR      SPCL
     C     FLAG          IFEQ      'Y'
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   KK              MOVEL     'Y'           #QORID                           ||
     C   KK              EXSR      OUTOVR
     C   KK              GOTO      ALOK
     C  NKK              GOTO      NXTC                                           ||
     C                   ENDIF                                                  --||
     C     #QORID        IFNE      'Y'
     C                   CALL      'GETGERM'
     C                   PARM                    VITEM
     C                   PARM                    VSIZE
     C                   PARM                    VWHS
     C                   PARM                    RQYYMD
     C                   PARM                    SOWDAT            7 0
     C                   Z-ADD     SOWDAT        SWYYMD            7 0
     C     RQYYMD        IFGT      SWYYMD
     C                   Z-ADD     TDATEC        SOWDAT
     C* WJB              CALL      'GETRDY'
WJB  C                   CALL      'GETREADY'
     C                   PARM                    VITEM
     C                   PARM                    VSIZE
     C                   PARM                    VWHS
     C                   PARM                    SOWDAT
     C                   PARM                    NEWRDY            7 0
     C                   Z-ADD     NEWRDY        NWYYMD            7 0
     C     RQYYMD        IFLT      NWYYMD
     C                   SETOFF                                       5153
     C                   SETON                                        52
     C                   MOVE      '4'           OOREAS
     C                   WRITE     SCRNCE
     C                   READ      SCRNCE                                 90
      ** SEE IF WE GET FROM SPEC
     C   KF              DO
     C                   Z-ADD     3             SPCL#             1 0
     C                   EXSR      SPCL
     C     FLAG          IFEQ      'Y'
     C                   GOTO      ALOK
     C                   END
     C                   ENDDO
     C   KK              MOVEL     'Y'           #QORID
     C   KK              EXSR      OUTOVR
     C   KK              GOTO      ALOK
     C  NKK              GOTO      NXTC
     C                   END
     C                   END
     C                   END
     C                   END
      ** CHECK OVERRIDE
     C                   SETOFF                                       45

     C     ALOK          TAG
      ** SEE IF WE GET FROM SPEC
     C     VLOTC         IFEQ      'Y'
     C     FLAG          ANDNE     'Y'
     C     OHSTA         ANDNE     'Y'
     C     #QORID        ANDNE     'Y'
     C*    QTYORD        ANDNE     OIQTAL
     C     QTYORD        ANDNE     S_OIQTAL
     C                   Z-ADD     4             SPCL#             1 0
     C                   EXSR      SPCL
     C     FLAG          IFNE      'Y'
     C                   GOTO      NXTC
     C                   END
     C                   END
     C                   END
     C     VOVER         IFNE      'N'
     C     VOVER         ANDNE     'Y'
     C     VOVER         ANDNE     '1'
     C     VOVER         ANDNE     '2'
     C     VOVER         ANDNE     '3'
     C     VOVER         ANDNE     '4'
     C     VOVER         ANDNE     '5'
     C                   SETON                                        45
     C                   GOTO      NXTC
     C                   ENDIF
     C     VOVER         IFEQ      'Y'
     C                   GOTO      SKPPRI
     C                   END
     C     VOVER         IFGT      '0'
     C                   MOVE      VOVER         PRICD
     C                   ELSE
     C                   MOVE      OHPRCD        PRICD
     C                   END
     C                   EXSR      GETPRI

     C     SKPPRI        TAG
      ** CALC TAGS IF WANTED
     C   06
     CAN 01VTAGS         IFEQ      0
     C     FIRST         ANDEQ     0
     C                   EXSR      CALTAG
     C                   ENDIF
     C*  06 01   VTAGS     IFEQ 0
     C*                    SETOF                     06
     C*                    ENDIF
     C  N06
     CAN 01VTAGS         IFGT      0
     C                   SETON                                        06
     C                   ENDIF
     C                   ADD       1             FIRST
      ** GET EXTENSION
     C                   EXSR      #EXLN
     C                   Z-ADD     #LINNT        VEXT
     C     VITEM         IFNE      OITEM
     C     VSIZE         ORNE      OSIZE
     C     VWHS          ORNE      OWHS
     C     QTYORD        ORNE      OQTY
     C     VOVER         ORNE      OVOVER
     C     VUPRIC        ORNE      OUPRIC
     C     VDISC         ORNE      ODISC
     C     VREQDT        ORNE      OREQDT
     C     VEXT          ORNE      OEXT
     C                   MOVE      VITEM         OITEM            12
     C                   MOVE      VSIZE         OSIZE             3
     C                   MOVE      VWHS          OWHS              3
     C                   Z-ADD     QTYORD        OQTY              8 1
     C                   MOVE      VOVER         OVOVER            1
     C                   Z-ADD     VUPRIC        OUPRIC            9 4
     C                   Z-ADD     VDISC         ODISC             4 2
     C                   Z-ADD     VREQDT        OREQDT            6 0
     C                   Z-ADD     VEXT          OEXT              9 2
     C                   GOTO      NXTC
     C                   END
     C     ACTNCD        IFEQ      'C'
     C     VITEM         IFNE      OIITEM
     C     VSIZE         ORNE      OISIZE
     C     QTYORD        ORNE      OIQORD
     C     VREQDT        ORNE      OIDTRQ
     C                   EXSR      CHGALO
     C                   ENDIF
     C                   END
     C                   MOVEL     VITEM         OIITEM
     C                   MOVEL     VSIZE         OISIZE
     C                   MOVE      VWHS          OIWHSE
     C     OIMKEY        CHAIN     FMINVT                             90
     C                   MOVEL     IMDES1        OIDES1
     C                   MOVEL     IMDES2        OIDES2
     C                   MOVEL     IMPCL1        OIPRCL
     C                   MOVEL     IMLOOK        OIITMA
     C     QTYORD        SUB       ORGQTY        NETQTY           11 1
     C                   Z-ADD     VCO           OICOMP
     C                   MOVEL     IMBIN#        OIBIN#
     C     VUOM          IFEQ      IMPUOM
     C                   MOVEL     VUOM          OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   END
     C     VUOM          IFEQ      IMSUOM
     C                   MOVEL     VUOM          OIUUOM
     C                   Z-ADD     IMMULT        OIMULT
     C                   END
     C     VUOM          IFEQ      IM3UOM
     C                   MOVEL     VUOM          OIUUOM
     C                   Z-ADD     IMMUL2        OIMULT
     C                   END
     C                   Z-ADD     IMUWGT        OIUWGT
     C                   Z-ADD     IMUCST        OIUCST
     C                   Z-ADD     VUPRIC        OIUPRI
     C                   Z-ADD     VDISC         OIQDDC
     C                   Z-ADD     VEXT          OIEXT$
     C                   Z-ADD     QTYORD        OIQORD
     C                   Z-ADD     0             OIAMT1
     C                   Z-ADD     0             OIAMT2
     C                   Z-ADD     0             OIAMT3
     C                   Z-ADD     #LINDS        OIDISC
     C                   MOVE      VOVER         OIOVER
     C                   MOVEL     VLOTC         OILOTC
     C                   MOVE      OHBOCD        OIBOCD
     C                   MOVE      OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVE      OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     VREQDT        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     OHTRDC        OITRDC
     C                   MOVEL     OHCOFL        OICOFL
     C                   MOVEL     LINTYP        OIITYP
     C     OHTXST        IFEQ      'Y'
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   ELSE
     C                   MOVEL     IMTXBL        OITXCD
     C                   MOVE      IMTCD1        OITXST
     C                   MOVE      IMTCD2        OITXCT
     C                   MOVE      IMTCD3        OITXLC
     C                   END
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     'N'           OICWT
     C                   Z-ADD     0             OILBS#
     C                   Z-ADD     0             OIWGSH
     C                   MOVE      ' '           OIRSCD
     C                   Z-ADD     0             OISEQP
     C                   MOVE      ' '           OIPRAL
     C                   MOVE      IMBPUM        OIBPUM
     C                   MOVE      VUOM          OISUOM
     C                   MOVE      VUOM          OIBLUM
     C                   Z-ADD     0             OIMUL2
     C***                  MOVELOHLOTC    OILOTC
     C                   MOVEL     OHSTA         OISTA
     C                   MOVEL     OHSHFR        OISHFR
     C                   Z-ADD     VTAGS         OITAGS
EFD02C***                  MOVEL'Y'       OIPPDC
     C** 74                MOVEL'Y'       OIPPDC
     C**N74                MOVEL'N'       OIPPDC
     C                   Z-ADD     OHDTCN        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVCD
     C                   MOVEL     OHQUOT        OIQTE
     C                   Z-ADD     OHORDT        OIORDT
     C                   Z-ADD     VREQDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVE      *BLANKS       OILOT#
     C                   MOVE      'N'           OIFRQD
     C                   MOVE      ' '           OISPFL
     C                   MOVEL     OHALPH        OIALPH
     C*                    MOVE *BLANKS   OIPRCL
     C                   MOVE      *BLANKS       OINPSL
     C                   Z-ADD     0             OIRQTY
     C                   MOVE      ' '           OIPOST
     C     OILOTC        IFEQ      'Y'
     C                   Z-ADD     0             OISOW
     C                   ELSE
     C                   CALL      'GETGERM'
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIRVDT
     C                   PARM                    SOWDAT
     C     ACTNCD        IFEQ      'C'
     C     SOWDAT        ANDEQ     OISOW
     C                   GOTO      SKPSOW
     C                   ENDIF
     C                   Z-ADD     SOWDAT        OISOW
     C                   MOVE      'N'           OIPOST

     C     SKPSOW        TAG
     C                   END
     C     ACTNCD        IFEQ      'A'
     C     ACTNCD        OREQ      'I'
     C                   MOVE      'A'           OISTAT
     C     ACTNCD        IFEQ      'A'
     C                   ADD       2             LSTSEQ
     C                   Z-ADD     LSTSEQ        OISEQ#
     C                   ELSE
     C                   Z-ADD     LINE          OISEQ#
     C                   END
      /Free
         //C                   MOVEL     OISEQ#        OILIST
       OILIST = %Char(OISEQ#);

       Exec SQL
         insert into WSORCHCPF
          (select
            OCFRORID
          , OCBRKORID
          , OCPOSEQ
          , OCBRKSLD
          , OCBRKSHP
          , OCCUST
          , OCORDNO
          , :OISEQ#  as OCORDLIN
          , 0        as OCBRKLNE
          , ' '      as OCBRKMAT
          , :OIITEM  as OCITEM
          , :OISIZE  as OCIMSZE
          , 'Y'      as OCORFLG
          , ' '      as OCORMSGID
          , 'This Line Added by Kube-Pak'
                     as OCORMSGD
          , (month(current date) * 10000) +
            (day(current date) * 100) +
            (year(current date) - 2000)
                     as OCCRTDAT
          , (hour(current time) * 10000) +
            (minute(current time) * 100) +
             second(current time)
                     as OCCRTTIM
          , user     as OCCRTUSR
          , :JOBID   as OCCRTJOB
          , :PROGID  as OCCRTPGM
          , 0        as OCUPDDAT
          , 0        as OCUPDTIM
          , ' '      as OCUPDUSR
          , ' '      as OCUPDJOB
          , ' '      as OCUPDPGM
          from WSORCHCPF
          where OCORDNO = :OIORD#
          Order by OCPOSEQ Desc
          Fetch first Row only);

      /End-Free
     C     IMLOTC        IFNE      'Y'
     C                   UNLOCK    FMINVT
     C                   Z-ADD     QTYORD        NEWQTY
     C                   Z-ADD     0             OLDQTY
     C                   CALL      'ALOCATE'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    OHCOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   ELSE
     C                   Z-ADD     TDATE         IMDTLO
     C  N90              UPDATE    RMINVT
     C                   Z-ADD     NETQTY        QTY
     C                   Z-ADD     0             QTYA
     C                   Z-ADD     VORDER        OIORD#
      ** 9/02/96
     C     OISOW         IFGT      0
     C                   Z-ADD     OISOW         ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
      ** ONLY ALLOCATE IF PAST SOW WEEK
     C     ##DDD         IFLT      LSTWK
     C                   EXSR      ALLO
     C                   END
     C                   END
     C                   END
      **** OUTPUT IORDR RECORD
     C                   Z-ADD     VORDER        OIORD#
      ** GET ROYALTY
     C  N90              EXSR      ROYAL
     C  N90              Z-ADD     ORUPRI        OIROY
     C     VINVCD        IFEQ      'N'
     C                   MOVE      'N'           OISHCD
     C                   MOVE      'N'           OIPLPT
     C                   Z-ADD     0             OIQINV
     C                   Z-ADD     0             OIQSHP
     C                   MOVEL     OHPHYT        OIPHYT
     C                   ELSE
     C                   MOVE      'Y'           OISHCD
     C                   MOVE      'Y'           OIPLPT
     C                   MOVEL     OHPHYT        OIPHYT
     C                   Z-ADD     QTYORD        OIQINV
     C                   Z-ADD     QTYORD        OIQSHP
     C                   END
     C                   MOVEL     OHSHPC        OISHPC
     C                   Z-ADD     0             OIINV#
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     QTYA          OIQTAL
     C                   MOVE      ' '           OIOPFL
     C                   MOVE      ' '           OIBOLN
     C                   Z-ADD     0             OIBORQ
     C                   MOVE      ' '           OIPRBO
     C                   MOVE      'N'           OISCHM
     C                   MOVE      'N'           OISCHS
     C                   Z-ADD     0             OIQINV
     C                   Z-ADD     OISEQ#        SEQ##             3 0
     C     T84           IFEQ      'Y'
     C                   Z-ADD     OISOW         CDNSOW
     C                   Z-ADD     OIRVDT        CDNREQ
     C                   Z-ADD     OIQORD        CDNQTY
WJB  C     VendKey       Chain     FMINVTVD
WJB  C                   If        %Found(FMINVTVD)
WJB  C                   Z-ADD     VDIMVEND      CDVEND
WJB  C                   EndIf
     C                   WRITE     RCUTDEL
     C                   END
     C                   WRITE     RIORDR
     C                   ELSE
     C**************       MOVELIMLOOK    OIITMA
     C**************       ADD  QTYA      OIQTAL
     C                   Z-ADD     OISEQ#        SEQ##             3 0
     C     T84           IFEQ      'Y'
     C     OISOW         IFNE      CDOSOW
     C     OIRVDT        ORNE      CDOREQ
     C     OIQORD        ORNE      CDOQTY
     C                   Z-ADD     OISOW         CDNSOW
     C                   Z-ADD     OIRVDT        CDNREQ
     C                   Z-ADD     OIQORD        CDNQTY
WJB  C     VendKey       Chain     FMINVTVD
WJB  C                   If        %Found(FMINVTVD)
WJB  C                   Z-ADD     VDIMVEND      CDVEND
WJB  C                   EndIf
     C                   WRITE     RCUTDEL
     C                   END
     C                   END
     C                   Eval      OIQTAL = S_OIQTAL
WJB   /Free
 |      If B2BCOMMENT <> OLDCOMMENT and B2BCOMMENT <> *Blanks;
 |        Exec SQL
 |          INSERT INTO FIORDRB2BC
 |          VALUES(:VORDER,:LINE,:B2BCOMMENT,current timestamp,current user);
 |      ENDIF;
 |      If B2BCOMMENT = *Blanks;
 |        Exec SQL
 |          DELETE FIORDRB2BC
 |          WHERE B2BORD# = :VORDER and B2BSEQ# = :LINE;
 |      ENDIF;
WJB   /End-Free
     C                   UPDATE    RIORDR
     C                   END
      ** GET REPRINT
     C     RPPCK         IFEQ      'Y'
     C     OHORD#        CHAIN     FORDCHG                            94
     C   94              WRITE     RORDCHG
     C  N94              UPDATE    RORDCHG
     C                   END
     C                   EXSR      BLDSFL
     C                   MOVE      *BLANKS       OITEM
     C                   MOVE      *BLANKS       OSIZE
     C                   MOVE      *BLANKS       OWHS
     C                   Z-ADD     0             OQTY
     C                   MOVE      *BLANKS       OVOVER
     C                   Z-ADD     0             OUPRIC
     C                   Z-ADD     0             ODISC
     C                   Z-ADD     0             OREQDT
     C                   Z-ADD     0             OEXT
     C                   Z-ADD     0             VAVAIL
     C                   SETOFF                                       747640
     C                   Z-ADD     0             FIRST             5 0
     C                   MOVE      *BLANKS       #QORID            1
     C                   GOTO      NXTC
      *

     C     END           TAG
     C                   SETON                                        LR
      /EJECT
      **************************
      * BACK ORDER THIS LINE   *
      **************************
     C     BCKORD        BEGSR
     C     LINTYP        IFEQ      ' '
     C     ITCKEY        CHAIN(N)  FMINVT                             31
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        VDESC
     C                   END
     C                   Z-ADD     OIUPRI        VUPRIC
     C                   Z-ADD     OIEXT$        VEXT
     C                   Z-ADD     OIQORD        QTYORD
     C*                  Z-ADD     OIDTRQ        VREQDT

     C     NXBCKO        TAG
     C                   SETON                                        59
     C                   EXFMT     ORDCTL
     C                   SETOFF                                       2476
     C   KF              GOTO      ENBCKO
      ** CHECK DATE
     C                   Z-ADD     VREQDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                          24
     C                   END
     C   24              GOTO      NXBCKO
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C     #Y            IFNE      1
     C     IMLOTC        ANDEQ     'Y'
     C                   SETON                                        2476
     C                   GOTO      NXBCKO
     C                   END
      ** IF HERE DATE OK
     C     VREQDT        IFNE      OIDTRQ
     C     OIPRBO        IFNE      'B'
     C                   Z-ADD     OIDTRQ        OIBORQ
     C                   END
     C                   MOVEL     'B'           OIBOLN
     C                   Z-ADD     VREQDT        OIDTRQ
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   UPDATE    RIORDR
      **2/18/13 added logic here to change AISHPD on FALITEM record to match new ship date.
     C     ALIKEY        Chain     FALITEM
     C                   If        %Found(FALITEM)
     C                   Eval      AISHPD = OIRVDT
     C                   Update    RALITEM
     C                   EndIf
      ** GET REPRINT
     C     RPPCK         IFEQ      'Y'
     C     OHORD#        CHAIN     FORDCHG                            94
     C   94              WRITE     RORDCHG
     C  N94              UPDATE    RORDCHG
     C                   END
     C                   END
     C     ENBCKO        ENDSR
      /EJECT
      *?  ...........................................................
      *?  :      ADJLIN - ADJUST THIS LINE                          :
      *?  :.........................................................:
     C     ADJLIN        BEGSR
     C                   ExSr      LoadDesc
     C                   ExSr      $ClrError
     C     VSIZE         CHAIN     FMSIZE                             90
     C                   Z-ADD     SZSALE        SALBLE
      *    Prompt user for number of good cells in flat to be adjusted.
     C                   SETOFF                                       15
     C                   Z-ADD     0             HOLDGD
     C                   Z-ADD     0             GOODCL

     C                   If        SALBLE < 2
     C                   Eval      $ERR_MsgID = 'OE10001'
     C                   Eval      $ERR_MsgData = %Char(SALBLE)
     C                   ExSr      $SndError
    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C                   Write     MSGCTL                                       ?Error Messages
     C                   ExFmt     SCRNJ
     C                   ExSr      $ClrError
     C                   LeaveSr
     C                   EndIF

     C     NEXTJ         TAG
    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C                   Write     MSGCTL                                       ?Error Messages
     C                   EXFMT     SCRNJ
     C                   ExSr      $ClrError
     C                   Eval      *In15 = *Off
      *    Edit User response
     C                   If        *InKL
     C                   LeaveSR
     C                   EndIF

     C     GOODCL        IFLE      0
     C                   Eval      $ERR_MsgID = 'OE10003'
     C                   Eval      $ERR_MsgData = %Char(SALBLE)
     C                   ExSr      $SndError
     C                   GOTO      NEXTJ
     C                   ENDIF

     C     GOODCL        IFGE      SALBLE
     C                   Eval      $ERR_MsgID = 'OE10002'
     C                   Eval      $ERR_MsgData = %Char(SALBLE)
     C                   ExSr      $SndError
     C                   GOTO      NEXTJ
     C                   ENDIF

     C     GOODCL        IFNE      HOLDGD
     C     GOODCL        DIV       SALBLE        WORK33            3 3
     C     WORK33        MULT      100           WORK31            3 1
     C     100           SUB       WORK31        DISCNT
     C                   SETON                                        15
WJB  C*    WORK33        MULT      VUPRIC        NEWPRC
WJB  C     WORK33        MULT      OIUPRI        NEWPRC
     C                   Eval      NEWPRC = %Int(Work33*OIUPRI*100)/100
     C                   Z-ADD     GOODCL        HOLDGD            3 0
     C                   GOTO      NEXTJ
     C                   ENDIF
     C*                  Z-ADD     OIUPRI        VUPRIC
     C*                  Z-ADD     OIEXT$        VEXT
     C*                  Z-ADD     OIQORD        QTYORD
     C*                  Z-ADD     OIDTRQ        VREQDT
      *    Deduct 1 from order quantity of original line
     C                   SUB       1             OIQORD
     C                   Eval      OIDTLA  = $MDYDate($Date(0))
     C                   Eval      OITIME  = $Now()
     C                   Eval      OIUSER  = $User()
     C                   Eval      OIEXT$ = OIQORD * OIUPRI
     C*                  If        OIQORD <= *Zero
     C*                  Eval      OISTAT  = 'D'
     C*                  Eval      OICOFL  = 'Y'
     C*                  EndIf
     C*                  UPDATE    RIORDR
WJB19C                   If        OIQORD <= *Zero
WJB19C                   Eval      PARTSEQ# = OISEQ#
WJB19C                   DELETE    RIORDR
WJB19C                   else
WJB19C                   Eval      PARTSEQ# = OISEQ# + 2
WJB19C                   UPDATE    RIORDR
WJB19C                   EndIf
      *  Create space for new line
     C                   Eval      Line = OISEQ#
     C                   ExSr      InsLineSR
      *    Deduct 1 from original FALITEM item record and write new record.
     C     ALIKEY        CHAIN     FALITEM                            90
     C                   If        %Found(FALITEM)
     C                   Eval      AIQTOA = AIQTOA - 1
     C                   Eval      AIDTLA = $MDYDate($Date(0))
     C                   Eval      AITIME = $Now()
     C                   Eval      AIUSER = $User()
     C                   Update    RALITEM
     C* WJB              If        WORK31 >= 75
     C                   Eval      AIOSEQ = OISEQ# + 2
     C                   Eval      AIQTOA = 1
     C                   Write     RALITEM
     C* WJB              EndIf
     C                   EndIf
      *    Copy original Line to New Line
WJB19C*                  ADD       2             OISEQ#
WJB19C                   eval      OISEQ# = PARTSEQ#
      *    Change new line quantity to 1.
     C                   Z-ADD     1             OIQORD
      *    Change price on new line to a proprated value of ($*Good/Saleable)
     C                   Z-ADD     NEWPRC        OIUPRI
     C                   Z-ADD     NEWPRC        OIEXT$
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   Eval      OIOVER = 'Y'
     C                   Eval      OISTAT = 'A'
     C                   Eval      OICOFL = 'N'
     C                   WRITE     RIORDR
      *    Change Description to read (xxx of yyy)
     C                   Eval      OIPCTF = (GoodCL*100/SALBLE)
    ?C                   Write     RIORDRPART                                   ?Clear Err Messages
     C                   Eval      Line = OISEQ#
     C                   ExSr      InsLineSR
     C                   Eval      Comment = 'Adj: (' + %Char(GoodCL) +
     C                              ' of ' + %Char(SALBLE) +
     C                              ') Disc: ' + %EditW(DISCNT:'   . %')
     C                   ExSr      CrtComment
     C     RPPCK         IFEQ      'Y'
     C     OHORD#        CHAIN     FORDCHG                            94
     C   94              WRITE     RORDCHG
     C  N94              UPDATE    RORDCHG
     C                   END
     C                   ENDSR
      /EJECT
      *?  ...........................................................
      *?  :      RESLIN - ReSow this Line                           :
      *?  :.........................................................:
     C     RESLIN        BEGSR
     C                   ExSr      LoadDesc
      *    Prompt user for date the resow will be ready.
     C                   Eval      ##SOW = $Date7($Monday($Date(0):'SAT'))
     C                   CALL      'GETSHIP'
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    ##SHIP            7 0          CYMD
     C                   PARM                    ##SOW             7 0          CYMD
     C* Old Resow Date   Eval      ResowDate =
     C*                            $MDYDate($AddDate($DateMDY(VREQDT):21))
     C                   Eval      ResowDate = $MDYDate($Date(##SHIP))
     C                   Eval      EarlyDate = ResowDate
     C                   Eval      RESOWQTY = QTYORD

     C     NEXTK         TAG
    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C                   Write     MSGCTL                                       ?Error Messages
     C                   EXFMT     SCRNK
     C                   ExSr      $ClrError
      *    Edit User response
     C                   If        *InKL
     C                   LeaveSR
     C                   EndIF

     C                   IF        RESOWQTY <= *Zero
     C                   Eval      $ERR_MsgID = 'QTY0001'
     C                   Eval      $ERR_MsgData = 'Resow'
     C                   ExSr      $SndError
     C                   GOTO      NEXTK
     C                   ENDIF

     C                   If        RESOWQTY > QTYORD
     C                   Eval      $ERR_MsgID = 'QTY0002'
     C                   Eval      %SubSt($ERR_MsgData:01:12) = 'Resow'
     C                   Eval      %SubSt($ERR_MsgData:13:12) = 'Order'
     C                   Eval      %SubSt($ERR_MsgData:25:15) =
     C                             %EditC(QTYORD:'4')
     C                   ExSr      $SndError
     C                   GOTO      NEXTK
     C                   ENDIF

     C     RESOWDATE     IFLE      0
     C                   Eval      $ERR_MsgID = 'DATE902'
     C                   Eval      $ERR_MsgData = 'Resow'
     C                   ExSr      $SndError
     C                   GOTO      NEXTK
     C                   ENDIF

     C                   IF        not $isDate#(RESOWDATE:'*MDY')
     C                   Eval      $ERR_MsgID = 'DATE901'
     C                   Eval      $ERR_MsgData = %Char(RESOWDATE)
     C                   ExSr      $SndError
     C                   GOTO      NEXTK
     C                   ENDIF

     C                   IF        $Monday($DateMDY(RESOWDATE):'MON')
     C                             <> $DateMDY(RESOWDATE)
     C                   Eval      $ERR_MsgID = 'DATE904'
     C                   Eval      $ERR_MsgData = %EditW(RESOWDATE:'  /  /  ')
     C                   Eval      RESOWDATE=
     C                             $MDYDate($Monday($DateMDY(RESOWDATE):'MON'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(RESOWDATE:'  /  /  ')
     C                   ExSr      $SndError
     C                   GOTO      NEXTK
     C                   ENDIF

      *?  If the Ship Date is less than the earliest calculated reselect date
     C                   IF        $DateMDY(RESOWDATE) < $Date(##SHIP)
     C                   Eval      $ERR_MsgID = 'BIR1001'
     C                   Eval      $ERR_MsgData = %EditW(EARLYDATE:'  /  /  ')
     C                   ExSr      $SndError
     C                   GOTO      NEXTK
     C                   ENDIF

      **2/18/2013 Instead of this, use the LOT_TRN_N program
      *    Update original Line to Available quantity
del->C* wjb 2/18/13      Eval      OIQORD = OIQORD - RESOWQTY
del->C* wjb 2/18/13      Eval      OIEXT$ = OIQORD * OIUPRI
del->C* wjb 2/18/13      Eval      OrigOIDTRQ = OIDTRQ
del->C* wjb 2/18/13      Update    RIORDR
wjb  C                   UnLock    FIORDR
     C                   Eval      OrigOIDTRQ = OIDTRQ
wjb  C                   CALL      'LOT_TRN_N'
wjb  C                   Parm      OIORD#        N_ORDER           6 0
wjb  C                   Parm      OISEQ#        N_SEQ#            3 0
wjb  C                   Parm                    N_990Item        12
wjb  C                   Parm                    N_990Size         3
wjb  C                   Parm                    N_990CRDY         7 0
wjb  C                   Parm                    N_990SOWD         7 0
wjb  C                   Parm                    N_990SHPD         7 0
wjb  C                   Parm      RESOWQTY      N_QTY             6 0
wjb  C                   Parm      'N'           N_COMMENT         1
      *?     Get the new sow date
     C                   Eval      ##SHIP = $Date7($DateMDY(ResowDate))
     C                   CALL      'GETGERM'
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    ##SHIP            7 0          CYMD
     C                   PARM                    ##SOW             7 0          CYMD
      *    Insert a New Line with Resow quantity
     C                   Eval      Line = OISEQ#
     C                   ExSr      InsLineSR
     C                   Eval      OISEQ#  = OISEQ# + 2
     C                   Eval      OIQORD  = RESOWQTY
     C                   Eval      OIEXT$  = RESOWQTY * OIUPRI
     C                   Eval      OIDTRQ  =  ResowDate                         REQ SHIP DATE
     C                   Eval      OIRVDT  = $Date7($DateMDY(ResowDate))        REQ SHIP DATE CYMD
     C                   Eval      OIORDT  = ResowDate                          ORG SHIP DATE CYMD
     C                   Eval      OIRVCD  = $Date7($DateMDY(ResowDate))        Expire Date
     C                   Eval      OISOW   = ##SOW                              Sow Date
     C                   Eval      OIPOST  = 'N'                                Post Flag
     C                   Eval      OIDTLA  = $MDYDate($Date(0))                 LAST ACTIVITY DATE
     C                   Eval      OITIME  = $Now()                             TIME
     C                   Eval      OIUSER  = $User()                            USER
WJB  C                   Eval      OILOTC  = 'N'                                Mark Lot Control =N
WJB  C                   Eval      OILOT#  = *Blanks                            Clear Lot Number
     C                   WRITE     RIORESOW
     C                   WRITE     RIORDR
      *    Change Description to read (RESOW: original ship was mm/dd/yy)
     C                   Eval      Comment = 'RESOW: original ship was '
     C                             + %Char($Month($DateMDY(OrigOIDTRQ))) + '/'
     C                             + %Char($Day($DateMDY(OrigOIDTRQ)))
     C                   Eval      Line = OISEQ#
     C                   ExSr      InsLineSR
     C                   ExSr      CrtComment
     C     RPPCK         IFEQ      'Y'
     C     OHORD#        CHAIN     FORDCHG                            94
     C   94              WRITE     RORDCHG
     C  N94              UPDATE    RORDCHG
     C                   END
     C                   ENDSR
      /EJECT
      *?  ...........................................................
      *?  :      PRTLIN - Partial Line                              :
      *?  :.........................................................:
     C     PRTLIN        BEGSR
     C                   ExSr      LoadDesc
      *    Prompt user for quantity Available and a date for availablility of balance
     C                   Z-ADD     0             AVAILABLE
     C                   Z-ADD     0             HoldAVAIL
     C                   Eval      BACKDATE =
     C                             $MDYDate($AddDate($DateMDY(VREQDT):21))

     C                   ExSr      $ClrError

     C     NEXTL         TAG
    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C                   Write     MSGCTL                                       ?Error Messages
     C                   EXFMT     SCRNL
     C                   ExSr      $ClrError

      *    Edit User response
     C                   If        *InKL
     C                   LeaveSR
     C                   EndIF

     C     AVAILABLE     IFLE      0
     C                   Eval      $ERR_MsgID = 'QTY0001'
     C                   Eval      $ERR_MsgData = 'Available'
     C                   ExSr      $SndError
     C                   GOTO      NEXTL
     C                   ENDIF

     C     AVAILABLE     IFGE      QTYORD
     C                   Eval      $ERR_MsgID = 'QTY0002'
     C                   Eval      %SubSt($ERR_MsgData:01:12) = 'Available'
     C                   Eval      %SubSt($ERR_MsgData:13:12) = 'Order'
     C                   Eval      %SubSt($ERR_MsgData:25:15) =
     C                             %EditC(QTYORD:'4')
     C                   ExSr      $SndError
     C                   GOTO      NEXTL
     C                   ENDIF

     C     BACKDATE      IFLE      0
     C                   Eval      $ERR_MsgID = 'DATE902'
     C                   Eval      $ERR_MsgData = 'Backorder'
     C                   ExSr      $SndError
     C                   GOTO      NEXTL
     C                   ENDIF

     C                   IF        not $isDate#(BACKDATE:'*MDY')
     C                   Eval      $ERR_MsgID = 'DATE901'
     C                   Eval      $ERR_MsgData = %Char(BACKDATE)
     C                   ExSr      $SndError
     C                   GOTO      NEXTL
     C                   ENDIF

     C                   IF        $Monday($DateMDY(BACKDATE):'MON')
     C                             <> $DateMDY(BACKDATE)
     C                   Eval      $ERR_MsgID = 'DATE904'
     C                   Eval      $ERR_MsgData = %EditW(BACKDATE:'  /  /  ')
     C                   Eval      BACKDATE =
     C                             $MDYDate($Monday($DateMDY(BACKDATE):'MON'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(BACKDATE:'  /  /  ')
     C                   ExSr      $SndError
     C                   GOTO      NEXTL
     C                   ENDIF

      *    Passed Edit
     C                   Eval      Balance = OIQORD - AVAILABLE

      *    Update original Line to Available quantity
     C                   Eval      OIQORD = AVAILABLE
     C                   Eval      OIEXT$ = AVAILABLE * OIUPRI
     C                   Update    RIORDR
      **2/18/2013 Update FALITEM record with new quantity
WJB  C     ALIKEY        Chain     FALITEM
WJB  C                   If        %Found(FALITEM)
WJB  C                   Eval      AIQTOA = OIQORD
WJB  C                   Eval      AIDTLA = $MDYDate($Date(0))
WJB  C                   Eval      AITIME = $Now()
WJB  C                   Eval      AIUSER = $User()
WJB  C                   Update    RALITEM
WJB  C                   EndIf
      *    Insert a New Line with Backorder quantity
     C                   Eval      LINE = OISEQ#
     C                   ExSr      InsLineSR
     C                   Eval      OISEQ# = OISEQ# + 2
     C                   Eval      OIQORD = Balance
     C                   Eval      OIEXT$ = Balance * OIUPRI
     C                   Eval      OIBOLN    =  'B'                             LINE ITEM PUT ON BO
     C                   Eval      OIBORQ    =  OIDTRQ                          ORIG B/O REQ SHIP DA
     C                   Eval      OIDTRQ    =  BackDate                        REQ SHIP DATE
     C                   Eval      OIRVDT    = $Date7($DateMDY(BackDate))       REQ SHIP DATE CYMD
     C                   Eval      OIDTLA  = $MDYDate($Date(0))                 LAST ACTIVITY DATE
     C                   Eval      OITIME  = $Now()                             TIME
     C                   Eval      OIUSER  = $User()                            USER
     C                   Write     RIORDR
      **2/18/2013 Write New RALITEM with Backorder Quantity and new AISHPD
WJB  C                   If        %Found(FALITEM)
WJB  C                   Eval      AIOSEQ = OISEQ#
WJB  C                   Eval      AISHPD = OIRVDT
WJB  C                   Eval      AIQTOA = Balance
WJB  C                   Write     RALITEM
WJB  C                   EndIf
     C     RPPCK         IFEQ      'Y'
     C     OHORD#        CHAIN     FORDCHG                            94
     C   94              WRITE     RORDCHG
     C  N94              UPDATE    RORDCHG
     C                   END
     C                   ENDSR
      /EJECT
      *?  ...........................................................
      *?  :      NAGLIN - Not Available Germination - Poor Germ     :
      *?  :.........................................................:
     C     NAGLIN        BEGSR
     C                   ExSr      LoadDesc
      *    Prompt user for how many items are N/A due to poor Germ.
     C                   Z-ADD     OIQORD        NotAvail

     C     NEXTM         TAG
     C                   EXFMT     SCRNM
     C                   If        *InKL
     C                   LeaveSR
     C                   EndIF

     C     NotAvail      IFLE      0
     C                   Eval      $ERR_MsgID = 'QTY0001'
     C                   Eval      $ERR_MsgData = 'Not Available'
     C                   ExSr      $SndError
     C                   GOTO      NEXTM
     C                   ENDIF

     C     NotAvail      IFGT      OIQORD
     C                   Eval      $ERR_MsgID = 'QTY0002'
     C                   Eval      %SubSt($ERR_MsgData:01:12) = 'Not Avail.'
     C                   Eval      %SubSt($ERR_MsgData:13:12) = 'Order'
     C                   Eval      %SubSt($ERR_MsgData:25:15) =
     C                             %EditC(QTYORD:'4')
     C                   ExSr      $SndError
     C                   GOTO      NEXTM
     C                   ENDIF

     C     NA_REASON     IFLT      '0'
     C     NA_REASON     ORGT      '3'
     C                   Eval      $ERR_MsgID = 'BIR1002'
     C                   Eval      $ERR_MsgData = ''
     C                   ExSr      $SndError
     C                   GOTO      NEXTM
     C                   ENDIF

      *    Passed Edit
      **2/182013  PUT LOT_TRN_N Here...
     C                   Unlock    FIORDR
wjb  C                   CALL      'LOT_TRN_N'
wjb  C                   Parm      OIORD#        N_ORDER           6 0
wjb  C                   Parm      OISEQ#        N_SEQ#            3 0
wjb  C                   Parm                    N_990Item        12
wjb  C                   Parm                    N_990Size         3
wjb  C                   Parm                    N_990CRDY         7 0
wjb  C                   Parm                    N_990SOWD         7 0
wjb  C                   Parm                    N_990SHPD         7 0
wjb  C                   Parm      NOTAVAIL      N_QTY             6 0
wjb  C                   Parm      NA_REASON     N_COMMENT         1
      *    Change order quantity on original line to Order - NotAvail
     C* WJBLINKEY        CHAIN     FIORDR                             90
     C* WJB              Eval      OrigOIQORD = OIQORD
     C* WJB              Eval      OIQORD = OIQORD - NotAvail                   QTY ORDERED
     C* WJB              Eval      OIEXT$ = OIQORD * OIUPRI                     EXT AMOUNT
     C* WJB              Eval      OIDTLA  = $MDYDate($Date(0))                 LAST ACTIVITY DATE
     C* WJB              Eval      OITIME  = $Now()                             TIME
     C* WJB              Eval      OIUSER  = $User()                            USER
     C* WJB              IF        OILOTC = 'Y'
     C* WJB              Call      'GETLOT'
     C* WJB              PARM                    OHORD#
     C* WJB              PARM                    OISEQ#
     C* WJB              PARM                    VREQDT
     C* WJB              PARM                    VITEM
     C* WJB              PARM                    VSIZE
     C* WJB              PARM                    OIWHSE
     C* WJB              PARM      OIQORD        QTYO
     C* WJB              PARM      OrigOIQORD    QTYA
     C* WJB              PARM      ' '           FLAG                           V=Remove Onhand
     C* WJB              If        Flag = 'N'
     C* WJB              LeaveSR
     C* WJB              Else
     C* WJB              Z-ADD     QTYA          OIQTAL
     C* WJB              Z-ADD     QTYA          S_OIQTAL
     C* WJB              ENDIF
     C* WJB              ENDIF
     C* WJB              UPDATE    RIORDR
      *    Insert a Comment Line
     C* WJB              Eval      Comment = 'Poor Germ: ('
     C* WJB                        + %Char(NotAvail) + ' of '
     C* WJB                        + %Char(OrigOIQORD) + ') N/A'
     C* WJB              ExSr      InsLineSR
     C* WJB              ExSr      CrtComment
     C     RPPCK         IFEQ      'Y'
     C     OHORD#        CHAIN     FORDCHG                            94
     C   94              WRITE     RORDCHG
     C  N94              UPDATE    RORDCHG
     C                   END
     C                   ENDSR
      /EJECT
      *?  ...........................................................
      *?  :      LoadDesc - Load Description for New Action Codes   :
      *?  :.........................................................:
     C     LOADDESC      BEGSR
     C     LINKEY        Chain     FIORDR
     C     LINTYP        IFEQ      ' '
     C     ITCKEY        CHAIN(N)  FMINVT                             31
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        VDESC
     C                   END
     C                   ENDSR
      /EJECT
      *?  ...........................................................
      *?  :      InsLineSR - Insert Line in Order Subroutine        :
      *?  :.........................................................:
     C     InsLineSR     BEGSR
      *    Inserts 2 Lines After Current Line
     C                   Eval      Line1 = LINE + 1
      /Free
       BIR104(VORDER:LINE1:2);
      /End-Free
     C                   ENDSR
      /EJECT
      *?  ...........................................................
      *?  :      CrtComment - Create a Comment Line in Order        :
      *?  :.........................................................:
      *       Creates a comment line based on the current item.
     C     CrtComment    BEGSR
     C                   Eval      SaveSeq# = OISEQ# + 2
     C                   Eval      SaveOIITEM = OIITEM
     C                   Eval      SaveOISIZE = OISIZE
     C                   Eval      SaveOIRVCD = OIRVCD
     C                   Eval      SaveOIDTRQ = OIDTRQ
     C                   Eval      SaveOIRVDT = OIRVDT
     C                   Eval      SaveOIALPH = OIALPH
     C                   Eval      SaveOIITMA = OIITMA
     C                   Eval      SaveText = OIPLPT                            01
     C                                      + OITXCD                            02
     C                                      + OITXST                            03
     C                                      + OITXCT                            04
     C                                      + OITXLC                            05
     C                                      + OIROUT                            06
     C                                      + ' '                               07
     C                                      + OICWT                             08
     C                                      + OIPPDC                            09
     C                                      + OIPHYT                            10
     C                                      + OISCHM                            11
     C                                      + OISCHS                            12
     C                                      + OIFRQD                            13
     C                   Clear                   RIORDR
     C                   Eval      OIITEM = SaveOIITEM                          ITEM
     C                   Eval      OISIZE = SaveOISIZE                          SIZE
     C                   Eval      OIITMA = SaveOIITMA                          ITEM ALPHA SEARCH
     C                   Eval      OISTAT = 'A'                                 STATUS
     C                   Eval      OIORD# = VORDER                              ORDER NUMBER
     C                   Eval      OISEQ# = SaveSeq#                            SEQ NUMBER
     C                   Eval      OICOMP = 1                                   COMPANY #
     C                   Eval      OISHPC = OHSHPC                              SHIP VIA CODE
     C                   Eval      OISHCD = 'N'                                 SHIP RELEASE CODE
     C                   Eval      OIOVER = '5'                                 OVERRIDE CODE
     C                   Eval      OIBOCD = 'Y'                                 ITEM B/O ALLOWED
     C                   Eval      OISLM1 = '01'                                SALESPERSON 1
     C                   Eval      OICUST = OHCUST                              CUSTOMER #
     C                   Eval      OIDTRQ = ResowDate                           REQ SHIP DATE
     C                   Eval      OIDTLA = $MDYDate($Date(0))                  LAST ACTIVITY DATE
     C                   Eval      OITIME = $Now()                              TIME
     C                   Eval      OIUSER = $User()                             USER
     C                   Eval      OIITYP = 'C'                                 ITEM TYPE
     C                   Eval      OILIST = *Blanks
     C                   Eval      OIPLPT = %SubSt(SaveText:01:1)               PICK LIST PRINTED
     C                   Eval      OITXCD = %SubSt(SaveText:02:1)               TAX ITEM CODE 1
     C                   Eval      OITXST = %SubSt(SaveText:03:1)               TAX ITEM CODE 2
     C                   Eval      OITXCT = %SubSt(SaveText:04:1)               TAX ITEM CODE 3
     C                   Eval      OITXLC = %SubSt(SaveText:05:1)               TAX ITEM CODE 4
     C                   Eval      OIROUT = %SubSt(SaveText:06:1)               ROUTE NUMBER
     C                   Eval      OISTOP = OHSTOP                              STOP
     C                   Eval      OICWT  = %SubSt(SaveText:08:1)               CATCH WEIGHT
     C                   Eval      OIMUL2 = 1                                   MULT 2
     C                   Eval      OILOTC = 'N'                                 LOT CONTROL
     C                   Eval      OISTA  = 'N'                                 SUBJ TO AVAIL FLAG
     C                   Eval      OIPPDC = %SubSt(SaveText:09:1)
     C                   Eval      OIPHYT = %SubSt(SaveText:10:1)
     C                   Eval      OISCHM = %SubSt(SaveText:11:1)
     C                   Eval      OISCHS = %SubSt(SaveText:12:1)
     C                   Eval      OIRVCD = SaveOIRVCD                          EXPIRE DATE - CYMD
     C                   Eval      OIDTRQ = SaveOIDTRQ                          HOLD ORIG REQ SHIP D
     C                   Eval      OIRVDT = SaveOIRVDT                          REQ SHIP DATE CYMD
     C                   Eval      OIFRQD = %SubSt(SaveText:13:1)               FORCE QTY DISC Y/N
     C                   Eval      OIALPH = SaveOIALPH
     C                   Eval      OIDES1 = Comment
     C                   Eval      OIEXT$ =  *Zeros
     C                   Eval      OIUPRI =  *Zeros
     C                   Eval      OILIST = *Blanks                             Blank for Comment
     C                   WRITE     RIORDR
     C                   ENDSR
      /EJECT
      **************************
      * DELETE THIS LINE       *
      **************************
     C     DELLIN        BEGSR
     C     LINTYP        IFEQ      ' '
     C     ITCKEY        CHAIN(N)  FMINVT                             31
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        VDESC
     C                   Z-ADD     OIUPRI        VUPRIC
     C                   Z-ADD     OIEXT$        VEXT
     C                   Z-ADD     OIQORD        QTYORD
     C                   END
      ** DO NOT ALLOW DELETE IF SHIPPED QTY EXISTS
     C     OIQSHP        IFGT      0
     C     OHIOCD        ANDNE     'Y'
     C                   SETON                                        99
     C                   ELSE
     C                   SETOFF                                       99
     C                   ENDIF
     C                   WRITE     SCRNDEL
     C                   READ      SCRNDEL                                90
     C   KF              GOTO      ENDELN
     C   99              GOTO      ENDELN
      ** RELIEVE ALLOCATED QTY
     C                   MOVE      'Y'           DEALL
     C     OIQORD        SUB       OIQSHP        QTY              11 1
     C  NKD              EXSR      DELALO
     C   KD              EXSR      DELALD
      ** RELIEVE NON LOT
     C     OIITYP        IFEQ      ' '
     C     OIMKEY        CHAIN     FMINVT                             31
     C     IMLOTC        IFNE      'Y'
     C                   UNLOCK    FMINVT
     C                   Z-ADD     0             NEWQTY
     C                   Z-ADD     QTY           OLDQTY
     C                   CALL      'ALOCATE'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    OHCOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   END
     C                   END
      ** DELETE IORDR RECORD
      ** CHECK IF WE NEED TO OUTPUT 105 DELETE REC
     C     IMSIZE        IFEQ      '105'
     C     IMFRSZ        ANDEQ     'CUT'
     C     VACT          ANDNE     'A'
     C                   CLEAR                   RCUTDEL
     C                   Z-ADD     OHORD#        CDORD#
     C                   Z-ADD     OHCUST        CDCUST
     C                   MOVEL     IMITEM        CDITEM
     C                   MOVEL     IMSIZE        CDSIZE
     C                   Z-ADD     OISOW         CDOSOW
     C                   Z-ADD     OIRVDT        CDOREQ
     C                   Z-ADD     OIQORD        CDOQTY
     C                   MOVEL     ACTNCD        CDACT
     C                   TIME                    CDTIME
     C                   Z-ADD     TDATEC        CDCHDT
     C                   MOVEL     USERID        CDUSER
     C                   MOVEL     'D'           CDACT
WJB  C     VendKey       Chain     FMINVTVD
WJB  C                   If        %Found(FMINVTVD)
WJB  C                   Z-ADD     VDIMVEND      CDVEND
WJB  C                   EndIf
     C                   WRITE     RCUTDEL
     C                   END
      ** GET REPRINT
     C     RPPCK         IFEQ      'Y'
     C     OHORD#        CHAIN     FORDCHG                            94
     C   94              WRITE     RORDCHG
     C  N94              UPDATE    RORDCHG
     C                   END
     C     LINKEY        Chain     FIORESOW
     C                   If        %Found(FIORESOW)
     C                   Delete    RIORESOW
     C                   EndIf
     C                   DELETE    RIORDR
WJB   *  ALSO DELETE FIORDR RECORD WHEN DELEING ORDER LINE                            WJB - 02/17/09
WJB  C                   Eval      OIQORD = *Zero
WJB  C                   Eval      OIQSHP = *Zero
WJB  C                   ExSr      ROYAL
     C     ENDELN        ENDSR
      /EJECT
      **************************
      * DELETE THIS ORDER      *
      **************************
     C     DELORD        BEGSR
     C                   EXSR      CLRC                                         Clear Screen C
     C                   GoTo      SkipThisSR
     C     DETLL         KLIST
     C                   KFLD                    VORDER
     C     DETLL         SETLL     FIORDR

     C     NXTDEL        TAG
     C     DETLL         READE     FIORDR                                 90
     C   90              GOTO      ENDDEL
      ** RELIEVE ALLOCATED QTY
     C* WJB              MOVE      'Y'           DEALL                   *Only Relieve Open Quantity
WJB  C                   MOVE      'N'           DEALL
     C     OIQORD        SUB       OIQSHP        QTY
     C                   EXSR      DELALO                                       *PGM 'ALOCD'
      ** RELIEVE NON LOT
     C     OIITYP        IFEQ      ' '
     C     OIMKEY        CHAIN     FMINVT                             31
     C     IMLOTC        IFNE      'Y'
     C                   UNLOCK    FMINVT
     C                   Z-ADD     0             NEWQTY
     C                   Z-ADD     QTY           OLDQTY
     C                   CALL      'ALOCATE'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    OHCOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   END
     C                   END
      ** CHECK IF WE NEED TO OUTPUT 105 DELETE REC
     C     IMSIZE        IFEQ      '105'
     C     IMFRSZ        ANDEQ     'CUT'
     C     VACT          ANDNE     'A'
     C                   CLEAR                   RCUTDEL
     C                   Z-ADD     OHORD#        CDORD#
     C                   Z-ADD     OHCUST        CDCUST
     C                   MOVEL     IMITEM        CDITEM
     C                   MOVEL     IMSIZE        CDSIZE
     C                   Z-ADD     OISOW         CDOSOW
     C                   Z-ADD     OIRVDT        CDOREQ
     C                   Z-ADD     OIQORD        CDOQTY
     C                   MOVEL     ACTNCD        CDACT
     C                   TIME                    CDTIME
     C                   Z-ADD     TDATEC        CDCHDT
     C                   MOVEL     USERID        CDUSER
     C                   MOVEL     'D'           CDACT
WJB  C     VendKey       Chain     FMINVTVD
WJB  C                   If        %Found(FMINVTVD)
WJB  C                   Z-ADD     VDIMVEND      CDVEND
WJB  C                   EndIf
     C                   WRITE     RCUTDEL
     C                   END
     C                   DELETE    RIORDR
     C                   GOTO      NXTDEL

     C     ENDDEL        TAG
WJB  C                   EXSR      RMVFUT                                       RMV FUT. ORD. RLS.
     C     VORDER        CHAIN     FHORDR                             90
     C  N90              DELETE    RHORDR
     C  N90              Eval      HSTUSER    = USERID
     C  N90              Eval      HSTPROGRAM = 'BIR100'
     C  N90              Eval      HSTTIME    = $Timestamp()
     C  N90              Write     RHORDRHIST
EFD01C                   CALL      'GETORD$'
EFD01C                   PARM                    OHORD#
EFD01C                   PARM                    NTOTD             9 2
     C     SkipThisSR    Tag
     C                   Call      'CANORD'
     C                   Parm                    VORDER
     C                   ENDSR
      /EJECT
WJB   ***************************************************
WJB   * REMOVE FUTURE ORDER RELEASE RECORDS FOR ORDER   *
WJB   ***************************************************
WJB  C     RMVFUT        BEGSR
WJB  C     VORDER        SETLL     FIORDRWK
WJB  C     VORDER        READE     FIORDRWK                               90
WJB  C     *IN90         DOWNE     *ON
WJB  C                   DELETE    RIORDRWK
WJB  C     VORDER        READE     FIORDRWK                               90
WJB  C                   ENDDO
WJB  C                   ENDSR
      /EJECT
      **************************
      * GET AVAILABLE TO SELL  *
      **************************
     C     GETAV         BEGSR
     C     IMLOTC        IFEQ      'Y'
     C                   Z-ADD     0             AVQTY
     C                   CALL      'GETAVSEL'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    OHPHYT
     C                   PARM                    ##MDY
     C                   PARM                    OHBLCU
     C                   PARM                    AVQTY            11 1
     C                   PARM                    SHPREG                         SHP FRM REGN
     C                   Z-ADD     AVQTY         VAVAIL
     C                   ELSE
     C     IMQTOH        SUB       IMQTAL        VAVAIL
     C                   END
     C                   ENDSR
      /EJECT
      **************************
      * INQUIRY OPTION MENU    *
      **************************
     C     GETINQ        BEGSR
     C     NXTINQ        TAG
     C                   WRITE     SCRNI
     C                   READ      SCRNI                                  90
     C                   SETOFF                                           10
     C     OPTION        IFEQ      0
     C                   GOTO      ENDINQ
     C                   END
     C     OPTION        IFEQ      1
     C                   CALL      'ARR220CL'
     C                   GOTO      ENDINQ
     C                   END
     C     OPTION        IFEQ      2
     C                   CALL      'ICR21ACL'
     C                   GOTO      ENDINQ
     C                   END
     C     OPTION        IFEQ      3
     C                   CALL      'QPK610CL'
     C                   GOTO      ENDINQ
     C                   END
     C     OPTION        IFEQ      4
     C                   CALL      'QPK630CL'
     C                   GOTO      ENDINQ
     C                   END
     C     OPTION        IFEQ      5
     C                   CALL      'BIR245'
     C                   GOTO      ENDINQ
     C                   END
     C     OPTION        IFEQ      6
     C                   CALL      'BIR265'
     C                   GOTO      ENDINQ
     C                   END
     C                   SETON                                        10
     C                   GOTO      NXTINQ
     C     ENDINQ        ENDSR
      /EJECT
      **************************
      * BUILD ORDER FROM HORDR *
      **************************
     C     BLDORD        BEGSR
     C                   Z-ADD     OHORD#        VORDER
     C                   Z-ADD     OHCOMP        VCO
     C                   Z-ADD     OHCUST        VSCUST
     C                   Z-ADD     OHBLCU        BLCUST
     C     VSCUST        CHAIN(N)  FMCUST                             90
     C******               Z-ADDCM#FLT    FLATS  111
     C                   Z-ADD     0             FLATS            11 1
     C                   EXSR      GETNOT
     C                   MOVEL     CMPORQ        POREQ             1
     C                   Z-ADD     OHARCU        ARCUST
     C                   MOVEL     OHNAME        CMNAME
     C                   MOVEL     OHSHP2        CMADD2
     C                   MOVEL     OHSHP3        CMADD3
     C                   MOVEL     OHSHP4        CMADD4
     C                   MOVEL     OHSHCT        CMCITY
     C                   MOVEL     OHSHST        CMSTST
     C                   MOVEL     OHSHZP        VZIPA1
     C                   MOVE      OHSHZP        VZIPA2
     C                   MOVEL     OHPONO        VPURCH
     C                   Z-ADD     OHDTOR        VORDTE
     C                   Z-ADD     OHDTCN        DTCN
     C                   Z-ADD     OHDTRQ        VRQDTE
     C                   Z-ADD     OHDTRQ        ORQDTE
     C                   Z-ADD     OHDTRQ        VREQDT
     C                   Z-ADD     OHDTCN        VCNDTE
     C                   MOVEL     OHSHIN        CMSHIN
     C                   MOVEL     OHSPIN        CMSPIN
     C                   MOVEL     OHTERM        COTERM
     C                   Z-ADD     OHTRAT        TCTRAT
     C                   Z-ADD     OHTDAY        TCTDAY
     C                   MOVEL     OHTXST        VTXST
     C                   MOVEL     OHTXJU        VTXJU
     C                   MOVEL     OHTYPE        CMCTYP
     C                   MOVEL     OHSHPC        VSVCD
      ** GET SHIP VIA DESC
     C                   EXSR      GETSHV
     C                   MOVEL     OHSTA         VSTA
     C                   MOVEL     OHSLD1        VNAM1B
     C                   MOVEL     OHSLD2        VADD2B
     C                   MOVEL     OHSLD3        VADD3B
     C                   MOVEL     OHSLD4        VADD4B
     C                   MOVEL     OHSLCT        VCITYB
     C                   MOVEL     OHSLST        VSTATB
     C                   MOVEL     OHSLZP        VZIPB1
     C                   MOVE      OHSLZP        VZIPB2
     C                   MOVE      OHSLM1        VSLSM1
     C                   Z-ADD     OHSCM1        CMCOMM
     C                   MOVE      OHSLM2        VSLSM2
     C                   Z-ADD     OHSCM2        VCOMM2
      ** GET SALESPERSON
     C                   EXSR      GETSLP
     C                   EXSR      GETSL2
      ** IF NO SLSMN2 SETOF 38
     C   38              SETOFF                                       38
     C                   MOVEL     OHIOCD        VINVCD
     C                   MOVEL     OHBOCD        CMBOOK
     C                   MOVEL     OHPPCD        VPPCOL
     C                   EXSR      GETPPC
     C                   Z-ADD     OHPRCD        CMPRCD
     C                   Z-ADD     OHPRCD        PRICD
     C                   Z-ADD     OHTRDC        CMTRDC
     C                   MOVEL     OHTMCD        VTRMCD
      ** GET TERMS DESCRIPTION
     C                   EXSR      GETTRM
     C                   MOVEL     OHUPSZ        VUPSZ
     C                   MOVEL     OHFRTX        VTXFRG
     C                   MOVEL     OHSPTX        VTXSPC
     C                   MOVEL     OHROUT        VROUTE
     C                   Z-ADD     OHSTOP        VSTOP
     C                   MOVEL     OHSHFR        VSHFR
      ** GET SHIP FROM LOCATION
     C                   EXSR      GETSFR
     C                   MOVEL     OHPLST        VFRTCD
     C                   MOVEL     OHOLST        VMORLS
     C                   EXSR      GETORL
     C                   MOVEL     OHLOC         VLOC
     C                   MOVEL     OHQUOT        VQUOTE
     C                   If        OHLOTC <> ' '
     C                   MOVEL     OHLOTC        VLOTC
     C                   Else
     C                   MOVE      'N'           VLOTC
     C                   EndIf
     C***                  Z-ADDOHVLDC    VOLDSC
     C     OHACK         IFEQ      'Y'
     C                   MOVEL     'N'           VACK
     C                   ELSE
     C                   MOVEL     'Y'           VACK
     C                   ENDIF
     C*          VOLDSC    IFEQ V2DIS
     C*                    SETON                     0405
     C*                    END
     C*          VOLDSC    IFEQ V1DIS
     C*                    SETON                     04
     C*                    END
     C**         OHFVDC    COMP 'Y'                      77
     C                   ENDSR
      *
      /EJECT
      ****************************
      * CALCULATE NUMBER OF TAGS *
      ****************************
     C     CALTAG        BEGSR
     C     VSIZE         CHAIN     FMSIZE                             88
     C  N88QTYORD        MULT      SZSALE        VTAGS
     C     LABHUN        IFEQ      'Y'
     C                   MOVE      VTAGS         TSTTAG            2 0
     C     100           SUB       TSTTAG        TAGADD            2 0
     C                   ADD       TAGADD        VTAGS
     C                   END
     C   88              Z-ADD     0             VTAGS
     C                   ENDSR
      *
      /EJECT
      **************************
      * GET PHYTO              *
      **************************
     C     GETPHY        BEGSR
     C     OHOLST        IFEQ      'TAG'
     C     OHPHYT        ORLE      ' '
     C                   GOTO      ENDPHY
     C                   END
     C     OHPHYT        CHAIN     FPHYTO                             90
     C  N90              DO
     C     OIKEY         KLIST
     C                   KFLD                    VORDER
     C                   KFLD                    SEQ
     C                   Z-ADD     998           SEQ
     C     OIKEY         CHAIN     FIORDR                             91
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     PHYDES        OIDES1
     C                   MOVE      *BLANKS       OIDES2
     C                   Z-ADD     VCO           OICOMP
     C                   MOVE      *BLANKS       OIWHSE
     C                   MOVE      *BLANKS       OIBIN#
     C                   MOVE      *BLANKS       OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   Z-ADD     0             OIUWGT
     C                   Z-ADD     0             OIUCST
     C                   Z-ADD     PHCHRG        OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     PHCHRG        OIEXT$
     C                   Z-ADD     0             OIQORD
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIROY
     C                   Z-ADD     0             OIAMT1
     C                   Z-ADD     0             OIAMT2
     C                   Z-ADD     0             OIAMT3
     C                   Z-ADD     0             OIDISC
     C                   MOVE      OHPRCD        OIOVER
     C                   MOVE      OHBOCD        OIBOCD
     C                   MOVE      OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVE      OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     OHDTRQ        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     0             OITRDC
     C                   MOVEL     'N'           OICTCD
     C                   MOVEL     OHCOFL        OICOFL
     C     PHCHRG        IFGT      0
     C                   MOVEL     'S'           OIITYP
     C                   Eval      OILIST = *Blanks
     C                   ELSE
     C                   MOVEL     'C'           OIITYP
     C                   END
     C                   Z-ADD     0             OIQINV
     C     OIITYP        IFEQ      'C'
     C                   Eval      OILIST = *Blanks                             Blank for Comment
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   END
     C     OIITYP        IFEQ      'S'
     C                   Eval      OILIST = *Blanks
     C                   MOVE      OHSPTX        OITXCD
     C                   MOVE      OHSPTX        OITXST
     C                   MOVE      OHSPTX        OITXCT
     C                   MOVE      OHSPTX        OITXLC
     C                   END
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     'N'           OICWT
     C                   Z-ADD     0             OILBS#
     C                   Z-ADD     0             OIWGSH
     C                   MOVE      ' '           OIRSCD
     C                   Z-ADD     0             OISEQP
     C                   MOVE      ' '           OIPRAL
     C                   MOVE      *BLANKS       OIBPUM
     C                   MOVE      *BLANKS       OISUOM
     C                   MOVE      *BLANKS       OIBLUM
     C                   Z-ADD     1.0000        OIMUL2
     C                   MOVEL     OHLOTC        OILOTC
     C                   MOVE      ' '           OIOPFL
     C                   MOVE      ' '           OIBOLN
     C                   Z-ADD     0             OIBORQ
     C                   MOVE      ' '           OIPRBO
     C                   MOVEL     OHSTA         OISTA
     C                   MOVEL     OHSHFR        OISHFR
     C                   Z-ADD     0             OITAGS
EFD02C*                    MOVEL'N'       OIPPDC
     C                   Z-ADD     OHDTCN        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVCD
     C                   MOVEL     OHQUOT        OIQTE
     C                   Z-ADD     OHORDT        OIORDT
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVE      *BLANKS       OILOT#
     C                   MOVE      'N'           OIFRQD
     C                   MOVE      ' '           OISPFL
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVE      *BLANKS       OIPRCL
     C                   MOVE      *BLANKS       OINPSL
     C                   Z-ADD     0             OIRQTY
     C                   MOVE      ' '           OIPOST
     C                   Z-ADD     0             OISOW
     C                   MOVE      'A'           OISTAT
     C   91              Z-ADD     998           OISEQ#
      **** OUTPUT IORDR RECORD
     C                   Z-ADD     VORDER        OIORD#
     C                   MOVE      'N'           OISHCD
     C                   MOVE      'N'           OIPLPT
     C                   Z-ADD     0             OIINV#
     C   91              WRITE     RIORDR
     C  N91              UPDATE    RIORDR
     C                   Z-ADD     999           SEQ
     C     OIKEY         CHAIN     FIORDR                             91
     C                   Z-ADD     999           OISEQ#
     C                   MOVEL     'C'           OIITYP
     C                   Eval      OILIST = *Blanks                             Blank for Comment
     C                   Z-ADD     0             OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     0             OIEXT$
     C     PHCERT        IFEQ      'Y'
     C                   MOVEL     MSG(12)       OIDES1
     C                   ELSE
     C                   MOVEL     MSG(11)       OIDES1
     C                   END
     C   91              WRITE     RIORDR
     C  N91              UPDATE    RIORDR
     C                   ENDDO
     C     ENDPHY        ENDSR
      *
      /EJECT
      **************************
      * CHANGE DISCOUNT        *
      **************************
     C     CHGDSC        BEGSR
     C   76              MOVEL     'Y'           VIQD
     C  N76              MOVEL     'N'           VIQD
     C                   Z-ADD     VDISC         VIQP
     C   74              MOVEL     'Y'           VQPPD
     C  N74              MOVEL     'N'           VQPPD
     C   77              MOVEL     'Y'           VVD
     C  N77              MOVEL     'N'           VVD
     C                   Z-ADD     VOLDSC        VVP
     C                   SETOFF                                       102030
     C                   SETOFF                                       1112
     C                   SETOFF                                       3132
     C                   SETOFF                                       99

     C     NXTDSC        TAG
     C                   WRITE     SCRNCD
     C                   READ      SCRNCD                                 90
     C                   SETOFF                                       102030
     C                   SETOFF                                       1112
     C                   SETOFF                                       3132
     C                   SETOFF                                       99
     C   KF              GOTO      ENDDSC
     C     VIQD          IFNE      'Y'
     C     VIQD          ANDNE     'N'
     C                   SETON                                        1099
     C                   END
     C     VIQD          IFEQ      'Y'
     C     VIQP          ANDLE     0
     C                   SETON                                        101199
     C                   END
     C     VIQD          IFEQ      'N'
     C     VIQP          ANDGT     0
     C                   SETON                                        101299
     C                   END
     C     VQPPD         IFNE      'Y'
     C     VQPPD         ANDNE     'N'
     C                   SETON                                        2099
     C                   END
     C     VVD           IFNE      'Y'
     C     VVD           ANDNE     'N'
     C                   SETON                                        3099
     C                   END
     C     VVD           IFEQ      'Y'
     C     VVP           ANDLE     0
     C                   SETON                                        303199
     C                   END
     C     VVD           IFEQ      'N'
     C     VVP           ANDGT     0
     C                   SETON                                        303299
     C                   END
     C   99              GOTO      NXTDSC
     C     VIQD          IFEQ      'Y'
     C                   Z-ADD     VIQP          VDISC
     C                   MOVEL     'Y'           OIFRQD
     C                   SETON                                        76
     C                   ELSE
     C                   SETOFF                                       76
     C                   END
     C     VVD           IFEQ      'Y'
     C                   Z-ADD     VVP           VOLDSC
     C**                   MOVEL'Y'       OHFVDC
     C                   SETON                                        77
     C                   ELSE
     C                   SETOFF                                       77
     C                   END
     C     LABYN         IFEQ      'Y'
     C                   SETON                                        06
     C                   ELSE
     C                   SETOFF                                       06
     C                   END
     C     ENDDSC        ENDSR
      *
      /EJECT
      **************************
      * OUTPUT ORDER OVERRIDE  *
      **************************
     C     OUTOVR        BEGSR
     C                   Z-ADD     VORDER        OOORD#
     C     ACTNCD        IFEQ      'A'
     C     LSTSEQ        ADD       2             OOSEQ#
     C                   ELSE
     C                   Z-ADD     OISEQ#        OOSEQ#
     C                   END
     C                   MOVE      'N'           OOSTAT
     C                   Z-ADD     VSCUST        OOCUST
     C                   MOVEL     VITEM         OOITEM
     C                   MOVEL     VSIZE         OOSIZE
     C                   MOVEL     VWHS          OOWHSE
     C                   Z-ADD     TDATE         OODATE
     C                   Z-ADD     TIMOD         OOTIME
     C                   MOVEL     USERID        OOUSER
     C                   MOVEL     WSID          OOWSID
     C                   Z-ADD     VCO           OOCOMP
     C                   Z-ADD     VREQDT        OORQDT
     C                   MOVEL     VSLSM1        OOSLSM
     C                   WRITE     RORDOVR
     C                   ENDSR
      *
      /EJECT
      **************************
      * BUILD DESCRIPTION      *
      **************************
     C     GETIDS        BEGSR
     C     OIMKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     OIMKEY        CHAIN(N)  FMINVT                             90
     C   90              MOVE      *BLANKS       ODESC            50
     C                   ENDSR
      *
      /EJECT
      **************************
      * CLEAR SCREENC FIELDS   *
      **************************
     C     CLRC          BEGSR
     C     VORDER        CHAIN(N)  FHORDR                             91
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             TOTDOL
     C                   Z-ADD     0             LINE
     C                   MOVE      *BLANKS       LINTYP
     C                   EXSR      ACTTYP
     C                   EXSR      GTLNTP
     C**                   Z-ADDOHVLDC    VOLDSC
     C*          OHFVDC    IFEQ 'Y'
     C*                    SETON                     77
     C*                    ELSE
     C*                    SETOF                     77
     C*                    END
     C*          VOLDSC    IFEQ V2DIS
     C*                    SETON                     0405
     C*                    END
     C*          VOLDSC    IFEQ V1DIS
     C*                    SETON                     04
     C*                    END
     C                   MOVE      *BLANKS       VITEM
     C**                   MOVE *BLANKS   VSIZE
     C                   MOVE      *BLANKS       VWHS
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             OIQTAL
     C                   MOVE      'N'           VOVER
     C                   Z-ADD     0             VUPRIC
     C                   Z-ADD     0             VDISC
     C                   Z-ADD     VRQDTE        VREQDT
     C                   Z-ADD     0             VEXT
     C                   Z-ADD     99999999      OEXT
     C                   MOVE      *BLANKS       VUOM
     C                   MOVE      *BLANKS       VDESC
     C                   Z-ADD     0             VTAGS
     C                   ENDSR
      *
      /EJECT
      **************************
      * CLEAR LINE ITEM FIELDS   *
      **************************
      *
     C     CLRD          BEGSR
     C***                  MOVE VACT      ACTNCD
     C                   MOVE      *BLANKS       LINTYP
     C                   Z-ADD     *ZEROS        VFSPRC
     C                   Z-ADD     *ZEROS        LINE
     C                   EXSR      GTLNTP
     C                   ENDSR
      *
      /EJECT
      *****************************************
      * GET FREIGHT, COMMENT, SPECIAL CHARGES *
      *****************************************
     C     GETFSC        BEGSR
     C                   MOVE      *BLANKS       FSDESC
     C                   Z-ADD     0             VFSPRC
     C                   Z-ADD     0             OIROY
     C                   SETOFF                                       404131
     C                   SETON                                        3056
     C     ACTNCD        IFEQ      'C'
     C                   MOVEL     OIDES1        FSDESC
     C                   Z-ADD     OIEXT$        VFSPRC
     C                   END
     C     LINTYP        IFEQ      'C'
     C                   SETON                                        4156
     C                   ELSE
     C                   SETOFF                                       41
     C                   END
     C     LINTYP        IFEQ      'F'
     C     ACTNCD        ANDEQ     'A'
     C     LINTYP        OREQ      'F'
     C     ACTNCD        ANDEQ     'I'
     C                   MOVEL     MSG(10)       FSDESC
     C                   ENDIF
     C     LINTYP        IFEQ      'S'
     C     ACTNCD        ANDEQ     'A'
     C     LINTYP        OREQ      'S'
     C     ACTNCD        ANDEQ     'I'
     C                   MOVEL     MSG(8)        FSDESC
     C                   ENDIF
      ** GET GL NUMBER
     C     LINTYP        IFEQ      'S'
     C                   SETOFF                                       58
     C     ACTNCD        IFEQ      'A'
     C     GDFKEY        KLIST
     C                   KFLD                    OHCOMP
     C                   KFLD                    GDTYP
     C                   MOVEL     '01'          GDTYP             2
     C     GDFKEY        CHAIN     FGLDF                              58
     C  N58              Z-ADD     GDSCHG        OIGLNO
     C                   END
     C  N58GLKEY         CHAIN     FMGLCH                             58
     C   58              MOVE      *BLANKS       GCDESC
     C  N58              MOVEL     OIGLNO        GLNO1
     C  N58              MOVE      OIGLNO        GLNO2
     C                   SETOFF                                       5658
     C                   END

     C     NXTFSC        TAG
     C                   WRITE     SCRNCFS
     C                   READ      SCRNCFS                                90
     C                   SETOFF                                       304099
     C                   SETOFF                                       312632
     C   KF              GOTO      ENDFSC
     C     OIDTRQ        IFLE      0
     C                   SETON                                        3299
     C                   ELSE
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        3299
     C                   END
     C                   END
     C   99              GOTO      NXTFSC
     C     FSDESC        IFEQ      *BLANKS
     C                   SETON                                        3199
     C                   END
     C     LINTYP        IFNE      'C'
     C     VFSPRC        ANDEQ     0
     C                   SETON                                        4099
     C                   ENDIF
      ** CHECK GL NUMBER
     C     LINTYP        IFEQ      'S'
     C                   MOVEL     GLNO1         OIGLNO
     C                   MOVE      GLNO2         OIGLNO
     C     GLKEY         KLIST
     C                   KFLD                    OHCOMP
     C                   KFLD                    OIGLNO
     C     GLKEY         CHAIN     FMGLCH                             58
     C   58              DO
     C                   MOVE      *BLANKS       GCDESC
     C                   SETON                                        99
     C                   ENDDO
     C                   END
     C   99              GOTO      NXTFSC
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVE      *BLANKS       OIITMA
     C                   MOVEL     FSDESC        OIDES1
     C                   MOVE      *BLANKS       OIDES2
     C                   Z-ADD     VCO           OICOMP
     C                   MOVE      *BLANKS       OIWHSE
     C                   MOVE      *BLANKS       OIBIN#
     C                   MOVE      *BLANKS       OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   Z-ADD     0             OIUWGT
     C                   Z-ADD     0             OIUCST
     C                   Z-ADD     VFSPRC        OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     VFSPRC        OIEXT$
     C                   Z-ADD     0             OIQORD
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIROY
     C                   Z-ADD     0             OIAMT1
     C                   Z-ADD     0             OIAMT2
     C                   Z-ADD     0             OIAMT3
     C                   Z-ADD     0             OIDISC
     C                   MOVE      OHPRCD        OIOVER
     C                   MOVE      OHBOCD        OIBOCD
     C                   MOVE      OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVE      OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C**                   Z-ADDOHDTRQ    OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     0             OITRDC
     C                   MOVEL     'N'           OICTCD
     C                   MOVEL     OHCOFL        OICOFL
     C                   MOVEL     LINTYP        OIITYP
     C                   Z-ADD     0             OIQINV
     C     OIITYP        IFEQ      'C'
     C                   Eval      OILIST = *Blanks                             Blank for Comment
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   END
     C     OIITYP        IFEQ      'F'
     C                   Eval      OILIST = *Blanks
     C                   MOVE      OHFRTX        OITXCD
     C                   MOVE      OHFRTX        OITXST
     C                   MOVE      OHFRTX        OITXCT
     C                   MOVE      OHFRTX        OITXLC
     C                   END
     C     OIITYP        IFEQ      'S'
     C                   Eval      OILIST = *Blanks
     C                   MOVE      OHSPTX        OITXCD
     C                   MOVE      OHSPTX        OITXST
     C                   MOVE      OHSPTX        OITXCT
     C                   MOVE      OHSPTX        OITXLC
     C                   END
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     'N'           OICWT
     C                   Z-ADD     0             OILBS#
     C                   Z-ADD     0             OIWGSH
     C                   MOVE      ' '           OIRSCD
     C                   Z-ADD     0             OISEQP
     C                   MOVE      ' '           OIPRAL
     C                   MOVE      *BLANKS       OIBPUM
     C                   MOVE      *BLANKS       OISUOM
     C                   MOVE      *BLANKS       OIBLUM
     C                   Z-ADD     1.0000        OIMUL2
     C                   MOVEL     OHLOTC        OILOTC
     C                   MOVE      ' '           OIOPFL
     C                   MOVE      ' '           OIBOLN
     C                   Z-ADD     0             OIBORQ
     C                   MOVE      ' '           OIPRBO
     C                   MOVEL     OHSTA         OISTA
     C                   MOVEL     OHSHFR        OISHFR
     C                   Z-ADD     0             OITAGS
EFD02C*                    MOVEL'N'       OIPPDC
     C                   Z-ADD     OHDTCN        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVCD
     C                   MOVEL     OHQUOT        OIQTE
     C                   Z-ADD     OHORDT        OIORDT
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVE      *BLANKS       OILOT#
     C                   MOVE      'N'           OIFRQD
     C                   MOVE      ' '           OISPFL
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVE      *BLANKS       OIPRCL
     C                   MOVE      *BLANKS       OINPSL
     C                   Z-ADD     0             OIRQTY
     C                   MOVE      ' '           OIPOST
     C                   Z-ADD     0             OISOW
     C     ACTNCD        IFEQ      'A'
     C     ACTNCD        OREQ      'I'
     C                   MOVE      'A'           OISTAT
     C     ACTNCD        IFEQ      'A'
     C                   ADD       2             LSTSEQ
     C                   Z-ADD     LSTSEQ        OISEQ#
     C                   ELSE
     C                   Z-ADD     LINE          OISEQ#
     C                   END
     C                   Z-ADD     OISEQ#        SEQ##             3 0
      **** OUTPUT IORDR RECORD
     C                   Z-ADD     VORDER        OIORD#
     C                   MOVE      'N'           OISHCD
     C                   MOVE      'N'           OIPLPT
     C                   Z-ADD     0             OIINV#
     C                   WRITE     RIORDR
     C                   ELSE
     C                   Z-ADD     OISEQ#        SEQ##             3 0
     C                   UPDATE    RIORDR
     C                   END
     C     ENDFSC        ENDSR
      *
      /EJECT
      **************************
      *   GET VOLUME DISCOUNT  *
      **************************
      *
     C     GETVOL        BEGSR
     C     VORDER        SETLL     FIORDR

     C     NXTVOL        TAG
     C     VORDER        READE     RIORDR                                 90
     C   90              GOTO      ENDVOL
     C     OIITYP        IFNE      ' '
     C**         OIOVER    OREQ 'Y'
     C                   GOTO      NXTVOL
     C                   END
     C                   Z-ADD     OIUPRI        #OPRC
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    OIITEM
     C                   PARM                    OISIZE
     C                   PARM                    OIWHSE
     C                   PARM                    OIUUOM
     C                   PARM                    QTYORD
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
     C     #OPRC         IFEQ      OIUPRI
     C                   GOTO      NXTVOL
     C                   END
     C                   Z-ADD     #OPRC         #PRC
     C                   Z-ADD     0             OIQDDC
     C     OIQORD        MULT(H)   OIUPRI        #LINGR            9 2
      *
      *  CALCULATE LINE NET AMOUNT
      *
     C     OIQORD        MULT(H)   #PRC          OIEXT$
      *
      *  CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       OIEXT$        OIDISC
     C                   Z-ADD     #OPRC         OIUPRI
     C                   UPDATE    RIORDR
     C                   GOTO      NXTVOL
     C     ENDVOL        ENDSR
      *
      /EJECT
      **************************
      *   GET SPEC ALLOCATION  *
      **************************
      *
     C     SPCL          BEGSR
     C                   If        IMLOTC = 'Y'
     C                   MOVE      *BLANKS       FLAG
     C     ACTNCD        IFEQ      'A'
     C     2             ADD       LSTSEQ        OISEQ#
     C                   Z-ADD     0             QTYA              6 0
     C                   ELSE
     C                   Z-ADD     OIQTAL        QTYA              6 0
     C                   Z-ADD     S_OIQTAL      QTYA              6 0
     C                   END
     C                   Z-ADD     QTYORD        QTYO              6 0
     C                   Eval      FLAG = OILOTC
     C                   CALL      'GETLOT'
     C                   PARM                    OHORD#
     C                   PARM                    OISEQ#
     C                   PARM                    VREQDT
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    QTYO
     C                   PARM                    QTYA
     C                   PARM                    FLAG              1
     C                   If        FLAG <> 'N'
     C     QTYA          IFNE      QTYO
     C                   MOVE      'Y'           FLAG
     C                   MOVE      'N'           OILOTC
     C                   MOVE      'N'           VLOTC
     C                   ELSE
     C                   MOVE      'Y'           OILOTC
     C                   MOVE      'Y'           FLAG
     C                   END
     C                   Z-ADD     QTYA          OIQTAL
     C                   Z-ADD     QTYA          S_OIQTAL
     C                   Else
     C                   Eval      FLAG = *Blanks
     C                   EndIf
     C                   EndIf
     C                   ENDSR
      *
      *
      /EJECT
      **************************
      *   BUILD ORDER SUB FILE *
      **************************
      *
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             LSTSEQ            3 0
     C                   Eval      Partial = ' '

     C     SKPBLD        TAG
     C     RECNO         IFLE      0
     C                   Z-ADD     1             RECNO
     C                   WRITE     ORDSFL
     C                   Eval      Partial = ' '
     C                   END
     C                   Z-ADD     1             PAGE#
     C                   MOVE      '1'           *IN80
     C                   WRITE     ORDCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             TOTDOL
     C                   Z-ADD     0             TOTLNE            5 0
     C                   Z-ADD     0             TOTQTY
     C                   Z-ADD     0             VOLQTY           11 1
     C                   Z-ADD     0             VOLDAT            6 0
     C                   Z-ADD     0             NUMDAT            5 0
     C                   Z-ADD     0             TOTTAG            9 0
     C     VORDER        SETLL     FIORDR
     C     VORDER        SETLL     FIORDRSA

     C     NXTBLD        TAG
     C*          VACT      IFEQ 'A'
     C     VORDER        READE(N)  RIORDR                                 90
     C*                    ELSE
     C*          VORDER    READEIORDR                    90
     C*                    END
     C   90              GOTO      ENDBLD
      *  LAST 10 LINES RESERVED
     C     OISEQ#        IFLT      990
     C     OISEQ#        IFGT      LSTSEQ
     C                   Z-ADD     OISEQ#        LSTSEQ            3 0
     C                   END
      ** GET LAST ITEM ON SCREEN
     C**         RECNO     IFGT 21
     C**         RECNO     SUB  6         PAGE#
     C*                    ELSE
     C*                    Z-ADDRECNO     PAGE#
     C*                    END
     C                   ADD       1             TOTLNE
     C                   END
     C     OISTAT        IFNE      'A'
     C                   GOTO      NXTBLD
     C                   END
     C     OISEQ#        IFGE      LINE
     C                   Z-ADD     RECNO         PAGE#
     C                   Z-ADD     99999         LINE
     C                   END
      ** Store the Quantity Allocated in the Subfile
     C                   Eval      S_OIQTAL = OIQTAL
      ** GET SHIP DATE HEADING
     C     OIDTRQ        IFNE      LSTDAT
     C     OIDTRQ        ANDGT     0
     C     OIDTRQ        ANDLT     123299
?    C                   MOVE      *BLANKS       DESC
?    C                   MOVEL     OIDTRQ        D2                2
?    C                   MOVE      '/'           D3                3
?    C                   MOVEL     D2            D3
?    C                   MOVEL     OIDTRQ        DW4               4
?    C                   MOVE      DW4           D2
?    C                   MOVEL     D3            D6                6
?    C                   MOVE      '/'           D3
?    C                   MOVEL     D2            D3
?    C                   MOVE      D3            D6
?    C                   MOVEL     D6            D8                8
?    C                   MOVE      OIDTRQ        D2
?    C                   MOVE      D2            D8
?    C                   MOVEL     MSG(19)       DES22            22
?    C     DES22         CAT       D8:1          DESC
?    C                   Z-ADD     0             SEQ
?    C                   MOVE      *BLANKS       ITEM
?    C                   MOVE      *BLANKS       SIZE
?    C                   Z-ADD     0             ORDQTY
?    C                   Z-ADD     0             EXTPRC            7 2
?    C                   Z-ADD     0             LSTDAT
?    C                   Z-ADD     0             LOTDT
?    C                   ADD       1             RECNO
?    C                   SETON                                        78
?    C                   WRITE     ORDSFL
     C                   Eval      Partial = ' '
?    C                   Z-ADD     OIDTRQ        LSTDAT
?    C                   SETOFF                                       78
     C                   ENDIF
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C                   Eval      OILIST = *Blanks
     C                   Z-ADD     OISEQ#        SEQ
     C                   MOVEL     OIITEM        ITEM
     C                   MOVEL     OISIZE        SIZE
     C                   Z-ADD     OIQORD        ORDQTY
     C                   ADD       OITAGS        TOTTAG
     C     ITMKOI        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C                   SETOFF                                       53
     C     OIITYP        IFEQ      ' '
     C     OISIZE        ANDNE     'ROY'
     C     ITMKOI        CHAIN(N)  FMINVT                             90
     C*                    EXSR GETDES
     C*                    MOVELVDESC     DESC
     C                   MOVEL     OIDES1        DESC
     C                   ELSE
     C                   MOVE      *BLANKS       DESC
     C                   MOVEL     OIDES1        DESC
     C                   END
     C                   Z-ADD     OIUPRI        EXTPRC            7 2
     C                   ADD       1             RECNO
     C     OIBOLN        IFEQ      'B'
     C     OIPRBO        OREQ      'B'
     C                   SETON                                        53
     C                   MOVEL     'B'           BOLN
     C                   ENDIF
     C     OILOTC        IFEQ      'Y'
     C     ALIKEY        KLIST
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C                   Eval      AICUST = *Zero
     C     ALIKEY        CHAIN(N)  FALITEM                            90
     C   90              Z-ADD     0             LOTDT
     C  N90              DO
     C                   If        AICUST = 999997
     C                   Eval      Partial = 'P'
     C                   Else
     C                   Eval      Partial = ' '
     C                   EndIf
     C                   Z-ADD     AICRDY        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         LOTDT
     C                   ENDDO
     C                   ELSE
     C                   Z-ADD     0             LOTDT
     C                   END
     C                   WRITE     ORDSFL
     C                   Eval      Partial = ' '
     C                   MOVE      *BLANKS       BOLN
     C                   SETOFF                                       53
     C                   ADD       OIEXT$        TOTDOL
      ** DO NOT ADD QTYS OF SPEC CHARGES ETC
     C     OIITYP        IFEQ      ' '
     C     OISIZE        ANDNE     'ROY'
     C     OISIZE        ANDNE     'TAG'
     C                   ADD       OIQORD        TOTQTY
     C                   END
      ** CHECK FOR VOLUME DISCOUNT
     C     PCEVD         IFEQ      'Y'
     C                   ADD       OIQORD        VOLQTY
     C     VOLDAT        IFEQ      0
     C                   Z-ADD     OIDTRQ        VOLDAT
     C                   ADD       1             NUMDAT
     C                   ELSE
     C     VOLDAT        IFNE      OIDTRQ
     C                   ADD       1             NUMDAT
     C                   Z-ADD     OIDTRQ        VOLDAT
     C                   END
     C                   END
     C                   END
     C     IMROYL        IFGT      0.0000
     C     IMVEND        ANDGT     0
     C     OISEQ#        ANDLE     990
     C                   EXSR      ROYAL
     C                   END
     C     SVPACK        IFGT      0.00
     C     OISEQ#        ANDLE     990
     C                   EXSR      PCKBLD
     C                   END
     C                   GOTO      NXTBLD
     C                   END
     C     OIITYP        IFEQ      'F'
     C     OIITYP        OREQ      'S'
      ** CHECK IF WE NEED PACKING CHARGE
     C     OISEQ#        IFEQ      997
     C     SVPACK        IFGT      0.00
     C                   EXSR      PACK
     C                   ELSE
     C                   EXSR      UNPACK
     C                   GOTO      NXTBLD
     C                   END
     C                   END
     C                   Z-ADD     OISEQ#        SEQ
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       DESC
     C                   MOVEL     OIDES1        DESC
     C                   Z-ADD     0             ORDQTY
     C                   Z-ADD     OIEXT$        EXTPRC
     C                   ADD       1             RECNO
      ** GET LAST RECORD ENTERED ON SCREEN
     C                   WRITE     ORDSFL
     C                   Eval      Partial = ' '
     C                   ADD       EXTPRC        TOTDOL
     C                   GOTO      NXTBLD
     C                   END
     C     OIITYP        IFEQ      'C'
     C                   Eval      OILIST = *Blanks
     C                   Z-ADD     OISEQ#        SEQ
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       DESC
     C                   MOVEL     OIDES1        DESC
     C                   Z-ADD     0             ORDQTY
     C                   Z-ADD     0             EXTPRC
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   Eval      Partial = ' '
     C                   GOTO      NXTBLD
     C                   END
     C                   GOTO      NXTBLD

     C     ENDBLD        TAG
     C     ACTNCD        IFEQ      'A'
     C     RECNO         SUB       4             WRKREC            5 0
     C                   Z-ADD     WRKREC        PAGE#
     C                   END
     C                   Z-ADD     0             SEQ
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       SIZE
     C                   MOVE      *BLANKS       DESC
     C                   MOVEL     MSG(9)        DESC
     C                   Z-ADD     0             ORDQTY
     C                   Z-ADD     0             EXTPRC
     C                   Z-ADD     0             LOTDT
     C                   Z-ADD     0             LSTDAT
     C                   ADD       1             RECNO
     C     PAGE#         IFLT      1
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   Eval      Partial = ' '
     C                   WRITE     ORDSFL
     C                   Eval      Partial = ' '
     C                   MOVE      *BLANKS       VITEM
     C**                   MOVE *BLANKS   VSIZE
     C                   MOVE      *BLANKS       VWHS
     C                   Z-ADD     0             QTYORD
     C                   Z-ADD     0             OIQTAL
     C     VOVER         IFNE      'Y'
     C                   MOVE      'N'           VOVER
     C                   Z-ADD     0             VUPRIC
     C                   Z-ADD     0             VDISC
     C                   END
     C                   Z-ADD     0             VEXT
     C                   Z-ADD     0             VAVAIL
     C                   Z-ADD     0             VTAGS
     C                   MOVE      *BLANKS       VUOM
     C                   MOVE      *BLANKS       VDESC
WJB  C                   MOVE      *BLANKS       B2BCOMMENT
     C     ORDPPD        IFEQ      'Y'
     C                   SETON                                        74
     C                   ELSE
     C                   SETOFF                                       74
     C                   END
      ** CHECK FOR VOL DISCOUNT
      ** 1/09/97 EFD SKIP VOL DISCOUNT FOR PLAINVEW AND KUBE PAK
     C                   GOTO      SKPVOL
     C     NUMDAT        IFEQ      1
     C     VOLQTY        IFGE      V2QT(1)
     C  N05              DO
     C                   Z-ADD     V2DIS         VOLDSC
     C                   EXSR      GETVOL
     C                   SETON                                        0405
     C                   GOTO      SKPBLD
     C                   ENDDO
     C                   END
     C     VOLQTY        IFGE      V1QT(1)
     C  N04              DO
     C                   Z-ADD     V1DIS         VOLDSC
     C                   EXSR      GETVOL
     C                   SETON                                        04
     C                   GOTO      SKPBLD
     C                   ENDDO
     C                   END
     C                   END
     C     NUMDAT        IFGT      1
     C     VOLQTY        IFGE      V2QT(2)
     C  N05              DO
     C                   Z-ADD     V2DIS         VOLDSC
     C                   EXSR      GETVOL
     C                   SETON                                        0405
     C                   GOTO      SKPBLD
     C                   ENDDO
     C                   END
     C     VOLQTY        IFGE      V2QT(1)
     C  N04              DO
     C                   Z-ADD     V1DIS         VOLDSC
     C                   EXSR      GETVOL
     C                   SETON                                        04
     C                   GOTO      SKPBLD
     C                   ENDDO
     C                   END
     C                   END

     C     SKPVOL        TAG
     C***                  WRITEORDCTL
     C                   ENDSR
      *
      /EJECT
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
      ** IF ITEM PRIVE OVERRIDDEN TO 0.00 DO NOT EXTEND ROYALTY
     C     OIOVER        IFEQ      'Y'
     C     OIUPRI        ANDEQ     0.00
     C                   Z-ADD     0             ORUPRI
     C                   Z-ADD     0             OREXT$
     C                   ENDIF
      ****
     C     ORUPRI        IFGT      0.0
?    C                   Z-ADD     0             SEQ
?    C                   MOVE      *BLANKS       ITEM
?    C                   MOVE      *BLANKS       SIZE
?    C     QTYOR         SUB       QTYSHP        ORDQTY
?    C                   Z-ADD     OREXT$        EXTPRC
?    C                   ADD       OREXT$        TOTDOL
?    C                   MOVEL     DESCR         DESC
?    C                   ADD       1             RECNO
?    C                   WRITE     ORDSFL
     C                   Eval      Partial = ' '
     C                   END
     C     ENDROY        ENDSR

      /EJECT
      *****************************
      * GET RID OF PACKING CHARGE *
      *****************************
      * IF SOMETHING CHANGED GET RID OF PACKING CHARGE
     C     UNPACK        BEGSR
     C                   Z-ADD     997           SEQ
     C     OIKEY         CHAIN     FIORDR                             88
     C  N88              DELETE    RIORDR
     C                   ENDSR

      /EJECT
      *****************************
      * BUILD DUMMY CHARGE RECORD *
      *****************************

     C     PCKBLD        BEGSR
     C     OHOLST        IFEQ      'TAG'
     C                   GOTO      ENDPCK
     C                   END
     C                   Z-ADD     997           SEQ
     C     OIKEY         CHAIN     FIORDR                             88
     C   88              DO
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVE      *BLANKS       OIWHSE
     C                   MOVEL     MSG(15)       OIDES1
     C                   MOVEL     *BLANKS       OIDES2
     C                   Z-ADD     VCO           OICOMP
     C                   MOVE      *BLANKS       OIBIN#
     C                   MOVEL     '  '          OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   Z-ADD     0             OIUWGT
     C                   Z-ADD     0             OIUCST
     C                   Z-ADD     SVPACK        OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     0             OIEXT$
     C                   Z-ADD     TOTQTY        OIQORD
     C                   Z-ADD     0             OIAMT1
     C                   Z-ADD     0             OIAMT2
     C                   Z-ADD     0             OIAMT3
     C                   Z-ADD     0             OIDISC
     C                   MOVE      'N'           OIOVER
     C                   MOVE      'N'           OIBOCD
     C                   MOVE      OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVE      OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     VREQDT        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     OHTRDC        OITRDC
     C                   MOVEL     OHCOFL        OICOFL
     C                   MOVEL     'S'           OIITYP
     C                   Eval      OILIST = *Blanks
     C     OHTXST        IFEQ      'Y'
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   ELSE
     C                   MOVE      'Y'           OITXCD
     C                   MOVE      'Y'           OITXST
     C                   MOVE      'Y'           OITXCT
     C                   MOVE      'Y'           OITXLC
     C                   END
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     'N'           OICWT
     C                   Z-ADD     0             OILBS#
     C                   Z-ADD     0             OIWGSH
     C                   MOVE      ' '           OIRSCD
     C                   Z-ADD     0             OISEQP
     C                   MOVE      ' '           OIPRAL
     C                   MOVE      '  '          OIBPUM
     C                   MOVE      '  '          OISUOM
     C                   MOVE      '  '          OIBLUM
     C                   Z-ADD     0             OIMUL2
     C                   MOVEL     'N'           OILOTC
     C                   MOVEL     'N'           OISTA
     C                   MOVEL     OHSHFR        OISHFR
     C                   Z-ADD     0             OITAGS
EFD02C*                    MOVEL'N'       OIPPDC
     C                   MOVE      OHDTCN        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVCD
     C                   MOVEL     OHQUOT        OIQTE
     C                   Z-ADD     OHORDT        OIORDT
     C                   Z-ADD     VREQDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVE      *BLANKS       OILOT#
     C                   MOVE      'N'           OIFRQD
     C                   MOVE      ' '           OISPFL
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVE      *BLANKS       OIPRCL
     C                   MOVE      *BLANKS       OINPSL
     C                   Z-ADD     0             OIRQTY
     C                   MOVE      ' '           OIPOST
     C                   Z-ADD     0             OISOW
     C                   MOVE      'N'           OIPOST
     C                   MOVE      'A'           OISTAT
     C                   Z-ADD     SEQ           OISEQ#
      **** OUTPUT IORDR RECORD
     C                   Z-ADD     VORDER        OIORD#
     C                   MOVE      'N'           OISHCD
     C                   MOVE      'N'           OIPLPT
     C                   Z-ADD     0             OIINV#
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIROY
     C                   MOVE      ' '           OIOPFL
     C                   MOVE      ' '           OIBOLN
     C                   Z-ADD     0             OIBORQ
     C                   MOVE      ' '           OIPRBO
     C                   Z-ADD     0             OIQINV
     C                   WRITE     RIORDR
     C                   ENDDO
     C                   Z-ADD     LSTSEQ        SEQ
     C                   ADD       1             SEQ
     C     OIKEY         SETLL     FIORDR
     C     ENDPCK        ENDSR

      /EJECT
      *****************************
      * CALCULATE PACKING CHARGES *
      *****************************

     C     PACK          BEGSR
     C                   Z-ADD     OISEQ#        HLDSEQ            3 0
     C                   Z-ADD     997           SEQ
     C     OIKEY         CHAIN     FIORDR                             88
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OIITEM
     C                   MOVEL     *BLANKS       OISIZE
     C                   MOVE      *BLANKS       OIWHSE
     C                   MOVEL     MSG(15)       OIDES1
     C                   MOVEL     *BLANKS       OIDES2
     C                   Z-ADD     VCO           OICOMP
     C                   MOVE      *BLANKS       OIBIN#
     C                   MOVEL     '  '          OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   Z-ADD     0             OIUWGT
     C                   Z-ADD     0             OIUCST
     C                   Z-ADD     SVPACK        OIUPRI
     C                   Z-ADD     0             OIQDDC
     C     TOTQTY        MULT      SVPACK        OIEXT$
     C                   Z-ADD     TOTQTY        OIQORD
     C                   Z-ADD     0             OIAMT1
     C                   Z-ADD     0             OIAMT2
     C                   Z-ADD     0             OIAMT3
     C                   Z-ADD     0             OIDISC
     C                   MOVE      'N'           OIOVER
     C                   MOVE      'N'           OIBOCD
     C                   MOVE      OHSLM1        OISLM1
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVE      OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     VREQDT        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     OHTRDC        OITRDC
     C                   MOVEL     OHCOFL        OICOFL
     C                   MOVEL     'S'           OIITYP
     C                   Eval      OILIST = *Blanks
     C     OHTXST        IFEQ      'Y'
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   ELSE
     C                   MOVE      'Y'           OITXCD
     C                   MOVE      'Y'           OITXST
     C                   MOVE      'Y'           OITXCT
     C                   MOVE      'Y'           OITXLC
     C                   END
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     'N'           OICWT
     C                   Z-ADD     0             OILBS#
     C                   Z-ADD     0             OIWGSH
     C                   MOVE      ' '           OIRSCD
     C                   Z-ADD     0             OISEQP
     C                   MOVE      ' '           OIPRAL
     C                   MOVE      '  '          OIBPUM
     C                   MOVE      '  '          OISUOM
     C                   MOVE      '  '          OIBLUM
     C                   Z-ADD     0             OIMUL2
     C                   MOVEL     'N'           OILOTC
     C                   MOVEL     'N'           OISTA
     C                   MOVEL     OHSHFR        OISHFR
     C                   Z-ADD     0             OITAGS
EFD02C*                    MOVEL'N'       OIPPDC
     C                   Z-ADD     OHDTCN        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVCD
     C                   MOVEL     OHQUOT        OIQTE
     C                   Z-ADD     OHORDT        OIORDT
     C                   Z-ADD     VREQDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVE      *BLANKS       OILOT#
     C                   MOVE      'N'           OIFRQD
     C                   MOVE      ' '           OISPFL
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVE      *BLANKS       OIPRCL
     C                   MOVE      *BLANKS       OINPSL
     C                   Z-ADD     0             OIRQTY
     C                   MOVE      ' '           OIPOST
     C                   Z-ADD     0             OISOW
     C                   MOVE      'N'           OIPOST
     C                   MOVE      'A'           OISTAT
     C                   Z-ADD     SEQ           OISEQ#
      **** OUTPUT IORDR RECORD
     C                   Z-ADD     VORDER        OIORD#
     C                   MOVE      'N'           OISHCD
     C                   MOVE      'N'           OIPLPT
     C                   Z-ADD     0             OIINV#
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIROY
     C                   MOVE      ' '           OIOPFL
     C                   MOVE      ' '           OIBOLN
     C                   Z-ADD     0             OIBORQ
     C                   MOVE      ' '           OIPRBO
     C                   Z-ADD     0             OIQINV
     C     OIEXT$        IFNE      0
     C   88              WRITE     RIORDR
     C  N88              UPDATE    RIORDR
     C                   ELSE
     C  N88              DELETE    RIORDR
     C                   END
      ** GET IORDR BACK TO NEXT RECORD
     C     HLDSEQ        IFLE      990
     C                   Z-ADD     LSTSEQ        SEQ
     C                   ADD       1             SEQ
     C     OIKEY         SETLL     FIORDR
     C                   END
     C                   ENDSR

      /EJECT
      **************************
      * CHECK ACTION CODE      *
      **************************

     C     CHKACT        BEGSR
     C                   SETOFF                                       35
     C     ACTNCD        IFEQ      '?'
     C                   EXSR      ACTHLP
     C                   END
     C                   EXSR      ACTTYP
     C     ACTDES        IFEQ      *BLANKS
     C                   SETON                                        1099
     C                   END
     C                   SETOFF                                       2021
     C     ACTNCD        IFEQ      'C'
     C     ACTNCD        OREQ      'D'
     C     ACTNCD        OREQ      'B'
WJB  C     ACTNCD        OREQ      'J'
WJB  C     ACTNCD        OREQ      'R'
WJB  C     ACTNCD        OREQ      'P'
WJB  C     ACTNCD        OREQ      'N'
     C                   Z-ADD     LINE          SEQ
     C     OIKEY         CHAIN     FIORDR                             20
     C   20              SETON                                        2199
     C  N20              MOVE      OIITYP        LINTYP
     C  N20OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C     FIRST         IFEQ      0
     C                   EXSR      GETOR
     C                   END
     C     OIQSHP        IFGT      0
     C                   SETON                                        35
     C                   END
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR

      /EJECT
      **************************
      * GET SCREEN FIELDS      *
      **************************

     C     GETOR         BEGSR
     C                   MOVEL     OIITEM        VITEM
     C                   MOVEL     OISIZE        VSIZE
     C                   MOVEL     OIWHSE        VWHS
     C                   If        OILOTC <> ' '
     C                   MOVEL     OILOTC        VLOTC
     C                   Else
     C                   MOVE      'N'           VLOTC
     C                   EndIf
     C                   Z-ADD     OIQORD        QTYORD
     C                   Z-ADD     OIQORD        ORGQTY
     C                   MOVE      OIOVER        VOVER
     C                   Z-ADD     OIQDDC        VDISC
     C                   Z-ADD     OIUPRI        VUPRIC
     C                   Z-ADD     OIEXT$        VEXT
     C                   MOVEL     OIUUOM        VUOM
     C                   Z-ADD     OITAGS        VTAGS
     C                   Z-ADD     OIDTRQ        VREQDT
 WJB C                   MOVE      *Blanks       OLDCOMMENT       35
  |   /Free
  |     Exec SQL
  |       Select B2BCMNT into :B2BCOMMENT
  |         from FIORDRB2BC
  |        Where B2BORD# = :OIORD#
  |          and B2BSEQ# = :OISEQ#
  |        Order by B2BORD#, B2BSEQ#, B2BTIME desc
  |       Fetch First Row Only;
  |       OLDCOMMENT = B2BCOMMENT;
 WJB  /End-Free
     C                   ENDSR

      /EJECT
      **************************
      * GET ACTION CODE SCREEN *
      **************************

     C     ACTHLP        BEGSR
     C                   SETOFF                                       101112
     C                   SETOFF                                       131415
     C                   SETOFF                                       20
     C                   MOVE      *BLANKS       ADD
     C                   MOVE      *BLANKS       CHG
     C                   MOVE      *BLANKS       DELE
     C                   MOVE      *BLANKS       INSERT
WJB  C                   MOVE      *BLANKS       BO
WJB  C                   MOVE      *BLANKS       ADJUST
WJB  C                   MOVE      *BLANKS       RESOW
WJB  C                   MOVE      *BLANKS       PARTSP
WJB  C                   MOVE      *BLANKS       NAGERM

     C     NXTSA         TAG
     C                   WRITE     SCRACT
     C                   READ      SCRACT                                 91
     C                   IF        ACTNCD = '?' or
     C                             ACTNCD = ' '
     C     ADD           COMP      'X'                                1010
     C     ADD           COMP      'A'                                1010
     C   10CHG           COMP      'X'                                1010
     C   10CHG           COMP      'C'                                1010
     C   10DELE          COMP      'X'                                1010
     C   10DELE          COMP      'D'                                1010
     C   10INSERT        COMP      'X'                                1010
     C   10INSERT        COMP      'I'                                1010
     C   10BO            COMP      'X'                                1010
     C   10BO            COMP      'B'                                1010
WJB  C   10ADJUST        COMP      'X'                                1010
WJB  C   10ADJUST        COMP      'J'                                1010
WJB  C   10RESOW         COMP      'X'                                1010
WJB  C   10RESOW         COMP      'R'                                1010
WJB  C   10PARTSP        COMP      'X'                                1010
WJB  C   10PARTSP        COMP      'P'                                1010
WJB  C   10NAGERM        COMP      'X'                                1010
WJB  C   10NAGERM        COMP      'N'                                1010
     C   10              GOTO      NXTSA
      ** MAKE SURE ONLY SELECTED AND LOAD ACTION CODE (ACTNCD)
     C                   Z-ADD     1             X2                2 0
     C     X2            DOWLE     18
     C     *IN11         ANDEQ     *OFF
     C     JUST1         COMP      JUST1A(X2)                             11
     C   11              MOVE      CODE1A(X2)    ACTNCD
     C                   ADD       1             X2
     C                   ENDDO
     C  N11              SETON                                        1020
WJB  C   10              GOTO      NXTSA
      *
WJB  C*           ADD       COMP 'X'                      11
WJB  C*           CHG       COMP 'X'                      12
WJB  C*           DELE      COMP 'X'                      13
WJB  C*           INSERT    COMP 'X'                      14
WJB  C*           BO        COMP 'X'                      15
WJB  C*   11 12
WJB  C*OR 11 13
WJB  C*OR 11 14
WJB  C*OR 11 15
WJB  C*OR 12 13
WJB  C*OR 12 14
WJB  C*OR 12 15             SETON                     1020
WJB  C*   13 14
WJB  C*OR 13 15
WJB  C*OR 14 15             SETON                     1020
WJB  C*   10                GOTO NXTSA
WJB  C*   11                MOVEL'A'       ACTNCD
WJB  C*   12                MOVEL'C'       ACTNCD
WJB  C*   13                MOVEL'D'       ACTNCD
WJB  C*   14                MOVEL'I'       ACTNCD
WJB  C*   15                MOVEL'B'       ACTNCD
     C                   EndIf
     C                   SETOFF                                       1020
     C                   ENDSR

      /EJECT
      **************************
      * BUILD TAG ORDER        *
      **************************

     C     BTGORD        BEGSR
      ** GET ORDER NUMBER
     C                   Z-ADD     0             OEC               2 0
     C     OEKEY         CHAIN     FOECTL                             90
     C                   MOVE      OCNORD        TORDER            6 0
     C     OCNORD        ADD       1             OCNORD
     C                   UPDATE    ROECTL
      ** OUTPUT LINE 1 ON ORIG ORDER WITH TAG ORDER NUMBER
     C                   Z-ADD     1             SEQ
     C     OIKEY         CHAIN     FIORDR                             91
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(13)       OIDES1
     C                   MOVEL     TORDER        OIDES1
     C                   MOVE      *BLANKS       OIDES2
     C                   Z-ADD     VCO           OICOMP
     C                   MOVE      *BLANKS       OIWHSE
     C                   MOVE      *BLANKS       OIBIN#
     C                   MOVE      *BLANKS       OIUUOM
     C                   Z-ADD     0             OIMULT
     C                   Z-ADD     0             OIUWGT
     C                   Z-ADD     0             OIUCST
     C                   Z-ADD     0             OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   Z-ADD     0             OIEXT$
     C                   Z-ADD     0             OIQORD
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIROY
     C                   Z-ADD     0             OIAMT1
     C                   Z-ADD     0             OIAMT2
     C                   Z-ADD     0             OIAMT3
     C                   Z-ADD     0             OIDISC
     C                   Z-ADD     OHSCM1        OICOM1
     C                   MOVE      OHSLM2        OISLM2
     C                   Z-ADD     OHSCM2        OICOM2
     C                   Z-ADD     OHCUST        OICUST
     C                   Z-ADD     OHDTRQ        OIDTRQ
     C                   Z-ADD     TDATE         OIDTLA
     C                   Z-ADD     TIMOD         OITIME
     C                   MOVEL     USERID        OIUSER
     C                   Z-ADD     0             OITRDC
     C                   MOVEL     'N'           OICTCD
     C                   MOVEL     OHCOFL        OICOFL
     C                   MOVEL     'C'           OIITYP
     C                   Eval      OILIST = *Blanks
     C                   Z-ADD     0             OIQINV
     C     OIITYP        IFEQ      'C'
     C                   Eval      OILIST = *Blanks
     C                   MOVE      'N'           OITXCD
     C                   MOVE      'N'           OITXST
     C                   MOVE      'N'           OITXCT
     C                   MOVE      'N'           OITXLC
     C                   END
     C                   MOVEL     OHROUT        OIROUT
     C                   Z-ADD     OHSTOP        OISTOP
     C                   MOVEL     'N'           OICWT
     C                   Z-ADD     0             OILBS#
     C                   Z-ADD     0             OIWGSH
     C                   MOVE      ' '           OIRSCD
     C                   Z-ADD     0             OISEQP
     C                   MOVE      ' '           OIPRAL
     C                   MOVE      *BLANKS       OIBPUM
     C                   MOVE      *BLANKS       OISUOM
     C                   MOVE      *BLANKS       OIBLUM
     C                   Z-ADD     1.0000        OIMUL2
     C                   MOVE      ' '           OIOPFL
     C                   MOVE      ' '           OIBOLN
     C                   Z-ADD     0             OIBORQ
     C                   MOVE      ' '           OIPRBO
     C                   MOVEL     OHSTA         OISTA
     C                   MOVEL     'TAG'         OISHFR
     C                   Z-ADD     0             OITAGS
EFD02C*                    MOVEL'N'       OIPPDC
     C                   Z-ADD     OHDTCN        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVCD
     C                   MOVEL     OHQUOT        OIQTE
     C                   Z-ADD     OHORDT        OIORDT
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        OIRVDT
     C                   MOVE      *BLANKS       OILOT#
     C                   MOVE      'N'           OIFRQD
     C                   MOVE      ' '           OISPFL
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVE      *BLANKS       OIPRCL
     C                   MOVE      *BLANKS       OINPSL
     C                   Z-ADD     0             OIRQTY
     C                   MOVE      ' '           OIPOST
     C                   Z-ADD     0             OISOW
     C                   MOVE      'A'           OISTAT
     C   91              Z-ADD     1             OISEQ#
      **** OUTPUT IORDR RECORD
     C                   Z-ADD     VORDER        OIORD#
     C                   MOVE      'N'           OISHCD
     C                   MOVE      'N'           OIPLPT
     C                   Z-ADD     0             OIINV#
     C   91              WRITE     RIORDR
     C  N91              UPDATE    RIORDR
      ** OUTPUT LINE 1 ON TAG ORDER WITH ORIG ORDER NUMBER
     C                   Z-ADD     1             SEQ
     C     OIKEYT        KLIST
     C                   KFLD                    TORDER
     C                   KFLD                    SEQ
     C     OIKEYT        CHAIN     FIORDR                             91
     C                   MOVEL     MSG(14)       OIDES1
     C                   MOVEL     VORDER        OIDES1
     C                   Z-ADD     TORDER        OIORD#
     C                   MOVE      'N'           OISHCD
     C                   MOVE      'N'           OIPLPT
     C                   Z-ADD     0             OIINV#
     C   91              WRITE     RIORDR
     C  N91              UPDATE    RIORDR
      * OUTPUT HEADER RECORD   *
     C                   Z-ADD     TORDER        OHORD#
     C                   MOVEL     'TAG   '      OHOLST
     C                   MOVEL     'TAG'         OHSHFR
     C                   WRITE     RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR100'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
SUD01C                   Exsr      WriteUpdRec
      ** NOW GET DETAIL LINES
     C                   Z-ADD     0             SEQ
     C     OIKEY         SETLL     FIORDR

     C     NXTTAG        TAG
     C     VORDER        READE     RIORDR                                 90
     C   90              GOTO      ENDTAG
     C     OIITYP        IFNE      ' '

     C     OITAGS        OREQ      0
     C                   GOTO      NXTTAG
     C                   ENDIF
     C                   MOVEL     'TAG'         OISIZE
     C                   MOVE      *BLANKS       OIWHSE
     C                   Z-ADD     OITAGS        OIQORD
     C                   Z-ADD     0             OITAGS
     C     OIMKEY        CHAIN     FMINVT                             90
     C                   ADD       OITAGS        IMQTAL
     C                   Z-ADD     0             VDISC
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   MOVE      *BLANKS       OIPRCL
     C  N90              DO
     C                   MOVEL     IMPCL1        OIPRCL
     C                   Z-ADD     TDATE         IMDTLO
     C                   UPDATE    RMINVT
     C                   MOVEL     IMDES1        OIDES1
     C                   MOVEL     IMDES2        OIDES2
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMPUOM
     C                   PARM                    QTYORD
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    VDISC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
     C                   Z-ADD     #OPRC         VUPRIC
     C                   Z-ADD     #OPRC         OIUPRI
     C                   Z-ADD     OIQORD        QTYORD
     C                   EXSR      #EXLN
     C                   Z-ADD     #LINNT        OIEXT$
     C                   Z-ADD     0             OIQDDC
     C                   ENDDO
     C   90              DO
     C                   MOVE      'N'           OIITYP
     C                   Eval      OILIST = *Blanks
     C                   Z-ADD     0             OIEXT$
     C                   Z-ADD     0             OIUPRI
     C                   Z-ADD     0             OIQDDC
     C                   ENDDO
     C                   Z-ADD     TORDER        OIORD#
     C                   WRITE     RIORDR
     C     OISEQ#        ADD       1             SEQ
     C     OIKEY         SETLL     FIORDR
     C                   GOTO      NXTTAG

     C     ENDTAG        TAG
     C     VORDER        CHAIN     FTAGXR                             90
     C                   Z-ADD     VORDER        TGOORD
     C                   Z-ADD     TORDER        TGTORD
     C                   Z-ADD     TORDER        TGORDT
     C                   MOVE      'A'           TGSTAT
     C                   MOVE      'N'           TGPRTD
     C                   Z-ADD     VORDTE        TGORDT
     C   90              WRITE     RTAGXR
     C  N90              UPDATE    RTAGXR
     C                   ENDSR

      /EJECT
      **************************
      * GET ACTION TYPE        *
      **************************

     C     ACTTYP        BEGSR
     C                   SETOFF                                       59
     C     ACTNCD        IFEQ      'A'
     C                   MOVEL     MSG(1)        ACTDES
     C                   SETOFF                                       102025
     C                   SETON                                        30
     C                   Z-ADD     0             ORGQTY           11 1
     C                   GOTO      ENDACT
     C                   END
     C     ACTNCD        IFEQ      'B'
     C                   MOVEL     MSG(20)       ACTDES
     C                   SETOFF                                       103025
     C                   SETON                                        20  59
     C                   GOTO      ENDACT
     C                   END
     C     ACTNCD        IFEQ      'C'
     C                   MOVEL     MSG(2)        ACTDES
     C                   SETOFF                                       103025
     C                   SETON                                        20
     C                   GOTO      ENDACT
     C                   END
     C     ACTNCD        IFEQ      'D'
     C                   MOVEL     MSG(3)        ACTDES
     C                   SETOFF                                       103025
     C                   SETON                                        20
     C                   GOTO      ENDACT
     C                   END
     C     ACTNCD        IFEQ      'I'
     C                   MOVEL     MSG(4)        ACTDES
     C                   SETOFF                                       103025
     C                   SETON                                        20
     C                   GOTO      ENDACT
     C                   END
WJB  C     ACTNCD        IFEQ      'J'                                          ADJUST
WJB  C                   MOVEL     MSG(21)       ACTDES
WJB  C                   SETOFF                                       103025
WJB  C                   SETON                                        20
WJB  C                   GOTO      ENDACT
WJB  C                   END
WJB  C     ACTNCD        IFEQ      'R'                                          RESOW
WJB  C                   MOVEL     MSG(22)       ACTDES
WJB  C                   SETOFF                                       103025
WJB  C                   SETON                                        20
WJB  C                   GOTO      ENDACT
WJB  C                   END
WJB  C     ACTNCD        IFEQ      'P'                                          PARTIAL SHIP
WJB  C                   MOVEL     MSG(23)       ACTDES
WJB  C                   SETOFF                                       103025
WJB  C                   SETON                                        20
WJB  C                   GOTO      ENDACT
WJB  C                   END
WJB  C     ACTNCD        IFEQ      'N'                                          N/A - POOR GERM
WJB  C                   MOVEL     MSG(24)       ACTDES
WJB  C                   SETOFF                                       103025
WJB  C                   SETON                                        20
WJB  C                   GOTO      ENDACT
WJB  C                   END
     C                   MOVE      *BLANKS       ACTDES
     C                   SETON                                        1099
     C     ENDACT        ENDSR

      /EJECT
      **************************
      * CHECK LINE TYPE        *
      **************************

     C     CHKTYP        BEGSR
     C     LINTYP        IFEQ      '?'
     C                   EXSR      LINHLP
     C                   END
     C                   EXSR      GTLNTP
     C                   ENDSR

      /EJECT
      **************************
      * GET LINE TYPE SCREEN   *
      **************************

     C     LINHLP        BEGSR
     C                   SETOFF                                       202122
     C                   SETOFF                                       232425
     C                   SETOFF                                       20
     C                   MOVE      *BLANKS       STOCK
     C                   MOVE      *BLANKS       NSTOCK
     C                   MOVE      *BLANKS       COMENT
     C                   MOVE      *BLANKS       FREIGT
     C                   MOVE      *BLANKS       SPECHG

     C     NXTTY         TAG
     C                   WRITE     SCRTYP
     C                   READ      SCRTYP                                 91
     C     STOCK         COMP      'X'                                2020
     C   20NSTOCK        COMP      'X'                                2020
     C   20COMENT        COMP      'X'                                2020
     C   20FREIGT        COMP      'X'                                2020
     C   20SPECHG        COMP      'X'                                2020
     C   20              GOTO      NXTTY
      *
      ** MAKE SURE ONLY SELECTED
      *
     C     STOCK         COMP      'X'                                    21
     C     NSTOCK        COMP      'X'                                    22
     C     COMENT        COMP      'X'                                    23
     C     FREIGT        COMP      'X'                                    24
     C     SPECHG        COMP      'X'                                    25
     C   21
     CAN 22
     COR 21
     CAN 23
     COR 21
     CAN 24
     COR 21
     CAN 25
     COR 22
     CAN 23
     COR 22
     CAN 24
     COR 22
     CAN 25              SETON                                          20
     C   23
     CAN 24
     COR 24
     CAN 25
     COR 23
     CAN 25              SETON                                          20
     C   20              GOTO      NXTTY
     C   21              MOVEL     ' '           LINTYP
     C   21              SETON                                        46
     C  N21              SETOFF                                       46
     C   22              MOVEL     'N'           LINTYP
     C   23              MOVEL     'C'           LINTYP
     C   24              MOVEL     'F'           LINTYP
     C   25              MOVEL     'S'           LINTYP
     C                   SETOFF                                         20
     C                   ENDSR

      /EJECT
      **************************
      * GET LINE TYPE          *
      **************************

     C     GTLNTP        BEGSR
     C     LINTYP        IFEQ      ' '
     C                   MOVEL     MSG(5)        TYPDES
     C                   GOTO      ENDGLT
     C                   END
     C     LINTYP        IFEQ      'N'
     C                   MOVEL     MSG(6)        TYPDES
     C                   GOTO      ENDGLT
     C                   END
     C     LINTYP        IFEQ      'F'
     C                   MOVEL     MSG(10)       TYPDES
     C                   GOTO      ENDGLT
     C                   END
     C     LINTYP        IFEQ      'C'
     C                   MOVEL     MSG(7)        TYPDES
     C                   GOTO      ENDGLT
     C                   END
     C     LINTYP        IFEQ      'S'
     C                   MOVEL     MSG(8)        TYPDES
     C                   GOTO      ENDGLT
     C                   END
     C                   MOVE      *BLANKS       TYPDES
     C                   SETON                                        3099
     C     ENDGLT        ENDSR
      *
      **** VALIDATE TERMS
      *
      /EJECT
      **************************
      * GET TERMS              *
      **************************
     C     GETTRM        BEGSR
     C                   SETOFF                                       9031
     C     VTRMCD        CHAIN(N)  FMTERM                             90
     C   90              SETON                                        31
     C  N90TCTDAY        IFGT      0
     C                   MOVE      'Y'           ORDPPD            1
EFD02C                   MOVE      'Y'           OIPPDC
     C                   SETON                                        74
     C                   ELSE
     C                   MOVE      'N'           ORDPPD
EFD02C                   MOVE      'N'           OIPPDC
     C                   SETOFF                                       74
     C                   END
     C                   ENDSR
      /EJECT
      *
      **** VALIDATE SHIP VIA
      *
     C     GETSHV        BEGSR
     C                   SETOFF                                         27
     C     SVKEY         KLIST
     C                   KFLD                    VSVCD             2
     C     SVKEY         CHAIN     FMSVIA                             27
     C                   ENDSR
      /EJECT
      *
      **** DISPLAY EXTRA DESCRIPTION
      *
     C     ADDDSC        BEGSR
     C                   WRITE     SCRNCI
     C                   READ      SCRNCI                                 90
     C                   ENDSR
      /EJECT
      *
      **** VALIDATE SHIP FROM
      *
     C     GETSFR        BEGSR
     C     VSHFR         CHAIN(N)  FMWHSE                             90
     C   90              SETON                                        26
     C  N90              MOVEL     WHREG         SHPREG            2
     C                   ENDSR
      /EJECT
      *
      **** GET CUSTOMER NOTES
      *
     C     GETNOT        BEGSR
     C                   Z-ADD     01            CCSEQ             2 0
     C     KEY8          KLIST
     C                   KFLD                    VSCUST
     C                   KFLD                    CCSEQ
     C     KEY8          CHAIN(N)  FCUSTCOM                           90
     C                   ENDSR
      /EJECT
      *
      **** VALIDATE SALESPERSON 1
      *
     C     GETSLP        BEGSR
     C     VSLSM1        CHAIN(N)  FMSLSM                             90
     C   90              SETON                                        38
     C   90              MOVE      *BLANKS       SNAME1
     C  N90              MOVEL     SMNAME        SNAME1
     C                   ENDSR
      /EJECT
      *
      **** VALIDATE SALESPERSON 2
      *
     C     GETSL2        BEGSR
     C     VSLSM2        CHAIN(N)  FMSLSM                             90
     C   90              SETON                                        38
     C   90              MOVE      *BLANKS       SNAME2
     C  N90              MOVEL     SMNAME        SNAME2
     C                   ENDSR
      /EJECT
      *
      * SALESPERSON LOOKUP
      *
     C     LKPSLP        BEGSR
     C                   MOVEL     VSLSM         SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLSM
     C                   MOVEL     SMSLSM        VSLSM
     C                   ENDSR
      /EJECT
      *
      * ITEM LOOKUP
      *
     C     ITMSRC        BEGSR
     C                   MOVEL     *BLANKS       IMLOOK
     C     11            SUBST     VITEM:2       IMLOOK
     C                   MOVEL     VSIZE         IMSIZE
     C***                  CALL 'ITMALOOK'
     C                   CALL      'LKITEM'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    DESHFR
     C                   MOVEL     IMITEM        VITEM
     C                   MOVEL     IMSIZE        VSIZE
     C                   MOVEL     IMWHSE        VWHS
      *
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     ITMKEY        CHAIN(N)  FMINVT                             90
     C     VITEM         CHAIN     FIADD                              31
     C  N31              SETON                                        07
     C   31              DO
     C                   SETOFF                                       07
     C                   SETOFF                                       31
     C                   ENDDO
     C                   EXSR      GETPRI
     C                   EXSR      GETDES
     C                   ENDSR
      /EJECT
      **
      * GET DESCRIPTION
      **
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   If        %Subst(OIDES1:1:6) = 'Adj: ('
     C                             and ACTNCD <> 'A'
     C                   Eval      VDESC = OIDES1
     C                   Else
     C                   MOVEL     DESCO         VDESC            50
     C                   EndIf
     C**                   MOVE 'N'       VOVER
     C                   MOVE      IMBPUM        VUOM
     C     PRCKEY        KLIST
     C                   KFLD                    IMPCL1
     C     PRCKEY        CHAIN     FMPRCL                             90
     C                   ENDSR
      /EJECT
      *
      **** CHANGE ALLOCATIONS
      *
     C     CHGALO        BEGSR
     C     VITEM         IFNE      OIITEM
     C     VSIZE         ORNE      OISIZE
     C     VREQDT        ORNE      OIDTRQ
      ** IF ITEM SIZE OR REQ DATE CHANGED GET RID OF OLD ALLOC
     C     OIQORD        SUB       OIQSHP        QTY
72012C                   If        VITEM <> OIITEM or VSIZE <> OISIZE
     C                   MOVE      'N'           DEALL
     C                   EXSR      DELALO
72012C                   EndIF
      ** RELIEVE NON LOT
     C     OIITYP        IFEQ      ' '
     C     OIMKEY        CHAIN     FMINVT                             31
     C     IMLOTC        IFNE      'Y'
     C                   UNLOCK    FMINVT
     C                   Z-ADD     0             NEWQTY
     C                   Z-ADD     QTY           OLDQTY
     C                   CALL      'ALOCATE'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    OHCOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   END
     C                   END
      ** NOW GET NEW ALLOCATION
     C                   MOVEL     VITEM         IMITEM
     C                   MOVEL     VSIZE         IMSIZE
     C                   MOVEL     VWHS          IMWHSE
     C     IMLOTC        IFNE      'Y'
     C                   UNLOCK    FMINVT
     C                   Z-ADD     QTYORD        NEWQTY
     C                   Z-ADD     0             OLDQTY
     C                   CALL      'ALOCATE'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    OHCOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   END
     C                   Z-ADD     QTYORD        QTY
     C                   Z-ADD     0             QTYA
     C                   EXSR      ALLO
     C                   Z-ADD     QTYA          OIQTAL
     C                   GOTO      ENDCHG
     C                   ENDIF
      ** IF HERE ONLY QTY CHANGED
     C     QTYORD        IFGT      OIQORD
      ** NOW GET NEW ALLOCATION
     C                   MOVEL     VITEM         IMITEM
     C                   MOVEL     VSIZE         IMSIZE
     C                   MOVEL     VWHS          IMWHSE
     C                   Z-ADD     QTYORD        QTY
     C                   Z-ADD     OIQTAL        QTYA
     C*    IMLOTC        IFEQ      'Y'
     C*                  EXSR      ALLO
     C*                  Z-ADD     QTYA          OIQTAL
     C*                  END
     C     OIMKEY        CHAIN     FMINVT                             31
     C     IMLOTC        IFEQ      'Y'
     C                   EXSR      ALLO
     C                   Z-ADD     QTYA          OIQTAL
     C                   END
     C     IMLOTC        IFNE      'Y'
     C                   UNLOCK    FMINVT
     C                   Z-ADD     QTYORD        NEWQTY
     C                   Z-ADD     OIQORD        OLDQTY
     C                   CALL      'ALOCATE'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    OHCOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   END
     C                   GOTO      ENDCHG
     C                   END
      ** IF HERE ONLY QTY REDUCED
      ** RELIEVE NON LOT
     C     OIITYP        IFEQ      ' '
     C     OIMKEY        CHAIN     FMINVT                             31
wjb  C*    IMLOTC        IFEQ      'Y'
wjb  C*                  MOVE      'N'           DEALL
wjb  C*                  EXSR      DELALO
wjb  C*                  END
wjb2 C     IMLOTC        IFEQ      'Y'
     C                   Z-ADD     6             SPCL#             1 0
wjb2 C                   EXSR      SPCL
wjb2 C                   END
     C     IMLOTC        IFNE      'Y'
     C                   UNLOCK    FMINVT
     C                   Z-ADD     QTYORD        NEWQTY
     C                   Z-ADD     OIQORD        OLDQTY
     C                   CALL      'ALOCATE'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    NEWQTY           11 1
     C                   PARM                    OLDQTY           11 1
     C                   PARM                    OHCOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   END
     C                   END
     C     ENDCHG        ENDSR
      /EJECT
      *
      **** GET ALLOCATIONS
      *
     C     ALLO          BEGSR
     C     #QORID        IFNE      'Y'
     C                   Z-ADD     5             SPCL#             1 0
     C                   EXSR      SPCL
     C                   END
     C                   ENDSR
      /EJECT
      *
      **** REMOVE ALLOCATIONS ONLY
      *
     C     DELALO        BEGSR
     C                   UNLOCK    FMINVT
     C                   CALL      'ALOCD'
     C                   PARM                    QTY
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   PARM                    DEALL             1            DELETE ALL Y
     C                   ENDSR
      /EJECT
      *
      **** GET COMMON FIELDS IN BROKER DETAIL LINES
      *
     C     BRKFIX        BEGSR
     C     OHORD#        SETLL     FIORDR

     C     NXTFIX        TAG
     C     OHORD#        READE     FIORDR                                 90
     C  N90              DO
     C                   Z-ADD     OHCUST        OICUST
     C                   MOVEL     OHALPH        OIALPH
     C                   MOVEL     'N'           OIFRQD
EFD02C*                    MOVEL'N'       OIPPDC
     C                   MOVEL     'N'           OISTA
     C                   MOVEL     OHCOFL        OICOFL
     C                   UPDATE    RIORDR
     C                   GOTO      NXTFIX
     C                   END
     C                   ENDSR
      /EJECT
      *
      *
      **** REMOVE ALLOCATIONS AND AVAILABLE
      *
     C     DELALD        BEGSR
     C                   UNLOCK    FMINVT
     C                   CALL      'ALOCDA'
     C                   PARM                    QTY
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   PARM                    DEALL             1            DELETE ALL Y
     C                   ENDSR
      /EJECT
      *
      **** GET PRICE
      *
     C     GETPRI        BEGSR
     C****                 MOVE OHPRCD    PRICD
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    VUOM
     C                   PARM                    QTYORD
     C                   PARM                    PRICD
     C                   PARM                    #OPRC             9 4
     C                   PARM                    VDISC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
     C                   Z-ADD     #OPRC         VUPRIC
     C                   ENDSR
      /EJECT
      *
      **** VALIDATE ORDER LIST
      *
     C     GETORL        BEGSR
      ** VMORLS
     C     VMORLS        IFNE      '*NONE'
     C     VMORLS        CHAIN     FMORLH                             90
     C   90              SETON                                        42
     C   90              MOVE      *BLANKS       OMORLS            5
     C  N90              DO
     C     VMORLS        IFNE      OMORLS
     C**         HLFRCD    IFGT 0
     C**                   Z-ADDHLFRCD    VFRTCD
     C**                   END
     C*          VMORLS    IFEQ '*NONE'
     C*                    MOVEL'000001'  VMORLS
     C*                    END
     C                   MOVEL     VMORLS        OMORLS
     C                   END                                                    VMORLS<>OMOR
     C                   ENDDO                                                  N90  DO
     C                   END                                                    MORLS<>*NONE
     C                   ENDSR
      /EJECT
      *
      **** Lock Special Prices if CUSTOM Order
      *
     C     LockCustom    BEGSR
      *
     C     VORDER        SetLL     FHORDRCSTM
     C                   If        %Equal(FHORDRCSTM)
     C                   Call      '#SETSPCPRC'
     C                   Parm                    VORDER
     C                   Parm      'Y'           P_OVER            1
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *
      **** VALIDATE FREIGHT TYPE
      *
     C     GETPPC        BEGSR
     C     VPPCOL        CHAIN     FFRTYP                             90
     C   90              SETON                                        33
     C                   ENDSR
      /EJECT
      *
      * CLEAR FIELDS SCREEN A
      *
     C     CLRA          BEGSR
     C                   Z-ADD     *ZEROS        VSCUST
     C*                    Z-ADD*ZEROS    VBCUST
     C                   Z-ADD     *ZEROS        VORDER
     C                   MOVEL     *BLANKS       VQUOTE
     C                   MOVEL     *BLANKS       VSNAME
     C                   MOVEL     *BLANKS       VPURCH
     C                   MOVEL     *BLANKS       VROUTE
     C                   MOVEL     *BLANKS       PRCCHG            1
     C                   Z-ADD     0             VSTOP
     C                   Z-ADD     0             ORQDTE            6 0
     C                   MOVEL     *BLANKS       VSHFR
     C**                   MOVEL*BLANKS   VBNAME
     C                   MOVEL     *BLANKS       CCCOM1
     C                   MOVEL     *BLANKS       CCCOM2
     C                   Z-ADD     *ZEROS        CURAR
     C                   Z-ADD     *ZEROS        AR1
     C                   Z-ADD     *ZEROS        AR2
     C                   Z-ADD     *ZEROS        AR3
     C                   Z-ADD     *ZEROS        AR4
     C                   Z-ADD     *ZEROS        TOTAR
     C                   ENDSR
      /EJECT
      *
      ** CALC EXTENSION
     C     #EXLN         BEGSR
      *
      *  SUBROUTINE #EXLN IS USED TO EXTEND THE VALUE OF A ORDER DETAIL
      *  LINE
      *
      *  USER WILL NEED TO LOAD FIELDS AS FOLLOWS
      *       ORDQTY    CONTAINS QUANTITY
      *       VUPRIC    CONTAINS PRICE
      *       VDISC     CONTAINS QUANTITY DISCOUNT PCT.
      *       #WKWGT    CONTAINS WEIGHT PER UNIT OF MEASURE
      *       #CWFLG    CATCH WEIGHT ITEM 'Y' OR 'N'
      *
      *       SUBROUTINE WILL RETURN THE FOLLOWING:
      *
      *       #LINGR    EXTENDED GROSS AMOUNT
      *       #LINNT    EXTENDED NET AMOUNT
      *       #LINDS    DISCOUNT DOLLAR AMOUNT
      *
     C     *LIKE         DEFINE    IMUWGT        #WKWGT
     C                   MOVE      #CWFLG        #CWFLG            1
      *
     C*          #CWFLG    IFEQ 'Y'
     C*          #WRFRQ    MULT #WKWGT    #WRFRQ    H
     C*                    END
      *
      *  EXTEND GROSS AMOUNT
      *
     C     QTYORD        MULT(H)   VUPRIC        #LINGR            9 2
      *
      *  ADJUST FOR DISC. PCT.
      *
     C     VDISC         IFGT      0
     C                   MOVE      VDISC         WKDISC            4 4
     C     1             SUB       WKDISC        WKDISC
     C     VUPRIC        MULT(H)   WKDISC        #PRC             11 4
     C                   ELSE
     C                   Z-ADD     VUPRIC        #PRC
     C                   END
      *
      *  CALCULATE LINE NET AMOUNT
      *
     C     QTYORD        MULT(H)   #PRC          #LINNT            9 2
      *
      *  CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       #LINNT        #LINDS            7 2
      *
     C                   ENDSR

      /EJECT
    ?D/COPY QFunctDefn,$ErrMsgSr

      /EJECT
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVEL     01            VCO
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        TDATEC            7 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
      ** GET TO MONDAY DAY NUMBER OF WEEK WE WANT TO ALLOCATE
      ** IF TUE OR EARLIER ALLOCATE TWO WEEKS AGO,
      ** IF WED OR LATER ALLOCATE LAST WEEK
     C     #Y            IFNE      1
     C     #Y            SUB       1             LFT#              2 0
     C                   SUB       LFT#          ##DDD
     C                   END
     C*          #Y        IFGT 2
     C**         ##DDD     SUB  7         LSTWK   50
     C     ##DDD         ADD       7             LSTWK             5 0
     C*                    ELSE
     C*          ##DDD     SUB  14        LSTWK   50
     C*                    END
     C     LINKEY        KLIST
     C                   KFLD                    VORDER
     C                   KFLD                    OISEQ#
     C                   Eval      $ERR_PROG  = 'BIR100'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library
     C                   ENDSR
SUD01 /Free
  |   //--------------------------------------------------------------------
  |   *?                :------------------------:
  |   *?                : WriteUpdRec Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Move Values into FHORDRSHTO File Fields
  |   *?
  |     Begsr WriteUpdRec;
  |
  |   *?   // Check Record Exists
  |        Chain (VORDER:VSCUST) FHORDRSHTL;
  |        If Not %Found;
  |           OSORD# = VORDER;
  |           OSCUST = VSCUST;
  |           OSSEQ# = VSSEQ#;
  |           OSCRTDAT = RunDate;
  |           OSCRTTIM = RunTime;
  |           OSCRTUSR = UserId;
  |           OSCRTJOB = JobId;
  |           OSCRTPGM = Pgm;
  |           Write FHORDRSHTR;
  |        Else;
  |           OSSEQ#   = VSSEQ#;
  |           OSUPDDAT = RunDate;
  |           OSUPDTIM = RunTime;
  |           OSUPDUSR = UserId;
  |           OSUPDJOB = JobId;
  |           OSUPDPGM = Pgm;
  |           Update FHORDRSHTR %Fields(OSSEQ#:OSUPDDAT:OSUPDTIM:
  |                                   OSUPDUSR:OSUPDJOB:OSUPDPGM);
  |        Endif;
  |     Endsr;
  |
SUD01 /End-Free

      /free
       dcl-proc is_B2B_Order;
         DCL-PI *n ind;
           inOrder  Zoned(6:0) Const;
         END-PI;
         dcl-s is_B2B ind inz(*off);

         Exec SQL
           Select '1' into :is_B2B from WSPOHDRPF where PHORDNO = :inOrder;

         return is_B2B;

       END-PROC;


       dcl-proc is_KP_Order;
         DCL-PI *n ind;
           inOrder  Zoned(6:0) Const;
         END-PI;
         dcl-s is_KP ind inz(*off);

        Exec SQL
          Select '1' into :is_KP from FHORDR where OHORD# = :inOrder
          and OHCUST in (1521,2730,8077,6417,7544,7543,373);

         If not is_KP and
          ( VSCUST = 1251
         or VSCUST = 2730
         or VSCUST = 8077
         or VSCUST = 6417
         or VSCUST = 7544
         or VSCUST = 7543
         or VSCUST = 373 );
           is_KP = *On;
         ENDIF;

         return is_KP;

       END-PROC;


      /End-Free

      ******************
** MESSAGE ARRAY
Add                                                        1
Change                                                     2
Delete                                                     3
Insert                                                     4
Stock Item                                                 5
Non-Stock                                                  6
Comment                                                    7
CHARGE FOR BOXES                                           8
*** End of Order ***                                       9
FREIGHT CHARGE                                             10
NO Certificate Required                                    11
*** Certificate Required ***                               12
       <-Tag Order #                                       13
       <-Plant Order #                                     14
Packing Charges                                            15
Royalty -                                                  16
8888888888888888888888888888                               17
9999999999999999999999999999                               18
Requested Ship Date -                                      19
Backorder                                                  20
Adjust                                                     21  WJB-ADD
ReSow                                                      22  WJB-ADD
Partial                                                    23  WJB-ADD
N/A Germ                                                   24  WJB-ADD
Import                                                     25  WJB-ADD
**  JUST1A - JUST ONE ARRAY
X         A<- ADD
A         A<- ADD
 X        C<- CHG
 C        C<- CHG
  X       D<- DELE
  D       D<- DELE
   X      I<- INSERT
   I      I<- INSERT
    X     B<- BO
    B     B<- BO
     X    J<- ADJUST
     J    J<- ADJUST
      X   R<- RESOW
      R   R<- RESOW
       X  P<- PARTSP
       P  P<- PARTSP
        X N<- NAGERM
        N N<- NAGERM
