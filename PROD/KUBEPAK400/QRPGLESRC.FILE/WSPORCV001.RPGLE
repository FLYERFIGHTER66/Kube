      *? Program        : WSPORCV001
      *?
      *? Description    : This pgm to Consume PO XML into RPG , Process
      *?                  and send back Response
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 05 Oct 2017
      //--------------------------------------------------------------------
      *? Special Notes  : ** XML response only for Successful PO Creation
      *?                  ** For Unsuccessful Order Will marked as Exception
      *?                  ** Check PO Unique and then Write Record
      *
      *? Called Program : WSPOVAL002 - WS - Receive XML for Order Creation
      *?                  WSPOACK003 - WS - Acknowledgement Process for Order Creation
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
      * VV01    04/30/18   Vimala V     Added New brokers for Phase II Changes
      * SUD01   04/05/18   S.Uthaya     Phase II Changes
      * VV02    08/06/18   Vimala V     Eason Changes
      * VV03    10/10/18   Vimala V     Eason Changes to move ShipMethodDesc to ShipMethod
      * SUD02   10/10/18   S.Uthaya     Store PO receive XML into IFS
      *?Changes in 2019
      * SUD03   03/15/19   S.Uthaya     Gloeckner Orders - Field Mapping(Switch Address 1 & 2)
      * SUD04   09/12/19   S.Uthaya     Storexml Parameter Length changed
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
      *?File: WS - XML Order Create Header File
        Dcl-F WSPOHDRPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File: WS - XML Order Create Header Logical File
      *?Key : From Org Id:Sequence Number
        Dcl-F WSPOHDRL0  Disk(*Ext) Keyed Usage(*Input) Rename(WSPOHDRR:Rec1)
                                                       Prefix(H);
      *?File: WS - XML Order Create Header Logical File
      *?Key : From Org Id:Customer PO:Sequence Number
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Input) Rename(WSPOHDRR:Rec2)
                                                       Prefix(I);
      *?File: WS - XML Order Create Detail File
        Dcl-F WSPODTLPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSORDER001)
        Dcl-Pi WSPORCV001;
           POXml      Char(1000000) Options(*Varsize);
           Httpstatus Int(10:0);
           Acknowledgement Like(PBrkAck);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Validation Program
        Dcl-Pr WSPOVAL002 Extpgm;
          PFromOrgId Like(PFromOrgId);
          PCustPO    Like(PCustPO);
          PSeqno     Like(PSeqno);
          PFlag      Like(PFlag);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Acknowledgement Program
        Dcl-Pr WSPOACK003 Extpgm;
          PFromOrgId Like(PFromOrgId);
          PCustPO    Like(PCustPO);
          PSeqno     Like(PSeqno);
          PBrkAck    Char(1000000);
        End-Pr;
      *
SUD02 *?Procedure Prototype Declaration : Store XML into IFS
  |     Dcl-Pr WSSTOREXML Extpgm;
SUD04     PXML       Char(9999999) Options(*Varsize);
  |       PFromOrgId Like(PFromOrgId);
  |       PCustPO    Like(PCustPO);
  |       PrFLag     Char(10);
SUD02   End-Pr;
      *
      *?Data Structure Declaration      : Identification
        Dcl-Ds Identification Qualified;
           Reference_ID         Char(36);
           Date                 Char(19);
           MessageProtocol_ID   Char(30);
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
           BrokerRevision          Char(2);
VV01       RootingStation          Char(40);
 |         TagExchange             Char(1);
VV01       SoldTo LikeDS(SoldTo);
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
SUD01      OrderdQty                  Char(13);
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
        Dcl-S WkFrmOrgId Like(PHFRORID);
        Dcl-S WkDate     Zoned(6);
        Dcl-S WkTag      Char(30);
        Dcl-S WkExtra    Char(55);
      *
      *?Function Variable Declaration :
        Dcl-S ThisMonday Zoned(6) Inz;
        Dcl-S Today      Date;
      *
      *?Parameter Variable Declaration :
        Dcl-S PBrkAck    Char(1000000) Inz;
