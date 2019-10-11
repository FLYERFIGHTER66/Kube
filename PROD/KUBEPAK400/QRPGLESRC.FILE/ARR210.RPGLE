      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      *  TO SEARCH FOR STARTING POINTS WITHIN THE PROGRAM
      *                                   OPTIONS   1ST SCREEN  PROCESSING
      *  PAYMENT TYPE 1 - CASH PAYMENTS    OPT1       SELC1        RUN1
      *               2 - CC PAYMENTS      OPT2       SELC2        RUN2
      *               3 - ADJUSTMENTS      OPT3       SELC3        RUN3
      *               4 - SPREAD ACCT      OPT4       SELC4        RUN4
      *               5 - INQUIRY          OPT5       SELC5        RUN5
      *               NOT PRINTING LINES   OPT6                    RUN6
      *               7 - NON CASH A/R     OPT7       SELC7        RUN7
      *--------------------------------------------------------------
      *  FIELD NAME - "BTST"  BILL TO / SHIP TO CONTROL
      *                       "N" = BILL TO ONLY KEY
      *                       "Y" = BILL TO / SHIP TO KEY
      *  FIELD NAME - "PAY01" ORIGINAL AMOUNT SELECTED TO PAY
      *               "PAY02" AMOUNT APPLIED WITH CMD 1
      *               "PAY03" AMOUNT SELECTED BUT NOT APPLIED (NO CND 1)
      *               "PAY08" AMOUNT PERM  APPLIED (01-02   =08) PERM ONLY
      *               "PAY09" AMOUNT TO BE APPLIED (01-02-03=09) ALL PAYS
      *--------------------------------------------------------------
      *  SWITCH USAGE  U1 - TEST FOR OUT OF BALANCE
      *                U2 - WILL DISPLAY ONLY OPEN LINES
      *                U7 - CONTROLS OPTIONS SCREEN
      *                U8 - WILL STOP KEYING OF CHECK DATE ON SEL1
      *--------------------------------------------------------------
      *  CASH PAYMENT TYPES                     1  2  3  4  4
      *                                         CK CC AD S1 S2
      *          01 - INVOICE                   Y  Y  Y     Y
      *          02 - PAYMENT (CASH/CHECK)      C
      *          03 - PAYMENT (CASH ON ACCOUNT) C  C  C  Y
      *          04 - ADJUSTMENT                      Y
      *          05 - CREDIT MEMO               Y  Y  Y  Y
      *          06 - NON A/R CASH
      *          07 - LATE CHARGE               Y  Y  Y     Y
      *   VOID   08 - PAYMENT (OLDEST FIRST)
      *          09 - DISCOUNT                  C  C
      *          10 - PAYMENT (CREDIT CARD)        C
      *          11 - DOWN PAYMENT
      *          12 - BOUNCED CHECK             Y  Y  Y     Y
      *          13 - DECLINED CREDIT CARD
      *          14 - BOUNCED CHECK CHARGE      Y  Y  Y     Y
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR210
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- APPLY CASH RECEIPTS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  MJT01              REMOVE NOT NEEDED INFO & FIX ALPHA
      *  MJT02  01/12/00    FIX G/L NUMBERS FOR ON ACCT & NON A        /R CASH
      *  MJT03  07/21/00    FIX STARTING PAGE NUMBERS                  /R CASH
      *  EFD02  08/10/00    FIX UPDATING AMT LAST PAYMENT ARHST        /R CASH
      *  EFD03  03/19/01    FIX COMPANY NUMBER IF NO A/R.              /R CASH
      *  EFD04  03/22/01    RECORD NUMBER TO SMALL FOR SUB FILES.
      *  MJT04  08/23/01    ADD BANK NUMBER TO AROPN & MTRAN
      *                     ADD INV# & SUFF TO AROPN & MTRAN FOR #4
      *  WJB    03/20/08    Put CC# on all CC transactions
      *
      //------------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ----------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ----------------------------------------
      * SUD01   04/19/18   S.Uthaya     PCI Project - Added Credit Card process
      *                                 Added F8 Function key to Process Payment
      * SUD02   07/24/18   S.Uthaya     Manual Swiping Logic Added
      * SUD03   07/26/18   S.Uthaya     Move Values based on Token/Credit Card
      *                                 to FMTRAN File
      //------------------------------------------------------------------------
     FFAROPNDD  IF   E           K DISK
     F                                     RENAME(RAROPN:RAROP1)
     FFAROPNSA  IF   E           K DISK
     F                                     RENAME(RAROPN:RAROP2)
     FFAROPN    UF A E           K DISK
     FFMTRAN    UF A E           K DISK
     FFMCUST    IF   E           K DISK
     FFCMREAS   IF   E           K DISK
     FFMBANK    IF   E           K DISK
     FFMCRED    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FFARHST    UF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFAR210    UF A E           K DISK
     FARR210FM  CF   E             WORKSTN
     F                                     SFILE(S10SFL:RR1)
     F                                     SFILE(S60SFL:RR5)
      *
SUD01 *
  |   /Free
  |   *?Procedure Interface Declaration : Credit Card Selection Screen
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
  |        PCApr      Char(10);                  // C.C Approval Statu
  |        PAmount    Packed(11:2);              // Amount to be paid
  |        PManual    Char(1);                   // To Identify Manual Process
  |     End-Ds;
  |   *
  |   /End-Free
SUD01 *
     D TP              S              3    DIM(15) CTDATA PERRCD(1)
     D CM              S             69    DIM(16) CTDATA PERRCD(1)
     D ER              S             28    DIM(10) CTDATA PERRCD(1)
     D SL              S             30    DIM(7) CTDATA PERRCD(1)
     D PH              S             17    DIM(6) CTDATA PERRCD(1)
     D W0              S             55    DIM(36) CTDATA PERRCD(1)
     D W1              S             55    DIM(16) CTDATA PERRCD(1)
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
      * SETUP ZONED NUMBERS FOR PASSING
     D                 DS
     D  ZON060                 1      6  0
      * TEST FOR CC EXPIRATION DATE
     D                 DS
     D  CCEXDS                 1      6
     D  CRCEX0                 1      2
     D  CRCEX2                 3      4
     D  CRCEX1                 5      6
     D  UDATDS                 7     12
     D  UDATX0                 7      8
     D  UDATX2                 9     10
     D  UDATX1                11     12
     D                UDS
     D  LCO                    1      2  0
     D  LCUST                  3      8  0
     D  LHIST                  9      9
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
     C     K0AROP        KLIST
     C                   KFLD                    CUST
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
     C                   KFLD                    SEQ#
     C     K1AROP        KLIST
     C                   KFLD                    CUST
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
     C     KKBTST        KLIST
     C                   KFLD                    CUST
     C                   KFLD                    SHIP
     C     K0BTST        KLIST
     C                   KFLD                    CUST
     C                   KFLD                    SHIP
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
     C                   KFLD                    SEQ#
     C     K1BTST        KLIST
     C                   KFLD                    CUST
     C                   KFLD                    SHIP
     C                   KFLD                    INV#
     C                   KFLD                    SUFF
     C     K1GLCH        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLAC
      *
     C                   Z-ADD     LCO           ARCOMP
     C                   Z-ADD     LCO           LCOXX            02 0
     C                   MOVE      '1'           SL01
     C                   MOVE      '1'           SL02             01
      *
     C     LCO           CHAIN     FARCTL                             50
     C     *IN50         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   GOTO      EOJ
     C                   END
      *
     C     LCO           CHAIN     FGLDF                              50
     C     *IN50         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C*                    GOTO EOJ
     C                   END
      *
     C     LCO           CHAIN     FMAPER                             50
     C     *IN50         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   GOTO      EOJ
     C                   END
     C                   Z-ADD     ACFSST        TDATE            06 0
     C                   CALL      '@DT@A1'
     C                   PARM                    TDATE
     C                   PARM                    TDATPY           07 0
     C                   PARM      'N'           RETC
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     ACEN12        TDATE
     C                   ELSE
     C                   Z-ADD     ACEN13        TDATE
     C                   END
     C                   CALL      '@DT@A1'
     C                   PARM                    TDATE
     C                   PARM                    TDATEY           07 0
     C                   PARM      'N'           RETC
      *
     C                   EXSR      GETDAT
     C     RETC          IFEQ      '3'
     C                   GOTO      EOJ
     C                   END
      *
     C                   MOVE      ACBANK        BANK
     C     BANK          CHAIN     FMBANK                             50
     C     *IN50         IFEQ      '1'
     C                   MOVEL     'RNF'         BANKDS
     C                   ELSE
     C                   MOVE      BADESC        BANKDS
     C                   END
     C                   SETON                                        19
     C                   Z-ADD     0             VALAST
     C                   Z-ADD     0             VSLAST
      *
      * START A NEW RECEIPT
      *
     C     RSTRTA        TAG
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '000'         *IN(19)
     C                   MOVE      *BLANKS       LOK1             15
     C                   MOVE      *BLANKS       LOK2             15
     C                   MOVE      'N'           PYON             01
     C                   MOVE      *BLANKS       SELC
     C                   MOVE      *BLANKS       GLDESC
     C                   MOVE      BANK          BANKXX
SEL1 C                   MOVE      *BLANKS       CHEK
SEL1 C                   Z-ADD     0             CKDT
SEL1 C                   Z-ADD     0             PAID
     C                   Z-ADD     0             PAGE#
     C                   MOVE      BANKXX        BANK
     C                   MOVE      '0'           *IN25
     C                   EXSR      CLRW1
      *
      * CONTINUE WITH A RECEIPT
      *
     C     NXTA          TAG
WJB  C                   Eval      CRCD  = *Blanks
WJB  C                   Eval      CRC#  = *Zeros
WJB  C                   Eval      PAID  = *Zeros
WJB  C                   Eval      CRCA  = *Blanks
WJB  C                   Eval      CRCE  = *Zeros
     C                   MOVEL     *BLANKS       CANAME
     C                   MOVEL     *BLANKS       CSNAME
     C                   Z-ADD     0             VACUST
     C                   Z-ADD     0             VSCUST
     C                   MOVEA     '00'          *IN(21)
     C     VALAST        IFGT      0
     C                   MOVE      '1'           *IN21
     C                   END
     C     VSLAST        IFGT      0
     C                   MOVE      '1'           *IN22
     C                   END
     C                   MOVE      '0'           *IN40
      *
     C                   MOVEA     '00'          *IN(25)
     C                   MOVEL     CM(11)        CM7801
     C     PYON          IFEQ      'Y'
     C                   MOVE      '1'           *IN25
     C                   MOVEL     CM(12)        CM7801
     C     SELC          IFEQ      '1'
     C     SELC          OREQ      '2'
     C                   MOVE      '1'           *IN26
     C                   END
     C                   END
      *
     C                   EXSR      CLRWXX
      *
     C     NXTAS         TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '000'         *IN(19)
     C                   SETOFF                                       99
      *
     C     PYON          IFNE      'Y'
     C     *INKC         IFEQ      '1'
     C     *INKG         OREQ      '1'
     C                   GOTO      EOJ
     C                   END
     C                   END
      *
      *
     C     *INKM         IFEQ      '1'
     C     PYON          ANDNE     'Y'
     C                   EXSR      GETDAT
     C     RETC          IFEQ      '3'
     C                   GOTO      EOJ
     C                   END
     C                   GOTO      RSTRTA
     C                   END
      *
      *
     C     SELC          IFNE      '1'
     C     SELC          ANDNE     '2'
     C     SELC          ANDNE     '3'
     C     SELC          ANDNE     '4'
     C     SELC          ANDNE     '5'
     C     SELC          ANDNE     '6'
     C     SELC          ANDNE     '7'
     C                   SETON                                        13
     C                   GOTO      NXTA
     C                   END
      *
      *
     C     VACUST        IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     CMCUST        VACUST
     C                   MOVEL     CMNAME        CANAME
     C                   GOTO      NXTAS
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VACUST        IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     VATELE        ANDGT     *BLANKS
     C                   MOVEL     VATELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VATELE
     C                   Z-ADD     CMCUST        VACUST
     C                   MOVEL     CMNAME        CANAME
     C                   GOTO      NXTAS
     C                   ENDIF
      *  ZIP CODE # SEARCH
      *
     C     VACUST        IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C     VATELE        ANDEQ     *BLANKS
     C     VZIP          ANDGT     *BLANKS
     C                   MOVEL     VZIP          CMZIP
     C                   CALL      'LKZIP'
     C                   PARM                    CMZIP
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VZIP
     C                   Z-ADD     CMCUST        VACUST
     C*                    MOVELCMNAME    VNAME
     C                   GOTO      NXTAS
     C                   ENDIF
      *
     C     VACUST        IFEQ      0
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        CHAIN     FMCUST                             31
     C   31              SETON                                        1114
     C   31              GOTO      NXTA
     C                   MOVEL     CMNAME        CANAME
     C                   MOVEL     CMLOOK        LOK1
      *
      * SHIP TO CUSTOMER
      *
     C     VSCUST        IFEQ      0
     C     VSALPH        ANDGT     *BLANKS
     C                   MOVEL     VSALPH        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VSALPH
     C                   MOVEL     CMNAME        CSNAME
     C                   Z-ADD     CMCUST        VSCUST
     C                   GOTO      NXTAS
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VSCUST        IFEQ      0
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
     C                   GOTO      NXTAS
     C                   ENDIF
      *
     C     VSCUST        IFGT      0
     C     VSALPH        ANDGT     *BLANKS
     C                   SETON                                        1517
     C   17              GOTO      NXTA
     C                   ENDIF
      *
     C     VSCUST        IFGT      0
     C     VSCUST        CHAIN     FMCUST                             31
     C  N31              MOVEL     CMNAME        CSNAME           30
     C   31              SETON                                        1615
     C   16              GOTO      NXTA
     C                   MOVEL     CMLOOK        LOK2
     C                   ENDIF
      *
     C** --- COMMON TO ALL LINE TYPES ------------------------------------------
     C                   MOVEA     '00000000'    *IN(10)
      *
     C                   Z-ADD     VACUST        CUST              6 0
     C                   Z-ADD     0             SHIP              6 0
     C                   MOVEL     LOK1          LOOK             15
     C                   MOVE      'N'           BTST             01
     C                   MOVE      'N'           INKLXX
     C     VSCUST        IFGT      0
     C                   Z-ADD     VSCUST        SHIP
     C                   MOVE      'Y'           BTST
     C                   MOVEL     LOK2          LOOK
     C                   MOVE      '1'           *IN10
     C                   END
     C* SETUP ARHST UPDATE
     C                   Z-ADD     0             PAID##
     C                   Z-ADD     0             PAID#D
     C                   Z-ADD     0             PAID#L
     C                   MOVE      'N'           CCHIST           01
     C     VACUST        CHAIN     FARHST                             50
     C     *IN50         IFEQ      '1'
     C                   Z-ADD     25            CTW
     C                   EXSR      WARN01
     C                   Z-ADD     0             HSCRC#
     C                   Z-ADD     0             HSCRDT
     C                   END
     C*
     C     PYON          IFEQ      'Y'
     C                   GOTO      SELCOK
     C                   END
     C                   Z-ADD     0             CT               03 0
     C                   MOVE      SELC          CT
     C                   MOVEL     SL(CT)        HEAD30
      *
      *
     C     PASCST        TAG
      *
      *
     C** --- CASH PAYMENT - LOAD CHECK INFO ------------------------------------
     C** --- OPT1 --- ** SEARCH FIELD
     C     SELC          IFEQ      '1'
     C                   MOVEA     '1100'        *IN(01)
     C                   MOVE      'Y=Pay'       HD05
     C                   MOVE      PH(01)        P17A
     C                   MOVE      PH(02)        P17B
     C                   EXSR      SELC1
     C     *IN99         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     PAID          PAY01             9 2
     C                   Z-ADD     0             PAY02             9 2
     C                   Z-ADD     0             PAY03             9 2
     C                   GOTO      SELCOK
     C                   END
      *
     C** --- CREDIT CARD - LOAD CREDIT CARD INFO -------------------------------
     C** --- OPT2 --- ** SEARCH FIELD
     C     SELC          IFEQ      '2'
     C                   MOVEA     '1100'        *IN(01)
     C                   MOVE      'Y=Pay'       HD05
     C                   MOVE      PH(01)        P17A
     C                   MOVE      PH(02)        P17B
     C                   EXSR      SELC2
     C     *IN99         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
     C                   Z-ADD     PAID          PAY01
     C                   Z-ADD     0             PAY02
     C                   Z-ADD     0             PAY03
     C                   GOTO      SELCOK
     C                   END
      *
     C** --- ADJUSTMENTS - LOAD ADJUSTMENT TYPE & DESCRIPTION ------------------
     C** --- OPT3 --- ** SEARCH FIELD
     C     SELC          IFEQ      '3'
     C                   MOVEA     '0000'        *IN(01)
     C                   MOVE      'Y=Adj'       HD05
     C                   MOVE      PH(01)        P17A
     C                   MOVE      PH(02)        P17B
     C                   EXSR      SELC3
     C     *IN99         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
     C                   MOVE      'Y'           OP3OK            01
     C                   GOTO      SELCOK
     C                   END
      *
     C** --- SPREAD ACCT - NO SCREEN -------------------------------------------
     C** --- OPT4 --- ** SEARCH FIELD
     C     SELC          IFEQ      '4'
     C                   MOVEA     '1110'        *IN(01)
     C                   MOVE      'Y=Adj'       HD05
     C                   MOVE      PH(03)        P17A
     C                   MOVE      PH(04)        P17B
     C                   GOTO      SELCOK
     C                   END
      *
     C** --- INQUIRY -----------------------------------------------------------
     C** --- OPT5 --- ** SEARCH FIELD
     C     SELC          IFEQ      '5'
     C                   MOVEA     '0000'        *IN(01)
     C                   MOVE      *BLANKS       HD05
     C                   MOVE      PH(01)        P17A
     C                   MOVE      PH(02)        P17B
     C                   Z-ADD     0             PAY01             9 2
     C                   Z-ADD     0             PAY02             9 2
     C                   Z-ADD     0             PAY03             9 2
     C                   GOTO      SELCOK
     C                   END
     C** --- NOT PRINTING LINES ON STATEMENT -----------------------------------
     C** --- OPT6 --- ** SEARCH FIELD
     C     SELC          IFEQ      '6'
     C                   MOVEA     '0010'        *IN(01)
     C                   MOVE      'Y=Adj'       HD05
     C                   MOVE      PH(02)        P17B
     C                   GOTO      SELCOK
     C                   MOVE      'Y'           DTYORN
     C                   END
     C** --- NON A/R CASH RECEIPTS ---------------------------------------------
     C** --- OPT7 --- ** SEARCH FIELD
     C     SELC          IFEQ      '7'
     C                   EXSR      SELC7
     C     *IN99         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
     C                   GOTO      SELCOK
     C                   END
      *
     C** --- NO SELECTION - DECLINE OPTION -------------------------------------
     C                   SETON                                        13
     C                   GOTO      NXTA
      *
     C** --- COMMON TO ALL TYPES -----------------------------------------------
     C     SELCOK        TAG
      *
     C     VSCUST        IFGT      0
     C                   MOVE      '1'           *IN10
     C                   END
      *
     C                   Z-ADD     VACUST        VALAST
     C                   Z-ADD     VSCUST        VSLAST
      *
     C** --- CASH PAYMENT - DETAIL ENTRY ---------------------------------------
     C** --- RUN1 --- ** SEARCH FIELD
     C     SELC          IFEQ      '1'
      *                                            IN10 = DISPLAY SHIP TO
      *                                              11 = PAYMENT KEYABLE
      *                                              12 = DISPLAY 2 CMD'S
      *                                              13 = DISPLAY ER28 FIELD
     C                   MOVEL     CM(01)        CM6901
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(02)        CM6902
     C                   ELSE
     C                   MOVEL     CM(03)        CM6902
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   MOVEA     '10'          *IN(12)
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
      *
     C     SELC1T        TAG
     C                   EXSR      S10BLD
      *
     C     SELC1X        TAG
     C                   EXSR      CALCOP
