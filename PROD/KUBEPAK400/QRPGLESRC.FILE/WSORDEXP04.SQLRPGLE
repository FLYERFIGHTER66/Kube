      *? Program        : WSORDEXP04
      *?
      *? Description    : This pgm to validate PO/CO Detail Fields
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 15 Nov 2017
      //--------------------------------------------------------------------
      *? Special Notes  : ** Validate Detail fields , If No errors Update
      *?                     XML file and Exception file flag
      *?                  ** Select Item and Create Item Xref, if there
      *?                     is no XREF found
      *?                  ** Override the item , If dont want to create item
      *?                     XREF and Process the order line with Zero Qty
      *?                  ** If there is no error in XML files Call
      *?                     Validation program to Create/Change Order
      *?
      *? Called Program : WSPOVAL002 - WS - XML File Validation and Order Creation
      *?                  WSCOVAL002 - WS - XML File Validation and Order Change
      *?                  WSPOACK003 - WS - Acknowledgement Process for Order Creation
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
      * SUD01   09/11/18   S.Uthaya     Added Michell Programs
      * SUD02   10/23/18   S.Uthaya     1.Screen Changes
      *                                 2.Added Item Status and Sowing Code in
      *                                    Subfile Part
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
      *?Key : Broker Name:BrokerOrderId:Header Seq no:Error Seq:Broker Material NO
        Dcl-F WSERREXPL2 Disk(*Ext) Keyed Usage(*Output:*Delete);
      *
      *?File: WS - XML Order Header Logical File
      *?Key : Broker Name:BrokerOrderId:Header Seq no
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Delete);
      *
      *?File: WS - Xml Create Order Detail Logical File
      *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
        Dcl-F WSPODTLL0 Disk(*Ext) Keyed Usage(*Update :*Output);
      *
      *?File: WS - XML Change Order Header Logical File
      *?Key : Broker Name:BrokerOrderId:Header Seq no
        Dcl-F WSCOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Delete);
      *
      *?File: WS - Xml Change Order Detail Logical File
      *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
        Dcl-F WSCODTLL0 Disk(*Ext) Keyed Usage(*Update :*Output);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for Error Detail Screen Program
        Dcl-F WSOREXFM04 Workstn Indds(Dspf) Sfile(ORDEXPS04:S04Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSORDEXP02)
        Dcl-Pi WSORDEXP04  Extpgm('WSORDEXP04');
           PBrkId    Char(10);
           PCustPO   Char(10);
           PHSeqNo   Packed(9);
           PDSeqNo   Packed(6);
           PErrSeq   Packed(5);
           POrdNo    Packed(6);
           PPgm      Char(10);
           PSts      Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Order Create Validation Program
        Dcl-Pr WSPOVAL002 ExtPgm;
           PBrkName Char(30);
           PCustPO  Char(10);
           PHSeqNo  Packed(9);
           PFlag    Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Order Change Validation Program
        Dcl-Pr WSCOVAL002 ExtPgm;
           PBrkName Char(30);
           PCustPO  Char(10);
           PHSeqNo  Packed(9);
           PFlag    Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Generate Acknowledgement XML for PO
        Dcl-Pr WSPOACK003 ExtPgm;
           PBrkName Char(30);
           PCustPO  Char(10);
           PHSeqNo  Packed(9);
           PBrkAck  Char(1000000) Options(*Varsize);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Generate Acknowledgement XML for PO
        Dcl-Pr WSCOACK003 ExtPgm;
           PBrkName Char(30);
           PCustPO  Char(10);
           PHSeqNo  Packed(9);
           PBrkAck  Char(1000000) Options(*Varsize);
        End-Pr;
      *
SUD01 *?Procedure Prototype Declaration : Acknowledgement Program
  |     Dcl-Pr WSPOACKMCH Extpgm;
  |        PBrkName Char(30);
  |        PCustPO  Char(10);
  |        PSeqno   Packed(9);
  |        PBrkAck  Char(1000000);
  |        PPrFlag    Char(2);
