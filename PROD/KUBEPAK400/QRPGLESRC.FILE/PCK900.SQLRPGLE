     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
        //
       //    SUMMARY PICKS FOR FINISHED TRUCKING
      //
     FPCK900P   O    E             PRINTER OFLIND(OA)

      //  Main procedure prototype & interface
     D PCK900          PR                  ExtPgm('PCK900')
     D #ThisDate                      6P 0 Const
     D #ThisOrder                     6P 0 Const
     D #UnprintedOnly                  N   Const
     D PCK900          PI
     D #ThisDate                      6P 0 Const
     D #ThisOrder                     6P 0 Const
     D #UnprintedOnly                  N   Const

     D GetOrder        PR
     D ProcessOrder    PR
     D  #Order#                       6S 0 Const
     D GetCarts        PR                  ExtPgm('BIR103')
     D  #OHDTRQ                       6P 0
     D  #OHORD#                       6P 0
     D  #CARTS52                      5P 2
     D  #SHOW                         1A   Const

     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$Monday

     D*#ThisDate       S              6P 0 Inz(081915)
     D ThisOrder       S              6S 0 Inz(0)
     D ThisLine        S              3S 0 Inz(0)
     D LastSize        S                   Like(OISIZE)
     D ThisDate        S               D
     D Date01          S              6S 0 Inz(0)
     D Date02          S              6S 0 Inz(0)
     D Date03          S              6S 0 Inz(0)
     D Date04          S              6S 0 Inz(0)
     D Date05          S              6S 0 Inz(0)
     D Date06          S              6S 0 Inz(0)
     D Date07          S              6S 0 Inz(0)

     D LPP             S              3S 0 Inz(55)
     D PrintIndex      S              4S 0 Inz(0)
     D BLANK70         S             70A   Inz(*Blanks)
     D Dots            S             30A   Inz('..............................')
     D Cart_Ord_Wk     S              7S 4 Inz(0)
     D Index           S              4S 0 Inz(0)
     D ShipVIACode     S              2A   Inz
     D ThisPage        S              4S 0 Inz(0)
     D endOfData       S               N   Inz(*Off)
     D index_Col1      S              4S 0 Inz(0)
     D index_Col2      S              4S 0 Inz(0)
     D #OHDTRQ         S              6P 0
     D #OHORD#         S              6P 0
     D #CARTS52        S              5P 2
     D #SHOW           S              1A

     D RHORDR        E DS                  Inz EXTNAME(FHORDR)
     D RIORDR        E DS                  Inz EXTNAME(FIORDR)
     D RMSIZE        E DS                  Inz EXTNAME(FMSIZE)
     D RMCUST        E DS                  Inz EXTNAME(FMCUST)

     D PrintDS         DS                  Inz
     D  Level                         1S 0 Inz(0)
     D  #OIITEM                            Like(OIITEM)
     D  #OISIZE                            Like(OISIZE)
     D  #OIDES1                            Like(OIDES1)
     D  #OIQORD                            Like(OIQORD)
     D  #OIQSHP                            Like(OIQSHP)
     D  #SZPCRT                            Like(SZPCRT)

     D PrintArray      S                   Inz Dim(9999) Like(PrintDS)
     D ConPhoSpecWk    S            256A
     D CityStZip       S             70A
     D Adr             S              1S 0 Inz(1)

     D AdrDS           DS                  Inz
     D  Adr1                               Inz
     D  Adr2                               Inz
     D  Adr3                               Inz
     D  Adr4                               Inz
     D  AdrArray                           Dim(4) Like(Adr1) Overlay(AdrDS)

     D UnprintedOnly   S               N    Inz(*On)
     D Printed         S               N    Inz(*On)
      /Free

    ? /COPY QFunctDefn,LASTUSEDCB

         Monitor;
           UnprintedOnly = #UnprintedOnly;
         On-Error;
         ENDMON;

         Monitor;
           If #ThisOrder = 0;
             ThisDate = $Monday($DateMDY(#ThisDate):'MON');
             Date01 = $MDYDate($AddDate(ThisDate:0));
             Date02 = $MDYDate($AddDate(ThisDate:1));
             Date03 = $MDYDate($AddDate(ThisDate:2));
             Date04 = $MDYDate($AddDate(ThisDate:3));
             Date05 = $MDYDate($AddDate(ThisDate:4));
             Date06 = $MDYDate($AddDate(ThisDate:5));
             Date07 = $MDYDate($AddDate(ThisDate:6));
             ShipViaCode = '01';
             GetOrders();
             ShipViaCode = '02';
             GetOrders();
           Else;
             ThisOrder = #ThisOrder;
             ProcessOrder(ThisOrder);
           EndIf;
         On-Error;
           *InLR = *On;
           Return;
         ENDMON;

         *InLR = *On;
         Return;

      /End-Free


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Get Order List Array                                             :
      // :..................................................................:
     P GetOrders       B
     D GetOrders       PI
      /Free

         SQLSTATE = '00000';
         Index = 0;

         Exec SQL  DECLARE OHC1 Cursor for     // Order Header Cursor
           SELECT  FHORDR.OHORD#
           FROM    FHORDR
           WHERE   FHORDR.OHORD# in (SELECT PLORD# FROM FIN_ORD)
             and   FHORDR.OHSTAT = 'A'
             and   FHORDR.OHSHPC = :ShipViaCode
             and   FHORDR.OHDTCN in
                   (:Date01 , :Date02, :Date03, :Date04,
                    :Date05 , :Date06, :Date07)
           ORDER BY FHORDR.OHSHZP, FHORDR.OHNAME
           For Read Only;

         Exec SQL   Close OHC1;
         Exec SQL   Open OHC1;

         SQLSTATE = '00000';
         DoW SQLSTATE = '00000';
           Exec SQL  Fetch OHC1 into :ThisOrder;
           If  SQLSTATE = '00000';
             If UnprintedOnly;
               Printed = *Off;
               Exec SQL Select '1' into :Printed from PCK900PF
                 Where ORDER# = :ThisOrder;
                 SQLSTATE = '00000';
               If Printed;
                 Iter;
               ENDIF;
             ENDIF;
            ProcessOrder(ThisOrder);
            SQLSTATE = '00000'; //Reset any SQL errors from ProcessOrder() routine
           ENDIF;
         ENDDO;
         Exec SQL   Close OHC1;


      /End-Free
     P GetOrders       E
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : PrintOrderList                                                   :
      // :..................................................................:
     P ProcessOrder    B
     D ProcessOrder    PI
     D  #ThisOrder                    6S 0 CONST
     D  isCustom       S               N
      /Free

         ThisLine = 0;
         ThisOrder = #ThisOrder;
         Clear Cart_Ord_Wk;
         LoadArray();

         If PrintIndex > 0;

            // - - - - - - - - - - - - - - - - -
           //  Load Order Header Information
          // - - - - - - - - - - - - - - - - - -

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

           Reset RMCUST;
           Exec SQL
             Select     *
             into      :RMCUST
             from       FMCUST
             where      CMCUST = :OHCUST;

           Reset AdrDS;
           CityStZip = %subst(%trim(
                       %Trim(OHSHCT)  + ', '  + OHSHST + ' ' +
                             OHSHZP)  + BLANK70:1:70);
           Adr = 1;
           If OHSHP2 <> *Blanks;
             AdrArray(Adr) = OHSHP2;
             Adr += 1;
           EndIf;
           If OHSHP3 <> *Blanks;
             AdrArray(Adr) = OHSHP3;
             Adr += 1;
           EndIf;
           If OHSHP4 <> *Blanks;
             AdrArray(Adr) = OHSHP4;
             Adr += 1;
           EndIf;
           If CityStZip <> *Blanks;
             AdrArray(Adr) = CityStZip;
             Adr += 1;
           EndIf;

           // Contact / Phone / Special Instructions
           ConPhoSpecWk = %Trim(CMCNME) + ' * ' + %editw(CMPHON:'   -   -    ');
           ConPhoSpec = %SubSt(ConPhoSpecWk:1:50);


           DateOrder = $DateMDY(OHDTOR);
           DelDate   = $DateMDY(OHDTCN);

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

           // Get Carts
           #OHDTRQ = OHDTRQ;
           #OHORD# = OHORD#;
           CallP GetCarts(#OHDTRQ:#OHORD#:#Carts52:'N');
           If #Carts52 <> 0;
             Cart_Ord_Wk = #Carts52;
           EndIf;

            // - - - - - - - - - - - -
           //  Process Details
          // - - - - - - - - - - - -

           ThisPage  = 0;
           endOfData = *Off;

           DoW not endOfData and (ThisPage - 1) * LPP * 2 < PrintIndex;
             ThisPage += 1;

             If (ThisPage - 1) * LPP * 2 < PrintIndex;
               Write Header;

               ThisLine  = 0;

               DoW ThisLine < LPP and not endOfData;
                 ThisLine += 1;

                 *In31 = *Off;   //  Item Detail 1
                 *In32 = *Off;   //  Plant Detail 1
                 *In33 = *Off;   //  Size Category 1

                 *In41 = *Off;   //  Item Detail 2
                 *In42 = *Off;   //  Plant Detail 2
                 *In43 = *Off;   //  Size Category 2

                 Clear QTY1;
                 Clear QTY2;

                 Index_col1 = ((ThisPage-1)*2*LPP)+ThisLine;
                 Index_col2 = Index_col1 + LPP;

                 PrintDS = PrintArray(Index_col1);
                 If #OIITEM <> ' ';
                   *In(30 + Level) = *On;
                   //ITEM1      = #OIITEM;
                   ITEMSIZE1  = %Trim(#OIITEM) + '-' + %Trim(#OISIZE);
                   QTY1       = #OIQORD - #OIQSHP;
                   IMDES133_1 = %Subst(%Trim(#OIDES1) + Dots:1:33);
                  Else;
                   IMDES133_1 = %Subst('.....End of Order' + Dots:1:33);
                   IMDES133_2 = %Subst('.....End of Order' + Dots:1:33);
                   endOfData = *On; //  When Col 1 has no more data, we are at the end.
                 EndIf;

                 PrintDS = PrintArray(Index_col2);
                 If #OIITEM <> ' ';
                   *In(40 + Level) = *On;
                   //ITEM2      = #OIITEM;
                   ITEMSIZE2  = %Trim(#OIITEM) + '-' + %Trim(#OISIZE);
                   QTY2       = #OIQORD - #OIQSHP;
                   IMDES133_2 = %Subst(%Trim(#OIDES1) + Dots:1:33);
                 EndIf;

                 Write Detail2;
               EndDo;

               Write Boxes2;
               Write Footer;
               Write Boxes;
             EndIf;

           EndDo;

           Clear Tot_Ord;
           Clear Cart_Ord;
           Clear Cart_Ord_Wk;

         EndIf;
         *InLR = *On;

         Exec SQL INSERT INTO PCK900PF
                  VALUES(:ThisOrder, '1', current timestamp);

      /End-Free
     P ProcessOrder    E


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Load Print Array                                                 :
      // :..................................................................:
     P LoadArray       B
     D LoadArray       PI
      /Free

         Exec SQL   DECLARE PAC1 Cursor for     //Print Array Cursor 1
           SELECT   0
                ,   OIITEM
                ,   OISIZE
                ,   OIDES1
                ,   OIQORD
                ,   OIQSHP
                ,   coalesce(SZPCRT,0)
           FROM     FIORDR left outer join FMSIZE
                 on FIORDR.OISIZE = FMSIZE.SZCODE
           WHERE    FIORDR.OIORD# = :ThisOrder
             and    FIORDR.OISTAT = 'A'
             and (( FIORDR.OIITYP = ' '
                and FIORDR.OIQORD - FIORDR.OIQSHP > 0 )
                 or FIORDR.OIITYP = 'C'
                and FIORDR.OIITEM = ' '   )
           ORDER BY FIORDR.OISIZE
                  , FIORDR.OIITMA
                  , FIORDR.OISEQ#
           For Read Only;

         Clear PrintArray;

         SQLSTATE = '00000';
         PrintIndex = 0;

         Exec SQL   Close PAC1;
         Exec SQL   Open PAC1;

         //  Read Entire Cursor DataSet
         DoW SQLSTATE = '00000';
             Exec SQL  Fetch PAC1 into :PrintDS;

           If  SQLSTATE = '00000';
             PrintIndex += 1;
             Level = 1;
             If #OISIZE <> LastSize;
               clear RMSIZE;
               Exec SQL
                 Select * Into :RMSIZE from FMSIZE where SZCODE = :#OISIZE;
               SQLState = '00000';
               LastSize = #OISIZE;
             ENDIF;
             If #OIITEM = *Blanks and #OIDES1 <> *Blanks;
               #OIITEM = '--';
             ENDIF;
             PrintArray(PrintIndex) = PrintDS;
             If Tot_Ord + ( #OIQORD - #OIQSHP ) > (10**%len(Tot_Ord))-1;
               Tot_Ord = (10**%len(Tot_Ord))-1;
              Else;
               Tot_Ord  = Tot_Ord + ( #OIQORD - #OIQSHP );
             EndIf;
             If #SZPCRT <> 0;
               Cart_Ord_Wk = Cart_Ord_Wk + ( (#OIQORD - #OIQSHP) / #SZPCRT );
             ENDIF;
           EndIf;

         ENDDO;

         //  Close Cursor
         Exec SQL   Close PAC1;
         Cart_Ord = Cart_Ord_wk;

      /End-Free
     P LoadArray       E
