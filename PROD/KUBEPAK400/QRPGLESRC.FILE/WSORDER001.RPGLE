      *? Program        : WSORDER001
      *?
      *? Description    : This pgm to Consume PO XML into RPG from webservice
      *?                  and send back Response
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 16 Nov 2017
      //--------------------------------------------------------------------
      *? Special Notes  :** XML response only for Successful PO Creation
      *
      *? Called Program : WSPORCV001 - For Purchase Order Creation
      *?                  WSCORCV001 - For Change Order
      *?                  WSPORCVMCH - Only For Michell Create Order & Order Change
      *?                  WSSAVXML01 - For saving xml in Reprocess folder
      *
      *? Response       : Acknowledgement Status for Brokers
      //------------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ----------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ----------------------------------------
      *         01/31/19   Vimala       Added Reprocess Logic based on Parameter File
      * SUD01   08/02/19   S.Uthaya     Added Tag for Michell
      //------------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
      *
        Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
           ActGrp ('HTTP') BndDir('QC2LE');
      //------------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Broker Defaults and Control Logical File
      *?Key : Broker Number:Broker Variable
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - XML Order Process Log File
        Dcl-F WSORDLOGPF Disk(*Ext) Keyed Usage(*Output);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry (From Webservice Call)
        Dcl-Pi WSORDER001;
           POXml           Char(1000000);
           Httpstatus      Int(10:0);
           Acknowledgement Like(PBrkAck);
        End-Pi;

      *?Procedure Prototype Declaration : PO Creation Program
        Dcl-Pr WSPORCV001 Extpgm('WSPORCV001');
           POXml           Char(1000000);
           Httpstatus      Int(10:0);
           Acknowledgement Like(PBrkAck);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Change Order Program
        Dcl-Pr WSCORCV001 Extpgm('WSCORCV001');
           POXml           Char(1000000);
           Httpstatus      Int(10:0);
           Acknowledgement Like(PBrkAck);
        End-Pr;
      *
      *?Procedure Prototype Declaration : PO/CO Creation Program for Michell
        Dcl-Pr WSPORCVMCH Extpgm('WSPORCVMCH');
           POXml           Char(1000000);
           Httpstatus      Int(10:0);
           Acknowledgement Like(PBrkAck);
        End-Pr;
      *
      *?Procedure Prototype Declaration : Program to store xml for Re-process
        Dcl-Pr WSSAVXML01 Extpgm('WSSAVXML01');
           POXml      Char(1000000);
           WkFromOrg  Char(30);
           WkBrokerId Char(10);
           Flag       Char(2);
           Process    Char(1);
        End-Pr;
      *
      *?Data Structure Declaration : OrderHeader
        Dcl-Ds OrderHeader  Qualified;
           IncomingType     Char(1);
           BrokerRevision   Char(2);
           BrokerOrderId    Char(10);
