      *? Program        : WSINVAVLTT  TEST TEST TEST TEST
      *?
      *? Description    : This program to Generate Inventory XML using GET
      *?                  method for Available Quantity
      *? Created By     : S.Uthayadurga
      *?
      *? Date           : 31 Oct 2017
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
        Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
           Debug(*Yes) ActGrp ('HTTP') BndDir('QC2LE');
      *
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: Outfile for All Quantity
        Dcl-F WSINV_AVL Disk(*Ext) Usage(*Input) Rename(WSINV_AVL:Rec1);
      *
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSINVAVLTT;
           PInvXml Char(12000000) Options(*Varsize);
           Httpstatus  Int(10:0);
        End-Pi;
      *
      *?Procedure Prototype Declaration : WSINVAVLQ
        Dcl-Pr WSINVAVLQ extpgm;
        End-Pr;
      *
      *?Procedure Prototype Declaration : AddXml Part
        Dcl-Pr AddToXml;
           Tagname      Char(50)    Value;
           Tagval       Char(300)   Value;
           Info         Char(10)    Value;
        End-Pr;
      *
      *?Program Status Data Strucure :
        Dcl-Ds Pgmstatus PSDS;
           Job     Char(10) Pos(244);
           User    Char(10) Pos(254);
           Rundate Zoned(6) Pos(276);
           Runtime Zoned(6) Pos(282);
           Pgm     Char(10) Pos(334);
        End-Ds;
      *
      *?Global Variable Declaration :
        Dcl-S Xml       Char(12000000) Inz;
        Dcl-S Info      Char(10)    Inz;
        Dcl-S WkDtTm    Char(19)    Inz;
      *
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :

           Exsr InzPgm;
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
        Begsr InzPgm;

      *?   // Call Inventory program to generate Available quantity file
              WSINVAVLQ();

      *?   // Clear XML
           PInvXml = *Blanks;
           Xml = *Blanks;

      *?   // Get Date and Time
           WkDtTm = %Char(%Date) + 'T' + %Char(%Time());

      *?   // Excute Process
           Exsr Process;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Return
           *InLR = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
        Begsr Process;

      *?   // Start Tag
           AddToXml('Availability' : *Blanks : 'Starttag');

      *?   // XML Body
           Exsr IdentificationSR;
           Exsr AvailabilityDataSR;

      *?   // End Tag
           AddToXml('Availability' : *Blanks : 'Endtag');

      *?   // Return Xml
           Xml = %ScanRpl('&': '&amp;': xml);
           PInvXml = Xml;
           If PInvXml <> *Blanks;
              HTTPSTATUS=200;
           Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------------:
      *?                : IdentificationSR Subroutine :
      *?                :-----------------------------:
      *
        Begsr IdentificationSR;

      *?   // Move values into Identification Part
           AddToXml('Identification' : *Blanks : 'Opentag');
           AddToXml('Date' : WkDtTm : 'Attribute');
           AddToXml('MessageProtocol_ID' : 'Availability'
                                            : 'Attribute');
           AddToXml('FromOrg_ID' : 'Kube Pak' : 'Attribute');
           AddToXml('ToOrg_ID' : 'Vendor' : 'Attribute');
           AddToXml('SenderOrg_ID' : 'Kube Pak' : 'Closetag');

        EndSr;
      //--------------------------------------------------------
      *?                :-----------------------------:
      *?                : AvailabilityDataSR Subroutine :
      *?                :-----------------------------:
      *
        Begsr AvailabilityDataSR;

      *?   // Generate Xml Availabity Data Part
           AddToXml('AvailabilityData' : *Blanks : 'Starttag');

      *?   // Generate Xml Item for Availabity Data Part
           Exsr ItemAllQty;

           AddToXml('AvailabilityData' : *Blanks : 'Endtag');

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : ItemAllQty Subroutine :
      *?                :-----------------------:
      *
        Begsr ItemAllQty;

      *?   // Read the file to Process XML
           Setll *Start WSINV_AVL;
           Read WSINV_AVL;

             Dow Not %Eof;
              AddToXml('Item' : *Blanks : 'Opentag');
              AddToXml('MaterialID' : WKITEM  : 'Attribute');
              AddToXml('AvailableQty' : WKQTY : 'Attribute');
              AddToXml('ShipWeekMonday' : DATEY00001 : 'Attribute');
              AddToXml('UOM' : WKUOM : 'Closetag');

              Read WSINV_AVL;
             Enddo;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : AddToXml Procedure :
      *?                :--------------------:
      *
      *?Logic   : AddToXml to generate XML Acknowledgement
      *?          Field by field process
      *?Example : Starttag : <Tagname>
      *?          Opentag  : <Tagname
      *?          Closetag :  Tagname/>
      *?          Close    :  Tagname>
      *?          Endtag   : </Tagname>
      *
        Dcl-Proc  AddToXml;
          Dcl-Pi AddToXml;
            Tagname      Char(50)  Value;
            Tagvalue     Char(300) Value;
            Info         Char(10)  Value;
          End-Pi;

      *?  // Check Info to add XML tag
          Select;

             When Info = 'Starttag';
                Xml = %Trimr(Xml) + '<' + %Trim(Tagname)
                                 + %Trim(Tagvalue)  + '>';

             When Info = 'Opentag';
                Xml = %Trimr(Xml) + ' ' + '<' + %Trim(Tagname) ;

             When Info = 'Attribute';
                Xml = %Trimr(Xml) + ' ' + %Trim(Tagname) + '="'
                                 + %Trim(Tagvalue) + '" ';

               When Info = 'Closetag';
                  Xml = %Trimr(Xml) + ' ' + %Trim(Tagname) + '="'
                                   + %Trim(Tagvalue) + '"' + ' />';

               When Info = 'Close';
                  Xml = %Trimr(Xml) + ' ' + %Trim(Tagname) + '="'
                                   + %Trim(Tagvalue) + '"' + ' >';

               When Info = 'Endtag';
                  Xml = %Trimr(Xml) + ' </' + %Trim(Tagname) + '>';

            Endsl;

        End-Proc;
      *?------------- End of Program ----------------------------------
