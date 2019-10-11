      *? Program        : WSURCINV01
      *?
      *? Description    : This program is to Consume XML into RPG,
      *?                  Process  - Inventory sent by Suppliers
      *?                  and load it into WSSUPINVPF
      *? Created By     : Vimala
      *?
      *? Date           : 31 Jul 2018
      //--------------------------------------------------------------------
      *? Special Notes  : Used for Gediflora and Dummen
      *
      *? Response       : HttpStatus
      *
      *? Called Program : WSSTOREXML - WSURC - Store PO/CO & URC Ack/Inv Xml in IFS
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *?Changes in 2018
      * VV01    09/18/18   Vimala       Provide Null Indicator for Allocated
      *                                 Quantity calculation in SQL
      * WJB01   11/07/18   W.J.Behr     Use KP Vendor # not Vend supplied number
      * VV02    11/21/18   Vimala       Delete records for Gediflora only once
      *?Changes in 2019
      * SUD01   09/11/19   S.Uthaya     Store Incoming XML
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
      *?File: WS - Supplier Inventory File
      *?Key : Customer Number:Card Number:Token Number
        Dcl-F WSSUPINVPF Disk(*Ext) Usage(*Output:*Delete) UsrOpn;
      *
      *?File: Broker Default File
      *?File: Broker ID:Broker Name:Values
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - XML Cross Reference File for FMINVT
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFINVTL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From Webservice Call)
        Dcl-Pi WSURCINV01;
           InvXml     Char(9999999);
           Httpstatus Int(10:0);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Store XML into IFS
SUD01   Dcl-Pr WSSTOREXML Extpgm;
  |       PXml       Char(9999999) Options(*Varsize);
  |       PFromOrgId Char(30);
  |       PCustPO    Char(10);
  |       PFlag      Char(10);
SUD01   End-Pr;
      *
      *?Data Structure Declaration      : Identification
        Dcl-Ds Identification Qualified;
           Reference_ID         Char(36);
           Date                 Char(19);
           DateTime             Char(19);
           MessageProtocol_ID   Char(30);
           FromOrg_ID           Char(30);
           ToOrg_ID             Char(30);
           SenderOrg_ID         Char(30);
        End-Ds;
      *
      *?Data Structure Declaration      : Availability Header
        Dcl-Ds AvailabilityHeader  Qualified;
           VendorNumber            Char(6);
           VendorName              Char(15);
           PlantCode               Char(30);
        End-Ds;
      *
      *?Data Structure Declaration      : Material Number
        Dcl-Ds MaterialNumber  Qualified Dim(99999);
           Type                Char(10);
           Number              Char(15);
        End-Ds;
      *
      *?Data Structure Declaration      : Availability Date
        Dcl-Ds AvailabilityDate Qualified Dim(99999);
           Date                Char(19);
        End-Ds;
      *
      *?Data Structure Declaration      : Units
        Dcl-Ds Units           Qualified Dim(99999);
           UnitOfMeasure       Char(3);
           Count               Char(12);
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
      *?Data Structure for Date         :
        Dcl-Ds DateFmt Len(10) Qualified;
           WkYear  Char(4) Pos(1);
           WkMonth Char(2) Pos(6);
           WkDate  Char(2) Pos(9);
        End-Ds;
      *
      *?Global Variable Declaration     :
        Dcl-S Options Char(150)   Inz;
        Dcl-S x       Packed(8:0) Inz;
      *
      *?Work Variable Declaration       :
        Dcl-S WkAlcQty  Packed(11)    Inz;
        Dcl-S WkDiff    Packed(15)    Inz;
        Dcl-S WkAvlDat  Packed(7)     Inz;
        Dcl-S WkBroker  Packed(6)     Inz;
        Dcl-S WkTag     Char(30)      Inz;
        Dcl-S WkExtra   Char(55)      Inz;
        Dcl-S WkItem    Char(15)      Inz;
SUD01   Dcl-S WkBrokerC Char(10)      Inz;
SUD01   Dcl-S WkStore   Char(1)       Inz;
        Dcl-S WkSize    Char(3)       Inz;
        Dcl-S WkXmlDt   Char(26)      Inz;
        Dcl-S WkSiDat   Char(26)      Inz;
        Dcl-S WkFilDt   Char(26)      Inz;
        Dcl-S WkSeq     Int(10:0)     Inz;
 VV01   Dcl-S NullInd   Int(5)        Inz(0);               // Null Indicator for WkAlcQty
 VV01   Dcl-S NullValue Like(NullInd) Inz(-1);
      *
      *?Parameter Variable Declaration  :
        Dcl-S PCustPO    Char(10)      Inz;
        Dcl-S PFlag      Char(10)      Inz;
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

      *?   // Call Subroutine to process Xml Data
           If InvXml <> *Blanks;
              Exsr Process;
           Else;

      *?      //Invalid Parameter
              Httpstatus = 400;
              Exsr EndPgm;
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
           Clear AvailabilityHeader;
           Clear MaterialNumber;
           Clear AvailabilityDate;
           Clear Units;

      *?   // Clear Variables
           Clear Options;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : Validate Subroutine :
      *?                :---------------------:
      *
      *?Logic : Move values to find Tag in the xml
      *?
        Begsr Validate;

      *?   // Mandatory Parameters Validation
           If InvXml = *Blanks;
             LeaveSr;
           Endif;

      *?   // To Identify XML for the Process
           WkTag = *Blanks;
           WkTag = 'AvailabilityFeed';

      *?   // Replace Special Character with Equivalent Value
           InvXml = %ScanRpl('& ' : '&amp; ': INVXML);

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

