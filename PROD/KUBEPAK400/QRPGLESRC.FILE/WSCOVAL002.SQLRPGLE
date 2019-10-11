      *? Program        : WSCOVAL002
      *?
      *? Description    : This pgm to Validate fields from Xml reference files
      *?                  and Process Change Order
      *? Created By     : Reddaiah N.P / S.Uthayadurga
      *?
      *? Date           : 17 Oct 2017
      //--------------------------------------------------------------------
      *? Special Notes  : ** Check Order number for Customer PO in XML PO files
      *?                     If Exists allow for change order or Marked as 'X'
      *?                  ** XML data to be validated before Change Order Update
      *?                  ** Read Order Change Control File WSORCHCPF to check,
      *?                     if order can be changed or not
      *?                  ** Order Not passing validation will put into
      *?                     Exception File
      *?                  ** If Available quantity less Requested Qty, Process
      *?                     for Avl quanity and write INFO into Error Exp File
      *
      *? Called Program : GETGERM   - Get Sow Date from Requested Date WEEK #/DATE
      *?                  WSRTVMSG  - WS - Retrieve message from Message file
      *?                  GETAVLINV - Get Available Inventory (Plugs)
      *?                  ALCLOTINV - Process Lot Inventory Allocation Request
      *?                  INVAVLSTS - Inventory Availability Status
      *
      *? Response       : PHFLAG - Process Flag('C' - Order Created)
      *?                                       ('E' - Marked as Exception)
      *?                                       ('X' - Marked as Delete)
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * WJB01   02/01/18   W.J.Behr     Write record to FHORDRHIST on upd/add
      * WJB02   02/19/18   W.J.Behr     Add Logic for OILOTC.  Change PI for ALC
      * WJB03   03/20/18   W.J.Behr     Add Logic for EndPgm.
      *?Phase II changes
      * SUD01   03/21/18   S.Uthaya     Check Contorl File with OISEQ# = '0'
      * SUD02   03/21/18   S.Uthaya     Re-Visit cancelled Item
      * SUD03   03/23/18   S.Uthaya     If there is a Header change, Update
      *                                 Detail file also
      * SUD04   03/27/18   S.Uthaya     Added parameter in ALCLOTINV
      *         03/29/18   S.Uthaya     Added parameter in GETAVLINV
      * SUD05   05/22/18   S.Uthaya     Requested ship date converted into Monday date
      *                                 for Inventory Programs
      * SUD06   08/23/18   S.Uthaya     Update the File Flag and Message
      *                                 in Exception File
      * VV01    10/09/18   Vimala       Round Off Ordered Quantity for Partials
      * SUD07   10/16/18   S.Uthaya     Get SOW date from the program
      * SUD08   11/09/18   S.Uthaya     For Not Authorized Item, Don't write into
      *                                 Exception , Write FIORDR Line With Status "D"
      *                                 and Quantity Zero (CANCELLED - Change VV07)
      * VV02    12/14/18   Vimala       Do not change OHDTOR field in FHORDR for Order Change
      * SUD09   12/27/18   S.Uthaya     If deleted line cause any problem during
      *                                 change order, Skip the line and process Order
      * VV03    01/04/19   Vimala       If Req Date Changed and Qty is available, write a blank
      *                                 comment record in FIORDRB2BC file to send in LineItecomment
      *                                 LineItemComment field in Broker Acknowledgment
      * VV04    01/07/19   Vimala       If Req Date in Change Order is same as Req Date in Create
      *                                 Order, allow to change the order to include New Lines
      *                                 even if all lines in WSORCHCPF file is 'N'. WSORCHCPF flag
      *                                 is checked for each line in OrderUpdate subroutine
      * VV05    01/09/19   Vimala       If Req Date is same, Order/Line in WSORCHCPF='N', if 0 Seq
      *                                 is not found in WSORCHCPF, if CDORDQTY > OIQORD, and if
      *                                 diff qty is avl from GETAVLINV,then increment qty for line
      * SUD10   01/16/19   S.Uthaya     If Incoming type = 'C' and Qty = 0 , Clear Orderline = 0
      *                                 (Bug Fixing)
      * VV06    01/18/19   Vimala       Compare ReqShipDate with FHORDR ReqShipDate and not from
      *                                 WSPOHDRPF file.
      *                                 If Order/Line has partial quantity allow to process Order -
      *                                 Do not send order to Error Exception if WkPart='Y'. Retain
      *                                 original quantity for partial line
      * VV06    01/24/19   Vimala       Compare ShipNumber and ShipMethod also from FHORDR instead
      *                                 of WSPOHDRPF file
      * VV07    02/05/19   Vimala       Do not check for Item Authorisation. Call INVAVLSTS program
      *                                 only if Confirmed Qty < Ordered Qty. Write a record in
      *                                 FIORDRB2BC file. Do not write record for same ReqShipDate
      *                                 and OCORFLG='N' for Qty < Ordered qty (Change VV05)
      * VV08    02/15/19   Vimala       If Ordered qty=0 and OCORFLG='N', do not update orderline
      * VV09    02/19/19   Vimala       Pass full qty to ALCLOTINV and not the diff qty
      * VV10    02/28/19   Vimala       Check flag for new lines added in xml file
      * SUD11   06/25/19   S.Uthaya     Added Command Line Logic
      //----------------------------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*Usa);
        /COPY QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - XML Create Order Header Logical File
      *?Key : From Org ID:Customer PO
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - XML Change Order Header Logical File
      *?Key : From Org ID:Customer PO:Header Seq No
        Dcl-F WSCOHDRL1  Disk(*Ext) Keyed Usage(*Output:*Update);
      *
      *?File: WS - Xml Order Detail Logical File
      *?Key : From Org ID:Customer PO:Header Seq No:Detail Seq No
        Dcl-F WSCODTLL0  Disk(*Ext) Keyed Usage(*Update);
      *
      *?File: Cross Reference File for FMCUST
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFCUSTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Cross Reference File for FMINVT
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFINVTL0 Disk(*Ext) Keyed Usage(*Input) Prefix(I);
      *
      *?File: Cross Reference File for FMSVIA
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFSVIAL0 Disk(*Ext) Keyed Usage(*Input) Prefix(S);
      *
      *?File: Xml Order Error Exception File
      *?Key : BrokerName:Customer PO
        Dcl-F WSERREXPL0 Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: M/F Customer Master File
      *?Key : Customer Number
        Dcl-F FMCUST     Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Item Master File
      *?Key : Item Number:Item Size
        Dcl-F FMINVT     Disk(*Ext) Keyed Usage(*Update);
      *
      *?File: M/F Terms Code Master File
      *?Key : Term Code
        Dcl-F FMTERM     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Tax Jurisdiction Master File
      *?Key : Tax Jurisdiction
        Dcl-F FMTAXF     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Ship Via Code Master File
      *?Key : Ship Via Code
        Dcl-F FMSVIA     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Size Code Master File
      *?Key : Size Code
        Dcl-F FMSIZE     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Open Order By Value Order File
      *?Key : Order Number
        Dcl-F FPPO       Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order User Information File
      *?Key : Order Number
        Dcl-F FOPNORD    Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order Header Record
      *?Key : Order #
        Dcl-F FHORDR     Disk(*Ext) Keyed Usage(*Update:*Output);
        Dcl-F FHORDRHIST Disk(*Ext) Usage(*Output);
      *
      *?File: Order Detail Record
      *?Key : Order Number:Order Seq#
        Dcl-F FIORDR     Disk(*Ext) Keyed Usage(*Input) Prefix(X)
                                                Rename(RIORDR:Rec1);
        Dcl-F FIORDRPART Disk(*Ext) Keyed Usage(*Input) Prefix(H);
      *
      *?Key : Order Number:List Code
        Dcl-F FIORDRL15  Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order Change Control Logical File
      *?Key : Order Number:Order Line Number:Broker Line Item Number
        Dcl-F WSORCHCL0  Disk(*Ext) Keyed Usage(*Update:*Output);
      *
      *?File: Order Change Control Logical File
      *?Key : Broker Name:Broker Order Id:Header Seq No
        Dcl-F WSORCHCL1  Disk(*Ext) Keyed Usage(*Input)
                              Rename(WSORCHCR:REC3) Prefix(Z);
VV03  *?File: Order Detail B2B Coments
  |   *?Key : Order Number: Order Line:TimeStamp(D)
VV03    Dcl-F FIORDRB2B1 Disk(*Ext) Keyed Usage(*Output);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSCOVAL002;
           PFromOrgId Like(CHFRORID);
           PCustPO    Like(CHBRKORID);
           PSeqno     Like(CHSEQNO);
           PFlag      Like(CHFLAG);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Call Rpg program to Get Avail Qty
        Dcl-Pr GETAVLINV Extpgm;                        // Rpg Program
           Item      Char(12)    Const;                 // Item
           Size      Char(3)     Const;                 // Size
           Mondaydte Date        Const;                 // ReqShipDate
           ReqQty    Zoned(11:2) Const;                 // Requested Qty
           AvlQty    Zoned(11:2);                       // Available Qty
           Lot_Flag  Char(1);
SUD04      WkParInd  Ind;
        End-Pr;
      *
      *?Procedure Prototype Declaration : Call Rpg program to Get Allocate Qty
        Dcl-Pr ALCLOTINV Extpgm;                        // Rpg Program
           OrderNumber     Zoned(6:0)  Const;           // Order Number
           OrderSequence   Zoned(3:0)  Const;           // Order Seq
           CustomerNumber  Zoned(6:0)  Const;           // Customer #
           Item            Char(12)    Const;           // Item
           Size            Char(3)     Const;           // Item Size
           MondayDate      Date        Const;           // Date
           QtyToAllocate   Zoned(11:2) Const;           // Qty to Allocate
           Allocated       Zoned(11:2);                 // Allocated
           Lot_Flag        Char(1);
