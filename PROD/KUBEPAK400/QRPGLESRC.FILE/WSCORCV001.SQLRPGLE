      *? Program        : WSCORCV001
      *?
      *? Description    : This program is to Consume XML into RPG,
      *?                  Process and send back Acknowledgment as a
      *?                  Response.
      *? Created By     : Reddaiah N.P
      *?
      *? Date           : 17 Oct 2017
      //--------------------------------------------------------------------
      *? Special Notes  : XML response only for Successful Order Change
      *?                  For Unsuccessful Order Will be marked as Exception
      *
      *? Called Program : WSCOVAL002 - WS - Receive XML for Change Order
      *?                  WSCOACK003 - WS - Acknowledgement Process for Change Order
      *?                  WSSTOREXML - WSURC - Store PO/CO & URC Ack/Inv Xml in IFS
      *
      *? Response       : Status Message for Broker
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *?Changes in 2018
      * SUD01   03/28/18   S.Uthaya     Response message changed based on
      *                                 some conditions
      * VV01    04/30/18   Vimala V     Added New brokers for Phase II Changes
      * SUD02   05/04/18   S.Uthaya     Phase II Changes
      * VV02    07/25/18   Vimala V     Changes to Write Duplicate Item/Size
      *                                 for Order coming from xml in WSCO file
      *         08/06/18   Vimala V     Eason Changes
      * VV03    10/10/18   Vimala V     Eason Changes to move ShipMethodDesc to ShipMethod
      * SUD03   10/10/18   S.Uthaya     Store PO receive XML into IFS
      *?Changes in 2019
      * SUD04   03/15/19   S.Uthaya     Gloeckner Orders - Field Mapping(Switch Address 1 & 2)
      * SUD05   09/12/19   S.Uthaya     Storexml Parameter Length changed
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
      *?File: WS -XML Change Order Header File
        Dcl-F WSCOHDRPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File: WS - XML Change Order Header Logical File
      *?Key : From Org Id:Sequence Number
        Dcl-F WSCOHDRL0  Disk(*Ext) Keyed Usage(*Input) Rename(WSCOHDRR:Rec1)
                                                       Prefix(H);
      *?Key : From Org Id:Customer PO:Sequence Number
        Dcl-F WSCOHDRL1  Disk(*Ext) Keyed Usage(*Input) Rename(WSCOHDRR:Rec2)
                                                       Prefix(I);
      *?File: WS Change Order Detail File
        Dcl-F WSCODTLPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File: WS - Xml Create Order Detail Logical File
      *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
        Dcl-F WSPODTLL0  Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: Cross Reference File for FMINVT
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFINVTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
SUD01 *
  |   *?File: WS - XML Order Create Header Logical File
  |   *?Key : From Org Id:Customer PO:Sequence Number
SUD01   Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Input);
      *
VV02  *?File: WS - WS - XML Order Change Control Logical File
  |   *?Key : From Org Id:Broker Order Id:Order #:Item:Size:BrkItem:BrkSize
VV02    Dcl-F WSORCHCL2  Disk(*Ext) Keyed Usage(*Input:*Update);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSORDER001)
        Dcl-Pi WSCORCV001;
           POXml      Char(1000000) Options(*Varsize);
           Httpstatus Int(10:0);
           Acknowledgement Like(PBrkAck);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Validation Program
        Dcl-Pr WSCOVAL002 Extpgm;
           PFromOrgId Like(PFromOrgId);
           PCustPO    Like(PCustPO);
           PSeqno     Like(PSeqno);
           PFlag      Like(PFlag);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Acknowledgement Program
        Dcl-Pr WSCOACK003 Extpgm;
           PFromOrgId Like(PFromOrgID);
           PCustPO    Like(PCustPO);
           PSeqno     Like(PSeqno);
           PBrkAck    Char(1000000);
        End-Pr;
      *
SUD03 *?Procedure Prototype Declaration : Store XML into IFS
  |     Dcl-Pr WSSTOREXML Extpgm;
  |       PXML       Char(9999999) Options(*Varsize);
  |       PFromOrgId Like(PFromOrgId);
  |       PCustPO    Like(PCustPO);
  |       PrFLag     Char(10);