SUD01 *?   // Store Inventory Xml into IFS
  |        If SIFRORID = 'DUMMEN NA,INC';
  |           WkBrokerC = %Char(WkBroker);
  |           Chain (WkBrokerC : 'URC_INV_STORE_XML') FBROKDFTL0;
  |           If %Found;
  |              WkStore = %Trim(DFVARVAL);
  |              If WkStore = '1';
  |                 SIFRORID= 'Dummen';
  |                 PFlag = 'Inventory';
  |                 WSSTOREXML(InvXml:SIFRORID:PCustPO:PFlag);
  |              Endif;
  |           Endif;
SUD01      Endif;

      *?   // End the Program
           *InLr = *On;
           Return;

        Endsr;
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

           Xml-Into Identification %XML(InvXml:Options);

      *?   // AvailabilityHeader Data Structure
           Options = 'path=' + %Trim(WkTag) + '/AvailabilityHeader ' +
                        %Trim(WkExtra) ;

           Xml-Into AvailabilityHeader %XML(InvXml:Options);

      *?   // AvailabilityItem/MaterialNumber Data Structure
           Options = 'path=' + %Trim(WkTag) +
                              '/AvailabilityItem/MaterialNumber ' +
                              %Trim(WkExtra) ;

           Xml-Into MaterialNumber %XML(InvXml:Options);

      *?   // AvailabilityItem/AvailabilityDate Data Structure
           Options = 'path=' + %Trim(WkTag) +
                              '/AvailabilityItem/AvailabilityDate ' +
                              %Trim(WkExtra) ;

           Xml-Into AvailabilityDate %XML(InvXml:Options);

      *?   // AvailabilityItem/Units Data Structure
           Options = 'path=' + %Trim(WkTag) + '/AvailabilityItem/Units ' +
                        %Trim(WkExtra) ;

           Xml-Into Units %XML(InvXml:Options);

      *?   // Move Datastructure Values into File
           Exsr WriteInvDet;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteInvDet Subroutine :
      *?            :------------------------:
      *
      *?Logic : Move Data structure fields into file fields and Write

        Begsr WriteInvDet;

      *?   // Open Files
           Open WSSUPINVPF;

      *?   // Clear Record Format
           Clear WSSUPINVR;

      *?   // Identification Part
           For x =  1 to %Elem(MaterialNumber);
              If MaterialNumber(x).Number <> *Blanks;
                 SIMSGPR   = Identification.MessageProtocol_Id;
                 SIFRORID  = Identification.FromOrg_ID;
                 SITOORID  = Identification.ToOrg_ID;
                 SISNDORID = Identification.SenderOrg_ID;
                 SIREFID   = Identification.Reference_ID;

      *?         // For Gediflora
                 If SIFRORID = 'Gediflora';
                    SIFRORID = 'GEDIFLORA';
                    SIIDATE   = Identification.Date;

      *?            // Delete all records from Supplier Inventory File
      *?            // Delete only once
VV02                If x = 1;
                       Exec Sql
                         Delete from WSSUPINVPF where SIFRORID = 'GEDIFLORA';
VV02                Endif;
                 Endif;

      *?         // For DUMMEN
                 If SIFRORID = 'DUMMEN'
                   or SIFRORID = 'DUMMEN NA,INC'
                   or SIFRORID = 'DUMMEN ANTIGUA';
                      SIFRORID = 'DUMMEN NA,INC';
                      SIIDATE   = Identification.DateTime;

      *?            // Calculate date/time from current extra to delete old data
      *?            // Delete only once
                    If x = 1;
                       Exsr DelInv;
                    Endif;
                 Endif;

      *?         // Get Supplier Id from FBROKDFT file
                 Chain ('1000' : SIFRORID) FBROKDFTL0;
                 If %Found;
                    WkBroker = %Int(%Trim(DFVARVAL));
                 Endif;

      *?         // AvailabilityHeader
                 If (AvailabilityHeader.VendorNumber) <> *Blanks;
                    SIVENNUM = %Int(AvailabilityHeader.VendorNumber);
                 Endif;

      *?         // Use KP Vendor Number, not vendor supplied vendor number
