    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Copy an Order                                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Apr. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program provides the ability to copy an existing   ?:
      *? : order verbatum to another customer number.                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  $Date        ?Get Date Value                             ?:
      *? :  $DateMDY     ?Get Date Number in MM/DD/YY                ?:
      *? :  $Monday      ?Get Monday Date Value                      ?:
      *? :  $AddDate     ?Add/Subtract Days from Date                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

      *? Update Files
     FFMCUST    UF   E           K DISK                                         ?Customer Master
     FFHORDR    UF A E           K DISK                                         ?Order Header
     FFHORDRHISTO  A E           K DISK
     FFOPNORD   UF A E           K DISK                                         ?Order Value
     FFIORDR    UF A E           K DISK                                         ?Order Detail
     FFALITEM   UF A E           K DISK                                         ?Item Allocated
     FFPPO      UF A E           K DISK                                         ?Order User Info
     FFMINVT    UF   E           K DISK                                         ?Item Master
     FFLKITM    UF   E           K DISK                                         ?Item Look up File
      *? Input Only Files
     FFMCUSTCN  IF   E           K DISK    RENAME(RMCUST:BILLTO)  PREFIX(BT_)   ?Cust Mast (Bill To)
     FFOECTL    IF   E           K DISK                                         ?Control File
     FFMTERM    IF   E           K DISK                                         ?Terms File
     FFMTAXF    IF   E           K DISK                                         ?Tax File
     FFDLOTRD   IF   E           K DISK                                         ?Lot Inventory by RD

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$GetOrder#
    ?D/COPY QFunctDefn,$UnitPrice
    ?D/COPY QFunctDefn,$PrintPick
    ?D/COPY QFunctDefn,$Allocate
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$User

      *? Data Structures
     D                SDS                                                       ?
     D    ProgID         *PROC                                                  ?Program Name

      *? Array Definitions
    ? * none

      *? Indicators
    ? * none

      *? Field Definitions
     D  UserID         S             10A                                        ?
     D  Today          S              6S 0                                      ?
     D  Now            S              6S 0                                      ?
     D  CountSeq       S                   Like(OISEQ#)                         ?
     D  Order          S                   Like(OHORD#)                         ?
     D  Customer       S                   Like(CMCUST)                         ?
     D  Nines15        S             15A   Inz('999999999999999')               ?15A  all 9's
     D  x              S              4S 0 Inz(0)                               ?Array Counter
     D  CountItem      S              4S 0 Inz(0)                               ?Tray Count for Item
     D  TodayMDY       S              6S 0 Inz(0)                               ?Today  ( MDY )
     D  TodayYMD7      S              7S 0 Inz(0)                               ?Today  ( CYMD7 )
     D  ThisMonday     S              6S 0 Inz(0)                               ?Monday ( MDY )
     D  ThisMonCYMD    S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D  Tax1           S              5S 2 Inz(0)                               ?Tax:State Tax
     D  Tax2           S              5S 2 Inz(0)                               ?Tax:County Tax
     D  Tax3           S              5S 2 Inz(0)                               ?Tax:Local Tax
     D  TotalTax01     S              7S 2 Inz(0)                               ?Sum:State Tax
     D  TotalTax02     S              7S 2 Inz(0)                               ?Sum:County Tax
     D  TotalTax03     S              7S 2 Inz(0)                               ?Sum:Local Tax
     D  TotalOrder     S              9S 2 Inz(0)                               ?Total Order Value
     D  OrderSeq#      S              3S 0                                      ?Order Detail Seq. #

      *?   Write records to the Order files with the new order #.
    ?C                   ExSr      Wrt_HORDR
     C                   Eval      Order = OHORD#
     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      Wrt_HORDR - Write the Order Header                 :
      *?  :.........................................................:
    ?C     Wrt_HORDR     BegSr                                                  ?

     C                   Reset                   TotalTax01                     ?ST Total Tax
     C                   Reset                   TotalTax02                     ?CO Total Tax
     C                   Reset                   TotalTax03                     ?MU Total Tax
     C                   Reset                   TotalOrder                     ?Total Order Value

     C                   Clear                   RHORDR
    ?C     Order         Chain     FHORDR                                       ?Get billto info
     C                   Clear                   BillTo
    ?C     CMBLCU        Chain     FMCUSTCN                                     ?Get billto info
     C                   Clear                   RMTERM
    ?C     BT_CMTMCD     Chain     FMTERM                                       ?Get Terms
     C                   Clear                   ROECTL
    ?C     BT_CMCOMP     Chain     FOECTL                                       ?Control File

     C                   Eval      OHSTAT='A'                                   ?STATUS
     C                   Eval      OHORD#=$GetOrder#(00)                        ?ORDER NUMBER
     C                   Eval      OHCOMP=01                                    ?COMPANY #
     C                   Eval      OHCUST=Customer                              ?CUSTOMER #
     C                   Eval      OHNAME=CMNAME                                ?SHIP TO NAME
     C                   Eval      OHSHP2=CMADD2                                ?ADDRESS LINE #1
     C                   Eval      OHSHP3=CMADD3                                ?ADDRESS LINE #2
     C                   Eval      OHSHP4=CMADD4                                ?ADDRESS LINE #3
     C                   Eval      OHSHCT=CMCITY                                ?CITY
     C                   Eval      OHSHST=CMSTST                                ?STATE
     C                   Eval      OHSHZP=CMZIP                                 ?ZIP CODE
     C* Same as Source   Eval      OHPONO=*Blank                                ?P.O. NUMBER
     C* Same as Source   Eval      OHDTOR=ThisMonday                            ?ORDER DATE
     C* Same as Source   Eval      OHDTRQ=ThisMonday                            ?REQ SHIP DATE
     C* Same as Source   Eval      OHDTRY=ThisMonCYMD                           ?REQ. DATE CYMD
     C* Same as Source   Eval      OHDTCN=TodayMDY                              ?CANCEL DATE
     C* Same as Source   Eval      OHSHIN='   Rcv''d in good'                   ?SHIPPING INSTRUCTIO
     C* Same as Source   Eval      OHSPIN='Condition By:__________________'     ?SPECIAL INSTRUCTION
     C                   Eval      OHTERM=TCDESC                                ?TERMS
     C                   Eval      OHTRAT=*Zero                                 ?CASH DISC PERCENT
     C                   Eval      OHTDAY=*Zero                                 ?CASH DISCOUNT DAYS
     C                   Eval      OHTXST=CMTXST                                ?TAX EXEMPT
     C                   Eval      OHTXJU=CMTXJU                                ?JURISDICTION
     C* calc'd below     Eval      OHAMT1=TotalTax01                            ?TAX AMT 1
     C* calc'd below     Eval      OHAMT2=TotalTax02                            ?TAX AMT 2
     C* calc'd below     Eval      OHAMT3=TotalTax03                            ?TAX AMT 3
     C                   Eval      OHTYPE=CMCTYP                                ?CUSTOMER TYPE
     C* Same as Source   Eval      OHSHPC='02'                                  ?SHIP VIA CODE
     C                   Eval      OHSTA ='N'                                   ?SUB TO AVAIL
     C                   Eval      OHACK ='N'                                   ?ORD. ACK. PRINTED
     C                   Eval      OHSLD1=BT_CMNAME                             ?BILL TO
     C                   Eval      OHSLD2=BT_CMADD2                             ?ADDRESS LINE #1
     C                   Eval      OHSLD3=BT_CMADD3                             ?ADDRESS LINE #2
     C                   Eval      OHSLD4=BT_CMADD4                             ?ADDRESS LINE #3
     C                   Eval      OHSLCT=BT_CMCITY                             ?CITY
     C                   Eval      OHSLST=BT_CMSTST                             ?STATE
     C                   Eval      OHSLZP=BT_CMZIP                              ?ZIP CODE
     C                   Eval      OHSLM1='01'                                  ?SALESPERSON 1
     C                   Eval      OHSCM1=*Zero                                 ?COMM % 1
     C                   Eval      OHSLM2=*Blanks                               ?SALESPERSON 2
     C                   Eval      OHSCM2=*Zero                                 ?COMM % 2
     C                   Eval      OHFRT$=*Zero                                 ?FREIGHT AMT
     C                   Eval      OHMER$=*Zero                                 ?MERCHANDISE AMT
     C                   Eval      OHDIS$=*Zero                                 ?DISCOUNT AMT
     C                   Eval      OHMIS$=*Zero                                 ?MISC. CHARGE AMT
     C                   Eval      OHTAX$=*Zero                                 ?TAX AMOUNT
     C                   Eval      OHFET$=*Zero                                 ?FET AMOUNT
     C                   Eval      OHIOCD='N'                                   ?INVOICE ONLY
     C                   Eval      OHBOCD=CMBOOK                                ?CUST B/O ALLOWED
     C                   Eval      OHCOFL='N'                                   ?CLOSED ORDER FLAG
     C                   Eval      OHHOLD='N'                                   ?HOLD ORDER FLAG
     C                   Eval      OHTDAT=Today                                 ?DATE OF TRANS
     C                   Eval      OHPLPT=*Blank                                ?PICK LIST PRINTED P
     C                   Eval      OHIVCD='N'                                   ?INVOICED CODE
     C                   Eval      OHDTLA=Today                                 ?LAST ACTIVITY DATE
     C                   Eval      OHTIME=Now                                   ?TIME
     C                   Eval      OHUSER=UserID                                ?USER
     C* Same as Source   Eval      OHORDY=ThisMonCYMD                           ?ORDER DATE CYMD
     C                   Eval      OHPPCD='P'                                   ?PREPAID/COLLECT
     C                   Eval      OHPRCD=CMPRCD                                ?PRICE CODE
     C                   Eval      OHTRDC=CMTRDC                                ?TRADE DISC. %
     C                   Eval      OHTMCD=CMTMCD                                ?TERMS CODE
     C                   Eval      OHTDAS=TCTDAS                                ?TERMS DAYS
     C                   Eval      OHINV#=*Zero                                 ?INVOICE NUMBER
     C                   Eval      OHINDT=*Zero                                 ?INVOICE DATE CYMD
     C                   Eval      OHUPSZ=CMUPSZ                                ?FREIGHT ZONE
     C                   Eval      OHFRTX='N'                                   ?TAX FREIGHT
     C                   Eval      OHSPTX='N'                                   ?TAX SPECIAL CHRGS
     C                   Eval      OHTXID=CMTXID                                ?TAX ID #
     C                   Eval      OHROUT=*Blank                                ?ROUTE #
     C                   Eval      OHSTOP=*Zero                                 ?STOP
     C                   Eval      OHARCU=CMARCU                                ?AR CUST #
     C                   Eval      OHSACU=CMSACU                                ?SA CUST #
     C                   Eval      OHBLCU=CMBLCU                                ?BILLING CUST #
     C                   Eval      OHTBLK=*Zero                                 ?TOTAL BULK PIECES
     C                   Eval      OHTBRK=*Zero                                 ?TOTAL BROKEN PIECES
     C                   Eval      OHDTAC=*Zero                                 ?SHIP DATE
     C                   Eval      OHALPH=CMLOOK                                ?CUSTOMER ALPHA
     C                   Eval      OHSHFR=CMTERR                                ?SHIP FROM
     C                   Eval      OHSHFR=*Blanks                               ?SHIP FROM
     C                   Eval      OHPLST='000001'                              ?FREIGHT CODE
     C                   Eval      OHIMED='N'                                   ?IMMED PRINT
     C                   Eval      OHIMED=*Blanks                               ?IMMED PRINT
     C                   Eval      OHCASH=*Zero                                 ?CASH APPLICATION
     C* Same as Source   Eval      OHORDT=ThisMonday                            ?ORIGINAL REQ DATE
     C                   Eval      OHOLST=CMORLS                                ?ORDER PRICE LIST
     C                   Eval      OHLOC ='R'                                   ?ORDER LOCATION
     C                   Eval      OHLOC =*Blanks                               ?ORDER LOCATION
     C                   Eval      OHOORD=*Zeros                                ?ORIGINAL ORDER #
     C                   Eval      OHDISC=*Zero                                 ?C&C OR SALE DISC. %
     C                   Eval      OHPHYT=CMPHYT                                ?PHYTO CODE
     C                   Eval      OHOPLP=*Blank                                ?ORDER PROOF PRINTED
     C                   Eval      OHPOS =*Blank                                ?INVOICE TYPE
     C                   Eval      OHSALE=*Blank                                ?SALE TYPE
     C                   Eval      OHQTPR='N'                                   ?QUOTE PRINTED
     C                   Eval      OHQUOT=*Blank                                ?QUOTE Y OR BLANK
     C* Same as Source   Eval      OHLOTC='Y'                                   ?LOT CONTROL ORDER?
     C                   Eval      OHIMFG='N'                                   ?IMMED INVOICE PRINT

    ?C     OHORD#        Chain     FHORDR
     C                   If        %found(FHORDR)
     C                   Eval      *InH1 = *On
     C                   Else
    ?C                   ExSr      Wrt_IORDR                                    ?Write Detail Record
     C                   Eval      OHAMT1=TotalTax01                            ?TAX AMT 1
     C                   Eval      OHAMT2=TotalTax01                            ?TAX AMT 2
     C                   Eval      OHAMT3=TotalTax01                            ?TAX AMT 3
      *?  Update Order User File Information
     C                   Eval      POORD# = OHORD#                              ?ORDER NUMBER
     C                   Eval      POTAKN = UserID                              ?ORDER TAKEN BY
     C                   Eval      POENTR = UserID                              ?ORDER ENTERED BY
     C                   Eval      POPICK = UserID                              ?PICKED BY
     C                   Eval      POPACK = UserID                              ?PACKED BY
    ?C                   Write     RPPO

    ?C                   Write     RHORDR
     C                   Eval      HSTUSER    = USERID
     C                   Eval      HSTPROGRAM = 'BIR107'
     C                   Eval      HSTTIME    = $Timestamp()
     C                   Write     RHORDRHIST
    ?C                   ExSr      Wrt_OPNORD                                   ?Write Order Value

    ?C     CMCUST        Chain     FMCUST                                       ?Chain for Update
     C                   Eval      CMOCUR = CMOCUR + 1                          ?QTY ORDERS CURRENT
     C                   Eval      CMOYTD = CMOYTD + 1                          ?QTY ORDERS YTD
     C                   Eval      CMDTLO = Today                               ?DATE LAST ORDER
     C                   Eval      CMVOPO = CMVOPO + TotalOrder                 ?VALUE OF OPEN ORDER
    ?C                   Update    RMCUST                                       ?Update Cust Master

     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Wrt_IORDR - Write Order Detail Record              :
      *?  :.........................................................:
    ?C     Wrt_IORDR     BegSr                                                  ?

    ?C     Order         SetLL     FIORDR
    ?C     Order         ReadE     FIORDR
     C                   DoW       not %EOF(FIORDR)
     C                   If        OISTAT='A'
     C                   Eval      OrderSeq# = OISEQ#

    ?C                   ExSr      Get_MINVT

     C                   Eval      OISTAT='A'                                   ?STATUS
     C                   Eval      OIORD#=OHORD#                                ?ORDER NUMBER
     C* Same as Source   Eval      OISEQ#=OrderSeq#                             ?SEQ NUMBER
     C* Same as Source   Eval      OIITEM=IMITEM                                ?ITEM NUMBER
     C* Same as Source   Eval      OISIZE=IMSIZE                                ?SIZE
     C* Same as Source   Eval      OIDES1=IMDES1                                ?DESCRIPTION 1
     C* Same as Source   Eval      OIDES2=IMDES2                                ?COMMENT
     C* Same as Source   Eval      OICOMP=IMCOMP                                ?COMPANY #
     C* Same as Source   Eval      OIWHSE=IMWHSE                                ?LOCATION
     C* Same as Source   Eval      OIBIN#=IMBIN#                                ?BIN #
     C* Same as Source   Eval      OIUUOM=IMPUOM                                ?UNIT OF MEASURE
     C* Same as Source   Eval      OIMULT=IMMULT                                ?MULT 1
     C* Same as Source   Eval      OIUWGT=IMUWGT                                ?UNIT WGT
     C                   Eval      OIUCST=IMUCST                                ?UNIT COST
     C                   If        OIOVER = 'N'
     C                   Eval      OIUPRI=$UnitPrice(IMITEM:IMSIZE:CMCUST)      ?UNIT PRICE
     C                   EndIf
     C                   Eval      OIQDDC=IMDIS1                                ?QTY DISCOUNT
     C                   Eval      OIEXT$=OIQORD*OIUPRI                         ?EXT AMOUNT
     C* Same as Source   Eval      OIQORD=CountItem                             ?QTY ORDERED
     C                   Eval      OIQSHP=*Zero                                 ?QTY SHIPPED
     C                   Eval      OIQBOO=*Zero                                 ?QTY BACKORDERED
     C* Same as Source   Eval      OISHPC='02'                                  ?SHIP VIA CODE
     C*  see above       Eval      OIAMT1=TXPCT1                                ?TAX AMT RATE 1
     C*  see above       Eval      OIAMT2=TXPCT2                                ?TAX AMT RATE 2
     C*  see above       Eval      OIAMT3=TXPCT3                                ?TAX AMT RATE 3
     C                   Eval      OIDISC=*Zero                                 ?DISCOUNT AMT
     C                   Eval      OISHCD='N'                                   ?SHIP RELEASE CODE
     C* Same as Source   Eval      OIOVER=%CHAR(CMPRCD)                         ?OVERRIDE CODE
     C* Same as Source   Eval      OIOVER='N'                                   ?OVERRIDE CODE
     C* Same as Source   Eval      OIBOCD=IMBOOK                                ?ITEM B/O ALLOWED
     C* Same as Source   Eval      OISLM1=OHSLM1                                ?SALESPERSON 1
     C* Same as Source   Eval      OICOM1=OICOM1                                ?COMMISSION 1
     C* Same as Source   Eval      OISLM2=OISLM2                                ?SALESPERSON 2
     C* Same as Source   Eval      OICOM2=OICOM2                                ?COMMISSION 2
     C                   Eval      OICUST=Customer                              ?CUSTOMER #
     C* Same as Source   Eval      OIDTRQ=ThisMonday                            ?REQ SHIP DATE
     C                   Eval      OIDTLA=Today                                 ?LAST ACTIVITY DATE
     C                   Eval      OITIME=Now                                   ?TIME
     C                   Eval      OIUSER=UserID                                ?USER ID
     C                   Eval      OITRDC=BT_CMTRDC                             ?TRADE DISC %
     C                   Eval      OICTCD=CMCTCD                                ?CONTRACT PRICE CODE
     C                   Eval      OICTCD='N'                                   ?CONTRACT PRICE CODE
     C                   Eval      OICOFL='N'                                   ?CLOSED ORDER FLAG
     C* Same as Source   Eval      OIITYP=*Blanks                               ?ITEM TYPE
     C                   Eval      OIQINV=*Zero                                 ?INVOICE QTY SHIPPED
     C                   Eval      OIPLPT='N'                                   ?PICK LIST PRINTED
     C*  see above       Eval      OITXCD=IMTXBL                                ?TAX ITEM CODE 1
     C*  see above       Eval      OITXST=IMTCD1                                ?TAX ITEM CODE 2
     C*  see above       Eval      OITXCT=IMTCD2                                ?TAX ITEM CODE 3
     C*  see above       Eval      OITXLC=IMTCD3                                ?TAX ITEM CODE 4
     C                   Eval      OIROUT=*Blanks                               ?ROUTE NUMBER
     C                   Eval      OISTOP=*Zero                                 ?STOP
     C                   Eval      OICWT =*Zero                                 ?CATCH WEIGHT
     C                   Eval      OILBS#=*Zero                                 ?POUNDS
     C                   Eval      OIWGSH=*Zero                                 ?WEIGHT SHIPPED
     C                   Eval      OIRSCD=*Blanks                               ?REASON
     C                   Eval      OISEQP=*Zero                                 ?PRIMARY SEQ #
     C                   Eval      OIPRAL=*Blanks                               ?PROMO ALLOW
     C* Same as Source   Eval      OIBPUM=IMBPUM                                ?BASE PRICE UNIT OF
     C* Same as Source   Eval      OISUOM=IMBPUM                                ?SHIP UOM
     C* Same as Source   Eval      OIBLUM=IMBPUM                                ?BILL UOM
     C                   Eval      OIMUL2=*Zero                                 ?MULT 2
     C* Same as Source   Eval      OILOTC=IMLOTC                                ?LOT CONTROL
     C                   Eval      OIOPFL=*Blanks                               ?OPEN ORDER POST FLA
     C                   Eval      OIBOLN=*Blanks                               ?LINE ITEM PUT ON BO
     C* Same as Source   Eval      OIBORQ=ThisMonday                            ?ORIG B/O REQ SHIP D
     C                   Eval      OIPRBO='N'                                   ?PREVIOUS BACKORDER
     C                   Eval      OIPRBO=' '                                   ?PREVIOUS BACKORDER
     C* Same as Source   Eval      OISTA ='N'                                   ?SUBJ TO AVAIL FLAG
     C                   Eval      OIINV#=*Zero                                 ?INVOICE NUMBER
     C                   Eval      OISHFR=CMSHFR                                ?SHIP FROM
     C                   Eval      OITAGS=*Zero                                 ?# TAGS
     C* Same as Source   Eval      OIPPDC='N'                                   ?PROMPT PAY DSC Y/N
     C                   Eval      OIPHYT=CMPHYT                                ?PHYTO CODE
     C                   Eval      OISCHM='N'                                   ?SCHED. TO MOVE FLAG
     C                   Eval      OISCHS='N'                                   ?SCHED. TO SOW FLAG
     C                   Eval      OIQTAL=*Zero                                 ?QTY ALLOCATED
     C                   Eval      OIGLNO=*Zero                                 ?G/L # SPEC CHARGES
     C                   Eval      OIITMA=IMLOOK                                ?ITEM ALPHA SEARCH
     C                   Eval      OISEDP=*Blanks                               ?SEED ORDERED Y/N
     C* Same as Source   Eval      OIRVCD=*Zero                                 ?EXPIRE DATE - CYMD
     C                   Eval      OIQTE =*Blanks                               ?QUOTE LINE ITEM
     C* Same as Source   Eval      OIORDT=ThisMonday                            ?HOLD ORIG REQ SHIP
     C* Same as Source   Eval      OIRVDT=TodayYMD7                             ?REQ SHIP DATE CYMD
     C                   Eval      OILOT#=*Blanks                               ?LOT NUMBER
     C                   Eval      OIFRQD='N'                                   ?FORCE QTY DISC Y/N
     C                   Eval      OISPFL=*Blanks                               ?SUMMARY PICKSLIP FL
     C                   Eval      OIALPH=CMLOOK                                ?CUST ALPHA SEARCH
     C                   Eval      OIPRCL=IMPCL1                                ?PROD CLASS 1
     C                   Eval      OINPSL=*Blanks                               ?NO PICKSLIP FUTURE
     C                   Eval      OIRQTY=*Zero                                 ?PRE RELEASE QTY
     C                   Eval      OIPOST=*Blanks                               ?POST FLAG
     C* Same as Source   Eval      OISOW =*Zero                                 ?SOW DATE CYMD
     C                   Eval      OICCDC=*Zero                                 ?C&C OR SALE DISC. %
     C                   Eval      OILIST=*Blanks                               ?LIST CODE
     C                   Eval      OIROY =IMROYL                                ?ROYALTY EACH

     C                   Eval      Tax1  = OIAMT1 * OIUPRI                      ?ST Tax on Item
     C                   Eval      Tax2  = OIAMT2 * OIUPRI                      ?CO Tax on Item
     C                   Eval      Tax3  = OIAMT3 * OIUPRI                      ?MU Tax on Item

     C                   Eval      TotalTax01 = TotalTax01 + Tax1               ?ST Total Tax
     C                   Eval      TotalTax02 = TotalTax02 + Tax2               ?CO Total Tax
     C                   Eval      TotalTax03 = TotalTax03 + Tax3               ?MU Total Tax
     C                   Eval      TotalOrder = TotalOrder + OIEXT$             ?Total Order Value

    ?C     DetailKey     Chain     FIORDR
    ?C     DetailKey     KList
    ?C                   KFld                    OIORD#
    ?C                   KFld                    OISEQ#
     C                   If        %found(FIORDR)
     C                   Eval      *InH2 = *On
     C                   Else
     C*  RB Only         CallP     $Allocate(OIITEM:OISIZE:OIQORD:'O')          ?Allocate Inventory
    ?C                   Write     RIORDR
    ?C* RBS only         ExSr      Wrt_ALITEM
     C                   EndIf
     C                   EndIf

    ?C     Order         ReadE     FIORDR
     C                   EndDo
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Wrt_OPNORD - Write Open Order Value Record         :
      *?  :.........................................................:
    ?C     Wrt_OPNORD    BegSr                                                  ?

     C                   Eval      OOORD# = OHORD#                              ?ORDER NUMBER
     C                   Eval      OOCOMP = 1                                   ?COMPANY #
     C                   Eval      OOCUST = Customer                            ?CUSTOMER #
     C                   Eval      OODTRY = OHDTRY                              ?REQ. DATE CYMD
     C                   Eval      OOORDY = OHORDY                              ?ORDER DATE CYMD
     C                   Eval      OOARCU = CMARCU                              ?AR CUST #
     C                   Eval      OOSACU = CMSACU                              ?SA CUST #
     C                   Eval      OOBLCU = CMBLCU                              ?BILLING CUST #
     C                   Eval      OOSHFR = CMTERR                              ?SHIP FROM
     C                   Eval      OOEXT$ = TotalOrder                          ?ORDER VALUE

    ?C                   Write     ROPNORD

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Get_MINVT - Get item information                   :
      *?  :.........................................................:
    ?C     Get_MINVT     BegSr                                                  ?

    ?C     ItemKey       KList
    ?C                   KFld                    OIITEM
    ?C                   KFld                    OISIZE
    ?C     ItemWhsKey    KList
    ?C                   KFld                    OIITEM
    ?C                   KFld                    OISIZE
    ?C                   KFld                    OIWHSE
    ?C     ItemKey       Chain     FMINVT                                       ?Item Master
     C                   Eval      IMQTAL = IMQTAL + OIQORD                     ?Allocated
     C                   Eval      IMQTAV = IMQTAV - OIQORD                     ?Available
     C                   If        %Found(FMINVT)
    ?C                   Update    RMINVT                                       ?Item Master
     C                   EndIf
    ?C     ItemWhsKey    Chain     FLKITM                                       ?Item Look up File
     C                   Eval      LKPAL  = LKPAL + OIQORD                      ?Allocated
     C                   If        %Found(FLKITM)
    ?C                   Update    RLKITM                                       ?Item Look up File
     C                   EndIf

      *?  Tax calculations
     C                   Clear                   RMTAXF
     C                   Eval      OITXCD = 'N'                                 ?TAX ITEM CODE 1
     C                   Eval      OITXST = 'N'                                 ?TAX ITEM CODE 2
     C                   Eval      OITXCT = 'N'                                 ?TAX ITEM CODE 3
     C                   Eval      OITXLC = 'N'                                 ?TAX ITEM CODE 4
     C                   If        CMTXST = 'N'                                 ?Tax Exempt ?
    ?C     CMTXJU        Chain     FMTAXF                                       ?Item Master File
     C                   If        %found(FMTAXF)
     C                   Eval      OIAMT1=TXPCT1                                ?TAX AMT RATE 1
     C                   Eval      OIAMT2=TXPCT2                                ?TAX AMT RATE 2
     C                   Eval      OIAMT3=TXPCT3                                ?TAX AMT RATE 3
     C                   If           OIAMT1<>*Zero
     C                             or OIAMT2<>*Zero
     C                             or OIAMT3<>*Zero
     C                   Eval      OITXCD='Y'                                   ?TAX ITEM CODE 1
     C                   EndIf
     C                   If        OIAMT1<>*Zero
     C                   Eval      OITXST='Y'                                   ?TAX ITEM CODE 2
     C                   EndIf
     C                   If        OIAMT2<>*Zero
     C                   Eval      OITXCT='Y'                                   ?TAX ITEM CODE 3
     C                   EndIf
     C                   If        OIAMT3<>*Zero
     C                   Eval      OITXLC='Y'                                   ?TAX ITEM CODE 4
     C                   EndIf
     C                   EndIf
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     *Entry        PList
    ?C                   Parm                    Order                          ?Order To Copy
    ?C                   Parm                    Customer                       ?New Cust. Number

     C*                  Eval      Order = 47100
     C*                  Eval      Customer = 6178
     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      UserID= $User()
     C                   Eval      Now = $Now()

    ?C     Customer      Chain     FMCUST
     C                   If        not %Found(FMCUST)
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C                   EndSR