SUD01      Broker_Order_ID  Char(10);
        End-Ds;
      *
      *?Data Structure Declaration : Identification
        Dcl-Ds Identification  Qualified;
           FromOrg_ID           Char(30);
        End-Ds;
      *
      *?Program Status Data Structure : PSDS
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           JobNum  Zoned(6) Pos(264);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Workl Variable Declaration :
        Dcl-S WkExtra      Char(55);
        Dcl-S WkTag        Char(30);
        Dcl-S WkTagS       Char(35);
        Dcl-S WkPause      Char(1);
        Dcl-S WkFromOrg    Char(30);
        Dcl-S WkBrokerId   Char(10);
      *
      *?Global Variable Declaration :
        Dcl-S Options  Char(150);
        Dcl-S Flag     Char(2)   Inz;
        Dcl-S Process  Char(1)   Inz;
        Dcl-S Pos      Zoned(3)  Inz;
      *
      *?Parameter Variable Declaration :
        Dcl-S PBrkAck  Char(1000000) Inz;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

      *?   // Execute Initialize
           Exsr InzPgm;

      *?   // Call Program based on XML Type
           If Flag <> *Blanks and HttpStatus = 200;

      *?      // Check if all xmls need to be held and moved to Reprocess folder
              WkPause = 'N';
              Chain ('1000':'PAUSEALLB2B') FBROKDFTL0;
              If %Found;
                 WkPause =  %Trim(DFVARVAL);
              Endif;

      *?      // Check if Xmls based on Broker need to be held and moved to Reprocess folder
              If WkPause = 'N';
                 Chain (WkFromOrg: 'PAUSEB2B') FBROKDFTL0;
                 If %Found;
                    WkPause =  %Trim(DFVARVAL);
                 Endif;
              Endif;

      *?      // Call program to move the xml to Reprocess folder
              If WkPause = 'Y';
                 Process = 'R';
                 WSSAVXML01(POXml:WkFromOrg:WkBrokerId:Flag:Process);
              Endif;

      *?      // If PauseAll or PauseBroker is 'N', the process the xml
              If WkPause = 'N';

      *?         // Call a different program for Michell
                 If WkTag = 'MichellPurchaseOrder_V2';
                    Monitor;
                       WSPORCVMCH(POXml:HttpStatus:PBrkAck);
                       Acknowledgement = PBrkAck;
                    On-Error;
                       HttpStatus = 500;
                    EndMon;
                 Else;

      *?            // For Create Order
                    If Flag = 'PO';
                       Monitor;
                         WSPORCV001(POXml:HttpStatus:PBrkAck);
                         Acknowledgement = PBrkAck;
                       On-Error;
                          HttpStatus = 500;
                       EndMon;
                    Elseif Flag = 'CO';

      *?               // For Change Order
                       Monitor;
                          WSCORCV001(POXml:HttpStatus:PBrkAck);
                          Acknowledgement = PBrkAck;
                       On-Error;
                          HttpStatus = 500;
                       EndMon;
                    Endif;
                 Endif;
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

      *?   // Initialise Response Parameters
           HttpStatus  = 200;        // Success Code

      *?   // Clear Variables
           Clear Flag;
           Pos = *Zeros;
           PBrkAck = *Blanks;

      *?   // Validate Input XML
           Exsr Validate;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : Validate Subroutine :
      *?                :---------------------:
      *
      *?Logic : Mandatory Parameters Validation & Get XML Order type
      *?
        Begsr Validate;

      *?   // Mandatory Parameters Validation
           If POXml = *Blanks;
              Httpstatus = 400;                    //Invalid Parameter
              Exsr EndPgm;
           Endif;

      *?   // Get xml tag to get the FromOrgId to check if xml needs to be held or not
           Exsr GetIdenSr;

      *?   // Check Flag and Process
           If Flag <> 'PO' And  Flag <> 'CO';
              Httpstatus = 400;                    //Invalid Parameter
              Exsr EndPgm;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : GetIdenSr Subroutine :
      *?                :----------------------:
      *
      *?Logic : Get the xml tag to get the FromOrgId
      *
        Begsr GetIdenSr;

      *?   // To Identify Broker for the Process - Create Order Process tag
           WkTag = *Blanks;
           Setll ('1000' : 'XMLPOTAG') FBROKDFTL0;
           ReadE ('1000' : 'XMLPOTAG') FBROKDFTL0;
           Dow  Not %Eof;
              WkTag  =  %Trim(DFVARVAL);
              WkTagS =  %Trim(DFVARVAL) + '>';
              Pos = %Scan(%Trim(WkTagS):POXml:1);
              If Pos <> *Zeros;

      *?         // Set Flag by default, changes for Gloeckner
                 Flag = 'PO';

      *?         // Get xml tags and set flags appropriately
                 Exsr GetXmlTagSr;
                 Leave;
              Endif;
              ReadE ('1000' : 'XMLPOTAG') FBROKDFTL0;
           EndDo;

      *?   // Check for Change Order Process tag
           If Pos = *Zeros;
              Setll ('1000' : 'XMLCOTAG') FBROKDFTL0;
              ReadE ('1000' : 'XMLCOTAG') FBROKDFTL0;
              Dow  Not %Eof;
                 WkTag  =  %Trim(DFVARVAL);
                 WkTagS =  %Trim(DFVARVAL) + '>';
                 Pos = %Scan(%Trim(WkTagS):POXml:1);
                 If Pos <> *Zeros;

      *?            // Set flag by default, changes for Gloeckner
                    Flag = 'CO';

      *?            // Get xml tags and set flags appropriately
                    Exsr GetXmlTagSr;
                    Leave;
                 Endif;
                 ReadE ('1000' : 'XMLCOTAG') FBROKDFTL0;
              EndDo;
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :------------------------:
      *?                : GetXmlTagSr Subroutine :
      *?                :------------------------:
      *
      *?Logic : Get xml tags for Identification and Order Header
      *
        Begsr GetXmlTagSr;

      *?   // Get FromOrg_id from Identification Data Structure
           WkExtra = 'allowextra=yes allowmissing=yes case=any doc=string';

      *?   // Identification Data Structure
           Options = 'path=' + %Trim(WkTag) + '/Identification ' +
                        %Trim(WkExtra) ;
           Monitor;
              Xml-Into Identification %XML(POXml:Options);
           On-Error;
              HttpStatus = 500;
           EndMon;
           WkFromOrg = Identification.FromOrg_Id;

      *?   // Get Values into OrderHeader Data Structure
           Options = 'path=' + %Trim(WkTag) + '/OrderHeader ' +
                        %Trim(WkExtra) ;
           Monitor;
              Xml-Into OrderHeader %XML(POXml:Options);
           On-Error;
              HttpStatus = 500;
           EndMon;
           WkBrokerId = OrderHeader.BrokerOrderId;
