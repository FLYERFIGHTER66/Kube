      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.  1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISESD INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR510
      *SYSTEM-------------- DAILY BILLING POST
      *APPLICATION--------- GENERAL LEDGER DETAIL RECORDS
      *DESCRIPTION--------- THIS PROGRAM CREATES GENERAL LEDGER
      *                     DETAIL TRANSACTIONS FROM
      *                     THE INVENTORY TRANSACTION FILE
      *                     FOR RECEIPTS, ADJUSTMENTS, TRANSFERS, AND
      *                     ISSUES.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFTINVTIS  UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFGLPRE    O  A E             DISK
      *
      *
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              DESCRIPTIONS
      *
      *
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
      *       ************************************
      *       *         PROGRAM MAINLINE         *
      *       ************************************
      *
      ******   NOTE  -  THIS PROGRAM CREATES G/L DETAIL FOR
      ******   INVENTORY TRANSACTIONS FROM INVENTORY TRANSACTION FILE.
      ******   AND FOR COST OF GOODS AND NON-STOCK MERCHANIDSE PURCHASES
      ******   FOR STOCK-ITEMS ONLY.
      *
     C     NXT           TAG
     C                   READ      FTINVTIS                               90
     C   90              GOTO      END
      ** CHECK FOR POSTED OR WRONG COMPANY
     C     ITGLUD        IFEQ      'Y'
     C     ITTCOM        ORNE      LCO
     C                   GOTO      NXT
     C                   END
      *
      * AT NEW INVENTORY ITEM NUMBER CHAIN TO MINVT FOR SALES ACCOUNT
      *
     C     ITITEM        IFNE      OITEM
     C     ITSIZE        ORNE      OSIZE
     C     ITTWSE        ORNE      OWHSE
     C     MINKEY        KLIST
     C                   KFLD                    ITITEM
     C                   KFLD                    ITSIZE
     C                   KFLD                    ITTWSE
     C                   Z-ADD     GDSALE        SAVSAL
     C                   Z-ADD     GDINVN        SAVINV
     C                   Z-ADD     GDCOGS        SAVCGS
     C     MINKEY        CHAIN     FMINVT                             22
      *
     C  N22              DO
     C     IMMERC        IFGT      0
     C                   Z-ADD     IMMERC        SAVSAL            8 0
     C                   END
     C     IMINVN        IFGT      0
     C                   Z-ADD     IMINVN        SAVINV            8 0
     C                   END
     C     IMCOGS        IFGT      0
     C                   Z-ADD     IMCOGS        SAVCGS            8 0
     C                   END
     C                   ENDDO                                                  N22 DO
     C                   MOVEL     ITITEM        OITEM
     C                   MOVEL     ITSIZE        OSIZE
     C                   MOVEL     ITTWSE        OWHSE
     C                   END
      *
      * SELECT PERIOD DATE FOR TRANSACTION
      *
     C                   Z-ADD     ITTDAT        TRNDAT
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     0             ACTPER
     C                   Z-ADD     0             BEGDAT            6 0
     C                   Z-ADD     0             ENDDAT            6 0
     C                   Z-ADD     0             BGCYMD            7 0
     C                   Z-ADD     0             ENCYMD            7 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
      * GET COMMON GLDET FIELDS
     C                   CLEAR                   RGLPRE
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     LCO           GTCOMP
     C                   Z-ADD     TDATE         GTDTLA
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     LSRCE         GTAPPL
     C                   MOVEL     'INV'         GTSRCE
     C                   Z-ADD     ITTDAT        GTTDAT
     C                   Z-ADD     ITYDAT        GTCYMD
     C     ACTPER        IFNE      99
     C                   MOVE      ITTDAT        #Y                2 0
     C                   MOVEL     #Y            GTAPER
     C                   MOVE      ACTPER        GTAPER
     C                   ELSE
     C                   Z-ADD     9999          GTAPER
     C                   END
      *
     C     ITDESC        COMP      *BLANKS                            818180
      *
      * DETERMINE TRANSACTION TYPE
      *
     C     ITTYPE        IFEQ      'P'
     C                   EXSR      TINUPD
     C                   GOTO      NXT
     C                   END
     C     ITTYPE        IFEQ      'R'
     C                   EXSR      SUBREC
     C                   EXSR      TINUPD
     C                   GOTO      NXT
     C                   END
     C     ITTYPE        IFEQ      'A'
     C                   EXSR      SUBADJ
     C                   EXSR      TINUPD
     C                   GOTO      NXT
     C                   END
     C     ITTYPE        IFEQ      'T'
     C                   EXSR      SUBTRN
     C                   EXSR      TINUPD
     C                   GOTO      NXT
     C                   END
     C     ITTYPE        IFEQ      'I'
     C                   EXSR      SUBISS
     C                   EXSR      TINUPD
     C                   GOTO      NXT
     C                   END
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *
      **********
      * SUBREC *
      **********
      * POST RECEIPT TO INVENTORY ACCOUNT
     C     SUBREC        BEGSR
     C                   MOVEL     MSG(1)        GTSRDS
     C   80              MOVEL     MSG(1)        GTJEDS
     C  N80              MOVEL     ITDESC        GTJEDS
     C     ITTQTY        MULT(H)   ITCOST        OUTDOL           11 2          NON CATCH WGT
     C**         ITLBS#    MULT ITCOST    OUTDOL           CATCH WGT.
     C                   Z-ADD     OUTDOL        GTDOL$
     C                   MOVE      SAVINV        GTACCT
     C                   WRITE     RGLPRE
      *
      * CREATE OFFSET TRANSACTION AGAINST PURCHASE EXPENSE
      * OR IF RECEIPT AGAINST CREDIT MEMO.
      *
     C     ITCMRC        COMP      'Y'                                    36
     C   36              MOVE      SAVCGS        GTACCT
     C  N36              MOVE      GDAPEX        GTACCT
     C                   Z-SUB     OUTDOL        GTDOL$
     C                   WRITE     RGLPRE                                       WRITE GLDET
     C                   ENDSR
      *
      **********
      * SUBADJ *
      **********
     C     SUBADJ        BEGSR
      * POST ADJUSTMENT TO INVENTORY ADJUSTMENTS ACCOUNT
     C     ITTREF        COMP      *BLANKS                            818180
     C                   MOVEL     MSG(2)        GTSRDS
     C   80              MOVEL     MSG(2)        GTJEDS
     C  N80              MOVEL     ITTREF        GTJEDS
      *  CASH ONLY ADJ
     C     ITCFLG        IFEQ      'Y'
     C                   Z-ADD     ITCOST        OUTDOL
     C                   ELSE
     C     ITTQTY        MULT(H)   ITCOAV        OUTDOL                         NON CATCH WGT
     C** 25      ITLBS#    MULT ITCOAV    OUTDOL    H      CATCH WEIGHT
     C                   END
     C                   Z-ADD     OUTDOL        GTDOL$
     C                   MOVE      SAVINV        GTACCT
     C                   WRITE     RGLPRE                                       WRITE GLDET
      *
      * CREATE OFFSET TRANSACTION AGAINST ADJUSTMENTS ACCOUNT
     C                   MOVE      GDINAJ        GTACCT
     C                   Z-SUB     OUTDOL        GTDOL$
     C                   WRITE     RGLPRE                                       WRITE GLDET
     C                   ENDSR
      *
      **********
      * SUBTRN *
      **********
     C     SUBTRN        BEGSR
      *
      * POST INV. ADD OR SUBTRACT TRANSFER AMOUNT TO COMPANY
      * OFFSET TRANSACTION WILL BE POSTED BY SEPARATE RECORD
      * FOR COMPANY TO WHICH TRANSFER MADE
     C                   MOVEL     MSG(3)        GTSRDS
     C   80              MOVEL     MSG(3)        GTJEDS
     C  N80              MOVEL     ITDESC        GTJEDS
     C     ITTQTY        MULT(H)   ITCOAV        OUTDOL                         NON CATCH WGT
     C** 25      ITLBS#    MULT ITCOAV    OUTDOL    H      CATCH WEIGHT
     C                   Z-ADD     OUTDOL        GTDOL$
     C                   MOVE      SAVINV        GTACCT
     C                   WRITE     RGLPRE                                       WRITE GLDET
      *
     C                   ENDSR
      *
      **********
      * SUBISS *
      **********
     C     SUBISS        BEGSR
      * POST ISSUE TRANSACTION TO COST OF GOODS
     C                   MOVEL     MSG(4)        GTSRDS
     C   80              MOVEL     MSG(4)        GTJEDS
     C  N80              MOVEL     ITDESC        GTJEDS
     C     ITTQTY        MULT(H)   ITCOAV        OUTDOL                         NON CATCH WGT
     C** 25      ITLBS#    MULT ITCOAV    OUTDOL    H      CATCH WEIGHT
     C                   MOVE      SAVCGS        GTACCT
     C                   Z-ADD     OUTDOL        GTDOL$
     C                   WRITE     RGLPRE                                       WRITE GLDET
      *            CREATE POST OFFSET TRANSACTION TO INVENTORY
     C                   MOVE      SAVINV        GTACCT
     C                   Z-SUB     OUTDOL        GTDOL$
     C                   WRITE     RGLPRE                                       WRITE GLDET
     C     EISS          ENDSR
      ***********************
      ** UPDATE TINVT      **
      ***********************
     C     TINUPD        BEGSR
     C                   MOVEL     'Y'           ITGLUD
     C                   UPDATE    RTINVT
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      *BLANKS       OITEM            12
     C                   MOVE      *BLANKS       OSIZE             3
     C                   MOVE      *BLANKS       OWHSE             3
     C     LCO           CHAIN     FGLDF                              77
     C                   ENDSR
** DISPLAY MESSAGE
Inventory Receipt
Inventory Adjustment
Inventory Transfer
Inventory Issue
