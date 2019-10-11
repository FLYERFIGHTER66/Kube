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
      *PROGRAM NAME--------- APR550
      *SYSTEM--------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION-          G/L DETAIL UPDATE
      *
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
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *  8/04/00 EFD CHECK MTUSER FOR BIR430 TO DETERMINE IF DOP RECORD
      *
      *
     FFMTRAN    UF   E           K DISK
     FFHORCW    IF   E           K DISK
     FFHORDW    IF   E           K DISK
     FFIORCW    UF   E           K DISK
     FFIORDW    UF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFGLPRE    O  A E             DISK
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LOKAY                  3      3
     D  LSLSJ                  4      4
     D  LSRCE                  5      7
      *
     D INVS            DS            30    OCCURS(1) INZ
     D  J1                     1      4    INZ('Inv ')
     D  WHINV#                 5     10  0 INZ
     D  J2                    11     15    INZ(' Seq ')
     D  WISEQ#                16     18  0 INZ
     D  J3                    19     24    INZ(' Cust ')
     D  WHCUST                25     30  0 INZ
     D CRMS            DS            30    OCCURS(1) INZ
     D  J4                     1      4    INZ('Crm ')
     D  CHCRM#                 5     10  0 INZ
     D  J5                    11     15    INZ(' Seq ')
     D  CISEQ#                16     18  0 INZ
     D  J6                    19     24    INZ(' Cust ')
     D  CHCUST                25     30  0 INZ
     D PAYS            DS            30    OCCURS(1) INZ
     D  J7                     1      8    INZ('Pymt Ck ')
     D  MTCHEK                 9     18    INZ
     D  J8                    19     24    INZ(' Cust ')
     D  MTCUST                25     30  0 INZ
     D ADJS            DS            30    OCCURS(1) INZ
     D  J9                     1      4    INZ('Adj ')
     D  AINV#                  5     10  0 INZ
     D  J10                   11     15    INZ(' Rea ')
     D  MTREAS                16     18    INZ
     D  J11                   19     24    INZ(' Cust ')
     D  ACUST                 25     30  0 INZ
     D NONS            DS            30    OCCURS(1) INZ
     D  J12                    1      8    INZ('NA/R Ck ')
     D  NCHEK                  9     18    INZ
     D  J13                   19     24    INZ(' Cust ')
     D  NCUST                 25     30  0 INZ
     D LATS            DS            30    OCCURS(1) INZ
     D  J14                    1      9    INZ('Late Chg ')
     D  LINV#                 10     15  0 INZ
     D  J15                   19     24    INZ(' Cust ')
     D  LCUST                 25     30  0 INZ
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      * GET G/L DEFAULT FOR A/R MONTH RECORD.
      *
     C                   MOVEL     '01'          TYPE              2
     C     KEYGL         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    TYPE
     C     KEYGL         CHAIN     FGLDF                              97
      *
     C     NXT           TAG
     C                   SETOFF                                       0102
     C                   READ      FMTRAN                                 90
     C   90              GOTO      END
      *
      * ALREADY UPDATED
      *
     C     MTGLUD        IFEQ      'Y'                                                      TED
     C     MTCOMP        ORNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     MTTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C                   Z-ADD     MTCOMP        CONO              2 0
     C                   Z-ADD     TDAT          TRNDAT            6 0
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
     C                   EXSR      GETGL
      * INVOICE
     C     MTTTYP        IFEQ      01
     C                   EXSR      INVOIC
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * PAYMENT  CASH OR CREDIT CARD
     C     MTTTYP        IFEQ      02
     C     MTTTYP        OREQ      10
     C                   EXSR      PYMNT
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * PAYMENT ON ACCOUNT
     C     MTTTYP        IFEQ      03
     C                   EXSR      ONACT
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * ADJUSTMENT
     C     MTTTYP        IFEQ      04
     C                   EXSR      ADJ
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * CREDIT MEMO
     C     MTTTYP        IFEQ      05
     C                   EXSR      CREDIT
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * NON-AR CASH
     C     MTTTYP        IFEQ      06
     C                   EXSR      NONAR
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * LATE CHARGE
     C     MTTTYP        IFEQ      07
     C                   EXSR      LATCHG
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * DISCOUNT
     C     MTTTYP        IFEQ      09
     C                   EXSR      DSCNT
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * DEPOSIT
     C     MTTTYP        IFEQ      11
     C                   EXSR      DEPOS
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * BOUNCED CHECK
     C     MTTTYP        IFEQ      12
     C                   EXSR      BNCCK
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      * BOUNCED CHECK CHARGE
     C     MTTTYP        IFEQ      14
     C                   EXSR      BNCCG
     C                   EXSR      UPTRAN
     C                   GOTO      NXT
     C                   END
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      **********
      * UMTRAN *
      **********
     C     UPTRAN        BEGSR
     C                   MOVEL     'Y'           MTGLUD
     C*                    Z-ADDTDATE     MTDTLA
     C*                    Z-ADDTIMOD     MTTIME
     C*                    MOVELUSERID    MTUSER
     C                   UPDATE    RMTRAN
     C                   ENDSR
      *                                                                ***
      *********
      * GETGL *
      *********
     C     GETGL         BEGSR
     C                   CLEAR                   RGLPRE
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     MTCOMP        GTCOMP
     C                   Z-ADD     MTTDAT        GTCYMD
     C                   Z-ADD     GTCYMD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         GTTDAT
     C*          LSRCE     IFEQ 'DOP'
     C*                    MOVEL'SLS'     GTSRCE
     C*                    MOVEL'DOP'     GTAPPL
     C*                    ELSE
     C*                    MOVEL'A/R'     GTSRCE
     C*                    MOVEL'A/R'     GTAPPL
     C*                    END
     C     MTTTYP        IFEQ      01
     C     MTTTYP        OREQ      05
     C                   MOVEL     'SLS'         GTSRCE
     C                   MOVEL     'DOP'         GTAPPL
     C                   ELSE
     C                   MOVEL     'A/R'         GTSRCE
     C                   MOVEL     'DOP'         GTAPPL
     C                   END
     C                   MOVEL     *BLANKS       GTPROD
     C                   MOVEL     *BLANKS       GTJEPR
     C                   Z-ADD     *ZEROS        GTJENM
     C                   Z-ADD     0             GTVEND
     C                   MOVEL     *BLANKS       GTJESF
     C**                   MOVELJEDS      GTJEDS
     C     #P            IFNE      99
     C                   MOVE      GTTDAT        ACTY              2 0
     C                   MOVEL     ACTY          ACTP              4 0
     C                   MOVE      #P            ACTP
     C                   ELSE
     C                   Z-ADD     9999          ACTP
     C                   END
     C                   MOVEL     ACTP          GTAPER
     C                   MOVEL     *BLANKS       GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C***                  MOVELAMTDES    GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   Z-ADD     TDATE         GTDTLA
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     MTSHFR        GTSHFR
     C                   ENDSR
      *
      **********
      * INVOICE TRANSACTION
      **********
     C     INVOIC        BEGSR
     C                   Z-ADD     MTINV#        INV#              6 0
      ** GET FREIGHT AND SPECIAL CHARGES
     C     INV#          CHAIN     FHORDW                             91
     C                   Z-ADD     MTFRT$        HLDFRT            9 2
     C                   Z-ADD     MTSPL$        HLDSPL            9 2
     C                   MOVEL     'I'           HLDTYP            1
     C     HLDFRT        IFNE      0
     C                   EXSR      FRT
     C                   END
     C     HLDSPL        IFNE      0
     C                   EXSR      SPL
     C                   END
      ** PUT OUT DISCOUNTS
     C                   MOVEL     INVS          GTJEDS
     C                   MOVEL     INVS          GTSRDS
      ** TRADE DISCOUNT
     C     MTDIS$        IFNE      0
     C                   Z-SUB     MTDIS$        GTDOL$
     C                   Z-ADD     GDTDSC        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      ** QUANTITY DISCOUNT
     C     MTQDIS        IFNE      0
     C                   Z-SUB     MTQDIS        GTDOL$
     C                   Z-ADD     GDVDSC        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      ** TAX AMOUNT
      * STATE
     C     MTAMT1        IFNE      0
     C                   Z-SUB     MTAMT1        GTDOL$
     C                   Z-ADD     GDSTTX        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      * COUNTY
     C     MTAMT2        IFNE      0
     C                   Z-SUB     MTAMT2        GTDOL$
     C                   Z-ADD     GDCOTX        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      * CITY
     C     MTAMT3        IFNE      0
     C                   Z-SUB     MTAMT3        GTDOL$
     C                   Z-ADD     GDCITX        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      ** TOTAL INVOICE
     C                   Z-ADD     GDARRC        GTACCT
     C                   Z-ADD     MT$AMT        GTDOL$
     C                   WRITE     RGLPRE
     C                   ENDSR
      *
      **********
      * BOUNCED CHECK CHARGE
      **********
     C     BNCCG         BEGSR
     C                   MOVEL     'B C Chg'     J7
     C                   MOVEL     PAYS          GTJEDS
     C                   MOVEL     PAYS          GTSRDS
      * A/R
     C                   Z-ADD     MTGLAC        GTACCT
     C                   Z-SUB     MT$AMT        GTDOL$
     C                   WRITE     RGLPRE
      ** TOTAL INVOICE
     C                   Z-ADD     GDARRC        GTACCT
     C                   Z-ADD     MT$AMT        GTDOL$
     C                   WRITE     RGLPRE
     C                   ENDSR
      **********
      * PAYMENT TRANSACTION
      **********
     C     PYMNT         BEGSR
     C                   MOVEL     PAYS          GTJEDS
     C     MTDESC        IFLE      *BLANKS
     C                   MOVEL     PAYS          GTSRDS
     C                   ELSE
     C                   MOVEL     MTDESC        GTSRDS
     C                   END
      ** CASH  DISCOUNT
     C     MTDISC        IFNE      0
     C                   Z-SUB     MTDISC        GTDOL$
     C                   Z-ADD     GDCDSC        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      ** CASH
     C     MT$AMT        IFNE      0
     C                   Z-SUB     MT$AMT        GTDOL$
     C     MTGLAC        IFGT      0
     C                   Z-ADD     MTGLAC        GTACCT
     C                   ELSE
     C                   Z-ADD     GDCASH        GTACCT
     C                   END
     C                   WRITE     RGLPRE
     C                   END
      * A/R
     C     MT$AMT        ADD       MTDISC        GTDOL$
     C                   Z-ADD     GDARRC        GTACCT
     C                   WRITE     RGLPRE
     C                   ENDSR
      **********
      * BOUNCED CHECK (REV PAYMENT - SAME AS PAYMENT ONLY J7 CHANGED
      *                REASON IS SIGN OF RECORD WILL MAKE REVERSED $
      **********
     C     BNCCK         BEGSR
     C                   MOVEL     'Bounced'     J7
     C                   MOVEL     PAYS          GTJEDS
     C     MTDESC        IFLE      *BLANKS
     C                   MOVEL     PAYS          GTSRDS
     C                   ELSE
     C                   MOVEL     MTDESC        GTSRDS
     C                   END
      * CASH  DISCOUNT
     C     MTDISC        IFNE      0
     C                   Z-SUB     MTDISC        GTDOL$
     C                   Z-ADD     GDCDSC        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      * CASH
     C                   Z-SUB     MT$AMT        GTDOL$
     C                   Z-ADD     GDCASH        GTACCT
     C                   WRITE     RGLPRE
      * A/R
     C     MT$AMT        ADD       MTDISC        GTDOL$
     C                   Z-ADD     GDARRC        GTACCT
     C                   WRITE     RGLPRE
     C                   ENDSR
      **********
      * DISCOUNT TRANSACTION
      **********
     C     DSCNT         BEGSR
     C                   MOVEL     PAYS          GTJEDS
     C     MTDESC        IFLE      *BLANKS
     C                   MOVEL     PAYS          GTSRDS
     C                   ELSE
     C                   MOVEL     MTDESC        GTSRDS
     C                   END
      ** CASH  DISCOUNT
     C     MTDISC        IFNE      0
     C                   Z-SUB     MTDISC        GTDOL$
     C                   Z-ADD     GDCDSC        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      ** CASH
     C*          MT$AMT    IFNE 0
     C*                    Z-SUBMT$AMT    GTDOL$
     C*          MTGLAC    IFGT 0
     C*                    Z-ADDMTGLAC    GTACCT
     C*                    ELSE
     C*                    Z-ADDGDCASH    GTACCT
     C*                    END
     C*                    WRITERGLPRE
     C*                    END
      * A/R
     C**         MT$AMT    ADD  MTDISC    GTDOL$
     C                   Z-ADD     MTDISC        GTDOL$
     C                   Z-ADD     GDARRC        GTACCT
     C                   WRITE     RGLPRE
     C                   ENDSR
      **********
      * PAYMENT ON ACCOUNT TRANSACTION
      **********
     C     ONACT         BEGSR
     C                   MOVEL     PAYS          GTJEDS
     C     MTDESC        IFLE      *BLANKS
     C                   MOVEL     PAYS          GTSRDS
     C                   ELSE
     C                   MOVEL     MTDESC        GTSRDS
     C                   END
      ** CASH
     C     MT$AMT        IFNE      0
     C                   Z-SUB     MT$AMT        GTDOL$
     C     MTGLAC        IFGT      0
     C                   Z-ADD     MTGLAC        GTACCT
     C                   ELSE
     C                   Z-ADD     GDCASH        GTACCT
     C                   END
     C                   WRITE     RGLPRE
     C                   END
      * A/R
     C                   Z-ADD     MT$AMT        GTDOL$
     C                   Z-ADD     GDARRC        GTACCT
     C                   WRITE     RGLPRE
     C                   ENDSR
      **********
      * ADJUSTMENT TRANSACTION
      **********
     C     ADJ           BEGSR
     C                   Z-ADD     MTCUST        ACUST
     C                   Z-ADD     MTINV#        AINV#
     C                   MOVEL     ADJS          GTJEDS
     C     MTDESC        IFLE      *BLANKS
     C                   MOVEL     ADJS          GTSRDS
     C                   ELSE
     C                   MOVEL     MTDESC        GTSRDS
     C                   END
      ** ADJUSTMENTS HAVE TWO RECORDS FOR EACH ADJ
     C     MT$AMT        IFNE      0
     C                   Z-ADD     MT$AMT        GTDOL$
     C     MTGLAC        IFGT      0
     C                   Z-ADD     MTGLAC        GTACCT
     C                   ELSE
     C                   Z-ADD     GDCASH        GTACCT
     C                   END
     C                   WRITE     RGLPRE
     C                   END
     C                   ENDSR
      *
      **********
      * CREDIT MEMO TRANSACTION
      **********
     C     CREDIT        BEGSR
     C                   Z-ADD     MTINV#        INV#              6 0
      * GET FREIGHT AND SPECIAL CHARGES
     C     INV#          CHAIN     FHORCW                             91
     C                   Z-ADD     MTFRT$        HLDFRT            9 2
     C                   Z-ADD     MTSPL$        HLDSPL            9 2
     C                   MOVEL     'C'           HLDTYP            1
     C     HLDFRT        IFNE      0
     C                   EXSR      FRT
     C                   END
     C     HLDSPL        IFNE      0
     C                   EXSR      SPL
     C                   END
      * PUT OUT DISCOUNTS
     C                   MOVEL     CRMS          GTJEDS
     C                   MOVEL     CRMS          GTSRDS
      * TRADE DISCOUNT
     C     MTDIS$        IFNE      0
     C                   Z-SUB     MTDIS$        GTDOL$
     C                   Z-ADD     GDTDSC        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      * QUANTITY DISCOUNT
     C     MTQDIS        IFNE      0
     C                   Z-SUB     MTQDIS        GTDOL$
     C                   Z-ADD     GDVDSC        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      * TAX AMOUNT
      * STATE
     C     MTAMT1        IFNE      0
     C                   Z-SUB     MTAMT1        GTDOL$
     C                   Z-ADD     GDSTTX        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      * COUNTY
     C     MTAMT2        IFNE      0
     C                   Z-SUB     MTAMT2        GTDOL$
     C                   Z-ADD     GDCOTX        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      * CITY
     C     MTAMT3        IFNE      0
     C                   Z-SUB     MTAMT3        GTDOL$
     C                   Z-ADD     GDCITX        GTACCT
     C                   WRITE     RGLPRE
     C                   END
      ** TOTAL INVOICE
     C                   Z-ADD     GDARRC        GTACCT
     C                   Z-ADD     MT$AMT        GTDOL$
     C                   WRITE     RGLPRE
     C                   ENDSR
      **********
      * NON-A/R TRANSACTION
      **********
     C     NONAR         BEGSR
     C                   MOVEL     MTCHEK        NCHEK
     C                   Z-ADD     MTCUST        NCUST
     C                   MOVEL     NONS          GTJEDS
     C     MTDESC        IFLE      *BLANKS
     C                   MOVEL     NONS          GTSRDS
     C                   ELSE
     C                   MOVEL     MTDESC        GTSRDS
     C                   END
      * NON-A/R HAS TWO RECORDS FOR EACH ENTRY
     C     MT$AMT        IFNE      0
     C                   Z-ADD     MT$AMT        GTDOL$
     C     MTGLAC        IFGT      0
     C                   Z-ADD     MTGLAC        GTACCT
     C                   ELSE
     C                   Z-ADD     GDCASH        GTACCT
     C                   END
     C                   WRITE     RGLPRE
     C                   END
     C                   ENDSR
      **********
      * LATE CHARGE
      **********
     C     LATCHG        BEGSR
     C                   Z-ADD     MTINV#        LINV#
     C                   Z-ADD     MTCUST        LCUST
     C                   MOVEL     LATS          GTJEDS
     C     MTDESC        IFLE      *BLANKS
     C                   MOVEL     LATS          GTSRDS
     C                   ELSE
     C                   MOVEL     MTDESC        GTSRDS
     C                   END
      * LATE CHARGE
     C     MT$AMT        IFNE      0
     C                   Z-SUB     MT$AMT        GTDOL$
     C     MTGLAC        IFGT      0
     C                   Z-ADD     MTGLAC        GTACCT
     C                   ELSE
     C                   Z-ADD     GDLCHG        GTACCT
     C                   END
     C                   WRITE     RGLPRE
     C                   END
      * A/R
     C                   Z-ADD     MT$AMT        GTDOL$
     C                   Z-ADD     GDARRC        GTACCT
     C                   WRITE     RGLPRE
     C                   ENDSR
      **********
      * DEPOSIT TRANSACTION
      **********
     C     DEPOS         BEGSR
      * CASH
     C     MT$AMT        IFNE      0
     C                   Z-SUB     MT$AMT        GTDOL$
     C     MTGLAC        IFGT      0
     C                   Z-ADD     MTGLAC        GTACCT
     C                   ELSE
     C                   Z-ADD     GDCASH        GTACCT
     C                   END
     C                   WRITE     RGLPRE
     C                   END
      * A/R
     C                   Z-ADD     MT$AMT        GTDOL$
     C                   Z-ADD     GDARRC        GTACCT
     C                   WRITE     RGLPRE
     C                   ENDSR
      *
      **********
      * GET FREIGHT AMOUNTS
      **********
     C     FRT           BEGSR
     C                   SETOFF                                       0105
     C                   Z-ADD     0             FRTAMT            9 2
     C                   Z-ADD     0             GTACCT
     C                   Z-ADD     0             GTDOL$
     C     MTSMFL        IFNE      'Y'
     C     HLDTYP        IFEQ      'I'
     C     INV#          SETLL     FIORDW
     C                   SETON                                        01
     C                   END
     C     HLDTYP        IFEQ      'C'
     C     INV#          SETLL     FIORCW
     C                   SETON                                        05
     C                   END
     C     NXTFRT        TAG
     C   01INV#          READE     FIORDW                                 92
     C   05INV#          READE     FIORCW                                 92
     C   92              GOTO      ENDFRT
     C   01WIITYP        IFNE      'F'
     C                   GOTO      NXTFRT
     C                   ELSE
     C                   Z-SUB     WIAMT         GTDOL$
     C                   SUB       WIAMT         HLDFRT
     C     WIGLNO        IFGT      0
     C                   Z-ADD     WIGLNO        GTACCT
     C                   ELSE
     C                   Z-ADD     GDFRGT        GTACCT
     C                   END
     C                   END
     C   05CIITYP        IFNE      'F'
     C                   GOTO      NXTFRT
     C                   ELSE
     C                   Z-SUB     CIEXT$        GTDOL$
     C                   SUB       CIEXT$        HLDFRT
     C     CIGLNO        IFGT      0
     C                   Z-ADD     CIGLNO        GTACCT
     C                   ELSE
     C                   Z-ADD     GDFRGT        GTACCT
     C                   END
     C                   END
     C   01              MOVEL     INVS          GTJEDS
     C   01              MOVEL     INVS          GTSRDS
     C   05              MOVEL     CRMS          GTJEDS
     C   05              MOVEL     CRMS          GTSRDS
     C                   WRITE     RGLPRE
     C                   GOTO      NXTFRT
     C                   ELSE                                                   SUMM INV
     C                   Z-ADD     GDFRGT        GTACCT
     C                   Z-SUB     MTFRT$        GTDOL$
     C                   Z-ADD     0             HLDFRT
     C   01              MOVEL     INVS          GTJEDS
     C   01              MOVEL     INVS          GTSRDS
     C   05              MOVEL     CRMS          GTJEDS
     C   05              MOVEL     CRMS          GTSRDS
     C                   WRITE     RGLPRE
     C                   END                                                    SUMM INV
     C     ENDFRT        TAG
     C     HLDFRT        IFNE      0
     C                   Z-ADD     GDFRGT        GTACCT
     C                   Z-SUB     HLDFRT        GTDOL$
     C   01              MOVEL     INVS          GTJEDS
     C   01              MOVEL     INVS          GTSRDS
     C   05              MOVEL     CRMS          GTJEDS
     C   05              MOVEL     CRMS          GTSRDS
     C                   WRITE     RGLPRE
     C                   END
     C                   Z-ADD     0             GTACCT
     C                   Z-ADD     0             GTDOL$
     C                   Z-ADD     0             CISEQ#
     C                   Z-ADD     0             WISEQ#
     C                   ENDSR
      **********
      * GET SPECIAL CHARGE AMOUNTS
      **********
     C     SPL           BEGSR
     C                   SETOFF                                       0105
     C                   Z-ADD     0             FRTAMT            9 2
     C                   Z-ADD     0             GTACCT
     C                   Z-ADD     0             GTDOL$
     C     MTSMFL        IFNE      'Y'
     C     HLDTYP        IFEQ      'I'
     C     INV#          SETLL     FIORDW
     C                   SETON                                        01
     C                   END
     C     HLDTYP        IFEQ      'C'
     C     INV#          SETLL     FIORCW
     C                   SETON                                        05
     C                   END
     C     NXTSPL        TAG
     C   01INV#          READE     FIORDW                                 92
     C   05INV#          READE     FIORCW                                 92
     C   92              GOTO      ENDSPL
     C   01WIITYP        IFNE      'S'
     C     WISPPT        OREQ      'Y'
     C                   GOTO      NXTSPL
     C                   ELSE
     C                   Z-SUB     WIAMT         GTDOL$
     C     WIGLNO        IFGT      0
     C                   Z-ADD     WIGLNO        GTACCT
     C                   ELSE
     C                   Z-ADD     GDSCHG        GTACCT
     C                   END
     C                   END
     C   05CIITYP        IFNE      'S'
     C                   GOTO      NXTSPL
     C                   ELSE
     C                   Z-SUB     CIEXT$        GTDOL$
     C     CIGLNO        IFGT      0
     C                   Z-ADD     CIGLNO        GTACCT
     C                   ELSE
     C                   Z-ADD     GDSCHG        GTACCT
     C                   END
     C                   END
     C   01              MOVEL     INVS          GTJEDS
     C   01              MOVEL     INVS          GTSRDS
     C   05              MOVEL     CRMS          GTJEDS
     C   05              MOVEL     CRMS          GTSRDS
     C                   WRITE     RGLPRE
     C   01              DO
     C                   MOVEL     'Y'           WISPPT
     C                   UPDATE    RIORDW
     C                   ENDDO
     C   05              DO
     C                   MOVEL     'Y'           CISPPT
     C                   UPDATE    RIORCW
     C                   ENDDO
     C                   GOTO      NXTSPL
     C                   ELSE                                                   SUMM INV
     C                   Z-ADD     GDSCHG        GTACCT
     C                   Z-SUB     MTSPL$        GTDOL$
     C                   Z-ADD     0             HLDSPL
     C   01              MOVEL     INVS          GTJEDS
     C   01              MOVEL     INVS          GTSRDS
     C   05              MOVEL     CRMS          GTJEDS
     C   05              MOVEL     CRMS          GTSRDS
     C                   WRITE     RGLPRE
     C                   END                                                    SUMM INV
     C     ENDSPL        TAG
     C                   Z-ADD     0             GTACCT
     C                   Z-ADD     0             GTDOL$
     C                   Z-ADD     0             CISEQ#
     C                   Z-ADD     0             WISEQ#
     C                   ENDSR
