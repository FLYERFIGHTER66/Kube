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
      *PROGRAM NAME-------- ARR360
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- PRINT LATE CHARGE EDIT REPORT
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 2/23/01 EFD01 GOTO NXT IF NOT SAME COMPANY
      *
      *
      *
     FFAROPN    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FARR360    O    F  120        PRINTER OFLIND(*INOF)
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LCDATE                 9     13  0
     D  LDAYS                 14     16  0
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
      * MAIN PROCESS
      *
     C                   Z-ADD     0             BCUST             6 0
     C     BCUST         SETLL     FAROPN
     C     NXT           TAG
     C                   READ      FAROPN                                 90
     C   90              GOTO      END
      *
     C     ARSTAT        IFEQ      'D'                                                      D?
     C                   GOTO      NXT
     C                   ENDIF
      *
EFD01C     ARCOMP        IFNE      LCO                                                      D?
EFD01C                   GOTO      NXT
EFD01C                   ENDIF
EFD01C     ARCUST        IFEQ      002353                                                   D?
EFD01C     ARCUST        OREQ      004954                                                   D?
EFD01C     ARCUST        OREQ      001705                                                   D?
EFD01C     ARCUST        OREQ      006945                                                   D?
EFD01C     ARCUST        OREQ      006396                                                   D?
EFD01C     ARCUST        OREQ      001972                                                   D?
EFD01C     ARCUST        OREQ      008308                                                   D?
EFD01C     ARCUST        OREQ      000987                                                   D?
EFD01C     ARCUST        OREQ      001508                                                   D?
EFD01C     ARCUST        OREQ      001209                                                   D?
EFD01C                   GOTO      NXT
EFD01C                   ENDIF
      *
     C     FIRST         IFGT      1
     C     ARCUST        ANDNE     OCUST
     C                   EXSR      LATCHG
     C                   Z-ADD     0             TOTDUE
     C                   Z-ADD     0             TOTLC$
     C                   Z-ADD     0             WLATE$
     C                   ENDIF
      *
     C     ARCUST        CHAIN     FMCUST                             92
     C     CMAPLC        IFEQ      'N'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DUEDTE            5 0
      *
     C     LCDATE        SUB       DUEDTE        DAYDIF            5 0          DAYS OVERDUE>0
      *
      * TEST FOR PAST DUE RELATIVE TO LDA DAYS
      *
     C  N88DAYDIF        IFGE      LDAYS
     C     ARTTYP        ANDNE     07
     C                   ADD       ARDUE$        TOTLC$           11 2
     C                   ENDIF
      *
     C   88DAYDIF        IFGE      LDAYS
     C                   ADD       ARDUE$        TOTLC$           11 2
     C                   ENDIF
      *
     C                   ADD       ARDUE$        TOTDUE           11 2
      *
     C                   ADD       1             FIRST
      *
     C                   Z-ADD     ARCUST        OCUST             6 0
     C                   MOVEL     CMNAME        ONAME            30
     C                   GOTO      NXT
      *
     C     END           TAG
     C  N77              EXCEPT    TLRN
     C   77              EXSR      LATCHG
     C   77              EXCEPT    TLR
     C                   SETON                                        LR
      *
      *********
      * LATCHG
      *********
      *
      * MULTIPLY TOTAL AMOUNT DUE FROM CUSTOMER BY LC %
      * DECIDE TO USE EITHER MINIMUM OR CALCULATED LATE CHARGE
      *
     C     LATCHG        BEGSR
      *
     C     TOTDUE        IFLE      0
     C     TOTLC$        ORLE      0
     C                   GOTO      NOLATE
     C                   ENDIF
      *
     C     TOTLC$        MULT(H)   ACLCPC        WLATE            13 4
     C     WLATE         DIV(H)    100           WLATE$           11 2
      *
     C     ACLCMN        IFGT      0
     C     WLATE$        ANDLT     ACLCMN
     C                   Z-ADD     ACLCMN        WLATE$
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   ADD       WLATE$        TOTAMT           11 2
     C                   ADD       TOTDUE        DUELR            11 2
     C                   ADD       TOTLC$        LC$LR            11 2
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   SETON                                        77
     C     NOLATE        ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      * GET LATE CHARGE %, MINIMUM CHARGE AND # OF DAYS
      *
     C     LCO           CHAIN(N)  FMCORG                             22
     C     LCO           CHAIN(N)  FARCTL                             22
      *
      * 88 = CHARGE LATE CHARGES ON LATE CHARGES
      *
     C     ACLCLC        IFEQ      'Y'
     C                   SETON                                        88
     C                   ENDIF
      *
     C                   Z-ADD     1             FIRST             6 0
      *
     C                   EXCEPT    HDG
      *
     C                   ENDSR
     OARR360    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           72 'Late Charges Edit Report'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           50 'Calculated As Of:'
     O                       LDATE         Y     59
     O                                           81 'On Invoices Overdue'
     O                       LDAYS         Z     85
     O                                           90 'Days'
     O          E            HDG            1
     O                                            5 'A/R'
     O                                           46 'Trans'
     O                                           55 'Due'
     O                                           85 'Total'
     O                                          100 'Amount'
     O                                          120 'Late Charge'
     O          E            HDG            1
     O                                            5 'Cust'
     O                                           24 'N   A   M   E'
     O                                           46 'Date'
     O                                           55 'Date'
     O                                           63 'Ref.'
     O                                           68 'Suff'
     O                                           85 'A/R Amt'
     O                                           94 'Over'
     O                       LDAYS         Z     98
     O                                          103 'Days'
     O                                          118 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       OCUST         Z      6
     O                       ONAME               37
     O                       LDATE         Y     46
     O                       LDATE         Y     55
     O                       LDATE         Z     64
     O                                           67 'LC'
     O                       TOTDUE        1     85
     O                       TOTLC$        1    100
     O                       WLATE$        1    120
     O          E            TLR            1
     O                                           85 '----------'
     O                                          100 '----------'
     O                                          120 '----------'
     O          E            TLR            1
     O                       DUELR         1     85
     O                       LC$LR         1    100
     O                       TOTAMT        1    120
     O          E            TLR         2  1
     O                       TOTAMT        1     80
     O                                           48 'Total Late Charges That'
     O                                           70 ' Will Be Added To A/R:'
      *
      * PRINT IF NO LATE CHARGE RECORDS
      *
     O          E            TLRN           1
     O                                           60 '** There Were No Late'
     O                                           82 'Charges Calculated **'
      *                                                                ***@DT@B2
