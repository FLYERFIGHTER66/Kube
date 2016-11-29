       //  ...........................................................
       //  :      Wrt_HORDR - Write the Order Header                 :
       //  :.........................................................:
       BegSr Wrt_HORDR;                                                       //?

         Clear RHORDR;
         Clear BillTo;
         Chain CMBLCU FMCUSTCN;                                               //?Get billto info
         Clear RMTERM;
         Chain BT_CMTMCD FMTERM;                                              //?Get Terms
         Clear ROECTL;
         Chain BT_CMCOMP FOECTL;                                              //?Control File

         OHSTAT='A';                                                          //?STATUS
         OHORD#=$GetOrder#(00);                                               //?ORDER NUMBER
         OHCOMP=01;                                                           //?COMPANY #
         OHCUST=SMCUST;                                                       //?CUSTOMER #
         OHNAME=CMNAME;                                                       //?SHIP TO NAME
         OHSHP2=CMADD2;                                                       //?ADDRESS LINE #1
         OHSHP3=CMADD3;                                                       //?ADDRESS LINE #2
         OHSHP4=CMADD4;                                                       //?ADDRESS LINE #3
         OHSHCT=CMCITY;                                                       //?CITY
         OHSHST=CMSTST;                                                       //?STATE
         OHSHZP=CMZIP;                                                        //?ZIP CODE
         OHPONO=*Blank;                                                       //?P.O. NUMBER
         OHDTOR=ThisMonday;                                                   //?ORDER DATE
         OHDTRQ=ThisMonday;                                                   //?REQ SHIP DATE
         OHDTRY=ThisMonCYMD;                                                  //?REQ. DATE CYMD
         OHDTCN=TodayMDY;                                                     //?CANCEL DATE
         OHSHIN='   Rcv''d in good';                                          //?SHIPPING INSTRUCTIO
         OHSPIN='Condition By:__________________';                            //?SPECIAL INSTRUCTION
         OHTERM=TCDESC;                                                       //?TERMS
         OHTRAT=*Zero;                                                        //?CASH DISC PERCENT
         OHTDAY=*Zero;                                                        //?CASH DISCOUNT DAYS
         OHTXST=CMTXST;                                                       //?TAX EXEMPT
         OHTXJU=CMTXJU;                                                       //?JURISDICTION
         // calc'd below     Eval      OHAMT1=TotalTax01                        ?TAX AMT 1
         // calc'd below     Eval      OHAMT2=TotalTax02                        ?TAX AMT 2
         // calc'd below     Eval      OHAMT3=TotalTax03                        ?TAX AMT 3
         OHTYPE=CMCTYP;                                                       //?CUSTOMER TYPE
         OHSHPC='02';                                                         //?SHIP VIA CODE
         OHSTA ='N';                                                          //?SUB TO AVAIL
         OHACK ='N';                                                          //?ORD. ACK. PRINTED
         OHSLD1=BT_CMNAME;                                                    //?BILL TO
         OHSLD2=BT_CMADD2;                                                    //?ADDRESS LINE #1
         OHSLD3=BT_CMADD3;                                                    //?ADDRESS LINE #2
         OHSLD4=BT_CMADD4;                                                    //?ADDRESS LINE #3
         OHSLCT=BT_CMCITY;                                                    //?CITY
         OHSLST=BT_CMSTST;                                                    //?STATE
         OHSLZP=BT_CMZIP;                                                     //?ZIP CODE
         OHSLM1='01';                                                         //?SALESPERSON 1
         OHSCM1=*Zero;                                                        //?COMM % 1
         OHSLM2=*Blanks;                                                      //?SALESPERSON 2
         OHSCM2=*Zero;                                                        //?COMM % 2
         OHFRT$=*Zero;                                                        //?FREIGHT AMT
         OHMER$=*Zero;                                                        //?MERCHANDISE AMT
         OHDIS$=*Zero;                                                        //?DISCOUNT AMT
         OHMIS$=*Zero;                                                        //?MISC. CHARGE AMT
         OHTAX$=*Zero;                                                        //?TAX AMOUNT
         OHFET$=*Zero;                                                        //?FET AMOUNT
         OHIOCD='N';                                                          //?INVOICE ONLY
         OHBOCD=CMBOOK;                                                       //?CUST B/O ALLOWED
         OHCOFL='N';                                                          //?CLOSED ORDER FLAG
         OHHOLD='N';                                                          //?HOLD ORDER FLAG
         OHTDAT=TodayMDY;                                                     //?DATE OF TRANS
         OHPLPT=*Blank;                                                       //?PICK LIST PRINTED P
         OHIVCD='N';                                                          //?INVOICED CODE
         OHDTLA=TodayMDY;                                                     //?LAST ACTIVITY DATE
         OHTIME=Now;                                                          //?TIME
         OHUSER=User;                                                         //?USER
         OHORDY=ThisMonCYMD;                                                  //?ORDER DATE CYMD
         OHPPCD='P';                                                          //?PREPAID/COLLECT
         OHPRCD=CMPRCD;                                                       //?PRICE CODE
         OHTRDC=CMTRDC;                                                       //?TRADE DISC. %
         OHTMCD=CMTMCD;                                                       //?TERMS CODE
         OHTDAS=TCTDAS;                                                       //?TERMS DAYS
         OHINV#=*Zero;                                                        //?INVOICE NUMBER
         OHINDT=*Zero;                                                        //?INVOICE DATE CYMD
         OHUPSZ=CMUPSZ;                                                       //?FREIGHT ZONE
         OHFRTX='N';                                                          //?TAX FREIGHT
         OHSPTX='N';                                                          //?TAX SPECIAL CHRGS
         OHTXID=CMTXID;                                                       //?TAX ID #
         OHROUT=*Blank;                                                       //?ROUTE #
         OHSTOP=*Zero;                                                        //?STOP
         OHARCU=CMARCU;                                                       //?AR CUST #
         OHSACU=CMSACU;                                                       //?SA CUST #
         OHBLCU=CMBLCU;                                                       //?BILLING CUST #
         OHTBLK=*Zero;                                                        //?TOTAL BULK PIECES
         OHTBRK=*Zero;                                                        //?TOTAL BROKEN PIECES
         OHDTAC=*Zero;                                                        //?SHIP DATE
         OHALPH=CMLOOK;                                                       //?CUSTOMER ALPHA
         OHSHFR=CMTERR;                                                       //?SHIP FROM
         OHSHFR=*Blanks;                                                      //?SHIP FROM
         OHPLST='000001';                                                     //?FREIGHT CODE
         OHIMED='N';                                                          //?IMMED PRINT
         OHIMED=*Blanks;                                                      //?IMMED PRINT
         OHCASH=*Zero;                                                        //?CASH APPLICATION
         OHORDT=ThisMonday;                                                   //?ORIGINAL REQ DATE
         OHOLST=CMORLS;                                                       //?ORDER PRICE LIST
         OHLOC ='R';                                                          //?ORDER LOCATION
         OHLOC =*Blanks;                                                      //?ORDER LOCATION
         OHOORD=*Zeros;                                                       //?ORIGINAL ORDER #
         OHDISC=*Zero;                                                        //?C&C OR SALE DISC. %
         OHPHYT=CMPHYT;                                                       //?PHYTO CODE
         OHOPLP=*Blank;                                                       //?ORDER PROOF PRINTED
         OHPOS =*Blank;                                                       //?INVOICE TYPE
         OHSALE=*Blank;                                                       //?SALE TYPE
         OHQTPR='N';                                                          //?QUOTE PRINTED
         OHQUOT=*Blank;                                                       //?QUOTE Y OR BLANK
         OHLOTC='Y';                                                          //?LOT CONTROL ORDER?
         OHIMFG='N';                                                          //?IMMED INVOICE PRINT

         Chain OHORD# FHORDR;
         If %found(FHORDR);
           *InH1 = *On;
         Else;
           ExSr Wrt_IORDR;                                                    // WRITE OUT THE DETAIL RECORDS
           OHAMT1=TotalTax01;                                                 //?TAX AMT 1
           OHAMT2=TotalTax01;                                                 //?TAX AMT 2
           OHAMT3=TotalTax01;                                                 //?TAX AMT 3
           //?  Update Order User File Information
           POORD# = OHORD#;                                                   //?ORDER NUMBER
           POTAKN = User;                                                     //?ORDER TAKEN BY
           POENTR = User;                                                     //?ORDER ENTERED BY
           POPICK = User;                                                     //?PICKED BY
           POPACK = User;                                                     //?PACKED BY
           Write RPPO;

           Write RHORDR;
           ExSr Wrt_OPNORD;                                                   //?Write Order Value

           Chain CMCUST FMCUST;                                               //?Chain for Update
           CMOCUR = CMOCUR + 1;                                               //?QTY ORDERS CURRENT
           CMOYTD = CMOYTD + 1;                                               //?QTY ORDERS YTD
           CMDTLO = TodayMDY;                                                 //?DATE LAST ORDER
           CMVOPO = CMVOPO + TotalOrder;                                      //?VALUE OF OPEN ORDER
           Update RMCUST;                                                     //?Update Cust Master

         EndIf;

       EndSr;