SUD03   End-Pr;
      *
      *?Data Structure Declaration      : Identification
        Dcl-Ds Identification Qualified;
           Reference_ID         Char(36);
           Date                 Char(19);
           MessageProtocol_Id   Char(30);
           FromOrg_ID           Char(30);
           ToOrg_ID             Char(30);
           SenderOrg_ID         Char(30);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderHeader
        Dcl-Ds OrderHeader    Qualified;
           CustomerPONumber        Char(35);
           BackOrderOK             Char(1);
VV01       VendorOrderID           Char(30);
           RequestedShipDate       Char(10);
           AirportCode             Char(10);
           BrokerUpdatedBy         Char(12);
           CarrierDescription      Char(50);
           HeaderComments          Char(255);
           CarrierNumber           Char(10);
           BrokerCreatedDate       Char(10);
           BrokerCreatedTime       Char(8);
           VendorNumber            Char(10);
           CommittedInventoryCode  Char(3);
VV01       ShipMethod              Char(30);
           BrokerOrderID           Char(10);
VV01       FreightPaymentMethod    Char(30);
           IncomingType            Char(1);
           ShippingInstructions    Char(255);
           SubstitutionOK          Char(1);
           SalesRepName            Char(30);
           BrokerUpdatedDate       Char(10);
           BrokerUpdatedTime       Char(8);
           ShipMethodDesc          Char(30);
           ChangeOrderBatchNumber  Char(5);
           CustomerReference       Char(12);
           TaxExchange             Char(10);
           BrokerDeliveryID        Char(10);
           TagRatio                Char(2);
VV01       TagRatioDescription     Char(80);
           ProductionWeek          Char(7);
           DistributorPONumber     Char(35);
VV01       BrokerRevision          Char(2);
 |         RootingStation          Char(40);
VV01       TagExchange             Char(1);
           SoldTo LikeDS(SoldTo);
           ShipTo LikeDs(ShipTo);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderHeader/Sold To
        Dcl-Ds SoldTo    Qualified;
           SoldToContactName   Char(40);
VV01       BrokerSoldToNumber  Char(12);
           SoldToName          Char(40);
           SoldToAddress1      Char(40);
           SoldToAddress2      Char(40);
           SoldToState         Char(3);
           SoldToCity          Char(35);
           SoldToCountry       Char(3);
           SoldToCountry3      Char(3);
           SoldToZip           Char(10);
           SoldToFax           Char(31);
VV01       SoldToPhone         Char(18);
           SoldToEmail         Char(50);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderHeader/Ship To
        Dcl-Ds ShipTo    Qualified;
           ShipToContactName         Char(40);
VV01       BrokerShipToNumber        Char(24);
           ShipToName                Char(40);
           ShipToAddress1            Char(40);
           ShipToAddress2            Char(40);
           ShipToState               Char(3);
           ShipToCity                Char(35);
           ShipToCountry             Char(3);
           ShipToCountry3            Char(3);
           ShipToZip                 Char(10);
           ShipToFax                 Char(31);
VV01       ShipToPhone               Char(18);
           ShipToEmail               Char(50);
           ShipToNonStandardAddress  Char(1);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderDetails/Item
        Dcl-Ds Item Qualified Dim(9999);
VV02       BrokerLineItemNumber       Char(10);
           BrokerMaterialNumber       Char(18);
           VendorMaterialNumber       Char(35);
           MaterialDescription        Char(45);
           OrderedQty                 Char(11);
SUD02      OrderdQty                  Char(13);
VV01       LineItemPrice              Char(14);
           LineItemComment            Char(255);
           ScheduledShipDate          Char(10);
           IncomingType               Char(1);
           CustomerPONumber           Char(35);
           UnitOfMeasure              Char(3);
           CommittedInventoryPONumber Char(10);
           BrokerSalesOrderID         Char(10);
           CustomerReference          Char(12);
           TagRatio                   Char(2);
VV01       TagRatioDescription        Char(24);
           PlantCode                  Char(4);
           PlantCodeDescription       Char(30);
           ShippingPoint              Char(4);
           ShippingPointDescription   Char(30);
           ProductionWeek             Char(7);
