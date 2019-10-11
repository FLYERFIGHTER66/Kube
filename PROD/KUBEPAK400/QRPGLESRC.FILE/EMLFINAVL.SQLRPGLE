**FREE
  CTL-OPT
    DftActGrp(*No)
    BndDir('*LIBL/KPFUNCTION')
    DatFmt(*Usa);
      /include QFunctDefn,@CopyRight

     //??:````````````````````````````````````````````````````````````:?
     //??: EMLFINAVL                                                  :?
     //??:............................................................:?
     //? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
     //? : Created:  2018                 ? Kube-Pak Corporation ?    :
     //? :      by:  William J. Behr                                  :
      // :............................................................:
      // :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      // :?  Change Log                                              ?:
      // :                                                           ?:
      // : EMLFINAVL Original Version 04/23/2018                     ?:
      // :............................................................:

       dcl-f emlfinavlf WORKSTN(*EXT) SFILE(EMLFINAVS2:RRN02);

      //  Main procedure prototype & interface
       dcl-pr EMLFINAVL end-pr;
       dcl-pi EMLFINAVL END-PI;

      // Local Function Prototypes
       dcl-pr Load01 end-pr;
       dcl-pr Scrn01 end-pr;
       dcl-pr Edit01 end-pr;
       dcl-pr EmailIt end-pr;
       dcl-pr EMCMNT extpgm('EMCMNT');
         *n packed(6:0);
         *n packed(9:0);
         *n ind;
       END-PR;

      // External Function Prototypes
      /include QFunctDefn,$ErrMsg
      /include QFunctDefn,$User
      /include QFunctDefn,$TimeStamp
      /include QFunctDefn,$RtvMsgD
      /include QFunctDefn,$isCust
      /include QFunctDefn,QCMDEXC
      /include QFunctDefn,$_DATES
      /include QFunctDefn,$isEmailAd
      /include QFunctFree,PSDS

      //? Data Structures
       dcl-ds Email_DS;
         CUSNAM char(30);
         EMAIL1 char(40);
         EMAIL2 char(40);
         EMAIL3 char(40);
         EMAILREST char(40);
         EMAIL char(286) Pos(1);
       END-DS;

       dcl-ds Season_DS Inz;
         HSSNCD zoned(2:0) inz(*Zeros);
         HSSEAS char(15) inz(*Blanks);
       END-DS;

       dcl-ds Seasons_DS Inz;
         HSSNCD01 inz(*Zeros);
         HSSEAS01 inz(*Blank);
         HSSNCD02 inz(*Zeros);
         HSSEAS02 inz(*Blank);
         HSSNCD03 inz(*Zeros);
         HSSEAS03 inz(*Blank);
         Seasons char(17) dim(03) pos(1);
       END-DS;


      //? Field Definitions
       dcl-s  Screen         zoned(3:0) Inz(0); // Screen Number
       dcl-s  RRN02          packed(4:0) Inz(0); // Screen Number 02 RRN
       dcl-s  MaxRRN02       packed(4:0) Inz(0); // Screen Number 02 RRN
       dcl-s  SPLJOBNAM      char(10); // JOBNAM
       dcl-s  SPLJOBUSR      char(10); // JOBUSR
       dcl-s  SPLJOBNBR      char(6); // JOBNBR
       dcl-s  Printer        char(10); // Printer to Use
       dcl-s  CustName       char(256); // Cust Name
       dcl-s  BCCEMAIL       varchar(256) Inz('bcc@kubepak.net'); // BCC Email Address
       dcl-s  CustEmail      char(256); // Cust Email Address
       dcl-s  BillCust       zoned(6:0) Inz(0); // Cust Name
       dcl-s  Time@          char(6); // Time Alpha
       dcl-s  TimeStamp@     char(26); // Time Alpha
       dcl-s  User           char(10); // User ID
       dcl-s  NewEmail       ind; //New Email Flag
       dcl-s  CustIn         char(6) Inz('      '); //Customer In
       dcl-s  $quote         char(1) Inz('''');
       dcl-s  HTML           varchar(256)
              Inz('/kube pak/PRODUCTION APPLICATIONS/iSeries Email/Finished Availablity.html');
       dcl-s  STMF           varchar(256)
              Inz('/kube pak/Avail_Out/EMLFINAVL/Kube-Pak Finished Inventory');
       dcl-s  STMF_PDF       varchar(256) Inz;
       dcl-s  STMF_CSV       varchar(256) Inz;
       dcl-s  STMF_XML       varchar(256) Inz;
       dcl-s  STMF_HTML      varchar(256) Inz;
       dcl-s  LastSearch     char(30) Inz;
       dcl-s  CPYTOIMPF      varchar(256);
       dcl-s  xml_field      varchar(256);
       dcl-s  lastRecordXml  ind;


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:

       DoW *InLR <> *On ;
         Select;
           When Screen = 01;
             Edit01();
           When Screen = 02;
             Edit02();
        // When Screen = 03;
        //   Edit03();
           Other;
             $ERR_PROG = PSDS.PROC_PGM;
             clear EMLFINAV01;
             InzSP();
             Load01();
             Scrn01();
         ENDSL;
       ENDDO;

       *InLR = *On;

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 1 SubProcedures                                           :
      // :..................................................................:
       dcl-proc Load01;

       // Load the Customer Email Address if a customer is passed in
       If CustIn <> *Blanks;
         SelCust = %dec(CustIn:6:0);
         GetCustEmail(SelCust);
        else;
         Clear Email;
       ENDIF;

       // Position the cursor on most likely field
       %SubArr(*IN : 40 : 03) = *Off;
       If SELCUST = *Zero;
         *In40 = *On;
         else;
         If SELEMAIL = *Blanks;
           *In41 = *On;
           else;
           *In42 = *On;
         ENDIF;
       ENDIF;

       SELLIST    = 'A';
       OMIT_NR    = 'N';
       OMIT_NA    = 'Y';
       INCL_PR    = 'Y';
       PRICE_CODE = 'C';
       SEND_AS    = 'C';

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc Scrn01;

         Screen = 01;
         // write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt EMLFINAV01;
         $ClrError();
         %SubArr(*IN : 50 : 10) = *Off;

         Time@ = %char(PSDS.RUN_TIME);
         Exec SQL Set :TimeStamp@ = current timestamp;

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc Edit01;
         dcl-s #CustEmail char(256);
         dcl-s RRN9P0 packed(9:0);
         dcl-s InquiryMode ind Inz(*Off);

         dcl-pr LKCUST extpgm('LKCUST');
           LOOKUP char(15);
           CUSTOMER# packed(6:0);
           CUSTOMER_NAME char(30);
         END-PR;

         $ClrError();

         #CustEmail = SELEMAIL;

         Select;
           When *In03;  // Exit Program
             *InLR = *On;
             return;
           When *In06;  // Use SMS screen (SCRN02)
             load02();
             scrn02();
           When *In07;  // Send to Multiples
             scrn01();
           When *In10;  // Work with Email
             If SELCUST = 0;
               SELCUST = 373;
             ENDIF;
             EMCMNT(SELCUST:RRN9P0:InquiryMode);
             scrn01();
           When SELLOOKUP <> *Blanks;  // Check for lookup
             LKCUST(SELLOOKUP:SELCUST:CUSTNAME);
             SELLOOKUP = *Blanks;
             SELEMAIL = GetCustEmail(SelCust);
             scrn01();
           When SELCUST =  0 and not isEmail(#CustEmail)
             or SELCUST <> 0 and not $isCust(SELCUST);   // Check error condition 51
             $sndError('CUS0001':'');
             *In50 = *On;
             *In51 = *On;
             scrn01();
           When #CustEmail = *Blanks and hasEmail(SELCUST);
             SELEMAIL = GetCustEmail(SelCust);
             scrn01();
           When #CustEmail = *Blanks  // Check error condition 52
             or not isEmail(#CustEmail);
               $sndError('EML0001':#CustEmail);
               *In50 = *On;
               *In52 = *On;
               scrn01();
           Other;

             Select;   //  Get the propper format
               When SEND_AS = 'P';   // PDF
                 generatePDF();
               When SEND_AS = 'C';   // CSV
                 generateCSV();
               When SEND_AS = 'X';   // XML
                 generateXML();
               When SEND_AS = 'H';   // HTML
                 generateHTML();
             ENDSL;

             EmailIt();  // Send the email

             SELCUST = *Zeros;
             SELEMAIL = *Blanks;
             TONAME = *Blanks;
             SELLOOKUP = *Blanks;
             scrn01();

         EndSl;

       END-PROC;


      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Screen 2 SubProcedures                                           :
      // :..................................................................:
       dcl-proc Load02;
         dcl-s SEARCH@ char(32);

         COUNTRY = 'USA';

         // Load the phone number if a customer is selected on screen 1 and a number is not keyed.
         If SELCUST <> *Zero and Phone# = *Zeros;
           Exec SQL // Get Customer Phone if we've sent SMS prior
             select    WLS_PHONE
               into   :PHONE#
             from      fmwlsdft
             where     WLS_CUST = :SELCUST
             Fetch First Row Only;
           If Phone# = *Zeros;
             Exec SQL // Get Bill To Customer from Invoice Header
               select    CMPHON
                 into   :PHONE#
               from      FMCUST
               where     CMCUST = :SELCUST
               Fetch First Row Only;
           ENDIF;
         ENDIF;

         // Check if we've sent SMS to this number before
         If SEARCH = *Blanks;
           Exec SQL
             Select    WLS_NAME
             into     :SEARCH
             From      fmwlsdft
             Where     WLS_PHONE = :PHONE#
             Fetch first row only;
         ENDIF;

         // Clear the subfile, prepare to write
         *In80 = *on;   // SFLCLR - Clear the subfile
         RRN02 = 0;
         write EMLFINAV02;
         RRN02 = *Zero;
         *In80 = *off;

         // Position the cursor on most likely field
         %SubArr(*IN : 60 : 03) = *Off;
         If PHONE# = *Zero;
           *In60 = *On;
           else;
           If SEARCH = *Blanks;
             *In61 = *On;
             else;
             *In62 = *On;
           ENDIF;
         ENDIF;

         SQLState = '00000';
         SEARCH@ = '%' + %trim(SEARCH) + '%';
         WLS_NAME = *Blanks;
         DoW SQLState = '00000';
           Exec SQL
             Select  WLS_NAME
             Into   :WLS_NAME
             From    FMWLSCAR
             Where   WLS_COUNTRY = :COUNTRY
               and   upper(WLS_NAME) like upper(trim(:SEARCH@))
               and   WLS_NAME > :WLS_NAME
             Order by WLS_NAME
             Fetch first row only;
           If SQLState = '00000';
             RRN02 = RRN02 + 1;
             MaxRRN02 = RRN02;
             write EMLFINAVS2;
           ENDIF;
         ENDDO;
         //dsply %char(RRN02);

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc Scrn02;

         Screen = 02;
         SFLCSRRRN2 = 0;
         // write ASSUME;
         If *In50;
           write msgctl;
         ENDIF;
         exfmt EMLFINAV02;
         $ClrError();
         %SubArr(*IN : 50 : 10) = *Off;

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc Edit02;
         dcl-s #CustEmail char(256);
         dcl-s WLS_GATEWAY varchar(80);

         Select;
           When *In03;
             *InLR = *on;
             return;
           When *In12;
             scrn01();
           Other;
             If MaxRRN02 = 1 and SEARCH = LastSEARCH;  // Only one record in subfile
               SFLCSRRRN2 = MaxRRN02; // use the only record
             ENDIF;
             If SFLCSRRRN2 > 0;
               Chain SFLCSRRRN2 EMLFINAVS2;
               Exec SQL  // Get the gateway to use
                 select  WLS_GATEWAY
                 into   :WLS_GATEWAY
                 from    FMWLSCAR
                 where   WLS_NAME = :WLS_NAME;
               SELEMAIL = %ScanRpl( 'number' : %char(PHONE#) : WLS_GATEWAY );
               Exec SQL DELETE FROM fmwlsdft WHERE WLS_PHONE = :PHONE#;
               Exec SQL INSERT INTO QUALDATA/FMWLSDFT (WLS_CUST, WLS_PHONE, WLS_NAME)
                         VALUES(:SELCUST, :PHONE#, :WLS_NAME);
               scrn01();
              Else;
               LastSEARCH = SEARCH;
               Load02();
               scrn02();
             ENDIF;
         ENDSL;

       END-PROC;

      //_____________________________________________________________________
      //
       dcl-proc WriteXML;


         reset STMF;
         STMF_XML = %trim(STMF) + timestamp@ + '.xml';
         STMF = STMF_XML;

         Exec SQL  //  Create temporary table to hold the XML
           declare global temporary table FINAVLXML
             ( XML_text VARCHAR(256) ) with replace ;

         xml(' <XML>');
         xml('  <workbook>');

         xml('   <worksheet name="Finished"');
         xml('      print-header="Finished Inventory"');
         xml('      print-orientation="portrait">');
         xml('    <row row-height="40">');
         xml('     <cell hspan="2">');
         xml('      <data type="LargeTextC" valign="center">');
         xml('       Kube-Pak Finished Inventory Availability');
         xml('      </data>');
         xml('     </cell>');
         xml('    </row>');
         xml('    <row>');
         xml('     <cell hspan="2">');
         xml('      <data type="SmallTextC" valign="center">');
         xml('       available in April 2016');
         xml('      </data>');
         xml('     </cell>');
         xml('    </row>');
         xml('    <row>');
         xml('     <cell hspan="2">');
         xml('     </cell>');
         xml('    </row>');
         xml('    <row row-height="100">');
         xml('     <cell>');
         xml('      <data type="picture" width="187">');
         xml('       /hssfcgi/images/boatM01.jpg');
         xml('      </data>');
         xml('     </cell>');
         xml('     <cell>');
         xml('      <data type="text" valign="center">');
         xml('       36 Solent Spear %LF Year: 2005%LF Price:  155,000 %LF Single Diesel%LF');
         xml('      </data>');
         xml('     </cell>');
         xml('    </row>');
         xml('    <row row-height="100">');
         xml('     <cell>');
         xml('      <data type="picture" width="187">');
         xml('       /hssfcgi/images/boatM02.jpg');
         xml('      </data>');
         xml('     </cell>');
         xml('     <cell>');
         xml('      <data type="text" valign="center">');
         xml('       75 Riva Venere%LF Year: 2006%LF Price: EUR 2,850,000 %LF Twin Diesel%LF');
         xml('      </data>');
         xml('     </cell>');
         xml('    </row>');
         xml('   </worksheet>');
         xml('  </workbook>');
         xml(' </XML>');

         CPYTOIMPF =
          'CPYTOIMPF  FROMFILE(QTEMP/FINAVLXML)' +
          ' TOSTMF(' + $quote + %trim(STMF_XML)+ $quote + ')' +
          ' MBROPT(*REPLACE)' +
          ' STMFCODPAG(*STDASCII)' +
          ' RCDDLM(*CRLF)' +
          ' DTAFMT(*FIXED)' +
          ' STRDLM(*NONE)';

         Exec SQL //  Run the CPYTOIMPF Command
           call QSYS2.QCMDEXC(:CPYTOIMPF);


       END-PROC;

      //_____________________________________________________________________
      //
       dcl-proc xml;
         dcl-pi *n;
           xml_to_write varchar(256) const;
         END-PI;

           Exec SQL INSERT INTO QTEMP/FINAVLXML (XML_TEXT) VALUES(:xml_to_write);

       END-PROC;

      //_____________________________________________________________________
      //
       dcl-proc GetData;

         Exec SQL
           declare global temporary table FINAVLWORK  (
             //season        VARCHAR(256) not null
             //Order_List_Description VARCHAR(256) not null
               Item_Number VARCHAR(256) not null
             , Item_Size_Code VARCHAR(256) not null
             , Item_Description VARCHAR(256) not null
             //Size_Description VARCHAR(256) not null
             //Container_Description VARCHAR(256) not null
             , AVAILABLE VARCHAR(256) not null
             , Price VARCHAR(256) not null
             , Ready_Color_Desc VARCHAR(256) not null
              ) with replace ;

         Exec SQL
           Insert into QTEMP.FINAVLWORK ( Values(
               ''
             , ''
             , 'Kube-Pak Inventory as of '||:timestamp@
             , ''
             , ''
             //''
             //''
             //''
             //''
             , '') );

         Exec SQL
           Insert into QTEMP.FINAVLWORK ( Values(
             //'Season'
             //'Order List Description'
               'Item Number'
             , 'Item Size'
             , 'Item Description'
             //'Size Description'
             //'Container Description'
             , 'Available'
             , 'Price'
             , 'Ready_Color_Desc') );

         Exec SQL
           Insert into QTEMP.FINAVLWORK (
             Select
             //trim(Season)
             //trim(Order_List_Description)
               trim(Item_Number)
             , trim(Item_Size)
             , trim(Item_Description)
             //trim(Size_Description)
             //trim(Container_Description)
             , AVAILABLE
             , case
                 when :INCL_PR = 'Y' and :PRICE_CODE = '1' then Price_Delivered_in_NJ
                 when :INCL_PR = 'Y' and :PRICE_CODE = '2' then Price_Delivered_out_of_State
                 when :INCL_PR = 'Y' and :PRICE_CODE = '3' then Price_Picked_up
                 when :INCL_PR = 'Y' and :PRICE_CODE = '4' then Price_MUMS_Truckload_NJ
                 when :INCL_PR = 'Y' and :PRICE_CODE = '5' then Price_MUMS_Truckload_out_of_State
                 else 0 end as Price
             , trim(coalesce(Ready_Color_Desc,''))
           From PHPDATA.Finished_Inventory_by_Season_with_prices
           Where :OMIT_NA = 'N' or AVAILABLE > 0
             and :OMIT_NR = 'N' or Ready_Color <> 'N R')
           Order by
               Season_Code
             , Order_List_Code
             , List_Sequence
             , List_AlphaSort;

         //Exec SQL
         //  create or replace table billb.FINAVLWORK
         //                           like FINAVLWORK;

         //Exec SQL
         //  delete from billb.FINAVLWORK;

         //Exec SQL
         //  insert into billb.FINAVLWORK
         //     (Select * from FINAVLWORK);

       END-PROC;


      //_____________________________________________________________________
      //
       dcl-proc generatePDF;
       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc generateCSV;

         GetData();   // Get the inventory data

         reset STMF;
         STMF_CSV = %trim(STMF) + timestamp@ + '.csv';
         STMF = STMF_CSV;

         CPYTOIMPF =
          'CPYTOIMPF  FROMFILE(QTEMP/FINAVLWORK)' +
          ' TOSTMF(' + $quote + %trim(STMF_CSV) + $quote + ')' +
          ' MBROPT(*REPLACE)' +
          ' STMFCODPAG(*STDASCII)' +
          ' RCDDLM(*CRLF)' +
          ' DTAFMT(*DLM)' +
          ' STRDLM(' + $quote + '"' + $quote + ')' +
          ' FLDDLM(' + $quote + ',' + $quote + ')';

         Exec SQL //  Run the CPYTOIMPF Command
           call QSYS2.QCMDEXC(:CPYTOIMPF);

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc generateXML;
         writeXML();
       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc generateHTML;
         writeXML();
       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc EmailIt;
         dcl-s Email_Command varchar(1080);

         Email_Command =
          'EMLHTML2' +
          ' SUBJECT('  + $quote+ 'Kube-Pak Inventory' + $quote + ')' +
          ' FROMNAME(' + $quote + 'Kube-Pak' + $quote + ')' +
          ' FROMADDR(' + $quote + 'DoNotReply@kubepak.com'+ $quote + ')' +
          ' TO(' + %trim(SELEMAIL) + '/' + $quote + %trim(ToName)  + $quote + '/*TO ' +
                   %trim(BCCEMAIL) + '/' + $quote + 'Kube-Pak BCC' + $quote + '/*BCC )' +
          ' HTML(' + $quote + HTML + $quote + ')' +
          ' STMF(' + $quote + STMF + $quote + ')';

         Exec sql //
           call QSYS2.QCMDEXC(:Email_Command);

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc hasEmail;
         dcl-pi *n ind;
           Cust# packed(6:0) const;
         END-PI;

         If isEmail(GetCustEmail(Cust#));
           Return *On;
          else;
           Return *Off;
         ENDIF;

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc isEmail;
         dcl-pi *n ind;
           #CustEmail char(256) const;
         END-PI;

           return   $isEmailAd(%subst(#CustEmail:001:32):
                               %subst(#CustEmail:033:32):
                               %subst(#CustEmail:065:32):
                               %subst(#CustEmail:097:32):
                               %subst(#CustEmail:129:32):
                               %subst(#CustEmail:161:32):
                               %subst(#CustEmail:193:32):
                               %subst(#CustEmail:225:32));
       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc GetCustEmail;
         dcl-pi *n char(256);
           Cust# packed(6:0) const;
         END-PI;
         dcl-s EmailAddress char(256);

         Exec SQL // Get Customer's Email Address
           select    EMAIL
             into   :EmailAddress
           from      FMEMAIL
           where     EMCODE in ('AVL', 'CUS')
             and     EMACCT = :Cust#
           Order by  EMCODE
           Fetch First Row Only;

         If SQLState = '00000';
           return EmailAddress;
          else;
           return 'Email not found for customer ' + %char(Cust#);
         endif;

       end-proc;

      //_____________________________________________________________________
      //
       dcl-proc InzSP;
         dcl-s x zoned(2:0);
         dcl-s LastHSSNCD zoned(2:0);

         SQLState = '00000';
         LastHSSNCD = 0;
         Clear Season_DS;
         Clear Seasons_DS;
         DoW SQLState = '00000';
           Exec SQL // Get the Seasons
             Select distinct
                         HSSNCD
                       , HSSEAS
             into       :Season_DS
             from        FMORLSEAS join CURSEASONS on HSSNCD = SEASON
             Where       HSSTAT = 'A'
               and       HSSNCD > :LastHSSNCD
             Order by    HSSNCD
             Fetch First Row Only;
           If SQLState = '00000';
             x = x + 1;
             Seasons(x) = Season_DS;
             LastHSSNCD = HSSNCD;
           ENDIF;
         ENDDO;
         Clear Season_DS;
         DoW x < 03;
           x = x + 1;
           Seasons(x) = Season_DS;
         ENDDO;

       end-proc;


      /include QFunctDefn,$ErrMsgSP
