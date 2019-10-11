      *? Program         : WSPLGORCRT
      *?
      *? Description     : This Pgm is to Create Orders Entered using
      *?                   Plug Order Entry Screen
      *? Created By      : Vimala
      *?
      *? Date            : 23 Jul 2018
      //--------------------------------------------------------------------
      *? Special Notes   :** Called from WSPLGORD04 - Plug Order Entry Summary Screen
      *?                  ** Write PO XML Header and Detail based on XML Work file
      *?                  ** Call PO Validation Program to Create Order
      *
      *? Called Program  : WSPOVAL002 - WS - XML File Validation and Order Creation
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
        Ctl-Opt DftActGrp(*No) Option(*SrcStmt : *NoDebugIO) Debug(*Yes)
           BndDir('*LIBL/KPFUNCTION') DatFmt(*Usa);
        /COPY QFunctDefn,@CopyRight
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Plug Order Work File - Build XML
        Dcl-F WPLGORXML0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - XML Order Create Header File
        Dcl-F WSPOHDRPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File: WS - XML Order Create Header Logical File
      *?Key : From Org Id : Sequence Number
        Dcl-F WSPOHDRL0  Disk(*Ext) Keyed Usage(*Input) Rename(WSPOHDRR:Rec1)
                                                        Prefix(H);
      *?Key : From Org ID:Customer PO:Header Seq No
        Dcl-F WSPOHDRL1  Disk(*Ext) Keyed Usage(*Input) Rename(WSPOHDRR:Rec2)
                                                        Prefix(I);
      *?File: WS - XML Order Create Detail File
        Dcl-F WSPODTLPF  Disk(*Ext) Usage(*Output:*Update) Usropn;
      *
      *?File: M/F Customer Master File
      *?Key : Customer Number
        Dcl-F FMCUST     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Ship Via Code Master File
      *?Key : Ship Via Code
        Dcl-F FMSVIA     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Size Code Master File
      *?Key : Size Code
        Dcl-F FMSIZE     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Update:*Output);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From WSPLGORD04)
        Dcl-Pi WSPLGORCRT;
           PCust#  Packed(6);
           PReqDt  Packed(8);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Validation Program
        Dcl-Pr WSPOVAL002 Extpgm;
          PFromOrgId Like(PFromOrgId);
          PBrkID     Like(PBrkID);
          PSeqno     Like(PSeqno);
          PFlag      Like(PFlag);
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
      *?Work Variable Declaration :
        Dcl-S WkDate     Zoned(6);
        Dcl-S WkCust     Packed(6);
        Dcl-S WkBrkId    Packed(6);
        Dcl-S WkRefNo    Packed(6);
        Dcl-S WkOrder#   Packed(6);
        Dcl-S WkFrmOrgId Like(PHFRORID);
        Dcl-S WkRefId    Like(PHREFID);
        Dcl-S WkSeqno    Like(PHSEQNO);
      *
      *?Function Variable Declaration :
        Dcl-S ThisMonday Zoned(6) Inz;
        Dcl-S Today      Date;
      *
      *?Parameter Variable Declaration :
        Dcl-S PFromOrgId Like(PHFRORID);
        Dcl-S PBrkID     Like(PHBRKORID);
        Dcl-S PSeqno     Like(PHSEQNO);
        Dcl-S PFlag      Like(PHFLAG);
      //--------------------------------------------------------------------
      *?                :--------------:
      *?                : Copy  Source :
      *?                :--------------:
      *
      *?Service Programs
    ? /COPY QFunctDefn,$Date
    ? /COPY QFunctDefn,$MDYDate
    ? /COPY QFunctDefn,$Monday
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Execute Initialize
           Exsr InzPgm;

      *?   // Call Validation Program
           If PHFLAG = ' ';
              WSPOVAL002(PHFRORID:PHBRKORID:PHSEQNO:PFlag);
              If PFlag = 'C';

      *?         // Process Flag is 'C', Return Order # to called Program
                 Chain (PHFRORID:PHBRKORID:PHSEQNO) WSPOHDRL1;
                 If %Found;
                    WkOrder# = IPHORDNO;
                 Endif;

      *?         // If Order Created, update Order# in WPLGORXML file
                 Exec Sql
                    Update WPLGORXML set WXORDNO=:WkOrder# Where
                        WXCUST = :PCust# and WXRQDTE = : PReqDt;
              Endif;
           Endif;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Parameters & Proceed Validation
      *?
        Begsr InzPgm;

      *?   // Get Monday Date for Current date
           Today       = $Date(0);                           // Today MDY
           ThisMonday  = $MDYDate($Monday(Today:'FRI'));     // Monday MDY
           WkDate      = ThisMonday;

      *?   // Process Data from WPLGORXML
           Exsr Process;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // End the Program
           *InLr = *On;
           Return;

        Endsr;
      //--------------------------------------------------------------------
      *?            :--------------------:
      *?            : Process Subroutine :
      *?            :--------------------:
      *
      *?Logic : Read WPLGORXML by date and write into Header/Detail

        Begsr Process;

      *?   // Get Bill to Customer Details for the Customer
           Exec Sql
              Select CMBLCU into :WkCust From FMCUST Where CMCUST = :PCUST#;

      *?   // Write Xml Header File
           Exsr WriteHeader;

      *?   // Process Plug Order XML file to write Detail records for Cust/Date
           Setll (PCust#:PReqDt) WPLGORXML0;
           Reade (PCust#:PReqDt) WPLGORXML0;
           Dow Not %Eof;

      *?      // Write Xml Detail File
              Exsr WriteDetail;

              Reade (PCust#:PReqDt) WPLGORXML0;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteHeader Subroutine :
      *?            :------------------------:
      *
      *?Logic : Write PO Header File based on Customer/Date received

        Begsr WriteHeader;

      *?   // Open Files
           Open WSPOHDRPF;

      *?   // Clear Record Format
           Clear WSPOHDRR;

      *?   // Get Highest Sequence number from file
           WkFrmOrgId = 'Kube Pak';
           Setgt WkFrmOrgId WSPOHDRL0;
           ReadPE WkFrmOrgId WSPOHDRL0;
           If Not %Eof;
             If HPHSEQNO = 999999999;
                HPHSEQNO = 1;
             Else;
                HPHSEQNO += 1;
             Endif;
           Else;
             HPHSEQNO  = 1;
           Endif;
           PHSEQNO = HPHSEQNO;

      *?   // Generate Unique Reference ID
           Chain ('1000':'Unique Reference ID') FBrokDftL0;
           If %Found;
              WkRefNo = %Int(DFVARVAL);
              WkRefId = %Char(%Date) + ':' + %Char(%Time()) + ':' +
                                              %Char((DFVARVAL));
              If WkRefNo = 999999;
                 WkRefNo = 000001;
              Else;
                 WkRefNo  += 1;
              Endif;
              DFVARVAL = %Editc(WkRefNo:'X');
              Update RBROKDFT %Fields(DFVARVAL);
           Endif;
           PHREFID   = WkRefId;

      *?   // Generate Customer Broker ID
           Chain ('1000':'Plug Order Id') FBrokDftL0;
           If %Found;
              WkBrkId = %Int(DFVARVAL);
              If WkBrkId= 999999;
                 WkBrkId= 000001;
              Else;
                 WkBrkId += 1;
              Endif;
              DFVARVAL = %Editc(WkBrkId :'X');
              Update RBROKDFT %Fields(DFVARVAL);
           Endif;
           PHBRKORID = 'PLUG' + %EditC(WkBrkId:'X');

      *?   // Identification Part
           PHMSGPR   = *Blanks;
           PHFRORID  = WkFrmOrgId;
           PHTOORID  = WkFrmOrgId;
           PHSNDORID = 'Plug-Order';

      *?   // Date Fields
           PHIDATE  = %Char(%Date(PReqDt:*ISO));
           PHRQSHDT = %Date(PReqDt:*ISO);
           PHORDDAT = %Date(PReqDt:*ISO);
           PHBRKCRDT= %Date(WkDate:*MDY);                         // Added for Sql Purpose
           PHBRKUPDT= %Date(WkDate:*MDY);                         // Added for Sql Purpose

      *?   // Other Header Fields
           PHBKOROK = '01';
           PHVENDID = *Blanks;
           PHCUSTPO = *Blanks;
           PHFREMTH = *Blanks;
           PHSHPINS = *Blanks;
           PHSUBSOK = *Blanks;
           PHSALNAM = *Blanks;
           PHLNITMN = *Zeros;
           PHTOTQTY = *Zeros;
           PHBRKCID = *Blanks;
           PHSALID  = *Blanks;
           PHVENID  = *Blanks;
           PHBRKSTS = *Blanks;
           PHCUSNAM = *Blanks;

      *?   // Order Header - Sold To - Bill To Customer details
           Chain WkCust FMCUST;
           If %Found;
              PHSLDNUM = %Char(WkCust);
              PHSLDNAM = CMNAME;
              PHSLDCON = CMCNME;
              PHSLDAD1 = CMADD2;
              PHSLDAD2 = CMADD3;
              PHSLDCTY = CMCITY;
              PHSLDSTE = CMSTST;
              PHSLDZIP = CMZIP;
              PHSLDCNTY= *Blanks;
              PHSLDFAX = *Blanks;
              PHSLDPHN = %Char(CMPHON);
              PHSLDEML = *Blanks;
              PHSLDBADR= *Blanks;
              PHVENCUSID = *Blanks;
           Endif;

      *?   // Order Header - Ship To
           Chain PCust# FMCUST;
           If %Found;
              PHSHPNUM = %Char(PCust#);
              PHSHPNAM = CMNAME;
              PHSHPCON = CMCNME;
              PHSHPAD1 = CMADD2;
              PHSHPAD2 = CMADD3;
              PHSHPCTY = CMCITY;
              PHSHPSTE = CMSTST;
              PHSHPCNTY= CMCOUN;
              PHSHPZIP = CMZIP;
              PHSHPFAX = *Blanks;
              PHSHPPHN = %Char(CMPHON);
              PHSHPEML = *Blanks;
              PHSHPBADR= *Blanks;
              PHSHPMTH = CMSVCD;

      *?      // ShipMethod
              Chain CMSVCD FMSVIA;
              If %Found;
                PHSHPMTHD =SVDESC;
              Endif;
           Endif;

      *?   // Audit Stamp
           PHCRTDAT = Rundate;
           PHCRTTIM = Runtime;
           PHCRTUSR = User;
           PHCRTJOB = Job;
           PHCRTPGM = Pgm;

      *?   // Write Rec
           Write WSPOHDRR;

      *?   // Close Files
           Close WSPOHDRPF;

        Endsr;
      //--------------------------------------------------------------------
      *?            :------------------------:
      *?            : WriteDetail Subroutine :
      *?            :------------------------:
      *
      *?Logic : Read WPLGORXML0 file for Customer/Request Date to Write PO Detail File

        Begsr WriteDetail;

      *?   // Open Files
           Open WSPODTLPF;

      *?   // Clear Record Format
           Clear WSPODTLR;

      *?   // Move values from Header file
           PDREFID   = PHREFID;
           PDIDATE   = PHIDATE;
           PDMSGPR   = PHMSGPR;
           PDFRORID  = PHFRORID;
           PDTOORID  = PHTOORID;
           PDSNDORID = PHSNDORID;
           PDHDRSEQ  = PHSEQNO;
           WkSeqNo  += 1;
           PDSEQNO   = WkSeqNo;

      *?   // Order Detail Part
           PDCUSTPO  = PHCUSTPO;
           PDBRKORID = PHBRKORID;
           PDSCHSHDT = %Date(WXRQDTE : *ISO);
           PDBRKMAT  = %Trim(WXITEM) + '-' + %Trim(WXSIZE);
           Chain WXSIZE FMSIZE;
           If %Found and SZSTAT = 'A';
              PDORDQTY = WXOQTY * SZSALE;
           Endif;
           PDBRKLNE +=1 ;
           PDVENMAT  = *Blanks;
           PDVENDSC  = *Blanks;
           PDVENDSC2 = *Blanks;
           PDSTATS   = *Blanks;
           PDQTYCD   = *Zeros;
           PDFLAG    = PHFLAG;

      *?   // Audit Stamp
           PDCRTDAT  = Rundate;
           PDCRTTIM  = Runtime;
           PDCRTUSR  = User;
           PDCRTJOB  = Job;
           PDCRTPGM  = Pgm;

      *?   // Write Rec
           Write WSPODTLR;

      *?   // Close Files
           Close WSPODTLPF;

        Endsr;
      *?---------------- End Of Subroutines --------------------------------
