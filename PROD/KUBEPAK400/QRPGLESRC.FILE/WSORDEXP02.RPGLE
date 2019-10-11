      *? Program        : WSORDEXP02
      *?
      *? Description    : This pgm to show Error Details for the Customer PO
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 10 Nov 2017
      //--------------------------------------------------------------------
      *? Special Notes  : ** Using SFLCSRRRN to get Fetch Subfile Row &
      *?                     There is no Input Fields in this Subfile
      *?                : ** Positon a cursor on error message line press enter
      *?                : ** F9 - Override Item , If dont want to Reactivate item
      *?                     in Master file & Process the order line with Zero Qty
      *?                  ** If there is no error in XML files Call
      *?                     Validation program to Create/Change Order
      *?
      *? Called Program : WSORDEXP03 - WS - PO Header Field Validations - Program 3
      *?                  WSORDEXP04 - WS - PO Detail Field Validations - Program 4
      *?                  WSPOVAL002 - WS - XML File Validation and Order Creation
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
      * SUD01   09/08/18   S.Uthaya     Added Function key F9 to Override Item
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
      *?File: WS - XML Order Error Exception Logical File
      *?Key : Broker ID : Customer PO : Header Seq : Error Seq
        Dcl-F WSERREXPL0 Disk(*Ext) Keyed Usage(*OutPut:*Update)
                                  Prefix(X) Rename(WSERREXPR:Rec);
      *?Key : Broker ID : Customer PO : Header Seq : Error Seq : Broker Material
        Dcl-F WSERREXPL2 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - XML Cross Reference File for FMINVT
      *?Key : ProvidedbyName : ProvidedbyType : ForeignKeyValue
        Dcl-F XREFINVTL0  Disk(*Ext) Keyed Usage(*Input);
      *
SUD01 *?File: WS - XML Order Header Logical File
  |   *?Key : Broker Name:BrokerOrderId:Header Seq no
  |     Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Delete);
  |   *
  |   *?File: WS - Xml Create Order Detail Logical File
  |   *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
  |     Dcl-F WSPODTLL0 Disk(*Ext) Keyed Usage(*Update :*Output);
  |   *
  |   *?File: WS - XML Change Order Header Logical File
  |   *?Key : Broker Name:BrokerOrderId:Header Seq no
  |     Dcl-F WSCOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Delete);
  |   *
  |   *?File: WS - Xml Change Order Detail Logical File
  |   *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
SUD01   Dcl-F WSCODTLL0 Disk(*Ext) Keyed Usage(*Update :*Output);
      *
      *?File: Display file for Error Detail Screen Program
        Dcl-F WSOREXFM02 Workstn Indds(Dspf) Sfile(ORDEXPS02:S02Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSORDEXP01)
        Dcl-Pi WSORDEXP02 ExtPgm;
SUD03      PBrkId  Char(15);
           PCustPO Char(10);
           PSeqNo  Packed(9);
           PPgm    Char(10);
           PSts    Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Validate Header Errors
        Dcl-Pr WSORDEXP03 Extpgm;
SUD03     PBrkId     Char(15);
          PCustPO    Char(10);
          PSeqNo     Packed(9);
          PErrSeq    Packed(5);
          POrdNo     Packed(6);
          PPgm       Char(10);
          PSts       Char(2);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Validate Detail Errors
        Dcl-Pr WSORDEXP04 Extpgm;
SUD03     PBrkId     Char(15);
          PCustPO    Char(10);
          PSeqNo     Packed(9);
          PDSeqNo    Packed(6);
          PErrSeq    Packed(5);
          POrdNo     Packed(6);
          PPgm       Char(10);
          PSts       Char(2);
        End-Pr;
      *
