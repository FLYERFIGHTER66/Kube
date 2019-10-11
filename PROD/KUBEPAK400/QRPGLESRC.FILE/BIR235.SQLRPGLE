    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES  1996
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
      **PROGRAM NAME-------- BIR235
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- SHIPMENT CONFIRMATION
      **
      ** CHANGE LOG:
      ** 5/06/97 EFD NEW LDA FORMAT.
      ** 6/18/97 EFD ADD CASH AND CARRY DISCOUNT
      ** 6/19/97 EFD NO DELIVERY IF SC OR LV ROUT NUMBER.
      ** 6/26/97 EFD FIX TOTAL DOLLARS ON SCREEN.
      ** 7/23/97 EFD USE DEPT FILE FOR CASH AND CARRY
      ** 8/28/97 EFD USE TOMORROWS DATE AFTER 12:00 NOON.
      * 10/02/97 EFD FOR FRESH USE DISCOUNT FOR EMPLOYEES
      * 11/19/97 EFD CHECK CANCEL AGAINST ORDER QTYS NOT SCREEN QTYS.
      * 12/19/97 EFD ADD LOGIC FOR CHECK AGAINST DEPT VS USER DEPT.
      *  1/09/98 EFD UNLCK FILES AT RESTART.
      *  4/16/98 EFD DO NOT GIVE CASH AND CARRY ON PRICE OVERRIDE.PK
      * 11/11/98 EFD ADD P TO PRINT COMMENT LINES.
      *  1/15/99 EFD PUT DATES IN ASSCENDING ORDER AND CHG F KEYS.
      * 10/22/99 EFD ADD LOGIC FOR NO ROYALTY IF UNIT PRICE = 0.00
      *  1/25/00 EFD ADD FPAYMNT FILE FOR PAYMENTS FORCE BANK NJN.
      * 12/15/00 EFD IF DELETE LINE SUBTRACT FROM ALLOCATED.
      *  5/02/01 EFD CHANGE F24 TO F12.
      * 11/29/01 EFD ADD MUST ENTER CHECK NUMBER IF PAYMENT. PER DARREN
      //------------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ----------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ----------------------------------------
      * SUD01   04/05/18   S.Uthaya     PCI Project - Added Credit Card process
      *                                 Existing Logic  (Including F5 = CC Scan)
      *                                 multiple credit cards for one payment. S
      *                                 for Cash and Check will be 1 & 2 in FPAY
      * SUD02   06/25/18   S.Uthaya     Manual Swiping Logic Added
      * SUD03   07/20/18   S.Uthaya     F23 function key - To delete records in
      *                                 FPAYMNT file for Old Credit card Txn
      * SUD04   07/26/18   S.Uthaya     Payment file updation Based on Token/CC
      * SUD05   05/14/19   S.Uthaya     Added FedEx Info in Control Screen
      //------------------------------------------------------------------------
      **
      *  U1 - IMMEDIATE INVOICE PRINT
      *
      ** RESERVED IORDR SEQ #
      * 001 - TAG ORDER NUMBER
      * 990 - CASH AND CARRY DISCOUNT
      * 991 - ROYALTY CHARGE.
      * 992 - ROYALTY CHARGE.
      * 993 - ROYALTY CHARGE.
      * 994 - ROYALTY CHARGE.
      * 995 - ROYALTY CHARGE.
      * 996 - DELIVERY CHARGE.
      * 997 - PACKING CHARGE
      * 998 - PHYTO CHARGE.
      * 999 - PHYTO CERTIFICATE REQUIRED.
      *
     FBIR235FM  CF   E             WORKSTN
     F                                     SFILE(ORDSFL:RECNO)
     F                                     SFILE(DATSFL:RECN1)
     F                                     SFILE(AORDSFL:RECN2)
     F**                                      RECNA KSFILE ASTSFL
     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    UF A E           K DISK
     FFPPO      UF A E           K DISK
     FFPAYMNT   UF A E           K DISK
?    FFIOROY    UF   E           K DISK
     FFHORDWTM  UF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
     FFMSVIA    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFFRTYP    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFUZONE    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFFPERC    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFEDEXSEQPFUF A E           K DISK
SUD01 *
  |   /Free
  |
  |   *?Procedure Prototype Declaration : Call Credit Card Selection Screen
  |     Dcl-Pr WSPCI001 ExtPgm;
  |        ParmDs Like(ParmDs);
  |     End-Pr;
SUD01 *
SUD02 *?Procedure Prototype Declaration : Credit Card Process Screen
  |     Dcl-Pr WSPCI002 ExtPgm;
  |        ParmDs Like(ParmDs);
SUD02   End-Pr;
SUD01 *
  |     Dcl-Ds ParmDs Qualified;
  |        PCust#     Packed(6);                 // Customer Number
  |        POrder#    Packed(6);                 // Order Number
  |        PInvoice   Packed(6);                 // Invoice Number
  |        PPgm       Char(10);                  // Program Name
  |        PSts       Char(10);                  // Status from Called
  |        PCCard     Packed(16);                // Card Number
  |        PCType     Char(4);                   // Credit Card Type
  |        PCExp      Packed(4);                 // Credit Card Expiry
  |        PToken     Packed(16);                // Token Number
  |        PCApr      Char(10);                  // C.C Approval Status
SUD01      PAmount    Packed(11:2);              // Amount to be Paid
SUD02      PManual    Char(1);                   // To Identify Manual Process
SUD01   End-Ds;
  |   *
SUD05   Dcl-S isFedExOrder Ind Inz(*Off);
  |     Dcl-S WkFreight    Packed(10:2) Inz;
  |     Dcl-S WkBox        Char(15)     Inz;
SUD05   Dcl-S WkService    Char(15)     Inz;
  |     Dcl-S GoodOrder Ind;  //Added by WJB 10/01/2019
  |   /End-Free
SUD01 *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(8) CTDATA PERRCD(1)
      * DATE ROUTINE ARRAY
