      *? Program        : WSORDEXP03
      *?
      *? Description    : This pgm to validate Po header field and Update
      *?                  XML Header and Error Files
      *?
      *? Created By     : Vamsikrishna.G / S.Uthayadurga
      *?
      *? Date           : 13 Nov 2017
      //--------------------------------------------------------------------
      *? Special Notes  : ** Validate Header fields , If No errors Update
      *?                     XML file and Exception file flag
      *?                  ** Select Customer Or Create Customer to
      *?                     create  Customer XREF
      *?                  ** F6 - Create Customer XREF
      *?                  ** F10- If there is no Error on the screen , Check
      *?                     XML Files and Create Order
      *?                  ** On successful order create Send Acknowledgement
      *?                  ** Check Other Orders For the Same Broker with Xref Error
      *?                     If So reprocess the Order
      *?
      *? Called Program : ARR010CLC  - Create New Customer
      *?                  WSPOVAL002 - WS - XML File Validation and Order Creation
      *?                  WSCOVAL002 - WS - XML File Validation and Order Change
      *?                  WSPOACK003 - WS - Acknowledgement Process for Order Create
      *?                  WSCOACK003 - WS - Acknowledgement Process for Change Order
      *?                  WSPOACKMCH - WS - Acknowledgment Process for Michell PO & CO
      *?                  WSSFLMSG   - WS - Send and clear message from subfile
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      *?Changes in 2018
      * SUD01   03/21/18   S.Uthaya     Remove customer type '30' from subfile
      *                                 when searching for Unmapped Customer
      * SUD02   03/21/18   S.Uthaya     Customer Creation field mapping from
      *                                 broker default file
      *                                 Tax Exeption from FCUSTCOM file
      *                                 Contact name from XML header file
      * SUD03   08/09/18   S.Uthaya     Removed Hardcoded Broker Name
      * SUD04   09/11/18   S.Uthaya     Added Michell Programs
      * VV01    10/10/18   Vimala V     Phone number not moved to CMPHON if only
      *                                 numbers are received (9999999999)
      * SUD05   10/24/18   S.Uthaya     Added City,State and Zip in Subfile Part
      *?Changes in 2019
      * SUD06   07/01/19   S.Uthaya     Reprocess PO/CO for the Broker, If any
      *                                 Pending Xref Error
      * SUD07   07/17/19   S.Uthaya     Broker ID Length Changed for McHutchison
      * SUD08   08/22/19   S.Uthaya     Phone Number Format Changes
      *         09/30/19   B.Behr       Only use first 10 numbers in Phone
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - XML Order Error Exception Logical File
      *?Key : Broker Name:BrokerOrderId:Header Seq no:Error Seq:Broker Material
        Dcl-F WSERREXPL2 Disk(*Ext) Keyed Usage(*Output:*Delete);
      *
      *?File: WS - XML Order Header Logical File
      *?Key : Broker Name:BrokerOrderId:Header Seq no
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Delete);
      *
      *?File: WS - Xml Create Order Detail Logical File
      *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
        Dcl-F WSPODTLL0  Disk(*Ext) Keyed Usage(*Update :*Output);
      *
      *?File: WS - XML Change Order Header Logical File
      *?Key : Broker Name:BrokerOrderId:Header Seq no
        Dcl-F WSCOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Delete);
      *
      *?File: WS - Xml Change Order Detail Logical File
      *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
        Dcl-F WSCODTLL0  Disk(*Ext) Keyed Usage(*Update :*Output);
      *
      *?File: FMCUST  M/F Customer Master File
        Dcl-F FMCUST     Disk(*Ext) Usage(*Update:*Output);
      *
      *?File: FNXTCUST Physical File
        Dcl-F FNXTCUST   Disk(*Ext) Usage(*Input);
      *
SUD02 *?File: FMCUST  M/F Customer Comeents File
  |   *?Key : Customer Number
SUD02   Dcl-F FCUSTCOM   Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?FILE: A/R Customer Summary Information
        Dcl-F FARHST     Disk(*Ext) Usage(*Update :*Output);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for Error Detail Screen Program
        Dcl-F WSOREXFM03 Workstn Indds(Dspf) Sfile(ORDEXPS03:S03Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSORDEXP02)
        Dcl-Pi WSORDEXP03;
SUD07      PBrkId  Char(15);
           PCustPO Char(10);
           PSeqNo  Packed(9);
           PErrSeq Packed(5);
           POrdNo  Packed(6);
           PPgm    Char(10);
           PSts    Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Order Create Validation Program
        Dcl-Pr WSPOVAL002 ExtPgm;
           PBrkName Char(30);
           PCustPO  Char(10);
           PSeqNo   Packed(9);
           PFlag    Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Order Change Validation Program
        Dcl-Pr WSCOVAL002 ExtPgm;
           PBrkName Char(30);
           PCustPO  Char(10);
           PSeqNo   Packed(9);
           PFlag    Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Generate Acknowledgement XML for PO
        Dcl-Pr WSPOACK003 ExtPgm;
           PBrkName  Char(30);
           PCustPO   Char(10);
           PSeqNo    Packed(9);
           PBrkAck   Char(1000000) Options(*Varsize);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Generate Acknowledgement XML for PO
        Dcl-Pr WSCOACK003 ExtPgm;
           PBrkName Char(30);
           PCustPO  Char(10);
           PSeqNo   Packed(9);
           PBrkAck  Char(1000000) Options(*Varsize);
        End-Pr;
      *
SUD04 *?Procedure Prototype Declaration : Acknowledgement Program
  |     Dcl-Pr WSPOACKMCH Extpgm;
  |        PBrkName Char(30);
  |        PCustPO  Char(10);
  |        PSeqno   Packed(9);
  |        PBrkAck  Char(1000000);
  |        PPrFlag  Char(2);
SUD04   End-Pr;
      *
      *?Procedure Prototype Declaration : To Create New Customer
        Dcl-Pr ARR010CLC ExtPgm;
           PCust Packed(6);
        End-Pr;
      *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG  ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
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
SUD08 *?Phone Data Structure            : To Convert Phone from Char to Numeric
  |     Dcl-Ds PhoneDs;
  |        PhoneAry  Char(1) Dim(18) Inz(*Blanks);
  |     End-Ds;
  |   *
  |     Dcl-Ds NewPhoneDS;
  |        NPhoneAry Char(1) Dim(18) Inz(*Blanks);
SUD08   End-Ds;
      *
      *?Local Variable Declaration      :
        Dcl-S Destination Varchar(256);
        Dcl-S ModReq      Char(10);
        Dcl-S FunReq      Char(10);
        Dcl-S ShpVia      Char(2);
        Dcl-S CustType    Char(2);
        Dcl-S Customer    Packed(6);
        Dcl-S ShipDate    Date(*ISO);
      *
      *?Work Variable Declaration       :
SUD06   Dcl-S WkErSeq   Packed(9)   Inz;
        Dcl-S WkCount   Zoned(4:0)  Inz;
        Dcl-S WkCount1  Zoned(4:0)  Inz;
        Dcl-S WkCount2  Zoned(4:0)  Inz;
SUD08   Dcl-S WkPos     Zoned(2:0)  Inz;
SUD08   Dcl-S WkNPos    Zoned(2:0)  Inz;
        Dcl-S WkDate    Zoned(6)    Inz;
        Dcl-S WkID      Zoned(6)    Inz;
        Dcl-S WkBrkId   Char(20)    Inz;
        Dcl-S WkDesc    Char(30)    Inz;
SUD02   Dcl-S WkName    Char(30)    Inz;
        Dcl-S WkLclKey  Char(20)    Inz;
