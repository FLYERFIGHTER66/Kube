      *? Program        : LKORDINV01
      *?
      *? Description    : This Pgm to Show Invoice by Order
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 18 Jun 2019
      //---------------------------------------------------------------------------------
      *? Special Notes  :
      *?
      *? Called Program : WSSFLMSG - WS - Send and clear message from subfile
      *?                  QCMDEXC  - Pgm To Call CL command in Rpg
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
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl)
                DatFmt(*Usa);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Display file for IFS Maintainance Screen Program
        Dcl-F LKORDINVFM Workstn Indds(Dspf) Sfile(ORDINVS01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi LKORDINV01 ExtPgm;
           POrder   Packed(6:0);
           PInvoice Packed(6:0);
        End-Pi;
      *
      *?Procedure Prototype Declaration : CL Pgm for Message Subfile
        Dcl-Pr BIR337CL ExtPgm('BIR337CL');
          PInv#   Packed(15:5);
          PType   Char(2);
        End-Pr;
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
      *?Program Status Data Structure   : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration     :
        Dcl-S ModReq Char(10)    Inz;
        Dcl-S FunReq Char(10)    Inz;
      *
      *?Work Variable Declaration       :
        Dcl-S WkMsgf     Char(10)      Inz;              // Used for Msg File
        Dcl-S WkMsgId    Char(7)       Inz;              // Used for Msg File
        Dcl-S WkMsg      Char(132)     Inz;              // Used for Msg File
        Dcl-S WkCount    Zoned(2:0)    Inz;
        Dcl-S NullInd    Int(5) Dim(7) Inz(0);           // Null Indicator for DS
        Dcl-S NullValue  Like(NullInd) Inz(-1);

      *?CL Command Variable Declaration :
        Dcl-S Command  Char(200)    Inz;
      *
      *?Flag Variable Declaration       :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlMulSel Ind Inz(*Off);
      *
      *?Parameter Variable Declaration  :
        Dcl-S PMsgf   Char(10);
        Dcl-S PMsgId  Char(7);
        Dcl-S POpt    Char(1);
        Dcl-S PType   Char(2);
        Dcl-S PInv#   Packed(15:5);
      *
      *?Program Indicators Declaration  :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration  :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Detail          Ind Pos(11);         // Detail Function Key
      *
           S01SflDsp       Ind Pos(13);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(14);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(15);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(16);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(17);         // Subfile Next Change Ind
      *
           S01OptRi        Ind Pos(18);         // File Type Reverse Image Ind
           S01OPtPc        Ind Pos(19);         // Retention Days Reverse Image Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line : Process the screen until EXIT key pressed

        Begsr Main;

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Process Main Screen
              Dow ModReq = 'SCREEN';
                 Exsr SN1M;
              Enddo;
           Enddo;

      *?   // End Program
           *InLr = True;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1M Subroutine :
      *?                :-----------------:
      *
      *?Logic : Call subroutine based on functional request
      *?
        Begsr SN1M;

      *?   // Initialization
           If FunReq = 'INITIAL';
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
      *?Logic : Clear all screen field values
      *?
        Begsr SN1I;

      *?   // Initialise Fields and indicators
           FlError = False;
           S01Rrn  = *Zeros;
           S01Opt  = *Zeros;
           H01CSRRRN = *Zeros;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;              // Clear Ind ON
           Dspf.S01SflDsp = False;             // Display Ind OFF

      *?   // Write Control Part
           Write ORDINVC01;

      *?   // Clear Subfile
           Dspf.S01SflClr    = False;          // Clear Ind OFF
           Dspf.S01SflDspCtl = True;           // Display Control Ind ON

      *?   // Build Subfile
           Exsr SN1B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Read the file and Build Subfile
      *?
        Begsr SN1B;

      *?   // Initialise Subfile fields and Indicator
           WkCount = *Zeros;
           S01Rrn  = *Zeros;
           S01Opt  = *Zeros;
           H01CSRRRN = S01Rrn;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A1 Cursor For
              Select WHINV#, WHNAME, WHINDT, WH$AMT, WHPOS
                 From FHORDWCR Where WHORD# = :Order#;

      *?   // Open Cursor
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;
           Exec Sql Fetch A1 into :S01INV#, :S01NAME, :S01INDT, :S01AMT,
                                 :S01POS;

      *?   // Load Subfile
           Dow SqlCod = 0 and WkCount < 17;

      *?      // Increment RRN
              S01Rrn  += 1;
              WkCount += 1;
              H01CSRRRN = S01RRN;
              Write ORDINVS01;

      *?      // Move Values
              Exec Sql Fetch A1 into :S01INV#, :S01NAME, :S01INDT,
                        :S01AMT, :S01POS;
           Enddo;

      *?   // Check Sql Code and Set ON Subfile End Indicator
           If SqlCod <> *Zeros Or S01RRN = 0;
              Dspf.S01SflEnd = *On;
           Else;
              Dspf.S01SflEnd = *Off;
           Endif;

      *?   // Check RRN and Show Subfile
           If S01Rrn <> *Zeros;
              Dspf.S01SflDsp = True;
           Else;

      *?      // No Records Found
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

      *?   // Write Footer
           Write ORDINVF01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt ORDINVC01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F11 Pressed
              When Dspf.Detail;
                 If H01CSRRRN <> *Zeros;
                    Chain H01CSRRRN ORDINVS01;
                    PType = 'IN';
                    PInv# = S01INV#;
                    BIR337CL(PInv#:PType);
                 Else;
                    PMsgId = 'WS00087';
                    Exsr Sendmessage;
                 Endif;
                 FunReq = 'DISPLAY';

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
      *?Logic : Validate input capable Subfile Fields , Pressed
      *?      : If No errors then Process , else Display error in Screen Pressed
      *?
        Begsr SN1V;

      *?   // Initialise Fields and Indicators
           Dspf.S01OptRi = False;
           Dspf.S01OptPc = False;
           FlMulSel= False;
           FlError = False;
           WkCount = *Zeros;

      *?   // Validate Entered values in Subfile
           If Dspf.S01SflDsp;
              ReadC ORDINVS01;
              Dow Not %Eof(LKORDINVFM);
                 Dspf.S01OptRi = False;

      *?         // Validate Option
                 If FlMulSel <> True ;
                    If S01Opt <> *Zeros And S01Opt <> 1;
                       FlError  = True;
                       Dspf.S01OptPc = True;
                       Dspf.S01OptRi = True;
                       PMsgId  = 'WS00028';
                       Exsr SendMessage;
                    Else;
                       If S01Opt = 1;
                          FlMulSel = True;
                       Endif;
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
                 Update ORDINVS01;
                 Dspf.S01SflNxtChg = False;
                 ReadC ORDINVS01;
              Enddo;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError;
              FunReq = 'DISPLAY';
           Else;
              FunReq = 'PROCESS';
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
              ReadC ORDINVS01;
              Dow Not %Eof(LKORDINVFM);
                 Select;

      *?            // Edit Link
                    When S01Opt = 1;
                       PInvoice = S01Inv#;
                       ModReq   = 'EXIT';
                 Endsl;
                 Dspf.S01SflNxtChg = True;
                 Update ORDINVS01;
                 Dspf.S01SflNxtChg = False;
                 ReadC ORDINVS01;
              Enddo;
           Endif;
           FunReq = 'INITIAL';

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
           C01Pgm = Job;
           Order# = POrder;
           Exec Sql Select OHSLD1 into :BillTo From FHORDR
              Where OHORD# = :POrder;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';
           Exsr Main;

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