SUD01 *?Procedure Prototype Declaration : Order Create Validation Program
  |     Dcl-Pr WSPOVAL002 ExtPgm;
  |        PBrkName Char(30);
  |        PCustPO  Char(10);
  |        PHSeqNo  Packed(9);
  |        PFlag    Char(1);
  |     End-Pr;
  |   *
  |   *?Procedure Prototype Declaration : Order Change Validation Program
  |     Dcl-Pr WSCOVAL002 ExtPgm;
  |        PBrkName Char(30);
  |        PCustPO  Char(10);
  |        PHSeqNo  Packed(9);
  |        PFlag    Char(1);
  |     End-Pr;
  |   *
  |   *?Procedure Prototype Declaration : Generate Acknowledgement XML for PO
  |     Dcl-Pr WSPOACK003 ExtPgm;
  |        PBrkName Char(30);
  |        PCustPO  Char(10);
  |        PHSeqNo  Packed(9);
  |        PBrkAck  Char(1000000) Options(*Varsize);
  |     End-Pr;
  |   *
  |   *?Procedure Prototype Declaration : Generate Acknowledgement XML for PO
  |     Dcl-Pr WSCOACK003 ExtPgm;
  |        PBrkName Char(30);
  |        PCustPO  Char(10);
  |        PHSeqNo  Packed(9);
  |        PBrkAck  Char(1000000) Options(*Varsize);
SUD01   End-Pr;
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
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG ExtPgm;
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
      *?Local Variable Declaration :
        Dcl-S ModReq Char(10);
        Dcl-S FunReq Char(10);
      *
      *?Work Variable Declaration :
        Dcl-S WkCount   Zoned(2:0)    Inz;
SUD01   Dcl-S WkFlag    Char(1)       Inz;
        Dcl-S WkFRrn    Like(S02RRn);
      *
      *?Work Variable Declaration :
        Dcl-S FlError  Ind Inz(*Off);
      *
      *?Parameter Variable Declaration :
        Dcl-S PErrSeq    Packed(5);                 // For Rpg Program
        Dcl-S POrdNo     Packed(6);
        Dcl-S PDSeqNO    Packed(6);
SUD01   Dcl-S PBrkAck    Char(1000000);
SUD01   Dcl-S PBrkName   Char(30);
        Dcl-S PMsgf      Char(10);                  // For CL Program
        Dcl-S PMsgId     Char(7);
        Dcl-S POpt       Char(1);
