    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      //??:````````````````````````````````````````````````````````````:?
      //??:     Calculate type and Number of Carts for an Order        :?
      //??:............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  Sep. 2004            ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Program Description                                     ?:
      //? :                                                           ?:
      //? :   This program calculates and then displays a screen      ?:
      //? : showing the type and count of carts needed for a specific ?:
      //? : order.                                                    ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Subroutine Usage                                        ?:
      //? :                                                           ?:
      //? : Subroutine ?-Subroutine Description                  ?  ?:
      //? :  *INZSR      -?Initialization Subroutine                  ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Function Usage                                          ?:
      //? :                                                           ?:
      //? : Function   ?-Function Description                    ?  ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Indicator Usage                                         ?:
      //? :                                                           ?:
      //? : *IND  ?-Indicator Usage                              ?  ?:
      //? :  LR      ?Does this really need a description ?           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Change Log                                              ?:
      //? :                                                           ?:
      //? : Int   Date  ?-Change Description                     ?  ?:
      //? :  WB01 4/15/05  ?Changed program to output the NeededWhole ?:
      //? :                ?arrray to the UDS on completion.          ?:
      //? :............................................................:

     FBIR103FM  CF   E             WORKSTN USROPN
     FBIR103PF  UF A E           K DISK

      //?  LDA
     D                UDS
     D UDSCarts@             901    945A                                        ?Whole Carts Needed
     D UDSCarts                       3S 0 DIM(15) OverLay(UDSCarts@)

      //? Screen Data Structures
     D  NeededPart     DS
     D Cart01Part                     5S 2                                      ?1 Shelf Carts
     D Cart02Part                     5S 2                                      ?2 Shelf Carts
     D Cart03Part                     5S 2                                      ?3 Shelf Carts
     D Cart04Part                     5S 2                                      ?4 Shelf Carts
     D Cart05Part                     5S 2                                      ?5 Shelf Carts
     D Cart06Part                     5S 2                                      ?6 Shelf Carts
     D Cart07Part                     5S 2                                      ?7 Shelf Carts
     D Cart08Part                     5S 2                                      ?8 Shelf Carts
     D Cart09Part                     5S 2                                      ?9 Shelf Carts
     D Cart10Part                     5S 2                                      ?10 Shelf Carts
     D Cart11Part                     5S 2                                      ?11 Shelf Carts
     D Cart12Part                     5S 2                                      ?12 Shelf Carts
     D Cart13Part                     5S 2                                      ?13 Shelf Carts
     D Cart14Part                     5S 2                                      ?14 Shelf Carts
     D Cart15Part                     5S 2                                      ?15 Shelf Carts
     D CartPart                       5S 2 DIM(15) OverLay(NeededPart)
     D                                     Inz(*Zero)

     D  NeededWhole    DS
     D Cart01Whol                     3S 0                                      ?1 Shelf Carts
     D Cart02Whol                     3S 0                                      ?2 Shelf Carts
     D Cart03Whol                     3S 0                                      ?3 Shelf Carts
     D Cart04Whol                     3S 0                                      ?4 Shelf Carts
     D Cart05Whol                     3S 0                                      ?5 Shelf Carts
     D Cart06Whol                     3S 0                                      ?6 Shelf Carts
     D Cart07Whol                     3S 0                                      ?7 Shelf Carts
     D Cart08Whol                     3S 0                                      ?8 Shelf Carts
     D Cart09Whol                     3S 0                                      ?9 Shelf Carts
     D Cart10Whol                     3S 0                                      ?10 Shelf Carts
     D Cart11Whol                     3S 0                                      ?10 Shelf Carts
     D Cart12Whol                     3S 0                                      ?10 Shelf Carts
     D Cart13Whol                     3S 0                                      ?10 Shelf Carts
     D Cart14Whol                     3S 0                                      ?10 Shelf Carts
     D Cart15Whol                     3S 0                                      ?10 Shelf Carts
     D CartWhole                      3S 0 DIM(15) OverLay(NeededWhole)
     D                                     Inz(*Zero)

     D  NeededShelf    DS
     D Shelf01                        7S 2                                      ?1 Shelf Shelves
     D Shelf02                        7S 2                                      ?2 Shelf Shelves
     D Shelf03                        7S 2                                      ?3 Shelf Shelves
     D Shelf04                        7S 2                                      ?4 Shelf Shelves
     D Shelf05                        7S 2                                      ?5 Shelf Shelves
     D Shelf06                        7S 2                                      ?6 Shelf Shelves
     D Shelf07                        7S 2                                      ?7 Shelf Shelves
     D Shelf08                        7S 2                                      ?8 Shelf Shelves
     D Shelf09                        7S 2                                      ?9 Shelf Shelves
     D Shelf10                        7S 2                                      ?10 Shelf Shelves
     D Shelf11                        7S 2                                      ?11 Shelf Shelves
     D Shelf12                        7S 2                                      ?12 Shelf Shelves
     D Shelf13                        7S 2                                      ?13 Shelf Shelves
     D Shelf14                        7S 2                                      ?14 Shelf Shelves
     D Shelf15                        7S 2                                      ?15 Shelf Shelves
     D Shelves                        7S 2 DIM(15) OverLay(NeededShelf)
     D                                     Inz(*Zero)

     D  RuleOfNines    DS
     D Nines01                        7S 2                                      ?1 Nines Shelves
     D Nines02                        7S 2                                      ?2 Nines Shelves
     D Nines03                        7S 2                                      ?3 Nines Shelves
     D Nines04                        7S 2                                      ?4 Nines Shelves
     D Nines05                        7S 2                                      ?5 Nines Shelves
     D Nines06                        7S 2                                      ?6 Nines Shelves
     D Nines07                        7S 2                                      ?7 Nines Shelves
     D Nines08                        7S 2                                      ?8 Nines Shelves
     D Nines09                        7S 2                                      ?9 Nines Shelves
     D Nines10                        7S 2                                      ?10 Nines Shelves
     D Nines11                        7S 2                                      ?11 Nines Shelves
     D Nines12                        7S 2                                      ?12 Nines Shelves
     D Nines13                        7S 2                                      ?13 Nines Shelves
     D Nines14                        7S 2                                      ?14 Nines Shelves
     D Nines15                        7S 2                                      ?15 Nines Shelves
     D Nines                          7S 2 DIM(15) OverLay(RuleOfNines)
     D                                     Inz(*Zero)
     D Apply9          S              1A   DIM(15)

     D  Shelf_Method   DS
     D ShelfNed01                     7S 2                                      ?1 ShelfM Shelves
     D ShelfNed02                     7S 2                                      ?2 ShelfM Shelves
     D ShelfNed03                     7S 2                                      ?3 ShelfM Shelves
     D ShelfNed04                     7S 2                                      ?4 ShelfM Shelves
     D ShelfNed05                     7S 2                                      ?5 ShelfM Shelves
     D ShelfNed06                     7S 2                                      ?6 ShelfM Shelves
     D ShelfNed07                     7S 2                                      ?7 ShelfM Shelves
     D ShelfNed08                     7S 2                                      ?8 ShelfM Shelves
     D ShelfNed09                     7S 2                                      ?9 ShelfM Shelves
     D ShelfNed10                     7S 2                                      ?10 ShelfM Shelves
     D ShelfNed11                     7S 2                                      ?11 ShelfM Shelves
     D ShelfNed12                     7S 2                                      ?12 ShelfM Shelves
     D ShelfNed13                     7S 2                                      ?13 ShelfM Shelves
     D ShelfNed14                     7S 2                                      ?14 ShelfM Shelves
     D ShelfNed15                     7S 2                                      ?15 ShelfM Shelves
     D ShelfNed                       7S 2 DIM(15) OverLay(Shelf_Method)
     D                                     Inz(*Zero)

     D XFootNed01                     7S 2 DIM(01) OverLay(Shelf_Method)
     D XFootNed02                     7S 2 DIM(02) OverLay(Shelf_Method)
     D XFootNed03                     7S 2 DIM(03) OverLay(Shelf_Method)
     D XFootNed04                     7S 2 DIM(04) OverLay(Shelf_Method)
     D XFootNed05                     7S 2 DIM(05) OverLay(Shelf_Method)
     D XFootNed06                     7S 2 DIM(06) OverLay(Shelf_Method)
     D XFootNed07                     7S 2 DIM(07) OverLay(Shelf_Method)
     D XFootNed08                     7S 2 DIM(08) OverLay(Shelf_Method)
     D XFootNed09                     7S 2 DIM(09) OverLay(Shelf_Method)
     D XFootNed10                     7S 2 DIM(10) OverLay(Shelf_Method)
     D XFootNed11                     7S 2 DIM(11) OverLay(Shelf_Method)
     D XFootNed12                     7S 2 DIM(12) OverLay(Shelf_Method)
     D XFootNed13                     7S 2 DIM(13) OverLay(Shelf_Method)
     D XFootNed14                     7S 2 DIM(14) OverLay(Shelf_Method)
     D XFootNed15                     7S 2 DIM(15) OverLay(Shelf_Method)
     D ApplySM         S              1A   DIM(15)

     D  CartNeedDS     DS
     D Cart01Need                     3S 0                                      ?1 Shelf Carts
     D Cart02Need                     3S 0                                      ?2 Shelf Carts
     D Cart03Need                     3S 0                                      ?3 Shelf Carts
     D Cart04Need                     3S 0                                      ?4 Shelf Carts
     D Cart05Need                     3S 0                                      ?5 Shelf Carts
     D Cart06Need                     3S 0                                      ?6 Shelf Carts
     D Cart07Need                     3S 0                                      ?7 Shelf Carts
     D Cart08Need                     3S 0                                      ?8 Shelf Carts
     D Cart09Need                     3S 0                                      ?9 Shelf Carts
     D Cart10Need                     3S 0                                      ?10 Shelf Carts
     D Cart11Need                     3S 0                                      ?10 Shelf Carts
     D Cart12Need                     3S 0                                      ?10 Shelf Carts
     D Cart13Need                     3S 0                                      ?10 Shelf Carts
     D Cart14Need                     3S 0                                      ?10 Shelf Carts
     D Cart15Need                     3S 0                                      ?10 Shelf Carts
     D CartNeed                       3S 0 DIM(15) OverLay(CartNeedDS)
     D                                     Inz(*Zero)

      //? Carts Data Structure
     D  Carts_DS       DS                  Inz
     D Cart_Size                      3S 0                                      ?# Shelves Per Cart
     D Cart_Needed                    7S 3                                      ?# Carts needed
     D Shelf_Needed                   9S 3                                      ?# Shelves Needed

      //? Work Arrays
     D  Extra          S              7S 2 Inz(*Zero) Dim(15)                   ?Extra Space
     D  Partial        S              7S 2 Inz(*Zero) Dim(15)                   ?Partial Carts
     D  Whole          S              5S 0 Inz(*Zero) Dim(15)                   ?Whole Carts

      //? Field Definitions
     D  Ship_Date_7    S              7S 0                                      ?Ship Date CYMD
     D  LeftOver9      S              7S 2
     D  LeftOverSM     S              7S 2
     D  Smallest9s     S              7S 2                                      ?Smallest Rule of 9s
     D  SmallestSM     S              7S 2                                      ?Smallest Shelf Meth
     D  Small9Size     S              2S 0                                      ?Size of Smallest 9s
     D  SmallSMSize    S              2S 0                                      ?Size of Smallest SM
     D  Partial9       S              7S 2                                      ?Partial 9's Carts
     D  x              S              2S 0
     D  y              S              2S 0
     D  Off15          S             15A   Inz('000000000000000')

      //? Indicators
     D  Found9         S               N                                        ?Found Rule of 9's
     D  FoundSM        S               N                                        ?Found Shelf Method
     D  TestScreen     S               N   Inz(*Off)                            ?Found Shelf Method
     D  EndOfFile      S               N   Inz(*Off)

      //? Function Prototypes
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User

      //?  ...........................................................
      //?  :    M A I N   C A L C U L A T I O N S                    :
      //?  :.........................................................:

     C     OrderDate     KList
     C                   KFld                    Order#                         ?Order Number
     C                   KFld                    ShipDate                       ?Ship Date
      /FREE
    ?  Chain OrderDate BIR103PF;
       Clear NeededPart;
       Clear NeededWhole;
       Clear NeededShelf;
       Clear RuleOfNines;
       Clear Shelf_Method;
       Clear CartNeedDS;
    ?  ExSr GetData;
    ?
       //? Read through SQL cursor and Print
    ?  ExSr ReadData;
       DoW not EndOfFile;
         ExSr LoadScreen;
    ?    ExSr ReadData;
       EndDo;

       ExSr CloseData;
      /END-FREE
     C                   XFoot     CartPart      TotalPart
     C                   XFoot     CartWhole     TotalWhole
     C                   XFoot     Shelves       TotalShelf
     C                   ExSr      NinesSR
     C                   XFoot     Nines         TotalNines
     C                   ExSr      ShelfMethod
     C                   XFoot     ShelfNed      ShelfNedTT
      /FREE
       x = 0;
       DOU x >= 15;
         x = x + 1;
         If %Int(ShelfNed(x)/x) <= 999;
           CartNeed(x) = %Int(ShelfNed(x)/x);
           If %Int(ShelfNed(x)/x) < ShelfNed(x)/x;
             CartNeed(x) = %Int(ShelfNed(x)/x) + 1;
           Else;
             CartNeed(x) = %Int(ShelfNed(x)/x);
           EndIf;
         Else;
           CartNeed(x) = 999;
         EndIf;
       EndDo;

      /END-FREE
     C                   XFoot     CartNeed      CartNeedTT
      /FREE

       If %Found(BIR103PF);
         Update BIR103R;
       Else;
         DATESHIP = $DateMDY(SHIPDATE);
         Write BIR103R;
       EndIf;

       If %Open(BIR103FM);
         If Show_YN = 'Y';
           ExFmt BIR10301;
           If *In16;
             ExFmt BIR10301TT;
             *In16 = *Off;
           EndIf;
         EndIf;
         Close BIR103FM;
       EndIf;

       UDSCarts = CartNeed;
       *InLR = *On;


       //?  ...........................................................
       //?  :      GetData - Get selected A/R Open information        :
       //?  :.........................................................:

       BegSr GetData;

    ?  exec sql
    ?
    ?    DECLARE   C1 cursor for
    ?
    ?    SELECT  SZSHLV