SUD01   End-Pr;
      *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm('WSSFLMSG');
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
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
      *?Global Variable Declaration :
        Dcl-S ModReq Char(10) Inz;
        Dcl-S FunReq Char(10) Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCount   Zoned(4:0) Inz;
        Dcl-S WkCount1  Zoned(4:0) Inz;
        Dcl-S WkCount2  Zoned(4:0) Inz;
        Dcl-S WkDesc    Char(256)  Inz;
        Dcl-S WkID      Zoned(6)   Inz;
        Dcl-S WkDate    Zoned(6)   Inz;
        Dcl-S WkFlag    Char(1)    Inz;
        Dcl-S WkFlag1   Char(1)    Inz;
        Dcl-S WkXFlag   Char(1)    Inz;
        Dcl-S WkPos     Zoned(2)   Inz;
        Dcl-S WkLclKey  Char(20)   Inz;
        Dcl-S WkTs      Timestamp  Inz;
        Dcl-S ShipDate  Date(*ISO);
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf      Char(10);                   // For CL program
        Dcl-S PMsgId     Char(7);
        Dcl-S POpt       Char(1);
        Dcl-S PFlag      Char(1);                    // For Rpg Program
        Dcl-S PBrkAck    Char(1000000);
        Dcl-S PBrkName   Char(30);
        Dcl-S Flag       Char(1);
        Dcl-S HttpStatus Int(10:0);
SUD01   Dcl-S PPrFlag    Char(2);                    // For RPG program
      *
      *?Constants Indicators Declaration :
        Dcl-S True     Ind Inz(*On);
        Dcl-S False    Ind Inz(*Off);
      *
      *?Flag Indicators Declaration :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlSflMod Ind Inz(*Off);
        Dcl-S FlCtlMod Ind Inz(*Off);
        Dcl-S FlMulSel Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Override        Ind Pos(9);          // Override Function Key
           Process         Ind Pos(10);         // Update Function Key
           Previous        Ind Pos(12);         // Previous Function Key
      *
           S04SflDsp       Ind Pos(41);         // Subfile Display Ind
           S04SflDspCtl    Ind Pos(42);         // Subfile Display Control Ind
           S04SflClr       Ind Pos(43);         // Subfile Clear Ind
           S04SflEnd       Ind Pos(44);         // Subfile End Ind
           S04SflNxtChg    Ind Pos(45);         // Subfile Next Change Ind
      *
           S04SelRi        Ind Pos(51);         // Option Reverse Image Ind
           C04MattoPr      Ind Pos(61);
           C04DatToPr      Ind Pos(62);
           C04QtyToPr      Ind Pos(63);
           S04SflToNd      Ind Pos(64);
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line : Process the Screen until pressed EXIT

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Screen
              Dow ModReq = 'SCREEN';
                 Exsr SN4M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN4M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN4M;

      *?   // Initialization
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
              Exsr SN4I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN4D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN4V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN4P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN4I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN4I;

      *?   // Initialize Indicators
           Dspf.C04QtyToPr = True;              // Ordered Qty Protected
           Dspf.C04MatToPr = True;              // Material Protected
           Dspf.C04DatToPr = True;              // Scheduled Date Protected
           Dspf.S04SflToNd = True;              // Subfile Part Protected
           Dspf.S04SelRi   = False;             // Select Reverse Image OFF
           FlMulSel  = False;                   // Multi Selection Ind OFF
           FlError   = False;                   // Error Flag
           FlCtlMod  = False;                   // Control Part Flag
           FlSflMod  = False;                   // Subfile Part Flag
           S04Sel    = *Zeros;                  // Select Option

      *?   // Select Subfile Records for Create Order
           If PPgm = 'CreateOrd';
              Chain (PBrkID:PCustPO:PHSeqNo:PDSeqNo) WSPODTLL0;
              If C04BRKMAT = *Blanks;
                 C04BRKMAT = PDBRKMAT;
              Endif;
              If C04MatDsc = *Blanks;
                 C04MatDsc = PDVENDSC;
              Endif;
              If C04SCSPDAT = *Blanks;
                 C04SCSPDAT= %Char(PDSCHSHDT:*MDY);
              Endif;
              If C04ORDQTY = *Zeros;
                 C04ORDQTY = PDORDQTY;
              Endif;

      *?   // Select Subfile Records for Change Order
           Elseif PPgm = 'ChangeOrd';
              Chain (PBrkID:PCustPO:PHSeqNo:PDSeqNo) WSCODTLL0;
              If C04BRKMAT = *Blanks;
                 C04BRKMAT = CDBRKMAT;
              Endif;
              If C04MatDsc = *Blanks;
                 C04MatDsc = CDVENDSC;
              Endif;
              If C04SCSPDAT = *Blanks;
                 C04SCSPDAT= %Char(CDSCHSHDT:*MDY);
              Endif;
              If C04ORDQTY = *Zeros;
                 C04ORDQTY = CDORDQTY;
              Endif;
           Endif;

      *?   // Set Indicator
           Exsr SetIndicator;

      *?   // Get Find Value
           If C04Find = *Blanks;
              If PPgm = 'CreateOrd';
                 WkPos = %Scan(' ' : PDVENDSC : 1);             // Get First Blank Pos
                 If WkPos <> *Zeros;
                    C04Find = %Subst(PDVENDSC:1:(WkPos-1));     // Substring First Word
                 Endif;
              Elseif PPgm =  'ChangeOrd';
                 WkPos = %Scan(' ' : CDVENDSC : 1);             // Get First Blank Pos
                 If WkPos <> *Zeros;
                    C04Find = %Subst(CDVENDSC:1:(WkPos-1));     // Substring First Word
                 Endif;
              Endif;
           Endif;

      *?   // Clear Subfile
           Dspf.S04SflClr = True;                      // Clear Ind ON
           Dspf.S04SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write ORDEXPC04;

      *?   // Clear Subfile RRN
           S04Rrn = *Zeros;
           Dspf.S04SflClr    = False;                  // Clear Ind OFF
           Dspf.S04SflDspCtl = True;                   // Display Control Ind ON

      *?   // Build the Subfile based on control fields
           If Dspf.S04SflToNd = False;
              Exsr SN4B;
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN4B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Select the records based on Error messages and build the
      *?        Subfile
      *?
        Begsr SN4B;

      *?   // Initialise Subfile Indicators
           S04Sel  = *Zeros;
           S04Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Select Subfile Records
           Exec Sql Declare A1 Cursor For
