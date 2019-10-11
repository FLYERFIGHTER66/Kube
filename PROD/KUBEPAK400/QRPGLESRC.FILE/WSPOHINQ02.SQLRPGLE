      *? Program        : WSPOHINQ02
      *?
      *? Description    : This pgm to PO Header History Inquiry Screen
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 03 Jan 2019
      //--------------------------------------------------------------------
      *? Special Notes  : ** Output subfile (Only for History Inquiry)
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
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes)
            DatFmt(*usa);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Display file for PO Header Inquiry Screen
        Dcl-F WSPOHINQFM Workstn Indds(Dspf) Sfile(POHINQS02:S02Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSPOHINQ02 ExtPgm;
           PVendor    Char(30);
           PVendorPo  Char(10);
           POrder     Packed(6);
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
        Dcl-S WkCount   Packed(4) Inz;
        Dcl-S WkHSeq#   Packed(9) Inz;
        Dcl-S WkFlag    Char(1)   Inz;
        Dcl-S WkSFlag   Char(1)   Inz;
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
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           S02SflDsp       Ind Pos(21);         // Subfile Display Ind
           S02SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S02SflClr       Ind Pos(23);         // Subfile Clear Ind
           S02SflEnd       Ind Pos(24);         // Subfile End Ind
           S02SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
           S02SflDrop      Ind Pos(11);         // Subfile Drop Ind
           S02SflDesRi     Ind Pos(30);         // Subfile Description Reverse Image
           S02SflDltRi     Ind Pos(31);         // Subfile Deleted Line Reverse Image
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
           Dspf.S02SflClr = True;                      // Clear Ind ON
           Dspf.S02SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write POHINQC02;

      *?   // Clear Rrn
           S02Rrn = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S02SflClr    = False;                  // Clear Ind OFF
           Dspf.S02SflDspCtl = True;                   // Display Control Ind ON

      *?   // Build Subfile
           Exsr SN1B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN1B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Control fields
      *?
        Begsr SN1B;

      *?   // Initialise Subfile fields and Indicator
           S02Rrn  = *Zeros;
           WkCount = *Zeros;
           WkFlag  = 'N';

      *?   // Get Record From CO Header File
           Exec SQL
              DECLARE  A1 Cursor for
              Select * from WSCOHDRL2
              Where CHFRORID = :PVendor And CHBRKORID = :PVendorPO
                    And CHORDNO = :POrder
              ORDER BY CHFRORID, CHBRKORID, CHORDNO,
                       CHCRTDAT, CHCRTTIM desc;

      *?   // If Record Found in CO File
           Exec Sql Open A1;
           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;
           Exec Sql Fetch A1 Into :WSCOHDRDS;
           If SqlCod = 0;
              WkFlag = 'Y';
           Endif;

      *?   // Get Record From PO Header File
           Exec SQL
               DECLARE  A2 Cursor for
               Select * from WSPOHDRL2
               Where PHFRORID = :PVendor And PHBRKORID = :PVendorPO
               ORDER BY PHFRORID, PHBRKORID, PHORDNO,
                     PHCRTDAT, PHCRTTIM desc;

      *?   // If Record Found in PO File
           Exec Sql Open A2;
           If SqlCode = -502 ;
              Exec Sql Close A2;
              Exec Sql Open A2;
           Endif;
           Exec Sql Fetch A2 Into :WSPOHDRDS;

      *?   // Load Control Part
           Exsr LoadCtlPart;

      *?   // Get Record From CO Header File
           If WkFlag = 'Y';
              Exec Sql Fetch A1 Into :WSCOHDRDS;

      *?      // Load Data into Subfile fields
              Dow SqlCod = 0 and WkCount < 9999;

      *?         // Increment RRN
                 Dspf.S02SflDltRi = False;
                 S02Rrn  += 1;
                 WkCount += 1;

      *?         // Write Subfile Display Part
                 Exsr LoadSflPart;
                 If S02HDSTS = 'Closed';
                    Dspf.S02SflDltRi = True;
                 Endif;
                 Write POHINQS02;
                 Exec Sql Fetch A1 Into :WSCOHDRDS;
              Enddo;
           Endif;

      *?   // Load PO Records in Subfile
           Exsr LoadPoRecords;

      *?   // Subfile End Indicator ON
           Dspf.S02SflEnd = *On;

      *?   // Check RRN and Show Subfile
           If S02Rrn <> *Zeros;
              Dspf.S02SflDsp = True;
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
           Write POHINQF02;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt POHINQC02;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F11 Pressed
              When Dspf.S02SflDrop;
                 FunReq = 'DISPLAY';

      *?      // F12 Pressed
              When Dspf.Cancel;
                 ModReq = 'EXIT';

      *?      // Other Pressed
              Other;
                 FunReq = 'DISPLAY';
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

      *?   // Move values into Contorl part fields
           If WkFlag = 'Y';
              C02PONO   = PVendorPO;                     // Vendor PO
              C02ORNO   = POrder;                        // Order Number
              C02ORDT   = %CHAR(CHORDDAT);               // Order Date
              C02FDTR   = PHIDATE;                       // Order Received Date
              C02SEQ#   = CHSEQNO;                       // Order Header Seq#
              C02LDTR   = CHIDATE;                       // Order Changed Date
              C02SHPNO  = CHSHPNUM;                      // Ship To Number
              C02SHNME  = CHSHPNAM;                      // Ship To Name
              C02SHADR1 = CHSHPAD1;                      // Ship To Address 1
              C02SHADR2 = CHSHPAD2;                      // Ship To Address 2
              C02SHCTY  = CHSHPCTY;                      // Ship To City
              C02SHST   = CHSHPSTE;                      // Ship To State
              C02SHZP   = CHSHPZIP;                      // Ship To Zip
              C02SHPH   = CHSHPPHN;                      // Ship To Phone
              C02SHFX   = CHSHPFAX;                      // Ship To Fax
              C02SHEML  = CHSHPEML;                      // Ship To Email
              If CHFLAG = 'C' Or CHFLAG = 'P';
                 C02HDSTS = 'Processed';                 // Order Status
              Elseif CHFLAG = 'E';
                 C02HDSTS = 'Exception';
              Elseif CHFLAG = 'X';
                 C02HDSTS = 'Closed';
              Endif;
           Else;
              C02PONO   = PVendorPO;                     // Vendor PO
              C02ORNO   = POrder;                        // Order Number
              C02ORDT   = %CHAR(PHORDDAT);               // Order Date
              C02FDTR   = PHIDATE;                       // Order Received Date
              C02SEQ#   = PHSEQNO;                       // Order Header Seq#
              C02LDTR   = PHIDATE;                       // Order Changed Date
              C02SHPNO  = PHSHPNUM;                      // Ship To Number
              C02SHNME  = PHSHPNAM;                      // Ship To Name
              C02SHADR1 = PHSHPAD1;                      // Ship To Address 1
              C02SHADR2 = PHSHPAD2;                      // Ship To Address 2
              C02SHCTY  = PHSHPCTY;                      // Ship To City
              C02SHST   = PHSHPSTE;                      // Ship To State
              C02SHZP   = PHSHPZIP;                      // Ship To Zip
              C02SHPH   = PHSHPPHN;                      // Ship To Phone
              C02SHFX   = PHSHPFAX;                      // Ship To Fax
              C02SHEML  = PHSHPEML;                      // Ship To Email
              If PHFLAG = 'C' Or PHFLAG = 'P';
                 C02HDSTS = 'Processed';                 // Order Status
              Elseif PHFLAG = 'E';
                 C02HDSTS = 'Exception';
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : LoadSflPart Subroutine :
      *?                :------------------------:
      *
      *?Logic : Load Subfile Part based on input parameters
      *?
        Begsr LoadSflPart;

      *?   // Move values into Subfile part fields
           If WkFlag = 'Y';
              S02SEQ#   = CHSEQNO;                       // Header Sequence
              S02ORNO   = CHORDNO;                       // Order Number
              S02ORDT   = %CHAR(CHORDDAT);               // Order Date
              S02LDTR   = CHIDATE;                       // Order Changed Date
              S02SHPNO  = CHSHPNUM;                      // Ship To Number
              S02SHNME  = CHSHPNAM;                      // Ship To Name
              S02SHADR1 = CHSHPAD1;                      // Ship To Address 1
              S02SHADR2 = CHSHPAD2;                      // Ship To Address 2
              S02SHCTY  = CHSHPCTY;                      // Ship To City
              S02SHST   = CHSHPSTE;                      // Ship To State
              S02SHZP   = CHSHPZIP;                      // Ship To Zip
              S02SHPH   = CHSHPPHN;                      // Ship To Phone
              S02SHFX   = CHSHPFAX;                      // Ship To Fax
              S02SHEML  = CHSHPEML;                      // Ship To Email
              If CHFLAG = 'C' Or CHFLAG = 'P';
                 S02HDSTS = 'Processed';                 // Order Status
              Elseif CHFLAG = 'E';
                 S02HDSTS = 'Exception';
              Elseif CHFLAG = 'X';
                 S02HDSTS = 'Closed';
              Endif;
           Else;
              S02SEQ#   = PHSEQNO;                       // Header Sequence
              S02ORNO   = PHORDNO;                       // Vendor PO
              S02ORDT   = %CHAR(PHORDDAT);               // Order Date
              S02LDTR   = PHIDATE;                       // Order Changed Date
              S02SHPNO  = PHSHPNUM;                      // Ship To Number
              S02SHNME  = PHSHPNAM;                      // Ship To Name
              S02SHADR1 = PHSHPAD1;                      // Ship To Address 1
              S02SHADR2 = PHSHPAD2;                      // Ship To Address 2
              S02SHCTY  = PHSHPCTY;                      // Ship To City
              S02SHST   = PHSHPSTE;                      // Ship To State
              S02SHZP   = PHSHPZIP;                      // Ship To Zip
              S02SHPH   = PHSHPPHN;                      // Ship To Phone
              S02SHFX   = PHSHPFAX;                      // Ship To Fax
              S02SHEML  = PHSHPEML;                      // Ship To Email
              If PHFLAG = 'C' Or PHFLAG = 'P';
                 S02HDSTS = 'Processed';                 // Order Status
              Elseif PHFLAG = 'E';
                 S02HDSTS = 'Exception';
              Elseif PHFLAG = 'X';
                 S02HDSTS = 'Closed';
              Endif;
           Endif;

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
           If WkFlag = 'Y';
              S02Seq#  = *Zeros;
              S02ORNO  = *Zeros;
              S02ORDT  = *Blanks;
              S02LDTR  = *Blanks;
              S02HDSTS = *Blanks;
              S02SHPNO = '*** PO Records ***';
              S02SHNME = *Blanks;
              S02SHADR1= *Blanks;
              S02SHADR2= *Blanks;
              S02SHCTY = *Blanks;
              S02SHST  = *Blanks;
              S02SHPH  = *Blanks;
              S02SHZP  = *Blanks;
              S02SHFX  = *Blanks;
              S02SHEML = *Blanks;
              S02Rrn  += 1;
              WkCount += 1;
              Dspf.S02SflDesRi = True;
              Write POHINQS02;
              Dspf.S02SflDesRi = False;
           Endif;

      *?   // Write PO Record
           If WkFlag = 'Y';
              WkFlag = 'N';
           Endif;
           Exsr LoadSflPart;
           S02Rrn  += 1;
           WkCount += 1;
           If S02HDSTS = 'Closed';
              Dspf.S02SflDltRi = True;
           Endif;
           Write POHINQS02;
           Exec Sql Fetch A2 Into :WSPOHDRDS;

      *?   // Load Data into Subfile fields
           Dow SqlCod = 0 and WkCount < 9999;

      *?      // Increment RRN
              Dspf.S02SflDltRi = False;
              Exsr LoadSflPart;
              S02Rrn  += 1;
              WkCount += 1;
              If S02HDSTS = 'Closed';
                 Dspf.S02SflDltRi = True;
              Endif;
              Write POHINQS02;

      *?      // Write Subfile Display Part
              Exec Sql Fetch A2 Into :WSPOHDRDS;

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
