      *? Program        : WSURCORD02
      *?
      *? Description    : This program to Create CUT records in FCUTLOT and
      *?                  Create Order based on Available Quantity in FCUTLOT.
      *?                  Create record in FCUTORD and build xml based on
      *?                  Sow Date For Eason Vendor Number - 928
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 05 Apr 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Creates record in FCUTLOT based on FMINVT and FIORD
      *?                : ** Calculate availibility based on fields in FCUTLOT
      *?                : ** If Available is > 0  create record in FCUTORD file
      *?                : ** Generate xml based on records written to FCUTORD
      *
      *? Called Program : #SOWFACT71 - Calculate Sow Factor using 7.1 Quantity
      *?                  WSSNDFTPC  - WS - SEND Inv/Ack files to Brokers FTP
      *?                  QCMDEXC - Pgm To Call CL command in Rpg
      *?                  CUR010  - Round to Next 100 Cuttings Needed (CALLED)
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *?Changes in 2019
      * WJB01   06/20/19   W.J.Behr     Change XML Main Tag per Eason
      *         07/11/19   S.Uthaya     ShipMethod by default FEDEX 2DAY
      *         09/24/19   S.Uthaya     Added IM#SED values with Ordered Qty
      * SUD01   10/03/19   S.Uthaya     Don't Order Item, If Xref Not found
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes)
           ActGrp ('HTTP') BndDir('HTTPAPI') AlwNull(*USRCTL);
      //--------------------------------------------------------------------
      *? Copy Httpapi_h Source
      /Include QRpglesrc,Httpapi_h
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
      *?File: WS - Cuts Order Xml Work File
      *?Key : Vendor:Sow Date:Order Number
        Dcl-F WSCUTXMLWF Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input:*Update);
      *
      *?File: Size Code Master File
      *?Key : Size Code
        Dcl-F FMSIZE     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Item Cross Reference  Logical File
      *?Key : Provided Name:Provided Type:Local Key
        Dcl-F XREFINVTL1 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS Cuts Order History File
      *?Key : None
        Dcl-F WSCUTOHPF  Disk(*Ext) Usage(*Output);
      *
      *?File: WS Cuts Order History Logical File
      *?Key : Vendor:Item:Size:Sow Date
        Dcl-F WSCUTOHL0  Disk(*Ext) Keyed Usage(*Update:*Output)
                                    Rename(WSCUTOHR:Rec) Prefix(X);
      *
      *?File: WS Cuts Order History Logical File
      *?Key : Vendor:Order#
        Dcl-F WSCUTOHL1  Disk(*Ext) Keyed Usage(*Input)
                                    Rename(WSCUTOHR:Rec1) Prefix(I);
      *
      *?File: WS Cuts Lot History File
      *?Key : None
        Dcl-F WSCUTLHPF  Disk(*Ext) Usage(*OutPut);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSURCORD02;
           PVendor    Packed(6);
        End-Pi;
      *
      *?Procedure Prototype Declaration : For Fixer Program
        Dcl-Pr #SOWFACT71 Extpgm;
           PItem      Char(12);
           PSize      Char(3);
           PTable     Char(2);
           POrdQ      Zoned(7:1);
           POrdF      Zoned(7:1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : For Rounding Quantity
        Dcl-Pr CUR010  Extpgm;
           PkQtyIn     Packed(7);
           PkQtyOt     Packed(7);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Send FTP Program
        Dcl-Pr WSSNDFTPC  Extpgm;
           PPgmName  Char(10);
           PLogName  Char(10);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(2000)   Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname   Char(50)   Value;
           Tagval    Char(300)  Value;
           Info      Char(10)   Value;
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
      *?Item-Order Data Structure :
        Dcl-Ds WDs Qualified;
           WVend   Packed(6)    Inz;
           WSowDt  Packed(7)    Inz;
           WItem   Char(12)     Inz;
           WSize   Char(3)      Inz;
           WOQty   Packed(11:1) Inz;
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S Cmd       Char(2000)    Inz;
        Dcl-S Xml       Char(1000000) Inz;
        Dcl-S XmlIfs    Char(300)     Inz;
        Dcl-S Info      Char(10)      Inz;
        Dcl-S NullInd   Int(5) Dim(5) Inz(0);
        Dcl-S NullValue Like(NullInd) Inz(-1);
      *
      *?Work Variable Declaration :
        Dcl-S WKDtTm          Char(19)      Inz;
        Dcl-S WkPath          Char(75)      Inz;
        Dcl-S WkFile          Char(75)      Inz;
        Dcl-S WDItem          Char(12)      Inz;
        Dcl-S WkLook          Char(15)      Inz;
        Dcl-S WkVItm          Char(30)      Inz;
        Dcl-S WkRefId         Char(32)      Inz;
        Dcl-S WkBroker        Char(15)      Inz;
        Dcl-S WkVenID         Char(30)      Inz;
        Dcl-S WkVenNam        Char(15)      Inz;
        Dcl-S WkLineNo        Char(10)      Inz;
        Dcl-S WkVendor        Char(6)       Inz;
        Dcl-S WDSize          Char(3)       Inz;
        Dcl-S WkFtp           Char(1)       Inz;
        Dcl-S WkNoChg         Char(1)       Inz('N');
        Dcl-S WkFirst         Char(1)       Inz('Y');
        Dcl-S WkFlag          Char(1)       Inz('Y');
        Dcl-S WkIncomingType  Char(1)       Inz;
        Dcl-S WkQFix          Zoned(7:1)    Inz;
        Dcl-S WkOQty          Zoned(11)     Inz;
        Dcl-S WkSQty          Zoned(11)     Inz;
        Dcl-S WkNedQ          Zoned(11)     Inz;
        Dcl-S WkQORD          Zoned(11)     Inz;
        Dcl-S WkTotQty        Zoned(11)     Inz;
        Dcl-S WkRefNo         Zoned(6)      Inz;
        Dcl-S WDOQty          Packed(11:1)  Inz;
        Dcl-S WkConfQty       Packed(11:1)  Inz;
        Dcl-S WkLine          Packed(10:0)  Inz;
        Dcl-S WkQTSP          Packed(6:1)   Inz;
        Dcl-S WkSeed          Packed(2:0)   Inz;
        Dcl-S WDVend          Packed(6)     Inz;
        Dcl-S WDSowDt         Packed(7)     Inz;
        Dcl-S WDRqDt          Packed(7)     Inz;
        Dcl-S WkCount         Packed(4)     Inz;
        Dcl-S WkYmd           Packed(7)     Inz;
        Dcl-S WkLen           Packed(3)     Inz;
        Dcl-S WkVend          Packed(6)     Inz;
        Dcl-S WkSowd          Packed(7)     Inz;
        Dcl-S WkOrder         Packed(6)     Inz;
        Dcl-S WkORD#          Packed(6)     Inz;
        Dcl-S WkRqDt          Date(*ISO)    Inz;
        Dcl-S WkTyDt          Date(*ISO)    Inz;
        Dcl-S WkDate          Date(*ISO)    Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PPgmName  Char(10)      Inz;
        Dcl-S PLogName  Char(10)      Inz;
        Dcl-S PTable    Char(2)       Inz;
        Dcl-S POrdQ     Zoned(7:1)    Inz;
        Dcl-S POrdF     Zoned(7:1)    Inz;
        Dcl-S PkQtyIn   Packed(7)     Inz;
        Dcl-S PkQtyOt   Packed(7)     Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Initialize
           Exsr InzPgm;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
        Begsr InzPgm;

      *?   // Clear XML
           Clear XML;

      *?   // Convert Input Parameter to Character to read FBROKDFT file
           WkVendor = %Char(PVendor);

      *?   // Get Vendor Name
           Chain ('1000' : WkVendor) FBROKDFTL0;
           If %Found;
              WkVenNam = %Trim(DFVARVAL);
           Endif;

      *?   // Get Date and Time
           WkDtTm = %Char(%Date) + 'T' + %Char(%Time());

      *?   // Create IFSXML temp file in QTEMP
           Exec SQL Create or Replace Table Qtemp.IFSXML (IFSXML VARCHAR(300));
           Exec SQL Delete From Qtemp.IFSXML;

      *?   // Execute Clear XML Work File for the Vendor
           Exec Sql Delete From WSCUTXMLWF;

      *?   // Execute Process
           Exsr Process;

      *?   // Build Xml and Post Xml
           Exsr BuildXml;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : SendXml Subroutine :
      *?                :--------------------:
      *
        Begsr SendXml;

      *?   // Create stream file
           Exsr CreateIfsSr;

      *?   // Call FTP Program
           PPgmName = 'WSORDEHFTP';
           PLogName = 'WSORDEHLOG';
           WSSNDFTPC(PPgmName:PLogName);

      *?   // Move Vendor and Date to work variables
           WkVend = CWVEND;
           WkSOWD = CWSOWD;
           WkORD# = CWORD#;

      *?   // Clear Flat File
           Cmd = 'CLRPFM FILE(QTEMP/IFSXML)';
           Exsr CallCmd;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : CreateIfsSr Subroutine :
      *?                :------------------------:
      *
      *?Logic : Create IFS file name based on Broker
      *
        Begsr CreateIfsSr;

      *?   // Get IFS Path
           Chain (WkVendor : 'URCORDERPATH' ) FBROKDFTL0;
           If %Found;
              WkPath = %Trim(DFVARVAL);
           Endif;

      *?   // Create stream file Name based on Broker
           WkFile = 'URC-' + %Trim(WkVendor) + '_ORD#-' + %Char(WkORD#)
                          + '_'  + %Char(%Timestamp()) + '.xml';

      *?   // Create stream file
           Cmd = 'CPYTOIMPF FROMFILE(IFSXML) STMFCODPAG(1208)'
               + ' TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
               + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*DLM)'
               + ' STRDLM(*NONE) RMVBLANK(*TRAILING)';
           Exsr CallCmd;

      *?   // Copy stream file to SEND folder
           WkFtp = '0';
           Chain (WkVendor : 'USEFTP' ) FBROKDFTL0;
           If %Found;
              WkFtp = %Trim(DFVARVAL);
           Endif;
           If WkFtp = '1';
              Chain (WkVendor : 'IFSURCFTP' ) FBROKDFTL0;
              If %Found;
                 WkPath = %Trim(DFVARVAL);
              Endif;

              Cmd = 'CPYTOIMPF FROMFILE(IFSXML) STMFCODPAG(1208)'
                  + ' TOSTMF(''' + %Trim(WkPath) + %Trim(WkFile) + ''')'
                  + ' MBROPT(*REPLACE) RCDDLM(*CRLF) DTAFMT(*DLM)'
                  + ' STRDLM(*NONE) RMVBLANK(*TRAILING)';
              Exsr CallCmd;
           Endif;

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

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
        Begsr Process;

      *?   // Get Current date
           WkDate = %Date();
           WkYmd  = %Dec(%Char(WkDate:*CYMD0):7:0);

      *?   // Get records from FMINVT and FIORDR where IMFRSZ='CUT'
           Exec Sql Declare A1 Cursor For
             Select IMVEND, OISOW, OIITEM, OISIZE,
                sum(OIQORD - OIQSHP) as Orderqty
                from FMINVTCT, FIORITEM
             Where
                OIITEM = IMITEM   and OISIZE = IMSIZE   and
                IMVEND = :PVendor and OISOW  >  :WkYmd  and
                OISTAT = 'A'      and OICUST <> 2730
                Group by IMVEND, OISOW, OIITEM, OISIZE
                Order by IMVEND, OISOW, OIITEM, OISIZE;

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;

      *?   // Read record by Vendor,SowDate,Item,Size to check FCUTLOT
           Exec Sql Fetch A1 into :WDs :NullInd;
           Dow SqlCod = 0;

      *?      // Move datastructure fields to workfields for easy usage
              Exsr MovFields;

SUD01 *?      // Check the Item in Xref. If not Found in Xref, Don't Process
  |           Chain (WkVenNam : 'Vendor' :WDITEM) XREFINVTL1;
SUD01         If %Found;

      *?         // Initialise Customer Order Quantity fields for Vendor in FCUTLOT
                 Exec Sql
                    Update FCUTLOT set CLQTTS = 0, CLQTTF = 0,
                           CLQTSL = 0, CLQTSP=0
                    Where  CLVEND = :WDVend and CLITEM = :WDItem and
                           CLSIZE = :WDSize and CLSOWD = :WDSowDt and
                           CLSTAT = 'A';

      *?         // Process only if Qty > 0
                 If WDOQty > 0;

      *?            // Get Item Lookup, Vendor Item from FMINVT
                    WkLook = *Blanks;
                    WkVItm = *Blanks;
                    WkSeed = *Zeros;
                    Exec Sql
                       Select IMLOOK, IMVITM, IM#SED into
                       :WkLook, :WkVItm, :WkSeed  From FMINVT
                       Where IMITEM = :WDItem and IMSIZE = :WDSize;

      *?            // Calculate Fixer Quantity based on Ordered Quantity
                    Exsr CalcFixers;

      *?            // Check if record exist in FUTLOT - Calculate qty
                    Chain (WDVend:WDItem:WDSize:WDSowDt) FCUTLOT;
                    If %Found;
                       CLQTTS = WDOQty;                       // QUANTITY TRAYS SOLD
                       CLQTSP = WkQTSP;                       // QUANTITY TRAYS SPEC
                       CLQTTF = WkQFix - WDOQty;              // QUANTITY FIXERS
                       CLQTSL = WkNedQ;                       // QUANTITY CUTS SOLD
                       CLQTAV = *Zero;                        // QTY. AVAILABLE
                       CLQTOO = CLQTSL - CLQTOH;              // QTY. CUTS ON ORDER

                       Update RCUTLOT %Fields(CLQTTS:CLQTSP:CLQTTF:CLQTSL:
                                              CLQTAV:CLQTOO);

      *?               // Move Process Type to Cuts Lot History File
                       CLHPROC = 'UPDATE';
                    Else;

      *?               // Move Process Type to Cuts Lot History File
                       CLHPROC = 'CREATE';

      *?               // Write record to FCUTLOT
                       Exsr WrtCutLot;
                    Endif;

      *?            // Write Cuts Lot History file for reference
                    Exsr WrtCutLotHis;

      *?            // Write/Upd record in FCUTORD file
                    Exsr WrtUpdCutOrd;

      *?            // Write all details in workfile to generate xml
                    Exsr WrtXmlFile;

                 Endif;                                  // If Wdoqty > 0
SUD01         Endif;                                     // If Found
              Exec Sql Fetch A1 into :WDs :NullInd;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : Move Fields Subroutine :
      *?                :------------------------:
      *
        Begsr MovFields;

      *?   // Move Datastructure fields from SQL to workfields for easy usage
           WDVend = 0;
           WDSowDt= 0;
           WDOQty = 0;
           WDItem = ' ';
           WDSize = ' ';
           WDVend = WDs.Wvend;
           WDItem = WDs.WItem;
           WDSize = WDs.WSize;
           WDSowDt= WDs.WSowDt;
           WDOQty = WDs.WOQty;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : Write FCUTLOT Subroutine :
      *?                :--------------------------:
      *
        Begsr WrtCutLot;

      *?   // Clear record format
           Clear RCUTLOT;

      *?   // Move other values to FCUTLOT fields and write record
           CLSTAT = 'A';
           CLVEND = WDVend;
           CLITEM = WDItem;
           CLSIZE = WDSize;
           CLUSEC = *Blanks;
           CLSOWD = WDSowDt;
           CLRDYD = WDRqDt;
           CLLOOK = WkLOOK;

      *?   // Move quantity fields to FCUTLOT file
           CLQTTS = WDOQty;
           CLQTSP = WkQTSP;
           CLQTTF = WkQFix - WDOQty;
           CLQTSL = WkNedQ;
           CLQTOH = 0;
           CLQTAV = 0;
           CLQTOO = WkNedQ;
           Write RCUTLOT;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : Calculate Fixers Subroutine :
      *?                :-----------------------------:
      *
        Begsr CalcFixers;

      *?   // Calculate Fixer Quantity using program #SOWFACT71
           WkQFix = 0;
           POrdQ  = WDOQty;
           #SOWFACT71(WDItem:WDsize:PTable:POrdQ:WkQFix);

      *?   // Convert Ordered Quantity to Eaches to get cuttings needed
           WkOQty = *Zeros;
           Chain WDSize FMSIZE;
           If %Found and SZSTAT = 'A';
              WkOQty = WKQFix * SZSALE;
           Endif;

      *?   // Multiply with IM#SED Values to get cuttings needed
           If WkSeed <> *Zeros;
              WkOQty = WkSeed * WkOQty;
           Endif;

      *?   // Round Quantity to nearest 100 using CUR010
           WkNedQ  = 0;
           PkQtyIn = WkOQty;
           PkQtyOt = 0;
           CUR010(PkQtyIn:PkQtyOt);
           WkNedQ = PkQtyOt;

      *?   // Calculate Spec Quantity for 2730 Customers
           Exec Sql
              Select sum(OIQORD - OIQSHP) into :WkQTSP from FIORDR, FMINVT
              Where  OIITEM = IMITEM  and OISize = IMSize  and
                     IMVEND = :WDVend and OICUST = 2730    and
                     OIITEM = :WDItem and OISIZE = :WDSize and
                     OISOW  = :WDSowDt;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------------:
      *?                : Write/Update FCUTORD Subroutine :
      *?                :---------------------------------:
      *
        Begsr WrtUpdCutOrd;

      *?   // Intialise Variables
           WkQORD = 0;
           WkNoChg='N';

      *?   // Check FCUTORD record to get cuttings on order and Confirmed qty
           Chain (WDVEND:WDItem:WDSize:WDSowDt) FCUTORD;
           If %Found;
              WkQORD = COQTOO - COQTRC;
              If WkQORD <> WkNedQ;
                 WkSQty = CLQTSL;
                 COQTOO = CLQTSL - CLQTOH;      // QTY. CUTS ORDERED
                 Update RCUTORD %Fields(COQTOO);

      *?         // Move Process Type to Cuts Order History File
                 COHPROC = 'UPDATE';
              Else;

      *?         // To update process in history file , If there is no change in Qty
                 WkSQty = 0;
                 WkNoChg='Y';
              Endif;
           Else;
              COQTOO = WkNedQ;
              WkSQty = COQTOO;

      *?      // Move other field values
              COVEND = WDVend;
              COSTAT = *Blanks;

      *?      // Order number is same as SowDate in YYMMDD format
              COORD# = %Dec(%Char(%Date(WDSowDt:*CYMD):*YMD0):6:0);
              COITEM = WDItem;
              COSIZE = WDSize;
              COUSEC = *Blanks;
              COORDD = %Dec(%Char(%Date():*CYMD0):7:0);
              COSOWD = WDSowDt;
              COLOOK = WkLook;
              COVNAL = WkLook;
              COSVND = WDVend;
              COVITM = WkVItm;
              COPRTD = 'N';
              COTRAN = 'Y';
              COQTRC = 0;

      *?      // Write FCUTORD
              Write RCUTORD;

      *?      // Move Process Type to Cuts Order History File
              COHPROC = 'CREATE';
           Endif;

      *?   // Write Cuts Order History file for reference
           Exsr WrtCutOrdHis;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : Write XmlFile Subroutine :
      *?                :--------------------------:
      *
        Begsr WrtXmlFile;

      *?   // Write records to work file to generate xml
           Clear WSCUTXMLR;
           If WkQORD <> WkNedQ;
              CWVEND = WDVend;
              CWSowD = WDSowDt;
              CWORD# = %Dec(%Char(%Date(WDSowDt:*CYMD):*YMD0):6:0);
              CWITEM = WDItem;
              CWSIZE = WDSize;
              CWORDQ = WkSQty;
              Write WSCUTXMLR;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : WrtCutOrdHis Subroutine  :
      *?                :--------------------------:
      *
        Begsr WrtCutOrdHis;

      *?   // Move other values to Order History fields and write record
           Chain(N) (COVEND:COITEM:COSIZE:COSOWD) WSCUTOHL0;
           If %Found;
              WkLine = XCOHLINE;
           Else;
              Setgt  (COVEND:COORD#) WSCUTOHL1;
              ReadPE (COVEND:COORD#) WSCUTOHL1;
              If Not %Eof;
                 WkLine = ICOHLINE + 10;
              Else;
                 WkCount = 0;
                 WkCount+= 1;
                 WkLine  = WkCount * 10;
              Endif;
           Endif;

           COHVEND = COVEND;
           COHLINE = WkLine;
           COHSTAT = COSTAT;
           COHORD# = COORD#;
           COHVENID= *Blanks;
           COHITEM = COITEM;
           COHSIZE = COSIZE;
           COHUSEC = COUSEC;
           COHORDD = COORDD;
           COHSOWD = COSOWD;
           COHRDYD = CORDYD;
           COHQTOO = WkSQty;
           COHQTRC = COQTRC;
           COHPRTD = COPRTD;
           COHTRAN = COTRAN;
           COHTIMST  = %Timestamp();
           COHCRTUSR = User;
           COHCRTJOB = Job;
           COHCRTPGM = Pgm;
           If WkNoChg = 'Y';
              COHPROC = 'NOCHANGE';
           Endif;
           Write WSCUTOHR;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : WrtCutLotHis Subroutine  :
      *?                :--------------------------:
      *
        Begsr WrtCutLotHis;

      *?   // Move other values to Lot History fields and write record
           CLHVEND = CLVEND;
           CLHSTAT = CLSTAT;
           CLHITEM = CLITEM;
           CLHSIZE = CLSIZE;
           CLHUSEC = CLUSEC;
           CLHSOWD = CLSOWD;
           CLHRDYD = CLRDYD;
           CLHQTTS = CLQTTS;
           CLHQTSP = CLQTSP;
           CLHQTTF = CLQTTF;
           CLHQTSL = CLQTSL;
           CLHQTOH = CLQTOH;
           CLHQTAV = CLQTAV;
           CLHQTOO = CLQTOO;
           CLHTIMST = %Timestamp();
           CLHCRTUSR = User;
           CLHCRTJOB = Job;
           CLHCRTPGM = Pgm;
           Write WSCUTLHR;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : BuildXml Subroutine :
      *?                :---------------------:
      *
        Begsr BuildXml;

      *?   // Initialise
           WkVend = 0;
           WkSOWD = 0;
           WkORD# = 0;
           WkFlag = 'N';

      *?   // Check Record in Work file for the Vendor
           Setll *Loval WSCUTXMLWF;
           Read WSCUTXMLWF;
           Dow Not %Eof;
              If WkFirst = 'Y';
                 WkVend = CWVEND;
                 WkSOWD = CWSOWD;
                 WkORD# = CWORD#;
                 WkFirst = 'N';
                 Exsr HeaderSr;
              Endif;
              If WkVend <> CWVEND Or WkSOWD <> CWSOWD;
                 Exsr FooterSr;
                 Exsr SendXml;
                 Exsr HeaderSr;
              Endif;

      *?      // Execute Item Part
              Exsr ItemSR;
              Read WSCUTXMLWF;
           Enddo;

      *?   // Write footer for last record  and Post xml
           If %Eof and WkFlag = 'Y';
              Exsr FooterSr;
              Exsr SendXml;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : HeaderSr Subroutine :
      *?                :---------------------:
      *
        Begsr HeaderSr;

      *?   // Header Value
           Clear Xml;
           Xml = '<?xml version="1.0" encoding="utf-8" ?> ' + Xml;

      *?   // Start Tag
           AddToXml('EasonPurchaseOrder' : *Blanks : 'Starttag');  //WJB01

      *?   // XML Body
           Exsr IdentificationSR;
           Exsr OrderHeaderSR;

      *?   // Move values into Detail tags
           AddToXml('OrderDetails' : *Blanks : 'Starttag');

      *?   // Reset Flag to Sent Last Order XML
           WkFlag = 'Y';

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : FooterSr Subroutine :
      *?                :---------------------:
      *
        Begsr FooterSr;

      *?   // OrderDetails Close Tag
           AddToXml('OrderDetails' : *Blanks : 'Endtag');

      *?   // End Tag
           AddToXml('EasonPurchaseOrder' : *Blanks : 'Endtag');   //WJB01


        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : IdentificationSr Subroutine :
      *?                :-----------------------------:
      *
        Begsr IdentificationSr;

      *?   // Move values into Identification Part
           AddToXml('Identification' : *Blanks : 'Opentag'); // Open Tag
           AddToXml('MessageProtocol_ID' : 'KubePakPurchaseOrder':'Attribute');

      *?   // Get Broker Number Parameter File
           Chain ('1000' : 'Kube-Pak') FBrokDftL0;
           If %Found;
              WkBroker =  %Trim(DFVARVAL);
           Endif;

      *?   // Move values into FromOrgId and SenderOrgId from Parameter File
           Chain (WkBroker:'FromOrgId') FBrokDftL0;
           If %Found;
              AddToXml('FromOrg_ID' : %Trim(DFVARVAL): 'Attribute');
           Endif;

           AddToXml('Date' : WkDtTm : 'Closetag');           // Close Tag

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : OrderHeaderSr Subroutine :
      *?                :--------------------------:
      *
        Begsr OrderHeaderSr;

      *?   // Move values into Order Header
           WkTyDt = %Date();
           WkRqDt = %Date(CWSOWD:*CYMD);
           AddToXml('OrderHeader' : *Blanks : 'Opentag');    // Open Tag
           AddToXml('BackOrderOK' : '0' : 'Attribute');
           AddToXml('BrokerCreatedDate' : %Char(WkTyDt) : 'Attribute');
           AddToXml('BrokerCreatedTime' : %Char(%Time()) : 'Attribute');

      *?   // Get Vendor Order from Cut Order History File
           WkVenId = *Blanks;
           Exec Sql
              SELECT Max( COHVENID )    // WJB 8/16/2019
              Into :WkVenId
              FROM WSCUTOHPF
              WHERE COHORD# = :CWORD# And COHVEND = :CWVEND
                And COHVENID <> ' ';

           AddToXml('BrokerOrderID' : WkVenId : 'Attribute');
           AddToXml('ChangeOrderBatchNumber' : '0' : 'Attribute');
           AddToXml('CustomerPONumber' : %Char(CWORD#) : 'Attribute');
           AddToXml('FreightPaymentMethod' : 'PPA' : 'Attribute');
           AddToXml('HeaderComments' : ' ' : 'Attribute');

      *?   // Blank out incoming type if this order sent previously
           WkIncomingType = 'N';
           Exec SQL
              Select ' ' Into :WkIncomingType
              From WSCUTOHL0
              Where COHSOWD = :CWSOWD And COHVEND = :CWVend
                And COHPROC <> 'CREATE'
              Order By COHTIMST Desc
              Fetch First Row Only;

           AddToXml('IncomingType' : WkIncomingType : 'Attribute');
           AddToXml('RequestedShipDate' : %Char(WkRqDt) : 'Attribute');
           AddToXml('SalesRepName' : ' ' : 'Attribute');
           AddToXml('ShipMethod' : 'FEDEX 2DAY' : 'Attribute');
           AddToXml('ShippingMethodDesc': 'FEDEX 2DAY' : 'Attribute');
           AddToXml('ShippingInstructions' : ' ' : 'Attribute');
           AddToXml('VendorNumber' : %Char(CWVEND) : 'Attribute');
           AddToXml('SubstitutionOK' : '1' : 'Close');       // Close Tag

           Exsr SoldToSR;
           Exsr ShipToSR;

           AddToXml('OrderHeader' : *Blanks : 'Endtag');     // End  Tag

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : SoldToSr Subroutine :
      *?                :---------------------:
      *
        Begsr SoldToSr;

      *?   // Move values into Sold To
           AddToXml('SoldTo' : *Blanks : 'Opentag');         // Open Tag
           AddToXml('BrokerSoldToNumber' : '1000' : 'Attribute');
           AddToXml('SoldToName' : 'Kube-Pak' : 'Attribute');
           AddToXml('SoldToContactName': 'Kube-Pak' : 'Attribute');
           AddToXml('SoldToAddress1' : '194 Route 526' : 'Attribute');
           AddToXml('SoldToAddress2' : ' ' : 'Attribute');
           AddToXml('SoldToCity' : 'ALLENTOWN' : 'Attribute');
           AddToXml('SoldToState' : 'NJ' : 'Attribute');
           AddToXml('SoldToZip' : '08501' : 'Attribute');
           AddToXml('SoldToPhone' : '609-259-3114' : 'Attribute');
           AddToXml('SoldToFax' : '609-259-0487' : 'Attribute');
           AddToXml('SoldToCountry' : 'USA' : 'Attribute');
           AddToXml('SoldToCountry3' : 'USA' : 'Closetag');  // Close Tag

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : ShipToSr Subroutine :
      *?                :---------------------:
      *
        Begsr ShipToSr;

      *?   // Move values into Ship To
           AddToXml('ShipTo' : *Blanks : 'Opentag');         // Open Tag
           AddToXml('BrokerShipToNumber' : '1000-000' : 'Attribute');
           AddToXml('ShipToName' : 'Kube-Pak' : 'Attribute');
           AddToXml('ShipToContactName': 'Kube-Pak' : 'Attribute');
           AddToXml('ShipToAddress1' : '194 Route 526' : 'Attribute');
           AddToXml('ShipToAddress2' : ' ' : 'Attribute');
           AddToXml('ShipToCity' : 'ALLENTOWN' : 'Attribute');
           AddToXml('ShipToState' : 'NJ' : 'Attribute');
           AddToXml('ShipToZip' : '08501' : 'Attribute');
           AddToXml('ShipToFax' : '609-259-0487' : 'Attribute');
           AddToXml('ShipToPhone' : '609-259-3114' : 'Attribute');
           AddToXml('ShipToCountry ' : 'USA' : 'Attribute');
           AddToXml('ShipToCountry3' : 'USA' : 'Closetag');  // Close Tag

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : ItemSR Subroutine :
      *?                :-------------------:
      *
        Begsr ItemSR;

      *?   // Blank out incoming type if this item sent previously
           WkIncomingType = 'N';
           Exec SQL
              Select ' ' Into :WkIncomingType
              From WSCUTOHL0
              Where  COHSOWD = :CWSOWD
                 And COHVEND = :CWVend And COHITEM = :CWITEM
                 And COHSIZE = :CWSIZE And COHPROC <> 'CREATE'
              Order By COHTIMST Desc
              Fetch First Row Only;

      *?   // Get Line Number from Cut Order History File
           Chain(N) (CWVend:CWITEM:CWSize:CWSOWD) WSCUTOHL0;
           If %Found;
              WkLine  = XCOHLINE;
              WkLineNo= %EditC((WkLine):'X');
           Else;
              WkLine  = *Zeros;
              WkLineNo= *Blanks;
           Endif;

      *?   // Move values from XML work file
           AddToXml('Item': *Blanks : 'Opentag');           // Open Tag
           AddToXml('BrokerLineItemNumber' : WkLineNo :'Attribute');
           AddToXml('VendorMaterialNumber' : CWITEM : 'Attribute');
           AddToXml('IncomingType' : WkIncomingType :'Attribute');
           AddToXml('LineItemComment' : *Blanks : 'Attribute');

      *?   // Get Eason Item from XREF file
           Chain (WkVenNam : 'Vendor' :CWITEM) XREFINVTL1;
           If %Found;
              AddToXml('BrokerMaterialNumber' : XRFORKEY : 'Attribute');
              AddToXml('MaterialDescription' : XRDESC : 'Attribute');
           Endif;

      *?   // Get Eason Item from XREF file
           WkConfQty = 0;
           Exec Sql
              SELECT Max(COHQTRC) Into :WkConfQty
              FROM WSCUTOHPF
              WHERE COHORD# = :CWORD# And COHVEND = :CWVEND
                And COHITEM = :CWITEM And COHSIZE = :CWSIZE
                And COHSOWD = :CWSOWD And COHQTRC <> 0;

           AddToXml('OrderdQty' : %Char(CWORDQ) : 'Attribute');
           AddToXml('ConfirmedQty' : %Char(WkConfQty) : 'Attribute');
           AddToXml('ScheduledShipDate': %Char(WkRqDt) :'Attribute');
           AddToXml('UnitofMeasure' : 'EA' : 'Closetag');   // Close Tag

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

      *?   // Check Info to add XML tag
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

              When Info = 'Element';
                  Xml = %Trimr(Xml) + ' <' + %Trim(Tagname) + '>'
                        + %Trim(Tagvalue) + '</' + %Trim(Tagname) + '>';

           Endsl;

      *?   // Write XML Line into IFS
           Exsr WriteIFS;
      *
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