SUD01   Dcl-S PFlag      Char(1);
SUD02   Dcl-S PPrFlag    Char(2);                   // For RPG program
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
SUD01      Override        Ind Pos(9);          // Override Function Key
           Previous        Ind Pos(12);         // Previous Function Key
      *
           S02SflDsp       Ind Pos(21);         // Subfile Display Ind
           S02SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S02SflClr       Ind Pos(23);         // Subfile Clear Ind
           S02SflEnd       Ind Pos(24);         // Subfile End Ind
        End-Ds;
      *
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
                 Exsr SN2M;
              Enddo;

           Enddo;

      *?   // End Program
           *InLr = True;
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
      *?                : SN2I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN2I;

      *?   // Clear Subfile
           Dspf.S02SflClr = True;                      // Clear Ind ON
           Dspf.S02SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write ORDEXPC02;

      *?   // Clear Rrn
           H02CSRRRN = *Zeros;
           S02Rrn    = *Zeros;

      *?   // Clear Subfile
           Dspf.S02SflClr    = False;          // Clear Ind OFF
           Dspf.S02SflDspCtl = True;           // Display Control Ind ON

      *?   // Check Control Field and Load Subfile
           Setll (C02BRKID:C02CUSTPO:C02HDRSEQ) WSERREXPL2;
           ReadE (C02BRKID:C02CUSTPO:C02HDRSEQ) WSERREXPL2;

      *?   // Build Subfile
           If Not %Eof;
              Exsr SN2B;
           Else;

      *?      // No Records Found
              Dspf.S02SflEnd = True;
              PMsgId = 'WS00030';
              Exsr Sendmessage;
           Endif;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN2B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Read the file and Build Subfile based on size
      *?
        Begsr SN2B;

      *?   // Initialise Subfile fields and Indicator
           S02Rrn    = *Zeros;
           WkFRrn    = S02Rrn;
           H02CSRRRN = S02Rrn;
           WkCount   = *Zeros;

      *?   // Load Subfile
           Dow Not %Eof And WkCount < 9999;

              If ERFLAG <> 'I' And ERFLAG <> 'X' And
                       ERFLAG <> *Blanks;

      *?         // Move Values into Subfile fields
                 S02SEQNO  = ERERRSEQ;
                 H02DSEQNO = ERPODSEQ;
                 H02ERRID  = ERRMSGID;

      *?         // Move Error msg based on Error Message ID
                 If ERRMSGID = 'WS00021' Or ERRMSGID = 'WS00024'
                    Or  ERRMSGID = 'WS00048';
                    If ERITMNUM = *Blanks;
                       Chain (PBrkId:'Customer':ERBRKMAT) XREFINVTL0;
                       If %Found;
                          S02ERROR = %Trim(XRLCLITEM) +  ' '  +
                                       %Trim(XRLCLSIZE) + '-' +  ERRMSG;
                       Else;
                          If ERBRKMAT <> *Blanks;
                             S02ERROR = %Trim(ERBRKMAT) + '-' + ERRMSG;
                          Else;
                             S02ERROR = ERRMSG;
                          Endif;
                       Endif;
                    Else;
                       S02ERROR = %Trim(ERITMNUM) + ' ' + %Trim(ERITMSIZ) +
                                          '-' + ERRMSG;
                    Endif;
                 Elseif ERRMSGID = 'WS00022' Or ERRMSGID = 'WS00019';
                    If ERBRKMAT <> *Blanks;
                       S02ERROR = %Trim(ERBRKMAT) + '-' + ERRMSG;
                    Else;
                       S02ERROR = ERRMSG;
                    Endif;
                 Elseif ERRMSGID = 'WS00026';
                    If ERRQSPDT <> *Loval;
                       If ERITMNUM <> *Blanks;
                          S02ERROR = %Trim(ERITMNUM) + ' (' + %Trim(ERITMSIZ) +
                                     ') ' + %Char(ERRQSPDT) + ' ' + ERRMSG;
                       Else;
                          S02ERROR = %Trim(ERBRKMAT) + ' ' +
                                       %Char(ERRQSPDT) + ' ' + ERRMSG;
                       Endif;
                    Else;
                       If ERITMNUM <> *Blanks;
                          S02ERROR = %Trim(ERITMNUM) + ' (' + %Trim(ERITMSIZ) +
                                     ') ' + ' ' + ERRMSG;
                       Else;
                          S02ERROR = %Trim(ERBRKMAT) + ' ' + ERRMSG;
                       Endif;
                    Endif;
                 Else;
                    S02ERROR = ERRMSG;
                 Endif;

                 S02TYPE  = ERFLAG;

      *?         // Increment RRN
                 S02Rrn   += 1;
                 WkCount  += 1;
                 H02CSRRRN = S02Rrn;
                 If WkCount =  1;
                    WkFRrn = S02Rrn;
                 Endif;

      *?         // Write Subfile Display Part
                 Write ORDEXPS02;
              Endif;
              ReadE (C02BRKID:C02CUSTPO:C02HDRSEQ) WSERREXPL2;

           Enddo;

      *?   // Subfile End Indicator ON
           Dspf.S02SflEnd = %Eof;

      *?   // Check RRN
           If S02Rrn <> *Zeros;
              Dspf.S02SflDsp = True;
              S02Rrn = WkFRrn;
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
           Write ORDEXPF02;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt ORDEXPC02;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 PSts   = '03';