VV01       VendorLineItemNumber       Char(4);
VV01       TagRatioValue              Char(2);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderDetails
        Dcl-Ds OrderDetails Qualified;
           Item LikeDs(Item) ;
        End-Ds;
      *
      *?Program Status Data Structure   :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration     :
        Dcl-S Options Char(150);
        Dcl-S Pos     Zoned(3);
        Dcl-S x       Int(5:0);
      *
      *?Work Variable Declaration       :
        Dcl-S WkBrkItem    Like(CDBRKMAT);
        Dcl-S WkLineItemNo Like(CDBRKLNE);
        Dcl-S WkFrmOrgId   Like(CHFRORID);
        Dcl-S WkBrokerId   Like(CHBRKORID);
        Dcl-S WkOrder      Like(CHORDNO);
        Dcl-S WkOrdLin     Like(CDORDLIN);
        Dcl-S WkSeq        Like(CHSEQNO);
        Dcl-S WkExtra      Char(55);
        Dcl-S WkItem       Char(12);
VV02    Dcl-S WkSize       Char(3);
        Dcl-S WkTag        Char(30);
SUD01   Dcl-S WkState      Char(1);
        Dcl-S WkDate       Zoned(6);
      *
      *?Function Variable Declaration :
        Dcl-S ThisMonday  Zoned(6) Inz;
        Dcl-S Today       Date;
      *
      *?Parameter Variable Declaration :
        Dcl-S PFromOrgId Like(CHFRORID);
        Dcl-S PCustPO    Like(CHBRKORID);
        Dcl-S PSeqno     Like(CHSEQNO);
        Dcl-S PFlag      Like(CHFLAG);
        Dcl-S PBrkAck    Char(1000000) Inz;
SUD05   Dcl-S PXml       Char(9999999) Inz;
SUD03   Dcl-S PrFlag     Char(10)      Inz;
      //--------------------------------------------------------------------
      *?                :--------------:
      *?                : Copy  Source :
      *?                :--------------:
      *
      *?Service Programs
    ? /COPY QFunctDefn,$Date
    ? /COPY QFunctDefn,$MDYDate
    ? /COPY QFunctDefn,$Monday
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Execute Initialize
           Exsr InzPgm;

      *?   // If HttpStatus is Success, Call Validate Program
           If Httpstatus = 200 and CHFLAG= ' ';
              WSCOVAL002(PFromOrgId:PCustPO:PSeqno:PFlag);
              If PFlag = 'C';

      *?         // Call Acknowledgement XML Generate Program
                 WSCOACK003(PFromOrgId:PCustPO:PSeqno:PBrkAck);
                 Acknowledgement = PBrkAck;

      *?      // Error status
              Elseif PFlag = 'E';
                 Acknowledgement = 'Change Order Placed with Error for PO:'
                                         + PCustPO + '.Please contact KubePak';
      *?      // Close Status
              Elseif PFlag = 'X';
SUD01            Chain (PFromOrgId:PCustPO) WSPOHDRL1;
  |              If %Found;
  |
  |   *?            // If PO Creation in Exception
  |                 If PHFLAG = 'E';
  |                    Acknowledgement = 'Order Change Received.' +
  |                                      'Acknowledgement will be sent shortly';
  |                 Elseif PHFLAG = 'P' Or PHFLAG = 'C';
  |                    WkOrder = PHORDNO;
  |                    Exec SQL
  |                       Select OHSTAT into :WkState from FHORDR
  |                       Where OHORD# = :WKOrder;
  |
  |   *?               // If Order Not Active in FHORDR
  |                    If WkState <> 'A';
  |                       Acknowledgement = 'Order not active.' +
  |                                         'Please call Kube-Pak';
  |
  |   *?               // If Order Not eligible to change
  |   *?               // If Order with OISEQ# = '0' in Control File
  |                    Else;
  |                       Acknowledgement = 'Order preparing for shipment and '+
  |                                         'not eligible for change.' +
  |                                         'Please call Kube-Pak';
  |                    Endif;
  |                 Endif;
  |              Else;
  |
  |   *?            // Order not found in PO XML file
  |                 Acknowledgement = 'Order Not Available for the PO:' +
  |                        PCustPo + '.Please call Kube-Pak';
