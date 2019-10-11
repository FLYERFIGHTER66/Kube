      *? Program        : WSURCACK02
      *?
      *? Description    : This program is to Consume Acknowledgement XML into RPG,
      *?                  Process
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 09 Apr 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Called from WSACKFTPC - WS - Get Ack xml files
      *?                     from Vendors using FTP
      *?                  ** Update FCUTORD, FCUTLOT And WSCUTOHPF file
      *?
      *? Called Program : WSSTOREXML - WSURC - Store PO/CO & URC Ack/Inv Xml in IFS
      *?                  QCMDEXC    - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *?Chabges in 2019
      *         09/16/19   WJB          Expanded PAckXml & WkXml to Match WSSTOREXML
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Actgrp(*NEW) Bnddir('QC2LE')
          Option(*SrcStmt : *NoDebugIO);
      //--------------------------------------------------------------------
      *? Copy Httpapi_h Source
      /Copy QRpglesrc,IFSIO_H
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
      *?Key : Vendor :Order:LineItemNo:Timestamp
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
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSURCACK02;
           PVendor Char(10);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Store XML into IFS
        Dcl-Pr WSSTOREXML Extpgm;
          PAckXml    Char(9999999) Options(*Varsize);
          PFromOrgId Like(PFromOrgId);
          PCustPO    Like(PCustPO);
          PrFLag     Char(10);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(200)    Const Options(*Varsize);
           Len Packed(15:5) Const;
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
           BackOrderOK             Char(1);
           BrokerCreatedDate       Char(10);
           ChangeOrderBatchNumber  Char(5);
           ShipMethod              Char(30);
           FreightPaymentMethod    Char(30);
           CustomerPONumber        Char(35);
           RequestedShipDate       Char(10);
           VendorNumber            Char(10);
           BrokerOrderID           Char(10);
           SubstitutionOK          Char(1);
        End-Ds;
      *
      *?Data Structure Declaration      : OrderDetails/Item
        Dcl-Ds Item Qualified Dim(9999);
           BrokerLineItemNumber       Char(10);
           BrokerMaterialNumber       Char(18);
           VendorMaterialNumber       Char(35);
           MaterialDescription        Char(45);
           ConfirmedQty               Char(7);
           ScheduledShipDate          Char(10);
           LineItemComment            Char(255);
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
        Dcl-S Dh       Pointer;
        Dcl-S Cmd      Char(400) Inz;
        Dcl-S Name     Char(640) Inz;
        Dcl-S Xml      Char(900) Inz;
        Dcl-S Options  Char(150) Inz;
        Dcl-S Pos      Zoned(3)  Inz;
        Dcl-S x        Int(5:0)  Inz;
      *
      *?Work Variable Declaration       :
        Dcl-S WkLineItemNo Packed(10:0)  Inz;
        Dcl-S WkBroker     Packed(6)     Inz;
        Dcl-S WkOrder      Packed(6)     Inz;
        Dcl-S WkQty        Packed(7)     Inz;
        Dcl-S WkXml        Char(9999999) Inz;
        Dcl-S WkBrkItem    Char(32)      Inz;
        Dcl-S WkSndOrgId   Char(30)      Inz;
        Dcl-S WkBrokerId   Char(10)      Inz;
        Dcl-S WkExtra      Char(55)      Inz;
        Dcl-S WkTag        Char(30)      Inz;
        Dcl-S WkFile       Char(75)      Inz;
        Dcl-S WkPath       Char(75)      Inz;
        Dcl-S WkPathPO     Char(75)      Inz;
        Dcl-S WkFlag       Char(1)       Inz('Y');
        Dcl-S WkState      Char(1)       Inz;
        Dcl-S WkPos        Int(10:0)     Inz;
      *
      *?Parameter Variable Declaration  :
        Dcl-S PAckXml    Char(9999999);
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

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Parameters
      *?
        Begsr InzPgm;

      *?   // Create IFSXML temp file in QTEMP
           Cmd = 'CRTPF FILE(QTEMP/CPYXML) RCDLEN(900)';
           Exsr CallCmd;

      *?   // Open and Read Directory
           Exsr OpenDirSr;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : OpenDirSr Subroutine :
      *?                :----------------------:
      *
        Begsr OpenDirSr;

      *?   // Get File Path
           Chain (PVendor : 'IFSURCACKFTP') FBROKDFTL0;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

      *?   // Open up the directory
           Dh = Opendir(%Trim(WkPath));
           If Dh = *NULL;
              Exsr EndPgm;
           Endif;

      *?   // Read each entry from the directory (in a loop)
           p_dirent = Readdir(dh);
           Dow p_dirent <> *NULL;
              Name = %Str(%Addr(d_name));
              Wkpos = *Zeros;
              Wkpos = %Scan('.xml' : Name : 1);
              If WkPos <> *Zeros;

      *?         // Process URC ACK
                 Exsr Process;
              Endif;
              p_dirent = Readdir(dh);
           Enddo;

      *?   // Close the directory
           Closedir(dh);

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CallCmd Subroutine :
      *?                :--------------------:
      *
        Begsr CallCmd;

      *?   // Call QCMDEXC ,Monitor if there is a error
           Monitor;
              QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
        Begsr Process;

      *?   // Copy data from IFS into Flat File
           WkFile = %Trim(WkPath) + '/' + %Trim(Name);
           CMD = 'CPYFRMIMPF FROMSTMF(''' + %Trim(WkFile) + ''')'   +
                 ' TOFILE(CPYXML) MBROPT(*REPLACE) FROMCCSID(1208)' +
                 ' TOCCSID(838) RCDDLM(*CRLF) STRDLM(*NONE) FLDDLM(*TAB)';
           Exsr CallCmd;

      *?   // Read Flat file and get XML as a string
           Exsr ReadXML;

      *?   // Process Ack for each XML
           Exsr Validate;

      *?   // Clear Temp File
           Cmd = 'CLRPFM FILE(QTEMP/CPYXML)';
           Exsr CallCmd;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : ReadXML Subroutine :
      *?                :--------------------:
      *
        Begsr ReadXML;

      *?   // Read XML File and make it String
           Exec Sql Declare A1 Cursor For
              Select CPYXML From QTEMP/CPYXML;
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;

           Exec Sql Fetch A1 Into :Xml;

      *?   // Make XML as a String
           WkFlag = 'Y';
           Dow SqlCod = 0;
              If WkFlag = 'Y';
                 WkPos = *Zeros;
                 Wkpos = %Scan('<?xml version' : Xml : 1);
                 If WkPos <> *Zeros;
                    WkFlag = 'N';
                    WkXml  = *Blanks;
                 Else;
                    WkFlag = 'N';
                    WkXml = %Trim(WkXml) + %Trim(Xml);
                 Endif;
              Else;
                 WkXml = %Trim(WkXml) + %Trim(Xml);
              Endif;
              Exec Sql Fetch A1 Into :Xml;
           Enddo;

      *?   // Close Cursor
           Exec Sql Close A1;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : Validate Subroutine :
      *?                :---------------------:
      *
      *?Logic : Mandatory Parameters Validation & Get Broker Name
      *?
        Begsr Validate;

      *?   // To Identify Broker for the Process
           WkTag = *Blanks;
           Setll ('1000' : 'XMLACKTAG') FBROKDFTL0;
           ReadE ('1000' : 'XMLACKTAG') FBROKDFTL0;
           Dow  Not %Eof;
              WkTag = %Trim(DFVARVAL);
              Pos = %Scan(%Trim(WkTag):WkXml:1);
              If Pos <> *Zeros;
                 Leave;
              Endif;
              ReadE ('1000' : 'XMLACKTAG') FBROKDFTL0;
           Enddo;

      *?   // Replace Special Character with Equivalent Value
           WkXml = %ScanRpl('& ' : '&amp; ': WkXml);

      *?   // Call Subroutine to process Xml Data
           If Pos <> *Zeros;

      *?      // Process Acknowledgement
              Exsr ProcessAck;

      *?      // Remove Link from IFS
              Cmd = 'RMVLNK OBJLNK(''' + %Trim(WkFile) + ''')';
              Exsr CallCmd;

      *?      // Store Receive XML into IFS
              PrFlag = 'Ack';
              WSSTOREXML(WkXML:WkSndOrgId:WkBrokerId:PrFlag);

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // End the Program
           *InLr = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ProcessAck Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Use XML-INTO keyword to map Xml fields to DS Fields
      *?      : Give Specific path information in Options
      *?      : Options : Path=option must be used to specify the XML
      *?                     element to be used
      *?      :           case=upper/lower/any
      *?      :           allowextra/allowmissing=yes/no

        Begsr ProcessAck;

      *?   // Clear DataStructure and Variables
           Clear Identification;
           Clear OrderHeader;
           Clear OrderDetails;
           Clear Item;
           Clear Options;

      *?   // Extra Path Properties
           WkExtra = 'allowextra=yes allowmissing=yes case=any doc=string';

      *?   // Identification Data Structure
           Options = 'path=' + %Trim(WkTag) + '/Identification ' +
                        %Trim(WkExtra) ;

           Xml-Into Identification %XML(WkXml:Options);

      *?   // OrderHeader Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderHeader ' +
                        %Trim(WkExtra) ;

           Xml-Into OrderHeader %XML(WkXml:Options);

      *?   // OrderDetails/Item Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderDetails/Item ' +
                        %Trim(WkExtra) ;

           Xml-Into Item %XML(WkXml:Options);

      *?   // Get WkXml Header file
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
           WkSndOrgId = Identification.SenderOrg_ID;
           WkBrokerId = OrderHeader.BrokerOrderID;
           If OrderHeader.CustomerPONumber <> *Blanks;
              WkOrder = %Int(%Trim(OrderHeader.CustomerPONumber));
           Endif;

      *?   // To Identify Broker for the Process
           WkTag = *Blanks;
           Chain ('1000' : 'EHRVendorNumber') FBROKDFTL0;
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
           For x = 1 to %Elem(Item);
              If Item(x).BrokerLineItemNumber <> *Blanks;

      *?         // Check PO XML file to get Order Number & OrderLineNo
                 WkLineItemNo = %Int(Item(x).BrokerLineItemNumber);
                 WkBrkItem = %TrimL(Item(x).BrokerMaterialNumber:'0');
                 Exsr UpdateAck;
              Elseif Item(x).BrokerLineItemNumber = *Blanks;
                 Leave;
              Endif;

           Endfor;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : UpdateAck Subroutine :
      *?            :----------------------:
      *
      *?Logic : Process the acknowledgement by Line Item Number
      *
        Begsr UpdateAck;

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

      *?      // Update BrokerOrderId & Line No in Cut Order History File
              COHVENID = WkBrokerId;
              Update WSCUTOHR %Fields(COHVENID);

           Endif;

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
