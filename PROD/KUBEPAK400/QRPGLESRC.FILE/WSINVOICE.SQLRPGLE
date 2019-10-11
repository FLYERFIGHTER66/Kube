      *? Program        : WSINVOICE
      *?
      *? Description    : This program is to Generate Invoice XML
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 02 Nov 2017
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * WJB01   03/06/18   W.J.Behr     Handle Zero Date in Invoice Detail (eg. Freight)
      * WJB02   07/31/18   W.J.Behr     Moved ScheduledShipDate attribute inside <Item> tag
      * VV02    08/09/18   Vimala V     Ship Via Cross Reference from XREFSVIO file
      *                                 Store generated Invoice in IFS folder
      * VV03    08/20/18   Vimala V     Send all lines from FIORDR even if Qty=0
      *                                 that matches with Order Xml files
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
           ActGrp ('HTTP') BndDir('QC2LE');
      *
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Invoice Header File
      *?Key : Invoice #
        Dcl-F FHORDW   Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Invoice Detail File
      *?Key : Invoice # : Invoice Seq #
        Dcl-F FIORDW   Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Order Detail Partial Item Records
      *?Key : Order # : Order Seq #
        Dcl-F FIORDRPART Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Size Code Master File
      *?Key : Size Code
        Dcl-F FMSIZE Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number : Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Update:*Input);
      *
VV02  *?File: WS - Xml Order Create Header Logical File
  |   *?Key : FromOrgId:OrderNumber
VV02    Dcl-F WSPOHDRL3 Disk(*Ext) Keyed Usage(*Input);
      *
VV02  *?File: WS - Xml Order Create Detail Logical File
  |   *?Key : FromOrgId:OrderNumber:OrderLineNumber
VV02    Dcl-F WSPODTLL2 Disk(*Ext) Keyed Usage(*Input);
      *
VV02  *?File: WS - Xml Order Change Header Logical File
  |   *?Key : FromOrgId:OrderNumber
VV02    Dcl-F WSCOHDRL3 Disk(*Ext) Keyed Usage(*Input);
      *
VV02  *?File: WS - Xml Order Change Header Logical File
  |   *?Key : FromOrgId:OrderNumber:OrderLineNumber
VV02    Dcl-F WSCODTLL2 Disk(*Ext) Keyed Usage(*Input);
      *
VV02  *?File: Ship Via Cross Reference for Outbound
  |   *?Key : ProvidedbyName:Type:Local Key
VV02    Dcl-F XREFSVIOL0 Disk(*Ext) Keyed Usage(*Input);
      *
VV02  *?File: Item Cross Reference
  |   *?Key : ProvidedbyName:Type:Foreign Key
VV02    Dcl-F XREFINVTL1 Disk(*Ext) Keyed Usage(*Input);
      *
VV03  *?File: WS - XML Order Change Control Logical File
  |   *?Key : OrderNumber:OrderLineNo:BrokerLineNo