MJT03C     PAGE#         IFLE      0
MJT03C     PAGE#         ORGT      999
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
     C                   EXFMT     S10CTL
     C                   MOVE      *BLANKS       ER28
     C                   MOVE      '0'           *IN13
      *
      *
     C     *INKD         IFEQ      '1'
     C     *INU4         ANDEQ     '1'
     C                   EXSR      OP010
     C                   GOTO      SELC1T
     C                   END
      *
     C     *INKE         IFEQ      '1'
     C                   EXSR      COLCOM
     C                   GOTO      SELC1X
     C                   END
      *
     C     *INKI         IFEQ      '1'
     C                   EXSR      S10NON
     C                   END
      * ** CHANGE DETAIL YES/NO - START **************************************
     C     *INKJ         IFEQ      '1'
     C*
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN02
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC1X
     C                   END
     C                   END
     C*
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(01)        CM6901
     C                   MOVEL     CM(03)        CM6902
     C                   MOVE      'N'           DTYORN
     C                   ELSE
     C                   MOVEL     CM(01)        CM6901
     C                   MOVEL     CM(02)        CM6902
     C                   MOVE      'Y'           DTYORN
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   GOTO      SELC1T
     C                   END
      * ** CHANGE DETAIL YES/NO - END ****************************************
      * ** CHANGE DUE DATE/INVOICE NUMBER - START ****************************
     C     *INKN         IFEQ      '1'
     C*
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN03
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC1X
     C                   END
     C                   END
     C*
     C     SL02          IFEQ      '1'
     C                   MOVE      'Due Date'    CM6902
     C                   MOVE      '2'           SL02
     C                   ELSE
     C                   MOVE      'Invoice '    CM6902
     C                   MOVE      '1'           SL02
     C                   END
     C                   GOTO      SELC1T
     C                   END
      * ** CHANGE DUE DATE/INVOICE NUMBER - END ******************************
      *
     C     *INKF         IFEQ      '1'
     C                   EXSR      CALCOP
     C*          PAY09     IFEQ 0
     C     PAY08         IFEQ      0
     C                   GOTO      RSTRTA
     C                   END
     C                   END
     C     *INKF         IFEQ      '1'
     C     PYON          IFEQ      'Y'
     C                   Z-ADD     0             PAY03
     C                   Z-ADD     PAY08         PAY09
     C                   Z-ADD     PAY08         AAMT
     C                   GOTO      NXTA
     C                   ELSE
     C                   GOTO      RSTRTA
     C                   END
     C                   END
      *
     C                   EXSR      S10CHK
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      S10POF
     C                   END
      *
     C     *INKH         IFEQ      '1'
     C                   EXSR      S10ALL
     C                   END
      *
     C                   EXSR      CALCOP
     C     PAY01         IFNE      PAY09
     C                   END
      *
     C     *INKL         IFEQ      '1'
     C     PAY09         ANDNE     0
     C                   MOVE      'Y'           INKLXX           01
     C                   Z-ADD     02            OLTTYP           02 0
     C                   Z-ADD     02            SLTTYP
     C                   EXSR      S10PUT
     C                   EXSR      CALCOP
     C                   EXSR      BALPUT
     C                   MOVEL     ER(09)        OP15
     C                   MOVE      '1'           *IN08
     C                   GOTO      SELC1T
     C                   END
      *
     C     *IN08         IFEQ      '0'
     C     INKLXX        ANDNE     'Y'
     C                   GOTO      SELC1X
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C     PAY03         ANDEQ     0
     C     INKLXX        ANDNE     'Y'
     C                   Z-ADD     13            CTW
     C                   EXSR      WARN01
     C                   GOTO      SELC1X
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C                   Z-ADD     02            SLTTYP           02 0
     C                   EXSR      S10PUT
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   EXSR      CALCOP
     C                   EXSR      CALDAT
     C     PAY09         IFEQ      0
     C     INKLXX        ANDEQ     'Y'
     C                   GOTO      NXTA
     C                   END
     C     PAY09         IFEQ      0
     C                   GOTO      RSTRTA
     C                   ELSE
     C                   GOTO      NXTA
     C                   END
     C                   END
      *
      *
     C                   GOTO      SELC1X
     C                   END
      *
     C** --- CC PAYMENT - DETAIL ENTRY -----------------------------------------
     C** --- RUN2 --- ** SEARCH FIELD
     C     SELC          IFEQ      '2'
      *                                            IN10 = DISPLAY SHIP TO
      *                                              11 = PAYMENT KEYABLE
      *                                              12 = DISPLAY 2 CMD'S
      *                                              13 = DISPLAY ER28 FIELD
     C                   MOVEL     CM(01)        CM6901
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(02)        CM6902
     C                   ELSE
     C                   MOVEL     CM(03)        CM6902
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   MOVEA     '10'          *IN(12)
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
      *
     C     SELC2T        TAG
     C                   EXSR      S10BLD
      *
     C     SELC2X        TAG
     C                   EXSR      CALCOP
MJT03C     PAGE#         IFLE      0
MJT03C     PAGE#         ORGT      999
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
     C                   EXFMT     S10CTL
     C                   MOVE      *BLANKS       ER28
     C                   MOVE      '0'           *IN13
      *
      *
     C     *INKD         IFEQ      '1'
     C     *INU4         ANDEQ     '1'
     C                   EXSR      OP010
     C                   GOTO      SELC2T
     C                   END
      *
     C     *INKE         IFEQ      '1'
     C                   EXSR      COLCOM
     C                   GOTO      SELC2X
     C                   END
      *
     C     *INKI         IFEQ      '1'
     C                   EXSR      S10NON
     C                   END
      *
      * ** CHANGE DETAIL YES/NO - START **************************************
     C     *INKJ         IFEQ      '1'
      *
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN02
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC2X
     C                   END
     C                   END
      *
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(01)        CM6901
     C                   MOVEL     CM(03)        CM6902
     C                   MOVE      'N'           DTYORN
     C                   ELSE
     C                   MOVEL     CM(01)        CM6901
     C                   MOVEL     CM(02)        CM6902
     C                   MOVE      'Y'           DTYORN
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   GOTO      SELC2T
     C                   END
      * ** CHANGE DETAIL YES/NO - END ****************************************
      * ** CHANGE DUE DATE/INVOICE NUMBER - START ****************************
     C     *INKN         IFEQ      '1'
      *
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN03
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC2X
     C                   END
     C                   END
      *
     C     SL02          IFEQ      '1'
     C                   MOVE      'Due Date'    CM6902
     C                   MOVE      '2'           SL02
     C                   ELSE
     C                   MOVE      'Invoice '    CM6902
     C                   MOVE      '1'           SL02
     C                   END
     C                   GOTO      SELC2T
     C                   END
      * ** CHANGE DUE DATE/INVOICE NUMBER - END ******************************
      *
     C     *INKF         IFEQ      '1'
     C                   EXSR      CALCOP
      *          PAY09     IFEQ 0
     C     PAY08         IFEQ      0
     C                   GOTO      RSTRTA
     C                   END
     C                   END
     C     *INKF         IFEQ      '1'
     C     PYON          IFEQ      'Y'
     C                   Z-ADD     0             PAY03
     C                   Z-ADD     PAY08         PAY09
     C                   Z-ADD     PAY08         AAMT
     C                   GOTO      NXTA
     C                   ELSE
     C                   GOTO      RSTRTA
     C                   END
     C                   END
      *
     C                   EXSR      S10CHK
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      S10POF
     C                   END
      *
     C     *INKH         IFEQ      '1'
     C                   EXSR      S10ALL
     C                   END
      *
     C                   EXSR      CALCOP
     C     PAY01         IFNE      PAY09
     C                   END
      *
     C     *INKL         IFEQ      '1'
     C     PAY09         ANDNE     0
     C                   MOVE      'Y'           INKLXX           01
     C                   Z-ADD     10            OLTTYP
     C                   Z-ADD     10            SLTTYP
     C                   EXSR      S10PUT
     C                   EXSR      CALCOP
     C                   EXSR      BALPUT
     C                   MOVEL     ER(09)        OP15
     C                   MOVE      '1'           *IN08
     C                   GOTO      SELC2T
     C                   END
      *
     C     *IN08         IFEQ      '0'
     C     INKLXX        ANDNE     'Y'
     C                   GOTO      SELC1X
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C     PAY03         ANDEQ     0
     C     INKLXX        ANDNE     'Y'
     C                   Z-ADD     13            CTW
     C                   EXSR      WARN01
     C                   GOTO      SELC2X
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C                   Z-ADD     10            SLTTYP
     C                   EXSR      S10PUT
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   EXSR      CALCOP
     C                   EXSR      CALDAT
     C     PAY09         IFEQ      0
     C     INKLXX        ANDEQ     'Y'
     C                   GOTO      NXTA
     C                   END
     C     PAY09         IFEQ      0
     C                   GOTO      RSTRTA
     C                   ELSE
     C                   GOTO      NXTA
     C                   END
     C                   END
      *
      *
     C                   GOTO      SELC2X
     C                   END
      *
      ** --- ADJUSTMENT - DETAIL ENTRY -----------------------------------------
      ** --- RUN3 --- ** SEARCH FIELD
     C     SELC          IFEQ      '3'
      *                                            IN10 = DISPLAY SHIP TO
      *                                              11 = PAYMENT KEYABLE
      *                                              12 = DISPLAY 2 CMD'S
      *                                              13 = DISPLAY ER28 FIELD
     C                   MOVEL     CM(06)        CM6901
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(09)        CM6902
     C                   ELSE
     C                   MOVEL     CM(10)        CM6902
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   MOVEA     '10'          *IN(12)
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
      *
     C     SELC3T        TAG
     C                   EXSR      S10BLD
      *
     C     SELC3X        TAG
     C                   EXSR      CALCOP
MJT03C     PAGE#         IFLE      0
MJT03C     PAGE#         ORGT      999
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
     C                   EXFMT     S10CTL
     C                   MOVE      *BLANKS       ER28
     C                   MOVE      '0'           *IN13
      *
      *
     C     *INKD         IFEQ      '1'
     C     *INU4         ANDEQ     '1'
     C                   EXSR      OP010
     C                   GOTO      SELC3T
     C                   END
      *
     C     *INKE         IFEQ      '1'
     C                   EXSR      COLCOM
     C                   GOTO      SELC3X
     C                   END
      *
      * ** CHANGE DETAIL YES/NO - START **************************************
     C     *INKJ         IFEQ      '1'
     C*
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN02
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC3X
     C                   END
     C                   END
      *
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(10)        CM6902
     C                   MOVE      'N'           DTYORN
     C                   ELSE
     C                   MOVEL     CM(09)        CM6902
     C                   MOVE      'Y'           DTYORN
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   GOTO      SELC3T
     C                   END
      * ** CHANGE DETAIL YES/NO - END ****************************************
      * ** CHANGE DUE DATE/INVOICE NUMBER - START ****************************
     C     *INKN         IFEQ      '1'
      *
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN03
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC3X
     C                   END
     C                   END
      *
     C     SL02          IFEQ      '1'
     C                   MOVE      'Due Date'    CM6902
     C                   MOVE      '2'           SL02
     C                   ELSE
     C                   MOVE      'Invoice '    CM6902
     C                   MOVE      '1'           SL02
     C                   END
     C                   GOTO      SELC3T
     C                   END
      * ** CHANGE DUE DATE/INVOICE NUMBER - END ******************************
      *
      *
     C                   EXSR      S10CHK
      *
     C     *INKF         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
      *
     C     *IN15         IFEQ      '1'
     C                   Z-ADD     13            CTW
     C                   EXSR      WARN01
     C                   GOTO      SELC3X
     C                   END
      *
     C     LINESP        IFGT      01
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   MOVEL     ER(02)        ER28
     C                   MOVE      '1'           *IN13
     C                   GOTO      SELC3X
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C     *IN08         ANDEQ     '0'
     C                   GOTO      SELC3X
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C     OP3OK         ANDEQ     'N'
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   MOVEL     ER(02)        ER28
     C                   MOVE      '1'           *IN13
     C                   GOTO      SELC3X
     C                   END
      *
     C     *INKA         IFEQ      '1'
     C                   Z-ADD     04            SLTTYP
     C                   EXSR      S30PUT
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   MOVE      'N'           OP3OK
     C                   EXSR      CALDAT
     C                   GOTO      RSTRTA
     C                   END
      *
     C                   GOTO      SELC3X
     C                   END
      *
      ** --- SPREAD PAYMENTS/CREDITS - DETAIL ENTRY ----------------------------
      ** --- RUN4 --- ** SEARCH FIELD
     C     SELC          IFEQ      '4'
      *                                            IN10 = DISPLAY SHIP TO
      *                                              11 = PAYMENT KEYABLE
      *                                              12 = DISPLAY 2 CMD'S
      *                                              13 = DISPLAY ER28 FIELD
      *  *** PASS NUMBER 01 ***
     C     SELC40        TAG
     C                   Z-ADD     0             TOT01            09 2
     C                   Z-ADD     0             TOT02            09 2
      *
     C                   MOVEL     CM(08)        CM6901
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(09)        CM6902
     C                   ELSE
     C                   MOVEL     CM(10)        CM6902
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   MOVEA     '11'          *IN(12)
     C                   MOVEA     '0'           *IN(15)
     C                   Z-ADD     0             PASS             02 0
     C                   MOVEL     ER(03)        ER28
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
      *
     C     SELC4T        TAG
     C                   EXSR      S10BLD
     C     LINE1         IFEQ      0
     C                   MOVE      ER(10)        ER28
     C                   MOVE      '1'           *IN13
     C                   END
     C     PASS          IFEQ      0
     C                   MOVE      '0'           *IN15
     C                   END
     C                   Z-ADD     01            PASS             02 0
      *
     C     SELC4X        TAG
     C                   Z-ADD     TOT01         TAMT
     C                   Z-ADD     TOT02         AAMT
     C                   Z-ADD     01            PASS             02 0