SUD04      WkParInd        Ind;
        End-Pr;
      *
SUD08 *?Procedure Prototype Declaration : Check on the Inventory availability status
  |     Dcl-Pr INVAVLSTS Extpgm;                   // Rpg Program
  |        Item          Char(12);                 // Item
  |        Size          Char(3);                  // Size
  |        ThisDate      Like(RqToday);            // Ready Date
  |        ThisType      Char(10);                 // Plug-View-Type
  |        ErrorNumber   Zoned(1:0);               // Error
  |        ErrDesc       Char(10);                 // Error Description
SUD08   End-Pr;
      *
      *?Procedure Prototype Declaration : Call CL program to Retreive MSG
        Dcl-Pr RtvErrMsg Extpgm('WSRTVMSG');            // CL Program
           WkMsgId  Char(7);                            // Msg Id
           WkMsgF   Char(10);                           // Msg File
           WKMsg    Char(132);                          // Msg Data
           WkDta    Char(10);
        End-Pr;
      *
SUD07 *?Procedure Prototype Declaration : Get Sow Date from Req Date WEEK#/DATE
  |     Dcl-Pr GETGERM Extpgm('GETGERM');
  |        PItem    Like(IMITEM);
  |        PSize    Like(IMSIZE);
  |        PWhse    Like(IMWHSE);
  |        PReqDte  Packed(7:0);                        // CYMD
  |        PSowDte  Packed(7:0);                        // CYMD
SUD07   End-Pr;
      *
      *?Procedure Prototype Declaration : To Get Comment for Detail file
        Dcl-Pr $Comment  Extpgm;
           PrOrdNo  Packed(6);                          // Order Number
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
      *?Data Structure for Zip Code     :
        Dcl-Ds WkZipC Qualified;
           WkChar5    Char(5) Pos(1);
           WkChar4    Char(4) Pos(7);
        End-Ds;
      *
      *?Work Variables Declaration      :
        Dcl-S WkMsg     Char(132)   Inz;             // Used for Msg File
        Dcl-S WkMsgf    Char(10)    Inz;             // Used for Msg File
        Dcl-S WkDta     Char(10)    Inz;             // Used for Msg File
SUD08   Dcl-S ThisType  Char(10)    Inz;             // Plug-View-Type
SUD08   Dcl-S ErrDesc   Char(40)    Inz;             // Error Description
        Dcl-S WkOrdLin  Char(4)     Inz;             // Orderline
        Dcl-S WkSvia    Char(2)     Inz;             // Used for SVIA Xref
        Dcl-S WkMsgId   Char(7)     Inz;             // Used for Msg File
        Dcl-S WkProc    Char(1)     Inz;
        Dcl-S WkFirst   Char(1)     Inz;             // Used for Msg File
        Dcl-S WkChar5   Char(5)     Inz;
        Dcl-S WkChar4   Char(4)     Inz;
        Dcl-S WkFound   Char(1)     Inz;             // Used for Msg File
        Dcl-S WkLotC    Char(1)     Inz;
        Dcl-S WkQty     Zoned(11:2) Inz;             // Used for GetavlInv
        Dcl-S WkTotQty  Zoned(12:2) Inz;             // Used for Msg File
        Dcl-S WkOQty    Zoned(11:2) Inz;             // Used for Qty Conversion
        Dcl-S WkOrdQty  Zoned(11:2) Inz;             // Used for Qty Conversion
VV01    Dcl-S WkOrdQty1 Zoned(11:0) Inz;             // Used for Remainder function
VV05    Dcl-S WkAddQty  Zoned(11:2) Inz;             // Used for Qty Conversion
VV05    Dcl-S WkDifQty  Zoned(11:2) Inz;             // Used for Qty Conversion
SUD08   Dcl-S Error     Zoned(1:0)  Inz;             // Error
        Dcl-S WkCount   Zoned(2)    Inz;             // Count
        Dcl-S WkOrdNo   Zoned(6)    Inz;             // Order Number
        Dcl-S WkCust    Zoned(6)    Inz;             // Used for Cust Xref
        Dcl-S WkErSeq   Zoned(6)    Inz;             // Used for Msg File
VV01    Dcl-S WkRem     Zoned(5)    Inz;             // Used for Rounding Off
        Dcl-S WkDte     Date(*Usa)  Inz;             // Used for GetavlInv
SUD04   Dcl-S WkParInd  Ind;                         // Used for Partial Order Indicator
      *
      *?Flag Variables Declaration      :
        Dcl-S WkFlag   Char(1)  Inz;                // Order Create Flag
        Dcl-S EFlag    Char(1)  Inz;                // Error Flag
        Dcl-S FFlag    Char(1)  Inz;                // File Flag
SUD11   Dcl-S WkLinF   Char(1)  Inz;                // Order Line Flag
        Dcl-S WkPart   Char(1)  Inz('N');           // Order found in FIORDRPART
SUD01   Dcl-S WkElgFlg Char(1)  Inz('N');           // Order Change Eligible Flg
SUD02   Dcl-S WkUpdate Char(1)  Inz('N');           // Re-Visit cancelled Item
SUD03   Dcl-S WkDtlUpd Char(1)  Inz('N');           // Update Detail for Header Change
VV05    Dcl-S WkDtEFlg Char(1)  Inz('N');           // Req Date is Equal set flag to 'Y'
VV05    Dcl-S WkAddQFg Char(1)  Inz('N');           // Flag to add qty to OIQRD
VV06    Dcl-S WkSHPC   Char(2)  Inz(' ');           // Ship Via Code
VV10    Dcl-S WkNewLn  Char(1)  Inz('N');           // Used for Qty check
      *
      *?Function Variables Declaration  :
        Dcl-S Today          Date;
        Dcl-S RqToday        Date;
        Dcl-S Now            Zoned(6) Inz;
        Dcl-S TodayMDY       Zoned(6) Inz;
        Dcl-S TodayYMD7      Zoned(7) Inz;
        Dcl-S ThisMonday     Zoned(6) Inz;
        Dcl-S ThisMonCYMD    Zoned(7) Inz;
        Dcl-S RqTodayMDY     Zoned(6) Inz;
        Dcl-S RqTodayYMD7    Zoned(7) Inz;
        Dcl-S RqThisMonday   Zoned(6) Inz;
        Dcl-S RqThisMonCYMD  Zoned(7) Inz;
VV06    Dcl-S RqMonMDY       Zoned(6) Inz;
      *
      *?Calculation Variables Declaration:
        Dcl-S Tax1        Zoned(5:2) Inz;
        Dcl-S Tax2        Zoned(5:2) Inz;
        Dcl-S Tax3        Zoned(5:2) Inz;
        Dcl-S TotalTax01  Zoned(7:2) Inz;
        Dcl-S TotalTax02  Zoned(7:2) Inz;
        Dcl-S TotalTax03  Zoned(7:2) Inz;
        Dcl-S TotalOrder  Zoned(9:2) Inz;
      //--------------------------------------------------------------------
      *?                :--------------:
      *?                : Copy  Source :
      *?                :--------------:
      *
      *?Service Programs
    ? /COPY QFunctDefn,$Date
    ? /COPY QFunctDefn,$Date7
    ? /COPY QFunctDefn,$MDYDate
    ? /COPY QFunctDefn,$Monday
    ? /COPY QFunctDefn,$GetOrder#
    ? /COPY QFunctDefn,$UnitPrice
    ? /COPY QFunctDefn,$Now
    ? /COPY QFunctDefn,$TimeStamp
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line

      *?   // Initialise
           Exsr InzPgm;

      *?   // Get WS Change Order Header File Record
           Chain (PFromOrgId:PCustPO:PSeqno) WSCOHDRL1;
           If %Found;

SUD01 *?      // Check Order eligible to accept Change Order
  |           Chain(N) (CHORDNO: 0 ) WSORCHCL0;
  |           If %Found;                      // If Found
  |              If OCORFLG = 'Y';
  |                 WkElgFlg = 'Y';           // Change Eligible
  |              Elseif OCORFLG = 'N';
  |                 WkElgFlg = 'N';           // Change Ineligible
  |              Endif;
  |           Else;                           // Not Found
  |              WkElgFlg = 'Y';
  |           Endif;
  |
  |           If WkElgFlg = 'Y';
SUD01
      *?         // Get Dates based on Requested Date
                 Exsr ReqDateSR;

      *?         // Check Order Number Exists in PO XMLfile
                 Exsr ChkOrderProcess;
SUD01         Else;
  |
  |   *   ?      // Update Header and Detail lines as 'X'= Closed
  |              Exsr UpdCORecord;
  |           Endif;
SUD01
      *?      // Validate Header and Detail File Fields
              If FFlag = *Blanks;
                 Exsr ValidateProcess;

      *?         // If No Error Go for Order Process
                 If WkFlag = *Blanks;
                    Exsr OrderProcess;
                 Endif;
              Endif;
           Endif;


      *?   // End program
           Exsr EndPgm;         //WJB03
           *InLr = *On;
           Return;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Parameters
      *?      : Read Xml Header File record for Order Change
      *?        Record Selecion with Entry parameters
      *
        Begsr InzPgm;

      *?   // Get Values from Copy Functions
           Now         = $Now;
           Today       = $Date(0);                       // Today MDY
           TodayYMD7   = $Date7(Today);                  // Today CYMD7
           TodayMDY    = $MDYDate(Today);                // Today MDY
           ThisMonCYMD = $Date7($Monday(Today:'FRI'));   // Monday CYMD
           ThisMonday  = $MDYDate($Monday(Today:'FRI')); // Monday MDY

      *?   // Initialise Flags
           EFlag = 'N';                                  // Error Flag
           FFlag = *Blanks;                              // Error File Flag
           WkFlag = *Blanks;                             // Order Create Flag
           WkFirst='Y';                                  // First Time Flag
           WkFound='N';                                  // First Time Flag

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : ReqDateSR Subroutine :
      *?                :----------------------:
      *
      *?Logic : Get Monday date based on Requested Date
      *
        Begsr ReqDateSR;

      *?   // Get Values from Copy Functions for Requested Ship Date
           RqToday       = CHRQSHDT;                         // Today MDY
           RqTodayYMD7   = $Date7(RqToday);                  // Today CYMD7
           RqTodayMDY    = $MDYDate(RqToday);                // Today MDY
           RqThisMonCYMD = $Date7($Monday(RqToday:'FRI'));   // Monday CYMD
           RqThisMonday  = $MDYDate($Monday(RqToday:'FRI')); // Monday MDY
