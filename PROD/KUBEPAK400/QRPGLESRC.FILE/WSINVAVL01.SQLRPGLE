      *? Program        : WSINVAVL01
      *?
      *? Description    : This program to Generate Inventory XML using POST
      *?                  method for Available Quantity
      *? Created By     : Vimala
      *?
      *? Date           : 25 Apr 2018
      //--------------------------------------------------------------------
      *? Special Notes  : *Entry Parameters
      *?                  Broker Id  (6P)  - Input Parameter
      *?                  Httpstatus (10I) - Output Parameter
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   05/31/18   S.Uthaya     Inventory XML store in IFS for Future
      *                                 reference
      * SUD02   05/17/19   S.Uthaya     IFS folder Named by Date
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) DatFmt(*Usa)
                Debug(*Yes) BndDir('HTTPAPI': 'QC2LE');
      //--------------------------------------------------------------------
      *?Include Httpapi_h Source
      /Include QRpglesrc,Httpapi_h
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Outfile for Available Quantity
        Dcl-F WSINVAVLL0 Disk(*Ext) Usage(*Input) Rename(WSINV_AVL:Rec1);
      *
      *?File: Item Cross Reference File
      *?Key : Provided Name:Provided Type:Local Key
        Dcl-F XREFINVTL1 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Item Size file
      *?Key : Size Code
        Dcl-F FMSIZE     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - Broker Default Parameter File
      *?Key : Broker Number : Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Update:*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSINVAVL01;
           PBrokerId    Packed(6);
           HttpStatus   Int(10:0);
        End-Pi;
      *
      *?Procedure Prototype Declaration : WSINVAVLQ
        Dcl-Pr WSINVAVLQ Extpgm End-Pr;
      *
SUD01 *?Procedure Prototype Declaration : WSINVFTPC
  |     Dcl-Pr WSINVFTPC ExtPgm;
  |        PPgmName   Char(10);
  |        PLogName   Char(10);
SUD01   End-Pr;
      *
      *?Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname  Char(50)   Value;
           Tagval   Char(300)  Value;
           Info     Char(10)   Value;
        End-Pr;
      *
      *?Procedure Interface Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd  Char(200)    Const Options(*Varsize);
           Len  Packed(15:5) Const;
        End-Pr;
      *
SUD02 *?Procedure Prototype Declaration : Pgm to Create Directory
  |     Dcl-Pr CRTDIRCL Extpgm;
  |        Link  Char(256)   Const;
SUD02   End-Pr;
      *
      *?Program Status Data Strucure :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Parameter Variable Declaration :
        Dcl-S PInvXml    Char(6773100) Inz;
        Dcl-S PPgmName   Char(10)      Inz('WSINSNDFTP');
        Dcl-S PLogName   Char(10)      Inz('WSINSNDLOG');
      *
      *?Global Variable Declaration :
        Dcl-S Xml        Char(6773100) Inz;
        Dcl-S Cmd        Char(200)     Inz;
        Dcl-S XmlIfs     Char(300)     Inz;
        Dcl-S Info       Char(10)      Inz;
        Dcl-S Url        Char(400)     Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkIQty     Packed(10:0)  Inz;
        Dcl-S WkRefNo    Zoned(6)      Inz;
        Dcl-S WkSequence Int(10:0)     Inz;
        Dcl-S WkDateN    Int(10:0)     Inz;
        Dcl-S WkQty1     Int(10:0)     Inz;
        Dcl-S WkAQty     Int(10:0)     Inz;
        Dcl-S WkDtTm     Char(19)      Inz;
        Dcl-S WkDateC    Char(10)      Inz;
        Dcl-S WkRefId    Char(32)      Inz;
        Dcl-S WkBrokerId Char(10)      Inz;
        Dcl-S WkBroker   Char(15)      Inz;
        Dcl-S WkForItem  Char(30)      Inz;
SUD01   Dcl-S WkPath     Char(75)      Inz;
  |     Dcl-S WkFile     Char(75)      Inz;
  |     Dcl-S WkLog      Char(100)     Inz;
  |     Dcl-S WkFtp      Char(1)       Inz;
  |     Dcl-S WkItm1     Char(22)      Inz;
SUD01   Dcl-S WkDte1     Char(8)       Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Initialse
           Exsr InzPgm;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
        Begsr InzPgm;

      *?   // Call Inventory program to generate Available quantity file
           WSINVAVLQ();

      *?   // Clear XML
           PInvXml = *Blanks;
           Xml = *Blanks;

      *?   // Get Date and Time
           WkDtTm = %Char(%Date) + 'T' + %Char(%Time());