SUD01 *?      // F9 Pressed
  |           When Dspf.Override;
  |              If H02CSRRRN <> *Zeros and H02ERRID = 'WS00024';
  |                 Exsr Updatedetail;
  |              Elseif H02CSRRRN <> *Zeros and H02ERRID <> 'WS00024';
  |                 PMsgId = 'WS00076';
  |                 Exsr Sendmessage;
  |                 FunReq = 'DISPLAY';
  |              Elseif H02CSRRRN = *Zeros;
  |                 PMsgId = 'WS00031';
  |                 Exsr Sendmessage;
  |                 FunReq = 'DISPLAY';
SUD01            Endif;

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
      *?                : SN2V Subroutine :
      *?                :-----------------:
      *
      *?Logic : Validate Cursor Position in subfile part                    sed
      *?      : If No errors then Process , Else Display error in Screen Pressed
      *?
        Begsr SN2V;

      *?   // Initialise Fields
           FlError = False;

      *?   // Validate Cursor Postion
           If Dspf.S02SflDsp;

      *?      // Validate Cursor RRN
              If H02CSRRRN = *Zeros;
                 FlError = True;
                 PmsgId = 'WS00031';
                 Exsr SendMessage;
              Endif;
           Endif;

      *?   // Check Error Flag and Execute Process
           If FlError ;
              FunReq = 'DISPLAY';
           Else;
              FunReq = 'PROCESS';
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

      *?   // Read Cursor Positioned record and Process based on RRN
           If Dspf.S02SflDsp;
              Chain H02CsrRrn ORDEXPS02;
              If %Found;

      *?         // Error in Header Part
                 If S02TYPE = 'H';
                    PErrSeq = S02SEQNO;
                    PSts    = *Blanks;
                    WSORDEXP03(PBrkID:PCustPO:PSeqNO:PErrSeq:POrdNo:PPgm:PSts);

      *?         // Error in Detail Part
                 Elseif  S02TYPE = 'D';
                    Setll (PBrkID:PCustPO:PSeqNO:S02SEQNO) WSERREXPL2;
                    ReadE (PBrkID:PCustPO:PSeqNO:S02SEQNO) WSERREXPL2;
                    Dow Not %Eof;
                       If (ERRMSGID = 'WS00019' Or ERRMSGID = 'WS00020'
                          Or ERRMSGID = 'WS00022' Or ERRMSGID = 'WS00048')
                          And ERFLAG = 'D';
                          PErrSeq = S02SEQNO;
                          PDSeqNo = H02DSEQNO;
                          PSts    = *Blanks;
                          WSORDEXP04(PBrkID:PCustPO:PSeqNO:PDSeqNO:
                                       PErrSeq:POrdNo:PPgm:PSts);
                          If PSts = '12' Or PSts = '03';
                             ModReq = 'EXIT';
                          Endif;
SUD01                  Elseif ERRMSGID = 'WS00024';
  |                       PmsgId = 'WS00077';
  |                       Exsr SendMessage;
  |                       PSts = ' ' ;
SUD01                  Else;
                          FlError = True;
                          PmsgId = 'WS00035';
                          Exsr SendMessage;
                       Endif;
                       ReadE (PBrkID:PCustPO:PSeqNO:S02SEQNO) WSERREXPL2;
                    Enddo;
                 Endif;

      *?         // Check Function Key Parameter
                 If FlError = False;
                    If PSts = '03';
                       ModReq = 'EXIT';
                    Elseif PSts = '12';
                       ModReq = 'SCREEN';
                       FunReq = 'INITIAL';
