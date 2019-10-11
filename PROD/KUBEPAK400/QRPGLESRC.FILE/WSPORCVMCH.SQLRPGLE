      *? Program        : WSPORCVMCH
      *?
      *? Description    : This pgm to Consume PO/CO XML into RPG , Process
      *?                  and send back Response for Michell
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 24 Apr 2018
      //--------------------------------------------------------------------
      *? Special Notes  :** XML response only for Successful PO Creation
      *?                 ** For Unsuccessful Order Will marked as Exception
      *?                 ** Check PO Unique and then Write Record
      *?                 ** As tag same in both Create and Change Order
      *?                    Check in Broker_Status to Get Type Of Order
      *
      *? Called Program : WSPOVAL002 - WS - XML File Validation and Order Creation
      *?                  WSPOACKMCH - WS - Acknowledgment Process for Michell
      *?                  WSCOVAL002 - WS - Validation XML for Change Order
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
      *
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
      *?Key : From Org Id:Customer Po:Sequence Number
        Dcl-F WSPOHDRL0  Disk(*Ext) Keyed Usage(*Input) Rename(WSPOHDRR:Rec1)
                                                       Prefix(H);
      *?File: WS - XML Order Create Header Logical File
      *?Key : From Org Id:Customer PO:Sequence Number
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Input) Rename(WSPOHDRR:Rec2)
                                                       Prefix(I);
      *?File: WS - XML Order Create Detail File
        Dcl-F WSPODTLPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File : WS -XML Change Order Header File
        Dcl-F WSCOHDRPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File : WS - XML Change Order Header Logical File
      *?Key : From Org Id:Sequence Number
        Dcl-F WSCOHDRL0  Disk(*Ext) Keyed Usage(*Input) Rename(WSCOHDRR:Rec3)
                                                       Prefix(H);
      *?Key : From Org Id:Customer PO:Sequence Number
        Dcl-F WSCOHDRL1  Disk(*Ext) Keyed Usage(*Input) Rename(WSCOHDRR:Rec4)
                                                       Prefix(I);
      *?File : WS Change Order Detail File
        Dcl-F WSCODTLPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File: Cross Reference File for FMINVT
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFINVTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - WS - XML Order Change Control Logical File
      *?Key : From Org Id:Broker Order Id:Order #:Item:Size:BrkItem:BrkSize
        Dcl-F WSORCHCL2  Disk(*Ext) Keyed Usage(*Input:*Update);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSORDER001)
        Dcl-Pi WSPORCVMCH;
           POXml      Char(1000000) Options(*Varsize);
           Httpstatus Int(10:0);
           Acknowledgement Like(PBrkAck);
        End-Pi;
      *
      *?Procedure Prototype Declaration : PO Validation Program
        Dcl-Pr WSPOVAL002 Extpgm;
           PFromOrgId Like(PFromOrgId);
           PCustPO    Like(PCustPO);
           PSeqno     Like(PSeqno);
           PFlag      Like(PFlag);
        End-Pr;
      *
      *?Procedure Prototype Declaration : CO Validation Program
        Dcl-Pr WSCOVAL002 Extpgm;
           PFromOrgId Like(PFromOrgId);
           PCustPO    Like(PCustPO);
           PSeqno     Like(PSeqno);
           PFlag      Like(PFlag);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Acknowledgement Program
        Dcl-Pr WSPOACKMCH Extpgm;
           PFromOrgId Like(PFromOrgId);
           PCustPO    Like(PCustPO);
           PSeqno     Like(PSeqno);
           PBrkAck    Char(1000000);
           PPrFlag    Char(2);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Store XML into IFS
        Dcl-Pr WSSTOREXML Extpgm;
          PXml       Char(9999999) Options(*Varsize);
          PFromOrgId Like(PFromOrgId);
          PCustPO    Like(PCustPO);
          POFLag     Char(10);
        End-Pr;
      *
      *?Data Structure Declaration      : Identification
        Dcl-Ds Identification Qualified;
           Reference_ID         Char(30);
           Date                 Char(10);
           MessageProtocol_ID   Char(30);
           FromOrg_ID           Char(30);
           ToOrg_ID             Char(30);
           SenderOrg_ID         Char(30);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderHeader
        Dcl-Ds OrderHeader    Qualified;
           CustomerPO              Char(35);
           BackOrderOK             Char(1);
           Vendor_Order_ID         Char(30);
           Requested_Ship_Date     Char(10);
           ShipMethod_Code         Char(30);
           ShipMethod_Name         Char(30);
           Broker_Order_ID         Char(10);
           FreightPaymentMethod    Char(30);
           Order_Instructions      Char(50);
           SubstitutionsOK         Char(1);
           Broker_Sales_Rep_Name   Char(30);
           Total_Line_Items        Char(6);
           Total_Qty               Char(13);
           Order_Date              Char(10);
           Broker_Customer_ID      Char(10);
           Broker_Sales_Rep_ID     Char(10);
           Broker_Vendor_ID        Char(10);
           Broker_Status           Char(15);
           Broker_CustomerName     Char(30);
           SoldTo LikeDS(SoldTo);
           ShipTo LikeDs(ShipTo);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderHeader/Sold To
        Dcl-Ds SoldTo    Qualified;
           Broker_Customer_ID  Char(12);
           Name                Char(40);
           Contact             Char(40);
           Address_Line_1      Char(40);
           Address_Line_2      Char(40);
           City                Char(35);
           State               Char(3);
           Postal_Code         Char(10);
           Country             Char(3);
           Fax                 Char(31);
           Phone               Char(18);
           Email               Char(50);
           Vendor_Customer_ID  Char(20);
           Broker_Address_ID   Char(20);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderHeader/Ship To
        Dcl-Ds ShipTo    Qualified;
           Broker_Customer_ID  Char(24);
           Name                Char(40);
           Contact             Char(40);
           Address_Line_1      Char(40);
           Address_Line_2      Char(40);
           City                Char(35);
           State               Char(3);
           Country             Char(3);
           Postal_Code         Char(10);
           Fax                 Char(31);
           Phone               Char(18);
           Email               Char(50);
           Broker_Address_ID   Char(20);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderDetails/Item
        Dcl-Ds Item Qualified Dim(9999);
           Broker_Material       Char(24);
           Vendor_Material       Char(35);
           Material_Description  Char(45);
           LineNumber            Char(6);
           Qty_Ordered           Char(13);
           Scheduled_Ship_Date   Char(10);
           Material_Description2 Char(45);
           Qty_Confirmed         Char(13);
           Status                Char(15);
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
        Dcl-S X       Int(5:0);
      *
      *?Work Variable Declaration       :
        Dcl-S WkFrmOrgId   Like(CHFRORID);
        Dcl-S WkBrokerId   Like(CHBRKORID);
        Dcl-S WkBrkItem    Like(CDBRKMAT);
        Dcl-S WkLineItemNo Like(CDBRKLNE);
        Dcl-S WkOrder      Like(CHORDNO);
        Dcl-S WkOrdLin     Like(CDORDLIN);
        Dcl-S WkSeq        Like(CHSEQNO);
        Dcl-S WkItem       Char(12);
        Dcl-S WkSize       Char(3);
        Dcl-S WkChgFlag    Char(1)   Inz('N');
        Dcl-S WkState      Char(1);
        Dcl-S WkDate       Zoned(6);
      *
      *?Function Variable Declaration   :
        Dcl-S ThisMonday  Zoned(6) Inz;
        Dcl-S Today       Date;
      *
      *?Parameter Variable Declaration  :
        Dcl-S PBrkAck    Char(1000000) Inz;
        Dcl-S PXml       Char(9999999) Inz;
        Dcl-S POFlag     Char(10);
        Dcl-S PrFlag     Char(2);
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

      *?   // If Order Create XML
           If WkChgFlag = 'N';

      *?      // If HttpStatus is Success, Call Validate Program
              If Httpstatus = 200 and PHFLAG = ' ';
                 PrFlag = 'PO';
                 WSPOVAL002(PFromOrgId:PCustPO:PSeqno:PFlag);
                 If PFlag = 'C';

      *?            // Process Flag is 'C', Call XML Generate Program
                    WSPOACKMCH(PFromOrgId:PCustPO:PSeqno:PBrkAck:PrFlag);
                    Acknowledgement = PBrkAck;

      *?         // Error Status
                 Elseif PFlag = 'E';
                    Acknowledgement = 'Order Placed with Error for PO :'
                                      + PCustPO + ' Please contact KubePak';
                 Endif;
              Elseif Httpstatus = 200 and PHFLAG = 'X';

      *?         // Close the Order
                 Acknowledgement = 'Duplicate Customer PO: ' + PHBRKORID +
                                      '- Order Closed';
              Endif;

      *?   // If Order Change XML
           Elseif WkChgFlag = 'Y';

      *?      // If HttpStatus is Success, Call Validate Program
              If Httpstatus = 200 and CHFLAG = ' ';
                 PrFlag = 'CO';
                 WSCOVAL002(PFromOrgId:PCustPO:PSeqno:PFlag);
                 If PFlag = 'C';

      *?            // Process Flag is 'C', Call XML Generate Program
                    WSPOACKMCH(PFromOrgId:PCustPO:PSeqno:PBrkAck:PrFlag);
                    Acknowledgement = PBrkAck;

      *?         // Error Status
                 Elseif PFlag = 'E';
                    Acknowledgement = 'Change Order Placed with Error for PO :'
                                        + PCustPO + ' Please contact KubePak';
                 Elseif PFlag = 'X';
                    Chain (PFromOrgId:PCustPO) WSPOHDRL1;
                    If %Found;

      *?               // If PO Creation in Exception
                       If IPHFLAG = 'E';
                          Acknowledgement = 'Order Change Received.' +
                                      'Acknowledgement will be sent shortly';
                       Elseif IPHFLAG = 'P' Or IPHFLAG = 'C';
                          WkOrder = IPHORDNO;
                          Exec SQL
                             Select OHSTAT into :WkState from FHORDR
                             Where OHORD# = :WKOrder;

      *?                  // If Order Not Active in FHORDR
                          If WkState <> 'A';
                             Acknowledgement = 'Order not active.' +
                                            'Please call Kube-Pak';

      *?                  // If Order Not eligible to change
      *?                  // If Order with OISEQ# = '0' in Control File
                          Else;
                             Acknowledgement = 'Order preparing for shipment ' +
                                        'and not eligible for change.' +
                                            'Please call Kube-Pak';
                          Endif;
                       Endif;
                    Endif;
                 Else;

      *?            // Order not found in PO XML file
                    Acknowledgement = 'Order Not Available for the PO:' +
                           PCustPo + '.Please call Kube-Pak';
                 Endif;
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

      *?   // Clear DataStructure
           Clear Identification;
           Clear OrderHeader;
           Clear SoldTo;
           Clear ShipTo;
           Clear OrderDetails;
           Clear Item;

      *?   // Clear Variables
           Clear Options;
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

      *?   // Replace Special Character with Equivalent Value
           POXML = %ScanRpl('&' : '&amp;': POXML);

      *?   // Call Subroutine to process Xml Data
           Exsr Process;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Store Receive XML into IFS
           If PrFlag = 'PO';
              POFlag = 'Create';
           Elseif PrFlag = 'CO';
              POFlag = 'Change';
           Endif;
           PXml = POXML;
           WSSTOREXML(PXML:PFromOrgId:PCustPO:POFlag);

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

      *?   // Identification Data Structure
           Options = 'path=MichellPurchaseOrder_V2/Identification +
                      allowextra=yes allowmissing=yes          +
                      case=any doc=string ';

           Xml-Into Identification %XML(POXml:Options);

      *?   // OrderHeader Data Structure
           Options = 'path=MichellPurchaseOrder_V2/OrderHeader +
                      allowextra=yes allowmissing=yes       +
                      case=any doc=string ';

           Xml-Into OrderHeader %XML(POXml:Options);

      *?   // OrderHeader/SoldTo Data Structure
           Options = 'path=MichellPurchaseOrder_V2/OrderHeader/SoldTo +
                         allowextra=yes allowmissing=yes              +
                         case=any doc=string ';

           Xml-Into SoldTo %XML(POXml:Options);

      *?   // OrderHeader/ShipTo Data Structure
           Options = 'path=MichellPurchaseOrder_V2/OrderHeader/ShipTo +
                      allowextra=yes allowmissing=yes              +
                      case=any doc=string ';

           Xml-Into ShipTo %XML(POXml:Options);

      *?   // OrderDetails/Item Data Structure
           Options = 'path=MichellPurchaseOrder_V2/OrderDetails/Item  +
                      allowextra=yes allowmissing=yes +
                      case=any  doc=string';

           Xml-Into Item %XML(POXml:Options);

      *?   // Check Input XML Order Type
           Exsr ChkOrdType;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : ChkOrdType Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Check the XML is Order Create Or Change Order

        Begsr ChkOrdType;

      *?   // Check the XML is Order Create Or Change Order
           If OrderHeader.Broker_Status = 'Open_Order';       // Order Create

      *?      // Move Datastructure Values into PO File
              Exsr WriteHeader;
              Exsr WriteDetail;
              WKChgFlag = 'N';

           Elseif OrderHeader.Broker_Status = 'Change_Ord' Or  // Change Order
                  OrderHeader.Broker_Status = 'Change_ord';

      *?      // Get POXML Header file
              Exsr GetHeader;

      *?      // Move Datastructure Values into CO File
              Exsr WriteHeaderCO;
              Exsr WriteDetailCO;
              WKChgFlag = 'Y';
           Endif;

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

      *?   // Clear Record Format
           Clear WSPOHDRR;

      *?   // Get Highest Sequence number from file
           Setgt ('Michell') WSPOHDRL0;
           ReadPE ('Michell') WSPOHDRL0;
           If Not %Eof;
             If HPHSEQNO = 999999999;
                HPHSEQNO = 1;
             Else;
                HPHSEQNO += 1;
             Endif;
           Else;
             HPHSEQNO  = 1;
           Endif;
           PHSEQNO = HPHSEQNO;

      *?   // Identification Part
           PHREFID   = Identification.Reference_ID;
           PHIDATE   = Identification.Date;
           PHMSGPR   = Identification.MessageProtocol_ID;
           PHFRORID  = Identification.FromOrg_ID;
           PHTOORID  = Identification.ToOrg_ID;
           PHSNDORID = Identification.SenderOrg_ID;

      *?   // Order Header Part
           If OrderHeader.Requested_Ship_Date <> *Blanks;
              PHRQSHDT = %Date(OrderHeader.Requested_Ship_Date :*Iso);
           Else;
              PHRQSHDT = %Date(WkDate:*Mdy);
           Endif;
           If OrderHeader.Order_Date <> *Blanks;
              PHORDDAT = %Date(OrderHeader.Order_Date);
           Else;
              PHORDDAT = %Date(WkDate:*Mdy);
           Endif;
           If OrderHeader.Total_Line_Items <> *Blanks;
              PHLNITMN = %Int(OrderHeader.Total_Line_Items);
           Endif;
           If OrderHeader.Total_Qty <> *Blanks;
              PHTOTQTY = %Dec(OrderHeader.Total_Qty:13:1);
           Endif;

           PHBRKCRDT= %Date(WkDate:*Mdy);                         // Added for Sql Purpose
           PHBRKUPDT= %Date(WkDate:*Mdy);                         // Added for Sql Purpose
           PHCUSTPO = OrderHeader.CustomerPO;
           PHBKOROK = OrderHeader.BackOrderOK;
           PHVENDID = OrderHeader.Vendor_Order_ID;
           PHSHPMTH = OrderHeader.ShipMethod_Code;
           PHSHPMTHD= OrderHeader.ShipMethod_Name;
           PHBRKORID= OrderHeader.Broker_Order_ID;
           PHFREMTH = OrderHeader.FreightPaymentMethod;
           PHSHPINS = OrderHeader.Order_Instructions;
           PHSUBSOK = OrderHeader.SubstitutionsOK;
           PHSALNAM = OrderHeader.Broker_Sales_Rep_Name;
           PHBRKCID = OrderHeader.Broker_Customer_ID;
           PHSALID  = OrderHeader.Broker_Sales_Rep_ID;
           PHVENID  = OrderHeader.Broker_Vendor_ID;
           PHBRKSTS = OrderHeader.Broker_Status;
           PHCUSNAM = OrderHeader.Broker_CustomerName;

      *?   // Check Customer PO Exists, If then Move flag as Closed "X"
           Chain (PHFRORID:PHBRKORID) WSPOHDRL1;
           If %Found;
              PHFLAG   = 'X';
           Else;
              PHFLAG   = *Blanks;
           Endif;

      *?   // Order Header - Sold To
           PHSLDNUM = OrderHeader.SoldTo.Broker_Customer_ID;
           PHSLDNAM = OrderHeader.SoldTo.Name;
           PHSLDCON = OrderHeader.SoldTo.Contact;
           PHSLDAD1 = OrderHeader.SoldTo.Address_Line_1;
           PHSLDAD2 = OrderHeader.SoldTo.Address_Line_2;
           PHSLDCTY = OrderHeader.SoldTo.City;
           PHSLDSTE = OrderHeader.SoldTo.State;
           PHSLDZIP = OrderHeader.SoldTo.Postal_Code;
           PHSLDCNTY= OrderHeader.SoldTo.Country;
           PHSLDFAX = OrderHeader.SoldTo.Fax;
           PHSLDPHN = OrderHeader.SoldTo.Phone;
           PHSLDEML = OrderHeader.SoldTo.Email;
           PHSLDBADR= OrderHeader.SoldTo.Broker_Address_ID;
           PHVENCUSID = OrderHeader.SoldTo.Vendor_Customer_ID;

      *?   // Order Header - Ship To
           PHSHPNUM = OrderHeader.ShipTo.Broker_Customer_ID;
           PHSHPNAM = OrderHeader.ShipTo.Name;
           PHSHPCON = OrderHeader.ShipTo.Contact;
           PHSHPAD1 = OrderHeader.ShipTo.Address_Line_1;
           PHSHPAD2 = OrderHeader.ShipTo.Address_Line_2;
           PHSHPCTY = OrderHeader.ShipTo.City;
           PHSHPSTE = OrderHeader.ShipTo.State;
           PHSHPCNTY= OrderHeader.ShipTo.Country;
           PHSHPZIP = OrderHeader.ShipTo.Postal_Code;
           PHSHPFAX = OrderHeader.ShipTo.Fax;
           PHSHPPHN = OrderHeader.ShipTo.Phone;
           PHSHPEML = OrderHeader.ShipTo.Email;
           PHSHPBADR= OrderHeader.ShipTo.Broker_Address_ID;

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
              If Item(x).LineNumber <> *Blanks;

      *?         // Identification Part
                 PDREFID   = Identification.Reference_ID;
                 PDIDATE   = Identification.Date;
                 PDMSGPR   = Identification.MessageProtocol_ID;
                 PDFRORID  = Identification.FromOrg_ID;
                 PDTOORID  = Identification.ToOrg_ID;
                 PDSNDORID = Identification.SenderOrg_ID;
                 PDHDRSEQ  = PHSEQNO;
                 PDSEQNO  += 1;

      *?         // Order Detail Part
                 PDCUSTPO = OrderHeader.CustomerPO;
                 PDBRKORID = OrderHeader.Broker_Order_ID;
                 If Item(x).LineNumber <> *Blanks;
                    PDBRKLNE = %Dec(Item(x).LineNumber :6:0);
                 Endif;
                 If Item(x).Qty_Ordered <> *Blanks;
                    PDORDQTY = %Dec(Item(x).Qty_Ordered:13:1);
                 Endif;
                 If Item(x).Scheduled_Ship_Date <> *Blanks;
                    PDSCHSHDT= %Date(Item(x).Scheduled_Ship_Date: *Iso);
                 Else;
                    PDSCHSHDT= %Date(WkDate:*Mdy);
                 Endif;
                 If Item(x).Qty_Confirmed <> *Blanks;
                    PDQTYCD  = %Dec(Item(x).Qty_Confirmed:13:1);
                 Endif;

                 PDBRKMAT = %TrimL(Item(x).Broker_Material:'0');
                 PDVENMAT = Item(x).Vendor_Material;
                 PDVENDSC = Item(x).Material_Description;
                 PDVENDSC2= Item(x).Material_Description2;
                 PDINCTYP = Item(x).Status;
                 PDFLAG   = PHFLAG;

      *?         // Audit Stamp
                 PDCRTDAT = Rundate;
                 PDCRTTIM = Runtime;
                 PDCRTUSR = User;
                 PDCRTJOB = Job;
                 PDCRTPGM = Pgm;

      *?         // Write Rec
                 Write WSPODTLR;

              Elseif  Item(x).LineNumber = *Blanks;
                 Leave;
              Endif;

           Endfor;

      *?   // Close Files
           Close WSPODTLPF;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : GetHeader Subroutine :
      *?            :----------------------:
      *
      *?Logic : Get the PO XML header file details using SQL

        Begsr GetHeader;

      *?   // Get FromOrgID & BrokerOrderId from Data Structure
           WkFrmOrgId = Identification.FromOrg_ID;
           WkBrokerId = OrderHeader.Broker_Order_ID;

      *?   // Check Record Exists with Flag "C" or "P" and Process
           Exec SQL
              Select PHORDNO,PHSEQNO Into :WkOrder, :WkSeq from WSPOHDRPF
              Where (PHFLAG='C' or PHFLAG='P')  And PHFRORID = :WkFrmOrgID And
              PHBRKORID = :WkBrokerID
              Fetch first row only;

        Endsr;
      //--------------------------------------------------------------------
      *?            :--------------------------:
      *?            : WriteHeaderCO Subroutine :
      *?            :--------------------------:
      *
      *?Logic : Move Data structure fields into file fields and Write

        Begsr WriteHeaderCO;

      *?   // Open Files
           Open WSCOHDRPF;

      *?   // Clear Record Format
           Clear WSCOHDRR;

      *?   // Get Highest Sequence Number
           Setgt ('Michell') WSCOHDRL0;
           ReadPE ('Michell') WSCOHDRL0;
           If Not %Eof;
             If HCHSEQNO = 999999999;
                HCHSEQNO = 1;
             Else;
                HCHSEQNO += 1;
             Endif;
           Else;
             HCHSEQNO  = 1;
           Endif;
           CHSEQNO   = HCHSEQNO;

      *?   // Identification Part
           CHREFID   = Identification.Reference_ID;
           CHIDATE   = Identification.Date;
           CHMSGPR   = Identification.MessageProtocol_Id;
           CHFRORID  = Identification.FromOrg_ID;
           CHTOORID  = Identification.ToOrg_ID;
           CHSNDORID = Identification.SenderOrg_ID;

      *?   // Order Header Part
           If OrderHeader.Requested_Ship_Date <> *Blanks;
              CHRQSHDT = %Date(OrderHeader.Requested_Ship_Date :*Iso);
           Else;
              CHRQSHDT = %Date(WkDate:*Mdy);
           Endif;
           If OrderHeader.Order_Date <> *Blanks;
              CHORDDAT = %Date(OrderHeader.Order_Date);
           Else;
              CHORDDAT = %Date(WkDate:*Mdy);
           Endif;
           If OrderHeader.Total_Line_Items <> *Blanks;
              CHLNITMN = %Int(OrderHeader.Total_Line_Items);
           Endif;
           If OrderHeader.Total_Qty <> *Blanks;
              CHTOTQTY = %Dec(OrderHeader.Total_Qty:13:1);
           Endif;

           CHBRKCRDT= %Date(WkDate:*Mdy);                         // Added for Sql Purpose
           CHBRKUPDT= %Date(WkDate:*Mdy);                         // Added for Sql Purpose
           CHCUSTPO = OrderHeader.CustomerPO;
           CHBKOROK = OrderHeader.BackOrderOK;
           CHVENDID = OrderHeader.Vendor_Order_ID;
           CHSHPMTH = OrderHeader.ShipMethod_Code;
           CHSHPMTHD= OrderHeader.ShipMethod_Name;
           CHBRKORID= OrderHeader.Broker_Order_ID;
           CHFREMTH = OrderHeader.FreightPaymentMethod;
           CHSHPINS = OrderHeader.Order_Instructions;
           CHSUBSOK = OrderHeader.SubstitutionsOK;
           CHSALNAM = OrderHeader.Broker_Sales_Rep_Name;
           CHBRKCID = OrderHeader.Broker_Customer_ID;
           CHSALID  = OrderHeader.Broker_Sales_Rep_ID;
           CHVENID  = OrderHeader.Broker_Vendor_ID;
           CHBRKSTS = OrderHeader.Broker_Status;
           CHCUSNAM = OrderHeader.Broker_CustomerName;
           CHORDNO  = WkOrder;                      // Order Number from PO XML file
           CHFLAG   = *Blanks;

      *?   // Order Header - Sold To
           CHSLDNUM = OrderHeader.SoldTo.Broker_Customer_ID;
           CHSLDNAM = OrderHeader.SoldTo.Name;
           CHSLDCON = OrderHeader.SoldTo.Contact;
           CHSLDAD1 = OrderHeader.SoldTo.Address_Line_1;
           CHSLDAD2 = OrderHeader.SoldTo.Address_Line_2;
           CHSLDCTY = OrderHeader.SoldTo.City;
           CHSLDSTE = OrderHeader.SoldTo.State;
           CHSLDZIP = OrderHeader.SoldTo.Postal_Code;
           CHSLDCNTY= OrderHeader.SoldTo.Country;
           CHSLDFAX = OrderHeader.SoldTo.Fax;
           CHSLDPHN = OrderHeader.SoldTo.Phone;
           CHSLDEML = OrderHeader.SoldTo.Email;
           CHSLDBADR= OrderHeader.SoldTo.Broker_Address_ID;
           CHVENCUSID = OrderHeader.SoldTo.Vendor_Customer_ID;

      *?   // Order Header - Ship To
           CHSHPNUM = OrderHeader.ShipTo.Broker_Customer_ID;
           CHSHPNAM = OrderHeader.ShipTo.Name;
           CHSHPCON = OrderHeader.ShipTo.Contact;
           CHSHPAD1 = OrderHeader.ShipTo.Address_Line_1;
           CHSHPAD2 = OrderHeader.ShipTo.Address_Line_2;
           CHSHPCTY = OrderHeader.ShipTo.City;
           CHSHPSTE = OrderHeader.ShipTo.State;
           CHSHPCNTY= OrderHeader.ShipTo.Country;
           CHSHPZIP = OrderHeader.ShipTo.Postal_Code;
           CHSHPFAX = OrderHeader.ShipTo.Fax;
           CHSHPPHN = OrderHeader.ShipTo.Phone;
           CHSHPEML = OrderHeader.ShipTo.Email;
           CHSHPBADR= OrderHeader.ShipTo.Broker_Address_ID;

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
      *?            :--------------------------:
      *?            : WriteDetailCO Subroutine :
      *?            :--------------------------:
      *
      *?Logic : Move Data Structure fields into file fields and Write
      *
        Begsr WriteDetailCO;

      *?   // Open Files
           Open WSCODTLPF;

      *?   // Clear Record Format
           Clear WSCODTLR;

      *?   // Move Item List into File
           For x =  1 to %Elem(Item);
              If Item(x).LineNumber <> *Blanks;

      *?         // Check PO XML file to get Order Number & OrderLineNo
                 WkLineItemNo = %Int(Item(x).LineNumber);
                 WkBrkItem = Item(x).Broker_Material;
                 Exsr GetOrderLine;

              Elseif  Item(x).LineNumber = *Blanks;
                 Leave;
              Endif;

           Endfor;

      *?   // Close Files
           Close WSCODTLPF;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-------------------------:
      *?            : GetOrderLine Subroutine :
      *?            :-------------------------:
      *
      *?Logic : Get Order# & Line# from PO XML file for the BrokerLineNo
      *
        Begsr GetOrderLine;

      *?   // Check Record Exists with Flag "C" or "P" and Process
           WkOrdLin = *Zeros;
           Exec Sql
              Select OCORDLIN Into :WkOrdLin from WSORCHCPF
              Where OCFRORID = :WkFrmOrgID And
              OCBRKORID = :WkBrokerID and OCORDNO = :WkOrder and
              OCBRKLNE = :WkLineItemNo and OCBRKMAT = :WkBrkItem;

      *?   // If Order Line not found in for the combination check
      *?   // control file without Broker Item/Line for manually added lines
           If WkOrdLin = *Zeros;
              Chain (WkFrmOrgID:'Customer':WkBrkItem) XREFINVTL0;
              If %Found;
                 WkItem = XRLCLITEM;
                 WkSize = XRLCLSIZE;
                 Exec SQL
                 Select OCORDLIN Into :WkOrdLin from WSORCHCPF
                 Where OCFRORID = :WkFrmOrgID And
                 OCBRKORID = :WkBrokerID and OCORDNO = :WkOrder and
                 OCITEM = :WkItem and OCIMSZE = :WkSize and
                 OCBRKLNE = 0 and OCBRKMAT = ' ';
                 If WkOrdLin <> *Zeros and OCBRKMAT = ' '  and
                                           OCBRKLNE = 0;
                    Chain (WkFrmOrgID:WKBrokerID:WkOrder:WkItem:
                                      WKSize) WSORCHCL2;
                    If %Found;
                       OCUPDDAT = Rundate;
                       OCUPDTIM = Runtime;
                       OCUPDUSR = User;
                       OCUPDJOB = Job;
                       OCUPDPGM = Pgm;
                       OCBRKLNE = WkLineItemNo;
                       OCBRKMAT = WkBrkItem;
                       Update WSORCHCR %Fields(OCBRKMAT:OCBRKLNE:OCUPDDAT
                                     :OCUPDTIM:OCUPDUSR:OCUPDJOB:OCUPDPGM);
                    Endif;
                 Endif;
              Endif;
           Endif;

      *?   // Move Detail fields values from Datastructure
           Exsr MoveDetail;

        Endsr;
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
           CDFRORID  = Identification.FromOrg_ID;
           CDTOORID  = Identification.ToOrg_ID;
           CDSNDORID = Identification.SenderOrg_ID;
           CDHDRSEQ  = CHSEQNO;
           CDSEQNO  += 1;

      *?   // Order Detail Part
           CDCUSTPO  = OrderHeader.CustomerPO;
           CDBRKORID = OrderHeader.Broker_Order_ID;
           If Item(x).LineNumber <> *Blanks;
              CDBRKLNE = %Dec(Item(x).LineNumber :6:0);
           Endif;
           If Item(x).Qty_Ordered <> *Blanks;
              CDORDQTY = %Dec(Item(x).Qty_Ordered:13:1);
           Endif;
           If Item(x).Scheduled_Ship_Date <> *Blanks;
              CDSCHSHDT= %Date(Item(x).Scheduled_Ship_Date: *Iso);
           Else;
               CDSCHSHDT= %Date(WkDate:*Mdy);
           Endif;
           If Item(x).Qty_Confirmed <> *Blanks;
              CDQTYCD  = %Dec(Item(x).Qty_Confirmed:13:1);
           Endif;

           CDBRKMAT = %TrimL(Item(x).Broker_Material:'0');
           CDVENMAT = Item(x).Vendor_Material;
           CDVENDSC = Item(x).Material_Description;
           CDVENDSC2= Item(x).Material_Description2;
           CDINCTYP = Item(x).Status;
           CDORDLIN = WkOrdLin;
           CDORDNO  = WKOrder;
           CDFLAG   = CHFLAG;

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