SUD02         SELECT IMITEM, IMSIZE, IMSTAT, IMSOWC, IMDES1
SUD02         FROM FMINVT, FMSIZC
              Where FMINVT.IMSIZE=FMSIZC.SCSIZE And
                    FMSIZC.SCCATG = 'PLUG' And  IMSTAT = 'A' And
              ((:C04Find = ' ' And (Soundex(IMITEM)= Soundex(:C04BrkMat)))
              Or (:C04Find <> ' ' And
              (IMITEM Like '%' Concat Trim(:C04find) Concat'%' Or
              IMDES1 Like '%' Concat Trim(:C04Find) Concat'%' Or
              IMDES2 Like '%' Concat Trim(:C04Find) Concat'%' Or
              IMSIZE like '%' Concat Trim(:C04Find) Concat'%')))
              ORDER BY IMLOOK, IMSIZE;

           Exec Sql
           Open A1;
           If SqlCode = -502 ;
              Exec Sql
              Close A1;
              Exec Sql
              Open A1;
           Endif;

SUD02      Exec Sql Fetch A1 Into :S04ITEM, :S04SIZE, :S04ITMSTS,
SUD02                       :S04ITMSWC, :S04DESC ;

      *?   // Read file to Load subfile
           Dow SqlCod = 0 And WkCount < 9999;

      *?      // Increment RRN
              S04Rrn  += 1;
              WkCount += 1;

      *?      // Write Subfile Display Part
              Write ORDEXPS04;