SUD04   Dcl-S PXml       Char(9999999) Inz;
SUD02   Dcl-S PrFlag     Char(10);
        Dcl-S PFromOrgId Like(PHFRORID);
        Dcl-S PCustPO    Like(PHBRKORID);
        Dcl-S PSeqno     Like(PHSEQNO);
        Dcl-S PFlag      Like(PHFLAG);
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
           If Httpstatus = 200 and PHFLAG = ' ';
              WSPOVAL002(PFromOrgId:PCustPO:PSeqno:PFlag);
              If PFlag = 'C';

      *?        // Process Flag is 'C', Call XML Generate Program
                WSPOACK003(PFromOrgId:PCustPO:PSeqno:PBrkAck);
                Acknowledgement = PBrkAck;

      *?      // Error Status
              Elseif PFlag = 'E';
                 Acknowledgement = 'Order Placed with Error for PO :' +
                                   PCustPO + ' Please contact KubePak';
              Endif;
           Elseif Httpstatus = 200 and PHFLAG = 'X';

      *?      // Close the Order
              Acknowledgement = 'Duplicate Customer PO: ' + PHBRKORID +
                                      '- Order Closed';
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

      *?   // Clear DataStructure
           Clear Identification;
           Clear OrderHeader;
           Clear SoldTo;
           Clear ShipTo;
           Clear OrderDetails;
           Clear Item;

      *?   // Clear Variables
           Clear Options;
           Pos = *Zeros;
           PBrkAck = *Blanks;

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
           Setll ('1000' : 'XMLPOTAG') FBROKDFTL0;
           ReadE ('1000' : 'XMLPOTAG') FBROKDFTL0;
           Dow  Not %Eof;
             WkTag =  %Trim(DFVARVAL);
             Pos = %Scan(%Trim(WkTag):POXml:1);
             If Pos <> *Zeros;
                Leave;
             Endif;
             ReadE ('1000' : 'XMLPOTAG') FBROKDFTL0;
           EndDo;

      *?   // Replace Special Character with Equivalent Value
           POXML = %ScanRpl('& ' : '&amp; ': POXML);

      *?   // Call Subroutine to process Xml Data
           If Pos <> *Zeros;
              Exsr Process;
           Else;
              Httpstatus = 400;      //Invalid Parameter
              Exsr EndPgm;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

SUD02 *?   // Store Receive XML into IFS
  |        PrFlag = 'Create';
SUD04      PXML   = POXML;
SUD04      WSSTOREXML(PXML:PFromOrgId:PCustPO:PrFlag);

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

      *?   // Move Datastructure Values into File
           Exsr WriteHeader;
           Exsr WriteDetail;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteHeader Subroutine :
      *?            :------------------------:
      *
      *?Logic : Move Data structure fields into file Fields and Write

        Begsr WriteHeader;

      *?   // Open Files
           Open WSPOHDRPF;

      *?   // Get Highest Sequence number from file
SUD01      If Identification.FromOrg_ID = 'Gloeckner';
  |           WkFrmOrgId = %Subst(Identification.FromOrg_ID:1:9);
  |        Else;
  |           WkFrmOrgId = Identification.FromOrg_ID;
SUD01      Endif;
           Setgt WkFrmOrgId  WSPOHDRL0;
           ReadPE WkFrmOrgId WSPOHDRL0;
           If Not %Eof;
             If HPHSEQNO = 999999999;
                HPHSEQNO = 1;
             Else;
                HPHSEQNO += 1;
             Endif;
           Else;
             HPHSEQNO  = 1;
           Endif;

      *?   // Clear Record Format
           Clear WSPOHDRR;
           PHSEQNO = HPHSEQNO;

      *?   // Identification Part
           PHREFID   = Identification.Reference_ID;
           PHIDATE   = Identification.Date;
           PHMSGPR   = Identification.MessageProtocol_ID;
