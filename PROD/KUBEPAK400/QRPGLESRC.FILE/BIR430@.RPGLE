      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.      ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR430
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- UPDATE MONTHLY TRANSACTIONS AND A/R OPEN
      *                     AND CUSTOMER MASTER
      *DESCRIPTION--------- DELETE FARWRK FILE AFTER UPDATING THE
      *                     OTHER FILES.  UPDATE CUSTOMER MASTER WITH
      *                     NEW A/R BALANCE DUE AND NEW VALUE OF OPEN
      *                     ORDERS. OUTPUT THE MONTHLY TRANSACTION
      *                     FILE.
      *
      *     INPUT TYPES - 01 INVOICES     - UNPAID
      *                                   - PAID BY CASH
      *                                   - PAID BY CREDIT CARD
      *                   05 CREDITS      - GENERAL
      *                                   - SPECIFIC INVOICE
      *
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARWRKA   UP   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCUST    UF   E           K DISK
     FFARHST    UF A E           K DISK
     FFMTRAN    UF A E           K DISK
     FFAROPN    UF A E           K DISK
     FFGLDF     IF   E           K DISK
     FFMBANK    IF   E           K DISK
     FBIR430    O    F  120        PRINTER OFLIND(*INOF)
     D*
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
     D                UDS
     D  LCO                    1      2  0
      *
     IRARWRK
     I              ATCUST                      ATCUST        L1
      *
      *
     C     K0AROP        KLIST
     C                   KFLD                    ATCUST
     C                   KFLD                    ATINV#
     C                   KFLD                    SUFF             02
     C                   KFLD                    SEQ#             03 0
     C     K1AROP        KLIST
     C                   KFLD                    ATCUST
     C                   KFLD                    ATORD#
     C                   KFLD                    SUFF             02
     C                   KFLD                    SEQ#             03 0
     C     K2AROP        KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C                   KFLD                    ZERO             03 0
     C     K3AROP        KLIST
     C                   KFLD                    ATCUST
     C                   KFLD                    ATINV#
     C                   KFLD                    SUFF02           02
     C                   KFLD                    SEQ#02           03 0
     C     K4AROP        KLIST
     C                   KFLD                    ATCUST
     C                   KFLD                    ATORD#
     C                   KFLD                    SUFF03           02
     C                   KFLD                    SEQ#03           03 0
     C     K5AROP        KLIST
     C                   KFLD                    ATCUST
     C                   KFLD                    REF#             06 0
     C                   KFLD                    SUFF
      *
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      '1'           *IN99
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    TDATE
     C                   PARM                    TDATEX           07 0
     C                   PARM      'N'           RETC             01
     C     LCO           CHAIN     FMCORG                             90
     C     *IN90         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   GOTO      END
     C                   END
     C     LCO           CHAIN     FGLDF                              90
     C     *IN90         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   GOTO      END
     C                   END
     C                   END
      *
     C     ATCOMP        IFNE      LCO                                          ONLY RUN FOR
     C                   GOTO      END                                          ONE COMPANY
     C                   END                                                    AT A TIME
      *
      *
     C     ATSTAT        IFEQ      'D'                                          DELETED RECORD
     C                   GOTO      END
     C                   END
      *
      *
     C*  TEST FOR VALID INPUT RECORD TYPE
     C     ATTTYP        IFNE      01
EFD  C     ATTTYP        ANDNE     05
     C                   EXSR      ERR                                          INVALID RECORD TYPE
     C                   EXCEPT    DET020
     C                   EXSR      HED
     C                   GOTO      END
     C                   END
      *
     C*  TEST FOR VALID BANK CODE
     C     ATINAP        IFNE      *ZEROS                                       IF PAYMENT
     C     ATBANK        CHAIN     FMBANK                             50        CHECK BANK NUMBER
     C     *IN50         IFEQ      '1'
     C                   EXSR      ERR                                          INVALID BANK CODE
     C                   EXCEPT    DET050
     C                   EXSR      HED
     C                   GOTO      END
     C                   END
     C                   END
      *
      * TEST FOR DUPLICATE INVOICE/CREDIT NUMBER
     C     ATSEQ#        IFLE      0
     C                   MOVE      *BLANKS       SUFF
     C                   Z-ADD     *ZEROS        SEQ#
     C     K0AROP        CHAIN(N)  FAROPN                             50
     C     *IN50         IFEQ      '0'
     C                   EXSR      ERR                                          THIS IS A DUPLICATE
     C                   EXCEPT    DET040
     C                   EXSR      HED
     C                   GOTO      END
     C                   END
     C                   Z-ADD     01            ATSEQ#                         FOR 1ST PAYMENT
     C                   END
      **
      **