SUD01            Endif;
              Endif;
           Endif;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Parameters , Data Structure & Proceed Validation
      *?
        Begsr InzPgm;

      *?   // Initialise Response Parameters
           HttpStatus  = 200;        // Success Code

      *?   // Clear DataStructure and Variables
           Clear Identification;
           Clear OrderHeader;
           Clear SoldTo;
           Clear ShipTo;
           Clear OrderDetails;
           Clear Item;

      *?   // Clear Variables
           Clear Options;
           Pos = *Zeros;

      *?   // Get Monday Date for Current date
           Today      = $Date(0);                           // Today MDY
           ThisMonday = $MDYDate($Monday(Today:'FRI'));     // Monday MDY
           WkDate     = ThisMonday;

      *?   // Validate Input Parameters
           Exsr Validate;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : Validate Subroutine :
      *?                :---------------------:
      *
      *?Logic : Mandatory Parameters Validation & Get Broker Name
      *?
        Begsr Validate;

      *?   // Mandatory Parameters Validation
           If POXml = *Blanks;
              Httpstatus = 400;      //Invalid Parameter
              Exsr EndPgm;
           Endif;

      *?   // To Identify Broker for the Process
           WkTag = *Blanks;
           Setll ('1000' : 'XMLCOTAG') FBROKDFTL0;
           ReadE ('1000' : 'XMLCOTAG') FBROKDFTL0;
           Dow  Not %Eof;
             WkTag =  %Trim(DFVARVAL);
             Pos = %Scan(%Trim(WkTag):POXml:1);
             If Pos <> *Zeros;
                Leave;
             Endif;
             ReadE ('1000' : 'XMLCOTAG') FBROKDFTL0;
           EndDo;

      *?   // Replace Special Character with Equivalent Value
           POXML = %ScanRpl('& ' : '&amp; ': POXML);

      *?   // Call Subroutine to process Xml Data
           If Pos <> *Zeros;
              Exsr Process;
           Else;
              Httpstatus = 400;   //Invalid Parameter
              Exsr EndPgm;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

SUD03 *?   // Store Receive XML into IFS
  |        PrFlag = 'Change';
SUD05      PXml   = POXML;
SUD05      WSSTOREXML(PXML:PFromOrgId:PCustPO:PrFlag);

      *?   // End the Program
           *InLr = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
      *?Logic : Use XML-INTO keyword to map Xml fields to DS Fields
      *?      : Give Specific path information in Options
      *?      : Options : Path=option must be used to specify the XML
      *?                     element to be used
      *?      :           case=upper/lower/any
      *?      :           allowextra/allowmissing=yes/no

        Begsr Process;

      *?   // Extra Path Properties
           WkExtra = 'allowextra=yes allowmissing=yes case=any doc=string';

      *?   // Identification Data Structure
           Options = 'path=' + %Trim(WkTag) + '/Identification ' +
                        %Trim(WkExtra) ;

           Xml-Into Identification %XML(POXml:Options);

      *?   // OrderHeader Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderHeader ' +
                        %Trim(WkExtra) ;

           Xml-Into OrderHeader %XML(POXml:Options);

      *?   // OrderHeader/SoldTo Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderHeader/SoldTo '+
                        %Trim(WkExtra) ;

           Xml-Into SoldTo %XML(POXml:Options);

      *?   // OrderHeader/ShipTo Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderHeader/ShipTo '+
                        %Trim(WkExtra) ;

           Xml-Into ShipTo %XML(POXml:Options);

      *?   // OrderDetails/Item Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderDetails/Item ' +
                        %Trim(WkExtra) ;

           Xml-Into Item %XML(POXml:Options);

      *?   // Get POXML Header file
           Exsr GetHeader;

      *?   // Move Datastructure Values into File
           Exsr WriteHeader;
           Exsr WriteDetail;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : GetHeader Subroutine :
      *?            :----------------------:
      *
      *?Logic : Get the PO XML header file details using SQL

        Begsr GetHeader;

      *?   // Get FromOrgID & BrokerOrderId from Data Structure
