      *? Program        : WSPOVAL002
      *?
      *? Description    : This pgm to Validate fields from Xml reference files
      *?                  and Process Order Creation
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 05 Oct 2017
      //------------------------------------------------------------------------
      *? Special Notes  : ** Xml data should be validated before order create
      *?                  ** Order Not passing validation will put into
      *?                     Exception File.
      *?                  ** If Available quantity less than Requested Qty, Process
      *?                     for Avl quanity and write INFO into Error Exp File
      *?                  ** Successful Order creation will be Noted into
      *?                     Control File (For Future reference)
      *?                  ** Phase II : Write Partial Order
      *?                  ** Partial record will be written in FIORDRPART by ALCLOTINV
      *
      *? Called Program : WSRTVMSG  - WS - Retrieve message from Message file
      *?                  GETAVLINV - Get Available Quantity
      *?                  ALCLOTINV - Allocate Quantity
      *?                  GETGERM   - Get Sow Date from Requested Date WEEK #/DATE
      *?                  INVAVLSTS - Inventory Availability Status
      *
      *? Response       : PHFLAG - Process Flag('C' - Order Created)
      *?                                       ('E' - Marked as Exception)
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * WJB02   02/19/18   W.J.Behr     Add Logic for OILOTC.  Change PI for ALC
      * WJB03   03/20/18   W.J.Behr     Add Logic for "AfterOrder"
      *?Phase II changes
      * SUD01   03/23/18   S.Uthaya     Added Partial Order Logic
      * SUD02   04/13/18   S.Uthaya     Added Logic : Full tray not avl and Partial
      *                                 avl then process for Partial for Full
      * SUD03   05/22/18   S.Uthaya     Requested ship date converted into Monday date
      *                                 for Inventory Programs
      * SUD04   09/10/18   S.Uthaya     Allow Zero Quantity Item for Order Create,if
      *                                 Incoming Type "C" - Only for Gloeckner
      * VV01    10/01/18   Vimala       Allow Zero Quantity Item for Order Create,if
      *                                 Incoming Type "C" - For All Brokers
      * SUD05   10/04/18   S.Uthaya     Unmapped the Item If Incoming Type is C and
      *                                 Zero Quantity and Item Xref Not found
      * SUD06   10/16/18   S.Uthaya     Get SOW date from the program
      * SUD07   08/21/18   S.Uthaya     Changes for Plug Order Entry
      *                                 1.Don't do Xref Validations
      *                                 2.Removed Customer PO from Order Header
      * SUD08   11/08/18   S.Uthaya     For Not Authorized Item, Don't write into
      *                                 Exception , Write FIORDR Line With Status "D"
      *                                 and Quantity Zero (CANCELLED - Change VV02)
      * VV02    02/05/19   Vimala       Do not check for Item Authorisation. Call INVAVLSTS program
      *                                 only if Confirmed Qty < Ordered Qty. Write a record in
      *                                 FIORDRB2BC file. Do not write record for same ReqShipDate
      *                                 and OCORFLG='N' for Qty < Ordered qty (Change VV05)
      * VV03    03/07/19   Vimala       Compare ReqShipDate with ReadyBayDate. If not same and if
      *                                 ReqShipDate < Readybaydate, move ReadyBayDate to ReqShipDate
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*Usa);
        /COPY QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Xml Create Order Header Logical File
      *?Key : From Org ID:Customer PO:Header Seq No
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: WS - Xml Create Order Detail Logical File
      *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
        Dcl-F WSPODTLL0  Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: WS - Xml Order Error Exception File
      *?Key : BrokerName:Customer PO
        Dcl-F WSERREXPL0 Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: WS - XML Cross Reference File for FMCUST
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFCUSTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - XML Cross Reference File for FMINVT
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFINVTL0 Disk(*Ext) Keyed Usage(*Input) Prefix(I);
      *
      *?File: WS - XML Cross Reference File for FMSVIA
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFSVIAL0 Disk(*Ext) Keyed Usage(*Input) Prefix(S);
      *
      *?File: Item Master File
      *?Key : Item Number:Item Size
        Dcl-F FMINVT     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Terms Code Master File
      *?Key : Term Code
        Dcl-F FMTERM     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Tax Jurisdiction Master File
      *?Key : Tax Jurisdiction
        Dcl-F FMTAXF     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Ship Via Code Master File
      *?Key : Ship Via Code
        Dcl-F FMSVIA     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Size Code Master File
      *?Key : Size Code
        Dcl-F FMSIZE     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Customer Master File
      *?Key : Customer Number
        Dcl-F FMCUST     Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order User Information File
      *?Key : Order Number
        Dcl-F FPPO       Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Open Order By Value Order File
      *?Key : Order Number
        Dcl-F FOPNORD    Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order Header Record
      *?Key : Order Number
        Dcl-F FHORDR     Disk(*Ext) Keyed Usage(*Update:*Output);
        Dcl-F FHORDRHIST Disk(*Ext) Usage(*Output);
      *
      *?File: Order Detail Record
      *?Key : Order Number:Order Seq#
        Dcl-F FIORDR     Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order Detail Partial Item Records
      *?Key : Order Number:Order Seq#
        Dcl-F FIORDRPART Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - Order Change Control File - Flag Maintenance
      *?Key : Order Number:Order Line Number:Broker Line Item Number
        Dcl-F WSORCHCPF  Disk(*Ext) Keyed Usage(*Update:*Output);
      *
VV02  *?File: Order Detail B2B Coments
  |   *?Key : Order Number: Order Line:TimeStamp(D)
VV02    Dcl-F FIORDRB2B1 Disk(*Ext) Keyed Usage(*Output);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPOVAL002;
           PFromOrgId Like(PHFRORID);
           PCustPO    Like(PHBRKORID);
           PSeqno     Like(PHSEQNO);
           PFlag      Like(PHFLAG);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Call CL program to Retreive MSG
        Dcl-Pr RtvErrMsg Extpgm('WSRTVMSG');            // CL Program
           WkMsgId  Char(7);                            // Msg Id
           WkMsgF   Char(10);                           // Msg File
           WKMsg    Char(132);                          // Msg
           WkDta    Char(10);                           // Msg Data
        End-Pr;
      *
      *?Procedure Prototype Declaration : To Get Comment for Detail file
        Dcl-Pr $Comment  Extpgm;
           PrOrdNo  Packed(6);                          // Order Number
        End-Pr;
      *
SUD06 *?Procedure Prototype Declaration : Get Sow Date from Req Date WEEK#/DATE
  |     Dcl-Pr GETGERM Extpgm('GETGERM');
  |        PItem    Like(IMITEM);
  |        PSize    Like(IMSIZE);
  |        PWhse    Like(IMWHSE);
  |        PReqDte  Packed(7:0);                        // CYMD
  |        PSowDte  Packed(7:0);                        // CYMD
SUD06   End-Pr;
      *
      *?Procedure Prototype Declaration : Call Rpg program to Get Avail Qty
        Dcl-Pr GETAVLINV Extpgm('GETAVLINV');           // Rpg Program
           Item      Char(12)    Const;                 // Item
           Size      Char(3)     Const;                 // Size
           Monday    Date        Const;                 // ReqShipDate
           ReqQty    Zoned(11:2) Const;                 // Requested Qty
           AvlQty    Zoned(11:2);                       // Available Qty
           Lot_Flag  Char(1);
SUD01      WkParInd  Ind;
        End-Pr;
      *
      *?Procedure Prototype Declaration : Call Rpg program to Allocate Avail Qty
        Dcl-Pr ALCLOTINV Extpgm('ALCLOTINV');           // Rpg Program
           OrderNumber     Zoned(6:0)  Const;           // Order Number
           OrderSequence   Zoned(3:0)  Const;           // Order Seq
           CustomerNumber  Zoned(6:0)  Const;           // Customer #
           Item            Char(12)    Const;           // Item
           Size            Char(3)     Const;           // Item Size
           MondayDate      Date        Const;           // Date
           QtyToAllocate   Zoned(11:2) Const;           // Qty to Allocate
           Allocated       Zoned(11:2) ;                // Allocated
           Lot_Flag        Char(1);
SUD01      WkParInd        Ind;
        End-Pr;
      *
SUD08 *?Procedure Prototype Declaration : Check on the Inventory availability status
  |     Dcl-Pr INVAVLSTS Extpgm;                   // Rpg Program
  |        Item          Char(12);                 // Item
  |        Size          Char(3);                  // Size
  |        ThisDate      Like(RqToday);            // Ready Date
  |        ThisType      Char(10);                 // Plug-View-Type
  |        ErrorNumber   Zoned(1:0);               // Error
  |        ErrDesc       Char(10);                 // Error Description
SUD08   End-Pr;
      *
      *?Program Status Data Structure :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Data Structure for Zip Code :
        Dcl-Ds WkZipC Qualified;
           WkChar5    Char(5) Pos(1);
           WkChar4    Char(4) Pos(7);
        End-Ds;
      *
      *?Work Variables Declaration :
        Dcl-S WkCust    Zoned(6)    Inz;              // Used for Cust Xref
        Dcl-S WkSvia    Char(2)     Inz;              // Used for SVIA Xref
        Dcl-S WkMsgf    Char(10)    Inz;              // Used for Msg File
        Dcl-S WkMsgId   Char(7)     Inz;              // Used for Msg File
        Dcl-S WkMsg     Char(132)   Inz;              // Used for Msg File
        Dcl-S WkDta     Char(10)    Inz;              // Used for Msg File
        Dcl-S WkFirst   Char(1)     Inz;              // Used for Msg File
        Dcl-S WkErSeq   Zoned(6)    Inz;              // Used for Msg File
        Dcl-S WkQty     Zoned(11:2) Inz;              // Used for GetavlInv
        Dcl-S WkOQty    Zoned(11:2) Inz;              // Used for Qty Conversion
        Dcl-S WkChar5   Char(5)     Inz;
        Dcl-S WkChar4   Char(4)     Inz;
        Dcl-S WkDte     Date(*Usa);                   // Used for GetavlInv
        Dcl-S WkLotC    Char(1)     Inz;