SUD01      PHFRORID  = WkFrmOrgId;
           PHTOORID  = Identification.ToOrg_ID;
           PHSNDORID = Identification.SenderOrg_ID;

      *?   // Order Header Part
           If OrderHeader.RequestedShipDate <> *Blanks;
              PHRQSHDT = %Date(OrderHeader.RequestedShipDate :*Iso);
           Else;
              PHRQSHDT = %Date(WkDate:*Mdy);
           Endif;
           If OrderHeader.BrokerCreatedDate <> *Blanks;
               PHBRKCRDT= %Date(OrderHeader.BrokerCreatedDate : *Iso);
           Else;
               PHBRKCRDT= %Date();
           Endif;
           If OrderHeader.BrokerCreatedTime <> *Blanks;
               PHBRKCRTM= %Time(OrderHeader.BrokerCreatedTime : *Hms);
           Endif;

           PHCUSTPO = OrderHeader.CustomerPONumber;
           PHBKOROK = OrderHeader.BackOrderOK;
           PHVENDID = OrderHeader.VendorOrderID;
           PHAIRCDE = OrderHeader.AirportCode;
           PHBRKUPBY= OrderHeader.BrokerUpdatedBy;
           PHCARRNO = OrderHeader.CarrierNumber;
           PHCARRDS = OrderHeader.CarrierDescription;
           PHHDRCMT = OrderHeader.HeaderComments;
           PHVENDNO = OrderHeader.VendorNumber;
           PHCMINCD = OrderHeader.CommittedInventoryCode;
           PHSHPMTH = OrderHeader.ShipMethod;

      *?   // Order Header - Move ShipMethodDesc to ShipMethod
VV03       If WkFrmOrgId = 'Eason';
 |            PHSHPMTH = OrderHeader.ShipMethodDesc ;
VV03       Endif;
      *
           PHBRKORID= OrderHeader.BrokerOrderID;
           PHFREMTH = OrderHeader.FreightPaymentMethod;
           PHINCTYP = OrderHeader.IncomingType;
           PHSHPINS = OrderHeader.ShippingInstructions;
           PHSUBSOK = OrderHeader.SubstitutionOK;
           PHSALNAM = OrderHeader.SalesRepName;
           PHBRKUPDT= %Date();
           PHORDDAT = %Date();

      *?   // Gloeckner Fields
SUD01      If WkFrmOrgId = 'Gloeckner';
VV01          PHBRKRVN = %Int(OrderHeader.BrokerRevision);
 |            PHRTGSTN = OrderHeader.RootingStation;
 |            PHEXCHNG = OrderHeader.TagExchange;
VV01       Endif;

      *?   // Check Customer PO Exists, If then Move flag as Closed "X"
           Chain (PHFRORID:PHBRKORID) WSPOHDRL1;
           If %Found;
              PHFLAG = 'X';
           Else;
              PHFLAG = *Blanks;
           Endif;

      *?   // Only for Ball PO
           If WkFrmOrgId = 'Ball Seed';
              If OrderHeader.BrokerUpdatedDate <> *Blanks;
                 PHBRKUPDT = %Date(OrderHeader.BrokerUpdatedDate : *Iso);
              Else;
                 PHBRKUPDT= %Date();
              Endif;
              If OrderHeader.BrokerUpdatedTime <> *Blanks;
                 PHBRKUPTM = %Time(OrderHeader.BrokerUpdatedTime : *Hms);
              Endif;

              PHCUSTREF  = OrderHeader.CustomerReference;
              PHTAXEXC   = OrderHeader.TaxExchange;
              PHBRKDELID = OrderHeader.BrokerDeliveryID;
              PHTAGRAT   = OrderHeader.TagRatio;
              PHTAGRATD  = OrderHeader.TagRatioDescription;
              PHPRODWK   = OrderHeader.ProductionWeek;
              PHDISPONM  = OrderHeader.DistributorPONumber;
           Endif;