SUD02      If Identification.FromOrg_ID = 'Gloeckner';
  |           WkFrmOrgId = %Subst(Identification.FromOrg_ID:1:9);
  |        Else;
  |           WkFrmOrgId = Identification.FromOrg_ID;
SUD02      Endif;
           WkBrokerId = OrderHeader.BrokerOrderID;

      *?   // Check Record Exists with Flag "C" or "P" and Process
           Exec SQL
              Select PHORDNO,PHSEQNO Into :WkOrder, :WkSeq from WSPOHDRPF
              Where (PHFLAG='C' or PHFLAG='P')  And PHFRORID = :WkFrmOrgID And
              PHBRKORID = :WkBrokerID
              Fetch first row only;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteHeader Subroutine :
      *?            :------------------------:
      *
      *?Logic : Move Data structure fields into file fields and Write

        Begsr WriteHeader;

      *?   // Open Files
           Open WSCOHDRPF;

      *?   // Get Highest Sequence number from file
SUD02      If Identification.FromOrg_ID = 'Gloeckner';
  |           WkFrmOrgId = %Subst(Identification.FromOrg_ID:1:9);
  |        Else;
  |           WkFrmOrgId = Identification.FromOrg_ID;
SUD02      Endif;
           Setgt WkFrmOrgId  WSCOHDRL0;
           ReadPE WkFrmOrgId WSCOHDRL0;
           If Not %Eof;
             If HCHSEQNO = 999999999;
                HCHSEQNO = 1;
             Else;
                HCHSEQNO += 1;
             Endif;
           Else;
             HCHSEQNO  = 1;
           Endif;

      *?   // Clear Record Format
           Clear WSCOHDRR;

      *?   // Move sequence Number
           CHSEQNO   = HCHSEQNO;

      *?   // Identification Part
           CHREFID   = Identification.Reference_ID;
           CHIDATE   = Identification.Date;
           CHMSGPR   = Identification.MessageProtocol_Id;
SUD01      CHFRORID  = WkFrmOrgId;
           CHTOORID  = Identification.ToOrg_ID;
           CHSNDORID = Identification.SenderOrg_ID;

      *?   // Order Header Part
           If OrderHeader.RequestedShipDate <> *Blanks;
              CHRQSHDT = %Date(OrderHeader.RequestedShipDate :*Iso);
           Else;
              CHRQSHDT = %Date(WkDate:*Mdy);
           Endif;
           If OrderHeader.BrokerCreatedDate <> *Blanks;
               CHBRKCRDT= %Date(OrderHeader.BrokerCreatedDate : *Iso);
           Else;
               CHBRKCRDT= %Date();
           Endif;
           If OrderHeader.BrokerCreatedTime <> *Blanks;
               CHBRKCRTM= %Time(OrderHeader.BrokerCreatedTime : *Hms);
           Endif;

           CHCUSTPO = OrderHeader.CustomerPONumber;
           CHBKOROK = OrderHeader.BackOrderOK;
           CHVENDID = OrderHeader.VendorOrderID;
           CHAIRCDE = OrderHeader.AirportCode;
           CHBRKUPBY=OrderHeader.BrokerUpdatedBy;
           CHCARRNO = OrderHeader.CarrierNumber;
           CHCARRDS = OrderHeader.CarrierDescription;
           CHHDRCMT = OrderHeader.HeaderComments;
           CHVENDNO = OrderHeader.VendorNumber;
           CHCMINCD = OrderHeader.CommittedInventoryCode;
           CHSHPMTH = OrderHeader.ShipMethod;

      *?   // Order Header - Move ShipMethodDesc to ShipMethod
VV03       If WkFrmOrgId = 'Eason';
 |            CHSHPMTH = OrderHeader.ShipMethodDesc ;
VV03       Endif;
      *
           CHBRKORID= OrderHeader.BrokerOrderID;
           CHFREMTH = OrderHeader.FreightPaymentMethod;
           CHINCTYP = OrderHeader.IncomingType;
           CHSHPINS = OrderHeader.ShippingInstructions;
           CHSUBSOK = OrderHeader.SubstitutionOK;
           CHSALNAM = OrderHeader.SalesRepName;
           CHBRKUPDT= %Date();
           CHORDDAT = %Date();

      *?   // Gloeckner Fields
