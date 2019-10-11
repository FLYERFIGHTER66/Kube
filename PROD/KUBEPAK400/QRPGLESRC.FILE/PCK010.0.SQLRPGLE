     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

     FPCK010P   O    E             PRINTER OFLIND(OA)

      //  Main procedure prototype & interface
     D PCK010          PR                  ExtPgm('PCK010')
     D  #ThisOrder                    6P 0 Const
     D  #ThisGroup                   10A   Const
     D  #ThisList                     6A   Const
     D PCK010          PI
     D  #ThisOrder                    6P 0 Const
     D  #ThisGroup                   10A   Const
     D  #ThisList                     6A   Const

     D PrintOrderList  PR
     D LoadArray       PR
     D ConditionArray  PR
     D QtyThisItem     PR             4S 0
     D  #ITEM                        12A   Const
     D  #SIZE                         3A   Const

     D/COPY QFunctDefn,$_Dates

     D ThisOrder       S              6S 0 Inz(0)
     D ThisGroup       S             10A   Inz(*Blanks)
     D ThisList        S              6A   Inz(*Blanks)
     D ThisLine        S              3S 0 Inz(0)
     D OldCateg        S                   Like(SizeCateg)
     D OldPlant        S                   Like(PlantName)
     D Index           S              4S 0 Inz(0)
     D PrintIndex      S              4S 0 Inz(0)
     D ThisOrderList   S              6A   Inz('SPKUBE')
     D OrderListCols   S              1S 0 Inz(2)
     D LPP             S              3S 0 Inz(64)
     D BLANK70         S             70A   Inz(*Blanks)
     D Dots            S             30A   Inz('..............................')
     D Cart1           S              5S 3 Inz(0)
     D Cart2           S              5S 3 Inz(0)
     D Cart3           S              5S 3 Inz(0)
     D Cart_PG_wk      S              7S 4 Inz(0)
     D NextBreak       S              4S 0
     D CityStZip       S             55A
     D ADR2and3        S             55A
     D Adr             S              1S 0 Inz(1)
     D isCustom        S               N

     D AdrDS           DS                  Inz
     D  Adr1                               Inz
     D  Adr2                               Inz
     D  Adr3                               Inz
     D  AdrArray                           Dim(3) Like(Adr1) Overlay(AdrDS)

     D RHORDR        E DS                  Inz EXTNAME(FHORDR)
     D PrintDefaults E DS                  Inz EXTNAME(FMORLHCFG)

     D Seasons         DS                  DtaAra(WEB020CL)
     D  Seas01                        2S 0
     D  Seas02                        2S 0
     D  Seas03                        2S 0

     D Ord_Totals      DS                  Inz
     D  Tot_Ord                       4S 0 Inz(0)
     D  Cart_Ord                      4S 1

     D TruckDS         DS                  Inz
     D  TruckDate7                    7S 0
     D  Truck                         8A

     D PrintDS         DS                  Inz
     D  Level                         1S 0 Inz(0)
     D  ListId                        6A
     D  SizeCateg                    40A
     D  PlantName                    30A
     D  PlantDesc                    30A
     D  ITEM                         12A
     D  SIZE                          3A
     D  SZPCRT                        3S 0 Inz(0)

     D OrderListArray  S              6A   Inz Dim(9999)
     D PrintArray      S                   Inz Dim(9999) Like(PrintDS)


    ? /COPY QFunctDefn,LASTUSEDCB

      /Free
         Monitor;
           ThisGroup = #ThisGroup;
           ThisList  = #ThisList ;
           ThisOrder = #ThisOrder;
         On-Error;
           Clear ThisOrder;
         ENDMON;

         LoadOrderList();

         Index = 1;
         DoW OrderListArray(Index) <> *Blanks;

           ThisOrderList = OrderListArray(Index);
           PrintOrderList();
           Index += 1;

         ENDDO;

         If ThisList = '*ALL' or ThisList = ' ' or ThisList = 'OTHER';
           ThisOrderList = 'Other';
           PrintOrderList();
         EndIf;

         *InLR = *On;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Get Order List Array                                             :
      // :..................................................................:
     P LoadOrderList   B
     D LoadOrderList   PI
      /Free

         Clear OrderListArray;
         Reset PrintDS;
         Reset PrintArray;
         SQLSTATE = '00000';
         Index = 0;

         If ThisOrder = 0;   // Get All Order Lists for active Season(s)
           In Seasons;
           Exec SQL   DECLARE OLC1 Cursor for
             SELECT   DISTINCT FMORLS.OLLIST
             FROM     FMORLS
                ,     FMORLSEAS
             WHERE    FMORLS.OLLIST=FMORLSEAS.HSLIST
               and    FMORLSEAS.HSSNCD in
                          (:Seas01 , :Seas02, :Seas03)
             ORDER BY FMORLS.OLLIST
             For Read Only;
           Exec SQL   Open OLC1;
           DoW SQLSTATE = '00000';
             Exec SQL  Fetch OLC1 into :ThisOrderList;
             If  SQLSTATE = '00000';
              Index += 1;
              OrderListArray(Index) = ThisOrderList;
             ENDIF;
           ENDDO;
           Exec SQL   Close OLC1;

         Else;  //  Get All Order Lists for :ThisOrder
           Exec SQL   DECLARE OLC2 Cursor for
             SELECT   DISTINCT FMORLS.OLLIST
             FROM     FMORLS
                ,     FIORDR
                ,     FMORLHCFG
             WHERE    FMORLS.OLITEM = FIORDR.OIITEM
               and    FMORLS.OLSIZE = FIORDR.OISIZE
               and    FMORLS.OLLIST = FMORLHCFG.HCLIST
               and    FIORDR.OIORD# = :ThisOrder
               and  ( :ThisGroup    = '*ALL' or
                      :ThisGroup    = ' '    or
                      FMORLHCFG.HCGRUP = :ThisGroup  )
               and  ( :ThisList     = '*ALL' or
                      :ThisList     = ' '    or
                      FMORLHCFG.HCLIST = :ThisList   )
               and    FMORLHCFG.HCACTV = 'Y'
               and    FIORDR.OISTAT    = 'A'
             ORDER BY FMORLS.OLLIST
             For Read Only;
           Exec SQL   Open OLC2;
           DoW SQLSTATE = '00000';
             Exec SQL  Fetch OLC2 into :ThisOrderList;
             If  SQLSTATE = '00000';
              Index += 1;
              OrderListArray(Index) = ThisOrderList;
             ENDIF;
           ENDDO;
           Exec SQL   Close OLC2;

           Exec SQL
             SELECT  sum(oiqord - oiqshp)
                  ,  dec(int(sum((oiqord - oiqshp)/SZPCRT)*1000))/1000
             INTO   :Ord_Totals
             FROM    fiordr
                ,    fmsize
             WHERE   FIORDR.OISIZE= FMSIZE.SZCODE
               and   FIORDR.oiityp = ' '
               and   FIORDR.OISTAT = 'A'
               and   FIORDR.OIORD# = :ThisOrder ;

         EndIf;

      /End-Free
     P LoadOrderList   E
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : PrintOrderList                                                   :
      // :..................................................................:
     P PrintOrderList  B
     D PrintOrderList  PI
      /Free

         LoadArray();
         ThisLine = 0;

         If PrintIndex > 0;
           Reset RHORDR;
           OHSHP2 = 'Order Not Found on File';
           Exec SQL
             Select     *
             into      :RHORDR
             from       FHORDR
             where      OHORD# = :ThisOrder;

           isCustom = *Off;
           Exec SQL
             Select     '1'
             into      :isCustom
             from       FHORDRCSTM
             where      COORD# = :ThisOrder
             Fetch First Row Only;
           *In60 = isCustom;

           ADR2and3 = %subst(%trim(
                       %trim(OHSHP3)  + '   ' +
                       %trim(OHSHP4)) + BLANK70 :1:55);
           Reset AdrDS;
           CityStZip = %subst(%trim(
                       %Trim(OHSHCT)  + ', '  + OHSHST + ' ' +
                             OHSHZP)  + BLANK70:1:70);
           Adr = 1;
           If OHSHP2 <> *Blanks;
             AdrArray(Adr) = OHSHP2;
             Adr += 1;
           EndIf;
           If ADR2and3 <> *Blanks;
             AdrArray(Adr) = ADR2and3;
             Adr += 1;
           EndIf;
           If CityStZip <> *Blanks;
             AdrArray(Adr) = CityStZip;
             Adr += 1;
           EndIf;

           Clear TruckDS;

           Exec SQL
             SELECT TRSHDT
                  , trim(TRTRK#) || '-' || trim(char(TRSTP#))
             INTO   :TruckDS
             FROM   ftrschd
             WHERE  TRORD# = :ThisOrder
                and TRSHDT = (SELECT max(TRSHDT)
                              FROM   ftrschd
                              WHERE TRORD# = :ThisOrder);

           TruckDate = $MDYDate($Date(TRUCKDATE7));

           // DateOrder = $DateMDY(OHDTOR);
           // DelDate   = $DateMDY(OHDTCN);

           Order    = %char(ThisOrder);

           Exec SQL
             Select     Left(SVDESC,30)
             into      :ShipVia
             from       FMSVIA
             where      SVCODE = :OHSHPC;
           EvalR ShipVia = %Trim(ShipVia);

           Exec SQL
             Select     CMFILL
             into      :CMFILL
             from       FMCUST
             where      CMCUST = :OHCUST;

           Write Header;

           DoW ThisLine < LPP;
             ThisLine += 1;

             *In31 = *Off;   //  Item Detail 1
             *In32 = *Off;   //  Plant Detail 1
             *In33 = *Off;   //  Size Category 1

             *In41 = *Off;   //  Item Detail 2
             *In42 = *Off;   //  Plant Detail 2
             *In43 = *Off;   //  Size Category 2

             *In51 = *Off;   //  Item Detail 3
             *In52 = *Off;   //  Plant Detail 3
             *In53 = *Off;   //  Size Category 3

             Clear QTY1;
             Clear QTY2;
             Clear QTY3;

             Clear Cart1;
             Clear Cart2;
             Clear Cart3;

             If ThisLine  <= PrintIndex;
               PrintDS = PrintArray(ThisLine);
               Monitor;
                 Level = Level + 0;
               On-Error;
                 Level = 0;
               ENDMON;
               *In(30 + Level) = *On;
               PlantName1 = PlantName;
               SizeCateg1 = SizeCateg;
               ITEM1 = ITEM;
               //SIZE1 = SIZE;
               ITEMSIZE1 = %Trim(ITEM) + '-' + %Trim(SIZE);
               PlantDesc1 = %Subst(%Trim(PlantDesc) + Dots:1:30);
               PlantNm3_1 = PlantName;
               SizeCat3_1 = SizeCateg;
               PlantDs3_1 = %Subst(%Trim(PlantDesc) + Dots:1:21);
               If Level = 1;    // Only calc and add details if detail line
                 QTY1 = QtyThisItem(Item:Size);
                 Cart1 = QTY1 / SZPCRT;
               EndIf;
             EndIf;

             If ThisLine + LPP <= PrintIndex
                  and OrderListCols >= 2;
               PrintDS = PrintArray(ThisLine+LPP);
               Monitor;
                 Level = Level + 0;
               On-Error;
                 Level = 0;
               ENDMON;
               *In(40 + Level) = *On;
               PlantName2 = PlantName;
               SizeCateg2 = SizeCateg;
               ITEM2 = ITEM;
               //SIZE2 = SIZE;
               ITEMSIZE2 = %Trim(ITEM) + '-' + %Trim(SIZE);
               PlantDesc2 = %Subst(%Trim(PlantDesc) + Dots:1:30);
               PlantNm3_2 = PlantName;
               SizeCat3_2 = SizeCateg;
               PlantDs3_2 = %Subst(%Trim(PlantDesc) + Dots:1:21);
               If Level = 1;    // Only calc and add details if detail line
                 QTY2 = QtyThisItem(Item:Size);
                 Cart2 = QTY2 / SZPCRT;
               EndIf;
             EndIf;

             If ThisLine + LPP + LPP <= PrintIndex
                  and OrderListCols >= 3;
               PrintDS = PrintArray(ThisLine+LPP+LPP);
               Monitor;
                 Level = Level + 0;
               On-Error;
                 Level = 0;
               ENDMON;
               *In(50 + Level) = *On;
               PlantNm3_3 = PlantName;
               SizeCat3_3 = SizeCateg;
               ITEM3 = ITEM;
               PlantDs3_3 = %Subst(%Trim(PlantDesc) + Dots:1:21);
               If Level = 1;    // Only calc and add details if detail line
                 QTY3 = QtyThisItem(Item:Size);
                 Cart3 = QTY3 / SZPCRT;
               EndIf;
             EndIf;

             If OrderListCols <= 2;
               Tot_PG = Tot_PG + QTY1 + QTY2;
               Cart_PG_wk = Cart_PG_wk + Cart1 + Cart2;
               Write Detail2;
              else;
               Tot_PG = Tot_PG + QTY1 + QTY2 + QTY3;
               Cart_PG_wk = Cart_PG_wk + Cart1 + Cart2 + Cart3;
               Write Detail3;
             EndIf;

           EndDo;

           Cart_PG += Cart_PG_wk;

           If OrderListCols <= 2;
             Write Boxes2;
            else;
             Write Boxes3;
           EndIf;

           Write Footer;
           Write Boxes;

           Clear Tot_PG;
           Clear Cart_PG;
           Clear Cart_PG_wk;

         EndIf;

      /End-Free
     P PrintOrderList  E


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Load Print Array                                                 :
      // :..................................................................:
     P LoadArray       B
     D LoadArray       PI
      /Free

         ConditionArray();     //  Get Defaults for Conditioning Array Print

         Exec SQL   DECLARE PAC1 Cursor for     //Print Array Cursor 1 (Order Lists)
           SELECT   0
              ,     FMORLS.OLLIST
              ,     XATABL.TBLONG
              ,     FSERINF.SIPLNT
              ,     FMINVT.IMDES4
              ,     FMORLS.OLITEM
              ,     FMORLS.OLSIZE
              ,     FMSIZE.SZPCRT
           FROM     fmorls
              ,     fmsizd
              ,     XATABL
              ,     FMINser
              ,     FSERINF
              ,     fminvt
              ,     fmsize
           WHERE    FMORLS.OLSIZE = FMSIZD.SZCODE
             and    'SZ'||FMSIZD.SZCATG = XATABL.TBTBCD
             and    FMORLS.OLITEM  = FMINSER.ISITEM
             and    FMINSER.ISCODE = FSERINF.SICODE
             and    FMORLS.OLITEM  = FMINVT.IMITEM
             and    FMORLS.OLSIZE  = FMINVT.IMSIZE
             and    FMORLS.OLSIZE  = FMSIZE.SZCODE
             and    OLLIST = :ThisOrderList
           ORDER BY FMORLS.OLLIST
                  , FMSIZD.SZCATG
                  , FSERINF.SIPLNT
                  , FMINVT.IMDES4
           For Read Only;

         Exec SQL   DECLARE PAC2 Cursor for     //Print Array Cursor 2 (Non-Order Lists)
           SELECT   0
              ,    :ThisOrderList
              ,     'Items not on an Order Form'
              ,     'Miscellaneous'
              ,     FIORDR.OIDES1
              ,     FIORDR.OIITEM
              ,     FIORDR.OISIZE
              ,     0
           FROM FIORDR LEFT OUTER JOIN FMORLS
             ON OIITEM = OLITEM
            and OISIZE = OLSIZE
           WHERE OLITEM is null
             and OISTAT = 'A'
             and OIITYP = ' '         //Remove this if we want to see comments
             and OIORD# = :ThisOrder
           UNION
             SELECT   0
                ,    :ThisOrderList
                ,     'Items not on an Order Form'
                ,     'Miscellaneous'
                ,     FIORDR.OIDES1
                ,     FIORDR.OIITEM
                ,     FIORDR.OISIZE
                ,     0
             FROM FIORDR LEFT OUTER JOIN FMORLS
               ON OIITEM = OLITEM
              and OISIZE = OLSIZE
             WHERE OLITEM is not null
               and OISTAT = 'A'
               and OLLIST in
                    (SELECT HCLIST FROM FMORLHCFG WHERE HCACTV <> 'Y')
               and OIITYP = ' '         //Remove this is we want to see comments
               and OIORD# = :ThisOrder
           ORDER BY OIITEM, OIDES1
           For Read Only;

         Clear PrintArray;

         SQLSTATE = '00000';
         PrintIndex = 0;

         //  Open Appropriate Cursor
         If ThisOrderList <> 'Other';
           Exec SQL   Open PAC1;
         Else;
           Exec SQL   Open PAC2;
         EndIf;

         //  Read Entire Cursor DataSet
         DoW SQLSTATE = '00000';
           If ThisOrderList <> 'Other';
             Exec SQL  Fetch PAC1 into :PrintDS;
           else;
             Exec SQL  Fetch PAC2 into :PrintDS;
             If SQLSTATE = '00000';
               SZPCRT = 1;
               Exec SQL  Select  SZPCRT
                         into   :SZPCRT
                         from    FMSIZE
                         where   SZCODE = :SIZE ;
             EndIf;
           EndIf;

           If  SQLSTATE = '00000';

             //  Process New Record
             CheckSpaces();

             If SizeCateg <> OldCateg and HCSZPT = 'Y';
               OldCateg = SizeCateg;
               Level = 3;
               If PrintIndex > 1;
                 PrintIndex += (1 + HCSZSB);
               Else;
                 PrintIndex += 1;
               EndIf;
               PrintArray(PrintIndex) = PrintDS;
               OldPlant = '**New Category**';
             EndIf;
             If PlantName <> OldPlant and HCPTPT = 'Y';
               OldPlant = PlantName;
               Level = 2;
               If PrintIndex > 1;
                 PrintIndex += (1 + HCPTSB);
               Else;
                 PrintIndex += 1;
               EndIf;
               PrintArray(PrintIndex) = PrintDS;
             ENDIF;
             Level = 1;
             If PrintIndex > 1;
               PrintIndex += (1 + HCITSB);
             Else;
               PrintIndex += 1;
             EndIf;
             PrintArray(PrintIndex) = PrintDS;
           EndIf;
         ENDDO;

         //  Close Appropriate Cursor
         If ThisOrderList <> 'Other';
           Exec SQL   Close PAC1;
         Else;
           Exec SQL   Close PAC2;
         EndIf;

      /End-Free
     P LoadArray       E
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Check for blank Spaces and new Columns                           :
      // :..................................................................:
     P CheckSpaces     B
     D CheckSpaces     PI
     D  LinesLeft      S              4S 0
     D  Lines2Prt      S              4S 0
      /Free

         //  How Many Lines left in Column ?
         If  PrintIndex > 1;
           NextBreak = (%Int((PrintIndex-1)/LPP)+1) * LPP;
         Else;
           NextBreak = LPP;
         EndIf;
         LinesLeft = NextBreak - PrintIndex;

         //  How Many Lines do we need to print ?
         Lines2Prt = *Zero;
         If OldCateg <> SizeCateg and HCSZPT = 'Y';
           Lines2Prt += (1 + HCSZSB);  //For the Size Break
         EndIf;
         If OldPlant <> PlantName  and HCPTPT = 'Y';
           Lines2Prt += (1 + HCPTSB);  //For the Plant Break
         EndIf;
         Lines2Prt += (1 + HCITSB);  //For the Item

         //  If we don't have enough lines in this column to print,
         //    skip to new column and re-print Size and Plant if specified.

         If LinesLeft < Lines2Prt;
           PrintIndex = NextBreak;
           If HCSZNC = 'Y' and OldCateg = SizeCateg;    // If new categ let normal logic handle
             Level = 3;
             PrintIndex += 1;
             SizeCateg = %Trim(SizeCateg) + ' (cont.)';
             PrintArray(PrintIndex) = PrintDS;
             SizeCateg = OldCateg;  // Set it back so it doesn't cause new categ logic
           EndIf;
           If HCPTNC = 'Y' and OldPlant = PlantName;    // If new plant let normal logic handle
             Level = 2;
             PrintIndex += 1;
             PlantName = %Trim(PlantName) + ' (cont.)';
             PrintArray(PrintIndex) = PrintDS;
             PlantName = OldPlant;  // Set it back so it doesn't cause new plant logic
           EndIf;
         EndIf;

      /End-Free
     P CheckSpaces     E
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Condition the Array                                              :
      // :..................................................................:
     P ConditionArray  B
     D ConditionArray  PI
      /Free

         //    HCGRUP             FMORLHCFG          List Group
         //    HCCOPP             FMORLHCFG          Columns Per Page
         //    HCSZSB             FMORLHCFG          Spaces Between Size Categ
         //    HCSZNC             FMORLHCFG          Repeat Size Cat Nxt Columm
         //    HCPTSB             FMORLHCFG          Spaces Between Plants
         //    HCPTNC             FMORLHCFG          Repeat Plant Nxt Columm
         //    HCITSB             FMORLHCFG          Spaces Between Items
         Exec SQL
           Select   *
           into    :PrintDefaults
           from     FMORLHCFG
           where    HCLIST = :ThisOrderList;

         OrderListCols = HCCOPP;

         ListName = 'Items not on an Order Form';
         Exec SQL
           Select   HLDESC
           into    :ListName
           from     FMORLH
           where    HLLIST = :ThisOrderList;

      /End-Free
     P ConditionArray  E
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Qutantity This Item                                              :
      // :..................................................................:
     P QtyThisItem     B
     D QtyThisItem     PI             4S 0
     D  #ITEM                        12A   Const
     D  #SIZE                         3A   Const
     D  #ItemQty       S              4S 0 Inz(0)
      /Free

         Exec SQL
           Select   sum(OIQORD - OIQSHP)
           into    :#ItemQty
           from     FIORDR
           where    OIORD# = :ThisOrder
             and    OISTAT = 'A'
             and    OIITYP = ' '
             and    OIITEM = :#ITEM
             and    OISIZE = :#SIZE;

         Return #ItemQty;

      /End-Free
     P QtyThisItem     E

