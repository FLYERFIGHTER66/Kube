**FREE
    //? Program        : WSURCSUP03
    //?
    //? Description    : This program is to Get .csv from Suppliers URL
    //?                  and upload the data into WSSUPINVPF
    //?                  for Plant Source International Only
    //?
    //? Created By     : Vimala
    //?
    //? Date           : 18 Sep 2018
    //?-------------------------------------------------------------------
    //? Special Notes  : ** Get .CSV from  Suppliers URL
    //?                : ** Write .CSV data into IFS stream file
    //?                : ** Copy Stream file to Qtemp PF file
    //?                : ** Delete all records from WSSUPINVPF before each run
    //?                : ** Process QTemp PF and write to WSSUPINVPF where

    //? Called Program : QCMDEXC - Pgm To Call CL command in Rpg
    //?-------------------------------------------------------------------

//?---------------- Modification Log ---------------------------------------
    //  MOD#    MOD Date   Programmer   Description
    //  ------  --------   ----------   ------------------------------------
    //  VV01    11/02/18   Vimala V     Include records having Quantity=0
    //  VV02    11/08/18   Vimala V     Change selection in SQL
    //  WJB01   11/27/18   Bill Behr    Change selection in SQL
    //  SUD01   05/14/19   S.Uthaya     Issue Fix in Using Monitor and Dummy
    //                                  records added with Zero Qty
    //          09/04/19   Bill Behr    Reworked PGM - Multiple changes - Use Arrays
    //          09/05/19   Bill Behr    Converted to all **FREE RPGLE

//?---------------- Header Specifications --------------------------------

        Ctl-Opt  Debug option(*NODEBUGIO : *SRCSTMT) Dftactgrp(*No)
           Actgrp(*Caller) DatFmt(*USA) Thread(*Serialize) Alwnull(*UsrCtl);

//?---------------- File Specification -----------------------------------

    //?File: WS - Supplier Inventory File    Key : Customer Number : Card Number : Token Number
    Dcl-F WSSUPINVPF Disk(*Ext) Usage(*Output:*Delete);

    //?File: Broker Default File             Key : Customer Number : Customer Number : Token Number
    Dcl-F FBROKDFTL0 Disk(*Ext) Keyed Usage(*Input);

    //?File: WS - Cross Reference for FMINVT Key : ProvidedbyName : ProvidedbyType : ForeignKeyValue
    Dcl-F XREFINVTL0 Disk(*Ext) Keyed Usage(*Input);

    //?File: Calendar CYW (Mondays Only)     Key : Century : Year : Week
    Dcl-F FCALENCYW  Disk(*Ext) Keyed Usage(*Input);