SUD01               Elseif PSts = '  ';
SUD01                  FunReq = 'DISPLAY';
                    Endif;
                 Else;
                    FunReq = 'DISPLAY';
                 Endif;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : INZSR Subroutine :
      *?                :------------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr *InzSr;

      *?   // Initialise Values
           PGMQ      = Pgm;
           C02Sys    = Job;
           C02Pgm    = Pgm;
           C02BRKID  = PBrkId;
           C02CUSTPO = PCustPo;
           C02HDRSEQ = PSeqNo;
           C02ORDNO  = POrdNo;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?                :-------------------------:
  |   *?                : UpdateDetail Subroutine :
  |   *?                :-------------------------:
  |   *
  |   *?Logic : Update Deatil File for the Detail Line
  |   *?
  |     Begsr UpdateDetail;
  |
  |   *?   // Update Record in WSPODTLPF
  |        If PPgm = 'CreateOrd';
  |           Chain (PBrkID:PCustPO:PSeqNo:H02DSEQNO) WSPODTLL0;
  |           PDFLAG   = 'U';
  |           PDUPDDAT = Rundate;
  |           PDUPDTIM = Runtime;
  |           PDUPDUSR = User;
  |           PDUPDJOB = Job;
  |           PDUPDPGM = Pgm;
  |           Update WSPODTLR %Fields(PDFLAG:PDUPDDAT:PDUPDTIM:
  |                                   PDUPDUSR:PDUPDJOB:PDUPDPGM);
  |
  |   *?   // Update Record in WSCODTLPF
  |        Elseif PPgm = 'ChangeOrd';
  |           Chain (PBrkID:PCustPO:PSeqNo:H02DSEQNO) WSCODTLL0;
  |           CDFLAG   = 'U';
  |           CDUPDDAT = Rundate;
  |           CDUPDTIM = Runtime;
  |           CDUPDUSR = User;
  |           CDUPDJOB = Job;
  |           CDUPDPGM = Pgm;
  |           Update WSCODTLR %Fields(CDFLAG:CDUPDDAT:CDUPDTIM:
  |                                   CDUPDUSR:CDUPDJOB:CDUPDPGM);
  |        Endif;
  |
  |   *?   // Execute UpdateError
  |        Exsr UpdateError;
  |        Exsr CreateOrder;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :------------------------:
  |   *?                : UpdateError Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Update Error File for the Detail Line
  |   *?
  |     Begsr UpdateError ;
  |
  |   *?   // Update Error Flag in Exception File
  |        Setll (PBrkId:PCustPO:PSeqNo) WSERREXPL0;
  |        ReadE (PBrkId:PCustPO:PSeqNo) WSERREXPL0;
  |        Dow Not %Eof;
  |           If XERFLAG = 'D' and XERPODSEQ = H02DSEQNO;
  |
  |              If XERRMSGID <> 'WS00021' and XERRMSGID <> 'WS00026';
  |                 XERFLAG = ' ';
  |
  |   *?            // Audit Stamp
  |                 XERUPDDAT = Rundate;
  |                 XERUPDTIM = Runtime;
  |                 XERUPDUSR = User;
  |                 XERUPDJOB = Job;
  |                 XERUPDPGM = Pgm;
  |                 Update Rec  %Fields(XERFLAG:XERUPDDAT:XERUPDTIM:
  |                                        XERUPDUSR:XERUPDJOB:XERUPDPGM);
  |              Endif;
  |           Endif;
  |           ReadE (PBrkId:PCustPO:PHSeqNo) WSERREXPL0;
  |        Enddo;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :------------------------:
  |   *?                : CreateOrder Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Check Error file , If there is no error ,Then update Xml
  |   *?        Files and call Validation program to Create/Change Order
  |   * ?
  |     Begsr CreateOrder;
  |
  |   *?   // Check Error File before Process Order
  |        WkFlag = 'Y';
  |        Setll (PBrkId:PCustPO:PSeqNo) WSERREXPL2;
  |        ReadE (PBrkId:PCustPO:PSeqNo) WSERREXPL2;
  |        Dow Not %Eof;
  |           If ERFLAG = 'H';
  |              WkFlag = 'N';
  |              Leave;
  |           Else;
  |              WkFlag = 'Y';
  |           Endif;
  |           If ERFLAG = 'D';
  |              If ERRMSGID <> 'WS00021';
  |                 WkFlag = 'N';
  |                 Leave;
  |              Else;
  |                 WkFlag = 'Y';
  |              Endif;
  |           Endif;
  |           If ERFLAG = 'I';
  |              WkFlag = 'Y';
  |           Endif;
  |           ReadE (PBrkId:PCustPO:PHSeqNo) WSERREXPL2;
  |        Enddo;
  |
  |   *?   // Process Order
  |        If WkFlag = 'Y';
  |
  |   *?      // Check Error file based on Order type call program
  |           Exsr UpdateHeader;
  |
  |   *?      // Create Order
  |           If PPgm = 'CreateOrd';
  |              PBrkName = PBrkId;
  |              PFlag = ' ';
  |              WSPOVAL002(PBrkName:PCustPO:PSeqno:PFlag);
  |              If PFlag = 'C';