SUD02      If WkFrmOrgId = 'Gloeckner';
VV01          CHBRKRVN = %Int(OrderHeader.BrokerRevision);
 |            CHRTGSTN = OrderHeader.RootingStation;
 |            CHEXCHNG = OrderHeader.TagExchange;
VV01       Endif;
           CHFLAG  = *Blanks;
           CHORDNO = WkOrder;                      // Order Number from PO

      *?   // Only for Ball PO
           If WkFrmOrgId = 'Ball Seed';
              If OrderHeader.BrokerUpdatedDate <> *Blanks;
                 CHBRKUPDT = %Date(OrderHeader.BrokerUpdatedDate : *Iso);
              Else;
                 CHBRKUPDT=%Date();
              Endif;
              If OrderHeader.BrokerUpdatedTime <> *Blanks;
                 CHBRKUPTM = %Time(OrderHeader.BrokerUpdatedTime : *Hms);
              Endif;

              CHCUSTREF  = OrderHeader.CustomerReference;
              CHTAXEXC   = OrderHeader.TaxExchange;
              CHBRKDELID = OrderHeader.BrokerDeliveryID;
              CHTAGRAT   = OrderHeader.TagRatio;
              CHTAGRATD  = OrderHeader.TagRatioDescription;
              CHPRODWK   = OrderHeader.ProductionWeek;
              CHDISPONM  = OrderHeader.DistributorPONumber;
           Endif;

VV02       If WkFrmOrgId = 'Ball Seed' Or WkFrmOrgId = 'Eason';
 |            If OrderHeader.ChangeOrderBatchNumber <> *Blanks;
 |               CHCHORNO= %Dec(OrderHeader.ChangeOrderBatchNumber:5:0);
 |            Endif;
 |            CHSHPMTHD = OrderHeader.ShipMethodDesc ;
VV02       Endif;

      *?   // Order Header - Sold To
           CHSLDCON = OrderHeader.SoldTo.SoldToContactName;
           CHSLDEML = OrderHeader.SoldTo.SoldToEmail;
           CHSLDNUM = OrderHeader.SoldTo.BrokerSoldToNumber;
           CHSLDFAX = OrderHeader.SoldTo.SoldToFax;
           CHSLDZIP = OrderHeader.SoldTo.SoldToZip;
           CHSLDAD1 = OrderHeader.SoldTo.SoldToAddress1;
           CHSLDAD2 = OrderHeader.SoldTo.SoldToAddress2;
           CHSLDPHN = OrderHeader.SoldTo.SoldToPhone;
           CHSLDNAM = OrderHeader.SoldTo.SoldToName;
           CHSLDSTE = OrderHeader.SoldTo.SoldToState;
           CHSLDCTY = OrderHeader.SoldTo.SoldToCity;
           CHSLDCNTY= OrderHeader.SoldTo.SoldToCountry;
           CHSLDCNTY3= OrderHeader.SoldTo.SoldToCountry3;    // Ball PO

      *?   // Order Header - Ship To
           CHSHPCON = OrderHeader.ShipTo.ShipToContactName;
           CHSHPEML = OrderHeader.ShipTo.ShipToEmail;
           CHSHPNUM = OrderHeader.ShipTo.BrokerShipToNumber;
           CHSHPFAX = OrderHeader.ShipTo.ShipToFax;
           CHSHPZIP = OrderHeader.ShipTo.ShipToZip;
SUD04      If WkFrmOrgId <> 'Gloeckner';
  |           CHSHPAD1 = OrderHeader.ShipTo.ShipToAddress1;
  |           CHSHPAD2 = OrderHeader.ShipTo.ShipToAddress2;
  |        Else;
  |           CHSHPAD1 = OrderHeader.ShipTo.ShipToAddress2;
  |           CHSHPAD2 = OrderHeader.ShipTo.ShipToAddress1;
