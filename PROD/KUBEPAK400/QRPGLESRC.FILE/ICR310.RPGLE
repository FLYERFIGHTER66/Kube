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
      *PROGRAM NAME-------- ICR310
      *SYSTEM-------------- INVENTORY
      *DESCRIPTION--------- STOCK STATUS REPORT PROMPT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFMINVT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FICR310    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LZO                   60     60
     D  LPA                   61     61
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
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
     C     LZO           IFEQ      'Y'                                           ZERO ALLOCATED
     C                   SETON                                        75
     C                   END
      *
     C     LPA           IFEQ      'Y'                                           POSITIVE AVAIL.
     C                   SETON                                        76
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
     C                   SETOFF                                       11
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
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
      *
      *  ITEMS WITH ZERO ALLOCATED
      *
     C     *IN75         IFEQ      *ON                                                      L
     C     IMQTAL        IFNE      0                                                        L
     C*          IMALC2    ORNE 0                                      L
     C*          IMALC3    ORNE 0                                      L
     C                   GOTO      NXT
     C                   ENDIF
     C                   ENDIF
      *
      *  ITEMS WITH POSITIVE AVAILABILITY
      *
     C     *IN76         IFEQ      *ON                                                      L
     C     IMQTAV        IFLE      0                                                        L
     C*          IMQTA2    ANDEQ0                                      L
     C*          IMQTA3    ANDEQ0                                      L
     C                   GOTO      NXT
     C                   ENDIF
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
     C   OF              EXCEPT    HDG
     C                   Z-ADD     1             CNT
     C*                    ENDIF
      *
     C     CNT           IFEQ      1
     C                   EXCEPT    DETL1
     C                   ENDIF
     C     NODET1        TAG
     C                   ADD       1             CNT
      *
     C                   ADD       IMQM01        SLSYTD           11 1
     C                   ADD       IMQM02        SLSYTD
     C                   ADD       IMQM03        SLSYTD
     C                   ADD       IMQM04        SLSYTD
     C                   ADD       IMQM05        SLSYTD
     C                   ADD       IMQM06        SLSYTD
     C                   ADD       IMQM07        SLSYTD
     C                   ADD       IMQM08        SLSYTD
     C                   ADD       IMQM09        SLSYTD
     C                   ADD       IMQM10        SLSYTD
     C                   ADD       IMQM11        SLSYTD
     C                   ADD       IMQM12        SLSYTD
     C                   ADD       IMQM13        SLSYTD
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
     C                   EXCEPT    DETL2
     C   37              EXCEPT    UMTWO
     C   38              EXCEPT    UTHREE
     C                   SETON                                        10
     C                   ADD       1             CNT
     C                   MOVEL     IMITEM        OITEM            12
     C                   MOVEL     IMSIZE        OSIZE             3
      *
     C                   GOTO      NXT
      *
     C     END           TAG
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
     C                   MOVEL     DESCO         DESP            104
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
     OICR310    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          114 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Stock Status By Item'
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
     O               75                          66 'Only Items With Zero All'
     O               75                          76 'ocated    '
     O               76                          66 'Only Items Positive Avai'
     O               76                          76 'lability  '
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
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
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           15 'Size'
     O                                           30 'Description'
     O                                           50 '---------------'
     O                                           74 'Q U A N T I T I E S'
     O                                           94 '---------------'
     O                                          106 'Sold'
     O                                          120 'Sold Last'
     O*       E  0             HDG
     O          E            HDG            1
     O                                            5 'Loc'
     O                                            9 'UM'
     O               73                          29 'Reorder Pt'
     O                                           42 'On P.O.'
     O                                           55 'Back Order'
     O                                           68 'On Hand'
     O                                           81 'Allocated'
     O                                           94 'Available'
     O                                          106 'MTD'
     O                                          120 '13 Months'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O*       EF10             DETL1
     O          EF           DETL1       1  1
     O                       IMITEM              12
     O                       IMSIZE              15
     O                       DESP               120
     O          EF           DETL1          1
     O                                           15 '_______________'
     O          EF           DETL2          1
     O                       IMWHSE               3
     O                       IMPUOM               9
     O               73      IMQEOQ        M     29
     O                       IMQTOO        M     43
     O                       IMQTBO        M     56
     O                       IMQTOH        M     69
     O                       IMQTAL        M     82
     O                       IMQTAV        M     95
     O                       IMQMTD        M    107
     O                       SLSYTD        MB   120
     O          EF           UMTWO          1
     O                       IMSUOM         B     9
     O                       IMQ2OH        MB    69
     O                       IMALC2        MB    82
     O                       IMQTA2        MB    95
     O          EF           UTHREE         1
     O                       IM3UOM         B     9
     O                       IMQ3OH        MB    69
     O                       IMALC3        MB    82
     O                       IMQTA3        MB    95
