      * CREDIT MEMO PROCESSING LDA LAYOUT
      *
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** BEGINING CREDIT NUMBER
     D  LBCRM                  4      9  0
      ** ENDING CREDIT NUMBER
     D  LECRM                 10     15  0
      ** CREDIT MEMO DATE
     D  LDATE                 16     21  0
      ** CREDIT MEMO END DATE
     D  LENDT                 22     27  0
      ** SHIP FROM LOCATION
     D  LSHFR                 28     30
      ** IMMEDIATE PRINT Y/N
     D  LIMED                 31     31
      ** BILL TO CUSTOMER
     D  LBLCS                 32     37  0
      ** SHIP TO CUSTOMER
     D  LSHCS                 38     43  0
      ** LAST INVOICE CREDITED
     D  LBINV                 44     49  0
      ** PRINTER ID
     D  LPRTR                100    109
      ** FORMS NUMBER
     D  LFORM                110    113
      ** NUMBER OF COPIES
     D  LCOPY                114    115  0
      ** JOBQ
     D  LJOB                 116    116
      ** HOLD PRINT OUTPUT
     D  LHOLD                117    120
      ** PRINT AND SAVE OUTPUT
     D  LSAVE                121    124
      ** CANCEL  X=CANCEL
     D  LCANCL               133    133
