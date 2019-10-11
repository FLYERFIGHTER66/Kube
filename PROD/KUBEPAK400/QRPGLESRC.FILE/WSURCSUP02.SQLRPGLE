      /free
      //--------------------------------------------------------------------
      *? Program        :  WSURCSUP02
      *?
      *? Description    : This program is to Get .csv from Suppliers URL
      *?                  and upload the data into WSSUPINVPF
      *?                  for Syngenta Supplier only
      *?
      *? Created By     : William Behr/Vimala
      *?
      *? Date           : 20 Aug 2018
      //--------------------------------------------------------------------
      *? Special Notes  : ** Get .CSV from  Suppliers URL
      *?                : ** Write .CSV data into IFS stream file
      *?                : ** Copy Stream file to Qtemp PF file
      *?                : ** Delete all records from WSSUPINVPF before each run
      *?                : ** Process QTemp PF and write to WSSUPINVPF where
      *?                : ** URC_TYPE='Vegetative' and FORM='URC'
      *
      *? Called Program : QCMDEXC - Pgm To Call CL command in Rpg
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
 VV01 * VV01    09/18/18   Vimala       Provide Null Indicator for Allocated
 VV01 *                                 Quantity calculation in SQL
 VV02 * VV02    01/03/19   Vimala V     Include records having Quantity=0
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : Header Specification :
      *?                :----------------------:
        Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
        Ctl-Opt  dftactgrp(*no) actgrp(*caller) DatFmt(*USA);
        Ctl-Opt  thread(*serialize);

      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : File Specification :
      *?                :--------------------:
      *
      *?File: WS - Supplier Inventory File
      *?Key : Customer Number : Card Number : Token Number
        Dcl-F WSSUPINVPF Disk(*Ext) Usage(*Output:*Delete);
      *
      *?File: Broker Default File
      *?Key : Customer Number : Customer Number : Token Number
        Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: WS - XML Cross Reference File for FMINVT
      *?Key : ProvidedbyName:ProvidedbyType:ForeignKeyValue
        Dcl-F XREFINVTL0 Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration: *Entry Parameters
        Dcl-Pi WSURCSUP02 ExtPgm;
           PSupCde  Char(6);
        End-Pi;
      *
      *?Procedure Prototype Declaration : Pgm to Call Command
        Dcl-Pr QCMDEXC Extpgm;
           Command Char(2000) Const Options(*Varsize);
           Len Packed(15:5) Const;
        End-Pr;
      *
      *?Global Variable Declaration
        Dcl-S CSV SQLTYPE(BLOB_FILE);
        Dcl-S WkUrl  VarChar(255);
        Dcl-S Command   Char(2000)   Inz;

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
        Dcl-S WkSeq     Packed(10)  Inz;
        Dcl-S WkDate    Char(11)    Inz;
        Dcl-S WkItem    Char(15)    Inz;
        Dcl-S WkSize    Char(3)     Inz;
        Dcl-S WkAvlDat  Packed(7)   Inz;
        Dcl-S WkAlcQty  Packed(11)  Inz;
 VV01   Dcl-S NullInd  Int(5)    Inz(0);                  //Null Indicator for WkAlcQty
 VV01   Dcl-S NullValue Like(NullInd) Inz(-1);
      *
      * Declare Data Structure for SQL
         Dcl-Ds WSSYNGENTDS ExtName('RC_SYNGENT');
         End-Ds;
      *
      *?Data Structure to load Date from temp file
        Dcl-Ds WD Qualified;
          WDURCType Char(15) Inz;
          WDVariety Char(15) Inz;
          WDURCDesc Char(15) Inz;
          WDCateg   Char(15) Inz;
          WDCrop    Char(15) Inz;
          WDSeries  Char(15) Inz;
          WDColor   Char(15) Inz;
          WDStatus  Char(15) Inz;
          WDForm    Char(15) Inz;
          WDAvail   Char(15) Inz;
          WDUrl     Char(15) Inz;
          WDt001    Char(18) Inz;
          WDt002    Char(18) Inz;
          WDt003    Char(18) Inz;
          WDt004    Char(18) Inz;
          WDt005    Char(18) Inz;
          WDt006    Char(18) Inz;
          WDt007    Char(18) Inz;
          WDt008    Char(18) Inz;
          WDt009    Char(18) Inz;
          WDt010    Char(18) Inz;
          WDt011    Char(18) Inz;
          WDt012    Char(18) Inz;
          WDt013    Char(18) Inz;
          WDt014    Char(18) Inz;
          WDt015    Char(18) Inz;
          WDt016    Char(18) Inz;
          WDt017    Char(18) Inz;
          WDt018    Char(18) Inz;
          WDt019    Char(18) Inz;
          WDt020    Char(18) Inz;
          WDt021    Char(18) Inz;
          WDt022    Char(18) Inz;
          WDt023    Char(18) Inz;
          WDt024    Char(18) Inz;
          WDt025    Char(18) Inz;
          WDt026    Char(18) Inz;
          WDt027    Char(18) Inz;
          WDt028    Char(18) Inz;
          WDt029    Char(18) Inz;
          WDt030    Char(18) Inz;
          WDt031    Char(18) Inz;
          WDt032    Char(18) Inz;
          WDt033    Char(18) Inz;
          WDt034    Char(18) Inz;
          WDt035    Char(18) Inz;
          WDt036    Char(18) Inz;
          WDt037    Char(18) Inz;
          WDt038    Char(18) Inz;
          WDt039    Char(18) Inz;
          WDt040    Char(18) Inz;
          WDt041    Char(18) Inz;
          WDt042    Char(18) Inz;
          WDt043    Char(18) Inz;
          WDt044    Char(18) Inz;
          WDt045    Char(18) Inz;
          WDt046    Char(18) Inz;
          WDt047    Char(18) Inz;
          WDt048    Char(18) Inz;
          WDt049    Char(18) Inz;
          WDt050    Char(18) Inz;
          WDt051    Char(18) Inz;
          WDt052    Char(18) Inz;
          WDt053    Char(18) Inz;
          WDt054    Char(18) Inz;
          WDt055    Char(18) Inz;
          WDt056    Char(18) Inz;
          WDt057    Char(18) Inz;
          WDt058    Char(18) Inz;
          WDt059    Char(18) Inz;
          WDt060    Char(18) Inz;
          WDt061    Char(18) Inz;
          WDt062    Char(18) Inz;
          WDt063    Char(18) Inz;
          WDt064    Char(18) Inz;
          WDt065    Char(18) Inz;
          WDt066    Char(18) Inz;
          WDt067    Char(18) Inz;
          WDt068    Char(18) Inz;
          WDt069    Char(18) Inz;
          WDt070    Char(18) Inz;
          WDt071    Char(18) Inz;
          WDt072    Char(18) Inz;
          WDt073    Char(18) Inz;
          WDt074    Char(18) Inz;
          WDt075    Char(18) Inz;
          WDt076    Char(18) Inz;
          WDt077    Char(18) Inz;
          WDt078    Char(18) Inz;
          WDt079    Char(18) Inz;
          WDt080    Char(18) Inz;
          WDt081    Char(18) Inz;
          WDt082    Char(18) Inz;
          WDt083    Char(18) Inz;
          WDt084    Char(18) Inz;
          WDt085    Char(18) Inz;
          WDt086    Char(18) Inz;
          WDt087    Char(18) Inz;
          WDt088    Char(18) Inz;
          WDt089    Char(18) Inz;
          WDt090    Char(18) Inz;
          WDt091    Char(18) Inz;
          WDt092    Char(18) Inz;
          WDt093    Char(18) Inz;
          WDt094    Char(18) Inz;
          WDt095    Char(18) Inz;
          WDt096    Char(18) Inz;
          WDt097    Char(18) Inz;
          WDt098    Char(18) Inz;
          WDt099    Char(18) Inz;
          WDt100    Char(18) Inz;
          WDt101    Char(18) Inz;
          WDt102    Char(18) Inz;
          WDt103    Char(18) Inz;
          WDt104    Char(18) Inz;
        End-Ds;
      *
      //--------------------------------------------------------------------
      *?                :------------------:
      *?                : Calculation Spec :
      *?                :------------------:
      *
      *?Main Line :
      *?   // Clear all records from WSSUPINVPF before loading fresh data
            Exsr DelInv;

      *?   // Get .csv file from Suppliers Url into IFS folder
            Exsr GetCSV;

      *?   // Populate WSSUPINVPF file from qtemp file
            Exsr LoadInv;

      *?   // End Program
            Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?// Return
           *InLr = *On;
           Return;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : DelInv Subroutine :
      *?                :-------------------:
      *
        Begsr DelInv;
      *? //Delete all records from Supplier Inventory File
        Exec Sql
          Delete from WSSUPINVPF where SIFRORID = 'Syngenta';

        EndSr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : GetCSV Subroutine :
      *?                :-------------------:
      *
        Begsr GetCSV;
      *?
      *? //Get Url from Control File
        Chain (PSupCde :'SUPPURLPATH') FBROKDFTL0;
        If %Found;
           WkUrl =  %Trim(DFVARVAL);
        Endif;

      *?  //If IFS file does not exist , create file
        CSV_Name ='/tmp/rc_syngent.csv';
        Command  = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(CSV_Name) + ''' )';
        Exsr CallCmd;

      *?//Change attributes of Stream file
        Command = 'CHGATR OBJ(''' + %Trim(CSV_Name) + ''')' +
                         ' ATR(*CCSID) VALUE(1208)';
        Exsr CallCmd;

      *? //To get Inventory Data from Web Url in .csv format and store in IFS
        CSV_NL=%Len(%TrimR(CSV_Name));
        CSV_FO=SQFOVR;                          // Overwrite
        Exec SQL Set :CSV = SYSTOOLS.HTTPGETBLOB(:WkUrl,'');  // Get data and put in IFS file

      *? //Create QTEMP file to hold data
        Exec SQL
           drop table qtemp.syngenta_URC_Upload;
        Exec SQL
           Create or Replace Table qtemp.syngenta_URC_Upload
           For system name rc_syngent
        (Syng_Type         for column URC_TYPE CHAR(10) NOT NULL WITH DEFAULT
         ,Syng_Variety_Id   for column VARIETY_ID CHAR(10) NOT NULL WITH DEFAULT
         ,Syng_Description  for column URC_DESC CHAR(80) NOT NULL WITH DEFAULT
         ,Syng_Category     for column CATEGORY CHAR(25) NOT NULL WITH DEFAULT
         ,Syng_Crop         for column CROP CHAR(25) NOT NULL WITH DEFAULT
         ,Syng_Series       for column SERIES CHAR(30) NOT NULL WITH DEFAULT
         ,Syng_Clr_Category for column COLOR_CAT CHAR(35) NOT NULL WITH DEFAULT
         ,Syng_Status       for column STATUS CHAR(25) NOT NULL WITH DEFAULT
         ,Syng_Form         for column FORM CHAR(15) NOT NULL WITH DEFAULT
         ,Syng_Available    for column AVAILABLE CHAR(25) NOT NULL WITH DEFAULT
         ,Syng_Product_Url  for column PROD_URL CHAR(255) NOT NULL WITH DEFAULT
         ,Week_001 Char(18) WITH DEFAULT
         ,Week_002 Char(18) WITH DEFAULT
         ,Week_003 Char(18) WITH DEFAULT
         ,Week_004 Char(18) WITH DEFAULT
         ,Week_005 Char(18) WITH DEFAULT
         ,Week_006 Char(18) WITH DEFAULT
         ,Week_007 Char(18) WITH DEFAULT
         ,Week_008 Char(18) WITH DEFAULT
         ,Week_009 Char(18) WITH DEFAULT
         ,Week_010 Char(18) WITH DEFAULT
         ,Week_011 Char(18) WITH DEFAULT
         ,Week_012 Char(18) WITH DEFAULT
         ,Week_013 Char(18) WITH DEFAULT
         ,Week_014 Char(18) WITH DEFAULT
         ,Week_015 Char(18) WITH DEFAULT
         ,Week_016 Char(18) WITH DEFAULT
         ,Week_017 Char(18) WITH DEFAULT
         ,Week_018 Char(18) WITH DEFAULT
         ,Week_019 Char(18) WITH DEFAULT
         ,Week_020 Char(18) WITH DEFAULT
         ,Week_021 Char(18) WITH DEFAULT
         ,Week_022 Char(18) WITH DEFAULT
         ,Week_023 Char(18) WITH DEFAULT
         ,Week_024 Char(18) WITH DEFAULT
         ,Week_025 Char(18) WITH DEFAULT
         ,Week_026 Char(18) WITH DEFAULT
         ,Week_027 Char(18) WITH DEFAULT
         ,Week_028 Char(18) WITH DEFAULT
         ,Week_029 Char(18) WITH DEFAULT
         ,Week_030 Char(18) WITH DEFAULT
         ,Week_031 Char(18) WITH DEFAULT
         ,Week_032 Char(18) WITH DEFAULT
         ,Week_033 Char(18) WITH DEFAULT
         ,Week_034 Char(18) WITH DEFAULT
         ,Week_035 Char(18) WITH DEFAULT
         ,Week_036 Char(18) WITH DEFAULT
         ,Week_037 Char(18) WITH DEFAULT
         ,Week_038 Char(18) WITH DEFAULT
         ,Week_039 Char(18) WITH DEFAULT
         ,Week_040 Char(18) WITH DEFAULT
         ,Week_041 Char(18) WITH DEFAULT
         ,Week_042 Char(18) WITH DEFAULT
         ,Week_043 Char(18) WITH DEFAULT
         ,Week_044 Char(18) WITH DEFAULT
         ,Week_045 Char(18) WITH DEFAULT
         ,Week_046 Char(18) WITH DEFAULT
         ,Week_047 Char(18) WITH DEFAULT
         ,Week_048 Char(18) WITH DEFAULT
         ,Week_049 Char(18) WITH DEFAULT
         ,Week_050 Char(18) WITH DEFAULT
         ,Week_051 Char(18) WITH DEFAULT
         ,Week_052 Char(18) WITH DEFAULT
         ,Week_053 Char(18) WITH DEFAULT
         ,Week_054 Char(18) WITH DEFAULT
         ,Week_055 Char(18) WITH DEFAULT
         ,Week_056 Char(18) WITH DEFAULT
         ,Week_057 Char(18) WITH DEFAULT
         ,Week_058 Char(18) WITH DEFAULT
         ,Week_059 Char(18) WITH DEFAULT
         ,Week_060 Char(18) WITH DEFAULT
         ,Week_061 Char(18) WITH DEFAULT
         ,Week_062 Char(18) WITH DEFAULT
         ,Week_063 Char(18) WITH DEFAULT
         ,Week_064 Char(18) WITH DEFAULT
         ,Week_065 Char(18) WITH DEFAULT
         ,Week_066 Char(18) WITH DEFAULT
         ,Week_067 Char(18) WITH DEFAULT
         ,Week_068 Char(18) WITH DEFAULT
         ,Week_069 Char(18) WITH DEFAULT
         ,Week_070 Char(18) WITH DEFAULT
         ,Week_071 Char(18) WITH DEFAULT
         ,Week_072 Char(18) WITH DEFAULT
         ,Week_073 Char(18) WITH DEFAULT
         ,Week_074 Char(18) WITH DEFAULT
         ,Week_075 Char(18) WITH DEFAULT
         ,Week_076 Char(18) WITH DEFAULT
         ,Week_077 Char(18) WITH DEFAULT
         ,Week_078 Char(18) WITH DEFAULT
         ,Week_079 Char(18) WITH DEFAULT
         ,Week_080 Char(18) WITH DEFAULT
         ,Week_081 Char(18) WITH DEFAULT
         ,Week_082 Char(18) WITH DEFAULT
         ,Week_083 Char(18) WITH DEFAULT
         ,Week_084 Char(18) WITH DEFAULT
         ,Week_085 Char(18) WITH DEFAULT
         ,Week_086 Char(18) WITH DEFAULT
         ,Week_087 Char(18) WITH DEFAULT
         ,Week_088 Char(18) WITH DEFAULT
         ,Week_089 Char(18) WITH DEFAULT
         ,Week_090 Char(18) WITH DEFAULT
         ,Week_091 Char(18) WITH DEFAULT
         ,Week_092 Char(18) WITH DEFAULT
         ,Week_093 Char(18) WITH DEFAULT
         ,Week_094 Char(18) WITH DEFAULT
         ,Week_095 Char(18) WITH DEFAULT
         ,Week_096 Char(18) WITH DEFAULT
         ,Week_097 Char(18) WITH DEFAULT
         ,Week_098 Char(18) WITH DEFAULT
         ,Week_099 Char(18) WITH DEFAULT
         ,Week_100 Char(18) WITH DEFAULT
         ,Week_101 Char(18) WITH DEFAULT
         ,Week_102 Char(18) WITH DEFAULT
         ,Week_103 Char(18) WITH DEFAULT
         ,Week_104 Char(18) WITH DEFAULT
          ) RCDFMT  RSYNGENTA;

      *?  //Upload .CSV file from IFS to PF
        Command = 'CPYFRMIMPF FROMSTMF(''' + %trim(CSV_Name) + ''') ' +
            ' TOFILE(QTEMP/RC_SYNGENT) ' +
            ' MBROPT(*REPLACE) ' +
            ' FROMCCSID(*FILE) ' +
            ' TOCCSID(37)  ' +
            ' RCDDLM(*LF)  ' +
            ' STRDLM(*NONE) ' +
            ' RMVBLANK(*NONE) ' +
            ' FROMRCD(*FIRST *END) ' +
            ' ERRRCDOPT(*REPLACE) ' +
            ' RPLNULLVAL(*FLDDFT) ';
           Exsr CallCmd;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : LoadInv Subroutine :
      *?                :--------------------:
      *
      *?   // Read rc_syngent file and load WSSUPPINVPF
        Begsr LoadInv;

      *?   // Read first record only to get column heading for date values
         Exec Sql
         Select * into :WD from rc_syngent
         Fetch first row only;

      *?   // Read records to populate inventory file
         Exec Sql Declare A1 cursor for
              Select * from rc_syngent
                 where URC_TYPE = 'Vegetative'
                   and FORM = 'URC'
                   For Read only;

         Exec Sql
            Open A1;
         If SqlCode = -502 ;
             Exec Sql
             Close A1;
             Exec Sql
             Open A1;
         EndIf;

         Exec Sql Fetch next from A1 into :WSSYNGENTDS;
         Dow SqlCod = 0;

      *? // Move Qty based on Date Column
             Exsr MovQty;

            Exec Sql Fetch next from A1 into :WSSYNGENTDS;
         Enddo;
         Exec Sql Close A1;

        EndSr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : MoveQty Subroutine :
      *?                :--------------------:
      *
        Begsr MovQty;
      *? // Move values to inventory file fields based on date
 VV02 *  //If WEEK_001 <> '0' and WEEK_001 <> '-';
 VV02      If WEEK_001 = '0' or WEEK_001 = '-';
 VV02         WEEK_001 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt001:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_001);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_002 <> '0' and WEEK_002 <> '-';
 VV02      If WEEK_002 = '0' or WEEK_002 = '-';
 VV02         WEEK_002 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt002:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_002);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_003 <> '0' and WEEK_003 <> '-';
 VV02      If WEEK_003 = '0' or WEEK_003 = '-';
 VV02         WEEK_003 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt003:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_003);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_004 <> '0' and WEEK_004 <> '-';
 VV02      If WEEK_004 = '0' or WEEK_004 = '-';
 VV02         WEEK_004 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt004:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_004);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_005 <> '0' and WEEK_005 <> '-';
 VV02      If WEEK_005 = '0' or WEEK_005 = '-';
 VV02         WEEK_005 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt005:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_005);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_006 <> '0' and WEEK_006 <> '-';
 VV02      If WEEK_006 = '0' or WEEK_006 = '-';
 VV02         WEEK_006 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt006:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_006);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_007 <> '0' and WEEK_007 <> '-';
 VV02      If WEEK_007 = '0' or WEEK_007 = '-';
 VV02         WEEK_007 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt007:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_007);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_008 <> '0' and WEEK_008 <> '-';
 VV02      If WEEK_008 = '0' or WEEK_008 = '-';
 VV02         WEEK_008 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt008:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_008);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_009 <> '0' and WEEK_009 <> '-';
 VV02      If WEEK_009 = '0' or WEEK_009 = '-';
 VV02         WEEK_009 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt009:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_009);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_010 <> '0' and WEEK_010 <> '-';
 VV02      If WEEK_010 = '0' or WEEK_010 = '-';
 VV02         WEEK_010 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt010:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_010);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_011 <> '0' and WEEK_011 <> '-';
 VV02      If WEEK_011 = '0' or WEEK_011 = '-';
 VV02         WEEK_011 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt011:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_011);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_012 <> '0' and WEEK_012 <> '-';
 VV02      If WEEK_012 = '0' or WEEK_012 = '-';
 VV02         WEEK_012 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt012:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_012);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_013 <> '0' and WEEK_013 <> '-';
 VV02      If WEEK_013 = '0' or WEEK_013 = '-';
 VV02         WEEK_013 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt013:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_013);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_014 <> '0' and WEEK_014 <> '-';
 VV02      If WEEK_014 = '0' or WEEK_014 = '-';
 VV02         WEEK_014 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt014:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_014);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_015 <> '0' and WEEK_015 <> '-';
 VV02      If WEEK_015 = '0' or WEEK_015 = '-';
 VV02         WEEK_015 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt015:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_015);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_016 <> '0' and WEEK_016 <> '-';
 VV02      If WEEK_016 = '0' or WEEK_016 = '-';
 VV02         WEEK_016 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt016:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_016);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_017 <> '0' and WEEK_017 <> '-';
 VV02      If WEEK_017 = '0' or WEEK_017 = '-';
 VV02         WEEK_017 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt017:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_017);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_018 <> '0' and WEEK_018 <> '-';
 VV02      If WEEK_018 = '0' or WEEK_018 = '-';
 VV02         WEEK_018 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt018:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_018);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_019 <> '0' and WEEK_019 <> '-';
 VV02      If WEEK_019 = '0' or WEEK_019 = '-';
 VV02         WEEK_019 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt019:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_019);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_020 <> '0' and WEEK_020 <> '-';
 VV02      If WEEK_020 = '0' or WEEK_020 = '-';
 VV02         WEEK_020 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt020:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_020);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_021 <> '0' and WEEK_021 <> '-';
 VV02      If WEEK_021 = '0' or WEEK_021 = '-';
 VV02         WEEK_021 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt021:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_021);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_022 <> '0' and WEEK_022 <> '-';
 VV02      If WEEK_022 = '0' or WEEK_022 = '-';
 VV02         WEEK_022 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt022:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_022);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_023 <> '0' and WEEK_023 <> '-';
 VV02      If WEEK_023 = '0' or WEEK_023 = '-';
 VV02         WEEK_023 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt023:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_023);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_024 <> '0' and WEEK_024 <> '-';
 VV02      If WEEK_024 = '0' or WEEK_024 = '-';
 VV02         WEEK_024 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt024:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_024);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_025 <> '0' and WEEK_025 <> '-';
 VV02      If WEEK_025 = '0' or WEEK_025 = '-';
 VV02         WEEK_025 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt025:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_025);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_026 <> '0' and WEEK_026 <> '-';
 VV02      If WEEK_026 = '0' or WEEK_026 = '-';
 VV02         WEEK_026 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt026:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_026);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_027 <> '0' and WEEK_027 <> '-';
 VV02      If WEEK_027 = '0' or WEEK_027 = '-';
 VV02         WEEK_027 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt027:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_027);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_028 <> '0' and WEEK_028 <> '-';
 VV02      If WEEK_028 = '0' or WEEK_028 = '-';
 VV02         WEEK_028 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt028:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_028);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_029 <> '0' and WEEK_029 <> '-';
 VV02      If WEEK_029 = '0' or WEEK_029 = '-';
 VV02         WEEK_029 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt029:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_029);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_030 <> '0' and WEEK_030 <> '-';
 VV02      If WEEK_030 = '0' or WEEK_030 = '-';
 VV02         WEEK_030 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt030:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_030);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_031 <> '0' and WEEK_031 <> '-';
 VV02      If WEEK_031 = '0' or WEEK_031 = '-';
 VV02         WEEK_031 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt031:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_031);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_032 <> '0' and WEEK_032 <> '-';
 VV02      If WEEK_032 = '0' or WEEK_032 = '-';
 VV02         WEEK_032 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt032:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_032);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_033 <> '0' and WEEK_033 <> '-';
 VV02      If WEEK_033 = '0' or WEEK_033 = '-';
 VV02         WEEK_033 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt033:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_033);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_034 <> '0' and WEEK_034 <> '-';
 VV02      If WEEK_034 = '0' or WEEK_034 = '-';
 VV02         WEEK_034 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt034:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_034);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_035 <> '0' and WEEK_035 <> '-';
 VV02      If WEEK_035 = '0' or WEEK_035 = '-';
 VV02         WEEK_035 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt035:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_035);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_036 <> '0' and WEEK_036 <> '-';
 VV02      If WEEK_036 = '0' or WEEK_036 = '-';
 VV02         WEEK_036 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt036:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_036);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_037 <> '0' and WEEK_037 <> '-';
 VV02      If WEEK_037 = '0' or WEEK_037 = '-';
 VV02         WEEK_037 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt037:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_037);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_038 <> '0' and WEEK_038 <> '-';
 VV02      If WEEK_038 = '0' or WEEK_038 = '-';
 VV02         WEEK_038 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt038:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_038);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_039 <> '0' and WEEK_039 <> '-';
 VV02      If WEEK_039 = '0' or WEEK_039 = '-';
 VV02         WEEK_039 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt039:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_039);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_040 <> '0' and WEEK_040 <> '-';
 VV02      If WEEK_040 = '0' or WEEK_040 = '-';
 VV02         WEEK_040 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt040:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_040);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_041 <> '0' and WEEK_041 <> '-';
 VV02      If WEEK_041 = '0' or WEEK_041 = '-';
 VV02         WEEK_041 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt041:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_041);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_042 <> '0' and WEEK_042 <> '-';
 VV02      If WEEK_042 = '0' or WEEK_042 = '-';
 VV02         WEEK_042 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt042:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_042);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_043 <> '0' and WEEK_043 <> '-';
 VV02      If WEEK_043 = '0' or WEEK_043 = '-';
 VV02         WEEK_043 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt043:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_043);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_044 <> '0' and WEEK_044 <> '-';
 VV02      If WEEK_044 = '0' or WEEK_044 = '-';
 VV02         WEEK_044 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt044:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_044);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_045 <> '0' and WEEK_045 <> '-';
 VV02      If WEEK_045 = '0' or WEEK_045 = '-';
 VV02         WEEK_045 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt045:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_045);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_046 <> '0' and WEEK_046 <> '-';
 VV02      If WEEK_046 = '0' or WEEK_046 = '-';
 VV02         WEEK_046 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt046:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_046);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_047 <> '0' and WEEK_047 <> '-';
 VV02      If WEEK_047 = '0' or WEEK_047 = '-';
 VV02         WEEK_047 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt047:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_047);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_048 <> '0' and WEEK_048 <> '-';
 VV02      If WEEK_048 = '0' or WEEK_048 = '-';
 VV02         WEEK_048 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt048:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_048);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_049 <> '0' and WEEK_049 <> '-';
 VV02      If WEEK_049 = '0' or WEEK_049 = '-';
 VV02         WEEK_049 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt049:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_049);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_050 <> '0' and WEEK_050 <> '-';
 VV02      If WEEK_050 = '0' or WEEK_050 = '-';
 VV02         WEEK_050 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt050:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_050);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_051 <> '0' and WEEK_051 <> '-';
 VV02      If WEEK_051 = '0' or WEEK_051 = '-';
 VV02         WEEK_051 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt051:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_051);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_052 <> '0' and WEEK_052 <> '-';
 VV02      If WEEK_052 = '0' or WEEK_052 = '-';
 VV02         WEEK_052 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt052:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_052);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_053 <> '0' and WEEK_053 <> '-';
 VV02      If WEEK_053 = '0' or WEEK_053 = '-';
 VV02         WEEK_053 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt053:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_053);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_054 <> '0' and WEEK_054 <> '-';
 VV02      If WEEK_054 = '0' or WEEK_054 = '-';
 VV02         WEEK_054 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt054:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_054);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_055 <> '0' and WEEK_055 <> '-';
 VV02      If WEEK_055 = '0' or WEEK_055 = '-';
 VV02         WEEK_055 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt055:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_055);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_056 <> '0' and WEEK_056 <> '-';
 VV02      If WEEK_056 = '0' or WEEK_056 = '-';
 VV02         WEEK_056 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt056:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_056);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_057 <> '0' and WEEK_057 <> '-';
 VV02      If WEEK_057 = '0' or WEEK_057 = '-';
 VV02         WEEK_057 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt057:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_057);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_058 <> '0' and WEEK_058 <> '-';
 VV02      If WEEK_058 = '0' or WEEK_058 = '-';
 VV02         WEEK_058 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt058:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_058);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_059 <> '0' and WEEK_059 <> '-';
 VV02      If WEEK_059 = '0' or WEEK_059 = '-';
 VV02         WEEK_059 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt059:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_059);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_060 <> '0' and WEEK_060 <> '-';
 VV02      If WEEK_060 = '0' or WEEK_060 = '-';
 VV02         WEEK_060 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt060:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_060);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_061 <> '0' and WEEK_061 <> '-';
 VV02      If WEEK_061 = '0' or WEEK_061 = '-';
 VV02         WEEK_061 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt061:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_061);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_062 <> '0' and WEEK_062 <> '-';
 VV02      If WEEK_062 = '0' or WEEK_062 = '-';
 VV02         WEEK_062 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt062:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_062);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_063 <> '0' and WEEK_063 <> '-';
 VV02      If WEEK_063 = '0' or WEEK_063 = '-';
 VV02         WEEK_063 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt063:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_063);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_064 <> '0' and WEEK_064 <> '-';
 VV02      If WEEK_064 = '0' or WEEK_064 = '-';
 VV02         WEEK_064 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt064:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_064);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_065 <> '0' and WEEK_065 <> '-';
 VV02      If WEEK_065 = '0' or WEEK_065 = '-';
 VV02         WEEK_065 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt065:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_065);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_066 <> '0' and WEEK_066 <> '-';
 VV02      If WEEK_066 = '0' or WEEK_066 = '-';
 VV02         WEEK_066 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt066:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_066);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_067 <> '0' and WEEK_067 <> '-';
 VV02      If WEEK_067 = '0' or WEEK_067 = '-';
 VV02         WEEK_067 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt067:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_067);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_068 <> '0' and WEEK_068 <> '-';
 VV02      If WEEK_068 = '0' or WEEK_068 = '-';
 VV02         WEEK_068 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt068:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_068);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_069 <> '0' and WEEK_069 <> '-';
 VV02      If WEEK_069 = '0' or WEEK_069 = '-';
 VV02         WEEK_069 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt069:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_069);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_070 <> '0' and WEEK_070 <> '-';
 VV02      If WEEK_070 = '0' or WEEK_070 = '-';
 VV02         WEEK_070 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt070:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_070);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_071 <> '0' and WEEK_071 <> '-';
 VV02      If WEEK_071 = '0' or WEEK_071 = '-';
 VV02         WEEK_071 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt071:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_071);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_072 <> '0' and WEEK_072 <> '-';
 VV02      If WEEK_072 = '0' or WEEK_072 = '-';
 VV02         WEEK_072 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt072:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_072);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_073 <> '0' and WEEK_073 <> '-';
 VV02      If WEEK_073 = '0' or WEEK_073 = '-';
 VV02         WEEK_073 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt073:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_073);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_074 <> '0' and WEEK_074 <> '-';
 VV02      If WEEK_074 = '0' or WEEK_074 = '-';
 VV02         WEEK_074 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt074:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_074);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_075 <> '0' and WEEK_075 <> '-';
 VV02      If WEEK_075 = '0' or WEEK_075 = '-';
 VV02         WEEK_075 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt075:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_075);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_076 <> '0' and WEEK_076 <> '-';
 VV02      If WEEK_076 = '0' or WEEK_076 = '-';
 VV02         WEEK_076 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt076:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_076);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_077 <> '0' and WEEK_077 <> '-';
 VV02      If WEEK_077 = '0' or WEEK_077 = '-';
 VV02         WEEK_077 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt077:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_077);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_078 <> '0' and WEEK_078 <> '-';
 VV02      If WEEK_078 = '0' or WEEK_078 = '-';
 VV02         WEEK_078 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt078:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_078);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_079 <> '0' and WEEK_079 <> '-';
 VV02      If WEEK_079 = '0' or WEEK_079 = '-';
 VV02         WEEK_079 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt079:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_079);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_080 <> '0' and WEEK_080 <> '-';
 VV02      If WEEK_080 = '0' or WEEK_080 = '-';
 VV02         WEEK_080 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt080:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_080);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_081 <> '0' and WEEK_081 <> '-';
 VV02      If WEEK_081 = '0' or WEEK_081 = '-';
 VV02         WEEK_081 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt081:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_081);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_082 <> '0' and WEEK_082 <> '-';
 VV02      If WEEK_082 = '0' or WEEK_082 = '-';
 VV02         WEEK_082 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt082:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_082);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_083 <> '0' and WEEK_083 <> '-';
 VV02      If WEEK_083 = '0' or WEEK_083 = '-';
 VV02         WEEK_083 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt083:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_083);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_084 <> '0' and WEEK_084 <> '-';
 VV02      If WEEK_084 = '0' or WEEK_084 = '-';
 VV02         WEEK_084 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt084:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_084);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_085 <> '0' and WEEK_085 <> '-';
 VV02      If WEEK_085 = '0' or WEEK_085 = '-';
 VV02         WEEK_085 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt085:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_085);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_086 <> '0' and WEEK_086 <> '-';
 VV02      If WEEK_086 = '0' or WEEK_086 = '-';
 VV02         WEEK_086 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt086:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_086);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_087 <> '0' and WEEK_087 <> '-';
 VV02      If WEEK_087 = '0' or WEEK_087 = '-';
 VV02         WEEK_087 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt087:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_087);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_088 <> '0' and WEEK_088 <> '-';
 VV02      If WEEK_088 = '0' or WEEK_088 = '-';
 VV02         WEEK_088 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt088:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_088);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_089 <> '0' and WEEK_089 <> '-';
 VV02      If WEEK_089 = '0' or WEEK_089 = '-';
 VV02         WEEK_089 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt089:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_089);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_090 <> '0' and WEEK_090 <> '-';
 VV02      If WEEK_090 = '0' or WEEK_090 = '-';
 VV02         WEEK_090 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt090:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_090);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_091 <> '0' and WEEK_091 <> '-';
 VV02      If WEEK_091 = '0' or WEEK_091 = '-';
 VV02         WEEK_091 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt091:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_091);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_092 <> '0' and WEEK_092 <> '-';
 VV02      If WEEK_092 = '0' or WEEK_092 = '-';
 VV02         WEEK_092 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt092:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_092);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_093 <> '0' and WEEK_093 <> '-';
 VV02      If WEEK_093 = '0' or WEEK_093 = '-';
 VV02         WEEK_093 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt093:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_093);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_094 <> '0' and WEEK_094 <> '-';
 VV02      If WEEK_094 = '0' or WEEK_094 = '-';
 VV02         WEEK_094 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt094:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_094);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_095 <> '0' and WEEK_095 <> '-';
 VV02      If WEEK_095 = '0' or WEEK_095 = '-';
 VV02         WEEK_095 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt095:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_095);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_096 <> '0' and WEEK_096 <> '-';
 VV02      If WEEK_096 = '0' or WEEK_096 = '-';
 VV02         WEEK_096 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt096:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_096);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_097 <> '0' and WEEK_097 <> '-';
 VV02      If WEEK_097 = '0' or WEEK_097 = '-';
 VV02         WEEK_097 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt097:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_097);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_098 <> '0' and WEEK_098 <> '-';
 VV02      If WEEK_098 = '0' or WEEK_098 = '-';
 VV02         WEEK_098 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt098:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_098);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_099 <> '0' and WEEK_099 <> '-';
 VV02      If WEEK_099 = '0' or WEEK_099 = '-';
 VV02         WEEK_099 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt099:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_099);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_100 <> '0' and WEEK_100 <> '-';
 VV02      If WEEK_100 = '0' or WEEK_100 = '-';
 VV02         WEEK_100 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt100:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_100);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_101 <> '0' and WEEK_101 <> '-';
 VV02      If WEEK_101 = '0' or WEEK_101 = '-';
 VV02         WEEK_101 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt101:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_101);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_102 <> '0' and WEEK_102 <> '-';
 VV02      If WEEK_102 = '0' or WEEK_102 = '-';
 VV02         WEEK_102 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt102:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_102);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_103 <> '0' and WEEK_103 <> '-';
 VV02      If WEEK_103 = '0' or WEEK_103 = '-';
 VV02         WEEK_103 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt103:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_103);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;
 VV02 *  //If WEEK_104 <> '0' and WEEK_104 <> '-';
 VV02      If WEEK_104 = '0' or WEEK_104 = '-';
 VV02         WEEK_104 = '0';
 VV02      Endif;
              WkDate   = %SubSt(WD.WDt104:8:11);
              SIAVLDAT = %char(%date(%Trim(WkDate):*usa/):*iso0);
              SISUPQTY = %Int(WEEK_104);
              Exsr CalcAlcQty;
              SIALCQTY = WkAlcQty;
              SIAVLQTY = SISUPQTY - SIALCQTY;
              Exsr WriteInvFile;
 VV02 *  //Endif;

        EndSr;
      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : CalcAlcQty Subroutine :
      *?                :-----------------------:
      *
        Begsr CalcAlcQty;
      *
      *?   // Calculate Allocated Qty from FCUTORD file

           WkItem = *Blanks;
           WkSize = *Blanks;
           WkAlcQty = *Zeros;
           Chain ('SYNGENTA FLOWER':'Vendor':VARIETY_ID) XREFINVTL0;
           If %Found;
              WkItem = XRLCLITEM;
              WkSize = XRLCLSIZE;
           Endif;

           WkAvlDat = %dec(%char(%date(SIAVLDAT:*iso0):*cymd0):7:0);
           Exec Sql
 VV01         Select sum(COQTOO - COQTRC) into :WkAlcQty :NullInd from FCUTORD
                     where COVEND = 2099
                       and COSTAT <> 'D'
                       and COITEM = :WkItem
                       and COSIZE = :WkSize
                       and COSOWD = :WkAvlDat;
 VV01         If NullInd = NullValue;
 VV01            WkAlcQty = 0;
 VV01         Endif;
        EndSr;
      *
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : WriteInvFile Subroutine :
      *?                :-------------------------:
      *
        Begsr WriteInvFile;
      *
      *?   // Write record to Supplier Inventory File
            SIMSGPR  = 'AvailabilityFeed';
            SIREFID  = *Blanks;
            SIIDATE  = %Char(%Date) +'T' + %Char(%Time);
            SIFRORID = 'Syngenta';
            SITOORID = 'KubePak';
            SISNDORID= 'Syngenta';
            SIVENNUM = 2099;
            SIVENNAM = 'Syngenta';
            SIPLTCDE = URC_TYPE;
            SIMATTYP = CROP;
            SIITEM   = VARIETY_ID;
            WkSeq   +=1;
            SISEQNO  = WkSeq;
            SIUOM    = 'EA';
      *?   // Audit Stamp
            SICRTDAT = Rundate;
            SICRTTIM = Runtime;
            SICRTUSR = User;
            SICRTJOB = Job;
            SICRTPGM = Pgm;

      *?   // Write Rec
           Write WSSUPINVR;
        EndSr;

      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : CallCmd Subroutine :
      *?                :--------------------:
      *
        Begsr CallCmd;

      *?   // Call QCMDEXC ,Monitor if there is a error
           Monitor;
              QCmdExc(%Trim(Command): %Len(%Trim(Command)));
           On-Error;
           EndMon;

        EndSr;
      //--------------------------------------------------------------------