MJT03C     PAGE#         IFLE      0
MJT03C     PAGE#         ORGT      999
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
     C                   EXFMT     S10CTL
     C                   MOVEL     ER(03)        ER28
     C     LINE1         IFEQ      0
     C                   MOVE      ER(10)        ER28
     C                   END
     C                   MOVE      'N'           W25ER
      *
     C     *INKD         IFEQ      '1'
     C     *INU4         ANDEQ     '1'
     C                   EXSR      OP010
     C                   GOTO      SELC4T
     C                   END
      *
     C     *INKF         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
      *
     C     *INKE         IFEQ      '1'
     C                   EXSR      COLCOM
     C                   GOTO      SELC4X
     C                   END
      *
      * ** CHANGE DETAIL YES/NO - START **************************************
      *
     C     *INKJ         IFEQ      '1'
      *
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN02
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC4X
     C                   END
     C                   END
      *
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(08)        CM6901
     C                   MOVEL     CM(10)        CM6902
     C                   MOVE      'N'           DTYORN
     C                   ELSE
     C                   MOVEL     CM(08)        CM6901
     C                   MOVEL     CM(09)        CM6902
     C                   MOVE      'Y'           DTYORN
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   GOTO      SELC4T
     C                   END
      * ** CHANGE DETAIL YES/NO - END ****************************************
      * ** CHANGE DUE DATE/INVOICE NUMBER - START ****************************
     C     *INKN         IFEQ      '1'
      *
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN03
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC4X
     C                   END
     C                   END
      *
     C     SL02          IFEQ      '1'
     C                   MOVE      'Due Date'    CM6902
     C                   MOVE      '2'           SL02
     C                   ELSE
     C                   MOVE      'Invoice '    CM6902
     C                   MOVE      '1'           SL02
     C                   END
     C                   GOTO      SELC4T
     C                   END
      * ** CHANGE DUE DATE/INVOICE NUMBER - END ******************************
      *
     C                   EXSR      S10CHK
     C     S10CT         IFGT      01
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   MOVE      ER(05)        ER28
     C                   GOTO      SELC4X
     C                   END
     C     W25ER         IFEQ      'Y'
     C                   GOTO      SELC4X
     C                   END
      *
      *
     C     *INKA         IFEQ      '1'
     C     TOT01         ANDNE     0
     C                   MOVEL     ER(04)        ER28
     C                   Z-ADD     02            PASS
     C                   GOTO      SELC9T
     C                   END
      *
     C                   GOTO      SELC4X
      *
      *
      *  *** PASS NUMBER 02 ***    ALL "4" IN GOTO & TAGS CHANGED TO "9"
      *
     C     SELC9T        TAG
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   EXSR      S40BLD
      *
     C     SELC9X        TAG
     C                   Z-ADD     TOT01         TAMT
     C                   Z-ADD     TOT02         AAMT
MJT03C     PAGE#         IFLE      0
MJT03C     PAGE#         ORGT      999
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
     C                   EXFMT     S10CTL
     C                   MOVEL     ER(04)        ER28
      *
     C     *INKD         IFEQ      '1'
     C     *INU4         ANDEQ     '1'
     C                   EXSR      OP010
     C                   GOTO      SELC9T
     C                   END
      *
     C     *INKE         IFEQ      '1'
     C                   EXSR      COLCOM
     C                   GOTO      SELC9X
     C                   END
      *
      *
      * ** CHANGE DETAIL YES/NO - START **************************************
     C     *INKJ         IFEQ      '1'
     C*
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN02
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC9X
     C                   END
     C                   END
     C*
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     CM(08)        CM6901
     C                   MOVEL     CM(09)        CM6902
     C                   MOVE      'N'           DTYORN
     C                   ELSE
     C                   MOVEL     CM(08)        CM6901
     C                   MOVEL     CM(10)        CM6902
     C                   MOVE      'Y'           DTYORN
     C                   END
     C     SL02          IFEQ      '1'
     C                   MOVE      'Invoice '    CM6902
     C                   ELSE
     C                   MOVE      'Due Date'    CM6902
     C                   END
     C                   GOTO      SELC40
     C                   END
      * ** CHANGE DETAIL YES/NO - END ****************************************
      * ** CHANGE DUE DATE/INVOICE NUMBER - START ****************************
     C     *INKN         IFEQ      '1'
     C*
     C                   EXSR      S10CNT
     C     LINEC         IFGT      0
     C                   EXSR      WARN03
     C     *INKB         IFEQ      '1'
     C                   GOTO      SELC9X
     C                   END
     C                   END
     C*
     C     SL02          IFEQ      '1'
     C                   MOVE      'Due Date'    CM6902
     C                   MOVE      '2'           SL02
     C                   ELSE
     C                   MOVE      'Invoice '    CM6902
     C                   MOVE      '1'           SL02
     C                   END
     C                   GOTO      SELC40
     C                   END
      * ** CHANGE DUE DATE/INVOICE NUMBER - END ******************************
      *
     C     *INKF         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
      *
     C                   EXSR      S10CHK
      *
      *
     C     *INKA         IFEQ      '1'
      *
     C                   MOVE      'N'           UPDT             01
     C                   Z-ADD     04            SLTTYP
     C                   EXSR      S40PUT
     C     TOT01         ADD       TOT02         BALANC           08 2
     C     BALANC        IFNE      0
     C                   MOVEL     ER(01)        ER28
     C                   MOVE      '1'           *IN13
     C                   GOTO      SELC9X
     C                   END
      *
     C                   MOVE      'Y'           UPDT
     C                   Z-ADD     04            SLTTYP
     C                   EXSR      S40PUT
     C                   EXSR      CALDAT
     C                   GOTO      RSTRTA
     C                   END
      *
      *
     C                   GOTO      SELC9X
     C                   END
      *
     C** --- INQUIRY -----------------------------------------------------------
     C** --- RUN5 --- ** SEARCH FIELD
     C     SELC          IFEQ      '5'
     C                   Z-ADD     LCO           PRMLCO           02 0
     C                   Z-ADD     VACUST        PRMCST           06 0
     C                   CALL      'ARR22CCL'
     C                   PARM                    PRMLCO
     C                   PARM                    PRMCST
     C                   GOTO      RSTRTA
     C                   END
      *
     C** --- NOT PRINTING LINES ON STATEMENT - DETAIL ENTRY --------------------
     C** --- RUN6 --- ** SEARCH FIELD
     C     SELC          IFEQ      '6'
      *                                            IN10 = DISPLAY SHIP TO
      *                                              11 = PAYMENT KEYABLE
      *                                              12 = DISPLAY 2 CMD'S
      *                                              13 = DISPLAY ER28 FIELD
     C                   Z-ADD     0             TAMT
     C                   Z-ADD     0             AAMT
      *
     C                   MOVEL     CM(16)        CM6901
     C                   MOVEA     '00'          *IN(12)
     C                   Z-ADD     01            PASS             02 0
     C                   MOVEL     ER(06)        ER28
     C                   MOVE      '1'           *IN13
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
      *
     C     SELC6T        TAG
     C                   EXSR      S60BLD
      *
     C     SELC6X        TAG
     C*                    MULT -1.00     AAMT
     C     AAMT          IFNE      0
     C                   MOVE      '1'           *IN02
     C                   ELSE
     C                   MOVE      '0'           *IN02
     C                   END
      *
MJT03C     PAGE#         IFLE      0
MJT03C     PAGE#         ORGT      999
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
     C                   EXFMT     S60CTL
     C                   MOVEL     ER(06)        ER28
      *
     C     *INKD         IFEQ      '1'
     C     *INU4         ANDEQ     '1'
     C                   EXSR      OP060
     C                   GOTO      SELC6T
     C                   END
      *
     C     *INKE         IFEQ      '1'
     C                   EXSR      COLCOM
     C                   GOTO      SELC6X
     C                   END
      *
     C     *INKB         IFEQ      '1'
     C     DTYORN        IFEQ      'Y'
     C                   MOVE      'N'           DTYORN
     C                   ELSE
     C                   MOVE      'Y'           DTYORN
     C                   ENDIF
     C                   GOTO      SELC6T
     C                   END
      *
     C     *INKF         IFEQ      '1'
     C                   GOTO      RSTRTA
     C                   END
      *
      *
     C                   EXSR      S60CHK
      *
      *
     C     W25ER         IFEQ      'Y'
     C                   MOVE      '0'           *IN08
     C                   GOTO      SELC6X
     C                   END
      *
      *
     C                   MOVE      'N'           UPDT             01
     C                   Z-ADD     04            SLTTYP
     C                   EXSR      S60PUT
     C                   MULT      -1.00         AAMT
     C     AAMT          IFNE      0
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   MOVEL     ER(01)        ER28
     C                   MOVE      '1'           *IN13
     C                   GOTO      SELC6X
     C                   END
     C     *IN15         IFEQ      '1'
     C                   MOVEL     ER(01)        ER28
     C                   MOVE      '1'           *IN13
     C                   GOTO      SELC6X
     C                   END
      *
     C     LINE1         IFEQ      0
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   GOTO      SELC6X
     C                   END
      *
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
      *
     C     *INKA         IFEQ      '1'
     C                   MOVE      'Y'           UPDT
     C                   Z-ADD     04            SLTTYP
     C                   EXSR      S60PUT
     C                   GOTO      RSTRTA
     C                   END
      *
      *
     C                   GOTO      SELC6X
     C                   END
     C** --- NON A/R CASH RECEIPTS ---------------------------------------------
     C** --- RUN7 --- ** SEARCH FIELD
     C     SELC          IFEQ      '7'
      *                                              NO SCREANS INVOLVED
     C                   Z-ADD     06            SLTTYP
     C                   EXSR      S70PUT
      *
     C                   GOTO      RSTRTA
      *
     C                   END
      *
     C** -----------------------------------------------------------------------
      *
     C     EOJ           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      TMWRK         EDAT
     C                   MOVE      'N'           DTYORN           01
     C                   ENDSR
      **
      **
     CSR   GETDAT        BEGSR
     C                   MOVEA     '0000'        *IN(10)
     C                   MOVE      '0'           *IN98
     C                   MOVE      *BLANKS       RETC
     C     GETDT1        TAG
     C                   WRITE     SCRNDT
     C                   READ      SCRNDT                                 50
     C                   MOVEA     '0000'        *IN(10)
      **
     C     *IN98         IFEQ      '1'
     C     TDAT          ANDNE     TDATHD
     C                   MOVE      '0'           *IN98
     C                   END
      **
     C     *INKC         IFEQ      '1'
     C     *INKG         OREQ      '1'
     C                   MOVE      '3'           RETC
     C                   GOTO      GETDT9
     C                   END
      **
     C                   Z-ADD     EDAT          TDATE            06 0
     C                   CALL      '@DT@A1'
     C                   PARM                    TDATE
     C                   PARM                    TDAT             07 0
     C                   PARM      'N'           RETC             01
     C     RETC          IFEQ      'Y'
     C                   SETON                                        1011
     C                   GOTO      GETDT1
     C                   END
     C     TDAT          IFLT      TDATPY
     C                   SETON                                        1012
     C                   GOTO      GETDT1
     C                   END
     C     *IN98         IFEQ      '1'
     C                   GOTO      GETDT9
     C                   END
     C     TDAT          IFGT      TDATEY
     C                   Z-ADD     TDAT          TDATHD           07 0
     C                   SETON                                        1013
     C                   SETON                                        98
     C                   GOTO      GETDT1
     C                   END
     C     GETDT9        TAG
     C                   MOVEA     '0000'        *IN(10)
     C                   MOVE      '0'           *IN98
     CSR                 ENDSR
      **
      **
     CSR   SELC1         BEGSR
     C                   MOVE      *BLANKS       CHEK
     C                   Z-ADD     0             PAID
     C                   MOVE      '0'           *IN99
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '0'           *IN(18)
     C     SELC1A        TAG
     C                   MOVE      'N'           SELCK1
     C     '0'           IFEQ      *IN(13)
     C     '0'           ANDEQ     *IN(14)
     C     '0'           ANDEQ     *IN(15)
     C     '0'           ANDEQ     *IN(16)
     C     '0'           ANDEQ     *IN(18)
     C                   MOVE      '1'           *IN12
     C                   END
      *
     C     *INU8         IFEQ      '1'
     C                   MOVE      '1'           *IN17
     C                   END
     C                   WRITE     SEL010
     C                   READ      SEL010                                 50
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '0'           *IN(18)
     C                   MOVE      '0'           *IN99
      *
     C     *INKF         IFEQ      '1'
     C                   MOVE      '1'           *IN99
     C                   GOTO      SELC1E
     C                   END
      *
     C                   MOVEL     BANK          TEST01           01
     C     TEST01        IFEQ      '?'
     C     TEST01        OREQ      '/'
     C                   CALL      'LKBANK'
     C                   PARM                    BANKXX            3
     C                   PARM                    BANKDS           30
     C                   MOVE      BANKXX        BANK
     C                   MOVE      'Y'           SELCK1           01
     C                   GOTO      SELC1A
     C                   END
      *
     C     BANK          CHAIN     FMBANK                             50
     C     *IN50         IFEQ      '1'
     C                   SETON                                        1611
     C                   GOTO      SELC1A
     C                   ELSE
     C                   MOVE      BADESC        BANKDS
     C                   Z-ADD     BAGLNO        BANKGL           08 0
     C     SELCK1        IFEQ      'Y'
     C                   MOVE      '1'           *IN12
     C                   GOTO      SELC1A
     C                   END
     C                   END
      *
     C     *INU8         IFEQ      '0'
     C     CHEK          IFEQ      *BLANKS
     C                   SETON                                        1218
     C                   GOTO      SELC1A
     C                   END
      *
     C                   CALL      '@DT@A1'
     C                   PARM                    CKDT
     C                   PARM                    CKDT07            7 0
     C                   PARM      'N'           RETC              1
     C     RETC          IFEQ      'Y'
     C                   MOVE      '1'           *IN14
     C                   GOTO      SELC1A
     C                   END
     C                   Z-ADD     CKDT07        CKDTXX           07 0
     C                   END
      *
     C     PAID          IFLE      0
     C                   SETON                                        15
     C                   GOTO      SELC1A
     C                   END
      *
     CSR   SELC1E        ENDSR
      **
      **
     CSR   SELC7         BEGSR
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      '0'           *IN99
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '1'           *IN(19)
     C                   MOVEA     '0'           *IN(98)
     C                   Z-ADD     0             GLAC
      *
     C     SELC7A        TAG
      *
     C     *INU8         IFEQ      '1'
     C                   MOVE      '1'           *IN17
     C                   END
     C                   WRITE     SEL070
     C                   READ      SEL070                                 50
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '0'           *IN(19)
     C                   MOVE      '0'           *IN99
      *
     C     *INKF         IFEQ      '1'
     C                   MOVE      '1'           *IN99
     C                   GOTO      SELC7E
     C                   END
      *
     C                   MOVEL     BANK          TEST01           01
     C     TEST01        IFEQ      '?'
     C     TEST01        OREQ      '/'
     C                   CALL      'LKBANK'
     C                   PARM                    BANKXX            3
     C                   PARM                    BANKDS           30
     C                   MOVE      BANKXX        BANK
     C                   MOVE      'Y'           SELCK1           01
     C                   MOVE      '0'           *IN98
     C                   GOTO      SELC7A
     C                   END
      *
     C     BANK          CHAIN     FMBANK                             50
     C     *IN50         IFEQ      '1'
     C                   SETON                                        1611
     C                   MOVE      '0'           *IN98
     C                   GOTO      SELC7A
     C                   ELSE
     C                   MOVE      BADESC        BANKDS
     C                   Z-ADD     BAGLNO        BANKGL
     C     SELCK1        IFEQ      'Y'
     C                   MOVE      '1'           *IN12
     C                   MOVE      '0'           *IN98
     C                   GOTO      SELC7A
     C                   END
     C                   END
      *
     C     *INKB         IFEQ      '1'
     C                   Z-ADD     0             GLACXX
     C                   Z-ADD     LCO           PRMLCO
     C                   MOVE      *BLANKS       LOOK15
     C                   CALL      'LKGLCH'
     C                   PARM                    LOOK15           15
     C                   PARM                    PRMLCO
     C                   PARM                    GLACXX           08 0
     C                   PARM                    GLCHDS           30
     C                   MOVE      GLACXX        GLAC
     C                   MOVE      GLCHDS        GLDESC
     C                   MOVEA     '00010000'    *IN(10)
     C                   MOVEA     '00'          *IN(18)
     C                   MOVE      '0'           *IN98
     C                   GOTO      SELC7A
     C                   END
     C     K1GLCH        CHAIN     FMGLCH                             50
     C     *IN50         IFEQ      '1'
     C                   SETON                                        1819
     C                   MOVE      '0'           *IN98
     C                   GOTO      SELC7A
     C                   ELSE
     C                   MOVE      GCDESC        GLDESC
     C                   END
      *
     C     *INU8         IFEQ      '0'
     C     CHEK          ANDEQ     *BLANKS
     C                   SETON                                        12
     C                   MOVE      '0'           *IN98
     C                   GOTO      SELC7A
     C                   END
      *
     C     PAID          IFLE      0
     C                   SETON                                        15
     C                   MOVE      '0'           *IN98
     C                   GOTO      SELC7A
     C                   END
      *
     C     DESC          IFEQ      *BLANKS
     C                   MOVEL     GLDESC        DESC
     C                   END
      *
      *
     C     *IN98         IFEQ      '0'
     C                   MOVE      '1'           *IN98
     C                   GOTO      SELC7A
     C                   END
      *
      *
     CSR   SELC7E        ENDSR
      **
