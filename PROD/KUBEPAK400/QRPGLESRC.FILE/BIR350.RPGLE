      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR350
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- DAILY SALES JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/07/01 EFD CHANGE CALC OF TRADE DISCOUNT.   EFD01
      *  3/07/01 EFD FIX DATE BREAK.                  EFD02
      *
     FFDSALESJ  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FBIR350    O    F  120        PRINTER OFLIND(*INOF)
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
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
      *
     C                   EXCEPT    HDG
     C                   Z-ADD     1             CNT               4 0
     C                   Z-ADD     1             FIRST             4 0
     C                   Z-ADD     1             FINV              4 0
      *
     C     NXT           TAG
     C                   READ      FDSALESJ                               90
     C   90              GOTO      END
      *
     C     SDSTAT        IFEQ      'D'
     C     SDSTAT        OREQ      'P'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SDCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SDSEQ#        IFGT      989
     C                   GOTO      NXT
     C                   ENDIF
      *
      * INVOICE TOTALS
      *
     C     FIRST         IFNE      1
     C     SDINV#        ANDNE     OLINV#
     C                   EXCEPT    TL1
     C                   Z-ADD     0             IDISAM
     C                   Z-ADD     0             ITRDSC
     C                   Z-ADD     1             FINV
     C                   ENDIF
      *
      * DATE TOTALS
      *
     C     FIRST         IFNE      1
     C     SDTDAT        ANDNE     OLDATE
     C                   EXCEPT    TL2
     C                   Z-ADD     0             DDISAM
     C                   Z-ADD     0             DTRDSC
     C                   Z-ADD     0             DEXAMT
     C                   Z-ADD     0             DNETAM
     C                   ENDIF
EFD02C                   Z-ADD     SDTDAT        OLDATE            7 0
      *
     C     FINV          IFEQ      1
     C     SDCUST        CHAIN     FMCUST                             11
     C  N11CMSTAT        COMP      'D'                                    11
     C     SDSLM1        CHAIN     FMSLSM                             11
     C                   Z-ADD     SDINV#        OLINV#            6 0
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C                   Z-ADD     SDTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C                   EXCEPT    DTL1
     C                   ENDIF
      *
     C                   ADD       1             FINV
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
      *
      * CALCULATE GROSS AMT, NET AMT, DISCOUNT AMOUNT
      *
     C     SDCWTF        IFEQ      'Y'
     C                   Z-ADD     1             #WRFRQ
     C                   Z-ADD     SDWGSH        #WKWGT
     C                   ELSE
     C                   Z-ADD     SDQSHP        #WRFRQ
     C                   Z-ADD     SDUWGT        #WKWGT
     C                   END
      *
     C                   Z-ADD     SDUPRI        #PRC
     C                   Z-ADD     SDDIS1        #DISC
     C                   MOVE      SDCWTF        #CWFLG
     C                   EXSR      #EXLNO
     C                   Z-ADD     #LINGR        EXAMT             9 2
     C                   Z-ADD     #LINNT        NETAMT            9 2
     C                   Z-ADD     #LINDS        DISAMT            7 2    50
      *
     C                   ADD       EXAMT         IEXAMT            9 2
     C                   ADD       NETAMT        INETAM            9 2
      *
      * REVERSE SIGN ON DISCOUNT AMOUNT
      *
     C                   Z-SUB     DISAMT        DISAMT
     C     DISAMT        ADD       IDISAM        IDISAM            9 2
      *
     C                   MOVEL     SDITEM        SDISW            12
     C**         SDISW     SETLLFMINVT
     C**                   READ FMINVT                   90
     C                   MOVEL     IMITEM        SITEM            15
     C*****                MOVE IMSIZE    SITEM
     C**         SITEM     IFGT SDITEM
     C     ITMKEY        KLIST
     C                   KFLD                    SDITEM
     C                   KFLD                    SDSIZE
     C     ITMKEY        CHAIN     FMINVT                             66
     C   66              DO
     C                   MOVE      *BLANKS       DESP
     C                   GOTO      NOITEM
     C                   ENDDO
     C**                   END
     C                   EXSR      GETDES
     C     NOITEM        TAG
     C                   ADD       EXAMT         DEXAMT            9 2
     C                   ADD       NETAMT        DNETAM            9 2
     C                   ADD       IDISAM        DDISAM            9 2
EFD01C**                   Z-ADDINETAM    PRICE1  92
EFD01C                   Z-ADD     NETAMT        PRICE1            9 2
     C                   Z-ADD     SDTRDC        DISHLD            4 2    51
     C  N51              MOVE      DISHLD        DISREF            4 4
     C  N511             SUB       DISREF        DISREF
     C  N51PRICE1        MULT      DISREF        PRICE1
EFD01C**         INETAM    SUB  PRICE1    ITRDSC  92
EFD01C     NETAMT        SUB       PRICE1        ITRDSC            9 2
      *
      * REVERSE THE SIGN FOR TRADE DISCOUNT
      *
     C                   Z-SUB     ITRDSC        ITRDSC
     C                   ADD       ITRDSC        DTRDSC            9 2
     C                   ADD       EXAMT         CEXAMT           10 2
     C                   ADD       NETAMT        CNETAM           10 2
     C                   ADD       DDISAM        CDISAM           10 2
