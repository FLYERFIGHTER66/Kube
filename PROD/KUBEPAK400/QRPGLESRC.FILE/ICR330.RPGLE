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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR330
      *SYSTEM-------------- INVENTORY
      *DESCRIPTION--------- INVENTORY ANALYSIS REPORT BY ITEM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFMINVT    IF   E           K DISK
     FFSHISTS   IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FICR330    O    F  122        PRINTER OFLIND(*INOF)
      *
     D CS$             S              9  2 DIM(26)
     D CC$             S              9  2 DIM(26)
     D CSQ             S             11  1 DIM(26)
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LBITEM                 3     14
     D  LEITEM                15     26
     D  LBSIZE                27     29
     D  LESIZE                30     32
     D  LBLOC                 33     35
     D  LELOC                 36     38
     D  LBVEND                39     44  0
     D  LEVEND                45     50  0
     D  LPC1                  51     52
     D  LPC2                  53     54
     D  LOH                   55     55
     D  LZOH                  56     56
     D  LNOH                  57     57
     D  LBRO                  58     58
     D  LBO                   59     59
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
     IRSHISTS
     I              SHCQ01                      CSQ(1)
     I              SHCQ02                      CSQ(2)
     I              SHCQ03                      CSQ(3)
     I              SHCQ04                      CSQ(4)
     I              SHCQ05                      CSQ(5)
     I              SHCQ06                      CSQ(6)
     I              SHCQ07                      CSQ(7)
     I              SHCQ08                      CSQ(8)
     I              SHCQ09                      CSQ(9)
     I              SHCQ10                      CSQ(10)
     I              SHCQ11                      CSQ(11)
     I              SHCQ12                      CSQ(12)
     I              SHCQ13                      CSQ(13)
     I              SHLQ01                      CSQ(14)
     I              SHLQ02                      CSQ(15)
     I              SHLQ03                      CSQ(16)
     I              SHLQ04                      CSQ(17)
     I              SHLQ05                      CSQ(18)
     I              SHLQ06                      CSQ(19)
     I              SHLQ07                      CSQ(20)
     I              SHLQ08                      CSQ(21)
     I              SHLQ09                      CSQ(22)
     I              SHLQ10                      CSQ(23)
     I              SHLQ11                      CSQ(24)
     I              SHLQ12                      CSQ(25)
     I              SHLQ13                      CSQ(26)
      *
     I              SHCS01                      CS$(1)
     I              SHCS02                      CS$(2)
     I              SHCS03                      CS$(3)
     I              SHCS04                      CS$(4)
     I              SHCS05                      CS$(5)
     I              SHCS06                      CS$(6)
     I              SHCS07                      CS$(7)
     I              SHCS08                      CS$(8)
     I              SHCS09                      CS$(9)
     I              SHCS10                      CS$(10)
     I              SHCS11                      CS$(11)
     I              SHCS12                      CS$(12)
     I              SHCS13                      CS$(13)
     I              SHLS01                      CS$(14)
     I              SHLS02                      CS$(15)
     I              SHLS03                      CS$(16)
     I              SHLS04                      CS$(17)
     I              SHLS05                      CS$(18)
     I              SHLS06                      CS$(19)
     I              SHLS07                      CS$(20)
     I              SHLS08                      CS$(21)
     I              SHLS09                      CS$(22)
     I              SHLS10                      CS$(23)
     I              SHLS11                      CS$(24)
     I              SHLS12                      CS$(25)
     I              SHLS13                      CS$(26)
      *
     I              SHCC01                      CC$(1)
     I              SHCC02                      CC$(2)
     I              SHCC03                      CC$(3)
     I              SHCC04                      CC$(4)
     I              SHCC05                      CC$(5)
     I              SHCC06                      CC$(6)
     I              SHCC07                      CC$(7)
     I              SHCC08                      CC$(8)
     I              SHCC09                      CC$(9)
     I              SHCC10                      CC$(10)
     I              SHCC11                      CC$(11)
     I              SHCC12                      CC$(12)
     I              SHCC13                      CC$(13)
     I              SHLC01                      CC$(14)
     I              SHLC02                      CC$(15)
     I              SHLC03                      CC$(16)
     I              SHLC04                      CC$(17)
     I              SHLC05                      CC$(18)
     I              SHLC06                      CC$(19)
     I              SHLC07                      CC$(20)
     I              SHLC08                      CC$(21)
     I              SHLC09                      CC$(22)
     I              SHLC10                      CC$(23)
     I              SHLC11                      CC$(24)
     I              SHLC12                      CC$(25)
     I              SHLC13                      CC$(26)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     TDATE         TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        P                 2 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   SETON                                        8990
      *
     C     LOH           IFEQ      'Y'                                           PLUS O/H
     C                   SETON                                        70
     C                   ENDIF
      *
     C     LZOH          IFEQ      'Y'                                           NEG O/H
     C                   SETON                                        71
     C                   END
      *
     C     LNOH          IFEQ      'Y'                                           0 ON HAND
     C                   SETON                                        72
     C                   END
      *
     C     LBRO          IFEQ      'Y'                                           PRINT AT OR
     C                   SETON                                        73
     C                   END
      *
     C     LBO           IFEQ      'Y'                                           BACK ORDER
     C                   SETON                                        74
     C                   END
      *
     C     LBITEM        IFGT      *BLANKS                                       ITM RANGE
     C                   SETON                                        40
     C                   ENDIF
      *
     C     LBSIZE        IFGT      *BLANKS                                       SIZE RANGE
     C                   SETON                                        41
     C                   ENDIF
      *
     C     LBLOC         IFGT      *BLANKS                                       LOC RANGE
     C                   SETON                                        42
     C                   ENDIF
      *
     C     LBVEND        IFGT      0                                             VEND RANGE
     C                   SETON                                        43
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS                                       PC RANGE
     C                   SETON                                        44
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     RSTRT         TAG
     C                   Z-ADD     1             CNT               3 0
     C                   Z-ADD     1             LINE              3 0
     C     NXT           TAG
     C                   SETOFF                                       1137
     C                   Z-ADD     0             PROFIT
     C                   Z-ADD     0             YTD$
     C                   Z-ADD     0             QYTD
     C                   Z-ADD     0             YTDC
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
     C                   Z-ADD     ACTPER        P                 2 0
      *
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   40IMITEM        IFLT      LBITEM                                                   TEM
     C     IMITEM        ORGT      LEITEM                                                   TEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   41IMSIZE        IFLT      LBSIZE                                                   TEM
     C     IMSIZE        ORGT      LESIZE                                                   TEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   42IMWHSE        IFLT      LBLOC                                                    TEM
     C     IMWHSE        ORGT      LELOC                                                    TEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   43IMVEND        IFLT      LBVEND                                                   NDR
     C     IMVEND        ORGT      LEVEND                                                   NDR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   44IMPCL1        IFLT      LPC1                                                     L
     C     IMPCL1        ORGT      LPC2                                                     L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  PLUS ON HAND
      *
     C   70IMQTOH        IFLE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  ZERO ON HAND
      *
     C   71IMQTOH        IFNE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  NEGATIVE ON HAND
      *
     C   72IMQTOH        IFGE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  ITEMS BELOW REORDER
      *
     C   73IMQEOQ        IFEQ      *ZEROS                                                   L
     C                   GOTO      NXT
     C                   ENDIF
     C   73IMQTOH        IFGT      IMQEOQ                                                   L
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  ITEMS ON BACKORDER
      *
     C   74IMQTBO        IFLE      0                                                        L
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   EXSR      GETDES
      *
     C   10IMITEM        IFEQ      OITEM
     C                   SETON                                        11
     C                   ENDIF
     C   10
     CAN 11IMSIZE        IFEQ      OSIZE
     C                   GOTO      NODET1
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   Z-ADD     1             CNT
      *
     C                   Z-ADD     LCO           SHCOMP
     C                   Z-ADD     0             SHCUST
     C                   MOVEL     IMITEM        SHITEM
     C                   MOVEL     IMSIZE        SHSIZE
     C                   MOVEL     *BLANKS       SHSLSM
     C     KEY25         KLIST
     C                   KFLD                    SHCUST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C                   KFLD                    SHSLSM
     C                   KFLD                    SHCOMP
     C     KEY25         CHAIN     FSHISTS                            92
     C   92              SETON                                        1214
     C   92              GOTO      NOSLS
      *
     C                   Z-ADD     CSQ(P)        QMTD             11 1
     C                   ADD       CSQ(P)        QYTD             11 1
     C                   ADD       CS$(P)        YTD$              9 2
     C     12            SUB       P             XL                2 0          LAST YR MTHS
     C                   SUB       1             P                 2 0
     C     P             DOUEQ     0
     C                   ADD       CSQ(P)        QYTD
     C                   ADD       CS$(P)        YTD$
     C                   ADD       CC$(P)        YTDC              9 2
     C                   SUB       1             P                 2 0
     C                   ENDDO
     C                   Z-ADD     25            Y                 2 0
     C     XL            DOUEQ     0                                               8
     C                   ADD       CSQ(Y)        QYTD
     C                   ADD       CS$(Y)        YTD$
     C                   ADD       CC$(Y)        YTDC
     C                   SUB       1             Y                 2 0
     C                   SUB       1             XL
     C                   ENDDO
      *
     C     NOSLS         TAG
      *
     C*                    ADD  IM$MTD    SLSYTD  92
     C*                    ADD  IM$M01    SLSYTD
     C*                    ADD  IM$M02    SLSYTD
     C*                    ADD  IM$M03    SLSYTD
     C*                    ADD  IM$M04    SLSYTD
     C*                    ADD  IM$M05    SLSYTD
     C*                    ADD  IM$M06    SLSYTD
     C*                    ADD  IM$M07    SLSYTD
     C*                    ADD  IM$M08    SLSYTD
     C*                    ADD  IM$M09    SLSYTD
     C*                    ADD  IM$M10    SLSYTD
     C*                    ADD  IM$M11    SLSYTD
     C*                    ADD  IMQMTD    QTYYTD 111
     C*                    ADD  IMQM01    QTYYTD
     C*                    ADD  IMQM02    QTYYTD
     C*                    ADD  IMQM03    QTYYTD
     C*                    ADD  IMQM04    QTYYTD
     C*                    ADD  IMQM05    QTYYTD
     C*                    ADD  IMQM06    QTYYTD
     C*                    ADD  IMQM07    QTYYTD
     C*                    ADD  IMQM08    QTYYTD
     C*                    ADD  IMQM09    QTYYTD
     C*                    ADD  IMQM10    QTYYTD
     C*                    ADD  IMQM11    QTYYTD
     C*                    ADD  IMCMTD    COSYTD  92
     C*                    ADD  IMCM01    COSYTD
     C*                    ADD  IMCM02    COSYTD
     C*                    ADD  IMCM03    COSYTD
     C*                    ADD  IMCM04    COSYTD
     C*                    ADD  IMCM05    COSYTD
     C*                    ADD  IMCM06    COSYTD
     C*                    ADD  IMCM07    COSYTD
     C*                    ADD  IMCM08    COSYTD
     C*                    ADD  IMCM09    COSYTD
     C*                    ADD  IMCM10    COSYTD
     C*                    ADD  IMCM11    COSYTD
     C     YTD$          SUB       YTDC          PROFIT            9 2
      *
     C     IMQTOH        IFGT      0
     C     IMUCST        ANDGT     0
     C     IMQTOH        MULT(H)   IMUCST        VALUE             9 2
     C                   ADD       VALUE         TOTVAL           10 2
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C                   EXCEPT    DETL1
     C                   SETON                                        77
     C                   ENDIF
     C     NODET1        TAG
     C                   ADD       1             CNT
      *
     C     IMSUOM        IFGT      *BLANKS                                                  RED
     C                   SETON                                        37                    RED
     C                   ENDIF
     C     IM3UOM        IFGT      *BLANKS                                                  RED
     C                   SETON                                        38                    RED
     C                   ENDIF
      *
     C                   Z-ADD     IMQTOH        #QTY1                          CONVERT ON HAND
     C                   Z-ADD     IMQ2OH        #QTY2                          QUANTITIES INTO
     C                   Z-ADD     IMQ3OH        #QTY3                          PRIMARY U/M
     C                   EXSR      #PRUM
     C                   Z-ADD     #PRQTY        SVQTOH           11 1
      *
     C                   Z-ADD     IMQTAL        #QTY1                          CONVERT
     C                   Z-ADD     IMALC2        #QTY2                          ALLOCATED QTYS.
     C                   Z-ADD     IMALC3        #QTY3
     C                   EXSR      #PRUM
     C                   Z-ADD     #PRQTY        SVQTAL           11 1
      *
     C                   Z-ADD     IMQTAV        #QTY1                          CONVERT
     C                   Z-ADD     IMQTA2        #QTY2                          AVAILABLE QTYS.
     C                   Z-ADD     IMQTA3        #QTY3
     C                   EXSR      #PRUM
     C                   Z-ADD     #PRQTY        SVQTAV           11 1
      *
     C     IMQEOQ        COMP      0                                  24
     C   24SVQTOH        COMP      IMQEOQ                               2424     AT/BELOW REORD
      *
      * EXECUTE ITEM TOTALS SUBROUTINE
      *
     C                   EXSR      ITTOT
      *
     C     IMWHSE        CHAIN(N)  FMWHSE                             90
     C*                    EXCPTDETL2
     C*  37                EXCPTUMTWO
      *  38                EXCPTUTHREE
     C                   SETON                                        10
     C                   ADD       1             CNT
     C                   MOVEL     IMITEM        OITEM            12
     C                   MOVEL     IMSIZE        OSIZE             3
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             30
     C                   ENDSR
      *
      *  *************************************************************
      *  *  THIS SUBROUTINE ACCUMULATES ITEM TOTALS FOR SIX FIELDS   *
      *  *  AND ALSO ACCUMULATES TOTAL VALUE OF INVENTORY            *
      *  *************************************************************
      *
     C     ITTOT         BEGSR
     C                   ADD       IMQTOO        ITMQOO
     C                   ADD       IMQTBO        ITMQBO
     C                   ADD       SVQTOH        ITMQOH
     C                   ADD       SVQTAL        ITMQAL
     C                   ADD       SVQTAV        ITMQAV
     C                   ADD       IMQMTD        ITMMTD
     C                   ENDSR
      *
      *  *************************************************************
      *  *  THIS SUBROUTINE CLEARS ITEM TOTAL FIELDS                 *
      *  *************************************************************
      *
     C     CLEAR         BEGSR
     C                   Z-ADD     0             ITMCST            9 2
     C                   Z-ADD     0             ITMQOO           11 1
     C                   Z-ADD     0             ITMQBO           11 1
     C                   Z-ADD     0             ITMQOH           11 1
     C                   Z-ADD     0             ITMQAL           11 1
     C                   Z-ADD     0             ITMQAV           11 1
     C                   Z-ADD     0             ITMMTD           11 1
     C                   ENDSR
      *
     C     #PRUM         BEGSR
      *  #PRUM - PRIMARY UNIT OF MEASURE QUANTITY ROUTINE
      *  CONVERTS QUANTITIES IN ALL UNITS OF MEASURE
      *  INTO THE PRIMARY UNIT OF MEASURE.
      *  ITEM MASTER QUANTITY FIELDS MUST BE Z-ADDED INTO
      *  #QTY1, #QTY2, #QTY3 BEFORE EXECUTING SUBROUTINE.
      *  OUTPUT FIELD IS #PRQTY
      *
     C     *LIKE         DEFINE    IMQTOH        #QTY1
     C     *LIKE         DEFINE    IMQ2OH        #QTY2
     C     *LIKE         DEFINE    IMQ3OH        #QTY3
     C     *LIKE         DEFINE    IMQTOH        #PRQTY
     C     *LIKE         DEFINE    IMQTOH        #WK1
     C     *LIKE         DEFINE    IMQTOH        #WK2
      *
     C                   Z-ADD     *ZEROS        #WK1
     C                   Z-ADD     *ZEROS        #WK2
      *
     C                   Z-ADD     #QTY1         #PRQTY
      *
     C     #QTY3         IFNE      *ZEROS
     C     IMMUL2        IFNE      *ZEROS
      *
     C     #QTY3         DIV(H)    IMMUL2        #WK2
     C     #WK2          ADD       #QTY2         #QTY2
      *
     C                   END
     C                   END
      *
     C     #QTY2         IFNE      *ZEROS
     C     IMMULT        IFNE      *ZEROS
      *
     C     #QTY2         DIV(H)    IMMULT        #WK1
      *
     C                   END
     C                   END
      *
     C                   ADD       #WK1          #PRQTY
      *
     C                   ENDSR
      *
     OICR330    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          115 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           69 'Inventory Analysis By '
     O                                           73 'Item'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O               70                          67 'Only Items With An On Ha'
     O               70                          82 'nd Balance     '
     O               71                          66 'Only Items With A Zero O'
     O               71                          81 'n Hand Quantity'
     O               72                          66 'Only Items With A Negati'
     O               72                          76 've Balance'
     O               73                          66 'Only Items At Or Below R'
     O               73                          78 'eorder Point'
     O               74                          66 'Only Items With Items On'
     O               74                          77 'Back Order'
     O          E            HDG            1
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            HDG            1
     O                                           24 '- Selection Criteria-'
     O                                           36 'Item:'
     O              N40                          42 'ALL'
     O               40                          42 'From'
     O               40      LBITEM              55
     O               40                          62 'To'
     O               40      LEITEM              75
     O                                          103 'Location:'
     O              N42                         109 'ALL'
     O               42                         109 'From'
     O               42      LBLOC              113
     O               42                         116 'To'
     O               42      LELOC              120
     O          E            HDG            1
     O                                           36 'Size:'
     O              N41                          42 'ALL'
     O               41                          42 'From'
     O               41      LBSIZE              46
     O               41                          50 'To'
     O               41      LESIZE              54
     O                                           67 'Vendor:'
     O              N43                          72 'ALL'
     O               43                          72 'From'
     O               43      LBVEND        Z     79
     O               43                          82 'To'
     O               43      LEVEND        Z     89
     O                                          103 'Prod Class:'
     O              N44                         109 'ALL'
     O               44                         109 'From'
     O               44      LPC1               112
     O               44                         116 'To'
     O               44      LPC2               120
     O          E            HDG            1
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            HDG            1
     O                                           58 'Date'
     O                                           82 '---------'
     O                                           93 'Last 12 Months'
     O                                          102 '---------'
     O          E            HDG            1
     O                                           58 'Last'
     O                                           68 'MTD'
     O                                           78 'Qty'
     O                                           91 'Sales'
     O                                          100 '$'
     O                                          110 'Qty'
     O                                          122 'On Hand'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           15 'Size'
     O                                           19 'Loc'
     O                                           34 'Description'
     O                                           58 'Sold'
     O                                           68 'Sold'
     O                                           78 'Sold'
     O                                           91 'Amount'
     O                                          102 'Profit'
     O                                          112 'On Hand'
     O                                          122 'Value'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL1          1
     O                       VALUE         MB   122
     O                       IMQTOH        MB   112
     O                       PROFIT        MB   103
     O                       YTD$          MB    92
     O                       QYTD          MB    80
     O                       QMTD          MB    69
     O                       IMDTLS        Y     59
     O                       IMITEM              12
     O                       IMSIZE              15
     O                       IMWHSE              19
     O                       DESP                50
     O*       EF 1             UMTWO
     O*                        IMSUOM B   9
     O*                        IMQ2OHMB  69
     O*                        IMALC2MB  82
     O*                        IMQTA2MB  95
     O*       EF 1             UTHREE
     O*                        IM3UOM B   9
     O*                        IMQ3OHMB  69
     O*                        IMALC3MB  82
     O*                        IMQTA3MB  95
     O          EF           TLR         2  1
     O                                           93 'Total Value Of On Hand I'
     O                                          105 'nventory ==>'
     O                       TOTVAL        JB   122
     O          EF           TLRN           1