SUD05      WkDte         = %Date(RqThisMonday:*MDY);

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------------:
      *?            : ChkOrderProcess Subroutine :
      *?            :----------------------------:
      *
      *?Logic : Check order number in PO XML file , If exists then allow
      *?      : for Order Change , Else Mark Flag 'X' as deleted
      *
        Begsr ChkOrderProcess;

      *?   // Read PO Create XML file to get Order # for Broker/PO #
           Setll (PFromOrgId:PCustPO) WSPOHDRL1;
           ReadE (PFromOrgId:PCustPO) WSPOHDRL1;
           Dow Not %Eof and WkFound='N';
              If PHFLAG = 'C' or PHFLAG = 'P';
                 WkOrdNo = PHORDNO;

      *?         // Check Req.Ship Date Change
                 Exsr ControlFileCheck;

      *?         // If Control file has any one line Change ineligible,
      *?         // Dont Process the Change Order ,Else Proceed for Change
                 If WkFound = 'Y';
                    Chain WkOrdNo FHORDR;
                    If %Found;
                       If OHSTAT <> 'A';

      *   ?               // Update Header and Detail lines as 'X'= Closed
                          Exsr UpdCORecord;
                       Else;

      *   ?               // Check Exception records exist,If yes delete old err
                          Exsr DelExpRecords;
                       Endif;
                    Else;

      *   ?            // If order not found, do not allow to create order
                       Exsr UpdCORecord;
                    Endif;
                 Endif;
              Endif;
              ReadE (PFromOrgId:PCustPO) WSPOHDRL1;
           Enddo;

      *?   // If No record found in WSPOHDRPF for Broker ID Or
      *?   // Line item ineligible for Req.Ship Date
           If WkFound='N';

      *?      // Update Header and Detail lines as 'X'= Closed/Deleted
              Exsr UpdCORecord;
           Endif;

      *?   // Return Flag if Error
           PFlag = CHFLAG;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------------:
      *?            : ControlFileCheck Subroutine :
      *?            :-----------------------------:
      *
      *?Logic : Check the control file if Requested date is changed.
      *?        If any one of the line in ineligible, then dont process
      *
        Begsr ControlFileCheck;

      *?   // Read if Order found in FHORDR, get the ReqShipDate
           Chain WkOrdNo FHORDR;
           If %Found;

VV06  *?     // Check Requested Ship date if Not same in CO and FHORDR
VV06  *?     // Req Ship Date converted to monday
             RqMonMDY = $MDYDate($Monday(CHRQSHDT:'FRI'));
VV06         If RqMonMDY <> OHDTRQ;
SUD03           WkDtlUpd = 'Y';

      *?        // Check Using PO Header Seq
                Setll (PFromOrgId:PCustPO:PHSEQNO) WSORCHCL1;
                ReadE (PFromOrgId:PCustPO:PHSEQNO) WSORCHCL1;
                Dow Not %Eof;
                   If ZOCORFLG = 'N';
SUD09                 Chain (ZOCORDNO:ZOCORDLIN) FIORDR;
  |                   If %Found;
  |                      If XOISTAT = 'A';
  |                         WkFound = 'N';
  |                         Leave;
  |                      Endif;
  |                   Endif;
SUD09              Endif;
                   WkFound = 'Y';
                   ReadE (PFromOrgId:PCustPO:PHSEQNO) WSORCHCL1;
                EndDo;

      *?        // Check Using CO Header Seq
SUD09           Setll (PFromOrgId:PCustPO:PSEQNO) WSORCHCL1;
  |             ReadE (PFromOrgId:PCustPO:PSEQNO) WSORCHCL1;
  |             Dow Not %Eof;
  |                If ZOCORFLG = 'N';
  |                   Chain (ZOCORDNO:ZOCORDLIN) FIORDR;
  |                   If %Found;
  |                      If XOISTAT = 'A';
  |                         WkFound = 'N';
  |                         Leave;
  |                      Endif;
  |                   Endif;
  |                Endif;
  |                WkFound = 'Y';
  |                ReadE (PFromOrgId:PCustPO:PSEQNO) WSORCHCL1;
SUD09           EndDo;

      *?     // Check Requested Ship date same in PO & CO
      *?     // Check Requested Ship date same in CO and FHORDR Ship Date
VV06         Elseif RqMonMDY = OHDTRQ;
                WkFound  = 'Y';
VV05            WkDtEFlg = 'Y';
             Endif;
VV06       Endif;                         //Found in FHORDR

        Endsr;
      //--------------------------------------------------------------------
VV06  *?            :----------------------:
  |   *?            : ChkShpVal Subroutine :
  |   *?            :----------------------:
  |   *
  |     Begsr ChkShpVal;
  |
  |   *?   // Check if the Ship Number and Ship Via code is different to update -
  |   *?   // detail records in FIORDR based on these values
  |   *?   // If Ship Number/Customer is different from FHORDR seton detail update flag
  |        If CMCUST <> OHCUST;
  |           WkDtlUpd = 'Y';
  |        Endif;
  |
  |   *?   // Cross reference file validation for Shipment Method
  |        WkSHPC = *Blanks;                     // Ship Via Code
  |        If PFromOrgID <> 'Ball Seed';
  |           Chain (CHFRORID:'Customer':CHSHPMTH) XREFSVIAL0;
  |           If %Found;
  |              Select;
  |              When SXRLCLKEY = 'FMCUST';
  |                 WkSHPC = CMSVCD;             // Ship Via Code
  |              When SXRLCLKEY = '02';
  |                 WkSvia = SXRLCLKEY;
  |                 Chain WkSvia FMSVIA;
  |                 If %Found;
  |                    WkSHPC = SVCODE;          // Ship Via Code
  |                 Endif;
  |              Endsl;
  |           Endif;
  |        Else;
  |           WkSHPC = CMSVCD;                   // Ship Via Code for BallSeed
  |        Endif;
  |
  |   *?   // If Ship Via code is different from FHORDR, seton detail update flag
  |        If WkSHPC <> OHSHPC;
  |           WkDtlUpd = 'Y';
  |        Endif;
  |