0001 D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND
0001 D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND
      * REQUESTED DATE
     D DAT             S              8  0 DIM(50) ASCEND
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10
      ** RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      ** SOURCE LIBRARY
     D  SLIBR                314    323
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** JOBQ Y/N
     D  LDAJBQ                 4      4
      ** ROUTE I.D.
     D  LDARTE                 5      6
      ** ROUTE ALL
     D  LDAALL                 7      9
      ** BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                 10     15  0
      ** ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 16     21  0
      ** FORM NUMBER
     D**                                     21  30 LFORM
      ** PRINTER I.D.
     D  LPRTR                 31     40
      ** INVOICE DATE
     D  LDATE                 41     46  0
      ** SHIP FROM LOCATION
     D  LSHFR                 47     49
      ** BEGINING ORDER NUMBER
     D  LBORD                 50     55  0
      ** ENDING ORDER NUMBER
     D  LEORD                 56     61  0
      ** CANCEL  X=CANCEL
     D  LCANCL                62     62
      ** POINT OF SALE INVOICE Y/N
     D  LPOS                  63     63
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 64     64
      ** CONFIRM SPECIFIC ORDER
     D  LSPEC                 65     65

     D Payment         S                   Like(OHCASH)
     D OHPAYAMT        S                   Like(OHCASH)
     D Sequence        S                   Like(PYSEQ#)
     D TaxFreight      S              1A
SUD01D WKSeqNo         S                   Like(PYSEQ#)
SUD01D Date7           S              7S 0

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Upper
    ?D/COPY QFunctDefn,$TimeStamp
    ? /COPY QFunctDefn,$_Fedex


      ***********************
      ** START UP ROUTINE  **
      ***********************
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     TDATE         LDATE             6 0
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             90
     C     RSTART        TAG
     C                   MOVE      *BLANKS       LCANCL
     C                   UNLOCK    FHORDR
     C                   UNLOCK    FIORDR
     C                   UNLOCK    FMINVT
     C                   CLEAR                   RHORDW
     C                   TIME                    TIMOD
     C**         TIMOD     IFGT 120000
     C                   TIME                    TMWRK
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     TDATE         ##MDY
     C**                   EXSR @DT@B2
     C**                   ADD  1         ##DDD
     C**                   EXSR @DT@D0
     C**                   Z-ADD##MDY     VDATE
     C**                   END
     C                   SETOFF                                       U11240
     C                   SETOFF                                       102030
     C                   SETOFF                                       113132
     C                   SETOFF                                       272829
     C                   SETOFF                                       219059
     C                   Z-ADD     0             VORDER            6 0
     C                   Z-ADD     0             OORD
     C                   MOVEL     'N'           LIMED
     C                   MOVE      *BLANKS       FPTYPE
     C                   Z-ADD     0             FPCHRG
     C                   Z-ADD     0             FUCHRG
     C     NXTA          TAG
WJB  C     LSPEC         IFNE      ' '
WJB  C     LBORD         IFEQ      *ZERO
WJB  C     SVBORD        ANDNE     *ZERO
WJB  C                   Z-ADD     SVBORD        LBORD
WJB  C                   ENDIF
WJB  C                   Z-ADD     LBORD         VORDER
WJB  C                   Z-ADD     LBORD         SVBORD            6 0
WJB  C                   Z-ADD     *ZERO         LBORD
WJB  C                   MOVE      *ON           *IN60
WJB  C                   GOTO      SKIPA
WJB  C                   ELSE
WJB  C                   MOVE      *OFF          *IN60
WJB  C                   ENDIF
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  91
WJB  C     SKIPA         TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       1114
     C     VORDER        IFNE      OORD
     C                   SETOFF                                       11
     C                   END
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      EOJ
     C                   ENDDO
     C   KK              DO
      /Free
        GoodOrder = *Off;
        Exec SQL // See if it's a good Order Number
        Select '1' into :GoodOrder
          from fhordr
          where ohord# = :VORDER
            and ohstat = 'A';
      /End-Free
     C                   If        GoodOrder
     C                   Eval      LCANCL = 'O'
     C                   Eval      LBORD = VORDER
     C                   Eval      *InLR = *On
     C                   GOTO      EOJ
     C                   Else
     C                   GOTO      NxtA
     C                   EndIf
     C                   ENDDO
     C   KE              GOTO      RSTART
      *
     C     VORDER        CHAIN     FHORDR                             92
     C   92              SETON                                        1099
     C   10              GOTO      NXTA
     C                   Z-ADD     VORDER        OORD              6 0
     C                   MOVEL     OHSHPC        OSHV              2
     C                   MOVEL     OHPPCD        OPPC              1
     C                   MOVEL     VPRINT        OPRT             10
     C                   MOVEL     VPRINT        LPRTR
      ** CHECK IF OPEN
     C     OHSTAT        IFNE      'A'
     C     OHCOFL        OREQ      'Y'
     C                   SETON                                        101399
     C                   ENDIF
     C   10              GOTO      NXTA
      ** CHECK DEPT
     C     DESHFR        IFGT      *BLANKS
     C     DESHFR        ANDNE     OHSHFR
     C                   SETON                                        101499
     C                   GOTO      NXTA
     C                   END
      *
     C                   Z-ADD     VDATE         ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        2099
     C   20              GOTO      NXTA
     C                   Z-ADD     VDATE         LDATE
      ** IF OK SET UP SCRNB AND OUTPUT IT
     C                   Clear                   RMCUST
     C                   Clear                   RMTERM
     C     OHCUST        Chain     FMCUST
     C                   If        %Found(FMCUST)
     C     CMTMCD        Chain     FMTERM
     C                   EndIf
      ** IF SHIP WITH NEXT CHANGE TO OUR TRUCK
     C     OHSHPC        IFEQ      'ON'
     C                   MOVEL     'OT'          OHSHPC
     C                   END
     C     OHSHPC        CHAIN     FMSVIA                             20
     C                   MOVEL     OHSHPC        OSHV              2
     C     OHPPCD        CHAIN     FFRTYP                             21
     C                   MOVEL     OHPPCD        OPPC              1
     C                   MOVEL     VPRINT        OPRT             10
     C                   Z-ADD     OHTBLK        NOPCS
     C     OHORD#        CHAIN     FPPO                               81
     C  N81              DO
     C                   MOVEL     POPICK        PCKBY            10
     C                   MOVEL     POPACK        PAKBY            10
     C                   MOVEL     POPICK        OPCKBY           10
     C                   MOVEL     POPACK        OPAKBY           10
     C                   ENDDO
     C   81              DO
     C                   MOVE      *BLANKS       PCKBY
     C                   MOVE      *BLANKS       PAKBY
     C                   MOVE      *BLANKS       OPCKBY
     C                   MOVE      *BLANKS       OPAKBY
     C                   SETOFF                                       81
     C                   ENDDO
      *
     C                   MOVE      *BLANKS       VPRINT
     C                   MOVEL     'P2'          VPRINT
      /Free
        If isFedExSVIA(OHSHPC);  // Get next FedEx Sequence Number
          DATE7 = $Date7($DateMDY(VDATE));
          OHROUT = 'FX';
          Chain (DATE7) FEDEXSEQPF;
            If %found(FEDEXSEQPF);
              If FXNEXT > OHSTOP + 1;  // Only increment if new work since Last time
                OHSTOP = FXNEXT;
                FXNEXT += 1;
                Update FedExSeqR;
              ENDIF;
            Else;
              OHSTOP = 1;
              FXNEXT = 2;
              FXDATE = DATE7;
              Write FedExSeqR;
            ENDIF;
        ENDIF;
      /End-Free
     C     NXTB          TAG
     C   U1              SETOFF                                       50
     C  NU1              SETON                                        50
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  91
     C                   SETOFF                                       102030
     C                   SETOFF                                           99
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      EOJ
     C                   ENDDO
     C   KK              DO
     C                   Eval      LCANCL = 'O'
     C                   Eval      LBORD = VORDER
     C                   Eval      *InLR = *On
     C                   GOTO      EOJ
     C                   ENDDO
     C   KF              GOTO      RSTART
     C   KB
     CANNU1
     CANNKB              DO
     C                   SETON                                        U1
     C                   EXSR      GTPTR
     C                   GOTO      NXTB
     C                   ENDDO
      ** CHECK IF WE NEED PRINTER ID
     C** U1                DO
     C     VPRINT        IFEQ      *BLANKS
     C                   SETON                                        1099
     C                   END
     C**                   ENDDO
     C     OHSHPC        IFEQ      '? '
     C     OHSHPC        OREQ      '/ '
     C                   MOVEL     OHSHPC        SVCODE            2
     C                   CALL      'LKSVIA'
     C                   PARM                    SVCODE
     C                   PARM                    SVDESC           30
     C                   MOVEL     *BLANKS       OHSHPC
     C                   MOVEL     SVCODE        OHSHPC
     C                   MOVEL     SVDESC        VDESC            30
     C                   ENDIF
     C     OHSHPC        CHAIN     FMSVIA                             20
     C   20              SETON                                        99
     C     OHPPCD        IFEQ      '? '
     C     OHPPCD        OREQ      '/ '
     C                   MOVEL     OHPPCD        FRCODE            1
     C                   CALL      'LKFRTT'
     C                   PARM                    FRCODE
     C                   PARM                    FRDESC           12
     C                   MOVEL     *BLANKS       OHPPCD
     C                   MOVEL     FRCODE        OHPPCD
     C*                    MOVELSVDESC    VDESC  30
     C                   ENDIF
     C     OHPPCD        CHAIN     FFRTYP                             21
     C   21              SETON                                        99
     C   99              GOTO      NXTB
      ** IND 30 IS USED IN SCRNB FOR # OF PIECES WHEN READY TO CHECK
     C     OHSHPC        IFNE      OSHV
     C     OHPPCD        ORNE      OPPC
     C     VPRINT        ORNE      OPRT
     C                   MOVEL     OHSHPC        OSHV              2
     C                   MOVEL     OHPPCD        OPPC              1
     C                   MOVEL     VPRINT        OPRT             10
     C                   MOVEL     VPRINT        LPRTR
     C                   GOTO      NXTB
     C                   END
      * SEE IF PACKING CHARGE NEEDED
     C                   EXSR      PACKC
      *
     C                   MOVE      OHPLST        FPCODE
     C     FRTKEY        CHAIN     FFPERC                             92
     C   92              DO
     C                   MOVE      *BLANKS       FPTYPE
     C                   ENDDO
      *
      * SEE IF CASH AND CARRY NEEDED
     C**                   EXSR GET990
      *
      ** OUTPUT PICK/PACK
     C     OHORD#        CHAIN     FPPO                               90
     C                   Z-ADD     OHORD#        POORD#
     C                   MOVEL     USERID        POCONF
     C                   MOVEL     PCKBY         POPICK
     C                   MOVEL     PAKBY         POPACK
     C   90              WRITE     RPPO
     C  N90              UPDATE    RPPO
SUD05C                   Exsr      FedExInfo
      **
?    C     NXTFMA        TAG
     C                   EXSR      BLDSFL
     C     NXTFMT        TAG
     C                   EXFMT     ORDCTL
     C   KF              GOTO      RSTART
      ** CHECK PRICE CODE CHANGE
     C                   SETOFF                                       55
     C     CHGPRC        IFNE      'N'
     C     CHGPRC        ANDNE     'Y'
     C                   SETON                                        55
     C                   GOTO      NXTFMT
     C                   END
     C     CHGPRC        IFEQ      'Y'
     C                   EXSR      PRCCHG
     C                   EXSR      CHKSFL
     C                   MOVEL     'N'           CHGPRC
     C                   GOTO      NXTFMT
     C                   END
      ** RELEASE ENTIRE ORDER
     C   KA              DO
     C     LD            IFGT      1
     C                   EXSR      RELTHR
     C                   ELSE
     C                   Z-ADD     21001231      LSTDAT
     C                   END
     C                   EXSR      RELALL
      /Free
        //Also calculate freight if Plug Order
        If isPlugOrder(OHORD#) and
           (    OHSHPC = '01'    // TRUCK-IF IN AREA
             or OHSHPC = '40'    // H & S TRUCK
             or OHSHPC = '41' ); // RB TRUCK
          Exsr TOASFL;
          Exsr GETFRT;
        ENDIF;
      /End-Free
     C                   EXSR      CHKSFL
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** RELEASE FUTURE ORDER QUANTITIES
     C   KB              DO
     C                   EXSR      RELFUT
     C                   EXSR      CHKSFL
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** UN-RELEASE ENTIRE ORDER
     C   KM
     COR KL              DO
     C                   EXSR      UNRALL
     C   KL              GOTO      RSTART
     C   KM              DO
     C                   Eval      LCANCL = 'O'
     C                   Eval      LBORD = VORDER
     C                   Eval      *InLR = *On
     C                   GOTO      EOJ
     C                   ENDDO
     C                   ENDDO
      ** CHECK FOR LINE ADDS
      ** COMMENT
     C   KH              DO
     C                   EXSR      TOASFL
     C                   EXSR      ADDCOM
     C                   EXSR      CHKSFL
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** SPECIAL CHARGE
     C   KI              DO
     C     ORDWARNTAG    TAG
     C                   ExFmt     ORDWARN
     C   KI              Do
     C                   EXSR      TOASFL
     C                   EXSR      ADDSPC
     C                   EXSR      CHKSFL
     C                   GOTO      NXTFMT
     C                   ENDDO
     C  NKC              Goto      ORDWARNTAG                                   If no F3 loop
     C                   ENDDO
      ** FREIGHT CHARGE
     C   KJ              DO
     C                   EXSR      TOASFL
     C                   EXSR      ADDFRT
     C                   EXSR      CHKSFL
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** CALCULATE FREIGHT CHARGE
     C   KK              DO
     C                   EXSR      TOASFL
     C                   EXSR      GETFRT
     C                   EXSR      CHKSFL
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** NOW CHECK IF ALL OK
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTFMT
     C   KD              DO
     C                   EXSR      PUTSFL
     C*  U1                Z-ADDVORDER    LBORD
     C*  U1                Z-ADDVORDER    LEORD
     C*  U1                GOTO EOJ
     C                   GOTO      RSTART
     C                   ENDDO
     C
     C   KE              DO
     C                   EXSR      PUTSFL
     C                   UNLOCK    FIORDR
     C                   UNLOCK    FHORDR
     C                   MOVEL     ' '           LIMED
     C                   Z-ADD     VORDER        LBORD
     C                   Z-ADD     VORDER        LEORD
     C                   Z-ADD     TDATE         NWDATE            6 0
     C                   CALL      'BIR440I'
     C                   PARM                    OHCOMP
     C                   PARM                    NWDATE
     C                   PARM                    VORDER
     C                   PARM                    LEORD             6 0
     C                   PARM                    LIMED             1
     C                   PARM                    OHINV#
     C     VORDER        CHAIN     FHORDR                             91
     C                   CALL      'GETARB'
     C                   PARM                    OHARCU
     C                   PARM                    TOTAR            11 2
     C                   PARM                    CMCRL$            9 2
     C                   SETOFF                                       5539

     C     OHINV#        CHAIN     FHORDWTM                           91
     C     WH$AMT        ADD       TOTAR         NETDUE
     C     NETDUE        COMP      CMCRL$                             96
     C                   ExSr      PriorPay
     C     NXTJ          TAG
SUD01C                   SETON                                        60
     C                   WRITE     SCRNJPOS
     C                   READ      SCRNJPOS                               91
     C                   SETOFF                                       5558
     C   KB              DO
     C                   MOVEL     OHARCU        VACUST
     C                   MOVEL     OHCOMP        COMP
     C                   CALL      'ARR22CCL'
     C                   PARM                    COMP              2
     C                   PARM                    VACUST            6
     C                   GOTO      NXTJ
     C                   ENDDO
SUD01C*?Removed F5=Scan as part of Credit card Process Logic
  |  C*                  If        *InKE
  |  C*                  Call      'CCSCAN'
  |  C*                  Parm                    CCName           25
  |  C*    PSCRCD        Parm                    CCType            4
  |  C*                  Parm                    CCNumber         16
  |  C*                  Parm                    CCExpires         4
  |  C*                  Eval      PSCRC# = %Int(CCNUMBER)
  |  C*                  Eval      PSCRCE = %Int(CCExpires)
  |  C*                  GOTO      NXTJ
  |  C*                  EndIf
SUD01C******************
     C   KF              DO
     C                   MOVEL     'N'           OHIMFG
     C                   UNLOCK    FHORDWTM
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR235_1'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C     VORDER        CHAIN     FHORDR                             91
     C                   GOTO      NXTFMT
     C                   ENDDO
      ** Edit Payment Information
SUD01C*    OHCREDIT      IfNE      0
  |  C*    PsCRC#        IfLE      *Zeros
  |  C*    PsCRCD        OrLE      *Blanks
  |  C*    PsCRCE        OrLE      *Zeros
  |  C*    PsCRCA        OrLE      *Blanks
  |  C*                  SETON                                        58
  |  C*                  GOTO      NXTJ
  |  C*                  EndIf
SUD01C*                  EndIf
     C     OHCHECK       IfNE      0
     C     PsCHEK        AndLE     *BLANKS
     C                   SETON                                        55
     C                   GOTO      NXTJ
     C                   END
      ** Process Payments
     C                   Eval      Sequence = *Zero
SUD01 ** Do not initialise as we have credit card payment records that are not d
  |  C     OHCREDIT      IfNe      *Zeros
  |  C                   Eval      OHPAYAMT = OHCREDIT
SUD01C                   Else
     C                   Eval      OHPAYAMT = *Zero
SUD01C                   Endif
     C     OHCASH        IfNe      *Zero
     C                   ExSr      InzPAYMNT
     C                   Eval      Payment  = OHCASH
     C                   Eval      CASH     = 'CASH'
     C                   Eval      PYCHEK   = CASH
SUD01C*                  Eval      Sequence = Sequence + 1
SUD01C                   Eval      Sequence = 1
     C                   ExSr      WrtPAYMNT
     C                   EndIf
     C     OHCHECK       IfNe      *Zero
     C                   ExSr      InzPAYMNT
     C                   Eval      Payment  = OHCHECK
     C                   Eval      PYCHEK   = PsCHEK
SUD01C*                  Eval      Sequence = Sequence + 1
SUD01C                   Eval      Sequence = 2
     C                   ExSr      WrtPAYMNT
     C                   EndIf
SUD03 *
  |   /Free
  |          *In88 = *Off;
  |          *In89 = *Off;
  |       If *InKX = *On;
  |          Exec Sql Delete from FPaymnt Where  PYSTAT = 'A' and
  |             PYCUST = :CMCUST and  PYORD#= :VOrder and PYSEQ# >= 3;
  |          If SqlCode = 0;
  |             *In88 = *On;
  |          Else;
  |             *In89 = *On;
  |          Endif;
SUD03     Endif;
SUD01
  |   *?  // Credit Card Selection Screen (Check CASH and CHECK field before
SUD01 *?  // Process & Check Function key for Manual Or Credit Card Process
SUD02     If *InKH Or *InKG;
SUD01
  |   *?     // Set Off Indicators
  |          *In55 = *Off;
  |          *In58 = *Off;
  |          *InKI = *Off;
  |
  |   *?     // Check CHECK Number and Amount
  |          If OHCHECK <> *Zero And PsCHEK <= *Blanks;
  |             *In55 = *On;
  |   /End-Free
  |  C                   GOTO      NXTJ
  |   /Free
  |          Endif;
  |   *
  |   *?     // Move and Intialise Values Into Data Structure
  |      //  ParmDs.PCust#   = CMCUST;  WJB01 - should use Billing Customer #, not Ship To
  |          ParmDs.PCust#   = OHBLCU;
  |          ParmDs.POrder#  = VORDER;
  |          ParmDs.PInvoice = OHINV#;
  |          ParmDs.PPgm     = 'BIR235';
  |          ParmDs.PSts     = *Blanks;
  |          ParmDs.PCCard   = *Zeros;
  |          ParmDs.PCType   = *Blanks;
  |          ParmDs.PCExp    = *Zeros;
  |          ParmDs.PToken   = *Zeros;
  |          ParmDs.PCApr    = *Blanks;
  |
  |   *?     // If Cash or Check <> 0, pass correct amount to Credit Card Screen
  |          ParmDs.PAmount  = NETDUE - OHPAYAMT;
  |
SUD01 *?     // Call Credit Card Selection Screen Program
SUD02        If *InKH;
  |             ParmDs.PManual = 'N';            // CC Process
  |             WSPCI001(ParmDs);
  |          Elseif *InKG;
  |             ParmDs.PManual = 'Y';            // For CC Manual Swiping
  |             WSPCI002(ParmDs);
SUD02        Endif;
SUD01
  |   *?     // If Payment cancelled by User
  |          If ParmDs.PSts = 'Cancel';
  |   /End-Free
  |  C                   GOTO      NXTJ
  |   /Free
  |          Endif;
  |
  |   *?     // If Payment Successful
SUD01        If (ParmDs.PAmount <> *Zeros And ParmDs.PSts <> 'Cancel'
SUD02                       and ParmDs.PSts = 'Approval' ) Or *InKG ;
SUD01           Exsr InzPAYMNT;
  |             Payment  = ParmDs.PAmount;
  |             PYCRCD   = ParmDs.PCType;
  |             PYCRCE   = *Zeros;
  |             PYCRCA   = ParmDs.PCApr;
  |             If WkSeqNo = 0;
  |                Sequence = 3;
  |             Else;
  |                Sequence = WkSeqNo + 1;
SUD01           Endif;
SUD02           If ParmDs.PManual = 'N';
SUD04              If ParmDs.PToken <> *Zeros;
  |                   PYCRC# = ParmDs.PToken;
  |                Else;
  |                   PYCRC# = ParmDs.PCCard;
SUD04              Endif;
SUD02           Elseif ParmDs.PManual = 'Y';
  |                PYCRC#   = ParmDs.PCCard;
SUD02           Endif;
SUD01           *InKI = *On;
  |             ExSr WrtPAYMNT;
  |
  |   *?        // Process CASH and CHECK if fields are not Zeros on F8
  |             Sequence = *Zero;
  |             If OHCASH <> *Zero;
  |                ExSr InzPAYMNT;
  |                Payment  = OHCASH;
  |                CASH     = 'CASH';
  |                PYCHEK   = CASH;
  |                Sequence = 1;
  |                *InKI = *On;
  |                OHPAYAMT = OHPAYAMT - OHCASH;
  |                Exsr WrtPAYMNT;
  |             Endif;
  |
  |   *?        // Check CASH Field and process CASH Payment
  |             If OHCHECK <> *Zero;
  |                ExSr InzPAYMNT;
  |                Payment  = OHCHECK;
  |                PYCHEK   = PsCHEK;
  |                Sequence = 2;
  |                *InKI = *On;
  |                OHPAYAMT = OHPAYAMT - OHCHECK;
  |                Exsr WrtPAYMNT;
  |             EndIf;
  |
  |          Endif;
  |       Endif;
  |   /End-Free
  |
  |  C*    OHCREDIT      IfNe      *Zero
  |  C*                  ExSr      InzPAYMNT
  |  C*                  Eval      Payment  = OHCREDIT
  |  C*                  Eval      PYCRC#   = PSCRC#
  |  C*                  Eval      PYCRCD   = PSCRCD
  |  C*                  Eval      PYCRCE   = PSCRCE
  |  C*                  Eval      PYCRCA   = PSCRCA
  |  C*                  Eval      Sequence = Sequence + 1
  |  C*                  ExSr      WrtPAYMNT
SUD01C*                  EndIf
      ** Make Payment(s)
     C                   Eval      BALANCE   = WH$AMT - OHPAYAMT
     C                   If        Balance < 0
     C                   Z-Sub     Balance       ONACCOUNT
     C                   Z-Add     *Zero         Balance
     C                   Else
     C                   Z-Add     *Zero         ONACCOUNT
     C                   EndIf
     C                   Eval      ARBALANCE = NETDUE - OHPAYAMT

     C                   If        not *InKI
     C                   GOTO      NXTJ
     C                   EndIf

     C                   MOVEL     'N'           OHIMFG
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR235_2'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   Z-ADD     OHPAYAMT      WHCASH
     C**                   MOVELOHSVI2    WHSVI2
     C                   UPDATE    RHORDW
     C                   MOVEL     OHINV#        LBINV
     C                   MOVEL     OHINV#        LEINV
     C                   Z-ADD     VDATE         LDATE
     C                   Z-ADD     OHCOMP        LDACOP
     C                   MOVEL     'I'           LCANCL
     C                   MOVEL     VPRINT        LPRTR
     C                   GOTO      EOJ
     C                   ENDDO
     C                   GOTO      NXTFMT
     C     EOJ           TAG
     C                   SETON                                        LR
      *******************
      * Prior Payment   *
      *******************
     C     PriorPay      BegSR

     C                   Z-Add     *Zero         OHPAYAMT

     C                   Z-Add     *Zero         OHCASH
     C                   Move      *Blanks       CASH
     C                   Z-Add     *Zero         OHCHECK
     C                   Move      *Blanks       PSCHEK
     C                   Z-Add     *Zero         OHCREDIT
      *
SUD01C*                  Z-Add     *Zero         PsCRC#
  |  C*                  Move      *Blanks       PsCRCD
  |  C*                  Z-Add     *Zero         PsCRCE
SUD01C*                  Move      *Blanks       PsCRCA

     C     VORDER        SetLL     FPAYMNT
     C     VORDER        ReadE     FPAYMNT
     C                   DoW       not %Eof(FPAYMNT)
     C                   If        PYSTAT <> 'D' and PYINV# = OHINV#
    ?C                   Select
     C                   When      PYCRC# <> *Zero
SUD01C                   Eval      WkSeqNo =  PYSEQ#
SUD01C                   Eval      OHCREDIT = OHCREDIT + -PYCASH
      *
SUD01C*                  Eval      PsCRC#  =  PYCRC#
  |  C*                  Eval      PsCRCD  =  PYCRCD
  |  C*                  Eval      PsCRCE  =  PYCRCE
  |  C*                  Eval      PsCRCA  =  PYCRCA
SUD01C*                  Z-Sub     PYCASH        OHCREDIT

    ?C                   When      $Upper(PYCHEK) = 'CASH'
     C                   Eval      CASH = 'CASH'
     C                   Z-Sub     PYCASH        OHCASH
    ?C                   Other
     C                   Eval      PsCHEK = PYCHEK
     C                   Z-Sub     PYCASH        OHCHECK
    ?C                   EndSl

     C                   Eval      OHPAYAMT = OHPAYAMT + -PYCASH

SUD01C                   If        PYCRC#  = *Zero
     C                   Delete    RPAYMNT
SUD01C                   Endif
     C                   EndIf
     C     VORDER        ReadE     FPAYMNT
     C                   EndDo

     C                   Eval      BALANCE = WH$AMT - OHPAYAMT
     C                   If        Balance < 0
     C                   Z-Sub     Balance       ONACCOUNT
     C                   Z-Add     *Zero         Balance
     C                   Else
     C                   Z-Add     *Zero         ONACCOUNT
     C                   EndIf
     C                   Eval      ARBALANCE = NETDUE - OHPAYAMT

     C                   EndSr
      *******************
      * Inz Payment   *
      *******************
     C     InzPAYMNT     BegSR
     C                   Z-ADD     VORDER        PYORD#
     C                   Z-ADD     *Zero         PYSEQ#
     C                   MOVEL     'A'           PYSTAT
     C                   Z-ADD     OHCUST        PYCUST
     C                   Z-ADD     OHCOMP        PYCOMP
     C                   Z-ADD     OHDTRQ        PYDTRQ
     C                   Z-ADD     OHDTRY        PYDTRY
     C                   Z-ADD     TDATE         PYTDAT
     C                   Z-ADD     OHINV#        PYINV#
     C                   MOVE      *BLANKS       PYIVCD
     C                   Z-ADD     TDATE         PYDTLA
     C                   Z-ADD     TIMOD         PYTIME
     C                   MOVEL     USERID        PYUSER
     C                   Z-ADD     OHARCU        PYARCU
     C                   Z-ADD     OHSACU        PYSACU
     C                   Z-ADD     OHBLCU        PYBLCU
     C                   Z-ADD     OHDTAC        PYDTAC
     C                   MOVEL     OHALPH        PYLOOK
     C                   MOVEL     OHSHFR        PYSHFR
     C                   MOVEL     'NJN'         PYBANK
     C                   Z-Add     *Zeros        PYCRC#
     C                   Move      *Blanks       PYCRCD
     C                   Z-Add     *Zeros        PYCRCE
     C                   Move      *Blanks       PYCRCA
     C                   Move      *Blanks       PYCHEK
     C                   EndSr
      *******************
      * Write Payment   *
      *******************
     C     WrtPAYMNT     BegSR
     C                   Z-ADD     Sequence      PYSEQ#
     C                   Z-SUB     Payment       PYCASH
     C                   Eval      OHPAYAMT = OHPAYAMT + Payment
     C   KI              WRITE     RPAYMNT
     C                   EndSr
      ********************
      * CHANGE PRICE     *
      ********************
     C     PRCCHG        BEGSR
     C     VORDER        CHAIN     FHORDR                             92
     C                   Z-ADD     0             NEWPRC
     C                   SETOFF                                       1011
     C     NXTP          TAG
     C                   WRITE     SCRNP
     C                   READ      SCRNP                                  90
     C   KF              GOTO      ENDPRC
     C                   SETOFF                                       1011
     C     NEWPRC        IFLT      1
     C     NEWPRC        ORGT      5
     C                   SETON                                        10
     C                   GOTO      NXTP
     C                   END
     C     NEWPRC        IFEQ      OHPRCD
     C                   SETON                                        1011
     C                   GOTO      NXTP
     C                   END
      ** IF HERE CHANGE PRICES
     C                   Z-ADD     NEWPRC        OHPRCD
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR235_3'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   UNLOCK    FIORDR
     C                   CALL      'CHGPRC'
     C                   PARM                    OHORD#
     C     ENDPRC        TAG
     C                   SETOFF                                       1011
     C     VORDER        CHAIN     FHORDR                             92
     C                   ENDSR
      *
      ********************
      * BUILD SUB FILE   *
      ********************
     C     BLDSFL        BEGSR
      *
      * SET FIORDR BACK TO BEGINING OF ORDER
      *
     C                   Z-ADD     0             LD                2 0
     C                   Z-ADD     0             DAT
     C                   MOVE      *BLANKS       SELECTION
     C                   MOVEL     'N'           CHGPRC
     C                   SETOFF                                       279926
     C     VORDER        SETLL     FIORDR
     C                   MOVE      '1'           *IN80
     C                   WRITE     ORDCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             U990              2 0
     C                   Z-ADD     0             TOTSHP            7 1
     C                   Z-ADD     0             TOT$
     C                   Z-ADD     0             FRT$
     C**         OHBOCD    IFEQ 'Y'
     C**                   MOVELMSG,5     BOMSG
     C**                   ELSE
     C**                   MOVELMSG,4     BOMSG
     C**                   END
     C     NXTIOR        TAG
     C                   SETOFF                                       90
     C     VORDER        READE     FIORDR                                 90
     C   90              GOTO      ENDI
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       33
     C     OISEQ#        IFLE      989
     C                   Z-ADD     OISEQ#        LSTLIN            3 0
     C                   END
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTIOR
     C                   ENDIF
     C     OICOFL        IFEQ      'Y'
     C                   GOTO      NXTIOR
     C                   ENDIF
     C     OISEQ#        IFGT      990
     C     U990          ANDLE     0
     C                   Z-ADD     OISEQ#        SEQ               3 0
     C                   Z-ADD     0             OISEQ#
     C                   MOVEL     MSG(2)        DESC
     C                   SETON                                        102030
     C                   SETON                                        313240
     C                   SETON                                        33
     C                   Z-ADD     0             FSAMT
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   Z-ADD     1             U990
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       33
     C                   Z-ADD     SEQ           OISEQ#
     C                   END
     C**                   END
     C     OIITYP        IFEQ      ' '
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN(N)  FMINVT                             90
     C                   EXSR      GETDES
     C                   ENDIF
     C     OIITYP        IFNE      ' '
     C                   MOVEL     OIDES1        DESC
     C                   ENDIF
      ** GET PACKING CHARGE
WJB15C                   Move      *Blanks       SIZEITEM         15
WJB15C                   Eval      SIZEITEM = OISIZE + OIITEM
     C     OIITYP        IFNE      'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     OISIZE        ANDNE     'ROY'
     C     OISIZE        ANDNE     'LCM'
     C     OISIZE        ANDNE     'TAG'
WJB15C     SIZEITEM      ANDNE     '7002000'
     C                   ADD       OIQINV        TOTSHP
     C                   ENDIF
      ** GET TOTAL IF TAG ORDER
     C     OHOLST        IFEQ      'TAG   '
     C     OIITYP        ANDNE     'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     HSIZE         ANDNE     'ROY'
     C     HSIZE         ANDNE     'LCM'
     C     OISIZE        ANDEQ     'TAG'
     C                   ADD       OIQINV        TOTSHP
     C                   ENDIF
      ** BUILD RECORD FOR ITEMS STOCK/NON STOCK
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C     OIQORD        SUB       OIQSHP        QTYOPN
      ** SEE IF REL QTY AND NO B/O
     C     OIQINV        IFGT      0
     C     OIQBOO        ANDLE     0
     C     QTYOPN        ANDGT     0
     C                   MOVEL     'C'           SELECTION
     C                   END
      ** FUTURE REL
     C     OIRQTY        IFGT      0
     C                   Z-ADD     OIRQTY        QTYOPN
     C                   END
     C                   Z-ADD     OIQINV        QTYSHP
     C                   MOVE      OIQDDC        DSWRK             5 4
     C     1.00          SUB       DSWRK         DSMULT            5 4
     C     OIUPRI        MULT      DSMULT        UPRWRK           11 4
     C                   Z-ADD     UPRWRK        PRICE
     C     QTYSHP        MULT(H)   UPRWRK        FSAMT
     C**         OIDTRQ    IFNE OHDTRQ
     C                   EXSR      CHKDAT
     C**                   END
     C                   MOVEL     OIITEM        ITEM
     C                   SETON                                        31
     C                   GOTO      WRTSFL
     C                   ENDIF
      ** BUILD RECORD FOR COMMENTS
     C     OIITYP        IFEQ      'C'
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     0             FSAMT
     C     OISHCD        IFEQ      'R'
     C                   MOVEL     'P'           SELECTION
     C                   END
     C                   SETON                                        102030
     C                   SETON                                        31
     C                   GOTO      WRTSFL
     C                   ENDIF
      ** BUILD RECORD FOR FREIGHT
     C     OIITYP        IFEQ      'F'
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     OIEXT$        FSAMT
     C                   SETON                                        1020
     C                   GOTO      WRTSFL
     C                   ENDIF
      ** BUILD RECORD FOR SPECIAL CHARGE
     C     OIITYP        IFEQ      'S'
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     OIEXT$        FSAMT
     C                   SETON                                        1020
     C                   GOTO      WRTSFL
     C                   ENDIF
      *
     C     WRTSFL        TAG
     C     OISEQ#        IFGT      990
     C                   SETON                                        102031
     C**                   SETON                     40
     C                   ENDIF
      ** CHECK FREIGHT
     C     OISEQ#        IFEQ      996
      /Free
       CHAIN (OHCOMP:OHPLST)  FFPERC;
      /End-Free
     C     FPTYPE        IFGT      *BLANKS
     C     FPTYPE        IFEQ      'F'
      /Free
       CHAIN (OHCOMP:OHUPSZ)  FUZONE;
      /End-Free
     C     TOTSHP        MULT      FUCHRG        FSAMT
     C                   ELSE
     C     FPCHRG        DIV(H)    100           FSWK              7 4
     C     TOT$          MULT(H)   FSWK          FSAMT
     C                   END
     C                   ELSE
     C**                   Z-ADD0         FSAMT
     C                   Z-ADD     OIEXT$        FSAMT
     C                   END
     C     OISEQ#        IFEQ      997
     C     SVPACK        IFGT      0
     C     OHOLST        ANDNE     'TAG   '
     C**         TOTSHP    MULT SVPACK    FSAMT
     C                   Z-ADD     SVPACK        FSAMT
     C                   ELSE
     C                   Z-ADD     OIEXT$        FSAMT
     C                   END
     C                   END
     C                   END
     C                   ADD       1             RECNO
     C                   ADD       FSAMT         TOT$
     C     OIITYP        IFEQ      'F'
     C                   ADD       OIEXT$        FRT$
     C                   ENDIF
     C                   WRITE     ORDSFL
     C                   MOVE      *BLANKS       SELECTION
     C     OIITYP        IFEQ      ' '
?    C                   EXSR      CHKDES
     C                   END
     C                   MOVE      *BLANKS       ITEM
     C                   GOTO      NXTIOR
      *
     C     ENDI          TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       33
     C                   SETON                                        10
     C                   SETON                                        3140
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *BLANKS       OIBOLN
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(1)        DESC
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     TOTSHP        QTYSHP
     C                   Z-ADD     TOT$          FSAMT
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   WRITE     ORDSFL
     C     RECNO         IFGT      14
     C                   SETON                                        97
     C                   ELSE
     C                   SETOFF                                       97
     C                   END
     C                   ENDSR
      ********************************
      * CHECK FOR ROYALTY OR COMMENT *
      ********************************
     C     CHKDES        BEGSR
?    C                   MOVEL     OISIZE        HSIZE             3
     C*          OIDES2    IFGT *BLANKS
?    C*                    SETON                     102030
?    C*                    SETON                     31      32
?    C*                    MOVELOIDES2    DESC
?    C*                    ADD  1         RECNO
?    C*                    MOVEL'LCM'     OISIZE
?    C*                    WRITEORDSFL
     C*                    ENDIF
?    C                   SETOFF                                       102030
?    C                   SETOFF                                       3132
      ** CHECK FOR ROYALTY
?    C                   CALL      'GETROYA'
?    C                   PARM                    OICOMP
?    C                   PARM                    OIORD#
?    C                   PARM                    OISEQ#
?    C                   PARM                    OIQINV
?    C                   PARM                    DESC60           60
?    C                   PARM                    ORUPRI            9 4
?    C                   PARM                    OREXT$            9 2
      ** IF ITEM PRIVE OVERRIDDEN TO 0.00 DO NOT EXTEND ROYALTY
     C     OIOVER        IFEQ      'Y'
     C     OIUPRI        ANDLE     0.00
     C                   Z-ADD     0             ORUPRI
     C                   Z-ADD     0             OREXT$
     C                   ENDIF
     C     ORUPRI        IFGT      0
?    C                   Z-ADD     OREXT$        FSAMT
?    C                   MOVEL     DESC60        DESC
?    C                   Z-ADD     OIQINV        QTYSHP
?    C                   ADD       FSAMT         TOT$
?    C                   SETON                                        102032
?    C                   ADD       1             RECNO
?    C                   MOVEL     'ROY'         OISIZE
?    C                   WRITE     ORDSFL
?    C                   SETOFF                                       102032
     C                   END
?    C                   MOVEL     HSIZE         OISIZE
     C                   ENDSR
      ********************
      * RELEASE ALL      *
      ********************
     C     RELALL        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOT$             11 4
     C     LSTDAT        SUB       19000000      TSTDAT            7 0
     C     NXTREL        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDREL
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTREL
?    C                   MOVEL     OISIZE        HSIZE
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       33
     C     OISEQ#        IFLE      0
     C                   GOTO      NXTREL
     C                   END
     C                   Z-ADD     OISEQ#        SEQ
     C     IORKEY        CHAIN     FIORDR                             90
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C     ##CYMD        IFGT      TSTDAT
     C                   GOTO      NXTREL
     C                   END
     C     HSIZE         IFEQ      'ROY'
     C     HSHIP         ANDGT     0
?    C                   EXSR      GETROY
?    C                   GOTO      NXTREL
     C                   END
     C     OISEQ#        IFLE      990
     C     OIITYP        IFEQ      'C'
     C                   MOVEL     'P'           SELECTION
     C                   SETON                                        102030
     C                   SETON                                        3140
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTREL
     C                   ENDIF
WJB  C     OIITYP        IFEQ      ' '
WJB  C     QTYOPN        ANDEQ     0
WJB  C     QTYSHP        ANDEQ     0
WJB  C                   MOVEL     'P'           SELECTION
WJB  C                   SETON                                        102030
WJB  C                   SETON                                        3140
WJB  C                   UPDATE    ORDSFL
WJB  C                   MOVEL     ' '           SELECTION
WJB  C                   GOTO      NXTREL
WJB  C                   ENDIF
     C     OIITYP        IFEQ      'S'
     C                   SETON                                        102040
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTREL
     C                   ENDIF
     C     OIITYP        IFEQ      ' '
     C**         KEY18     CHAINFMINVT               90
     C**                   EXSR GETDES
     C     OIQORD        SUB       OIQSHP        QTYOPN
     C                   Z-ADD     QTYOPN        QTYSHP
     C     OIRQTY        IFGT      0
     C                   Z-ADD     OIRQTY        QTYSHP
     C                   END
     C                   Z-ADD     QTYSHP        HSHIP
     C                   Z-ADD     OIUPRI        HPRICE            9 4
     C                   MOVE      OIQDDC        DSWRK             5 4
     C     1.00          SUB       DSWRK         DSMULT            5 4
     C     OIUPRI        MULT      DSMULT        UPRWRK           11 4
     C                   Z-ADD     UPRWRK        PRICE
     C     QTYSHP        MULT(H)   UPRWRK        FSAMT
     C***        OIUPRI    MULT QTYSHP    FSAMT     H
     C                   END
     C     OIITYP        IFEQ      'N'
     C     OIQORD        SUB       OIQSHP        QTYOPN
     C                   Z-ADD     QTYOPN        QTYSHP
     C     OIUPRI        MULT(H)   QTYSHP        FSAMT
     C                   END
      ** GET PACKING CHARGE
WJB15C                   Move      *Blanks       SIZEITEM         15
WJB15C                   Eval      SIZEITEM = OISIZE + OIITEM
     C     OIITYP        IFNE      'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     OISIZE        ANDNE     'ROY'
     C     OISIZE        ANDNE     'TAG'
WJB15C     SIZEITEM      ANDNE     '7002000'
     C                   ADD       QTYSHP        TOTSHP
     C                   ENDIF
      ** GET TOTAL IF TAG ORDER
     C     OHOLST        IFEQ      'TAG   '
     C     OIITYP        ANDNE     'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     HSIZE         ANDNE     'ROY'
     C     OISIZE        ANDEQ     'TAG'
     C                   ADD       OIQSHP        TOTSHP
     C                   ENDIF
     C                   ADD       FSAMT         TOT$
     C                   SETON                                        31
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTREL
     C                   END
      ** PACKING CHARGE
     C     OISEQ#        IFEQ      997
     C     OHOLST        ANDNE     'TAG   '
      * 11/5/96
     C*          SVPACK    MULT TOTSHP    FSAMT     H
     C                   Z-ADD(H)  SVPACK        FSAMT
     C                   ADD       FSAMT         TOT$
     C                   SETON                                        102031
     C                   SETON                                        40
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTREL
     C                   END
     C                   SETON                                        102031
     C                   SETON                                        40
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTREL
     C     ENDREL        TAG
     C                   ENDSR
      ********************
      * RELEASE FUTURE   *
      ********************
     C     RELFUT        BEGSR
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             TOT$             11 4
     C     NXTFUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDFUT
     C                   END
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      NXTFUT
?    C                   MOVEL     OISIZE        HSIZE
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       33
     C     OISEQ#        IFLE      0
     C                   GOTO      NXTFUT
     C                   END
     C                   Z-ADD     OISEQ#        SEQ
     C     IORKEY        CHAIN     FIORDR                             90
     C     HSIZE         IFEQ      'ROY'
     C     HSHIP         ANDGT     0
?    C                   EXSR      GETROY
?    C                   GOTO      NXTFUT
     C                   END
     C     OISEQ#        IFLE      990
     C     OIITYP        IFEQ      'C'
     C                   SETON                                        102030
     C                   SETON                                        3140
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTFUT
     C                   ENDIF
     C     OIITYP        IFEQ      'S'
     C                   SETON                                        102040
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTFUT
     C                   ENDIF
     C     OIITYP        IFEQ      ' '
     C     KEY18         CHAIN(N)  FMINVT                             90
     C                   EXSR      GETDES
     C     OIRQTY        IFGT      0
     C                   Z-ADD     OIRQTY        QTYSHP
     C                   END
     C                   Z-ADD     OIUPRI        HPRICE
     C                   MOVE      OIQDDC        DSWRK             5 4
     C     1.00          SUB       DSWRK         DSMULT            5 4
     C     OIUPRI        MULT      DSMULT        UPRWRK           11 4
     C                   Z-ADD     UPRWRK        PRICE
     C     QTYSHP        MULT(H)   UPRWRK        FSAMT
     C***        OIUPRI    MULT QTYSHP    FSAMT     H
     C                   END
     C     OIITYP        IFEQ      'N'
     C     OIQORD        SUB       OIQSHP        QTYOPN
     C                   Z-ADD     QTYOPN        QTYSHP
     C     OIUPRI        MULT(H)   QTYSHP        FSAMT
     C                   END
      ** GET PACKING CHARGE
WJB15C                   Move      *Blanks       SIZEITEM         15
WJB15C                   Eval      SIZEITEM = OISIZE + OIITEM
     C     OIITYP        IFNE      'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     OISIZE        ANDNE     'ROY'
     C     OISIZE        ANDNE     'TAG'
WJB15C     SIZEITEM      ANDNE     '7002000'
     C                   ADD       QTYSHP        TOTSHP
     C                   Z-ADD     QTYSHP        HSHIP
     C                   ENDIF
      ** GET TOTAL IF TAG ORDER
     C     OHOLST        IFEQ      'TAG   '
     C     OIITYP        ANDNE     'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     HSIZE         ANDNE     'ROY'
     C     OISIZE        ANDEQ     'TAG'
     C                   ADD       OIQSHP        TOTSHP
     C                   ENDIF
     C                   ADD       FSAMT         TOT$
     C                   SETON                                        31
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTFUT
     C                   END
      ** PACKING CHARGE
     C     OISEQ#        IFEQ      997
     C     OHOLST        ANDNE     'TAG   '
      * 11/5/96
     C*          SVPACK    MULT TOTSHP    FSAMT     H
     C                   Z-ADD(H)  SVPACK        FSAMT
     C                   ADD       FSAMT         TOT$
     C                   SETON                                        102031
     C                   SETON                                        40
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTFUT
     C                   END
     C                   SETON                                        102031
     C                   SETON                                        40
     C                   UPDATE    ORDSFL
     C                   GOTO      NXTFUT
     C     ENDFUT        TAG
     C                   ENDSR
      ********************
      * CHECK SUB FILE   *
      ********************
     C     CHKSFL        BEGSR
     C                   Z-ADD     0             TOT$
     C                   Z-ADD     0             TOTM$            11 2
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     0             DISTOT            9 2
     C                   Z-ADD     0             FRT$
     C                   Z-ADD     0             TRDDIS
     C                   Z-ADD     1             RECNO
     C                   SETOFF                                       992726
     C                   SETOFF                                       272829
     C                   SETOFF                                       59
     C     OHTRDC        IFGT      0.00
     C                   SETON                                        59
     C                   END
     C     NXTCHK        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       403132
     C                   SETOFF                                       33
     C                   SETOFF                                       717374
     C     RECNO         CHAIN     ORDSFL                             90
     C                   MOVEL     DESC          TSTDES
     C     TSTDES        IFEQ      '----'
     C                   GOTO      ENDCHK
     C                   END
     C   90              DO
     C                   ADD       1             RECNO
     C     LSTREC        ADD       2             LSTRD             5 0
     C     RECNO         IFLE      LSTRD
     C                   GOTO      NXTCHK
     C                   ELSE
     C                   GOTO      ENDCHK
     C                   END
     C                   ENDDO
     C     OISEQ#        IFEQ      0
     C                   ADD       1             RECNO
     C                   GOTO      NXTCHK
     C                   END
     C                   MOVEL     OISIZE        HSIZE
     C                   Z-ADD     OISEQ#        SEQ
     C     IORKEY        CHAIN     RIORDR                             90
     C     SELECTION     IFEQ      'D'
     C     HSIZE         ANDNE     'LCM'
     C     HSIZE         ANDNE     'ROY'
     C                   MOVE      'D'           OISTAT
     C                   MOVE      'H'           OISHCD
     C                   Z-ADD     0             OIQBOO
     C                   SUB       OIQINV        OIQSHP
     C                   Z-ADD     0             OIQINV
     C     OIQSHP        IFLT      0
     C                   Z-ADD     0             OIQSHP
     C                   END
     C  N90              MOVE      'P'           OIPLPT
     C  N90              UPDATE    RIORDR
     C**         OISEQ#    IFEQ 990
     C**                   Z-ADD0         OHDISC
     C**                   END
     C                   SETON                                        102030
     C                   SETON                                        314032
     C                   MOVE      *BLANKS       DESC
     C                   UPDATE    ORDSFL
     C                   ADD       1             RECNO
     C                   GOTO      NXTCHK
     C                   END
 B1  C     SELECTION     IFEQ      'D'
     C     HSIZE         ANDEQ     'LCM'
?    C                   MOVE      *BLANKS       OIDES2
?    C  N90              UPDATE    RIORDR
?    C                   SETON                                        102030
?    C                   SETON                                        314032
?    C                   MOVE      *BLANKS       DESC
?    C                   MOVE      *BLANKS       SELECTION
?    C                   MOVEL     HSIZE         OISIZE
?    C                   UPDATE    ORDSFL
?    C                   ADD       1             RECNO
?    C                   GOTO      NXTCHK
 E1  C                   END
 B1  C     SELECTION     IFEQ      'D'
     C     HSIZE         ANDEQ     'ROY'
?    C                   Z-ADD     0             OIROY
?    C  N90              UPDATE    RIORDR
      ** DELETE ROYALTY LINE
?    C     ROYKEY        KLIST
?    C                   KFLD                    OHORD#
?    C                   KFLD                    OISEQ#
?    C     ROYKEY        CHAIN     FIOROY                             81
?    C  N81              DELETE    RIOROY
?    C                   SETON                                        102030
?    C                   SETON                                        314032
?    C                   MOVE      *BLANKS       DESC
?    C                   MOVE      *BLANKS       SELECTION
?    C                   MOVEL     HSIZE         OISIZE
?    C                   UPDATE    ORDSFL
?    C                   ADD       1             RECNO
?    C                   GOTO      NXTCHK
 E1  C                   END
     C     OIITYP        IFEQ      'C'
     C                   SETON                                        102030
     C                   SETON                                        31  32
     C                   SETOFF                                       40
     C                   UPDATE    ORDSFL
     C                   ADD       1             RECNO
     C                   GOTO      NXTCHK
     C                   END
      ** GET PACKING CHARGE
WJB15C                   Move      *Blanks       SIZEITEM         15
WJB15C                   Eval      SIZEITEM = OISIZE + OIITEM
     C     OIITYP        IFNE      'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     HSIZE         ANDNE     'ROY'
     C     HSIZE         ANDNE     'LCM'
     C     OISIZE        ANDNE     'TAG'
WJB15C     SIZEITEM      ANDNE     '7002000'
     C                   ADD       QTYSHP        TOTSHP
     C                   ENDIF
      ** GET TOTAL IF TAG ORDER
     C     OHOLST        IFEQ      'TAG   '
     C     OIITYP        ANDNE     'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     HSIZE         ANDNE     'ROY'
     C     HSIZE         ANDNE     'LCM'
     C     OISIZE        ANDEQ     'TAG'
     C                   ADD       OIQSHP        TOTSHP
     C                   ENDIF
 B1  C     HSIZE         IFEQ      'ROY'
     C     HSHIP         ANDGT     0
     C                   EXSR      GETROY
?    C                   ADD       1             RECNO
?    C                   GOTO      NXTCHK
 E1  C                   ENDIF
 B1  C     HSIZE         IFEQ      'LCM'
     C     HSIZE         OREQ      'ROY'
?    C                   ADD       1             RECNO
?    C                   GOTO      NXTCHK
 E1  C                   ENDIF
      ** BUILD RECORD FOR ITEMS STOCK/NON STOCK
     C     OIITYP        IFEQ      ' '
     C     HSIZE         ANDNE     'ROY'
     C     HSIZE         ANDNE     'LCM'
     C     OIITYP        OREQ      'N'
     C     HSIZE         ANDNE     'ROY'
     C     HSIZE         ANDNE     'LCM'
     C                   MOVE      OIQDDC        DSWRK             5 4
     C     1.00          SUB       DSWRK         DSMULT            5 4
     C     OIUPRI        MULT      DSMULT        UPRWRK           11 4
     C                   Z-ADD     UPRWRK        PRICE
     C     QTYSHP        MULT(H)   UPRWRK        FSAMT
     C                   Z-ADD     QTYSHP        HSHIP            11 1
     C                   Z-ADD     OIUPRI        HPRICE
     C     OIPPDC        IFNE      'N'
     C     OIITYP        ANDEQ     ' '
     C     OIQDDC        ANDEQ     *ZEROS
     C                   ADD       FSAMT         DISTOT
     C                   END
     C     OIQSHP        ADD       QTYSHP        QTYTST           11 1
     C                   SUB       OIQINV        QTYTST
     C     QTYTST        IFGT      OIQORD
     C                   SETON                                        712899
     C                   END
     C     QTYSHP        IFNE      0
     C     QTYSHP        ANDLT     QTYOPN
     C     OHBOCD        ANDEQ     'N'
     C     SELECTION     ANDNE     'C'
     C                   SETON                                        717499
     C                   SETON                                        27
     C                   END
      ** FROM HERE 6/24/98
     C     KEY18         CHAIN(N)  FMINVT                             90
     C                   Z-ADD     0             VDISC             4 2
     C     OIOVER        IFNE      'Y'
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMPUOM
     C                   PARM                    QTYSHP
     C                   PARM                    OIOVER
     C                   PARM                    #OPRC             9 4
     C                   PARM                    VDISC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC            4 2
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    ORDD              1
     C                   Z-ADD     #OPRC         VUPRIC            9 4
     C                   Z-ADD     #OPRC         OIUPRI
     C**                   Z-ADDOIQORD    QTYORD 111
     C                   Z-ADD     QTYSHP        QTYORD           11 1
     C**                   MOVELORDD      OIPPDC
     C                   EXSR      #EXLN
     C                   ELSE
     C                   Z-ADD     OIUPRI        VUPRIC            9 4
     C**                   Z-ADDOIQORD    QTYORD 111
     C                   Z-ADD     QTYSHP        QTYORD           11 1
     C                   EXSR      #EXLN
     C                   END
     C                   Z-ADD     #LINNT        OIEXT$
     C                   Z-ADD     #LINNT        FSAMT
     C                   UPDATE    RIORDR
      * 11/19/97
     C     OIQORD        SUB       OIQSHP        OPTEST           11 1
     C                   ADD       OIQINV        OPTEST
     C     QTYSHP        IFGE      OPTEST
     C     SELECTION     ANDEQ     'C'
     C                   SETON                                        74  99
     C                   END
     C  N28OIQORD        SUB       QTYTST        QTYOPN
     C   28              Z-ADD     0             QTYOPN
     C                   SETON                                        31
     C                   GOTO      WRTCHK
     C                   ENDIF
      ** BUILD RECORD FOR FREIGHT
     C     OIITYP        IFEQ      'F'
     C     FSAMT         IFEQ      0
     C     OISEQ#        ANDLE     990
     C                   SETON                                        732999
     C                   ENDIF
     C     SELECTION     IFEQ      'C'
     C                   SETON                                        74  99
     C                   END
     C                   SETON                                        1020
     C                   GOTO      WRTCHK
     C                   ENDIF
      ** BUILD RECORD FOR SPECIAL CHARGE
     C     OIITYP        IFEQ      'S'
     C     FSAMT         IFEQ      0
     C     OISEQ#        ANDLT     990
     C                   SETON                                        732999
     C                   END
     C     SELECTION     IFEQ      'C'
     C                   SETON                                        74  99
     C                   END
     C                   SETON                                        1020
     C                   GOTO      WRTCHK
     C                   ENDIF
      *
     C     WRTCHK        TAG
     C     OISEQ#        IFGT      990
     C                   SETON                                        102031
     C**                   SETON                     40
     C                   ENDIF
     C     OISEQ#        IFEQ      997
     C     SVPACK        IFGT      0
     C     OHOLST        ANDNE     'TAG   '
     C**         TOTSHP    MULT SVPACK    FSAMT
     C                   Z-ADD     SVPACK        FSAMT
     C                   ELSE
     C                   Z-ADD     0             FSAMT
     C                   END
     C                   END
     C     OISEQ#        IFEQ      996
     C     FPTYPE        IFGT      *BLANKS
     C     FPTYPE        IFEQ      'F'
     C     TOTSHP        MULT      FUCHRG        FSAMT
     C                   ELSE
     C     FPCHRG        DIV(H)    100           FSWK              7 4
     C     TOTM$         MULT(H)   FSWK          FSAMT
     C                   END
     C                   ELSE
     C**                   Z-ADD0         FSAMT
     C                   Z-ADD     OIEXT$        FSAMT
     C                   END
     C                   END
     C***                  ADD  FSAMT     TOT$
      ** GET DISCOUNT
     C*          OISEQ#    IFEQ 990
     C*          IORKEY    CHAINRIORDR               90
     C*          OISTAT    IFNE 'D'
     C*          DECANC    DIV  100       WRKPCT  76
     C*          DISTOT    MULT WRKPCT    WRKD    92H
     C*                    Z-SUBWRKD      OIEXT$
     C*                    Z-SUBWRKD      OIUPRI
     C*                    Z-SUBWRKD      FSAMT
     C*                    ELSE
     C*                    Z-ADD0         OIEXT$
     C*                    Z-ADD0         OIUPRI
     C*                    Z-ADD0         FSAMT
     C*                    Z-ADD0         WRKD
     C*                    END
     C*                    UPDATRIORDR
     C*                    END
     C     OISEQ#        IFEQ      996
     C                   Z-ADD     FSAMT         DLV$              9 2
     C                   END
     C                   ADD       FSAMT         TOT$
     C     OIITYP        IFNE      'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     OISIZE        ANDNE     'ROY'
     C     HSIZE         ANDNE     'LCM'
     C     OISIZE        ANDNE     'TAG'
     C                   ADD       FSAMT         TOTM$
     C                   ENDIF
     C     OIITYP        IFEQ      'F'
     C                   ADD       FSAMT         FRT$
     C                   ENDIF
     C                   UPDATE    ORDSFL
     C                   ADD       1             RECNO
     C                   GOTO      NXTCHK
      *
     C     ENDCHK        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   MOVEL     DESC          TSTDES
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       33
     C                   SETON                                        10
     C                   SETON                                        3140
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(1)        DESC
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     TOTSHP        QTYSHP
     C                   Z-ADD     TOT$          FSAMT
     C     TSTDES        IFNE      '----'
     C                   ADD       2             RECNO
      /Free
        If OIITYP = 'C' and OISHCD = 'R';
          SELECTION = 'P';
        EndIf;
      /End-Free
     C                   WRITE     ORDSFL
     C                   ELSE
     C                   UPDATE    ORDSFL
     C                   END
     C     RECNO         IFGT      14
     C                   SETON                                        97
     C                   ELSE
     C                   SETOFF                                       97
     C                   END
      ** GET TRADE DISCOUNT
     C   59              DO
     C                   Z-ADD     TOTM$         NETPRC            9 4
     C                   Z-ADD     OHTRDC        DISHLD            4 2
     C                   MOVE      DISHLD        DISREF            4 4
     C     1             SUB       DISREF        DISREF
     C     NETPRC        MULT      DISREF        NETPRC
     C**         WKNTAX    MULT DISREF    WKNTAX
     C     TOTM$         SUB       NETPRC        TRDDIS
     C                   Z-SUB     TRDDIS        TRDDIS
     C                   ENDDO
     C  N59              DO
     C                   Z-ADD     0             TRDDIS
     C                   ENDDO
      ** CHECK IF ANY RELEASED
     C**         TOT$      SUB  DLV$      TOTTST  92
     C     TOT$          IFNE      0
     C     TOTSHP        ORNE      0
     C                   SETOFF                                       77
     C                   ELSE
     C                   MOVE      'H'           OHHOLD
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR235_4'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C     VORDER        CHAIN     FHORDR                             92
     C                   SETON                                        7799
     C                   END
     C                   ENDSR
      ********************
      * UPDATE ORDER     *
      ********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             TOT$
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     1             RECNO
     C                   SETOFF                                       9927
     C                   SETOFF                                       272829
     C     NXTPUT        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       403132
     C                   SETOFF                                       33
     C                   SETOFF                                       717374
     C     RECNO         CHAIN     ORDSFL                             90
     C                   MOVEL     DESC          TSTDES
     C     TSTDES        IFEQ      '----'
     C                   GOTO      ENDPUT
     C                   END
?    C                   MOVEL     OISIZE        HSIZE
     C   90              DO
     C                   ADD       1             RECNO
     C     LSTREC        ADD       2             LSTRD             5 0
     C     RECNO         IFLE      LSTRD
     C                   GOTO      NXTPUT
     C                   ELSE
     C                   GOTO      ENDPUT
     C                   END
     C                   ENDDO
     C     OISEQ#        IFEQ      0
     C     HSIZE         OREQ      'LCM'
     C                   ADD       1             RECNO
     C                   GOTO      NXTPUT
     C                   END
 B1  C     HSIZE         IFEQ      'ROY'
?    C                   EXSR      PUTROY
?    C                   ADD       1             RECNO
?    C                   GOTO      NXTPUT
 E1  C                   END
     C                   Z-ADD     OISEQ#        SEQ
     C     IORKEY        CHAIN     RIORDR                             90
     C     SELECTION     IFEQ      'D'
     C                   MOVE      'D'           OISTAT
     C                   MOVE      'H'           OISHCD
     C                   Z-ADD     0             OIQBOO
     C                   Z-ADD     0             OIQINV
     C                   SUB       QTYSHP        OIQSHP
     C     OIQSHP        IFLT      0
     C                   Z-ADD     0             OIQSHP
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     MINKEY        CHAIN     FMINVT                             91
     C  N91              DO
     C     OIQORD        SUB       OIQSHP        WRKAL            11 1
     C     WRKAL         IFGT      0
     C                   SUB       WRKAL         IMQTAL
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C                   UPDATE    RMINVT
     C                   END
     C                   ENDDO
     C     MINKEY        CHAIN     FLKITM                             91
     C  N91              DO
     C     WRKAL         IFGT      0
     C                   SUB       WRKAL         LKPAL
     C                   UPDATE    RLKITM
     C                   END
     C                   ENDDO
     C  N90              MOVEL     'P'           OIPLPT
     C  N90              UPDATE    RIORDR
     C                   ADD       1             RECNO
     C                   GOTO      NXTPUT
     C                   END
     C*          QTYSHP    IFLE 0
     C*                    ADD  1         RECNO
     C*                    GOTO NXTPUT
     C*                    END
     C     OIITYP        IFEQ      'C'
     C     SELECTION     ANDEQ     'P'
     C                   MOVEL     'R'           OISHCD
     C                   MOVEL     'P'           OIPLPT
     C                   UPDATE    RIORDR
     C                   ADD       1             RECNO
     C                   GOTO      NXTPUT
     C                   END
     C     OIITYP        IFEQ      ' '
     C     QTYOPN        ANDEQ     0
     C     SELECTION     ANDEQ     'P'
     C                   MOVEL     'C'           OIITYP
     C                   MOVEL     'R'           OISHCD
     C                   MOVEL     'P'           OIPLPT
     C                   UPDATE    RIORDR
     C                   MOVE      ' '           OIITYP
     C                   ADD       1             RECNO
     C                   GOTO      NXTPUT
     C                   END
      ** GET PACKING CHARGE
WJB15C                   Move      *Blanks       SIZEITEM         15
WJB15C                   Eval      SIZEITEM = OISIZE + OIITEM
     C     OIITYP        IFNE      'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     OISIZE        ANDNE     'ROY'
     C     OISIZE        ANDNE     'TAG'
WJB15C     SIZEITEM      ANDNE     '7002000'
     C                   ADD       QTYSHP        TOTSHP
     C                   ENDIF
      ** GET TOTAL IF TAG ORDER
     C     OHOLST        IFEQ      'TAG   '
     C     OIITYP        ANDNE     'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     HSIZE         ANDNE     'ROY'
     C     OISIZE        ANDEQ     'TAG'
     C                   ADD       OIQSHP        TOTSHP
     C                   ENDIF
      ** BUILD RECORD FOR ITEMS STOCK/NON STOCK
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C                   MOVE      OIQDDC        DSWRK             5 4
     C     1.00          SUB       DSWRK         DSMULT            5 4
     C     OIUPRI        MULT      DSMULT        UPRWRK           11 4
     C                   Z-ADD     UPRWRK        PRICE
     C     QTYSHP        MULT(H)   UPRWRK        FSAMT
     C***        QTYSHP    MULT OIUPRI    FSAMT
     C     QTYSHP        SUB       OIQINV        QTYDIF           11 1
     C                   ADD       QTYDIF        OIQSHP
     C                   Z-ADD     QTYSHP        OIQINV
     C                   Z-ADD     QTYSHP        HSHIP
     C                   Z-ADD     OIUPRI        HPRICE            9 4
     C     SELECTION     IFNE      'C'
     C     OIQORD        SUB       OIQSHP        OIQBOO
     C                   ELSE
     C                   Z-ADD     0             OIQBOO
     C                   END
     C     OIQSHP        IFGT      0
     C                   MOVEL     'R'           OISHCD
     C                   ELSE
     C                   MOVEL     'H'           OISHCD
     C                   END
     C     KEY18         CHAIN(N)  FMINVT                             90
     C                   GOTO      WRTPUT
     C                   ENDIF
      ** BUILD RECORD FOR FREIGHT
     C     OIITYP        IFEQ      'F'
     C                   Z-ADD     FSAMT         OIUPRI
     C                   Z-ADD     FSAMT         OIEXT$
     C     FSAMT         IFNE      0
     C                   MOVE      'R'           OISHCD
     C                   ELSE
     C                   MOVE      'H'           OISHCD
     C                   END
     C                   GOTO      WRTPUT
     C                   ENDIF
      ** BUILD RECORD FOR SPECIAL CHARGE
     C     OIITYP        IFEQ      'S'
     C                   Z-ADD     FSAMT         OIUPRI
     C                   Z-ADD     FSAMT         OIEXT$
     C     FSAMT         IFNE      0
     C                   MOVE      'R'           OISHCD
     C                   ELSE
     C                   MOVE      'H'           OISHCD
     C                   END
     C                   GOTO      WRTPUT
     C                   ENDIF
      *
     C     WRTPUT        TAG
     C     OISEQ#        IFEQ      997
     C     SVPACK        IFGT      0
     C     OHOLST        ANDNE     'TAG   '
     C**         TOTSHP    MULT SVPACK    FSAMT
     C                   Z-ADD     SVPACK        FSAMT
     C                   MOVE      'R'           OISHCD
     C                   ELSE
     C                   Z-ADD     0             FSAMT
     C                   MOVE      'H'           OISHCD
     C                   END
     C                   Z-ADD     FSAMT         OIEXT$
     C                   Z-ADD     SVPACK        OIUPRI
     C                   Z-ADD     TOTSHP        OIQINV
     C                   Z-ADD     TOTSHP        OIQSHP
     C                   Z-ADD     0             OIQBOO
     C                   END
     C                   ADD       FSAMT         TOT$
     C                   MOVEL     'P'           OIPLPT
     C                   UPDATE    RIORDR
     C                   ADD       1             RECNO
     C                   GOTO      NXTPUT
      *
     C     ENDPUT        TAG
     C     TOT$          IFNE      0
     C     TOTSHP        ORNE      0
     C                   MOVE      'R'           OHHOLD
     C                   ELSE
     C                   MOVE      'H'           OHHOLD
     C                   END
     C***                  MOVE *BLANKS   OHPOS
     C                   MOVEL     LIMED         OHIMED
     C                   Z-ADD     VDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##CYMD        OHDTAC
     C                   Z-ADD     NOPCS         OHTBLK
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR235_5'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   ENDSR
      ********************
      * UN RELEASE ORDER *
      ********************
     C     UNRALL        BEGSR
     C                   Z-ADD     0             TOT$
     C                   Z-ADD     0             TOTSHP
     C                   Z-ADD     1             RECNO
     C                   SETOFF                                       9927
     C                   SETOFF                                       272829
     C     NXTUNR        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       403132
     C                   SETOFF                                       33
     C                   SETOFF                                       717374
     C     RECNO         CHAIN     ORDSFL                             90
     C                   MOVEL     DESC          TSTDES
     C     TSTDES        IFEQ      '----'
     C                   GOTO      ENDUNR
     C                   END
     C   90              DO
     C                   ADD       1             RECNO
     C     LSTREC        ADD       2             LSTRD             5 0
     C     RECNO         IFLE      LSTRD
     C                   GOTO      NXTUNR
     C                   ELSE
     C                   GOTO      ENDUNR
     C                   END
     C                   ENDDO
     C     OISEQ#        IFEQ      0
     C                   ADD       1             RECNO
     C                   GOTO      NXTUNR
     C                   END
     C                   Z-ADD     OISEQ#        SEQ
     C     IORKEY        CHAIN     RIORDR                             90
     C     OIITYP        IFEQ      'C'
     C                   MOVEL     'H'           OISHCD
     C                   UPDATE    RIORDR
     C                   ADD       1             RECNO
     C                   GOTO      NXTUNR
     C                   END
      ** GET TOTAL IF TAG ORDER
     C     OHOLST        IFEQ      'TAG   '
     C     OIITYP        ANDNE     'S'
     C     OIITYP        ANDNE     'F'
     C     OIITYP        ANDNE     'C'
     C     OISIZE        ANDNE     'ROY'
     C     OISIZE        ANDEQ     'TAG'
     C                   ADD       OIQSHP        TOTSHP
     C                   ENDIF
      ** BUILD RECORD FOR ITEMS STOCK/NON STOCK
     C     OIITYP        IFEQ      ' '
     C     OIITYP        OREQ      'N'
     C                   Z-ADD     0             QTYSHP
     C     QTYSHP        MULT      OIUPRI        FSAMT
     C                   SUB       OIQINV        OIQSHP
     C                   Z-ADD     QTYSHP        OIQINV
     C                   MOVEL     'H'           OISHCD
     C                   END
      ** BUILD RECORD FOR FREIGHT
     C     OIITYP        IFEQ      'F'
     C                   Z-ADD     FSAMT         OIUPRI
     C                   Z-ADD     FSAMT         OIEXT$
     C                   MOVE      'H'           OISHCD
     C                   GOTO      WRTUNR
     C                   ENDIF
      ** BUILD RECORD FOR SPECIAL CHARGE
     C     OIITYP        IFEQ      'S'
     C                   MOVE      'H'           OISHCD
     C                   GOTO      WRTUNR
     C                   ENDIF
      *
     C     WRTUNR        TAG
     C     OISEQ#        IFEQ      997
     C                   Z-ADD     0             FSAMT
     C                   MOVE      'H'           OISHCD
     C                   END
     C                   ADD       FSAMT         TOT$
     C                   UPDATE    RIORDR
     C                   ADD       1             RECNO
     C                   GOTO      NXTUNR
      *
     C     ENDUNR        TAG
     C                   MOVE      'H'           OHHOLD
     C**                   Z-ADDVDATE     OHDTAC
     C                   UPDATE    RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR235_6'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
     C                   ENDSR
      ********************
      * COPY TO ASFL     *
      ********************
     C     TOASFL        BEGSR
     C                   MOVE      '1'           *IN80
     C                   WRITE     AORDCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECN2             5 0
     C                   Z-ADD     1             RECNO
     C     LSTREC        ADD       1             LSTRE1            5 0
     C     NXTASF        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       403132
     C                   SETOFF                                       33
     C     RECNO         CHAIN     ORDSFL                             90
     C   90              GOTO      ENDASF
     C                   MOVEL     DESC          TSTDES            4
      ** DO NOT WRITE TOTAL LINE OUT
     C     TSTDES        IFEQ      '----'
     C                   GOTO      ENDASF
     C                   END
     C                   MOVEL     OISIZE        HSIZE
     C     OISEQ#        IFGT      0
     C                   Z-ADD     OISEQ#        SEQ
     C     IORKEY        CHAIN     FIORDR                             91
     C     OIITYP        IFEQ      'S'
     C     OIITYP        OREQ      'F'
     C                   SETON                                        1020
     C                   END
     C     OIITYP        IFEQ      'C'
     C                   SETON                                        102030
     C                   END
     C                   ELSE
     C                   SETON                                        102030
     C                   SETON                                        323340
     C                   END
     C     HSIZE         IFEQ      'ROY'
     C                   SETON                                        102032
     C                   END
      ** NOW COPY LINES
     C                   Z-ADD     OISEQ#        ASEQ#
     C                   MOVEL     OIITEM        AITEM
     C                   MOVEL     HSIZE         ASIZE
     C                   MOVEL     DESC          ADESC
     C                   MOVEL     OIBOLN        ABOLN
     C                   Z-ADD     OIDTRQ        ADTRQ
     C                   Z-ADD     QTYOPN        QTYOPA
     C                   Z-ADD     QTYSHP        QTYSHA
     C                   Z-ADD     FSAMT         FSAMTA
     C                   MOVEL     SELECTION     SELECA
     C                   ADD       1             RECN2
     C                   WRITE     AORDSFL
     C                   ADD       1             RECNO
     C     RECNO         IFLE      LSTRE1
     C                   GOTO      NXTASF
     C                   END
     C     ENDASF        ENDSR
      ********************
      * COPY FROM ASFL   *
      ********************
     C     FRMSFL        BEGSR
     C                   MOVE      '1'           *IN80
     C                   WRITE     ORDCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     1             RECN2
     C                   Z-ADD     0             RECNO
     C                   MOVE      'Y'           INSERT            1
     C                   MOVE      'N'           I996              1
     C     NXTFSF        TAG
     C                   SETOFF                                       102030
     C                   SETOFF                                       403132
     C                   SETOFF                                       33
     C     RECN2         CHAIN     AORDSFL                            90
     C   90              GOTO      ENDFSF
      ** CHECK IF 996 LINE
     C     ASEQ#         IFEQ      996
     C     VLINE         ANDEQ     996
     C                   MOVEL     'N'           INSERT
     C                   ENDIF
     C                   MOVEL     ASIZE         HSIZE
      ** CHECK FOR INSERTED LINE
     C     ASEQ#         IFGT      VLINE
     C     INSERT        ANDEQ     'Y'
     C                   Z-ADD     VLINE         SEQ
     C     IORKEY        CHAIN     FIORDR                             90
     C  N90              DO
     C     OIITYP        IFEQ      'S'
     C     OIITYP        OREQ      'F'
     C                   SETON                                        1020
     C                   END
     C     OIITYP        IFEQ      'C'
     C                   SETON                                        102030
     C                   MOVEL     ' '           SELECTION
     C                   END
      ** NOW COPY LINES
     C                   MOVEL     OIDES1        DESC
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     0             QTYSHP
     C                   Z-ADD     OIEXT$        FSAMT
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   ENDDO
     C                   MOVE      'N'           INSERT
     C                   ENDIF
     C     ASEQ#         IFGT      0
     C                   Z-ADD     ASEQ#         SEQ
     C     IORKEY        CHAIN     FIORDR                             91
     C     OIITYP        IFEQ      'S'
     C     OIITYP        OREQ      'F'
     C                   SETON                                        1020
     C                   END
     C     OIITYP        IFEQ      'C'
     C                   SETON                                        102030
     C                   END
     C                   ELSE
     C                   SETON                                        102030
     C                   SETON                                        323340
     C                   Z-ADD     0             OISEQ#
     C                   END
     C     HSIZE         IFEQ      'ROY'
     C                   MOVEL     HSIZE         OISIZE
     C                   SETON                                        102032
     C                   END
      ** NOW COPY LINES
     C                   MOVEL     ABOLN         OIBOLN
     C                   Z-ADD     ADTRQ         OIDTRQ
     C                   MOVEL     ADESC         DESC
     C                   Z-ADD     QTYOPA        QTYOPN
     C                   Z-ADD     QTYSHA        QTYSHP
     C                   Z-ADD     FSAMTA        FSAMT
     C                   MOVEL     SELECA        SELECTION
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   ADD       1             RECN2
     C                   GOTO      NXTFSF
     C     ENDFSF        TAG
      ** TEST IF WE ADDED LINE
     C     INSERT        IFEQ      'Y'
     C                   Z-ADD     VLINE         SEQ
     C     IORKEY        CHAIN     FIORDR                             90
     C  N90              DO
     C     OIITYP        IFEQ      'S'
     C     OIITYP        OREQ      'F'
     C                   SETON                                        1020
     C                   END
     C     OIITYP        IFEQ      'C'
     C                   SETON                                        102030
     C                   END
      ** NOW COPY LINES
     C                   MOVEL     OIDES1        DESC
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     0             QTYSHP
     C                   Z-ADD     OIEXT$        FSAMT
     C                   MOVEL     ' '           SELECTION
      /Free
        If OIITYP = 'C' and OISHCD = 'R';
          SELECTION = 'P';
        EndIf;
      /End-Free
     C                   ADD       1             RECNO
     C                   WRITE     ORDSFL
     C                   END
     C                   END
     C                   SETOFF                                       102030
     C                   SETOFF                                       313240
     C                   SETOFF                                       33
     C                   SETON                                        10
     C                   SETON                                        3140
     C                   Z-ADD     0             OISEQ#
     C                   MOVE      *BLANKS       OIITEM
     C                   MOVE      *BLANKS       OISIZE
     C                   MOVEL     MSG(1)        DESC
     C                   Z-ADD     0             QTYOPN
     C                   Z-ADD     TOTSHP        QTYSHP
     C                   Z-ADD     TOT$          FSAMT
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   WRITE     ORDSFL
     C     RECNO         IFGT      14
     C                   SETON                                        97
     C                   ELSE
     C                   SETOFF                                       97
     C                   END
     C                   ENDSR
      ********************
      * ADD COMMENT LINE *
      ********************
     C     ADDCOM        BEGSR
     C                   MOVE      *BLANKS       VACT              1
     C                   MOVE      *BLANKS       OVACT             1
     C                   MOVE      *BLANKS       LINTYP            1
     C                   MOVE      *BLANKS       OLNTYP            1
     C                   MOVE      *BLANKS       LDESC
     C                   MOVE      *BLANKS       OLDESC           30
     C                   Z-ADD     0             VLINE
     C                   Z-ADD     0             OLINE             3 0
     C                   Z-ADD     0             LNAMT
     C                   Z-ADD     0             OLNAMT            9 2
     C                   SETOFF                                       202122
     C                   SETOFF                                       26
     C                   SETON                                        3056
      /Free
         Exec SQL  //  Get Last Line + 2
           Select  max(OISEQ#)+ 2
             Into  :VLINE
             from  FIORDR
            where  OIORD# = :VORDER
              and  OISEQ# between 1 and 987;
      /End-Free
     C     NXTCOM        TAG
     C                   EXFMT     AORDCTL
     C   KF              GOTO      ENDCOM
     C                   SETOFF                                       202122
     C     VLINE         IFLT      2
     C     VLINE         ORGT      990
     C                   SETON                                        2021
     C                   GOTO      NXTCOM
     C                   END
     C     VLINE         IFNE      OLINE
     C                   EXSR      CHKLIN
     C   20              GOTO      NXTCOM
     C                   END
     C                   SETOFF                                       26
     C     LDESC         IFLE      *BLANKS
     C                   SETON                                        26
     C                   MOVE      *BLANKS       LDESC
     C                   GOTO      NXTCOM
     C                   END
     C     OLDESC        IFNE      LDESC
     C                   MOVEL     LDESC         OLDESC
     C                   GOTO      NXTCOM
     C                   END
     C                   MOVE      'C'           TYPE
     C                   EXSR      ADDREC
     C                   EXSR      FRMSFL
     C     ENDCOM        TAG
     C                   ENDSR
      ********************
      * ADD SPECIAL CHRG *
      ********************
     C     ADDSPC        BEGSR
     C                   MOVE      *BLANKS       VACT              1
     C                   MOVE      *BLANKS       OVACT             1
     C                   MOVE      *BLANKS       LINTYP            1
     C                   MOVE      *BLANKS       OLNTYP            1
     C                   MOVE      *BLANKS       LDESC
     C                   MOVE      *BLANKS       OLDESC           30
     C                   Z-ADD     0             VLINE
     C                   Z-ADD     0             OLINE             3 0
     C                   Z-ADD     0             LNAMT
     C                   Z-ADD     0             OLNAMT            9 2
     C                   Z-ADD     0             OLGLNO            8 0
     C                   SETOFF                                       202122
     C                   SETOFF                                       26
     C                   SETOFF                                       3056
      /Free
         Exec SQL  //  Get Last Line + 2
           Select  max(OISEQ#)+ 2
             Into  :VLINE
             from  FIORDR
            where  OIORD# = :VORDER
              and  OISEQ# between 1 and 987;
      /End-Free
     C     GLDKEY        KLIST
     C                   KFLD                    OHCOMP
     C                   KFLD                    GLTYP
     C                   MOVEL     '01'          GLTYP             2
     C     GLDKEY        CHAIN     FGLDF                              57
     C  N57              DO
     C                   MOVEL     GDSCHG        GLNO1
     C                   MOVE      GDSCHG        GLNO2
     C                   ENDDO
     C     NXTSPC        TAG
     C                   EXFMT     AORDCTL
     C   KF              GOTO      ENDSPC
     C                   SETOFF                                       202122
     C                   SETOFF                                       303157
     C     VLINE         IFLT      2
     C     VLINE         ORGT      990
     C                   SETON                                        2021
     C                   GOTO      NXTSPC
     C                   END
     C     VLINE         IFNE      OLINE
     C                   EXSR      CHKLIN
     C   20              GOTO      NXTSPC
     C                   END
     C                   SETOFF                                       26
     C     LDESC         IFLE      *BLANKS
     C                   SETON                                        26
     C                   MOVE      *BLANKS       LDESC
     C                   GOTO      NXTSPC
     C                   END
     C     LNAMT         IFEQ      0
     C                   SETON                                        31
     C                   Z-ADD     0             OLNAMT
     C                   GOTO      NXTSPC
     C                   END
      ** GET GL NO.
     C                   MOVEL     GLNO1         OIGLNO
     C                   MOVE      GLNO2         OIGLNO
     C     GLKEY         KLIST
     C                   KFLD                    OHCOMP
     C                   KFLD                    OIGLNO
     C     GLKEY         CHAIN     FMGLCH                             57
     C   57              DO
     C                   Z-ADD     0             OLGLNO
     C                   GOTO      NXTSPC
     C                   ENDDO
     C     OLDESC        IFNE      LDESC
     C     OLNAMT        ORNE      LNAMT
     C     OLGLNO        ORNE      OIGLNO
     C                   MOVEL     LDESC         OLDESC
     C                   Z-ADD     LNAMT         OLNAMT
     C                   Z-ADD     OIGLNO        OLGLNO
     C                   GOTO      NXTSPC
     C                   END
     C                   MOVE      'S'           TYPE
     C                   EXSR      ADDREC
     C                   EXSR      FRMSFL
     C     ENDSPC        TAG
     C                   ENDSR
      ********************
      * ADD FREIGHT CHRG *
      ********************
     C     ADDFRT        BEGSR
     C                   MOVE      *BLANKS       VACT              1
     C                   MOVE      *BLANKS       OVACT             1
     C                   MOVE      *BLANKS       LINTYP            1
     C                   MOVE      *BLANKS       OLNTYP            1
     C                   MOVE      *BLANKS       LDESC
     C                   MOVE      *BLANKS       OLDESC           30
     C                   Z-ADD     0             VLINE
     C                   Z-ADD     0             OLINE             3 0
     C                   Z-ADD     0             LNAMT
     C                   Z-ADD     0             OLNAMT            9 2
     C                   SETOFF                                       202122
     C                   SETOFF                                       26
     C                   SETOFF                                       30
     C                   SETON                                        56
      /Free
         Exec SQL  //  Get Last Line + 2
           Select  max(OISEQ#)+ 2
             Into  :VLINE
             from  FIORDR
            where  OIORD# = :VORDER
              and  OISEQ# between 1 and 987;
      /End-Free
     C     NXTFRT        TAG
     C                   EXFMT     AORDCTL
     C   KF              GOTO      ENDFRT
     C                   SETOFF                                       202122
     C                   SETOFF                                       3031
     C     VLINE         IFLT      2
     C     VLINE         ORGT      990
     C                   SETON                                        2021
     C                   GOTO      NXTFRT
     C                   END
     C     VLINE         IFNE      OLINE
     C                   EXSR      CHKLIN
     C   20              GOTO      NXTFRT
     C                   END
     C                   SETOFF                                       26
     C     LDESC         IFLE      *BLANKS
     C                   SETON                                        26
     C                   MOVE      *BLANKS       LDESC
     C                   GOTO      NXTFRT
     C                   END
     C     LNAMT         IFEQ      0
     C                   SETON                                        31
     C                   Z-ADD     0             OLNAMT
     C                   GOTO      NXTFRT
     C                   END
     C     OLDESC        IFNE      LDESC
     C     OLNAMT        ORNE      LNAMT
     C                   MOVEL     LDESC         OLDESC
     C                   Z-ADD     LNAMT         OLNAMT
     C                   GOTO      NXTFRT
     C                   END
     C                   MOVE      'F'           TYPE
     C                   EXSR      ADDREC
     C                   EXSR      FRMSFL
     C     ENDFRT        TAG
     C                   ENDSR
      **************
      * ADD RECORD *
      **************
     C     ADDREC        BEGSR
     C                   CLEAR                   RIORDR
     C                   Z-ADD     VORDER        OIORD#
     C                   Z-ADD     VLINE         OISEQ#
     C                   MOVE      'A'           OISTAT
     C                   MOVE      'P'           OIPLPT
     C                   Z-ADD     OHCOMP        OICOMP
     C                   MOVEL     LDESC         OIDES1
     C                   MOVE      TYPE          OIITYP
     C                   Z-ADD     HLDDAT        OIDTRQ
     C                   Z-ADD     LNAMT         OIUPRI
     C                   Z-ADD     LNAMT         OIEXT$
      /Free
        If OIITYP = 'C';
          OISHCD = 'R';
        EndIf;
      /End-Free
      * 10/23/96
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
     C                   WRITE     RIORDR
     C                   Z-ADD     0             OIGLNO
     C                   ENDSR
      *******************************
      * CHECK FOR VALID LINE NUMBER *
      *******************************
     C     CHKLIN        BEGSR
     C                   SETOFF                                       2022
     C                   Z-ADD     0             OLINE
     C     CHKKEY        KLIST
     C                   KFLD                    VORDER
     C                   KFLD                    VLINE
     C     CHKKEY        SETLL     FIORDR
     C                   READ      RIORDR                                 90
     C  N90OISEQ#        IFEQ      VLINE
     C     OIORD#        ANDEQ     VORDER
     C                   SETON                                        2220
     C                   GOTO      ENDLIN
     C                   END
     C     CHKKEY        SETLL     FIORDR
     C                   READP     RIORDR                                 90
     C  N90OIORD#        IFEQ      VORDER
     C                   Z-ADD     OISEQ#        SEQAFT            3 0
     C                   Z-ADD     OIDTRQ        HLDDAT            6 0
     C                   ELSE
     C                   Z-ADD     1             SEQAFT
     C                   Z-ADD     OHDTRQ        HLDDAT            6 0
     C                   END
     C                   Z-ADD     VLINE         OLINE
     C     ENDLIN        ENDSR
      ********************
      * GET ROYALTY      *
      ********************
     C     GETROY        BEGSR
      ** CHECK FOR ROYALTY
?    C                   CALL      'GETROYA'
?    C                   PARM                    OICOMP
?    C                   PARM                    OIORD#
?    C                   PARM                    OISEQ#
?    C                   PARM                    HSHIP
?    C                   PARM                    DESC60           60
?    C                   PARM                    ORUPRI            9 4
?    C                   PARM                    OREXT$            9 2
     C     HPRICE        IFEQ      0.0000
     C                   Z-ADD     0             ORUPRI
     C                   Z-ADD     0             OREXT$
     C                   END
 B1  C     ORUPRI        IFGT      0
?    C                   Z-ADD     OREXT$        FSAMT
?    C                   MOVEL     DESC60        DESC
?    C                   Z-ADD     HSHIP         QTYSHP
?    C                   ADD       FSAMT         TOT$
?    C                   SETON                                        102032
?    C                   MOVEL     'ROY'         OISIZE
?    C                   UPDATE    ORDSFL
?    C                   SETOFF                                       102032
 E1  C                   END
     C                   Z-ADD     0             HSHIP
     C                   ENDSR
      ********************
      * PUT ROYALTY      *
      ********************
     C     PUTROY        BEGSR
      ** CHECK FOR ROYALTY
?    C                   CALL      'GETROYP'
?    C                   PARM                    OICOMP
?    C                   PARM                    OIORD#
?    C                   PARM                    OISEQ#
?    C                   PARM                    HSHIP
?    C                   PARM                    DESC60           60
?    C                   PARM                    ORUPRI            9 4
?    C                   PARM                    OREXT$            9 2
     C     HPRICE        IFEQ      0.0000
     C                   Z-ADD     0             ORUPRI
     C                   Z-ADD     0             OREXT$
     C                   END
     C                   ENDSR
      ********************
      * CHECK REQ DATES  *
      ********************
     C     CHKDAT        BEGSR
     C                   Z-ADD     OIDTRQ        ##MDY
     C                   EXSR      @DT@A1
     C                   Z-ADD     1             D                 2 0
     C                   MOVEL     ##CYMD        CYTST             1 0
     C*          CYTST     IFEQ 0
     C     19000000      ADD       ##CYMD        NEWDT             8 0
     C*                    ELSE
     C*          20000000  ADD  ##CYMD    NEWDT   80
     C*                    END
     C     NEWDT         LOOKUP    DAT(D)                                 90
     C   90              GOTO      ENDDAT
     C                   ADD       1             LD
     C                   Z-ADD     NEWDT         DAT(LD)
     C     ENDDAT        ENDSR
      ********************
      * CHECK DATE THRU  *
      ********************
     C     RELTHR        BEGSR
     C                   Z-ADD     0             LSTDAT            8 0
     C                   Z-ADD     0             HLSTDT            8 0
     C                   SORTA     DAT
     C                   MOVE      '1'           *IN80
     C                   WRITE     DATCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECN1             5 0
     C                   SETOFF                                       10
     C                   Z-ADD     1             D
     C     NXTRL         TAG
     C     DAT(D)        IFGT      0
     C                   ADD       1             RECN1
     C                   MOVE      *BLANKS       SELECTION
     C                   Z-ADD     DAT(D)        DATER
     C                   Z-ADD     DAT(D)        HLSTDT
     C                   WRITE     DATSFL
     C                   END
     C                   ADD       1             D
     C     D             IFLT      51
     C                   GOTO      NXTRL
     C                   END
     C                   Z-ADD     0             DATER
     C     NXTDA         TAG
     C                   EXFMT     DATCTL
     C   KB              DO
     C                   Z-ADD     HLSTDT        LSTDAT
     C                   GOTO      ENDRL
     C                   ENDDO
     C     NXRL          TAG
     C                   READC     DATSFL                                 90
     C  N90SELECTION     IFNE      'X'
     C                   GOTO      NXRL
     C                   END
     C                   Z-ADD     DATER         LSTDAT
     C     LSTDAT        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      NXTDA
     C                   END
     C                   Z-ADD     DATER         LSTDAT
     C     ENDRL         ENDSR
      ************************
      * CHECK FREIGHT CHARGE *
      ************************
     C     GETFRT        BEGSR
     C                   Z-ADD     996           SEQ               3 0
     C     IORKEY        CHAIN     FIORDR                             91
     C     FRTKEY        KLIST
     C                   KFLD                    OHCOMP
     C                   KFLD                    FPCODE
     C                   MOVE      OHPLST        FPCODE
     C     FRTKEY        CHAIN     FFPERC                             92
     C   92              DO
     C                   MOVE      *BLANKS       FPTYPE
     C                   MOVEL     'D'           OISTAT
     C  N91              UPDATE    RIORDR
     C                   GOTO      ENDFGT
     C                   ENDDO
     C     FPTYPE        IFEQ      'F'
     C     UPSKEY        KLIST
     C                   KFLD                    OHCOMP
     C                   KFLD                    OHUPSZ
     C     UPSKEY        CHAIN     FUZONE                             92
     C   92              DO
     C                   Z-ADD     0             FUCHRG
     C                   MOVEL     'D'           OISTAT
     C  N91              UPDATE    RIORDR
     C                   GOTO      ENDFOK
     C                   ENDDO
     C                   END
     C   91              DO
     C                   CLEAR                   RIORDR
     C                   Z-ADD     VORDER        OIORD#
     C                   Z-ADD     996           OISEQ#
     C                   MOVE      'A'           OISTAT
     C                   Z-ADD     OHCOMP        OICOMP
     C                   MOVEL     MSG(8)        OIDES1
     C                   MOVE      'F'           OIITYP
     C                   MOVEL     'P'           OIPLPT
     C                   WRITE     RIORDR
     C                   ENDDO
     C  N91              DO
     C                   MOVE      'A'           OISTAT
     C                   MOVEL     'P'           OIPLPT
     C                   MOVEL     ' '           OICOFL
     C                   UPDATE    RIORDR
     C                   ENDDO
      /Free

       Exec SQL // Get FHORDR.OHFRTX
         Select OHFRTX into :TaxFreight from FHORDR where OHORD# = :OIORD#;

       Exec SQL
         Update FIORDR
            Set OITXCD = :TaxFreight,
                OITXST = :TaxFreight,
                OITXCT = :TaxFreight,
                OITXLC = :TaxFreight
         where  OIORD# = :OIORD#
           and  OISEQ# = :OISEQ#;

      /End-Free
     C     ENDFOK        TAG
     C                   Z-ADD     996           VLINE
     C                   MOVEL     'F'           TYPE
     C                   EXSR      FRMSFL
     C     ENDFGT        ENDSR
      ************************
      * CHECK PACKING CHARGE *
      ************************
     C     PACKC         BEGSR
     C     IORKEY        KLIST
     C                   KFLD                    VORDER
     C                   KFLD                    SEQ
     C                   Z-ADD     997           SEQ               3 0
     C     IORKEY        CHAIN     FIORDR                             91
     C     SVPACK        IFEQ      0
     C     OHOLST        OREQ      'TAG   '
     C  N91              MOVE      'D'           OISTAT
     C  N91              UPDATE    RIORDR
     C                   GOTO      ENDKC
     C                   END
     C     SVPACK        IFNE      0
     C   91              DO
     C                   CLEAR                   RIORDR
     C                   Z-ADD     VORDER        OIORD#
     C                   Z-ADD     997           OISEQ#
     C                   MOVE      'A'           OISTAT
     C                   Z-ADD     OHCOMP        OICOMP
     C                   MOVEL     MSG(3)        OIDES1
     C                   MOVE      'S'           OIITYP
     C                   MOVEL     'P'           OIPLPT
     C                   WRITE     RIORDR
     C                   ENDDO
     C  N91OISTAT        IFEQ      'D'
     C                   MOVE      'A'           OISTAT
     C                   MOVEL     'P'           OIPLPT
     C                   UPDATE    RIORDR
     C                   END
     C                   END
     C     ENDKC         ENDSR
      *
      **************************
      * GET CASH AND CARRY     *
      **************************
     C*          GET990    BEGSR
     C**                   Z-ADD0         OHDISC
     C*                    Z-ADD990       SEQ
     C*          IORKEY    CHAINFIORDR               91
     C* N91      OISTAT    IFEQ 'D'
     C*                    GOTO END990
     C*                    END
     C*                    MOVE *BLANKS   OIITEM
     C*                    MOVE *BLANKS   OISIZE
     C*          DECCDE    IFLE *BLANKS
     C*                    MOVELMSG,7     OIDES1
     C*                    ELSE
     C*                    MOVELDECCDE    OIDES1
     C*                    END
     C*                    MOVE *BLANKS   OIDES2
     C*                    Z-ADDOHCOMP    OICOMP
     C*                    MOVE *BLANKS   OIWHSE
     C*                    MOVE *BLANKS   OIBIN#
     C*                    MOVE *BLANKS   OIUUOM
     C*                    Z-ADD0         OIMULT
     C*                    Z-ADD0         OIUWGT
     C*                    Z-ADD0         OIUCST
     C*                    Z-ADD0         OIUPRI
     C*                    Z-ADD0         OIQDDC
     C*                    Z-ADD0         OIEXT$
     C*                    Z-ADD0         OIQORD
     C*                    Z-ADD0         OIQSHP
     C*                    Z-ADD0         OIQBOO
     C**                   Z-ADD0         OIFET$
     C*                    Z-ADD0         OIAMT1
     C*                    Z-ADD0         OIAMT2
     C*                    Z-ADD0         OIAMT3
     C*                    Z-ADD0         OIDISC
     C*                    MOVE OHPRCD    OIOVER
     C*                    MOVE OHBOCD    OIBOCD
     C*                    MOVE OHSLM1    OISLM1
     C*                    Z-ADDOHSCM1    OICOM1
     C*                    MOVE OHSLM2    OISLM2
     C*                    Z-ADDOHSCM2    OICOM2
     C*                    Z-ADDOHCUST    OICUST
     C*                    Z-ADDOHDTRQ    OIDTRQ
     C*                    Z-ADDTDATE     OIDTLA
     C*                    Z-ADDTIMOD     OITIME
     C*                    MOVELUSERID    OIUSER
     C*                    Z-ADD0         OITRDC
     C*                    MOVEL'N'       OICTCD
     C*                    MOVELOHCOFL    OICOFL
     C*                    MOVEL'S'       OIITYP
     C**                   Z-ADD0         OIQINV
     C*                    MOVE OHSPTX    OITXCD
     C*                    MOVEL'N'       OITXST
     C*                    MOVEL'N'       OITXCT
     C*                    MOVEL'N'       OITXLC
     C*                    MOVELOHROUT    OIROUT
     C*                    Z-ADDOHSTOP    OISTOP
     C*                    MOVEL'N'       OICWT
     C*                    Z-ADD0         OILBS#
     C*                    Z-ADD0         OIWGSH
     C*                    MOVE ' '       OIRSCD
     C*                    Z-ADD0         OISEQP
     C*                    MOVE ' '       OIPRAL
     C*                    MOVE *BLANKS   OIBPUM
     C*                    MOVE *BLANKS   OISUOM
     C*                    MOVE *BLANKS   OIBLUM
     C**                   Z-ADD1.0000    OIMUL2
     C*                    MOVEL'N'       OILOTC
     C*                    MOVE ' '       OIOPFL
     C*                    MOVE ' '       OIBOLN
     C*                    Z-ADD0         OIBORQ
     C*                    MOVE ' '       OIPRBO
     C*                    MOVELOHSTA     OISTA
     C*                    MOVELOHSHFR    OISHFR
     C*                    Z-ADD0         OITAGS
     C*                    MOVEL'N'       OIPPDC
     C*          OHDTCN    MULT 10000.01  OIRVCD
     C*                    MOVELOHQUOT    OIQTE
     C*                    Z-ADDOHORDT    OIORDT
     C*          OHDTRQ    MULT 10000.01  OIRVDT
     C*                    MOVE *BLANKS   OILOT#
     C*                    MOVE 'N'       OIFRQD
     C*                    MOVE ' '       OISPFL
     C*                    MOVELOHALPH    OIALPH
     C*                    MOVE *BLANKS   OIPRCL
     C*                    MOVE *BLANKS   OINPSL
     C*                    Z-ADD0         OIRQTY
     C*                    MOVE ' '       OIPOST
     C*                    Z-ADD0         OISOW
     C*                    MOVE 'A'       OISTAT
     C*  91                Z-ADD990       OISEQ#
      **** OUTPUT IORDR RECORD
     C*                    Z-ADDVORDER    OIORD#
     C*                    MOVE 'N'       OISHCD
     C*                    MOVE 'P'       OIPLPT
     C*                    Z-ADD0         OIINV#
     C**                   Z-ADDDECANC    OHDISC
     C*  91                WRITERIORDR
     C* N91                UPDATRIORDR
     C*          END990    ENDSR
      *
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
     C     VUPRIC        MULT(H)   WKDISC        #PRC             11 2
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
      *
      *
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR
     C                   MOVE      ##MDY         #03A              3 0
     C                   MOVEL     0             #03A
     C                   MOVEL     ##MDY         #04               4 0
     C                   MOVEL     ##MDY         #02B              2 0
     C                   MOVE      #04           #02C              2 0
     C                   Z-ADD     ##MDY         ##MDY             6 0  90
     C  N90              Z-ADD     #02B          #02               2 0    90
     C  N90#02B          COMP      12                                 90
     C  N90#02C          COMP      01                                   90
     C  N90#02C          COMP      31                                 90  91
     C     #02B          COMP      07                                 92
     C   921             ADD       #02B          #02
     C     #02           DIV       2             #02
     C                   MVR                     #02                  92
     C   91
     CANN92              SETON                                        90
     C     #02B          COMP      02                                     91
     C  N91
     COR 90              GOTO      @DT@AX
     C     #03A          DIV       4             #03               3 0
     C                   MVR                     #02                      91
     C     #02C          COMP      29                                 90  92
     C  N91
     CAN 92              SETON                                        90
     C     @DT@AX        TAG
     C                   MOVEL     #03A          ##CYMD            7 0
     C                   MOVE      #04           ##CYMD
     C     #03A          COMP      070                                  91
     C   91              MOVEL     1             ##CYMD
     C   90              Z-ADD     0             ##CYMD
     C                   SETOFF                                       9192
     C                   ENDSR
      *****
0006 C********************************************************************@DT@B2
0007 C* CONVERT MMDDYY TO DAY OF CENTURY DDDDD. INDICATOR 90 NEGATIVE DATE@DT@B2
0008 C* ##MDY INPUT DATE MMDDYY                                           @DT@B2
0009 C* ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B2
0010 C* INDICATORS USED 90-92                                             @DT@B2
0011 C********************************************************************@DT@B2
0003 C     @DT@B2        BEGSR
0012 C                   Z-ADD     ##MDY         ##MDY             6 0  90
0013 C* CONVERT YEAR TO DAYS                                              @DT@B2
0014 C                   MOVE      ##MDY         #02               2 0
0015 C     #02           MULT      365           ##DDD             5 0
0016 C     #02           DIV       4             #02                  91
0017 C   91              MVR                     #02A              2 0    91
0018 C     #02           ADD       ##DDD         ##DDD
0019 C* CONVERT MONTH TO DAYS                                             @DT@B2
0020 C                   MOVEL     ##MDY         #04               4 0
0021 C                   MOVEL     #04           #02A
0022 C     #DY(#02A)     ADD       ##DDD         ##DDD
0023 C     #02A          COMP      02                                 92
     C   91
0024 CANN92##DDD         SUB       1             ##DDD
0025 C* ADD DAY OF MONTH                                                  @DT@B2
0026 C                   MOVE      #04           #02
0027 C     #02           ADD       ##DDD         ##DDD
0028 C   90              Z-ADD     0             ##DDD
0029 C                   SETOFF                                         9192
0030 C                   ENDSR
0006 C********************************************************************@DT@D0
0007 C* CONVERT DAY OF CENTURY DDDDD TO MMDDYY                            @DT@D0
0008 C* ##DDD INPUT DAY OF CENTURY.                                       @DT@D0
0009 C* ##MDY OUTPUT DATE MMDDYY.                                         @DT@D0
0010 C* INDICATOR 90 IS A MINUS DATE.                                     @DT@D0
0011 C* INDICATORS 91-93 USED.                                            @DT@D0
0012 C********************************************************************@DT@D0
0003 CSR   @DT@D0        BEGSR
0013 CSR                 Z-ADD     0             ##MDY             6 0
0014 C                   SETOFF                                       919293
0015 C* TEST IF ZERO OR NEGATIVE                                          @DT@D0
0016 C     ##DDD         SUB       1             #05               5 0  90
0017 C   90              GOTO      @DT@DX
0018 C* CALCULATE YEARS AND DAY OF YEAR                                   @DT@D0
0019 C     #05           DIV       365           #03               3 0
0020 C                   MVR                     #03A              3 0
0021 C* CALCULATE # OF LEAPS                                              @DT@D0
0022 C     #03           DIV       4             #02               2 0    92
0023 C                   MVR                     #01               1 0    91
     C   92
0024 CAN 91              SETOFF                                       91
0025 C     #03A          ADD       1             #03A
0026 C* IF LEAP YEAR, REDUCE # OF LEAPS BY ONE.                           @DT@D0
0027 CSR 91#02           SUB       1             #02
0028 CSR   #03A          SUB       #02           #03A                 92
0029 C* IF DAYS NOT POSITIVE, ADJUST YEARS.                               @DT@D0
0030 CSRN92#03A          ADD       365           #03A
0031 C  N92#03           SUB       1             #03                    91
0032 C* DETERMINE IF NEW YEAR IS A LEAP.                                  @DT@D0
     CSRN92
0033 CANN91#01           COMP      1                                      91
0034 C* IF LEAP YEAR WAS MINUS                                            @DT@D0
     CSRN92
0035 CAN 91#03A          ADD       1             #03A
0036 C*                                                                   @DT@D0
0037 CSR   @DT@DA        TAG
0038 C* CALCULATE MONTH AND DAY.                                          @DT@D0
0039 CSR                 Z-ADD     2             #02                    9293
0040 C* LEAP YEAR.                                                        @DT@D0
0041 CSR 91#03A          COMP      60                                 93  92
     CSR 91
0042 CAN 93#03A          SUB       1             #03A
     CSR 91
0043 CAN 92              Z-ADD     3             #02
0044 CSRN92#03A          LOOKUP    #JD(#02)                           93  93
0045 C*                                                                   @DT@D0
0046 CSR   #02           SUB       1             #02
0047 CSR   #03A          SUB       #JD(#02)      #03A
0048 CSR                 Z-ADD     #03A          #04               4 0
0049 CSR                 MOVEL     #02           #04
0050 CSR                 Z-ADD     #03           ##MDY
0051 CSR                 MOVEL     #04           ##MDY
0052 C*                                                                   @DT@D0
0053 CSR                 SETOFF                                       919293
0054 CSR   @DT@DX        ENDSR
     C********************************************************************@DT@D0
      **
      * GET DESCRIPTION
      **
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'P'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             30
     C                   ENDSR
      *************
      * GET PRINTER
      *************
     C     GTPTR         BEGSR
     C                   MOVEL     *BLANKS       LPRTR
     C                   MOVEL     'Y'           LIMED
     C                   MOVEL     OHSHFR        LSHFR
     C                   MOVEL     'I'           TYPE              1
     C                   MOVEL     DEPINV        LPRTR
     C                   MOVEL     LPRTR         VPRINT
     C                   ENDSR
      /Free
SUD05 //--------------------------------------------------------------------
  |   *?                :----------------------:
  |   *?                : FedExInfo Subroutine :
  |   *?                :----------------------:
  |   *
  |     Begsr FedExInfo;
  |
  |   *?   // Initialise
  |        isFedExOrder = *Off;
  |        WkFreight = *Zeros;
  |        Invoice = *Zeros;
  |        BillAmt = *Zeros;
  |        LGCNT   = *Zeros;
  |        MDCNT   = *Zeros;
  |        SMCNT   = *Zeros;
  |        UKCNT   = *Zeros;
  |        WkBox   = *Blanks;
  |
  |   *?   // Check Order is FedEx or Not
  |        isFedExOrder = ISFEDEXORD(OHORD#);
  |        If isFedExOrder = *On;
  |           *In45 = *Off;
  |
  |   *?      // Get Service Type
  |           Exec Sql Select Service into :WkService From WRITE_SHP
  |              Where :OHORD# in (ORDER_1,ORDER_2,ORDER_3,ORDER_4,ORDER_5) ;
  |           Service# = %Trim(WkService);
  |
  |   *?      // Get Invoice
  |           Invoice = FEDEXONINV(OHORD#);
  |
  |   *?      // Get Bill Amount
  |           BILLAMT = FEDEXBILL(OHORD#);
  |
  |   *?      // Get Box Count , Boxing Charges and Freight
  |           LGCNT = FEDEXBOXC(OHORD# : 'LG');
  |           If LGCNT <> *Zeros;
  |              Wkbox = FEDEXBOXCH(OHORD# : 'LG');
  |              WkFreight = FEDEXFRGHT(OHORD# : 'LG');
  |              BOX1  = %Trim(WkBox);
  |              FRGT1 = WkFreight;
  |              TEXT1 = 'Kube-Pak';
  |           Else;
  |              BOX1  = *Blanks;
  |              FRGT1 = *Zeros;
  |              TEXT1 = *Blanks;
  |           Endif;
  |
  |           MDCNT = FEDEXBOXC(OHORD# : 'MD');
  |           If MDCNT <> *Zeros;
  |              Wkbox = FEDEXBOXCH(OHORD# : 'MD');
  |              WkFreight = FEDEXFRGHT(OHORD# : 'MD');
  |              BOX2  = %Trim(WkBox);
  |              FRGT2 = WkFreight;
  |              TEXT2 = 'Kube-Pak';
  |           Else;
  |              BOX2  = *Blanks;
  |              FRGT2 = *Zeros;
  |              TEXT2 = *Blanks;
  |           Endif;
  |
  |           SMCNT = FEDEXBOXC(OHORD# : 'SM');
  |           If SMCNT <> *Zeros;
  |              Wkbox = FEDEXBOXCH(OHORD# : 'SM');
  |              WkFreight = FEDEXFRGHT(OHORD# : 'SM');
  |              BOX3  =  %Trim(WkBox);
  |              FRGT3 = WkFreight;
  |              TEXT3 = 'Kube-Pak';
  |           Else;
  |              BOX3  = *Blanks;
  |              FRGT3 = *Zeros;
  |              TEXT3 = *Blanks;
  |           Endif;
  |
  |           UKCNT = FEDEXBOXC(OHORD# : 'UK');
  |           If UKCNT <> *Zeros;
  |              BOX4  = 'Unknown';
  |              WkFreight = FEDEXFRGHT(OHORD# : 'UK');
  |              FRGT4 = WkFreight;
  |              TEXT4 = 'Kube-Pak';
  |              *In46 = *On;
  |           Else;
  |              BOX4  = *Blanks;
  |              FRGT4 = *Zeros;
  |              TEXT4 = *Blanks;
  |              *In46 = *Off;
  |           Endif;
  |        Else;
  |           *In45 = *On;
  |           *In46 = *Off;
  |        Endif;
  |
  |     Endsr;
SUD05 *?-------------------- End Of Subroutine --------------------------------
        //--- isPlugOrder ------------------------------------------------------
        dcl-proc isPlugOrder;
          dcl-pi *n ind;
            #order packed(6:0);
          END-PI;
          dcl-s hasPlugs ind inz(*off);
          Exec SQL // See if order is a plug order
            Select '1' into :hasPlugs
              from PLUG_ORD where PLORD# = :OHORD#
            Fetch First Row Only;
          Return hasPlugs;
        END-PROC;

        //--- isFedExSVIA ------------------------------------------------------
        dcl-proc isFedExSVIA;
          dcl-pi *n ind;
            #SVIA char(2);
          END-PI;
          dcl-s isFedEx ind inz(*off);
          Exec SQL // See if SVIA is a FedEx SVIA
            Set  :isFedEx = isFedExSVIA(:#SVIA);
          Return isFedEx;
        END-PROC;
      /End-Free
** MESSAGE
----* End of Order *                                       1
Automatic Misc Charges                                     2
Packing Charges                                            3
Customer Does NOT Allow B/O                                4
Customer Does Allow B/O                                    5
Delivery Charge                                            6
5% Cash/Carry Discount * Items                             7
Freight Charge                                             8
**  02 03 04 05 06 07 08 09 10 11 12 DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