SUD01C**************************************************************************
     CSR   SELC2         BEGSR
     C                   MOVE      *BLANKS       CRCD
     C                   MOVE      *BLANKS       CRC#
     C                   MOVE      *BLANKS       CRCE
     C                   MOVE      *BLANKS       CRCA
     C                   Z-ADD     0             PAID
     C*                    MOVE 'N'       CCHIST 01
     C     SELC2B        TAG
     C                   MOVE      '0'           *IN99
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '0'           *IN(18)
     C     SELC2A        TAG
     C     '0'           IFEQ      *IN10
     C     '0'           ANDEQ     *IN11
     C     '0'           ANDEQ     *IN13
     C     '0'           ANDEQ     *IN14
     C     '0'           ANDEQ     *IN15
     C     '0'           ANDEQ     *IN16
     C     '0'           ANDEQ     *IN17
     C     '0'           ANDEQ     *IN18
     C                   MOVE      '1'           *IN12
     C                   END
SUD01C*?   // Seton non display indicator for Credit Card Screen Fields
SUD01C                   SETON                                        50
     C                   EXFMT     SEL020
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '0'           *IN(18)
     C                   MOVE      '0'           *IN99
      *
     C     *INKF         IFEQ      '1'
     C                   MOVE      '1'           *IN99
     C                   GOTO      SELC2E
     C                   END
      *
SUD01 *
  |   /Free
  |   *
  |   *?   // If Amount Field is not Zero Process payment On pressing Enter
  |        If PAID <> 0;
  |           *InKH  = *On;
  |        Endif;
  |
SUD01 *?  // Credit Card Selection Screen
SUD02     If *InKH Or *InKG;
SUD01
  |   *?     // Move and Intialise Values Into Data Structure
  |          ParmDs.PCust#   = VACUST;
  |          ParmDs.POrder#  = *Zeros;
  |          ParmDs.PInvoice = *Zeros;
  |          ParmDs.PPgm     = 'ARR210';
  |          ParmDs.PSts     = *Blanks;
  |          ParmDs.PCCard   = *Zeros;
  |          ParmDs.PCType   = *Blanks;
  |          ParmDs.PCExp    = *Zeros;
  |          ParmDs.PToken   = *Zeros;
  |          ParmDs.PCApr    = *Blanks;
SUD01        ParmDs.PAmount  = Paid;
SUD02        If *InKG;
  |             ParmDs.PManual  = 'Y';              // Manual Process
  |             WSPCI002(ParmDs);
  |          Else;
  |             ParmDs.PManual  = 'N';              // Payment Process
  |             WSPCI001(ParmDs);
SUD02        Endif;
SUD01
  |          If ParmDs.PSts = 'Cancel';
  |             *InKF = *On;
  |   /End-Free
  |  C                   Goto      SELC2A
  |   /Free
  |          Else;
  |
  |             If ParmDs.PAmount <> *Zeros And ParmDs.PSts <> 'Cancel'
SUD01                       and ParmDs.PSts = 'Approval';
SUD02              If ParmDs.PManual = 'N';
SUD02                 CRCE = ParmDs.PCExp;
SUD03                 If ParmDs.PToken <> *Zeros;
  |                      CRC# = ParmDs.PToken;
  |                   Else;
  |                      CRC# = ParmDs.PCCard;
SUD03                 Endif;
SUD02              Else;
  |                   CRC# = ParmDs.PCCard;
  |                Endif;
  |                Paid = ParmDs.PAmount;
  |                CRCD = ParmDs.PCType;
  |                CRCA = ParmDs.PCApr;
SUD02           Endif;
SUD01        Endif;
  |
  |       Endif;
SUD01 /End-Free
     C*                    MOVELBANK      TEST01 01
     C*          TEST01    IFEQ '?'                        SEARCH BANK
     C*          TEST01    OREQ '/'
     C*                    CALL 'LKBANK'
     C*                    PARM           BANKXX  3
     C*                    PARM           BANKDS 30
     C*                    MOVE BANKXX    BANK
     C*                    GOTO SELC2A
     C*                    ELSE
     C*          BANK      CHAINFMBANK               50    NO SEARCH
     C*          *IN50     IFEQ '1'
     C*                    SETON                     16
     C*                    GOTO SELC2A
     C*                    ELSE
     C*                    MOVE BADESC    BANKDS
     C*                    Z-ADDBAGLNO    BANKGL
     C*                    END
     C*                    END
      *
      * 8/8/99 ADDED BY GD
      *
SUD01C*    1             SUBST     CRCD:1        VTST              1
  |  C*    VTST          IFEQ      '?'
  |  C*    VTST          OREQ      '/'
  |  C*                  MOVEL     CRCD          CCCODE
  |  C*                  CALL      'LKCRED'
  |  C*                  PARM                    CCCODE
  |  C*                  PARM                    CCDESC
  |  C*                  MOVEL     *BLANKS       CRCD
  |  C*                  MOVEL     CCCODE        CRCD
  |  C*                  ENDIF
  |   *
  |  C*    CRCD          CHAIN     FMCRED                             13
  |  C*  13              SETON                                        12
  |  C*  13              GOTO      SELC2A
SUD01C*    CCBANK        CHAIN     FMBANK                             50
     C*          *IN50     IFEQ '1'
     C*                    SETON                     16
     C*                    GOTO SELC2A
     C*                    ELSE
SUD01C*                  MOVE      BADESC        BANKDS
SUD01C*                  Z-ADD     BAGLNO        BANKGL
     C*                    END
      * ----------
SUD01C*    CRC#          IFEQ      0
SUD01C*    CRCE          ANDEQ     0
     C*          VACUST    CHAINFARHST               50    GET FROM HISTORY
SUD01C*    *IN50         IFEQ      '0'
  |  C*    CRCD          IFEQ      HSCRCD
  |  C*                  Z-ADD     HSCRC#        CRC#
  |  C*                  Z-ADD     HSCRDT        CRCE
  |  C*                  MOVE      'Y'           CCHIST
  |  C*                  MOVE      '0'           *IN99
  |  C*                  MOVEA     '00000000'    *IN(10)
  |  C*                  MOVEA     '1'           *IN(18)
  |  C*                  GOTO      SELC2A
  |  C*                  END
  |  C*                  END
  |  C*                  END
  |   * ----------
  |  C*    CRC#          IFEQ      0
  |  C*                  SETON                                        14
  |  C*                  GOTO      SELC2A
  |  C*                  END
  |   *
  |  C*                  Z-ADD     000100        CRCEXX           06 0
  |  C*                  MOVEL     CRCE          CRCEX1           02
  |  C*                  MOVE      CRCE          CRCEX2           02
  |  C*                  MOVEL     CRCEX1        CRCEXX
  |  C*                  MOVE      CRCEX2        CRCEXX
  |  C*                  CALL      '@DT@A1'
  |  C*                  PARM                    CRCEXX
  |  C*                  PARM                    CKDT07           07 0
  |  C*                  PARM      'N'           RETC             01
  |  C*    RETC          IFEQ      'Y'
  |  C*                  MOVE      '1'           *IN15
  |  C*                  GOTO      SELC2A
  |  C*                  END
  |   *
  |  C*    CRCEX2        IFGT      '50'
  |  C*    CRCEX2        ANDLE     '99'
  |  C*                  MOVE      '00'          CRCEX0
  |  C*                  ELSE
  |  C*                  MOVE      '01'          CRCEX0
  |  C*                  END
  |  C*    UYEAR         IFGT      50
  |  C*    UYEAR         ANDLE     99
  |  C*                  MOVE      '00'          UDATX0
  |  C*                  ELSE
  |  C*                  MOVE      '01'          UDATX0
  |  C*                  END
  |  C*                  MOVE      UYEAR         UDATX2
  |  C*                  MOVE      UMONTH        UDATX1
  |  C*    CCEXDS        IFLT      UDATDS
  |  C*                  MOVE      '1'           *IN15
  |  C*                  GOTO      SELC2A
SUD01C*                  END
     C     PAID          IFLE      0
     C                   SETON                                        1118
     C                   GOTO      SELC2A
     C                   END
      *
SUD01C*    CRCA          IFEQ      *BLANKS
  |  C*                  SETON                                        17
  |  C*                  GOTO      SELC2A
SUD01C*                  END
      * ----------
     C*          CCHIST    IFEQ 'Y'
     C*          CRCE      ANDNEHSCRDT
     C*                    Z-ADDCRCE      HSCRDT           IF EXP NE HST
     C*                    UPDATRARHST
     C*                    END
      * ----------
      *
     CSR   SELC2E        ENDSR
SUD01C**************************************************************************
      **
     CSR   SELC3         BEGSR
     C                   MOVEA     '001000'      *IN(10)
     C                   MOVE      '0'           *IN99
     C                   MOVE      *BLANKS       REAS
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       CRDESC
     C                   MOVE      'N'           CSAJ
     C     SELC3A        TAG
     C                   WRITE     SEL030
     C                   READ      SEL030                                 50
     C                   MOVEA     '000000'      *IN(10)
     C                   MOVE      '0'           *IN99
      *
     C     *INKF         IFEQ      '1'
     C                   MOVE      '1'           *IN99
     C                   GOTO      SELC3E
     C                   END
      *
     C                   MOVEL     REAS          TEST01
     C     TEST01        IFEQ      '?'
     C     TEST01        OREQ      '/'
     C                   CALL      'LKREAS'
     C                   PARM                    LCOXX
     C                   PARM                    REAS              3
     C                   PARM                    CRDESC
     C                   GOTO      SELC3A
     C                   ELSE
     C     REAKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    REAS
     C     REAKEY        CHAIN     FCMREAS                            50
     C*          REAS      CHAINFCMREAS              50    NO SEARCH
     C     *IN50         IFEQ      '1'
     C                   SETON                                        1011
     C                   GOTO      SELC3A
     C                   END
     C                   END
      *
     C     CRGLNO        IFEQ      0
     C                   Z-ADD     16            CTW
     C                   EXSR      WARN01
     C                   GOTO      SELC3A
     C                   END
      *
     C     CSAJ          IFNE      'Y'
     C     CSAJ          ANDNE     'N'
     C                   SETON                                        13
     C                   GOTO      SELC3A
     C                   END
      *
     C     DESC          IFEQ      *BLANKS
     C                   MOVEL     CRDESC        DESC
     C                   END
      *
      *
     CSR   SELC3E        ENDSR
      *
      *
     CSR   S10BLD        BEGSR
      *                                                    *IN09 - RI SUFF
     C                   MOVE      '1'           *IN80
     C                   WRITE     S10CTL
     C                   MOVE      '0'           *IN80
      *
     C                   Z-ADD     0             LINE1            03 0
EFD04C                   Z-ADD     0             RR1              05 0
     C     SL02          IFEQ      '1'
     C     BTST          IFEQ      'N'
     C     CUST          SETLL     FAROPNDD
     C                   ELSE
     C     KKBTST        SETLL     FAROPNSA
     C                   END
     C                   END
     C     SL02          IFEQ      '2'
     C     CUST          SETLL     FAROPN
     C                   END
      *
     C     *IN50         DOUEQ     '1'
     C     SL02          IFEQ      '1'
     C     BTST          IFEQ      'N'
     C     CUST          READE     FAROPNDD                               50
     C                   ELSE
     C     KKBTST        READE     FAROPNSA                               50
     C                   END
     C                   END
     C     SL02          IFEQ      '2'
     C     CUST          READE     FAROPN                                 50
     C                   END
     C     *IN50         IFEQ      '1'
EFD04C                   Z-ADD     RR1           LLIN             05 0
     C                   LEAVE
     C                   END
      *
     C     SELC          IFEQ      '6'
     C     ARPRST        ANDEQ     'N'
     C                   ITER
     C                   END
      *
     C                   Z-ADD     ARTTYP        CT
     C                   Z-ADD     ARTTYP        TTYP
     C     CT            IFGE      01
     C     CT            ANDLE     15
     C                   MOVEL     TP(CT)        TYPE
     C                   ELSE
     C                   MOVE      *BLANKS       TYPE
     C                   END
      * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      * DISPLAY / NOT DISPLAY OPTIONS
      *
     C                   Z-ADD     ARDUE$        DUE$
     C                   Z-ADD     ARSEQ#        SEQ#
     C                   EXSR      SET11
      *
     C     DTYORN        IFEQ      'N'
      *
   X C     *IN11         IFEQ      '0'
   X C     ARINV#        CHAIN     FAR210                             51
   XXC     SELC          IFEQ      '4'
   XXC     ARDUE$        ANDNE     0
   XXC                   MOVE      '0'           *IN51
   XXC                   END
   XXC     SELC          IFEQ      '5'
   XXC     ARDUE$        ANDNE     0
   XXC                   MOVE      '0'           *IN51
   XXC                   END
   XXC     *IN51         IFEQ      '1'
   XXC                   ITER
   XXC                   END
   X C                   END
     C                   END
      *
     C                   ADD       1             RR1
     C                   MOVE      *BLANKS       CODE
     C     SL01          IFEQ      '1'
     C                   Z-ADD     ARDUDT        DUDT07
     C                   CALL      '@DTCNV'
     C                   PARM                    DUDT07            7 0
     C                   PARM                    DUDT              6 0
     C                   PARM      'N'           ##ERR             1
     C                   Z-ADD     DUDT          DATE
     C                   MOVE      '  Due   '    HD08
     C                   END
     C     SL01          IFEQ      '2'
     C                   Z-ADD     ARTDAT        DUDT07
     C                   CALL      '@DTCNV'
     C                   PARM                    DUDT07            7 0
     C                   PARM                    DUDT              6 0
     C                   PARM      'N'           ##ERR             1
     C                   Z-ADD     DUDT          DATE
     C                   MOVE      ' Entry  '    HD08
     C                   END
     C                   Z-ADD     DUDT07        DDAT
     C                   Z-ADD     0             PAY$
     C                   Z-ADD     0             PDIS
     C                   Z-ADD     ARINV#        INV#
     C                   Z-ADD     ARSEQ#        SEQ#
     C                   MOVE      ARSUFF        SUFF
     C                   MOVE      AR$AMT        DAMT
     C                   MOVE      ARTAXJ        TAXJ
     C                   MOVE      ARSHFR        SHFR
     C     ARTTYP        IFEQ      01
     C     ARDISC        SUB       ARDTAK        DISC
     C                   ELSE
     C                   MOVE      ARDTAK        DISC
     C                   END
MJT01C     SEQ#          IFEQ      0
     C                   MOVE      ARDUE$        DUE$
     C                   MOVE      ARDUE$        DUEX
MJT01C                   ELSE
MJT01C                   Z-ADD     0             DUE$
MJT01C                   Z-ADD     0             DUEX
MJT01C                   END
     C** . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
     C** U1 IS USED TO TEST THE BALANCE OF AN INVOICE
     C                   MOVE      '0'           *IN09
     C     *INU1         IFEQ      '1'
     C     ARSEQ#        ANDEQ     0
     C                   CALL      'ARR212'
     C                   PARM                    CUST
     C                   PARM                    ARINV#
     C                   PARM                    ARSUFF
     C                   PARM      ' '           RETC
     C     RETC          IFNE      *BLANKS
     C                   MOVE      *BLANKS       SUFF
     C                   MOVEL     RETC          SUFF
     C                   MOVE      '1'           *IN09
     C                   END
     C                   END
     C** . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
     C**
      *
     C     SELC          IFEQ      '4'
     C     DUE$          ANDEQ     0
     C                   MOVE      '0'           *IN11
     C                   END
     C     SELC          IFEQ      '5'
     C                   MOVE      '0'           *IN11
     C                   END
      *
     C     *IN11         IFEQ      '1'
     C                   ADD       1             LINE1
     C                   END
      *
     C                   WRITE     S10SFL
     C                   ENDDO
      ** ***********
     C     RR1           IFEQ      0
     C                   MOVEL     ER(08)        ER28
     C                   MOVE      '1'           *IN13
     C                   ADD       1             RR1
     C                   MOVE      *BLANKS       CODE
     C                   Z-ADD     0             PAY$
     C                   Z-ADD     0             PDIS
     C                   Z-ADD     0             INV#
     C                   MOVE      *BLANKS       SUFF
     C                   MOVE      *BLANKS       TYPE
     C                   MOVE      *BLANKS       DATE
     C                   Z-ADD     0             DAMT
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DUE$
     C                   Z-ADD     0             DUEX
     C                   MOVE      *BLANKS       TAXJ
     C                   MOVE      *BLANKS       SHFR
     C                   WRITE     S10SFL
     C                   END
      ** ***********
     CSR                 ENDSR
      *
      *
     CSR   S40BLD        BEGSR
      *                                                    *IN09 - RI SUFF
      *
     C                   Z-ADD     0             TOT01
     C                   Z-ADD     0             TOT02
     C                   Z-ADD     0             RR1
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       01            RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   Z-ADD     RR1           LLIN
     C                   LEAVE
     C                   END
      *
     C     TTYP          IFEQ      03
     C     TTYP          OREQ      05
     C     TTYP          OREQ      11