//?---------------- Data Specifications -----------------------------------

    Dcl-Pi WSURCSUP03 ExtPgm;
       PSupCde  Char(6);
    End-Pi;

    Dcl-Pr QCMDEXC Extpgm;
       Command Char(2000) Const Options(*Varsize);
       Len Packed(15:5) Const;
    End-Pr;

    Dcl-S CSV      SQLTYPE(BLOB_FILE);
    Dcl-S Command  Char(2000)   Inz;
    Dcl-S WkUrl    VarChar(255);
    Dcl-S FlDummy  Ind Inz(*Off);
    Dcl-S WkSeq     Packed(10)    Inz;
    Dcl-S WkCYMD    Packed(7)     Inz;
    Dcl-S WkItem    Char(15)      Inz;
    Dcl-S WkSize    Char(3)       Inz;
    Dcl-S WkAvlDat  Packed(7)     Inz;
    Dcl-S WkAlcQty  Packed(11)    Inz;
    Dcl-S WkCent    Packed(2)     Inz;
    Dcl-S WkYear    Packed(2)     Inz;
    Dcl-S Col#      Packed(2)     Inz;           // Column Number Index
    Dcl-S Week      Packed(2)     Inz;
    Dcl-S WkCurYr   Char(1)       Inz('N');
    Dcl-S NullInd   Int(5)        Inz(0);        // Null Indicator for WkAlcQty
    Dcl-S NullValue Like(NullInd) Inz(-1);
    Dcl-S WDtArray  Char(10)      Inz Dim(52);   // 52 Columns of Data Array
    Dcl-S WeekArray Zoned(8:0)    Inz Dim(52);   // Week in CCYYMMDD for 52 columns Array
    Dcl-S Monday    Zoned(8:0)    Inz;           // Work field for Monday Date

    Dcl-Ds WSPSIDS ExtName('RC_PSIDATA');
    End-Ds;

    Dcl-Ds WD Qualified;
      WDItemCode Char(15) Inz;
      WDItemDesc Char(40) Inz;
      WDt001     Char(10) Inz;
      WDt002     Char(10) Inz;
      WDt003     Char(10) Inz;
      WDt004     Char(10) Inz;
      WDt005     Char(10) Inz;
      WDt006     Char(10) Inz;
      WDt007     Char(10) Inz;
      WDt008     Char(10) Inz;
      WDt009     Char(10) Inz;
      WDt010     Char(10) Inz;
      WDt011     Char(10) Inz;
      WDt012     Char(10) Inz;
      WDt013     Char(10) Inz;
      WDt014     Char(10) Inz;
      WDt015     Char(10) Inz;
      WDt016     Char(10) Inz;
      WDt017     Char(10) Inz;
      WDt018     Char(10) Inz;
      WDt019     Char(10) Inz;
      WDt020     Char(10) Inz;
      WDt021     Char(10) Inz;
      WDt022     Char(10) Inz;
      WDt023     Char(10) Inz;
      WDt024     Char(10) Inz;
      WDt025     Char(10) Inz;
      WDt026     Char(10) Inz;
      WDt027     Char(10) Inz;
      WDt028     Char(10) Inz;
      WDt029     Char(10) Inz;
      WDt030     Char(10) Inz;
      WDt031     Char(10) Inz;
      WDt032     Char(10) Inz;
      WDt033     Char(10) Inz;
      WDt034     Char(10) Inz;
      WDt035     Char(10) Inz;
      WDt036     Char(10) Inz;
      WDt037     Char(10) Inz;
      WDt038     Char(10) Inz;
      WDt039     Char(10) Inz;
      WDt040     Char(10) Inz;
      WDt041     Char(10) Inz;
      WDt042     Char(10) Inz;
      WDt043     Char(10) Inz;
      WDt044     Char(10) Inz;
      WDt045     Char(10) Inz;
      WDt046     Char(10) Inz;
      WDt047     Char(10) Inz;
      WDt048     Char(10) Inz;
      WDt049     Char(10) Inz;
      WDt050     Char(10) Inz;
      WDt051     Char(10) Inz;
      WDt052     Char(10) Inz;
    End-Ds;

    Dcl-Ds Pgmstatus PSDS;
       Job     Char(10) Pos(244);
       User    Char(10) Pos(254);
       Rundate Zoned(6) Pos(276);
       Runtime Zoned(6) Pos(282);
       Pgm     Char(10) Pos(334);
    End-Ds;

//?---------------- Calculation Specs --------------------------------

    Exsr DelInv;   // Clear all records from WSSUPINVPF before loading fresh data

    Exsr GetCSV;   // Get .csv file from Suppliers Url into IFS folder

    Exsr LoadInv;  // Load Inventory

    Exsr EndPgm;

//--------------------------------------------------------------------

    Begsr DelInv;

       Exec Sql  // Delete all records from Supplier Inventory File -SUD01
          Delete from Qtemp.RC_PSIDATA ;

       Exec Sql  // Delete all records from Supplier Inventory File
          Delete from WSSUPINVPF where SIFRORID = 'PSI URC';

    Endsr;