SUD01 *?   // Create IFSXML temp file in QTEMP
  |        Cmd = 'CRTPF FILE(QTEMP/IFSXML) RCDLEN(300) SIZE(*NOMAX)';
  |        Exsr CallCmd;
  |
  |   *?   // Insert XML Header into Flat File
  |        XmlIfs = '<?xml version="1.0" encoding="utf-8" ?>';
  |        Exec Sql
  |        INSERT INTO IFSXML Values(:XmlIfs);
SUD01      XmlIfs = *Blanks;

      *?   // Add HTTP Library to Library List
           Cmd = 'ADDLIBLE LIB(LIBHTTP) POSITION(*Last)';
SUD01      Exsr CallCmd;

      *?   // Convert Entry parameter to Character and Get Broker Name
           WkBrokerId = %Char(PBrokerId);
           Chain ('1000' : WkBrokerId) FBrokDftL0;
           If %Found;
              WkBroker =  %Trim(DFVARVAL);
           Endif;

      *?   // Process data and build Xml
           Exsr Process;

SUD01 *?   // Store XML into IFS
SUD01      Exsr StoreIfs;

      *?   // Post XML
           Exsr PostXml;

        Endsr;
SUD01 //--------------------------------------------------------------------
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
  |        Chain ('IFS' : 'IFSINVPATH' ) FBROKDFTL0;
SUD01      If %Found;
SUD02         WkPath = %Trim(DFVARVAL) + %Trim(%Char(%Date)) + '/';
  |
  |   *?      // Create directory if doesnt exist
SUD02         CrtDirCL(%Trim(WkPath));
SUD01      Endif;
  |
  |        WkFile = 'INVAVL-' + %Trim(WkBroker) +  '_'
  |                              + %Char(%Timestamp()) + '.xml';
  |        Cmd = 'CPYTOIMPF FROMFILE(IFSXML) STMFCODPAG(1208) ' +
  |              'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
  |              + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)';
  |        Exsr CallCmd;
  |
  |     EndSr;
  |   //--------------------------------------------------------------------
  |   *?                :-------------------:
  |   *?                : Endpgm Subroutine :
  |   *?                :-------------------:
  |   *
  |     Begsr EndPgm;
  |
  |   *?   // Clear Flat File
  |        Cmd  = 'CLRPFM FILE(QTEMP/IFSXML)';
