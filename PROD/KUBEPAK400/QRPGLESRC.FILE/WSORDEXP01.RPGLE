      *? Program        : WSORDEXP01
      *?
      *? Description    : This pgm to Maintain Error Exception File
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 07 Nov 2017
      //--------------------------------------------------------------------
      *? Special Notes  :** List of Exception wrt Broker and Customer PO
      *?                 ** Option 2 to Rectify the errors
      *?                 ** Option 4 to Close the Order
      *?                 ** Option 5 to View the Order
      *?                 ** Option 6 to Reprocess the Order
      *?
      *? Called Program : WSORDEXP02 - WS - Detailed Error Maintenance Screen - Program 2
      *?                  WSPOVAL002 - WS - XML File Validation and Order Creation
      *?                  WSCOVAL002 - WS - XML File Validation and Order Change
      *?                  WSPOACK003 - WS - Acknowledgement Process for Order Creation
      *?                  WSCOACK003 - WS - Acknowledgement Process for Change Order
      *?                  WSPOACKMCH - WS - Acknowledgment Process for Michell PO & CO
      *?                  BIR255CLO  - O/E Open Orders By Order Number Called W/O Order
      *?                  WSSFLMSG   - WS - Send and clear message from subfile
      *?                  QCMDEXC    - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * WJB01   04/03/18   W.J.Behr     Add logic to do Order Inquiry
      * SUD01   08/09/18   S.Uthaya     Removed Hardcoded Values for Control Field
      * SUD02   09/11/18   S.Uthaya     Added Michell Programs
      * SUD03   07/17/19   S.Uthaya     Broker ID Length Changed for McHutchison
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
      *?File: WS - Xml Order Error Exception Logical File
      *?Key : Broker Name : BrokerOrderId : Header Seq no : Error Flag
        Dcl-F WSERREXPL1 Disk(*Ext) Keyed Usage(*Output:*Update:*Delete);
      *
      *?File: WS - Xml Create Order Header Logical File
      *?Key : From Org ID : Customer PO : Header Seq No
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Update) UsrOpn;
      *
      *?File: WS - Xml Create Order Detail Logical File
      *?Key : From Org ID : Customer PO : Header Seq No : Detail Seq No
        Dcl-F WSPODTLL0  Disk(*Ext) Keyed Usage(*Update :*Output) UsrOpn;
      *
      *?File: WS - Xml Change Order Header Logical File
      *?Key : From Org ID : Customer PO : Header Seq No
        Dcl-F WSCOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Update) UsrOpn;
      *
      *?File: WS - Xml Change Order Detail Logical File
      *?Key : From Org ID : Customer PO : Header Seq No : Detail Seq No
        Dcl-F WSCODTLL0  Disk(*Ext) Keyed Usage(*Update :*Output) UsrOpn;
      *
      *?File: Display file for Exception Maintenance Main Screen
        Dcl-F WSOREXFM01 Workstn Indds(Dspf) Sfile(ORDEXPS01:S01Rrn);
      *
SUD01 *?File: WS - Broker Defaults and Control Logical File
  |   *?Key : Broker Number:Broker Variable
SUD01   Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : No Entry Parameters
        Dcl-Pi WSORDEXP01 End-Pi;
      *
      *?Procedure Prototype Declaration : Pgm to Load All Detailed Errors
        Dcl-Pr WSORDEXP02 Extpgm;
SUD03     PBrkID  Char(15);
          PCustPO Char(10);
          PSeqno  Packed(9);
          PPgm    Char(10);
          PSts    Char(2);
        End-Pr;
      *
      *?Procedure Prototype Declaration : PO Validation Program
        Dcl-Pr WSPOVAL002 Extpgm;
          PBrkName Char(30);
          PCustPO  Char(10);
          PSeqno   Packed(9);
          PFlag    Like(PFlag);
        End-Pr;
      *
      *?Procedure Prototype Declaration : PO Acknowledgement Program
        Dcl-Pr WSPOACK003 Extpgm;
          PBrkName Char(30);
          PCustPO  Char(10);
          PSeqno   Packed(9);
          PBrkAck  Char(1000000);
        End-Pr;
      *
      *?Procedure Prototype Declaration : PO Validation Program
        Dcl-Pr WSCOVAL002 Extpgm;
          PBrkName Char(30);
          PCustPO  Char(10);
          PSeqno   Packed(9);
          PFlag    Like(PFlag);
        End-Pr;
      *
      *?Procedure Prototype Declaration : PO Acknowledgement Program
        Dcl-Pr WSCOACK003 Extpgm;
          PBrkName Char(30);
          PCustPO  Char(10);
          PSeqno   Packed(9);
          PBrkAck  Char(1000000);
        End-Pr;
      *
