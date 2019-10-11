      *? Program        : WSPODINQ03
      *?
      *? Description    : This pgm to PO Detail History Inquiry Screen
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 01 Jan 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Detail History Inquiry
      *?                : ** Sorting By Sequence#
      *?                : ** Sorting By Broker Line#
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   04/03/19   S.Uthaya     1. Added Broker Line & KP Item Filter
      *                                 2. Added Sequence & Broker Line Sorting
      *                                 3. Added Broker Line & KP Item Entry Parameter
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
      *?File: Display file for PO Detail Inquiry Screen
        Dcl-F WSPODINQFM Workstn Indds(Dspf) Sfile(PODINQS03:S03Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPODINQ03;
           PVendor    Char(30);
           PVendorPo  Char(10);
           POrder     Packed(6);
SUD01      PBrkLin    Char(10);
SUD01      PKPItem    Char(5);
        End-Pi;
      *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG  ExtPgm;
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
        Dcl-S WkCount   Packed(4)  Inz;         // For Subfile Count
        Dcl-S WkHSeq#   Packed(9)  Inz;         // For Subfile Header Seq#
        Dcl-S WkDSeq#   Packed(6)  Inz;         // For Subfile Detail Seq#
SUD01   Dcl-S WkDate7   Packed(7)  Inz;         // For Subfile Date Conversion
  |     Dcl-S WkDate6   Packed(6)  Inz;         // For Subfile Date Conversion
  |     Dcl-S WkTime    Packed(6)  Inz;         // For Subfile Time Conversion
  |     Dcl-S WkSort    Packed(1)  Inz;         // For Sorting Identification
  |     Dcl-S WkDate    Date(*ISO) Inz;         // For Subfile Date Conversion
  |     Dcl-S WkFlag    Char(1)    Inz;         // For Subfile Ctl&Dtl Part Loading
  |     Dcl-S WkBrLn#   Char(10)   Inz;
SUD01   Dcl-S WkKPItm   Char(5)    Inz;
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
SUD01 *?Flag Indicators Declaration :
  |     Dcl-S FlSortS Ind Inz(*Off);            // For Subfile Sorting by Sequence
SUD01   Dcl-S FlSortB Ind Inz(*Off);            // For Subfile Sorting by Broker Line
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf      Char(10);              // For CL Program
        Dcl-S PMsgId     Char(7);               // For CL Program
        Dcl-S POpt       Char(1);               // For CL Program
        Dcl-S PErr       Char(1);               // For CL Program
      *
      *?Display File Indicators Declaration :
        Dcl-Ds Dspf Qualified;
SUD01      SortS           Ind Pos(7);          // Sort by Seq Function Key
SUD01      SortB           Ind Pos(8);          // Sort by BrkLin Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           S03SflDsp       Ind Pos(21);         // Subfile Display Ind
           S03SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S03SflClr       Ind Pos(23);         // Subfile Clear Ind
           S03SflEnd       Ind Pos(24);         // Subfile End Ind
           S03SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
           S03SflDrop      Ind Pos(11);         // Subfile Drop Ind
           S03SflDesRi     Ind Pos(30);         // Subfile Description Reverse Image
           S03SflDltRi     Ind Pos(31);         // Subfile Deleted Line Reverse Image
      *
           C03BrkLinRi     Ind Pos(32);         // Broker Line Reverse Image
           C03KPItemRi     Ind Pos(33);         // KP Item Reverse Image
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
                 Exsr SN1M;
              Enddo;

           Enddo;

      *?   // Close Cursor
           Exec Sql Close A1;
           Exec Sql Close A2;
           Exec Sql Close A3;
           Exec Sql Close A4;
           Exec Sql Close B1;
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

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1I Subroutine :
      *?                :-----------------:
      *
      *?Logic : Clear all screen control Parameters and control field values
      *?
        Begsr SN1I;

      *?   // Clear Subfile
           Dspf.S03SflClr = True;                      // Clear Ind ON
           Dspf.S03SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write PODINQC03;

      *?   // Clear Rrn
           S03Rrn = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S03SflClr    = False;                  // Clear Ind OFF
           Dspf.S03SflDspCtl = True;                   // Display Control Ind ON

      *?   // Load Control fields
           WkFlag = 'N';
           Exsr LoadCtlPart;

      *?   // Build Subfile
           Exsr SN1B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Control fields , Sorting and Filter
      *?
        Begsr SN1B;

      *?   // Initialise Subfile fields and Indicator
           S03Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Get Record From CO Header File
           If WkFlag = 'Y';

      *?      // Declare Cursor Based on Sorting
SUD01         Exsr DeclareCursor;

      *?      // Load Data into Subfile fields
              Dow SqlCod = 0 and WkCount < 9999;

      *?         // Write Subfile Display Part
                 Dspf.S03SflDltRi = False;
                 S03HSeq# = WkHSeq#;
                 S03DSeq# = WkDSeq#;
SUD01            WkDate6= WkDate7;
  |              WkDate = %Date(WkDate6:*MDY);
  |              S03TIMEST= %Char(%Timestamp( %Char(WkDate) + '-'
SUD01                        + %Char(%Time(WkTime)) + '.000000' ));
                 Chain (C03OrNo:S03KPORLN) FIORDR;
                 If %Found;
                    S03KPITM = OIITEM;
                    S03KPSIZ = OISIZE;
                    S03KPDES = OIDES1;
                    S03KPQTY = OIQORD;
                 Endif;
                 If H01Flag = 'X';
                    Dspf.S03SflDltRi = True;
                 Endif;

      *?         // Write Based on Filter
                 If C03KPItm <> *Blanks;
                    If C03KPItm = S03KpItm;
                       S03Rrn  += 1;
                       WkCount += 1;
                       Write PODINQS03;
                    Endif;
                 Else;
                    S03Rrn  += 1;
                    WkCount += 1;
                    Write PODINQS03;
                 Endif;

SUD01 *?         // Fetch next record
  |              If FlSortS = False and FlSortB = False and WkSort = 0;
  |                 Exec Sql Fetch A1 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                  :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN, :S03BRKCMT,
  |                  :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
  |
  |              Elseif FlSortS = True and FlSortB = False and WkSort = 0;
  |                 Exec Sql Fetch A2 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                  :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN, :S03BRKCMT,
  |                  :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
  |
  |              Elseif FlSortS = False and FlSortB = True and WkSort = 1;
  |                 Exec Sql Fetch A3 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                  :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN, :S03BRKCMT,
  |                  :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
  |
  |              Elseif FlSortS = False and FlSortB = False and WkSort = 1;
  |                 Exec Sql Fetch A4 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                  :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN, :S03BRKCMT,
  |                  :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
SUD01            Endif;
              Enddo;
           Endif;

      *?   // Load PO Records in Subfile
           Exsr LoadPoRecords;

      *?   // Subfile End Indicator ON
           Dspf.S03SflEnd = *On;

      *?   // Check RRN and Show Subfile
           If S03Rrn <> *Zeros;
              Dspf.S03SflDsp = True;
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

      *?   // Write the Footer
           Write PODINQF03;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt PODINQC03;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

SUD01 *?      // F7 Pressed
  |           When Dspf.SortS;
  |              If FlSortS = False;
  |                 FlSortS = True;
  |              Else;
  |                 FlSortS = False;
  |              Endif;
  |              FlSortB = False;
  |              WkSort = 0;
  |              FunReq = 'INITIAL';
  |
  |   *?      // F8 Pressed
  |           When Dspf.SortB;
  |              If FlSortB = False;
  |                 FlSortB = True;
  |              Else;
  |                 FlSortB = False;
  |              Endif;
  |              FlSortS = False;
  |              WkSort = 1;
SUD01            FunReq = 'INITIAL';

      *?      // F11 Pressed
              When Dspf.S03SflDrop;
                 FunReq = 'DISPLAY';

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ModReq = 'EXIT';

      *?      // Other Pressed
              Other;
                 If WkKpItm <> C03KpItm Or WkBrLn# <> C03BRLN#;
                    FunReq = 'INITIAL';
                 Else;
                    FunReq = 'DISPLAY';
                 Endif;
           Endsl;

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
              Where CHFRORID = :PVendor And CHBRKORID = :PVendorPO
                    And CHORDNO = :POrder
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
           Endif;

      *?   // Get Record From PO Header File
           Exec SQL
              DECLARE  C2 Cursor for
              Select * from WSPOHDRL2
              Where PHFRORID = :PVendor And PHBRKORID = :PVendorPO
                    And PHORDNO = :POrder
              ORDER BY PHFRORID, PHBRKORID, PHORDNO,
                    PHCRTDAT, PHCRTTIM desc
              Fetch first row only;

      *?   // If Record Found in PO File
           If SqlCod = 0;
              Exec Sql Open C2;
              If SqlCode = -502 ;
                 Exec Sql Close C2;
                 Exec Sql Open C2;
              Endif;
              Exec Sql Fetch C2 Into :WSPOHDRDS;
           Endif;

      *?   // Move values into Contorl part fields
           If WkFlag = 'Y';
              C03PONO   = PVendorPO;                     // Vendor PO
              C03ORNO   = POrder;                        // Order Number
              C03ORDT   = %CHAR(CHORDDAT);               // Order Date
              C03FDTR   = PHIDATE;                       // Order Received Date
              C03LDTR   = CHIDATE;                       // Order Changed Date
              C03SHPNO  = CHSHPNUM;                      // Ship To Number
              C03SHNME  = CHSHPNAM;                      // Ship To Name
              C03SHADR1 = CHSHPAD1;                      // Ship To Address 1
              C03SHADR2 = CHSHPAD2;                      // Ship To Address 2
              C03SHCTY  = CHSHPCTY;                      // Ship To City
              C03SHST   = CHSHPSTE;                      // Ship To State
              C03SHZP   = CHSHPZIP;                      // Ship To Zip
              C03SHPH   = CHSHPPHN;                      // Ship To Phone
              C03SHFX   = CHSHPFAX;                      // Ship To Fax
              C03SHEML  = CHSHPEML;                      // Ship To Email
              If CHFLAG = 'C' Or CHFLAG = 'P';
                 C03HDSTS = 'Processed';                 // Order Status
              Elseif CHFLAG = 'E';
                 C03HDSTS = 'Exception';
              Elseif CHFLAG = 'X';
                 C03HDSTS = 'Closed';
              Endif;
           Else;
              C03PONO   = PVendorPO;                     // Vendor PO
              C03ORNO   = POrder;                        // Order Number
              C03ORDT   = %CHAR(PHORDDAT);               // Order Date
              C03FDTR   = PHIDATE;                       // Order Received Date
              C03LDTR   = PHIDATE;                       // Order Changed Date
              C03SHPNO  = PHSHPNUM;                      // Ship To Number
              C03SHNME  = PHSHPNAM;                      // Ship To Name
              C03SHADR1 = PHSHPAD1;                      // Ship To Address 1
              C03SHADR2 = PHSHPAD2;                      // Ship To Address 2
              C03SHCTY  = PHSHPCTY;                      // Ship To City
              C03SHST   = PHSHPSTE;                      // Ship To State
              C03SHZP   = PHSHPZIP;                      // Ship To Zip
              C03SHPH   = PHSHPPHN;                      // Ship To Phone
              C03SHFX   = PHSHPFAX;                      // Ship To Fax
              C03SHEML  = PHSHPEML;                      // Ship To Email
              If PHFLAG = 'C' Or PHFLAG = 'P';
                 C03HDSTS = 'Processed';                 // Order Status
              Elseif PHFLAG = 'E';
                 C03HDSTS = 'Exception';
              Endif;
           Endif;

SUD01 *?   // Move values into Work Fields
  |        WkBrLn# = C03BRLN#;
SUD01      WkKpItm = C03KPITM;

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?                :--------------------------:
  |   *?                : DeclareCursor Subroutine :
  |   *?                :--------------------------:
  |   *
  |   *?Logic : Declare Cursor Based on Sorting
  |   *?
  |     Begsr DeclareCursor;
  |
  |   *?   // Sort By Sequence
  |        If FlSortS = False and FlSortB = False and WkSort = 0;
  |           Exec SQL
  |              DECLARE  A1 Cursor for
  |              Select CDHDRSEQ, CDSEQNO, CDBRKLNE, CDBRKMAT, CDVENDSC,
  |                   CDORDQTY, CDORDLIN, CDLNITMCM, CDKPITMCM, CDFLAG,
  |                   CDCRTDAT, CDCRTTIM
  |              From WSCODTLPF
  |              Where CDFRORID = :PVendor And CDBRKORID = :PVendorPO
  |                    And (CDBRKLNE = :C03BrLn# Or :C03BrLn# = ' ')
  |              ORDER BY CDHDRSEQ Desc ,CDSEQNO;
  |        Elseif FlSortS = True and FlSortB = False and WkSort = 0;
  |           Exec SQL
  |              DECLARE  A2 Cursor for
  |              Select CDHDRSEQ, CDSEQNO, CDBRKLNE, CDBRKMAT, CDVENDSC,
  |                   CDORDQTY, CDORDLIN, CDLNITMCM, CDKPITMCM, CDFLAG,
  |                   CDCRTDAT, CDCRTTIM
  |              From WSCODTLPF
  |              Where CDFRORID = :PVendor And CDBRKORID = :PVendorPO
  |                    And (CDBRKLNE = :C03BrLn# Or :C03BrLn# = ' ')
  |              ORDER BY CDHDRSEQ ,CDSEQNO;
  |
  |   *?   // Sort By Broker Line
  |        Elseif FlSortS = False and FlSortB = True and WkSort = 1;
  |           Exec SQL
  |              DECLARE  A3 Cursor for
  |              Select CDHDRSEQ, CDSEQNO, CDBRKLNE, CDBRKMAT, CDVENDSC,
  |                   CDORDQTY, CDORDLIN, CDLNITMCM, CDKPITMCM, CDFLAG,
  |                   CDCRTDAT, CDCRTTIM
  |              From WSCODTLPF
  |              Where CDFRORID = :PVendor And CDBRKORID = :PVendorPO
  |                    And (CDBRKLNE = :C03BrLn# Or :C03BrLn# = ' ')
  |              ORDER BY CDBRKLNE;
  |        Elseif FlSortS = False and FlSortB = False and WkSort = 1;
  |           Exec SQL
  |              DECLARE  A4 Cursor for
  |              Select CDHDRSEQ, CDSEQNO, CDBRKLNE, CDBRKMAT, CDVENDSC,
  |                   CDORDQTY, CDORDLIN, CDLNITMCM, CDKPITMCM, CDFLAG,
  |                   CDCRTDAT, CDCRTTIM
  |              From WSCODTLPF
  |              Where CDFRORID = :PVendor And CDBRKORID = :PVendorPO
  |                    And (CDBRKLNE = :C03BrLn# Or :C03BrLn# = ' ')
  |              ORDER BY CDBRKLNE Desc;
  |        Endif;
  |
  |   *?   // Open Cursor and Fetch Record
  |        If FlSortS = False and FlSortB = False and WkSort = 0;
  |           Exec Sql Open A1;
  |           If SqlCode = -502 ;
  |              Exec Sql Close A1;
  |              Exec Sql Open A1;
  |           Endif;
  |
  |           Exec Sql Fetch A1 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                 :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN,
  |                 :S03BRKCMT, :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
  |        Elseif FlSortS = True and FlSortB = False and WkSort = 0;
  |           Exec Sql Open A2;
  |           If SqlCode = -502 ;
  |              Exec Sql Close A2;
  |              Exec Sql Open A2;
  |           Endif;
  |
  |           Exec Sql Fetch A2 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                 :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN,
  |                 :S03BRKCMT, :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
  |        Elseif FlSortS = False and FlSortB = True and WkSort = 1;
  |           Exec Sql Open A3;
  |           If SqlCode = -502 ;
  |              Exec Sql Close A3;
  |              Exec Sql Open A3;
  |           Endif;
  |
  |           Exec Sql Fetch A3 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                 :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN,
  |                 :S03BRKCMT, :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
  |        Elseif FlSortS = False and FlSortB = False and WkSort = 1;
  |           Exec Sql Open A4;
  |           If SqlCode = -502 ;
  |              Exec Sql Close A4;
  |              Exec Sql Open A4;
  |           Endif;
  |
  |           Exec Sql Fetch A4 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
  |                 :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN,
  |                 :S03BRKCMT, :S03KPCMT, :H01Flag, :WkDate7, :WkTime;
  |        Endif;
  |
  |
  |     Endsr;
SUD01 //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : LoadPoRecords Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Load PO detail file records in subfile
      *?
        Begsr LoadPoRecords;

      *?   // Move values into Subfile
           If WkFlag = 'Y' and S03Rrn <> *Zeros;
              S03HSeq# = *Zeros;
              S03DSeq# = *Zeros;
              S03BRDes = '      *** PO Records ***';
              S03BRLN# = *Blanks;
              S03BRITM = *Blanks;
              S03BRQTY = *Zeros;
              S03KPORLN= *Zeros;
              S03BRKCMT= *Blanks;
              S03KPCMT = *Blanks;
              S03KPITM = *Blanks;
              S03KPSIZ = *Blanks;
              S03KPDES = *Blanks;
              S03KPQTY = *Zeros;
              S03Rrn  += 1;
              WkCount += 1;
              Dspf.S03SflDesRi = True;
              Write PODINQS03;
              Dspf.S03SflDesRi = False;
           Endif;

      *?   // Move values into Subfile
           Exec SQL
              DECLARE  B1 Cursor for
              Select PDHDRSEQ, PDSEQNO, PDBRKLNE, PDBRKMAT, PDVENDSC,
                  PDORDQTY, PDORDLIN, PDLNITMCM, PDKPITMCM, PDFLAG,
                  PDCRTDAT, PDCRTTIM
              From WSPODTLPF
              Where PDFRORID = :PVendor And PDBRKORID = :PVendorPO
                    And (PDBRKLNE = :C03BrLn# Or :C03BrLn# = ' ')
              ORDER BY PDHDRSEQ Desc ,PDSEQNO;

      *?   // Open Cursor
           Exec Sql Open B1;
           If SqlCode = -502 ;
              Exec Sql Close B1;
              Exec Sql Open B1;
           Endif;

           Exec Sql Fetch B1 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#, :S03BRITM,
               :S03BRDES, :S03BRQTY, :S03KPORLN, :S03BRKCMT, :S03KPCMT,
               :H01Flag, :WKDate7, :WkTime;

      *?   // Load Data into Subfile fields
           Dow SqlCod = 0 and WkCount < 9999;

      *?       // Write Subfile Display Part
               Dspf.S03SflDltRi = False;
               S03HSeq# = WkHSeq#;
               S03DSeq# = WkDSeq#;
               WkDate6= WkDate7;
               WkDate = %Date(WkDate6:*MDY);
               S03TIMEST= %Char(%Timestamp( %Char(WkDate) + '-'
                             + %Char(%Time(WkTime)) + '.000000' ));
               Chain (C03OrNo:S03KPORLN) FIORDR;
               If %Found;
                  S03KPITM = OIITEM;
                  S03KPSIZ = OISIZE;
                  S03KPDES = OIDES1;
                  S03KPQTY = OIQORD;
               Endif;
               If H01Flag = 'X';
                  Dspf.S03SflDltRi = True;
               Endif;

      *?       // Write Based on Filter
               If C03KpItm <> *Blanks;
                  If C03KpItm = S03KpItm;
                     S03Rrn  += 1;
                     WkCount += 1;
                     Write PODINQS03;
                  Endif;
               Else;
                  S03Rrn  += 1;
                  WkCount += 1;
                  Write PODINQS03;
               Endif;

               Exec Sql Fetch B1 into :WkHSEQ#, :WkDSEQ#, :S03BRLN#,
                   :S03BRITM, :S03BRDES, :S03BRQTY, :S03KPORLN, :S03BRKCMT,
                   :S03KPCMT, :H01Flag, :WKDate7, :WkTime;
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
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

      *?   // Open Main Screen
           C03BrLn# = PBrkLin;
           C03KpItm = PKpItem;

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
      *?---------------- End Of Subroutines --------------------------------