EFD  C*                    CALL '@DT@A1'
EFD  C*                    PARM           ATDUDT
EFD  C*                    PARM           DUDT   070
EFD  C*                    PARM 'N'       RETC
EFD  C                   Z-ADD     ATDUDT        DUDT             07 0
      *
      * FIND THE PROPER PAYMENT NUMBER OF > 1 PAYMENT
     C     ATSEQ#        IFGT      *ZEROS
     C                   MOVE      *BLANKS       SUFF
     C                   Z-ADD     ATSEQ#        SEQ#
     C     RETRY1        TAG
     C     K0AROP        CHAIN     FAROPN                             50
     C     *IN50         IFEQ      '0'
     C                   ADD       1             SEQ#
     C                   GOTO      RETRY1
     C                   END                                                    SEQ # TO BE USED
     C                   Z-ADD     SEQ#          ATSEQ#                         FOR > 1ST PAYMENT
     C                   END
      *
     C                   MOVE      'N'           REJ
      *
      * GET DOWN PAYMENT FOR AN INVOICE
     C                   Z-ADD     *ZEROS        DOWN             11 2
     C     ATTTYP        IFEQ      01                                           INVOICE RECORD
     C     ATDEP         IFEQ      'Y'                                          WITH A DOWN PAYMENT
     C                   MOVE      'DP'          SUFF
     C                   Z-ADD     *ZEROS        SEQ#
     C     K1AROP        CHAIN(N)  FAROPN                             50
     C     *IN50         IFEQ      '1'
     C                   Z-ADD     *ZEROS        ARDUE$                         DOWN PAYMENT FROM A/
     C                   EXSR      ERR                                          NO DOWN PAYMENT REC
     C                   EXCEPT    DET030
     C                   EXSR      HED
     C                   END
     C                   Z-ADD     ARDUE$        DOWN
     C                   END
     C                   END
      *
     C                   EXSR      GETC                                         UPDATE CUST MAST
     C     REJ           IFEQ      'Y'
     C                   GOTO      END
     C                   END
      *
     C                   EXSR      GETH                                         UPDATE HST
      *
      * INVOICE AND PAYMENT ON FIRST RECORD
     C     ATSEQ#        IFEQ      01
     C     ATINAP        IFEQ      *ZEROS                                       NO PAYMENT
     C                   EXSR      GETA                                         OUTPUT AROPN INV/CRD
     C                   EXSR      GETM                                         OUTPUT MTRAN INV/CRD
     C                   END
     C     ATINAP        IFNE      *ZEROS                                       PAYMENT
     C                   ADD       ATINAP        ARPAID
     C     AT$AMT        ADD       ARPAID        ARDUE$
     C                   EXSR      GETA                                         OUTPUT AROPN INV/CRD
     C                   EXSR      GETM                                         OUTPUT MTRAN INV/CRD
     C                   EXSR      GETAP                                        OUTPUT AROPN INV/CRD
     C                   EXSR      GETMP                                        OUTPUT MTRAN IF PAID
     C                   EXSR      GETAPR                                       UPDATE AROPN INV/CRD
     C                   END
     C                   END
      *
      * PAYMENT ON ADDITIONAL RECORD
     C     ATSEQ#        IFGT      01
     C     ATINAP        ANDNE     *ZEROS
     C                   MOVE      *BLANKS       SUFF
     C                   Z-ADD     *ZEROS        SEQ#
     C     K0AROP        CHAIN     FAROPN                             50
     C                   SUB       ATINAP        ARPAID
     C                   ADD       ATINAP        ARDUE$
     C                   UPDATE    RAROPN                                       UPDATE HEADER RECORD
     C                   EXSR      GETAP                                        OUTPUT AROPN IF PAID
     C                   EXSR      GETMP                                        OUTPUT MTRAN IF PAID
     C                   EXSR      GETAPR                                       UPDATE AROPN INV/CRD
     C                   END
      *
      *
     C                   DELETE    RARWRK                                       DELETE WORK RECORD
      *
      *
     C     DOWN          IFNE      *ZEROS                                       SPREAD DOWN PAYMENT
      *
     C                   MOVE      'Y'           OKFINE           01
     C                   EXSR      DOWN1                                        TEST FOR BOTH RECORD
     C     OKFINE        IFNE      'Y'
     C                   GOTO      END
     C                   END
      *
     C                   EXSR      DOWN2                                        SPREAD PAYMENT
     C                   EXSR      DOWN3                                        SPREAD PAYMENT
      *
     C                   END
      *
      *
     C     END           TAG                                                    FOR REJECTED RECORDS
      *
     CL1                 EXSR      GETL1                                        DO SUMMARY CALCS
      *
      **************************************************************************
      * CUSTTOMER RECORD
     CSR   GETC          BEGSR
      *
     C     ATCUST        CHAIN     FMCUST                             90
     C     *IN90         IFEQ      '1'
     C                   EXSR      ERR
     C                   EXCEPT    DET010
     C                   EXSR      HED
     C                   MOVE      'Y'           REJ              01
     C                   GOTO      GETCED
     C                   END
      *
     C                   SUB       AT$AMT        CMVOPO                         AMT OF INV-VAL OPN O
     C                   Z-ADD     ATTDAT        CMDTLS                         TRANS DATE-DT LAST S
     C                   Z-ADD     TDATEX        CMDTLA                         UDATE     -LAST ACT
     C                   MOVEL     USERID        CMUSER                         USER ID   -LAST USER
     C                   Z-ADD     TIMOD         CMTIME                         TIME      -TIME
     C                   UPDATE    RMCUST
      *
     CSR   GETCED        ENDSR
      *
      **************************************************************************
      * HST RECORD
     CSR   GETH          BEGSR
      *
     C     ATCUST        CHAIN     FARHST                             90
      *
     C     *IN90         IFEQ      '1'
     C                   CLEAR                   RARHST
     C                   MOVEL     'A'           HSSTAT                         STATUS
     C                   Z-ADD     ATCUST        HSCUST                         CUST #
     C                   END
      *
     C                   Z-ADD     ATTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C     HSDTFS        IFEQ      0
     C                   Z-ADD     TDAT          HSDTFS                         FIRST SALE
     C                   END
      *
     C     ATCRC#        IFGT      *ZEROS                                       CC # WORK
     C     HSCRC#        ANDEQ     *ZEROS                                       CC # HST
     C                   Z-ADD     ATCRC#        HSCRC#
     C                   Z-ADD     ATCRCE        HSCRDT
     C                   MOVE      ATCRCD        HSCRCD
     C                   END
      *
     C     ATCRC#        IFGT      *ZEROS                                       CC # WORK
     C     ATCRCD        ANDEQ     HSCRCD                                       CODE WRK EQ HST
     C     ATCRC#        ANDEQ     HSCRC#                                       CC # WRK EQ HST
     C     ATCRCE        ANDNE     HSCRDT                                       EXP  WRK NE HST
     C                   Z-ADD     ATCRCE        HSCRDT
     C                   END
      *
     C                   Z-ADD     TDAT          HSDTLS                         DATE LAST SALE
     C                   Z-ADD     AT$AMT        HSAMLS                         AMT LAST SALE
     C                   ADD       1             HS#INV                         YTD INVOICES
      *
     C     *IN90         IFEQ      '1'
     C                   WRITE     RARHST
     C                   ELSE
     C                   UPDATE    RARHST
     C                   END
      *
     CSR                 ENDSR
      *
      **************************************************************************
      * INVOICE RECORD / AROPN
     CSR   GETA          BEGSR
     C                   MOVEL     'A'           ARSTAT
     C                   Z-ADD     ATCUST        ARCUST
     C                   Z-ADD     ATINV#        ARINV#
     C                   MOVEL     ATSUFF        ARSUFF
     C                   Z-ADD     *ZEROS        ARSEQ#
     C                   MOVEL     ATCTYP        ARCTYP
     C                   MOVEL     ATSLM1        ARSLM1
     C                   Z-ADD     ATCOM1        ARCOM1
     C                   MOVEL     ATSLM2        ARSLM2
     C                   Z-ADD     ATCOM2        ARCOM2
     C                   MOVEL     ATTERR        ARTERR
     C                   Z-ADD     ATCOMP        ARCOMP
     C                   Z-ADD     ATTTYP        ARTTYP
     C                   Z-ADD     ATTDAT        ARTDAT
     C                   Z-ADD     DUDT          ARDUDT
     C                   Z-ADD     GDARRC        ARGLAC
     C                   Z-ADD     ATDCDT        ARDCDT
     C                   Z-ADD     ATORD#        ARORD#
     C                   Z-ADD     ATDISC        ARDISC
     C                   Z-ADD     ATSHCU        ARSHCU
     C                   Z-ADD     ATSACU        ARSACU
     C                   Z-ADD     ATBLCU        ARBLCU
     C                   MOVEL     CMLOOK        ARLOOK
     C                   MOVEL     ATPONO        ARPONO
     C*                    MOVELATPOS     ARPOSC
     C                   MOVEL     ATPOS         ARPOS
     C*                    MOVELATCSAJ    ARCSAJ
     C                   MOVEL     ATSHFR        ARSHFR
     C                   MOVE      *BLANKS       ARCHEK
     C                   Z-ADD     *ZEROS        ARCKDT
     C                   MOVE      *BLANKS       ARDESC
     C                   Z-ADD     TDATE         ARDTLA
     C                   Z-ADD     TIMOD         ARTIME
     C                   MOVEL     USERID        ARUSER
     C                   MOVE      *BLANKS       ARCRCD
     C                   Z-ADD     *ZEROS        ARCRC#
     C                   Z-ADD     *ZEROS        ARCRCE
     C                   MOVE      *BLANKS       ARCRCA
     C                   Z-ADD     ATSHP#        ARSHP#
     C                   MOVEL     ATREAS        ARREAS
     C                   MOVEL     ATTAXJ        ARTAXJ
     C                   Z-ADD     AT$AMT        AR$AMT
     C                   Z-ADD     AT$AMT        ARDUE$
     C                   Z-ADD     *ZEROS        ARADJ$
     C**
     C                   WRITE     RAROPN                                       INVOICE/CREDIT
     C**
     CSR                 ENDSR
      *
      **************************************************************************
      * PAYMENT RECORD / AROPN
     CSR   GETAP         BEGSR
     C                   MOVEL     'A'           ARSTAT
     C                   Z-ADD     ATCUST        ARCUST
     C                   Z-ADD     ATINV#        ARINV#
     C                   MOVEL     ATSUFF        ARSUFF
     C                   Z-ADD     ATSEQ#        ARSEQ#
     C                   MOVEL     ATCTYP        ARCTYP
     C                   MOVEL     ATSLM1        ARSLM1
     C                   Z-ADD     ATCOM1        ARCOM1
     C                   MOVEL     ATSLM2        ARSLM2
     C                   Z-ADD     ATCOM2        ARCOM2
     C                   MOVEL     ATTERR        ARTERR
     C                   Z-ADD     ATCOMP        ARCOMP
     C     ATCKNO        IFNE      *BLANKS
     C                   Z-ADD     02            ARTTYP
     C                   END
     C     ATCRC#        IFGT      *ZEROS
     C                   Z-ADD     10            ARTTYP
     C                   END
     C                   Z-ADD     ATTDAT        ARTDAT
     C                   Z-ADD     DUDT          ARDUDT
     C                   Z-ADD     BAGLNO        ARGLAC
     C                   Z-ADD     ATDCDT        ARDCDT
     C                   Z-ADD     ATORD#        ARORD#
     C                   Z-ADD     *ZEROS        ARDISC
     C                   Z-ADD     ATSHCU        ARSHCU
     C                   Z-ADD     ATSACU        ARSACU
     C                   Z-ADD     ATBLCU        ARBLCU
     C                   MOVEL     CMLOOK        ARLOOK
     C                   MOVEL     ATPONO        ARPONO
     C*                    MOVELATPOS     ARPOSC
     C                   MOVEL     ATPOS         ARPOS
     C*                    MOVELATCSAJ    ARCSAJ
     C                   MOVEL     ATSHFR        ARSHFR
     C                   MOVE      ATCKNO        ARCHEK
     C                   Z-ADD     *ZEROS        ARCKDT
     C                   MOVE      *BLANKS       ARDESC
     C                   Z-ADD     TDATEX        ARDTLA
     C                   Z-ADD     TIMOD         ARTIME
     C                   MOVEL     USERID        ARUSER
     C                   MOVEL     ATCRCD        ARCRCD
     C                   Z-ADD     ATCRC#        ARCRC#
     C                   Z-ADD     ATCRCE        ARCRCE
     C                   MOVEL     ATCRCA        ARCRCA
     C                   Z-ADD     ATSHP#        ARSHP#
     C                   MOVEL     ATREAS        ARREAS
     C                   MOVEL     ATTAXJ        ARTAXJ
     C                   Z-ADD     *ZEROS        ARPAID
     C                   Z-ADD     *ZEROS        ARDUE$
     C                   Z-ADD     ATINAP        AR$AMT
     C**
     C                   WRITE     RAROPN                                       INVOICE/CREDIT
     C**
     C**
     CSR                 ENDSR
      *
     CSR   GETAPR        BEGSR