SUD02 *?Procedure Prototype Declaration : Acknowledgement Program
  |     Dcl-Pr WSPOACKMCH Extpgm;
  |        PBrkName Char(30);
  |        PCustPO  Char(10);
  |        PSeqno   Packed(9);
  |        PBrkAck  Char(1000000);
  |        PPrFlag  Char(2);
SUD02   End-Pr;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Cmd Char(200)    Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Procedure Prototype Declaration : Pgm to Call Order Inquiry BIR255CLO
        Dcl-Pr DisplayOrder Extpgm('BIR255CLO');   //  WJB01
           OrderNumber Packed(6:0) Const;
        End-Pr;
      *
      *?Program Status Data Structure : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S ModReq Char(10)    Inz;
        Dcl-S FunReq Char(10)    Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCount  Zoned(2:0) Inz;
        Dcl-S WkBrk    Char(20)   Inz;
        Dcl-S WkPos    Char(10)   Inz;
        Dcl-S WkBrkId  Char(10)   Inz;
        Dcl-S WkFlag   Char(1)    Inz;
        Dcl-S WkPrFlag Char(1)    Inz;
        Dcl-S WkTs     Timestamp  Inz;

      *?CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;
      *
      *?Flag Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlCtlMod Ind Inz(*Off);
        Dcl-S FlSflMod Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S HttpStatus Int(10:0);               // For RPG program
        Dcl-S PSeqno     Packed(9);
        Dcl-S PBrkAck    Char(1000000);
        Dcl-S PBrkName   Char(30);
        Dcl-S PMsgf      Char(10);                // For CL program
        Dcl-S PBrkId     Char(15);
        Dcl-S PCustPO    Char(10);
        Dcl-S PPgm       Char(10);
        Dcl-S PMsgId     Char(7);
        Dcl-S POpt       Char(1);
        Dcl-S PFlag      Char(1);
        Dcl-S PSts       Char(2);
        Dcl-S Flag       Char(1);