WJB01            SIVENNUM = %Int(WkBroker);
                 SIVENNAM = AvailabilityHeader.VendorName;
                 SIPLTCDE = AvailabilityHeader.PlantCode;

      *?         // AvailabilityItem
                 SIMATTYP = MaterialNumber(x).Type;
                 SIITEM   = MaterialNumber(x).Number;
                 WkSeq   += 1;
                 SISEQNO  = WkSeq;

                 DateFmt  = %Subst(AvailabilityDate(x).Date:1:10);
                 SIAVLDAT = DateFmt.WkYear + DateFmt.Wkmonth + DateFmt.WkDate;

                 SIUOM    = Units(x).UnitOfMeasure;
                 If (Units(x).Count) <> *Blanks;
                    SISUPQTY = %Int(Units(x).Count);

      *?            // Calculate Allocated qty from FCUTORD file
                    Exsr CalcAlcQty;
                    SIALCQTY = WkAlcQty;
                    SIAVLQTY = SISUPQTY - SIALCQTY;
                 Endif;

      *?         // Audit Stamp
                 SICRTDAT = Rundate;
                 SICRTTIM = Runtime;
                 SICRTUSR = User;
                 SICRTJOB = Job;
                 SICRTPGM = Pgm;

      *?         // Write Rec
                 Write WSSUPINVR;

              Elseif MaterialNumber(x).Number = *Blanks;
                 Leave;
              Endif;

           Endfor;

      *?   // Close Files
           Close WSSUPINVPF;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : CalcAlcQty Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Read FCUTORD file to calculate Allocated quantity  for the Supplier

        Begsr CalcAlcQty;

      *?   // Get KubePak Item and Size
           WkItem = *Blanks;
           WkSize = *Blanks;
           WkAlcQty = *Zeros;
           Chain (SIFRORID:'Vendor':SIITEM) XREFINVTL0;
           If %Found;
              WkItem = XRLCLITEM;
              WkSize = XRLCLSIZE;
           Endif;

      *?   // Get allocated quantity from FCUTORD file
           WkAvlDat = %Dec(%Char(%Date(SIAVLDAT:*ISO0):*CYMD0):7:0);
           Exec Sql
 VV01         Select Sum(COQTOO - COQTRC) Into :WkAlcQty :NullInd From FCUTORD
 VV01                Where COVEND = :WKBroker
                       And COSTAT <> 'D'
                       And COITEM = :WkItem
                       And COSIZE = :WkSize
                       And COSOWD = :WkAvlDat;

 VV01      If NullInd = NullValue;
  |           WkAlcQty = 0;
 VV01      Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : DelInv Subroutine :
      *?                :-------------------:
      *
      *?Logic : Get date/time from xml to check against WSSUPINVPF and delete all
      *?        records that are older than 15 minutes from xml date/time for DUMMEN

        Begsr DelInv;

      *?   // Check Time
           Exec Sql
              Delete from WSSUPINVPF where  SIVENNUM = 23
              and timestamp(to_timestamp(right('00'||trim(char(SICRTDAT)),6)
              ||' '||right('00'||trim(char(SICRTTIM)),6),'MMDDYY HH24MISS'))
              < current TIMESTAMP  - 45 minutes;
           LeaveSR;


      *?   // Get date and time from the received xml
           WkXmlDt = %Trim(%Char(SIIDATE));
           WkXmlDt = %ScanRpl('T' : '-' : WkXmlDt);
           WkXmlDt = %ScanRpl(':' : '.' : WkXmlDt);

      *?   // Get all the distinct date values SIIDATE from WSSUPINVPF
           Exec Sql Declare A1 Cursor for
              Select Distinct(SIIDATE)
                From WSSUPINVPF Where SIFRORID = 'DUMMEN ANTIGUA';

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;

      *?   // Read all distinct records and check if its older than 15 minutes of xml date
           Exec Sql Fetch A1 Into :WkSIDAT;
           Dow SqlCod = 0;

              If WkSIDAT <> *Blanks;
                 WkFilDt = WkSIDAT;
                 WkFilDt= %ScanRpl('T' : '-' : WkFilDt);
                 WkFilDt= %ScanRpl(':' : '.' : WkFilDt);
                 WkDiff = %Diff(%TimeStamp(WkXmlDt):%Timestamp(WkFilDt)
                                                   : *MINUTES);
              Endif;

      *?      // If records are 15 minutes older delete from Inventory file
              If Wkdiff >= 15;
                 Exec Sql
                    Delete from WSSUPINVPF where  SIFRORID = 'DUMMEN ANTIGUA';
              Endif;

              Exec Sql Fetch A1 Into :WkSIDAT;
           Enddo;

        Endsr;