VV03    Dcl-F WSORCHCL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSINVOICE ;
           PInvNum       Like(WHINV#);
           HttpStatus    Int(10:0);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Call Pgm to POST XML
        Dcl-Pr WSPOSTXML ExtPgm('WSPOSTXML');
           PInvXml      Char(1000000) Options(*Varsize);
           PFromOrgId   Char(30)   Options(*Varsize);
           PFlag        Char(1);
           HttpStatus   Int(10:0);
        End-Pr;
      *
      *?Procedure Interface Declaration : Pgm to Call Command
VV02    Dcl-Pr QCMDEXC Extpgm;
  |        Cmd Char(200)    Const Options(*Varsize);
  |        Len Packed(15:5) Const;
VV02    End-Pr;
      *
      *?Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname      Char(50)    Value;
           Tagval       Char(300)   Value;
           Info         Char(10)    Value;
        End-Pr;
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
      *?Global Variable Declaration :
        Dcl-S PInvXml    Char(1000000) Inz;
        Dcl-S Xml        Char(1000000) Inz;
        Dcl-S Info       Char(10)      Inz;
        Dcl-S Cmd        Char(200)     Inz;
        Dcl-S XmlIfs     Char(300)     Inz;
        Dcl-S WkDtTm     Char(19)      Inz;
        Dcl-S WkRefId    Char(32)      Inz;
        Dcl-S WkRefNo    Zoned(6)      Inz;
        Dcl-S WkDate     Date(*ISO)    Inz;
        Dcl-S WkScDt     Char(19)      Inz;
        Dcl-S WkInDt     Char(19)      Inz;
        Dcl-S WkRqDt     Char(19)      Inz;
        Dcl-S WkDtAc     Char(19)      Inz;
        Dcl-S WkQty      Zoned(11:1)   Inz;
VV03    Dcl-S WkQty1     Zoned(11)     Inz;
        Dcl-S WkItem     Char(25)      Inz;
        Dcl-S WkCustRef  Char(12)      Inz;
        Dcl-S WkShipNo   Char(20)      Inz;
        Dcl-S WkBrkLne   Char(6)       Inz;
        Dcl-S WkOrdQty   Packed(13:1)  Inz;
VV02    Dcl-S WkPath     Char(75)      Inz;
VV02    Dcl-S WkFile     Char(75)      Inz;
      *
      *?Parameter Variable Declaration :
      * Parameter Variable Declaration :
        Dcl-S PFlag      Char(1);
        Dcl-S PFromOrgId Char(30);
      *
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

           Exsr InzPgm;
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
        Begsr InzPgm;

      *?   // Add HTTP Library in Library List
           Monitor;
              Cmd = 'ADDLIBLE LIB(LIBHTTP) POSITION(*Last)';
              Exsr CallCmd;
              On-Error;
           EndMon;

      *?   // Clear XML
           Clear PInvXml;

      *?   // Get Date and Time
           WkDtTm = %Char(%Date) + 'T' + %Char(%Time());

VV02  *    // Create IFSXML temp file in QTEMP
  |        Cmd = 'CRTPF FILE(QTEMP/IFSXML) RCDLEN(300) SIZE(*NOMAX)';
  |        Exsr CallCmd;
  |
  |   *    // Insert XML Header into Flat File
  |        XmlIfs = '<?xml version="1.0" encoding="utf-8" ?>';
  |        Exec Sql
  |        INSERT INTO IFSXML Values(:XmlIfs);
VV02       XmlIfs = *Blanks;

      *?   // Read Invoice Header to get Billing Customer
      *?   // Send Invoice XML only if Ball or Griffin Broker
           Chain PInvNum FHORDW;
           If %Found;
              If WHBLCU =1533 or WHBLCU = 2386;

      *?         // Excute Process
                 Exsr Process;
      *?         // Store XML into IFS
                 Exsr StoreIfs;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Clear Flat File
           Cmd  = 'CLRPFM FILE(QTEMP/IFSXML)';
           Exsr CallCmd;

      *?   // Return
           *InLr = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
        Begsr Process;

      *?   // Start Tag
           AddToXml('BrokerInvoice' : *Blanks : 'Starttag');

      *?   // XML Body
           Exsr IdentificationSR;
           Exsr InvoiceHeaderSR;
           Exsr InvoiceDetailsSR;
           Exsr InvoiceFooterSR;

      *?   // End Tag
           AddToXml('BrokerInvoice' : *Blanks : 'Endtag');


      *?   // Post XML to Client Site
           PInvXml = Xml;
           PFlag = 'I';
           WSPOSTXML(PInvXml:PFromOrgId:PFlag:HttpStatus);

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : IdentificationSR Subroutine :
      *?                :-----------------------------:
      *
        Begsr IdentificationSR;

      *?   // Move values into Identification Part
      *?   // Generate Unique Reference ID
           Chain ('1000':'Unique Reference ID') FBrokDftL0;
           If %Found;
              WkRefNo = %Int(DFVARVAL);
              WkRefId = %Char(%Date) + ':' + %Char(%Time()) + ':' +
                                             %Char((DFVARVAL));
              If WkRefNo = 999999;
                 WkRefNo = 000001;
              Else;
                 WkRefNo  += 1;
              Endif;
                 DFVARVAL = %Editc(WkRefNo:'X');
                 Update RBROKDFT %Fields(DFVARVAL);
           Endif;

           AddToXml('Identification' : *Blanks  : 'Opentag');
           AddToXml('Reference_ID' :  WkRefId  : 'Attribute');
           AddToXml('MessageProtocol_ID' : 'KubePakInvoice'  : 'Attribute');

      *?   // Move values into FromOrgId/SenderOrg_ID from Parameter File
           Chain(N) (%Char(WHBLCU):'FromOrgId') FBrokDftL0;
           If %Found;
              AddToXml('FromOrg_ID' : %Trim(DFVARVAL):'Attribute');
              AddToXml('SenderOrg_ID' : %Trim(DFVARVAL): 'Attribute');
           Endif;

           Chain(N) (%Char(WHBLCU):'ToOrgId') FBrokDftL0;
           If %Found;
              AddToXml('ToOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
              PFromOrgId = %Trim(DFVARVAL);
           Endif;

           AddToXml('Date' :  WkDtTm  : 'Closetag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :----------------------------:
      *?                : InvoiceHeaderSR Subroutine :
      *?                :----------------------------:
      *
        Begsr InvoiceHeaderSR;

      *?   // Check if order found in PO xml file or CO xml file to get values
           Chain (PFromOrgId:WHORD#) WSCOHDRL3;
           If %Found();
              WkCustRef = PHCUSTREF;
              WkShipNo  = %Char(PHSHPNUM);
           Else;
              Chain (PFromOrgId:WHORD#) WSPOHDRL3;
              If %Found();
                 WkCustRef = CHCUSTREF;
                 WkShipNo  = %Char(CHSHPNUM);
           Endif;
           Endif;

      *?   // Move values into InvoiceHeader Part
           AddToXml('InvoiceHeader' : *Blanks : 'Opentag');

      *?   // Move values for Griffin Header Part
VV02       If WHBLCU = 2386;
              AddToXml('VendorOrderID' : %Char(WHORD#) : 'Attribute');
              AddToXml('VendorInvoiceID': %Char(WHINV#) :'Attribute');
              AddToXml('TermCode' : WHTMCD : 'Attribute');
              AddToXml('BrokerOrderID' : WHPONO : 'Attribute');
              WkDate = %Date(WHINDT:*mdy);
              WkInDt = %Char(WkDate);
              AddToXml('BrokerInvoiceDate' : WkInDT : 'Attribute');
              AddToXml('BrokerCreatedDate' : WkInDT  : 'Attribute');
              AddToXml('CurrencyCode' : 'USD' : 'Attribute');
              WkDate = %Date(WHDTRQ:*mdy);
              WkRqDt = %Char(WkDate);
              AddToXml('RequestedShipDate' : WkRqDt :'Attribute');
              WkDate = %Date(WHDTAC:*cymd);
              WkDtAc = %Char(WkDate);
              AddToXml('ActualShipDate' : %Char(WkDtAc) : 'Attribute');

VV02  *?   // Get Ship Method from XREFSVIO file
 |            Chain (PFromOrgId :'Customer' : WHSHPC) XREFSVIOL0;
 |            If %Found;
 |               AddToXml('ShipMethod' : XRFORKEY : 'Attribute');
VV02          Endif;

              AddToXml('InvoiceType' : 'Invoice' : 'Attribute');
              AddToXml('VendorNumber' : *Blanks : 'Closetag');
VV02       Endif;                                                          //Griffin Close


      *?   // Move values for BallSeed Header Part
VV02       If WHBLCU = 1533;
              AddToXml('VendorOrderID' : %Char(WHORD#) : 'Attribute');
              AddToXml('VendorInvoiceID': %Char(WHINV#) :'Attribute');
              AddToXml('TermCode' : WHTMCD : 'Attribute');
              AddToXml('BrokerOrderID' : WHPONO : 'Attribute');
              WkDate = %Date(WHINDT:*mdy);
              WkInDt = %Char(WkDate) + 'T' + ('00:00:00');
              AddToXml('BrokerInvoiceDate' : WkInDT : 'Attribute');
              AddToXml('BrokerCreatedDate' : *Blanks : 'Attribute');
              AddToXml('CurrencyCode' : 'USD' : 'Attribute');
              WkDate = %Date(WHDTRQ:*mdy);
              WkRqDt = %Char(WkDate) + 'T' + ('00:00:00');
              AddToXml('RequestedShipDate' : WkRqDt :'Attribute');
              WkDate = %Date(WHDTAC:*cymd);
              WkDtAc = %Char(WkDate) + 'T' + ('00:00:00');
              AddToXml('ActualShipDate' : %Char(WkDtAc) : 'Attribute');

VV02  *?   // Get Ship Method from XREFSVIO file
 |            Chain (PFromOrgId :'Customer' : WHSHPC) XREFSVIOL0;
 |            If %Found;
 |               AddToXml('ShipMethod' : XRFORKEY : 'Attribute');
 |               AddToXml('ShippingMethodDesc' : XRDESC : 'Attribute');
VV02          Endif;

              AddToXml('InvoiceType' : 'IN' : 'Attribute');
              AddToXml('VendorNumber' : *Blanks : 'Attribute');
              AddToXml('CustomerPONumber' : WkCustRef : 'Attribute');
              AddToXml('FreightPaymentMethod' : *Blanks : 'Attribute');
              AddToXml('HeaderComments' : *Blanks : 'Attribute');
              AddToXml('BrokerDeliveryID' : *Blanks : 'Attribute');
              AddToXml('Consolidated' : '0' : 'Close');

              Exsr SoldToSR;
              Exsr ShipToSR;

      *?   // Move Tracking Number only for Ball Seed
              Exsr TrackingNumberSR;
              AddToXml('InvoiceHeader' : *Blanks : 'Endtag');
 VV02      Endif;                                                       //Ball Seed Close

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : SoldTo Subroutine :
      *?                :-------------------:
      *
        Begsr SoldToSR;

      *?   // Move values into SoldTo tags from Order File
           AddToXml('SoldTo' : *Blanks : 'Opentag');
           AddToXml('SoldToName' : WHSLD1 : 'Attribute');
           AddToXml('SoldToContactName' : WHSLD1 : 'Attribute');
           AddToXml('SoldToAddress1' : WHSLD2 : 'Attribute');
           AddToXml('SoldToAddress2' : WHSLD3 : 'Attribute');
           AddToXml('SoldToState' : WHSLST : 'Attribute');
           AddToXml('SoldToCity' : WHSLCT : 'Attribute');
           AddToXml('SoldToZip' : WHSLZP : 'Attribute');
           AddToXml('SoldToPhone' : *Blanks : 'Attribute');
           AddToXml('SoldToEmail' : *Blanks : 'Closetag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : ShipTo Subroutine :
      *?                :-------------------:
      *
        Begsr ShipToSR;

      *?   // Move values into ShipTo tags from Invoice Header File
           AddToXml('ShipTo' : *Blanks : 'Opentag');
           AddToXml('ShipToName' : WHNAME : 'Attribute');
           AddToXml('ShipToContactName': WHNAME : 'Attribute');
           AddToXml('ShipToAddress1' : WHSHP2 : 'Attribute');
           AddToXml('ShipToAddress2' : WHSHP3 : 'Attribute');
           AddToXml('ShipToState' : WHSHST : 'Attribute');
           AddToXml('ShipToCity' : WHSHCT : 'Attribute');
           AddToXml('ShipToCountry ' : *Blanks : 'Attribute');
           AddToXml('ShipToZip' : WHSLZP : 'Attribute');
           AddToXml('ShipToFax' : *Blanks : 'Attribute');
           AddToXml('ShipToPhone' : *Blanks : 'Attribute');
           AddToXml('ShipToEmail' : *Blanks : 'Attribute');
           AddToXml('BrokerShipToNumber' : WKShipNo : 'Closetag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Tracking Number   :
      *?                :-------------------:
      *
        Begsr TrackingNumberSR;

      *?   // Move values into Tracking Number Tags from Invoice Header File
           AddToXml('TrackingNumbers' : *Blanks : 'Starttag');
           AddToXml('TrackingNumber' : *Blanks : 'Opentag');
           AddToXml('TrackingNumber' : *Blanks : 'Closetag');
           AddToXml('TrackingNumbers' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : InvoiceDetailsSR Subroutine :
      *?                :-----------------------------:
      *
        Begsr InvoiceDetailsSR;

      *?   // Move values into Detail tags
           AddToXml('InvoiceDetails' : *Blanks : 'Starttag');

      *?   // Move values into Detail tags from Invoice Detail File
      *?   // Execute Item Part
           Exsr ItemSR;
           AddToXml('InvoiceDetails' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : ItemSR Subroutine :
      *?                :-------------------:
      *
        Begsr ItemSR;

      *?   // Read Invoice Detail file to build xml
           Setll (WHINV#) FIORDW;
           ReadE (WHINV#) FIORDW;

           Dow Not %Eof;
VV03        //If WIITYP <> 'C' and WIITYP <> 'F';

VV03         If WIITYP <> 'F';

      *?        // Check in Order control file to send records even if Qty=0
VV03            Chain (WHORD#:WISEQP) WSORCHCL0;
VV03            If %Found();
VV03               WkBrKLne = %Char(OCBRKLNE);

      *?     // Check if order found in PO xml file or CO xml file to get values
                  Chain (PFromOrgId:WHORD#:WISEQP) WSCODTLL2;
                  If %Found();
VV03               //WkBrKLne = %Char(CDBRKLNE);
                     WkOrdQty  = CDORDQTY;
                  Else;
                  Chain (PFromOrgId:WHORD#:WISEQP) WSPODTLL2;
                  If %Found();
VV03               //WkBrKLne = %Char(PDBRKLNE);
                     WkOrdQty  = PDORDQTY;
                  Endif;
                  Endif;

                  If WIDTRQ <> 0;                        //WJB01  If detail date is zero...
                     WkDate = %Date(WIDTRQ:*mdy);
                  Else;                                 //WJB01  ...use header date instead.
                     WkDate = %Date(WHDTRQ:*mdy);         //WJB01
                  EndIf;                                 //WJB01

      *?     // Move values into Item tags from Invoice/XML Order Files
                  AddToXml('Item': *Blanks : 'Opentag');

      *?     // Move Item Detail values for Griffin
VV02              If WHBLCU = 2386;
  |   *?            // Read cross reference to get BrokerMaterialID
  |                  WkItem = (%Trim(WIITEM) + %Trim(WISIZE));
  |                 Chain (PFromOrgId : 'Customer' :WkItem) XREFINVTL1;
  |                 If %found;
  |                    AddToXml('BrokerMaterialNumber' : XRFORKEY
  |                                                     : 'Attribute');
  |                    AddToXml('MaterialDescription' : XRDESC : 'Attribute');
VV02                Endif;
                    AddToXml('BrokerLineItemNumber' : WkBrkLne :'Attribute');
                    AddToXml('VendorMaterialNumber' : XRLCLKEY : 'Attribute');
                    AddToXml('LineItemPrice' : %Char(WIUPRI) : 'Attribute');
                    WkScDt = %Char(WkDate);
                    AddToXml('ScheduledShipDate' : WkScDt: 'Attribute');  // WJB02
      *?          // Send Quantity Shipped in Broker Quantity
                    WkQty = *Zeros;
                    Chain (WISIZE) FMSIZE;
                    If %found and SZSTAT = 'A';
                       WkQty = WIQSHP * SZSALE;
                    Endif;

VV03                //AddToXml('Shp_Qty' : %Char(WkQty) : 'Attribute');
      *?     // Move Qty without decimals for Griffin
VV03                If WkQty = *Zeros;
VV03                   AddToXml('Shp_Qty' : '0' : 'Attribute');
VV03                Else;
VV03                   WkQty1 = WkQty;
VV03                   AddToXml('Shp_Qty' : %Char(WkQty1) : 'Attribute');
VV03                Endif;
                    AddToXml('Shp_QtyUOM' : 'EA' : 'Closetag');
                  Endif;                                                    //Griffin close

      *?     // Move Item Detail values for BallSeed
VV02              If WHBLCU = 1533;
                     AddToXml('BrokerLineItemNumber' : WkBrkLne :'Attribute');
                     AddToXml('LineItemPrice' : %Char(WIUPRI) : 'Attribute');
                     AddToXml('LineItemTotalPrice' : %Char(WIAMT)
                                                   : 'Attribute');
                     AddToXml('MaterialDescription' : WIDES1 : 'Attribute');
                     AddToXml('LineItemStatus' : *Blanks : 'Attribute');
                     AddToXml('OrderdQtyUOM' : WIUUOM : 'Attribute');
                     AddToXml('RejectionCode' : 'N' : 'Attribute');
                     WkScDt = %Char(WkDate);
                     AddToXml('ScheduledShipDate' : WkScDt: 'Attribute');

      *?     // Send Quantity Ordered in Broker Quantity
                //WkQty = *Zeros;
                //Chain (WIORD#:WISEQP) FIORDRPART;
                //If %found;
                //    WkQty = (WkOrdQty * OIPCTF) / 100;
                //Else;
                //  Chain (WISIZE) FMSIZE;
                //  If %found;
                //     WkQty = WkOrdQty * SZSALE;
                //  Endif;
                //Endif;

                     AddToXml('OrderdQty' : %Char(WkOrdQty) : 'Attribute');

      *?          // Send Quantity Shipped in Broker Quantity
                     WkQty = *Zeros;
                     Chain (WISIZE) FMSIZE;
                     If %found and SZSTAT = 'A';
                        WkQty = WIQSHP * SZSALE;
                     Endif;

                     AddToXml('Shp_Qty' : %Char(WkQty) : 'Attribute');
                     AddToXml('Shp_QtyUoM' : 'EA' : 'Attribute');
                     AddToXml('BrokerDeliveryID' : *Blanks : 'Attribute');
                     AddToXml('VendorMaterialNumber' : XRLCLKEY : 'Closetag');
VV02              Endif;                                                       //BallSeed Close
      *
VV03            Endif;                                                      //Chain WSORCHCL0
             Endif;                                                         //WIITYP <> F
           ReadE (WHINV#) FIORDW;
           Enddo;

        EndSr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : Invoice Footer Subroutine :
      *?                :---------------------------:
      *
        Begsr InvoiceFooterSR;

           AddToXml('InvoiceFooter': *Blanks : 'Opentag');

      *?   // Move values into Invoice Footer tags for Ball Seed
VV02       If WHBLCU = 2386;
              AddToXml('Discount' : %Char(WHDIS$):'Attribute');
              AddToXml('FreightCharge' : %Char(WHFRT$) : 'Attribute');
              AddToXml('RoyaltyCharge' : *Blanks : 'Attribute');
              AddToXml('TagCharge' : *Blanks : 'Attribute');
              AddToXml('OrderTotal' : %Char(WH$AMT) : 'Closetag');
VV02       Endif;                                                    //Griffin Close

      *?   // Move values into Invoice Footer tags for Ball Seed
VV02       If WHBLCU = 1533;
              AddToXml('OrderSales' : *Blanks : 'Attribute');
              AddToXml('Discount' : %Char(WHDIS$):'Attribute');
              AddToXml('DiscountPercent' : %Char(WHTRDC) : 'Attribute');
              AddToXml('Units' : *Blanks : 'Attribute');
              AddToXml('Racks' : *Blanks : 'Attribute');
              AddToXml('OrderWeight' : *Blanks : 'Attribute');
              AddToXml('OrderWeightUOM' : *Blanks : 'Attribute');
              AddToXml('FreightPer' : %Char(WHFRT$) : 'Attribute');
              AddToXml('FreightPerType' : 'N' : 'Attribute');
              AddToXml('FreightCharge' : %Char(WHFRT$) : 'Attribute');
              AddToXml('FreightChargeAlt' : *Blanks : 'Attribute');
              AddToXml('Misc' : %Char(WHMIS$) : 'Attribute');
              AddToXml('RoyaltyCharge' : *Blanks : 'Attribute');
              AddToXml('TagCharge' : *Blanks : 'Attribute');
              AddToXml('OrderMinCharge' : *Blanks : 'Attribute');
              AddToXml('DocumentCharge' : *Blanks : 'Attribute');
              AddToXml('HandlingCharge' : *Blanks : 'Attribute');
              AddToXml('PackingCharge' : *Blanks : 'Attribute');
              AddToXml('ItemMinimumCharge' : *Blanks : 'Attribute');
              AddToXml('FuelCharge' : *Blanks : 'Attribute');
              AddToXml('BelowMinTagCharge' : *Blanks : 'Attribute');
              AddToXml('GSTCharge' : *Blanks : 'Attribute');
              AddToXml('PSTCharge' : *Blanks : 'Attribute');
              AddToXml('HSTCharge' : *Blanks : 'Attribute');
              AddToXml('OrderTotal' : %Char(WH$AMT) : 'Attribute');
              AddToXml('Boxes' : *Blanks : 'Closetag');
VV02       Endif;

        EndSr;
VV02  //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : CallCmd Subroutine :
  |   *?                :--------------------:
  |   *
  |     Begsr CallCmd;
  |
  |   *?   // Call CL program to perform Command
  |        Monitor;
  |           QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
  |        On-Error;
  |        EndMon;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :---------------------:
  |   *?                : StoreIfs Subroutine :
  |   *?                :---------------------:
  |   *
  |     Begsr StoreIfs;
  |
  |   *?   // Create stream file
  |        Chain ('IFS' : 'IFSINVOICE' ) FBROKDFTL0;
  |        If %Found;
  |           WkPath = %Trim(DFVARVAL);
  |        Endif;
  |
  |        WkFile = 'INVOICE-' + %Trim(%Char(WHINV#)) +  '_'
  |                              + %Char(%Timestamp()) + '.xml';
  |        Cmd = 'CPYTOIMPF FROMFILE(IFSXML) STMFCODPAG(1208) ' +
  |              'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
  |              + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)';
  |        Exsr CallCmd;
  |
VV02    EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : AddToXml Procedure :
      *?                :--------------------:
      *
      *?Logic   : AddToXml to generate XML Acknowledgement
      *?          Field by field process
      *?Example : Starttag : <Tagname>
      *?          Opentag  : <Tagname
      *?          Closetag :  Tagname/>
      *?          Close    :  Tagname>
      *?          Endtag   : </Tagname>
      *
        Dcl-Proc  AddToXml;
          Dcl-Pi AddToXml;
            Tagname      Char(50)  Value;
            Tagvalue     Char(300) Value;
            Info         Char(10)  Value;
          End-Pi;

      *?   // Replace Special Characters
VV02       If TagValue <> *Blanks;
  |           TagValue = %ScanRpl('&': '&amp;': TagValue);
  |           TagValue = %ScanRpl('''': '&apos;' : TagValue);
  |           TagValue = %ScanRpl('"': '&quot;' : TagValue);
VV02       Endif;

      *?  // Check Info to add XML tag
          Select;

             When Info = 'Starttag';
                Xml = %Trimr(Xml) + '<' + %Trim(Tagname)
                                 + %Trim(Tagvalue)  + '>';

             When Info = 'Opentag';
                Xml = %Trimr(Xml) + ' ' + '<' + %Trim(Tagname) ;

             When Info = 'Attribute';
                Xml = %Trimr(Xml) + ' ' + %Trim(Tagname) + '="'
                                 + %Trim(Tagvalue) + '" ';

               When Info = 'Closetag';
                  Xml = %Trimr(Xml) + ' ' + %Trim(Tagname) + '="'
                                   + %Trim(Tagvalue) + '"' + ' />';

               When Info = 'Close';
                  Xml = %Trimr(Xml) + ' ' + %Trim(Tagname) + '="'
                                   + %Trim(Tagvalue) + '"' + ' >';

               When Info = 'Endtag';
                  Xml = %Trimr(Xml) + ' </' + %Trim(Tagname) + '>';

              When Info = 'Element';
                  Xml = %Trimr(Xml) + ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

            Endsl;

      *?    // Write XML Line into IFS
VV02        Exsr WriteIFS;

VV02  //--------------------------------------------------------------------
  |   *?            :---------------------:
  |   *?            : WriteIFS Subroutine :
  |   *?            :---------------------:
  |   *
  |   *?Logic : Write Each tag as a Record into Flat File
  |   *?
  |     Begsr WriteIFS;
  |
  |   *?   // Check Info to add XML tag
  |        Select;
  |
  |           When Info = 'Starttag';
  |              XmlIfs =  '<' + %Trim(Tagname)
  |                              + %Trim(Tagvalue)  + '>';
  |
  |           When Info = 'Opentag';
  |              XmlIfs =  '<' + %Trim(Tagname) ;
  |
  |           When Info = 'Attribute';
  |              XmlIfs =  %Trim(Tagname) + '="'
  |                              + %Trim(Tagvalue) + '" ';
  |
  |           When Info = 'Closetag';
  |              XmlIfs =  %Trim(Tagname) + '="'
  |                                + %Trim(Tagvalue) + '"' + ' />';
  |
  |           When Info = 'Close';
  |              XmlIfs =  %Trim(Tagname) + '="'
  |                                + %Trim(Tagvalue) + '"' + ' >';
  |
  |           When Info = 'Endtag';
  |              XmlIfs = ' </' + %Trim(Tagname) + '>';
  |
  |           When Info = 'Element';
  |              XmlIfs = ' <' + %Trim(Tagname) + '>'
  |                     + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';
  |
  |        Endsl;
  |
  |   *?   // Insert into Flat File
  |        Exec Sql
  |        INSERT INTO IFSXML Values(:XMLIFS);
  |
  |     Endsr;
  |
VV02    End-Proc;
      *?------------- End of Program ----------------------------------