//--------------------------------------------------------------------

    Begsr GetCSV;

      // Get Url from Control File
      Chain (PSupCde :'SUPPURLPATH') FBROKDFTL0;
      If %Found;
        WkUrl = %Trim(DFVARVAL);
      Endif;

      // If IFS file does not exist , create file
      CSV_Name = '/tmp/rc_psidata.csv';
      Command  = 'STRQSH Cmd(''' + 'TOUCH ' + %Trim(CSV_Name) + ''' )';
      Exsr CallCmd;

      // Change attributes of Stream file
      Command = 'CHGATR OBJ(''' + %Trim(CSV_Name) + ''')' +
                        ' ATR(*CCSID) VALUE(1208)';
      Exsr CallCmd;

      // To get Inventory Data from Web Url in .csv format and store in IFS
      CSV_NL=%Len(%TrimR(CSV_Name));
      CSV_FO=SQFOVR;                                        // Overwrite
      Exec SQL Set :CSV = SYSTOOLS.HTTPGETBLOB(:WkUrl,'');  // Get data and put in IFS file

      // Create QTEMP file to hold data
      Exec SQL
        Drop table qtemp.rc_psidata;

      Exec SQL
         Create or Replace Table qtemp.psi_URC_Upload
         For system name rc_psidata
        (PSI_ItemCode for column Item_Code CHAR(15) NOT NULL WITH DEFAULT
        ,PSI_ItemDesc for column Item_Desc CHAR(40) NOT NULL WITH DEFAULT
        ,Week_001 Char(10) NOT NULL WITH DEFAULT
        ,Week_002 Char(10) NOT NULL WITH DEFAULT
        ,Week_003 Char(10) NOT NULL WITH DEFAULT
        ,Week_004 Char(10) NOT NULL WITH DEFAULT
        ,Week_005 Char(10) NOT NULL WITH DEFAULT
        ,Week_006 Char(10) NOT NULL WITH DEFAULT
        ,Week_007 Char(10) NOT NULL WITH DEFAULT
        ,Week_008 Char(10) NOT NULL WITH DEFAULT
        ,Week_009 Char(10) NOT NULL WITH DEFAULT
        ,Week_010 Char(10) NOT NULL WITH DEFAULT
        ,Week_011 Char(10) NOT NULL WITH DEFAULT
        ,Week_012 Char(10) NOT NULL WITH DEFAULT
        ,Week_013 Char(10) NOT NULL WITH DEFAULT
        ,Week_014 Char(10) NOT NULL WITH DEFAULT
        ,Week_015 Char(10) NOT NULL WITH DEFAULT
        ,Week_016 Char(10) NOT NULL WITH DEFAULT
        ,Week_017 Char(10) NOT NULL WITH DEFAULT
        ,Week_018 Char(10) NOT NULL WITH DEFAULT
        ,Week_019 Char(10) NOT NULL WITH DEFAULT
        ,Week_020 Char(10) NOT NULL WITH DEFAULT
        ,Week_021 Char(10) NOT NULL WITH DEFAULT
        ,Week_022 Char(10) NOT NULL WITH DEFAULT
        ,Week_023 Char(10) NOT NULL WITH DEFAULT
        ,Week_024 Char(10) NOT NULL WITH DEFAULT
        ,Week_025 Char(10) NOT NULL WITH DEFAULT
        ,Week_026 Char(10) NOT NULL WITH DEFAULT
        ,Week_027 Char(10) NOT NULL WITH DEFAULT
        ,Week_028 Char(10) NOT NULL WITH DEFAULT
        ,Week_029 Char(10) NOT NULL WITH DEFAULT
        ,Week_030 Char(10) NOT NULL WITH DEFAULT
        ,Week_031 Char(10) NOT NULL WITH DEFAULT
        ,Week_032 Char(10) NOT NULL WITH DEFAULT
        ,Week_033 Char(10) NOT NULL WITH DEFAULT
        ,Week_034 Char(10) NOT NULL WITH DEFAULT
        ,Week_035 Char(10) NOT NULL WITH DEFAULT
        ,Week_036 Char(10) NOT NULL WITH DEFAULT
        ,Week_037 Char(10) NOT NULL WITH DEFAULT
        ,Week_038 Char(10) NOT NULL WITH DEFAULT
        ,Week_039 Char(10) NOT NULL WITH DEFAULT
        ,Week_040 Char(10) NOT NULL WITH DEFAULT
        ,Week_041 Char(10) NOT NULL WITH DEFAULT
        ,Week_042 Char(10) NOT NULL WITH DEFAULT
        ,Week_043 Char(10) NOT NULL WITH DEFAULT
        ,Week_044 Char(10) NOT NULL WITH DEFAULT
        ,Week_045 Char(10) NOT NULL WITH DEFAULT
        ,Week_046 Char(10) NOT NULL WITH DEFAULT
        ,Week_047 Char(10) NOT NULL WITH DEFAULT
        ,Week_048 Char(10) NOT NULL WITH DEFAULT
        ,Week_049 Char(10) NOT NULL WITH DEFAULT
        ,Week_050 Char(10) NOT NULL WITH DEFAULT
        ,Week_051 Char(10) NOT NULL WITH DEFAULT
        ,Week_052 Char(10) NOT NULL WITH DEFAULT
         ) RCDFMT  RSPSIDATA;

      // Upload .CSV file from IFS to PF
      Command = 'CPYFRMIMPF FROMSTMF(''' + %trim(CSV_Name) + ''') ' +
         ' TOFILE(qtemp/rc_psidata) ' +
         ' MBROPT(*REPLACE) ' +
         ' FROMCCSID(*FILE) ' +
         ' TOCCSID(*File)  ' +
         ' RCDDLM(*CRLF)  ' +
         ' STRDLM(*DBLQUOTE) ' +
         ' RMVBLANK(*NONE) ' +
         ' FROMRCD(*FIRST *END) ' +
         ' ERRRCDOPT(*REPLACE) ' +
         ' RPLNULLVAL(*FLDDFT) ';
      Exsr CallCmd;

    Endsr;

//--------------------------------------------------------------------

    Begsr LoadInv;
    //?Logic : Read Rc_psidata file and load WSSUPINVPF

      Exec Sql  // Read first record only to get column heading for date values
         Select * into :WD from qtemp.rc_psidata
         Fetch first row only;   // First row = headings with week numbers

      ExSr Move2Array;
      // Get week Dates for the data provided
      For Col# = 1 to 52;
        If WDtArray(Col#) <> *Blanks;
          Week =
            %int(%subst(WDtArray(Col#):%len(%trim(WDtArray(Col#)))-1:2));
          Exec SQL
           Select MONDAY8YMD into :Monday from mondays_all
            where WEEK_NUMBER = :Week and datefld
            between most_recent_Monday and current date + 365 days;
          WeekArray(Col#) = Monday;
        ENDIF;
      ENDFOR;

      // Load Dummy Records if First Week is Zeros
      If WeekArray(1) = *Zeros;
        Exsr LoadDummySr;
        ExSr EndPgm;
      ENDIF;

      // Read records to populate inventory file
      Exec Sql Declare A1 cursor for // WJB01
         Select * from qtemp.rc_psidata
            Where Upper(Item_Code) Not Like '%CODE%'
            AND Upper(Item_Code) Not Like '%ITEM%'
            AND Item_Code <> ' '        // WJB02
            For Read only;
      Exec Sql Open A1;
      If SqlCode = -502 ;
         Exec Sql Close A1;
         Exec Sql Open A1;
      Endif;

      Exec Sql Fetch Next From A1 Into :WD;
      Dow SqlCod = 0;

         // Move Qty based on Date Column
         ExSr Move2Array;
         For Col# = 1 to 52;
           If WeekArray(Col#) <> 0;
             SIAVLDAT = %char(WeekArray(Col#));
             Monitor;
               SISUPQTY = %Int(WDtArray(Col#));
              On-Error;
               SISUPQTY = *Zero;
             EndMon;
             Exsr CalcAlcQty;
             SIALCQTY = WkAlcQty;
             SIAVLQTY = SISUPQTY - SIALCQTY;
             Exsr WriteInvFile;
           ENDIF;
         ENDFOR;

         Exec Sql Fetch next from A1 into :WD;

      Enddo;
      Exec Sql Close A1;

    Endsr;

//--------------------------------------------------------------------

    Begsr CalcAlcQty;

      // Calculate Allocated Qty from FCUTORD file
      WkItem   = *Blanks;
      WkSize   = *Blanks;
      WkAlcQty = *Zeros;
      Chain ('PSI URC':'Vendor':Item_Code) XREFINVTL0;
      If %Found;
         WkItem = XRLCLITEM;
         WkSize = XRLCLSIZE;
      Endif;

      WkAvlDat = %Dec(%Char(%Date(SIAVLDAT:*ISO0):*CYMD0):7:0);
      Exec Sql
         Select Sum(COQTOO - COQTRC) Into :WkAlcQty :NullInd from FCUTORD
         Where COVEND = 1908
            And COSTAT <> 'D'
            And COITEM = :WkItem
            And COSIZE = :WkSize
            And COSOWD = :WkAvlDat;
      If NullInd = NullValue;
         WkAlcQty = 0;
      Endif;

    Endsr;

//--------------------------------------------------------------------

    Begsr Move2Array;
      WDtArray(01) = WD.WDt001;
      WDtArray(02) = WD.WDt002;
      WDtArray(03) = WD.WDt003;
      WDtArray(04) = WD.WDt004;
      WDtArray(05) = WD.WDt005;
      WDtArray(06) = WD.WDt006;
      WDtArray(07) = WD.WDt007;
      WDtArray(08) = WD.WDt008;
      WDtArray(09) = WD.WDt009;
      WDtArray(10) = WD.WDt010;
      WDtArray(11) = WD.WDt011;
      WDtArray(12) = WD.WDt012;
      WDtArray(13) = WD.WDt013;
      WDtArray(14) = WD.WDt014;
      WDtArray(15) = WD.WDt015;
      WDtArray(16) = WD.WDt016;
      WDtArray(17) = WD.WDt017;
      WDtArray(18) = WD.WDt018;
      WDtArray(19) = WD.WDt019;
      WDtArray(20) = WD.WDt020;
      WDtArray(21) = WD.WDt021;
      WDtArray(22) = WD.WDt022;
      WDtArray(23) = WD.WDt023;
      WDtArray(24) = WD.WDt024;
      WDtArray(25) = WD.WDt025;
      WDtArray(26) = WD.WDt026;
      WDtArray(27) = WD.WDt027;
      WDtArray(28) = WD.WDt028;
      WDtArray(29) = WD.WDt029;
      WDtArray(30) = WD.WDt020;
      WDtArray(31) = WD.WDt031;
      WDtArray(32) = WD.WDt032;
      WDtArray(33) = WD.WDt033;
      WDtArray(34) = WD.WDt034;
      WDtArray(35) = WD.WDt035;
      WDtArray(36) = WD.WDt036;
      WDtArray(37) = WD.WDt037;
      WDtArray(38) = WD.WDt038;
      WDtArray(39) = WD.WDt039;
      WDtArray(40) = WD.WDt040;
      WDtArray(41) = WD.WDt041;
      WDtArray(42) = WD.WDt042;
      WDtArray(43) = WD.WDt043;
      WDtArray(44) = WD.WDt044;
      WDtArray(45) = WD.WDt045;
      WDtArray(46) = WD.WDt046;
      WDtArray(47) = WD.WDt047;
      WDtArray(48) = WD.WDt048;
      WDtArray(49) = WD.WDt049;
      WDtArray(50) = WD.WDt050;
      WDtArray(51) = WD.WDt051;
      WDtArray(52) = WD.WDt052;
    Endsr;

//--------------------------------------------------------------------

    Begsr WriteInvFile;

      // Write record to Supplier Inventory File
      SIMSGPR  = 'AvailabilityFeed';
      SIREFID  = WD.WDItemDesc;
      SIIDATE  =  %Char(%Date) +'T' + %Char(%Time);
      SIFRORID = 'PSI URC';
      SITOORID = 'KubePak';
      SISNDORID= 'PSI URC';
      SIVENNUM = 1908;
      SIVENNAM = 'Plant Src Intl';
      SIPLTCDE = *Blanks;
      SIMATTYP = 'SELLER';
      SIITEM   = WD.WDItemCode;
      WkSeq   +=1;
      SISEQNO  = WkSeq;
      SIUOM    = 'EA';

      // Audit Stamp
      SICRTDAT = Rundate;
      SICRTTIM = Runtime;
      SICRTUSR = User;
      SICRTJOB = Job;
      SICRTPGM = Pgm;

      // Write Rec
      Write WSSUPINVR;

    Endsr;

//--------------------------------------------------------------------

    Begsr LoadDummySr;


      Exec Sql  // Delete all records from Supplier Inventory File
         Delete from Qtemp.RC_PSIDATA ;

      Exec Sql // Insert Header record
        Insert Into qtemp.rc_psidata
          Values('Item' , 'Desc' ,
          01,02,03,04,05,06,07,08,09,10,
          11,12,13,14,15,16,17,18,19,20,
          21,22,23,24,25,26,27,28,29,30,
          31,32,33,34,35,36,37,38,39,40,
          41,42,43,44,45,46,47,48,49,50,
          51,52);

      Exec Sql // Insert Zero records
        Insert Into qtemp.rc_psidata(
          Select XRFORKEY,
          XRDESC  ,
          0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,
          0,0,0,0,0,0,0,0,0,0,
          0,0
          From XREFINVT Where XRPVDID = 1908);

    Endsr;

//--------------------------------------------------------------------

    Begsr CallCmd;

      Monitor;  // Call QCMDEXC ,Monitor if there is a error
         QCmdExc(%Trim(Command): %Len(%Trim(Command)));
      On-Error;
      EndMon;

    Endsr;

//--------------------------------------------------------------------

        Begsr EndPgm;
           *InLr = *On;
           Return;
        Endsr;

//?-------------------- End Of Subroutines ----------------------------
