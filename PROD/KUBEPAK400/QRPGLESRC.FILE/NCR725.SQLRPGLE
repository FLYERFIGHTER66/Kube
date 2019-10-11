     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Create a Finished Order from list of Items       :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  August 2014          ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Edit Log                                                ?:
      //? :                                                           ?:
      //? :  WJB    -? 8/13/14 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:
WJB  FFMCUST    UF   E           K DISK                                         ?Customer Master
     FFMCUSTCN  IF   E           K DISK    RENAME(RMCUST:BILLTO)  PREFIX(BT_)   ?Customer Master

     FFMTAXF    IF   E           K DISK                                         ?Tax File
     FFMTERM    IF   E           K DISK                                         ?Terms File

     FFMINVT    UF   E           K DISK                                         ?Item Master
     FFMUPCUPC  IF   E           K DISK                                         ?Item/UPC Master

     FFOECTL    IF   E           K DISK                                         ?Order Control File
     FFHORDR    UF A E           K DISK                                         ?Order Header
     FFHORDRHISTO  A E           K DISK
     FFOPNORD   UF A E           K DISK                                         ?Order Value
     FFIORDR    UF A E           K DISK                                         ?Order Detail
     FFPPO      UF A E           K DISK                                         ?Order User Info

      //? Main procedure prototype & interface
     D NCR725          PR                  ExtPgm('NCR725')
     D  #TimeStamp                     Z
     D  #Order#                       6S 0
     D NCR725          PI
     D  #TimeStamp                     Z
     D  #Order#                       6S 0

     D Wrt_HORDR       PR
     D Wrt_IORDR       PR
     D Wrt_OPNORD      PR

      //? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$GetOrder#
    ?D/COPY QFunctDefn,$UnitPrice
    ?D/COPY QFunctDefn,$PrintPick
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$_IC

      //? Field Definitions
     D   x             S              4S 0 Inz(0)                               ?Array Counter
     D   CountItem     S                   Inz(0) Like(OIQORD)                  ?Item Count
     D   Today         S               D                                        ?Today
     D   TodayMDY      S              6S 0 Inz(0)                               ?Today  ( MDY )
     D   TodayYMD7     S              7S 0 Inz(0)                               ?Today  ( CYMD7 )
     D   ThisMonday    S              6S 0 Inz(0)                               ?Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D   Tax1          S              5S 2 Inz(0)                               ?Tax:State Tax
     D   Tax2          S              5S 2 Inz(0)                               ?Tax:County Tax
     D   Tax3          S              5S 2 Inz(0)                               ?Tax:Local Tax
     D   TotalTax01    S              7S 2 Inz(0)                               ?Sum:State Tax
     D   TotalTax02    S              7S 2 Inz(0)                               ?Sum:County Tax
     D   TotalTax03    S              7S 2 Inz(0)                               ?Sum:Local Tax
     D   TotalOrder    S              9S 2 Inz(0)                               ?Total Order Value
     D   OrderSeq#     S              3S 0                                      ?Order Detail Seq. #
     D   ThisCust      S                   Like(CMCUST)
     D   ThisUPC       S                   Like(UPCCODE)
     D   TimeStamp     S               Z

      //? Arrays
     D   ItemSize      S             15A   Dim(9999) Inz('999999999999999')     ?Items to Process
     D   UPC           S             12S 0 Dim(9999) Inz(999999999999)          ?UPCs to Process
     D   ProcQty       S             11S 1 Dim(9999) Inz(0)                     ?Quantity to Process

      //? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

       //?  ...........................................................
       //?  :   MAIN PROGRAM CALCS                                    :
       //?  :.........................................................:
      /Free

         TimeStamp = #TimeStamp;                                              //?Scan TimeStamp
         Today = $Date(0);                                                    //?Today MDY
         TodayMDY = $MDYDate(Today);                                          //?Today MDY
         TodayYMD7 = $Date7(Today);                                           //?Today CYMD7
         ThisMonday = $MDYDate($Monday(Today:'FRI'));                         //?Monday MDY
         ThisMonCYMD = $Date7($Monday(Today:'FRI'));                          //?Monday CYMD

         ThisCust    = *Zero;
         Exec SQL Select     FOCUST
                  Into       :ThisCust
                  From       FFINCRT
                  Where      FOTIME = :TimeStamp
                    and      FOSTAT = 'A'
                  Fetch First Row Only;
         If ThisCUST <> *Zero;
           If ThisCust > 99999; // Cust > 99999 represents an Order Number for an existing order
             Chain (ThisCust) FHORDR;
             If %Found(FHORDR);
               ThisCust = OHCUST;
             EndIf;
           EndIf;
         Chain (ThisCust) FMCUST;                                             //?Customer Master
         EndIf;

         If #Order# = *Zero;
           Wrt_HORDR();
           *InLR = *On;
           #Order# = OIORD#;
          Else;
           OrderSeq# = 8;
           Exec SQL
             Select   max(OISEQ#)
             into    :OrderSeq#
             from     FIORDR
             Where    OIORD# = :#Order#
               and    OISEQ# < 990;
           Wrt_IORDR();
           *InLR = *On;
         EndIf;

         Return;

         Chain OHORD# FHORDR;
         Chain (OIORD#:OISEQ#) FIORDR;

      /End-Free
       //?  ...........................................................
       //?  :   SUB-PROCEDURES                                        :
       //?  :.........................................................:

       //?Wrt_HORDR - Write the Order Header
     P Wrt_HORDR       B
     D Wrt_HORDR       PI
      /Free

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
         OHCUST=ThisCUST;                                                     //?CUSTOMER #
         OHNAME=CMNAME;                                                       //?SHIP TO NAME
         OHSHP2=CMADD2;                                                       //?ADDRESS LINE #1
         OHSHP3=CMADD3;                                                       //?ADDRESS LINE #2
         OHSHP4=CMADD4;                                                       //?ADDRESS LINE #3
         OHSHCT=CMCITY;                                                       //?CITY
         OHSHST=CMSTST;                                                       //?STATE
         OHSHZP=CMZIP;                                                        //?ZIP CODE
         OHPONO=*Blank;                                                       //?P.O. NUMBER
       //OHDTOR=ThisMonday;                                                   //?ORDER DATE
         OHDTOR=TodayMDY;                                                     //?ORDER DATE
       //OHDTRQ=ThisMonday;                                                   //?REQ SHIP DATE
         OHDTRQ=TodayMDY;                                                     //?REQ SHIP DATE
       //OHDTRY=ThisMonCYMD;                                                  //?REQ. DATE CYMD
         OHDTRY=TodayYMD7  ;                                                  //?REQ. DATE CYMD
         OHDTCN=TodayMDY;                                                     //?CANCEL DATE
         OHSHIN='   Rcv''d in good';                                          //?SHIPPING INSTRUCTIO
         OHSPIN='Condition By:__________________';                            //?SPECIAL INSTRUCTION
         OHTERM=TCDESC;                                                       //?TERMS
         OHTRAT=*Zero;                                                        //?CASH DISC PERCENT
         OHTDAY=*Zero;                                                        //?CASH DISCOUNT DAYS
         OHTXST=CMTXST;                                                       //?TAX EXEMPT
         OHTXJU=CMTXJU;                                                       //?JURISDICTION
         // calc'd below     Eval      OHAMT1=TotalTax01                      //    ?TAX AMT 1
         // calc'd below     Eval      OHAMT2=TotalTax02                      //    ?TAX AMT 2
         // calc'd below     Eval      OHAMT3=TotalTax03                      //    ?TAX AMT 3
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
         OHTIME=$now();                                                       //?TIME
         OHUSER=User;                                                         //?USER
       //OHORDY=ThisMonCYMD;                                                  //?ORDER DATE CYMD
         OHORDY=TodayYMD7  ;                                                  //?ORDER DATE CYMD
         OHPPCD='P';                                                          //?PREPAID/COLLECT
         OHPRCD=CMPRCD;                                                       //?PRICE CODE
         OHPRCD=3;                                                            //?PRICE CODE
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
       //OHORDT=ThisMonday;                                                   //?ORIGINAL REQ DATE
         OHORDT=TodayMDY;                                                     //?ORIGINAL REQ DATE
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
         OHLOTC='N';                                                          //?LOT CONTROL ORDER?
         OHIMFG='N';                                                          //?IMMED INVOICE PRINT

         Chain OHORD# FHORDR;
         If %found(FHORDR);
           *InH1 = *On;
         Else;
           OrderSeq# = 8;
           Wrt_IORDR();
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
           HSTUSER    = $User()       ;
           HSTPROGRAM = 'NCR725'      ;
           HSTTIME    = $Timestamp()  ;
           Write RHORDRHIST           ;
           Wrt_OPNORD();                                                      //?Write Order Value

           CMOCUR = CMOCUR + 1;                                               //?QTY ORDERS CURRENT
           CMOYTD = CMOYTD + 1;                                               //?QTY ORDERS YTD
           CMDTLO = TodayMDY;                                                 //?DATE LAST ORDER
           CMVOPO = CMVOPO + TotalOrder;                                      //?VALUE OF OPEN ORDER
           Update RMCUST;                                                     //?Update Cust Master

         EndIf;

      /End-Free
     P Wrt_HORDR       E


       //?Wrt_IORDR - Write Order Detail Record
     P Wrt_IORDR       B
     D Wrt_IORDR       PI
      /Free

         CountItem   = *Zero;
         ThisUPC     = 1;
         //ThisCust    = 1;
         Clear RIORDR;

         //Dow ThisUPC <> *Zero and ThisCUST <> *Zero;
         Dow ThisUPC <> *Zero;
           Exec SQL
                    Update     FFINCRT
                    Set        FOSTAT = 'D'
                    Where      FOTIME = :TimeStamp
                      and      FOUPC  = :ThisUPC;
           ThisUPC = *Zero;
           ThisUPC = *Zero;
           Exec SQL Select     FOUPC
                    Into       :ThisUPC
                    From       FFINCRT
                    Where      FOTIME = :TimeStamp
                      and      FOSTAT = 'A'
                    Order By   FOLOOK
                    Fetch First Row Only;
           Exec SQL Select     sum(FOQTYS)
                    Into       :CountItem
                    From       FFINCRT
                    Where      FOTIME = :TimeStamp
                      and      FOUPC  = :ThisUPC
                      and      FOSTAT = 'A';

           Chain (ThisUPC) FMUPCUPC;                                         //?UPC/Item Master
           Chain (UPCITEM:UPCSIZE) FMINVT;                                   //?Item Master

           If %Found(FMUPCUPC) and %Found(FMINVT) and %Found(FMCUST);
             OrderSeq# = OrderSeq# + 2;

             //?  Tax calculations
             Clear RMTAXF;
             OITXCD = 'N';                                                    //?TAX ITEM CODE 1
             OITXST = 'N';                                                    //?TAX ITEM CODE 2
             OITXCT = 'N';                                                    //?TAX ITEM CODE 3
             OITXLC = 'N';                                                    //?TAX ITEM CODE 4
             If CMTXST = 'N';                                                 //?Tax Exempt ?
               Chain CMTXJU FMTAXF;                                           //?Item Master File
               If %found(FMTAXF);
                 OIAMT1=TXPCT1;                                               //?TAX AMT RATE 1
                 OIAMT2=TXPCT2;                                               //?TAX AMT RATE 2
                 OIAMT3=TXPCT3;                                               //?TAX AMT RATE 3
                 If OIAMT1<>*Zero
                       or OIAMT2<>*Zero
                       or OIAMT3<>*Zero;
                   OITXCD='Y';                                                //?TAX ITEM CODE 1
                 EndIf;
                 If OIAMT1<>*Zero;
                   OITXST='Y';                                                //?TAX ITEM CODE 2
                 EndIf;
                 If OIAMT2<>*Zero;
                   OITXCT='Y';                                                //?TAX ITEM CODE 3
                 EndIf;
                 If OIAMT3<>*Zero;
                   OITXLC='Y';                                                //?TAX ITEM CODE 4
                 EndIf;
               EndIf;
             EndIf;

             //?  Populate Order Detail Record
             OISTAT='A';                                                      //?STATUS
             OIORD#=OHORD#;                                                   //?ORDER NUMBER
             OISEQ#=OrderSeq#;                                                //?SEQ NUMBER
             OIITEM=IMITEM;                                                   //?ITEM NUMBER
             OISIZE=IMSIZE;                                                   //?SIZE
             OIDES1=IMDES1;                                                   //?DESCRIPTION 1
             OIDES2=IMDES2;                                                   //?COMMENT
             OICOMP=IMCOMP;                                                   //?COMPANY #
             OIWHSE=IMWHSE;                                                   //?LOCATION
             OIBIN#=IMBIN#;                                                   //?BIN #
             OIUUOM=IMPUOM;                                                   //?UNIT OF MEASURE
             OIMULT=IMMULT;                                                   //?MULT 1
             OIUWGT=IMUWGT;                                                   //?UNIT WGT
             OIUCST=IMUCST;                                                   //?UNIT COST
             OIUPRI=IMSEL3;                                                   //?UNIT PRICE (Pickup)
             OIOVER='3';                                                      //?OVERRIDE CODE
             OIOVER='N';                                                      //?OVERRIDE CODE
             OIQDDC=IMDIS1;                                                   //?QTY DISCOUNT
             OIEXT$=CountItem*OIUPRI;                                         //?EXT AMOUNT
             OIQORD=CountItem;                                                //?QTY ORDERED
             OIQSHP=*Zero;                                                    //?QTY SHIPPED
             OIQBOO=*Zero;                                                    //?QTY BACKORDERED
             OISHPC='02';                                                     //?SHIP VIA CODE
             //  see above       Eval      OIAMT1=TXPCT1                                ?TAX AMT RAT
             //  see above       Eval      OIAMT2=TXPCT2                                ?TAX AMT RAT
             //  see above       Eval      OIAMT3=TXPCT3                                ?TAX AMT RAT
             OIDISC=*Zero;                                                    //?DISCOUNT AMT
             OISHCD=*Blanks;                                                  //?SHIP RELEASE CODE
             OISHCD='N';                                                      //?SHIP RELEASE CODE
             OIBOCD=IMBOOK;                                                   //?ITEM B/O ALLOWED
             OISLM1=OHSLM1;                                                   //?SALESPERSON 1
             OICOM1=OICOM1;                                                   //?COMMISSION 1
             OISLM2=OISLM2;                                                   //?SALESPERSON 2
             OICOM2=OICOM2;                                                   //?COMMISSION 2
             OICUST=ThisCUST;                                                 //?CUSTOMER #
           //OIDTRQ=ThisMonday;                                               //?REQ SHIP DATE
             OIDTRQ=TodayMDY;                                                 //?REQ SHIP DATE
             OIDTLA=TodayMDY;                                                 //?LAST ACTIVITY DATE
             OITIME=$Now();                                                   //?TIME
             OIUSER=User;                                                     //?USER
             OITRDC=BT_CMTRDC;                                                //?TRADE DISC %
             OICTCD=CMCTCD;                                                   //?CONTRACT PRICE CODE
             OICTCD='N';                                                      //?CONTRACT PRICE CODE
             OICOFL='N';                                                      //?CLOSED ORDER FLAG
             OIITYP=*Blanks;                                                  //?ITEM TYPE
             OIQINV=*Zero;                                                    //?INVOICE QTY SHIPPED
             OIPLPT='N';                                                      //?PICK LIST PRINTED
             //  see above       Eval      OITXCD=IMTXBL                                ?TAX ITEM CO
             //  see above       Eval      OITXST=IMTCD1                                ?TAX ITEM CO
             //  see above       Eval      OITXCT=IMTCD2                                ?TAX ITEM CO
             //  see above       Eval      OITXLC=IMTCD3                                ?TAX ITEM CO
             OIROUT=*Blanks;                                                  //?ROUTE NUMBER
             OISTOP=*Zero;                                                    //?STOP
             OICWT =*Zero;                                                    //?CATCH WEIGHT
             OILBS#=*Zero;                                                    //?POUNDS
             OIWGSH=*Zero;                                                    //?WEIGHT SHIPPED
             OIRSCD=*Blanks;                                                  //?REASON
             OISEQP=*Zero;                                                    //?PRIMARY SEQ #
             OIPRAL=*Blanks;                                                  //?PROMO ALLOW
             OIBPUM=IMBPUM;                                                   //?BASE PRICE UNIT OF
             OISUOM=IMBPUM;                                                   //?SHIP UOM
             OIBLUM=IMBPUM;                                                   //?BILL UOM
             OIMUL2=*Zero;                                                    //?MULT 2
             OILOTC='N';                                                      //?LOT CONTROL
             OIOPFL=*Blanks;                                                  //?OPEN ORDER POST FLA
             OIBOLN=*Blanks;                                                  //?LINE ITEM PUT ON BO
           //OIBORQ=ThisMonday;                                               //?ORIG B/O REQ SHIP D
             OIBORQ=TodayMDY;                                                 //?ORIG B/O REQ SHIP D
             OIPRBO='N';                                                      //?PREVIOUS BACKORDER
             OIPRBO=' ';                                                      //?PREVIOUS BACKORDER
             OISTA ='N';                                                      //?SUBJ TO AVAIL FLAG
             OIINV#=*Zero;                                                    //?INVOICE NUMBER
             OISHFR=CMSHFR;                                                   //?SHIP FROM
             OITAGS=*Zero;                                                    //?# TAGS
             OIPPDC='N';                                                      //?PROMPT PAY DSC Y/N
             OIPHYT=CMPHYT;                                                   //?PHYTO CODE
             OISCHM='N';                                                      //?SCHED. TO MOVE FLAG
             OISCHS='N';                                                      //?SCHED. TO SOW FLAG
             OIQTAL=*Zero;                                                    //?QTY ALLOCATED
             OIGLNO=*Zero;                                                    //?G/L # SPEC CHARGES
             OIITMA=IMLOOK;                                                   //?ITEM ALPHA SEARCH
             OISEDP=*Blanks;                                                  //?SEED ORDERED Y/N
             OIRVCD=*Zero;                                                    //?EXPIRE DATE - CYMD
             OIQTE =*Blanks;                                                  //?QUOTE LINE ITEM
           //OIORDT=ThisMonday;                                               //?HOLD ORIG REQ SHIP
             OIORDT=TodayMDY;                                                 //?HOLD ORIG REQ SHIP
             OIRVDT=TodayYMD7;                                                //?REQ SHIP DATE CYMD
             OILOT#=*Blanks;                                                  //?LOT NUMBER
             OIFRQD='N';                                                      //?FORCE QTY DISC Y/N
             OISPFL=*Blanks;                                                  //?SUMMARY PICKSLIP FL
             OIALPH=CMLOOK;                                                   //?CUST ALPHA SEARCH
             OIPRCL=IMPCL1;                                                   //?PROD CLASS 1
             OINPSL=*Blanks;                                                  //?NO PICKSLIP FUTURE
             OIRQTY=*Zero;                                                    //?PRE RELEASE QTY
             OIPOST=*Blanks;                                                  //?POST FLAG
             OISOW =*Zero;                                                    //?SOW DATE CYMD
             OICCDC=*Zero;                                                    //?C&C OR SALE DISC. %
             OILIST=*Blanks;                                                  //?LIST CODE
             OIROY =IMROYL;                                                   //?ROYALTY EACH

           //Tax1  = OIAMT1 * OIUPRI;                                         //?ST Tax on Item
           //Tax2  = OIAMT2 * OIUPRI;                                         //?CO Tax on Item
           //Tax3  = OIAMT3 * OIUPRI;                                         //?MU Tax on Item

             TotalTax01 = TotalTax01 + (OIAMT1 * OIUPRI);                     //?ST Total Tax
             TotalTax02 = TotalTax02 + (OIAMT2 * OIUPRI);                     //?CO Total Tax
             TotalTax03 = TotalTax03 + (OIAMT3 * OIUPRI);                     //?MU Total Tax
             TotalOrder = TotalOrder + OIEXT$;                                //?Total Order Value

             Chain (OIORD#:OISEQ#) FIORDR;
             If %found(FIORDR);
               *InH2 = *On;
             Else;
               Write RIORDR;
               IMQTAL += CountItem;
               IMQTAV -= CountItem;
               Update RMINVT;
               Exec SQL
                 UPDATE  FLKITM
                 SET     LKPAL = LKPAL + :CountItem
                 WHERE   LKITEM = :OIITEM
                   and   LKSIZE = :OISIZE;
             EndIf;

           EndIf;
         EndDo;
      /End-Free
     P Wrt_IORDR       E




       //?Wrt_OPNORD - Write Open Order Value Record
     P Wrt_OPNORD      B
     D Wrt_OPNORD      PI
      /Free

         OOORD# = OHORD#;                                                     //?ORDER NUMBER
         OOCOMP = 1;                                                          //?COMPANY #
         OOCUST = ThisCUST;                                                   //?CUSTOMER #
       //OODTRY = ThisMonCYMD;                                                //?REQ. DATE CYMD
         OODTRY = TodayYMD7  ;                                                //?REQ. DATE CYMD
         OOORDY = TodayYMD7;                                                  //?ORDER DATE CYMD
         OOARCU = CMARCU;                                                     //?AR CUST #
         OOSACU = CMSACU;                                                     //?SA CUST #
         OOBLCU = CMBLCU;                                                     //?BILLING CUST #
         OOSHFR = CMTERR;                                                     //?SHIP FROM
         OOEXT$ = TotalOrder;                                                 //?ORDER VALUE

         Write ROPNORD;

      /End-Free
     P Wrt_OPNORD      E