SUD02   Dcl-S PPrFlag    Char(2);                 // For RPG program
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Refresh         Ind Pos(5);          // Refresh Function Key
      *
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
      *
           S01OptRi        Ind Pos(50);         // Option Reverse Image Ind
           S01OptPc        Ind Pos(51);         // Position Cursor Ind
           C01BrkRi        Ind Pos(52);         // Broker Control Field Reverse Image Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line : Process the screen until EXIT key pressed

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Main Screen
              Dow ModReq = 'SCREEN';
                 Exsr SN1M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;
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
      *?                : SN1I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN1I;

      *?   // Initialise Reverse Image indicator
           Dspf.S01OptRi = False;
           Dspf.C01BrkRi = False;
           FlError  = False;
           FlCtlMod = False;
           FlSflMod = False;
           S01Opt   = *Zeros;
           S01Rrn   = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write ORDEXPC01;

      *?   // Clear Subfile
           Dspf.S01SflClr    = False;          // Clear Ind OFF
           Dspf.S01SflDspCtl = True;           // Display Control Ind ON

      *?   // Check Control Field and Load Subfile
           If C01BRKID = *Blanks and C01POSTO = *Blanks;
              Setll *Loval WSERREXPL1;
              Read WSERREXPL1;
              WkBrk = *Blanks;
              WkPos = *Blanks;
              Dspf.S01SflEnd = %Eof;
           Else;
              Setll (C01BRKID:C01POSTO) WSERREXPL1;
              ReadE C01BRKID WSERREXPL1;
              WkBrk = C01BRKID;
              WkPos = C01POSTO;
              Dspf.S01SflEnd = %Eof;
           Endif;

      *?   // Build Subfile
           If Not %Eof;
              Exsr SN1B;
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
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Read the file and Build Subfile based on size
      *?
        Begsr SN1B;

      *?   // Initialise Subfile fields and Indicator
           Dspf.S01OptRi = False;
           Dspf.S01OptPc = True;
           Dspf.C01BrkRi = False;
           S01Opt   = *Zeros;
           S01Rrn   = *Zeros;
           WkCount  = *Zeros;
           WkBrkId  = *Blanks;

      *?   // Load Subfile
           Dow Not %Eof And WkCount < 9999;

      *?      // Move Values into Subfile fields
              If ERBRKORID <> WkBrkID And ERFlag <> 'X' And ERFlag <> 'I'
                 And ERFlag <> *Blanks;
                 S01BRKID  = ERBRKNAM;
                 S01CUSTPO = ERBRKORID;
                 WKBrkID   = ERBRKORID;
                 S01SEQNO  = ERPOSEQ;
                 S01ORDNO  = ERORDNO;
                 S01SLDTO  = ERBRKSLD;
                 If ERCRTPGM = 'WSPOVAL002';
                    S01TYPE = 'CreateOrd';
                 Elseif ERCRTPGM = 'WSCOVAL002';
                    S01TYPE = 'ChangeOrd';
                 Endif;
                 WkTs =  %Timestamp((%Date(ERCRTDAT:*MDY)) +
                                  (%Time(ERCRTTIM)));
                 S01TIMEST = %Char(WkTs);

      *?         // Increment RRN
                 S01Rrn  += 1;
                 WkCount += 1;

      *?         // Write Subfile Display Part
                 Write ORDEXPS01;
              Endif;

              If C01BRKID = *Blanks;
                 Read WSERREXPL1;
              Else;
                 ReadE C01BRKID WSERREXPL1;
              Endif;

           Enddo;

      *?   // Subfile End Indicator ON
           Dspf.S01SflEnd = %Eof;

      *?   // Check RRN
           If S01Rrn <> *Zeros;
              Dspf.S01SflDsp = True;
           Else;

      *?      // No Records Found
              Dspf.S01SflEnd = True;
              PMsgId = 'WS00030';
              Exsr Sendmessage;
           Endif;

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
           Write ORDEXPF01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt ORDEXPC01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F5 Pressed
              When Dspf.Refresh;
                 C01PosTo = *Blanks;
                 C01BrkId = *Blanks;
                 ModReq   = 'SCREEN';
                 FunReq   = 'RELOAD';

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
      *?Logic : Validate input capable Control and Subfile Fields , Pressed
      *?      : If No errors then Process , else Display error in Screen Pressed
      *?
        Begsr SN1V;

      *?   // Initialise Fields and Indicators
           Dspf.C01BrkRi = False;
           Dspf.S01OptRi = False;
           Dspf.S01OptPc = False;
           FlCtlMod = False;
           FlSflMod = False;
           FlError  = False;
           WkCount  = *Zeros;

      *?   // Check Broker Control Fields
           If WkBrk <> C01BrkId;
SUD01         Chain ('1000' : C01BrkId) FbrokdftL0;
SUD01         If Not %Found And C01BrkId <> *Blanks;
                 Dspf.C01BrkRi = True;
                 Dspf.S01OptPc = False;
                 FlError = True;
                 PMsgId  = 'WS00029';
                 Exsr SendMessage;
              Else;
                 WkBrk = C01BrkId;
                 FlCtlMod = True;
                 FlError  = False;
                 Exsr ClearMessage;
              Endif;
           Endif;

      *?   // Check postion to Customer Field
           If WkPos <> C01PosTo and C01PosTo <> *Blanks;
              WkPos = C01PosTo;
              WkBrk = C01BrkId;
              If C01BrkId <> *Blanks;