SUD01   Dcl-S WkOrdQty  Zoned(11:2) Inz;              // Used for Partial Order
  |     Dcl-S WkOrdQty1 Zoned(11:0) Inz;              // Used for Partial Order
  |     Dcl-S WkPartQty Zoned(5)    Inz(0);           // Used for Partial Order Qty
  |     Dcl-S WkFullQty Zoned(5)    Inz(0);           // Used for Full Order Qty
  |     Dcl-S WkPQty    Zoned(5)    Inz(0);           // Used for Partial Offered Qty
  |     Dcl-S WkParInd  Ind         Inz(*Off);        // Used for Partial Order Ind
  |     Dcl-S WkList    Char(3)     Inz;
  |     Dcl-S WkFor     Zoned(2)    Inz(1);           // Used for Partial Order
  |     Dcl-S WkPer     Packed(5:2) Inz;              // Used for Partial Order Percentage
  |     Dcl-S WkDis     Packed(5:2) Inz;              // Used for Partial Order Discount
SUD01   Dcl-S X         Zoned(1)    Inz(1);           // Used for Partial Order
SUD07   Dcl-S WkPos     Zoned(1)    Inz(0);           // Used for Plug Order
SUD08   Dcl-S ThisType  Char(10);                     // Plug-View-Type
  |     Dcl-S Error     Zoned(1:0);                   // Error
SUD08   Dcl-S ErrDesc   Char(40);                     // Error Description
      *
      *?Flag Variables Declaration :
        Dcl-S EFlag     Char(1)  Inz('N');            // Error Flag (Y/N)
        Dcl-S FFlag     Char(1)  Inz(' ');            // File Falg(H-Header : D-Detail)
        Dcl-S WkFlag    Char(1)  Inz;                 // Order Create Flag
SUD01   Dcl-S WkFullF   Char(1)  Inz('N');            // Inv Avl Flag for Full Tray
SUD01   Dcl-S WkPartF   Char(1)  Inz('N');            // Inv Avl Flag for Partial Qty
SUD02   Dcl-S WkPrFlag  Char(1)  Inz('N');            // Used for Partial Order Qty
SUD05   Dcl-S WkUFlag   Char(1)  Inz('N');            // Used for Unmapped Item
SUD07   Dcl-S WkBrkFlg  Char(1)  Inz('N');            // Used for Plug Order
VV02  * // Dcl-S WkErFlag  Char(1)  Inz('N');            // Used for Not Aunthorized Item Check
      *
      *?Function Variables Declaration :
        Dcl-S Now            Zoned(6) Inz;
        Dcl-S Today          Date;
        Dcl-S TodayMDY       Zoned(6) Inz;
        Dcl-S TodayYMD7      Zoned(7) Inz;
        Dcl-S ThisMonday     Zoned(6) Inz;
        Dcl-S ThisMonCYMD    Zoned(7) Inz;
        Dcl-S RqToday        Date;
        Dcl-S RqTodayMDY     Zoned(6) Inz;
        Dcl-S RqTodayYMD7    Zoned(7) Inz;
        Dcl-S RqThisMonday   Zoned(6) Inz;
        Dcl-S RqThisMonCYMD  Zoned(7) Inz;
VV03    Dcl-S WkRqMon        Date(*ISO);
VV03    Dcl-S WkRbDte        Date(*ISO);
      *
      *?Variables Used for Calculation :
        Dcl-S Tax1        Zoned(5:2) Inz;
        Dcl-S Tax2        Zoned(5:2) Inz;
        Dcl-S Tax3        Zoned(5:2) Inz;
        Dcl-S TotalTax01  Zoned(7:2) Inz;
        Dcl-S TotalTax02  Zoned(7:2) Inz;
        Dcl-S TotalTax03  Zoned(7:2) Inz;
        Dcl-S TotalOrder  Zoned(9:2) Inz;
      //--------------------------------------------------------------------
      *?                :--------------:
      *?                : Copy  Source :
      *?                :--------------:
      *
      *?Service Programs
    ? /COPY QFunctDefn,$Date
    ? /COPY QFunctDefn,$Date7
    ? /COPY QFunctDefn,$MDYDate
    ? /COPY QFunctDefn,$Monday
    ? /COPY QFunctDefn,$GetOrder#
    ? /COPY QFunctDefn,$UnitPrice
    ? /COPY QFunctDefn,$Now
    ? /COPY QFunctDefn,$TimeStamp
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line

      *?   // Start program
           Exsr InzPgm;

      *?   // End program
           *InLr = *On;
           Return;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Parameters
      *?      : Read Xml Header File record for Order Creation
      *?        Record Selecion with Entry parameters
      *
        Begsr InzPgm;

      *?   // Get Values from Copy Functions
           Now         = $Now;
           Today       = $Date(0);                       // Today MDY
           TodayYMD7   = $Date7(Today);                  // Today CYMD7
           TodayMDY    = $MDYDate(Today);                // Today MDY
           ThisMonCYMD = $Date7($Monday(Today:'FRI'));   // Monday CYMD
           ThisMonday  = $MDYDate($Monday(Today:'FRI')); // Monday MDY

      *?   // Get Xml Order Header File Record
           Chain (PFromOrgId:PcustPO:PSeqno) WSPOHDRL1;
           If %Found;

      *?      // Get Dates based on Requested Date
              Exsr ReqDateSR;

      *?      // Initialise Parameters
              EFlag = 'N';                               // Error Flag
              WkFlag= *Blanks;                           // Order Create Flag
              FFlag = *Blanks;                           // Error File Flag
              WkFirst='Y';                               // First Time Flag

      *?      // Validate Header File Fields
              Exsr HeaderValidate;

      *?      // Check Work Flag and Process Order Creation
              If WkFlag = *Blanks;
                 Exsr OrderCreate;
                 AfterOrder();          //WJB03
              Endif;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : ReqDateSR Subroutine :
      *?                :----------------------:
      *
      *?Logic : Get Monday date based on Requested Date
      *
        Begsr ReqDateSR;

VV03  *?   // Get Readybaydate
VV03       Exec sql SET :WkRbDte = Ready_Bay_Week;

VV03  *?   // Convert ReqShipdate to Monday date and compare with ReadyBayDate
VV03       RqThisMonday = $MDYDate($Monday(PHRQSHDT:'FRI')); // Monday *ISO
VV03       WkRqMon = %Date(RqThisMonday:*MDY);

VV03       If WkRqMon <> WkRbDte and WkRqMon < WkRbDte;
VV03          RqToday    = WkRbDte;
VV03       Else;
              RqToday    = PHRQSHDT;                         // Today MDY
VV03       Endif;
      *?   // Get Values from Copy Functions for Requested Ship Date
           RqTodayYMD7   = $Date7(RqToday);                  // Today CYMD7
           RqTodayMDY    = $MDYDate(RqToday);                // Today MDY
           RqThisMonCYMD = $Date7($Monday(RqToday:'FRI'));   // Monday CYMD
           RqThisMonday  = $MDYDate($Monday(RqToday:'FRI')); // Monday MDY
SUD03      WkDte         = %Date(RqThisMonday:*MDY);

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : HeaderValidate Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Validate Mandatory Fields in Xml Header File
      *?      : Validate against FMCUST Xref File
      *?      : Validate against FMCUST with Status = 'A'
      *
        Begsr HeaderValidate;

      *?   // Mandatory Fields validation
           If PHBRKORID = *Blanks;
              WkMsgId = 'WS00001';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If PHRQSHDT = *Loval;
              WkMsgId = 'WS00002';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If PHSHPNUM = *Blanks;
              WkMsgId = 'WS00009';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If PHSHPNAM = *Blanks;
              WkMsgId = 'WS00010';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If PHSHPAD1 = *Blanks and PHSHPAD2 = *Blanks;
              WkMsgId = 'WS00011';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If PHSHPSTE = *Blanks;
              WkMsgId = 'WS00012';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If PHSHPCTY = *Blanks;
              WkMsgId = 'WS00013';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If PHSHPPHN = *Blanks;
              WkMsgId = 'WS00014';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

SUD07 *?   // Cross reference file validation for BrokerShiptoNumber
  |        If PFromOrgId <> 'Kube Pak';                     // Xref Not for Plug Order
  |           Chain (PFromOrgId:'Customer':PHSHPNUM) XREFCUSTL0;
  |           If %Found;
  |              WkCust = %Int(XRLCLKEY);
  |              Chain(N) WkCust FMCUST;
  |              If %Found and CMSTAT <> 'A';
  |                 WkMsgId = 'WS00023';
  |                 EFlag = 'Y';
  |                 FFlag = 'H';
  |                 Exsr ErrProcess;
  |              Endif;
  |              If Not %Found;
  |                 WkMsgId = 'WS00015';
  |                 EFlag = 'Y';
  |                 FFlag = 'H';
  |                 Exsr ErrProcess;
  |              Endif;
  |           Else;
  |              WkMsgId = 'WS00016';
  |              EFlag = 'Y';
  |              FFlag = 'H';
  |              Exsr ErrProcess;
  |           Endif;
  |        Else;
  |           XRLCLKEY = PHSHPNUM;
  |           WkCust = %Int(XRLCLKEY);
  |           Chain(N) WkCust FMCUST;
  |        Endif;
  |
  |   *?   // Cross reference file validation for Shipment Method
