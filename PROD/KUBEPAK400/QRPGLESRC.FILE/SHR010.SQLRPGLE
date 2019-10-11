      *? Program        : SHR010
      *?
      *? Description    : This Program to Maintain ShipTo Master File
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 14 Nov 2018
      *---------------------------------------------------------------------
      *? Special Notes  : Called from BIR100 - To Select Shipto Address(OE Menu)
      *?                              ARR010 - To Maintain ShipTo Address(MF Menu)
      *?
      *? Called Program : WSSFLMSG - WS - Send and Clear message from subfile
      *?                  WSRTVMSG - WS - Retrieve message from Message file
      *?                  LKTAXJ   - Tax Juris Lookup
      //-------------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   -----------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   -----------------------------------------
      *?Changes in 2019
      * SUD01   03/26/19   S.Uthaya     1. Change in Display file layout
      *                                 2. Bug fixing in Tax Jurisdiction
      *                                    Validation
      * SUD02   06/04/19   S.Uthaya     Change Flow in Screen
      * SUD03   06/06/19   S.Uthaya     1. Do not allow change of Customer Number
      *                                 2. Change Sort order to be State/Zip
      *                                 3. Add filter capability with Single field
      * WJB     06/18/19   W.J.Behr     Add Logic for edit if SEQ# = 0
      * SUD04   06/19/19   S.Uthaya     Fixed Looping issue while calling from BIR100
      * SUD05   10/03/19   S.Uthaya     Change Sort Order to be State/City
      *                                 Address 4 Hided from SHR010R01 Screen
      //--------------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl);
      //--------------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Ship-to Master Logical File
      *?Key : Customer Number : Seq# Number
        Dcl-F FSHIPTOL0  Disk(*Ext) Keyed Usage(*Delete:*Output);
      *
SUD01 *?File: M/F Tax Jurisdiction Master File
  |   *?Key : Tax Jurisdiction
SUD01   Dcl-F FMTAXF     Disk(*Ext) Keyed Usage(*Input);
      *
SUD04 *?File: M/F Customer Master File
  |   *?Key : Customer Number