VV02       If WkFrmOrgId = 'Ball Seed' Or WkFrmOrgId = 'Eason';
 |            If OrderHeader.ChangeOrderBatchNumber <> *Blanks;
 |               PHCHORNO = %Dec(OrderHeader.ChangeOrderBatchNumber:5:0);
 |            Endif;
 |            PHSHPMTHD  = OrderHeader.ShipMethodDesc ;
VV02       Endif;

      *?   // Order Header - Sold To
           PHSLDCON = OrderHeader.SoldTo.SoldToContactName;
           PHSLDEML = OrderHeader.SoldTo.SoldToEmail;
           PHSLDNUM = OrderHeader.SoldTo.BrokerSoldToNumber;
           PHSLDFAX = OrderHeader.SoldTo.SoldToFax;
           PHSLDZIP = OrderHeader.SoldTo.SoldToZip;
           PHSLDAD1 = OrderHeader.SoldTo.SoldToAddress1;
           PHSLDAD2 = OrderHeader.SoldTo.SoldToAddress2;
           PHSLDPHN = OrderHeader.SoldTo.SoldToPhone;
           PHSLDNAM = OrderHeader.SoldTo.SoldToName;
           PHSLDSTE = OrderHeader.SoldTo.SoldToState;
           PHSLDCTY = OrderHeader.SoldTo.SoldToCity;
           PHSLDCNTY= OrderHeader.SoldTo.SoldToCountry;
           PHSLDCNTY3= OrderHeader.SoldTo.SoldToCountry3;    // Ball PO

      *?   // Order Header - Ship To
           PHSHPCON = OrderHeader.ShipTo.ShipToContactName;
           PHSHPEML = OrderHeader.ShipTo.ShipToEmail;
           PHSHPNUM = OrderHeader.ShipTo.BrokerShipToNumber;
           PHSHPFAX = OrderHeader.ShipTo.ShipToFax;
           PHSHPZIP = OrderHeader.ShipTo.ShipToZip;
SUD03      If WkFrmOrgId <> 'Gloeckner';
  |           PHSHPAD1 = OrderHeader.ShipTo.ShipToAddress1;
  |           PHSHPAD2 = OrderHeader.ShipTo.ShipToAddress2;
  |        Else;
  |           PHSHPAD1 = OrderHeader.ShipTo.ShipToAddress2;
  |           PHSHPAD2 = OrderHeader.ShipTo.ShipToAddress1;
SUD03      Endif;
           PHSHPPHN = OrderHeader.ShipTo.ShipToPhone;
           PHSHPNAM = OrderHeader.ShipTo.ShipToName;
           PHSHPSTE = OrderHeader.ShipTo.ShipToState;
           PHSHPCTY = OrderHeader.ShipTo.ShipToCity;
           PHSHPCNTY= OrderHeader.ShipTo.ShipToCountry;
           PHSHPCNTY3= OrderHeader.ShipTo.ShipToCountry3;
           PHSHPNSAD = OrderHeader.ShipTo.ShipToNonStandardAddress;

      *?   // Audit Stamp
           PHCRTDAT = Rundate;
           PHCRTTIM = Runtime;
           PHCRTUSR = User;
           PHCRTJOB = Job;
           PHCRTPGM = Pgm;

      *?   // Write Rec
           Write WSPOHDRR;
           PFromOrgId = PHFRORID;
           PCustPO    = PHBRKORID;
           PSeqno     = PHSEQNO;

      *?   // Close Files
           Close WSPOHDRPF;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteDetail Subroutine :
      *?            :------------------------:
      *
      *?Logic : Move Data structure fields into file Fields and Write

        Begsr WriteDetail;

      *?   // Open Files
           Open WSPODTLPF;

      *?   // Clear Record Format
           Clear WSPODTLR;

      *?   // Move Item List into File
           For x =  1 to %Elem(Item);
              If Item(x).BrokerLineItemNumber <> *Blanks;

      *?         // Identification Part
                 PDREFID   = Identification.Reference_ID;
                 PDIDATE   = Identification.Date;
                 PDMSGPR   = Identification.MessageProtocol_ID;
