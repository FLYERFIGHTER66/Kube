             //   Tax calculations
             OITXCD = 'N';                                                    // TAX ITEM CODE 1
             OITXST = 'N';                                                    // TAX ITEM CODE 2
             OITXCT = 'N';                                                    // TAX ITEM CODE 3
             OITXLC = 'N';                                                    // TAX ITEM CODE 4
             If CMTXST = 'N';                                                 // Tax Exempt ?
               Chain CMTXJU FMTAXF;                                           // Item Master File
               If %found(FMTAXF);
                 OIAMT1=TXPCT1;                                               // TAX AMT RATE 1
                 OIAMT2=TXPCT2;                                               // TAX AMT RATE 2
                 OIAMT3=TXPCT3;                                               // TAX AMT RATE 3
                 If OIAMT1<>*Zero
                       or OIAMT2<>*Zero
                       or OIAMT3<>*Zero;
                   OITXCD='Y';                                                // TAX ITEM CODE 1
                 EndIf;
                 If OIAMT1<>*Zero;
                   OITXST='Y';                                                // TAX ITEM CODE 2
                 EndIf;
                 If OIAMT2<>*Zero;
                   OITXCT='Y';                                                // TAX ITEM CODE 3
                 EndIf;
                 If OIAMT3<>*Zero;
                   OITXLC='Y';                                                // TAX ITEM CODE 4
                 EndIf;
               EndIf;
             EndIf;

             OISTAT='A';                                                      // STATUS
             OIORD#=OHORD#;                                                   // ORDER NUMBER
             OISEQ#=OrderSeq#;                                                // SEQ NUMBER
             OIITEM=IMITEM;                                                   // ITEM NUMBER
             OISIZE=IMSIZE;                                                   // SIZE
             OIDES1=IMDES1;                                                   // DESCRIPTION 1
             OIDES2=IMDES2;                                                   // COMMENT
             OICOMP=IMCOMP;                                                   // COMPANY #
             OIWHSE=IMWHSE;                                                   // LOCATION
             OIBIN#=IMBIN#;                                                   // BIN #
             OIUUOM=IMPUOM;                                                   // UNIT OF MEASURE
             OIMULT=IMMULT;                                                   // MULT 1
             OIUWGT=IMUWGT;                                                   // UNIT WGT
             OIUCST=IMUCST;                                                   // UNIT COST
             OIUPRI=$UnitPrice(IMITEM:IMSIZE:CMCUST);                         // UNIT PRICE
             OIOVER=%CHAR(CMPRCD);                                            // OVERRIDE CODE
             OIOVER='N';                                                      // OVERRIDE CODE
             If TRSTAT = 'P';
               $SowD  = TRSCYM;
               $Ready = TRCRDT;
               LotPartPct = $LotPartPct(TRITEM:TRSIZE:$SowD:$Ready);
               If LotPartPct = *Zero;
                 LotPartPct = 1;
               EndIf;
               OIUPRI = OIUPRI * LotPartPct;
               PartText = 'Adj: (xxx of xxx) Disc: xx.x%';
               SaleableTot = $Saleable(TRSIZE);
               SaleableQty = $Saleable(TRSIZE)*(LotPartPct);
               Discount    = 100 - (LotPartPct*100);
               %Subst(PartText:07:3) = %EditW(SaleableQty:'  0');
               %Subst(PartText:14:3) = %EditW(SaleableTot:'  0');
               %Subst(PartText:24:5) = %EditW(Discount:'   .0');
               OIOVER = 'Y';
               OIPCTF = LotPartPct;
               Write RIORDRPART;
             EndIf;
             OIQDDC=IMDIS1;                                                   // QTY DISCOUNT
             OIEXT$=CountItem*OIUPRI;                                         // EXT AMOUNT
             OIQORD=CountItem;                                                // QTY ORDERED
             OIQSHP=*Zero;                                                    // QTY SHIPPED
             OIQBOO=*Zero;                                                    // QTY BACKORDERED
             OISHPC='02';                                                     // SHIP VIA CODE
             //  see above       Eval      OIAMT1=TXPCT1                                 TAX AMT RAT
             //  see above       Eval      OIAMT2=TXPCT2                                 TAX AMT RAT
             //  see above       Eval      OIAMT3=TXPCT3                                 TAX AMT RAT
             OIDISC=*Zero;                                                    // DISCOUNT AMT
             OISHCD=*Blanks;                                                  // SHIP RELEASE CODE
             OISHCD='N';                                                      // SHIP RELEASE CODE
             OIBOCD=IMBOOK;                                                   // ITEM B/O ALLOWED
             OISLM1=OHSLM1;                                                   // SALESPERSON 1
             OICOM1=OICOM1;                                                   // COMMISSION 1
             OISLM2=OISLM2;                                                   // SALESPERSON 2
             OICOM2=OICOM2;                                                   // COMMISSION 2
             OICUST=SMCUST;                                                   // CUSTOMER #
             OIDTRQ=ThisMonday;                                               // REQ SHIP DATE
             OIDTLA=TodayMDY;                                                 // LAST ACTIVITY DATE
             OITIME=Now;                                                      // TIME
             OIUSER=User;                                                     // USER
             OITRDC=BT_CMTRDC;                                                // TRADE DISC %
             OICTCD=CMCTCD;                                                   // CONTRACT PRICE CODE
             OICTCD='N';                                                      // CONTRACT PRICE CODE
             OICOFL='N';                                                      // CLOSED ORDER FLAG
             OIITYP=*Blanks;                                                  // ITEM TYPE
             OIQINV=*Zero;                                                    // INVOICE QTY SHIPPED
             OIPLPT='N';                                                      // PICK LIST PRINTED
             //  see above       Eval      OITXCD=IMTXBL                                 TAX ITEM CO
             //  see above       Eval      OITXST=IMTCD1                                 TAX ITEM CO
             //  see above       Eval      OITXCT=IMTCD2                                 TAX ITEM CO
             //  see above       Eval      OITXLC=IMTCD3                                 TAX ITEM CO
             OIROUT=*Blanks;                                                  // ROUTE NUMBER
             OISTOP=*Zero;                                                    // STOP
             OICWT =*Zero;                                                    // CATCH WEIGHT
             OILBS#=*Zero;                                                    // POUNDS
             OIWGSH=*Zero;                                                    // WEIGHT SHIPPED
             OIRSCD=*Blanks;                                                  // REASON
             OISEQP=*Zero;                                                    // PRIMARY SEQ #
             OIPRAL=*Blanks;                                                  // PROMO ALLOW
             OIBPUM=IMBPUM;                                                   // BASE PRICE UNIT OF
             OISUOM=IMBPUM;                                                   // SHIP UOM
             OIBLUM=IMBPUM;                                                   // BILL UOM
             OIMUL2=*Zero;                                                    // MULT 2
             OILOTC='Y';                                                      // LOT CONTROL
             OIOPFL=*Blanks;                                                  // OPEN ORDER POST FLA
             OIBOLN=*Blanks;                                                  // LINE ITEM PUT ON BO
             OIBORQ=ThisMonday;                                               // ORIG B/O REQ SHIP D
             OIPRBO='N';                                                      // PREVIOUS BACKORDER
             OIPRBO=' ';                                                      // PREVIOUS BACKORDER
             OISTA ='N';                                                      // SUBJ TO AVAIL FLAG
             OIINV#=*Zero;                                                    // INVOICE NUMBER
             OISHFR=CMSHFR;                                                   // SHIP FROM
             OITAGS=*Zero;                                                    // # TAGS
             OIPPDC='N';                                                      // PROMPT PAY DSC Y/N
             OIPHYT=CMPHYT;                                                   // PHYTO CODE
             OISCHM='N';                                                      // SCHED. TO MOVE FLAG
             OISCHS='N';                                                      // SCHED. TO SOW FLAG
             OIQTAL=*Zero;                                                    // QTY ALLOCATED
             OIGLNO=*Zero;                                                    // G/L # SPEC CHARGES
             OIITMA=IMLOOK;                                                   // ITEM ALPHA SEARCH
             OISEDP=*Blanks;                                                  // SEED ORDERED Y/N
             OIRVCD=*Zero;                                                    // EXPIRE DATE - CYMD
             OIQTE =*Blanks;                                                  // QUOTE LINE ITEM
             OIORDT=ThisMonday;                                               // HOLD ORIG REQ SHIP
             OIRVDT=TodayYMD7;                                                // REQ SHIP DATE CYMD
             OILOT#=*Blanks;                                                  // LOT NUMBER
             OIFRQD='N';                                                      // FORCE QTY DISC Y/N
             OISPFL=*Blanks;                                                  // SUMMARY PICKSLIP FL
             OIALPH=CMLOOK;                                                   // CUST ALPHA SEARCH
             OIPRCL=IMPCL1;                                                   // PROD CLASS 1
             OINPSL=*Blanks;                                                  // NO PICKSLIP FUTURE
             OIRQTY=*Zero;                                                    // PRE RELEASE QTY
             OIPOST=*Blanks;                                                  // POST FLAG
             OISOW =*Zero;                                                    // SOW DATE CYMD
             OICCDC=*Zero;                                                    // C&C OR SALE DISC. %
             OILIST=*Blanks;                                                  // LIST CODE
             OIROY =IMROYL;                                                   // ROYALTY EACH

             Tax1  = OIAMT1 * OIUPRI;                                         // ST Tax on Item
             Tax2  = OIAMT2 * OIUPRI;                                         // CO Tax on Item
             Tax3  = OIAMT3 * OIUPRI;                                         // MU Tax on Item

             TotalTax01 = TotalTax01 + Tax1;                                  // ST Total Tax
             TotalTax02 = TotalTax02 + Tax2;                                  // CO Total Tax
             TotalTax03 = TotalTax03 + Tax3;                                  // MU Total Tax
             TotalOrder = TotalOrder + OIEXT$;                                // Total Order Value

