      *? Program        : WSGRFINV01
      *?
      *? Description    : This program to Generate Inventory XML using POST
      *?                  method for Available Quantity for Griffin
      *? Created By     : Vimala
      *?
      *? Date           : 30 Oct 2018
      //--------------------------------------------------------------------
      *? Special Notes  : *Entry Parameters
      *?                  Broker Id  (6A)  - Input Parameter
      *?                  Start Week (8A)  - Input Parameter
      *?                  End Week   (8A)  - Input Parameter
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
        Dcl-Pi WSGRFINV01;
           PBrokerId  Char(6);
           PStartDt   Char(8);
           PEndDt     Char(8);
        End-Pi;
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
           Cmd  Char(2000)   Const Options(*Varsize);
           Len  Packed(15:5) Const;
        End-Pr;
      *
      *?Procedure Interface Declaration : Pgm to Create Directory
        Dcl-Pr CRTDIRCL Extpgm;
           Link  Char(256)   Const;
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
      *?Inventory Data Structure :
        Dcl-Ds WDs Qualified;
           WDItem Char(22) Inz;
           WDDate Char(8)  Inz;
           WDQty  Packed(10)  Inz;
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S Cmd        Char(2000)    Inz;
        Dcl-S XmlIfs     Char(300)     Inz;
        Dcl-S Info       Char(10)      Inz;
        Dcl-S Url        Char(400)     Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkDtTm     Char(19)      Inz;
        Dcl-S WkDateN    Int(10:0)     Inz;
        Dcl-S WkDateC    Char(10)      Inz;
        Dcl-S WkRefNo    Zoned(6)      Inz;
        Dcl-S WkRefId    Char(32)      Inz;
        Dcl-S WkBrokerId Char(10)      Inz;
        Dcl-S WkBroker   Char(15)      Inz;
        Dcl-S WkForItem  Char(30)      Inz;
        Dcl-S WkForItemD Char(50)      Inz;
        Dcl-S WkAQty     Int(10:0)     Inz;
        Dcl-S WkPath     Char(75)      Inz;
        Dcl-S WkFile     Char(75)      Inz;
        Dcl-S NullInd    Int(5)        Inz(0);
        Dcl-S NullValue  like(NullInd) Dim(3) Inz(-1);
        Dcl-S WkTempFile Char(200)  Inz;
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

      *?   // Get Date and Time
           WkDtTm = %Char(%Date) + 'T' + %Char(%Time());

      *?   // Create IFSXML temp file in QTEMP
           Exec SQL create or replace table QTEMP.IFSXML (IFSXML VARCHAR(300));
           Exec SQL delete from qtemp.IFSXML;

      *?   // Insert XML Header into Flat File
           XmlIfs = '<?xml version="1.0" encoding="utf-8" ?>';
           Exec Sql
           INSERT INTO IFSXML Values(Trim(:XmlIfs));
           XmlIfs = *Blanks;

      *?   // Add HTTP Library to Library List
           Cmd = 'ADDLIBLE LIB(LIBHTTP) POSITION(*Last)';
           Exsr CallCmd;

      *?   // Move Entry parameter to get Broker Name
           WkBrokerId = PBrokerId;
           Chain ('1000' : WkBrokerId) FBrokDftL0;
           If %Found;
              WkBroker =  %Trim(DFVARVAL);
           Endif;

      *?   // Process data and build Xml
           Exsr Process;

      *?   // Store XML into IFS
           Exsr StoreIfs;

      *?   // Post XML
           Exsr PostXml;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CallCmd Subroutine :
      *?                :--------------------:
      *
        Begsr CallCmd;

      *?   // Call CL program to perform Command
           Monitor;
              QCmdExc(%Trim(Cmd): %Len(%Trim(Cmd)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : StoreIfs Subroutine :
      *?                :---------------------:
      *
        Begsr StoreIfs;

      *?   // Create stream file
           Chain ('IFS' : 'IFSINVPATH' ) FBROKDFTL0;
           If %Found;
              WkPath = %Trim(DFVARVAL) +
                       %Trim(%Char(%date))+'/';
      *?      // Create directory if doesnt exist
              CrtDirCL(%Trim(WkPath));
           Endif;

      *?   // Copy file to IFS
           WkFile = 'INV-' + %Trim(WkBroker) +  '_'
                                 + %Char(%Timestamp()) + '.xml';
           Cmd = 'CPYTOIMPF FROMFILE(IFSXML) STMFCODPAG(1208)'
               + ' TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
               + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*DLM)'
               + ' STRDLM(*NONE) RMVBLANK(*TRAILING)';
           Exsr CallCmd;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Clear Flat File
           Cmd  = 'CLRPFM FILE(QTEMP/IFSXML)';
           Exsr CallCmd;

      *?   // Close Cursor
           Exec Sql Close A1;

      *?   // Remove Tempfile link created by HTTP
           Cmd = 'RMVLNK OBJLNK(''' + %Trim(WkTempFile) + ''')';
           Exsr CallCmd;

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

      *?   // Start Tag
           AddToXml('GriffinAvailability_V1' : *Blanks : 'Starttag');

      *?   // XML Body
           Exsr IdentificationSR;
           Exsr AvailabilityDataSR;

      *?   // End Tag
           AddToXml('GriffinAvailability_V1' : *Blanks : 'Endtag');

        EndSr;
      //-------------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : IdentificationSR Subroutine :
      *?                :-----------------------------:
      *
        Begsr IdentificationSR;

      *?   // Move values into Identification Part
           AddToXml('Identification' : *Blanks : 'Opentag');
           AddToXml('MessageProtocol_ID' : 'GriffinAvailability_V1'
                                            : 'Attribute');

      *?   // Get values from Broker Default Parameter File
           Chain (WkBrokerId:'FromOrgId') FBrokDftL0;
           If %Found;
              AddToXml('FromOrg_ID' : %Trim('002577') : 'Attribute');
              AddToXml('SenderOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
           Endif;

           Chain (WkBrokerId:'ToOrgId') FBrokDftL0;
           If %Found;
              AddToXml('ToOrg_ID' : %Trim(DFVARVAL) : 'Attribute');
           Endif;
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
           AddToXml('Reference_ID' :  WkRefId  : 'Attribute');
           AddToXml('Date' : WkDtTm : 'Closetag');

        EndSr;
      //-------------------------------------------------------------------------
      *?                :-------------------------------:
      *?                : AvailabilityDataSR Subroutine :
      *?                :-------------------------------:
      *
        Begsr AvailabilityDataSR;

      *?   // Generate Availability data for Griffin
           AddToXml('AvailabilityData' : *Blanks : 'Starttag');

      *?   // Generate Xml Item for Availability Data Part
           Exsr ItemAvlQty;

           AddToXml('AvailabilityData' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ItemAvlQty Subroutine :
      *?                :-----------------------:
      *
        Begsr ItemAvlQty;

      *?// Build SQL to read data between the received Parameter dates

           Exec Sql Declare A1 Cursor for
              Select WAITEM,WADATE, sum(WAQTY)
                 from WSSTDINAL0
                 where WADATE >= :PStartDt and WADATE <= :PEndDt
                 Group by WAITEM, WADATE
                 Order by WAITEM, WADATE
                 For Read Only;

           Exec Sql
           Open A1;
           If SqlCode = -502 ;
              Exec Sql
              Close A1;
              Exec Sql
              Open A1;
           EndIf;

           Exec Sql Fetch A1 into :WDs :NullInd;
           Dow SqlCod = 0;
              Exsr Buildxml;
              Exec Sql Fetch A1 into :WDs :NullInd;
           Enddo;

      *?   // Write Last record
           Exsr Buildxml;

        EndSr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : Buildxml Subroutine :
      *?                :---------------------:

        Begsr Buildxml;

      *?   // Initialise Variables
           WkAQty = 0;
           WkForItem = *Blanks;
           WkForItemD = *Blanks;

      *?   // Get Item from Cross Reference
           Chain (WkBroker : 'Customer' :WDs.WDItem) XREFINVTL1;
           If %Found;
              WkForItem  = XRFORKEY;
              WkForItemD = XRDESC;

      *?      // Check Size for the Line Item
              Chain XRLCLSIZE FMSIZE;
              If %Found and SZSTAT = 'A';
                 WkAQty = WDs.WDQty * SZSALE;
              Else;
                 WkAQty = WDs.WDQty;
              Endif;
           Endif;

      *?   // Send Item Material only if Cross reference is found
           If WkForItem <> *Blanks;

              AddToXml('Item' : *Blanks : 'Opentag');
              AddToXml('BlanketQty' : '0' : 'Attribute');
              AddToXml('GeneralAvailabilityQty' : %Char(WkAQty) :
                                                  'Attribute');
              AddToXml('GriffinMaterialID' : %Trim(WkForItem) :
                                             'Attribute');

      *?      // Convert Date to ISO format
              WkDateN = %Int(WDs.WDDate);
              WkDateC = %Char(%Date(WkDateN : *Iso));
              AddToXml('ShipWeekMonday' : WkDateC : 'Attribute');
              AddToXml('VendorID' : '002577' : 'Attribute');
              AddToXml('VendorMaterialID' : %Trim(WkForItemD) : 'Closetag');
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : PostXml Subroutine :
      *?                :--------------------:
      *
        Begsr PostXml;

      *?   // To get tech info about the HTTP transaction
           Http_debug(*ON: '/tmp/httpapi_POSTBRKINV.log');

      *?   // Get Url from Control File
           Chain (WkBrokerId :'URL INVENTORY POST') FBROKDFTL0;
           If %Found;
              Url =  %Trim(DFVARVAL);
           Endif;

      *?   // HTTP creates new file to receive reply
           WkTempfile = http_tempfile();

      *?   // POST stmf file created to client site
           Http_url_post_stmf(%Trim(Url) :%Trim(WkPath) + %Trim(WkFile)
                                    :WkTempFile);

        EndSr;
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
      *?          Element  : <Tagname></Tagname>
      *
        Dcl-Proc  AddToXml;
          Dcl-Pi AddToXml;
            Tagname      Char(50)  Value;
            Tagvalue     Char(300) Value;
            Info         Char(10)  Value;
          End-Pi;

      *?   // Replace Special Characters
           If TagValue <> *Blanks;
              TagValue = %ScanRpl('&': '&amp;': TagValue);
              TagValue = %ScanRpl('''': '&apos;' : TagValue);
              TagValue = %ScanRpl('"': '&quot;' : TagValue);
           Endif;

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
           INSERT INTO IFSXML Values(Trim(:XMLIFS));

        Endsr;

        End-Proc;
      *?------------- End of Program ----------------------------------