SUD04      Endif;
           CHSHPPHN = OrderHeader.ShipTo.ShipToPhone;
           CHSHPNAM = OrderHeader.ShipTo.ShipToName;
           CHSHPSTE = OrderHeader.ShipTo.ShipToState;
           CHSHPCTY = OrderHeader.ShipTo.ShipToCity;
           CHSHPCNTY= OrderHeader.ShipTo.ShipToCountry;
           CHSHPCNTY3= OrderHeader.ShipTo.ShipToCountry3;
           CHSHPNSAD = OrderHeader.ShipTo.ShipToNonStandardAddress;

      *?   // Audit Stamp
           CHCRTDAT = Rundate;
           CHCRTTIM = Runtime;
           CHCRTUSR = User;
           CHCRTJOB = Job;
           CHCRTPGM = Pgm;

      *?   // Write Rec
           Write WSCOHDRR;
           PFromOrgId = CHFRORID;
           PCustPO    = CHBRKORID;
           PSeqno     = CHSEQNO;

      *?   // Close Files
           Close WSCOHDRPF;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteDetail Subroutine :
      *?            :------------------------:
      *
      *?Logic : Move Data Structure fields into file fields and Write
      *
        Begsr WriteDetail;

      *?   // Open Files
           Open WSCODTLPF;

      *?   // Clear Record Format
           Clear WSCODTLR;

      *?   // Move Item List into File
           For x =  1 to %Elem(Item);
              If Item(x).BrokerLineItemNumber <> *Blanks;

      *?         // Check PO XML file to get Order Number & OrderLineNo
                 WkLineItemNo = %Int(Item(x).BrokerLineItemNumber);
                 WkBrkItem = %TrimL(Item(x).BrokerMaterialNumber:'0');

VV02  *?         // Get Order Line number from Order Control File
VV02             Exsr GetOrderLine;

              Elseif Item(x).BrokerLineItemNumber = *Blanks;
                 Leave;
              Endif;

           Endfor;

      *?   // Close Files
           Close WSCODTLPF;

        Endsr;
      //--------------------------------------------------------------------
VV02  *?            :-------------------------:
  |   *?            : GetOrderLine Subroutine :
  |   *?            :-------------------------:
  |   *
  |   *  ?Logic : Get Order# & Line# from WSORCHCPF - Order Control File
  |   *
  |     Begsr GetOrderLine;
  |
  |   *?   // Check Record Exists in WSORCHCPF
  |        WkOrdLin = *Zeros;
  |        Exec Sql
  |           Select OCORDLIN Into :WkOrdLin from WSORCHCPF
  |           Where OCFRORID = :WkFrmOrgID And
  |           OCBRKORID = :WkBrokerID and OCORDNO = :WkOrder and
  |           OCBRKLNE = :WkLineItemNo and OCBRKMAT = :WkBrkItem;
  |
  |   *?   // If Order Line not found in for the combination check
  |   *?   // control file without Broker Item/Line for manually added lines
  |        If WkOrdLin = *Zeros;
  |           Chain (WkFrmOrgID:'Customer':WkBrkItem) XREFINVTL0;
  |           If %Found;
  |              WkItem = XRLCLITEM;
  |              WkSize = XRLCLSIZE;
  |              Exec SQL
  |              Select OCORDLIN Into :WkOrdLin from WSORCHCPF
  |              Where OCFRORID = :WkFrmOrgID And
  |              OCBRKORID = :WkBrokerID and OCORDNO = :WkOrder and
  |              OCITEM = :WkItem and OCIMSZE = :WkSize and
  |              OCBRKLNE = 0 and OCBRKMAT = ' ';
  |              If WkOrdLin <> *Zeros and OCBRKMAT = ' '  and
  |                                        OCBRKLNE = 0;
  |                 Chain (WkFrmOrgID:WKBrokerID:WkOrder:WkItem:
  |                                   WKSize) WSORCHCL2;
  |                 If %Found;
  |                    OCUPDDAT = Rundate;
  |                    OCUPDTIM = Runtime;
  |                    OCUPDUSR = User;
  |                    OCUPDJOB = Job;
  |                    OCUPDPGM = Pgm;
  |                    OCBRKLNE = WkLineItemNo;
  |                    OCBRKMAT = WkBrkItem;
  |                    Update WSORCHCR %Fields(OCBRKMAT:OCBRKLNE:OCUPDDAT
  |                                  :OCUPDTIM:OCUPDUSR:OCUPDJOB:OCUPDPGM);
  |                 Endif;
  |              Endif;
  |           Endif;
  |        Endif;
  |
  |   *?   // Move Detail fields values from Datastructure
  |        Exsr MoveDetail;
  |