WJB  C     TTYP          OREQ      10
     C                   ADD       PAY$          TOT01
     C                   SUB       PDIS          TOT01
     C                   ELSE
     C                   ADD       PAY$          TOT02
     C                   SUB       PDIS          TOT02
     C                   END
      *
     C                   EXSR      SET11
      *
     C     *INU2         IFEQ      '1'
     C     SEQ#          ANDEQ     00
     C     DUE$          IFEQ      0
     C                   MOVE      'Y'           REJLIN           01
     C                   ELSE
     C                   MOVE      'N'           REJLIN
     C                   END
     C                   END
      *
      *
     C** . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
     C**
     C                   UPDATE    S10SFL
     C                   ENDDO
     C**
     CSR                 ENDSR
      *
      *
     CSR   S60BLD        BEGSR
      *                                                    *IN09 - RI SUFF
     C                   MOVE      '1'           *IN80
     C                   WRITE     S60CTL
     C                   MOVE      '0'           *IN80
      *
EFD04C                   Z-ADD     0             RR5              05 0
     C     SL02          IFEQ      '1'
     C     BTST          IFEQ      'N'
     C     CUST          SETLL     FAROPNDD
     C                   ELSE
     C     KKBTST        SETLL     FAROPNSA
     C                   END
     C                   END
     C     SL02          IFEQ      '2'
     C     CUST          SETLL     FAROPN
     C                   END
      *
     C     *IN50         DOUEQ     '1'
     C     SL02          IFEQ      '1'
     C     BTST          IFEQ      'N'
     C     CUST          READE     FAROPNDD                               50
     C                   ELSE
     C     KKBTST        READE     FAROPNSA                               50
     C                   END
     C                   END
     C     SL02          IFEQ      '2'
     C     CUST          READE     FAROPN                                 50
     C                   END
     C     *IN50         IFEQ      '1'
EFD04C                   Z-ADD     RR5           LLIN             05 0
     C                   LEAVE
     C                   END
      *
     C                   MOVE      *BLANKS       CM07
     C     SELC          IFEQ      '6'
     C     ARPRST        ANDEQ     'N'
     C                   MOVE      'STOPPED'     CM07
     C                   END
      *
     C                   Z-ADD     ARTTYP        CT
     C                   Z-ADD     ARTTYP        TTYP
     C     CT            IFGE      01
     C     CT            ANDLE     15
     C                   MOVEL     TP(CT)        TYPE
     C                   ELSE
     C                   MOVE      *BLANKS       TYPE
     C                   END
      *
     C     DTYORN        IFEQ      'N'
     C     ARPRST        ANDEQ     'N'
     C                   ITER
     C                   END
     C                   MOVE      '1'           *IN11
      *
      *
     C                   ADD       1             RR5
     C                   MOVE      *BLANKS       CODE
     C     SL01          IFEQ      '1'
     C                   Z-ADD     ARDUDT        DUDT07
     C                   CALL      '@DTCNV'
     C                   PARM                    DUDT07            7 0
     C                   PARM                    DUDT              6 0
     C                   PARM      'N'           ##ERR             1
     C                   Z-ADD     DUDT          DATE
     C                   MOVE      '  Due   '    HD08
     C                   END
     C     SL01          IFEQ      '2'
     C                   Z-ADD     ARTDAT        DUDT07
     C                   CALL      '@DTCNV'
     C                   PARM                    DUDT07            7 0
     C                   PARM                    DUDT              6 0
     C                   PARM      'N'           ##ERR             1
     C                   Z-ADD     DUDT          DATE
     C                   MOVE      ' Entry  '    HD08
     C                   END
     C                   Z-ADD     DUDT07        DDAT
     C                   Z-ADD     0             PAY$
     C                   Z-ADD     0             PDIS
     C                   Z-ADD     ARINV#        INV#
     C                   Z-ADD     ARSEQ#        SEQ#
     C                   MOVE      ARSUFF        SUFF
     C                   MOVE      AR$AMT        DAMT
     C     ARTTYP        IFEQ      01
     C     ARDISC        SUB       ARDTAK        DISC
     C                   ELSE
     C                   MOVE      ARDTAK        DISC
     C                   END
     C                   MOVE      ARDUE$        DUE$
     C**
     C                   WRITE     S60SFL
     C                   ENDDO
      ** ***********
     C     RR5           IFEQ      0
     C                   MOVEL     ER(08)        ER28
     C                   MOVE      '1'           *IN13
     C                   ADD       1             RR5
     C                   MOVE      *BLANKS       CODE
     C                   Z-ADD     0             INV#
     C                   MOVE      *BLANKS       SUFF
     C                   MOVE      *BLANKS       TYPE
     C                   MOVE      TDATE         DATE
     C                   Z-ADD     0             DAMT
     C                   Z-ADD     0             DISC
     C                   Z-ADD     0             DUE$
     C                   MOVE      *BLANKS       CM07
     C                   WRITE     S60SFL
     C                   END
      ** ***********
     CSR                 ENDSR
      *
     CSR   S50LOD        BEGSR
      *
     C     BTST          IFEQ      'N'
     C     CUST          SETLL     FAROPNDD
     C                   ELSE
     C     KKBTST        SETLL     FAROPNSA
     C                   END
      *
     C     *IN50         DOUEQ     '1'
     C     BTST          IFEQ      'N'
     C     CUST          READE     FAROPNDD                               50
     C                   ELSE
     C     KKBTST        READE     FAROPNSA                               50
     C                   END
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      *
     C     TDAT          IFEQ      ARTDAT
     C     ARINV#        CHAIN     FAR210                             51
     C     *IN51         IFEQ      '1'
     C                   Z-ADD     ARINV#        W1INV#
     C                   WRITE     RAR210
     C                   END
     C                   END
      *
     C                   ENDDO
      *
     CSR                 ENDSR
      *
      *
     CSR   S10CNT        BEGSR
     C                   Z-ADD     0             RR1
EFD04C                   Z-ADD     0             LINEC            05 0
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      *
     C     CODE          IFNE      *BLANKS
     C     PAY$          ORNE      0
     C     PDIS          ORNE      0
     C                   ADD       1             LINEC
     C                   LEAVE
     C                   END
     C                   ENDDO
      **
     CSR                 ENDSR
      *
      *
     CSR   S10CHK        BEGSR
     C                   Z-ADD     0             PAY03
     C                   EXSR      CALCOP
     C                   Z-ADD     0             RR1
     C                   Z-ADD     0             S10CT             3 0
     C                   Z-ADD     0             LINESP            3 0
      *
     C*          SELC      IFEQ '3'                        SPREAD ON ACCT
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C*                    END
      *
     C     SELC          IFEQ      '4'
     C     PASS          IFEQ      1
     C                   Z-ADD     0             TOT01
     C                   Z-ADD     0             TOT02
     C                   END
     C     PASS          IFEQ      2
     C                   Z-ADD     0             TOT02
     C                   END
     C                   END
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      *
     C                   Z-ADD     DUE$          DUEX
     C                   Z-ADD     DUE$          LDUE             08 2
      *                                                    GET THE LARGEST $ AMT
NEW  C     CODE          IFNE      'Y'
NEW  C                   EXSR      SET11
NEW  C                   UPDATE    S10SFL
NEW  C                   END
     C*-------------------------------------------------------------------------
      * CODE *NE Y OR *BLANKS
     C     CODE          IFNE      'Y'
     C     CODE          ANDNE     *BLANKS
     C                   MOVE      'Y'           W25              01
     C                   END
     C     PDIS          IFNE      0
     C     PDIS          ANDGT     DISC
     C                   MOVE      'Y'           W17              01
     C                   END
     C*-------------------------------------------------------------------------
MJT03C     CODE          IFEQ      'Y'
MJT03C     RR1           IFGT      15
MJT03C     RR1           DIV       15            RRNX             04 0
MJT03C     RRNX          MULT      15            PAGE#
MJT03C                   ADD       1             PAGE#
MJT03C                   END
MJT03C     RR1           IFLE      15
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
MJT03C     PAGE#         IFGT      RR1
MJT03C                   SUB       15            PAGE#
MJT03C                   END
MJT03C                   END
     C*-------------------------------------------------------------------------
      * CODE = Y
      * PAID > 0
L1   C     CODE          IFEQ      'Y'
     C                   ADD       1             LINESP
      *                                                    GET THE LARGEST $ AMT
L2   C     SELC          IFNE      '3'
L2   C     SELC          ANDNE     '4'
      *                                                    GET THE LARGEST $ AMT
L3   C     LDUE          IFGT      0
L3   C     PAY$          ANDGT     0
      *                                                    GET THE LARGEST $ AMT
L4   C     PAY$          IFGT      LDUE
     C                   Z-ADD     LDUE          PAY$
L4   C                   END
      *                                                    GET THE LARGEST $ AMT
     C                   EXSR      TSTPY1
     C                   EXSR      SET11
CALDUC                   SUB       PAY$          DUEX
CALDUC                   SUB       PDIS          DUEX
     C                   UPDATE    S10SFL
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ITER
L3   C                   END
      *                                                    GET THE LARGEST $ AMT
L2   C                   END
     C*-------------------------------------------------------------------------
      *  LINE < 0.00
L2   C     SELC          IFNE      '3'
L2   C     SELC          ANDNE     '4'
      *                                                    GET THE LARGEST $ AMT
L3   C     LDUE          IFLT      0
L3   C     PAY$          ANDLT     0
      *                                                    GET THE LARGEST $ AMT
L4   C     PAY$          IFLT      LDUE
     C                   Z-ADD     LDUE          PAY$
     C                   EXSR      SET11
CALDUC                   SUB       PAY$          DUEX
CALDUC                   SUB       PDIS          DUEX
     C                   UPDATE    S10SFL
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ITER
L4   C                   END
      *
L3   C                   END
      *
L2   C                   END
     C*-------------------------------------------------------------------------
      *  PAY$=0.00
L2   C     SELC          IFNE      '3'
L2   C     SELC          ANDNE     '4'
L2   C     PAY$          ANDEQ     0
L2   C     PDIS          ANDEQ     0
     C*
L3   C     TTYP          IFEQ      01
L3   C     TTYP          OREQ      04
L3   C     TTYP          OREQ      05
L3   C     TTYP          OREQ      07
L3   C     TTYP          OREQ      12
L3   C     TTYP          OREQ      13
L3   C     TTYP          OREQ      14
     C     DUE$          SUB       DISC          PAY$
     C     PAY$          IFNE      0
     C                   Z-ADD     DISC          PDIS
     C                   END
     C*
     C     PAY$          IFGT      0
     C     PAY$          ANDGT     PAY09
     C                   Z-ADD     PAY09         PAY$
     C                   END
     C*
L4   C     SELC          IFNE      '3'
     C                   EXSR      TSTPY1
L4   C                   END
     C*
     C                   EXSR      SET11
CALDUC                   SUB       PAY$          DUEX
CALDUC                   SUB       PDIS          DUEX
     C                   UPDATE    S10SFL
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   ITER
L3   C                   END
     C*
L2   C                   END
     C*-------------------------------------------------------------------------
      *  PAY$=0.00
L2   C     SELC          IFEQ      '3'
L2   C     PAY$          ANDEQ     0
L2   C     PDIS          ANDEQ     0
     C*
L3   C     TTYP          IFEQ      01
L3   C     TTYP          OREQ      04
L3   C     TTYP          OREQ      05
L3   C     TTYP          OREQ      07
L3   C     SEQ#          OREQ      0
     C     DUE$          SUB       DISC          PAY$
     C                   Z-ADD     DISC          PDIS
     C*
     C     PAY$          MULT      -1.00         PAY$
     C     PDIS          MULT      -1.00         PDIS
     C*
L4   C     SELC          IFNE      '3'
     C                   EXSR      TSTPY1
L4   C                   END
     C*
     C                   EXSR      SET11
CALDUC                   ADD       PAY$          DUEX
CALDUC                   ADD       PDIS          DUEX
     C                   UPDATE    S10SFL
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ITER
L3   C                   END
     C*
L2   C                   END
     C*-------------------------------------------------------------------------
      * CODE = Y
L2   C     SELC          IFEQ      '4'
L2   C     PAY$          IFEQ      0
L2   C     PDIS          ANDEQ     0
     C     DUE$          SUB       DISC          PAY$
     C                   Z-SUB     DISC          PDIS
     C*
     C*          TTYP      IFNE 03
     C*          TTYP      ANDNE05
     C*          TTYP      ANDNE11
     C*          PAY$      ANDGETOT01
     C*                    Z-ADDTOT01     PAY$
     C*                    END
     C     TTYP          IFNE      03
     C     TTYP          ANDNE     05
WJB  C     TTYP          ANDNE     10
     C     TTYP          ANDNE     11
     C     TOT02         ADD       PAY$          TOTX2            08 2
     C     TOTX2         IFGT      TOT01
     C     TOT01         SUB       TOT02         PAY$
     C                   END
     C                   END
     C*
     C     PAY$          MULT      -1.00         PAY$
     C     PDIS          MULT      -1.00         PDIS
     C                   END
     C**
MJT04C     PASS          IFEQ      01
MJT04C                   Z-ADD     INV#          SINV             06 0
MJT04C                   MOVE      SUFF          SSUF             02
MJT04C                   END
     C**
L4   C     PASS          IFEQ      02
     C     TOT01         SUB       TOT02         OPEN             08 2
     C**
L5   C     PAY$          IFGT      OPEN
L3   C     TTYP          IFNE      03
L3   C     TTYP          ANDNE     05
L3   C     TTYP          ANDNE     11
WJB  C     TTYP          ANDNE     10
     C                   Z-ADD     OPEN          PAY$
     C                   Z-ADD     0             PDIS
     C     PAY$          MULT      -1.00         PAY$
     C     PDIS          MULT      -1.00         PDIS
L5   C                   END
L5   C                   END
     C**
L4   C                   END
     C**
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
L3   C*                    END
     C**
L2   C                   END
     C**
     C     SELC          IFEQ      '4'
     C     PASS          IFEQ      1
     C                   ADD       PAY$          TOT01
     C                   END
     C     PASS          IFEQ      2
     C     TTYP          ANDNE     03
     C     TTYP          ANDNE     05
     C     TTYP          ANDNE     11
WJB  C     TTYP          ANDNE     10
     C     PAY$          MULT      -1.00         PAY$$            07 2
     C                   ADD       PAY$$         TOT02
     C                   END
     C                   END
     C**
     C*-------------------------------------------------------------------------
      ** THESE LINES DO NOT FIT ANY OF THE ABOVE
     C     SELC          IFNE      '3'
     C     SELC          ANDNE     '4'
     C                   MOVE      'Y'           W10              01
     C                   END
      **
     C     SELC          IFEQ      '3'
     C     SELC          OREQ      '4'
CALDUC                   ADD       PAY$          DUEX
CALDUC                   ADD       PDIS          DUEX
     C                   END
     C     SELC          IFNE      '3'
     C     SELC          ANDNE     '4'
CALDUC                   SUB       PAY$          DUEX
CALDUC                   SUB       PDIS          DUEX
     C                   END
      **
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   MOVE      '1'           *IN08
     C                   MOVEL     ER(09)        OP15
     C                   ITER
