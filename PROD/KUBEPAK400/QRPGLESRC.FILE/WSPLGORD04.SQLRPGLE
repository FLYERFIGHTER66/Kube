      *? Program        : WSPLGORD04
      *?
      *? Description    : This pgm to Create Plug Order for the Customer
      *?
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 24 Jul 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** From the Subfile based on Requested ship date Order
      *?                     will be Created line by line on F6 - Order Create
      *?                  ** F6 - To create Order for each date
      *?                  ** On Cursor in Order# BIR100CLO will be called
      *?
      *? Called Program : WSPLGORCRT - WS - Plug Order Entry Batch Program
      *?                : WSSFLMSG   - WS - Send and Clear message from subfile
      *?                : BIR100CLO  - Order Entry - Pass in Order Number for Change
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
        Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Plug Order Work File - Build XML
        Dcl-F WPLGORXML Disk(*Ext) Usage(*Output:*Update);
      *?Key : Customer Number : Requested Ship Date
        Dcl-F WPLGORXML0 Disk(*Ext) Keyed Usage(*Input) Rename(WPLGORXMLR:Rec)
                                                Prefix(I);
      *?File: Display file for Plug Order Entry Program
        Dcl-F WSPLG004FM Workstn Indds(Dspf) Sfile(PLGSFL4:S04Rrn);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSPLGORD03)
        Dcl-Pi WSPLGORD04;
           PCust#  Packed(6);
           PSts    Char(2);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Order Create Batch Program
        Dcl-Pr WSPLGORCRT  ExtPgm;
           PCust#  Packed(6);
           PReqDte Packed(8);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Order Change Program
        Dcl-Pr BIR100CLO  ExtPgm;
           POrder# Packed(6);
           PSeq#   Packed(3);
        End-Pr;
      *
      *?Procedure Prototype Declaration : CL Program for Message Subfile
        Dcl-Pr WSSFLMSG  ExtPgm;
           PMsgf  Char(10);
           PMsgId Char(7);
           POpt   Char(1);
        End-Pr;
      *
      *?Data Structure :
        Dcl-Ds SflRec Qualified;
           Item    Char(5);
           Size    Char(3);
           Desc    Char(30);
           Alpha   Char(15);
           Price   Packed(6:2);
           ReqDte  Date(*ISO);
           Ordqty  Packed(4);
        End-Ds;
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
        Dcl-S ModReq    Char(10)  Inz;
        Dcl-S FunReq    Char(10)  Inz;
      *
      *?Work Variable Declaration :
        Dcl-S WkCount  Zoned(5:0)   Inz;
        Dcl-S WkCustNa Char(30)     Inz;
        Dcl-S WkSvia   Char(2)      Inz;
        Dcl-S WkDesc   Char(30)     Inz;
        Dcl-S WkRrn    Like(S04Rrn) Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PMsgf   Char(10);
        Dcl-S PMsgId  Char(7);
        Dcl-S POpt    Char(1);
        Dcl-S POrder# Packed(6);
        Dcl-S PReqDte Packed(8);
        Dcl-S PSeq#   Packed(3);
      *
      *?Flag Variables Declaration :
        Dcl-S FlError  Ind Inz(*Off);
        Dcl-S FlExit   Ind Inz(*Off);
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
      *
      *?Subfile Indicators Declaration :
        Dcl-Ds Dspf Qualified;
           Exit            Ind Pos(3);          // Exit Function Key
           Create          Ind Pos(6);          // Create Order Function Key
           Cancel          Ind Pos(12);         // Cancel Function Key
      *
           S04SflDsp       Ind Pos(21);         // Subfile Display Ind
           S04SflDspCtl    Ind Pos(22);         // Subfile Display Control Ind
           S04SflClr       Ind Pos(23);         // Subfile Clear Ind
           S04SflEnd       Ind Pos(24);         // Subfile End Ind
           S04SflNxtChg    Ind Pos(25);         // Subfile Next Change Ind
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
                 Exsr SN4M;
              Enddo;

           Enddo;

      *?   // End Program
           Exec Sql
             Set Option CLOSQLCSR=*ENDMOD;
           *InLr = *On;
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

      *?   // Clear Subfile
           Dspf.S04SflClr = True;                      // Clear Ind ON
           Dspf.S04SflDsp = False;                     // Display Ind OFF

      *?   // Write Control Part
           Write PLGCTL4;

      *?   // Clear Rrn and Flag
           FlError = False;
           S04Rrn = *Zeros;

      *?   // Clear Indicator Off
           Dspf.S04SflClr    = False;                  // Clear Ind OFF
           Dspf.S04SflDspCtl = True;                   // Display Control Ind ON

      *?   // Build the Subfile
           Exsr SN4B;
           FunReq = 'DISPLAY';

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------:
      *?                : SN4B Subroutine :
      *?                :-----------------:
      *
      *?Logic : Build Subfile based on Inventory Temp File
      *?
        Begsr SN4B;

      *?   // Initialise Rrn and Count
           S04Rrn  = *Zeros;
           WkCount = *Zeros;

      *?   // Execute Sql to get Subfile Records
           Exec Sql Declare A1 Cursor for
           Select WPDTE1, Sum(WPOQTY1) From WPLGORDL0
           Group by WPDTE1
           Order by WPDTE1;

      *?   // Open Cursor
           Exec Sql
              Open A1;
              If SqlCode = -502 ;
                 Exec Sql
                 Close A1;
                 Exec Sql
                 Open A1;
             EndIf;

      *?   // Load Subfile
           Exec Sql Fetch A1 Into :S04REQDTE, :S04TOTTRY;
           Dow SqlCod = 0 and WkCount < 9999;
              If S04TOTTRY <> *Zeros;

      *?         // Increment RRN
                 S04Rrn  += 1;
                 WkCount += 1;
                 S04Cust  = PCust#;
                 S04Name  = WkCustNa;
                 S04Svia  = WkDesc;
                 PReqDte = %Dec(%Char(S04ReqDte:*ISO0):8:0);
                 Chain (PCust#:PReqDte) WPLGORXML0;
                 If IWXORDNO <> *Zeros;
                    S04Order = %Char(IWXORDNO);
                 Else;
                    S04Order = *Blanks;
                 Endif;
                 Write PLGSFL4;
              Endif;
              Exec Sql Fetch A1 Into :S04REQDTE, :S04TOTTRY;
           Enddo;

      *?   // Close Cursor
           Exec Sql Close A1;
           Dspf.S04SflEnd = *On;

      *?   // Check RRN and Show Subfile
           If S04Rrn <> *Zeros;
              Dspf.S04SflDsp = True;
           Else;

      *?      // No Records Found
              PMsgId = 'WS00030';
              Exsr Sendmessage;
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
           Write PLGFTR4;

      *?   // Write the Message Subfile Control Part
           Write MsgCtl;

      *?   // Write the Subfile Control Part
           Exfmt PLGCTL4;

      *?   // Clear Message
           Exsr ClearMessage;

      *?   // Check for Function Keys
           Select;

      *?      // F3 Pressed
              When Dspf.Exit;
                 ModReq = 'EXIT';
                 PSts = '03';

      *?      // F6 Pressed
              When Dspf.Create;
                 Exsr OrderCreateSr;
                 FunReq = 'INITIAL';

      *?      // F12 Pressed
              When Dspf.Cancel;
                 If FlExit = True;
                    ModReq = 'EXIT';
                    PSts = '03';
                 Else;
                    ModReq = 'EXIT';
                    PSts = '12';
                 Endif;

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
      *?Logic : Validate Cursor Position in subfile part
      *?      : If No errors then Process , Else Display error in Screen
      *?
        Begsr SN4V;

      *?   // Initialise Indicators
           FlError  = False;

      *?   // Validate Cursor Position on Subfile Display Part
           If Dspf.S04SflDsp;

      *?      // Validate Cursor RRN
              If CSRRRN  = *Zeros;
                 FlError = True;
                 PmsgId  = 'WS00031';
                 Exsr SendMessage;
              Elseif CSRRRN <> *Zeros;
                 If S04Order = *Blanks;
                    FlError = True;
                    PmsgId  = 'WS00078';
                    Exsr SendMessage;
                 Endif;
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
      *?                : SN4P Subroutine :
      *?                :-----------------:
      *
      *?Logic : Process Non Error Screen Inputs
      *?
        Begsr SN4P;

      *?   // Read Cursor Positioned record and Process based on RRN & Order No
           If Dspf.S04SflDsp;
              Chain CSRRRN PLGSFL4;
              If %Found;

      *?         // If Order Number Exists Process Change Order
                 PSeq# = *Zeros;
                 POrder# = %Int(S04Order);
                 BIR100CLO(POrder#:PSeq#);
              Endif;
           Endif;
           FunReq = 'INITIAL';
           ModReq = 'SCREEN';

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

      *?   // Get Customer Name
           WkCustNa = *Blanks;
           Exec Sql
              Select CMNAME, CMSVCD into :WkCustNa, :WkSvia From FMCUST Where
              CMCUST = :PCust#;

      *?   // Get ShipVia Description
           WkDesc = *Blanks;
           Exec Sql
              Select SVDESC into :WkDesc From FMSVIA Where
              SVCODE = :WKSvia;

      *?   // Open Main Screen
           ModReq = 'SCREEN';
           FunReq = 'INITIAL';

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------------:
      *?                : OrderCreateSr Subroutine :
      *?                :--------------------------:
      *
      *?Logic : Read Subfile Records one by one and Create Order
      *?
        Begsr OrderCreateSr;

      *?   // Read Line by Line and Process the Order by Requested Ship Date
           For WkRrn = 1 to WkCount;
              Chain WkRrn PLGSFL4;
              If %Found;

      *?         // Write into XML File
                 If S04ORDER = *Blanks;
                    Exsr WriteXmlSr;

      *?            // Call Batch Program
                    PReqDte = %Dec(%Char(S04ReqDte:*ISO0):8:0);
                    POrder# = *Zeros;
                    FlExit = True;
                    WSPLGORCRT(S04Cust:PReqDte);
                 Endif;
              Else;
                 Leave;
              Endif;
           Endfor;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : WriteXmlSr Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Read Inventory File and Write into XML File
      *?
        Begsr WriteXmlSr;

      *?   // Execute Sql to get Inventory Records
           Exec Sql Declare A2 Cursor for
              Select WPITEM, WPSIZE, WPDES1, WPLOOK, WPPRICE, WPDTE1, WPOQTY1
              From WPLGORDL0
              Where WPOQTY1 <> 0 and  WPDTE1 = :S04ReqDte;

      *?   // Open Cursor
           Exec Sql
              Open A2;
              If SqlCode = -502 ;
                 Exec Sql
                 Close A2;
                 Exec Sql
                 Open A2;
             Endif;

      *?   // Load Subfile
           Exec Sql Fetch A2 into :SflRec;
           Dow SqlCod = 0;

      *?      // Clear Record
              Clear WPLGORXMLR;

      *?      // Move Values into XML File
              WXCUST = PCust#;
              WXITEM = SflRec.Item;
              WXSIZE = SflRec.Size;
              WXDES1 = SflRec.Desc;
              WXLOOK = SflRec.Alpha;
              WXPRICE= SflRec.Price;
              WXRQDTE= %Int(%Char(SflRec.ReqDte:*ISO0));
              WXOQTY = SflRec.Ordqty;
              WXORDNO= *Zeros;

              Write WPLGORXMLR;
              Exec Sql Fetch A2 into :SflRec;
           Enddo;

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