VV02    Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : MoveDetail Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Move Data Structure fields into file fields and Write
      *
        Begsr MoveDetail;

      *?   // Identification Part
           CDREFID   = Identification.Reference_ID;
           CDIDATE   = Identification.Date;
           CDMSGPR   = Identification.MessageProtocol_Id;
SUD01      CDFRORID  = WkFrmOrgId;
           CDTOORID  = Identification.ToOrg_ID;
           CDSNDORID = Identification.SenderOrg_ID;
           CDHDRSEQ  = CHSEQNO;
           CDSEQNO  += 1;

      *?   // Order Detail Part
           If WkFrmOrgId = 'Griffin';
              CDCUSTPO = OrderHeader.CustomerPONumber;
           Endif;
           CDBRKORID = OrderHeader.BrokerOrderID;
           If Item(x).BrokerLineItemNumber <> *Blanks;
VV02          CDBRKLNE = %Dec(Item(x).BrokerLineItemNumber :10:0);
           Endif;
           If Item(x).OrderedQty <> *Blanks;
              CDORDQTY = %Dec(Item(x).OrderedQty:13:1);
           Endif;
SUD02      If Item(x).OrderdQty <> *Blanks;
  |           CDORDQTY = %Dec(Item(x).OrderdQty:13:1);
SUD02      Endif;
           If Item(x).LineItemPrice <> *Blanks;
VV01          CDLNITMPR= %Dec(Item(x).LineItemPrice:14:4);
           Endif;
           If Item(x).ScheduledShipDate <> *Blanks;
              CDSCHSHDT= %Date(Item(x).ScheduledShipDate: *Iso);
           Else;
              CDSCHSHDT= %Date(WkDate:*Mdy);
           Endif;

           CDBRKMAT = %TrimL(Item(x).BrokerMaterialNumber:'0');
           CDVENMAT = Item(x).VendorMaterialNumber;
           CDVENDSC = Item(x).MaterialDescription;
           CDLNITMCM= Item(x).LineItemComment;
           CDINCTYP = Item(x).IncomingType;

      *?   // Only for Gloeckner
SUD02      If WkFrmOrgId = 'Gloeckner';
              If Item(x).TagRatioValue <> *Blanks;
                 CDTAGRATV= %Int(Item(x).TagRatioValue);
              Endif;
VV01          CDTAGRATD= Item(x).TagRatioDescription;
 |            CDVENLNE = %Int(Item(x).VendorLineItemNumber);
VV01       Endif;
           CDFLAG   = CHFLAG;
           CDORDLIN = WkOrdLin;
           CDORDNO  = WKOrder;
VV02       CDUNTOM  = Item(x).UnitOfMeasure;

      *?   // Only for Ball PO
           If WkFrmOrgId = 'Ball Seed';
              CDCUSTPO = Item(x).CustomerPONumber;
              CDCOMINV = Item(x).CommittedInventoryPONumber;
              CDBRKSALO= Item(x).BrokerSalesOrderID;
              CDCUSTREF= Item(x).CustomerReference;
              CDTAGRAT = Item(x).TagRatio;
              CDTAGRATD= Item(x).TagRatioDescription;
              CDPLNTCD = Item(x).PlantCode;
              CDPLNTDS = Item(x).PlantCodeDescription;
              CDSHPPNT = Item(x).ShippingPoint;
              CDSHPDS  = Item(x).ShippingPointDescription;
           Endif;

      *?   // Audit Stamp
           CDCRTDAT = Rundate;
           CDCRTTIM = Runtime;
           CDCRTUSR = User;
           CDCRTJOB = Job;
           CDCRTPGM = Pgm;

      *?   // Write Rec
           Write WSCODTLR;

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
