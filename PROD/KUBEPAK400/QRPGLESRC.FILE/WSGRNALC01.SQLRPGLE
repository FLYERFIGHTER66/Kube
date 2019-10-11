      *? Program         : WSGRNALC01
      *?
      *? Description     : This Pgm is to Store Space allocation details into
      *?                   Work file
      *? Created By      : S.Uthayadurga
      *?
      *? Date            : 18 Feb 2019
      //--------------------------------------------------------------------
      *? Special Notes   :** Get data from Current Date to 53 Weeks Date
      *?                  ** Get data into query file
      *?                  ** Calculate Unit Values & write into Main File
      *?                  ** Calculate Total Values & write into Summary File
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   04/24/19   S.Uthaya     Added Summary File
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
      *?File: WS - Green House Space Allocation Query File
        Dcl-F WSGHSQRYPF Disk(*Ext) Usage(*Input:*Output);
      *
      *?File: WS - Green House Space Allocation File
        Dcl-F WSGRNSPCPF Disk(*Ext) Usage(*Input:*Output);
      *
SUD01 *?File: WS - Green House Space Summary File
SUD01   Dcl-F WSSPCSUML1 Disk(*Ext) Usage(*Update:*Output);
      *
      *?File: M/F Item Master File
      *?Key : Item : Size
        Dcl-F FMINVT     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Production Factor Table Master File
      *?Key : Table Id
        Dcl-F FPTABLE    Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: M/F Production Factor Table Master File
      *?Key : Table Id
        Dcl-F FMPRCL     Disk(*Ext) Keyed Usage(*Input);
      *
      *?File: Calendar File
      *?Key : Date
        Dcl-F FCALEN     Disk(*Ext) Keyed Usage(*Input);
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Data Specification :
      *?                :--------------------:
      *
      *?Procedure Interface Declaration : *Entry
        Dcl-Pi WSGRNALC01 ExtPgm;
        End-Pi;
      *
      *?Procedure Prototype Declaration : Call Sow Factor
        Dcl-Pr #SOWFACTOR Extpgm;
           PItem Like(IMITEM);
           PSize Like(IMSIZE);
           PFTab Like(IMFTAB);
           POQty Zoned(7:0);
           PSQty Zoned(7:0);
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
      *?Date Data Structure : For Date MMDD/YY
        Dcl-Ds WkCymdDs Len(6);
           Mdy1    Char(4) Pos(1);
           Mdy2    Char(2) Pos(5);
        End-Ds;
      *
      *?Date Data Structure : For Date MM/DD/YY
        Dcl-Ds WkDTRQ Len(6);
           MM      Packed(2) Pos(1);
           DD      Packed(2) Pos(3);
           YY      Packed(2) Pos(5);
        End-Ds;
      *
      *?Date Data Structure : FPTABLE Datastructure
        Dcl-Ds FactorDs Extname('FPTABLE') End-Ds;
      *
      *?Date Data Structure : Used for Factor Calculation
        Dcl-Ds Ds1 Qualified;
           Stat    Char(1);
           TabId   Char(2);
           Desc    Char(30);
           Type    Char(2);
           BegQty  Packed(7:0) Dim(12);
           EndQty  Packed(7:0) Dim(12);
           FacUnt  Packed(5:0) Dim(12);
           FacPer  Packed(5:2) Dim(12);
        End-Ds;
      *
      *?Date Data Structure : Summary File
        Dcl-Ds Ds2 Qualified;
           Year    Packed(4:0);
           Qty     Packed(11:0) Dim(53);
        End-Ds;
      *
      *?Array Declaration : For Product Class , Date and FMINVT
        Dcl-S PC      Char(2)     Dim(7) Ctdata PerRcd(7) Ascend; // Compiletime Array for PC
        Dcl-S IGB     Like(IMBD1) Dim(4);              // Begin Date GERM(1-4)
        Dcl-S IGE     Like(IMED1) Dim(4);              // End Date GERM(1-4)
        Dcl-S IGW     Like(IMWG1) Dim(4);              // Weeks to GERM(1-4)
        Dcl-S IGB7    Zoned(7:0)  Dim(4);              // Begin Date (Cyymmdd)
        Dcl-S IGE7    Zoned(7:0)  Dim(4);              // End Date (Cyymmdd)
        Dcl-S GF      Zoned(8:0)  Dim(53);             // Germinate Unit
        Dcl-S HF      Zoned(8:0)  Dim(53);             // Hold Unit
        Dcl-S DtAry   Packed(7:0) Dim(99);             // Load Date array for 99 Weeks
        Dcl-S DtAry6  Packed(6:0) Dim(53);             // Load Date array for 53 Weeks
      *
      *?Global Variable Declaration : Used for Calculation
        Dcl-S X      Zoned(3);                         // Count used for FOR Loop
        Dcl-S BYR    Zoned(2);                         // Begin Year
        Dcl-S EYR    Zoned(2);                         // End Year
        Dcl-S ToSow  Zoned(7);                         // Quantity to Sow
        Dcl-S TotGer Zoned(2:0);                       // Total Germ
        Dcl-S Count  Zoned(3);                         // Count
      *
      *?Flag Variable Declaration : For Date Validation
        Dcl-S FlError Ind Inz(*Off);                 // Date Validation Flag
      *
      *?Work Variable Declaration : Used for Calculation
        Dcl-S WkPclass   Char(2);                      // Product Class
        Dcl-S WkDate     Date(*ISO);                   // Current date
        Dcl-S WkCDate    Date(*ISO);                   // Current Monday Date
        Dcl-S WkLDate    Date(*ISO);                   // 53rd Week Monday Date
        Dcl-S WkMon      Date(*ISO);                   // Monday Week
        Dcl-S WkCount    Zoned(2);                     // Count
        Dcl-S WkGerm     Zoned(2);                     // Germinate
        Dcl-S WkStrAry   Zoned(2);                     // Start Array
        Dcl-S WkEndAry   Zoned(2);                     // End Array
        Dcl-S WkTot      Zoned(2);                     // Total Number of Weeks