SUD04   Dcl-F FMCUST     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file to Select Credit Card Screen
        Dcl-F SHR010FM   Workstn    Indds(Dspf) Sfile(SHR010S01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi SHR010 ExtPgm;
           ShipToDs1 LikeDs(ShipToDs);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Call ShipTo Directions Program
        Dcl-Pr DIR010 ExtPgm;
           PCust Packed(6);
           PSeq# Packed(3);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Call Customer Maintenance Program
        Dcl-Pr ARR010CLC ExtPgm;
           PCust Packed(6);
        End-Pr;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;                         // CL Program
           PMsgf  Char(10);                             // Msg File
           PMsgId Char(7);                              // Msg Id
           POpt   Char(1);                              // Msg Opt
        End-Pr;
      *
      *?Procedure Prototype Declaration : Call CL program to Retreive MSG
        Dcl-Pr WSRTVMSG Extpgm;                         // CL Program
           WkMsgId  Char(7);                            // Msg Id
           WkMsgF   Char(10);                           // Msg File
           WKMsg    Char(132);                          // Msg
           WkDta    Char(10);                           // Msg Data
        End-Pr;
      *
      *?Procedure Prototype Declaration : To get Tax Juris For Customer
        Dcl-Pr LKTAXJ Extpgm;
          PTaxJu    Char(3);
          PTaxNm    Char(30);
        End-Pr;
      *
      *?Program Status Data Structure   : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?ShipTo Data Structure           : *Entry Ds
        Dcl-Ds ShipToDs Qualified;
           Number Packed(6:0);
           Seq#   Packed(3:0);
           Name   Char(30);
           CName  Char(30);
           Adr1   Char(30);
           Adr2   Char(30);
           Adr3   Char(30);
           Adr4   Char(30);
           City   Char(18);
           State  Char(2);
           Zip    Char(9);
           Phone  Packed(10:0);
           TaxE   Char(1);
           TaxJ   Char(3);
           Pgm    Char(10);
        End-Ds;
      *
      *?Global Variable Declaration     :
        Dcl-S ModReq    Char(10)    Inz;
        Dcl-S FunReq    Char(10)    Inz;
      *
      *?Work Variable Declaration       :
SUD05   Dcl-S WkFRrn    Like(S01RRN);
        Dcl-S WkSeq#    Packed(3)   Inz;
        Dcl-S WkCust    Packed(6)   Inz;
        Dcl-S WkCount   Zoned(2:0)  Inz;
        Dcl-S WkMsg     Char(132)   Inz;              // Used for Msg File
        Dcl-S WkMsgf    Char(10)    Inz;              // Used for Msg File
        Dcl-S WkDta     Char(10)    Inz;              // Used for Msg File
        Dcl-S WkFilter  Char(20)    Inz;
        Dcl-S WkMsgId   Char(7)     Inz;              // Used for Msg File
        Dcl-S WkFlag    Char(1)     Inz;
        Dcl-S WkTaxJ    Char(3)     Inz;
      *
      *?Flag Variable Declaration       :
        Dcl-S FlError   Ind   Inz(*Off);
        Dcl-S FlMulSel  Ind   Inz(*Off);
        Dcl-S FlCtlMod  Ind   Inz(*Off);
        Dcl-S FlSflMod  Ind   Inz(*Off);
SUD01   Dcl-S FlDisplay Ind   Inz(*Off);
      *
      *?Parameter Variable Declaration  :
        Dcl-S PSeq#     Packed(3);
        Dcl-S PMsgf     Char(10);                     // For CL program
        Dcl-S PTaxNm    Char(30);
        Dcl-S PMsgId    Char(7);
        Dcl-S POpt      Char(1);
      *
      *?Program Indicators Declaration  :
        Dcl-S True      Ind Inz(*On);
        Dcl-S False     Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration  :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           AddShipTo       Ind Pos(6);          // Add ShipTo Key
           Direction       Ind Pos(8);          // Direction Key from Add Screen
           Directions      Ind Pos(9);          // Directions Maintenance Key
           Previous        Ind Pos(12);         // Previous Function Key
      *
           S01SflDrop      Ind Pos(11);         // Subfile Drop Function Key
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           S01OptRi        Ind Pos(50);         // Option Reverse Image Ind
           S01OptPc        Ind Pos(51);         // Position Cursor Ind
      *
           R01NameRi       Ind Pos(28);         // Name Reverse Image Ind
           R01CNameRi      Ind Pos(29);         // Contact Name Reverse Image In
           R01Adr1Ri       Ind Pos(30);         // Address 1 Reverse Image Ind
           R01Adr2Ri       Ind Pos(31);         // Address 2 Reverse Image Ind
           R01Adr3Ri       Ind Pos(32);         // Address 3 Reverse Image Ind
           R01CityRi       Ind Pos(34);         // City Reverse Image Ind
           R01StStRi       Ind Pos(35);         // State Reverse Image Ind
           R01ZipRi        Ind Pos(36);         // Zip Reverse Image Ind
           R01PhoneRi      Ind Pos(37);         // Phone Reverse Image Ind
           R01TaxERi       Ind Pos(38);         // Tax Exempt Reverse Image Ind
           R01TaxJRi       Ind Pos(39);         // Tax Juris Image Ind
           R01Protect      Ind Pos(40);         // Screen Fields Protect Ind
      *
           C01CustRi       Ind Pos(41);         // Screen Fields Protect Ind
           C01DelRi        Ind Pos(44);         // Option Delete Reverse Image I
           C01DelNd        Ind Pos(45);         // Option Delete Non Display Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line : Process the screen until Cancel key pressed

SUD01   Begsr Main;

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Main Screen
              Dow ModReq = 'SCREEN1';
                 Exsr SN1M;
              Enddo;

      *?      // Add/Update/View Screen
              Dow ModReq = 'SCREEN2';
                 Exsr SN2M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;
           Return;

SUD01   Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN1M;

      *?   // Initialization
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
              Exsr SN1I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN1D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN1V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN1P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN2M;

      *?   // Initialization
           If FunReq = 'INITIAL' Or FunReq = 'RELOAD';
              Exsr SN2I;
           Endif;

      *?   // Display
           If FunReq = 'DISPLAY';
              Exsr SN2D;
           Endif;

      *?   // Validate
           If FunReq = 'VALIDATE';
              Exsr SN2V;
           Endif;

      *?   // Process
           If FunReq = 'PROCESS';
              Exsr SN2P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN1I;

      *?   // Initialise Reverse Image & Non Display indicator
           FlError = False;
           S01Opt  = *Zeros;
           S01Rrn  = *Zeros;
           WkFlag  = *Blanks;
           H01CSRRRN = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write SHR010C01;

      *?   // Clear Subfile
           Dspf.S01SflClr    = False;          // Clear Ind OFF
           Dspf.S01SflDspCtl = True;           // Display Control Ind ON

      *?   // Build Subfile
           If C01Cust = *Zeros;
              C01Cust = ShipToDs.Number;
           Endif;
           Exsr SN1B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Read the file and Build Subfile based on Customer
      *?
        Begsr SN1B;

      *?   // Initialise Subfile fields and Indicator
           S01Opt  = *Zeros;
           S01Rrn  = *Zeros;
           WkCount = *Zeros;
           H01CSRRRN = S01Rrn;
           Dspf.C01DelNd = True;

      *?   // Execute Sql to get Subfile Records based on Customer
           Exec Sql Declare A1 Cursor For
              Select STSEQ#,STNAME,STADR1,STADR2,STADR3,STADR4,
                     STCITY,STSTST,STZIP,STPHON,STTXST,STTXJU,STCNAM
              From  FSHIPTOL0
              Where ((STCUST = :C01Cust Or :C01Cust = 0)  And
SUD03         (:C01Filter = ' ')) Or
  |           (:C01Filter <> ' ' And (STCUST = :C01Cust Or :C01Cust = 0)  And
  |           (STNAME Like '%' Concat TRIM(:C01FILTER) Concat'%'
  |           OR STADR1 Like '%' Concat TRIM(:C01FILTER) Concat'%'
  |           OR STADR2 Like '%' Concat TRIM(:C01FILTER) Concat'%'
  |           OR STADR3 Like '%' Concat TRIM(:C01FILTER) Concat'%'
  |           OR STADR4 Like '%' Concat TRIM(:C01FILTER) Concat'%'
  |           OR STCITY Like '%' Concat TRIM(:C01FILTER) Concat'%'
  |           OR STSTST Like '%' Concat TRIM(:C01FILTER) Concat'%'
  |           OR STZIP  Like '%' Concat TRIM(:C01FILTER) Concat'%'
SUD03         OR Char(STPHON) Like '%' Concat TRIM(:C01FILTER) Concat'%' ))
SUD05         Order by STSTST , STCITY;

           WkCust = C01Cust;
SUD03      WkFilter = C01Filter;

           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           EndIf;

           Exec Sql Fetch A1 Into :S01SEQ#,:S01NAME,:S01ADR1,:S01ADR2,:S01ADR3,
SUD05                     :S01ADR4,:H01City,:H01Stat,:H01Zip,:S01PHON,:S01TAXE,
                          :S01TAXJ, :S01CNAM;

           Dow SqlCod = 0 And WkCount < 9999;

      *?      // Increment RRN
              S01Rrn  += 1;
              WkCount += 1;
SUD05         If WkCount = 1;
  |              WkFRrn = S01Rrn;
SUD05         Endif;
              H01CSRRRN = S01RRN;
SUD01         S01CTSTZIP = %Trim(H01City) + ' ' + %Trim(H01Stat) + ' ' + H01Zip;

      *?      // Write Subfile Display Part
              Write SHR010S01;
              Exec Sql Fetch A1 Into :S01SEQ#,:S01NAME,:S01ADR1,:S01ADR2,
SUD05                 :S01ADR3, :S01ADR4,:H01City,:H01Stat,:H01Zip,:S01PHON,
                           :S01TAXE,:S01TAXJ,:S01CNAM;
           Enddo;
           Exec Sql Close A1;

      *?   // Move Control Fields
           If C01Cust <> *Zeros;
              C01Name = *Blanks;
              Exec Sql
                 Select CMNAME into :C01Name From FMCUST Where
                 CMCUST = :C01Cust;
           Else;
              C01Name = *Blanks;
           Endif;

      *?   // Subfile End Indicator ON
           Dspf.S01SflEnd = *On;

      *?   // Check RRN
           If S01Rrn <> *Zeros;
              S01Rrn = WKFRrn;                      // Position to First Record
              Dspf.S01SflDsp = True;
              FunReq = 'DISPLAY';
           Else;

      *?      // No Records Found
              Dspf.S01SflEnd = True;
              PMsgId = 'WS00030';
              Exsr Sendmessage;
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN1D;

      *?   // Write the Footer
           Write SHR010F01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt SHR010C01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F6 Pressed
              When Dspf.AddShipTo;
                 ModReq = 'SCREEN2';
                 FunReq = 'INITIAL';
                 WkFlag = 'A';

      *?      // F11 Pressed
              When Dspf.S01SflDrop;
                 FunReq = 'DISPLAY';

      *?      // F9 Pressed
              When Dspf.Directions;
                 If H01CSRRRN <> *Zeros;
                    Chain H01CSRRRN SHR010S01;
                    DIR010(C01Cust:S01Seq#);
                    ModReq = 'SCREEN1';
                    FunReq = 'INITIAL';
                 Else;
                    PMsgId = 'WS00087';
                    Exsr Sendmessage;
                    FunReq = 'DISPLAY';
                 Endif;

      *?      // Other Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input capable Subfile Fields ,
      *?      : If No errors then Process , Else Display error in Screen Pressed
      *?
        Begsr SN1V;

      *?   // Initialise Fields and Indicators
           FlError = False;
           FlMulSel= False;
           WkCount = *Zeros;

      *?   // Validate Non Display Field
           If Dspf.C01DelNd = False;
              Exsr DeleteSr;
              FlCtlMod = True;
              If C01Del = 'Y';
                 PMsgId  = 'WS00075';
                 Exsr SendMessage;
              Endif;
              FlSflMod = False;
SUD03         If ShipToDs.Pgm = 'ARR010';
  |              Dspf.C01CustRi= False;
SUD03         Endif;
           Endif;

      *?   // Validate Control field in Subfile
SUD03      If ShipToDs.Pgm <> 'BIR100' Or ShipToDs.Pgm <> 'BIR100E';
              If C01Cust <> *Zeros and WkCust <> C01Cust and
                                       Dspf.C01DelNd = True;
                 WkCust = C01Cust;
                 Exec Sql Select CMNAME into C01Name From FMCUST
                      Where CMCUST = :C01Cust;
                 If C01Name <> *Blanks;
                    WkCust = C01Cust;
                    Dspf.C01CustRi = False;
                    FlCtlMod = True;
                 Else;
                    Dspf.C01CustRi = True;
                    PMsgId  = 'WS00015';
                    FlError = True;
                    Exsr SendMessage;
                 Endif;
              Else;
                 If Dspf.C01DelNd = True;
                    FlCtlMod = False;
                 Endif;
                 WkCust = C01Cust;
              Endif;
SUD03      Endif;

      *?   // Validate Control filter in Subfile
           If WkFilter <> C01Filter;
              FlCtlMod = True;
              WkFilter = C01Filter;
           Endif;

      *?   // Validate Entered values in Subfile
           If Dspf.S01SflDsp and Dspf.C01DelNd = True;
              ReadC SHR010S01;
              Dow Not %Eof(SHR010FM);
                 Dspf.S01OptRi = False;

      *?         // Validate Option
                 If FlMulSel <> True ;
                    If S01Opt <> *Zeros And S01Opt <> 1 and S01Opt <> 2
                       And S01Opt <> 4 and S01Opt <> 5;
                       Dspf.S01OptPc = True;
                       Dspf.S01OptRi = True;
                       PMsgId  = 'WS00028';
                       FlError = True;
                       Exsr SendMessage;
                    Else;
                       If S01Opt = 1;
                          FlMulSel = True;
                       Endif;
                       FlSflMod = True;
                    Endif;
                 Elseif FlMulSel = True;
                    If S01Opt <> *Zeros;
                       FlError  = True;
                       Dspf.S01OptRi = True;
                       PMsgId  = 'WS00036';
                       Exsr SendMessage;
                    Endif;
                 Endif;

                 Dspf.S01SflNxtChg = True;
                 Update SHR010S01;
                 Dspf.S01SflNxtChg = False;
                 ReadC SHR010S01;
              Enddo;
           Endif;

           If FlSflMod and C01Cust = *Zeros;
              FlSflMod = False;
              FlError  = True;
              Dspf.C01CustRi = True;
              PMsgId  = 'WS00074';
              FlError = True;
              Exsr SendMessage;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
           Elseif FlCtlMod;
              FunReq = 'INITIAL';
           Elseif FlSflMod;
              FunReq = 'PROCESS';
           Else;
              FunReq = 'INITIAL';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN1P;

      *?   // Read Changed record and Process based on Option
           If Dspf.S01SflDsp;
              ReadC SHR010S01;
              Dow Not %Eof(SHR010FM);
                 Select;

      *?            // Select
                    When S01Opt = 1;
                       ShipToDs.Number= C01CUST;
                       ShipToDs.Seq#  = S01SEQ#;
                       ShipToDs.Name  = S01NAME;
                       ShipToDs.CName = S01CNAM;
                       ShipToDs.Adr1  = S01ADR1;
                       ShipToDs.Adr2  = S01ADR2;
                       ShipToDs.Adr3  = S01ADR3;
                       ShipToDs.Adr4  = S01ADR4;
                       ShipToDs.City  = H01CITY;
                       ShipToDs.State = H01STAT;
                       ShipToDs.Zip   = H01ZIP;
                       ShipToDs.Phone = S01PHON;
                       ShipToDs.TaxE  = S01TAXE;
                       ShipToDs.TaxJ  = S01TAXJ;

      *           ?    // Move Values from Pgm Ds to Return Ds
                       Eval-Corr ShipToDs1 = ShipToDs;
                       ModReq = 'EXIT';

      *?            // Edit
                    When S01Opt = 2;
                       If S01Seq# <> *Zeros;
                          WkFlag = 'U';
                          WkSeq# = S01Seq#;
                          ModReq = 'SCREEN2';
                          FunReq = 'INITIAL';
SUD01                     Exsr SN2M;
                       Else;
                          If ShiptoDs.Pgm = 'BIR100'or ShiptoDs.Pgm = 'BIR100E';
                             ARR010CLC(C01CUST);
                          Else;
                             Return;
                          Endif;
                       Endif;

      *?            // Delete
                    When S01Opt = 4;
                       Dspf.C01DelNd = False;
                       Dspf.C01DelRi = True;
                       Dspf.C01CustRi= True;
                       C01Del = 'Y';

      *?            // Inquiry
                    When S01Opt = 5;
                       WkFlag = 'V';
                       WkSeq# = S01Seq#;
                       ModReq = 'SCREEN2';
                       FunReq = 'INITIAL';
                       Exsr SN2M;
                 Endsl;
                 Dspf.S01SflNxtChg = True;
                 Update SHR010S01;
                 Dspf.S01SflNxtChg = False;
                 ReadC SHR010S01;
              Enddo;

      *?      // Check Non Display Field
              If Dspf.C01DelNd = False;
                 FunReq = 'DISPLAY';
              Else;
                 FunReq = 'INITIAL';
                 FlSflMod = False;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen parameters and field values
      *?
        Begsr SN2I;

      *?   // Clear Record Format
           Clear SHR010R01;

      *?   // Initialise Indicators
           FlError = False;
           Exsr Setindicator;
           R01Cust   = C01Cust;
           R01CusNam = C01Name;
           If WkFlag = 'V';
              Chain(N) (R01Cust:WkSeq#) FSHIPTOL0;
              Exsr MoveValues;
           Endif;
           If WkFlag = 'U';
              Chain (R01Cust:WkSeq#) FSHIPTOL0;
              Exsr MoveValues;
           Endif;
           If WkFlag = 'A';
              Setgt R01Cust FSHIPTOL0;
              ReadPE(N) R01Cust FSHIPTOL0;
              If Not %Eof;
                 R01Seq# = STSEQ# + 1;
              Else;
                 R01Seq# = 1;
              Endif;
              Exec Sql
                 Select CMTXJU,CMTXST into :R01TaxJ, :R01TaxE From FMCUST
                 Where CMCUST = :R01Cust;
              R01Name = C01Name;
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Display Record format based on function keys
      *?
        Begsr SN2D;

      *?   // Write the Subfile Control Part
           Exfmt SHR010R01;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
SUD02            If ShiptoDs.Pgm <> 'BIR100E';
  |                 ModReq = 'EXIT';
  |              Else;
  |                 ModReq = 'EXIT';
  |                 Exsr Main;
SUD02            Endif;

      *?      // F8 Pressed
              When Dspf.Direction;
                 If R01CUST <> *Zeros;
                    DIR010(R01Cust:R01Seq#);
                 Else;
                    PMsgId = 'WS00041';
                    Exsr Sendmessage;
                 Endif;
                 ModReq = 'SCREEN2';
                 FunReq = 'DISPLAY';

      *?      // F12 Pressed
              When Dspf.Previous;
SUD02            If ShiptoDs.Pgm <> 'BIR100E';
  |                 ModReq = 'SCREEN1';
  |                 FunReq = 'INITIAL';
  |              Else;
  |                 ModReq = 'EXIT';
  |                 Exsr Main;
SUD02            Endif;

      *?      // Other Pressed
              Other;
                 If WkFlag <> 'V';
                    FunReq = 'VALIDATE';
                 Else;
                    FunReq = 'DISPLAY';
                 Endif;
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate input capable Fields ,
      *?      : If No errors then Process , Else Display error in Screen Pressed
      *?
        Begsr SN2V;

      *?   // Initialise Fields and Indicators
           FlDisplay= False;
           FlError = False;
           Exsr SetIndicator;

      *?   // Validate Name
           If R01Name = *Blanks;
              FlError = True;
              Dspf.R01NameRi = True;
              WkMsgID = 'WS00010';
              Exsr ErrMessage;
           Endif;

      *?   // Validate Address
           If R01Adr1 = *Blanks and R01Adr2 = *Blanks and R01Adr3 = *Blanks
              and FlError = False;
              FlError = True;
              Dspf.R01Adr1Ri = True;
              Dspf.R01Adr2Ri = True;
              Dspf.R01Adr3Ri = True;
              WkMsgID = 'WS00011';
              Exsr ErrMessage;
           Endif;

      *?   // Validate City
           If R01City = *Blanks and FlError = False;
              FlError = True;
              Dspf.R01CityRi = True;
              WkMsgID = 'WS00013';
              Exsr ErrMessage;
           Endif;

      *?   // Validate State
           If R01StSt = *Blanks and FlError = False;
              FlError = True;
              Dspf.R01StStRi = True;
              WkMsgID = 'WS00012';
              Exsr ErrMessage;
           Endif;

      *?   // Validate Zip
           If R01Zip = *Blanks and FlError = False;
              FlError = True;
              Dspf.R01ZipRi = True;
              WkMsgID = 'WS00047';
              Exsr ErrMessage;
           Endif;

      *?   // Validate Tax Exempt
           If R01TaxE = *Blanks and FlError = False;
              FlError = True;
              Dspf.R01TaxERi = True;
              WkMsgID = 'WS00085';
              Exsr ErrMessage;
           Else;
              If R01TaxE <> 'N' and R01TaxE <> 'Y' and FlError = False;
                 FlError = True;
                 Dspf.R01TaxERi = True;
                 WkMsgID = 'WS00085';
                 Exsr ErrMessage;
              Endif;
           Endif;

      *?   // Validate Tax Juris
           If R01TaxJ = *Blanks and FlError = False;
              FlError = True;
              Dspf.R01TaxJRi = True;
              WkMsgID = 'WS00086';
              Exsr ErrMessage;

SUD01      Elseif %Subst(R01TaxJ:1:1) = '?' Or %Subst(R01TaxJ:1:1) = '/';

      *?      // Get Tax Juris from Lookup
              PTaxNm = *Blanks;
              ErrMsg = *Blanks;
SUD01         LKTAXJ(WkTaxJ:PTaxNm);
  |           If WkTaxj = *Blanks;
  |              FlError = True;
  |              Dspf.R01TaxJRi = True;
  |              WkMsgID = 'WS00086';
  |              Exsr ErrMessage;
  |           Else;
  |              R01TaxJ = WkTaxJ;
  |              FlDisplay = True;
SUD01         Endif;

           Elseif R01TaxJ <> '?' Or R01TaxJ <> '/' and R01TaxJ <> *Blanks;
SUD01         Chain R01TaxJ FMTAXF;
  |           If Not %Found;
  |              FlError = True;
  |              Dspf.R01TaxJRi = True;
  |              WkMsgID = 'WS00096';
  |              Exsr ErrMessage;
SUD01         Endif;
           Endif;

      *?   // Check Error Flag and Execute Process
SUD01      If FlError or FlDisplay;
              FunReq = 'DISPLAY';
              Exsr SN2M;
           Else;
              FunReq = 'PROCESS';
              Exsr SN2P;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN2P;

      *?   // Write/Update Record
           Exsr WriteUpdRec;
SUD02      If ShipToDs.Pgm <> 'BIR100E';
  |           ModReq = 'SCREEN1';
  |           FunReq = 'INITIAL';
  |        Else;
  |           ShipToDs.Number= R01CUST;
  |           ShipToDs.Seq#  = R01SEQ#;
  |           ShipToDs.Name  = R01NAME;
  |           ShipToDs.CName = R01CNAM;
  |           ShipToDs.Adr1  = R01ADR1;
  |           ShipToDs.Adr2  = R01ADR2;
  |           ShipToDs.Adr3  = R01ADR3;
  |           ShipToDs.Adr4  = *Blanks;
  |           ShipToDs.City  = R01CITY;
  |           ShipToDs.State = R01STST;
  |           ShipToDs.Zip   = R01ZIP;
  |           ShipToDs.Phone = R01PHON;
  |           ShipToDs.TaxE  = R01TAXE;
  |           ShipToDs.TaxJ  = R01TAXJ;
  |
  |   *?      // Move Values from Pgm Ds to Return Ds
  |           Eval-Corr ShipToDs1 = ShipToDs;
  |           ModReq = 'EXIT';
SUD02      Endif;
           Exsr Main;

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
           PGMQ = Pgm;

      *?   // Move Values from Entry Datastructure to Pgm Datastructure
           Eval-Corr ShipToDs = ShipToDs1;

      *?   // Check Record Exits in ShipTo File
           If ShipToDs.Pgm = 'ARR010';
              Exsr ShipToSr;
           Endif;

      *?   // Move Control Fields
           C01Cust = ShipToDs.Number;

      *?   // Protect Customer Field
SUD02      If ShipToDs.Pgm = 'BIR100' Or ShipToDs.Pgm = 'BIR100E';
SUD03         Dspf.C01CustRi= True;
SUD03         Dspf.S01OptPc = True;
           Endif;

      *?   // Open Main Screen
SUD02      If ShipToDs.Pgm = 'ARR010' Or ShipToDs.Pgm = 'BIR100';
              ModReq = 'SCREEN1';
              FunReq = 'INITIAL';
SUD02         Exsr Main;
  |        Else;
  |           Exec Sql
  |              Select CMNAME into :C01Name From FMCUST Where
  |              CMCUST = :C01Cust;
  |           If ShipToDs.Seq# <> *Zeros;
  |              WkFlag = 'U';
  |              WkSeq# = ShipToDs.Seq#;
  |              ModReq = 'SCREEN2';
  |              FunReq = 'INITIAL';
  |              Exsr SN2M;
  |           Else;
  |              If ShiptoDs.Pgm = 'BIR100' Or ShiptoDs.Pgm = 'BIR100E';
SUD02               ARR010CLC(C01CUST);                 //WJB 6/18/19  Add logic for BIR100E
SUD04               Chain C01Cust FMCust;
  |                 If %Found;
  |                    ShipToDs.Number= CMCUST;
  |                    ShipToDs.Seq#  = 0;
  |                    ShipToDs.Name  = CMNAME;
  |                    ShipToDs.CName = CMCNME;
  |                    ShipToDs.Adr1  = CMADD2;
  |                    ShipToDs.Adr2  = CMADD3;
  |                    ShipToDs.Adr3  = CMADD4;
  |                    ShipToDs.Adr4  = *Blanks;
  |                    ShipToDs.City  = CMCITY;
  |                    ShipToDs.State = CMSTST;
  |                    ShipToDs.Zip   = CMZIP;
  |                    ShipToDs.Phone = CMPHON;
  |                    ShipToDs.TaxE  = CMTXST;
  |                    ShipToDs.TaxJ  = CMTXJU;
  |
  |   *?               // Move Values from Pgm Ds to Return Ds
  |                    Eval-Corr ShipToDs1 = ShipToDs;
  |                    ModReq = 'EXIT';
SUD04               Endif;
SUD02            Endif;
  |              ModReq = 'EXIT';
  |              Exsr Main;
  |           Endif;
SUD02      Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : DeleteSR Subroutine :
      *?                :---------------------:
      *
      *?Logic : Delete Record from Credit card token file
      *?
        Begsr DeleteSr;

      *?   // Initialize inidcators
           If C01Del = 'Y';
              Chain (C01Cust:S01Seq#) FSHIPTOL0;
              If %Found;
                 Delete FSHIPTOR;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : SetIndicator Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Set Indicator for all fields
      *?
        Begsr SetIndicator;

      *?   // Initialize inidcators
           If WkFlag = 'A' Or WkFlag = 'U';
              If WkFlag = 'A';
                 Heading = 'Add Ship To Address';
              Else;
                 Heading = 'Edit Ship To Address';
              Endif;
              Dspf.R01NameRi = False;
              Dspf.R01CNameRi= False;
              Dspf.R01Adr1Ri = False;
              Dspf.R01Adr2Ri = False;
              Dspf.R01Adr3Ri = False;
              Dspf.R01CityRi = False;
              Dspf.R01StStRi = False;
              Dspf.R01ZipRi  = False;
              Dspf.R01PhoneRi= False;
              Dspf.R01TaxERi = False;
              Dspf.R01TaxJRi = False;
              Dspf.R01Protect = False;
           Elseif WkFlag = 'V';
              Heading = 'View Ship To Address';
              Dspf.R01Protect = True;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : WriteUpdRec Subroutine :
      *?                :------------------------:
      *
      *?Logic : Move Values into File Fields
      *?
        Begsr WriteUpdRec;

      *?   // Move Values based on Flag
           If WkFlag = 'A';
              STCust = C01Cust;
              STSeq# = R01Seq#;
              STName = R01Name;
              STCNam = R01CNam;
              STAdr1 = R01Adr1;
              STAdr2 = R01Adr2;
              STAdr3 = R01Adr3;
              STAdr4 = *Blanks;
              STCity = R01City;
              STStSt = R01StSt;
              STZip  = R01Zip;
              STPhon = R01Phon;
              STTxst = R01TaxE;
              STTxju = R01TaxJ;
              STCRTDAT = RunDate;
              STCRTTIM = RunTime;
              STCRTUSR = User;
              STCRTJOB = Job;
              STCRTPGM = Pgm;
              Write FSHIPTOR;
              ModReq = 'SCREEN1';
              FunReq = 'INITIAL';
           Elseif WkFlag = 'U';
              Chain (STCust:STSeq#) FSHIPTOL0;
              If %Found;
                 STName = R01Name;
                 STCNam = R01CNam;
                 STAdr1 = R01Adr1;
                 STAdr2 = R01Adr2;
                 STAdr3 = R01Adr3;
                 STAdr4 = *Blanks;
                 STCity = R01City;
                 STStSt = R01StSt;
                 STZip  = R01Zip;
                 STPhon = R01Phon;
                 STTxst = R01TaxE;
                 STTxju = R01TaxJ;
                 STUPDDAT = RunDate;
                 STUPDTIM = RunTime;
                 STUPDUSR = User;
                 STUPDJOB = Job;
                 STUPDPGM = Pgm;
                 Update FSHIPTOR %Fields(STName:StCNam:STAdr1:STAdr2:STAdr3:
                                StAdr4:STCity:STStst:STZip:StPhon:STTxst:STTxju:
                                STUPDDAT:STUPDTIM:STUPDUSR:STUPDJOB:STUPDPGM);
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : MoveValues  Subroutine :
      *?                :------------------------:
      *
      *?Logic : Move Values into Screen Fields
      *?
        Begsr MoveValues;

      *?   // Move File fields to Screen Fields
           R01Seq# = STSeq#;
           R01Name = STName;
           R01CNam = STCNam;
           R01Adr1 = STAdr1;
           R01Adr2 = STAdr2;
           R01Adr3 = STAdr3;
           R01City = STCity;
           R01Stst = STStst;
           R01Zip  = STZip;
           R01Phon = STPhon;
           R01TaxE = STTxst;
           R01TaxJ = STTxju;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : ShipToSr Subroutine :
      *?                :---------------------:
      *
      *?Logic : Check ShipTo Number in ShipTo Master File
      *?
        Begsr ShipToSr;

      *?   // Check Record existance , Based on that Write/Update
           Chain (ShipToDs.Number:ShipToDs.Seq#) FSHIPTOL0;
           If Not %Found;
              STCust = ShipToDs.Number;
              STSeq# = ShipToDs.Seq#;
              STName = ShipToDs.Name;
              STCNam = ShipToDs.CName;
              STAdr1 = ShipToDs.Adr1;
              STAdr2 = ShipToDs.Adr2;
              STAdr3 = ShipToDs.Adr3;
              STAdr4 = ShipToDs.Adr4;
              STCity = ShipToDs.City;
              STStst = ShipToDs.State;
              STZip  = ShipToDs.Zip;
              STPhon = ShipToDs.Phone;
              STTxst = ShipToDs.TaxE;
              STTxju = ShipToDs.TaxJ;
              STCRTDAT = RunDate;
              STCRTTIM = RunTime;
              STCRTUSR = User;
              STCRTJOB = Job;
              STCRTPGM = Pgm;
              Write FSHIPTOR;
           Else;
              STName = ShipToDs.Name;
              STCNam = ShipToDs.CName;
              STAdr1 = ShipToDs.Adr1;
              STAdr2 = ShipToDs.Adr2;
              STAdr3 = ShipToDs.Adr3;
              STAdr4 = ShipToDs.Adr4;
              STCity = ShipToDs.City;
              STStst = ShipToDs.State;
              STZip  = ShipToDs.Zip;
              STPhon = ShipToDs.Phone;
              STTxst = ShipToDs.TaxE;
              STTxju = ShipToDs.TaxJ;
              STUPDDAT = RunDate;
              STUPDTIM = RunTime;
              STUPDUSR = User;
              STUPDJOB = Job;
              STUPDPGM = Pgm;
              Update FSHIPTOR %Fields(StName:StCNam:StAdr1:StAdr2:StAdr3:
                            StAdr4:StCity:StStst:StZip:StPhon:StTxst:StTxju:
                            StUPDDAT:StUPDTIM:StUPDUSR:StUPDJOB:StUPDPGM);
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : ClearMessage Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Call CL program to Clear Message
      *?
        Begsr ClearMessage;

      *?   // Clear Message from Message Subfile Control Part
           PMsgf = 'WSMSGF';
           POpt  = 'C';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : SendMessage Subroutine :
      *?                :------------------------:
      *
      *?Logic : Call CL program to Send Message
      *?
        Begsr SendMessage;

      *?   // Show Message on Message Subfile Control Part
           PMsgf = 'WSMSGF';
           POpt  = 'I';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ErrMessage Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Call CL program to Show Message
      *?
        Begsr ErrMessage;

      *?   // Show Message On Screen from Message File
           Monitor;
             WkMsgf = 'WSMSGF';
             WkDta  = *Blanks;
             WSRTVMSG(WkMsgID:WkMsgf:WKMSG:WkDta);
           On-Error;
           EndMon;
           ErrMsg = WkMsg;
           ModReq  = 'SCREEN2';
           FunReq  = 'DISPLAY';

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