SUD07      If PFromOrgId <> 'Ball Seed' and PFromOrgId <> 'Kube Pak';
              Chain (PHFRORID:'Customer':PHSHPMTH) XREFSVIAL0;
              If Not %Found;
                 WkMsgId = 'WS00027';
                 EFlag = 'Y';
                 FFlag = 'H';
                 Exsr ErrProcess;
              Endif;
           Endif;

      *?   // Order Create Flag
           If EFlag = 'Y';
             WkFlag = 'Y';
             PHFLAG  = 'E';
           Endif;

      *?   // Process Detail Validation
      *?   // Read Xml Order Detail File Non Processed Records
           Setll (PHFRORID:PHBRKORID:PHSEQNO) WSPODTLL0;
           ReadE (PHFRORID:PHBRKORID:PHSEQNO) WSPODTLL0;
           Dow Not %Eof;

      *?      // Validate Detail File Fields, Only for Xreferenced Item
              If PDFLAG <> 'U';
                 Exsr DetailValidate;
SUD05            Exsr UpdateDetailSr;
              Endif;
              ReadE (PHFRORID:PHBRKORID:PHSEQNO) WSPODTLL0;
           Enddo;

      *?   // If Error in Detail File Update Header File Flag
           If PHFLAG  = 'E';
              PHORDNO = *Zeros;
              Exsr WSHdrAudit;
              Update WSPOHDRR %Fields(PHFlag:PHORDNO:PHUPDDAT:PHUPDTIM
                                            :PHUPDUSR:PHUPDJOB:PHUPDPGM);
      *?      // Return Flag if Error
              PFlag = PHFLAG;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : DetailValidate Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Validate Mandatory Fields in Xml Detail File
      *?      : Validate against FMINVT Xref File
      *?      : Validate against FMINVT with Status = 'A'
      *
        Begsr DetailValidate;

      *?   // Mandatory Fields validation
           EFlag    = 'N';
SUD05      WkUFlag  = 'N';
VV02  * // SUD08      WkErFlag = 'N';
           WkOQty = *Zeros;

      *?   // Cross reference file validation for Item (Xref Not for Plug Order)
SUD07      If PHFRORID <> 'Kube Pak';
SUD05         If PDINCTYP <> 'C' and PDORDQTY <> *Zeros;
  |              IXRLCLITEM = *Blanks;
  |              IXRLCLSIZE = *Blanks;
  |              Chain (PHFRORID:'Customer':PDBRKMAT) XREFINVTL0;
  |              If %Found;
  |                 Chain (IXRLCLITEM:IXRLCLSIZE) FMINVT;
  |                 If %Found and IMSTAT <> 'A';
  |                    WkMsgId = 'WS00024';
  |                    EFlag = 'Y';
  |                    FFlag = 'D';
  |                    WkOQty = PDORDQTY;
  |                    Exsr ErrProcess;
  |                 Endif;
  |                 If Not %Found;
  |                    WkMsgId = 'WS00021';
  |                    EFlag = 'Y';
  |                    FFlag = 'D';
  |                    WkOQty = PDORDQTY;
  |                    Exsr ErrProcess;
SUD05               Endif;

VV02  *?SUD08 //    // Check For Not Authorized Item
  |   *       //    If EFlag = 'N';
  |   *       //       Exsr CheckItemAuth;
VV02  *SUD08  //    Endif;

SUD05            Else;
  |                 WkMsgId = 'WS00022';
  |                 EFlag = 'Y';
  |                 FFlag = 'D';
  |                 WkOQty = PDORDQTY;
  |                 Exsr ErrProcess;
SUD05            Endif;

SUD08 *?         // Check only for Authorized Item
VV02  * // SUD08            If PDSCHSHDT = *Loval and WkErFlag = 'N';
VV02          If PDSCHSHDT = *Loval;
                    WkMsgId = 'WS00020';
                    EFlag = 'Y';
                    FFlag = 'D';
                    Exsr ErrProcess;
                 Endif;
SUD05         Else;
  |              WkUFlag = 'Y';
SUD05         Endif;
SUD07      Else;
  |           WkPos = %Scan('-':PDBRKMAT:1);
  |           IXRLCLITEM = %Subst(PDBRKMAT:1:WkPos-1);
  |           IXRLCLSIZE = %Subst(PDBRKMAT:WkPos+1);
  |           WkPos = 0;
SUD07      Endif;

SUD04 *?   // Allow Zero Quantity with Incoming Type "C"  & Do only for Authorized Item
VV02  * //SUD05      If PDORDQTY <= *Zeros and WkUFlag = 'N' and WkErFlag = 'N';       //SUD08
VV02       If PDORDQTY <= *Zeros and WkUFlag = 'N';
VV01        //If PFromOrgId = 'Gloeckner';
SUD04            If PDINCTYP <> 'C';
  |                 WkMsgId = 'WS00019';
  |                 EFlag = 'Y';
  |                 FFlag = 'D';
  |                 WkOQty= PDORDQTY;
  |                 Exsr ErrProcess;
  |              Endif;
VV01        //Endif;
SUD04      Endif;

      *?   // Convert Ordered Quantity to KubePak Quantity
VV02  * // SUD08      If PDORDQTY <> *Zeros and WkErFlag = 'N';
VV02       If PDORDQTY <> *Zeros;
SUD01
  |   *?      // Check partial Quantity
  |           Exsr CheckPartial;
  |
  |   *?      // Get available Inventory
SUD01         Exsr GetAvlInvSr;

           Endif;

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?                :-------------------------:
  |   *?                : CheckPartial Subroutine :
  |   *?                :-------------------------:
  |   *
  |   *?Logic : Check Partial Quantity for each Line Item
  |   *
  |     Begsr CheckPartial;
  |
SUD01 *?   // Initialise work variables
SUD02      WkPrFlag = 'N';
SUD01      WkParInd  = *Off;
  |        WkOQty    = *Zeros;
  |        WkPer     = *Zeros;
  |        WkDis     = *Zeros;
  |        WKFullF   = 'N';
  |        WkPartF   = 'N';
  |        WkFullQty = 0;
  |        WkPartQty = 0;
  |        X = 1;
  |
  |   *?   // Check Size for the Line Item
  |        Chain IXRLCLSIZE FMSIZE;
  |        If %Found and SZSTAT = 'A';
  |           WkOrdQty1 = %Int(PDORDQTY);
  |           WkFullQty = %Div(WkORDQTY1:SZSALE);
  |           WkPartQty = %Rem(WkORDQTY1:SZSALE);
  |
  |   *?      // Ordered Full and Partial Qty
  |           If WkPartQty <> *Zeros and WkFullQty <> *Zeros;
  |              X = 2;
  |           Endif;
  |
  |   *?      // Ordered Only Full Qty
  |           If X = 1 and WkFullQty <> *Zeros;
  |              WkOQty = %Div(WkORDQTY1:SZSALE);
  |
  |   *?      // Ordered Only Partial Qty
  |           Elseif X = 1 and WkFullQty = *Zeros;
  |              WkOQty = %Rem(WkORDQTY1:SZSALE);
  |              WkParInd = *On;
  |           Else;
  |              WkOQty = %Div(WkORDQTY1:SZSALE);
  |              WkParInd = *Off;
  |           Endif;
  |        Else;
  |           WkOQty = PDORDQTY;
  |        Endif;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :------------------------:
  |   *?                : GetAvlInvSr Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Get available Inventory before process
  |   *?
  |   *
  |     Begsr GetAvlInvSr;
  |
  |   *?   // Check only if Item is found in cross reference
  |        For WkFor = 1 to X;
  |           WkQty = *Zeros;
  |           If X = 2 and WkFor = 2;
  |              WkParInd = *On;
  |              WkOQty = 1;
  |           Endif;
  |
  |           If IXRLCLITEM <> *Blanks and IXRLCLSIZE <> *BLANKS;
  |              GETAVLINV(IXRLCLITEM:IXRLCLSIZE:WkDte:WkOQty:WkQty
  |                               :WkLotC:WkParInd);
  |           Endif;
  |
  |   *?      // Write info message in Exception File
  |           If WkQty = *Zeros;              // Qty Available
  |              WkMsgId = 'WS00026';
  |              FFlag = 'I';
  |              WkOQty = PDORDQTY;
  |              Exsr InfoSr;
  |           Endif;
  |
  |        Endfor;
  |
  |     Endsr;
SUD01 //--------------------------------------------------------------------
VV02  *?                :------------------------:
  |   *?                : CheckAvlSts Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Check Item available status by calling program INVAVLSTS
  |   *?
  |   *
  |     Begsr CheckAvlSts;
  |
  |   *?   // Check Item Status for Item and Broker
  |   *    WkErFlag = 'N';
  |        If PHFRORID = 'Ball Seed';
  |           ThisType = 'Ball Seed';
  |        Else;
  |           ThisType = 'WEB';
  |        Endif;
  |
  |   *?   // Call Inventory Availability Status Program
  |        Error   = *Zeros;
  |        ErrDesc = *Blanks;
  |        INVAVLSTS(IXRLCLITEM:IXRLCLSIZE:RqToday:
  |                  ThisType:Error:ErrDesc);
  |        If Error <> 0;
  |   *       WkErFlag = 'Y';
  |   *?   // Write a record in FIORDRB2B comment file for any error to be sent in Ack
  |           Exsr WriteB2BErr;
  |        Endif;
  |
  |     Endsr;