EFD01C**                   ADD  DTRDSC    CTRDSC 102
EFD01C                   ADD       ITRDSC        CTRDSC           10 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DTL2
     C                   Z-ADD     0             EXAMT
     C                   Z-ADD     0             NETAMT
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *********
      ** GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             48
     C                   ENDSR
      *
     C     #EXLNO        BEGSR
      *
      *  SUBROUTINE #EXLNO IS USED TO EXTEND THE VALUE OF A ORDER DETAIL
      *  LINE
      *  USE THIS SUBROUTINE WHEN FIELD DEFINITIONS FROM IORDR ARE REQ'D
      *
      *  USER WILL NEED TO LOAD FIELDS AS FOLLOWS
      *       #WRFRQ    CONTAINS QUANTITY
      *       #PRC      CONTAINS PRICE
      *       #DISC     CONTAINS QUANTITY DISCOUNT PCT.
      *       #WKWGT    CONTAINS WEIGHT PER UNIT OF MEASURE
      *       #CWFLG    CATCH WEIGHT ITEM 'Y' OR 'N'
      *
      *       SUBROUTINE WILL RETURN THE FOLLOWING:
      *
      *       #LINGR    EXTENDED GROSS AMOUNT
      *       #LINNT    EXTENDED NET AMOUNT
      *       #LINDS    DISCOUNT DOLLAR AMOUNT
      *
      *
     C                   Z-ADD     #WRFRQ        #WRFRQ           11 1
     C                   Z-ADD     #PRC          #PRC              9 4
     C                   Z-ADD     #DISC         #DISC             4 2
     C                   Z-ADD     #WKWGT        #WKWGT           11 4
     C                   MOVE      #CWFLG        #CWFLG            1
      *
     C     #CWFLG        IFEQ      'Y'
     C     #WRFRQ        MULT(H)   #WKWGT        #WRFRQ
     C                   END
      *
      *  EXTEND GROSS AMOUNT
      *
     C     #WRFRQ        MULT      #PRC          #LINGR            9 2
      *
      *  ADJUST FOR DISC. PCT.
      *
     C     #DISC         IFNE      0
     C                   MOVE      #DISC         WKDISC            4 4
     C     1             SUB       WKDISC        WKDISC
     C     #PRC          MULT      WKDISC        #PRC
     C                   END
      *
      *  CALCULATE LINE NET AMOUNT
      *
     C     #WRFRQ        MULT      #PRC          #LINNT            9 2
      *
      *  CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       #LINNT        #LINDS            7 2
      *
     C                   ENDSR
      *
     OBIR350    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           69 'Daily Sales Journal'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            6 'Inv #'
     O                                           15 'S/A #'
     O                                           32 'Customer'
     O                                           54 'A/R #'
     O                                           60 'Date'
     O                                           69 'Ord #'
     O                                           85 'Qty'
     O                                           95 'Unit'
     O                                          106 'Merch.'
     O                                          116 'Net'
     O          E            HDG            0
     O                                           15 'Item       Size'
     O                                           19 'Seq'
     O                                           27 'Pr Cl'
     O                                           77 'UM'
     O                                           86 'Ship'
     O                                           95 'Price'
     O                                          106 'Amount'
     O                                          118 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DTL1           1
     O                       SDINV#        Z      6
     O                       SDSUFF               8
     O                       SDCUST        Z     15
     O                 N11   CMNAME              46
     O                  11                       36 '*Inactive Customer*'
     O                       CMARCU        Z     53
     O                       TDAT          Y     62
     O                       SDORD#        Z     69
     O                       SDSLM1              72
     O                       SMNAME             103
     O          EF           DTL2           1
     O                       SDPCL1              24
     O                       SDPCL2              27
     O                       SDITEM              12
     O                       SDSIZE              15
     O                       SDSEQ#        Z     19
     O                       NETAMT        JB   119
     O                       EXAMT         JB   107
     O                       SDUPRI        L     97
     O                       SDQSHP        M     87
     O                       SDUUOM              77
     O                       DESP                73
     O                    N50                   120 'Q'
     O          E            TL1         1  1
     O                                           94 'Invoice Totals:'
     O                       IEXAMT        JB   107
     O                       INETAM        JB   119
     O                    N51                   120 'T'
     O          E            TL2         1  2
     O                                           84 'Total For Date:'
     O                       TDAT          Y     94
     O                       DEXAMT        JB   107
     O                       DNETAM        JB   119
     O          E            TLR            1
     O                                           25 'Total For Company:'
     O                       SDCOMP              32
     O                                           55 'Merchandise Amount'
     O                       CEXAMT        JB    79
     O          E            TLR            1
     O                                           52 'Qty. Disc. Amt.'
     O                       CDISAM        JB    79
     O                                          110 'Q = Qty. Disc. Applied'
     O          E            TLR            1
     O                                           47 'Net Amount'
     O                       CNETAM        JB    79
     O          E            TLR            2
     O                                           52 'Trd. Disc. Amt.'
     O                       CTRDSC        JB    79
     O                                          110 'T = Trd. Disc. Applied'