L1   C                   END
     C*-------------------------------------------------------------------------
      **
     C     PAY$          IFNE      0
     C                   MOVE      'Y'           W15              01
     C                   MOVEL     ER(09)        OP15
     C                   END
      **
     C     PAY$          IFEQ      0
     C     PDIS          ANDNE     0
     C                   MOVE      'Y'           W16              01
     C                   MOVEL     ER(09)        OP15
     C                   END
      **
     C                   ENDDO
      **
     C     W10           IFEQ      'Y'
     C                   Z-ADD     01            CTW              02 0
     C                   EXSR      WARN01
     C                   MOVE      'N'           W10
     C                   MOVE      '0'           *IN08
     C                   END
     C     W15           IFEQ      'Y'
     C                   Z-ADD     04            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W15
     C                   MOVE      '0'           *IN08
     C                   END
     C     W16           IFEQ      'Y'
     C                   Z-ADD     19            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W16
     C                   MOVE      '0'           *IN08
     C                   END
     C     W17           IFEQ      'Y'
     C                   Z-ADD     22            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W17
     C                   MOVE      '0'           *IN08
     C                   END
     C     W20           IFEQ      'Y'
     C                   Z-ADD     07            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W20
     C                   MOVE      '0'           *IN08
     C                   END
     C     W25           IFEQ      'Y'
     C                   Z-ADD     10            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W25
     C                   MOVE      'Y'           W25ER            01
     C                   MOVE      '0'           *IN08
     C                   END
      ** - ***********************************************************
     C     SELC          IFEQ      '4'
      *
     C     PASS          IFEQ      1
     C     TOT01         ANDEQ     0
     C                   Z-ADD     28            CTW
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   EXSR      WARN01
     C                   END
      *
     C     PASS          IFEQ      2
     C     TOT02         ANDEQ     0
     C                   Z-ADD     31            CTW
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   EXSR      WARN01
     C                   END
     C     PASS          IFEQ      2
     C     TOT01         ANDNE     TOT02
     C                   MOVE      '0'           *IN08
     C                   MOVE      *BLANKS       OP15
     C                   END
      *
     C                   END
      ** - ***********************************************************
      **
     CSR                 ENDSR
      *
      *
     CSR   S60CHK        BEGSR
      *
     C                   Z-ADD     0             LINE1
     C                   Z-ADD     0             RR5
     C                   MOVE      ' '           W25ER
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR5
     C     RR5           CHAIN     S60SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
     C                   MOVE      '0'           *IN14
      **
     C*-------------------------------------------------------------------------
MJT03C     CODE          IFEQ      'Y'
MJT03C     RR5           IFGT      15
MJT03C     RR5           DIV       15            RRNX             04 0
MJT03C     RRNX          MULT      15            PAGE#
MJT03C                   ADD       1             PAGE#
MJT03C                   END
MJT03C     RR5           IFLE      15
MJT03C                   Z-ADD     1             PAGE#
MJT03C                   END
MJT03C     PAGE#         IFGT      RR5
MJT03C                   SUB       15            PAGE#
MJT03C                   END
MJT03C                   END
     C*-------------------------------------------------------------------------
      * CODE *NE Y OR *BLANKS
     C     CODE          IFNE      'Y'
     C     CODE          ANDNE     *BLANKS
     C                   MOVE      'Y'           W25              01
     C                   END
     C*-------------------------------------------------------------------------
     C     CODE          IFEQ      'Y'
     C                   ADD       1             LINE1
     C*
     C     SEQ#          IFEQ      0
     C     DUE$          ANDNE     0
     C                   MOVE      '1'           *IN14
     C                   MOVE      'Y'           W26              01
     C                   UPDATE    S60SFL
     C                   ITER
     C                   END
      **
     C                   END
      **
     C                   ENDDO
      **
     C     W25           IFEQ      'Y'
     C                   Z-ADD     10            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W25
     C                   MOVE      'Y'           W25ER            01
     C                   END
     C     W26           IFEQ      'Y'
     C                   Z-ADD     34            CTW
     C                   EXSR      WARN01
     C                   MOVE      'N'           W26
     C                   MOVE      'Y'           W25ER            01
     C                   END
     CSR                 ENDSR
      *
      *
     CSR   S10POF        BEGSR
      *                                       ACPLC = "Y" PAY LATE CHARGES FIRST
      *                                               07 = LATE CHARGES
     C     ACPLC         IFNE      'Y'
     C                   Z-ADD     0             PASS
     C                   EXSR      POFALL
     C                   END
     C     ACPLC         IFEQ      'Y'
     C                   Z-ADD     01            PASS
     C                   EXSR      POFALL
     C                   END
     C     ACPLC         IFEQ      'Y'
     C                   Z-ADD     02            PASS
     C                   EXSR      POFALL
     C                   END
      **
     CSR                 ENDSR
      *
      *
     CSR   S10PUT        BEGSR
     C                   Z-ADD     0             RR1
     C*                    MOVE '1'       *IN98            NO CHANGES
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
L1   C     PAY$          IFNE      0
      **
L2   C     PDIS          IFGT      DISC
     C                   Z-ADD     DISC          PDIS
L2   C                   END
      **
     C                   MOVE      'Y'           PYON             01
     C                   EXSR      GETL
     C                   EXSR      CLR1
     C** ----------------------------------------------------------------------
     C** FOR PAYMENT RECORD ONLY (NOT DISCOUNT)
     C     LAST01        ADD       1             NEXT             03 0
     C     SELC          IFEQ      '2'
     C                   Z-ADD     CRC#          ARCRC#
     C                   Z-ADD     CRCE          ARCRCE
     C                   MOVE      CRCA          ARCRCA
     C                   MOVE      CRCD          ARCRCD
     C                   ELSE
     C                   Z-ADD     0             ARCRC#
     C                   Z-ADD     0             ARCRCE
     C                   MOVE      *BLANKS       ARCRCA
     C                   MOVE      *BLANKS       ARCRCD
     C                   END
     C     SELC          IFEQ      '3'
     C                   MOVE      REAS          ARREAS
     C                   ELSE
     C                   MOVE      *BLANKS       ARREAS
     C                   END
     C                   Z-ADD     NEXT          ARSEQ#
     C                   Z-ADD     SLTTYP        ARTTYP
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     DDAT          ARDUDT
     C                   Z-SUB     0             ARDTAK
     C                   Z-SUB     PAY$          AR$AMT
     C                   MOVEL     CHEK          ARCHEK
     C                   Z-ADD     CKDTXX        ARCKDT
     C                   MOVE      *BLANKS       ARDESC
     C                   Z-ADD     GDARRC        ARGLAC
     C     SELC          IFEQ      '1'
     C     SELC          OREQ      '2'
     C     SELC          OREQ      '7'
     C                   Z-ADD     BANKGL        ARGLAC
     C                   END
MJT01C                   MOVE      LOOK          ARLOOK
EFD03C                   Z-ADD     LCO           ARCOMP
     C                   MOVE      TAXJ          ARTAXJ
     C                   MOVE      SHFR          ARSHFR
MJT04C                   MOVE      BANK          ARBKCD
      ** OUTPUT PAYMENT DETAIL RECORD TO AROPN
MJT04C                   MOVE      ' '           ARPRST
     C                   WRITE     RAROPN
      ** OUTPUT PAYMENT DETAIL RECORD TO TRAN
     C                   Z-ADD     0             MTDISC
     C                   EXSR      PUTTRN
     C** ----------------------------------------------------------------------
     C** FOR DISCOUNT ONLY
     C     PDIS          IFNE      0
     C                   ADD       1             NEXT             03 0
     C                   Z-ADD     NEXT          ARSEQ#
     C                   Z-ADD     09            ARTTYP
     C                   Z-SUB     PDIS          ARDTAK
     C                   Z-SUB     PDIS          AR$AMT
     C                   Z-ADD     GDCDSC        ARGLAC
      ** OUTPUT DISCOUNT DETAIL RECORD TO AROPN
MJT04C                   MOVE      ' '           ARPRST
     C                   WRITE     RAROPN
      ** OUTPUT DISCOUNT DETAIL RECORD TO TRAN
     C                   Z-SUB     PDIS          MTDISC
     C                   EXSR      PUTTRN
     C                   END
     C** ----------------------------------------------------------------------
      **
      ** HEADER RECORD UPDATE
     C                   Z-ADD     0             SEQ#
     C     K0AROP        CHAIN     FAROPN                             52
L2   C     *IN52         IFEQ      '0'
     C                   Z-ADD     ARDUE$        OLDDUE           08 2
     C                   ADD       PDIS          ARDTAK
     C*                    SUB  PDIS      ARDISC
     C                   ADD       PAY$          ARPAID
     C                   SUB       PAY$          ARDUE$
     C                   SUB       PDIS          ARDUE$
     C                   MOVE      *BLANKS       ARDESC
     C                   UPDATE    RAROPN
     C                   EXSR      PAID#1
L2   C                   END
L1   C                   END
      **
     C                   ADD       PAY$          PAY02
     C                   SUB       PAY$          PAY03
     C     ARINV#        CHAIN     FAR210                             52
     C     *IN52         IFEQ      '1'
     C                   Z-ADD     ARINV#        W1INV#
     C                   WRITE     RAR210
     C                   END
      **
     C     CODE          IFNE      *BLANKS
     C     PAY$          ORNE      0
     C     PDIS          ORNE      0
     C                   MOVE      *BLANKS       CODE
     C                   Z-ADD     0             PAY$
     C                   Z-ADD     0             PDIS
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   END
      **
     C                   ENDDO
      *
     CSR                 ENDSR
      *
      *
     CSR   S30PUT        BEGSR
     C                   Z-ADD     0             RR1
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
     C     PAY$          IFNE      0
     C     PDIS          IFGT      DISC
     C                   Z-ADD     DISC          PDIS
     C                   END
     C                   MOVE      'Y'           PYON             01
     C                   EXSR      GETL
     C                   EXSR      CLR1
     C     LAST01        ADD       1             NEXT             03 0
     C     SELC          IFEQ      '3'
     C                   MOVE      REAS          ARREAS
     C                   ELSE
     C                   MOVE      *BLANKS       ARREAS
     C                   END
     C                   Z-ADD     NEXT          ARSEQ#
     C                   Z-ADD     SLTTYP        ARTTYP
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     DDAT          ARDUDT
     C                   Z-ADD     PDIS          ARDTAK
     C                   Z-ADD     PAY$          AR$AMT
     C                   MOVEL     CHEK          ARCHEK
     C                   Z-ADD     CKDTXX        ARCKDT
     C                   MOVE      DESC          ARDESC
     C                   MOVE      TAXJ          ARTAXJ
     C                   MOVE      SHFR          ARSHFR
     C                   Z-ADD     GDARRC        ARGLAC
MJT01C                   MOVE      LOOK          ARLOOK
EFD03C                   Z-ADD     LCO           ARCOMP
MJT04C                   MOVE      BANK          ARBKCD
MJT04C                   MOVE      ' '           ARPRST
     C                   WRITE     RAROPN
     C                   Z-ADD     0             MTDISC
     C                   EXSR      PUTTRN
     C                   MOVE      CRGLNO        ARGLAC
     C                   EXSR      PUTREV
     C                   Z-ADD     0             SEQ#
     C     K0AROP        CHAIN     FAROPN                             52
     C     *IN52         IFEQ      '0'
     C                   SUB       PDIS          ARDTAK
     C                   ADD       PAY$          ARADJ$
     C                   ADD       PDIS          ARDUE$
     C                   ADD       PAY$          ARDUE$
     C                   MOVE      DESC          ARDESC
     C                   UPDATE    RAROPN
     C                   END
     C                   END
      **
     C                   SUB       PAY$          PAY03
      **
     C                   ENDDO
      *
     CSR                 ENDSR
      *
      *
     CSR   S40PUT        BEGSR
     C                   Z-ADD     0             RR1
     C     UPDT          IFEQ      'N'
     C                   Z-ADD     0             TOT01
     C                   Z-ADD     0             TOT02
     C                   END
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
      **
     C     UPDT          IFEQ      'N'
     C     TTYP          IFEQ      03
     C     TTYP          OREQ      05
WJB  C     TTYP          OREQ      10
     C                   ADD       PAY$          TOT01
     C                   SUB       PDIS          TOT01
     C                   ELSE
     C                   ADD       PAY$          TOT02
     C                   SUB       PDIS          TOT02
     C                   END
     C                   END
      **
      **
     C     PAY$          IFNE      0
     C     UPDT          ANDEQ     'Y'
     C     PDIS          IFGT      DISC
     C                   Z-ADD     DISC          PDIS
     C                   END
     C                   MOVE      'Y'           PYON             01
     C                   EXSR      GETL
     C                   EXSR      CLR1
     C     LAST01        ADD       1             NEXT             03 0
     C                   Z-ADD     NEXT          ARSEQ#
     C                   Z-ADD     INV#          ARINV#
     C                   MOVE      SUFF          ARSUFF
     C                   Z-ADD     SLTTYP        ARTTYP
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     DDAT          ARDUDT
     C                   Z-ADD     PDIS          ARDTAK
     C                   Z-ADD     PAY$          AR$AMT
     C                   MOVEL     CHEK          ARCHEK
     C                   Z-ADD     CKDTXX        ARCKDT
     C                   MOVE      *BLANKS       ARDESC
MJT01C                   MOVE      LOOK          ARLOOK
EFD03C                   Z-ADD     LCO           ARCOMP
MJT04C                   MOVE      BANK          ARBKCD
MJT04C                   MOVE      SINV          ARSINV
MJT04C                   MOVE      SSUF          ARSSUF
MJT04C                   MOVE      ' '           ARPRST
     C                   WRITE     RAROPN
     C                   Z-ADD     0             MTDISC
MJT04C                   MOVE      SINV          MTSINV
MJT04C                   MOVE      SSUF          MTSSUF
     C                   EXSR      PUTTRN
MJT04C                   Z-ADD     *ZEROS        MTSINV
MJT04C                   MOVE      *BLANKS       MTSSUF
     C                   Z-ADD     0             SEQ#
     C     K0AROP        CHAIN     FAROPN                             52
     C     *IN52         IFEQ      '0'
     C                   SUB       PDIS          ARDTAK
     C                   ADD       PAY$          ARADJ$
     C                   ADD       PDIS          ARDUE$
     C                   ADD       PAY$          ARDUE$
     C                   MOVE      *BLANKS       ARDESC
     C                   UPDATE    RAROPN
     C                   END
     C                   END
      **
     C                   ENDDO
      *
     CSR                 ENDSR
      *
      *
     CSR   S60PUT        BEGSR
     C                   Z-ADD     0             RR1
     C                   MOVE      '0'           *IN15
     C     UPDT          IFEQ      'N'
     C                   Z-ADD     0             TAMT
     C                   Z-ADD     0             AAMT
     C                   END
      *
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S60SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
      **
     C     CODE          IFEQ      'Y'
     C     CM07          IFEQ      'STOPPED'
     C                   ITER
     C                   END
     C     SEQ#          IFEQ      000
     C     DUE$          ANDNE     0
     C                   MOVE      ER(07)        ER28
     C                   MOVE      '1'           *IN15
     C                   END
     C     UPDT          IFEQ      'N'
     C                   ADD       DAMT          AAMT
     C                   END
     C                   END
      **
      **
     C     CODE          IFEQ      'Y'
     C     UPDT          ANDEQ     'Y'
     C     K0AROP        CHAIN     FAROPN                             51
     C                   MOVE      'N'           ARPRST
     C                   UPDATE    RAROPN
     C                   END
      **
     C                   ENDDO
      *
     CSR                 ENDSR
      *
      *
     CSR   S70PUT        BEGSR
      **
     C                   Z-ADD     EDAT          INV#
     C                   MOVE      *BLANKS       SUFF
     C                   EXSR      GETL
     C                   EXSR      CLR1
      **
     C                   Z-ADD     INV#          ARINV#
     C                   Z-ADD     SLTTYP        ARTTYP
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     TDAT          ARDUDT
     C                   Z-ADD     0             ARDTAK
     C                   Z-ADD     PAID          AR$AMT
     C                   MOVEL     CHEK          ARCHEK
     C                   Z-ADD     CKDTXX        ARCKDT
     C                   MOVE      DESC          ARDESC
     C                   MOVE      GLAC          ARGLAC
     C                   Z-ADD     0             MTDISC
MJT01C                   MOVE      LOOK          ARLOOK
      * CHG PUTTRN TO PUTREV
MJT02C                   EXSR      PUTREX
EFD01C                   MOVE      BAGLNO        ARGLAC
      * CHG PUTREV TO PUTTRN
EFD01C                   EXSR      PUTTRN
      *
     CSR                 ENDSR
      *
      *
     CSR   BALPUT        BEGSR
      *
     C                   MOVE      'N'           PYON
      *
     C                   Z-ADD     EDAT          INV#
     C                   MOVE      'OA'          SUFF
     C                   Z-ADD     0             SEQ#
      *
     C                   EXSR      GETL
      *
     C     K0AROP        CHAIN     FAROPN                             50
     C     *IN50         IFEQ      '0'
     C                   Z-ADD     AR$AMT        XX$AMT           11 2
     C                   Z-ADD     ARDUE$        XXDUE$           11 2
     C                   Z-ADD     ARDISC        XXDISC           11 2
     C                   Z-ADD     ARDTAK        XXDTAK           11 2
     C                   Z-ADD     ARPAID        XXPAID           11 2
     C                   Z-ADD     ARADJ$        XXADJ$           11 2
     C                   MOVE      'N'           NEWYN            01
     C                   ELSE
     C                   Z-ADD     0             XX$AMT
     C                   Z-ADD     0             XXDUE$
     C                   Z-ADD     0             XXDISC
     C                   Z-ADD     0             XXDTAK
     C                   Z-ADD     0             XXPAID
     C                   Z-ADD     0             XXADJ$
     C                   MOVE      'Y'           NEWYN
     C                   END
     C                   Z-ADD     INV#          ARINV#
     C                   MOVE      SUFF          ARSUFF
     C                   Z-ADD     SEQ#          ARSEQ#
      **
      **
     C                   EXSR      CLR1
     C                   Z-ADD     0             ARSEQ#
     C                   MOVEL     CHEK          ARCHEK
     C*                    Z-ADDSLTTYP    ARTTYP           EFD - BY SELECTION
     C     SELC          IFEQ      '2'
     C                   Z-ADD     10            ARTTYP
     C                   ELSE
     C                   Z-ADD     03            ARTTYP
     C                   ENDIF
     C                   Z-ADD     TDAT          ARTDAT
     C                   Z-ADD     TDAT          ARDUDT
     C                   Z-ADD     0             ARDTAK
     C                   Z-SUB     AAMT          AR$AMT
     C                   Z-SUB     AAMT          ARDUE$