SUD01               PBrkAck = *Blanks;
SUD02               If PBrkName <> 'Michell';
  |                    WSPOACK003(PBrkName:PCustPO:PSeqno:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'PO';
  |                    WSPOACKMCH(PBrkName:PCustPO:PSeqno:PBrkAck
  |                                         :PPrFlag);
SUD02               Endif;
SUD01               ModReq = 'EXIT';
  |                 PSts = '12';
  |              Endif;
  |
  |   *?      // Change Order
  |           Elseif PPgm = 'ChangeOrd';
  |              PBrkName = PBrkId;
  |              PFlag = ' ';
  |              WSCOVAL002(PBrkName:PCustPO:PSeqno:PFlag);
  |              If PFlag = 'C';
SUD01               PBrkAck = *Blanks;
SUD02               If PBrkName <> 'Michell';
  |                    WSCOACK003(PBrkName:PCustPO:PSeqno:PBrkAck);
  |                 Else;
  |                    PPrFlag = 'CO';
  |                    WSPOACKMCH(PBrkName:PCustPO:PSeqno:PBrkAck
  |                                         :PPrFlag);
SUD02               Endif;
SUD01               ModReq = 'EXIT';
  |                 PSts = '12';
  |              Endif;
  |           Endif;
  |        Endif;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :-------------------------:
  |   *?                : UpdateHeader Subroutine :
  |   *?                :-------------------------:
  |   *
  |   *?Logic : Update XML Header files if there are no error in Detail File
  |   *?
  |     Begsr UpdateHeader;
  |
  |   *?   // Update Record in WSPOHDRPF
  |        If PPgm = 'CreateOrd';
  |           Chain (PBrkID:PCustPO:PSeqNo) WSPOHDRL1;
  |           PHFLAG   = ' ';
  |           PHUPDDAT = Rundate;
  |           PHUPDTIM = Runtime;
  |           PHUPDUSR = User;
  |           PHUPDJOB = Job;
  |           PHUPDPGM = Pgm;
  |
  |           Update WSPOHDRR %Fields(PHFLAG:PHUPDDAT:PHUPDTIM:
  |                                   PHUPDUSR:PHUPDJOB:PHUPDPGM);
  |
  |   *?   // Update Record in WSCOHDRPF
  |        Elseif PPgm = 'ChangeOrd';
  |           Chain (PBrkID:PCustPO:PSeqNo) WSCOHDRL1;
  |           CHFLAG   = ' ';
  |           CHUPDDAT = Rundate;
  |           CHUPDTIM = Runtime;
  |           CHUPDUSR = User;
  |           CHUPDJOB = Job;
  |           CHUPDPGM = Pgm;
  |
  |           Update WSCOHDRR %Fields(CHFLAG:CHUPDDAT:CHUPDTIM:
  |                                   CHUPDUSR:CHUPDJOB:CHUPDPGM);
  |        Endif;
  |
  |     Endsr;
SUD01 //--------------------------------------------------------------------
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
