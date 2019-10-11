      *? Program        : WSURCACK01
      *?
      *? Description    : This program is to Consume Acknowledgement XML into RPG
      *?                  Via API Process
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 21 Mar 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Called from WSACKFTPC - WS - Get Ack xml files
      *?                     from Vendors using FTP
      *?                  ** Update FCUTORD , FCUTLOT And WSCUTOHPF file
      *?
      *? Called Program : WSSTOREXML - WSURC - Store PO/CO & URC Ack/Inv Xml in IFS
      *
      *? Response       : Status Message for Vendor
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
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Cutting Lot File
      *?Key : Vendor:Item:Size:SowDate
        Dcl-F FCUTLOT    Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Cutting Open Order file (Vendor)
      *?Key : Vendor:Item:Size:SowDate
        Dcl-F FCUTORD    Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: WS Cuts Order History Logical File
      *?Key : Vendor:Order:LineNumber:TimeStamp
        Dcl-F WSCUTOHL1  Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From Webservice)
        Dcl-Pi WSURCACK01 ExtPgm;
           PAckXml    Char(1000000) Options(*Varsize);
           Httpstatus Int(10:0);
           PStatus    Char(50);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Store XML into IFS
        Dcl-Pr WSSTOREXML Extpgm;
          PXml       Char(9999999) Options(*Varsize);
          PFromOrgId Like(PFromOrgId);
          PCustPO    Like(PCustPO);
          PrFLag     Char(10);
        End-Pr;
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
           AcknowledgementType     Char(1);
           VendorOrderID           Char(30);
           RequestedShipDate       Char(10);
           VendorNumber            Char(10);
           BrokerOrderID           Char(10);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderDetails/Item
        Dcl-Ds Item Qualified Dim(9999);
           BrokerLineItemNumber       Char(10);
           BrokerMaterialNumber       Char(18);
           VendorMaterialNumber       Char(35);
           MaterialDescription        Char(45);
           OrderdQty                  Char(13);
           ConfirmedQty               Char(7);
           ScheduledShipDate          Char(10);
           ShippingPoint              Char(4);
           LineItemComment            Char(225);
           RejectionCode              Char(10);
           PlantCode                  Char(10);
           LineItemStatus             Char(1);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderDetails
        Dcl-Ds OrderDetails Qualified;
           Item LikeDs(Item);
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
        Dcl-S X       Int(5:0);
      *
      *?Work Variable Declaration       :
        Dcl-S WkLineItemNo Packed(10:0);
        Dcl-S WkOrder      Packed(6);
        Dcl-S WkBroker     Packed(6);
        Dcl-S WkQty        Packed(7);
        Dcl-S WkBrkItem    Char(32);
        Dcl-S WkFrmOrgId   Char(30);
        Dcl-S WkExtra      Char(55);
        Dcl-S WkTag        Char(30);
        Dcl-S WkDate       Date(*ISO);
      *
      *?Parameter Variable Declaration  :
        Dcl-S PXml       Char(9999999);
        Dcl-S PFromOrgId Char(30);
        Dcl-S PCustPO    Char(10);
        Dcl-S PrFlag     Char(10);
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Execute Initialize
           Exsr InzPgm;

      *?   // Validate Input Parameters
           Exsr Validate;

      *?   // If HttpStatus is Success
           If Httpstatus = 200;
              PStatus = 'Acknowledgement received successfully';

      *?   // If HttpStatus is no good
           Else;
              PStatus = 'Xml Upload Error';
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
           HttpStatus = 200;        // Success Code

      *?   // Clear DataStructure and Variables
           Clear Identification;
           Clear OrderHeader;
           Clear OrderDetails;
           Clear Item;

      *?   // Clear Variables
           Clear Options;
           Pos = *Zeros;

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
           If PAckXml = *Blanks;
              PStatus = 'Xml is blank';
              Httpstatus = 400;                     //Invalid Parameter
              Exsr EndPgm;
           Endif;

      *?   // To Identify Broker for the Process
           WkTag = *Blanks;
           Setll ('1000' : 'XMLACKTAG') FBROKDFTL0;
           ReadE ('1000' : 'XMLACKTAG') FBROKDFTL0;
           Dow  Not %Eof;
              WkTag =  %Trim(DFVARVAL);
              Pos = %Scan(%Trim(WkTag):PAckXml:1);
              If Pos <> *Zeros;
                 Leave;
              Endif;
              ReadE ('1000' : 'XMLACKTAG') FBROKDFTL0;
           Enddo;

      *?   // Replace Special Character with Equivalent Value
           PACKXML = %ScanRpl('& ' : '&amp; ': PACKXML);

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

      *?   // Store Receive XML into IFS
           PrFlag = 'Ack';
           PCustPO= %Char(WkOrder);
           PXml   = PACKXML;
           WSSTOREXML(PXML:WkFrmOrgId:PCustPO:PrFlag);

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

           Xml-Into Identification %XML(PAckXml:Options);

      *?   // OrderHeader Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderHeader ' +
                        %Trim(WkExtra) ;

           Xml-Into OrderHeader %XML(PAckXml:Options);

      *?   // OrderDetails/Item Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderDetails/Item ' +
                        %Trim(WkExtra) ;

           Xml-Into Item %XML(PAckXml:Options);

      *?   // Get PAckXml Header file
           Exsr GetHeader;

      *?   // Move Datastructure Values into File
           Exsr GetDetail;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : GetHeader Subroutine :
      *?            :----------------------:
      *
      *?Logic : Get the Ack XML header file details using SQL

        Begsr GetHeader;

      *?   // Get FromOrgID & BrokerOrderId from Data Structure
           WkFrmOrgId = Identification.FromOrg_ID;
           WkOrder = %Int(OrderHeader.BrokerOrderID);

      *?   // To Get Vendor Number
           WkTag = *Blanks;
           Chain ('1000' : WkFrmOrgId) FBROKDFTL0;
           If %Found;
              WkBroker = %Int(%Trim(DFVARVAL));
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : GetDetail Subroutine :
      *?            :----------------------:
      *
      *?Logic : Move Data Structure fields into file fields and Write
      *
        Begsr GetDetail;

      *?   // Move Item List into File
           For X = 1 to %Elem(Item);
              If Item(X).BrokerLineItemNumber <> *Blanks;

      *?         // Check PO XML file to get Order Number & OrderLineNo
                 WkLineItemNo = %Int(Item(X).BrokerLineItemNumber);
                 WkBrkItem = %TrimL(Item(X).VendorMaterialNumber);
                 Exsr ProcessAck;
              Elseif Item(X).BrokerLineItemNumber = *Blanks;
                 Leave;
              Endif;

           Endfor;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : ProcessAck Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Process the acknowledgement by Line Item Number
      *
        Begsr ProcessAck;

      *?   // Check in Cut Order History File By Vendor , Order & Line Number
           Chain (WkBroker:WkOrder:WkLineItemNo) WSCUTOHL1;
           If %Found;

      *?      // Update Cut Order File
              Chain (COHVEND:COHITEM:COHSIZE:COHSOWD) FCUTORD;
              If %Found;
                 COSTAT = 'C';
                 WkQty  = COQTOO;
                 COQTOO = *Zero;
                 COQTRC = %Int(Item(x).ConfirmedQty);
                 Update RCUTORD %Fields(COSTAT:COQTOO:COQTRC);
              Endif;

      *?      // Update Cut Lot File
              Chain (COHVEND:COHITEM:COHSIZE:COHSOWD) FCUTLOT;
              If %Found;
                 CLQTOH = %Int(Item(x).ConfirmedQty);
                 CLQTAV = %Int(Item(x).ConfirmedQty) - CLQTSL;
                 CLQTOO = CLQTOO - WkQty;
                 Update RCUTLOT %Fields(CLQTOH:CLQTAV:CLQTOO);
              Endif;

      *?      // Update Broker Order Id in Cut Order History File
              COHVENID = OrderHeader.VendorOrderID;
              Update WSCUTOHR %Fields(COHVENID);

           Endif;

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