FIX  C     K2AROP        CHAIN     FAROPN                             50
FIX  C                   ADD       ATINAP        ARPAID
FIX  C                   ADD       ATINAP        ARDUE$
FIX  C                   UPDATE    RAROPN
     CSR                 ENDSR
      *
      *
      **************************************************************************
      * INVOICE RECORD / MTRAN
     CSR   GETM          BEGSR
     C                   MOVEL     'A'           MTSTAT
     C                   Z-ADD     ATCUST        MTCUST
     C                   Z-ADD     ATINV#        MTINV#
     C                   MOVEL     ATSUFF        MTSUFF
     C                   Z-ADD     *ZEROS        MTSEQ#
     C                   MOVEL     ATCTYP        MTCTYP
     C                   MOVEL     ATSLM1        MTSLM1
     C                   Z-ADD     ATCOM1        MTCOM1
     C                   MOVEL     ATSLM2        MTSLM2
     C                   Z-ADD     ATCOM2        MTCOM2
     C                   MOVEL     ATTERR        MTTERR
     C                   Z-ADD     ATCOMP        MTCOMP
     C                   Z-ADD     ATTTYP        MTTTYP
     C                   Z-ADD     ATTDAT        MTTDAT
     C                   Z-ADD     DUDT          MTDUDT
     C                   Z-ADD     AT$AMT        MT$AMT
     C                   Z-ADD     ATDIS$        MTDIS$
     C                   Z-ADD     ATQDI$        MTQDIS
     C                   Z-ADD     ATFRT$        MTFRT$
     C                   Z-ADD     ATSPL$        MTSPL$
     C                   Z-ADD     ATAMT1        MTAMT1
     C                   Z-ADD     ATAMT2        MTAMT2
     C                   Z-ADD     ATAMT3        MTAMT3
     C                   Z-ADD     ATMER$        MTMER$
     C                   Z-ADD     GDARRC        MTGLAC
     C                   MOVEL     ' '           MTGLAR
     C                   MOVEL     ' '           MTGLUD
     C                   Z-ADD     0             MTO30$
     C                   Z-ADD     ATDCDT        MTDCDT
     C                   Z-ADD     ATORD#        MTORD#
     C                   Z-ADD     ATDISC        MTDISC
     C                   Z-ADD     ATSHCU        MTSHCU
     C                   Z-ADD     ATSACU        MTSACU
     C                   Z-ADD     ATBLCU        MTBLCU
     C                   MOVEL     CMLOOK        MTLOOK
     C                   MOVEL     ATPONO        MTPONO
     C                   MOVEL     ATPOS         MTPOSC
     C                   MOVEL     ATPOS         MTPOS
     C                   MOVEL     *BLANKS       MTCSAJ
     C                   MOVEL     ATSHFR        MTSHFR
     C                   MOVE      *BLANKS       MTCHEK
     C                   Z-ADD     *ZEROS        MTCKDT
     C                   MOVE      *BLANKS       MTDESC
     C                   Z-ADD     TDATEX        MTDTLA
     C                   Z-ADD     TIMOD         MTTIME
     C                   MOVEL     USERID        MTUSER
     C                   MOVE      *BLANKS       MTCRCD
     C                   Z-ADD     *ZEROS        MTCRC#
     C                   Z-ADD     *ZEROS        MTCRCE
     C                   MOVE      *BLANKS       MTCRCA
     C                   Z-ADD     ATSHP#        MTSHP#
     C                   MOVEL     ATREAS        MTREAS
     C                   MOVEL     ATTAXJ        MTTAXJ
     C**
     C                   WRITE     RMTRAN                                       INVOICE/CREDIT
     C**
     CSR                 ENDSR
      *
      **************************************************************************
      * PAYMENT RECORD / MTRAN
     CSR   GETMP         BEGSR
     C                   MOVEL     'A'           MTSTAT
     C                   Z-ADD     ATCUST        MTCUST
     C                   Z-ADD     ATINV#        MTINV#
     C                   MOVEL     ATSUFF        MTSUFF
     C                   Z-ADD     ATSEQ#        MTSEQ#
     C                   MOVEL     ATCTYP        MTCTYP
     C                   MOVEL     ATSLM1        MTSLM1
     C                   Z-ADD     ATCOM1        MTCOM1
     C                   MOVEL     ATSLM2        MTSLM2
     C                   Z-ADD     ATCOM2        MTCOM2
     C                   MOVEL     ATTERR        MTTERR
     C                   Z-ADD     ATCOMP        MTCOMP
     C     ATCRCD        IFEQ      *ZEROS
     C                   Z-ADD     02            MTTTYP
     C                   ELSE
     C                   Z-ADD     10            MTTTYP
     C                   END
     C                   Z-ADD     ATTDAT        MTTDAT
     C                   Z-ADD     DUDT          MTDUDT
     C                   Z-ADD     *ZEROS        MTDIS$
     C                   Z-ADD     *ZEROS        MTQDIS
     C                   Z-ADD     *ZEROS        MTFRT$
     C                   Z-ADD     *ZEROS        MTSPL$
     C                   Z-ADD     *ZEROS        MTAMT1
     C                   Z-ADD     *ZEROS        MTAMT2
     C                   Z-ADD     *ZEROS        MTAMT3
     C                   Z-ADD     *ZEROS        MTMER$
     C                   Z-ADD     BAGLNO        MTGLAC
     C                   MOVEL     ' '           MTGLAR
     C                   MOVEL     ' '           MTGLUD
     C                   Z-ADD     *ZEROS        MTO30$
     C                   Z-ADD     ATDCDT        MTDCDT
     C                   Z-ADD     ATORD#        MTORD#
     C                   Z-ADD     *ZEROS        MTDISC
     C                   Z-ADD     ATSHCU        MTSHCU
     C                   Z-ADD     ATSACU        MTSACU
     C                   Z-ADD     ATBLCU        MTBLCU
     C                   MOVEL     CMLOOK        MTLOOK
     C                   MOVEL     ATPONO        MTPONO
     C                   MOVEL     ATPOS         MTPOSC
     C                   MOVEL     ATPOS         MTPOS
     C                   MOVEL     *BLANKS       MTCSAJ
     C                   MOVEL     ATSHFR        MTSHFR
     C                   MOVE      ATCKNO        MTCHEK
     C                   Z-ADD     *ZEROS        MTCKDT
     C                   MOVE      *BLANKS       MTDESC
     C                   Z-ADD     TDATEX        MTDTLA
     C                   Z-ADD     TIMOD         MTTIME
     C                   MOVEL     USERID        MTUSER
     C                   MOVEL     ATCRCD        MTCRCD
     C                   Z-ADD     ATCRC#        MTCRC#
     C                   Z-ADD     ATCRCE        MTCRCE
     C                   MOVEL     ATCRCA        MTCRCA
     C                   Z-ADD     ATSHP#        MTSHP#
     C                   MOVEL     ATREAS        MTREAS
     C                   MOVEL     ATTAXJ        MTTAXJ
     C                   Z-ADD     AR$AMT        MT$AMT
     C**
     C                   WRITE     RMTRAN                                       INVOICE/CREDIT
     C**
     CSR                 ENDSR
      *
      *
     CSR   GETL1         BEGSR
     C                   Z-ADD     LCO           MTCOMP
     C     ATCUST        CHAIN(N)  FMCUST                             90
     C                   CALL      'GETCARBL'
     C                   PARM                    MTCOMP
     C                   PARM                    ATCUST
     C                   PARM                    CMARB$
     C                   PARM                    CMCUR$
     C                   PARM                    CMAR1$
     C                   PARM                    CMAR2$
     C                   PARM                    CMAR3$
     C                   PARM                    CMAR4$
     C                   PARM                    CMFUT$
     C*                    UPDATRMCUST
      *
     C     ATCUST        CHAIN     FARHST                             90
      *
     C     CMARB$        IFGT      HSHARB
     C                   Z-ADD     CMARB$        HSHARB                         HIGHEST BALANCE
     C                   Z-ADD     ATTDAT        HSDTAR                         DATE OF HIGHEST BAL
     C                   END
     CSR                 ENDSR
      *
      *  TEST TO SEE THAT THE RECORDS ARE THERE AND ARE NOT EQ TO ZERO
     CSR   DOWN1         BEGSR
     C*          K3AROP    KLIST
     C*                    KFLD           ATCUST
     C*                    KFLD           ATINV#
     C*                    KFLD           SUFF02 02
     C*                    KFLD           SEQ#02 030
     C                   MOVE      *BLANKS       SUFF02
     C                   Z-ADD     *ZEROS        SEQ#02
     C     K3AROP        CHAIN     FAROPN                             50
     C     *IN50         IFEQ      '1'
     C                   MOVE      'N'           OKFINE
     C                   GOTO      DOWN1X
     C                   END
     C     ARDUE$        IFEQ      *ZEROS
     C                   MOVE      'N'           OKFINE
     C                   GOTO      DOWN1X
     C                   END
     C                   Z-ADD     ARDUE$        PAYINV           11 2
     C*          K4AROP    KLIST
     C*                    KFLD           ATCUST
     C*                    KFLD           ATORD#
     C*                    KFLD           SUFF03 02
     C*                    KFLD           SEQ#03 030
     C                   MOVE      'DP'          SUFF03
     C                   Z-ADD     *ZEROS        SEQ#03
     C     K4AROP        CHAIN     FAROPN                             50
     C     *IN50         IFEQ      '1'
     C                   MOVE      'N'           OKFINE
     C                   GOTO      DOWN1X
     C                   END
     C     ARDUE$        IFEQ      *ZEROS
     C                   MOVE      'N'           OKFINE
     C                   GOTO      DOWN1X
     C                   END
     C*                    Z-SUBARDUE$    PAYDWN 112
     C                   Z-ADD     ARDUE$        PAYDWN           11 2
      *
     C     PAYINV        IFGT      PAYDWN
     C                   Z-ADD     PAYDWN        PAY$             11 2
     C                   END
     C     PAYINV        IFLT      PAYDWN
     C                   Z-ADD     PAYINV        PAY$
     C                   END
     C     PAYINV        IFEQ      PAYDWN
     C                   Z-ADD     PAYINV        PAY$
     C                   END
     CSR   DOWN1X        ENDSR
      *
      *  INVOICE PORTION OF SPREAD
     CSR   DOWN2         BEGSR
      *
     C                   Z-ADD     ATINV#        REF#
     C                   MOVE      *BLANKS       SUFF
     C                   EXSR      GETL
      **
     C     LAST01        ADD       1             ARSEQ#
     C                   MOVE      *BLANKS       ARSUFF
     C                   Z-ADD     ATINV#        ARINV#
     C                   Z-ADD     04            ARTTYP
     C                   Z-ADD     ATTDAT        ARTDAT
     C                   Z-ADD     ATTDAT        ARDUDT
     C                   Z-ADD     *ZEROS        ARDTAK
     C                   MOVE      *BLANKS       ARCHEK
     C                   Z-ADD     *ZEROS        ARCKDT
     C                   MOVE      *BLANKS       ARDESC
     C                   Z-ADD     *ZEROS        ARADJ$
     C                   Z-ADD     *ZEROS        ARPAID
     C                   Z-ADD     PAY$          AR$AMT
     C                   WRITE     RAROPN                                       NEW AR REC
     C                   Z-ADD     *ZEROS        MTDISC
     C                   EXSR      PUTTRN                                       NEW TRAN REC
     C     K3AROP        CHAIN     FAROPN                             52
     C     *IN52         IFEQ      '0'
     C*                    SUB  PDIS      ARDTAK
     C                   ADD       PAY$          ARADJ$
     C*                    ADD  PDIS      ARDUE$
     C                   ADD       PAY$          ARDUE$
     C                   MOVE      *BLANKS       ARDESC
     C                   UPDATE    RAROPN                                       UPDATE INVOICE
     C                   END
     CSR                 ENDSR
      *
      *  PAYMENT PORTION OF SPREAD
     CSR   DOWN3         BEGSR
      *
     C                   Z-ADD     ATORD#        REF#
     C                   MOVE      'DP'          SUFF
     C                   EXSR      GETL
      **
     C     LAST01        ADD       1             ARSEQ#
     C                   MOVE      'DP'          ARSUFF
     C                   Z-ADD     ATORD#        ARINV#
     C                   Z-ADD     04            ARTTYP
     C                   Z-ADD     ATTDAT        ARTDAT
     C                   Z-ADD     ATTDAT        ARDUDT
     C                   Z-ADD     *ZEROS        ARDTAK
     C                   MOVE      *BLANKS       ARCHEK
     C                   Z-ADD     *ZEROS        ARCKDT
     C                   Z-ADD     *ZEROS        ARDUE$
     C                   MOVE      *BLANKS       ARDESC
     C                   Z-ADD     *ZEROS        ARADJ$
     C                   Z-ADD     *ZEROS        ARPAID
     C                   Z-SUB     PAY$          AR$AMT
     C                   WRITE     RAROPN                                       NEW AR REC
     C                   Z-ADD     *ZEROS        MTDISC
     C                   EXSR      PUTTRN                                       NEW TRAN REC
     C     K4AROP        CHAIN     FAROPN                             52
     C     *IN52         IFEQ      '0'
 X   C*                    SUB  PDIS      ARDTAK
 X   C                   SUB       PAY$          ARADJ$
 X   C*                    ADD  PDIS      ARDUE$
     C                   SUB       PAY$          ARDUE$
     C*                    MOVE *BLANKS   ARDESC
     C                   UPDATE    RAROPN                                       UPDATE INVOICE
     C                   END
     CSR                 ENDSR
      **
     CSR   GETL          BEGSR
     C                   Z-ADD     *ZEROS        LAST01           03 0
     C                   Z-ADD     *ZEROS        LAST02           03 0
     C     K5AROP        SETLL     FAROPN
     C     K5AROP        SETLL     FMTRAN
     C**
     C     *IN51         DOUEQ     '1'                                          GET LAST AR
     C     K5AROP        READE     FAROPN                                 51
     C     *IN51         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   Z-ADD     ARSEQ#        LAST01
     C                   ENDDO
     C**
     C     *IN51         DOUEQ     '1'                                          GET LAST TRAN
     C     K5AROP        READE     FMTRAN                                 51
     C     *IN51         IFEQ      '1'
     C                   LEAVE
     C                   END
     C                   Z-ADD     MTSEQ#        LAST02
     C                   ENDDO
     CSR                 ENDSR
      *
     CSR   ERR           BEGSR
     C                   ADD       1             ERRS             04 0
     C     ERRS          IFEQ      0001
     C                   EXCEPT    HEAD
     C                   END
     CSR                 ENDSR
      *
     CSR   HED           BEGSR
     C     *INOF         IFEQ      '1'
     C                   EXCEPT    HEAD
     C                   MOVE      '0'           *INOF
     C                   END
     CSR                 ENDSR
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
     C                   MOVE      04            MTTTYP
     C                   MOVE      ARTDAT        MTTDAT
     C                   MOVE      ARDUDT        MTDUDT
     C                   MOVE      ARTAXJ        MTTAXJ
     C                   MOVE      ARSHFR        MTSHFR
     C                   Z-ADD     AR$AMT        MT$AMT
     C                   Z-ADD     *ZEROS        MTDIS$
     C                   Z-ADD     *ZEROS        MTQDIS
     C                   Z-ADD     *ZEROS        MTFRT$
     C                   Z-ADD     *ZEROS        MTSPL$
     C                   Z-ADD     *ZEROS        MTAMT1
     C                   Z-ADD     *ZEROS        MTAMT2
     C                   Z-ADD     *ZEROS        MTAMT3
     C                   Z-ADD     *ZEROS        MTMER$
     C                   MOVE      ARGLAC        MTGLAC
     C                   MOVE      *BLANKS       MTGLAR
     C                   MOVE      *BLANKS       MTGLUD
     C                   Z-ADD     *ZEROS        MTO30$
     C                   MOVE      ARDCDT        MTDCDT
     C                   MOVE      ARORD#        MTORD#
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
     C                   MOVE      *BLANKS       MTSHFR
     C                   MOVE      ARCHEK        MTCHEK
     C                   MOVE      ARCKDT        MTCKDT
     C                   MOVE      ARDESC        MTDESC
     C                   MOVE      ARDTLA        MTDTLA
     C                   MOVE      ARTIME        MTTIME
     C                   MOVE      ARUSER        MTUSER
     C*
     C                   MOVE      *BLANKS       MTCRCD
     C                   Z-ADD     *ZEROS        MTCRC#
     C                   Z-ADD     *ZEROS        MTCRCE
     C                   MOVE      *BLANKS       MTCRCA
     C*
     C                   MOVE      *BLANKS       MTSHP#
     C                   WRITE     RMTRAN
     CSR                 ENDSR
      *
      * ERROR LISTING - ARWRK RECORDS NOT USED TO UPDATE AROPN/MTRAN
      *
     OBIR430    E            HEAD           1 03
     O                       PROGID              10
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           66 'A/R Work Records Not'
     O                                           74 'Updated'
     O                       TIMOD              120 '  :  :  '
     O          E            HEAD           0
     O                                           13 'Ship Cust'
     O                                           30 'Invoice/Suffix'
     O                                           65 'Transaction Date'
     O                                           75 'Amount'
     O          E            HEAD           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O*       E  2             DET
     O*                        ATSHCUZ   10
     O*                        ATINV#Z   24
     O*                                  25 '-'
     O*                        ATSUFF    27
     O*                        ATTDATY   60
     O*                        AT$AMT1   80
     O          E            DET010      2
     O                       ATSHCU        Z     10
     O                       ATINV#        Z     24
     O                                           25 '-'
     O                       ATSUFF              27
     O                       ATTDAT        Y     60
     O                       AT$AMT        1     80
     O                                          120 '** No Customer Found    '
     O          E            DET020      2
     O                       ATSHCU        Z     10
     O                       ATINV#        Z     24
     O                                           25 '-'
     O                       ATSUFF              27
     O                       ATTDAT        Y     60
     O                       AT$AMT        1     80
     O                                          120 '** Invalid Record Type  '
     O          E            DET030      2
     O                       ATSHCU        Z     10
     O                       ATINV#        Z     24
     O                                           25 '-'
     O                       ATSUFF              27
     O                       ATTDAT        Y     60
     O                       AT$AMT        1     80
     O                                          120 '** No Down Payment Found'
     O          E            DET040      2
     O                       ATSHCU        Z     10
     O                       ATINV#        Z     24
     O                                           25 '-'
     O                       ATSUFF              27
     O                       ATTDAT        Y     60
     O                       AT$AMT        1     80
     O                                          120 '** Duplicate Invoice    '
     O          E            DET050      2
     O                       ATSHCU        Z     10
     O                       ATINV#        Z     24
     O                                           25 '-'
     O                       ATSUFF              27
     O                       ATTDAT        Y     60
     O                       AT$AMT        1     80
     O                                          120 '** Invalid Bank Code    '