SUD06   Dcl-S WkBrkName Char(30)    Inz;
  |     Dcl-S WkErBrkID Char(10)    Inz;
SUD06   Dcl-S WkPgm     Char(10)    Inz;
SUD08   Dcl-S WkPhone   Char(18)    Inz;
SUD08   Dcl-S WkNPhone  Char(18)    Inz;
        Dcl-S WkPrFlag  Char(1)     Inz;
        Dcl-S WkFlag    Char(1)     Inz;
SUD02   Dcl-S WkIDc     Char(6)     Inz;
        Dcl-S WkTs      Timestamp   Inz;
      *
      *?Parameter Variable Declaration  :
        Dcl-S PBrkAck    Char(1000000);
        Dcl-S PBrkName   Char(30);
        Dcl-S PMsgf      Char(10);
        Dcl-S PMsgId     Char(7);
        Dcl-S POpt       Char(1);
        Dcl-S PFlag      Char(1);
        Dcl-S Flag       Char(1);
SUD04   Dcl-S PPrFlag    Char(2);                 // For RPG program
        Dcl-S PCust      Packed(6);
        Dcl-S HttpStatus Int(10:0);
      *
      *?Flag Variables Declaration      :
        Dcl-S FlSflMod Ind Inz(*Off);
        Dcl-S FlCtlMod Ind Inz(*Off);
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlError1 Ind Inz(*Off);
        Dcl-S FlError2 Ind Inz(*Off);
        Dcl-S FlMulSel Ind Inz(*Off);
      *
      *?Program Indicators Declaration  :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration  :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Create          Ind Pos(6);          // Create Function Key
           Process         Ind Pos(10);         // Update Function Key
           Previous        Ind Pos(12);         // Previous Function Key
      *
           S03SflDsp       Ind Pos(41);         // Subfile Display Ind
           S03SflDspCtl    Ind Pos(42);         // Subfile Display Control Ind
           S03SflClr       Ind Pos(43);         // Subfile Clear Ind
           S03SflEnd       Ind Pos(44);         // Subfile End Ind
           S03SflNxtChg    Ind Pos(45);         // Subfile Next Change Ind
      *
           C03CusNoPr      Ind Pos(61);         // Customer Protect Ind
           C03ShpDtPr      Ind Pos(62);         // ReqShpDt Protect Ind
           C03CusNaPr      Ind Pos(63);         // CusName Protect Ind
           C03ShpCdPr      Ind Pos(64);         // ShipVia Protect Ind
           C03CusPkPr      Ind Pos(65);         // CustPickup Protect Ind
           C03CusPkNd      Ind Pos(72);         // CustPickup Nondispaly Ind
           C03CusAdPr      Ind Pos(66);         // CustAddress Protect Ind
           C03CusCtPr      Ind Pos(67);         // CustCity Protect Ind
           C03CusStPr      Ind Pos(68);         // CustState Protect Ind
           C03CusZpPr      Ind Pos(69);         // CustZip Protect Ind
           C03CusPhPr      Ind Pos(70);         // CustPhone Protect Ind
           C03CusFxPr      Ind Pos(71);         // CustFax Protect Ind
           S03SelRi        Ind Pos(73);         // Select Reverse Image Ind
           C03SflNd        Ind Pos(75);         // Subfile Non Dispaly
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Screen
              Dow ModReq = 'SCREEN';
                 Exsr SN3M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN3M;

      *?   // Initialization
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
              Exsr SN3I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN3D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN3V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN3P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?      : If any ShipTo Xref Error Or ShipTo Address Error , Then
      *?        then Display subfile Part ,Else Dont Display subfile Part
      *?      : If ShipVia Xref Error and BrokerId <> 'Ball Seed' ,then
      *?        Create ShipVia Xref
      *?
        Begsr SN3I;

      *?   // Execute Set Indicators based on Error Message
           FlMulSel = False;
           S03Sel   = *Zeros;

      *?   // Get Control fields values from XML Header file based on Pgm
      *?   // For Create Order
           If PPgm = 'CreateOrd';
              Chain(N) (PBrkID:PCustPO:PSeqNO) WSPOHDRL1;
              If %Found;
SUD02            WkName = PHSHPCON;
                 If C03SHPDATE =  *Blanks;
                    If PHRQSHDT <> *Loval;
                       C03SHPDATE =  %Char(PHRQSHDT:*MDY/);
                    Endif;
                 Endif;
                 If C03CUST = ' ';
                    C03CUST    =  PHSHPNUM;
                 Endif;
                 If C03NAME = ' ';
                    C03NAME    =  PHSHPNAM;
                 Endif;
                 If C03ADRS1= ' ';
                    C03ADRS1   =  PHSHPAD1;
                 Endif;
                 If C03ADRS2= ' ';
                    C03ADRS2   =  PHSHPAD2;
                 Endif;
                 If C03CITY = ' ';
                    C03CITY    =  PHSHPCTY;
                 Endif;
                 If C03STATE= ' ';
                    C03STATE= PHSHPSTE;
                 Endif;
                 If C03ZIP= ' ';
                    C03ZIP= PHSHPZIP;
                 Endif;
SUD08            If C03PHONE= ' ';
  |                 WkPhone = *Blanks;
  |                 WkPhone = PHSHPPHN;
  |                 Exsr PhoneSr;
  |                 C03PHONE= WkNPhone;
  |              Endif;
  |              If C03FAX  = ' ';
  |                 WkPhone = *Blanks;
  |                 WkPhone = PHSHPFAX;
  |                 Exsr PhoneSr;
  |                 C03FAX = WkNPhone;
SUD08            Endif;
                 If C03SHPCODE  = ' ';
                   C03SHPCODE = PHSHPMTH;
                 Endif;
              Endif;

      *?   // For Change Order
           Elseif PPgm = 'ChangeOrd';
              Chain(N) (PBrkID:PCustPO:PSeqNO) WSCOHDRL1;
              If %Found;
SUD02            WkName = CHSHPCON;
                 If C03SHPDATE =  *Blanks;
                    If CHRQSHDT <> *Loval;
                       C03SHPDATE =  %Char(CHRQSHDT:*MDY/);
                    Endif;
                 Endif;
                 If C03CUST = ' ';
                    C03CUST    =  CHSHPNUM;
                 Endif;
                 If C03NAME = ' ';
                    C03NAME    =  CHSHPNAM;
                 Endif;
                 If C03ADRS1= ' ';
                    C03ADRS1   =  CHSHPAD1;
                 Endif;
                 If C03ADRS2= ' ';
                    C03ADRS2   =  CHSHPAD2;
                 Endif;
                 If C03CITY = ' ';
                    C03CITY    =  CHSHPCTY;
                 Endif;
                 If C03STATE= ' ';
                    C03STATE= CHSHPSTE;
                 Endif;
                 If C03ZIP= ' ';
                    C03ZIP= CHSHPZIP;
                 Endif;
SUD08            If C03PHONE= ' ';
  |                 WkPhone = *Blanks;
  |                 WkPhone = CHSHPPHN;
  |                 Exsr PhoneSr;
  |                 C03PHONE= WkNPhone;
  |              Endif;
  |              If C03FAX  = ' ';
  |                 WkPhone = *Blanks;
  |                 WkPhone = CHSHPFAX;
  |                 Exsr PhoneSr;
  |                 C03FAX = WkNPhone;
