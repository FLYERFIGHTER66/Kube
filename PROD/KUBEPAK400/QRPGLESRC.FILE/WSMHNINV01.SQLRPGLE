      *? Program        : WSMHNINV01
      *?
      *? Description    : This program to Generate Inventory XML using POST
      *?                  method for Available Quantity for McHutchison
      *? Created By     : Vimala
      *?
      *? Date           : 7 Nov 2018
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
      * SUD01   06/11/19   S.Uthaya     Bug Fixing in FTP Process
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
        Dcl-Pi WSMHNINV01;
           PBrokerId   Char(6);
           PStartDt    Char(8);
           PEndDt      Char(8);
        End-Pi;
      *
      *?Procedure Prototype Declaration : WSSNDFTPC
        Dcl-Pr WSSNDFTPC ExtPgm;
           PPgmName   Char(10);
           PLogName   Char(10);
        End-Pr;
      *
      *?Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname  Char(50)   Value;
           Tagval   Char(300)  Value;
           Info     Char(10)   Value;
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd  Char(2000)   Const Options(*Varsize);
           Len  Packed(15:5) Const;
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Create Directory
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
           WDItem Char(22)   Inz;
           WDDate Char(8)    Inz;
           WDQty  Packed(10) Inz;
        End-Ds;
      *
      *?Parameter Variable Declaration :
        Dcl-S PPgmName   Char(10)      Inz('WSINVMHFTP');
        Dcl-S PLogName   Char(10)      Inz('WSINVMHLOG');
      *
      *?Global Variable Declaration :
        Dcl-S Cmd        Char(2000)    Inz;
        Dcl-S Url        Char(400)     Inz;
        Dcl-S XmlIfs     Char(300)     Inz;
        Dcl-S Info       Char(10)      Inz;
      *
      *?Work Variable Declaration :
        Dcl-S NullValue  Like(NullInd) Dim(3) Inz(-1);
        Dcl-S NullInd    Int(5)        Inz(0);
        Dcl-S WkDateN    Int(10:0)     Inz;
        Dcl-S WkAQty     Int(10:0)     Inz;
        Dcl-S WkRefNo    Zoned(6)      Inz;
        Dcl-S WkTempFile Char(200)     Inz;
        Dcl-S WkDtTm     Char(19)      Inz;
        Dcl-S WkDateC    Char(10)      Inz;
        Dcl-S WkRefId    Char(32)      Inz;
        Dcl-S WkBrokerId Char(10)      Inz;
        Dcl-S WkBroker   Char(15)      Inz;
        Dcl-S WkForItem  Char(30)      Inz;
        Dcl-S WkPath     Char(75)      Inz;
        Dcl-S WkFile     Char(75)      Inz;
        Dcl-S WkFtp      Char(1)       Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Initialize
           Exsr InzPgm;

      *?   // Process data and build Xml
           Exsr Process;

      *?   // Store XML into IFS
           Exsr StoreIfs;

      *?   // Post XML
           Exsr PostXml;

      *?   // End Program
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
           Exec SQL create or replace table qtemp.IFSXML (IFSXML VARCHAR(300));
           Exec SQL delete from qtemp.IFSXML;

      *?   // Insert XML Header into Flat File
           XmlIfs = '<?xml version="1.0" encoding="utf-8" ?>';
           Exec Sql
           INSERT INTO IFSXML Values(Trim(:XmlIfs));
           XmlIfs = *Blanks;

      *?   // Add HTTP Library to Library List
           Cmd = 'ADDLIBLE LIB(LIBHTTP) POSITION(*Last)';
           Exsr CallCmd;

      *?   // Move Entry parameter to Work Variable and read FBROKDFT file
           WkBrokerId = PBrokerId;
           Chain ('1000' : WkBrokerId) FBrokDftL0;
           If %Found;
              WkBroker =  %Trim(DFVARVAL);
           Endif;


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
           AddToXml('AvailabilityFeed' : *Blanks : 'Starttag');

      *?   // XML Body
           Exsr IdentificationSR;
           Exsr AvailabilityDataSR;

      *?   // End Tag
           AddToXml('AvailabilityFeed' : *Blanks : 'Endtag');

        EndSr;
      //-------------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : IdentificationSR Subroutine :
      *?                :-----------------------------:
      *
        Begsr IdentificationSR;

      *?   // Move values into Identification Part
           AddToXml('Identification' : *Blanks : 'Starttag');
           AddToXml('MessageProtocol_ID' : 'AvailabilityFeed' : 'Element');

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
           AddToXml('Reference_ID' :  WkRefId  : 'Element');
           AddToXml('DateTime' : WkDtTm : 'Element');

      *?   // Get values from Broker Default Parameter File
           Chain (WkBrokerId:'FromOrgId') FBrokDftL0;
           If %Found;
              AddToXml('FromOrg_ID' : %Trim(DFVARVAL) : 'Element');
           Endif;

           Chain (WkBrokerId:'ToOrgId') FBrokDftL0;
           If %Found;
              AddToXml('ToOrg_ID' : %Trim(DFVARVAL) : 'Element');
           Endif;
           AddToXml('Identification' : *Blanks : 'Endtag');

      *?   // Generate Xml Availability Header Part
           AddToXml('AvailabilityHeader' : *Blanks : 'Starttag');
           Chain (WkBrokerId:'VendorNumber') FBrokDftL0;
           If %Found;
              AddToXml('VendorNumber' : %Trim(DFVARVAL) : 'Element');
           Endif;
           Chain (WkBrokerId:'VendorName') FBrokDftL0;
           If %Found;
              AddToXml('VendorName' : %Trim(DFVARVAL) : 'Element');
           Endif;
           AddToXml('AvailabilityHeader' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------------------:
      *?                : AvailabilityDataSR Subroutine :
      *?                :-------------------------------:
      *
        Begsr AvailabilityDataSR;

      *?   // Generate Xml Item for Availability Data Part for Gloeckner
           Exsr ItemAvlQty;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ItemAvlQty Subroutine :
      *?                :-----------------------:
      *
        Begsr ItemAvlQty;

      *?   // Build SQL to read data between the received Parameter dates
           Exec Sql Declare A1 Cursor for
              Select WAITEM,WADATE, sum(WAQTY)
                 from WSSTDINAL0
                 where WADATE >= :PStartDt and WADATE <= :PEndDt
                 Group by WAITEM, WADATE
                 Order by WAITEM, WADATE
                 For Read Only;

           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           EndIf;

           Exec Sql Fetch A1 into :WDs :NullInd;
           Dow SqlCod = 0;
              Exsr Buildxml;
              Exec Sql Fetch A1 into :WDs :NullInd;
           Enddo;

      *?   // Write last record
           Exsr Buildxml;

        EndSr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Buildxml Subroutine :
      *?                :----------------------:
        Begsr Buildxml;

      *?   // Initialise Variables
           WkAQty = 0;

      *?   // Get Item from Cross Reference
           Chain (WkBroker : 'Customer' :WDs.WDItem) XREFINVTL1;
           If %Found;

      *?      // Check Size for the Line Item
              Chain XRLCLSIZE FMSIZE;
              If %Found and SZSTAT = 'A';
                 WkAQty = WDs.WDQty * SZSALE;
              Else;
                 WkAQty = WDs.WDQty;
              Endif;
           Endif;

      *?   // Generate Xml Availability Data Part for McHutchison
      *?   // Send Item Material only if Cross reference is found
           AddToXml('AvailabilityItem' : *Blanks : 'Starttag');
           AddToXml('MaterialNumber' : *Blanks : 'Starttag');
           AddToXml('Type' : 'SELLER' : 'Element');
           AddToXml('Number' : %Trim(WDs.WDItem) : 'Element');
           AddToXml('MaterialNumber' : *Blanks : 'Endtag');

      *?   // Convert Date to ISO format
           WkDateN = %Int(WDs.WDDate);
           WkDateC = %Char(%Date(WkDateN : *Iso));
           AddToXml('AvailabilityDate' : *Blanks : 'Starttag');
           AddToXml('Date' : WkDateC : 'Element');
           AddToXml('AvailabilityDate' : *Blanks : 'Endtag');

           AddToXml('Units' : *Blanks : 'Starttag');
           AddToXml('UnitOfMeasure' : 'EA' : 'Element');
           AddToXml('Count' : %Char(WkAQty) : 'Element');
           AddToXml('Units' : *Blanks : 'Endtag');
           AddToXml('AvailabilityItem' : *Blanks : 'Endtag');

        EndSr;
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

      *?   // FTP xml to Client site
           WkFtp = '0';
           Chain (WkBrokerId :'USEFTP') FBROKDFTL0;
           If %Found;
              WkFtp = %Trim(DFVARVAL);
              If WkFtp = '1';
                 Exsr FtpProcess;
              Endif;
           Endif;

      *?   // POST stmf file created to client site
           If WKFtp = '0';

      *?      // HTTP creates new file to receive reply
              WkTempfile =  http_tempfile();

      *?      // Post Stmf file created to Client site
              Http_url_post_stmf(%Trim(Url) :%Trim(WkPath) + %Trim(WkFile)
                                    :WkTempFile);
      *?      // Remove Link
              Cmd = 'RMVLNK OBJLNK(''' + %Trim(WkPath) +
                                %Trim(Wkfile) + ''')';
              Exsr CallCmd;

           Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : FtpProcess Subroutine :
      *?                :-----------------------:
      *
        Begsr FtpProcess;

      *?   // Get Path to send Streamfile using FTP  - Local Directory
           Chain (WkBrokerId : 'IFSINVFTP') FBrokDftL0;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

           WkFile = 'INV-' + %Trim(WkBroker) +  '_'
                                 + %Char(%Timestamp()) + '.xml';
           Cmd = 'CPYTOIMPF FROMFILE(IFSXML) STMFCODPAG(1208)'
               + ' TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
               + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*DLM)'
               + ' STRDLM(*NONE) RMVBLANK(*TRAILING)';
           Exsr CallCmd;

      *?   // Call FTP Program to Send XML
           WSSNDFTPC(PPgmName : PLogName);

SUD01 *?   // Remove Link
  |        Cmd = 'RMVLNK OBJLNK(''' + %Trim(WkPath) + %Trim(Wkfile) + ''')';
SUD01      Exsr CallCmd;

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