VV06    Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : UpdCORecord Subroutine :
      *?            :------------------------:
      *
        Begsr UpdCORecord;

      *?   // Update XML Order Header File flag as cannot process
           FFlag  = 'X';
           CHFLAG = 'X';
           Exsr WSHdrAudit;
           Update WSCOHDRR %Fields(CHFlag:CHUPDDAT:CHUPDTIM
                              :CHUPDUSR:CHUPDJOB:CHUPDPGM);

      *?   // Read Xml Order Detail File and update the flag
           Setll (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           ReadE (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           Dow Not %Eof;

              CDFlag = 'X';
              Exsr WSDtlAudit;
              Update WSCODTLR %Fields(CDFLAG:CDUPDDAT:CDUPDTIM:
                           CDUPDUSR:CDUPDJOB:CDUPDPGM);
              ReadE (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           Enddo;

SUD01 *?   // Return Flag
SUD01      PFlag = CHFLAG;

        Endsr;
      //--------------------------------------------------------------------
      *?            :--------------------------:
      *?            : DelExpRecords Subroutine :
      *?            :--------------------------:
      *
        Begsr DelExpRecords;

      *  ? // Read all records
           Setll (PFromOrgId:PCustPO) WSERREXPL0;
           ReadE (PFromOrgId:PCustPO) WSERREXPL0;
           Dow Not %Eof;
              ERFLAG = 'X';

      *  ?    // Audit Stamp
              ERUPDDAT = Rundate;
              ERUPDTIM = Runtime;
              ERUPDUSR = User;
              ERUPDJOB = Job;
              ERUPDPGM = Pgm;
              Update WSERREXPR %Fields(ERFLAG:ERUPDDAT:ERUPDTIM
                                      :ERUPDUSR:ERUPDJOB:ERUPDPGM);
              ReadE (PFromOrgId:PCustPO) WSERREXPL0;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------------:
      *?                : ValidateProcess Subroutine :
      *?                :----------------------------:
      *
      *?Logic : Validate Mandatory Fields in Xml Header File
      *?      : Validate against KubePak Customer Xref File
      *?      : Validate against FMCUST with Status = 'A'
      *
        Begsr ValidateProcess;

      *?   // Mandatory Fields validation
           If CHBRKORID= *Blanks;
              WkMsgId = 'WS00001';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If CHRQSHDT = *Loval;
              WkMsgId = 'WS00002';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If CHSHPNUM = *Blanks;
              WkMsgId = 'WS00009';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If CHSHPNAM = *Blanks;
              WkMsgId = 'WS00010';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If CHSHPAD1 = *Blanks and CHSHPAD2 = *Blanks;
              WkMsgId = 'WS00011';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If CHSHPSTE = *Blanks;
              WkMsgId = 'WS00012';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If CHSHPCTY = *Blanks;
              WkMsgId = 'WS00013';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

           If CHSHPPHN = *Blanks;
              WkMsgId = 'WS00014';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

      *?   // Cross reference file validation for BrokerShiptoNumber
           Chain (PFromOrgId:'Customer':CHSHPNUM) XREFCUSTL0;
           If %Found;
              WkCust = %Int(XRLCLKEY);
              Chain(N) WkCust FMCUST;
              If %Found and CMSTAT <> 'A';
                 WkMsgId = 'WS00023';
                 EFlag = 'Y';
                 FFlag = 'H';
                 Exsr ErrProcess;
              Endif;
              If Not %Found;
                 WkMsgId = 'WS00015';
                 EFlag = 'Y';
                 FFlag = 'H';
                 Exsr ErrProcess;
              Endif;
           Else;
              WkMsgId = 'WS00016';
              EFlag = 'Y';
              FFlag = 'H';
              Exsr ErrProcess;
           Endif;

      *?   // Cross reference file validation for Shipment Method
           If PFromOrgId <> 'Ball Seed';
              Chain (CHFRORID:'Customer':CHSHPMTH) XREFSVIAL0;
              If Not %Found;
                 WkMsgId = 'WS00027';
                 EFlag = 'Y';
                 FFlag = 'H';
                 Exsr ErrProcess;
              Endif;
           Endif;

      *?   // Order Change Flag
           If EFlag  = 'Y';
              WkFlag = 'Y';
              CHFLAG = 'E';
           Endif;

      *?   // Process Detail Validation
      *?   // Read Xml Order Detail File Non Processed Records
           Setll (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           ReadE (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           Dow Not %Eof;
              If CDFLAG <> 'U';

      *?         // Validate Detail File Fields,Only Xreferenced Item
                 Exsr ItemQtyCheck;
                 If WkOQty <> CDORDQTY And CDORDQTY <> 0;
                    Exsr DetailValidate;
                 Endif;

                 If EFlag  = 'Y';
                    WkFlag = 'Y';
                    CDFlag = 'E';
                    CHFlag = 'E';
                    Exsr WSDtlAudit;
                    Update WSCODTLR %Fields(CDFLAG:CDUPDDAT:CDUPDTIM:
                                            CDUPDUSR:CDUPDJOB:CDUPDPGM);
                 Endif;
              Endif;
              ReadE (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           Enddo;

      *?   // If Error in Detail File Update Header File Flag Or
      *?   // If Only Header in Error, Update Exception Flag in Header File
           If CHFLAG = 'E';
              Exsr WSHdrAudit;
              Update WSCOHDRR %Fields(CHFlag:CHUPDDAT:CHUPDTIM
                                      :CHUPDUSR:CHUPDJOB:CHUPDPGM);
      *?      // Return Flag
              PFlag = CHFLAG;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : ItemQtyCheck Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Check Quantity of XML record with FIORDR. If same do not
      *?        Validate
      *
        Begsr ItemQtyCheck;

      *?   // Initialise Variables
           WkPart='N';
           WkOQty = *Zeros;
           WkOrdQty = *Zeros;
           WkCount  = *Zeros;
SUD10      WkOrdLin = *Blanks;
           EFlag = 'N';

      *?   // Check if there are multiple lines in FIORDR for CDORDLIN
           WkOrdLin = %Char(CDORDLIN);
           Exec SQL
              Select Count(*) Into :WkCount From FIORDRL15
              Where OIORD# = :WkOrdNo And OILIST = :WkOrdLin;

      *?   // Read each line in FIORDR in a loop based on Order/List Code
           If WkCount > 1;

      *?      // Check if Order/Line exist in FIORDRPART file
              Setll (CDORDNO:WkOrdLin) FIORDRL15;
              Reade (CDORDNO:WkOrdLin) FIORDRL15;
              Dow Not %Eof;
                 Chain (CHORDNO:OISEQ#) FIORDRPART;
                 If %Found;
                    WkPart = 'Y';
                    WkOrdQty = WkOrdQty + ((OIQORD * HOIPCTF) / 100);
                 Else;
                    WkOrdQty = WkOrdQty + OIQORD;
                 Endif;
                 Reade (CDORDNO:WkOrdLin) FIORDRL15;
              Enddo;
              If WKOrdQty <> 0;
                 Chain OISIZE FMSIZE;
                 If %Found and SZSTAT = 'A';
                    WkOQty = WKOrdQty * SZSALE;
                 Endif;
              Endif;

      *?   // If only 1 line is found in FIORDR for CDORDNO
           Else;
              Chain(N) (CDORDNO:WkOrdLin) FIORDRL15;
              If %Found and OIQORD <> 0;
                 Chain OISIZE FMSIZE;
                 If %Found and SZSTAT = 'A';
                    WkOQty = OIQORD * SZSALE;
                 Endif;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
VV07  *?                :------------------------:
  |   *?                : CheckAvlSts Subroutine :
  |   *?                :------------------------:
  |   *
  |   *?Logic : Check Item available status by calling program INVAVLSTS
  |   *?
  |     Begsr CheckAvlSts;
  |
  |   *?   // Check Item Status for Item and Broker
  |        If CHFRORID = 'Ball Seed';
  |           ThisType = 'Ball Seed';
  |        Else;
  |           ThisType = 'WEB';
  |        Endif;
  |
  |   *?   // Call Inventory Availability Status Program
  |        Error   = *Zeros;
  |        ErrDesc = *Blanks;
  |        INVAVLSTS(IXRLCLITEM:IXRLCLSIZE:RqToday:
  |                  ThisType:Error:ErrDesc);
  |        If Error <> 0;
  |
  |   *?      // Write a record in FIORDRB2B comment file for any error to be sent in Ack
  |           Exsr WriteB2BErr;
  |        Endif;
  |
  |     Endsr;
VV07  //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : DetailValidate Subroutine :
      *?                :---------------------------:
      *
      *?Logic : Validate Mandatory Fields in Xml Detail File
      *?      : Validate against KubePak Item Xref File
      *?      : Validate against FMINVT with Status = 'A'
      *
        Begsr DetailValidate;

      *?   // Initialise parameters
           EFlag = 'N';

      *?   // Cross reference file validation for Item
           IXRLCLITEM = *Blanks;
           IXRLCLSIZE = *Blanks;
           Chain (CHFRORID:'Customer':CDBRKMAT) XREFINVTL0;
           If %Found;
              Chain (IXRLCLITEM:IXRLCLSIZE) FMINVT;
              If %Found and IMSTAT <> 'A';
                 WkMsgId = 'WS00024';
                 EFlag = 'Y';
                 FFlag = 'D';
                 WkOQty = CDORDQTY;
                 Exsr ErrProcess;
              Endif;
              If Not %Found;
                 WkMsgId = 'WS00021';
                 EFlag = 'Y';
                 FFlag = 'D';
                 WkOQty = CDORDQTY;
                 Exsr ErrProcess;
              Endif;

           Else;
              WkMsgId = 'WS00022';
              EFlag = 'Y';
              FFlag = 'D';
              WkOQty = CDORDQTY;
              Exsr ErrProcess;
           Endif;

      *?   // Mandatory Fields validation
VV07       If CDORDQTY < *Zeros;
              WkMsgId = 'WS00034';
              WkOQty = CDORDQTY;
              EFlag = 'Y';
              FFlag = 'D';
              WkOQty = CDORDQTY;
              Exsr ErrProcess;
           Endif;

VV07       If CDSCHSHDT = *Loval;
              WkMsgId = 'WS00020';
              EFlag = 'Y';
              FFlag = 'D';
              WkOQty = CDORDQTY;
              Exsr ErrProcess;
           Endif;

      *?   // Convert Quantity to KubePak Quantity only if <> 0
           WkOQty = *Zeros;
           If CDORDQTY <> *Zeros;
              Chain IXRLCLSIZE FMSIZE;
              If %Found and SZSTAT = 'A';
                 WkOQty = CDORDQTY/SZSALE;

VV01  *?         // Check Remainder for Ordered Qty, if not 0 then round off
 |               WkOrdQty1 = *Zeros;
 |               WkRem     = *Zeros;
 |               WkOrdQty1 = %Int(CDORDQTY);
 |               WkRem = %Rem(WkOrdQty1:SZSALE);
 |               If WkRem <> 0;
 |                  WkOQty = %IntH(WkOQty);
VV01             Endif;
              Else;
                 WkOQty = CDORDQTY;
              Endif;

      *?      // Get Available Quantity before process
      *?      // Check quantity if Item is found
              WkQty = *Zeros;
SUD04         WkParInd = *Off;
              If IXRLCLITEM <> *Blanks and IXRLCLSIZE <> *BLANKS;
SUD04            GETAVLINV(IXRLCLITEM:IXRLCLSIZE:WkDte:WkOQTY:WkQty:
SUD04                     WkLotC:WkParInd);
              Endif;

              If WkQty = *Zeros;              // Qty Available
                 WkMsgId = 'WS00026';
                 FFlag = 'I';
                 WkOQty = CDORDQTY;
                 Exsr InfoSr;
              Endif;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-------------------------:
      *?            : OrderProcess Subroutine :
      *?            :-------------------------:
      *
      *?Logic : Update/Create Order
      *?
        Begsr OrderProcess;

      *?   //Initialise Process Flag
           WkProc = 'N';

      *?   // Update order if found in header
           Chain WKOrdNo FHORDR;
           If %Found;
              Exsr UpdHeaderRecord;
              Exsr OrderUpdate;
           Endif;

           If WkProc='Y';

      *?      // Write/Update User Order Information
              Exsr CrtUpdPPO;

      *?      // Write/Update Open Order Information
              Exsr CrtUpdOpenOrd;
           EndIf;

      *?   // Update Process Flag Completed with Audit Stamp
           CHFLAG   = 'C';
           CHORDNO  = OHORD#;
           Exsr WSHdrAudit;
           Update WSCOHDRR %Fields(CHFLAG:CHORDNO:CHUPDDAT:CHUPDTIM
                                          :CHUPDUSR:CHUPDJOB:CHUPDPGM);
      *?   // Return Flag
           PFlag = CHFLAG;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : OrderUpdate Subroutine :
      *?            :------------------------:
      *
      *?Logic : Update existing Order
      *?
        Begsr OrderUpdate;
      *?
           Setll (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           ReadE (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           Dow Not %Eof;

      *?      // Process only for Xreferenced Item
SUD11         WkLinF = 'N';
              If CDFLAG <> 'U';

      *?         // Read Order Detail File
VV05             WkAddQFg = 'N';
VV10             WkNewLn = 'N';
SUD10            WkOrdLin = *Blanks;
                 WkOrdLin = %Char(CDORDLIN);
SUD02            Chain(N) (CDORDNO:WkOrdLin) FIORDRL15;
                 If %Found;
                    Chain(N) (CDORDNO:CDORDLIN) WSORCHCL0;
                    If %Found;
VV05
  |   *?               //If flag is 'N' and date is Equal allow to process
VV05                   If OCORFLG='N' and WkDtEFlg = 'N';
SUD06                     FFlag = 'I';
  |                       OCORMSGD = 'Order cannot be changed if ' +
SUD06                                'Change Control flag N';
                          Exsr ErrProcess;
                       Else;
                          Exsr ItemQtyCheck;

VV05  *?                  //Check if Qty is available for same Req Ship Date if OCORFLG='N'
VV05                      If OCORFLG='N' and WkDtEFlg = 'Y';

VV06  *?                     //If Qty > FIORDR qty and line is not partial line
VV05                         If CDORDQTY > WkOQty and WkPart = 'N';
  |                             Exsr ChkAddQty;
  |                          Endif;
VV05                      Endif;

VV08  *?                  //If Qty <> FIORDR qty and line is not partial line then proceed
  |                       If (WkOQty <> CDORDQTY  Or WkDtlUpd = 'Y'
  |                          Or (CDORDQTY = *Zeros and OCORFLG='Y'))
VV08                         and WkPart = 'N';

                             If WkCount > 1;
SUD02                           If CDORDQTY = *Zeros;

      *?                           //Update all lines for that OILIST
                                   Exec Sql
                                   Update FIORDRL15 set OISTAT='D', OIQORD=0
                                   where OIORD#=:WkOrdNo and OILIST= :WkOrdLin;
SUD02                           Else;
  |                                WKUpdate = 'N';
  |                                Setll (CDORDNO:WkOrdLin) FIORDRL15;
  |                                ReadE (CDORDNO:WkOrdLin) FIORDRL15;
  |                                Dow Not %Eof and WKUpdate = 'N';
  |                                   If OIITYP <> 'C';
  |                                      Exsr SetDetailRecord;
  |                                      Update RIORDR;
  |                                      WkUpdate = 'Y';
  |                                   Endif;
  |                                   ReadE (CDORDNO:WkOrdLin) FIORDRL15;
  |                                Enddo;
SUD02                           Endif;
                             Else;
SUD02                           Chain (CDORDNO:WkOrdLin) FIORDRL15;
SUD02                           Exsr SetDetailRecord;
                                Update RIORDR;
                             Endif;
                             WkProc='Y';
                          Endif;
                       Endif;
                    Endif;
                 Else;

      *?            // If Order Line does not exist in FIORDR create order line
      *?            // only if Ordered Quantity is not Zeros
                    If CDORDQTY <> *Zeros;
                       Exsr CrtOrderDtl;
                       Write RIORDR;
                       WkProc='Y';

      *?               // Write the new line into Order Control file
                       Exsr  WriteCntF;

                    Endif;

SUD10 *?            // Incoming type = 'C' and Qty = 0 , Dont Write Linein FIORDR
  |                 If CDORDQTY = *Zeros and CDINCTYP = 'C';
  |                    OILIST = *Blanks;
SUD10               Endif;

SUD11 *?            // Write Comment line If AVL Qty = 0
  |                 If CDORDQTY <> *Zeros;
  |                    WkLinF = 'Y';
  |                    CDORDLIN = %Int(OILIST);                    // Orderline Number
  |                    If OIQORD = *Zeros and WkParInd = *Off;
  |                       OISEQ# += 1;
  |                       OIITYP = 'C';
  |                       OIDES1 = %Trim(OIITEM) + ' ' + %Trim(OISIZE) +
  |                                ' Qty ' + %Char(CDORDQTY) + ' Not Avail';
  |                       OIITEM = *Blanks;
  |                       OISIZE = *Blanks;
  |                       Write RIORDR;
  |                    Endif;
SUD11               Endif;

                 Endif;

      *?         // Update Flag in XML Order Detail File ("C" - Created)
                 CDFlag  = 'C';
                 CDORDNO = OIORD#;                        // Order Number

SUD11            If WkLinF = 'N';
SUD10               If OILIST <> *Blanks;
  |                    CDORDLIN = %Int(OILIST);           // Orderline Number
  |                 Else;
  |                    CDORDLIN = 0;                      // Orderline Number
SUD10                Endif;
SUD11            Endif;

                 Exsr WSDtlAudit;
                 Update WSCODTLR %Fields(CDFLAG:CDORDNO:CDORDLIN:CDUPDDAT:
                                         CDUPDTIM:CDUPDUSR:CDUPDJOB:CDUPDPGM);

              Endif;       // Cdflag <> 'U'
              ReadE (CHFRORID:CHBRKORID:CHSEQNO) WSCODTLL0;
           Enddo;

      *?   // Calculate Tax amount for the Change Order / Update FMCUST
           If WkProc='Y';
              Exsr ConsiderAllOrders;
           Endif;

      *?   // Update Order Header/History Header
           Exsr UpdateHDR;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : CrtOrderDtlSubroutine  :
      *?            :------------------------:
      *
      *?Logic : Create detail record ,If New line Item Comes
      *?
        Begsr CrtOrderDtl;

      *?   // Clear Record Format
           Clear RIORDR;

      *?   // Generate Sequence Number
           Setgt  OHORD# FIORDR;
           ReadPE OHORD# FIORDR;
           If Not %Eof;
             XOISEQ# += 2;
           Else;
             XOISEQ# = 10;
           Endif;

      *?   // From FHORDR File
           OISTAT = 'A';                         // Status
           OIORD# = OHORD#;                      // Order Number
           OISEQ# = XOISEQ#;
           OIDTRQ = OHDTRQ;                      // Req Ship Date
           OIRVDT = RqThisMonCYMD;               // Req Ship Date CYMD
           OICUST = OHCUST;                      // Customer #
           OISLM1 = OHSLM1;                      // SalesPerson 1
           OISHPC = OHSHPC;                      // Ship Via
           OILIST = %Char(OISEQ#);

VV10  *?   // Move 'Y' to New Line flag for qty calculation
VV10       WkNewLn = 'Y';

      *?   // Move Detail File Fields
           Exsr SetDetailRecord;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ErrProcess Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Retreive message from Message File (WSMSGF) and
      *?        Write into Error Exception File
      *?Used Program & File : WSRTVMSG : WSMSGF
      *
        Begsr ErrProcess;

      *?   // Call CL program to Get Error Msg
           If OCORFLG <> 'N';
              Monitor;
                WkMsgf = 'WSMSGF';
                RtvErrMsg(WkMsgID:WkMsgf:WKMSG:WkDta);
              On-Error;
              EndMon;
           Else;
              WKMsgId = OCORMSGID;      // Error Message ID from WSORCH CPF
              WkMsg   = OCORMSGD;       // Error Message
           Endif;

      *?   // Move Values into Fields
           ERBRKNAM  = CHFRORID;                // BrokerName
           ERBRKORID = CHBRKORID;               // Customer PO
           ERPOSEQ   = CHSEQNO;                 // PO Sequence # Unique
           If WkFirst='Y';
              WkErSeq  = 1;                     // First Sequence
              WkFirst  = 'N';                   // First Time Flag
           Else;
              WkErSeq  += 1;
           Endif;
           ERERRSEQ = WkErSeq;                  // Error Sequence #
           ERRQSPDT = CHRQSHDT;                 // Requested Ship Date
           ERRMSGID = WkMsgID;                  // Error Message ID
           ERRMSG   = WkMsg ;                   // Error Message
           ERFLAG   = FFlag;                    // Flag
           ERBRKSLD = CHSLDNUM;                 // Sold To Customer
           ERBRKSHP = CHSHPNUM;                 // Ship To Customer
           ERCUSNUM = CMCUST;
           ERORDNO  = CHORDNO;
           If FFlag = 'H';
              ERBRKMAT = *Blanks;               // Broker Item
              ERITMNUM = *Blanks;
              ERITMSIZ = *Blanks;
              ERQTYORD = *Zeros;
              ERPODSEQ = *Zeros;
           Elseif FFlag = 'D';
              ERBRKMAT = CDBRKMAT;              // Broker Item
              ERITMNUM = IXRLCLITEM;            // Item
              ERITMSIZ = IXRLCLSIZE;            // Size
              ERQTYORD = WkOQTY;                // Quantity Ordered
              ERPODSEQ = CDSEQNO;
           Endif;

      *?   // Execute Audit Stamp
           Exsr WSErrAudit;

      *?   // Write Error Record
           Write WSERREXPR;

        EndSr;
      //--------------------------------------------------------------------
      *?            :-------------------:
      *?            : InfoSR Subroutine :
      *?            :-------------------:
      *
      *?Logic : Retreive message from Message File (WSMSGF) and
      *?        Write into Error Exception File
      *?Used Program & File : WSRTVMSG : WSMSGF
      *
        Begsr InfoSR;

      *?   // Call CL program to Get Error Msg  GF
           If WkMsgId <> 'WS00025';
             WkDta = *Blanks;
           Endif;

           Monitor;
             WkMsgf  = 'WSMSGF';
             RtvErrMsg(WkMsgID:WkMsgf:WKMSG:WkDta);
           On-Error;
           EndMon;

      *?   // Concat Ordered Qty with Msg
           If WkMsgId = 'WS00046';
             WKMsg = %Trim(WKMsg) + ' ' + %Char(WkOQty);
           Endif;

      *?   // Move Values into Fields
           ERBRKNAM = CHFRORID;                //BrokerName
           ERBRKORID= CHBRKORID;               //Customer PO
           ERPOSEQ   = CHSEQNO;                //PO Sequence # Unique
           If WkFirst='Y';
              WkErSeq  = 1;                    //First Time Flag
              WkFirst  = 'N';                  //First Time Flag
           Else;
              WkErSeq  = +1;
           Endif;
           ERERRSEQ  = WkErSeq;             //Error Sequence #
           ERRQSPDT = CHRQSHDT;                //Requested Ship Date
           ERRMSGID = WkMsgID;                 //Error Message ID
           ERRMSG   = WkMsg ;                  //Error Message
           ERFLAG   = 'I';                     //Flag
           ERBRKSLD = CHSLDNUM;                //Broker Sold To Customer
           ERBRKSHP = CHSHPNUM;                //Broker Ship to Customer
           ERCUSNUM = CMCUST;                  //KubePak Customer
           ERBRKMAT = CDBRKMAT;                //Broker Material #
           ERPODSEQ = CDSEQNO;                 //Detail Seq No
           ERITMNUM = IMITEM;                  //Item
           ERITMSIZ = *Blanks;                 //Size
           ERQTYORD = WkOQTY;                  //Quantity Ordered

      *?   // Execute Audit Stamp
           Exsr WSErrAudit;

      *?   // Write Error Record
           Write WSERREXPR;

        EndSr;
      //---------------------------------------------------------------
      *?            :----------------------:
      *?            : UpdatePPO Subroutine :
      *?            :----------------------:
      *
      *?Logic : Update a record into User information file
      *?
        Begsr CrtUpdPPO;

      *?   // Check Record Exists in FPPO
           Chain (OHORD#) FPPO;

      *?   // Move Values into Order User Information File
           POORD# = OHORD#;
           POTAKN = User;
           POENTR = User;
           POPICK = User;
           POPACK = User;
           If %Found;
             Update  RPPO;
           Else;
             Write RPPO;
           EndIf;

        Endsr;
      //--------------------------------------------------------------------
      *?            :--------------------------:
      *?            : UpdateOpenOrd Subroutine :
      *?            :--------------------------:
      *
      *?Logic : Update a record into Open order file
      *?
        Begsr CrtUpdOpenOrd;

      *?   // Move Values into Open Order File
           Chain(N) WkCust FMCUST;
           If %Found;
              OOORD# = OHORD#;
              OOCOMP = 1;
              OOCUST = CMCUST;
              OODTRY = ThisMonCYMD;
              OOORDY = TodayYMD7;
              OOARCU = CMARCU;
              OOSACU = CMSACU;
              OOBLCU = CMBLCU;
              OOSHFR = CMTERR;
              OOEXT$ = TotalOrder;

              Chain (OHORD#) FOPNORD;
              If %Found;
                 Update ROPNORD;
              Else;
                 Write ROPNORD;
              Endif;

           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------------:
      *?            : UpdHeaderRecord Subroutine :
      *?            :----------------------------:
      *
      *?Logic : Update a record in Header File (FHORDR)
      *?
        Begsr UpdHeaderRecord;

VV06  *?   //Check if ShipNumber and ShipVia are different to update detail line
VV06       Exsr ChkShpVal;

      *?   // From XREFCUSTL0 File
           OHCUST = %Int(XRLCLKEY);              // Customer from CusRefFile

      *?   // From WSCOHDRL1 File
           OHNAME = CHSHPNAM;                    // Ship To Name
           OHSHP2 = CHSHPAD1;                    // Address Line #1
           OHSHP3 = CHSHPAD2;                    // Address Line #2
           OHSHP4 = OHSHP4;                      // Address Line #3
           OHSHCT = CHSHPCTY;                    // City
           OHSHST = CHSHPSTE;                    // State

      *?   // Remove hyphen for Zip and move
           WkZipC = CHSHPZIP;
           OHSHZP = WkZipC.WkChar5;                       // Zip Code
           OHDTRQ = $MDYDate($Monday(CHRQSHDT:'FRI'));    // Req Ship Date
           OHDTCN = OHDTRQ;                               // Cancel Date

      *?   // From FMCUST File
           OHTXST = CMTXST;                      // Tax Exempt from FMCUST
           OHTXJU = CMTXJU;                      // Jurisdiction
           OHSHIN = CMSHIN;                      // Shipping Instructions
           OHTYPE = CMCTYP;                      // Customer Type
           OHBOCD = CMBOOK;                      // Cust B/O Allowed
           OHPRCD = CMPRCD;                      // Price Code
           OHTRDC = CMTRDC;                      // Trade Disc. %
           OHTMCD = CMTMCD;                      // Terms Code
           OHUPSZ = CMUPSZ;                      // Freight Zone
           OHARCU = CMARCU;                      // AR Cust #
           OHTXID = CMTXID;                      // Tax ID #
           OHPHYT = CMPHYT;                      // Phyto Code
           OHALPH = CMLOOK;                      // Customer Alpha
           OHSHFR = *Blanks;                     // Ship From
           OHOLST = CMORLS;                      // Order Price List
           OHSACU = CMSACU;                      // SA Cust #
           OHBLCU = CMBLCU;                      // Billing Cust #

      *?   // From FMSVIA/FMCUST File
           If CHFRORID <> 'Ball Seed';
              Chain (CHFRORID:'Customer':CHSHPMTH) XREFSVIAL0;
              If %Found;
                 Select;
                 When SXRLCLKEY = 'FMCUST';
                    OHSHPC = CMSVCD;             // Ship Via Code
                 When SXRLCLKEY = '02';
                    WkSvia = SXRLCLKEY;
                    Chain WkSvia FMSVIA;
                    If %Found;
                       OHSHPC = SVCODE;          // Ship Via Code
                    Endif;
                 Endsl;
              Endif;
           Else;
              OHSHPC = CMSVCD;                  // Ship Via Code
           Endif;

      *?   // From FMTERM File
           Chain OHTMCD FMTERM;
           If %Found;
              OHTERM = TCDESC;                   // Terms
              OHTDAS = TCTDAS;                   // Terms Days
           Endif;

      *?   // Constant Values
           OHDTRY = RqThisMonCYMD;               // Req. Date CYMD
           OHORDY = TodayYMD7;                   // Order Date CYMD
           OHORDT = RqTodayMDY;                  // Original Req Date

VV02  *?   // Do not change date when change order is received
VV02  *    OHDTOR = TodayMDY;                    // Order Date(*MDY0)
           OHTDAT = TodayMDY;                    // Date Of Trans
           OHDTLA = TodayMDY;                    // Last Activity Date
           OHTIME = Now;                         // Time
           OHUSER = User;                        // User
           OHSPIN = *Blanks;                     // Special Instructions
           OHTRAT = *Zeros;                      // Cash Disc Percent
           OHTDAY = *Zeros;                      // Cash Discount Days
           OHSTA  = 'N';                         // Sub To Avail
           OHACK  = 'N';                         // Ord. Ack. Printed
           OHSLM1 = '01';                        // SalesPerson 1
           OHSCM1 = *Zeros;                      // Comm % 1
           OHSLM2 = *Blanks;                     // SalesPerson 2
           OHSCM2 = *Zeros;                      // Comm % 2
           OHFRT$ = *Zeros;                      // Freight Amt
           OHMER$ = *Zeros;                      // Merchandise Amt
           OHDIS$ = *Zeros;                      // Discount Amt
           OHMIS$ = *Zeros;                      // Misc. Charge Amt
           OHTAX$ = *Zeros;                      // Tax Amount
           OHFET$ = *Zeros;                      // Fet Amount
           OHIOCD = 'N';                         // Invoice Only
           OHCOFL = 'N';                         // Closed Order Flag
           OHHOLD = 'N';                         // Hold Order Flag
           OHPLPT = *Blanks;                     // Pick List Printed P
           OHIVCD = 'N';                         // Invoiced Code
           OHPPCD = 'P';                         // Prepaid/Collect
           OHINV# = *Zeros;                      // Invoice Number
           OHINDT = *Zeros;                      // Invoice Date CYMD
           OHFRTX = 'N';                         // Tax Freight
           OHSPTX = 'N';                         // Tax Special Chargs
           OHROUT = *Blanks;                     // Route #
           OHSTOP = *Zeros;                      // Stop
           OHTBLK = *Zeros;                      // Total Bulk Pieces
           OHTBRK = *Zeros;                      // Total Broken Pieces
           OHDTAC = *Zeros;                      // Ship Date
           OHPLST = '000001';                    // Freight Code
           OHIMED = *Blanks;                     // Immed Print
           OHCASH = *Zeros;                      // Cash Application
           OHLOC  = *Blanks;                     // Order Location
           OHOORD = *zeros;                      // Original Order #
           OHDISC = *Zeros;                      // C&C Or Sale Disc. %
           OHOPLP = *Blanks;                     // Order Proof Printed
           OHPOS  = *Blanks;                     // Invoice Type
           OHSALE = *Blanks;                     // Sale Type
           OHQTPR = 'N';                         // Quote Printed
           OHQUOT = *Blanks;                     // Quote Y Or Blank
           OHIMFG = 'N';                         // Immed Invoice Print

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------------:
      *?            : SetDetailRecord Subroutine :
      *?            :----------------------------:
      *?
        Begsr SetDetailRecord;

      *?   // Move Values into Order Detail File
      *?   // Get Kubepak Item
           Chain (CHFRORID:'Customer':CDBRKMAT) XREFINVTL0;

      *?   // Get Item Details from Item Master
           Chain (IXRLCLITEM:IXRLCLSIZE) FMINVT;

      *?   // From FMINVT File
           OIITEM = IMITEM;                      // Item Number
           OISIZE = IMSIZE;                      // Size
           OIDES1 = IMDES1;                      // Description 1
           OIDES2 = *Blanks;                     // Comment
           OICOMP = IMCOMP;                      // Comapny #
           OIWHSE = IMWHSE;                      // Location
           OIBIN# = IMBIN#;                      // Bin #
           OIUUOM = IMPUOM;                      // Unit Of Measure
           OIMULT = IMMULT;                      // Mult 1
           OIUWGT = IMUWGT;                      // Unit Wgt
           OIQDDC = IMDIS1;                      // Qty Discount
           OIROY  = IMROYL;                      // Royalty Each
           OIBOCD = IMBOOK;                      // Item B/O Allowed
           OIPRCL = IMPCL1;                      // Prod Class 1
           OIUCST = IMUCST;                      // Unit Cost
           OIBPUM = IMBPUM;                      // Base Price Unit Of Measure
           OISUOM = IMSUOM;                      // Ship Uom
           OIBLUM = IMBPUM;                      // Bill Uom
           OIITMA = IMLOOK;                      // Item Alpha Search
           OIUPRI = $UnitPrice(IMITEM:IMSIZE:CMCUST);   // Unit Price

      *?   // From FMCUST File
           Chain (PFromOrgId:'Customer':CHSHPNUM) XREFCUSTL0;
           WkCust = %Int(XRLCLKEY);
           Chain(N) WkCust FMCUST;
           OITRDC = CMTRDC;                      // Trade Disc %
           OICTCD = CMCTCD;                      // Contract Price Code
           OISHFR = CMSHFR;                      // Ship From
           OIPHYT = CMPHYT;                      // Phyto Code
           OIALPH = CMLOOK;                      // Cust Alpha Search

      *?   // Constant Values (OILIST retains same value for update line)
           OIDTLA = TodayMDY;                    // Last Activity Date
           OITIME = Now;                         // Time
           OIUSER = User;                        // User
           OIBORQ = *Zeros;                      // Orig B/O Req Ship Date
           OIORDT = RqTodayMDY;                  // Hold Orig Req Ship Date
           OIQSHP = *Zeros;                      // Qty Shipped
           OIQBOO = *Zeros;                      // Qty BackOrdered
           OIDISC = *Zeros;                      // Discount Amt
           OISHCD = *Blanks;                     // Ship Release Code
           OIOVER = 'N';                         // Override Code
           OICOM1 = *Zeros;                      // Commission 1
           OISLM2 = *Blanks;                     // Salesperson 2
           OICOM2 = *Zeros;                      // Commission 2
           OICOFL = 'N';                         // Closed Order Flag
           OIITYP = *Blanks;                     // Item Type
           OIQINV = *Zeros;                      // Invoice Qty Shipped
           OIPLPT = 'N';                         // Pick List Printed
           OIROUT = *Blanks;                     // Route Number
           OISTOP = *Zeros;                      // Stop
           OICWT  = *Zeros;                      // Catch Weight
           OILBS# = *Zeros;                      // Pounds
           OIWGSH = *Zeros;                      // Weight Shipped
           OIRSCD = *Blanks;                     // Reason
           OISEQP = *Zeros;                      // Primary Seq #
           OIPRAL = *Blanks;                     // Promo Allow
           OIMUL2 = *Zeros;                      // Mult 2
           OIOPFL = *Blanks;                     // Open Order Post Flag
           OIBOLN = *Blanks;                     // Line Item Put On BO
           OIPRBO = ' ';                         // Previous Backorder
           OISTA  = 'N';                         // Subj To Avail Flag
           OIINV# = *Zeros;                      // Invoice Number
           OITAGS = *Zeros;                      // # Tags
           OIPPDC = 'N';                         // Prompt Pay Dsc Y/N
           OISCHM = 'N';                         // Sched. To Move Flag
           OISCHS = 'N';                         // Sched. To Sow Flag
           OIQTAL = *Zeros;                      // Qty Allocated
           OIGLNO = *Zeros;                      // G/L # Spec Charges
           OISEDP = *Blanks;                     // Seed Ordered Y/N
           OIRVCD = RqTodayYMD7;                 // Expire Date   CYMD
           OIQTE  = *Blanks;                     // Quote Line Item
           OILOT# = *Blanks;                     // Lot Number
           OIFRQD = 'N';                         // Force Qty Disc Y/N
           OISPFL = *Blanks;                     // Summary Pickslip Flag Y/N
           OINPSL = *Blanks;                     // No Pickslip FutureRelease
           OIRQTY = *Zeros;                      // Pre Release Qty
           OIPOST = *Blanks;                     // Post Flag
           OICCDC = *Zeros;                      // C&C Or Sale Disc. %
           OIDTRQ = OHDTRQ;                      // Req Ship Date
           OIRVDT = RqTodayYMD7;                 // Req Ship Date CYMD

SUD07 *?   // Get Sow Date from GETGERM (CYMD)
SUD07      GETGERM(OIITEM:OISIZE:OIWHSE:OIRVDT:OISOW);

      *?   // From FHORDR File
           OICUST = OHCUST;                      // Customer #
           OISLM1 = OHSLM1;                      // SalesPerson 1
           OISHPC = OHSHPC;                      // Ship Via

      *?   // Convert Quantity to KubePak Quantity
           WkOQty = *Zeros;
           If CDORDQTY <> *Zeros;
              Chain OISIZE FMSIZE;
              If %Found and SZSTAT = 'A';
                 WkOQty = CDORDQTY/SZSALE;

VV01  *?         // Check Remainder for Ordered Qty, if not 0 then round off
 |               WkOrdQty1 = *Zeros;
 |               WkRem     = *Zeros;
 |               WkOrdQty1 = %Int(CDORDQTY);
 |               WkRem = %Rem(WkOrdQty1:SZSALE);
 |               If WkRem <> 0;
 |                  WkOQty = %IntH(WkOQty);
VV01             Endif;
              Else;
                 WkOQty = CDORDQTY;
              Endif;
           Else;
              WkOQty = CDORDQTY;
           Endif;

SUD02 *?   // Check Qty & Set status as 'Deleted' for cancelled orders
           If WkOQty = *Zeros;
VV10          If OCORFLG = 'Y' or WkNewLn = 'Y';
 |               OISTAT = 'D';
VV08          Endif;
SUD02      Else;
SUD02         OISTAT = 'A';
           Endif;

      *?   // Get Allocated Quantity and Process
SUD04      WkParInd = *Off;
           WkQty = *Zeros;
           ALCLOTINV(OHORD#:OISEQ#:OHCUST:IXRLCLITEM:IXRLCLSIZE:
SUD04                WkDte:WkOQTY:WkQty:WkLotC:WkParInd);

      *?   // Add Qty to existing quantity for records having OCORFLG='N'
      *?   // Overwrite FIORDR qty only if diff qty is avl else
      *?   // Retain original qty
VV05       If WkAddQFg = 'Y';
VV09          If WkQty > 0 and WkAddQty > 0;
VV09             OIQORD = WkQty;
  |           Endif;
VV05       Else;

VV08  *?      //Update quantity in FIORDR only if OCORFLG flag is 'Y' in WSORCHCPF
VV10          If OCORFLG = 'Y' or WkNewLn ='Y';
                 OIQORD = WkQty;
VV08          Endif;
VV05       Endif;

           OHLOTC = WkLotC;                                     //WJB02
           OILOTC = WkLotC;                                     //WJB02

VV03  *?   //Write a record in FIORDRB2BC file with blank comment for diff Req date and qty >0
VV03       Exsr WriteB2BCmt;

VV07  *?   //If Available qty =0 and not Additional qty check and Check order flag='Y'
VV07  *?   //Call INVAVLSTS program to write record in FIORDRB2BC file
VV10       If WkQty = 0  and WkAddQFg = 'N' and (OCORFLG= 'Y' or WkNewLn = 'Y');
VV07          Exsr CheckAvlSts;
VV07       Endif;

VV07  *?   //If Confirmed qty >0 and < Ordered Qty and not Additional qty check
VV10       If WkQty > 0 and WkQty < WkOQTY and WkAddQFg = 'N'
VV10                    and (OCORFLG='Y' or WkNewLn = 'Y');
VV07          ErrDesc = 'Full Qty not Avail for this Ship Wk';
  |           Exsr WriteB2BErr;
VV07       Endif;

VV05  *?   // Avlb qty is less than Req Qty Write infomsg into ErrExpPf
  |   *?   // Do not send Info message for Order/line having OCORFLG='N'
VV05       If WkOQTY <> *Zeros and WkOQTY > WkQty and WkAddQFg = 'N';
              If WkQty <> *Zeros;
                 WkDta = %Char(WkQty) + %Char(WkOQty);
                 WkMsgId = 'WS00025';
              Else;
                 WkMsgId = 'WS00046';
              Endif;
              Exsr InfoSr;
           Endif;

           OIEXT$ = OIQORD * OIUPRI;                // Ext Amount

      *?   // From FMTAXF File
           If CMTXST = 'N';
              Chain CMTXJU FMTAXF;
              If %Found and TXSTAT = 'A';
                 OIAMT1 = TXPCT1;                   // Tax Amt Rate 1
                 OIAMT2 = TXPCT2;                   // Tax Amt Rate 2
                 OIAMT3 = TXPCT3;                   // Tax Amt Rate 3
              Endif;
           Endif;

      *?   // Check Condition
           If OIAMT1 <> *Zeros and OIAMT2 <> *Zeros and OIAMT2 <> *Zeros;
              OITXCD = 'Y';                      // Tax Item Code 1
           Else;
              OITXCD = 'N';                      // Tax Item Code 1
           Endif;

           If OIAMT1 <> *Zeros;
              OITXST = 'Y';                      // Tax Item Code 2
           Else;
              OITXST = 'N';                      // Tax Item Code 2
           Endif;

           If OIAMT2 <> *Zeros;
              OITXCT = 'Y';                      // Tax Item Code 3
           Else;
              OITXCT = 'N';                      // Tax Item Code 3
           Endif;

           If OIAMT3 <> *Zeros;
              OITXLC = 'Y';                      // Tax Item Code 4
           Else;
              OITXLC = 'N';                      // Tax Item Code 4
           Endif;

      *?   // Tax Calculation
           Tax1  = OIAMT1 * OIUPRI;              // ST Tax on Item
           Tax2  = OIAMT2 * OIUPRI;              // CO Tax on Item
           Tax3  = OIAMT3 * OIUPRI;              // MU Tax on Item

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------------:
      *?            : ConsiderAllOrdersSubroutine :
      *?            :-----------------------------:
      *
      *?Logic : Read Order Detail file Calculate Tax amount ,
      *?        Add Comment and Update record into Order History File
      *
        Begsr ConsiderAllOrders;

      *?   // Read Order Detail File
           Setll OHORD# FIORDRL15;
           ReadE OHORD# FIORDRL15;
           Dow Not %Eof;

      *?      // Tax Calculation
              Tax1  = OIAMT1 * OIUPRI;              // ST Tax on Item
              Tax2  = OIAMT2 * OIUPRI;              // CO Tax on Item
              Tax3  = OIAMT3 * OIUPRI;              // MU Tax on Item

      *?      // Calculate Total value for All items
              TotalTax01 = TotalTax01 + Tax1;       // ST Total Tax
              TotalTax02 = TotalTax02 + Tax2;       // CO Total Tax
              TotalTax03 = TotalTax03 + Tax3;       // MU Total Tax
              TotalOrder = TotalOrder + OIEXT$;     // Total Order

              ReadE OHORD# FIORDRL15;
           EndDo;

      *?   // Check total quantity for cancelled orders and update
           Exec Sql
              Select Sum(CDORDQTY) Into :WkTotQty From WSCODTLL0
              Where CDFRORID = :PFromOrgId And CDHDRSEQ = :PSeqno And
              CDBRKORID = :PCustPO;

      *?   // Update Order Header line as 'D' if Total qty is Zero
           If WkTotQty = *Zeros;
              OHSTAT = 'D';

      *?      // Update All Order Detail lines as 'D' if header is 'D'
              Exec Sql
                 Update FIORDR set OISTAT='D' where OIORD#=:WkOrdNo;
           Endif;

      *?   // Update Order Header Values for the order
           OHAMT1 = TotalTax01;                  // Tax Amt 1
           OHAMT2 = TotalTax02;                  // Tax Amt 2
           OHAMT3 = TotalTax03;                  // Tax Amt 3

      *?   // Update Customer Master File
           Chain CMCUST FMCUST;
           If %Found;
              CMOCUR = CMOCUR + 1;
              CMOYTD = CMOYTD + 1;
              CMDTLO = TodayMDY;
              CMVOPO = CMVOPO + TotalOrder;
              Update RMCUST %Fields(CMOCUR:CMOYTD:CMDTLO:CMVOPO);
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : UpdateHDR Subroutine :
      *?            :----------------------:
      *
      *?Logic : Update Header and History Header File for the order
      *?
        Begsr UpdateHDR;

      *?   // Update Order Header
           Update RHORDR;

      *?   // Update Order History Header
           HSTUSER = User;
           HSTPROGRAM = Pgm;
           HSTTIME = $timestamp();
           Write RHORDRHIST;

      *?   // Write/Update Comments in Order Detail File
           $Comment(OHORD#);

        Endsr;
      //--------------------------------------------------------------------
      *?            :----------------------:
      *?            : WriteCntF Subroutine :
      *?            :----------------------:
      *
      *?Logic : Write a record into Order Change Control File
      *?
        Begsr WriteCntF;

      *?   // Clear Record
           Clear WSORCHCR;

      *?   // Move Values into Open Order File
           OCFRORID  = CHFRORID;
           OCBRKORID = CHBRKORID;
           OCPOSEQ   = CHSEQNO;
           OCBRKSLD  = CHSLDNUM;
           OCBRKSHP  = CHSHPNUM;
           OCCUST    = CMCUST;
           OCORDNO   = OIORD#;
           OCORDLIN  = OISEQ#;
           OCBRKLNE  = CDBRKLNE;
           OCBRKMAT  = CDBRKMAT;
           OCITEM    = OIITEM;
           OCIMSZE   = OISIZE;
           OCORFLG   = 'Y';
           OCORMSGID = *Blanks;
           OCORMSGD  = *Blanks;

      *?   // Audit Stamp
           OCCRTDAT = Rundate;
           OCCRTTIM = Runtime;
           OCCRTUSR = User;
           OCCRTJOB = Job;
           OCCRTPGM = Pgm;

      *?   // Write Record
           Write WSORCHCR;

        Endsr;
      //--------------------------------------------------------------------
VV03  *?            :------------------------:
  |   *?            : WriteB2BCmt Subroutine :
  |   *?            :------------------------:
  |   *
  |   *?Logic : Write a record into Order Detail B2B Comments file
  |   *?
  |     Begsr WriteB2BCmt;
  |
  |   *?   // If ReqShipDate is changed and Qty is available only
  |        If WkDtlUpd = 'Y' and WkQty > 0;
  |
  |   *?      // Clear and Write Record
  |           Clear RIORDRB2BC;
  |           B2BORD# = CDORDNO;
VV10          B2BSEQ# = OISEQ#;
  |           B2BCMNT = *Blanks;
  |           B2BTIME = %Timestamp();
  |           B2BUSER = User;
  |           Write RIORDRB2BC;
  |        Endif;
  |
VV03    Endsr;
      //--------------------------------------------------------------------
VV07  *?            :------------------------:
  |   *?            : WriteB2BErr Subroutine :
  |   *?            :------------------------:
  |   *
  |   *?Logic : Write a record into Order Detail B2B Comments file for any error encountered
  |   *?
  |     Begsr WriteB2BErr;
  |
  |   *?   // Clear and Write Record
  |        Clear RIORDRB2BC;
  |        B2BORD# = CDORDNO;
VV10       B2BSEQ# = OISEQ#;
  |        B2BCMNT = ErrDesc;
  |        B2BTIME = %Timestamp();
  |        B2BUSER = User;
  |        Write RIORDRB2BC;
  |
VV07    Endsr;
      //--------------------------------------------------------------------
VV05  *?            :----------------------:
  |   *?            : ChkAddQty Subroutine :
  |   *?            :----------------------:
  |   *
  |   *?Logic : Check if quantity is available to be added to the existing line if CDORDQTY > OIQORD
  |   *?        For same ReqShip Date, No 0 Seq record and OCORFLG = 'N' in WSORCHCPF
  |   *?
  |     Begsr ChkAddQty;
  |
  |   *?   // Get difference qty to be checked if available
  |        WkAddQFg = 'Y';
  |        WkDifQty = *Zeros;
  |        WkAddQty = *Zeros;
  |        WkDifQty = CDORDQTY - WKOQty;
  |
  |   *?   // Convert the different qty to Kubepak qty to check for availability
  |        Chain OISIZE FMSIZE;
  |        If %Found and SZSTAT = 'A';
  |           WkOQty = WkDifQty / SZSALE;
  |
  |   *?      // Check Remainder for Ordered Qty, if not 0 then round off
  |           WkOrdQty1 = *Zeros;
  |           WkRem     = *Zeros;
  |           WkOrdQty1 = %Int(WkDifQTY);
  |           WkRem = %Rem(WkOrdQty1:SZSALE);
  |           If WkRem <> 0;
  |              WkOQty = %IntH(WkOQty);
  |           Endif;
  |        Else;
  |           WkOQty = WkDifQty;
  |        Endif;
  |
  |   *?   // Get Available Quantity before process
  |        WkQty = *Zeros;
  |        WkParInd = *Off;
  |
  |        GETAVLINV(OIITEM:OISIZE:WkDte:WkOQTY:WkQty:
  |                   WkLotC:WkParInd);
  |
  |        If WkQty <> 0;
  |           WkAddQty = WkQty;
  |        Endif;
  |
  |   *?   // Move Diff Qty back to Broker Qty for further calculation with CDORDQTY
  |        WkOQty = WkDifQty;
  |
VV05    Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : WSHdrAudit Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Move values into Audit Fields
      *?
        Begsr WSHdrAudit;

      *?   // Audit Stamp
           CHUPDDAT = Rundate;
           CHUPDTIM = Runtime;
           CHUPDUSR = User;
           CHUPDJOB = Job;
           CHUPDPGM = Pgm;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : WSDtlAudit Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Move values into Audit Fields
      *?
        Begsr WSDtlAudit;

      *?   // Audit Stamp
           CDUPDDAT = Rundate;
           CDUPDTIM = Runtime;
           CDUPDUSR = User;
           CDUPDJOB = Job;
           CDUPDPGM = Pgm;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-----------------------:
      *?            : WSErrAudit Subroutine :
      *?            :-----------------------:
      *
      *?Logic : Move values into Audit Fields
      *?
        Begsr WSErrAudit;

      *?   // Audit Stamp
           ERCRTDAT = Rundate;
           ERCRTTIM = Runtime;
           ERCRTUSR = User;
           ERCRTJOB = Job;
           ERCRTPGM = Pgm;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-------------------:
      *?            : EndPgm Subroutine :
      *?            :-------------------:
      *
      *?Logic : Stuff that needs to run after an order change is processed  WJB0
      *?
        Begsr EndPgm;
        Endsr;
      *?----------------- End of Subroutines ------------------------------