SUD01   Dcl-S WkWeek     Zoned(2);                     // Week used for Summary file
  |     Dcl-S WkDate6    Zoned(6);                     // Date in MDY
SUD01   Dcl-S WkDat6     Zoned(6);                     // Current Date in MDY
        Dcl-S WkMdy      Zoned(6);                     // Date in MDY
        Dcl-S WkCMon     Zoned(6);                     // First Monday Date
        Dcl-S WkLMon     Zoned(6);                     // 53rd Week Monday Date
        Dcl-S WkMon7     Zoned(7);                     // Monday CYYMMDD format
        Dcl-S WkCymd     Zoned(7);                     // Used for Date Conversion
        Dcl-S WkOrder    Zoned(7);                     // Quantity Ordered
        Dcl-S WkGrmCnt   Zoned(2:0);                   // Germ Count
        Dcl-S WkNoWeek   Zoned(2:0);                   // Total Number Of Week
        Dcl-S WkS        Zoned(3:0);                   // Week Count
        Dcl-S WkPc       Zoned(5:4);                   // Used for Factor Calculation
        Dcl-S WkPct      Zoned(5:4);                   // Used for Factor Calculation
        Dcl-S WkQty      Zoned(8:1);                   // Quantity
        Dcl-S WkSOWQTY   Zoned(8:1);                   // Sow Quantity