MJT02C*                    Z-ADDGDARRC    ARGLAC
MJT02C                   Z-ADD     BAGLNO        ARGLAC
     C                   Z-ADD     0             MTDISC
EFD03C                   Z-ADD     LCO           ARCOMP
     C                   EXSR      PUTTRN
     C                   ADD       XX$AMT        AR$AMT
     C                   ADD       XXDUE$        ARDUE$
     C*                    ADD  XXDISC    ARDISC
     C                   ADD       XXDTAK        ARDTAK
     C                   ADD       XXPAID        ARPAID
     C                   ADD       XXADJ$        ARADJ$
MJT01C                   MOVE      LOOK          ARLOOK
     C     NEWYN         IFEQ      'Y'
MJT04C                   MOVE      BANK          ARBKCD
MJT04C                   MOVE      ' '           ARPRST
     C                   WRITE     RAROPN
     C                   ELSE
     C                   MOVE      *BLANKS       ARCHEK
     C                   MOVEL     'Multiple'    ARCHEK
     C                   UPDATE    RAROPN
     C                   END
     C                   ADD       AAMT          PAY02
     C                   Z-ADD     0             AAMT
      **
     C     ARINV#        CHAIN     FAR210                             51
     C     *IN51         IFEQ      '1'
     C                   Z-ADD     ARINV#        W1INV#
     C                   WRITE     RAR210
     C                   END
      **
     CSR                 ENDSR
      **
      **
     C*R         GETA      BEGSR
     C*    **
     C*    ABCDEFGHIJKLMNOPQRSTUVWXYZ
     C*          GETA01    TAG
     C*                    MOVE ARSUFF    SUFF01 01
     C*                    Z-ADD01        CT     030
     C*                    MOVE '0'       *IN50
     C*          SUFF01    LOKUPAL,CT                    50
     C*          *IN50     IFEQ '1'
     C*                    ADD  1         CT
     C*                    MOVE AL,CT     SUFF
     C*                    END
     C*          K0AROP    CHAINFAROPN               50
     C*          *IN50     IFEQ '0'
     C*                    GOTO GETA01
     C*                    END
     C*R                   ENDSR
      *
      *
     CSR   PUTTRN        BEGSR
     C                   ADD       1             LAST02
     C                   MOVE      ARSTAT        MTSTAT
     C                   MOVE      ARCUST        MTCUST
     C                   MOVE      ARINV#        MTINV#
     C                   MOVE      ARSUFF        MTSUFF
     C                   MOVE      LAST02        MTSEQ#
     C                   MOVE      ARCTYP        MTCTYP
     C                   MOVE      ARSLM1        MTSLM1
     C                   MOVE      ARCOM1        MTCOM1
     C                   MOVE      ARSLM2        MTSLM2
     C                   MOVE      ARCOM2        MTCOM2
     C                   MOVE      ARTERR        MTTERR
     C                   MOVE      ARCOMP        MTCOMP
     C                   MOVE      ARTTYP        MTTTYP
     C                   MOVE      ARTDAT        MTTDAT
     C                   MOVE      ARDUDT        MTDUDT
     C                   MOVE      ARTAXJ        MTTAXJ
     C                   MOVE      ARSHFR        MTSHFR
     C                   Z-ADD     AR$AMT        MT$AMT
     C                   Z-ADD     0             MTDIS$
     C                   Z-ADD     0             MTQDIS
     C                   Z-ADD     0             MTFRT$
     C                   Z-ADD     0             MTSPL$
     C                   Z-ADD     0             MTAMT1
     C                   Z-ADD     0             MTAMT2
     C                   Z-ADD     0             MTAMT3
     C                   Z-ADD     0             MTMER$
     C                   MOVE      ARGLAC        MTGLAC
     C                   MOVE      *BLANKS       MTGLAR
     C                   MOVE      *BLANKS       MTGLUD
     C                   Z-ADD     0             MTO30$
     C                   MOVE      ARDCDT        MTDCDT
     C                   MOVE      ARORD#        MTORD#
     C*                    Z-ADDARDISC    MTDISC
     C                   MOVE      *BLANKS       MTDMFL
     C                   MOVE      *BLANKS       MTSMFL
     C                   MOVE      ARSHCU        MTSHCU
     C                   MOVE      ARSACU        MTSACU
     C                   MOVE      ARBLCU        MTBLCU
     C                   MOVE      ARLOOK        MTLOOK
     C                   MOVE      ARPONO        MTPONO
     C                   MOVE      *BLANKS       MTPOSC
     C                   MOVE      *BLANKS       MTPOS
     C                   MOVE      *BLANKS       MTCSAJ
     C     SELC          IFEQ      '3'
     C                   MOVE      CSAJ          MTCSAJ
     C     CSAJ          IFNE      'Y'
     C     CSAJ          ANDNE     'N'
     C                   MOVE      'Y'           MTCSAJ
     C                   END
     C                   END
     C                   MOVE      *BLANKS       MTSHFR
     C                   MOVE      ARCHEK        MTCHEK
     C                   MOVE      ARREAS        MTREAS
     C                   MOVE      ARCKDT        MTCKDT
     C                   MOVE      ARDESC        MTDESC
     C                   MOVE      ARDTLA        MTDTLA
     C                   MOVE      ARTIME        MTTIME
     C                   MOVE      ARUSER        MTUSER
     C*
     C                   MOVE      *BLANKS       MTCRCD
     C                   Z-ADD     0             MTCRC#
     C                   Z-ADD     0             MTCRCE
     C                   MOVE      *BLANKS       MTCRCA
     C     MTTTYP        IFEQ      03
     C     OLTTYP        ANDEQ     10
     C                   MOVEL     CRCD          MTCRCD
     C                   Z-ADD     CRC#          MTCRC#
     C                   Z-ADD     CRCE          MTCRCE
     C                   MOVEL     CRCA          MTCRCA
     C                   END
     C     MTTTYP        IFEQ      10
WJB  C     MTTTYP        OrNe      10
WJB  C     CRC#          AndNe     0
     C                   MOVEL     CRCD          MTCRCD
     C                   Z-ADD     CRC#          MTCRC#
     C                   Z-ADD     CRCE          MTCRCE
     C                   MOVEL     CRCA          MTCRCA
     C                   END
     C*
     C                   MOVE      *BLANKS       MTSHP#
MJT04C                   MOVE      BANK          MTBKCD
     C                   WRITE     RMTRAN
     CSR                 ENDSR
      *
      *
MJT02CSR   PUTREX        BEGSR
MJT02C                   ADD       1             LAST02
MJT02C                   MOVE      ARSTAT        MTSTAT
MJT02C                   MOVE      ARCUST        MTCUST
MJT02C                   MOVE      ARINV#        MTINV#
MJT02C                   MOVE      ARSUFF        MTSUFF
MJT02C                   MOVE      LAST02        MTSEQ#
MJT02C                   MOVE      ARCTYP        MTCTYP
MJT02C                   MOVE      ARSLM1        MTSLM1
MJT02C                   MOVE      ARCOM1        MTCOM1
MJT02C                   MOVE      ARSLM2        MTSLM2
MJT02C                   MOVE      ARCOM2        MTCOM2
MJT02C                   MOVE      ARTERR        MTTERR
MJT02C                   MOVE      ARCOMP        MTCOMP
MJT02C                   MOVE      ARTTYP        MTTTYP
MJT02C                   MOVE      ARTDAT        MTTDAT
MJT02C                   MOVE      ARDUDT        MTDUDT
MJT02C                   MOVE      ARTAXJ        MTTAXJ
MJT02C                   MOVE      ARSHFR        MTSHFR
MJT02C                   Z-ADD     AR$AMT        MT$AMT
MJT02C                   Z-ADD     0             MTDIS$
MJT02C                   Z-ADD     0             MTQDIS
MJT02C                   Z-ADD     0             MTFRT$
MJT02C                   Z-ADD     0             MTSPL$
MJT02C                   Z-ADD     0             MTAMT1
MJT02C                   Z-ADD     0             MTAMT2
MJT02C                   Z-ADD     0             MTAMT3
MJT02C                   Z-ADD     0             MTMER$
MJT02C                   MOVE      ARGLAC        MTGLAC
MJT02C                   MOVE      *BLANKS       MTGLAR
MJT02C                   MOVE      *BLANKS       MTGLUD
MJT02C                   Z-ADD     0             MTO30$
MJT02C                   MOVE      ARDCDT        MTDCDT
MJT02C                   MOVE      ARORD#        MTORD#
MJT02C*                    Z-ADDARDISC    MTDISC
MJT02C                   MOVE      *BLANKS       MTDMFL
MJT02C                   MOVE      *BLANKS       MTSMFL
MJT02C                   MOVE      ARSHCU        MTSHCU
MJT02C                   MOVE      ARSACU        MTSACU
MJT02C                   MOVE      ARBLCU        MTBLCU
MJT02C                   MOVE      ARLOOK        MTLOOK
MJT02C                   MOVE      ARPONO        MTPONO
MJT02C                   MOVE      *BLANKS       MTPOSC
MJT02C                   MOVE      *BLANKS       MTPOS
MJT02C                   MOVE      *BLANKS       MTCSAJ
MJT02C                   MOVE      *BLANKS       MTSHFR
MJT02C                   MOVE      ARCHEK        MTCHEK
MJT02C                   MOVE      ARREAS        MTREAS
MJT02C                   MOVE      ARCKDT        MTCKDT
MJT02C                   MOVE      ARDESC        MTDESC
MJT02C                   MOVE      ARDTLA        MTDTLA
MJT02C                   MOVE      ARTIME        MTTIME
MJT02C                   MOVE      ARUSER        MTUSER
     C*
MJT02C                   MOVE      *BLANKS       MTCRCD
MJT02C                   Z-ADD     0             MTCRC#
MJT02C                   Z-ADD     0             MTCRCE
MJT02C                   MOVE      *BLANKS       MTCRCA
MJT02C     MTTTYP        IFEQ      03
MJT02C     OLTTYP        ANDEQ     10
MJT02C                   MOVEL     CRCD          MTCRCD
MJT02C                   Z-ADD     CRC#          MTCRC#
MJT02C                   Z-ADD     CRCE          MTCRCE
MJT02C                   MOVEL     CRCA          MTCRCA
MJT02C                   END
MJT02C     MTTTYP        IFEQ      10
WJB  C     MTTTYP        OrNe      10
WJB  C     CRC#          AndNe     0
MJT02C                   MOVEL     CRCD          MTCRCD
MJT02C                   Z-ADD     CRC#          MTCRC#
MJT02C                   Z-ADD     CRCE          MTCRCE
MJT02C                   MOVEL     CRCA          MTCRCA
MJT02C                   END
MJT02C*
MJT02C                   Z-SUB     AR$AMT        MT$AMT
MJT02C                   Z-ADD     0             MTMER$
MJT02C                   MOVE      ARGLAC        MTGLAC
MJT02C                   MOVE      *BLANKS       MTSHP#
MJT04C                   MOVE      BANK          MTBKCD
MJT02C                   WRITE     RMTRAN
MJT02CSR                 ENDSR
      *
      *
     CSR   PUTREV        BEGSR
     C                   ADD       1             LAST02
     C*                    MOVE ARTMTGLAC MTSTAT
     C*                    MOVE ARCUST    MTCUST
     C*                    MOVE ARINV#    MTINV#
     C*                    MOVE ARSUFF    MTSUFF
     C                   MOVE      LAST02        MTSEQ#
     C*                    MOVE ARCTYP    MTCTYP
     C*                    MOVE ARSLM1    MTSLM1
     C*                    MOVE ARCOM1    MTCOM1
     C*                    MOVE ARSLM2    MTSLM2
     C*                    MOVE ARCOM2    MTCOM2
     C*                    MOVE ARTERR    MTTERR
     C*                    MOVE ARCOMP    MTCOMP
     C*                    MOVE ARTTYP    MTTTYP
     C*                    MOVE ARTDAT    MTTDAT
     C*                    MOVE ARDUDT    MTDUDT
     C                   Z-SUB     AR$AMT        MT$AMT
     C*                    Z-ADD0         MTDIS$
     C*                    Z-ADD0         MTQDIS
     C*                    Z-ADD0         MTFRT$
     C*                    Z-ADD0         MTSPL$
     C*                    Z-ADD0         MTAMT1
     C*                    Z-ADD0         MTAMT2
     C*                    Z-ADD0         MTAMT3
     C                   Z-ADD     0             MTMER$
     C                   MOVE      ARGLAC        MTGLAC
     C*                    MOVE *BLANKS   MTGLAR
     C*                    MOVE *BLANKS   MTGLUD
     C*                    Z-ADD0         MTO30$
     C*                    MOVE ARDCDT    MTDCDT
     C*                    MOVE ARORD#    MTORD#
     C*                    Z-SUBARDISC    MTDISC
     C*                    MOVE *BLANKS   MTDMFL
     C*                    MOVE *BLANKS   MTSMFL
     C*                    MOVE ARSHCU    MTSHCU
     C*                    MOVE ARSACU    MTSACU
     C*                    MOVE ARBLCU    MTBLCU
     C*                    MOVE ARLOOK    MTLOOK
     C*                    MOVE ARPONO    MTPONO
     C*                    MOVE *BLANKS   MTPOSC
     C*                    MOVE *BLANKS   MTPOS
     C*                    MOVE *BLANKS   MTCSAJ
     C*                    MOVE *BLANKS   MTSHFR
     C*                    MOVE ARCHEK    MTCHEK
     C*                    MOVE ARCKDT    MTCKDT
     C*                    MOVE ARDESC    MTDESC
     C*                    MOVE ARDTLA    MTDTLA
     C*                    MOVE ARTIME    MTTIME
     C*                    MOVE ARUSER    MTUSER
MJT04C                   MOVE      BANK          MTBKCD
     C                   WRITE     RMTRAN
     CSR                 ENDSR
      *
      *
     CSR   S10ALL        BEGSR
     C                   Z-ADD     0             RR1
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
     C     SELC          IFNE      '4'
     C     TTYP          IFEQ      01
     C     TTYP          OREQ      05
     C     TTYP          OREQ      07
     C                   MOVE      'Y'           CODE
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   END
     C                   END
     C     SELC          IFEQ      '4'
     C     TTYP          IFEQ      01
     C     TTYP          OREQ      03
     C     TTYP          OREQ      05
     C     TTYP          OREQ      07
WJB  C     TTYP          OREQ      10
     C                   MOVE      'Y'           CODE
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   END
     C                   END
     C                   ENDDO
     CSR                 ENDSR
      *
      *
     CSR   S10NON        BEGSR
     C                   Z-ADD     0             RR1
     C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
      **
     C     CODE          IFNE      *BLANKS
     C     PAY$          ORNE      0
     C     PDIS          ORNE      0
     C                   MOVE      *BLANKS       CODE
     C                   Z-ADD     0             PAY$
     C                   Z-ADD     0             PDIS
     C                   EXSR      SET11
     C                   UPDATE    S10SFL
     C                   END
      **
     C                   ENDDO
      **
     CSR                 ENDSR
      **
      **
     CSR   GETL          BEGSR
     C                   Z-ADD     0             LAST01           03 0
     C                   Z-ADD     0             LAST02           03 0
     C     K1AROP        SETLL     FAROPN
     C     K1AROP        SETLL     FMTRAN
     C**
     C     *IN51         DOUEQ     '1'
     C     K1AROP        READE     FAROPN                                 51
     C     *IN51         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   Z-ADD     ARSEQ#        LAST01
      ** EFD 5/02/02 FROM INVOICE CARRING TO NEXT RECORD.
     C                   Z-ADD     0             ARSINV
     C                   MOVE      *BLANKS       ARSSUF
     C                   ENDDO
     C**
     C     *IN51         DOUEQ     '1'
     C     K1AROP        READE     FMTRAN                                 51
     C     *IN51         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   Z-ADD     MTSEQ#        LAST02
     C                   ENDDO
     CSR                 ENDSR
      **
      **
     CSR   CLR1          BEGSR
