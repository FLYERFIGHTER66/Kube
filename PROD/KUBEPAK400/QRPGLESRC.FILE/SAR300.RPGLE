      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.  215-642-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR300
      *SYSTEM-------------- ORDER ENTRY DAILY ORDER POST
      *APPLICATION--------- POST SALES AND COST OF SALES
      *
      *  POSTING TO GENERAL LEDGER DETAIL FILE FROM MONTHLY SALES FILE
      *             STOCK ITEMS:
      *             SALES POSTED
      *             NON-STOCK ITEMS:
      *             SALES, COST OF GOODS AND
      *                    NON-STOCK MERCHANDISE PURCHASES POSTED.
      *
      *    (NOTE: - BOTH INVOICE MERCHANDISE ITEMS AND CREDIT MEMO
      *             MERCHANDISE ITEMS PROCESSED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/12/01 EFD POST TOTAL SALES DOLLARS, DISCOUNTS TAKEN CARE OF
      *              IN MTRAN.     EFD01
      * 10/18/01 EFD REVERSE ABOVE FOR CREDITS
      *
     FFMSALEI   UF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFGLPRE    O  A E             DISK
     F*
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0
     D  LOKAY                  3      3
     D  LSLSJ                  4      4
     D  LSRCE                  5      7
      *
     D IDES            DS            30    OCCURS(1) INZ
     D  DTYP                   1      4    INZ
     D  MSINV#                 5     10  0 INZ
     D  J2                    11     15    INZ(' Seq ')
     D  MSSEQ#                16     18  0 INZ
     D  J3                    19     23    INZ(' Dte ')
     D  MSTDAT                24     30  0 INZ
      *
      *       ************************************
      *       *         PROGRAM MAINLINE         *
      *       ************************************
      *
      * NOTE  -  THIS PROGRAM CREATES G/L DETAIL FOR SALES
      *          FOR BOTH STOCK AND NON-STOCK MONTHLY SALES RECORDS
      *          AND FOR COST OF GOODS & NON-STOCK MERCHANIDSE PURCHASES
      *          FOR NON-STOCK ITEMS ONLY.
      *
      * OFFSET JOURNAL ENTRIES ARE CREATED IN TWO OTHER PROGRAMS       :
      * 1.  A/R, SPECIAL CHG, FRGT CHARGE AND TAXES FROM
      *     MTRAN IN PROGRAM ARR550 AND
      * 2.  COST OF GOODS SOLD AND MERCHANDISE PURCHASE
      *     FROM TINVT IN PROGRAM ICR510 (FOR STOCK ITEMS)
      *
      *
      * AT NEW INVENTORY ITEM NUMBER CHAIN TO INVENTORY MASTER
      * FOR SALES ACCOUNT
      *
     C     NXT           TAG
     C                   READ      FMSALEI                                90
     C   90              GOTO      END
      * CHECK UPDATE AND COMPANY
     C     MSGLUD        IFEQ      'Y'
     C     MSCOMP        ORNE      LCO
     C                   GOTO      NXT
     C                   END
      *
     C                   SETOFF                                       1112
     C                   SETOFF                                       2125
     C                   CLEAR                   RGLPRE
      *
      * DETERMINE IF STOCK OR NON-STOCK MERCHANDISE LINE ITEM
      * AND WHETHER INVOICE OR CREDIT MEMORANDUM
      *
     C     MSITYP        COMP      ' '                                    11
     C  N11MSITYP        COMP      'N'                                    12
     C  N11
     CANN12              GOTO      NXT
      *
     C     MSTTYP        COMP      01                                     21
     C  N21MSTTYP        COMP      05                                     25
     C  N21
     CANN25              GOTO      NXT
     C   21              MOVEL     'Inv  '       DTYP
     C   25              MOVEL     'Crm  '       DTYP
     C                   Z-ADD     MSTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
      ** GET GLPRE FIELDS
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     LCO           GTCOMP
     C                   MOVEL     IDES          GTSRDS
     C                   MOVEL     IDES          GTJEDS
     C                   Z-ADD     ##MDY         GTTDAT
     C                   MOVEL     'SLS'         GTSRCE
      *
      * GET YEAR/PERIOD FOR THE TRANSACTION
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     0             ACTPER            2 0
     C                   Z-ADD     0             BEGDAT            6 0
     C                   Z-ADD     0             ENDDAT            6 0
     C                   Z-ADD     0             BGCYMD            7 0
     C                   Z-ADD     0             ENCYMD            7 0
     C                   Z-ADD     GTTDAT        TRNDAT            6 0
     C                   Z-ADD     0             ERR               1 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   MOVE      BEGDAT        #Y                2 0
     C     ACTPER        IFNE      99
     C                   MOVEL     #Y            GTAPER
     C                   MOVE      ACTPER        GTAPER
     C                   ELSE
     C                   Z-ADD     9999          GTAPER
     C                   END
     C                   Z-ADD     TDATE         GTDTLA
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     MSSHFR        GTSHFR
     C                   Z-ADD     MSTDAT        GTCYMD
     C                   MOVEL     LSRCE         GTAPPL
      *
     C   11MSITEM        IFNE      OITEM
     C     MSSIZE        ORNE      OSIZE
     C     MSWHSE        ORNE      OWHSE
     C                   MOVE      GDSALE        OUTACT
     C     MINKEY        KLIST
     C                   KFLD                    MSITEM
     C                   KFLD                    MSSIZE
     C                   KFLD                    MSWHSE
     C     MINKEY        CHAIN     FMINVT                             22
     C  N22IMMERC        IFEQ      0
     C                   SETON                                        60
     C                   ENDIF
     C  N22
     CANN60              MOVE      IMMERC        OUTACT            8 0
     C                   MOVEL     MSITEM        OITEM            12
     C                   MOVEL     MSSIZE        OSIZE             3
     C                   MOVEL     MSWHSE        OWHSE             3
     C                   END
     C   12              MOVE      GDSALE        OUTACT
      *
      * PROCESS POSTING OF NON-STOCK MERCHANDISE LINE ITEMS
      * TO COST OF GOODS AND NON-STOCK MERCHANDISE PURCHASES ACCT      TS
      *
     C   11              GOTO      ARND
      *
     C     MSUCST        MULT      MSQSHP        TOTDOL           11 2
      *
     C                   Z-ADD     TOTDOL        GTDOL$
     C                   MOVE      GDCOGS        GTACCT
     C                   WRITE     RGLPRE
      *
     C                   MOVE      GDPUNS        GTACCT
     C                   Z-SUB     TOTDOL        GTDOL$
     C                   WRITE     RGLPRE
      *
     C     ARND          TAG
      *
      * POST SALES OF BOTH NON-STOCK AND STOCK MERCHANDISE
      * LINE ITEMS TO SALES ACCOUNT.  NON-STOCK ITEMS POSTED
      * TO DEFAULT SALES ACCOUNT, BUT
      * STOCK ITEMS ONLY POSTED TO DEFAULT SALES ACCOUNT
      * IF NO SPECIFIC SALES ACCOUNT IN INVENTORY MASTER
      * FOR PARTICULAR ITEM.
      *
      ** FOR CREDITS USE EXT AMT INVOICE USE CALC
EFD01C   25              Z-ADD     MSEXT$        TOTDOL
EFD01C  N25MSUPRI        MULT(H)   MSQSHP        TOTDOL
      *
     C                   Z-SUB     TOTDOL        GTDOL$
      *
     C     MSGSLS        IFLE      0
     C                   MOVE      OUTACT        GTACCT
     C                   ELSE
     C                   Z-ADD     MSGSLS        GTACCT
     C                   END
      *
     C                   WRITE     RGLPRE
      *
      * IN EITHER CASE, UPDATE MSALE RECORD WITH SALES ACCOUNT A       ND
      * 'Y' IN POSTED FIELD
      *
     C                   MOVEL     USERID        MSUSER
     C                   Z-ADD     TIMOD         MSTIME
     C                   Z-ADD     TDATE         MSDTLA
     C                   MOVEL     'Y'           MSGLUD
     C                   Z-ADD     GTACCT        MSGSLS
     C                   UPDATE    RMSALE
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCO           CHAIN     FGLDF                              90
     C                   ENDSR
      **