SUD01   Dcl-S WkTotQty   Packed(11:0);                 // Total Quantity
SUD01   Dcl-S WkYear     Packed(4:0);                  // Year used for Summary file
      *
      *?Program Indicators Declaration :
        Dcl-S True  Ind Inz(*On);
        Dcl-S False Ind Inz(*Off);
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

      *?   // Process
           Exsr Process;

      *?   // End Program
           Exsr EndPgm;

      //--------------------------------------------------------------------
      *?                :-----------------------:
      *?                : Initialise Subroutine :
      *?                :-----------------------:
      *
      *?Logic : Initialise Parameters
      *?      : Get First and Last Monday in All formats
      *?
        Begsr InzPgm;

      *?   // Get Monday Date for Current date
           WkDate  = %Date;                                // Today  YYYY-MM-DD
           WkDat6  = Rundate;                              // Today  MMDDYY
           WkCMon  = $MDYDate($Monday(WkDate:'FRI'));      // Monday MMDDYY
           WkCDate = %Date(WkCMon:*MDY);                   // Monday YYYY-MM-DD
           WkLDate = WkCDate + %Days(365);                 // Next 53rd Week
           WkLMon  = $MDYDate($Monday(WkLDate:'FRI'));     // Next 53rd Monday MMDDYY
           WkLDate = %Date(WkLMon:*MDY);                   // Next 53rd Monday YYYY-MM-DD

      *?   // Clear Query File
           Exec Sql Delete from WSGHSQRYPF;

      *?   // Check Records Exists in Main File for Current Date
           Exec Sql Select Count(*) Into :Count From WSGRNSPCPF
              Where GSRDAT = :Rundate;
           If Count > 0;

      *?      // If Found , Delete Records from WSGRNSPCPF Only for Current Date
              Exec Sql
                 Delete from WSGRNSPCPF Where GSRDAT = :Rundate;
              WkCount = 0;
           Endif;

      *?   // Load Array
           Exsr LoadArray;

        Endsr;
      //--------------------------------------------------------------------
      *?                :----------------------:
      *?                : LoadArray Subroutine :
      *?                :----------------------:
      *
      *?Logic : Load array for load back 20 weeks and next 53 weeks
      *?        from the Current Monday date
      *?      : Get Start array , End Array and Total Week
      *?
        Begsr LoadArray;

      *?   // Load Date Array from back 20 weeks
           For X = 1 to 99;
              If X = 1;
                 WkMon = WkCDate - %Days(140);               // 20 Weeks Back
                 WkMon7 = %Int(%Char(WkMon:*CYMD0));
              Else;
                 WkMon = WkMon + %Days(7);                   // Next Week
                 WkMon7 = %Int(%Char(WkMon:*CYMD0));
              Endif;
              DtAry(X) = WkMon7;
           Endfor;

      *?   // Get Start Array
           WkMon7 = %Int(%Char(WkCDate:*CYMD0));
           X = %Lookup(WkMon7:DtAry:1:99);
           WkStrAry = X;

      *?   // Get End Array
           WkMon7 = %Int(%Char(WkLDate:*CYMD0));
           X = %Lookup(WkMon7:DtAry:1:99);
           WkEndAry = X + 1;

      *?   // Get No of Weeks
           WkTot = WkEndAry - WkStrAry;

      *?   // Load Date Array in MDY format for 53 Weeks
           X = 1;
           WkCount = WkStrAry;
           Dou X = WkTot + 1;
              DtAry6(X) = %Int(%Char(%Date(DtAry(WkCount):*Cymd):*Mdy0));
              WkCount += 1;
              X += 1;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : Process Subroutine :
      *?                :--------------------:
      *
      *?Logic : Get the data from FIORDR and FMINVT files
      *?
        Begsr Process;

      *?   // Get Data and Write into Work file
           Exsr GetData;

      *?   // Get Record for Space Allocation File
           Exsr GetRec;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : Endpgm Subroutine :
      *?                :-------------------:
      *
        Begsr EndPgm;

      *?   // Write Summary File
           Exsr WriteSum;

      *?   // Close Cursor
           Exec Sql Close A1;

      *?   // End the Program
           *InLr = *On;
           Return;

        Endsr;
      //--------------------------------------------------------------------
      *?            :--------------------:
      *?            : GetData Subroutine :
      *?            :--------------------:
      *
      *?Logic : Get Data from Order Detail file and Item Master File

        Begsr GetData;

      *?   // Select records from Order Header and Item Master file
           Exec Sql Declare A1 Cursor For
              SELECT
              ALL    T02.IMPCL1, T01.OIITEM, T01.OISIZE, T01.OIDTRQ, T01.OIRVDT,
                     T01.OISOW, Sum((OIQORD-OIQSHP))
              FROM   FIORDR T01 INNER JOIN
                     FMINVT T02
              ON     OIITEM = IMITEM
                AND  OISIZE = IMSIZE
              WHERE  OISTAT <> 'D'
                AND  OISOW > 000000
                AND  OIQORD-OIQSHP > 0
                AND  OISTA <> 'Y'
                AND  OIQTE <> 'Y'
              Group By
                T01.OIITEM, T01.OISIZE, T01.OIDTRQ, T01.OIRVDT, T02.IMPCL1,
                     T01.OISOW
              ORDER BY  001 ASC, 002 ASC, 003 ASC, 005 ASC;

      *?   // Open Cursor
           Exec Sql Open A1;

           If SqlCode = -502 ;
              Exec Sql Close A1;
              Exec Sql Open A1;
           Endif;
           Exec Sql Fetch A1 into :GRPCL1, :GRITEM, :GRSIZE, :GRDTRQ, :GRRVDT,
                    :GRSOW, :GRQTY;

      *?   // Load File
           Dow SqlCod = 0;
              Exec SQL
                 Insert into WSGHSQRYPF
                 Values(:GRITEM, :GRSIZE, :GRPCL1, :GRDTRQ, :GRRVDT,
                        :GRSOW, :GRQTY);

              Exec Sql Fetch A1 into :GRPCL1, :GRITEM, :GRSIZE, :GRDTRQ,
                       :GRRVDT, :GRSOW, :GRQTY;
           Enddo;

        Endsr;
      //--------------------------------------------------------------------
      *?            :-------------------:
      *?            : GetRec Subroutine :
      *?            :-------------------:
      *
      *?Logic : Get a record for Space allocation file

        Begsr GetRec;

      *?   // Read all record from the File
           Setll *Start WSGHSQRYPF;
           Read WSGHSQRYPF;
           Dow Not %Eof;
              Chain (GRITEM:GRSIZE) FMINVT;

      *?      // For Each Product Class Write a record into File
              If WkPClass <> IMPCL1 and WkPClass > *Blanks;
                 Exsr WriteRec;
                 WkPClass = *Blanks;
              Endif;

      *?      // If Product Class Found in Array
              X = %LookUp(IMPCL1:PC:1:7);
              If X <> 0;

      *?         // Move Germ values into Array
                 Exsr MoveGermValues;

      *?         // Get Germ Values
                 WkPClass = IMPCL1;
                 Exsr GetGerminate;
                 If IMFTAB <= *Blanks Or IMFTAB = '00';
                    IMFTAB = '01';
                 Endif;
                 If IMFTAB <> '**';
                    Chain IMFTAB FPTABLE;
                    Ds1 = FactorDs;
                 Endif;

      *?         // Get Product Class Description
                 Chain IMPCL1 FMPRCL;

      *?         // Get Number of Weeks
                 Exsr GetWeek;
                 If WkNoWeek > 0;

      *?            // Get Quantity
                    Exsr GetQty;

      *?            // Add Qty to Arrays
                    Exsr AddAry;
                 Endif;
              Endif;
              Read WSGHSQRYPF;
           Enddo;

      *?   // Write Last Class
           If WkPClass <> IMPCL1 and WkPClass > *Blanks;
              Exsr WriteRec;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?            :---------------------:
      *?            : WriteRec Subroutine :
      *?            :---------------------:
      *
      *?Logic : Write a record into Space allocation file

        Begsr WriteRec;

      *?   // Write a Record
           X = 1;
           For X = 1 to 53;
              GSPCL1  = WkPClass;
              GSDESC  = PCDESC;
              GSRVDT  = %Dec(%Char(%Date(Dtary6(X):*MDY):*CYMD0):7:0);
              GSDTRQ  = Dtary6(X);
              GSRDAT  = $MDYDate(WkDate);
              GSGUNIT = Gf(X);
              GSHUNIT = Hf(X);
              GSTUNIT = GSGUNIT + GSHUNIT;
              Write WSGRNSPCR;
           Endfor;

      *?   // Initialise Array
           Gf = 0;
           Hf = 0;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : GetGerminate Subroutine :
      *?                :-------------------------:
      *
      *?Logic : Check the Germ Date / Weeks with Calendar File Week
      *
        Begsr GetGerminate;

      *?   // Check Weeks, If Array value is less than 99
           If IGB(1) < 99;

      *?      // Get Calendar Record
              Chain GRDTRQ FCALEN;
              If %Found;
                 For X = 1 to 4;

      *?            // Check for Same Year Weeks
                    If CLWEEK >= IGB(X) and CLWEEK <= IGE(X);
                       WkGerm = IGW(X);
                       Leave;
                    Endif;

      *?            // Check for Different Year Weeks
                    If IGE(X) < IGB(X);
                       If CLWEEK >= IGB(X) and CLWEEK <= 53;
                          WkGerm = IGW(X);
                          Leave;
                       Endif;
                       If CLWEEK <= IGE(X) and CLWEEK > 0;
                          WkGerm = IGW(X);
                          Leave;
                       Endif;
                    Endif;
                 Endfor;
              Endif;
           Endif;

      *?   // Check Date, If Array value is Greater than 99
           If IGB(1) > 99;
              WKDtRq = %Char(GRDTRQ);
              BYR = YY;
              For X = 1 to 4;

      *?         // Begining Week is Greater than End Week, Then Get Previous Year
                 If IGB(X) > IGE(X);
                    If BYR <> 0;
                       EYR = BYR - 1;                   // Previous Year
                    Endif;
                 Else;
                    EYR = BYR;
                 Endif;                                 // Same Year

      *?         // Check Begin Date
                 MDY1 = %Char(IGB(X));
                 MDY2 = %Char(EYR);
                 Exsr ValidateDate;
                 If FlError = False;
                    IGB7(X) = WkCymd;
                 Endif;

      *?         // Check End Date
                 MDY1 = %Char(IGE(X));
                 MDY2 = %Char(BYR);
                 Exsr ValidateDate;
                 If FlError = False;
                    IGE7(X) = WkCymd;
                 Endif;

      *?         // Move Week
                 If IGB7(X) > 0 and GRRVDT >= IGB7(X) and
                    GRRVDT <= IGE7(X);
                    WkGerm = IGW(X);
                    Leave;
                 Endif;

              Endfor;
           Endif;
           TotGer = WkGerm;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : GetQty Subroutine :
      *?                :-------------------:
      *
      *?Logic : Get Quantity for the Prodcut Class and Sow Date
      *
        Begsr GetQty;

      *?   // Get Quantity from Query File
           WkOrder  = GRQty;
           WkSowQty = GRQty;
           For X = 1 to 12;
              If WkSOWQTY >= Ds1.BegQty(X) and WkSOWQTY <= Ds1.EndQty(X);
                 If Ds1.FacUnt(X) > 0;
                    WkQty = WkSOWQTY + Ds1.FacUnt(X);
                 Else;
                    WkPc  = %Dech((Ds1.FacPer(X)/100):5:4);
                    WkPc += 1;
                    WkQty = %Dech((WkSOWQTY * WkPc):8:1);
                    WkQty = %Inth(WkQty) + 1;
                Endif;
                Grqty = WkQty;
                Leave;
              Endif;
           Endfor;

      *?   // Get Sow Factor
    ?      #SOWFACTOR(GRITEM:GRSIZE:IMFTAB:WkOrder:ToSow);
           GRQty = ToSow;

        Endsr;
      //--------------------------------------------------------------------
      *?                :--------------------:
      *?                : GetWeek Subroutine :
      *?                :--------------------:
      *
      *?Logic : Get Week from Record
      *
        Begsr GetWeek;

      *?   // Calculate Week
           X = %LookUp(GRSow:DtAry:1:99);

      *?   // Array is Greater than End Array
           If X > WkEndAry;
              WkNoWeek = *Zeros;
           Endif;

      *?   // Array is Less than Start Array
           If X < WkStrAry;
              WkNoWeek = WkStrAry - X;
              WkGrmCnt = ToTger - WkNoWeek;
              If WkGrmCnt < 0;
                 WkGrmCnt = 0;
              Else;
                 WkS = 1;
              Endif;
           Endif;

      *?   // Array is Greater than or Equal to Start Array
           If X >= WkStrAry;
              WkNoWeek = X - WkStrAry;
              WkGrmCnt = ToTger;
              WkS = WkNoWeek + 1;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------:
      *?                : AddAry Subroutine :
      *?                :-------------------:
      *
      *?Logic : Add Quantity to Arrays
      *
        Begsr AddAry;

      *?   // Put Values in Array for Selected Weeks
           Dow WkGrmCnt > 0;
              If WkS <= WkTot;
                 Gf(WkS) += GrQty;
              Endif;

              WkS += 1;
              WkGrmCnt -= 1;
              If WkS = 53;
                 WkGrmCnt = 0;
              Endif;
           Enddo;

      *?   // Put Last Week in Hold Array
           If WkS <= WkTot and WkS <> *Zero;
              Hf(WkS) += Grqty;
           Endif;

        Endsr;
      //--------------------------------------------------------------------
      *?                :---------------------------:
      *?                : MoveGermValues Subroutine :
      *?                :---------------------------:
      *
        Begsr MoveGermValues;

      *?   // Move values from Item master files to array
           IGB(1) = IMBD1;
           IGB(2) = IMBD2;
           IGB(3) = IMBD3;
           IGB(4) = IMBD4;
           IGE(1) = IMED1;
           IGE(2) = IMED2;
           IGE(3) = IMED3;
           IGE(4) = IMED4;
           IGW(1) = IMWG1;
           IGW(2) = IMWG2;
           IGW(3) = IMWG3;
           IGW(4) = IMWG4;

        Endsr;
      //--------------------------------------------------------------------
      *?                :-------------------------:
      *?                : ValidateDate Subroutine :
      *?                :-------------------------:
      *
        Begsr ValidateDate;

      *?   // Check valid date
           WkCymd = *Zeros;
           WkMdy = %Int(WkCymdDs);
           Test(DE) *MDY WkMdy;
           If %Error;
              FlError = *On;
           Else;
              WkDate = %Date(WkMdy:*MDY);
              WkCymd = %Int(%Char(WkDate:*CYMD0));
           Endif;

        Endsr;