NEW ?          , Case when sum(OIRQTY) <> 0 then sum(OIRQTY/SZPCRT)
NEW ?            else sum((OIQORD-OIQSHP)/SZPCRT) end as Carts
NEW ?          , Case when sum(OIRQTY) <> 0 then sum((OIRQTY/SZPCRT)*SZSHLV)
NEW ?            else sum(((OIQORD-OIQSHP)/SZPCRT)*SZSHLV) end as Shelves
    ?    FROM        FIORDR, FMSIZE
    ?    WHERE       OISIZE = SZCODE
    ?            and OIRVDT = :Ship_Date_7
    ?            and OIITYP <> 'C'
    ?            and OIORD# = :Order#
    ?            and OISTAT = 'A'
    ?    GROUP BY SZSHLV
    ?    ORDER BY SZSHLV
    ?
    ?    For Read only;


         //  Open the SQL recordset
    ?  exec sql    Open      C1;

       EndSr;

       //?  ...........................................................
       //?  :      CloseDate - Close the Data Set                     :
       //?  :.........................................................:

       BegSr CloseData;

         //  Close the SQL recordset
    ?  exec sql    Close C1;

       EndSr;

       //?  ...........................................................
       //?  :      ReadData - Read Data                               :
       //?  :.........................................................:

       BegSr ReadData;

         //  Read Sow Schedule Records for Selected Week
    ?  exec sql
    ?   Fetch C1 into :Carts_DS;

         If SQLSTT = '02000';                                                 //?Read until EOF
           EndOfFile = *On;
         Else;
           EndOfFile = *Off;
         EndIf;

       EndSr;

       //?  ...........................................................
       //?  :      LoadScreen - Load SQL Values into Screen fields    :
       //?  :.........................................................:

       BegSr LoadScreen;

         //? Place the number of carts needed in the field for appropriate size.
         If Cart_Size < 1
               or Cart_Size > 15;
           Cart_Size = 1;
           *In50 = *On;
         EndIf;

         If Cart_Needed > 999.00;
           Cart_Needed = 999.00;
         ENDIF;

         CartPart(Cart_Size) = Cart_Needed;
         Shelves(Cart_Size) = Shelf_Needed;
         If %Int(CartPart(Cart_Size)) <
               CartPart(Cart_Size);
           CartWhole(Cart_Size) =
               %Int(CartPart(Cart_Size) + 1);
         Else;
           CartWhole(Cart_Size) = Cart_Needed;
         EndIf;

       EndSr;


       //?  ...........................................................
       //?  :      NinesSR    - Process the Rule of Nines             :
       //?  :.........................................................:

       BegSr NinesSR;

         RuleOfNines = NeededShelf;
         DoU Found9 = *Off;
           Found9 = *Off;

           //?  Find the least populated Partial Cart between 05 and 08 shelves
           x = 9;
           Smallest9s = 99999.99;
           DOU x = 5;
             x = x - 1;
             Partial9 = x-((CartWhole(x)*x)-Nines(x));
             If Partial9 = x;
               Partial9 = 0;
             EndIf;
             If Partial9 < Smallest9s and
                   Partial9 > *Zeros and
                   Apply9(x) <> 'Y';
               Smallest9s = Partial9;
               Small9Size = x;
               Found9 = *On;
             EndIf;
           EndDo;
           //?  See if there is leftover space on a 9 shelf cart
           If Found9;
             Apply9(Small9Size) = 'Y';
             Leftover9 = 9-(Nines(9)/9-%Int(Nines(9)/9))*9;
             If Leftover9 = 9;
               Leftover9 = 0;
             EndIf;
             If Leftover9 >= Smallest9s;
               Nines(9) = Nines(9) + Smallest9s;
               Nines(Small9Size) = Nines(Small9Size)
                   - Smallest9s;
             Else;
               Nines(9) = Nines(9) + Leftover9;
               Nines(Small9Size) = Nines(Small9Size)
                   - Leftover9;
             EndIf;
           EndIf;
         EndDo;

       EndSr;

       //?  ...........................................................
       //?  :      CalcCarts - Calculate Partial, Whole & Extra       :
       //?  :.........................................................:

       BegSr CalcCarts;

         Clear Whole;
         Clear Partial;
         Clear Extra;
         y = 16;
         DOU y = 1;
           y = y - 1;
           //?          Whole Carts
           If %Int(ShelfNed(y)/y) = ShelfNed(y)/y;
             Whole(y) = %Int(ShelfNed(y)/y);
           Else;
             Whole(y) = %Int(ShelfNed(y)/y) + 1;
           EndIf;
           //?          Partial (material to try to move)
           Partial(y) = y-((Whole(y)*y)-ShelfNed(y));
           If Partial(y) = y;
             Partial(y) = 0;
           EndIf;
           //?          Extra   (Extra space to be filled)
           Extra(y) = y - Partial(y);
           If Extra(y) = y;
             Extra(y) = 0;
           EndIf;
         EndDo;

       EndSr;

       //?  ...........................................................
       //?  :      ShelfMethod - Process the Shelf Method             :
       //?  :.........................................................:

       BegSr ShelfMethod;

         //?  Starting Point for Shelf Method is the results of the Rule of 9's
         Shelf_Method = RuleOfNines;
         ExSr CalcCarts;
         //?  Keep trying this routine until no more carts are candidates for consolidation
         DoU FoundSM = *Off;
           FoundSM = *Off;
           SmallestSM = 99999.99;

           //?  Find the least populated Partial Cart between 01 and 15 shelves
           x = 16;
           DOU x = 1;
             x = x - 1;
             If Partial(x) < SmallestSM and
                   Partial(x) > *Zeros     and
                   ApplySM(x) <> 'Y';
               SmallestSM = Partial(x);
               SmallSMSize = x;
               FoundSM = *On;
             EndIf;
           EndDo;

           //?  Now that we have the smallest cart,
           //?  Determine How much space is left on lower # carts
           If FoundSM;
             //?  Mark this size as having been processed.
             ApplySM(SmallSMSize) = 'Y';
             //?  Sum all extra space for Carts with fewer shelves
             x = SmallSMSize - 1;
             LeftOverSM = 0;
             DoW x > 0;
               LeftOverSM = LeftOverSM + Extra(x);
               x = x - 1;
             EndDo;
             //?  If there is enough room, Distribute amongst carts with fewer shelves.
             If LeftOverSM > SmallestSM;
               x = SmallSMSize;
               DoW X > 1;
                 x = x - 1;

                 If Extra(x) > *Zero;
                   If Extra(x) > SmallestSM;
                     //?      If extra is enough for entire partial,  move partial to extra.
                     ShelfNed(x) = ShelfNed(x) + SmallestSM;
                     ShelfNed(SmallSMSize) = ShelfNed(SmallSMSize)
                         - SmallestSM;
                     ExSr CalcCarts;
                     x = 0;
                   Else;
                     //?      If extra is not enough for entire partial,  move part of partial to ex
                     ShelfNed(x) = ShelfNed(x) + Extra(x);
                     ShelfNed(SmallSMSize) = ShelfNed(SmallSMSize)
                         - Extra(x);
                     ExSr CalcCarts;
                   EndIf;
                 EndIf;
               EndDo;
             EndIf;
           EndIf;
         EndDo;

       EndSr;

       //?  ...........................................................
       //?  :      *INZSR - Initialization Subroutine                 :
       //?  :.........................................................:

       BEGSR *INZSR;

      /END-FREE
     C     *Entry        PList
     C                   Parm                    ShipDate                       ?Ship Date
     C                   Parm                    Order#                         ?Order Number
     C                   Parm      TotalPart     Qty_Carts         5 2          ?Number of Carts
     C                   Parm                    Show_YN           1            ?Show Screen Y/N

      /FREE
         If Show_YN = 'Y';
           Open BIR103FM;
         EndIf;

         If ShipDate = 0;
           *InLr = *On;
           Return;
         EndIf;

         Ship_Date_7 = $Date7($DateMDY(ShipDate));

       EndSR;
      /END-FREE
