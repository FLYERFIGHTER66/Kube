      *? Program        : WSPOINQ01
      *?
      *? Description    : This pgm to PO Inquiry Main Screen
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 08 Jan 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Based on Cursor Part & Press F4-Inquiry Call Inquiry Subfile
      *?                  ** If Cursor in Control, Call Header Inquiry Subfile
      *?                  ** If Cursor in Subfile, Call Detail Inquiry Subfile
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   04/01/19   S.Uthaya     Changes in Inquiry Logic
      * SUD02   06/20/19   S.Uthaya     Added F9=B2B Log File Inquiry
      * SUD03   06/24/19   S.Uthaya     Added F4=Vendor Number Inquiry
      * SUD04   08/01/19   S.Uthaya     Bug Fixing in Main Screen Validation Part
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes)
           DatFmt(*Usa);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Order Detail File
      *?Key : Order Number : Order Seq#
        Dcl-F FIORDR     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Display file for PO Detail Inquiry Screen
        Dcl-F WSPOINQFM  Workstn Indds(Dspf) Sfile(POINQS01:S01Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPOINQ01;
        End-Pi;
      *
      *?Procedure Prototype Declaration : Header Inquiry Program
        Dcl-Pr WSPOHINQ02 ExtPgm;
           PBroker    Char(30);
           PVendorPo  Char(10);
           POrder     Packed(6);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Detail Inquiry Program
        Dcl-Pr WSPODINQ03 ExtPgm;
           PBroker    Char(30);
           PVendorPo  Char(10);
           POrder     Packed(6);
SUD01      PBrkLin    Char(10);
SUD01      PKpItem    Char(5);
        End-Pr;
      *
SUD03 *?Procedure Prototype Declaration : Vendor Number Inquiry Program
  |     Dcl-Pr WSVENINQ01 ExtPgm;
           PVendor Packed(6:0);
           PName   Char(10);
SUD03   End-Pr;
      *
SUD02 *?Procedure Prototype Declaration : B2B Log Inquiry Program
  |     Dcl-Pr WSB2BINQ01 ExtPgm;
  |        PVendorPo  Char(10);
  |     End-Pr;
SUD02 *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG  ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
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
      *?Program Status Data Structure :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Data Structure PO for SQL :
        Dcl-Ds WSPOHDRDS ExtName('WSPOHDRL2');
        End-Ds;
      *
      *?Data Structure CO for SQL :
        Dcl-Ds WSCOHDRDS ExtName('WSCOHDRL2');
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S ModReq    Char(10)  Inz;
        Dcl-S FunReq    Char(10)  Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCount   Packed(4) Inz;
        Dcl-S WkHSeq#   Packed(9) Inz;
        Dcl-S WkDSeq#   Packed(6) Inz;
        Dcl-S WkVend    Char(6)   Inz;
        Dcl-S WkBrkId   Packed(6) Inz;
        Dcl-S WkOrder   Packed(6) Inz;
        Dcl-S WkBroker  Char(30)  Inz;
        Dcl-S WkPoNo    Char(10)  Inz;
        Dcl-S WkFlag    Char(1)   Inz;
        Dcl-S WkMsgf    Char(10)  Inz;              // Used for Msg File
        Dcl-S WkMsgId   Char(7)   Inz;              // Used for Msg File
        Dcl-S WkMsg     Char(132) Inz;              // Used for Msg File
        Dcl-S WkDta     Char(10)  Inz;              // Used for Msg File
      *
      *?Flag Indicators Declaration :
        Dcl-S FlError   Ind Inz(*Off);
        Dcl-S FlCtl     Ind Inz(*Off);
        Dcl-S FlSfl     Ind Inz(*Off);
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf      Char(10);              // For CL Program
        Dcl-S PMsgId     Char(7);
        Dcl-S POpt       Char(1);
        Dcl-S PErr       Char(1);
      *
      *?Display File Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(03);         // Exit Function Key
           Inquiry         Ind Pos(04);         // Inquiry Function Key
           Refresh         Ind Pos(05);         // Refresh Function Key
           VendPOInq       Ind Pos(09);         // VendorPO Inquiry Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           R01VendRi       Ind Pos(18);         // Vendor Reverse Image
           R01OrderRi      Ind Pos(19);         // Order# Reverse Image
      *
           S01SflDsp       Ind Pos(21);         // Subfile Display Ind
           S01SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S01SflClr       Ind Pos(23);         // Subfile Clear Ind
           S01SflEnd       Ind Pos(24);         // Subfile End Ind
           S01SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
           S01SflDrop      Ind Pos(11);         // Subfile Drop Ind
      *
           S01BrkCanRi     Ind Pos(31);         // Broker Cancelled Line
           C01VendRi       Ind Pos(41);         // Vendor Number Reverse Image Ind
           C01OrNoRi       Ind Pos(42);         // Order Number Reverse Image Ind
           C01PoNoRi       Ind Pos(43);         // Vendor PO Reverse Image Ind
        End-Ds;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Process until Exit
           Dou ModReq = 'EXIT';

      *?      // Main Screen
              Dow ModReq = 'SCREEN1';
                 Exsr SN1M;
              Enddo;

      *?      // Subfile Screen
              Dow ModReq = 'SCREEN2';
                 Exsr SN2M;
              Enddo;

           Enddo;

      *?   // Close Cursor
           Exec Sql Close A1;
           Exec Sql Close A2;
           Exec Sql Close C1;
           Exec Sql Close C2;

      *?   // End Program
           *InLr = *On;
           Return;

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
      *?Logic : Clear all screen Parameters
      *?
        Begsr SN1I;

      *?   // Clear Record
           Clear POINQR01;
           Dspf.R01VendRi = False;
           Dspf.R01OrderRi= False;

      *?   // Display
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Check the Function Key Pressed
      *?
        Begsr SN1D;

      *?   // Write the Subfile Control Part
           Exfmt POINQR01;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F4 Pressed
              When Dspf.Inquiry;
                 WSVENINQ01(R01Vend:R01Name);
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
      *?Logic : Validate Input Capable Fields
      *?
        Begsr SN1V;

      *?   // Clear Flag
           FlError = False;
           WkVend  = *Zeros;
           WkOrder = *Zeros;
           WkPoNo  = *Blanks;

      *?   // Check Input capable fields
           If R01Vend = *Zeros and R01PONO = *Blanks and R01ORNO = *Zeros;
              Dspf.R01VendRi  = True;
              Dspf.R01OrderRi = True;
              FlError = True;
              WkMsgID = 'WS00091';
              Exsr ErrMessage;
           Endif;

      *?   // Get Order Number for the Po
           If (R01Vend = *Zeros Or R01PONO = *Blanks) and R01ORNO = *Zeros
              and FlError = False;
              Dspf.R01VendRi = True;
              FlError = True;
              WkMsgID = 'WS00092';
              Exsr ErrMessage;
           Endif;

      *?   // Get Order Number for the Vendor and PO
           If R01Vend <> *Zeros and R01PONO <> *Blanks and FlError = False;
SUD01         WkBrkId = R01Vend;
              WkPoNo  = R01PoNo;
              WkVend = %Char(R01Vend);
              Exsr GetOrder;
SUD01         If WkOrder <> *Zeros;
  |              R01ORNO = WkOrder;
  |              R01Vend = WkBrkId;
  |              R01PoNo = WkPoNo ;
  |           Else;
  |              WkBrkId = *Zeros;
  |              WkPoNo  = *Blanks;
SUD01         Endif;
           Endif;

      *?   // Get Vendor name for the Vendor
           Exec Sql
              Select CMNAME Into :R01NAME From FmCust
              Where CmCust = :R01Vend;

      *?   // Get PO for the Order
           If R01OrNo <> *Zeros and FlError = False;
              WkOrder = R01OrNo;
              Exsr GetPO;
SUD01         If WkPoNo <> *Blanks;
  |              R01Vend = WkBrkId;
  |              R01PONO = WkPoNo;
  |           Else;
  |              WkBrkId = *Zeros;
  |              WkPoNo  = *Blanks;
  |              WkOrder = *Zeros;
SUD01         Endif;
              WkVend = %Char(R01Vend);
           Endif;

      *?   // Check PO and Vendor
           If R01Vend = *Zeros and R01PONO = *Blanks and FlError = False;
              Dspf.R01VendRi  = True;
              Dspf.R01OrderRi = True;
              FlError = True;
              WkMsgID = 'WS00094';
              Exsr ErrMessage;
           Endif;

      *?   // Process Based on Flag
           If FlError = True;
              FunReq  = 'DISPLAY';
           Else;
SUD01         If WkVend <> *Zeros and WkPoNo <> *Blanks and
  |              WkOrder <> *Zeros;
  |              FunReq = 'INITIAL';
  |              ModReq = 'SCREEN2';
  |              C01ORNO = WkOrder;
  |              C01Vend = WkBrkId;
  |              C01PoNo = WkPoNo;
  |           Else;
  |              Dspf.R01VendRi = True;
  |              Dspf.R01OrderRi= True;
  |              FlError = True;
  |              WkMsgID = 'WS00093';
  |              Exsr ErrMessage;
SUD01         Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN2I;

      *?   // Clear Subfile
           Dspf.S01SflClr = True;                      // Clear Ind ON
           Dspf.S01SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write POINQC01;

      *?   // Clear Rrn
           S01Rrn = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S01SflClr    = False;                  // Clear Ind OFF
           Dspf.S01SflDspCtl = True;                   // Display Control Ind ON

      *?   // Load Control fields
           WkFlag = ' ';
           Exsr LoadCtlPart;

      *?   // Build Subfile
           Exsr SN2B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Control fields
      *?
        Begsr SN2B;

      *?   // Initialise Subfile fields and Indicator
           S01Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Get Record From CO Header File
           If WkFlag = 'Y';
              Exec SQL
                 DECLARE  A1 Cursor for
                 Select CDHDRSEQ, CDSEQNO, CDBRKLNE, CDBRKMAT, CDVENDSC,
                          CDORDQTY, CDORDLIN, CDLNITMCM, CDKPITMCM
                 From WSCODTLPF
                 Where CDFRORID = :WkBroker And CDBRKORID = :C01PONO
                       And CDHDRSEQ = :WkHSeq#
                 Order By CDSEQNO;

      *?      // Open Cursor
              Exec Sql Open A1;
              If SqlCode = -502 ;
                 Exec Sql Close A1;
                 Exec Sql Open A1;
              Endif;

              Exec Sql Fetch A1 into :WkHSEQ#, :WkDSEQ#, :S01BRLN#, :S01BRITM,
                 :S01BRDES, :S01BRQTY, :S01KPORLN, :S01BRKCMT, :S01KPCMT;

      *?      // Load Data into Subfile fields
              Dow SqlCod = 0 and WkCount < 9999;

      *?         // Increment RRN
                 Dspf.S01BrkCanRi = False;
                 S01Rrn  += 1;
                 WkCount += 1;

      *?         // Write Subfile Display Part
                 S01HSeq# = WkHSeq#;
                 S01DSeq# = WkDSeq#;
                 Chain (WkOrder:S01KPORLN) FIORDR;
                 If %Found;
                    S01KPITM = OIITEM;
                    S01KPSIZ = OISIZE;
                    S01KPDES = OIDES1;
                    S01KPQTY = OIQORD;
                 Endif;
                 If S01BrQty = *Zeros;
                    Dspf.S01BrkCanRi = True;
                 Endif;
                 Write POINQS01;
                 Exec Sql Fetch A1 into :WkHSEQ#, :WkDSEQ#, :S01BRLN#,
                     :S01BRITM, :S01BRDES, :S01BRQTY, :S01KPORLN, :S01BRKCMT,
                     :S01KPCMT;
              Enddo;
           Endif;

      *?   // Load PO Records in Subfile
           If WkFlag = 'N';
              Exsr LoadPoRecords;
           Endif;

      *?   // Subfile End Indicator ON
           Dspf.S01SflEnd = *On;

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
      *?                : SN2D Subroutine :
      *?                :-----------------:
      *
      *?Logic : Write the Message Control Part , Check the Function Key Pressed
      *?
        Begsr SN2D;

      *?   // Write the Footer
           Write POINQF01;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt POINQC01;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';

      *?      // F4 Pressed
              When Dspf.Inquiry;
SUD01            If CSRRCD <> 'POINQS01' and CSRRCD <> 'POINQC01';
                    FlError = True;
                    PmsgId  = 'WS00093';
                    Exsr SendMessage;
                    FunReq = 'DISPLAY';
                 Else;
SUD01               If CSRRCD = 'POINQS01';
  |                    If CSRRRN = *Zeros;
  |                       FlError = True;
  |                       PmsgId  = 'WS00093';
  |                       Exsr SendMessage;
  |                       FunReq = 'DISPLAY';
  |                    Else;
  |                       FunReq = 'VALIDATE';
  |                    Endif;
  |                 Endif;
  |                 If CSRRCD = 'POINQC01';
  |                    FunReq = 'VALIDATE';
SUD01               Endif;
                 Endif;

      *?      // F5 Pressed
              When Dspf.Refresh;
                 Exsr LoadCtlPart;
                 FunReq = 'RELOAD';

      *?      // F9 Pressed
              When Dspf.VendPOInq;
                 WSB2BINQ01(C01PONO);
                 FunReq = 'DISPLAY';

      *?      // F11 Pressed
              When Dspf.S01SflDrop;
                 FunReq = 'DISPLAY';

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ModReq = 'SCREEN1';
                 FunReq = 'INITIAL';

      *?      // Other Pressed
              Other;
                 FunReq = 'VALIDATE';
           Endsl;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate Input Capable Subfile control fields
      *?
        Begsr SN2V;

      *?   // Initialise Indicator
           FlError = False;
           FlSfl   = False;
           FlCtl   = False;

      *?   // Check Input capable fields
           If C01Vend = *Zeros and C01PONO = *Blanks and C01ORNO = *Zeros;
              Dspf.C01VendRi = True;
              Dspf.C01OrNoRi = True;
              Dspf.C01PoNoRi = True;
              FlError = True;
              PMsgId  = 'WS00091';
              Exsr SendMessage;
           Endif;

      *?   // Check Existing Data with Current Data
SUD01      If WkBrkId <> C01Vend Or WkPoNo <> C01PoNo Or
SUD01         WkOrder <> C01OrNo and FlError = False;
              If (C01Vend = *Zeros Or C01PoNo = *Blanks) and FlError = False;
                 If C01OrNo = *Zeros;
                    Dspf.C01VendRi = True;
                    Dspf.C01PoNoRi = True;
                    FlError = True;
                    PMsgId  = 'WS00092';
                    Exsr SendMessage;
                 Endif;
              Endif;

      *?      // Get Order Number for the Vendor and PO
              If C01Vend <> *Zeros and C01PoNo <> *Blanks and C01OrNO = *Zeros
                 and FlError = False;
                 Exsr GetOrder;
                 C01OrNo = WkOrder;
              Endif;

      *?      // Get PO for the Order
              If C01OrNO <> *Zeros and C01PoNo = *Blanks Or C01Vend = *Zeros
                 and FlError = False;
                 Exsr GetPO;
SUD01            C01Vend = WkBrkId;
SUD01            C01PoNo = WkPoNo;
              Endif;

      *?      // Get Vendor name for the Vendor
              If C01Vend <> *Zeros;
                 C01VNME = *Blanks;
                 Exec Sql
                   Select CMNAME Into :C01VNME From FmCust
                   Where CmCust = :C01Vend;
              Else;
                 C01VNME = *Blanks;
              Endif;

      *?      // Get Order Number for the Po
              If C01Vend <> *Zeros and C01PoNo <> *Blanks and
                 C01OrNo <> *Zeros and FlError = False;
                 WkVend = %Char(C01Vend);
                 Chain (WkVend : 'ToOrgId') FbrokdftL0;
                 If %Found;
                    WkBroker = DFVARVAL;
                 Else;
                    WkBroker = *Blanks;
                 Endif;
                 FlCtl = True;
              Endif;
              WkBrkId = C01Vend;
              WkPoNo  = C01PoNo;
              WkOrder = C01OrNo;
           Endif;

      *?   // Validate Cursor Position on Subfile Display Part
           If FlError = False and FlCtl = False;
              FlSfl = True;
           Endif;

      *?   // Process Based on Flag
           If FlError = True;
              FunReq  = 'DISPLAY';
           Elseif FlCtl = True;
              FunReq  = 'INITIAL';
           Elseif FlSfl = True;
              FunReq  = 'PROCESS';
           Else;
              FunReq  = 'DISPLAY';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process the screen based on Cursor location
      *?
        Begsr SN2P;

      *?   // Check Cursor Position
           If Dspf.S01SflDsp and Dspf.Inquiry = True and
SUD01              CSRRCD = 'POINQS01';
              Chain CSRRRN POINQS01;
              If %Found;

      *?         // Call Po Detail Inquiry
                 WSPODINQ03(WkBroker:C01PONO:C01OrNO:S01BRLN#:S01KPITM);
              Endif;
           Endif;

      *?   // Call Po Header Inquiry
SUD01      If CSRRCD = 'POINQC01' and Dspf.Inquiry = True;
              WSPOHINQ02(WkBroker:C01PONO:C01OrNO);
           Endif;

           ModReq = 'SCREEN2';
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : LoadCtlPart Subroutine :
      *?                :------------------------:
      *
      *?Logic : Load Control Part based on input parameters
      *?
        Begsr LoadCtlPart;

      *?   // Get Record From CO Header File
           Exec SQL
              DECLARE  C1 Cursor for
              Select * from WSCOHDRL2
              Where CHFRORID = :WkBroker And CHBRKORID = :WkPoNo
                    And CHORDNO = :WkOrder
              ORDER BY CHFRORID, CHBRKORID, CHORDNO,
                       CHCRTDAT, CHCRTTIM desc
              Fetch first Row Only;

      *?   // If Record Found in CO File
           Exec Sql Open C1;
           If SqlCode = -502 ;
              Exec Sql Close C1;
              Exec Sql Open C1;
           Endif;
           Exec Sql Fetch C1 Into :WSCOHDRDS;
           If SqlCod = 0;
              WkFlag = 'Y';

      *?   // Get Record From PO Header File
           Else;
              Exec SQL
                 DECLARE  C2 Cursor for
                 Select * from WSPOHDRL2
                 Where PHFRORID = :WkBroker And PHBRKORID = :WkPoNo
                       And PHORDNO = :WkOrder
                 ORDER BY PHFRORID, PHBRKORID, PHORDNO,
                          PHCRTDAT, PHCRTTIM desc
                 Fetch first Row Only;

      *?      // If Record Found in PO File
              Exec Sql Open C2;
              If SqlCode = -502 ;
                 Exec Sql Close C2;
                 Exec Sql Open C2;
              Endif;
              Exec Sql Fetch C2 Into :WSPOHDRDS;
              If SqlCod = 0 and WkFlag = ' ';
                 WkFlag = 'N';
              Endif;
           Endif;

      *?   // Move values into Contorl part fields
           If WkFlag = 'Y';
              WkHSeq#   = CHSEQNO;                       // Header Sequence
              C01ORDT   = %CHAR(CHORDDAT);               // Order Date
              C01FDTR   = PHIDATE;                       // Order Received Date
              C01LDTR   = CHIDATE;                       // Order Changed Date
              C01SHPNO  = CHSHPNUM;                      // Ship To Number
              C01SHNME  = CHSHPNAM;                      // Ship To Name
              C01SHADR1 = CHSHPAD1;                      // Ship To Address 1
              C01SHADR2 = CHSHPAD2;                      // Ship To Address 2
              C01SHCTY  = CHSHPCTY;                      // Ship To City
              C01SHST   = CHSHPSTE;                      // Ship To State
              C01SHZP   = CHSHPZIP;                      // Ship To Zip
              C01SHPH   = CHSHPPHN;                      // Ship To Phone
              C01SHFX   = CHSHPFAX;                      // Ship To Fax
              C01SHEML  = CHSHPEML;                      // Ship To Email
              If CHFLAG = 'C' Or CHFLAG = 'P';
                 C01HDSTS = 'Processed';                 // Order Status
              Elseif CHFLAG = 'E';
                 C01HDSTS = 'Exception';
              Elseif CHFLAG = 'X';
                 C01HDSTS = 'Closed';
              Endif;
           Elseif WkFlag = 'N';
              WkHSeq#   = PHSEQNO;                       // Header Sequence
              C01ORDT   = %CHAR(PHORDDAT);               // Order Date
              C01FDTR   = PHIDATE;                       // Order Received Date
              C01LDTR   = PHIDATE;                       // Order Changed Date
              C01SHPNO  = PHSHPNUM;                      // Ship To Number
              C01SHNME  = PHSHPNAM;                      // Ship To Name
              C01SHADR1 = PHSHPAD1;                      // Ship To Address 1
              C01SHADR2 = PHSHPAD2;                      // Ship To Address 2
              C01SHCTY  = PHSHPCTY;                      // Ship To City
              C01SHST   = PHSHPSTE;                      // Ship To State
              C01SHZP   = PHSHPZIP;                      // Ship To Zip
              C01SHPH   = PHSHPPHN;                      // Ship To Phone
              C01SHFX   = PHSHPFAX;                      // Ship To Fax
              C01SHEML  = PHSHPEML;                      // Ship To Email
              If PHFLAG = 'C' Or PHFLAG = 'P';
                 C01HDSTS = 'Processed';                 // Order Status
              Elseif PHFLAG = 'E';
                 C01HDSTS = 'Exception';
              Endif;
           Elseif WkFlag = ' ';
              C01ORDT   = *Blanks;                       // Order Date
              C01FDTR   = *Blanks;                       // Order Received Date
              C01LDTR   = *Blanks;                       // Order Changed Date
              C01SHPNO  = *Blanks;                       // Ship To Number
              C01SHNME  = *Blanks;                       // Ship To Name
              C01SHADR1 = *Blanks;                       // Ship To Address 1
              C01SHADR2 = *Blanks;                       // Ship To Address 2
              C01SHCTY  = *Blanks;                       // Ship To City
              C01SHST   = *Blanks;                       // Ship To State
              C01SHZP   = *Blanks;                       // Ship To Zip
              C01SHPH   = *Blanks;                       // Ship To Phone
              C01SHFX   = *Blanks;                       // Ship To Fax
              C01SHEML  = *Blanks;                       // Ship To Email
              C01HDSTS  = *Blanks;                       // Order Status
           Endif;

      *?   // Move values into Work Variable
           Exec Sql
              Select CMNAME Into :C01VNME From FmCust
              Where CmCust = :C01Vend;
           WkBrkId = C01Vend;
           WkPoNo  = C01PONO;
           WkOrder = C01ORNO;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : LoadPoRecords Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Load PO detail file records in subfile
      *?
        Begsr LoadPoRecords;

      *?   // Move values into Subfile
           Exec SQL
              DECLARE  A2 Cursor for
              Select PDHDRSEQ, PDSEQNO, PDBRKLNE, PDBRKMAT, PDVENDSC,
                       PDORDQTY, PDORDLIN, PDLNITMCM, PDKPITMCM
              From WSPODTLPF
              Where PDFRORID = :WkBroker And PDBRKORID = :WkPoNo
                    and PDHDRSEQ = :WkHSeq#
              Order By PDSEQNO;

      *?   // Open Cursor
           Exec Sql Open A2;
           If SqlCode = -502 ;
              Exec Sql Close A2;
              Exec Sql Open A2;
           Endif;

           Exec Sql Fetch A2 into :WkHSEQ#, :WkDSEQ#, :S01BRLN#, :S01BRITM,
               :S01BRDES, :S01BRQTY, :S01KPORLN, :S01BRKCMT, :S01KPCMT;

      *?   // Load Data into Subfile fields
           Dow SqlCod = 0 and WkCount < 9999;

      *?       // Increment RRN
               Dspf.S01BrkCanRi = False;
               S01Rrn  += 1;
               WkCount += 1;

      *?       // Write Subfile Display Part
               S01HSeq# = WkHSeq#;
               S01DSeq# = WkDSeq#;
               Chain (C01OrNo:S01KPORLN) FIORDR;
               If %Found;
                  S01KPITM = OIITEM;
                  S01KPSIZ = OISIZE;
                  S01KPDES = OIDES1;
                  S01KPQTY = OIQORD;
               Endif;
               If S01BrQty = *Zeros;
                  Dspf.S01BrkCanRi = True;
               Endif;
               Write POINQS01;
               Exec Sql Fetch A2 into :WkHSEQ#, :WkDSEQ#, :S01BRLN#,
                   :S01BRITM, :S01BRDES, :S01BRQTY, :S01KPORLN, :S01BRKCMT,
                   :S01KPCMT;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Initialize Screen Inputs
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PGMQ = Pgm;

      *?   // Open Main Screen
           ModReq = 'SCREEN1';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : GetOrder Subroutine :
      *?                :---------------------:
      *
      *?Logic : Get Order for the PO and Vendor
      *?
        Begsr GetOrder;

      *?   // Get Order For the Broker Order ID and Vendor
           Chain (WkVend : 'ToOrgId') FbrokdftL0;
           If %Found;
              WkBroker = DFVARVAL;
           Else;
              WkBroker = *Blanks;
           Endif;

      *?   // Get Order For the Broker Order ID and Vendor
           Exec SQL
              Select CHORDNO into :WkOrder
              From WSCOHDRPF
              Where CHFRORID = :WkBroker And CHBRKORID = :WkPoNo And
SUD04               CHFLAG = 'P';

           If WkOrder = *Zeros;
              Exec SQL
                 Select PHORDNO into :WkOrder
                 From WSPOHDRPF
                 Where PHFRORID = :WkBroker And PHBRKORID = :WkPoNo And
SUD04                  PHFLAG = 'P';
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : GetPO Subroutine :
      *?                :------------------:
      *
      *?Logic : Get PO and Vendor for the Order
      *?
        Begsr GetPO;

      *?   // Get Broker Order ID and Vendor for the Order
           Exec SQL
              Select CHBRKORID, CHFRORID into :WkPoNo , :WKBroker
              From WSCOHDRPF
              Where CHORDNO = :WkOrder;

           If WkPoNo = *Blanks;
              Exec SQL
                 Select PHBRKORID, PHFRORID into :WkPoNo , :WKBroker
                 From WSPOHDRPF
                 Where PHORDNO = :WkOrder;
           Endif;

      *?   // Get Vendor Number
           Chain ('1000' : WkBroker) FbrokdftL0;
           If %Found;
              WkBrkId = %Int(DFVARVAL);
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
           PMsgf = 'WSMSGF';
           POpt  = 'C';
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
           ModReq  = 'SCREEN1';
           FunReq  = 'DISPLAY';

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