SUD01      If WkBrokerId = *Blanks;
SUD01         WkBrokerId = OrderHeader.Broker_Order_ID;
           Endif;

      *?   // If Gloeckner check for PO or CO
           Exsr GetDs;

        EndSr;
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : GetDs Subroutine :
      *?                :------------------:
      *
        Begsr GetDs;

      *?   // Check Type of Order for Gloeckner
           If WkTag = 'GloecknerPurchaseOrderChange';
              If OrderHeader.IncomingType = 'N' and
                 OrderHeader.BrokerRevision = '0';
                 Flag = 'PO';                                 // Gloeckner Order Create
              Elseif OrderHeader.IncomingType = 'M' and
                 OrderHeader.BrokerRevision <> '0';
                 Flag = 'CO';                                 // Gloeckner Change Order
              Endif;
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :---------------------:
      *?                : B2BLogSr Subroutine :
      *?                :---------------------:
      *
      *?Write a record into Audid file based on Httpstatus
      *
        Begsr B2BLogSr;

      *?   // Check Http Status only if WkPause = 'N'
           If WkPause = 'Y';
              OLMSG = 'Xml Paused from Processing. Please check With Kube-Pak';
              Acknowledgement = %Trim(OLMSG);
           Else;
      *?      // Check Http Status and write a Log
              If HttpStatus = 200;
                 OLMSG  = PBrkAck;
              Elseif HttpStatus = 400;
                 OLMSG = 'Invalid Xml';
              Elseif HttpStatus = 500;
                 Process = 'E';
                 WSSAVXML01(POXml:WkFromOrg:WkBrokerId:Flag:Process);
                 Acknowledgement = 'Xml Tag Upload Error';
                 OLMSG = Acknowledgement;
              Endif;
           Endif;

      *?   // Write a Log Record
           OLFRORID  = WkFromOrg;
           OLBRKORID = WkBrokerId;
           OLCRTDAT  = Rundate;
           OLCRTTIM  = Runtime;
           OLCRTUSR  = User;
           OLCRTJOB  = Job;
           OLCRTJBN  = JobNum;
           OLCRTPGM  = Pgm;
           Write WSORDLOGR;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Write B2B Audit File
           Exsr B2BLogSr;

      *?   // End the Program
           *InLr = *On;
           Return;

        EndSr;
      *?---------------- End Of Subroutines --------------------------------