VV02  //--------------------------------------------------------------------
VV02  *?            :------------------------:
  |   *?            : WriteB2BErr Subroutine :
  |   *?            :------------------------:
  |   *
  |   *?Logic : Write a record into Order Detail B2B Comments file for any error encountered
  |   *?
  |     Begsr WriteB2BErr;
  |
  |   *?   // Clear Record
  |        Clear RIORDRB2BC;
  |
  |        B2BORD# = OHORD#;
  |        B2BSEQ# = OISEQ#;
  |        B2BCMNT = ErrDesc;
  |        B2BTIME = %Timestamp();
  |        B2BUSER = User;
  |        Write RIORDRB2BC;
  |
VV02    Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ErrProcess Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Retrieve message from Message File (WSMSGF) and
      *?        Write into Error Exception File
      *?Used Program & File : WSRTVMSG : WSMSGF
      *
        Begsr ErrProcess;

      *?   // Call CL program to Get Error Msg
           Monitor;
             WkMsgf = 'WSMSGF';
             WkDta  = *Blanks;
             RtvErrMsg(WkMsgID:WkMsgf:WKMSG:WkDta);
           On-Error;
           EndMon;

      *?   // Clear Record
           Clear WSERREXPR;

      *?   // Move Values into Fields
           ERBRKNAM  = PHFRORID;               // BrokerName
           ERBRKORID = PHBRKORID;              // Broker Order ID
           ERPOSEQ   = PHSEQNO;                // PO Sequence # Unique
           If WkFirst='Y';
              WkErSeq  = 1;                    // First Time Flag
              WkFirst  = 'N';                  // First Time Flag
           Else;
              WkErSeq  += 1;
           Endif;
           ERERRSEQ = WkErSeq;                 // Error Sequence #
           ERRQSPDT = PHRQSHDT;                // Requested Ship Date
           ERRMSGID = WkMsgID;                 // Error Message ID
           ERRMSG   = WkMsg ;                  // Error Message
           ERFLAG   = FFlag;                   // Flag
           ERBRKSLD = PHSLDNUM;                // Sold To Customer
           ERBRKSHP = PHSHPNUM;                // Ship To Customer
           ERCUSNUM = CMCUST;
           ERORDNO  = *Zeros;                  // Order Number
           If FFlag = 'H';
              ERBRKMAT = *Blanks;
              ERITMNUM = *Blanks;
              ERITMSIZ = *Blanks;
              ERQTYORD = *Zeros;
              ERPODSEQ = *Zeros;
           Elseif FFlag = 'D';
              ERBRKMAT = PDBRKMAT;             // Broker Item
              ERITMNUM = IXRLCLITEM;           // Item
              ERITMSIZ = IXRLCLSIZE;           // Size
              ERQTYORD = WkOQTY;               // Quantity Ordered
              ERPODSEQ = PDSEQNO;
           Endif;

      *?   // Execute Audit Stamp
           Exsr WSErrAudit;

      *?   // Write Error Record
           Write WSERREXPR;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : OrderCreate Subroutine :
      *?            :------------------------:
      *
      *?Logic : OrderCreate Process
      *?
        Begsr OrderCreate;

      *?   // Execute Header Subroutine
           Exsr WriteHeader;

      *?   // Read XML Order Detail File
           Setll (PHFRORID:PHBRKORID:PHSEQNO) WSPODTLL0;
           ReadE (PHFRORID:PHBRKORID:PHSEQNO) WSPODTLL0;
           Dow Not %Eof;

SUD01 *?      // Execute Detail Subroutine, Process Only XReferenced Item
SUD01         If PDFLAG <> 'U';
SUD07            If PHFRORID <> 'Kube Pak';
  |                 Chain (PHFRORID:'Customer':PDBRKMAT) XREFINVTL0;
  |                 If %Found;
SUD07                  WkBrkFlg = 'Y';
VV02  * SUD08//        Exsr CheckItemAuth;               // Check For Authorization
SUD07               Else;
  |                    WkBrkFlg = 'N';
  |                 Endif;
  |              Else;
  |                 WkPos = %Scan('-':PDBRKMAT:1);
  |                 IXRLCLITEM = %Subst(PDBRKMAT:1:WkPos-1);
  |                 IXRLCLSIZE = %Subst(PDBRKMAT:WkPos+1);
  |                 WkPos = 0;
SUD07               WkBrkFlg = 'Y';
VV02  * SUD08 //    WkErFlag = 'N';
SUD07            Endif;
  |
VV02  *SUD07  //          If WkBrkFlg = 'Y' and WkErFlag = 'N';        // SUD08
VV02             If WkBrkFlg = 'Y';
SUD01
SUD01 *?            // Check Partial Qualntity
SUD04               If PDORDQTY <> *Zeros;
  |                    Exsr CheckPartial;
  |                    Exsr ChkAvlInvSr;
  |                 Else;
  |                    WkFullQty = *Zeros;
  |                    WkPartQty = *Zeros;
  |                    WkParInd  = *Off;
SUD04               Endif;
SUD01
  |   *?            // Write detail record based on available quantity
  |                 Select;
  |                 When WkFullQty <> *Zeros and WkPartQty = *Zeros;      // Only for Full Tray
  |                    If WkPrFlag = 'N';
  |                       WkFor = 1;
  |                       Exsr WriteDetail;
  |                    Else;
  |                       If WkFullF = 'Y';
  |                          X = 2;
  |                          Exsr PartialSr;
  |                       Else;
  |                          WkFor = 1;
  |                          Exsr WriteDetail;
  |                       Endif;
  |                    Endif;
  |                 When WkFullQty = *Zeros and WkPartQty <> *Zeros;      // Only for Partial
  |                    WkFor = 1;
  |                    Exsr WriteDetail;
  |                 When WkFullQty <> *Zeros and WkPartQty <> *Zeros;     // Both Full and Partial
  |                    If WkFullF = 'Y' and WkPartF = 'Y';                // Both F & P Available
  |                       X = 2;
  |                       Exsr PartialSr;
  |                    Elseif WkFullF = 'N' and WkPartF = 'Y';            // Only Partial Available
  |                       WkFor = 1;
  |                       Exsr WriteDetail;
  |                    Elseif WkFullF = 'Y' and WkPartF = 'N';            // Only FullTray Available
  |                       WkFor = 1;
  |                       Exsr WriteDetail;
  |                    Elseif WkFullF = 'N' and WkPartF = 'N';            // Both not available
  |                       WkFor = 1;
  |                       Exsr WriteDetail;
SUD01                  Endif;
SUD04               When WkFullQty = *Zeros and WkPartQty = *Zeros;       // Both Full and Partial
  |                    WkFor = 1;
SUD04                  Exsr WriteDetail;
SUD01               Endsl;
SUD01            Endif;

VV02  * SUD08 //           If WkErFlag = 'Y';
  |           //      WkFullQty = *Zeros;
  |           //      WkPartQty = *Zeros;
  |           //      WkParInd  = *Off;
  |           //      WkFor = 1;
  |           //      Exsr WriteDetail;
