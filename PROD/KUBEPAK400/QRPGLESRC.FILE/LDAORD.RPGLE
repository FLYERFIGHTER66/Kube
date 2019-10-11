      * ORDER ENTRY/PROCESSING LDA LAYOUT
      * INCLUDING: BIR100, POS, BIR310, BIR440, BIR235, BIC330, BIR330
      *  NOT DILLON,PLAINVEW,GRENLEAF
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LCO                    1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** ROUTE I.D.
     D  LDARTE                 4      5
      ** ROUTE ALL
     D  LDAALL                 6      8
      ** BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                  9     14  0
      ** ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 15     20  0
      ** INVOICE DATE
     D  LDATE                 21     26  0
      ** SHIP FROM LOCATION
     D  LSHFR                 27     29
      ** BEGINING ORDER NUMBER
     D  LBORD                 30     35  0
      ** ENDING ORDER NUMBER
     D  LEORD                 36     41  0
      ** POINT OF SALE INVOICE Y/N
     D  LPOS                  42     42
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 43     43
      ** BEGINING DATE
     D  LBEGDT                44     49  0
      ** ENDING DATE
     D  LENDDT                50     55  0
      ** SELECTION PICK SLIP
     D  LSELEC                56     56  0
      ** PRODUCT CLASS 1
     D  LPC1                  57     58
      ** PRODUCT CLASS 2
     D  LPC2                  59     60
      ** ROUTE 1
     D  LRTE1                 61     62
      ** ROUTE 2
     D  LRTE2                 63     64
      ** PHYTO 1
     D  LPHY1                 65     65
      ** PHYTO 2
     D  LPHY2                 66     66
      ** PREV. PRINTED
     D  LPREV                 67     67
      ** SHIP 1
     D  LSHP1                 68     69
      ** SHIP 2
     D  LSHP2                 70     71
      ** LOCATION 1
     D  LLOC1                 72     74
      ** LOCATION 2
     D  LLOC2                 75     77
      ** TAG
     D  LTAG                  78     78  0
      ** DATE
     D  LSTDAT                79     84  0
      ** SALE I.D.
     D  LSALE                 85     87
      ** DEPARTMENT
     D  LDEPT                 88     90
      ** SALE DATE
     D  TYCENB                91     95  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    119
      ** NUMBER OF COPIES
     D  LCOPY                120    121  0
      ** JOBQ
     D  LJOB                 122    122
      ** HOLD PRINT OUTPUT
     D  LHOLD                123    126
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                127    130
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
      ** PRINTER ID PICK SLIP 2
     D  LPRT2                134    143
      ** JULIAN DATE
     D  LJUL                 144    148  0