SUD01 //--------------------------------------------------------------------
  |   *?                :---------------------:
  |   *?                : WriteSum Subroutine :
  |   *?                :---------------------:
  |   *
  |   *?Logic : Write a record into Space Summary file
  |
  |     Begsr WriteSum;
  |
  |   *?   // Write a Record
  |        Exsr ClearDs;
  |        X = 1;
  |        For X = 1 to 53;
  |           WkTotQty = *Zeros;
  |           WkDate6  = Dtary6(X);
  |           Chain WkDate6 FCALEN;
  |
  |   *?      // Get Year
  |           WkYear = %Int(%EditC(CLCENT:'X') + %EditC(CLYEAR:'X'));
  |           If Ds2.Year = *Zeros;
  |              Ds2.Year = WkYear;
  |           Endif;
  |           If WkYear = Ds2.Year and WkYear <> *Zeros
  |                  and Ds2.Year <> *Zeros;
  |              WkWeek = ClWeek;
  |              Exec Sql
  |                 Select Sum(GSTUNIT) Into :WkTotQty from Wsgrnspcpf
  |                 Where GSDTRQ = :WkDate6 And GSRDAT = :WkDat6;
  |              Ds2.Qty(WkWeek) = WkTotQty;
  |              Ds2.Year        = WkYear;
  |           Elseif WkYear > Ds2.Year and WkYear <> *Zeros
  |                  and Ds2.Year <> *Zeros;
  |              Chain WkYEAR WSSPCSUML1;
  |              If %Found;
  |                 Exsr UpdateSr;
  |              Else;
  |                 Exsr WriteSr;
  |              Endif;
  |              WkWeek = ClWeek;
  |              Exec Sql
  |                 Select Sum(GSTUNIT) Into :WkTotQty from Wsgrnspcpf
  |                 Where GSDTRQ = :WkDate6 And GSRDAT = :WkDat6;
  |              Ds2.Qty(WkWeek) = WkTotQty;
  |              Ds2.Year        = WkYear;
  |           Endif;
  |
  |        Endfor;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : ClearDs Subroutine :
  |   *?                :--------------------:
  |   *
  |   *?Logic : Clear Data Structure
  |
  |     Begsr ClearDs;
  |
  |   *?   // Clear Data Structure
  |        Ds2.Year   = *Zeros;
  |        Ds2.Qty(1) = *Zeros;
  |        Ds2.Qty(2) = *Zeros;
  |        Ds2.Qty(3) = *Zeros;
  |        Ds2.Qty(4) = *Zeros;
  |        Ds2.Qty(5) = *Zeros;
  |        Ds2.Qty(6) = *Zeros;
  |        Ds2.Qty(7) = *Zeros;
  |        Ds2.Qty(8) = *Zeros;
  |        Ds2.Qty(9) = *Zeros;
  |        Ds2.Qty(10)= *Zeros;
  |        Ds2.Qty(11)= *Zeros;
  |        Ds2.Qty(12)= *Zeros;
  |        Ds2.Qty(13)= *Zeros;
  |        Ds2.Qty(14)= *Zeros;
  |        Ds2.Qty(15)= *Zeros;
  |        Ds2.Qty(16)= *Zeros;
  |        Ds2.Qty(17)= *Zeros;
  |        Ds2.Qty(18)= *Zeros;
  |        Ds2.Qty(19)= *Zeros;
  |        Ds2.Qty(20)= *Zeros;
  |        Ds2.Qty(21)= *Zeros;
  |        Ds2.Qty(22)= *Zeros;
  |        Ds2.Qty(23)= *Zeros;
  |        Ds2.Qty(24)= *Zeros;
  |        Ds2.Qty(25)= *Zeros;
  |        Ds2.Qty(26)= *Zeros;
  |        Ds2.Qty(27)= *Zeros;
  |        Ds2.Qty(28)= *Zeros;
  |        Ds2.Qty(29)= *Zeros;
  |        Ds2.Qty(30)= *Zeros;
  |        Ds2.Qty(31)= *Zeros;
  |        Ds2.Qty(32)= *Zeros;
  |        Ds2.Qty(33)= *Zeros;
  |        Ds2.Qty(34)= *Zeros;
  |        Ds2.Qty(35)= *Zeros;
  |        Ds2.Qty(36)= *Zeros;
  |        Ds2.Qty(37)= *Zeros;
  |        Ds2.Qty(38)= *Zeros;
  |        Ds2.Qty(39)= *Zeros;
  |        Ds2.Qty(40)= *Zeros;
  |        Ds2.Qty(41)= *Zeros;
  |        Ds2.Qty(42)= *Zeros;
  |        Ds2.Qty(43)= *Zeros;
  |        Ds2.Qty(44)= *Zeros;
  |        Ds2.Qty(45)= *Zeros;
  |        Ds2.Qty(46)= *Zeros;
  |        Ds2.Qty(47)= *Zeros;
  |        Ds2.Qty(48)= *Zeros;
  |        Ds2.Qty(49)= *Zeros;
  |        Ds2.Qty(50)= *Zeros;
  |        Ds2.Qty(51)= *Zeros;
  |        Ds2.Qty(52)= *Zeros;
  |        Ds2.Qty(53)= *Zeros;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :--------------------:
  |   *?                : WriteSr Subroutine :
  |   *?                :--------------------:
  |   *
  |   *?Logic : Write a record into Space Summary file
  |
  |     Begsr WriteSr;
  |
  |   *?   // Write a Record
  |        Clear WSSPCSUMR;
  |        GPYEAR = Ds2.Year;
  |        GPTWk1 = Ds2.Qty(1);
  |        GPTWk2 = Ds2.Qty(2);
  |        GPTWk3 = Ds2.Qty(3);
  |        GPTWk4 = Ds2.Qty(4);
  |        GPTWk5 = Ds2.Qty(5);
  |        GPTWk6 = Ds2.Qty(6);
  |        GPTWk7 = Ds2.Qty(7);
  |        GPTWk8 = Ds2.Qty(8);
  |        GPTWk9 = Ds2.Qty(9);
  |        GPTWk10 = Ds2.Qty(10);
  |        GPTWk11 = Ds2.Qty(11);
  |        GPTWk12 = Ds2.Qty(12);
  |        GPTWk13 = Ds2.Qty(13);
  |        GPTWk14 = Ds2.Qty(14);
  |        GPTWk15 = Ds2.Qty(15);
  |        GPTWk16 = Ds2.Qty(16);
  |        GPTWk17 = Ds2.Qty(17);
  |        GPTWk18 = Ds2.Qty(18);
  |        GPTWk19 = Ds2.Qty(19);
  |        GPTWk20 = Ds2.Qty(20);
  |        GPTWk21 = Ds2.Qty(21);
  |        GPTWk22 = Ds2.Qty(22);
  |        GPTWk23 = Ds2.Qty(23);
  |        GPTWk24 = Ds2.Qty(24);
  |        GPTWk25 = Ds2.Qty(25);
  |        GPTWk26 = Ds2.Qty(26);
  |        GPTWk27 = Ds2.Qty(27);
  |        GPTWk28 = Ds2.Qty(28);
  |        GPTWk29 = Ds2.Qty(29);
  |        GPTWk30 = Ds2.Qty(30);
  |        GPTWk31 = Ds2.Qty(31);
  |        GPTWk32 = Ds2.Qty(32);
  |        GPTWk33 = Ds2.Qty(33);
  |        GPTWk34 = Ds2.Qty(34);
  |        GPTWk35 = Ds2.Qty(35);
  |        GPTWk36 = Ds2.Qty(36);
  |        GPTWk37 = Ds2.Qty(37);
  |        GPTWk38 = Ds2.Qty(38);
  |        GPTWk39 = Ds2.Qty(39);
  |        GPTWk40 = Ds2.Qty(40);
  |        GPTWk41 = Ds2.Qty(41);
  |        GPTWk42 = Ds2.Qty(42);
  |        GPTWk43 = Ds2.Qty(43);
  |        GPTWk44 = Ds2.Qty(44);
  |        GPTWk45 = Ds2.Qty(45);
  |        GPTWk46 = Ds2.Qty(46);
  |        GPTWk47 = Ds2.Qty(47);
  |        GPTWk48 = Ds2.Qty(48);
  |        GPTWk49 = Ds2.Qty(49);
  |        GPTWk50 = Ds2.Qty(50);
  |        GPTWk51 = Ds2.Qty(51);
  |        GPTWk52 = Ds2.Qty(52);
  |        GPTWk53 = Ds2.Qty(53);
  |
  |        Write WSSPCSUMR;
  |
  |     Endsr;
  |   //--------------------------------------------------------------------
  |   *?                :---------------------:
  |   *?                : UpdateSr Subroutine :
  |   *?                :---------------------:
  |   *
  |   *?Logic : Update a record into Space Summary file
  |
  |     Begsr UpdateSr;
  |
  |   *?   // Update a Record
  |        If GPTWK1 < Ds2.Qty(1);
  |           GPTWk1 = Ds2.Qty(1);
  |        Else;
  |           GPTWk1 = GPTWk1;
  |        Endif;
  |
  |        If GPTWK2 < Ds2.Qty(2);
  |           GPTWk2 = Ds2.Qty(2);
  |        Else;
  |           GPTWk2 = GPTWk2;
  |        Endif;
  |
  |        If GPTWK3 < Ds2.Qty(3);
  |           GPTWk3 = Ds2.Qty(3);
  |        Else;
  |           GPTWk3 = GPTWk3;
  |        Endif;
  |
  |        If GPTWK4 < Ds2.Qty(4);
  |           GPTWk4 = Ds2.Qty(4);
  |        Else;
  |           GPTWk4 = GPTWk4;
  |        Endif;
  |
  |        If GPTWK5 < Ds2.Qty(5);
  |           GPTWk5 = Ds2.Qty(5);
  |        Else;
  |           GPTWk5 = GPTWk5;
  |        Endif;
  |
  |        If GPTWK6 < Ds2.Qty(6);
  |           GPTWk6 = Ds2.Qty(6);
  |        Else;
  |           GPTWk6 = GPTWk6;
  |        Endif;
  |
  |        If GPTWK7 < Ds2.Qty(7);
  |           GPTWk7 = Ds2.Qty(7);
  |        Else;
  |           GPTWk7 = GPTWk7;
  |        Endif;
  |
  |        If GPTWK8 < Ds2.Qty(8);
  |           GPTWk8 = Ds2.Qty(8);
  |        Else;
  |           GPTWk8 = GPTWk8;
  |        Endif;
  |
  |        If GPTWK9 < Ds2.Qty(9);
  |           GPTWk9 = Ds2.Qty(9);
  |        Else;
  |           GPTWk9 = GPTWk9;
  |        Endif;
  |
  |        If GPTWK10 < Ds2.Qty(10);
  |           GPTWk10 = Ds2.Qty(10);
  |        Else;
  |           GPTWk10 = GPTWk10;
  |        Endif;
  |
  |        If GPTWK11 < Ds2.Qty(11);
  |           GPTWk11 = Ds2.Qty(11);
  |        Else;
  |           GPTWk11 = GPTWk11;
  |        Endif;
  |
  |        If GPTWK12 < Ds2.Qty(12);
  |           GPTWk12 = Ds2.Qty(12);
  |        Else;
  |           GPTWk12 = GPTWk12;
  |        Endif;
  |
  |        If GPTWK13 < Ds2.Qty(13);
  |           GPTWk13 = Ds2.Qty(13);
  |        Else;
  |           GPTWk13 = GPTWk13;
  |        Endif;
  |
  |        If GPTWK14 < Ds2.Qty(14);
  |           GPTWk14 = Ds2.Qty(14);
  |        Else;
  |           GPTWk14 = GPTWk14;
  |        Endif;
  |
  |        If GPTWK15 < Ds2.Qty(15);
  |           GPTWk15 = Ds2.Qty(15);
  |        Else;
  |           GPTWk15 = GPTWk15;
  |        Endif;
  |
  |        If GPTWK16 < Ds2.Qty(16);
  |           GPTWk16 = Ds2.Qty(16);
  |        Else;
  |           GPTWk16 = GPTWk16;
  |        Endif;
  |
  |        If GPTWK17 < Ds2.Qty(17);
  |           GPTWk17 = Ds2.Qty(17);
  |        Else;
  |           GPTWk17 = GPTWk17;
  |        Endif;
  |
  |        If GPTWK18 < Ds2.Qty(18);
  |           GPTWk18 = Ds2.Qty(18);
  |        Else;
  |           GPTWk18 = GPTWk18;
  |        Endif;
  |
  |        If GPTWK19 < Ds2.Qty(19);
  |           GPTWk19 = Ds2.Qty(19);
  |        Else;
  |           GPTWk19 = GPTWk19;
  |        Endif;
  |
  |        If GPTWK20 < Ds2.Qty(20);
  |           GPTWk20 = Ds2.Qty(20);
  |        Else;
  |           GPTWk20 = GPTWk20;
  |        Endif;
  |
  |        If GPTWK21 < Ds2.Qty(21);
  |           GPTWk21 = Ds2.Qty(21);
  |        Else;
  |           GPTWk21 = GPTWk21;
  |        Endif;
  |
  |        If GPTWK22 < Ds2.Qty(22);
  |           GPTWk22 = Ds2.Qty(22);
  |        Else;
  |           GPTWk22 = GPTWk22;
  |        Endif;
  |
  |        If GPTWK23 < Ds2.Qty(23);
  |           GPTWk23 = Ds2.Qty(23);
  |        Else;
  |           GPTWk23 = GPTWk23;
  |        Endif;
  |
  |        If GPTWK24 < Ds2.Qty(24);
  |           GPTWk24 = Ds2.Qty(24);
  |        Else;
  |           GPTWk24 = GPTWk24;
  |        Endif;
  |
  |        If GPTWK25 < Ds2.Qty(25);
  |           GPTWk25 = Ds2.Qty(25);
  |        Else;
  |           GPTWk25 = GPTWk25;
  |        Endif;
  |
  |        If GPTWK26 < Ds2.Qty(26);
  |           GPTWk26 = Ds2.Qty(26);
  |        Else;
  |           GPTWk26 = GPTWk26;
  |        Endif;
  |
  |        If GPTWK27 < Ds2.Qty(27);
  |           GPTWk27 = Ds2.Qty(27);
  |        Else;
  |           GPTWk27 = GPTWk27;
  |        Endif;
  |
  |        If GPTWK28 < Ds2.Qty(28);
  |           GPTWk28 = Ds2.Qty(28);
  |        Else;
  |           GPTWk28 = GPTWk28;
  |        Endif;
  |
  |        If GPTWK29 < Ds2.Qty(29);
  |           GPTWk29 = Ds2.Qty(29);
  |        Else;
  |           GPTWk29 = GPTWk29;
  |        Endif;
  |
  |        If GPTWK30 < Ds2.Qty(30);
  |           GPTWk30 = Ds2.Qty(30);
  |        Else;
  |           GPTWk30 = GPTWk30;
  |        Endif;
  |
  |        If GPTWK31 < Ds2.Qty(31);
  |           GPTWk31 = Ds2.Qty(31);
  |        Else;
  |           GPTWk31 = GPTWk31;
  |        Endif;
  |
  |        If GPTWK32 < Ds2.Qty(32);
  |           GPTWk32 = Ds2.Qty(32);
  |        Else;
  |           GPTWk32 = GPTWk32;
  |        Endif;
  |
  |        If GPTWK33 < Ds2.Qty(33);
  |           GPTWk33 = Ds2.Qty(33);
  |        Else;
  |           GPTWk33 = GPTWk33;
  |        Endif;
  |
  |        If GPTWK34 < Ds2.Qty(34);
  |           GPTWk34 = Ds2.Qty(34);
  |        Else;
  |           GPTWk34 = GPTWk34;
  |        Endif;
  |
  |        If GPTWK35 < Ds2.Qty(35);
  |           GPTWk35 = Ds2.Qty(35);
  |        Else;
  |           GPTWk35 = GPTWk35;
  |        Endif;
  |
  |        If GPTWK36 < Ds2.Qty(36);
  |           GPTWk36 = Ds2.Qty(36);
  |        Else;
  |           GPTWk36 = GPTWk36;
  |        Endif;
  |
  |        If GPTWK37 < Ds2.Qty(37);
  |           GPTWk37 = Ds2.Qty(37);
  |        Else;
  |           GPTWk37 = GPTWk37;
  |        Endif;
  |
  |        If GPTWK38 < Ds2.Qty(38);
  |           GPTWk38 = Ds2.Qty(38);
  |        Else;
  |           GPTWk38 = GPTWk38;
  |        Endif;
  |
  |        If GPTWK39 < Ds2.Qty(39);
  |           GPTWk39 = Ds2.Qty(39);
  |        Else;
  |           GPTWk39 = GPTWk39;
  |        Endif;
  |
  |        If GPTWK40 < Ds2.Qty(40);
  |           GPTWk40 = Ds2.Qty(40);
  |        Else;
  |           GPTWk40 = GPTWk40;
  |        Endif;
  |
  |        If GPTWK41 < Ds2.Qty(41);
  |           GPTWk41 = Ds2.Qty(41);
  |        Else;
  |           GPTWk41 = GPTWk41;
  |        Endif;
  |
  |        If GPTWK42 < Ds2.Qty(42);
  |           GPTWk42 = Ds2.Qty(42);
  |        Else;
  |           GPTWk42 = GPTWk42;
  |        Endif;
  |
  |        If GPTWK43 < Ds2.Qty(43);
  |           GPTWk43 = Ds2.Qty(43);
  |        Else;
  |           GPTWk43 = GPTWk43;
  |        Endif;
  |
  |        If GPTWK44 < Ds2.Qty(44);
  |           GPTWk44 = Ds2.Qty(44);
  |        Else;
  |           GPTWk44 = GPTWk44;
  |        Endif;
  |
  |        If GPTWK45 < Ds2.Qty(45);
  |           GPTWk45 = Ds2.Qty(45);
  |        Else;
  |           GPTWk45 = GPTWk45;
  |        Endif;
  |
  |        If GPTWK46 < Ds2.Qty(46);
  |           GPTWk46 = Ds2.Qty(46);
  |        Else;
  |           GPTWk46 = GPTWk46;
  |        Endif;
  |
  |        If GPTWK47 < Ds2.Qty(47);
  |           GPTWk47 = Ds2.Qty(47);
  |        Else;
  |           GPTWk47 = GPTWk47;
  |        Endif;
  |
  |        If GPTWK48 < Ds2.Qty(48);
  |           GPTWk48 = Ds2.Qty(48);
  |        Else;
  |           GPTWk48 = GPTWk48;
  |        Endif;
  |
  |        If GPTWK49 < Ds2.Qty(49);
  |           GPTWk49 = Ds2.Qty(49);
  |        Else;
  |           GPTWk49 = GPTWk49;
  |        Endif;
  |
  |        If GPTWK50 < Ds2.Qty(50);
  |           GPTWk50 = Ds2.Qty(50);
  |        Else;
  |           GPTWk50 = GPTWk50;
  |        Endif;
  |
  |        If GPTWK51 < Ds2.Qty(51);
  |           GPTWk51 = Ds2.Qty(51);
  |        Else;
  |           GPTWk51 = GPTWk51;
  |        Endif;
  |
  |        If GPTWK52 < Ds2.Qty(52);
  |           GPTWk52 = Ds2.Qty(52);
  |        Else;
  |           GPTWk52 = GPTWk52;
  |        Endif;
  |
  |        If GPTWK53 < Ds2.Qty(53);
  |           GPTWk53 = Ds2.Qty(53);
  |        Else;
  |           GPTWk53 = GPTWk53;
  |        Endif;
  |
  |        Update WSSPCSUMR;
  |
SUD01   Endsr;
      *?---------------- End Of Subroutines --------------------------------
      *?Compile Time Array
** Prodcut Class
50515253545560