SUD08            Endif;
                 If C03SHPCODE  = ' ';
                   C03SHPCODE = CHSHPMTH;
                 Endif;

              Endif;
           Endif;

      *?   // Clear Subfile
           Dspf.S03SflClr = True;                      // Clear Ind ON
           Dspf.S03SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write ORDEXPC03;

      *?   // Clear Rrn
           S03Rrn = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S03SflClr    = False;                  // Clear Ind OFF
           Dspf.S03SflDspCtl = True;                   // Display Control Ind ON

      *?   // Get Broker Number from Broker Default File
           Chain ('1000' : C03BRKID) FBROKDFTL0;
           If %Found;
              WkID  = %Int(%Trim(DFVARVAL));
SUD02         WkIDC = %Trim(DFVARVAL);
           Endif;

      *?   // Build the Subfile based on Cursor
           Exsr SetIndicator;
           If Dspf.C03SflNd = False;
              Exsr SN3B;
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Control fields
      *?
        Begsr SN3B;

      *?   // Initialise Rrn and Count
           S03Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Execute Sql to get Subfile Records
           If WkCount1 = 0 Or C03CUST = ' ';
              Dspf.C03SflNd = False;
              Exec Sql Declare A1 Cursor For
                 Select IFNULL(CMCUST,0),IFNULL(CMNAME,' '),
SUD05            IFNULL(CMADD2,' '), CMCITY, CMSTST, CMZIP
                 From FmCust Left outer join
                 FaRhst On CmCust = HsCust Where
SUD01            (:C03Find = ' ' And CMBLCU = :WkID And CMCTYP <> '30' And
                 (Soundex(CmName) = Soundex(:C03NAME) Or
                 (CmStst = :C03STATE And (Soundex(Cmadd2) = Soundex(:C03ADRS1)
                 Or Soundex(Cmadd2) = Soundex(:C03ADRS2) Or
                 Soundex(Cmadd3) = Soundex(:C03ADRS1) Or
                 Soundex(Cmadd3) = Soundex(:C03ADRS2))) Or
                 Char(CmPhon) = :C03PHONE Or Char(Cmpho2) = :C03PHONE Or
                 Char(HsFax) = :C03FAX)) OR
SUD01            (:C03Find <> ' ' And CMBLCU = :WkId And CMCTYP <> '30' And
                 (CmName Like '%' Concat TRIM(:C03FIND) Concat'%'
                 OR Cmadd2 Like '%' Concat TRIM(:C03FIND) Concat'%'
                 OR Cmadd3 Like '%' Concat TRIM(:C03FIND) Concat'%'
                 OR CmLook Like '%' Concat TRIM(:C03FIND) Concat'%'
                 OR Char(CmpHon) Like '%' Concat TRIM(:C03FIND) Concat'%'
                 OR Char(CmZip) Like '%' Concat TRIM(:C03FIND) Concat'%'
                 OR Char(HsFax) Like '%' Concat TRIM(:C03FIND) Concat'%')) ;

              Exec Sql Open A1;
              If SqlCode = -502 ;
                  Exec Sql Close A1;
                  Exec Sql Open A1;
              EndIf;

SUD05         Exec Sql Fetch A1 Into :S03CUST, :S03NAME, :S03ADDRESS,
SUD05                  :S03City, :S03State, :S03Zip;

      *?      // Load Subfile
              Dow SqlCod = 0 And WkCount < 9999;

      *?          // Increment RRN
                  S03Rrn  += 1;
                  WkCount += 1;

      *?          // Write Subfile Display Part
                  Write ORDEXPS03;

SUD05             Exec Sql Fetch A1 Into :S03CUST, :S03NAME, :S03ADDRESS,
SUD05                      :S03City, :S03State, :S03Zip;

              Enddo;
              Exec Sql Close A1;
           Endif;

      *?   // Subfile End Indicator ON
           Dspf.S03SflEnd = *On;

      *?   // Check RRN and Show Subfile Or End of File Based on Indicator
           If S03Rrn <> *Zeros and Dspf.C03SflNd = False;
              Dspf.S03SflDsp = True;
           Else;
              If Dspf.C03SflNd = False;

      *?         // No Records Found
                 PMsgId = 'WS00030';
                 Exsr Sendmessage;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN3D;

      *?   // Write the Footer
           Write ORDEXPF03;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt ORDEXPC03;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 PSts   = '03';

      *?      // F6 Pressed (Create New Customer)
              When Dspf.Create ;
                 Exsr SN3C;
                 C03CSTUSE = Customer;
                 FunReq = 'DISPLAY';

      *?      // F10 Pressed
              When Dspf.Process;
                 Exsr ValidateSR;
                 If Dspf.C03SflNd = False;
                    If FlError <> True and FlError1 <> True and
                       FlError2 <> True  and C03CSTUSE <> *Zeros;
                       If WkCount2 = 0;
                          Exsr CreateXrefSvia;
                       Endif;
                       Exsr SN3U;
                       ModReq = 'EXIT';
                       PSts   = '12';
                    Else;
                       If C03CSTUSE = *Zeros;
                          PMsgId  = 'WS00045';
                          Exsr SendMessage;
                       Else;
                          PMsgId  = 'WS00038';
                          Exsr SendMessage;
                       Endif;
                    Endif;
                 Else;
                    If FlError <> True and FlError1 <> True and
                       FlError2 <> True;
                       If WkCount2 = 0;
                          Exsr CreateXrefSvia;
                       Endif;
                       Exsr UpdateHeader;
                       ModReq = 'EXIT';
                       PSts   = '12';
                    Else;
                       PMsgId  = 'WS00038';
                       Exsr SendMessage;
                    Endif;
                 Endif;

      *?      // F12 Pressed
              When Dspf.Previous;
                 ModReq = 'EXIT';
                 PSts   = '12';

      *?      // Other Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input capable Control and Subfile Fields ,
      *?      : If No errors then Process , Else Display error in Screen
      *?
        Begsr SN3V;

      *?   // Initialise Fields
           Dspf.S03SelRi = False;
           WkCount  = *Zeros;
           FlError  = False;
           FlMulSel = False;

      *?   // Validate Screen Fields
           Exsr ValidateSR;
           If FlError = True;
              FlCtlMod = True;
           Endif;

      *?   // Validate Entered values in Subfile
           If Dspf.S03SflDsp And FlError = False;
              ReadC ORDEXPS03;
              Dow Not %Eof;
                 Dspf.S03SelRi = False;

      *?         // Validate Option
                 If FlMulSel <> True ;
                    If S03Sel <> 1 And S03Sel <> 0 ;
                       FlError  = True;
                       Dspf.S03SelRi = True;
                       PMsgId  = 'WS00028';
                       Exsr SendMessage;
                    Else;
                      If S03Sel = 0 ;
                         Dspf.S03SelRi = False;
                      Else;
                         FlMulSel = True;
                      EndIf;
                       FlSflMod = True;
                    Endif;
                 Elseif FlMulSel = True;
                    FlError = True;
                    Dspf.S03SelRi = True;
                    PMsgId  = 'WS00036';
                    Exsr SendMessage;
                 Endif;
                 Dspf.S03SflNxtChg = True;
                 Update ORDEXPS03;
                 Dspf.S03SflNxtChg = False;
                 ReadC ORDEXPS03;
              Enddo;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError Or FlError1 Or FlError2;
              FunReq = 'DISPLAY';
           Elseif FlSflMod;
              FunReq = 'PROCESS';
           Elseif FlError = False;
              If C03Find = ' ';
                 FunReq = 'PROCESS';
              Else ;
                 FunReq = 'INITIAL';
              EndIf;
           Else;
              FunReq = 'DISPLAY';
              ModReq = 'SCREEN';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN3P;

      *?   // Read Changed record and Process based on Option
           If Dspf.S03SflDsp;
              ReadC ORDEXPS03;
              Dow Not %Eof;

                 If S03Sel = 1 ;
                    C03CSTUSE = S03CUST ;
                    S03SEL = 0;
                 EndIf;
                 Dspf.S03SflNxtChg = False;
                 Update ORDEXPS03;
                 Dspf.S03SflNxtChg = False;
                 ReadC ORDEXPS03;
              Enddo;

           Endif;
           FunReq = 'INITIAL';
           ModReq = 'SCREEN';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3C Subroutine :
      *?                :-----------------:
      *
      *?Logic : Create new Customer in FMCUST based on XML Inputs and
      *?        Screen Customer On Function Key F6 = Create Customer
      *?
        Begsr SN3C;

      *?   // Initialize Indicators
           Dspf.C03CusNoPr = False;
           Dspf.C03CusNaPr = False;
           Dspf.C03CusAdPr = False;
           Dspf.C03CusCtPr = False;
           Dspf.C03CusStPr = False;
           Dspf.C03CusZpPr = False;
           Dspf.C03CusPhPr = False;
           Dspf.C03CusFxPr = False;
           FlError2 = False;

      *?   // If ShipTo Address is not Equal to Blanks
           If C03Cust <> ' ' And C03Name <> ' ' And C03City <> ' ' And
              C03State <> ' ' And C03Phone <> ' ' And C03Zip <> ' ' And
              (C03Adrs1 <> ' ' Or C03Adrs2 <> ' ');

              Setll *Start FNXTCUST;
              Read FNXTCUST ;
              Customer = NXCUST ;

      *?      // Delete the above customer from Fnxtcust file
              Exec Sql
                 Delete from FNXTCUST where NXCUST = :Customer;

      *?      // Clear Record
              Clear RMCUST;

      *?      // Create new customer in FMCUST file
              CMSTAT = 'A' ;
              CMCUST = Customer;
              CMNAME = C03NAME ;
              CMADD2 = C03ADRS1 ;
              CMADD3 = C03ADRS2 ;
              CMCITY = C03CITY  ;
              CMSTST = C03STATE ;