SUD01            Chain ('1000' : C01BrkId) FbrokdftL0;
SUD01            If %Found;
                    FlCtlMod = True;
                    FlError  = False;
                    Exsr ClearMessage;
                 Else;
                    Dspf.C01BrkRi = True;
                    Dspf.S01OptPc = False;
                    FlError = True;
                    PMsgId  = 'WS00039';
                    Exsr SendMessage;
                 Endif;
              Elseif C01BrkId = *Blanks;
                 Dspf.C01BrkRi = True;
                 Dspf.S01OptPc = False;
                 FlError = True;
                 PMsgId  = 'WS00039';
                 Exsr SendMessage;
              Endif;
           Endif;

      *?   // Validate Entered values in Subfile
           If FlCtlMod <> True;
              If Dspf.S01SflDsp;
                 ReadC ORDEXPS01;
                 Dow Not %Eof(WSOREXFM01);
                    Dspf.S01OptRi = False;

      *?            // Validate Option
                    If S01Opt <> *Zeros And S01Opt <> 2 And S01Opt <> 4
                       And S01Opt <> 5 And S01Opt <> 6;
                       FlError  = True;
                       FlSflMod = False;
                       Dspf.S01OptPc = True;
                       Dspf.S01OptRi = True;
                       PMsgId  = 'WS00028';
                       Exsr SendMessage;
                    Else;
                       FlSflMod = True;
                    Endif;
                    Dspf.S01SflNxtChg = True;
                    Update ORDEXPS01;
                    Dspf.S01SflNxtChg = False;
                    ReadC ORDEXPS01;
                 Enddo;
              Endif;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
           Else;
              If FlCtlMod;
                 FunReq = 'INITIAL';
              Elseif FlSflMod;
                 FunReq = 'PROCESS';
              Else;
                 FunReq = 'RELOAD';
              Endif;
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
              ReadC ORDEXPS01;
              Dow Not %Eof(WSOREXFM01);
                 Select;

      *?            // Call to Error Detail Screen
                    When S01Opt = 2;
                       Exsr EditSR;

      *?            // Close the Order
                    When S01Opt = 4;
                       WkFlag = 'X';
                       Exsr ErrorSR;

      *?            // Display Open Order            //    WJB01
                    When S01Opt = 5;                 //      |
                       DisplayOrder(S01ORDNO);       //    WJB01

      *?            // Reprocess the Order
                    When S01Opt = 6;
                       WkFlag   = ' ';
                       WkPrFLAG = 'N';
                       Exsr ReprocessSR;

                 Endsl;
                 Dspf.S01SflNxtChg = True;
                 Update ORDEXPS01;
                 Dspf.S01SflNxtChg = False;
                 ReadC ORDEXPS01;
              Enddo;
              FunReq = 'INITIAL';

           Endif;

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
           PGMQ   = Pgm;
           C01Sys = Pgm;
           C01Pgm = Job;

      *?   // By Default Show All Records
           C01BRKID = *Blanks;
           C01POSTO = *Blanks;

      *?   // Add HTTP Library in Library List
           Monitor;
              Command = 'ADDLIBLE LIB(LIBHTTP) POSITION(*Last)';
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : EditSR Subroutine :
      *?                :-------------------:
      *
      *?Logic : Call Error Detail screen with respect to Customer PO#
      *?
        Begsr EditSR;

      *?   // Call Program to Show all error in screen
           WSORDEXP02(S01BRKID:S01CUSTPO:S01SEQNO:S01TYPE:PSts);
           If PSts = '12';
              S01Opt = *Zeros;
              ModReq = 'SCREEN';
              FunReq = 'INITIAL';
           Elseif PSts = '03';
              ModReq = 'EXIT';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : ErrorSR Subroutine :
      *?                :--------------------:
      *
      *?Logic : Update flag in Error message File and call
      *?        subroutine to Update XML files
      *?
        Begsr ErrorSR;

      *?   // Read Exception File and update the Flag
           Setll (S01BRKID:S01CUSTPO) WSERREXPL1;
           ReadE (S01BRKID:S01CUSTPO) WSERREXPL1;
           Dow Not %Eof;

      *?      // Audit Stamp
              ERFLAG   = WkFLAG;
              ERUPDDAT = Rundate;
              ERUPDTIM = Runtime;
              ERUPDUSR = User;
              ERUPDJOB = Job;
              ERUPDPGM = Pgm;
              Update WSERREXPR  %Fields(ERFLAG:ERUPDDAT:ERUPDTIM:
                                       ERUPDUSR:ERUPDJOB:ERUPDPGM);
              ReadE (S01BRKID:S01CUSTPO) WSERREXPL1;
           Enddo;

      *?   // Update in XML Header/Detail Files
           Exsr UpdateSR;
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : UpdateSR Subroutine :
      *?                :---------------------:
      *
      *?Logic : Update the flag in Create/Change XML Header/Detail File
      *?
        Begsr UpdateSR;

      *?   // Order Create XML Files
           If S01Type = 'CreateOrd';

      *?      // Open Files
              Open WSPOHDRL1;
              Open WSPODTLL0;

      *?      // Read XML Header File and Update the flag
              Chain (S01BRKID:S01CustPO:S01SEQNO) WSPOHDRL1;
              If %Found;
                 PHFLAG   = WkFlag;
                 PHUPDDAT = Rundate;
                 PHUPDTIM = Runtime;
                 PHUPDUSR = User;
                 PHUPDJOB = Job;
                 PHUPDPGM = Pgm;
                 Update WSPOHDRR %Fields(PHFLAG:PHUPDDAT:PHUPDTIM
                                :PHUPDUSR:PHUPDJOB:PHUPDPGM);
              Endif;

      *?      // Read XML Detail File and Update the flag
              Setll (S01BRKID:S01CustPO:S01SEQNO) WSPODTLL0;
              ReadE (S01BRKID:S01CustPO:S01SEQNO) WSPODTLL0;
              Dow Not %Eof;
                 PDFLAG   = PHFLAG;
                 PDUPDDAT = Rundate;
                 PDUPDTIM = Runtime;
                 PDUPDUSR = User;
                 PDUPDJOB = Job;
                 PDUPDPGM = Pgm;
                 Update WSPODTLR %Fields(PDFLAG:PDUPDDAT:PDUPDTIM
                                :PDUPDUSR:PDUPDJOB:PDUPDPGM);
                 ReadE (S01BRKID:S01CustPO:S01SEQNO) WSPODTLL0;
              Enddo;

      *?      // Close Files
              Close WSPOHDRL1;
              Close WSPODTLL0;

      *?   // Order Change XML Files
           Elseif S01Type = 'ChangeOrd';

      *?      // Open Files
              Open WSCOHDRL1;
              Open WSCODTLL0;

      *?      // Read XML Header File and Update the flag
              Chain (S01BRKID:S01CustPO:S01SEQNO) WSCOHDRL1;
              If %Found;
                 CHFLAG   = WkFlag;
                 CHUPDDAT = Rundate;
                 CHUPDTIM = Runtime;
                 CHUPDUSR = User;
                 CHUPDJOB = Job;
                 CHUPDPGM = Pgm;
                 Update WSCOHDRR %Fields(CHFLAG:CHUPDDAT:CHUPDTIM
                                :CHUPDUSR:CHUPDJOB:CHUPDPGM);
              Endif;

      *?      // Read XML Detail File and Update the flag
              Setll (S01BRKID:S01CustPO:S01SEQNO) WSCODTLL0;
              ReadE (S01BRKID:S01CustPO:S01SEQNO) WSCODTLL0;
              Dow Not %Eof;
                 CDFLAG   = CHFLAG;
                 CDUPDDAT = Rundate;
                 CDUPDTIM = Runtime;
                 CDUPDUSR = User;
                 CDUPDJOB = Job;
                 CDUPDPGM = Pgm;
                 Update WSCODTLR %Fields(CDFLAG:CDUPDDAT:CDUPDTIM
                                :CDUPDUSR:CDUPDJOB:CDUPDPGM);
                 ReadE (S01BRKID:S01CustPO:S01SEQNO) WSCODTLL0;
              Enddo;

      *?      // Close Files
              Close WSCOHDRL1;
              Close WSCODTLL0;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : ReprocessSR Subroutine :
      *?                :------------------------:
      *
      *?Logic : If all the Errors are rectified on the Exception screen,
      *?        allow them to call Validation program
      *?      : If Validation success POST Acknowledgment
      *?
        Begsr ReprocessSR;

      *?   // Check Error Exception File
           Setll (S01BrkID:S01CustPO:S01SeqNo) WSERREXPL1;
           ReadE (S01BrkID:S01CustPO:S01SeqNo) WSERREXPL1;
           Dow Not %Eof;

      *?      // Check Error Flag in Exception File
              If ERFLAG = 'D';
                 If ERRMSGID = 'WS00021' Or ERRMSGID = 'WS00024';
                    WkPrFlag   = 'Y';
                 Else;
                    WkPrFlag = 'N';
                    Leave;
                 Endif;
              Elseif ERFLAG = 'I';
                 If ERRMSGID = 'WS00025' Or ERRMSGID = 'WS00026';
                    WkPrFlag   = 'Y';
                 Endif;
              Elseif ERFLAG = 'H';
                 WkPrFlag = 'N';
                 Leave;
              Endif;
              ReadE (S01BrkID:S01CustPO:S01SeqNo) WSERREXPL1;
           Enddo;

      *?   // Check Flag status and Process
           If WkPrFlag = 'Y';

      *?      // Update Error file ,XML Files and then Create Order
              WkFlag = ' ';
              Exsr ErrorSR;
              Exsr CreateOrder;
           Elseif WkPrFlag = 'N';
               FlError  = True;
               FlSflMod = True;
               Dspf.S01OptRi = True;
               PMsgId  = 'WS00038';
               Exsr SendMessage;
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : CreateOrder Subroutine :
      *?                :------------------------:
      *
      *?Logic : If there are no Errors then call validation program
      *?      : For successful validation create order and send
      *?        Acknowledgement
      *?
        Begsr CreateOrder;

      *?   // Create Order Process
           If S01Type = 'CreateOrd';

      *?      // Open Files
              Open WSPOHDRL1;
              Open WSPODTLL0;

              Chain(N) (S01BRKID:S01CustPO:S01SEQNO) WSPOHDRL1;
              If %Found;
                 If PHFLAG = ' ';
                    PBrkName = S01BrkId;
                    PFlag = ' ';
                    WSPOVAL002(PBrkName:S01CustPO:S01Seqno:PFlag);
                    If PFlag = 'C';

      *?               // Process Flag is 'C', Call XML Generate Program
                       PBrkAck = *Blanks;