SUD01      Exsr CallCmd;

      *?   // Return
           *InLR = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
        Begsr Process;

      *?   // Generate XML for Michell
           If PBrokerID = 3975;

      *?      // Start Tag
              AddToXml('MichellAvailability_V1' : *Blanks : 'Starttag');

      *?      // XML Body
              Exsr MIdentificationSR;
              Exsr MAvailabilityDataSR;

      *?      // End Tag
              AddToXml('MichellAvailability_V1' : *Blanks : 'Endtag');
           Endif;

      *?   // Generate XML for Gloeckner
           If PBrokerID = 234;

      *?      // Start Tag for Gloeckner
              AddToXml('AvailabilityFeed' : *Blanks : 'Starttag');

      *?      // XML Body
              Exsr GIdentificationSR;
              Exsr GAvailabilityDataSR;

      *?      // End Tag
              AddToXml('AvailabilityFeed' : *Blanks : 'Endtag');
           Endif;

      *?   // Add XML Header in Return Xml
           PInvXml = '<?xml version="1.0" encoding="utf-8" ?> ' + Xml;
           If PInvXml <> *Blanks;
              HttpStatus=200;
           Endif;

        EndSr;
      //-------------------------------------------------------------------------
      *?                :------------------------------:
      *?                : MIdentificationSR Subroutine :
      *?                :------------------------------:
      *
        Begsr MIdentificationSR;

      *?   // Move values into Identification Part
           AddToXml('Identification' : *Blanks : 'Opentag');
           AddToXml('MessageProtocol_ID' : 'MichellAvailability_V1'
                                            : 'Attribute');

      *?   // Get values from Broker Default Parameter File
           Chain (WkBrokerId:'FromOrgId') FBrokDftL0;
           If %Found;
              AddToXml('FromOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
              AddToXml('SenderOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
           Endif;

           Chain (WkBrokerId:'ToOrgId') FBrokDftL0;
           If %Found;
              AddToXml('ToOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
           Endif;
           AddToXml('Date' : WkDtTm : 'Closetag');

        EndSr;
      //-------------------------------------------------------------------------
      *?                :------------------------------:
      *?                : GIdentificationSR Subroutine :
      *?                :------------------------------:
      *
        Begsr GIdentificationSR;

      *?   // Move values into Identification Part
           AddToXml('Identification' : *Blanks : 'Starttag');
SUD01      AddToXml('MessageProtocol_ID' : 'AvailabilityFeed' : 'Element');

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
SUD01      AddToXml('Reference_ID' :  WkRefId  : 'Element');
SUD01      AddToXml('DateTime' : WkDtTm : 'Element');

      *?   // Get values from Broker Default Parameter File
           Chain (WkBrokerId:'FromOrgId') FBrokDftL0;
           If %Found;
SUD01         AddToXml('FromOrg_ID' : %Trim(DFVARVAL) : 'Element');
           Endif;

           Chain (WkBrokerId:'ToOrgId') FBrokDftL0;
           If %Found;
SUD01         AddToXml('ToOrg_ID' : %Trim(DFVARVAL) : 'Element');
           Endif;
SUD01      AddToXml('Identification' : *Blanks : 'Endtag');

      *?   // Generate Xml Availability Header Part
           AddToXml('AvailabilityHeader' : *Blanks : 'Starttag');
SUD01      Chain (WkBrokerId:'VendorNumber') FBrokDftL0;
  |        If %Found;
  |           AddToXml('VendorNumber' : %Trim(DFVARVAL) : 'Element');
SUD01      Endif;
SUD01      Chain (WkBrokerId:'VendorName') FBrokDftL0;
  |        If %Found;
  |           AddToXml('VendorName' : %Trim(DFVARVAL) : 'Element');
SUD01      Endif;
           AddToXml('AvailabilityHeader' : *Blanks : 'Endtag');

        EndSr;
      //------------------------------------------------------------------------
      *?                :--------------------------------:
      *?                : MAvailabilityDataSR Subroutine :
      *?                :--------------------------------:
      *
        Begsr MAvailabilityDataSR;

      *?   // Generate Xml for Michell
           AddToXml('AvailabilityData' : *Blanks : 'Starttag');

      *?   // Generate Xml Item for Availability Data Part
           Exsr MItemAvlQty;

           AddToXml('AvailabilityData' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------------------:
      *?                : GAvailabilityDataSR Subroutine :
      *?                :--------------------------------:
      *
        Begsr GAvailabilityDataSR;

      *?   // Generate Xml Item for Availability Data Part for Gloeckner
           Exsr GItemAvlQty;

        EndSr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : MItemAvlQty Subroutine :
      *?                :------------------------:
      *
        Begsr MItemAvlQty;

      *?   // Sequence #
           WkSequence = 0;

      *?   // Read the file to Process XML
           Setll *Start WSINVAVLL0;
           Read WSINVAVLL0;
           Dow Not %Eof;

      *?      // Sum Quantity for records having same Item and Date
              If (WKITEM <> WkItm1 or DATEY00001 <> WkDte1)
                  and WKItm1 <> *Blanks;
                  Exsr MBuildxml;
                  WkQty1 = *Zeros;
              Endif;

      *?      // Move file fields to work variables
              WkItm1 = WKITEM;
              WkDte1 = DATEY00001;
              WkIQty = %Int(WKQTY);
              WkQty1 = WkIQty + WkQty1;

              Read WSINVAVLL0;
           Enddo;

      *?   // Write Last record
           Exsr MBuildxml;

        EndSr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : MBuildxml Subroutine :
      *?                :----------------------:

        Begsr MBuildxml;

      *?   // Initialise Variables
           WkAQty = 0;
           WkForItem = *Blanks;

      *?   // Get Item from Cross Reference
           Chain (WkBroker : 'Customer' :WkItm1) XREFINVTL1;
           If %Found;
              WkForItem = XRFORKEY;

      *?      // Check Size for the Line Item
              Chain XRLCLSIZE FMSIZE;
              If %Found and SZSTAT = 'A';
                 WkAQty = WkQty1 * SZSALE;
              Else;
                 WkAQty = WkQty1;
              Endif;
           Endif;

      *?   // Send Item Material only if Cross reference is found
           If WkForItem <> *Blanks;

      *?      // Increment Sequence
              WkSequence = WkSequence + 1;
              AddToXml('Item' : *Blanks : 'Opentag');

              AddToXml('GeneralAvailabilityQty' : %Char(WkAQty) :
                                                  'Attribute');
              AddToXml('MichellsMaterialID' : %Trim(WkForItem) :
                                             'Attribute');
              AddToXml('Sequence' : %Char(WkSequence) : 'Attribute');

      *?      // Convert Date to ISO format
              WkDateN = %Int(WkDte1);
              WkDateC = %Char(%Date(WkDateN : *Iso));
              AddToXml('ShipWeekMonday' : WkDateC : 'Attribute');
              AddToXml('VendorID' : *Blanks : 'Attribute');
              AddToXml('VendorMaterialID' : %Trim(WkItm1) : 'Closetag');
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : GItemAvlQty Subroutine :
      *?                :------------------------:
      *
        Begsr GItemAvlQty;

      *?   // Read the file to Process XML
           Setll *Start WSINVAVLL0;
           Read WSINVAVLL0;
           Dow Not %Eof;

      *?      // Sum Quantity for records having same Item and Date
              If (WKITEM <> WkItm1 or DATEY00001 <> WkDte1)
                 and WKItm1 <> *Blanks;
                 Exsr GBuildxml;
                 WkQty1 = *Zeros;
              Endif;

      *?      // Move file fields to work variables
              WkItm1 = WKITEM;
              WkDte1 = DATEY00001;
              WkIQty = %Int(WKQTY);
              WkQty1 = WkIQty + WkQty1;

              Read WSINVAVLL0;
           Enddo;

      *?   // Write last record
           Exsr GBuildxml;

        EndSr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : GBuildxml Subroutine :
      *?                :----------------------:
        Begsr GBuildxml;

      *?   // Initialise Variables
           WkAQty = 0;
           WkForItem = *Blanks;

      *?   // Get Item from Cross Reference
           Chain (WkBroker : 'Customer' :WKItm1) XREFINVTL1;
           If %Found Or Not %Found;                 // Changed to not use XREFINVT
              WkForItem = XRFORKEY;
              WkForItem = WKItm1;                   // Just send KP Item Number instead

      *?      // Check Size for the Line Item
              Chain XRLCLSIZE FMSIZE;
              If %Found and SZSTAT = 'A';
                 WkAQty = WkQty1 * SZSALE;
              Else;
                 WkAQty = WkQty1;
              Endif;
           Endif;

      *?   // Convert Date to ISO format
           WkDateN = %Int(WkDte1);
           WkDateC = %Char(%Date(WkDateN : *Iso));

      *?   // Generate Xml Availability Data Part for Gloeckner
      *?   // Send Item Material only if Cross reference is found
           If WkForItem <> *Blanks;
              AddToXml('AvailabilityItem' : *Blanks : 'Starttag');
              AddToXml('MaterialNumber' : *Blanks : 'Starttag');
              AddToXml('Type' : 'SELLER' : 'Element');
              AddToXml('Number' : %Trim(WkForItem) : 'Element');
              AddToXml('MaterialNumber' : *Blanks : 'Endtag');

              AddToXml('AvailabilityDate' : *Blanks : 'Starttag');
              AddToXml('Date' : WkDateC : 'Element');
              AddToXml('AvailabilityDate' : *Blanks : 'Endtag');

              AddToXml('Units' : *Blanks : 'Starttag');
              AddToXml('UnitOfMeasure' : 'EA' : 'Element');
              AddToXml('Count' : %Char(WkAQty) : 'Element');
              AddToXml('Units' : *Blanks : 'Endtag');
              AddToXml('AvailabilityItem' : *Blanks : 'Endtag');
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : PostXml Subroutine :
      *?                :--------------------:
      *
        Begsr PostXml;

SUD01 *?   // To get tech info about the HTTP transaction
  |        Chain (WkBrokerId:'StoreLog') FBrokDftL0;
  |        If %Found;
  |           If DFVARVAL = '1';
  |              WkLog = '/tmp/httpapi_POSTINVENT/' + %trim(WkBroker) + '_' +
  |                       %Char(%Timestamp()) + '.log';
  |              Http_debug(*ON: WkLog);
  |           Else;
  |              Http_debug(*ON: '/tmp/httpapi_POSTINVENT.log');
  |           Endif;
  |        Else;
  |           Http_debug(*ON: '/tmp/httpapi_POSTINVENT.log');
SUD01      Endif;

      *?   // Get Url from Control File
           Chain (WkBrokerId :'URL INVENTORY POST') FBROKDFTL0;
           If %Found;
              Url =  %Trim(DFVARVAL);
           Endif;

SUD01 *?   // FTP xml to client site
  |        WkFtp = '0';
  |        Chain (WkBrokerId :'USEFTP') FBROKDFTL0;
  |        If %Found;
  |           WkFtp = %Trim(DFVARVAL);
  |           If WkFtp = '1';
  |              Exsr FtpProcess;
  |           Endif;
SUD01      Endif;

      *?   // POST xml to client site
           If WKFtp = '0';
              Http_url_post_xml(Url : %Addr(Xml) : %Len(%Trim(Xml))
                                 : *NULL : *NULL : *NULL );
           Endif;

        EndSr;
SUD01 //--------------------------------------------------------------------
  |   *?                :-----------------------:
  |   *?                : FtpProcess Subroutine :
  |   *?                :-----------------------:
  |   *
  |     Begsr FtpProcess;
  |
  |   *?   // Copy into Local Data
  |        WkPath = '/INVENTORY/SEND/';
  |
  |        WkFile = 'INVAVL-' + %Trim(WkBroker) +  '_'
  |                              + %Char(%Timestamp()) + '.xml';
  |        Cmd = 'CPYTOIMPF FROMFILE(IFSXML) STMFCODPAG(1208) ' +
  |              'TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
  |              + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*FIXED)';
  |        Exsr CallCmd;
  |
  |   *?   // Call FTP Program to Send XML
  |        WSINVFTPC(PPgmName : PLogName);
  |
  |   *?   // Remove Link
  |        Cmd = 'RMVLNK OBJLNK(''' + %Trim(WkPath) +
  |                             %Trim(Wkfile) + ''')';
  |        Exsr CallCmd;
  |
  |     Endsr;
SUD01 //--------------------------------------------------------------------
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
      *?          Element  : <Tagname></Tagname>
      *
        Dcl-Proc  AddToXml;
          Dcl-Pi AddToXml;
            Tagname      Char(50)  Value;
            Tagvalue     Char(300) Value;
            Info         Char(10)  Value;
          End-Pi;

      *?   // Replace Special Characters
SUD01      If TagValue <> *Blanks;
  |           TagValue = %ScanRpl('&': '&amp;': TagValue);
  |           TagValue = %ScanRpl('''': '&apos;' : TagValue);
  |           TagValue = %ScanRpl('"': '&quot;' : TagValue);
SUD01      Endif;

      *?  // Check Info to add XML tag
          Select;

             When Info = 'Starttag';
                Xml = %Trimr(Xml) + '<' + %Trim(Tagname)
                                 + %Trim(Tagvalue)  + '> ';

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
            Exsr WriteIFS;

      //--------------------------------------------------------------------
      *?            :---------------------:
      *?            : WriteIFS Subroutine :
      *?            :---------------------:
      *
      *?Logic : Write Each tag as a Record into Flat File
      *?
        Begsr WriteIFS;

      *?   // Check Info to add XML tag
           Select;

              When Info = 'Starttag';
                 XmlIfs =  '<' + %Trim(Tagname)
                                 + %Trim(Tagvalue)  + '>';

              When Info = 'Opentag';
                 XmlIfs =  '<' + %Trim(Tagname) ;

              When Info = 'Attribute';
                 XmlIfs =  %Trim(Tagname) + '="'
                                 + %Trim(Tagvalue) + '" ';

              When Info = 'Closetag';
                 XmlIfs =  %Trim(Tagname) + '="'
                                   + %Trim(Tagvalue) + '"' + ' />';

              When Info = 'Close';
                 XmlIfs =  %Trim(Tagname) + '="'
                                   + %Trim(Tagvalue) + '"' + ' >';

              When Info = 'Endtag';
                 XmlIfs = ' </' + %Trim(Tagname) + '>';

              When Info = 'Element';
                 XmlIfs = ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

           Endsl;

      *?   // Insert into Flat File
           Exec Sql
           INSERT INTO IFSXML Values(:XMLIFS);

        Endsr;

        End-Proc;
      *?------------- End of Program ----------------------------------