SUD02         CMZIP  = %SUBST(C03ZIP:1:5);      // Get only first 5 digit
VV01          CMPHON = %Int(C03PHONE);

      *?      // Get Billing Customer From Broker Default file
              CMARCU = WkID;
              CMBLCU = WkID;

SUD02 *?      // Get Customer type from Broker default file
  |           Chain (WkIDC : 'CMCTYP') FBROKDFTL0;
  |           If %Found;
  |              CMCTYP = %Trim(DFVARVAL);
  |           Endif;
  |
  |   *?      // Get Customer Abbreviation from Broker default file
  |           Chain (WkIDC : 'CMBABB') FBROKDFTL0;
  |           If %Found;
  |              CMBABB = %Trim(DFVARVAL);
SUD02         Endif;

      *?      // Other Hard coded values
              CMSACU = Customer;
              CMSLSM = '01';
              CMTERR = 'NJ';
              CMCOMM =  0;
              CMPORQ = 'Y';
              CMORLS = '*NONE';
              CMJOBR = 'N';
              CMPRCD = 1;
              CMCTCD = 'N';
              CMBOOK = 'Y';
              CMQDIS = 'N';
              CMTRDC = 20.00;
              CMTXID = 'BROKER';
              CMSVCD = '01';            // Default to truck
              CMTMCD = '01';
              CMCRL$ = *ZEROS;
              CMCNAM = *BLANKS;
              CMARCD = 'O';
              CMSMCD = 1;
              CMCOPY = 1;
              CMACK  = 'Y';
              CMAPLC = 'Y';
              CMCODF = 'N';
              CMDSHF = 'N';
SUD02         CMCNME = WkName;

              Destination =
                %Trim(CMNAME)+'+'+
                %Trim(CMADD2)+'+'+
                %Trim(CMADD3)+'+'+
                %Trim(CMCITY)+'+'+
                %Trim(CMSTST)+'+'+
                %Trim(CMZIP);
              Destination = %ScanRpl('  ': ' ': Destination);
              Destination = %ScanRpl(' ': '+': Destination);

      *?      // Get Freight Zone
              Exec SQL
                 Select FZONE Into :CMUPSZ From FUZONEZ
                 Where Milesfkp( :Destination )
                 Between FUFMMI And FUTOMI;

SUD02 *?      // Check record in Tax Exempt FCUSTCOM
  |           Chain(N) Customer FCUSTCOM;
  |           If %Found;
  |              CMTXST = 'Y';
  |           Else;
  |
  |   *?         // Write record in FCUSTCOM
  |              Clear RCUSTCOM;
  |              CCSTAT = 'A';                  // STATUS
  |              CCUST  = Customer;             // CUST NUMBER
  |              CCSEQ  = 1;                    // COMMENT SEQ
  |              CCCOM1 = *Blanks;              // CUSTOMER COMMENT 1
  |              CCCOM2 = *Blanks;              // CUSTOMER COMMENT 2
  |              CCEML  = *Blanks;              // EMAIL ADDRESS
  |              CCURL  = *Blanks;              // WEB ADDRESS
  |              CCST3  = 'E';                  // ST3 Y/N/E
  |              CCCRED = 'N';                  // CREDIT APP ON FILE Y/N
  |              Write RCUSTCOM;
  |              CMTXST = 'Y';
SUD02         Endif;

      *?      // Write record in FMCUST
              Write RMCUST;

      *?      // Write record in FARHST file
              Clear RARHST;
              HSSTAT = 'A';
              HSCUST = Customer;
              HSINCL = 'Y';