VV02  *SUD08  //          Endif;
SUD01         Endif;
              ReadE (PHFRORID:PHBRKORID:PHSEQNO) WSPODTLL0;
           Enddo;

           OHAMT1 = TotalTax01;                  // Tax Amt 1
           OHAMT2 = TotalTax02;                  // Tax Amt 2
           OHAMT3 = TotalTax03;                  // Tax Amt 3

      *?   // Write User Order Information
           Exsr WritePPO;

      *?   // From FMCUST File
           Chain(N) OHBLCU FMCUST;
           If %Found;
              OHSLD1 = CMNAME;                      // Bill To
              OHSLD2 = CMADD2;                      // Address Line #1
              OHSLD3 = CMADD3;                      // Address Line #2
              OHSLD4 = CMADD4;                      // Address Line #3
              OHSLCT = CMCITY;                      // City
              OHSLST = CMSTST;                      // State
              OHSLZP = CMZIP ;                      // Zip Code
           Endif;

      *?   // Write Header Record
           Write RHORDR;
           HSTUSER = User;
           HSTPROGRAM = Pgm;
           HSTTIME = $Timestamp();
           Write RHORDRHIST;
           $Comment(OHORD#);                    // To Update FHORDR & FIORDR

      *?   // Write Open Order Information
           Exsr WriteOpenOrd;

      *?   // Update Customer Master File
           Chain WkCUST FMCUST;
           If %Found;
              CMOCUR = CMOCUR + 1;
              CMOYTD = CMOYTD + 1;
              CMDTLO = TodayMDY;
              CMVOPO = CMVOPO + TotalOrder;
              Update RMCUST %Fields(CMOCUR:CMOYTD:CMDTLO:CMVOPO);
           Endif;

      *?   // Update Process Flag Completed with Audit Stamp
           PHFLAG  = 'C';
           PHORDNO = OHORD#;
           Exsr WSHdrAudit;
           Update WSPOHDRR %Fields(PHFLAG:PHORDNO:PHUPDDAT:PHUPDTIM
                                       :PHUPDUSR:PHUPDJOB:PHUPDPGM);
      *?   // Return Flag
           PFlag = PHFLAG;

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?                :------------------------:
  |   *?                : ChkAvlInvSr Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Check available Inventory before writing process
  |   *?
  |   *
  |     Begsr ChkAvlInvSr;
  |
  |   *?   // Check only if Item is found in cross reference
  |        For WkFor = 1 to X;
  |           WkQty = *Zeros;
  |           If X = 2 and WkFor = 2;
  |              WkParInd = *On;
  |              WkOQty = 1;
  |           Endif;
  |
  |           If IXRLCLITEM <> *Blanks and IXRLCLSIZE <> *BLANKS;
  |              GETAVLINV(IXRLCLITEM:IXRLCLSIZE:WkDte:WkOQty:WkQty
  |                               :WkLotC:WkParInd);
  |           Endif;
SUD01
SUD02 *?      // Check Partial Qty if full tray is not available(When There is no Partial Order)
  |           If WkParInd = *Off and WkPartQty = *Zeros;
  |              If WkQty < WkOQty and WkQty <> *Zeros;
  |                 WkFullF = 'Y';
  |              Endif;
  |              If WKQty = *Zeros Or WkQty < WkOQty;
  |                 WkPrFlag = 'N';
  |                 WkQty    = *Zeros;
  |                 WkOQty   = 1;
  |                 WkParInd = *On;
  |                 GETAVLINV(IXRLCLITEM:IXRLCLSIZE:WkDte:WkOQty:WkQty
  |                                        :WkLotC:WkParInd);
  |                 If WkQty <> *Zeros;
  |                    WkPrFlag = 'Y';                       // If Partial available Process
  |                 Else;
  |                    WkParInd = *Off;                      // Write FIORDR With 0 Qty
  |                 Endif;
  |              Endif;
  |           Endif;
SUD02
SUD01         If WKQty <> *Zeros and WkParInd = *Off;
  |              WkFullF = 'Y';
  |           Elseif WKQty <> *Zeros and WkParInd = *On;
  |              WkPartF = 'Y';
  |           Endif;
  |
  |        Endfor;
  |
SUD01   Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteHeader Subroutine :
      *?            :------------------------:
      *
      *?Logic : Move values from corresponding File Fields
      *?      : Use Functions to get Date and Order Number
      *?      : Used files - FMCUST, FMTERM , XREFCUST
      *
        Begsr WriteHeader;

      *?   // Clear Record
           Clear RHORDR;

      *?   // Move Values into Order Header File
           OHSTAT = 'A';                         // Status - Constant
           OHORD# = $GetOrder#(00);              // Order Number
           OHCOMP = 01;                          // Company # - Constant

      *?   // From XREFCUSTL0 File
           OHCUST = %Int(XRLCLKEY);              // Customer from FMCUST XRefFil

      *?   // From WSPOHDRL1 File
           OHNAME = PHSHPNAM;                    // Ship To Name
           OHSHP2 = PHSHPAD1;                    // Address Line #1
           OHSHP3 = PHSHPAD2;                    // Address Line #2
           OHSHP4 = *Blanks;                     // Address Line #3
           OHSHCT = PHSHPCTY;                    // City
           OHSHST = PHSHPSTE;                    // State

      *?   // Remove Hyphen for Zip and Move
           WkZipC =  PHSHPZIP;
           OHSHZP =  WkZipC.WkChar5 ;                     // Zip Code
           If PFromOrgId <> 'Kube Pak';
              OHPONO = PHBRKORID;                         // P.O. Number
           Endif;
VV03  * // OHDTRQ = $MDYDate($Monday(PHRQSHDT:'FRI'));    // Req Ship Date
VV03       OHDTRQ = RqThisMonday;                         // Req Ship Date
           OHDTCN = OHDTRQ;                               // Cancel Date

      *?   // From FMCUST File
           OHTXST = CMTXST;                      // Tax Exempt from FMCUST
           OHTXJU = CMTXJU;                      // Jurisdiction
           OHSHIN = CMSHIN;                      // Shipping Instructions
           OHTYPE = CMCTYP;                      // Customer Type
           OHBOCD = CMBOOK;                      // Cust B/O Allowed
           OHPRCD = CMPRCD;                      // Price Code
           OHTRDC = CMTRDC;                      // Trade Disc. %
           OHTMCD = CMTMCD;                      // Terms Code
           OHUPSZ = CMUPSZ;                      // Freight Zone
           OHARCU = CMARCU;                      // AR Cust #
           OHTXID = CMTXID;                      // Tax ID #
           OHPHYT = CMPHYT;                      // Phyto Code
           OHALPH = CMLOOK;                      // Customer Alpha
           OHSHFR = *Blanks;                     // Ship From
           OHOLST = CMORLS;                      // Order Price List
           OHSACU = CMSACU;                      // SA Cust #
           OHBLCU = CMBLCU;                      // Billing Cust #

      *?   // From FMSVIA/FMCUST File
SUD07      If PHFRORID <> 'Ball Seed' and PHFRORID <> 'Kube Pak';
              Chain (PHFRORID:'Customer':PHSHPMTH) XREFSVIAL0;
              If %Found;
                 Select;
                    When SXRLCLKEY = 'FMCUST';
                       OHSHPC = CMSVCD;             // Ship Via Code
                    When SXRLCLKEY = '02';
                       WkSvia = SXRLCLKEY;
                       Chain WkSvia FMSVIA;
                       If %Found;
                          OHSHPC = SVCODE;       // Ship Via Code
                       Endif;
                 Endsl;
              Endif;
           Else;
              OHSHPC = CMSVCD;                   // Ship Via Code
           Endif;

      *?   // From FMTERM File
           Chain OHTMCD FMTERM;
           If %Found;
              OHTERM = TCDESC;                   // Terms
              OHTDAS = TCTDAS;                   // Terms Days
           Endif;

      *?   // Constant Values
           OHDTRY = RqThisMonCYMD;               // Req. Date CYMD
           OHORDY = TodayYMD7;                   // Order Date CYMD
           OHORDT = RqTodayMDY;                  // Original Req Date
           OHDTOR = TodayMDY;                    // Order Date(*MDY0)
           OHTDAT = TodayMDY;                    // Date Of Trans
           OHDTLA = TodayMDY;                    // Last Activity Date
           OHTIME = Now;                         // Time
           OHUSER = User;                        // User
           OHSPIN = *Blanks;                     // Special Instructions
           OHTRAT = *Zeros;                      // Cash Disc Percent
           OHTDAY = *Zeros;                      // Cash Discount Days
           OHSTA  = 'N';                         // Sub To Avail
           OHACK  = 'N';                         // Ord. Ack. Printed
           OHSLM1 = '01';                        // SalesPerson 1
           OHSCM1 = *Zeros;                      // Comm % 1
           OHSLM2 = *Blanks;                     // SalesPerson 2
           OHSCM2 = *Zeros;                      // Comm % 2
           OHFRT$ = *Zeros;                      // Freight Amt
           OHMER$ = *Zeros;                      // Merchnadise Amt
           OHDIS$ = *Zeros;                      // Discount Amt
           OHMIS$ = *Zeros;                      // Misc. Charge Amt
           OHTAX$ = *Zeros;                      // Tax Amount
           OHFET$ = *Zeros;                      // Fet Amount
           OHIOCD = 'N';                         // Invoice Only
           OHCOFL = 'N';                         // Closed Order Flag
           OHHOLD = 'N';                         // Hold Order Flag
           OHPLPT = *Blanks;                     // Pick List Printed P
           OHIVCD = 'N';                         // Invoiced Code
           OHPPCD = 'P';                         // Prepaid/Collect
           OHINV# = *Zeros;                      // Invoice Number
           OHINDT = *Zeros;                      // Invoice Date CYMD
           OHFRTX = 'N';                         // Tax Freight
           OHSPTX = 'N';                         // Tax Special Chargs
           OHROUT = *Blanks;                     // Route #
           OHSTOP = *Zeros;                      // Stop
           OHTBLK = *Zeros;                      // Total Bulk Pieces
           OHTBRK = *Zeros;                      // Total Broken Pieces
           OHDTAC = *Zeros;                      // Ship Date
           OHPLST = '000001';                    // Freight Code
           OHIMED = *Blanks;                     // Immed Print
           OHCASH = *Zeros;                      // Cash Application
           OHLOC  = *Blanks;                     // Order Location
           OHOORD = *Zeros;                      // Original Order #
           OHDISC = *Zeros;                      // C&C Or Sale Disc. %
           OHOPLP = *Blanks;                     // Order Proof Printed
           OHPOS  = *Blanks;                     // Invoice Type
           OHSALE = *Blanks;                     // Sale Type
           OHQTPR = 'N';                         // Quote Printed
           OHQUOT = *Blanks;                     // Quote Y Or Blank
           OHIMFG = 'N';                         // Immed Invoice Print

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteDetail Subroutine :
      *?            :------------------------:
      *
      *?Logic : Move values from corrsponding File Fields to Order Detail File
      *?      : Use Functions to get Date
      *?      : Used files - FMINVT, FMCUST , FMTAXF
      *
        Begsr WriteDetail;

      *?   // Clear Record
           Clear RIORDR;

      *?   // From FHORDR File
           OIORD# = OHORD#;                      // Order Number
           OIDTRQ = OHDTRQ;                      // Req Ship Date
           OIRVDT = RqThisMonCYMD;               // Req Ship Date CYMD
           OICUST = OHCUST;                      // Customer #
           OISLM1 = OHSLM1;                      // SalesPerson 1
           OISHPC = OHSHPC;                      // Ship Via

      *?   // Generate Sequence Number
           Setgt (OIORD#) FIORDR;
           ReadPE (OIORD#) FIORDR;
           If Not %Eof;
              OISEQ# += 2;
           Else;
              OISEQ# = 10;
           Endif;
           OISTAT = 'A';                         // Status


      *?   // From FMINVT File
      *?   // Cross reference file for Item
SUD07      If PHFRORID <> 'Kube Pak';
  |           Chain (PHFRORID:'Customer':PDBRKMAT) XREFINVTL0;
SUD07      Endif;
           Chain (IXRLCLITEM:IXRLCLSIZE) FMINVT;
           OIDES1 = IMDES1;                      // Description 1
           OIDES2 = *Blanks;                     // Comment
           OICOMP = IMCOMP;                      // Company #
           OIWHSE = IMWHSE;                      // Location
           OIBIN# = IMBIN#;                      // Bin #
           OIUUOM = IMPUOM;                      // Unit Of Measure
           OIMULT = IMMULT;                      // Mult 1
           OIUWGT = IMUWGT;                      // Unit Wgt
           OIQDDC = IMDIS1;                      // Qty Discount
           OIROY  = IMROYL;                      // Royalty Each
           OIBOCD = IMBOOK;                      // Item B/O Allowed
           OIPRCL = IMPCL1;                      // Prod Class 1
           OIUCST = IMUCST;                      // Unit Cost
           OIBPUM = IMBPUM;                      // Base Price Unit Of Measure
           OISUOM = IMSUOM;                      // Ship Uom
           OIBLUM = IMBPUM;                      // Bill Uom
           OIITMA = IMLOOK;                      // Item Alpha Search
           OIUPRI = $UnitPrice(IMITEM:IMSIZE:CMCUST);   // Unit Price

      *?   // From FMCUST File
           OITRDC = CMTRDC;                      // Trade Disc %
           OICTCD = CMCTCD;                      // Contract Price Code
           OISHFR = CMSHFR;                      // Ship From
           OIPHYT = CMPHYT;                      // Phyto Code
           OIALPH = CMLOOK;                      // Cust Alpha Search

      *?   // Constant Values
           OIDTLA = TodayMDY;                    // Last Activity Date
           OITIME = Now;                         // Time
           OIUSER = User;                        // User
           OIBORQ = *Zeros;                      // Orig B/O Req Ship Date
           OIORDT = RqTodayMDY;                  // Hold Orig Req Ship Date
           OIQSHP = *Zeros;                      // Qty Shipped
           OIQBOO = *Zeros;                      // Qty BackOrdered
           OIDISC = *Zeros;                      // Discount Amt
           OISHCD = *Blanks;                     // Ship Release Code
           OIOVER = 'N';                         // Override Code
           OICOM1 = *Zeros;                      // Commission 1
           OISLM2 = *Blanks;                     // Salesperson 2
           OICOM2 = *Zeros;                      // Commission 2
           OICOFL = 'N';                         // Closed Order Flag
           OIITYP = *Blanks;                     // Item Type
           OIQINV = *Zeros;                      // Invoice Qty Shipped
           OIPLPT = 'N';                         // Pick List Printed
           OIROUT = *Blanks;                     // Route Number
           OISTOP = *Zeros;                      // Stop
           OICWT  = *Zeros;                      // Catch Weight
           OILBS# = *Zeros;                      // Pounds
           OIWGSH = *Zeros;                      // Weight Shipped
           OIRSCD = *Blanks;                     // Reason
           OISEQP = *Zeros;                      // Primary Seq #
           OIPRAL = *Blanks;                     // Promo Allow
           OIMUL2 = *Zeros;                      // Mult 2
           OIOPFL = *Blanks;                     // Open Order Post Flag
           OIBOLN = *Blanks;                     // Line Item Put On BO
           OIPRBO = ' ';                         // Previous Backorder
           OISTA  = 'N';                         // Subj To Avail Flag
           OIINV# = *Zeros;                      // Invoice Number
           OITAGS = *Zeros;                      // # Tags
           OIPPDC = 'N';                         // Prompt Pay Dsc Y/N
           OISCHM = 'N';                         // Sched. To Move Flag
           OISCHS = 'N';                         // Sched. To Sow Flag
           OIQTAL = *Zeros;                      // Qty Allocated
           OIGLNO = *Zeros;                      // G/L # Spec Charges
           OISEDP = *Blanks;                     // Seed Ordered Y/N
           OIRVCD = RqTodayYMD7;                 // Expire Date   CYMD
           OIQTE  = *Blanks;                     // Quote Line Item
           OILOT# = *Blanks;                     // Lot Number
           OIFRQD = 'N';                         // Force Qty Disc Y/N
           OISPFL = *Blanks;                     // Summary Pickslip Flag Y/N
           OINPSL = *Blanks;                     // No Pickslip FutureRelease
           OIRQTY = *Zeros;                      // Pre Release Qty
           OIPOST = *Blanks;                     // Post Flag
           OICCDC = *Zeros;                      // C&C Or Sale Disc. %

SUD01      If WkFor = 1;
  |           OILIST = %Char(OISEQ#);
  |           WkList = %Char(OISEQ#);
  |        Elseif WkFor = 2;
  |           OILIST = WkList;                   // List Code (OISEQ# Future Ref
SUD01      Endif;

      *?   // From XREFINVTL0 File
           OIITEM = IXRLCLITEM;                  // Item Number
           OISIZE = IXRLCLSIZE;                  // Size

SUD06 *?   // Get Sow Date from GETGERM (CYMD)
  |        // OISOW  = 9999999;
SUD06      GETGERM(OIITEM:OISIZE:OIWHSE:OIRVDT:OISOW);

SUD08 *?   // Check Authorization for Item and Customer
VV02  * // If WkErFlag = 'N';

      *?   // Convert Quantity to KubePak Quantity
           WkOQty = *Zeros;
           Chain OISIZE FMSIZE;
           If %Found and SZSTAT = 'A';
SUD01         If WkPartQty <> *Zeros and WkFullQty <> *Zeros And WkFor = 1;
  |              If WkFullF = 'Y';
  |                 WkParInd = *Off;
  |                 WkOQty = WkFullQty;
  |              Elseif WkPartF = 'Y';
  |                 WkParInd = *On;
SUD01               WkOQty = WkPartQty;
SUD02            Else;
  |                 WkParInd = *Off;
SUD02               WkOQty = WkFullQty;
SUD01            Endif;
  |              Elseif WkPartQty <> *Zeros and WkFor = 1;
  |                 WkParInd = *On;
  |                 WkOQty = WkPartQty;
SUD01            Elseif WkFullQty <> *Zeros and WkFor = 1;
SUD02               If WKPrFlag = 'N';
  |                    WkParInd = *Off;
  |                    WkOQty = WkFullQty;
  |                 Else;
  |                 If WkFullF = 'Y';
  |                    WkParInd = *Off;
  |                    WkOQty = WkFullQty;
  |                 Else;
  |                    WkParInd = *On;
  |                    WkOQty = PDORDQTY;
  |                    WkPartQty = PDORDQTY;
  |                 Endif;
SUD02            Endif;
SUD01         Endif;
  |
  |           If WkFor = 2;
  |              If WkPrFlag = 'N';
  |                 WkParInd = *On;
  |                 WkOQty = WkPartQty;
  |              Else;
  |                 WkParInd = *On;
  |                 WkOQty = PDORDQTY;
  |                 WkPartQty = PDORDQTY;
  |              Endif;
SUD01         Endif;

      *?      // Get Available Quantity and Process
              WkQty = *Zeros;
SUD04         If WkOQTY <> *Zeros;
                 ALCLOTINV(OHORD#:OISEQ#:OHCUST:IXRLCLITEM:IXRLCLSIZE:
SUD01                      WkDte:WkOQTY:WkQty:WkLotC:WkParInd);
SUD04         Endif;
              OIQORD = WkQty;
              OHLOTC = WkLotC;        //WJB02
              OILOTC = WkLotC;        //WJB02

      *?      // Avlb qty is less than Req Qty Write infomsg into ErrExpPf
SUD01         If WkOQTY > WkQty And WkParInd = *Off;
                 If WkQty <> *Zeros;
                    WkDta = %Char(WkQty) + %Char(WkOQty);
                    WkMsgId = 'WS00025';
                 Else;
                    WkMsgId = 'WS00046';
                 Endif;
                 Exsr InfoSr;
              Endif;
      *
VV02  *?      // If Avlb qty is 0 Call INVAVLSTS pgm and write to FIORDRB2BC
VV02          If WkQty = 0;
VV02             Exsr CheckAvlSts;
VV02          Endif;
      *
VV02  *?      // If Avlb qty > 0 and < Ord Qty, write another comment to FIORDRB2BC
VV02          If WkQty > 0 and WkQty < WkOQTY;
VV02             ErrDesc = 'Full Qty not Avail for this Ship Wk';
VV02             Exsr WriteB2bErr;
VV02          Endif;
           Endif;
VV02  * // Endif;

VV02  *?SUD08// For Not Authorized Item and Customer
  |   *    If WkErFlag = 'Y';
  |   *       OISTAT = 'D';                       // Status for not Authorized Item
  |   *       OIQORD = *Zeros;
  |   *       OHLOTC = 'N';
  |   *       OILOTC = 'N';
VV02  *    Endif;

SUD01 *?   // Calculate Amount
  |        If WkFullQty <> *Zeros and WkFor = 1 and WkParInd = *Off;
  |           OIEXT$ = OIQORD * OIUPRI;             // Ext Amount
  |           OIOVER = 'N';
  |        Elseif WkPartQty <> *Zeros and WkFor = 1 and WkParInd = *On;
  |           Chain (OIORD#:OISEQ#) FIORDRPART;
  |           If %Found;
  |              WkPer  = OIPCTF;
  |           Endif;
  |           OIUPRI = (WkPer * OIUPRI) / 100;
  |           OIEXT$ = OIQORD * OIUPRI;             // Ext Amount
  |           OIOVER = 'Y';
  |        Elseif WkPartQty <> *Zeros and WkFor = 2;
  |           Chain (OIORD#:OISEQ#) FIORDRPART;
  |           If %Found;
  |              WkPer  = OIPCTF;
  |           Endif;
  |           OIUPRI = (WkPer * OIUPRI) / 100;
  |           OIEXT$ = OIQORD * OIUPRI;             // Ext Amount
SUD01         OIOVER = 'Y';
SUD04      Elseif WkPartQty = *Zeros and WkFullQty = *Zeros and
  |           WkParInd = *Off and WkFor = 1;
  |           OIEXT$ = OIQORD * OIUPRI;             // Ext Amount
SUD04         OIOVER = 'N';
SUD01      Endif;

      *?   // From FMTAXF File
           If CMTXST = 'N';
              Chain CMTXJU FMTAXF;
              If %Found and TXSTAT = 'A';
                 OIAMT1 = TXPCT1;                   // Tax Amt Rate 1
                 OIAMT2 = TXPCT2;                   // Tax Amt Rate 2
                 OIAMT3 = TXPCT3;                   // Tax Amt Rate 3
              Endif;
           Endif;

      *?   // Check Condition
           If OIAMT1 <> *Zeros and OIAMT2 <> *Zeros and OIAMT2 <> *Zeros;
              OITXCD = 'Y';                      // Tax Item Code 1
           Else;
              OITXCD = 'N';                      // Tax Item Code 1
           Endif;

           If OIAMT1 <> *Zeros;
              OITXST = 'Y';                      // Tax Item Code 2
           Else;
              OITXST = 'N';                      // Tax Item Code 2
           Endif;

           If OIAMT2 <> *Zeros;
              OITXCT = 'Y';                      // Tax Item Code 3
           Else;
              OITXCT = 'N';                      // Tax Item Code 3
           Endif;

           If OIAMT3 <> *Zeros;
              OITXLC = 'Y';                      // Tax Item Code 4
           Else;
              OITXLC = 'N';                      // Tax Item Code 4
           Endif;

      *?   // Tax Calculation
           Tax1  = OIAMT1 * OIUPRI;              // ST Tax on Item
           Tax2  = OIAMT2 * OIUPRI;              // CO Tax on Item
           Tax3  = OIAMT3 * OIUPRI;              // MU Tax on Item

      *?   // Tax Subroutine
           Exsr TotalTax;

      *?   // Write Record
           Write RIORDR;

      *?   // Write into Control file
           Exsr  WriteCntF;

      *?   // Write Comment Record if Available Quantity is Zero
           PDORDLIN = OISEQ#;                                    // Orderline Number
VV02  * SUD04 //If PDORDQTY <> *Zeros and WkErFlag = 'N';             // SUD08
VV02       If PDORDQTY <> *Zeros;                                // SUD08
              If OIQORD = *Zeros and WkParInd = *Off;
                 OISEQ# += 1;
                 OIITYP = 'C';
                 OIDES1 = %Trim(OIITEM) + ' ' + %Trim(OISIZE) +  ' Qty ' +
SUD01                     %Char(PDORDQTY) + ' Not Avail';
                 OIITEM = *Blanks;
                 OISIZE = *Blanks;
                 Write RIORDR;
               Endif;
SUD04      Endif;

SUD01 *?   // Write Comment Record if Partial Record found
  |        If WkParInd = *On and OIQORD <> *Zeros;
  |           WkPQty = (WkPer/100) * SZSALE;
  |           WkDis  = 100 - WkPer;
  |           OISEQ# += 1;
  |           OIITYP = 'C';
  |           OIQORD = *Zeros;
  |           OIDES1 = 'Adj: (' + %Trim(%Char(WkPQty)) + ' of ' +
  |                     %Trim(%Char(SZSALE)) + ') Disc: '  +
  |                     %Trim(%Char(WkDis)) +  '%';
  |           If WkPer <> *Zeros and WkDis <> *Zeros;
  |              Write RIORDR;
  |           Endif;
  |        Endif;
  |
  |   *?   // Update Flag in XML Order Detail File ("C" - Created)
SUD01      If WkFor = 1;
              PDFlag  = 'C';
              PDORDNO = OIORD#;                    // Order Number
              Exsr WSDtlAudit;
              Update WSPODTLR %Fields(PDFLAG:PDORDNO:PDORDLIN:PDUPDDAT:
                                    PDUPDTIM:PDUPDUSR:PDUPDJOB:PDUPDPGM);
SUD01      Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?            :---------------------:
      *?            : TotalTax Subroutine :
      *?            :---------------------:
      *
      *?Logic : Calculate Total tax for Header
      *?
        Begsr TotalTax;

      *?   // Calculate Total value for All items
           TotalTax01 = TotalTax01 + Tax1;       // ST Total Tax
           TotalTax02 = TotalTax02 + Tax2;       // CO Total Tax
           TotalTax03 = TotalTax03 + Tax3;       // MU Total Tax
           TotalOrder = TotalOrder + OIEXT$;     // Total Order Value

        Endsr;
      //--------------------------------------------------------------------
      *?            :---------------------:
      *?            : WritePPO Subroutine :
      *?            :---------------------:
      *
      *?Logic : Write a record into User information file
      *?
        Begsr WritePPO;

      *?   // Clear Record
           Clear RPPO;

      *?   // Move Values into Order User Information File
           POORD# = OHORD#;
           POTAKN = User;
           POENTR = User;
           POPICK = User;
           POPACK = User;

      *?   // Write Record
           Write  RPPO;

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?            :----------------------:
  |   *?            : PartialSr Subroutine :
  |   *?            :----------------------:
  |   *
  |   *?Logic : Write 2 records for Partial order
  |   *?
  |     Begsr PartialSr;
  |
  |   *?   // Calculate and write record
  |        WkParInd = *Off;
  |        For WKFor = 1 to X;
  |          If WkFor = 2;
  |             WkParInd = *On;
  |          Endif;
  |          Exsr WriteDetail;
  |        Endfor;
  |
SUD01   Endsr;
      //--------------------------------------------------------------------
      *?            :-------------------------:
      *?            : WriteOpenOrd Subroutine :
      *?            :-------------------------:
      *
      *?Logic : Write a record into Open order file
      *?
        Begsr WriteOpenOrd;

      *?   // Clear Record
           Clear ROPNORD;

      *?   // Move Values into Open Order File
           Chain(N) WkCust FMCUST;
           If %Found;
              OOORD# = OHORD#;
              OOCOMP = 1;
              OOCUST = CMCUST;
              OODTRY = ThisMonCYMD;
              OOORDY = TodayYMD7;
              OOARCU = CMARCU;
              OOSACU = CMSACU;
              OOBLCU = CMBLCU;
              OOSHFR = CMTERR;
              OOEXT$ = TotalOrder;
           Endif;

      *?   // Write Record
           Write  ROPNORD;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : InfoSR Subroutine :
      *?                :-------------------:
      *
      *?Logic : Retreive message from Message File (WSMSGF) and
      *?        Write into Error Exception File
      *?Used Program & File : WSRTVMSG : WSMSGF
      *
        Begsr InfoSR;

      *?   // Call CL program to Get Error Msg
           If WkMsgId <> 'WS00025';
             WkDta = *Blanks;
           Endif;

           Monitor;
             WkMsgf  = 'WSMSGF';
             RtvErrMsg(WkMsgID:WkMsgf:WKMsg:WkDta);
           On-Error;
           EndMon;

      *?   // Concat Ordered Qty with Msg
SUD04      If WkOQty <> *Zeros;
              If WkMsgId = 'WS00046';
                 WKMsg = %Trim(WKMsg) + ' ' + %Trim(%Char(WkOQty));
              Endif;
SUD04      Endif;

      *?   // Clear Record
           Clear WSERREXPR;

      *?   // Move Values into Fields
           ERBRKNAM = PHFRORID;                // BrokerName
           ERBRKORID= PHBRKORID;               // Broker Order ID
           ERRQSPDT = PHRQSHDT;                // Requested Ship Date
           ERPOSEQ  = PHSEQNO;                 // PO Sequence # Unique
           ERPODSEQ = PDSEQNO;                 // Detail Seq Number
           If WkFirst='Y';
              WkErSeq  = 1;                    // First Time Flag
              WkFirst  = 'N';                  // First Time Flag
           Else;
              WkErSeq  += 1;
           Endif;
           ERERRSEQ = WkErSeq;                 // Error Sequence Number
           ERRMSGID = WkMsgID;                 // Error Message ID
           ERRMSG   = WkMsg ;                  // Error Message
           ERFLAG   = 'I';                     // Flag
           ERBRKSLD = PHSLDNUM;                // Broker Sold To Customer
           ERBRKSHP = PHSHPNUM;                // Broker Ship to Customer
           ERCUSNUM = CMCUST;                  // KubePak Customer
           ERBRKMAT = PDBRKMAT;                // Broker Material #
           ERITMNUM = IMITEM;                  // Item
           ERITMSIZ = *Blanks;                 // Size
           ERQTYORD = WkOQTY;                  // Quantity Ordered
           ERORDNO  = *Zeros;                  // Order Number

      *?   // Execute Audit Stamp
           Exsr WSErrAudit;

      *?   // Write Error Record
           Write WSERREXPR;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : WriteCntF Subroutine :
      *?            :----------------------:
      *
      *?Logic : Write a record into Order Change Control File
      *?
        Begsr WriteCntF;

      *?   // Clear Record
           Clear WSORCHCR;

      *?   // Move Values into Open Order File
           OCFRORID  = PHFRORID;
           OCBRKORID = PHBRKORID;
           OCPOSEQ   = PHSEQNO;
           OCBRKSLD  = PHSLDNUM;
           OCBRKSHP  = PHSHPNUM;
           OCCUST    = CMCUST;
           OCORDNO   = OIORD#;
           OCORDLIN  = OISEQ#;
           OCBRKLNE  = PDBRKLNE;
           OCBRKMAT  = PDBRKMAT;
           OCITEM    = OIITEM;
           OCIMSZE   = OISIZE;
           OCORFLG   = 'Y';
           OCORMSGID = *Blanks;
           OCORMSGD  = *Blanks;

      *?   // Audit Stamp
           OCCRTDAT = Rundate;
           OCCRTTIM = Runtime;
           OCCRTUSR = User;
           OCCRTJOB = Job;
           OCCRTPGM = Pgm;

      *?   // Write Record
           Write WSORCHCR;

        Endsr;
SUD05 //--------------------------------------------------------------------
  |   *?                :---------------------------:
  |   *?                : UpdateDetailSr Subroutine :
  |   *?                :---------------------------:
  |   *
  |   *?Logic : Update Detail File for the Detail Line
  |   *?
  |     Begsr UpdateDetailSr;
  |
  |   *?   // Update Record in WSPODTLPF
  |        If EFlag  = 'Y';
  |           WkFlag = 'Y';
  |           PDFlag = 'E';
  |           PHFlag = 'E';
  |        Endif;
  |
  |        If WkUFlag = 'Y';
  |           PDFLAG  = 'U';
  |        Endif;
  |
  |        PDORDNO = *Zeros;
  |        PDORDLIN= *Zeros;
  |        Exsr WSDtlAudit;
  |        Update WSPODTLR %Fields(PDFLAG:PDORDNO:PDORDLIN:PDUPDDAT:
  |                                PDUPDTIM:PDUPDUSR:PDUPDJOB:PDUPDPGM);
  |
SUD05   Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : WSHdrAudit Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Move values into Audit Fields
      *?
        Begsr WSHdrAudit;

      *?   // Audit Stamp
           PHUPDDAT = Rundate;
           PHUPDTIM = Runtime;
           PHUPDUSR = User;
           PHUPDJOB = Job;
           PHUPDPGM = Pgm;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : WSDtlAudit Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Move values into Audit Fields
      *?
        Begsr WSDtlAudit;

      *?   // Audit Stamp
           PDUPDDAT = Rundate;
           PDUPDTIM = Runtime;
           PDUPDUSR = User;
           PDUPDJOB = Job;
           PDUPDPGM = Pgm;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : WSErrAudit Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Move values into Audit Fields
      *?
        Begsr WSErrAudit;

      *?   // Audit Stamp
           ERCRTDAT = Rundate;
           ERCRTTIM = Runtime;
           ERCRTUSR = User;
           ERCRTJOB = Job;
           ERCRTPGM = Pgm;

        Endsr;
      //-------------------------------------------------------------------
      *?            :-------------------------:
      *?            : AfterOrder Subprocedure :
      *?            :-------------------------:

       Dcl-Proc AfterOrder;

       /Include QFunctFree,$PrintPick
       /Include QFunctFree,$Comment

       Dcl-S isReadyBay ind inz(*off);
       Dcl-S isTruck    ind inz(*off);
       Dcl-S RBSHIPVIACODE char(2);
       Dcl-S #PRTPICK01 char(10);
       Dcl-S #PRTPICK02 char(10);
       Dcl-S #PRTBILL char(10);

      *?  // Reset Order Date if ordering material from previous date
          Exec SQL
             UPDATE FHORDR as ord
             SET  ord.OHORDY =  ord.OHDTRY
             ,    ord.OHDTOR = (Select CLDATE
                                  from FCALEN
                                 where CLCYMD = ord.OHDTRY)
             WHERE  ord.OHORDY >  ord.OHDTRY
             and  ord.OHORD# = :OHORD#;

           Reset isReadyBay;

      *?  // Determine if order is ready bay
          Exec SQL
             SELECT  '1'
             INTO   :isReadyBay
             FROM    FALITEM
             WHERE   AIGLOC = 'R'
             and   AIORD# = :OHORD#
             Fetch first row only;

         If isReadyBay;

            If OHSHPC = '01';
               isTruck = *On;
            Endif;

      *?    // Do not allow changes to RB orders
            Exec SQL
               INSERT INTO WSORCHCPF   (
               SELECT
               OCFRORID,
               OCBRKORID,
               0 as OCPOSEQ,
               OCBRKSLD,
               OCBRKSHP,
               OCCUST,
               OCORDNO,
               0 as OCORDLIN,
               0 as OCBRKLNE,
               ' ' as OCBRKMAT,
               ' ' as OCITEM,
               ' ' as OCIMSZE,
               'N' as OCORFLG,
               'WS00052' as OCORMSGID,
               'Ready Bay Orders are not eligible for change.' as OCORMSGD,
               OCCRTDAT,
               OCCRTTIM,
               OCCRTUSR,
               OCCRTJOB,
               OCCRTPGM,
               OCUPDDAT,
               OCUPDTIM,
               OCUPDUSR,
               OCUPDJOB,
               OCUPDPGM

               FROM WSORCHCPF

               WHERE OCORDNO = :OHORD#
               and OCORDNO not in (SELECT OCORDNO
                                   FROM   WSORCHCPF
                                   WHERE  OCORDNO = :OHORD#
                                     and  OCPOSEQ = 0)
               Fetch First Row Only );

      *?    // Change ALL RB lines to Change Eligible = 'N'
            Exec SQL
               UPDATE WSORCHCPF
               SET OCORFLG = 'N'
               WHERE OCORDNO = :OHORD#;

               RBSHIPVIACODE = OHSHPC;

      *?    // Get RB SVIA Code
            Exec SQL
               SELECT READYBAYSHIPVIACODE
               INTO :RBSHIPVIACODE
               FROM frbsvia
               WHERE ORIGINALSHIPVIACODE = :OHSHPC
               Fetch First Row Only;

      *?    // Update SVIA on Order Header
            Exec SQL
                UPDATE FHORDR
                SET    OHSHPC = :RBSHIPVIACODE
                ,    OHPRCD = 5
                WHERE OHORD# = :OHORD#;

      *?    // Update SVIA, Unit Price, Extended Price and Override Code
            Exec SQL
               UPDATE FIORDR as det
               SET    det.OISHPC = :RBSHIPVIACODE
               ,      det.OIUPRI = COALESCE (
                                 (SELECT  item1.IMSEL5
                                    FROM  FMINVT as item1
                                   WHERE  item1.IMITEM = det.OIITEM
                                     and  item1.IMSIZE = det.OISIZE),0)
               ,      det.OIEXT$ = det.OIQORD *
                                COALESCE (
                                 (SELECT  item2.IMSEL5
                                    FROM  FMINVT as item2
                                   WHERE  item2.IMITEM = det.OIITEM
                                     and  item2.IMSIZE = det.OISIZE),0)
               ,      det.OIOVER = '5'
               WHERE  det.OIORD# = :OHORD#;


      *?    // Unit Price, Extended Price for Partials
            Exec SQL
               Update FIORDR as detls
               Set (detls.OIUPRI, detls.OIEXT$, detls.OIOVER) =
               ( Select coalesce (cast(parts.OIPCTF / 100 as numeric(5,3)),1)
                           * items.IMSEL5
                       , coalesce (cast(parts.OIPCTF / 100 as numeric(5,3)),1)
                           * items.IMSEL5 * detls.OIQORD
                       , 'Y'
                    from FMINVT as items
                         left outer join FIORDRPART as parts
                                     on  parts.OIITEM = items.IMITEM
                                    and  parts.OISIZE = items.IMSIZE
                   where  parts.OIORD# = detls.OIORD#
                     and  parts.OISIZE = detls.OISIZE
                     and  parts.OIORD# = detls.OIORD#
                     and  parts.OISEQ# = detls.OISEQ#)
               Where    detls.OIORD# = :OHORD#
               and    detls.OIITYP = ' '
               and    detls.OISTAT = 'A'
               and    detls.OIORD#||detls.OISEQ#||detls.OIITEM||detls.OISIZE in
               (select partl.OIORD#||partl.OISEQ#||partl.OIITEM||partl.OISIZE
               from FIORDRPART as partl);

               #PRTPICK01 = 'DONTPRINT';
               #PRTPICK02 = 'DONTPRINT';

      *?    // Get RBOUTQ Printer Name
            Exec SQL
               SELECT  DPPRTR
               INTO :#PRTPICK01
               FROM  DFTPRTPF
               WHERE  DPTYPE = 'P' and DPNAME = 'RBOUTQ'
               Fetch First Row Only ;

      *?    // Get Pick Printer #2
            Exec SQL
               SELECT  DPPRTR
               INTO :#PRTPICK02
               FROM  DFTPRTPF
               WHERE  DPTYPE = 'P' and DPNAME = '#PRTPICK02'
               Fetch First Row Only ;

            $Comment(OHORD#);

            $PrintPick(OHORD#:#PRTPICK01:'002':'*YES');
            $PrintPick(OHORD#:#PRTPICK02:'001':'*YES');

            If isTruck;
               #PRTBILL = 'DONTPRINT';

      *?       // Get Bill S. Printer
               Exec SQL
                  SELECT  DPPRTR
                  INTO :#PRTBILL
                  FROM  DFTPRTPF
                  WHERE  DPTYPE = 'U' and DPNAME = 'BILL'
                  Fetch First Row Only ;
               $PrintPick(OHORD#:#PRTBILL:'001':'*YES');
            Endif;                                      // If isTruck
         Endif;                                         // If isReadyBay

       End-Proc;
      *?-------------------------- End of Program -----------------------------------------