SUD02                  If PBrkName <> 'Michell';
  |                       WSPOACK003(PBrkName:S01CustPO:S01Seqno:PBrkAck);
  |                    Else;
  |                       PPrFlag = 'PO';
  |                       WSPOACKMCH(PBrkName:S01CustPO:S01Seqno:PBrkAck
  |                                           :PPrFlag);
SUD02                  Endif;
                    Endif;
                 Endif;
              Endif;

      *?      // Close Files
              Close WSPOHDRL1;
              Close WSPODTLL0;

      *?   // Change Order Process
           Elseif S01Type = 'ChangeOrd';

      *?      // Open Files
              Open WSCOHDRL1;
              Open WSCODTLL0;

              Chain(N) (S01BRKID:S01CustPO:S01SEQNO) WSCOHDRL1;
              If %Found;
                 If CHFLAG = ' ';
                    PBrkName = S01BrkId;
                    PFlag = ' ';
                    WSCOVAL002(PBrkName:S01CustPO:S01Seqno:PFlag);
                    If PFlag = 'C';

      *?               // Process Flag is 'C', Call XML Generate Program
                       PBrkAck = *Blanks;
SUD02                  If PBrkName <> 'Michell';
  |                       WSCOACK003(PBrkName:S01CustPO:S01Seqno:PBrkAck);
  |                    Else;
  |                       PPrFlag = 'CO';
  |                       WSPOACKMCH(PBrkName:S01CustPO:S01Seqno:PBrkAck
  |                                           :PPrFlag);
SUD02                  Endif;
                    Endif;
                 Endif;
              Endif;

      *?      // Close Files
              Close WSCOHDRL1;
              Close WSCODTLL0;

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
           PMsgf  = 'WSMSGF';
           POpt   = 'C';
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
           PMsgf  = 'WSMSGF';
           POpt   = 'I';
           WSSFLMSG(PMsgf:PMsgId:POpt);

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
