      *? Program        : WSPOGETACK
      *?
      *? Description    : This program to Generate Acknowledgement XML
      *?                  using GET method for Create Orders only
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 23 Oct 2017
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *
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
      *?File: Xml Order Header Logical File
      *?Key : From Org ID : Broker Order ID : Order No : Create Date : Time
        Dcl-F WSPOHDRL2 Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Xml Order Detail Logical File
      *?Key : From Org ID : Header Seq No : Detail Seq No
        Dcl-F WSPODTLL1 Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order Header Record
      *?Key : Order Number
        Dcl-F FHORDR Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Order Header Record
      *?Key : Status :  Order Number : Order Seq No
        Dcl-F FIORDRACT  Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number : Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Item Cross Reference  Logical File
      *?Key : Provided Name : Provided Type : Local Key
        Dcl-F XREFINVTL1 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Customer Master File
      *?Key : Customer Code
        Dcl-F FMCUST Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Size Code Master File
      *?Key : Size Code
        Dcl-F FMSIZE Disk(*Ext) Keyed Usage(*Input);
      *
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPOGETACK;
           PFromOrgID   Like(PHFRORID);
           PBrokOrID    Like(PHBRKORID);
           POrderNo     Like(PHORDNO);
           HttpStatus   Int(10:0);
           PBrkAck      Char(1000000) Options(*Varsize);
        End-Pi;
      *
      *?Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname      Char(50)    Value;
           Tagval       Char(300)   Value;
           Info         Char(10)    Value;
        End-Pr;
      *
      *?Declare Data Structure for SQL
         Dcl-Ds WSPOHDRL2DS ExtName('WSPOHDRL2');
         End-Ds;
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
        Dcl-S Xml       Char(1000000) Inz;
        Dcl-S Info      Char(10)    Inz;
        Dcl-S WkDtTm    Char(19)    Inz;
        Dcl-S WkFlag    Char(1)     Inz;
        Dcl-S WkItem    Char(15)    Inz;
        Dcl-S WkDate    Date(*ISO)  Inz;
        Dcl-S WkRqdt    Char(10)    Inz;
        Dcl-S WkCrtDat  Packed(7) Inz;
        Dcl-S WkCrtTim  Packed(6) Inz;
        Dcl-S WkOQty  Zoned(11:2) Inz;                // Used for Qty Conversion
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

      *?   // Clear XML
           Clear PBrkAck;

      *?   // Get Date and Time
           WkDtTm = %Char(%Date) + 'T' + %Char(%Time());

      *?   // Excute Process
           Exsr Process;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

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

      *?   // Check Record Exists with Flag "C" or "P" and Process
         Exec SQL
             DECLARE  C1 cursor for
             Select   * from WSPOHDRL2
             where    (PHFLAG='C' or PHFLAG='P') AND PHFRORID = :PFromOrgID
             AND PHBRKORID = :PBrokOrId AND PHORDNO = :POrderNo
             ORDER BY PHFRORID, PHBRKORID, PHORDNO,
                      PHCRTDAT, PHCRTTIM desc
             Fetch first Row Only;

      *?   // Open the SQL recordset
          exec sql
             Open C1  ;

          If SqlCode = -502;
             Exec Sql Close C1;
             Exec Sql Open C1;
          Endif;

      *?   // Read the SQL recordset
          Exec Sql Fetch C1 Into :WspoHdrl2Ds;
          If  SQLCODE = 100   ;
      *?   // Order not found message
              Httpstatus = 400;
          Else;

            If PHFLAG = 'C' Or PHFLAG = 'P';
              WkCrtDat = PHCRTDAT;
              WkCrtTim = PHCRTTIM;
      *?         // Start Tag
                 AddToXml('BrokerAcknowledgement' : *Blanks : 'Starttag');

      *?         // XML Body
                 Exsr IdentificationSR;
                 Exsr OrderHeaderSR;
                 Exsr OrderDetailSR;

      *?         // Update Process Flag Processed with Audit Stamp
         Chain (PFromOrgID:PBrokOrId:POrderNo:WkCrtDat:WkCrtTim) WspoHdrl2;
                 If %found(WspoHdrL2) ;
                    PHFLAG   = 'P';
                    Exsr WSHdrAudit;
                    Update WSPOHDRR %Fields(PHFLAG:PHUPDDAT:PHUPDTIM
                                             :PHUPDUSR:PHUPDJOB:PHUPDPGM);
                 Endif;

      *?         // End Tag
                 AddToXml('BrokerAcknowledgement' : *Blanks : 'Endtag');

      *?         // Return Xml
                 Httpstatus = 200;
                 Xml = %ScanRpl('&': '&amp;': xml);
                 PBrkack = Xml;

              Elseif PHFLAG = 'E';
                 Httpstatus = 200;
                 PBrkAck = 'Record marked as a Error Exception';
              Elseif PHFLAG = ' ';
                 Httpstatus = 200;
                 PBrkAck = 'Order not yet created';
              Endif;

           Endif;

         exec sql
          Close C1 ;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : IdentificationSR Subroutine :
      *?                :-----------------------------:
      *
        Begsr IdentificationSR;

      *?   // Move values into Identification Part
           AddToXml('Identification' : *Blanks : 'Opentag');
           AddToXml('MessageProtocol_ID' : 'BrokerAcknowledgement':'Attribute');

      *?   // Move values into FromOrId from Parameter File
           If PHFRORID = 'Griffin';
              Chain ('2386':'FromOrgId') FBrokDftL0;
           Elseif PHFRORID = 'Ball Seed';
              Chain ('1533':'FromOrgId') FBrokDftL0;
           Endif;

           If %Found;
              AddToXml('FromOrg_ID' : %Trim(DFVARVAL): 'Attribute');
           Endif;

      *?   // Move values into ToOrgId from Parameter File
           If PHFRORID = 'Griffin';
              Chain ('2386':'ToOrgId') FBrokDftL0;
           Elseif PHFRORID = 'Ball Seed';
              Chain ('1533':'ToOrgId') FBrokDftL0;
           Endif;

           If %Found;
              AddToXml('ToOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
              AddToXml('SenderOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
           Endif;
           AddToXml('Date' : WkDtTm : 'Closetag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : OrderHeaderSR Subroutine :
      *?                :--------------------------:
      *
        Begsr OrderHeaderSR;

      *?   // Move values into OrderHeader Part
           AddToXml('OrderHeader' : *Blanks : 'Opentag');

      *?   // Move Values from FHORDR
           Chain PHORDNO FHORDR;
           If %Found;
              AddToXml('AcknowledgementType' : OHSTAT : 'Attribute');
              AddToXml('VendorOrderID' : %Char(OHORD#) : 'Attribute');
           Endif;

      *?   // Move other values only for Ball
           If PHFRORID = 'Ball Seed';
              AddToXml('AirportCode' : PHAIRCDE : 'Attribute');
              AddToXml('BrokerCreatedTime' : %Char(PHBRKCRTM) : 'Attribute');
              AddToXml('BrokerUpdatedTime' : %Char(PHBRKUPTM) : 'Attribute');
              AddToXml('BrokerUpdatedDate' : %Char(PHBRKUPDT) : 'Attribute');
              AddToXml('BrokerUpdatedBy' : PHBRKUPBY : 'Attribute');
              AddToXml('RejectionStatus' : *Blanks : 'Attribute');
              AddToXml('ShippingMethodDesc' : PHSHPMTHD : 'Attribute');
              AddToXml('HeaderComments' : PHHDRCMT : 'Attribute');
              AddToXml('CarrierNumber' : PHCARRNO : 'Attribute');
              AddToXml('ChangeOrderBatchNumber' : %Char(PHCHORNO): 'Attribute');
              AddToXml('CustomerReference' : *Blanks : 'Attribute');
              AddToXml('CommittedInventoryCode' : PHCMINCD : 'Attribute');
           Endif;

      *?   // Common for Griffin and Ball
           AddToXml('CustomerPONumber' : PHCUSTPO : 'Attribute');
           AddToXml('BackOrderOK' : PHBKOROK : 'Attribute');
           AddToXml('OverAllProcessStatus' : PHFLAG : 'Attribute');
           AddToXml('RequestedShipDate' : %Char(PHRQSHDT) : 'Attribute');
           AddToXml('BrokerCreatedDate' : %Char(PHBRKCRDT) : 'Attribute');
           AddToXml('VendorNumber' : PHVENDNO : 'Attribute');
           AddToXml('ShipMethod' : OHSHPC : 'Attribute');
           AddToXml('BrokerOrderID' : PHBRKORID : 'Attribute');
           AddToXml('FreightPaymentMethod' : PHFREMTH : 'Attribute');
           AddToXml('ShippingInstructions' : PHSHPINS : 'Attribute');
           AddToXml('SubstitutionOK' : PHSUBSOK : 'Close');

           Exsr ShipToSR;
           Exsr SoldToSR;

           AddToXml('OrderHeader' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : SoldTo Subroutine :
      *?                :-------------------:
      *
        Begsr SoldToSR;

      *?   // Check Record in Order Header File
           Chain PHORDNO FHORDR;
           If %Found;

      *?      // Move values into SoldTo tags from Order File
              AddToXml('SoldTo' : *Blanks : 'Opentag');
              AddToXml('SoldToName' : OHSLD1 : 'Attribute');
              AddToXml('SoldToAddress1' : OHSLD2 : 'Attribute');
              AddToXml('SoldToAddress2' : OHSLD3 : 'Attribute');
              AddToXml('SoldToState' : OHSLST : 'Attribute');
              AddToXml('SoldToCity' : OHSLCT : 'Attribute');
              AddToXml('SoldToZip' : OHSLZP : 'Attribute');
           Endif;

      *?   // Move values into SoldTo tags from Xml Xref Order File
           If PHFRORID = 'Ball Seed';
              AddToXml('BrokerSoldToNumber' : %Char(OHBLCU) : 'Attribute');
           Endif;
      *?   // Move values into SoldTo tags from Customer Master File
           Chain OHCUST FMCUST;
           AddToXml('SoldToContactName' : OHSLD1 : 'Attribute');
           AddToXml('SoldToCountry' : CMCOUN : 'Attribute');
           AddToXml('SoldToPhone' : %Char(CMPHON) : 'Attribute');
           AddToXml('SoldToFax' : PHSLDFAX : 'Attribute');
           AddToXml('SoldToEmail' : PHSLDEML : 'Closetag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : ShipTo Subroutine :
      *?                :-------------------:
      *
        Begsr ShipToSR;

      *?   // Move values into ShipTo tags from Xml Xref Order File
           AddToXml('ShipTo' : *Blanks : 'Opentag');

           If PHFRORID = 'Ball Seed';
              AddToXml('ShipToNonStandardAddress' : PHSHPNSAD : 'Attribute');
           Endif;
           AddToXml('ShipToContactName': PHSHPCON : 'Attribute');
           AddToXml('ShipToName' : PHSHPNAM : 'Attribute');
           AddToXml('BrokerShipToNumber' : PHSHPNUM : 'Attribute');
           AddToXml('ShipToAddress1' : PHSHPAD1 : 'Attribute');
           AddToXml('ShipToAddress2' : PHSHPAD2 : 'Attribute');
           AddToXml('ShipToState' : PHSHPSTE : 'Attribute');
           AddToXml('ShipToCity' : PHSHPCTY : 'Attribute');
           AddToXml('ShipToCountry ' : PHSHPCNTY : 'Attribute');
           AddToXml('ShipToZip' : PHSHPZIP : 'Attribute');
           AddToXml('ShipToFax' : PHSHPFAX : 'Attribute');
           AddToXml('ShipToPhone' : PHSHPPHN : 'Attribute');
           AddToXml('ShipToEmail' : PHSHPEML : 'Closetag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : OrderDetailSR Subroutine :
      *?                :--------------------------:
      *
        Begsr OrderDetailSR;

      *?   // Move values into Detail tags from Xml Xref Order File
           AddToXml('OrderDetails' : *Blanks : 'Starttag');

      *?   // Execute Item Part
           Exsr ItemSR;
           AddToXml('OrderDetails' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : ItemSR Subroutine :
      *?                :-------------------:
      *
        Begsr ItemSR;

      *?   // Check Record Exists with Flag "C"/"P" and Process
      *?   // Check Order Detail to get all records that were entered manually
           Setll ('A':PHORDNO) FIORDRACT;
           ReadE ('A':PHORDNO) FIORDRACT;
           Dow Not %Eof;
               AddToXml('Item': *Blanks : 'Opentag');

      *?   // Convert quantity to Broker Quantity
                 WkOQty = *Zeros;
                 Chain OISIZE FMSIZE;
                   If %Found and SZSTAT = 'A';
                     WkOQty = OIQORD * SZSALE;
                   Else;
                     WkOQty = OIQORD;
                 Endif;

               AddToXml('ConfirmedQty' : %Char(WkOQty) : 'Attribute');
               AddToXml('RejectionCode' : 'N' : 'Attribute');   //??
               IF OIDTRQ < OHDTRQ;
                  WkDate = %Date(OHDTRQ:*mdy);
                  WkRqDt = %Char(WkDate);
                  AddToXml('ScheduledShipDate': WkRqDt:
                                                     'Attribute');
               Else;
                  WkDate = %Date(OIDTRQ:*mdy);
                  WkRqDt = %Char(WkDate);
                  AddToXml('ScheduledShipDate': WkRqDt :
                                                     'Attribute');
               Endif;

            Chain (PFromOrgID:PHBRKORID:PHSEQNO:PHORDNO:OISEQ#) WSPODTLL1;
              If %Found;
                If PDFLAG = 'C' Or PDFLAG = 'P';

      *?         // Move values into Item tags from Xml Xref Order File
                 AddToXml('BrokerLineItemNumber' : %Char(PDBRKLNE):'Attribute');
                 AddToXml('BrokerMaterialNumber' : PDBRKMAT : 'Attribute');
                 AddToXml('CommittedInventryPONumber' : PDCOMINV : 'Attribute');
                 AddToXml('LineItemComment' : PDLNITMCM : 'Attribute');
                 AddToXml('LineItemStatus' : PDFLAG : 'Attribute');
                 AddToXml('MaterialDescription' : PDVENMAT : 'Attribute');
                 AddToXml('OrderdQty' : %Char(PDORDQTY) : 'Attribute');
                 If PHFRORID = 'Ball Seed';
                    AddToXml('LineItemPrice' : %Char(PDLNITMPR) : 'Attribute');
                    AddToXml('UnitofMeasure' : OIUUOM : 'Attribute');
                    AddToXml('SubbedBrokerMaterial' : *Blanks : 'Attribute');
                 Endif;
                 AddToXml('VendorMaterialNumber' : PDVENMAT : 'Closetag');

      *?      // Update Flag in XML Order Detail File ("C" - Created)
              If PDFlag = 'C';
                 PDFlag = 'P';
                 Exsr WSDtlAudit;
                 Update WSPODTLR %Fields(PDFLAG:PDUPDDAT:PDUPDTIM:
                                         PDUPDUSR:PDUPDJOB:PDUPDPGM);
              Endif;
            Endif;
      *?      // If record not found in XML Detail File
            Else;
                 AddToXml('BrokerLineItemNumber' : *Blanks :'Attribute');
      *?      // Read Cross Reference to get Broker Material ID for new lines
                 WkItem = OIITEM + OISIZE;
                 Chain (PHFRORID : 'Customer' :WkItem) XREFINVTL1;

                 AddToXml('BrokerMaterialNumber' : XRFORKEY : 'Attribute');
                 AddToXml('MaterialDescription' : XRDESC : 'Attribute');
                 AddToXml('CommittedInventryPONumber' : PHBRKORID: 'Attribute');
                 AddToXml('LineItemComment' : *Blanks : 'Attribute');
                 AddToXml('LineItemStatus' : *Blanks : 'Attribute');
                 AddToXml('OrderdQty' : *Blanks  : 'Attribute');
                 If PHFRORID = 'Ball Seed';
                    AddToXml('LineItemPrice' : *Blanks  : 'Attribute');
                    AddToXml('UnitofMeasure' : OIUUOM : 'Attribute');
                    AddToXml('SubbedBrokerMaterial' : *Blanks : 'Attribute');
                 Endif;
                 AddToXml('VendorMaterialNumber' : *Blanks : 'Closetag');
              Endif;

            ReadE ('A': PHORDNO) FIORDRACT;
           Enddo;

        EndSr;
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

            Endsl;

        End-Proc;
      *?------------- End of Program ----------------------------------