SUD08         HSFAX  = %Int(C03FAX);
              Write RARHST;

      *?      // Call ARR010CLC to Create Customer
              ARR010CLC(Customer);

              Exec Sql
                 Select CmCtyp Into :CustType From FmCust
                 Where CmCust = :Customer;

              If CustType = '99';
                 FlError1 = True;
                 PMsgId  = 'WS00033';
                 Exsr SendMessage;
              EndIf;
              C03CSTUSE = Customer;

           Else;
              FlError2 = True;
              PMsgId  = 'WS00032';
              Exsr SendMessage;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN3U Subroutine :
      *?                :-----------------:
      *
      *?Logic : Create XrefCust based on XML Inputs and Screen Inputs
      *?          On Function Key F10 = Update
      *?      : Update XMl Header file and Error Exception File Flags as Blank
      *
        Begsr SN3U;

      *?   // Get Timestamp
           WkTs = %Timestamp();

      *?   // Execute Sql Statement to Insert Record in XREFCUST
           Exec Sql
           INSERT INTO XREFCUST (TABLECROSSREFERENCED,
                                 PROVIDEDBYNAME,
                                 PROVIDEDBYTYPE,
                                 PROVIDEDBYID,
                                 FOREIGNKEYVALUE,
                                 DESCRIPTION,
                                 LOCALKEYVALUE,
                                 CREATED_TS,
                                 CREATED_BY)
                       VALUES ('FMCUST',
                               :C03BRKID,
                               'Customer',
                               :WkID,
                               :C03CUST,
                               :S03NAME,
                               :C03CSTUSE,
                               :WkTs,
                               :User);

      *?   // Execute UpdateHeader
           Exsr UpdateHeader;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : UpdateHeader Subroutine :
      *?                :-------------------------:
      *
        Begsr UpdateHeader;

      *?   // Create Order : Update Record in WSPOHDRPF
           If PPgm = 'CreateOrd';
              Chain (C03BrkID:C03Custpo:C03Seqno) WSPOHDRL1;
              PHSEQNO  = C03SEQNO;
              WkDate   = %Dec(%Char(%Date(C03SHPDATE:*MDY/):*MDY0):7:0);
              PHRQSHDT = %Date(WkDate:*Mdy);
              PHSHPNUM = C03CUST;
              PHSHPNAM = C03NAME;
              PHSHPAD1 = C03ADRS1;
              PHSHPAD2 = C03ADRS2;
              PHSHPCTY = C03CITY;
              PHSHPSTE = C03STATE;
              PHSHPZIP = C03ZIP;
              PHSHPPHN = C03PHONE;
              PHSHPFAX = C03FAX;
              PHSHPMTH = C03SHPCODE;
              PHFLAG   = ' ';
              PHUPDDAT = Rundate;
              PHUPDTIM = Runtime;
              PHUPDUSR = User;
              PHUPDJOB = Job;
              PHUPDPGM = Pgm;

              Update WSPOHDRR %Fields(PHSEQNO:PHSHPNUM:PHSHPNAM:PHSHPMTH:
                                      PHSHPAD1:PHSHPAD2:PHSHPCTY:PHSHPSTE:
                                      PHSHPPHN:PHSHPFAX:PHSHPZIP:
                                      PHFLAG:PHUPDDAT:PHUPDTIM:
                                      PHUPDUSR:PHUPDJOB:PHUPDPGM);

      *?   // Change Order : Update Record in WSCOHDRPF
           Elseif PPgm = 'ChangeOrd';
              Chain (C03BrkID:C03Custpo:C03Seqno) WSCOHDRL1;
              CHSEQNO  = C03SEQNO;
              WkDate   = %Dec(%Char(%Date(C03SHPDATE:*MDY/):*MDY0):7:0);
              CHRQSHDT = %Date(WkDate:*Mdy);
              CHSHPNUM = C03CUST;
              CHSHPNAM = C03NAME;
              CHSHPAD1 = C03ADRS1;
              CHSHPAD2 = C03ADRS2;
              CHSHPCTY = C03CITY;
              CHSHPSTE = C03STATE;
              CHSHPZIP = C03ZIP;
              CHSHPPHN = C03PHONE;
              CHSHPFAX = C03FAX;
              CHSHPMTH = C03SHPCODE;
              CHFLAG   = ' ';
              CHUPDDAT = Rundate;
              CHUPDTIM = Runtime;
              CHUPDUSR = User;
              CHUPDJOB = Job;
              CHUPDPGM = Pgm;

              Update WSCOHDRR %Fields(CHSEQNO:CHSHPNUM:CHSHPNAM:CHSHPMTH:
                                      CHSHPAD1:CHSHPAD2:CHSHPCTY:CHSHPSTE:
                                      CHSHPPHN:CHSHPFAX:CHSHPZIP:
                                      CHFLAG:CHUPDDAT:CHUPDTIM:
                                      CHUPDUSR:CHUPDJOB:CHUPDPGM);
           Endif;

      *?   // Execute UpdateError
           Exsr UpdateError;

      *?   // If No Exception Process Create Order
           If WkPrFlag = 'N';
              Exsr CreateOrder;

SUD06 *?      // Check Error File for Other PO/CO With the Same Broker
  |           WkBrkName = C03BrkID;
SUD06         Exsr CheckErrorFile;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : UpdateError Subroutine :
      *?                :------------------------:
      *
        Begsr UpdateError;

      *?   // Update Error Flag in Exception File
           WkPrFlag = 'N';
           Setll (PBrkId:PCustPO:PSeqNo) WSERREXPL2;
           ReadE (PBrkId:PCustPO:PSeqNo) WSERREXPL2;
           Dow Not %Eof;
              If ERFLAG = 'H';
                 ERFLAG = ' ';

      *?         // Audit Stamp
                 ERUPDDAT = Rundate;
                 ERUPDTIM = Runtime;
                 ERUPDUSR = User;
                 ERUPDJOB = Job;
                 ERUPDPGM = Pgm;
                 Update WSERREXPR  %Fields(ERFLAG:ERUPDDAT:ERUPDTIM:
                                         ERUPDUSR:ERUPDJOB:ERUPDPGM);
              Elseif ERFLAG = 'D';
                 If ERRMSGID <> 'WS00021' and ERRMSGID <> 'WS00024' And
                    ERRMSGID <> 'WS00026';
                    WkPrFlag = 'N';
                 Else;
                    ERFLAG = ' ';

      *?            // Audit Stamp
                    ERUPDDAT = Rundate;
                    ERUPDTIM = Runtime;
                    ERUPDUSR = User;
                    ERUPDJOB = Job;
                    ERUPDPGM = Pgm;
                    Update WSERREXPR  %Fields(ERFLAG:ERUPDDAT:ERUPDTIM:
                                            ERUPDUSR:ERUPDJOB:ERUPDPGM);
                 Endif;
              Endif;
              ReadE (PBrkId:PCustPO:PSeqNo) WSERREXPL2;
           Enddo;

        Endsr;