SUD02         Exec Sql Fetch A1 Into :S04ITEM, :S04SIZE, :S04ITMSTS,
SUD02                          :S04ITMSWC, :S04DESC ;

           Enddo;
           EXEC SQL CLOSE A1 ;

      *?   // Subfile End Indicator ON
           Dspf.S04SflEnd = *On;

      *?   // Check RRN
           If S04Rrn <> *Zeros;
              Dspf.S04SflDsp = True;
           Else;

      *?      // No Records Found
              If Dspf.S04SflToNd = False;
                 Dspf.S04SflEnd = True;
                 PMsgId = 'WS00030';
                 Exsr Sendmessage;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN4D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN4D;

      *?   // Write the Footer
           Write ORDEXPF04;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt ORDEXPC04;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 PSts   = '03';

      *?      // F9 Pressed
              When Dspf.Override;
                 If Dspf.S04SflToNd = False;
                    If C04ORDQTY <> *Zeros and C04SCSPDAT <> *Blanks
                       and C04BRKMAT <> *Blanks And
                       C04ITMUSE = *Blanks and C04SIZUSE = *Blanks;
                       WkFlag1  = 'U' ;
                       Exsr Updatedetail;
                       PSts = '12';
                       ModReq = 'EXIT';
                    Else;
                       PMsgId = 'WS00050';
                       Exsr Sendmessage;
                    Endif;
                 Endif;

      *?      // F10 Pressed
              When Dspf.Process;
                 Exsr ValidateSR;
                 If FlError = False;
                    If Dspf.S04SflToNd = False;
                       If C04ITMUSE <> *Blanks and C04SIZUSE <> *Blanks and
                          C04ORDQTY <> *Zeros and C04SCSPDAT <> *Blanks
                          and C04BRKMAT <> *Blanks;
                          Exsr SN4U;
                          PSts = '12';
                          ModReq = 'EXIT';
                       Else;

      *?                  // Check all mandatory fields before proceed
                          If C04ITMUSE = *Blanks And C04SIZUSE = *Blanks;
                             PMsgId = 'WS00037';
                             Exsr Sendmessage;
                          Elseif C04ORDQTY = *Zeros Or C04SCSPDAT = *Blanks
                                 Or C04BRKMAT = *Blanks;
                             PMsgId = 'WS00041';
                             Exsr Sendmessage;
                          Endif;
                       Endif;
                    Elseif Dspf.S04SflToNd = True;
                       If C04ORDQTY = *Zeros Or C04SCSPDAT = *Blanks
                          Or C04BRKMAT = *Blanks;
                          PMsgId = 'WS00038';
                          Exsr Sendmessage;
                       Else;
                          Exsr UpdateDetail;
                          ModReq = 'EXIT';
                          PSts = '12';
                       Endif;
                    Endif;
                 Else;
                    FunReq = 'DISPLAY';
                 Endif;
                 FunReq = 'DISPLAY';

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
      *?                : SN4V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input capable Control and Subfile Fields ,
      *?      : If No errors then Process , else Display error in Screen Pressed
      *?
        Begsr SN4V;

      *?   // Initialise Fields
           Dspf.S04SelRi = False;
           WkCount  = *Zeros;
           FlCtlMod  = False;
           FlSflMod  = False;
           FlError  = False;
           FlMulSel = False;

      *?   // Validate Control Fields
           Exsr ValidateSR;
           If FlError = True;
              FlCtlMod = True;
           Endif;

      *?   // Validate Entered values in Subfile
           If FlError = False;
              If Dspf.S04SflDsp;
                 ReadC ORDEXPS04;
                 Dow Not %Eof;
                    Dspf.S04SelRi = False;

      *?            // Validate Option
                    If FlmulSel <> True ;
                       If S04Sel <> 1 And S04Sel <> 0 ;
                          FlError  = True;
                          Dspf.S04SelRi = True;
                          PMsgId  = 'WS00028';
                          Exsr SendMessage;
                       Else;
                          Dspf.S04SelRi = False;
                          If S04Sel = 0 ;
                             Dspf.S04SelRi = False;
                          Else;
                             FlmulSel = True;
                          EndIf;
                          FlSflMod = True;
                       Endif;
                    Else ;
                       If S04Sel = 0 ;
                          Dspf.S04SelRi = False;
                       Else;
                          FlError  = True;
                          Dspf.S04SelRi = True;
                          PMsgId  = 'WS00028';
                          Exsr SendMessage;
                       EndIf;
                    EndIf;
                    Dspf.S04SflNxtChg = True;
                    Update ORDEXPS04;
                    Dspf.S04SflNxtChg = False;
                    ReadC ORDEXPS04;
                 Enddo;
              Endif;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError ;
              FunReq = 'DISPLAY';
           Elseif FlSflMod;
              FunReq = 'PROCESS';
           Elseif FlCtlMod;
              FunReq = 'DISPLAY';
           Else;
              FunReq = 'INITIAL';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN4P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN4P;

      *?   // Read Changed record and Process based on Option
           WkDesc = *Blanks ;
           If Dspf.S04SflDsp;
              ReadC ORDEXPS04;
              Dow Not %Eof;
                 If S04Sel = 1 ;
                    C04ITMUSE = S04ITEM ;
                    C04SIZUSE = S04SIZE ;
                    WkDesc    = S04DESC ;
                    S04Sel = 0;
                 Endif;
                 Dspf.S04SflNxtChg = True;
                 Update ORDEXPS04;
                 Dspf.S04SflNxtChg = False;
                 ReadC ORDEXPS04;
              Enddo;
           Endif;

           S04Sel = 0;
           FunReq = 'DISPLAY';
           ModReq = 'SCREEN';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ValidateSR Subroutine :
      *?                :-----------------------:
      *
        Begsr ValidateSR;

      *?   // Broker Material Number Should not be Blanks
           FlError = False;
           If C04BRKMAT = *Blanks;
              PMsgId = 'WS00018';
              FlError   = True;
              Exsr SendMessage;
           Endif;

      *?   // Cross reference file validation for Item
           WkXFlag = 'N';
           If C04BRKMAT <> *Blanks and Dspf.S04SflToNd = False;
              WkCount1 = 0;
              Exec Sql
                 Select Count(*) Into :WkCount1
                 From XrefInvt Where XRPVDNM = :C04BRKID And
                 XRPVDTP = 'Customer' And
                 XRFORKEY = :C04BRKMAT;

              If Sqlcode = 0 and WkCount1 = 0;
                 WkXFlag = 'Y';
              Endif;
           Endif;

      *?   // Scheduled Ship Date Should not be Blanks
           If C04SCSPDAT = *Blanks;
              FlError   = True;
              PMsgId = 'WS00020';
              Exsr SendMessage;
           Endif;

      *?   // Order Quantity Should not be Zeros
           If C04ORDQTY = *Zeros;
              PMsgId = 'WS00019';
              FlError   = True;
              Exsr SendMessage;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN4U Subroutine :
      *?                :-----------------:
      *
      *?Logic : Create Xref for Item and Update XMl file
      *?
        Begsr SN4U;

           If WkXFlag = 'Y';

      *?      // Get Broker Number from Broker Default File
              Chain ('1000' : C04BRKID) FBROKDFTL0;
              If %Found;
                 WkID = %Int(%Trim(DFVARVAL));
              Endif;
              WkLclKey = %Trim(C04ITMUSE) + %Trim(C04SIZUSE);
              WkTs     = %Timestamp();

      *?      // Execute Sql Statement to Insert Record in XREFINVT
              Exec Sql
              INSERT INTO XREFINVT (TABLECROSSREFERENCED,
                                    PROVIDEDBYNAME,
                                    PROVIDEDBYTYPE,
                                    PROVIDEDBYID,
                                    FOREIGNKEYVALUE,
                                    DESCRIPTION,
                                    LOCALKEYVALUE,
                                    LOCALITEMNUMBER,
                                    LOCALITEMSIZE,
                                    CREATED_TS,
                                    CREATED_BY)
                          VALUES ('FMINVT',
                                  :C04BRKID,
                                  'Customer',
                                  :WkId,
                                  :C04BRKMAT,
                                  :WkDesc,
                                  :WkLclKey,
                                  :C04ITMUSE,
                                  :C04SIZUSE,
                                  :WkTs,
                                  :User);
           Endif;

      *?   // Execute UpdateDetail
           WkFlag1  = ' ' ;
           Exsr Updatedetail;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : UpdateDetail Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Update Deatil File for the Detail Line
      *?
        Begsr UpdateDetail;

      *?   // Update Record in WSPODTLPF
           If PPgm = 'CreateOrd';
                 PDORDQTY = C04ORDQTY;
                 PDBRKMAT = C04BRKMAT;
                 PDVENDSC = C04MATDSC;
                 WkDate   = %Dec(%Char(%Date(C04SCSPDAT:*MDY/):*MDY0):7:0);
                 PDSCHSHDT= %Date(WkDate:*Mdy);
                 PDFLAG   = WkFlag1;
                 PDUPDDAT = Rundate;
                 PDUPDTIM = Runtime;
                 PDUPDUSR = User;
                 PDUPDJOB = Job;
                 PDUPDPGM = Pgm;
                 Update WSPODTLR %Fields(PDBRKMAT:PDORDQTY:PDVENDSC:
                                      PDSCHSHDT:PDFLAG:PDUPDDAT:PDUPDTIM:
                                      PDUPDUSR:PDUPDJOB:PDUPDPGM);
      *?   // Update Record in WSCODTLPF
           Elseif PPgm = 'ChangeOrd';
                 CDORDQTY = C04ORDQTY;
                 CDBRKMAT = C04BRKMAT;
                 CDVENDSC = C04MATDSC;
                 WkDate   = %Dec(%Char(%Date(C04SCSPDAT:*MDY/):*MDY0):7:0);
                 CDSCHSHDT= %Date(WkDate:*Mdy);
                 CDFLAG   = WkFlag1;
                 CDUPDDAT = Rundate;
                 CDUPDTIM = Runtime;
                 CDUPDUSR = User;
                 CDUPDJOB = Job;
                 CDUPDPGM = Pgm;
                 Update WSCODTLR %Fields(CDBRKMAT:CDORDQTY:CDVENDSC:
                                      CDSCHSHDT:CDFLAG:CDUPDDAT:CDUPDTIM:
                                      CDUPDUSR:CDUPDJOB:CDUPDPGM);
           Endif;

      *?   // Execute UpdateError
           Exsr UpdateError;
           Exsr CreateOrder;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : UpdateError Subroutine :
      *?                :------------------------:
      *
      *?Logic : Update Error File for the Detail Line
      *?
        Begsr UpdateError ;

           Setll (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           ReadE (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           Dow Not %Eof;
              If ERFLAG = 'D' and ERPODSEQ = PDSeqNo;

                 If ERRMSGID <> 'WS00021' and ERRMSGID <> 'WS00024' And
                    ERRMSGID <> 'WS00026';

      *?            // Update Error Flag in Exception File
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
              ReadE (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialise Subroutine
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PGMQ      = Pgm;
           C04Sys    = Job;
           C04Pgm    = Pgm;
           C04BRKID  = PBrkId;
           C04CUSTPO = PCustPo;
           C04SEQNO  = PHSeqNo;
           C04ORDER  = POrdNo;

           Setll (PBrkId:PCustPO:PHSeqNo:PErrSeq) WSERREXPL2;
           ReadE(N) (PBrkId:PCustPO:PHSeqNo:PErrSeq) WSERREXPL2;
           Dow Not %Eof;
              If ERFLAG <> ' ' ;
                 C04ERRMSG = ERRMSG;
              Endif;
              ReadE(N) (PBrkId:PCustPO:PHSeqNo:PErrSeq) WSERREXPL2;
           Enddo;

      *?   // Requested Ship Date
           Chain(N) (PBrkId:PCustPO:PHSeqNo:PErrSeq) WSERREXPL2;
           If %Found;
              C04SHPDATE = %Char(ERRQSPDT:*Mdy);
           Endif;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

      *?   // Close Cursor
           Exec Sql Close A1;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : SetIndicator Subroutine :
      *?                :-------------------------:
      *
      *?Logic : To set inidicator before load the subfile
      *?
        Begsr SetIndicator;

      *?   // For Create Order
           If PPgm = 'CreateOrd';

      *?      // Broker Material Number Should not be Blanks
              If PDBRKMAT = *Blanks;
                 If C04BRKMAT <> *Blanks;
                    Dspf.C04MatToPr = False;
                 Else;
                    Dspf.C04MatToPr = False;
                 Endif;
                 Dspf.S04SflToNd = False;
              Endif;

      *?      // Cross reference file validation for Item
              If PDBRKMAT  <> *Blanks Or C04BRKMAT <> *Blanks;
                 WkCount1 = 0;
                 Exec Sql
                 Select Count(*) Into :WkCount1 From XrefInvt
                 Where XRPVDNM = :PBRKID And
                 XRPVDTP = 'Customer' And
                 XRFORKEY = :C04BRKMAT ;

                 If Sqlcode = 0 and WkCount1 = 0;
                    Dspf.S04SflToNd = False;
                 Endif;
                 WkCount1 = 0;
              Endif;

      *?      // Scheduled Ship Date Should not be Blanks
              If PDSCHSHDT = *Loval;
                 If C04SCSPDAT = *Blanks;
                    Dspf.C04DatToPr = False;
                 Endif;
              Endif;

      *?      // Order Quantity Should not be Zeros
              If PDORDQTY = *Zeros Or ERRMSGID = 'WS00048';
                 If C04ORDQTY = *Zeros;
                    Dspf.C04QtyToPr = False;
                 Endif;
              Endif;

      *?   // For Change Order
           Elseif PPgm = 'ChangeOrd';

      *?      // Broker Material Number Should not be Blanks
              If CDBRKMAT = *Blanks;
                 If C04BRKMAT <> *Blanks;
                    Dspf.C04MatToPr = False;
                 Else;
                    Dspf.C04MatToPr = False;
                 Endif;
                 Dspf.S04SflToNd = False;
              Endif;

      *?      // Cross reference file validation for Item
              If CDBRKMAT  <> *Blanks Or C04BRKMAT <> *Blanks;
                 WkCount1 = 0;
                 Exec Sql
                 Select Count(*) Into :WkCount1 From XrefInvt
                 Where XRPVDNM = :PBRKID And
                 XRPVDTP = 'Customer' And
                 XRFORKEY = :CDBRKMAT ;

                 If Sqlcode = 0 and WkCount1 = 0;
                    Dspf.S04SflToNd = False;
                 Endif;
                 WkCount1 = 0;
              Endif;

      *?      // Scheduled Ship Date Should not be Blanks
              If CDSCHSHDT = *Loval;
                 If C04SCSPDAT = *Blanks;
                    Dspf.C04DatToPr = False;
                 Endif;
              Endif;

      *?      // Order Quantity Should not be less than Zeros
              If CDORDQTY < *Zeros Or ERRMSGID = 'WS00048';
                 If C04ORDQTY = *Zeros;
                    Dspf.C04QtyToPr = False;
                 Endif;
              Endif;
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
           Setll (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           ReadE (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
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
              ReadE (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
           Enddo;

      *?   // Process Order
           If WkFlag = 'Y';

      *?      // Check Error file based on Order type call program
              Exsr UpdateHeader;

      *?      // Create Order
              If PPgm = 'CreateOrd';
                 PBrkName = C04BRKID;
                 PFlag = ' ';
                 WSPOVAL002(PBrkName:PCustPO:PHSeqno:PFlag);
                 If PFlag = 'C';
                    PBrkAck = *Blanks;
SUD01               If PBrkName <> 'Michell';
  |                    WSPOACK003(PBrkName:PCustPO:PHSeqno:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'PO';
  |                    WSPOACKMCH(PBrkName:PCustPO:PHSeqno:PBrkAck
  |                                         :PPrFlag);
SUD01               Endif;
                 Endif;

      *?      // Change Order
              Elseif PPgm = 'ChangeOrd';
                 PBrkName = C04BRKID;
                 PFlag = ' ';
                 WSCOVAL002(PBrkName:PCustPO:PHSeqno:PFlag);
                 If PFlag = 'C';
                    PBrkAck = *Blanks;
SUD01               If PBrkName <> 'Michell';
  |                    WSCOACK003(PBrkName:PCustPO:PHSeqno:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'CO';
  |                    WSPOACKMCH(PBrkName:PCustPO:PHSeqno:PBrkAck
  |                                         :PPrFlag);
SUD01               Endif;
                 Endif;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : UpdateHeader Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Update XML Header files if there are no error in Detail File
      *?
        Begsr UpdateHeader;

      *?   // Update Record in WSPOHDRPF
           If PPgm = 'CreateOrd';
              Chain (C04BrkID:C04Custpo:C04Seqno) WSPOHDRL1;
              PHFLAG   = ' ';
              PHUPDDAT = Rundate;
              PHUPDTIM = Runtime;
              PHUPDUSR = User;
              PHUPDJOB = Job;
              PHUPDPGM = Pgm;

              Update WSPOHDRR %Fields(PHFLAG:PHUPDDAT:PHUPDTIM:
                                      PHUPDUSR:PHUPDJOB:PHUPDPGM);

      *?   // Update Record in WSCOHDRPF
           Elseif PPgm = 'ChangeOrd';
              Chain (C04BrkID:C04Custpo:C04Seqno) WSCOHDRL1;
              CHFLAG   = ' ';
              CHUPDDAT = Rundate;
              CHUPDTIM = Runtime;
              CHUPDUSR = User;
              CHUPDJOB = Job;
              CHUPDPGM = Pgm;

              Update WSCOHDRR %Fields(CHFLAG:CHUPDDAT:CHUPDTIM:
                                      CHUPDUSR:CHUPDJOB:CHUPDPGM);
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
