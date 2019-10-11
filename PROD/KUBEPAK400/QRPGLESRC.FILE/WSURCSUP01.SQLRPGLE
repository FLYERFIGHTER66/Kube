      *? Program        :  WSURCSUP01
      *?
      *? Description    : This program is to Get XML from Suppliers URL
      *?                  and upload the XML data into file
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 05 Jun 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Get XML from  Suppliers URL
      *?                : ** Write XML data into IFS stream file
      *?                : ** Write XML data in Supplier Inventory File
      *?                : ** COMPILE program with?COMMIT(*CHG)
      *
      *? Called Program : QCMDEXC - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
 VV01 * VV01    09/18/18   Vimala       Provide Null Indicator for Allocated
 VV01 *                                 Quantity calculation in SQL
 VV02 * VV02    10/05/18   Vimala       Include Monitor/EndMon for Error
 VV02 *                                 in Http_Url_get statement
WJB01 * WJB01   11/07/18   W.J.Behr     Use KP Vendor # not Vend supplied number
WJB02 * WJB02   11/08/18   W.J.Behr     Change Directory
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
           BndDir('HTTPAPI');
      *
      *?Include Httpapi_h Source
      /Include QRpglesrc,Httpapi_h
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Supplier Inventory File
      *?Key : Customer Number : Card Number : Token Number
        Dcl-F WSSUPINVPF Disk(*Ext) Usage(*Output:*Delete);
      *
      *?File: Broker Default File
      *?Key : Customer Number : Customer Number : Token Number
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
      *?Procedure Interface Declaration: *Entry Parameters
        Dcl-Pi WSURCSUP01 ExtPgm;
           PSupCde  Char(6);
           PSeason  Char(2);
           PSDate   Char(2);
           PEDate   Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(200)    Const Options(*Varsize);
           Len Packed(15:5) Const;
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
      *?Data Structure for Date
        Dcl-Ds DateFmt Len(10) Qualified;
           WkYear  Char(4) Pos(1);
           WkMonth Char(2) Pos(6);
           WkDate  Char(2) Pos(9);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S Cmd       Char(400)    Inz;
        Dcl-S Url       Char(400)    Inz;
        Dcl-S Rc        Int(10:0)    Inz;
        Dcl-S Filename  Char(100)    Inz;
        Dcl-S XmlFile   Char(100)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkFile    Char(75)    Inz;
        Dcl-S WkPath    Char(75)    Inz;
        Dcl-S WkMsgPr   Char(30)    Inz;
        Dcl-S WkRefId   Char(40)    Inz;
        Dcl-S WkDateTm  Char(19)    Inz;
        Dcl-S WkFrmId   Char(30)    Inz;
        Dcl-S WkToId    Char(30)    Inz;
        Dcl-S WkVenNum  Char(6)     Inz;
        Dcl-S WkVenNam  Char(15)    Inz;
        Dcl-S WkType    Char(10)    Inz;
        Dcl-S WkItem    Char(10)    Inz;
        Dcl-S WkAvlDt   Char(19)    Inz;
        Dcl-S WkUOM     Char(3)     Inz;
        Dcl-S WkAvlQty  Char(11)    Inz;
        Dcl-S WkSeq     Int(10:0)   Inz;
        Dcl-S WkUrl     Char(200)   Inz;
        Dcl-S WkLItm    Char(15)    Inz;
        Dcl-S WkLSiz    Char(3)     Inz;
        Dcl-S WkAvlDat  Packed(7)   Inz;
        Dcl-S WkAlcQty  Packed(11)  Inz;
        Dcl-S WkBroker  Packed(6)   Inz;
 VV01   Dcl-S NullInd  Int(5)    Inz(0);                  //Null Indicator for WkAlcQty
 VV01   Dcl-S NullValue Like(NullInd) Inz(-1);
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Get XML from Supplier Url
           Exsr GetXml;

      *?   // End Program
           Exsr EndPgm;

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
      *?                :-------------------:
      *?                : GetXml Subroutine :
      *?                :-------------------:
      *
        Begsr GetXml;

      *?   // To get tech info about the HTTP transaction
           Http_debug(*ON: '/tmp/httpapi_URCGETXML.log');

      *?   // Get Url from Control File
           Chain (PSupCde :'SUPPURLPATH') FBROKDFTL0;
           If %Found;
              WkUrl =  %Trim(DFVARVAL);
           Endif;

           Url = %Trim(WkUrl) + '?Season=' + %Trim(PSeason) + '&startweek=' +
                 %Trim(PSDate) + '&endweek=' + %Trim(PEDate);

      *?   // Create Stream file & Change attribute to read XML
           Exsr CrtStmf;

      *?   // Get xml from client site - always will load to this file
         //XmlFile = ('/URCINVENTORY/GetInv_Supp.xml');      WJB02
           XmlFile = ('/WebServices/URCINVENTORY/GetInv_Supp.xml');
           Rc = Http_Url_get(Url : XmlFile);

      *?   // If Response code = 1 (Success)
           If Rc = 1;
      *?   // Copy to stream file from XmlFile for reference
              Rc = Http_Url_get(Url : Filename);
              WkSeq = 0;
      *?   // Load xml data into physical file
              Exsr LoadFile;
           Else;
 VV02         Monitor;
 VV02           On-Error;
 VV02         EndMon;
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CrtStmf Subroutine :
      *?                :--------------------:
      *
        Begsr CrtStmf;

      *?   // Create Stream file in IFS
           WKFile = *Blanks;
           Chain (PSupCde:'URCIFSPATH') FBROKDFTL0;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

           WkFile = 'GetInv_'  + %Trim(%Char(PSupCde))
                               + '_'  + %Char(%Timestamp());
           Filename =  %Trim(WkPath)+ %Trim(WkFile) +  '.xml';
           Cmd = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(Filename) + ''' )';
           Exsr CallCmd;

      *?   // Change attributes of Stream file
           Cmd = 'CHGATR OBJ(''' + %Trim(Filename) + ''')' +
                         ' ATR(*CCSID) VALUE(1208)';
           Exsr CallCmd;

      *?   // If Xml Load file does not exist , create file
         //XmlFile =  ('/URCINVENTORY/GetInv_Supp.xml');  WJB02
           XmlFile =  ('/WebServices/URCINVENTORY/GetInv_Supp.xml');
           Cmd = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(XmlFile) + ''' )';
           Exsr CallCmd;

      *?   // Change attributes of Stream file
           Cmd = 'CHGATR OBJ(''' + %Trim(XmlFile) + ''')' +
                         ' ATR(*CCSID) VALUE(1208)';
           Exsr CallCmd;

        EndSr;
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
      *?            :---------------------:
      *?            : LoadFile Subroutine :
      *?            :---------------------:
      *
      *?Logic : Move Xml Tag into file Fields and Write

        Begsr LoadFile;

      *?   // Get Supplier Header Details
           Exec sql DECLARE C1 CURSOR FOR
              SELECT * FROM XMLTABLE('/AvailabilityFeed' PASSING
            //XMLPARSE(DOCUMENT GET_XML_FILE('/URCINVENTORY/GetInv_Supp.xml')) WJB02
              XMLPARSE(DOCUMENT GET_XML_FILE(
                       '/WebServices/URCINVENTORY/GetInv_Supp.xml'))
              COLUMNS
              MsgPr  Varchar(30)  PATH 'Identification/MessageProtocol_ID',
              RefId  Varchar(40)  PATH 'Identification/Reference_ID',
              DateTm Varchar(19)  PATH 'Identification/DateTime',
              FrmId  Varchar(30)  PATH 'Identification/FromOrg_ID',
              ToId   Varchar(30)  PATH 'Identification/ToOrg_ID',
              VenNum Varchar(6)   PATH 'AvailabilityHeader/VendorNumber',
              VenNam Varchar(15)  PATH 'AvailabilityHeader/VendorName')
                 as WebServiceResult;

           Exec SQL Open C1;
           SQLState = '00000';

           Exec sql FETCH C1 INTO :WkMsgPr, :WkRefId, :WkDateTm, :WkFrmId,
                                  :WkToId, :WkVenNum, :WkVenNam;
           Exec SQL Close C1;

      *?   // Get Supplier Header Details
           Exec sql DECLARE D1 CURSOR FOR
              SELECT * FROM XMLTABLE('/AvailabilityFeed/AvailabilityItem'
              PASSING XMLPARSE(DOCUMENT
          //          GET_XML_FILE('/URCINVENTORY/GetInv_Supp.xml'))  WJB02
                      GET_XML_FILE(
                      '/WebServices/URCINVENTORY/GetInv_Supp.xml'))
              COLUMNS
              Type   Varchar(10)  PATH 'MaterialNumber/Type',
              ItmNbr Varchar(10)  PATH 'MaterialNumber/Number',
              AvlDT  Varchar(19)  PATH 'AvailabilityDate/Date',
              UOM    Varchar(3)   PATH 'Units/UnitOfMeasure',
              AvlQty Varchar(11)  PATH 'Units/Count')
              as WebServiceResultD;

           Exec SQL Open D1;
           SQLState = '00000';

           Exec SQL FETCH D1 INTO :WkType, :WkItem, :WkAvlDt,
                         :WkUOM, :WkAvlQty;
           DoW SQLSTATE = '00000';
              Exsr WriteInvFile;
              Exec sql FETCH D1 INTO :WkType, :WkItem, :WkAvlDt,
                             :WkUOM, :WkAvlQty;
           EndDo;
           Exec SQL Close D1;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-------------------------:
      *?            : WriteInvFile Subroutine :
      *?            :-------------------------:
      *
      *?Logic : Move XML tags into file Fields and Write

        Begsr WriteInvFile;

      *?   // Clear Record Format
           Clear WSSUPINVR;

      *?   // Identification
           SIMSGPR   = WkMsgPr;
           SIREFID   = WkRefID;
           SIIDATE   = WkDateTm;
           SIFRORID  = WkFrmId;
           SITOORID  = WkToId;

      *?   // Availability Header
           If WkVenNum <> *Blanks;
              SIVENNUM  = %Int(WkVenNum);
           Endif;
           // Change WJB01 - 11/07/2018 Use KP Vendor Number, not vendor supplied vendor number
           SIVENNUM = %Int(WkBroker);
           // End Change WJB01
           SIVENNAM  = WkVenNam;

      *?   // Get Supplier Id from FBROKDFT file
           Chain ('1000' : SIVENNAM) FBROKDFTL0;
           If %Found;
              WkBroker =  %Int(%Trim(DFVARVAL));
           Endif;

      *?   // Availability Item - Material
           SIMATTYP  = WkType;
           SIITEM    = WkItem;
           WkSeq    += 1;
           SISEQNO   = WkSeq;

      *?   // Availability Item - Date
           DateFmt  = %Subst(WkAvlDT:1:10);
           SIAVLDAT = DateFmt.WkYear + DateFmt.Wkmonth + DateFmt.WkDate;

      *?   // Availability Item - Units
           SIUOM  = WkUOM;
           If WkAvlQty <> *Blanks;
              SISUPQTY = %Int(WkAvlQty);
      *?   // Calculate allocated Quantity from FCUTORD file
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
           Endif;

      *?   // Audit Stamp
           SICRTDAT = Rundate;
           SICRTTIM = Runtime;
           SICRTUSR = User;
           SICRTJOB = Job;
           SICRTPGM = Pgm;

      *?   // Write Rec
           Write WSSUPINVR;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : CalcAlcQty Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Read FCUTORD file to calculate Allocated quantity  for the Supplier

        Begsr CalcAlcQty;

           WkLItm = *Blanks;
           WkLSiz = *Blanks;
           WkAlcQty = *Zeros;
         //Chain (SIVENNAM:'Supplier':SIITEM) XREFINVTL0;  WJB02
           Chain (SIVENNAM:'Vendor':SIITEM) XREFINVTL0;
           If %Found;
              WkLItm = XRLCLITEM;
              WkLSiz = XRLCLSIZE;
           Endif;

      *?   // Calculate Allocated Qty from FCUTORD file
           WkAvlDat = %dec(%char(%date(SIAVLDAT:*iso0):*cymd0):7:0);
           Exec Sql
 VV01         Select sum(COQTOO - COQTRC) into :WkAlcQty :NullInd from FCUTORD
                     where COVEND = :WKBroker
                       and COSTAT <> 'D'
                       and COITEM = :WkLItm
                       and COSIZE = :WkLSiz
                       and COSOWD = :WkAvlDat;
 VV01         If NullInd = NullValue;
 VV01            WkAlcQty = 0;
 VV01         Endif;
        EndSr;
      *?---------------- End Of Subroutines --------------------------------