SUD01            PDFRORID  = WKFrmOrgID;
                 PDTOORID  = Identification.ToOrg_ID;
                 PDSNDORID = Identification.SenderOrg_ID;
                 PDHDRSEQ  = PHSEQNO;
                 PDSEQNO  += 1;

      *?         // Order Detail Part
                 If WkFrmOrgId = 'Griffin';
                    PDCUSTPO = OrderHeader.CustomerPONumber;
                 Endif;
                 PDBRKORID = OrderHeader.BrokerOrderID;
                 If Item(x).BrokerLineItemNumber <> *Blanks;
VV02                PDBRKLNE = %Dec(Item(x).BrokerLineItemNumber :10:0);
                 Endif;
                 If Item(x).OrderedQty <> *Blanks;
                    PDORDQTY = %Dec(Item(x).OrderedQty:11:1);
                 Endif;
SUD01            If Item(x).OrderdQty <> *Blanks;
  |                 PDORDQTY = %Dec(Item(x).OrderdQty:13:1);
SUD01            Endif;
                 If Item(x).LineItemPrice <> *Blanks;
VV01                PDLNITMPR= %Dec(Item(x).LineItemPrice:14:4);
                 Endif;
                 If Item(x).ScheduledShipDate <> *Blanks;
                    PDSCHSHDT= %Date(Item(x).ScheduledShipDate: *Iso);
                 Else;
                    PDSCHSHDT= %Date(WkDate:*Mdy);
                 Endif;

                 PDBRKMAT = %TrimL(Item(x).BrokerMaterialNumber:'0');
                 PDVENMAT = Item(x).VendorMaterialNumber;
                 PDVENDSC = Item(x).MaterialDescription;
                 PDLNITMCM= Item(x).LineItemComment;
                 PDINCTYP = Item(x).IncomingType;
VV02             PDUNTOM  = Item(x).UnitOfMeasure;

      *?         // Only for Gloeckner
SUD01            If WkFrmOrgId = 'Gloeckner';
VV01                PDTAGRATD= Item(x).TagRatioDescription;
SUD01               If Item(x).TagRatioValue <> *Blanks;
VV01                   PDTAGRATV= %Int(Item(x).TagRatioValue);
SUD01               Endif;
VV01                PDVENLNE = %Int(Item(x).VendorLineItemNumber);
VV01             Endif;
                 PDFLAG = PHFLAG;

      *?         // Only for Ball PO
                 If WkFrmOrgId = 'Ball Seed';
                    PDCUSTPO = Item(x).CustomerPONumber;
                    PDCOMINV = Item(x).CommittedInventoryPONumber;
                    PDBRKSALO= Item(x).BrokerSalesOrderID;
                    PDCUSTREF= Item(x).CustomerReference;
                    PDTAGRAT = Item(x).TagRatio;
                    PDTAGRATD= Item(x).TagRatioDescription;
                    PDPLNTCD = Item(x).PlantCode;
                    PDPLNTDS = Item(x).PlantCodeDescription;
                    PDSHPPNT = Item(x).ShippingPoint;
                    PDSHPDS  = Item(x).ShippingPointDescription;
                 Endif;

      *?         // Audit Stamp
                 PDCRTDAT = Rundate;
                 PDCRTTIM = Runtime;
                 PDCRTUSR = User;
                 PDCRTJOB = Job;
                 PDCRTPGM = Pgm;

      *?         // Write Rec
                 Write WSPODTLR;

              Elseif  Item(x).BrokerLineItemNumber = *Blanks;
                 Leave;
              Endif;

           Endfor;

      *?   // Close Files
           Close WSPODTLPF;

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