SUD06 //--------------------------------------------------------------------
  |   *?                :---------------------------:
  |   *?                : CheckErrorFile Subroutine :
  |   *?                :---------------------------:
  |   *
  |     Begsr CheckErrorFile;
  |
  |   *?   // Create Order : Update Record in WSPOHDRPF
  |        Exec Sql Declare A2 Cursor For
  |           Select ERBRKORID, ERPOSEQ, ERCRTPGM
  |           From WSERREXPPF Where (ERBRKNAM = :WkBrkName)
  |           And (ERFLAG = 'H' Or ERFLAG ='D')
  |           And (ERRMSGID = 'WS00022' Or ERRMSGID = 'WS00016' Or
  |                ERRMSGID = 'WS00027');
  |
  |        Exec Sql Open A2;
  |        If SqlCode = -502 ;
  |           Exec Sql Close A2;
  |           Exec Sql Open A2;
  |        Endif;
  |
  |        Exec Sql Fetch A2 Into :WkErBrkID, :WkErSeq, :WkPgm;
  |
  |   *?   // Check and Process Order
  |        Dow SqlCod = 0;
  |           Exsr UpdateHeaderPO;
  |           Exec Sql Fetch A2 Into :WkErBrkID, :WkErSeq, :WkPgm;
  |        Enddo;
  |        Exec Sql Close A2;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :---------------------------:
  |   *?                : UpdateHeaderPO Subroutine :
  |   *?                :---------------------------:
  |   *
  |     Begsr UpdateHeaderPO;
  |
  |   *?   // Create Order : Update Record in WSPOHDRPF
  |        If WkPgm = 'WSPOVAL002';
  |           Chain (WkBrkName:WkErBrkID:WkErSeq) WSPOHDRL1;
  |           If PHFLAG = 'E';
  |              PHFLAG   = ' ';
  |              PHUPDDAT = Rundate;
  |              PHUPDTIM = Runtime;
  |              PHUPDUSR = User;
  |              PHUPDJOB = Job;
  |              PHUPDPGM = Pgm;
  |              Update WSPOHDRR %Fields(PHFLAG:PHUPDDAT:PHUPDTIM:
  |                                      PHUPDUSR:PHUPDJOB:PHUPDPGM);
  |           Endif;
  |
  |   *?   // Change Order : Update Record in WSCOHDRPF
  |        Elseif WkPgm = 'WSCOVAL002';
  |           Chain (WkBrkName:WkErBrkID:WkErSeq) WSCOHDRL1;
  |           If CHFLAG = 'E';
  |              CHFLAG   = ' ';
  |              CHUPDDAT = Rundate;
  |              CHUPDTIM = Runtime;
  |              CHUPDUSR = User;
  |              CHUPDJOB = Job;
  |              CHUPDPGM = Pgm;
  |              Update WSCOHDRR %Fields(CHFLAG:CHUPDDAT:CHUPDTIM:
  |                                      CHUPDUSR:CHUPDJOB:CHUPDPGM);
  |           Endif;
  |        Endif;
  |
  |   *?   // Execute UpdateError
  |        Exsr UpdateErrorPO;
  |
  |   *?   // If No Exception Process Create Order
  |        If WkPrFlag = 'N';
  |           Exsr CreateOrderPO;
  |        Endif;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------------:
  |   *?                : UpdateErrorPO Subroutine :
  |   *?                :--------------------------:
  |   *
  |     Begsr UpdateErrorPO;
  |
  |   *?   // Update Error Flag in Exception File
  |        WkPrFlag = 'N';
  |        Setll (WkBrkName:WkErBrkID:WkErSeq) WSERREXPL2;
  |        ReadE (WkBrkName:WkErBrkID:WkErSeq) WSERREXPL2;
  |        Dow Not %Eof;
  |           If ERFLAG = 'H';
  |              ERFLAG = ' ';
  |
  |   *?         // Audit Stamp
  |              ERUPDDAT = Rundate;
  |              ERUPDTIM = Runtime;
  |              ERUPDUSR = User;
  |              ERUPDJOB = Job;
  |              ERUPDPGM = Pgm;
  |              Update WSERREXPR  %Fields(ERFLAG:ERUPDDAT:ERUPDTIM:
  |                                      ERUPDUSR:ERUPDJOB:ERUPDPGM);
  |           Elseif ERFLAG = 'D';
  |              If ERRMSGID <> 'WS00021' and ERRMSGID <> 'WS00024' And
  |                 ERRMSGID <> 'WS00026';
  |                 WkPrFlag = 'N';
  |              Else;
  |                 ERFLAG = ' ';
  |
  |   *?            // Audit Stamp
  |                 ERUPDDAT = Rundate;
  |                 ERUPDTIM = Runtime;
  |                 ERUPDUSR = User;
  |                 ERUPDJOB = Job;
  |                 ERUPDPGM = Pgm;
  |                 Update WSERREXPR  %Fields(ERFLAG:ERUPDDAT:ERUPDTIM:
  |                                         ERUPDUSR:ERUPDJOB:ERUPDPGM);
  |              Endif;
  |           Endif;
  |           ReadE (WkBrkName:WkErBrkID:WkErSeq) WSERREXPL2;
  |        Enddo;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------------:
  |   *?                : CreateOrderPO Subroutine :
  |   *?                :--------------------------:
  |   *
  |   *?Logic : Check Error file , If there is no error ,Then update Xml
  |   *?        Files and call Validation program to Create/Change Order
  |   * ?
  |     Begsr CreateOrderPO;
  |
  |   *?   // Check Error File before Process Order
  |        WkFlag = 'Y';
  |        Setll    (WkBrkName:WkErBrkID:WkErSeq) WSERREXPL2;
  |        ReadE(N) (WkBrkName:WkErBrkID:WkErSeq) WSERREXPL2;
  |        Dow Not %Eof;
  |           If ERFLAG = 'H';
  |              WkFlag = 'N';
  |              Leave;
  |           Else;
  |              WkFlag = 'Y';
  |           Endif;
  |           If ERFLAG = 'D';
  |              If ERRMSGID <> 'WS00021' And ERRMSGID <> 'WS00024';
  |                 WkFlag = 'N';
  |                 Leave;
  |              Else;
  |                 WkFlag = 'Y';
  |              Endif;
  |           Endif;
  |           If ERFLAG = 'I';
  |              WkFlag = 'Y';
  |           Endif;
  |           ReadE(N) (WkBrkName:WkErBrkID:WkErSeq) WSERREXPL2;
  |        Enddo;
  |
  |   *?   // Process Order
  |        If WkFlag = 'Y';
  |           If WkPGM = 'WSPOVAL002';
  |              PFlag = ' ';
  |              WSPOVAL002(WkBrkName:WkErBrkID:WkErSeq:PFlag);
  |              If PFlag = 'C';
  |                 PBrkAck = *Blanks;
  |                 If PBrkName <> 'Michell';
  |                    WSPOACK003(WkBrkName:WkErBrkID:WkErSeq:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'PO';
  |                    WSPOACKMCH(WkBrkName:WkErBrkID:WkErSeq:PBrkAck
  |                                         :PPrFlag);
  |                 Endif;
  |                 PSts = '12';
  |              Endif;
  |           Elseif WkPGM = 'WSCOVAL002';
  |              PFlag = ' ';
  |              WSCOVAL002(WkBrkName:WkErBrkID:WkErSeq:PFlag);
  |              If PFlag = 'C';
  |                 PBrkAck = *Blanks;
  |                 If PBrkName <> 'Michell';
  |                    WSCOACK003(WkBrkName:WkErBrkID:WkErSeq:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'CO';
  |                    WSPOACKMCH(WkBrkName:WkErBrkID:WkErSeq:PBrkAck
  |                                         :PPrFlag);
  |                 Endif;
  |                 PSts = '12';
  |              Endif;
  |           Endif;
  |        Endif;
  |
SUD06   Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : CreateXrefSvia Subroutine :
      *?                :---------------------------:
      *
        Begsr CreateXrefSvia;

      *?   // Get TimeStamp
           WkTs = %Timestamp();

      *?   // Customer Pickup
           If C03CSTPICK = 'Y';
              WkLclKey = '02';
           Else;
              WkLclKey = 'FMCUST';
           Endif;

      *?   // Execute Sql Statement to Insert Record in XREFSVIA
           Exec Sql
              INSERT INTO XREFSVIA (TABLECROSSREFERENCED,
                                 PROVIDEDBYNAME,
                                 PROVIDEDBYTYPE,
                                 PROVIDEDBYID,
                                 FOREIGNKEYVALUE,
                                 DESCRIPTION,
                                 LOCALKEYVALUE,
                                 CREATED_TS,
                                 CREATED_BY)
                       VALUES ('FMSVIA',
                               :C03BRKID,
                               'Customer',
                               :WkID,
                               :C03SHPCODE,
                               :WkDesc,
                               :WkLclKey,
                               :WkTs,
                               :User);

        Endsr;
SUD08 //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : PhoneSr Subroutine :
  |   *?                :--------------------:
  |   *
  |   *?Logic : Get phone number and Fax for screen
  |   *?
  |     Begsr PhoneSr;
  |
  |   *?   // Clear Values
  |        WkNPhone = *Zeros;
  |        Clear PhoneAry;
  |        Clear NPhoneAry;
  |
  |   *?   // Format Phone Number
  |        PhoneDs = WkPhone;
  |        WkNPos  = 1;
  |        For WkPos = 1 by 1 to 18;
  |           If PhoneAry(WkPos) >= '0' and PhoneAry(WkPos) <= '9';
  |              NPhoneAry(WkNPos) = PhoneAry(WkPos);
  |              WkNPos += 1;
  |           Endif;
  |        Endfor;
  |
  |   *?   // Formatted Phone Number
  |        WkNPhone = %Subst(NewPhoneDs:1:10);
  |        If WkNPhone = ' ';  //  WJB set to *Zero if no value
             WkNPhone = '0';
           ENDIF;
  |     Endsr;
SUD08 //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialize Screen Inputs
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PGMQ      = Pgm;
           C03Sys    = Job;
           C03Pgm    = Pgm;
           C03BRKID  = PBrkId;
           C03CUSTPO = PCustPo;
           C03SEQNO  = PSeqNo;
           C03ORDER  = POrdNo;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

      *?   // Close cursor
           Exec Sql Close A1;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : SetIndicator Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Set Indicators before loading Subfile
      *?
        Begsr SetIndicator;

      *?   // Initilize Subfile Indicators
           Dspf.C03CusNoPr = True;
           Dspf.C03ShpDtPr = True;
           Dspf.C03CusNaPr = True;
           Dspf.C03ShpCdPr = True;
           Dspf.C03CusPkPr = True;
           Dspf.C03CusPkNd = True;
           Dspf.C03CusAdPr = True;
           Dspf.C03CusCtPr = True;
           Dspf.C03CusStPr = True;
           Dspf.C03CusZpPr = True;
           Dspf.C03CusPhPr = True;
           Dspf.C03CusFxPr = True;
           Dspf.C03SflNd   = True;

           If PPgm = 'CreateOrd';

      *?      // Check Record exists in XREFCUST
              If PHSHPNUM = ' ' ;
                 If C03CUST = ' ' ;
                    Dspf.C03CusNoPr = False;
                 Else;
                    Dspf.C03CusNoPr = False;
                 Endif;
                 Dspf.C03SflNd   = False;
              Endif;

      *?      // Check Record exists in XREFCUST
              If C03CUST <> *Blanks ;
                 WkCount1 = 0 ;
                 Exec Sql
                    Select Count(*) Into :WkCount1 From XrefCust
                    Where XRPVDNM = :C03BRKID And
                    XRPVDTP = 'Customer' And XRFORKEY = :C03CUST;
                 If SqlCode = 0 and Wkcount1 = 0;
                    Dspf.C03SflNd   = False;
                 Endif;
              Endif;

      *?      // Check Requested ship date
              If PHRQSHDT = *Loval;
                 If C03SHPDATE = *Loval;
                    Dspf.C03ShpDtPr = False;
                 Else;
                    Dspf.C03ShpDtPr = False;
                 Endif;
              Endif;

SUD03 *?      // Check ShipCode Execpt Ball Seed
SUD03         If PHSHPMTH = *Blanks and C03BRKID <> 'Ball Seed';
                 If C03SHPCODE = *Blanks;
                    Dspf.C03ShpCdPr = False;
                    Dspf.C03CusPkPr = False;
                    Dspf.C03CusPkNd = False;
                    C03CSTPICK      = 'Y';
                 Else;
                    Dspf.C03ShpCdPr = False;
                    Dspf.C03CusPkPr = False;
                    Dspf.C03CusPkNd = False;
                 Endif;
              Endif;

SUD03 *?      // Check Record exists in XREFSVIA Except Ball Seed
SUD03         If C03BRKID <> 'Ball Seed';
                 WkCount2 = 0 ;
                 Exec Sql
                    Select Count(*) Into :WkCount2
                    From XrefSvia Where XRPVDNM = :C03BRKID And
                    XRPVDTP = 'Customer' And XRFORKEY = :C03SHPCODE;
                 If SqlCode = 0 and WkCount2 = 0;
                    Dspf.C03ShpCdPr = False;
                    Dspf.C03CusPkPr = False;
                    Dspf.C03CusPkNd = False;
                    C03SVIADES      = 'Not Yet Matched';
                    C03CSTPICK      = 'Y';
                 Elseif SqlCode = 0 and WkCount2 <> 0 and
                       C03SHPCODE <> *Blanks;
                    Dspf.C03CusPkPr = True;
                    Dspf.C03ShpCdPr = True;
                    Dspf.C03CusPkNd = True;
                 Endif;
              Else;
                 Dspf.C03CusPkPr = True;
                 Dspf.C03CusPkNd = True;
              Endif;

      *?      // Check Ship To fields
              If PHSHPNAM = ' ';
                 If C03NAME = ' ';
                    Dspf.C03CusNaPr = False;
                 Else;
                    Dspf.C03CusNaPr = False;
                 Endif;
              Endif;

              If PHSHPAD1 = ' ' And PHSHPAD2 = ' ';
                 If C03ADRS1 = ' ' And C03ADRS2 = ' ';
                    Dspf.C03CusAdPr = False;
                 Else;
                    Dspf.C03CusAdPr = False;
                 Endif;
              Endif;

              If PHSHPCTY= ' ';
                 If C03CITY = ' ';
                    Dspf.C03CusCtPr = False;
                 Else;
                    Dspf.C03CusCtPr = False;
                 Endif;
              Endif;

              If PHSHPSTE = ' ';
                 If C03STATE = ' ';
                    Dspf.C03CusStPr = False;
                 Else;
                    Dspf.C03CusStPr = False;
                 Endif;
              Endif;

              If PHSHPZIP = ' ';
                 If C03ZIP = ' ';
                    Dspf.C03CusZPPr = False;
                 Else;
                    Dspf.C03CusZpPr = False;
                 Endif;
              Endif;

              If PHSHPPHN = ' ';
                 If C03PHONE = ' ';
                    Dspf.C03CusPhPr = False;
                 Else;
                    Dspf.C03CusStPr = False;
                 Endif;
              Endif;

              If PHSHPFAX = ' ';
                 If C03FAX = ' ';
                    Dspf.C03CusFxPr = False;
                 Else;
                    Dspf.C03CusStPr = False;
                 Endif;
              Endif;

           Elseif PPgm = 'ChangeOrd';

      *?      // Check Record exists in XREFCUST
              If CHSHPNUM = ' ' ;
                 If C03CUST = ' ' ;
                    Dspf.C03CusNoPr = False;
                 Else;
                    Dspf.C03CusNoPr = False;
                 Endif;
                 Dspf.C03SflNd   = False;
              Endif;

      *?      // Check Record exists in XREFCUST
              If C03CUST <> *Blanks ;
                 WkCount1 = 0 ;
                 Exec Sql
                    Select Count(*) Into :WkCount1 From XrefCust
                    Where XRPVDNM = :C03BRKID And
                    XRPVDTP = 'Customer' And XRFORKEY = :C03CUST;
                 If SqlCode = 0 and Wkcount1 = 0;
                    Dspf.C03SflNd   = False;
                 Endif;
              Endif;

      *?      // Check Requested ship date
              If CHRQSHDT = *Loval;
                 If C03SHPDATE = *Loval;
                    Dspf.C03ShpDtPr = False;
                 Else;
                    Dspf.C03ShpDtPr = False;
                 Endif;
              Endif;

SUD03 *?      // Check ShipCode Except Ball Seed
SUD03         If CHSHPMTH = *Blanks and C03BRKID <> 'Ball Seed';
                 If C03SHPCODE = *Blanks;
                    Dspf.C03ShpCdPr = False;
                    Dspf.C03CusPkPr = False;
                    Dspf.C03CusPkNd = False;
                    C03CSTPICK      = 'Y';
                 Else;
                    Dspf.C03ShpCdPr = False;
                    Dspf.C03CusPkPr = False;
                    Dspf.C03CusPkNd = False;
                 Endif;
              Endif;

SUD03 *?      // Check Record exists in XREFSVIA Except Ball Seed
SUD03         If C03BRKID <> 'Ball Seed';
                 WkCount2 = 0 ;
                 Exec Sql
                    Select Count(*) Into :WkCount2 From XrefSvia
                    Where XRPVDNM = :C03BRKID And
                    XRPVDTP = 'Customer' And XRFORKEY = :C03SHPCODE;
                 If SqlCode = 0 and WkCount2 = 0;
                    Dspf.C03ShpCdPr = False;
                    Dspf.C03CusPkPr = False;
                    Dspf.C03CusPkNd = False;
                    C03SVIADES      = 'Not Yet Matched';
                    C03CSTPICK      = 'Y';
                 Elseif SqlCode = 0 and WkCount2 <> 0 And
                       C03SHPCODE <> *Blanks;
                    Dspf.C03ShpCdPr = True;
                    Dspf.C03CusPkPr = True;
                    Dspf.C03CusPkNd = True;
                 Endif;
              Else;
                 Dspf.C03CusPkNd = True;
              Endif;

      *?      // Check Ship To fields
              If CHSHPNAM = ' ';
                 If C03NAME = ' ';
                    Dspf.C03CusNaPr = False;
                 Else;
                    Dspf.C03CusNaPr = False;
                 Endif;
              Endif;

              If CHSHPAD1 = ' ' and CHSHPAD2 = ' ';
                 If C03ADRS1 = ' ' And C03ADRS2 = ' ';
                    Dspf.C03CusAdPr = False;
                 Else;
                    Dspf.C03CusAdPr = False;
                 Endif;
              Endif;

              If CHSHPCTY= ' ';
                 If C03CITY = ' ';
                    Dspf.C03CusCtPr = False;
                 Else;
                    Dspf.C03CusCtPr = False;
                 Endif;
              Endif;

              If CHSHPSTE = ' ';
                 If C03STATE = ' ';
                    Dspf.C03CusStPr = False;
                 Else;
                    Dspf.C03CusStPr = False;
                 Endif;
              Endif;

              If CHSHPZIP = ' ';
                 If C03ZIP = ' ';
                    Dspf.C03CusZPPr = False;
                 Else;
                    Dspf.C03CusZpPr = False;
                 Endif;
              Endif;

              If CHSHPPHN = ' ';
                 If C03PHONE = ' ';
                    Dspf.C03CusPhPr = False;
                 Else;
                    Dspf.C03CusStPr = False;
                 Endif;
              Endif;

              If CHSHPFAX = ' ';
                 If C03FAX = ' ';
                    Dspf.C03CusFxPr = False;
                 Else;
                    Dspf.C03CusStPr = False;
                 Endif;
              Endif;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ValidateSr Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Validate input fields in Screen
      *?
        Begsr ValidateSR;

      *?   // Check Control Fields and Set Indicator
           If C03CUST = ' ';
              Dspf.C03CusNoPr = False;                  // ShipTo
              Dspf.C03SflNd   = False;
              FlError = True;
              PMsgId  = 'WS00009';
              Exsr SendMessage;
           Endif;

           If C03NAME = ' ' ;
              Dspf.C03CusNaPr = False;                  // ShiPTo Name
              FlError = True;
              PMsgId  = 'WS00010';
              Exsr SendMessage;
           Endif;

           If C03ADRS1 = ' ' And C03ADRS2 = ' ';
              Dspf.C03CusAdPr = False;                  // ShipTo Address
              FlError = True;
              PMsgId  = 'WS00011';
              Exsr SendMessage;
           Endif;

           If C03STATE = ' ';
              Dspf.C03CusStPr = False;                  // ShipTo State
              FlError = True;
              PMsgId  = 'WS00012';
              Exsr SendMessage;
           Endif;

           If C03ZIP = ' ';
              Dspf.C03CusZpPr = False;                  // ShipTo Zip
              FlError = True;
              PMsgId  = 'WS00047';
              Exsr SendMessage;
           Endif;

           If C03CITY = ' ';
              Dspf.C03CusCtPr = False;                  // ShipTo City
              FlError = True;
              PMsgId  = 'WS00013';
              Exsr SendMessage;
           Endif;

           If C03PHONE = ' ';
              Dspf.C03CusPhPr = False;                  // ShipTo Phone
              FlError = True;
              PMsgId  = 'WS00014';
              Exsr SendMessage;
           Endif;

           If C03SHPDATE = *Loval;
              Dspf.C03ShpDtPr = False;                  // ReqShipDate
              FlError = True;
              PMsgId  = 'WS00002';
              Exsr SendMessage;
           Endif;

SUD03      If C03SHPCODE = *Blanks and C03BRKID <> 'Ball Seed';
              Dspf.C03ShpCdPr = False;                  // ShipVia Code
              FlError = True;
              PMsgId  = 'WS00043';
              Exsr SendMessage;
           Endif;

SUD03      If C03BRKID <> 'Ball Seed' and WkCount2 = *Zeros;
              If C03CSTPICK <> 'Y' and C03CSTPICK <> 'N';
                 FlError = True;
                 Dspf.C03CusPkPr = False;
                 PMsgId  = 'WS00044';
                 Exsr SendMessage;
              Endif;
           Endif;

      *?   // Check Subfile Fields
           If C03CSTUSE <> *Zeros;
              Exec Sql
                 Select CmCtyp Into :CustType From FmCust
                 Where CmCust = :C03CSTUSE;
              If CustType = '99';
                 FlError1 = True;
                 PMsgId  = 'WS00033';
                 Exsr SendMessage;
              EndIf;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : CreateOrder Subroutine :
      *?                :------------------------:
      *
      *?Logic : Check Error file , If there is no error ,Then update Xml
      *?        Files and call Validation program to Create/Change Order
      * ?
        Begsr CreateOrder;

      *?   // Check Error File before Process Order
           WkFlag = 'Y';
           Setll    (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           ReadE(N) (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           Dow Not %Eof;
              If ERFLAG = 'H';
                 WkFlag = 'N';
                 Leave;
              Else;
                 WkFlag = 'Y';
              Endif;
              If ERFLAG = 'D';
                 If ERRMSGID <> 'WS00021' And ERRMSGID <> 'WS00024';
                    WkFlag = 'N';
                    Leave;
                 Else;
                    WkFlag = 'Y';
                 Endif;
              Endif;
              If ERFLAG = 'I';
                 WkFlag = 'Y';
              Endif;
              ReadE(N) (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           Enddo;

      *?   // Process Order
           If WkFlag = 'Y';
              If PPgm = 'CreateOrd';
                 PBrkName = C03BRKID;
                 PFlag = ' ';
                 WSPOVAL002(PBrkName:PCustPO:PSeqno:PFlag);
                 If PFlag = 'C';
                    PBrkAck = *Blanks;
SUD04               If PBrkName <> 'Michell';
  |                    WSPOACK003(PBrkName:PCustPO:PSeqno:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'PO';
  |                    WSPOACKMCH(PBrkName:PCustPO:PSeqno:PBrkAck
  |                                         :PPrFlag);
SUD04               Endif;
                    PSts = '12';
                 Endif;
              Elseif PPgm = 'ChangeOrd';
                 PBrkName = C03BRKID;
                 PFlag = ' ';
                 WSCOVAL002(PBrkName:PCustPO:PSeqno:PFlag);
                 If PFlag = 'C';
                    PBrkAck = *Blanks;
SUD04               If PBrkName <> 'Michell';
  |                    WSCOACK003(PBrkName:PCustPO:PSeqno:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'CO';
  |                    WSPOACKMCH(PBrkName:PCustPO:PSeqno:PBrkAck
  |                                         :PPrFlag);
SUD02               Endif;
                    PSts = '12';
                 Endif;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : ClearMessage Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Clear Message
      *?
        Begsr ClearMessage;

      *?   // Clear Message from Message Subfile Control Part
           PMsgf  = 'WSMSGF';
           POpt   = 'C';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : SendMessage Subroutine :
      *?                :------------------------:
      *
      *?Logic : Send Message
      *?
        Begsr SendMessage;

      *?   // Show Message on Message Subfile Control Part
           PMsgf  = 'WSMSGF';
           POpt   = 'I';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