CLR  C                   MOVE      *BLANKS       ARSTAT
CLR  C                   Z-ADD     0             ARDUDT
CLR  C                   Z-ADD     0             AR$AMT
CLR  C*                    Z-ADD0         ARDISC
CLR  C                   Z-ADD     0             ARDTAK
CLR  C                   Z-ADD     0             ARADJ$
CLR  C                   Z-ADD     0             ARPAID
CLR  C                   Z-ADD     0             ARDUE$
CLR  C                   MOVE      *BLANKS       ARCHEK
CLR  C                   Z-ADD     0             ARCKDT
CLR  C                   Z-ADD     CKDT          ARGLAC
CLR  C                   MOVE      *BLANKS       ARDESC
CLR  C                   Z-ADD     0             ARDCDT
CLR  C                   MOVE      *BLANKS       ARCRCD
CLR  C                   Z-ADD     0             ARCRC#
CLR  C                   Z-ADD     0             ARCRCE
CLR  C                   MOVE      *BLANKS       ARCRCA
COM  C                   MOVE      TDATE         ARDTLA
COM  C                   MOVE      TIMOD         ARTIME
COM  C                   MOVE      USERID        ARUSER
COM  C                   MOVE      'A'           ARSTAT
COM  C                   Z-ADD     CUST          ARCUST
COM  C*                    Z-ADDSHIP      ARSHCU
     CSR                 ENDSR
      *
      *
     CSR   SET11         BEGSR
     *******************************************************************
     C     SELC          IFEQ      '1'
     C     SELC          OREQ      '2'
     C                   MOVE      '0'           *IN11
     C     TTYP          IFEQ      01
MJT01C*          TTYP      OREQ 05                         CREDIT
     C     TTYP          OREQ      07
     C     TTYP          OREQ      12
     C     TTYP          OREQ      13
     C     TTYP          OREQ      14
     C*          ARDUE$    IFNE 0
     C     DUE$          IFNE      0
     C                   MOVE      '1'           *IN11
     C                   END
     C                   END
     C                   END
     *******************************************************************
     C     SELC          IFEQ      '3'
     C*
     C                   MOVE      '0'           *IN11
     C*
     C     TTYP          IFEQ      01
     C     TTYP          OREQ      03
     C     TTYP          OREQ      04
     C     TTYP          OREQ      05
     C     TTYP          OREQ      07
     C     TTYP          OREQ      11
     C     TTYP          OREQ      12
     C     TTYP          OREQ      13
     C     TTYP          OREQ      14
WJB  C     TTYP          OREQ      10
     C     SEQ#          IFEQ      0
     C                   MOVE      '1'           *IN11
     C                   END
     C                   END
     C*
     C                   END
     *******************************************************************
     C     SELC          IFEQ      '4'
     C                   MOVE      '0'           *IN11
     C     PASS          IFLE      01
     C     TTYP          IFEQ      03
     C     TTYP          OREQ      05
     C     TTYP          OREQ      11
WJB  C     TTYP          OREQ      10
     C*          ARDUE$    IFNE 0
     C     DUE$          IFNE      0
     C                   MOVE      '1'           *IN11
     C                   END
     C                   END
     C                   END
     C*                    END
     ** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
     C*          SELC      IFEQ '4'                        SPREAD #2
     C     PASS          IFGE      02
     C*                    MOVE '0'       *IN11
     C     TTYP          IFEQ      01
     C     TTYP          OREQ      07
     C     TTYP          OREQ      12
     C     TTYP          OREQ      14
     C*          ARDUE$    IFNE 0
     C     DUE$          IFNE      0
     C                   MOVE      '1'           *IN11
     C                   END
     C                   END
     C                   END
     C                   END
     *******************************************************************
     C                   MOVE      '0'           *IN15
     C     SELC          IFEQ      '4'
     C     PASS          ANDEQ     01
     C     PAY$          IFNE      0
     C                   ADD       1             S10CT
     C                   END
     C                   END
     C**
     CSR                 ENDSR
      *
     CSR   TSTPY1        BEGSR
     C     PAY$          IFGT      0
     C     PAY$          ANDGT     PAY09
     C                   MOVE      'Y'           W20              01
     C                   Z-ADD     PAY09         PAY$
     C                   Z-ADD     0             PDIS
     C                   END
     C     PAY$          IFEQ      0
     C                   MOVE      'Y'           W10
     C                   END
     C*
     CSR                 ENDSR
     C**
     CSR   TSTPY2        BEGSR
     C     PAY09         IFLT      0
     C                   Z-ADD     0             PDIS
     C                   SUB       PAY$          PAY03
     C                   ADD       PAY09         PAY$
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   END
     CSR                 ENDSR
      *
      *
     CSR   TSTNEG        BEGSR
     C     PAY$          IFLT      0
     C     PAY$          ANDLT     PAY03
     C                   Z-ADD     PAY03         PAY$
     C                   Z-ADD     0             PDIS
     C                   END
     CSR                 ENDSR
      *
      *
     CSR   COLCOM        BEGSR
     C                   CALL      'ARR222'
     C                   PARM                    CUST
     C                   PARM                    RETC
     C     RETC          IFEQ      'A'
     C                   MOVE      CUST          CUSTA            06
     C                   CALL      'ARR223CA'
     C                   PARM                    CUSTA
     C                   END
     CSR                 ENDSR
     C**
     C**
     CSR   CALCOP        BEGSR
     C     PAY01         SUB       PAY02         PAY08            09 2
     C     PAY08         SUB       PAY03         PAY09            09 2
     C                   Z-ADD     PAY01         TAMT
     C                   Z-ADD     PAY09         AAMT
     CSR                 ENDSR
      *
     CSR   CLRW1         BEGSR
     C                   Z-ADD     0             W1INV#
     C     W1INV#        SETLL     FAR210
     C     *IN50         DOUEQ     '1'
     C                   READ      FAR210                                 50
     C     *IN50         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   DELETE    RAR210
     C                   ENDDO
     CSR                 ENDSR
      *
     C**
     CSR   WARN01        BEGSR
     C                   MOVEL     W0(CTW)       WN01
     C                   ADD       01            CTW
     C                   MOVEL     W0(CTW)       WN02
     C                   ADD       01            CTW
     C                   MOVEL     W0(CTW)       WN03
     C                   EXFMT     WARN00
     CSR                 ENDSR
     C**
     CSR   WARN02        BEGSR
     C     DTYORN        IFEQ      'N'
     C                   MOVEL     W1(01)        WN01
     C                   MOVEL     W1(02)        WN02
     C                   MOVEL     W1(03)        WN03
     C                   MOVEL     W1(04)        WN04
     C                   END
     C     DTYORN        IFEQ      'Y'
     C                   MOVEL     W1(05)        WN01
     C                   MOVEL     W1(06)        WN02
     C                   MOVEL     W1(07)        WN03
     C                   MOVEL     W1(08)        WN04
     C                   END
     C     WARN2A        TAG
     C                   EXFMT     WARN10
     C     *INKB         IFEQ      '1'
     C     *INKJ         OREQ      '1'
     C                   GOTO      WARN2X
     C                   END
     C                   GOTO      WARN2A
     CSR   WARN2X        ENDSR
     C**
     CSR   WARN03        BEGSR
     C     SL02          IFEQ      '1'
     C                   MOVEL     W1(09)        WN01
     C                   MOVEL     W1(10)        WN02
     C                   MOVEL     W1(11)        WN03
     C                   MOVEL     W1(12)        WN04
     C                   END
     C     SL02          IFEQ      '2'
     C                   MOVEL     W1(13)        WN01
     C                   MOVEL     W1(14)        WN02
     C                   MOVEL     W1(15)        WN03
     C                   MOVEL     W1(16)        WN04
     C                   END
     C     WARN3A        TAG
     C                   EXFMT     WARN10
     C     *INKB         IFEQ      '1'
     C     *INKJ         OREQ      '1'
     C                   GOTO      WARN3X
     C                   END
     C                   GOTO      WARN3A
     CSR   WARN3X        ENDSR
      *
     CSR   POFALL        BEGSR
     C                   Z-ADD     0             RR1
L1   C     *IN50         DOUEQ     '1'
     C                   ADD       1             RR1
     C     RR1           CHAIN     S10SFL                             50
L2   C     *IN50         IFEQ      '1'
     C                   LEAVE
L2   C                   END
L2   C     PAY$          IFEQ      0
L2   C     PDIS          ANDEQ     0
      ** ---
00   C     PASS          IFEQ      0
00   C     TTYP          IFNE      01
00   C     TTYP          ANDNE     04
00   C     TTYP          ANDNE     07
00   C                   ITER
00   C                   END
00   C                   END
00   C     PASS          IFEQ      01
00   C     TTYP          IFNE      07
00   C                   ITER
00   C                   END
00   C                   END
00   C     PASS          IFEQ      02
00   C     TTYP          IFNE      01
00   C     TTYP          ANDNE     04
00   C                   ITER
00   C                   END
00   C                   END
      ** ---
     C     DUE$          SUB       DISC          PAY$
     C                   ADD       PAY$          PAY03
     C                   EXSR      CALCOP
     C                   Z-ADD     DISC          PDIS
     C**
     C                   EXSR      TSTPY2
     C                   EXSR      SET11
L3   C     PAY$          IFNE      0
     C                   MOVE      'Y'           CODE
L3   C                   END
     C                   UPDATE    S10SFL
L2   C                   END
L1   C                   ENDDO
     CSR                 ENDSR
      *
     CSR   CALDAT        BEGSR
     C                   CALL      'GETCARBL'
     C                   PARM                    LCOXX
     C                   PARM                    CUST
     C                   PARM                    CMARB$
     C                   PARM                    CMCUR$
     C                   PARM                    CMAR1$
     C                   PARM                    CMAR2$
     C                   PARM                    CMAR3$
     C                   PARM                    CMAR4$
     C                   PARM                    CMFUT$
     C**
     C     SELC          IFEQ      '2'
     C     CCHIST        ANDEQ     'Y'
     C     CRC#          IFNE      HSCRC#
     C     CRCE          ORNE      HSCRDT
     C     CRCD          ORNE      HSCRCD
      *
     C                   If        CRC# <> *Zeros
     C                   Z-ADD     CRC#          HSCRC#
     C                   END
     C                   If        CRCE <> *Zero
     C                   Z-ADD     CRCE          HSCRDT
     C                   END
     C                   If        CRCD <> *Blanks
     C                   Move      CRCD          HSCRCD
     C                   END
     C                   END
     C                   END
      *
     C                   Z-ADD     TDAT          ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
      *
EFD02C     PAY01         IFGT      0
     C                   ADD       PAID##        HS#PAY
     C                   ADD       PAID#D        HSAVDY
     C                   ADD       PAID#L        HSTMDL
     C                   Z-ADD     ##MDY         HSDTLP
     C                   Z-ADD     PAY01         HSAMLP
     C                   END
      *
     C                   UPDATE    RARHST
      *
     CSR                 ENDSR
      *
     CSR   PAID#1        BEGSR
     C     OLDDUE        IFNE      0
     C     ARDUE$        ANDEQ     0
     C     SELC          IFEQ      '1'
     C     SELC          OREQ      '2'
     C**
     C                   ADD       1             PAID##           05 0
     C**
     C                   Z-ADD     TDAT          ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##DDD         PAIDD1            5 0
     C**
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##DDD         PAIDD2            5 0
      *
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##DDD         PAIDD3            5 0
      *
     C     PAIDD2        SUB       PAIDD1        PAIDD            05 0
     C                   ADD       PAIDD         PAID#D           05 0
      *
     C     PAIDD1        IFGT      PAIDD3
     C                   ADD       1             PAID#L           05 0
     C                   END
     C**
     C                   END
     C                   END
     C**
     CSR                 ENDSR
     C**
     C**
     CSR   CLRWXX        BEGSR
     C                   MOVE      'N'           W10
     C                   MOVE      'N'           W15
     C                   MOVE      'N'           W16
     C                   MOVE      'N'           W17
     C                   MOVE      'N'           W20
     C                   MOVE      'N'           W25
     CSR                 ENDSR
     C**
     C**
     CSR   OP010         BEGSR
     C                   MOVE      '0'           *IN61
     C     OP010T        TAG
     C                   EXFMT     OPT010
     C     SL01          IFNE      '1'
     C     SL01          ANDNE     '2'
     C                   MOVE      '1'           *IN61
     C                   GOTO      OP010T
     C                   END
     C     *INKV         IFEQ      '1'
     C                   CALL      'ATTN01'
     C                   END
     CSR                 ENDSR
     C**
     CSR   OP060         BEGSR
     C                   MOVE      '0'           *IN61
     C                   EXFMT     OPT060
     C     *INKV         IFEQ      '1'
     C                   CALL      'ATTN01'
     C                   END
     CSR                 ENDSR
**
Inv                   1
Pmt                   2
Pmt                   3
Adj                   4
Crm                   5
Non                   6
L/C                   7
Pmt                   8
Dis                   9
C/C                  10
Dep                  11
RtC                  12
Dcl                  13
CkC                  14
                     15
** ******************************************************************
 Roll            F5=Coll Notes   F6=Restart  F8=Sel All  F9=Deselect   CSH TOP
 F10=No Detail  F11=Oldest 1st  F12=Balance on Account   F14=Invoice
 F10=Detail     F11=Oldest 1st  F12=Balance on Account   F14=Invoice
                                                                      CC  TOP
                                                                          BOT
 Roll                            F5=Collection Notes     F6=Restart   ADJ TOP
                                                                          BOT
 Roll                            F5=Collection Notes     F6=Restart     SPD TOP
                             F10=No Detail               F14=Invoice    BOT A
                             F10=Display Detail          F14=Invoice    BOT B
   Enter to Process    F3/F7=End of Job    F13=Change Deposit Date    1st A
   Enter to Process                                                   1st B
 Roll     F5=Collection Notes      F6=Restart       F10=No Detail      CSH TOP
 Roll     F5=Collection Notes     F6=Restart   F10=Display Detail      CSH TOP
                                                                          BOT B
 Roll   F2=Toggle Details   F5=Collection Notes   F6=Restart
** *************************
 Entry Must Balance To Zero
 Only One Update/Adjustment
Select Credit or Pymt To Use
 Select Invoice or Late Chg
 Only One Payment At A Time
 Select Lines To Omit
 Seq of 00 Must Be Paid
   No Open Records Found
   F1=Accept
No Credit or Pymt To Select
** ***************************
 Invoice Payment - Cash/Check
 Invoice Payment - Credit Card
        Adjustments
Spread on Account/Credit Memos
        A/R Inquiry
 Statement Printing Options
   Non A/R Cash Receipts
** PH ***********
     Payment Amt:
Balance to Apply:
  Payment Amount:
  Invoice Amount:


** W0 **************************************************
      Please Remove "Y" From Lines That Should                   1     W10   01
          Not Be Selected At This Time.                          2
                                                                 3
Please place a "Y" on the lines that have a payment              4     W15   04
amount but are not marked with a "Y" or remove the               5
payment amount.                                                  6
  Amount being paid is larger than amount of check.              7     W20   07
                                                                 8
      Press Enter and correct payment amount.                    9
               "Y" Is The Only Valid Code.                      10     W25   10
              Change Code to "Y" or Blanks.                     11
                                                                12
F1 Is Not Valid.   You Must Select A Transaction                13           13
       or Hit F6 To Restart With No Update.                     14
                                                                15
   G/L Account Number is Missing.  Code Cannot be Used.         16           16
                                                                17
                                                                18
A discount amount has been taken on a line that does            19     W16   19
not have a payment.  Please remove the discount or              20
make the line a payment.                                        21
Discount taken is greater than discount offered on              22     W16   22
at least one line.  Please change the discount                  23
amount.                                                         24
       No A/R History Record Found                              25           25
                                                                26
                                                                27
                                                                28
       Please Select Payment or Credit to be Used.              29           28
                                                                30
       Please Select Invoice or Late Charge to be Used.         31           31
                                                                32
                                                                33
 Any Line That Has An Open Balance cannot Be Removed            34
 From Statements.                                               35
                                                                36
** W1 **************************************************
You Have Selected To Change The Display Status From                    W10   01
Summary To Detail.  If You Do This All Payments Keyed
And Not Accepted Will Be Lost And Must Be Rekeyed.
 F2=Back(Payments Retained)  F10=Continue(Payments Lost)
You Have Selected To Change The Display Status From                    W10   01
Detail To Summary.  If You Do This All Payments Keyed
And Not Accepted Will Be Lost And Must Be Rekeyed.
 F2=Back(Payments Retained)  F10=Continue(Payments Lost)
You Have Selected To Change The Display Sequence From                  W10   01
Due Date to Invoice.  If You Do This All Payments Keyed
And Not Accepted Will Be Lost And Must Be Rekeyed.
 F2=Back(Payments Retained)  F10=Continue(Payments Lost)
You Have Selected To Change The Display Sequence From                  W10   01
Invoice to due Date.  If You Do This All Payments Keyed
And Not Accepted Will Be Lost And Must Be Rekeyed.
 F2=Back(Payments Retained)  F10=Continue(Payments Lost)
