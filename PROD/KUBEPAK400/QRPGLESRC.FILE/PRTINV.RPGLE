      **DESCRIPTION--------- THIS PROGRAM WILL RE-PRINT A SPECIFIC INVOICE
      *
      *   CHANGE--DATE-------DESCRIPTION
      * 01/02/2015 WJB Initial Programming
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
      *
      ****************
      *   LDA        *
      ****************
     D  LDA_DATA      UDS                  DTAARA(*LDA)
     D  LCO                    1      2  0                                      COMPANY
     D  LDARPT                 3      3                                         REPRINT Y/N
     D  LDARTE                 4      5                                         ROUTE I.D.
     D  LDAALL                 6      8                                         ROUTE ALL
     D  LBINV                  9     14  0                                      BEGINING INV NUMB
     D  LEINV                 15     20  0                                      ENDING INV NUMBER
     D  LDATE                 21     26  0                                      INVOICE DATE
     D  LSHFR                 27     29                                         SHIP FROM LOCATION
     D  LBORD                 30     35  0                                      BEGINING ORD NUMBER
     D  LEORD                 36     41  0                                      ENDING ORD NUMBER
     D  LPOS                  42     42                                         POS INVOICE Y/N
     D  LIMED                 43     43                                         IMMED PRINT Y/N
     D  LBEGDT                44     49  0                                      BEGINING DATE
     D  LENDDT                50     55  0                                      ENDING DATE
     D  LSELEC                56     56  0                                      SEL PICK SLIP
     D  LPC1                  57     58                                         PRODUCT CLASS 1
     D  LPC2                  59     60                                         PRODUCT CLASS 2
     D  LRTE1                 61     62                                         ROUTE 1
     D  LRTE2                 63     64                                         ROUTE 2
     D  LPHY1                 65     65                                         PHYTO 2
     D  LPHY2                 66     66                                         PHYTO 2
     D  LPREV                 67     67                                         PREV. PRINTED
     D  LSHP1                 68     69                                         SHIP 1
     D  LSHP2                 70     71                                         SHIP 2
     D  LLOC1                 72     74                                         LOCATION 1
     D  LLOC2                 75     77                                         LOCATION 2
     D  LTAG                  78     78  0                                      TAG
     D  LSTDAT                79     84  0                                      DATE
     D  LSALE                 85     87                                         SALE I.D.
     D  LDEPT                 88     90                                         DEPARTMENT
     D  TYCENB                91     95  0                                      SALE DATE
     D  LPRTR                100    109                                         PRINTER ID
     D  LFORM                110    119                                         FORMS NUMBER
     D  LCOPY                120    121  0                                      NUMBER COPIES
     D  LJOB                 122    122                                         JOBQ
     D  LHOLD                123    126                                         HOLD PRINT
     D  LSAVE                127    130                                         PRINT/SAVE
     D  LCANCL               133    133                                         X=CANCEL
     D  LPRT2                134    143                                         PRT PICK 2
     D  LJUL                 144    148  0                                      JULIAN DATE

     D  SelInv         S              6P 0                                      JULIAN DATE

      *
      ****************
      *   MAIN       *
      ****************
     C     *Entry        Plist
     C                   Parm                    SelInv

      /Free
         In LDA_DATA;
         LCO      =  1;
         LDARPT   =  *Blanks;
         LDARTE   =  *Blanks;
         LDAALL   =  *Blanks;
         LBINV    =  SelInv;
         LEINV    =  *Zero;
         LDATE    =  *Zero;
         LSHFR    =  *Blanks;
         LBORD    =  *Zero;
         LEORD    =  *Zero;
         LPOS     =  *Blanks;
         LIMED    =  *Blanks;
         LBEGDT   =  *Zero;
         LENDDT   =  *Zero;
         LSELEC   =  *Zero;
         LPC1     =  *Blanks;
         LPC2     =  *Blanks;
         LRTE1    =  *Blanks;
         LRTE2    =  *Blanks;
         LPHY1    =  *Blanks;
         LPHY2    =  *Blanks;
         LPREV    =  *Blanks;
         LSHP1    =  *Blanks;
         LSHP2    =  *Blanks;
         LLOC1    =  *Blanks;
         LLOC2    =  *Blanks;
         LTAG     =  *Zero;
         LSTDAT   =  *Zero;
         LSALE    =  *Blanks;
         LDEPT    =  *Blanks;
         TYCENB   =  *Zero;
         LPRTR    =  *Blanks;
         LFORM    =  *Blanks;
         LCOPY    =  *Zero;
         LJOB     =  *Blanks;
         LHOLD    =  *Blanks;
         LSAVE    =  *Blanks;
         LCANCL   =  *Blanks;
         LPRT2    =  *Blanks;
         LJUL     =  *Zero;
         out LDA_DATA;
      /End-Free

     C                   Call      'BIR331'
     C                   RETURN
